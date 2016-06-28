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
        ESC_XOR_FLAG : std_logic_vector(7 downto 0) := x"AA";
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
	type sm_type is (idle, start_flag, send_data, send_esc_fl, send_esc_data, send_chk1, send_chk2, stop_flag);
	signal current_state, next_state : sm_type;
    signal chksum1, chksum2 : std_logic_vector(7 downto 0) := (others => '0');
    signal byte_buffer : std_logic_vector(47 downto 0) := (others => '0');
    signal pkt_reg : std_logic_vector(31 downto 0) is byte_buffer(47 downto 16);
    signal chksum1 : std_logic_vector(7 downto 0) is byte_buffer(15 downto 8);
    signal chksum2 : std_logic_vector(7 downto 0) is byte_buffer(7 downto 0);
    signal busy_s : std_logic := '0';
    signal byte_cnt : unsigned(2 downto 0) := (others => '0');
    signal data_byte : std_logic_vector(7 downto 0);
begin    
    busy <= busy_s;
    busy_s <= '1' when (current_state /= idle) else '0';
    
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
    
    buf_addr_mux : process()
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
    
    dataout_calc : process(current_state, byte_cntr)
    begin
        if(current_state = start_flag or current_state = stop_flag) then
            uart_data <= PKT_FLAG;
        elsif(current_state = send_esc_fl) then
            uart_data <= PKT_ESC_FLAG;
        elsif(current_state = send_data) then
            uart_data <= data_byte;
        elsif(current_state = send_esc_data) then
            uart_data <= ESC_XOR_FLAG xor data_byte;
        end if;
    end process dataout_calc;

    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= idle;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;   

    calc_state : process(current_state, we)
    begin
        case current_state is
            when idle =>
                next_state <= idle;
                if(we = '1') then
                    next_state <= start_flag;
                end if; 
            when start_flag =>
                next_state <= start_flag;
                if(uart_busy = '0') then
                    next_state <= send_data;
                end if;
            when stop =>
                next_state <= stop;
                if(bit_pulse = '1') then
                    next_state <= idle;
                end if;
            when others => next_state <= idle;
        end case;
    end process calc_state;        
end beh;

