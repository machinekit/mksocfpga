
// Quartus Prime Verilog Template
// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

module capsense
(
	input	clk, reset,
	input [num-1:0] sense,
	input [3:0] hysteresis [num-1:0],
	output [11:0] calibval_0,
	output [11:0] counts_0,
	output reg charge,
	output reg [num-1:0] touched
);

	parameter num = 4;
	// Declare states
	parameter CHARGE = 1, DISCHARGE = 2;

// freqwuency in Mhz  , times in us
	parameter clockfrequency = 200;
	parameter periodtime = 5;

	parameter period_count = (clockfrequency * periodtime);

	reg [11:0] counter;
	reg [7:0] avg_cnt;
	reg [7:0] run_cal;
	reg [3:0] sense_reg[num];
	reg pinval[num];
	reg [15:0] avgsum[num];

	reg [11:0] calibval[num];
	reg [11:0] calibvalmin[num];
	reg [11:0] calibvalmax[num];
	reg [11:0] counts[num];
	reg [11:0] c_counts[num];
	reg [8:0] trigbar[num];
		
	// Declare state register
	reg		[1:0]state;

	wire [11:0] counts_slice[num];
	wire [11:0] avgsum_slice[num];
	wire [11:0] avgsum_slice_min[num];
	wire [11:0] avgsum_slice_max[num];

	wire [11:0] actual_count = period_count - counter;
	
	assign calibval_0 = calibval[0];
	assign counts_0 = counts[0];
	
	genvar ii;
	integer i1, i2, i3, i4, i5, i6, l1, l2, l3;
	generate for(ii = 0; ii < num; ii = ii + 1) begin: GEN_LOOP
		
		assign counts_slice[ii] = counts[ii][11:0];
		assign avgsum_slice[ii] = avgsum[ii][15:4];
		assign avgsum_slice_min[ii] = avgsum[ii][15:4] - 1;
		assign avgsum_slice_max[ii] = avgsum[ii][15:4] + hysteresis[ii];
	
		always @(posedge clk) begin
			sense_reg[ii][0] <= sense[ii];
			sense_reg[ii][1] <= sense_reg[ii][0];
			sense_reg[ii][2] <= sense_reg[ii][1];
			sense_reg[ii][3] <= sense_reg[ii][2];
			if (sense_reg[ii] == 4'hF) begin pinval[ii] <= 1'b1; end
			else if (sense_reg[ii] == 4'h0) begin pinval[ii] <= 1'b0; end
		end
	end

	always @(posedge charge or posedge reset) begin
		if (reset) begin
			avg_cnt <= 16;
			run_cal <= 8'hFF;
			for(i1 = 0; i1 < num; i1 = i1 + 1) begin: iGEN_LOOP1
				avgsum[i1] <= 0;
				calibval[i1] <= ~0;
				calibvalmin[i1] <= 0;
				calibvalmax[i1] <= ~0;
				touched[i1] <= 1'b0;
				trigbar[i1] <= 9'h00;
			end
		end
		else begin
			if (run_cal == 8'h00) begin
				if(avg_cnt == 0) begin
					avg_cnt <= 16;
					for(i2 = 0; i2 < num; i2 = i2 + 1) begin: iGEN_LOOP2
						avgsum[i2] <= 0;
						if (avgsum_slice[i2] > calibvalmax[i2] || avgsum_slice[i2] < calibvalmin[i2]) begin
							trigbar[i2] <= (trigbar[i2] << 1) | 9'h01;
						end else if (avgsum_slice[i2] <= calibval[i2] && avgsum_slice[i2] >= calibvalmin[i2]) begin
							trigbar[i2] <= trigbar[i2] >> 1;							
						end
						if (touched[i2] == 1'b0) begin
							touched[i2] <= trigbar[i2][6];
						end
						else begin
							touched[i2] <= trigbar[i2][2];						
						end
					end
				end
				else begin
					for(i3 = 0; i3 < num; i3 = i3 + 1) begin: iGEN_LOOP3
						avgsum[i3] <= avgsum[i3] + counts_slice[i3];
					end
					avg_cnt <= avg_cnt -1;
				end
			end
			else if (run_cal > 8'h00 && run_cal < 8'hFF )begin
				if(avg_cnt == 0) begin
					avg_cnt <= 16;
					for(i4 = 0; i4 < num; i4 = i4 + 1) begin: iGEN_LOOP4
						avgsum[i4] <= 0;
						if (avgsum_slice[i4] < calibval[i4]) begin
							calibval[i4] <= avgsum_slice[i4];
							calibvalmin[i4] <= avgsum_slice_min[i4];
							calibvalmax[i4] <= avgsum_slice_max[i4];
						end
					end
					run_cal <= run_cal - 8'h01;
				end
				else begin
					for(i5 = 0; i5 < num; i5 = i5 + 1) begin: iGEN_LOOP5
						avgsum[i5] <= avgsum[i5] + counts_slice[i5];
					end
					avg_cnt <= avg_cnt -1;
				end
			end
			else begin
				for(i6 = 0; i6 < num; i6 = i6 + 1) begin: iGEN_LOOP6
					calibval[i6] <= ~0;
					calibvalmin[i6] <= 0;
					calibvalmax[i6] <= ~0;
				end
				run_cal <= 8'hFE;
			end
		end
	end
	// Run charge discharge and measure cycle
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			for(l1 = 0; l1 < num; l1 = l1 + 1) begin: lGEN_LOOP1
				counts[l1] <= 0;	
				c_counts[l1] <= 0;
			end
			charge <= 1'b1;
			counter <= period_count;
			state <= CHARGE;
		end
		else
		begin
			case (state)
				CHARGE: // charge
				begin
					for(l2 = 0; l2 < num; l2 = l2 + 1) begin: lGEN_LOOP2
						if (!pinval[l2]) begin
							c_counts[l2] <= actual_count;
						end
					end
					if(counter == 0) begin
						counter <= period_count;
						charge <= 1'b0;
						state <= DISCHARGE;
					end
					else begin
						counter <= counter -1;
						charge <= 1'b1;
						state <= CHARGE;
					end
				end
				DISCHARGE: // discharge
				begin
					for(l3 = 0; l3 < num; l3 = l3 + 1) begin: lGEN_LOOP3
						if (pinval[l3]) begin
							counts[l3] <= c_counts[l3] + actual_count;
						end
					end
					if(counter == 0) begin
						counter <= period_count;
						charge <= 1'b1;
						state <= CHARGE;
					end
					else begin
						counter <= counter -1;
						charge <= 1'b0;
						state <= DISCHARGE;
					end
				end
				default:
				begin
					counter <= period_count;
					charge <= 1'b1;
					state <= CHARGE;
				end
			endcase
		end
	end
	endgenerate

endmodule
