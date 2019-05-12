// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// ============================================================================
//
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Tue Dec  2 09:28:38 2014
// ============================================================================

module DE0_Nano_SoC_Cramps(

    ///////// ADC /////////
    output             ADC_CONVST,
    output             ADC_SCK,
    output             ADC_SDI,
    input              ADC_SDO,

    ///////// ARDUINO /////////
    inout       [15:0] ARDUINO_IO,
    inout              ARDUINO_RESET_N,

    ///////// CLOCK //////////
    input              FPGA_CLK1_50,
    input              FPGA_CLK2_50,
    input              FPGA_CLK3_50,


    output             CLK_I2C_SCL,
    inout              CLK_I2C_SDA,











    ///////// HPS //////////
    inout              HPS_CONV_USB_N,
    output      [14:0] HPS_DDR3_ADDR,
    output      [2:0]  HPS_DDR3_BA,
    output             HPS_DDR3_CAS_N,
    output             HPS_DDR3_CKE,
    output             HPS_DDR3_CK_N,
    output             HPS_DDR3_CK_P,
    output             HPS_DDR3_CS_N,
    output      [3:0]  HPS_DDR3_DM,
    inout       [31:0] HPS_DDR3_DQ,
    inout       [3:0]  HPS_DDR3_DQS_N,
    inout       [3:0]  HPS_DDR3_DQS_P,
    output             HPS_DDR3_ODT,
    output             HPS_DDR3_RAS_N,
    output             HPS_DDR3_RESET_N,
    input              HPS_DDR3_RZQ,
    output             HPS_DDR3_WE_N,
    output             HPS_ENET_GTX_CLK,
    inout              HPS_ENET_INT_N,
    output             HPS_ENET_MDC,
    inout              HPS_ENET_MDIO,
    input              HPS_ENET_RX_CLK,
    input       [3:0]  HPS_ENET_RX_DATA,
    input              HPS_ENET_RX_DV,
    output      [3:0]  HPS_ENET_TX_DATA,
    output             HPS_ENET_TX_EN,
    inout              HPS_GSENSOR_INT,
    inout              HPS_I2C0_SCLK,
    inout              HPS_I2C0_SDAT,
    inout              HPS_I2C1_SCLK,
    inout              HPS_I2C1_SDAT,
    inout              HPS_KEY,
    inout              HPS_LED,
    inout              HPS_LTC_GPIO,
    output             HPS_SD_CLK,
    inout              HPS_SD_CMD,
    inout       [3:0]  HPS_SD_DATA,
    output             HPS_SPIM_CLK,
    input              HPS_SPIM_MISO,
    output             HPS_SPIM_MOSI,
    inout              HPS_SPIM_SS,
    input              HPS_UART_RX,
    output             HPS_UART_TX,
    input              HPS_USB_CLKOUT,
    inout       [7:0]  HPS_USB_DATA,
    input              HPS_USB_DIR,
    input              HPS_USB_NXT,
    output             HPS_USB_STP,

    ///////// KEY /////////
    input       [1:0]  KEY,

    ///////// LED /////////
    output      [7:0]  LED,

    ///////// SW /////////
    input       [3:0]  SW,

    ///////// GPIO /////////
    inout       [35:0] GPIO[1:0]
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
// DE0-Nano Dev kit and I/O adaptors specific info
import boardtype::*;
parameter NumIOAddrReg = 6;

    wire        hps_fpga_reset_n;
    wire [1:0]  fpga_debounced_buttons;
    wire [6:0]  fpga_led_internal;
//  wire [2:0]  hps_reset_req;
    wire        hps_cold_reset;
    wire        hps_warm_reset;
    wire        hps_debug_reset;
//    wire [27:0] stm_hw_events;
    wire        fpga_clk_50;



// connection of internal logics
//    assign LED[5:1] = fpga_led_internal;
    assign fpga_clk_50 = FPGA_CLK1_50;
//    assign stm_hw_events    = {{15{1'b0}}, SW, fpga_led_internal, fpga_debounced_buttons};
// hm2
    wire [AddrWidth-1:2]    hm_address;
    wire [31:0]             hm_datao;
    wire [31:0]             hm_datai;
    wire [31:0]             busdata_out;
    wire                    hm_read;
    wire                    hm_write;
    wire [3:0]              hm_chipsel;
    wire                    hm_clk_med;
    wire                    hm_clk_high;
    wire                    adc_clk_40;
//    wire                    clklow_sig;
    wire                    clkmed_sig;
    wire                    clkhigh_sig;

// Mesa I/O Signals:
    wire [LEDCount-1:0]         hm2_leds_sig;
    wire [IOWidth-1:0]          hm2_bitsout_sig;
    wire [IOWidth-1:0]          hm2_bitsin_sig;

    wire [MuxLedWidth-1:0]      io_leds_sig[NumGPIO-1:0];
    wire [MuxGPIOIOWidth-1:0]   io_bitsout_sig[NumGPIO-1:0];
    wire [MuxGPIOIOWidth-1:0]   io_bitsin_sig[NumGPIO-1:0];

//irq:
    wire int_sig;
    assign ARDUINO_IO[15] = int_sig;

// Capsense:
	wire [NumSense-1:0] 	touched;

// connection of internal logics
    assign LED[4:1] = touched;

//=======================================================
//  Structural coding
//=======================================================











soc_system u0 (
    //Clock&Reset
    .clk_clk                               (fpga_clk_50 ),                               //                            clk.clk
    .reset_reset_n                         (hps_fpga_reset_n ),                         //                          reset.reset_n











    //HPS ddr3
    .memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
    .memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
    .memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
    .memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
    .memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
    .memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
    .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
    .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
    .memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
    .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
    .memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
    .memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
    .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n[i1]
    .memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
    .memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
    .memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin
    //HPS ethernet
    .hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),       //                             hps_0_hps_io.hps_io_emac1_inst_TX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),   //                             .hps_io_emac1_inst_TXD0
    .hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),   //                             .hps_io_emac1_inst_TXD1
    .hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),   //                             .hps_io_emac1_inst_TXD2
    .hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),   //                             .hps_io_emac1_inst_TXD3
    .hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),   //                             .hps_io_emac1_inst_RXD0
    .hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),         //                             .hps_io_emac1_inst_MDIO
    .hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),         //                             .hps_io_emac1_inst_MDC
    .hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),         //                             .hps_io_emac1_inst_RX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),         //                             .hps_io_emac1_inst_TX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),        //                             .hps_io_emac1_inst_RX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),   //                             .hps_io_emac1_inst_RXD1
    .hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),   //                             .hps_io_emac1_inst_RXD2
    .hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),   //                             .hps_io_emac1_inst_RXD3
    //HPS SD card
    .hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),           //                               .hps_io_sdio_inst_CMD
    .hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),      //                               .hps_io_sdio_inst_D0
    .hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),      //                               .hps_io_sdio_inst_D1
    .hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),            //                               .hps_io_sdio_inst_CLK
    .hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),      //                               .hps_io_sdio_inst_D2
    .hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),      //                               .hps_io_sdio_inst_D3
    //HPS USB
    .hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),      //                               .hps_io_usb1_inst_D0
    .hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),      //                               .hps_io_usb1_inst_D1
    .hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),      //                               .hps_io_usb1_inst_D2
    .hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),      //                               .hps_io_usb1_inst_D3
    .hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),      //                               .hps_io_usb1_inst_D4
    .hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),      //                               .hps_io_usb1_inst_D5
    .hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),      //                               .hps_io_usb1_inst_D6
    .hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),      //                               .hps_io_usb1_inst_D7
    .hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),       //                               .hps_io_usb1_inst_CLK
    .hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),          //                               .hps_io_usb1_inst_STP
    .hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),          //                               .hps_io_usb1_inst_DIR
    .hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),          //                               .hps_io_usb1_inst_NXT
    //HPS SPI
    .hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),           //                               .hps_io_spim1_inst_CLK
    .hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),           //                               .hps_io_spim1_inst_MOSI
    .hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),           //                               .hps_io_spim1_inst_MISO
    .hps_0_hps_io_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS   ),             //                               .hps_io_spim1_inst_SS0
    //HPS UART
    .hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX   ),          //                               .hps_io_uart0_inst_RX
    .hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX   ),          //                               .hps_io_uart0_inst_TX
    //HPS I2C1
    .hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C0_SDAT  ),        //                               .hps_io_i2c0_inst_SDA
    .hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C0_SCLK  ),        //                               .hps_io_i2c0_inst_SCL
    //HPS I2C2
    .hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C1_SDAT  ),        //                               .hps_io_i2c1_inst_SDA
    .hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C1_SCLK  ),        //                               .hps_io_i2c1_inst_SCL
    //GPIO
    .hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N ),  //                               .hps_io_gpio_inst_GPIO09
    .hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N ),  //                               .hps_io_gpio_inst_GPIO35
    .hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO   ),  //                               .hps_io_gpio_inst_GPIO40
    .hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED   ),  //                               .hps_io_gpio_inst_GPIO53
    .hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY   ),  //                               .hps_io_gpio_inst_GPIO54
    .hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT ),  //                               .hps_io_gpio_inst_GPIO61
    //FPGA Partion
    .led_pio_export                        ( fpga_led_internal ),    //    led_pio_external_connection.export
    .dipsw_pio_export                      ( SW ),  //  dipsw_pio_external_connection.export
    .button_pio_export                     ( fpga_debounced_buttons ), // button_pio_external_connection.export
    .hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),                //                hps_0_h2f_reset.reset_n
    // hm2reg_io_0_conduit
    .mk_io_hm2_datain                      (busdata_out),                    //           .hm2_datain
    .mk_io_hm2_dataout                     (hm_datai),                    //            hm2reg.hm2_dataout
    .mk_io_hm2_address                     (hm_address),                  //           .hm2_address
    .mk_io_hm2_write                       (hm_write),                    //           .hm2_write
    .mk_io_hm2_read                        (hm_read),                     //           .hm2_read
    .mk_io_hm2_chipsel                     (hm_chipsel),                  //           .hm2_chipsel
    .mk_io_hm2_int_in                      (int_sig),                     //           .hm2_int_in
    .clk_100mhz_out_clk                    (hm_clk_med),                  //            clk_100mhz_out.clk
    .clk_200mhz_out_clk                    (hm_clk_high),                 //            clk_100mhz_out.clk
    .adc_clk_40mhz_clk                     (adc_clk_40)                  //             adc_clk_40mhz.clk
);

top_io_modules top_io_modules_inst
(
    .clk(fpga_clk_50) ,	// input  clk_sig
    .reset_n(hps_fpga_reset_n) ,	// input  reset_n_sig
    .button_in(KEY) ,	// input [KEY_WIDTH-1:0] button_in_sig
    .button_out(fpga_debounced_buttons) ,	// output [KEY_WIDTH-1:0] button_out_sig
    .LED(LED[0]) 	// output  LED_sig
);

defparam top_io_modules_inst.KEY_WIDTH = 2;

// Mesa code ------------------------------------------------------//

assign clkhigh_sig = hm_clk_high;
assign clkmed_sig = hm_clk_med;


genvar ig;
generate for(ig=0;ig<NumGPIO;ig=ig+1) begin : iosigloop
    assign io_bitsout_sig[ig] = hm2_bitsout_sig[(ig*MuxGPIOIOWidth)+:MuxGPIOIOWidth];
    assign io_bitsin_sig[ig] = hm2_bitsin_sig[(ig*MuxGPIOIOWidth)+:MuxGPIOIOWidth];
end
endgenerate

gpio_adr_decoder_reg gpio_adr_decoder_reg_inst
(
    .CLOCK(fpga_clk_50) ,	// input  CLOCK_sig
    .reg_clk(clkhigh_sig) ,	// input  CLOCK_sig
    .reset_reg_N(hps_fpga_reset_n) ,	// input  reset_reg_N_sig
    .chip_sel(hm_chipsel[0]) ,	// input  data_ready_sig
    .write_reg(hm_write) ,	// input  data_ready_sig
    .read_reg(hm_read) ,	// input  data_ready_sig
//	.leds_sig(io_leds_sig) ,	// input  data_ready_sig
    .busaddress(hm_address) ,	// input [AddrWidth-1:0] address_sig
    .busdata_in(hm_datai) ,	// input [BusWidth-1:0] data_in_sig
    .iodatafromhm3 ( io_bitsout_sig ),
    .busdata_fromhm2 ( hm_datao ),
    .gpioport( GPIO ),
    .iodatatohm3 ( io_bitsin_sig ),
    .busdata_to_cpu ( busdata_out ),
// ADC
    .adc_clk(adc_clk_40),	// input  adc_clk_sig
    .ADC_CONVST_o(ADC_CONVST),	// output  ADC_CONVST_o_sig
    .ADC_SCK_o(ADC_SCK),	// output  ADC_SCK_o_sig
    .ADC_SDI_o(ADC_SDI),	// output  ADC_SDI_o_sig
    .ADC_SDO_i(ADC_SDO),	// input  ADC_SDO_i_sig
// CAP_Sensors
	.touched(touched),
    .buttons(fpga_debounced_buttons)
);

defparam gpio_adr_decoder_reg_inst.AddrWidth = AddrWidth;
defparam gpio_adr_decoder_reg_inst.BusWidth = BusWidth;
defparam gpio_adr_decoder_reg_inst.GPIOWidth = GPIOWidth;
defparam gpio_adr_decoder_reg_inst.MuxGPIOIOWidth = MuxGPIOIOWidth;
defparam gpio_adr_decoder_reg_inst.NumIOAddrReg = NumIOAddrReg;
defparam gpio_adr_decoder_reg_inst.NumGPIO = NumGPIO;
defparam gpio_adr_decoder_reg_inst.ADC = ADC;
defparam gpio_adr_decoder_reg_inst.Capsense = Capsense;
defparam gpio_adr_decoder_reg_inst.NumSense = NumSense;

HostMot3_cfg HostMot3_inst
(
    .ibustop(hm_datai) ,	// input [buswidth-1:0] ibus_sig
    .obustop(hm_datao) ,	// output [buswidth-1:0] obus_sig
    .addr(hm_address) ,	// input [addrwidth-1:2] addr_sig	-- addr => A(AddrWidth-1 downto 2),
    .readstb(hm_read ) ,	// input  readstb_sig
    .writestb(hm_write) ,	// input  writestb_sig

    .clklow(fpga_clk_50) ,	// input  clklow_sig  				-- PCI clock --> all
    .clkmed(clkmed_sig) ,	// input  clkmed_sig  				-- Processor clock --> sserialwa, twiddle
    .clkhigh(clkhigh_sig) ,	// input  clkhigh_sig				-- High speed clock --> most
    .intirq(int_sig) ,	// output  int_sig							--int => LINT, ---> PCI ?
    .iobitsouttop(hm2_bitsout_sig) ,	// inout [IOWidth-1:0] 				--iobits => IOBITS,-- external I/O bits
    .iobitsintop(hm2_bitsin_sig) 	// inout [IOWidth-1:0] 				--iobits => IOBITS,-- external I/O bits
//	.liobits(liobits_sig) ,	// inout [lIOWidth-1:0] 			--liobits_sig
//	.leds(hm2_leds_sig) 	// output [ledcount-1:0] leds_sig		--leds => LEDS
);

// defparam HostMot3_inst.ThePinDesc = PinDesc;
// defparam HostMot3_inst.TheModuleID =  "ModuleID";
// defparam HostMot3_inst.IDROMType = 3;
defparam HostMot3_inst.SepClocks = SepClocks;
defparam HostMot3_inst.OneWS = OneWS;
// defparam HostMot3_inst.UseIRQLogic = "true";
// defparam HostMot3_inst.PWMRefWidth = 13;
// defparam HostMot3_inst.UseWatchDog = "true";
// defparam HostMot3_inst.OffsetToModules = 64;
// defparam HostMot3_inst.OffsetToPinDesc = 448;
defparam HostMot3_inst.ClockHigh = ClockHigh;
defparam HostMot3_inst.ClockMed = ClockMed;
defparam HostMot3_inst.ClockLow = ClockLow;
defparam HostMot3_inst.BoardNameLow = BoardNameLow;
defparam HostMot3_inst.BoardNameHigh = BoardNameHigh;
defparam HostMot3_inst.FPGASize = FPGASize;
defparam HostMot3_inst.FPGAPins = FPGAPins;
defparam HostMot3_inst.IOPorts = IOPorts;
defparam HostMot3_inst.IOWidth = IOWidth;
defparam HostMot3_inst.PortWidth = PortWidth;
defparam HostMot3_inst.LIOWidth = LIOWidth;
defparam HostMot3_inst.LEDCount = LEDCount;
defparam HostMot3_inst.BusWidth = BusWidth;
defparam HostMot3_inst.AddrWidth = AddrWidth;
// defparam HostMot3_inst.InstStride0 = 4;
// defparam HostMot3_inst.InstStride1 = 64;
// defparam HostMot3_inst.RegStride0 = 256;
// defparam HostMot3_inst.RegStride1 = 256;

endmodule
