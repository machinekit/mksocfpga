-- UART Test Program Controller Implementation
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_test_app_control is
	port 
	(
	    mast_rst_n : out std_logic;
        clk     : in std_logic;
        rx_data : in std_logic_vector(7 downto 0); -- The rx data bus
        rx_data_rdy : in std_logic;
        rx_read_data : out std_logic;
        rx_overflow_err : in std_logic;
        rx_frame_err : in std_logic;
        tx_data : out std_logic_vector(7 downto 0); -- The tx data bus
        tx_load_data : out std_logic;
        tx_busy : in std_logic -- false when ready for new data
	);
end entity;

architecture beh of uart_test_app_control is
	type sm_type is (startup, idle, read_data, write_data, write_err);
	signal current_state, next_state : sm_type := startup;
	signal rx_data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_of_flag : std_logic := '0';
    signal rx_fr_flag : std_logic := '0';
    signal rx_read : std_logic;
    signal tx_load : std_logic;
begin    

    rx_read_data <= rx_read;
    rx_read <= '1' when ((current_state = idle) and (rx_data_rdy = '1')) else '0';
    tx_load_data <= tx_load;
    tx_load <= '1' when ((current_state = write_data or current_state = write_err) and tx_busy = '0') else '0';
    mast_rst_n <= '0' when (current_state = startup) else '1';
    
    update_tx : process(clk, current_state)
    begin
        if(rising_edge(clk)) then
            if( current_state = read_data) then
                case to_integer(unsigned(rx_data_reg)) is
                    when 10|13|32 => -- do not translate Cr Lf when 10|13|32 => -- do not translate Cr LfSp !
                        tx_data <= rx_data_reg;
                    when others =>
                        tx_data <= std_logic_vector(unsigned(rx_data_reg) + 1);
                end case;
            elsif( current_state = write_data) then
                if(rx_of_flag = '1' and rx_fr_flag = '0') then
                    tx_data <= x"4F";
                elsif(rx_of_flag = '1' and rx_fr_flag = '0') then
                    tx_data <= x"46"; 
                elsif(rx_of_flag = '1' and rx_fr_flag = '0') then
                    tx_data <= x"42";
                else
                    tx_data <= x"53";
                end if;
            end if;
        end if;
    end process update_tx;
    
    update_rx : process(clk, rx_read)
    begin
        if(rising_edge(clk)) then
            if(rx_read = '1') then
                rx_data_reg <= rx_data;     -- latch data and error state
                rx_of_flag <= rx_overflow_err;
                rx_fr_flag <= rx_frame_err;
            end if;
        end if;
    end process update_rx;

    update_state : process(clk, next_state)
    begin
        if (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;   

    calc_state : process(current_state, rx_data_rdy, tx_load)
    begin
        case current_state is
            when startup =>
                next_state <= idle;
            when idle =>
                next_state <= idle;
                if(rx_data_rdy = '1') then
                    next_state <= read_data;
                end if; 
            when read_data =>
                next_state <= write_data;
            when write_data =>
                next_state <= write_data;
                if(tx_load = '1') then
                    next_state <= write_err;
                end if;
            when write_err =>
                next_state <= write_err;
                if(tx_load = '1') then
                    next_state <= idle;
                end if;
            when others => next_state <= idle;
        end case;
    end process calc_state;        
end beh;
