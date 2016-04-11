// ============================================================================
// Copyright (c) 2013 by Arrow Electronics, Inc.
// ============================================================================
//
// Permission:
//
//   Arrow grants permission to use and modify this code for use
//   in synthesis for all Arrow Development Boards. Other use of this code,
//	  including the selling ,duplication, or modification of any portion is
//   strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Arrow provides no warranty regarding the use
//   or functionality of this code.
//
// ============================================================================
//
//  Arrow Technologies Inc
//  Englewood, CO. USA
//
//
//                     web: http://www.Arrow.com/
//
//
// ============================================================================
// Date:  Mon Mar 27 13:20:22 2013
// ============================================================================
//
// ============================================================================
// Revision Change list:
// ============================================================================
//
// 								soc_system_20130323
//
//	Description: Connected hps_fpga_reset_n output to verilog top level reset.
//					 Added button debounce circuitry. Bypassed at present. Debug required.
//					 Used clk_bot1. clk_50m_fpga does not work. Debug required.
//
//
// 								soc_system_20130408
//
//	Description: Changed vga_sync_n & vga_blank_n from inputs to outputs
//					 Changed ddr3_fpga_rasn, ddr3_fpga_resetn, ddr3_fpga_wen from
//					 inputs to outputs.
//
//
// 								soc_system_20130411
//
//	Description: Removed debounce circuit. External 74HC245 performs pushbutton
//					 debounce.
//
//
// 								soc_system_20131109
//
//	Description: Upgrade to release 13.1
//					 Quartus: Changed top level to ghrd_top
//					 Quartus: Added Source/Probe Megawizard instances for f2h cold/warm/debug resets
//					 Quartus: Added system trace connections
//					 Qsys: Changed naming for jtag_master from master_secure to hps_only_master
//					 Qsys: Changed naming for jtag_master from master_non_sec to fpga_only_master
//					 Qsys: hps_component. Enabled input ports for f2h cold/warm/debug resets
//					 Qsys: hps_component. Enabled system trace ports
//
//
// 								soc_system_20140711
//
//	Description: Upgrade to release 14.0
//					 Quartus: Changed device to 5CSXFC6D6F31C6
//					 Qsys: hps_component. Enabled f2dram_0, 256 bit bidirectional Avalon-MM FPGA to SDRAM interface
//					 Qsys: Added f2sdram_only jtag_master
//
//
// 								soc_system_20141225
//
//	Description: Upgrade to release 14.1
//					 Quartus:
//					 Qsys: Added a mm_bridge between the lw_axi_master and all fpga peripherals
//					 Qsys: hps_component / hps_clocks_tab. qspi clock freq changed to 333MHz
//							 from 400MHz
//					 Qsys: hps_component / hps_clocks_tab. configuration / hps to fpga user 0
//							 clock frequency changed to 123.333333MHz from 100MHz
//
//
// 								soc_system_20150901
//
//	Description: Upgrade to release 15.0
//					 Quartus:
//					 Qsys:
//
//
// 								soc_system_20160212
//
//	Description: Upgrade to release 15.1
//					 Quartus:
//					 Qsys:
//
// ============================================================================
// Qsys System :
// ============================================================================
//
// Description:
//
//		To view the Qsys system open Qsys and selected soc_system.qsys.
//		This system mimics the Altera Development kit GHRD design. The system
//		console script, "ghrd_sc_script.tcl", which can be found in this projects
//		root directory, is identical to the Altera script and will implement all
//		the functionality described in the GHRD Users Guide. All software examples
//		shown in the users guide will also be fully functional on the Arrow SoCKIT.
//
//
// ============================================================================

`include "top/config_soc.v"

module ghrd_top (

		output wire [14:0] memory_mem_a,
		output wire [2:0]  memory_mem_ba,
		output wire        memory_mem_ck,
		output wire        memory_mem_ck_n,
		output wire        memory_mem_cke,
		output wire        memory_mem_cs_n,
		output wire        memory_mem_ras_n,
		output wire        memory_mem_cas_n,
		output wire        memory_mem_we_n,
		output wire        memory_mem_reset_n,
		inout  wire [31:0] memory_mem_dq,
		inout  wire [3:0]  memory_mem_dqs,
		inout  wire [3:0]  memory_mem_dqs_n,
		output wire        memory_mem_odt,
		output wire [3:0]  memory_mem_dm,
		input  wire        memory_oct_rzqin,
		output wire        hps_emac1_TX_CLK,
		output wire        hps_emac1_TXD0,
		output wire        hps_emac1_TXD1,
		output wire        hps_emac1_TXD2,
		output wire        hps_emac1_TXD3,
		input  wire        hps_emac1_RXD0,
		inout  wire        hps_emac1_MDIO,
		output wire        hps_emac1_MDC,
		input  wire        hps_emac1_RX_CTL,
		output wire        hps_emac1_TX_CTL,
		input  wire        hps_emac1_RX_CLK,
		input  wire        hps_emac1_RXD1,
		input  wire        hps_emac1_RXD2,
		input  wire        hps_emac1_RXD3,
		inout  wire        hps_qspi_IO0,
		inout  wire        hps_qspi_IO1,
		inout  wire        hps_qspi_IO2,
		inout  wire        hps_qspi_IO3,
		output wire        hps_qspi_SS0,
		output wire        hps_qspi_CLK,
		inout  wire        hps_sdio_CMD,
		inout  wire        hps_sdio_D0,
		inout  wire        hps_sdio_D1,
		output wire        hps_sdio_CLK,
		inout  wire        hps_sdio_D2,
		inout  wire        hps_sdio_D3,
		inout  wire        hps_usb1_D0,
		inout  wire        hps_usb1_D1,
		inout  wire        hps_usb1_D2,
		inout  wire        hps_usb1_D3,
		inout  wire        hps_usb1_D4,
		inout  wire        hps_usb1_D5,
		inout  wire        hps_usb1_D6,
		inout  wire        hps_usb1_D7,
		input  wire        hps_usb1_CLK,
		output wire        hps_usb1_STP,
		input  wire        hps_usb1_DIR,
		input  wire        hps_usb1_NXT,
		output wire        hps_spim0_CLK,
		output wire        hps_spim0_MOSI,
		input  wire        hps_spim0_MISO,
		output wire        hps_spim0_SS0,
		output wire        hps_spim1_CLK,
		output wire        hps_spim1_MOSI,
		input  wire        hps_spim1_MISO,
		output wire        hps_spim1_SS0,
		input  wire        hps_uart0_RX,
		output wire        hps_uart0_TX,
		inout  wire        hps_i2c1_SDA,
		inout  wire        hps_i2c1_SCL,
		inout  wire        hps_gpio_GPIO00,
		inout  wire        hps_gpio_GPIO09,
		inout  wire        hps_gpio_GPIO35,
		inout  wire        hps_gpio_GPIO48,
		inout  wire        hps_gpio_GPIO53,
		inout  wire        hps_gpio_GPIO54,
		inout  wire        hps_gpio_GPIO55,
		inout  wire        hps_gpio_GPIO56,
		inout  wire        hps_gpio_GPIO61,
		inout  wire        hps_gpio_GPIO62,


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////		FPGA Interface			////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	//FPGA-GPLL-CLK------------------------//X pins
   input          clk_100m_fpga,       // 2.5V    //50 MHz ajustable from SiLabs SI5338
   input          clk_50m_fpga,        // 2.5V    //50 MHz ajustable from SiLabs SI5338
	input          clk_top1,            // 2.5V    //50 MHz ajustable from SiLabs SI5338
   input          clk_bot1,            // 1.5V    //50 MHz ajustable from SiLabs SI5338
	input          fpga_resetn,         // 2.5V    //FPGA Reset Pushbutton

	//////////////////// SiLabs Clock Generator I/F 	///////////////////
   output   wire  clk_i2c_sclk,        // I2C Clock
   inout    wire  clk_i2c_sdat,        // I2C Data

`ifdef user_peripheral
	//FPGA-User-IO-------------------------//14 pins //--------------------------
 	input	 [3:0]   user_dipsw_fpga,     //
	output [3:0]   user_led_fpga,       //
	input	 [3:0]   user_pb_fpga,        //
  	input  	wire  irda_rxd,				// IRDA Receive LED
  	output  	wire  fan_ctrl,				// control for fan
`endif

`ifdef ddr3
//FPGA-DDR3-400Mx32--------------------//74 pins //--------------------------
   output [14:0]  ddr3_fpga_a,         // SSTL15  //Address
   output [2:0]   ddr3_fpga_ba,        // SSTL15  //Bank Address
	output         ddr3_fpga_casn,      // SSTL15  //Column Address Strobe
	output         ddr3_fpga_cke,       // SSTL15  //Clock Enable
	output         ddr3_fpga_clk_n,     // SSTL15  //Diff Clock - Neg
	output         ddr3_fpga_clk_p,     // SSTL15  //Diff Clock - Pos
   output         ddr3_fpga_csn,       // SSTL15  //Chip Select
   output [3:0]   ddr3_fpga_dm,        // SSTL15  //Data Write Mask
   inout  [31:0]  ddr3_fpga_dq,        // SSTL15  //Data Bus
   inout  [3:0]   ddr3_fpga_dqs_n,     // SSTL15  //Diff Data Strobe - Neg
   inout  [3:0]   ddr3_fpga_dqs_p,     // SSTL15  //Diff Data Strobe - Pos
   output         ddr3_fpga_odt,       // SSTL15  //On-Die Termination Enable
   output          ddr3_fpga_rasn,     // SSTL15  //Row Address Strobe
   output          ddr3_fpga_resetn,   // SSTL15  //Reset
   output          ddr3_fpga_wen,      // SSTL15  //Write Enable
	input          ddr3_fpga_rzq,       // OCT_rzqin //On-die termination enable
//   input          oct_rdn,        	// SSTL15    //On-die termination enable
//   input          oct_rup,       		// SSTL15    //On-die termination enable
`endif

`ifdef temp_sense
 		//////////////////// 	Temp. Sensor I/F 	////////////////////
		// 							SPI interface								//
   output   wire  temp_cs_n,				// Chip Select
   output   wire  temp_sclk,       		// Slave Clock
   output   wire  temp_mosi,				// Data Out
   input    wire  temp_miso,				// Data In
`endif

`ifdef vga
		////////////////////	VIDEO 	 		////////////////////
   output 	wire  vga_clk,					// Video Clock
   output 	wire  vga_hs,					// Horizontal Synch
   output 	wire  vga_vs,					// Vertical Synch
   output   wire  [7:0] vga_r,			// Red
   output   wire  [7:0] vga_g,			// Green
   output   wire  [7:0] vga_b,			// Blue
   output 	wire  vga_blank_n,			// Composite Blank Control
   output 	wire  vga_sync_n,				// Composite Synch Control
`endif

`ifdef audio
	////////////////////	AUDIO 	 		////////////////////
   input 	wire  aud_adcdat,				// ADC Serial Data or I2C_SCLK
   input 	wire  aud_adclrck, 			// FDDR3e clock
   input 	wire  aud_bclk,				// Bit Clock
   output 	wire  aud_dacdat,				// DAC Serial Data
   inout 	wire  aud_daclrck,			// FDDR3e Clock
	output   wire  aud_i2c_sclk,
	inout    wire  aud_i2c_sdat,
	output   wire  aud_mute,
	output   wire  aud_xck,
`endif

`ifdef hsma
//HSMC-Port-A--------------------------////--------------------------
	input                         [2:1]        hsmc_clkin_n,
	input                         [2:1]        hsmc_clkin_p,
	output                        [2:1]        hsmc_clkout_n,
	output                        [2:1]        hsmc_clkout_p,
	input                                      hsmc_clk_in0,
	output                                     hsmc_clk_out0,
	inout                         [3:0]        hsmc_d,
`ifdef HSMC_XCVR
//	input                         [7:0]        hsmc_gxb_rx_n,
	input                         [7:0]        hsmc_gxb_rx_p,
//	output                        [7:0]        hsmc_gxb_tx_n,
	output                        [7:0]        hsmc_gxb_tx_p,
//	input                                      hsmc_ref_clk_n,
	input                                      hsmc_ref_clk_p,
`endif
	input                         [16:0]       hsmc_rx_n,
	input                         [16:0]       hsmc_rx_p,
	output                                     hsmc_scl,
	inout                                      hsmc_sda,
	output                         [16:0]       hsmc_tx_n,
	output                         [16:0]       hsmc_tx_p
 `endif

`ifdef htg 
	inout                         [35:0]       GPIO0,
	inout                         [35:0]       GPIO1,
	input                                      hsmc_rx_n8,
	input                                      hsmc_rx_p8,
	output                                     hsmc_tx_n8,
	output                                     hsmc_tx_p8,
	inout                         [3:0]        hsmc_d,
	input                                      hsmc_clk_in0,
	output                                     hsmc_clk_out0,
	inout                                      hsmc_sda,
	output                                     hsmc_scl

`endif
 
 	//////////////////// QSPI Flash I/F 	///////////////////
//   inout   wire  [3:0] fpga_epqc_data,     // Flash Data
//   output  wire  fpga_epqc_dclk,           // Data Clock
//   output  wire  fpga_epqc_ncso            // Chip Select

);

// internal wires and registers declaration
  wire [3:0]  fpga_led_internal;
  wire        hps_fpga_reset_n;
  wire [2:0]  hps_reset_req;
  wire        hps_cold_reset;
  wire        hps_warm_reset;
  wire        hps_debug_reset;
  wire [27:0] stm_hw_events;


// connection of internal logics
//  assign user_led_fpga = ~fpga_led_internal;
  assign user_led_fpga = fpga_led_internal;
  assign stm_hw_events    = {{18{1'b0}}, user_dipsw_fpga, fpga_led_internal, user_pb_fpga};

//  assign hsmc_tx_p = (user_dipsw_fpga[0]) ? 17'b0 : 17'h1FFFF;

    soc_system u0 (
        .clk_clk                               (clk_bot1),
        .reset_reset_n                         (hps_fpga_reset_n),
        .memory_mem_a                          (memory_mem_a),
        .memory_mem_ba                         (memory_mem_ba),
        .memory_mem_ck                         (memory_mem_ck),
        .memory_mem_ck_n                       (memory_mem_ck_n),
        .memory_mem_cke                        (memory_mem_cke),
        .memory_mem_cs_n                       (memory_mem_cs_n),
        .memory_mem_ras_n                      (memory_mem_ras_n),
        .memory_mem_cas_n                      (memory_mem_cas_n),
        .memory_mem_we_n                       (memory_mem_we_n),
        .memory_mem_reset_n                    (memory_mem_reset_n),
        .memory_mem_dq                         (memory_mem_dq),
        .memory_mem_dqs                        (memory_mem_dqs),
        .memory_mem_dqs_n                      (memory_mem_dqs_n),
        .memory_mem_odt                        (memory_mem_odt),
        .memory_mem_dm                         (memory_mem_dm),
        .memory_oct_rzqin                      (memory_oct_rzqin),
        .hps_0_hps_io_hps_io_emac1_inst_TX_CLK (hps_emac1_TX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_TXD0   (hps_emac1_TXD0),
        .hps_0_hps_io_hps_io_emac1_inst_TXD1   (hps_emac1_TXD1),
        .hps_0_hps_io_hps_io_emac1_inst_TXD2   (hps_emac1_TXD2),
        .hps_0_hps_io_hps_io_emac1_inst_TXD3   (hps_emac1_TXD3),
        .hps_0_hps_io_hps_io_emac1_inst_RXD0   (hps_emac1_RXD0),
        .hps_0_hps_io_hps_io_emac1_inst_MDIO   (hps_emac1_MDIO),
        .hps_0_hps_io_hps_io_emac1_inst_MDC    (hps_emac1_MDC),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CTL (hps_emac1_RX_CTL),
        .hps_0_hps_io_hps_io_emac1_inst_TX_CTL (hps_emac1_TX_CTL),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CLK (hps_emac1_RX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_RXD1   (hps_emac1_RXD1),
        .hps_0_hps_io_hps_io_emac1_inst_RXD2   (hps_emac1_RXD2),
        .hps_0_hps_io_hps_io_emac1_inst_RXD3   (hps_emac1_RXD3),
        .hps_0_hps_io_hps_io_qspi_inst_IO0     (hps_qspi_IO0),
        .hps_0_hps_io_hps_io_qspi_inst_IO1     (hps_qspi_IO1),
        .hps_0_hps_io_hps_io_qspi_inst_IO2     (hps_qspi_IO2),
        .hps_0_hps_io_hps_io_qspi_inst_IO3     (hps_qspi_IO3),
        .hps_0_hps_io_hps_io_qspi_inst_SS0     (hps_qspi_SS0),
        .hps_0_hps_io_hps_io_qspi_inst_CLK     (hps_qspi_CLK),
        .hps_0_hps_io_hps_io_sdio_inst_CMD     (hps_sdio_CMD),
        .hps_0_hps_io_hps_io_sdio_inst_D0      (hps_sdio_D0),
        .hps_0_hps_io_hps_io_sdio_inst_D1      (hps_sdio_D1),
        .hps_0_hps_io_hps_io_sdio_inst_CLK     (hps_sdio_CLK),
        .hps_0_hps_io_hps_io_sdio_inst_D2      (hps_sdio_D2),
        .hps_0_hps_io_hps_io_sdio_inst_D3      (hps_sdio_D3),
        .hps_0_hps_io_hps_io_usb1_inst_D0      (hps_usb1_D0),
        .hps_0_hps_io_hps_io_usb1_inst_D1      (hps_usb1_D1),
        .hps_0_hps_io_hps_io_usb1_inst_D2      (hps_usb1_D2),
        .hps_0_hps_io_hps_io_usb1_inst_D3      (hps_usb1_D3),
        .hps_0_hps_io_hps_io_usb1_inst_D4      (hps_usb1_D4),
        .hps_0_hps_io_hps_io_usb1_inst_D5      (hps_usb1_D5),
        .hps_0_hps_io_hps_io_usb1_inst_D6      (hps_usb1_D6),
        .hps_0_hps_io_hps_io_usb1_inst_D7      (hps_usb1_D7),
        .hps_0_hps_io_hps_io_usb1_inst_CLK     (hps_usb1_CLK),
        .hps_0_hps_io_hps_io_usb1_inst_STP     (hps_usb1_STP),
        .hps_0_hps_io_hps_io_usb1_inst_DIR     (hps_usb1_DIR),
        .hps_0_hps_io_hps_io_usb1_inst_NXT     (hps_usb1_NXT),
        .hps_0_hps_io_hps_io_spim0_inst_CLK    (hps_spim0_CLK),
        .hps_0_hps_io_hps_io_spim0_inst_MOSI   (hps_spim0_MOSI),
        .hps_0_hps_io_hps_io_spim0_inst_MISO   (hps_spim0_MISO),
        .hps_0_hps_io_hps_io_spim0_inst_SS0    (hps_spim0_SS0),
        .hps_0_hps_io_hps_io_spim1_inst_CLK    (hps_spim1_CLK),
        .hps_0_hps_io_hps_io_spim1_inst_MOSI   (hps_spim1_MOSI),
        .hps_0_hps_io_hps_io_spim1_inst_MISO   (hps_spim1_MISO),
        .hps_0_hps_io_hps_io_spim1_inst_SS0    (hps_spim1_SS0),
        .hps_0_hps_io_hps_io_uart0_inst_RX     (hps_uart0_RX),
        .hps_0_hps_io_hps_io_uart0_inst_TX     (hps_uart0_TX),
        .hps_0_hps_io_hps_io_i2c1_inst_SDA     (hps_i2c1_SDA),
        .hps_0_hps_io_hps_io_i2c1_inst_SCL     (hps_i2c1_SCL),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO00  (hps_gpio_GPIO00),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO09  (hps_gpio_GPIO09),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO35  (hps_gpio_GPIO35),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO48  (hps_gpio_GPIO48),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO53  (hps_gpio_GPIO53),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO54  (hps_gpio_GPIO54),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO55  (hps_gpio_GPIO55),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO56  (hps_gpio_GPIO56),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO61  (hps_gpio_GPIO61),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO62  (hps_gpio_GPIO62),
		  .hps_0_f2h_stm_hw_events_stm_hwevents  (stm_hw_events),
        .led_pio_external_connection_export  (fpga_led_internal),
		  .dipsw_pio_external_connection_export  (user_dipsw_fpga),
        .button_pio_external_connection_export (user_pb_fpga),
		  .hps_0_h2f_reset_reset_n               (hps_fpga_reset_n),
		  .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset),
		  .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset),
		  .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset),
		  .mk_io_hm2_datain                  		(hm_datao),     //   .hm2_datain
		  .mk_io_hm2_dataout                 	  	(hm_datai),     //    hm2reg.hm2_dataout
		  .mk_io_hm2_address                 	  	(hm_address),   //   .hm2_address
		  .mk_io_hm2_write                   		(hm_write),     //   .hm2_write
		  .mk_io_hm2_read                    		(hm_read),      //   .hm2_read
		  .mk_io_hm2_chipsel            				(hm_chipsel),   //   .hm2_chipsel
		  .clk_100mhz_out_clk                    	(hm_clk_med),   //    clk_100mhz_out.clk
		  .clk_200mhz_out_clk                    	(hm_clk_high)   //    clk_100mhz_out.clk
    );



  parameter AddrWidth = 16;
  parameter IOWidth = 34;
  parameter LIOWidth = 6;
  parameter IOPorts = 2;

// hm2
  wire [AddrWidth-3:0] 	hm_address;
  wire [31:0] 	hm_datao;
  wire [31:0] 	hm_datai;
  wire       	hm_read;
  wire 			hm_write;
  wire [3:0]	hm_chipsel;
  wire			hm_clk_med;
  wire			hm_clk_high;
  wire 			clklow_sig;
  wire 			clkhigh_sig;

  
//  assign GPIO_1[] = ;

 //  assign GPIO_0[] = ;

  
// Mesa code ------------------------------------------------------//

assign clklow_sig = clk_bot1;
assign clkhigh_sig = hm_clk_high;
assign clkmed_sig = hm_clk_med;

//import work::*;

wire [IOWidth-1:0] iobits_sig;
assign GPIO0[IOWidth-1:0] = iobits_sig;

wire [LIOWidth-1:0] liobits_sig;
//assign GPIO_1[LIOWidth-1:0] = liobits_sig;
//assign ARDUINO_IO[LIOWidth-1:0] = liobits_sig;
assign GPIO1[LIOWidth-1:0] = liobits_sig;


//HostMot2 #(.IOWidth(IOWidth),.IOPorts(IOPorts)) HostMot2_inst
HostMot2 HostMot2_inst
(
	.ibus(hm_datai) ,	// input [buswidth-1:0] ibus_sig
	.obus(hm_datao) ,	// output [buswidth-1:0] obus_sig
	.addr(hm_address) ,	// input [addrwidth-1:2] addr_sig	-- addr => A(AddrWidth-1 downto 2),
	.readstb(hm_read ) ,	// input  readstb_sig
	.writestb(hm_write) ,	// input  writestb_sig

	.clklow(clklow_sig) ,	// input  clklow_sig  				-- PCI clock --> all
	.clkmed(clkmed_sig) ,	// input  clkmed_sig  				-- Processor clock --> sserialwa, twiddle
	.clkhigh(clkhigh_sig) ,	// input  clkhigh_sig				-- High speed clock --> most
//	.int(int_sig) ,	// output  int_sig							--int => LINT, ---> PCI ?
//	.dreq(dreq_sig) ,	// output  dreq_sig
//	.demandmode(demandmode_sig) ,	// output  demandmode_sig
	.iobits(iobits_sig) ,	// inout [IOWidth-1:0] 				--iobits => IOBITS,-- external I/O bits
	.liobits(liobits_sig) ,	// inout [lIOWidth-1:0] 			--liobits_sig
//	.rates(rates_sig) ,	// output [4:0] rates_sig
	.leds(GPIO0[35:34]) 	// output [ledcount-1:0] leds_sig		--leds => LEDS
);



// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (clk_bot1),
  .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset (
  .clk       (clk_bot1),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (clk_bot1),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_debug_reset (
  .clk       (clk_bot1),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

endmodule
