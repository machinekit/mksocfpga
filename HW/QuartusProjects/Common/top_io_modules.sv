module top_io_modules

#(
	// Parameter Declarations
	parameter KEY_WIDTH = 2
)

(
	// Input Ports
	input wire clk,
	input wire reset_n,
	input [KEY_WIDTH-1:0] button_in,

	// Output Ports
	output [KEY_WIDTH-1:0] button_out,
//	output hps_cold_reset,
//	output hps_warm_reset,
//	output hps_debug_reset,
	output LED
);

//	wire [2:0]  hps_reset_req;

// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
  .clk                                  (clk),
  .reset_n                              (reset_n),
  .data_in                              (button_in),
  .data_out                             (button_out)
);
  defparam debounce_inst.WIDTH = 2;
  defparam debounce_inst.POLARITY = "LOW";
  defparam debounce_inst.TIMEOUT = 50000;               // at 50Mhz this is a debounce time of 1ms
  defparam debounce_inst.TIMEOUT_WIDTH = 16;            // ceil(log2(TIMEOUT))

// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (clk),
  .source     (hps_reset_req)
);
/*
altera_edge_detector pulse_cold_reset (
  .clk       (clk),
  .rst_n     (reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (clk),
  .rst_n     (reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_debug_reset (
  .clk       (clk),
  .rst_n     (reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;
*/
led_blinker led_blinker_inst
(
	.clk(clk) ,	// input  clk_sig
	.reset_n(reset_n) ,	// input  reset_n_sig
	.LED(LED) 	// output  LED_sig
);

defparam led_blinker_inst.COUNT_MAX = 24999999;

endmodule
