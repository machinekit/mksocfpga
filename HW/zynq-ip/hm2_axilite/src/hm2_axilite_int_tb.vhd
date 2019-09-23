-- This is based on the AXI Lite Test bench example at
-- https://github.com/frobino/axi_custom_ip_tb

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hm2_axilite_int_tb is
  generic (
  TB_ADDR_WIDTH : integer := 16;
  TB_DATA_WIDTH : integer := 32
  );
end hm2_axilite_int_tb;

architecture beh of hm2_axilite_int_tb is

  -- Generic 32-bit bus signals --
  signal addr : std_logic_vector(TB_ADDR_WIDTH-1 downto 0);
  signal ibus : std_logic_vector(TB_DATA_WIDTH-1 downto 0);
  signal obus : std_logic_vector(TB_DATA_WIDTH-1 downto 0);
  signal readstb : std_logic;
  signal writestb : std_logic;

  -- AXI Lite signals --
  signal axi_aclk : std_logic;
  signal axi_aresetn : std_logic;
  signal axi_awaddr : std_logic_vector(TB_ADDR_WIDTH-1 downto 0);
  signal axi_awprot : std_logic_vector(2 downto 0);
  signal axi_awvalid : std_logic;
  signal axi_awready : std_logic;
  signal axi_wdata : std_logic_vector(TB_DATA_WIDTH-1 downto 0);
  signal axi_wstrb : std_logic_vector((TB_DATA_WIDTH/8)-1 downto 0);
  signal axi_wvalid : std_logic;
  signal axi_wready : std_logic;
  signal axi_bresp : std_logic_vector(1 downto 0);
  signal axi_bvalid : std_logic;
  signal axi_bready : std_logic;
  signal axi_araddr : std_logic_vector(TB_ADDR_WIDTH-1 downto 0);
  signal axi_arprot : std_logic_vector(2 downto 0);
  signal axi_arvalid : std_logic;
  signal axi_arready : std_logic;
  signal axi_rdata : std_logic_vector(TB_DATA_WIDTH-1 downto 0);
  signal axi_rresp : std_logic_vector(1 downto 0);
  signal axi_rvalid : std_logic;
  signal axi_rready : std_logic;

  signal write_data : std_logic;
  signal read_data : std_logic;

  -- Simulation timing
  constant clockperiod : TIME := 5 ns;

begin

  UUT : entity work.hm2_axilite_int
    generic map (
      C_S_AXI_DATA_WIDTH => TB_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => TB_ADDR_WIDTH)
    port map (
      ADDR => addr(15 downto 2),
      IBUS => ibus,
      OBUS => obus,
      READSTB => readstb,
      WRITESTB => writestb,
      S_AXI_ACLK => axi_aclk,
      S_AXI_ARESETN => axi_aresetn,
      S_AXI_AWADDR => axi_awaddr,
      S_AXI_AWPROT => axi_awprot,
      S_AXI_AWVALID => axi_awvalid,
      S_AXI_AWREADY => axi_awready,
      S_AXI_WDATA => axi_wdata,
      S_AXI_WSTRB => axi_wstrb,
      S_AXI_WVALID => axi_wvalid,
      S_AXI_WREADY => axi_wready,
      S_AXI_BRESP => axi_bresp,
      S_AXI_BVALID => axi_bvalid,
      S_AXI_BREADY => axi_bready,
      S_AXI_ARADDR => axi_araddr,
      S_AXI_ARREADY => axi_arready,
      S_AXI_ARPROT => axi_arprot,
      S_AXI_ARVALID => axi_arvalid,
      S_AXI_RDATA => axi_rdata,
      S_AXI_RRESP => axi_rresp,
      S_AXI_RVALID => axi_rvalid,
      S_AXI_RREADY => axi_rready
    );

  regs : entity work.hm2_axilite_gen32_simreg
    generic map (
      C_S_AXI_DATA_WIDTH => TB_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => TB_ADDR_WIDTH)
    port map (
      RESETN => axi_aresetn,
      CLK => axi_aclk,
      ADDR => addr,
      IBUS => ibus,
      OBUS => obus,
      READSTB => readstb,
      WRITESTB => writestb
    );

    addr(1 downto 0) <= (others => '0');

  -- Generate the reference clock @ 50% duty cycle
  clock_gen : process
  begin
    wait for (clockperiod / 2);
    axi_aclk <= '1';
    wait for (clockperiod / 2);
    axi_aclk <= '0';
  end process;

  -- A write transaction
  -- You must set the data and address bus to the desired location/value before
  -- kicking off this process with the write_data signal
  do_write : process
  begin
     axi_awvalid <= '0';  -- Start with the address and data valid flags being false
     axi_wvalid <= '0';
     axi_bready <= '0';   -- Deassert response ready
     loop
         wait until write_data = '1';
         wait until axi_aclk = '0';
             axi_awvalid <= '1';
             axi_wvalid <= '1';
         wait until axi_bvalid = '1';  -- Slave will indicate when response is valid
             assert axi_bresp = "00" report "AXI data not written" severity failure;
             axi_awvalid <= '0';
             axi_wvalid <= '0';
             axi_bready <='1';
         wait until axi_bvalid = '0';  -- Transaction ends, kill ready flag
             axi_bready <= '0';
     end loop;
  end process;

  -- A read transaction
  -- You must set the address bus to the desired location before
  -- kicking off this process with the read_data signal
   do_read : process
   BEGIN
     axi_arvalid <= '0';
     axi_rready <= '0';
      loop
          wait until read_data = '1';
          wait until axi_aclk = '0';
              axi_arvalid <= '1';
              axi_rready <= '1';
          wait until axi_arready = '1' and rising_edge(axi_aclk);
              axi_arvalid <= '0';
          wait until axi_rvalid = '1' and rising_edge(axi_aclk);
             assert axi_rresp = "00" report "AXI data not written" severity failure;
            axi_rready <= '0';
      end loop;
  end process;

  -- The stimulus
  stim : process
  begin
    axi_aresetn <= '0';
    write_data <= '0';
    read_data <= '0';

    wait for 15 ns;
      axi_aresetn <= '1';
      axi_awaddr <= x"0000";
      axi_wstrb <= b"1111";
      axi_wdata <= x"11111111";
      write_data <= '1';                --Start AXI Write to Slave
    wait for 1 ns;
      write_data <= '0'; --Clear Start Send Flag
    wait until axi_bvalid = '1';
    wait until axi_bvalid = '0';  --AXI Write finished
      axi_awaddr <= x"0004";
      axi_wdata <= x"22222222";
      axi_wstrb <= b"1111";
      write_data <= '1';                --Start AXI Write to Slave
    wait for 1 ns;
      write_data <= '0'; --Clear Start Send Flag
    wait until axi_bvalid = '1';
    wait until axi_bvalid = '0';  --AXI Write finished
      axi_awaddr <= x"0008";
      axi_wdata <= x"33333333";
      axi_wstrb <= b"1111";
      write_data <= '1';                --Start AXI Write to Slave
    wait for 1 ns;
      write_data <= '0'; --Clear Start Send Flag
    wait until axi_bvalid = '1';
    wait until axi_bvalid = '0';  --AXI Write finished
      axi_awaddr <= x"000C";
      axi_wdata <= x"A5A5A5A5";
      axi_wstrb <= b"1111";
      write_data <= '1';                --Start AXI Write to Slave
    wait for 1 ns;
      write_data <= '0'; --Clear Start Send Flag
    wait until axi_bvalid = '1';
    wait until axi_bvalid = '0';  --AXI Write finished
      axi_araddr <= x"0000";
      read_data <= '1';                --Start AXI Read from Slave
    wait for 1 ns;
      read_data <= '0'; --Clear "Start Read" Flag
    wait until axi_rvalid = '1';
    wait until axi_rvalid = '0';
      axi_araddr <= x"0004";
      read_data <= '1';                --Start AXI Read from Slave
    wait for 1 ns;
      read_data <= '0'; --Clear "Start Read" Flag
    wait until axi_rvalid = '1';
    wait until axi_rvalid = '0';
      axi_araddr <= x"0008";
      read_data <= '1';                --Start AXI Read from Slave
    wait for 1 ns;
      read_data <= '0'; --Clear "Start Read" Flag
    wait until axi_rvalid = '1';
    wait until axi_rvalid = '0';
      axi_araddr <= x"000C";
      read_data <= '1';                --Start AXI Read from Slave
    wait for 1 ns;
      read_data <= '0'; --Clear "Start Read" Flag
    wait until axi_rvalid = '1';
    wait until axi_rvalid = '0';
    wait; -- will wait forever
  end process;
end beh;
