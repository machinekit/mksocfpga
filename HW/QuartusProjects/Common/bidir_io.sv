module bidir_io
#(parameter IOWidth=36, parameter PortNumWidth=8)
(
	input [PortNumWidth-1:0] portselnum [IOWidth-1:0],
	input		clk,
	input 	[IOWidth-1:0] out_ena,
	input 	[IOWidth-1:0] od,
	input 	[IOWidth-1:0] out_data,
	inout 	[IOWidth-1:0] gpioport,
	output	[IOWidth-1:0] data_from_gpio
);

reg  [IOWidth-1:0] io_data_in;
////reg  [IOWidth-1:0] out_data_reg;
reg  [IOWidth-1:0] outmuxdataout;

wire [IOWidth-1:0] od_data;
//wire [IOWidth-1:0] outmuxdatain;
//wire [IOWidth-1:0] outmuxdata [IOWidth-1:0];

genvar loop;
generate
	for(loop=0;loop<IOWidth;loop=loop+1) begin : iogenloop
//		assign od_data[loop] = od[loop] ? (out_data[loop] ? 1'b0 : 1'bz) : out_data[loop];
		assign od_data[loop] = od[loop] ? (outmuxdataout[loop] ? 1'b0 : 1'bz) : outmuxdataout[loop];
////		assign outmuxdatain[loop]  = out_ena[loop] ? od_data[loop] : 1'bZ;
////		assign outmuxdatain[loop]  = out_ena[loop] ? out_data[loop] : 1'bZ;
////		assign gpioport[loop]  = outmuxdataout[loop];
		assign gpioport[loop]  = out_ena[loop] ? od_data[loop] : 1'bZ;
		assign data_from_gpio[loop]  = io_data_in[loop];
//		assign gpio_in_data[loop]  = gpioport[portselnum[loop]];

//		assign outmuxdata[loop] = outmuxdatain[loop] ? {IOWidth{1'b1}} : 0;
		
		always @ (posedge clk)
		begin
//			io_data_in[loop] <= gpioport[loop];
			io_data_in[loop] <= gpioport[portselnum[loop]];
////			out_data_reg[loop] <= out_data[loop];
////			outmuxdataout[loop] <= outmuxdata[portselnum[loop]];
			outmuxdataout[loop] <= out_data[portselnum[loop]];
		end
	end
endgenerate


//	reg  [IOWidth-1:0] io_data_in
//

endmodule
