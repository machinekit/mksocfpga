-- ============================================================================
-- Copyright (c) 2014 by Terasic Technologies Inc.
-- ============================================================================
--
-- Permission:
--
--   Terasic grants permission to use and modify this code for use
--   in synthesis for all Terasic Development Boards and Altera Development
--   Kits made by Terasic.  Other use of this code, including the selling
--   ,duplication, or modification of any portion is strictly prohibited.
--
-- Disclaimer:
--
--   This VHDL/Verilog or C/C++ source code is intended as a design reference
--   which illustrates how these types of functions can be implemented.
--   It is the user's responsibility to verify their design for
--   consistency and functionality through the use of formal
--   verification methods.  Terasic provides no warranty regarding the use
--   or functionality of this code.
--
-- ============================================================================
--
--  Terasic Technologies Inc
--  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
--
--
--                     web: http://www.terasic.com/
--                     email: support@terasic.com
--
-- ============================================================================
--Date:  Tue Dec  2 09:28:38 2014
-- ============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.soc_pkg.all;
use work.cv_ip_pkg.all;

entity DE0_Nano_SoC_DB25 is
    port (
        --------- ADC ---------
        ADC_CONVST         : out   std_logic;
        ADC_SCK            : out   std_logic;
        ADC_SDI            : out   std_logic;
        ADC_SDO            : in    std_logic;

        --------- ARDUINO ---------
        ARDUINO_IO         : inout std_logic_vector(15 downto 0);
        ARDUINO_RESET_N    : inout std_logic;

        --------- FPGA ---------
        FPGA_CLK1_50       : in    std_logic;
        FPGA_CLK2_50       : in    std_logic;
        FPGA_CLK3_50       : in    std_logic;

        --------- GPIO ---------
        GPIO_0             : inout std_logic_vector(35 downto 0);
        GPIO_1             : inout std_logic_vector(35 downto 0);

        --------- HPS ---------
        HPS_CONV_USB_N     : inout std_logic;
        HPS_DDR3_ADDR      : out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA        : out   std_logic_vector( 2 downto 0);
        HPS_DDR3_CAS_N     : out   std_logic;
        HPS_DDR3_CKE       : out   std_logic;
        HPS_DDR3_CK_N      : out   std_logic;
        HPS_DDR3_CK_P      : out   std_logic;
        HPS_DDR3_CS_N      : out   std_logic;
        HPS_DDR3_DM        : out   std_logic_vector( 3 downto 0);
        HPS_DDR3_DQ        : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N     : inout std_logic_vector( 3 downto 0);
        HPS_DDR3_DQS_P     : inout std_logic_vector( 3 downto 0);
        HPS_DDR3_ODT       : out   std_logic;
        HPS_DDR3_RAS_N     : out   std_logic;
        HPS_DDR3_RESET_N   : out   std_logic;
        HPS_DDR3_RZQ       : in    std_logic;
        HPS_DDR3_WE_N      : out   std_logic;
        HPS_ENET_GTX_CLK   : out   std_logic;
        HPS_ENET_INT_N     : inout std_logic;
        HPS_ENET_MDC       : out   std_logic;
        HPS_ENET_MDIO      : inout std_logic;
        HPS_ENET_RX_CLK    : in    std_logic;
        HPS_ENET_RX_DATA   : in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV     : in    std_logic;
        HPS_ENET_TX_DATA   : out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN     : out   std_logic;
        HPS_GSENSOR_INT    : inout std_logic;
        HPS_I2C0_SCLK      : inout std_logic;
        HPS_I2C0_SDAT      : inout std_logic;
        HPS_I2C1_SCLK      : inout std_logic;
        HPS_I2C1_SDAT      : inout std_logic;
        HPS_KEY            : inout std_logic;
        HPS_LED            : inout std_logic;
        HPS_LTC_GPIO       : inout std_logic;
        HPS_SD_CLK         : out   std_logic;
        HPS_SD_CMD         : inout std_logic;
        HPS_SD_DATA        : inout std_logic_vector(3 downto 0);
        HPS_SPIM_CLK       : out   std_logic;
        HPS_SPIM_MISO      : in    std_logic;
        HPS_SPIM_MOSI      : out   std_logic;
        HPS_SPIM_SS        : inout std_logic;
        HPS_UART_RX        : in    std_logic;
        HPS_UART_TX        : out   std_logic;
        HPS_USB_CLKOUT     : in    std_logic;
        HPS_USB_DATA       : inout std_logic_vector(7 downto 0);
        HPS_USB_DIR        : in    std_logic;
        HPS_USB_NXT        : in    std_logic;
        HPS_USB_STP        : out   std_logic;

        --------- KEY ---------
        KEY                : in    std_logic_vector(1 downto 0);

        --------- LED ---------
        LED                : out   std_logic_vector(7 downto 0);

        --------- SW ---------
        SW                 : in    std_logic_vector(3 downto 0) );
end DE0_Nano_SoC_DB25;

architecture arch of DE0_Nano_SoC_DB25 is

    -- REG/WIRE declarations
    signal hps_fpga_reset_n         : std_logic;
    signal fpga_debounced_buttons   : std_logic_vector(1 downto 0);
    signal buttons                  : std_logic_vector(3 downto 0);
    signal fpga_led_internal        : std_logic_vector(7 downto 0);
    signal hps_reset_req            : std_logic_vector(2 downto 0);
    signal hps_cold_reset           : std_logic;
    signal hps_warm_reset           : std_logic;
    signal hps_debug_reset          : std_logic;
    signal stm_hw_events            : std_logic_vector(27 downto 0);
    signal fpga_clk_50              : std_logic;

    -- hm2
    constant AddrWidth              : integer := 16;
    constant IOWidth                : integer := 68;
    constant LIOWidth               : integer := 0;

    signal hm_address               : std_logic_vector(AddrWidth-3 downto 0);
    signal hm_datao                 : std_logic_vector(31 downto 0);
    signal hm_datai                 : std_logic_vector(31 downto 0);
    signal hm_read                  : std_logic;
    signal hm_write                 : std_logic;
--  signal hm_chipsel               : std_logic_vector(3 downto 0);
    signal hm_clk_med               : std_logic;
    signal hm_clk_high              : std_logic;
    signal clklow_sig               : std_logic;
    signal clkhigh_sig              : std_logic;

    --irq:
    signal irq                      : std_logic;

    signal counter                  : unsigned(25 downto 0);
    signal led_level                : std_logic;
begin

-- connection of internal logics
    LED(7 downto 1) <= fpga_led_internal(6 downto 0);
    fpga_clk_50     <= FPGA_CLK2_50;
    stm_hw_events   <= b"00000000000000" & SW & fpga_led_internal & fpga_debounced_buttons;
    ARDUINO_IO(15)  <= irq;

--=======================================================
--  Structural coding
--=======================================================

    u0 : soc_system
    port map (
        --Clock&Reset
        clk_clk                                 => FPGA_CLK1_50,            --                            clk.clk
        reset_reset_n                           => hps_fpga_reset_n,        --                          reset.reset_n

        --HPS ddr3
        memory_mem_a                            => HPS_DDR3_ADDR,           --                         memory.mem_a
        memory_mem_ba                           => HPS_DDR3_BA,             --                               .mem_ba
        memory_mem_ck                           => HPS_DDR3_CK_P,           --                               .mem_ck
        memory_mem_ck_n                         => HPS_DDR3_CK_N,           --                               .mem_ck_n
        memory_mem_cke                          => HPS_DDR3_CKE,            --                               .mem_cke
        memory_mem_cs_n                         => HPS_DDR3_CS_N,           --                               .mem_cs_n
        memory_mem_ras_n                        => HPS_DDR3_RAS_N,          --                               .mem_ras_n
        memory_mem_cas_n                        => HPS_DDR3_CAS_N,          --                               .mem_cas_n
        memory_mem_we_n                         => HPS_DDR3_WE_N,           --                               .mem_we_n
        memory_mem_reset_n                      => HPS_DDR3_RESET_N,        --                               .mem_reset_n
        memory_mem_dq                           => HPS_DDR3_DQ,             --                               .mem_dq
        memory_mem_dqs                          => HPS_DDR3_DQS_P,          --                               .mem_dqs
        memory_mem_dqs_n                        => HPS_DDR3_DQS_N,          --                               .mem_dqs_n
        memory_mem_odt                          => HPS_DDR3_ODT,            --                               .mem_odt
        memory_mem_dm                           => HPS_DDR3_DM,             --                               .mem_dm
        memory_oct_rzqin                        => HPS_DDR3_RZQ,            --                               .oct_rzqin

        --HPS ethernet
        hps_0_hps_io_hps_io_emac1_inst_TX_CLK   => HPS_ENET_GTX_CLK,        --                   hps_0_hps_io.hps_io_emac1_inst_TX_CLK
        hps_0_hps_io_hps_io_emac1_inst_TXD0     => HPS_ENET_TX_DATA(0),     --                               .hps_io_emac1_inst_TXD0
        hps_0_hps_io_hps_io_emac1_inst_TXD1     => HPS_ENET_TX_DATA(1),     --                               .hps_io_emac1_inst_TXD1
        hps_0_hps_io_hps_io_emac1_inst_TXD2     => HPS_ENET_TX_DATA(2),     --                               .hps_io_emac1_inst_TXD2
        hps_0_hps_io_hps_io_emac1_inst_TXD3     => HPS_ENET_TX_DATA(3),     --                               .hps_io_emac1_inst_TXD3
        hps_0_hps_io_hps_io_emac1_inst_RXD0     => HPS_ENET_RX_DATA(0),     --                               .hps_io_emac1_inst_RXD0
        hps_0_hps_io_hps_io_emac1_inst_MDIO     => HPS_ENET_MDIO,           --                               .hps_io_emac1_inst_MDIO
        hps_0_hps_io_hps_io_emac1_inst_MDC      => HPS_ENET_MDC,            --                               .hps_io_emac1_inst_MDC
        hps_0_hps_io_hps_io_emac1_inst_RX_CTL   => HPS_ENET_RX_DV,          --                               .hps_io_emac1_inst_RX_CTL
        hps_0_hps_io_hps_io_emac1_inst_TX_CTL   => HPS_ENET_TX_EN,          --                               .hps_io_emac1_inst_TX_CTL
        hps_0_hps_io_hps_io_emac1_inst_RX_CLK   => HPS_ENET_RX_CLK,         --                               .hps_io_emac1_inst_RX_CLK
        hps_0_hps_io_hps_io_emac1_inst_RXD1     => HPS_ENET_RX_DATA(1),     --                               .hps_io_emac1_inst_RXD1
        hps_0_hps_io_hps_io_emac1_inst_RXD2     => HPS_ENET_RX_DATA(2),     --                               .hps_io_emac1_inst_RXD2
        hps_0_hps_io_hps_io_emac1_inst_RXD3     => HPS_ENET_RX_DATA(3),     --                               .hps_io_emac1_inst_RXD3

        --HPS SD card
        hps_0_hps_io_hps_io_sdio_inst_CMD       => HPS_SD_CMD,              --                               .hps_io_sdio_inst_CMD
        hps_0_hps_io_hps_io_sdio_inst_D0        => HPS_SD_DATA(0),          --                               .hps_io_sdio_inst_D0
        hps_0_hps_io_hps_io_sdio_inst_D1        => HPS_SD_DATA(1),          --                               .hps_io_sdio_inst_D1
        hps_0_hps_io_hps_io_sdio_inst_CLK       => HPS_SD_CLK,              --                               .hps_io_sdio_inst_CLK
        hps_0_hps_io_hps_io_sdio_inst_D2        => HPS_SD_DATA(2),          --                               .hps_io_sdio_inst_D2
        hps_0_hps_io_hps_io_sdio_inst_D3        => HPS_SD_DATA(3),          --                               .hps_io_sdio_inst_D3

        --HPS USB
        hps_0_hps_io_hps_io_usb1_inst_D0        => HPS_USB_DATA(0),         --                               .hps_io_usb1_inst_D0
        hps_0_hps_io_hps_io_usb1_inst_D1        => HPS_USB_DATA(1),         --                               .hps_io_usb1_inst_D1
        hps_0_hps_io_hps_io_usb1_inst_D2        => HPS_USB_DATA(2),         --                               .hps_io_usb1_inst_D2
        hps_0_hps_io_hps_io_usb1_inst_D3        => HPS_USB_DATA(3),         --                               .hps_io_usb1_inst_D3
        hps_0_hps_io_hps_io_usb1_inst_D4        => HPS_USB_DATA(4),         --                               .hps_io_usb1_inst_D4
        hps_0_hps_io_hps_io_usb1_inst_D5        => HPS_USB_DATA(5),         --                               .hps_io_usb1_inst_D5
        hps_0_hps_io_hps_io_usb1_inst_D6        => HPS_USB_DATA(6),         --                               .hps_io_usb1_inst_D6
        hps_0_hps_io_hps_io_usb1_inst_D7        => HPS_USB_DATA(7),         --                               .hps_io_usb1_inst_D7
        hps_0_hps_io_hps_io_usb1_inst_CLK       => HPS_USB_CLKOUT,          --                               .hps_io_usb1_inst_CLK
        hps_0_hps_io_hps_io_usb1_inst_STP       => HPS_USB_STP,             --                               .hps_io_usb1_inst_STP
        hps_0_hps_io_hps_io_usb1_inst_DIR       => HPS_USB_DIR,             --                               .hps_io_usb1_inst_DIR
        hps_0_hps_io_hps_io_usb1_inst_NXT       => HPS_USB_NXT,             --                               .hps_io_usb1_inst_NXT

        --HPS SPI
        hps_0_hps_io_hps_io_spim1_inst_CLK      => HPS_SPIM_CLK,            --                               .hps_io_spim1_inst_CLK
        hps_0_hps_io_hps_io_spim1_inst_MOSI     => HPS_SPIM_MOSI,           --                               .hps_io_spim1_inst_MOSI
        hps_0_hps_io_hps_io_spim1_inst_MISO     => HPS_SPIM_MISO,           --                               .hps_io_spim1_inst_MISO
        hps_0_hps_io_hps_io_spim1_inst_SS0      => HPS_SPIM_SS,             --                               .hps_io_spim1_inst_SS0

        --HPS UART
        hps_0_hps_io_hps_io_uart0_inst_RX       => HPS_UART_RX,             --                               .hps_io_uart0_inst_RX
        hps_0_hps_io_hps_io_uart0_inst_TX       => HPS_UART_TX,             --                               .hps_io_uart0_inst_TX

        --HPS I2C1
        hps_0_hps_io_hps_io_i2c0_inst_SDA       => HPS_I2C0_SDAT,           --                               .hps_io_i2c0_inst_SDA
        hps_0_hps_io_hps_io_i2c0_inst_SCL       => HPS_I2C0_SCLK,           --                               .hps_io_i2c0_inst_SCL

        --HPS I2C2
        hps_0_hps_io_hps_io_i2c1_inst_SDA       => HPS_I2C1_SDAT,           --                               .hps_io_i2c1_inst_SDA
        hps_0_hps_io_hps_io_i2c1_inst_SCL       => HPS_I2C1_SCLK,           --                               .hps_io_i2c1_inst_SCL

        --GPIO
        hps_0_hps_io_hps_io_gpio_inst_GPIO09    => HPS_CONV_USB_N,          --                               .hps_io_gpio_inst_GPIO09
        hps_0_hps_io_hps_io_gpio_inst_GPIO35    => HPS_ENET_INT_N,          --                               .hps_io_gpio_inst_GPIO35
        hps_0_hps_io_hps_io_gpio_inst_GPIO40    => HPS_LTC_GPIO,            --                               .hps_io_gpio_inst_GPIO40
        hps_0_hps_io_hps_io_gpio_inst_GPIO53    => HPS_LED,                 --                               .hps_io_gpio_inst_GPIO53
        hps_0_hps_io_hps_io_gpio_inst_GPIO54    => HPS_KEY,                 --                               .hps_io_gpio_inst_GPIO54
        hps_0_hps_io_hps_io_gpio_inst_GPIO61    => HPS_GSENSOR_INT,         --                               .hps_io_gpio_inst_GPIO61

        --FPGA Partion
        led_pio_export                          => fpga_led_internal,       --    led_pio_external_connection.export
        dipsw_pio_export                        => SW,                      --  dipsw_pio_external_connection.export
        button_pio_export                       => buttons,                 -- button_pio_external_connection.export
        hps_0_h2f_reset_reset_n                 => hps_fpga_reset_n,        --                hps_0_h2f_reset.reset_n
        hps_0_f2h_cold_reset_req_reset_n        => not hps_cold_reset,      --       hps_0_f2h_cold_reset_req.reset_n
        hps_0_f2h_debug_reset_req_reset_n       => not hps_debug_reset,     --      hps_0_f2h_debug_reset_req.reset_n
        hps_0_f2h_stm_hw_events_stm_hwevents    => stm_hw_events,           --        hps_0_f2h_stm_hw_events.stm_hwevents
        hps_0_f2h_warm_reset_req_reset_n        => not hps_warm_reset,      --       hps_0_f2h_warm_reset_req.reset_n

        -- hm2reg_io_0_conduit
        mk_io_hm2_dataout                       => hm_datai,                --                         hm2reg.hm2_dataout
        mk_io_hm2_datain                        => hm_datao,                --                               .hm2_datain
        mk_io_hm2_address                       => hm_address,              --                               .hm2_address
--      mk_io_hm2_addrout                       => hm_addri,                --                               .hm2_address
--      mk_io_hm2_addrin                        => hm_addro,                --                               .hm2_address
        mk_io_hm2_write                         => hm_write,                --                               .hm2_write
        mk_io_hm2_read                          => hm_read,                 --                               .hm2_read
--      mk_io_hm2_chipsel                       => hm_chipsel,              --                               .hm2_chipsel
--      mk_io_hm2_we                            => hm_chipsel,              --                               .hm2_chipsel
        mk_io_hm2_int_in                        => irq,                     --                               .hm2_int_in
        clk_100mhz_out_clk                      => hm_clk_med,              --                 clk_100mhz_out.clk
        clk_200mhz_out_clk                      => hm_clk_high,             --                 clk_100mhz_out.clk
        adc_io_convst                           => ADC_CONVST,              --                            adc.CONVST
        adc_io_sck                              => ADC_SCK,                 --                               .SCK
        adc_io_sdi                              => ADC_SDI,                 --                               .SDI
        adc_io_sdo                              => ADC_SDO                  --                               .SDO
--      axi_str_data                            => out_data[7:0],           --                    stream_port.data
--      axi_str_valid                           => out_data[8],             --                               .valid
--      axi_str_ready                           => ar_in_sig[1])            --                               .ready
);

-- Debounce logic to clean out glitches within 1ms
    debounce_inst : debounce
    generic map (
        WIDTH => 2,
        POLARITY => "LOW",
        TIMEOUT => 50000,                -- at 50Mhz this is a debounce time of 1ms
        TIMEOUT_WIDTH => 16 )            -- ceil(log2(TIMEOUT))
    port map (
        clk         => fpga_clk_50,
        reset_n     => hps_fpga_reset_n,
        data_in     => KEY,
        data_out    => fpga_debounced_buttons );

    buttons <= b"00" & fpga_debounced_buttons;

-- Source/Probe megawizard instance
    hps_reset_inst : hps_reset
    port map (
        probe       => '0',
        source_clk  => fpga_clk_50,
        source      => hps_reset_req );

    pulse_cold_reset : altera_edge_detector
    generic map (
        PULSE_EXT => 6,
        EDGE_TYPE => 1,
        IGNORE_RST_WHILE_BUSY => 1)
    port map (
        clk         => fpga_clk_50,
        rst_n       => hps_fpga_reset_n,
        signal_in   => hps_reset_req(0),
        pulse_out   => hps_cold_reset );

    pulse_warm_reset : altera_edge_detector
    generic map (
        PULSE_EXT => 2,
        EDGE_TYPE => 1,
        IGNORE_RST_WHILE_BUSY => 1 )
    port map (
        clk         => fpga_clk_50,
        rst_n       => hps_fpga_reset_n,
        signal_in   => hps_reset_req(1),
        pulse_out   => hps_warm_reset );

    pulse_debug_reset : altera_edge_detector
    generic map (
        PULSE_EXT => 32,
        EDGE_TYPE => 1,
        IGNORE_RST_WHILE_BUSY => 1 )
    port map (
        clk         => fpga_clk_50,
        rst_n       => hps_fpga_reset_n,
        signal_in   => hps_reset_req(2),
        pulse_out   => hps_debug_reset );

    process(fpga_clk_50, hps_fpga_reset_n)
    begin
        if hps_fpga_reset_n='0' then
            counter     <= (others=>'0');
            led_level   <= '0';
        elsif rising_edge(fpga_clk_50) then
            if counter = 24999999 then
                counter     <= (others=>'0');
                led_level   <= not led_level;
            else
                counter     <= counter + 1;
            end if;
        end if;
    end process;

    LED(0)  <= led_level;

-- Mesa code --------------------------------------------------------

    HostMot2_inst : entity work.HostMot2_cfg
    port map (
        ibus        => hm_datai,        -- input  [buswidth-1:0] ibus_sig
        obus        => hm_datao,        -- output [buswidth-1:0] obus_sig
        addr        => hm_address,      -- input  [addrwidth-1:2] addr_sig  -- addr => A(AddrWidth-1 downto 2),
        readstb     => hm_read,         -- input  readstb_sig
        writestb    => hm_write,        -- input  writestb_sig
        clklow      => fpga_clk_50,     -- input  clklow_sig                -- PCI clock --> all
        clkmed      => hm_clk_med,      -- input  clkmed_sig                -- Processor clock --> sserialwa, twiddle
        clkhigh     => hm_clk_high,     -- input  clkhigh_sig               -- High speed clock --> most
        irq         => irq,             -- output irq                       -- int => LINT, ---> PCI ?
        dreq        => open,            -- output dreq_sig
        demandmode  => open,            -- output demandmode_sig
--      iobits      =>                  -- inout  [IOWidth-1:0]             -- iobits => IOBITS,-- external I/O bits
        -- GPIO_0                   -- DB25-P2
        iobits( 0)  => GPIO_0(16),  -- PIN 1
        iobits( 1)  => GPIO_0(17),  -- PIN 14
        iobits( 2)  => GPIO_0(14),  -- PIN 2
        iobits( 3)  => GPIO_0(15),  -- PIN 15
        iobits( 4)  => GPIO_0(12),  -- PIN 3
        iobits( 5)  => GPIO_0(13),  -- PIN 16
        iobits( 6)  => GPIO_0(10),  -- PIN 4
        iobits( 7)  => GPIO_0(11),  -- PIN 17
        iobits( 8)  => GPIO_0(08),  -- PIN 5
        iobits( 9)  => GPIO_0(09),  -- PIN 6
        iobits(10)  => GPIO_0(06),  -- PIN 7
        iobits(11)  => GPIO_0(07),  -- PIN 8
        iobits(12)  => GPIO_0(04),  -- PIN 9
        iobits(13)  => GPIO_0(05),  -- PIN 10
        iobits(14)  => GPIO_0(02),  -- PIN 11
        iobits(15)  => GPIO_0(03),  -- PIN 12
        iobits(16)  => GPIO_0(00),  -- PIN 13

        -- GPIO_0                   -- DB25-P3
        iobits(17)  => GPIO_0(34),  -- PIN 1
        iobits(18)  => GPIO_0(35),  -- PIN 14
        iobits(19)  => GPIO_0(32),  -- PIN 2
        iobits(20)  => GPIO_0(33),  -- PIN 15
        iobits(21)  => GPIO_0(30),  -- PIN 3
        iobits(22)  => GPIO_0(31),  -- PIN 16
        iobits(23)  => GPIO_0(28),  -- PIN 4
        iobits(24)  => GPIO_0(29),  -- PIN 17
        iobits(25)  => GPIO_0(26),  -- PIN 5
        iobits(26)  => GPIO_0(27),  -- PIN 6
        iobits(27)  => GPIO_0(24),  -- PIN 7
        iobits(28)  => GPIO_0(25),  -- PIN 8
        iobits(29)  => GPIO_0(22),  -- PIN 9
        iobits(30)  => GPIO_0(23),  -- PIN 10
        iobits(31)  => GPIO_0(20),  -- PIN 11
        iobits(32)  => GPIO_0(21),  -- PIN 12
        iobits(33)  => GPIO_0(18),  -- PIN 13

        -- GPIO_1                   -- DB25-P2
        iobits(34)  => GPIO_1(16),  -- PIN 1
        iobits(35)  => GPIO_1(17),  -- PIN 14
        iobits(36)  => GPIO_1(14),  -- PIN 2
        iobits(37)  => GPIO_1(15),  -- PIN 15
        iobits(38)  => GPIO_1(12),  -- PIN 3
        iobits(39)  => GPIO_1(13),  -- PIN 16
        iobits(40)  => GPIO_1(10),  -- PIN 4
        iobits(41)  => GPIO_1(11),  -- PIN 17
        iobits(42)  => GPIO_1(08),  -- PIN 5
        iobits(43)  => GPIO_1(09),  -- PIN 6
        iobits(44)  => GPIO_1(06),  -- PIN 7
        iobits(45)  => GPIO_1(07),  -- PIN 8
        iobits(46)  => GPIO_1(04),  -- PIN 9
        iobits(47)  => GPIO_1(05),  -- PIN 10
        iobits(48)  => GPIO_1(02),  -- PIN 11
        iobits(49)  => GPIO_1(03),  -- PIN 12
        iobits(50)  => GPIO_1(00),  -- PIN 13

        -- GPIO_1                   -- DB25-P3
        iobits(51)  => GPIO_1(34),  -- PIN 1
        iobits(52)  => GPIO_1(35),  -- PIN 14
        iobits(53)  => GPIO_1(32),  -- PIN 2
        iobits(54)  => GPIO_1(33),  -- PIN 15
        iobits(55)  => GPIO_1(30),  -- PIN 3
        iobits(56)  => GPIO_1(31),  -- PIN 16
        iobits(57)  => GPIO_1(28),  -- PIN 4
        iobits(58)  => GPIO_1(29),  -- PIN 17
        iobits(59)  => GPIO_1(26),  -- PIN 5
        iobits(60)  => GPIO_1(27),  -- PIN 6
        iobits(61)  => GPIO_1(24),  -- PIN 7
        iobits(62)  => GPIO_1(25),  -- PIN 8
        iobits(63)  => GPIO_1(22),  -- PIN 9
        iobits(64)  => GPIO_1(23),  -- PIN 10
        iobits(65)  => GPIO_1(20),  -- PIN 11
        iobits(66)  => GPIO_1(21),  -- PIN 12
        iobits(67)  => GPIO_1(18),  -- PIN 13

        liobits     => open,            -- inout  [lIOWidth-1:0]             -- lhm2_iobits
        rates       => open,            -- output [4:0] rates_sig
        leds(0)     => GPIO_0(01),      -- output [ledcount-1:0] leds_sig   -- leds => LEDS
        leds(1)     => GPIO_0(19),
        leds(2)     => GPIO_1(01),
        leds(3)     => GPIO_1(19)
        );

end arch;
