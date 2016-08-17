library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity btint_top is
    generic (
        PP_BUF_ADDR_WIDTH : natural := 6;
        BAUD_TIMER_WIDTH : natural := 16;
        PKT_FLAG : std_logic_vector(7 downto 0) := x"FE";
        PKT_ESC_FLAG : std_logic_vector(7 downto 0) := x"FD";
        PKT_BL_FLAG : std_logic_vector(7 downto 0) := x"FC";
        ESC_XOR_FLAG : std_logic_vector(7 downto 0) := x"AA"
    );
    port (
        rst_n : in std_logic;
        clk : in std_logic;
        uart_tx : out std_logic;
        uart_rx : in std_logic;
        addr_rd : in std_logic_vector(15 downto 0);
        addr_wr : in std_logic_vector(15 downto 0);
        idata : in std_logic_vector(31 downto 0);
        odata : out std_logic_vector(31 downto 0);
        wr : in std_logic;
        wr_strobe : in std_logic_vector(3 downto 0);
        sync : in std_logic
    );
end entity;

architecture imp of btint_top is
    -- UART Transmission
    signal utx_busy : std_logic;
    signal utx_data : std_logic_vector(7 downto 0);
    signal utx_load : std_logic := '0';

    -- Packet Transmitter
    signal pkttx_packet : std_logic_vector(31 downto 0);
    signal pkttx_we : std_logic;
    signal pkttx_busy : std_logic;

    -- UART Reception
    signal urx_data : std_logic_vector(7 downto 0);
    signal urx_data_rdy: std_logic;
    signal urx_rd : std_logic;
    signal urx_fr_err : std_logic;
    signal urx_of_err : std_logic;

    -- Packet Validator, writes to pp buffer
    signal pp_wr : std_logic;
    signal pp_lock : std_logic;
    signal pp_wr_data : std_logic_vector(7 downto 0);
    signal pp_wr_addr : std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
    signal odata_rx : std_logic_vector(31 downto 0);
    signal pp_we1 : std_logic;
    signal pp_we2 : std_logic;

    -- Master controller, reads from pp buffer
    signal pp_rd_addr : std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
    signal pp_rd_data1 : std_logic_vector(7 downto 0);
    signal pp_rd_data2 : std_logic_vector(7 downto 0);
    signal odata_ctrl : std_logic_vector(31 downto 0);
    signal cnt_rst_n : std_logic;

    -- Sets up 230400 baud with a 50MHz input clock
    constant BAUDREG : unsigned(BAUD_TIMER_WIDTH - 1 downto 0) := x"001A";
begin
  pp_we1 <= '1' when (pp_wr = '1' and pp_lock = '0') else '0';
  pp_we2 <= '1' when (pp_wr = '1' and pp_lock = '1') else '0';
    -- ------------------------------------------
    -- Ping-Pong Buffer
    -- ------------------------------------------
    pp_buf1 : entity work.ram_dualp
        generic map(
            PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
        )
        port map (
            clk => clk,
            rd_addr => pp_rd_addr,
            rd_data => pp_rd_data1,
            we => pp_we1,
            wr_addr => pp_wr_addr,
            wr_data => pp_wr_data
        );

    pp_buf2 : entity work.ram_dualp
        generic map(
            PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
        )
        port map (
            clk => clk,
            rd_addr => pp_rd_addr,
            rd_data => pp_rd_data2,
            we => pp_we2,
            wr_addr => pp_wr_addr,
            wr_data => pp_wr_data
        );

    -- ------------------------------------------
    -- Transmission Components from the bottom up
    -- ------------------------------------------

    -- The UART transmit side
    uart_tx1 : entity work.uart_tx
        generic map (
            TIMER_WIDTH => BAUD_TIMER_WIDTH)
        port map (
            rst_n => cnt_rst_n,
            clk => clk,
            load => utx_load,
            data_in => utx_data,
            baudreg => BAUDREG,
            uart_tx => uart_tx,
            busy => utx_busy
        );

    -- The outgoing packet processor
    pkt_tx1 : entity work.pkt_builder_tx
        generic map (
            PKT_FLAG => PKT_FLAG,
            PKT_ESC_FLAG => PKT_ESC_FLAG,
            PKT_BL_FLAG => PKT_BL_FLAG,
            ESC_XOR_FLAG => ESC_XOR_FLAG
        )
        port map (
            rst_n => cnt_rst_n,
            clk => clk,
            packet => pkttx_packet,
            we => pkttx_we,
            busy => pkttx_busy,
            uart_data => utx_data,
            uart_busy => utx_busy,
            uart_load => utx_load
        );

    -- ------------------------------------------
    -- Reception Components from the bottom up
    -- ------------------------------------------

    -- The UART reception side
    uart_rx1 : entity work.uart_rx
        generic map (
            TIMER_WIDTH => BAUD_TIMER_WIDTH
        )
        port map (
            rst_n => cnt_rst_n,
            clk => clk,
            uart_rx => uart_rx,
            data_read => urx_rd,
            baudreg => BAUDREG,
            data_ready => urx_data_rdy,
            data_out => urx_data,
            overflow_err => urx_of_err,
            frame_err => urx_fr_err
        );

    -- The incoming packet validator
    pkt_rx1 : entity work.pkt_receiver_rx
        generic map (
            PKT_FLAG => PKT_FLAG,
            PKT_ESC_FLAG => PKT_ESC_FLAG,
            ESC_XOR_FLAG => ESC_XOR_FLAG,
            PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
        )
        port map (
            rst_n => cnt_rst_n,
            clk => clk,
            pp_buf_lock => pp_lock,
            pp_addr => pp_wr_addr,
            pp_data => pp_wr_data,
            pp_wr => pp_wr,
            uart_data => urx_data,
            uart_data_rdy => urx_data_rdy,
            uart_rd => urx_rd,
            uart_fr_err => urx_fr_err,
            uart_of_err => urx_of_err,
            addr_rd => addr_rd,
            odata => odata_rx
        );

    -- ------------------------------------------
    -- Top level controller
    -- ------------------------------------------

    btint_control1 : entity work.btint_controller
        generic map(
            PP_BUF_ADDR_WIDTH => PP_BUF_ADDR_WIDTH
        )
        port map (
            rst_n => rst_n,
            cnt_rst_n => cnt_rst_n,
            clk => clk,
            pp_buf_lock => pp_lock,
            pp_addr => pp_rd_addr,
            pp_data1 => pp_rd_data1,
            pp_data2 => pp_rd_data2,
            pkt_tx_data => pkttx_packet,
            pkt_tx_we => pkttx_we,
            pkt_tx_busy => pkttx_busy,
            addr_wr => addr_wr,
            idata => idata,
            wr => wr,
            wr_strobe => wr_strobe,
            addr_rd => addr_rd,
            odata => odata_ctrl,
            sync => sync
        );

   rd_addr_mux : process(addr_rd, odata_ctrl, odata_rx)
   begin
     case(addr_rd) is
       when x"0600" | x"0604" | x"0608" | x"060C" =>
          odata <= odata_rx;
       when others =>
          odata <= odata_ctrl;
     end case;
   end process rd_addr_mux;
end imp;
