module led_blinker (
	input		wire		clk,
	input		wire		reset_n,
	output 	wire		LED
);

parameter COUNT_MAX = 24999999;

reg [25:0] counter;
reg  led_level;
always @	(posedge clk or negedge reset_n)
begin
	if(~reset_n)
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
