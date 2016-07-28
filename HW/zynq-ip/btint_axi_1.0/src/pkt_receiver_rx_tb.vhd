-- A simple test bench for the packet building component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pkt_receiver_rx_tb is
    generic (
        BAUD_TIMER_WIDTH : natural := 16
    );
end entity pkt_receiver_rx_tb;

architecture beh of pkt_receiver_rx_tb is
    signal clktx : std_logic := '0';
    signal clkrx : std_logic := '1';
    signal rst_n : std_logic := '1';
    signal uart_busy : std_logic;
    signal uart_data : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_load : std_logic := '0';
    signal uart_tx : std_logic;
    signal pkt_packet : std_logic_vector(31 downto 0);
    signal pkt_we : std_logic := '0';
    signal pkt_busy : std_logic;

    signal pp_buf_lock : std_logic_vector(1 downto 0); -- Ping pong between two buffer locations
    signal pp_addr : std_logic_vector(5 downto 0); -- PP Buffer address bus
    signal pp_data : std_logic_vector(7 downto 0); -- PP Buffer data bus
    signal pp_wr : std_logic;
    signal uart_rx_data : std_logic_vector(7 downto 0);
    signal uart_rx_data_rdy: std_logic;
    signal uart_rx_rd : std_logic;
    signal uart_rx_fr_err : std_logic;
    signal uart_rx_of_err : std_logic;
    signal addr_rd : std_logic_vector(15 downto 0);
    signal odata : std_logic_vector(31 downto 0);

    -- Simulation timing
    constant clockperiod : TIME := 10 ns;
begin

    UUT : entity work.pkt_receiver_rx
        port map (
            rst_n => rst_n,
            clk => clkrx,
            pp_buf_lock => pp_buf_lock,
            pp_addr => pp_addr,
            pp_data => pp_data,
            pp_wr => pp_wr,
            uart_data => uart_rx_data,
            uart_data_rdy => uart_rx_data_rdy,
            uart_rd => uart_rx_rd,
            uart_fr_err => uart_rx_fr_err,
            uart_of_err => uart_rx_of_err,
            addr_rd => addr_rd,
            odata => odata
        );

    tx_pkt_builder : entity work.pkt_builder_tx
        port map (
            rst_n => rst_n,
            clk => clktx,
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
        clk => clktx,
        load => uart_load,
        data_in => uart_data,
        uart_tx => uart_tx,
        busy => uart_busy
      );

    uart_rx_comp : entity work.uart_rx
        generic map (
            TIMER_WIDTH => BAUD_TIMER_WIDTH
        )
        port map (
            rst_n => rst_n,
            clk => clkrx,
            uart_rx => uart_tx, -- loop back the packet sent from tx
            data_read => uart_rx_rd,
            data_ready => uart_rx_data_rdy,
            data_out => uart_rx_data,
            overflow_err => uart_rx_of_err,
            frame_err => uart_rx_fr_err
        );

      -- Generate the reference clock @ 50% duty cycle
      clocktx_gen : process
      begin
        wait for (clockperiod / 2);
        clktx <= '1';
        wait for (clockperiod / 2);
        clktx <= '0';
      end process clocktx_gen;

      clockrx_gen : process
      begin
        wait for (clockperiod / 2);
        clkrx <= '0';
        wait for (clockperiod / 2);
        clkrx <= '1';
      end process clockrx_gen;

      -- The stimulus
      stim : process
      begin
        rst_n <= '0';
        addr_rd <= x"0608";

        wait for 15 ns;                 -- Basic packet
            rst_n <= '1';
            pkt_packet <= x"A5020304";
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
        wait until pkt_busy = '0';      -- Framing error packet
        wait for 100 us;
                pkt_packet <= x"04030201";
                pkt_we <= '1';
        wait until pkt_busy = '1';
                pkt_we <= '0';
        wait until pkt_busy = '0';      -- Framing error fixed packet
        wait for 100 us;
            pkt_packet <= x"05040302";
            pkt_we <= '1';
        wait until pkt_busy = '1';
            pkt_we <= '0';
        wait; -- done, wait forever
      end process stim;
end beh;
