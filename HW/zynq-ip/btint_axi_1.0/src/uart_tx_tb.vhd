-- A simple test bench for the uart tx component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_tb is
    generic (
        BAUD_TIMER_WIDTH : natural := 16
    );
end uart_tx_tb;

architecture beh of uart_tx_tb is
    signal clk : std_logic := '0';
    signal load : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal busy : std_logic;
    signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_tx : std_logic;

--    signal clk16_deb : std_logic;
--    signal clk16_timer_deb : unsigned(BAUD_TIMER_WIDTH - 1 downto 0);
--    signal bit_pulse_deb : std_logic;
--    signal tx_bit_cnt_deb : unsigned(3 downto 0);
--    signal tx_bitclk_cnt_deb : unsigned(3 downto 0);
--    signal tx_clk_reset_deb : std_logic ;
--    signal current_state_deb : 	unsigned(1 downto 0);
--    signal next_state_deb : unsigned(1 downto 0);
--    signal tx_shift_reg_deb : std_logic_vector(9 downto 0);

    -- Simulation timing
    constant clockperiod : TIME := 10 ns;
begin
    UUT : entity work.uart_tx
      generic map (
        TIMER_WIDTH => BAUD_TIMER_WIDTH)
      port map (
        rst_n => rst_n,
        clk => clk,
        load => load,
        data_in => tx_data,
        uart_tx => uart_tx,
        busy => busy
--        clk16_deb => clk16_deb,
--        clk16_timer_deb => clk16_timer_deb,
--        bit_pulse_deb => bit_pulse_deb,
--        tx_bit_cnt_deb => tx_bit_cnt_deb,
--        tx_bitclk_cnt_deb => tx_bitclk_cnt_deb,
--        tx_clk_reset_deb => tx_clk_reset_deb,
--        current_state_deb => current_state_deb,
--        next_state_deb => next_state_deb,
--        tx_shift_reg_deb => tx_shift_reg_deb
      );

      -- Generate the reference clock @ 50% duty cycle
      clock_gen : process
      begin
        wait for (clockperiod / 2);
        clk <= '1';
        wait for (clockperiod / 2);
        clk <= '0';
      end process clock_gen;

      -- The stimulus
      stim : process
      begin
        rst_n <= '0';

        wait for 15 ns;
            rst_n <= '1';
            tx_data <= x"00";   -- first data to send is binary 0
            load <= '0';
        wait until busy = '0';
                load <= '1'; -- kickoff write
        wait until busy = '1';
            load <= '0';
            tx_data <= x"55"; -- second byte to send
        wait until busy = '0';
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"48";  -- H
        wait until busy = '0';
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"45";  -- E
        wait until busy = '0';
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4C";  -- L
        wait until busy = '0';
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4C";  -- L
        wait until busy = '0';
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4F";  -- O
        wait; -- done, wait forever
      end process stim;
end beh;
