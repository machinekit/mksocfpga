-- Test application that receives data from UART RX
-- increments and resends over UART TX
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_test_app is
    generic (
        BAUD_TIMER_WIDTH : natural := 16
    );
    port (
        clk : in std_logic;
        uart_tx : out std_logic;
        uart_rx : in std_logic
    );
end uart_test_app;

architecture arch of uart_test_app is
    signal tx_load : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal tx_busy : std_logic;
    signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_read : std_logic;
	signal rx_data_ready : std_logic;
	signal rx_data : std_logic_vector(7 downto 0);
	signal rx_overflow_err : std_logic;
	signal rx_frame_err : std_logic;

begin
    rxUUT : entity work.uart_rx
      generic map (
        TIMER_WIDTH => BAUD_TIMER_WIDTH
      )
      port map (
        rst_n => rst_n,
        clk => clk,
        uart_rx => uart_rx,
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
        load => tx_load,
        data_in => tx_data,
        uart_tx => uart_tx,
        busy => tx_busy
      );

    uartCont : entity work.uart_test_app_control
        port map(
            mast_rst_n => rst_n,
            clk => clk,
            rx_data => rx_data,
            rx_data_rdy => rx_data_ready,
            rx_read_data => rx_read,
            rx_overflow_err => rx_overflow_err,
            rx_frame_err => rx_frame_err,
            tx_data => tx_data,
            tx_load_data => tx_load,
            tx_busy => tx_busy
        );
end arch;
