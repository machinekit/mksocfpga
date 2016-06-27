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

`define ENABLE_HPS
//`define ENABLE_CLK

module DE0_NANO(

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_SCK,
      output             ADC_SDI,
      input              ADC_SDO,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO,
      inout              ARDUINO_RESET_N,

`ifdef ENABLE_CLK
      ///////// CLK /////////
      output             CLK_I2C_SCL,
      inout              CLK_I2C_SDA,
`endif /*ENABLE_CLK*/

      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      input              FPGA_CLK2_50,
      input              FPGA_CLK3_50,

      ///////// GPIO /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,

`ifdef ENABLE_HPS
      ///////// HPS /////////
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

`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY,

      ///////// LED /////////
      output      [7:0]  LED,

      ///////// SW /////////
      input       [3:0]  SW
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
// DE0-Nano Dev kit and I/O adaptors specific info
import boardtype::*;

//--------- moved to include file -----------//
//  parameter GPIOWidth 		= 36;
//  parameter NumGPIO 			= 2;
//  parameter MuxGPIOIOWidth 	= IOWidth/NumGPIO;
//-------------------------------------------//

  wire  hps_fpga_reset_n;
  wire [1:0] fpga_debounced_buttons;
  wire [6:0]  fpga_led_internal;
  wire [2:0]  hps_reset_req;
  wire        hps_cold_reset;
  wire        hps_warm_reset;
  wire        hps_debug_reset;
  wire [27:0] stm_hw_events;
  wire 		  fpga_clk_50;
// connection of internal logics
  assign LED[7:1] = fpga_led_internal;
  assign fpga_clk_50 = FPGA_CLK2_50;
  assign stm_hw_events    = {{15{1'b0}}, SW, fpga_led_internal, fpga_debounced_buttons};
// hm2
  wire [AddrWidth-3:0] 	hm_address;
  wire [31:0] 				hm_datao;
  wire [31:0] 				hm_datai;
  wire       				hm_read;
  wire 						hm_write;
  wire [3:0]				hm_chipsel;
  wire						hm_clk_med;
  wire						hm_clk_high;
  wire 						clklow_sig;
  wire 						clkhigh_sig;

  tri [IOWidth-1:0] 		hm2_iobits_sig;
  tri [LEDCount-1:0]		hm2_leds_sig;

//  assign GPIO_0[IOWidth-1:0] = hm2_iobits_sig;

// GPIO mux

//`define DB25
// if defined mux --> DE0_Nano_SoC_DB25 adaptor
// this can be done ion the include file

  generate
	if(NumGPIO == 1) begin
		wire [GPIOWidth-1:0]				GPIO;
		wire [MuxGPIOIOWidth-1:0]		hm2_iobits;
		wire [(LEDCount/NumGPIO)-1:0]	hm2_leds;
		assign GPIO_0 						= GPIO;
		assign hm2_iobits 				= hm2_iobits_sig;
		assign hm2_leds 					= hm2_leds_sig;

      if (BoardAdaptor == 1) begin

         // DE0_Nano_SoC_DB25 adaptor
         assign GPIO[16] = hm2_iobits[00]; // PIN 1
         assign GPIO[17] = hm2_iobits[01]; // PIN 14
         assign GPIO[14] = hm2_iobits[02]; // PIN 2
         assign GPIO[15] = hm2_iobits[03]; // PIN 15
         assign GPIO[12] = hm2_iobits[04]; // PIN 3
         assign GPIO[13] = hm2_iobits[05]; // PIN 16
         assign GPIO[10] = hm2_iobits[06]; // PIN 4
         assign GPIO[11] = hm2_iobits[07]; // PIN 17
         assign GPIO[08] = hm2_iobits[08]; // PIN 5
         assign GPIO[09] = hm2_iobits[09]; // PIN 6
         assign GPIO[06] = hm2_iobits[10]; // PIN 7
         assign GPIO[07] = hm2_iobits[11]; // PIN 8
         assign GPIO[04] = hm2_iobits[12]; // PIN 9
         assign GPIO[05] = hm2_iobits[13]; // PIN 10
         assign GPIO[02] = hm2_iobits[14]; // PIN 11
         assign GPIO[03] = hm2_iobits[15]; // PIN 12
         assign GPIO[00] = hm2_iobits[16]; // PIN 13
         assign GPIO[01] = hm2_leds[0];

         // DB25-P3
         assign GPIO[34] = hm2_iobits[17]; // PIN 1
         assign GPIO[35] = hm2_iobits[18]; // PIN 14
         assign GPIO[32] = hm2_iobits[19]; // PIN 2
         assign GPIO[33] = hm2_iobits[20]; // PIN 15
         assign GPIO[30] = hm2_iobits[21]; // PIN 3
         assign GPIO[31] = hm2_iobits[22]; // PIN 16
         assign GPIO[28] = hm2_iobits[23]; // PIN 4
         assign GPIO[29] = hm2_iobits[24]; // PIN 17
         assign GPIO[26] = hm2_iobits[25]; // PIN 5
         assign GPIO[27] = hm2_iobits[26]; // PIN 6
         assign GPIO[24] = hm2_iobits[27]; // PIN 7
         assign GPIO[25] = hm2_iobits[28]; // PIN 8
         assign GPIO[22] = hm2_iobits[29]; // PIN 9
         assign GPIO[23] = hm2_iobits[30]; // PIN 10
         assign GPIO[20] = hm2_iobits[31]; // PIN 11
         assign GPIO[21] = hm2_iobits[32]; // PIN 12
         assign GPIO[18] = hm2_iobits[33]; // PIN 13
         assign GPIO[19] = hm2_leds[1];
      end
      else if (BoardAdaptor == 0) begin
         assign GPIO		= {hm2_leds,hm2_iobits};
      end
   end
	else if(NumGPIO == 2) begin
// DE0_Nano_SoC_DB25 adaptor
		wire [MuxGPIOIOWidth-1:0]	hm2_iobits[NumGPIO-1:0];
		wire [MuxLedWidth-1:0]		hm2_leds[NumGPIO-1:0];
		wire [GPIOWidth-1:0]			GPIO[NumGPIO-1:0];

		assign hm2_iobits[0] 		= hm2_iobits_sig[MuxGPIOIOWidth-1:0];
		assign hm2_iobits[1] 		= hm2_iobits_sig[IOWidth-1:MuxGPIOIOWidth];
		assign GPIO_0					= GPIO[0];
		assign GPIO_1					= GPIO[1];
		assign hm2_leds[0] 			= hm2_leds_sig[MuxLedWidth-1:0];
		assign hm2_leds[1] 			= hm2_leds_sig[LEDCount-1:MuxLedWidth];
		genvar i1;
		for (i1=0;i1<NumGPIO;i1=i1+1)begin : gpioloop
      if (BoardAdaptor == 1) begin
			assign GPIO[i1][16] = hm2_iobits[i1][00]; // PIN 1
			assign GPIO[i1][17] = hm2_iobits[i1][01]; // PIN 14
			assign GPIO[i1][14] = hm2_iobits[i1][02]; // PIN 2
			assign GPIO[i1][15] = hm2_iobits[i1][03]; // PIN 15
			assign GPIO[i1][12] = hm2_iobits[i1][04]; // PIN 3
			assign GPIO[i1][13] = hm2_iobits[i1][05]; // PIN 16
			assign GPIO[i1][10] = hm2_iobits[i1][06]; // PIN 4
			assign GPIO[i1][11] = hm2_iobits[i1][07]; // PIN 17
			assign GPIO[i1][08] = hm2_iobits[i1][08]; // PIN 5
			assign GPIO[i1][09] = hm2_iobits[i1][09]; // PIN 6
			assign GPIO[i1][06] = hm2_iobits[i1][10]; // PIN 7
			assign GPIO[i1][07] = hm2_iobits[i1][11]; // PIN 8
			assign GPIO[i1][04] = hm2_iobits[i1][12]; // PIN 9
			assign GPIO[i1][05] = hm2_iobits[i1][13]; // PIN 10
			assign GPIO[i1][02] = hm2_iobits[i1][14]; // PIN 11
			assign GPIO[i1][03] = hm2_iobits[i1][15]; // PIN 12
			assign GPIO[i1][00] = hm2_iobits[i1][16]; // PIN 13
			assign GPIO[i1][01] = hm2_leds[i1][0];

	// DB25-P3
			assign GPIO[i1][34] = hm2_iobits[i1][17]; // PIN 1
			assign GPIO[i1][35] = hm2_iobits[i1][18]; // PIN 14
			assign GPIO[i1][32] = hm2_iobits[i1][19]; // PIN 2
			assign GPIO[i1][33] = hm2_iobits[i1][20]; // PIN 15
			assign GPIO[i1][30] = hm2_iobits[i1][21]; // PIN 3
			assign GPIO[i1][31] = hm2_iobits[i1][22]; // PIN 16
			assign GPIO[i1][28] = hm2_iobits[i1][23]; // PIN 4
			assign GPIO[i1][29] = hm2_iobits[i1][24]; // PIN 17
			assign GPIO[i1][26] = hm2_iobits[i1][25]; // PIN 5
			assign GPIO[i1][27] = hm2_iobits[i1][26]; // PIN 6
			assign GPIO[i1][24] = hm2_iobits[i1][27]; // PIN 7
			assign GPIO[i1][25] = hm2_iobits[i1][28]; // PIN 8
			assign GPIO[i1][22] = hm2_iobits[i1][29]; // PIN 9
			assign GPIO[i1][23] = hm2_iobits[i1][30]; // PIN 10
			assign GPIO[i1][20] = hm2_iobits[i1][31]; // PIN 11
			assign GPIO[i1][21] = hm2_iobits[i1][32]; // PIN 12
			assign GPIO[i1][18] = hm2_iobits[i1][33]; // PIN 13
			assign GPIO[i1][19] = hm2_leds[i1][1];
      end
      else if (BoardAdaptor == 0) begin
			assign GPIO[i1]		= {hm2_leds[i1],hm2_iobits[i1]};
		end
	end
 end
 endgenerate

  wire [LIOWidth-1:0]	hm2_liobits_sig;

//irq:
  wire int_sig;
  assign ARDUINO_IO[15] = int_sig;

//  wire [8:0] 	out_oe;
//  wire [8:0]	out_data;
//  wire [1:0]	ar_out_oe;
//  wire [1:0]	ar_in_sig;

//=======================================================
//  Structural coding
//=======================================================

//  assign ARDUINO_IO[8:0] = out_oe[8:0] ? out_data[8:0] : 1'bz;
//  assign ARDUINO_IO[10:9] = ar_out_oe ? ar_in_sig : 1'bz;

//  assign out_oe = 9'b1;
//  assign ar_out_oe = 2'b0;

soc_system u0 (
	//Clock&Reset
	.clk_clk                               (FPGA_CLK1_50 ),                               //                            clk.clk
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
	.led_pio_export                        ( fpga_led_internal 	),    //    led_pio_external_connection.export
	.dipsw_pio_export                      ( SW	),  //  dipsw_pio_external_connection.export
	.button_pio_export                     ( fpga_debounced_buttons	), // button_pio_external_connection.export
	.hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),                //                hps_0_h2f_reset.reset_n
	.hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset ),      //       hps_0_f2h_cold_reset_req.reset_n
	.hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset ),     //      hps_0_f2h_debug_reset_req.reset_n
	.hps_0_f2h_stm_hw_events_stm_hwevents  (stm_hw_events ),  //        hps_0_f2h_stm_hw_events.stm_hwevents
	.hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset ),      //       hps_0_f2h_warm_reset_req.reset_n
	// hm2reg_io_0_conduit
	.mk_io_hm2_datain                  		(hm_datao),                    //           .hm2_datain
	.mk_io_hm2_dataout                 	  	(hm_datai),                    //            hm2reg.hm2_dataout
	.mk_io_hm2_address                 	  	(hm_address),                  //           .hm2_address
	.mk_io_hm2_write                   		(hm_write),                    //           .hm2_write
	.mk_io_hm2_read                    		(hm_read),                     //           .hm2_read
	.mk_io_hm2_chipsel            			(hm_chipsel),                  //           .hm2_chipsel
	.mk_io_hm2_int_in						(int_sig),                     //           .hm2_int_in
	.clk_100mhz_out_clk                    	(hm_clk_med),                  //            clk_100mhz_out.clk
	.clk_200mhz_out_clk                    	(hm_clk_high),                 //            clk_100mhz_out.clk
	.adc_io_convst                          (ADC_CONVST),                  //            adc.CONVST
	.adc_io_sck								(ADC_SCK),                     //           .SCK
	.adc_io_sdi								(ADC_SDI),                     //           .SDI
	.adc_io_sdo								(ADC_SDO)                      //           .SDO
//   .axi_str_data                      (out_data[7:0]),                   //            stream_port.data
//   .axi_str_valid                     (out_data[8]),                     //           .valid
//   .axi_str_ready                     (ar_in_sig[1])                     //           .ready
 );

// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
  .clk                                  (fpga_clk_50),
  .reset_n                              (hps_fpga_reset_n),
  .data_in                              (KEY),
  .data_out                             (fpga_debounced_buttons)
);
  defparam debounce_inst.WIDTH = 2;
  defparam debounce_inst.POLARITY = "LOW";
  defparam debounce_inst.TIMEOUT = 50000;               // at 50Mhz this is a debounce time of 1ms
  defparam debounce_inst.TIMEOUT_WIDTH = 16;            // ceil(log2(TIMEOUT))

// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (fpga_clk_50),
  .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_debug_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

led_blinker led_blinker_inst
(
	.fpga_clk_50(fpga_clk_50) ,	// input  fpga_clk_50_sig
	.hps_fpga_reset_n(hps_fpga_reset_n) ,	// input  hps_fpga_reset_n_sig
	.LED(LED[0]) 	// output  LED_sig
);

defparam led_blinker_inst.COUNT_MAX = 24999999;

// Mesa code ------------------------------------------------------//

assign clklow_sig = fpga_clk_50;
assign clkhigh_sig = hm_clk_high;
assign clkmed_sig = hm_clk_med;

assign ARDUINO_IO[LIOWidth-1:0] = hm2_liobits_sig;

HostMot2_cfg HostMot2_inst
(
	.ibus(hm_datai) ,	// input [buswidth-1:0] ibus_sig
	.obus(hm_datao) ,	// output [buswidth-1:0] obus_sig
	.addr(hm_address) ,	// input [addrwidth-1:2] addr_sig	-- addr => A(AddrWidth-1 downto 2),
	.readstb(hm_read ) ,	// input  readstb_sig
	.writestb(hm_write) ,	// input  writestb_sig

	.clklow(clklow_sig) ,	// input  clklow_sig  				-- PCI clock --> all
	.clkmed(clkmed_sig) ,	// input  clkmed_sig  				-- Processor clock --> sserialwa, twiddle
	.clkhigh(clkhigh_sig) ,	// input  clkhigh_sig				-- High speed clock --> most
	.intirq(int_sig) ,	// output  int_sig							--int => LINT, ---> PCI ?
//	.dreq(dreq_sig) ,	// output  dreq_sig
//	.demandmode(demandmode_sig) ,	// output  demandmode_sig
	.iobits(hm2_iobits_sig) ,	// inout [IOWidth-1:0] 				--iobits => IOBITS,-- external I/O bits
	.liobits(hm2_liobits_sig) ,	// inout [lIOWidth-1:0] 			--liobits_sig
//	.rates(rates_sig) ,	// output [4:0] rates_sig
	.leds(hm2_leds_sig) 	// output [ledcount-1:0] leds_sig		--leds => LEDS
//	.leds(GPIO_0[35:34]) 	// output [ledcount-1:0] leds_sig		--leds => LEDS
);

// defparam HostMot2_inst.ThePinDesc = PinDesc;
// defparam HostMot2_inst.TheModuleID =  "ModuleID";
// defparam HostMot2_inst.IDROMType = 3;
defparam HostMot2_inst.SepClocks = SepClocks;
defparam HostMot2_inst.OneWS = OneWS;
// defparam HostMot2_inst.UseIRQLogic = "true";
// defparam HostMot2_inst.PWMRefWidth = 13;
// defparam HostMot2_inst.UseWatchDog = "true";
// defparam HostMot2_inst.OffsetToModules = 64;
// defparam HostMot2_inst.OffsetToPinDesc = 448;
defparam HostMot2_inst.ClockHigh = ClockHigh;
defparam HostMot2_inst.ClockMed = ClockMed;
defparam HostMot2_inst.ClockLow = ClockLow;
defparam HostMot2_inst.BoardNameLow = BoardNameLow;
defparam HostMot2_inst.BoardNameHigh = BoardNameHigh;
defparam HostMot2_inst.FPGASize = FPGASize;
defparam HostMot2_inst.FPGAPins = FPGAPins;
defparam HostMot2_inst.IOPorts = IOPorts;
defparam HostMot2_inst.IOWidth = IOWidth;
defparam HostMot2_inst.PortWidth = PortWidth;
defparam HostMot2_inst.LIOWidth = LIOWidth;
defparam HostMot2_inst.LEDCount = LEDCount;
defparam HostMot2_inst.BusWidth = BusWidth;
defparam HostMot2_inst.AddrWidth = AddrWidth;
// defparam HostMot2_inst.InstStride0 = 4;
// defparam HostMot2_inst.InstStride1 = 64;
// defparam HostMot2_inst.RegStride0 = 256;
// defparam HostMot2_inst.RegStride1 = 256;

endmodule
