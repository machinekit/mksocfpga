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

entity uart_tx is
    generic(
        TIMER_WIDTH : natural := 16
    );
	port
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        load    : in std_logic; -- Assert when new data ready to load
        data_in : in std_logic_vector(7 downto 0); -- The byte to serialize
        baudreg : in unsigned(TIMER_WIDTH - 1 downto 0);
        uart_tx   : out std_logic; -- The asynchronous tx output
        busy    : out std_logic -- false when ready for new data
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

architecture beh of uart_tx is
	type sm_type is (idle, shifting, stop);
	signal current_state, next_state : sm_type;
	signal tx_shift_reg : std_logic_vector(9 downto 0) := (others => '1');
	signal bit_pulse : std_logic := '0';
	signal tx_bit_cnt : unsigned(3 downto 0) := (others => '1');
	signal tx_bitclk_cnt : unsigned(3 downto 0) := (others => '1');
	signal tx_clk_reset : std_logic := '0';
	signal clk16_timer : unsigned(TIMER_WIDTH - 1 downto 0) := (others => '0');
  signal clk16 : std_logic;
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
    uart_tx <= tx_shift_reg(0);
    busy <= '1' when (current_state /= idle) else '0';
    tx_clk_reset <= '1' when (current_state = idle and load = '1') else '0';

    update_tx_clk16 : process(rst_n, clk, tx_clk_reset, clk16_timer, baudreg)
    begin
        if(rst_n = '0') then
            clk16_timer <= baudreg;
            clk16 <= '0';
        elsif(rising_edge(clk)) then
            clk16 <= '0';
            if(tx_clk_reset = '1') then
                clk16_timer <= baudreg;
            elsif(clk16_timer = to_unsigned(0, TIMER_WIDTH)) then
                clk16_timer <= baudreg;
            else
                clk16_timer <= clk16_timer - 1;
            end if;
            if(clk16_timer = to_unsigned(1, TIMER_WIDTH)) then
                clk16 <= '1';
            end if;
        end if;
    end process update_tx_clk16;

    update_tx_bitclk : process(rst_n, clk, tx_clk_reset, tx_bitclk_cnt, clk16)
    begin
        if(rst_n = '0') then
            tx_bitclk_cnt <= (others => '1');  -- default the count to 15
            bit_pulse <= '0';
        elsif(rising_edge(clk)) then
            bit_pulse <= '0';
            if(tx_clk_reset = '1') then
                tx_bitclk_cnt <= (others => '1');
            elsif(clk16 = '1') then
                if(tx_bitclk_cnt = to_unsigned(0, 4)) then
                    tx_bitclk_cnt <= (others => '1');
                else
                    tx_bitclk_cnt <= tx_bitclk_cnt - 1;
                end if;
                if(tx_bitclk_cnt = to_unsigned(1, 4)) then
                  bit_pulse <= '1';
                end if;
            end if;
        end if;
    end process update_tx_bitclk;

    update_bit_cnt : process(rst_n, clk, current_state, bit_pulse, tx_bit_cnt)
    begin
        if(rst_n = '0') then
            tx_bit_cnt <= to_unsigned(8, 4);  -- default to 8 bits of data + 1 bit of start to shift
        elsif(rising_edge(clk)) then
            if(current_state = idle) then
                tx_bit_cnt <= to_unsigned(8, 4);
            elsif(current_state = shifting and bit_pulse = '1') then
                tx_bit_cnt <= tx_bit_cnt - 1;
            end if;
        end if;
    end process update_bit_cnt;

    update_shift : process(rst_n, clk, current_state, load, bit_pulse)
    begin
        if(rst_n = '0') then
            tx_shift_reg <= (others => '1');
        elsif(rising_edge(clk)) then
            if(current_state = idle and load = '1') then
                tx_shift_reg <= '1' & data_in & '0';
            elsif (current_state = shifting and bit_pulse = '1') then
                tx_shift_reg <= '1' & tx_shift_reg(tx_shift_reg'high downto 1);
            end if;
        end if;
    end process update_shift;

    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= stop;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;

    calc_state : process(current_state, load, bit_pulse, tx_bit_cnt)
    begin
        case current_state is
            when idle =>
                next_state <= idle;
                if(load = '1') then
                    next_state <= shifting;
                end if;
            when shifting =>
                next_state <= shifting;
                if(tx_bit_cnt = to_unsigned(0, 3) and bit_pulse = '1') then
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
