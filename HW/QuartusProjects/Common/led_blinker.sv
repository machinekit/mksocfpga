module led_blinker (
	input		wire		fpga_clk_50,
	input		wire		hps_fpga_reset_n,
	output 	wire		LED
);

parameter COUNT_MAX = 24999999;

reg [25:0] counter;
reg  led_level;
always @	(posedge fpga_clk_50 or negedge hps_fpga_reset_n)
begin
	if(~hps_fpga_reset_n)
	begin
		counter<=0;
		led_level<=0;
end

else if(counter==COUNT_MAX)
	begin
		counter<=0;
		led_level<=~led_level;
	end
else
		counter<=counter+1'b1;
end

assign LED=led_level;

endmodule
