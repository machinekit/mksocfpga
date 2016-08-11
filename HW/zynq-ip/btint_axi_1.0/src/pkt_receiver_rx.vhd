-- Incoming packet validator for btint
-- Calculates checksum, removes delimiters, and
-- escape data from line transmission.
-- Valid packet contents are written to the
-- Ping-Pong buffer.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pkt_receiver_rx is
    generic(
        PKT_FLAG : std_logic_vector(7 downto 0) := x"FE";
        PKT_ESC_FLAG : std_logic_vector(7 downto 0) := x"FD";
        ESC_XOR_FLAG : std_logic_vector(7 downto 0) := x"AA";
        PP_BUF_ADDR_WIDTH : natural := 6
    );
	port
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        pp_buf_lock : out std_logic; -- Ping pong between two buffer locations, 0 locks buffer 0, 1 locks buffer 1
        pp_addr : out std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0); -- PP Buffer address bus
        pp_data : out std_logic_vector(7 downto 0); -- PP Buffer data bus
        pp_wr : out std_logic;
        uart_data : in std_logic_vector(7 downto 0);
        uart_data_rdy: in std_logic;
        uart_rd : out std_logic;
        uart_fr_err : in std_logic;
        uart_of_err : in std_logic;
        addr_rd : in std_logic_vector(15 downto 0);
        odata : out std_logic_vector(31 downto 0)
	);
end entity;

architecture beh of pkt_receiver_rx is
  	type sm_type is (idle, byte_dec, latch_byte, latch_esc_byte, val_chk);
    type pkt_sm_type is (pkt_search_hdr, pkt_in_msg, pkt_escaped);
  	signal current_state, next_state : sm_type := idle;
  	signal pkt_state, next_pkt_state : pkt_sm_type := pkt_search_hdr;
    signal chksum1 : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum1_add : unsigned(15 downto 0) := (others => '0');
    signal chksum1_mod : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum2 : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum2_add : unsigned(15 downto 0) := (others => '0');
    signal chksum2_mod : std_logic_vector(7 downto 0) := (others => '0');
    signal byte_cnt : signed(PP_BUF_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal rx_data_byte : std_logic_vector(7 downto 0);
    signal uart_rd_s : std_logic := '0';
    signal pp_wr_s : std_logic := '0';
    signal pkt_fifo : std_logic_vector(15 downto 0);
    signal pp_buf_lock_s : std_logic;

    -- Registers
    signal rx_fr_err_cnt : std_logic_vector(31 downto 0) := (others => '0');
    signal rx_of_err_cnt : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_byte_cnt : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_chkerr_cnt : std_logic_vector(31 downto 0) := (others => '0');

    -- addresses
    constant REG_OF_ERR_ADDR : std_logic_vector(15 downto 0) := x"0600";
    constant REG_FR_ERR_ADDR : std_logic_vector(15 downto 0) := x"0604";
    constant REG_BYTE_CNT_ADDR : std_logic_vector(15 downto 0) := x"0608";
    constant REG_CHKERR_CNT_ADDR : std_logic_vector(15 downto 0) := x"060C";
begin

    -- Reading registers mux
    reg_read : process(addr_rd, rx_of_err_cnt, rx_fr_err_cnt, reg_byte_cnt, reg_chkerr_cnt)
    begin
        case addr_rd is
            when REG_OF_ERR_ADDR =>
                odata <= rx_of_err_cnt;
            when REG_FR_ERR_ADDR =>
                odata <= rx_fr_err_cnt;
            when REG_BYTE_CNT_ADDR =>
                odata <= reg_byte_cnt;
            when REG_CHKERR_CNT_ADDR =>
                odata <= reg_chkerr_cnt;
            when others =>
                odata <= (others => '0');
        end case;
    end process reg_read;

    pp_data <= pkt_fifo(15 downto 8);
    pp_addr <= std_logic_vector(byte_cnt) when (byte_cnt >= to_signed(0, PP_BUF_ADDR_WIDTH - 1)) else (others => '0');
    uart_rd <= uart_rd_s;
    -- Don't write the last two bytes that arrive in the packet, they are the checksum. 2 byte fifo handles this
    pp_wr <= '1' when (pp_wr_s = '1' and (byte_cnt >= to_signed(0, PP_BUF_ADDR_WIDTH - 1))) else '0';
    pp_buf_lock <= pp_buf_lock_s;

    -- Internal signal calc
    pp_wr_s <= '1' when (current_state = latch_byte or current_state = latch_esc_byte) else '0';
    uart_rd_s <= '1' when (current_state = idle and uart_data_rdy = '1') else '0';

    get_rx_byte : process(rst_n, clk, current_state, uart_rd_s)
    begin
        if(rst_n = '0') then
            rx_data_byte <= (others => '0');
        elsif(rising_edge(clk)) then
            if(uart_rd_s = '1') then
                rx_data_byte <= uart_data;
            end if;
        end if;
    end process get_rx_byte;

    -- Select which pp buffer we are writing to
    upd_pp : process(rst_n, clk, current_state, pp_buf_lock_s, chksum1, chksum2)
    begin
        if(rst_n = '0') then
            pp_buf_lock_s <= '0';
            reg_chkerr_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            pp_buf_lock_s <= pp_buf_lock_s;
            if(current_state = val_chk) then
                if(pkt_fifo = (chksum1 & chksum2)) then
                  if(pp_buf_lock_s = '1') then -- good checksum switch buffer
                    pp_buf_lock_s <= '0';
                  else
                    pp_buf_lock_s <= '1';
                  end if;
                else
                    reg_chkerr_cnt <= std_logic_vector(unsigned(reg_chkerr_cnt) + 1);
                end if;
            end if;
        end if;
    end process upd_pp;

    upd_byte_cnt : process(rst_n, clk, current_state, pkt_state, reg_byte_cnt, byte_cnt)
    begin
        if(rst_n = '0') then
            byte_cnt <= to_signed(-2, PP_BUF_ADDR_WIDTH);
            reg_byte_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            byte_cnt <= byte_cnt;
            reg_byte_cnt <= reg_byte_cnt;
            if(pkt_state = pkt_search_hdr) then
                byte_cnt <= to_signed(-2, PP_BUF_ADDR_WIDTH);
            elsif(current_state = latch_byte or current_state = latch_esc_byte)then
                byte_cnt <= byte_cnt + 1;
                reg_byte_cnt <= std_logic_vector(unsigned(reg_byte_cnt) + 1);
            end if;
        end if;
    end process upd_byte_cnt;

    update_fifo : process(rst_n, clk, current_state, pkt_state, rx_data_byte, pkt_fifo)
    begin
        if(rst_n = '0') then
            pkt_fifo <= (others => '0');
        elsif(rising_edge(clk)) then
            if(current_state = idle and pkt_state = pkt_search_hdr) then
                pkt_fifo <= (others => '0');
            elsif(current_state = latch_byte) then
                pkt_fifo <= pkt_fifo(7 downto 0) & rx_data_byte;
            elsif(current_state = latch_esc_byte) then
                pkt_fifo <= pkt_fifo(7 downto 0) & (rx_data_byte xor ESC_XOR_FLAG);
            end if;
        end if;
    end process update_fifo;

    mod_calc : process(chksum1, chksum1_add, chksum1_mod, chksum2, chksum2_add, chksum2_mod, pkt_fifo) -- The fletcher checksum is mod 255
    begin
        chksum1_add <= unsigned(x"00" & chksum1) + unsigned(x"00" & pkt_fifo(15 downto 8));
        chksum2_add <= unsigned(x"00" & chksum2) + unsigned(x"00" & chksum1) + unsigned(x"00" & pkt_fifo(15 downto 8));

        if(chksum1_add > to_unsigned(510, 16)) then
            chksum1_mod <= std_logic_vector(resize(chksum1_add - to_unsigned(510, 16), chksum1_mod'length));
        elsif(chksum1_add > to_unsigned(255, 16)) then
            chksum1_mod <= std_logic_vector(resize(chksum1_add - to_unsigned(255, 16), chksum1_mod'length));
        else
            chksum1_mod <= std_logic_vector(chksum1_add(7 downto 0));
        end if;

        if(chksum2_add > to_unsigned(765, 16)) then
            chksum2_mod <= std_logic_vector(resize(chksum2_add - to_unsigned(765, 16), chksum2_mod'length));
        elsif(chksum2_add > to_unsigned(510, 16)) then
              chksum2_mod <= std_logic_vector(resize(chksum2_add - to_unsigned(510, 16), chksum2_mod'length));
        elsif(chksum2_add > to_unsigned(255, 16)) then
            chksum2_mod <= std_logic_vector(resize(chksum2_add - to_unsigned(255, 16), chksum2_mod'length));
        else
            chksum2_mod <= std_logic_vector(chksum2_add(7 downto 0));
        end if;
    end process;

    update_chksum : process(rst_n, clk, current_state, byte_cnt)
    begin
        if(rst_n = '0') then
            chksum1 <= (others => '0');
            chksum2 <= (others => '0');
        elsif(rising_edge(clk)) then
            if(current_state = idle) then
                if(pkt_state = pkt_search_hdr) then
                    chksum1 <= (others => '0');
                    chksum2 <= (others => '0');
                end if;
            elsif(current_state = latch_byte or current_state = latch_esc_byte) then
                if(byte_cnt >= to_signed(0, PP_BUF_ADDR_WIDTH)) then
                    chksum1 <= chksum1_mod;
                    chksum2 <= chksum2_mod;
                end if;
            end if;
        end if;
    end process update_chksum;

    update_err_cnt : process(rst_n, clk, uart_rd_s, uart_fr_err, uart_of_err, rx_fr_err_cnt, rx_of_err_cnt)
    begin
        if(rst_n = '0') then
            rx_fr_err_cnt <= (others => '0');
            rx_of_err_cnt <= (others => '0');
        elsif(rising_edge(clk)) then
            if(uart_rd_s = '1') then
                if(uart_fr_err /= '0') then
                    rx_fr_err_cnt <= std_logic_vector(unsigned(rx_fr_err_cnt) + 1);
                elsif(uart_of_err /= '0') then
                    rx_of_err_cnt <= std_logic_vector(unsigned(rx_of_err_cnt) + 1);
                end if;
            end if;
        end if;
    end process update_err_cnt;

    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= idle;
            pkt_state <= pkt_search_hdr;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
            pkt_state <= next_pkt_state;
        end if;
    end process update_state;

    calc_state : process(current_state, pkt_state, uart_data_rdy, rx_data_byte, byte_cnt, uart_fr_err, uart_of_err)
    begin
        next_state <= current_state; -- Hold state by default
        next_pkt_state <= pkt_state;
        case current_state is
            when idle =>
                if(uart_data_rdy = '1') then
                    if(uart_fr_err /= '0' or uart_of_err /= '0') then
                        next_state <= idle; -- Oops, error, nothing to look at
                        next_pkt_state <= pkt_search_hdr;
                    else
                        next_state <= byte_dec;
                    end if;
                end if;
            when byte_dec =>    -- rx byte is latched now in the buffer
                if(pkt_state = pkt_escaped) then
                    next_state <= latch_esc_byte;
                    next_pkt_state <= pkt_in_msg;
                elsif(pkt_state = pkt_in_msg) then
                    if(rx_data_byte = PKT_ESC_FLAG) then
                        next_state <= idle;
                        next_pkt_state <= pkt_escaped;
                    elsif(rx_data_byte = PKT_FLAG) then
                        if(byte_cnt >= to_signed(4, PP_BUF_ADDR_WIDTH - 1)) then -- packet must be minimum 4 bytes plus 2 byte checksum
                            next_state <= val_chk;
                            next_pkt_state <= pkt_search_hdr;
                        elsif(byte_cnt = to_signed(-2, PP_BUF_ADDR_WIDTH -1)) then
                            next_state <= idle;
                            next_pkt_state <= pkt_in_msg;
                        else
                            next_state <= idle;
                            next_pkt_state <= pkt_search_hdr;
                        end if;
                    else
                        next_state <= latch_byte;
                    end if;
                else
                    if(rx_data_byte = PKT_FLAG) then
                        next_pkt_state <= pkt_in_msg;
                    end if;
                    next_state <= idle;
                end if;
            when latch_byte | latch_esc_byte =>
                next_state <= idle;
            when val_chk =>
                next_state <= idle;
                next_pkt_state <= pkt_search_hdr; -- For clarity of desired packet state in code, state should already be here
            when others =>
                next_state <= idle;
        end case;
    end process calc_state;
end beh;
