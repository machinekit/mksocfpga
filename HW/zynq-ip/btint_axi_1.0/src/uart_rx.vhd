-- UART TX Implementation
-- Requires high speed clk
-- and clk running at 16 times the baud rate
-- Generates asynchronous 8n1 tx stream
-- BaudReg needs to be set according to:
-- BaudReg = Fclk / (16 * Baud Rate) - 1
-- Baud rate timer is duplicated in RX and TX side to allow reseting of timers
-- whenever each direction desires.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    generic(
        TIMER_WIDTH : natural := 16
    );
	port 
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        baudreg : in unsigned(TIMER_WIDTH - 1 downto 0); -- The baud rate timer count
        uart_rx : in std_logic; -- The asynchronous rx input
        data_read : in std_logic; -- Assert when reading data from buffer
        data_ready : out std_logic; -- Asserted when new data ready to load
        data_out : out std_logic_vector(7 downto 0); -- The byte deserialized
        overflow_err : out std_logic; -- data arrived before old data read from buffer. new data discarded
        frame_err : out std_logic
        
        -- debug outputs
--        clk16_deb : out std_logic;
--        clk16_timer_deb : out unsigned(TIMER_WIDTH - 1 downto 0);
--        bit_pulse_deb : out std_logic;
--        tx_bit_cnt_deb : out unsigned(3 downto 0);
--        tx_bitclk_cnt_deb : out unsigned(3 downto 0);
--        tx_clk_reset_deb : out std_logic; 
--        current_state_deb : out unsigned(1 downto 0);
--        next_state_deb : out unsigned(1 downto 0);
--        tx_shift_reg_deb : out std_logic_vector(9 downto 0)
	);
end entity;

architecture beh of uart_rx is
	type sm_type is (idle, start, shifting, stop);
	signal current_state, next_state : sm_type;
	signal rx_shift_reg : std_logic_vector(7 downto 0) := (others => '1');
	signal bit_pulse : std_logic := '0';
	signal rx_bit_cnt : unsigned(3 downto 0) := (others => '1');
	signal rx_bitclk_cnt : unsigned(3 downto 0) := (others => '1');
	signal rx_clk_reset : std_logic := '0';
	signal clk16_timer : unsigned(TIMER_WIDTH - 1 downto 0) := (others => '1');
    signal clk16 : std_logic;
    signal maj_voters : std_logic_vector(2 downto 0) := (others => '0');
    signal maj_vote : std_logic := '0';
    signal fr_err : std_logic := '0';
    signal of_err : std_logic := '0';
    signal data_rdy : std_logic := '0';
begin
    -- debug outputs
--    clk16_deb <= clk16;
--    clk16_timer_deb <= clk16_timer;
--    bit_pulse_deb <= bit_pulse;
--    tx_bit_cnt_deb <= tx_bit_cnt;
--    tx_bitclk_cnt_deb <= tx_bitclk_cnt;
--    tx_clk_reset_deb <= tx_clk_reset;
--    current_state_deb <= to_unsigned(1, 2) when current_state = shifting else
--                         to_unsigned(2, 2) when current_state = stop else
--                         to_unsigned(0, 2);
--    next_state_deb <= to_unsigned(1, 2) when next_state = shifting else
--                      to_unsigned(2, 2) when next_state = stop else
--                      to_unsigned(0, 2);
--    tx_shift_reg_deb <= tx_shift_reg;

    -- Module begin
    rx_clk_reset <= '1' when (current_state = idle and uart_rx = '0') else '0';
    maj_vote <= '1' when ((maj_voters(1) = '1' and maj_voters(0) = '1') or 
                          (maj_voters(2) = '1' and maj_voters(0) = '1') or
                          (maj_voters(2) = '1' and maj_voters(1) = '1'))
                else '0';
    overflow_err <= of_err;
    frame_err <= fr_err;
    data_ready <= data_rdy;

    update_rx_clk16 : process(rst_n, clk, rx_clk_reset, baudreg)
    begin
        if(rst_n = '0') then
            clk16_timer <= baudreg;
            clk16 <= '0';
        elsif(rising_edge(clk)) then
            clk16 <= '0';
            if(rx_clk_reset = '1') then
                clk16_timer <= baudreg;
            elsif(clk16_timer = to_unsigned(0, TIMER_WIDTH)) then
                clk16_timer <= baudreg;
                clk16 <= '1';
            else
                clk16_timer <= clk16_timer - 1;
            end if;
        end if;
    end process update_rx_clk16;

    update_rx_bitclk : process(rst_n, clk, rx_clk_reset, rx_bitclk_cnt, clk16)
    begin
        if(rst_n = '0') then
            rx_bitclk_cnt <= (others => '0');  -- default the count to 0
            bit_pulse <= '0';
        elsif(rising_edge(clk)) then
            bit_pulse <= '0';
            if(rx_clk_reset = '1') then
                rx_bitclk_cnt <= (others => '0');
            elsif(clk16 = '1') then
                if(rx_bitclk_cnt = to_unsigned(15, 4)) then
                    rx_bitclk_cnt <= (others => '0');
                    bit_pulse <= '1';
                else
                    rx_bitclk_cnt <= rx_bitclk_cnt + 1;
                end if;
            end if;
        end if;
    end process update_rx_bitclk;
    
    update_bit_cnt : process(rst_n, clk, current_state, bit_pulse, rx_bit_cnt)
    begin
        if(rst_n = '0') then
            rx_bit_cnt <= (others => '0');
        elsif(rising_edge(clk)) then
            if(current_state = idle) then
                rx_bit_cnt <= (others => '0');
            elsif(current_state = shifting and bit_pulse = '1') then
                rx_bit_cnt <= rx_bit_cnt + 1;
            end if;
        end if;
    end process update_bit_cnt;
    
    update_maj_voters : process(rst_n, clk, uart_rx, rx_bitclk_cnt)
    begin
        if(rst_n = '0') then
            maj_voters <= (others => '1');
        elsif(rising_edge(clk)) then
            if(rx_bitclk_cnt = to_unsigned(6, 4)) then
                maj_voters(0) <= uart_rx;
            elsif(rx_bitclk_cnt = to_unsigned(7, 4)) then
                maj_voters(1) <= uart_rx;
            elsif(rx_bitclk_cnt = to_unsigned(8, 4)) then
                maj_voters(2) <= uart_rx;
            end if;
        end if;
    end process update_maj_voters;
    
    update_shift : process(rst_n, clk, current_state, maj_vote, bit_pulse)
    begin
        if(rst_n = '0') then
            rx_shift_reg <= (others => '0');
        elsif(rising_edge(clk)) then
            if (current_state = shifting and bit_pulse = '1') then
                rx_shift_reg <= maj_vote & rx_shift_reg(rx_shift_reg'high downto 1);
            end if;
        end if;
    end process update_shift;
    
    update_outs : process(rst_n, clk, of_err, fr_err, rx_shift_reg)
    begin
        if(rst_n = '0') then
            of_err <= '0';
            fr_err <= '0';
            data_out <= (others => '0');
        elsif(rising_edge(clk)) then
            if(current_state = stop and bit_pulse = '1') then
                -- Update overflow error
                if(data_rdy = '1') then
                    of_err <= '1';
                else -- latch the data
                    data_out <= rx_shift_reg;  
                    data_rdy <= '1';      
                end if;               
               -- framing error when stop bit is read as '0'
                if(maj_vote = '0') then 
                    fr_err <= '1';
                else                    -- only clear framing error on reception of good data
                    fr_err <= '0';
                end if; 
            elsif(data_read = '1') then
                data_rdy <= '0';
                of_err <= '0';
                fr_err <= '0';
            end if;
        end if;
    end process update_outs;
    
    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= idle;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;   

    calc_state : process(current_state, bit_pulse, rx_bit_cnt, uart_rx)
    begin
        case current_state is
            when idle =>
                next_state <= idle;
                if(uart_rx = '0') then
                    next_state <= start;
                end if; 
            when start =>
                next_state <= start;
                if(bit_pulse = '1') then
                    next_state <= shifting;
                end if;    
            when shifting =>
                next_state <= shifting;
                if(rx_bit_cnt = to_unsigned(7, 3) and bit_pulse = '1') then
                    next_state <= stop;
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
