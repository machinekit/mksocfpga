module hm2reg_io (
// signals to connect to an Avalon clock source interface
	input clk,
	input reset_n,
	// signals to connect to an Avalon-MM slave interface
	input [ADDRESS_WIDTH-1:0] slave_address,
	input slave_read,
	input slave_write,
	output reg [DATA_WIDTH-1:0] slave_readdata,
	input [DATA_WIDTH-1:0] slave_writedata,
	input slave_chipselect,
//	interrupt siganls
	output reg slave_irq,
// signals to connect to custom con logic
//	output waitrequest,
	output reg [DATA_WIDTH-1:0] con_dataout,
	input [DATA_WIDTH-1:0] con_datain,
	output reg [ADDRESS_WIDTH-1:0] con_adrout,
	output reg con_write_out,
	output reg con_read_out,
	output reg con_chip_sel,
	input con_int_in
);

parameter ADDRESS_WIDTH = 14;          // address size width
parameter DATA_WIDTH = 32;          // word size of each input and output register

parameter IRQ_EN = 1;				 // 0 = Enable interrupt, 1 = Disable interrupt


always @(posedge clk) begin
	if (!reset_n) begin
		slave_readdata[DATA_WIDTH-1:0] <= 0;
		slave_irq <= 0;
		con_dataout[DATA_WIDTH-1:0] <= 0;
		con_adrout[ADDRESS_WIDTH-1:0] <= 0;
		con_chip_sel <= 0;
		con_read_out <= 0;
		con_write_out <= 0;

	end
	else begin
		con_chip_sel <= slave_chipselect;
		con_read_out <= slave_read;
		con_write_out <= slave_write;
		con_adrout[ADDRESS_WIDTH-1:0] <= slave_address[ADDRESS_WIDTH-1:0];
		if (slave_read) begin
			slave_readdata[DATA_WIDTH-1:0] <= con_datain[DATA_WIDTH-1:0];
		end
		if	(slave_write) begin
			con_dataout <= slave_writedata;
		end
		if (IRQ_EN == 1) begin
			if (!con_int_in)
				slave_irq <= 1'b1;
			else if (slave_read)
				slave_irq <= 1'b0;
		end
	end
end

endmodule
