-- A simple test bench for the packet building component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pkt_builder_tx_tb is
    generic (
        BAUD_TIMER_WIDTH : natural := 16
    );
end pkt_builder_tx_tb;

architecture beh of pkt_builder_tx_tb is
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal baudreg : unsigned(BAUD_TIMER_WIDTH - 1 downto 0);
    signal uart_busy : std_logic;
    signal uart_data : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_load : std_logic := '0';
    signal uart_tx : std_logic;
    signal pkt_packet : std_logic_vector(31 downto 0);
    signal pkt_we : std_logic := '0';
    signal pkt_busy : std_logic;

    -- Simulation timing
    constant clockperiod : TIME := 10 ns;
begin
    UUT : entity work.pkt_builder_tx
        port map (
            rst_n => rst_n,
            clk => clk,
            packet => pkt_packet,
            we => pkt_we,
            busy => pkt_busy,
            uart_data => uart_data,
            uart_busy => uart_busy,
            uart_load => uart_load
        );

    uart_tx_comp : entity work.uart_tx
      generic map (
        TIMER_WIDTH => BAUD_TIMER_WIDTH)
      port map (
        rst_n => rst_n,
        clk => clk,
        load => uart_load,
        data_in => uart_data,
        uart_tx => uart_tx,
        busy => uart_busy
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
        wait for 15 ns;                 -- Basic packet
            rst_n <= '1';
            pkt_packet <= x"01020304";
            pkt_we <= '1';
        wait until pkt_busy = '1';
            pkt_we <= '0';
        wait until pkt_busy = '0';      -- Flag escaped packet
            pkt_packet <= x"01FEFCFD";
            pkt_we <= '1';
        wait until pkt_busy = '1';
            pkt_we <= '0';
        wait until pkt_busy = '0';      -- Checksum gets escaped packet
                pkt_packet <= x"01FC0001";
                pkt_we <= '1';
        wait until pkt_busy = '1';
                pkt_we <= '0';
        wait; -- done, wait forever
      end process stim;
end beh;
