-- Outgoing packet formatter for btint
-- Calculates checksum, delimits, and
-- escapes data for line transmission
-- This could be done with a FIFO, but
-- since the relevant packets for btint
-- coms are never longer than 4 bytes
-- just use a 32 bit value latched at
-- we.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pkt_builder_tx is
    generic(
        PKT_FLAG : std_logic_vector(7 downto 0) := x"FE";
        PKT_ESC_FLAG : std_logic_vector(7 downto 0) := x"FD";
        PKT_BL_FLAG : std_logic_vector(7 downto 0) := x"FC";
        ESC_XOR_FLAG : std_logic_vector(7 downto 0) := x"AA"
    );
	port
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        packet  : in std_logic_vector(31 downto 0); -- Only support 32 bit packet contents
        we      : in std_logic; -- Assert to latch packet and begin transmission
        busy    : out std_logic;
        uart_data : out std_logic_vector(7 downto 0);
        uart_busy : in std_logic;
        uart_load : out std_logic
	);
end entity;

architecture beh of pkt_builder_tx is
	type sm_type is (idle, start_flag, send_data, send_esc_flag, send_esc_data, chk_burn, stop_flag);
	signal current_state, next_state : sm_type;
    signal pkt_reg : std_logic_vector(31 downto 0) := (others => '0');
    signal chksum1 : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum1_add : unsigned(15 downto 0) := (others => '0');
    signal chksum1_mod : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum2 : std_logic_vector(7 downto 0) := (others => '0');
    signal chksum2_add : unsigned(15 downto 0) := (others => '0');
    signal chksum2_mod : std_logic_vector(7 downto 0) := (others => '0');
    signal busy_s : std_logic := '0';
    signal byte_cnt : unsigned(2 downto 0) := (others => '0');
    signal data_byte : std_logic_vector(7 downto 0);
    signal utx_load : std_logic;
begin
    busy <= busy_s;
    uart_load <= utx_load;
    busy_s <= '1' when (current_state /= idle) else '0';
    utx_load <= '1' when ((current_state = start_flag and uart_busy = '0') or
                           (current_state = stop_flag and uart_busy = '0')  or
                           (current_state = send_data and uart_busy = '0')  or
                           (current_state = send_esc_data and uart_busy = '0') or
                           (current_state = send_esc_flag and uart_busy = '0'))
                     else '0';

     latch_packet : process(rst_n, clk, busy_s, packet, we)
     begin
         if(rst_n = '0') then
             pkt_reg <= (others => '0');
         elsif(rising_edge(clk)) then
             if(busy_s /= '1' and we = '1') then
                 pkt_reg <= packet;
             end if;
         end if;
     end process;

    upd_byte_cnt : process(rst_n, clk, current_state, utx_load)
    begin
        if(rst_n = '0') then
            byte_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            case current_state is
                when idle =>
                    byte_cnt <= (others => '0');
                when send_data | send_esc_data =>
                    if(utx_load = '1') then
                        byte_cnt <= byte_cnt + 1;
                    end if;
                when others =>
                    byte_cnt <= byte_cnt;
            end case;
        end if;
    end process upd_byte_cnt;

    buf_addr_mux : process(byte_cnt, pkt_reg, chksum1, chksum2)
    begin
        case byte_cnt is
        when b"000" =>
            data_byte <= pkt_reg(31 downto 24);
        when b"001" =>
            data_byte <= pkt_reg(23 downto 16);
        when b"010" =>
            data_byte <= pkt_reg(15 downto 8);
        when b"011" =>
            data_byte <= pkt_reg(7 downto 0);
        when b"100" =>
            data_byte <= chksum1;
        when b"101" =>
            data_byte <= chksum2;
        when others =>
            data_byte <= (others => '0');
        end case;
    end process buf_addr_mux;

    dataout_calc : process(current_state, data_byte)
    begin
        if(current_state = start_flag or current_state = stop_flag) then
            uart_data <= PKT_FLAG;
        elsif(current_state = send_esc_flag) then
            uart_data <= PKT_ESC_FLAG;
        elsif(current_state = send_esc_data) then
            uart_data <= ESC_XOR_FLAG xor data_byte;
        else
            uart_data <= data_byte;
        end if;
    end process dataout_calc;

    mod_calc : process(chksum1, chksum1_add, chksum1_mod, chksum2, chksum2_add, chksum2_mod, data_byte) -- The fletcher checksum is mod 255
    begin
        chksum1_add <= unsigned(x"00" & chksum1) + unsigned(x"00" & data_byte);
        chksum2_add <= unsigned(x"00" & chksum2) + unsigned(x"00" & chksum1) + unsigned(x"00" & data_byte);

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

    update_chksum : process(rst_n, clk, current_state, byte_cnt, data_byte, chksum1, chksum2)
    begin
        if(rst_n = '0') then
            chksum1 <= (others => '0');
            chksum2 <= (others => '0');
        elsif(rising_edge(clk)) then
            case current_state is
                when idle =>
                    chksum1 <= (others => '0');
                    chksum2 <= (others => '0');
                when send_data | send_esc_data =>
                    if(utx_load = '1' and byte_cnt <= b"011") then
                        chksum1 <= chksum1_mod;
                        chksum2 <= chksum2_mod;
                    end if;
                when others =>
                    chksum1 <= chksum1;
                    chksum2 <= chksum2;
            end case;
        end if;
    end process update_chksum;

    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= idle;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;

    calc_state : process(current_state, we, uart_busy, byte_cnt, data_byte)
    begin
        case current_state is
            when idle =>
                next_state <= idle;
                if(we = '1') then
                    -- New packet is latched in buffer at this transition
                    next_state <= start_flag;
                end if;
            when start_flag | send_data | send_esc_data =>
                next_state <= current_state; -- default back to the current state
                if(uart_busy = '0') then -- Wait for any old transmission to finish
                -- data to be sent is latched to uart here
                    next_state <= chk_burn;
                end if;
            when chk_burn =>
                next_state <= chk_burn; -- We have to give one clock to allow the checksums to update before
                                          -- deciding where to go next. The byte counter is already updated to the new value
                if(byte_cnt = b"110") then -- if we are sending the 6th byte (chksum2) we're done
                    next_state <= stop_flag;
                else
                    if(data_byte = PKT_FLAG or data_byte = PKT_ESC_FLAG or data_byte = PKT_BL_FLAG) then
                        next_state <= send_esc_flag;
                    else
                        next_state <= send_data;
                    end if;
                end if;
            when send_esc_flag => -- Send the escape flag over uart
                next_state <= send_esc_flag;
                if(uart_busy = '0') then
                    -- escape flag is latched to uart_tx here.
                    next_state <= send_esc_data;
                end if;
            when stop_flag => -- Send stop flag over uart
                next_state <= stop_flag;
                if(uart_busy = '0') then
                    -- stop flag is latched to uart here
                    next_state <= idle;
                end if;
            when others => next_state <= idle;
        end case;
    end process calc_state;
end beh;
