-- A simple test bench for the btint controller
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity btint_controller_tb is
    generic (
        BAUD_TIMER_WIDTH : natural := 16;
        PP_BUF_ADDR_WIDTH : natural := 6
    );
end entity;

architecture beh of btint_controller_tb is
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal uart_busy : std_logic;
    signal uart_data : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_load : std_logic := '0';
    signal uart_tx : std_logic;
    signal pkt_packet : std_logic_vector(31 downto 0);
    signal pkt_we : std_logic := '0';
    signal pkt_busy : std_logic;
    signal pp_rd_addr : std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
    signal pp_wr_addr : std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
    signal pp_rd_data1 : std_logic_vector(7 downto 0);
    signal pp_rd_data2 : std_logic_vector(7 downto 0);
    signal pp_wr_data : std_logic_vector(7 downto 0);
    signal pp_lock : std_logic_vector(1 downto 0) := (others => '0');
    signal pp_rd_sel : std_logic_vector(1 downto 0);
    signal pp_wr : std_logic := '0';
    signal addr_rd : std_logic_vector(15 downto 0) := x"0000";
    signal addr_wr : std_logic_vector(15 downto 0) := x"0000";
    signal idata : std_logic_vector(31 downto 0);
    signal odata : std_logic_vector(31 downto 0);
    signal wr : std_logic := '0';
    signal wr_strobe : std_logic_vector(3 downto 0) := b"1111";
    signal sync : std_logic := '0';

    -- Simulation timing
    constant clockperiod : TIME := 10 ns;
    constant syncperiod : TIME := 1 ms;
begin
    UUT : entity work.btint_controller
        generic map(
            PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
        )
        port map (
            rst_n => rst_n,
            clk => clk,
            pp_buf_lock => pp_lock,
            pp_addr => pp_rd_addr,
            pp_data1 => pp_rd_data1,
            pp_data2 => pp_rd_data2,
            pkt_tx_data => pkt_packet,
            pkt_tx_we => pkt_we,
            pkt_tx_busy => pkt_busy,
            addr_wr => addr_wr,
            idata => idata,
            wr => wr,
            wr_strobe => wr_strobe,
            addr_rd => addr_rd,
            odata => odata,
            sync => sync
        );

    pkt_tx : entity work.pkt_builder_tx
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

      pp_buf1 : entity work.ram_dualp
       generic map(
        PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
       )
       port map (
        clk => clk,
        we => (pp_lock(0) and pp_wr),
        rd_addr => pp_rd_addr,
        rd_data => pp_rd_data1,
        wr_addr => pp_wr_addr,
        wr_data => pp_wr_data
       );

       pp_buf2 : entity work.ram_dualp
       generic map(
        PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
       )
       port map (
        clk => clk,
        we => (pp_lock(1) and pp_wr),
        rd_addr => pp_rd_addr,
        rd_data => pp_rd_data2,
        wr_addr => pp_wr_addr,
        wr_data => pp_wr_data
       );


      -- Generate the reference clock @ 50% duty cycle
      clock_gen : process
      begin
        wait for (clockperiod / 2);
        clk <= '1';
        wait for (clockperiod / 2);
        clk <= '0';
      end process clock_gen;

      -- generate the sync pulse clock
      sync_gen : process
      begin
        wait for (syncperiod / 2);
        sync <= '1';
        wait for (syncperiod / 2);
        sync <= '0';
      end process sync_gen;

      -- The stimulus
      stim : process
      begin
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"00";
        rst_n <= '0';

        wait for 15 ns;
            rst_n <= '1';
        wait until pkt_busy = '0'; -- let packet finish going out
        wait until clk = '0';       -- write 6 byte bad response into pp_buffer
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"10";          -- switch buffer

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let retry packet send
        wait until clk = '0';       -- write 6 byte good response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"08";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"01";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"01";          -- switch buffer

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let request next gain packet send
        wait until clk = '0';       -- write 6 byte good response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"08";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"02";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"10";          -- switch buffer

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let request next gain packet send
        wait until clk = '0';       -- write 6 byte good response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"08";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"03";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"01";          -- switch buffer

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let request next gain packet send
        wait until clk = '0';      -- write 6 byte good data response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"02";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"04";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"10";          -- switch buffer

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let request next gain packet send
        wait until clk = '0';      -- write 6 byte good data response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"02";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"05";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"01";          -- switch buffer

       wait for 100 us;
       -- Cycle through the registers
        wait until clk = '0';
        addr_rd <= x"0000";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0001";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0002";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0003";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0004";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0005";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0006";
        wait until clk = '1';
        wait until clk = '0';
        addr_rd <= x"0007";
        wait until clk = '1';

        wait until pkt_busy = '1';
        wait until pkt_busy = '0'; -- let request next gain packet send
        wait until clk = '0';      -- write 6 byte good data response into pp_buffer
        pp_wr_addr <= b"000000";
        pp_wr_data <= x"02";
        pp_wr <= '1';
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_data <= x"06";
        pp_wr_addr <= b"000001";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000010";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000011";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000100";
        wait until clk = '1';
        wait until clk = '0';
        pp_wr_addr <= b"000101";
        wait until clk = '1';
        pp_wr <= '0';
        pp_lock <= b"10";          -- switch buffer

        addr_rd <= x"0006";

        wait; -- done, wait forever
      end process stim;
end beh;
