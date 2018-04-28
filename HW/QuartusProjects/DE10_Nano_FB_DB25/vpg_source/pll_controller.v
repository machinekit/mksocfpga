module pll_controller (
	input							clk,
	input							reset_n,
	input				[3:0]		mode,
	input							mode_change,
	input				[31:0]	mgmt_readdata,
	output	reg				mgmt_read,
	output	reg				mgmt_write,
	output	reg	[5:0]		mgmt_address,
	output	reg	[31:0]	mgmt_writedata
);

`include "vpg.h"

//=======================================================
//  Signal declarations
//=======================================================
reg	[17:0]	m_counter, n_counter, c_counter;
reg	[1:0]		write_count;
reg	[2:0]		mode_change_d;
reg	[3:0]		state;

//=======================================================
//  Structural coding
//=======================================================
always@(posedge clk or negedge reset_n)
begin
	if (!reset_n)
	begin
		mode_change_d <= 3'b0;
		state <= 4'h0;
		write_count <= 2'b0;
		mgmt_read <= 1'b0;
		mgmt_write <= 1'b0;
	end
	else
	begin
 		mode_change_d <= {mode_change_d[1:0], mode_change}; 	
  	
	case (state)
		4'h0 : begin //idle		  	 
			if (!mode_change_d[2] && mode_change_d[1])
         begin
				state <=4'h1;
	         mgmt_address <= 6'h0; //polling mode
	         mgmt_writedata <= 32'h1;
         end 
			end
		4'h1 : begin //polling mode
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h2;
					mgmt_address <= 6'h4; //m_counter
					mgmt_writedata <= {14'h0, m_counter};
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h2 : begin //m_counter
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h3;
					mgmt_address <= 6'h3; //n_counter
					mgmt_writedata <= {14'h0, n_counter};
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h3 : begin //n_counter
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h4;
					mgmt_address <= 6'h5; //c_counter
					mgmt_writedata <= {14'h0, c_counter};
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h4 : begin //c_counter
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h5;
					mgmt_address <= 6'h8; //bandwidth
					mgmt_writedata <= 32'h6; //medium
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h5 : begin //bandwidth
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h6;
					mgmt_address <= 6'h9; //charge pump
					mgmt_writedata <= 32'h3; //medium
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h6 : begin //charge pump
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h7;
					mgmt_address <= 6'h2; //start reconfig
					mgmt_writedata <= 32'h1;
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h7 : begin //start reconfig
			if (write_count == 2'b0)
				mgmt_write <= 1'b1;
			else
				mgmt_write <= 1'b0;

				if (write_count[1])
				begin
					write_count <= 2'b0;
					state <=4'h8;
					mgmt_address <= 6'h1; //status check
				end
				else
					write_count <= write_count+2'b1;
			end	
		4'h8 : begin //status check
			if (mgmt_read && mgmt_readdata[0])
			begin
				mgmt_read <= 1'b0;
				state <=4'h0;
			end
			else
				mgmt_read <= 1'b1;
			end	
	endcase
	end	
end
  
always @(mode)
begin
	case (mode)
		`VGA_640x480p60: begin  // 50*1/(1*2)=25 MHZ
			 m_counter <= 18'h1_00_00; //bypass
			 n_counter <= 18'h1_00_00; //bypass 
			 c_counter <= 18'h0_01_01; //1+1=2
		end	
		`MODE_720x480: begin  // 50*54/(5*20)=27 MHZ
			 m_counter <= 18'h2_1B_1B; //27+27=54
			 n_counter <= 18'h2_03_02; //3+2=5
			 c_counter <= 18'h0_0A_0A; //10+10=20 
		end
		`MODE_1024x768: begin  // 50*13/(2*5)=65 MHZ
			 m_counter <= 18'h2_07_06; //7+6=13
			 n_counter <= 18'h0_01_01; //1+1=2
			 c_counter <= 18'h2_03_02; //3+2=5 
		end
		`MODE_1280x1024: begin  // 50*54/(5*5)=108 MHZ
			 m_counter <= 18'h0_1B_1B; //27+27=54
			 n_counter <= 18'h2_03_02; //3+2=5
			 c_counter <= 18'h2_03_02; //3+2=5 
		end	
		`FHD_1920x1080p60: begin  // 50*74/(5*5)=148 MHZ
			 m_counter <= 18'h0_25_25; //37+37=74
			 n_counter <= 18'h2_03_02; //3+2=5
			 c_counter <= 18'h2_03_02; //3+2=5 
		end		
		default: begin  // 50*81/(5*5)=162 MHZ
			 m_counter <= 18'h2_29_28; //41+40=81
			 n_counter <= 18'h2_03_02; //3+2=5
			 c_counter <= 18'h2_03_02; //3+2=5  
		end
	endcase
end

endmodule