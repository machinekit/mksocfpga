-- A simple test bench for the uart rx component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_tb is
    generic (
        BAUD_TIMER_WIDTH : natural := 16
    );
end uart_rx_tb;

architecture beh of uart_rx_tb is
    signal clk : std_logic := '0';
    signal load : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal busy : std_logic;
    signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_tx : std_logic;
	signal rx_read : std_logic;
	signal rx_data_ready : std_logic;
	signal rx_data : std_logic_vector(7 downto 0);
	signal rx_overflow_err : std_logic;
	signal rx_frame_err : std_logic;

    -- Simulation timing
    constant clockperiod : TIME := 10 ns;
begin

    rxUUT : entity work.uart_rx
      generic map (
        TIMER_WIDTH => BAUD_TIMER_WIDTH
      )
      port map (
        rst_n => rst_n,
        clk => clk,
        uart_rx => uart_tx,
        data_read => rx_read,
        data_ready => rx_data_ready,
        data_out => rx_data,
        overflow_err => rx_overflow_err,
        frame_err => rx_frame_err
        );

    txUUT : entity work.uart_tx
      generic map (
        TIMER_WIDTH => BAUD_TIMER_WIDTH
      )
      port map (
        rst_n => rst_n,
        clk => clk,
        load => load,
        data_in => tx_data,
        uart_tx => uart_tx,
        busy => busy
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
        rx_read <= '0';

        wait for 15 ns;
            rst_n <= '1';
            tx_data <= x"01";   -- first data to send is 1
            load <= '0';
        wait until busy = '0';
            load <= '1'; -- kickoff write
        wait until busy = '1';
            load <= '0';
            tx_data <= x"55"; -- second byte to send
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"48";  -- H
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"45";  -- E
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4C";  -- L
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4C";  -- L
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
            tx_data <= x"4F";  -- O
        wait until rx_data_ready = '1';
            rx_read <= '1';
        wait for 25 ns;
            rx_read <= '0';
        wait for 25 ns;
            load <= '1';
        wait until busy = '1';
            load <= '0';
        wait; -- done, wait forever
      end process stim;
end beh;
