module gpio_mux (
	inout [GPIOWidth-1:0]	GPIO,
	inout [IOWidth-1:0] 	hm2_iobits,
	inout [1:0]				hm2_leds
);

parameter GPIOWidth = 36;
parameter IOWidth = 34;

`ifdef GPIO_STRAIGHT

assign GPIO[IOWidth-1:0] = hm2_iobits;
assign GPIO[GPIOWidth-1:IOWidth] = hm2_leds;

`else
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

`endif

endmodule
