/* note for avalon interface
    bus type: nagtive
    read legacy = 0 (to consistent to FIFO)

*/

module adc_ltc2308_fifo(
    // avalon slave port
    input   clock,
    input   reset_n,
    input   addr,
//    input   read,
    input   read_outdata,
    input   write,
    output  reg [31:0]  readdataout,
    input       [31:0]  writedatain,

    input   adc_clk, // max 40mhz
    // adc interface
    output  ADC_CONVST_o,
    output  ADC_SCK_o,
    output  ADC_SDI_o,
    input   ADC_SDO_i
);


////////////////////////////////////
// avalon slave port
`define WRITE_REG_START_CH				0
`define WRITE_REG_MEASURE_NUM			1

// write for control
reg             measure_fifo_start;
reg [11:0]      measure_fifo_num;
reg [2:0]       measure_fifo_ch;
reg	            auto_ch_select;
// FIFO
wire fifo_wrfull;
wire fifo_rdempty;
wire  fifo_wrreq;
wire [11:0]	 fifo_q;
//wire fifo_rdreq;
wire [2:0] fifo_ch_q;

always @ ( negedge reset_n or posedge write)
begin
    if (!reset_n)
        measure_fifo_start <= 1'b0;
    else if (write) begin
        if (addr == `WRITE_REG_START_CH) begin
            measure_fifo_start   <= writedatain[0];
            measure_fifo_ch		<= writedatain[6:4];
            auto_ch_select			<= writedatain[8];
        end
        else if (write  && addr == `WRITE_REG_MEASURE_NUM) begin
            {measure_fifo_num} <= writedatain[11:0];
        end
    end
end

///////////////////////
// read
`define READ_REG_MEASURE_DONE   0
`define READ_REG_ADC_VALUE      1
wire slave_read_status;
wire slave_read_data;

assign slave_read_status = (addr == `READ_REG_MEASURE_DONE) ? 1'b1:1'b0;
assign slave_read_data = (addr == `READ_REG_ADC_VALUE)      ? 1'b1:1'b0;

reg measure_fifo_done;
always @ (posedge read_outdata)
begin
    if (slave_read_status)
        readdataout <= {4'b0, measure_fifo_num, 9'b0, measure_fifo_ch, 3'b0, measure_fifo_done};
    else if (slave_read_data)
        readdataout <= {13'b0, fifo_ch_q, 4'b0, fifo_q};
end

//reg [1:0] post_read_outdata;
reg post_read_outdata;
reg fifo_rdreq;
always @ (posedge clock or negedge reset_n)
begin
    if (!reset_n) begin
        post_read_outdata <= 1'b0;
        fifo_rdreq <= 1'b0;
    end
    else begin
        post_read_outdata <= read_outdata;
        fifo_rdreq <= ((post_read_outdata == 1'b1) && (read_outdata == 1'b0)) ? 1'b1:1'b0;
//        post_read_outdata[1] <= post_read_outdata[0];
    end
end

// read ack for adc data. (note. Slave_read_data is read lency=2, so slave_read_data is assert two clock)
//assign fifo_rdreq = ((post_read_outdata == 1'b1) && (read_outdata == 1'b0)) ? 1'b1:1'b0;
//assign fifo_rdreq = 1'b0;

////////////////////////////////////
// create triggle message: adc_reset

reg pre_measure_fifo_start;
always @ (posedge adc_clk)
begin
    pre_measure_fifo_start <= measure_fifo_start;
//	pre_measure_fifo_start[1] <= pre_measure_fifo_start[0];
end

wire adc_reset ;
assign adc_reset  = (!pre_measure_fifo_start & measure_fifo_start)?1'b1:1'b0;

////////////////////////////////////
// control measure_start
reg [11:0] measure_count;

reg config_first;
reg wait_measure_done;
reg measure_start;
wire measure_done;
wire [11:0] measure_dataread;

// auto channel change
//wire [2:0] adc_ch_sel = (auto_ch_select) ? 3'h7:measure_fifo_ch;
reg [2:0] adc_ch;
reg [2:0] adc_ch_dly;

always @ (posedge adc_clk or posedge adc_reset )
begin
    if (adc_reset)
    begin
        measure_start <= 1'b0;
        config_first <= 1'b1;
        measure_count <= 0;
        measure_fifo_done <= 1'b0;
        wait_measure_done <= 1'b0;
        adc_ch <= 0;
        adc_ch_dly <= 0;
    end
    else if (!measure_fifo_done & !measure_start & !wait_measure_done)
    begin
        measure_start <= 1'b1;
        wait_measure_done <= 1'b1;
    end
    else if (wait_measure_done) // && measure_start)
    begin
        measure_start <= 1'b0;
        if (measure_done)
        begin
            if (config_first)
                config_first <= 1'b0;
            else
            begin	// read data and save into fifo
                if (measure_count < measure_fifo_num) // && !fifo_wrfull)
                begin
                    measure_count <= measure_count + 1;
                    wait_measure_done <= 1'b0;
                if (pre_measure_fifo_start)
                    if (auto_ch_select)
                    begin
                        adc_ch <= ((adc_ch + 1) & 3'h7);
                        adc_ch_dly <= adc_ch;
                    end
                    else
                    begin
                        adc_ch <= measure_fifo_ch;
                        adc_ch_dly <= adc_ch;
                    end
                end
                else
                begin
                    measure_fifo_done <= 1'b1;
                end
            end
        end
    end
end

// write data into fifo

reg pre_measure_done;

always @ (posedge adc_clk or posedge adc_reset )
begin
    if (adc_reset)
        pre_measure_done <= 1'b0;
    else
        pre_measure_done <= measure_done;
end

assign fifo_wrreq = (!pre_measure_done & measure_done & !config_first)?1'b1:1'b0;

///////////////////////////////////////
// SPI

adc_ltc2308 adc_ltc2308_inst(
    .clk(adc_clk), // max 40mhz

    // start measure
    .measure_start(measure_start), // posedge triggle
    .measure_done(measure_done),
    .measure_ch(adc_ch),
    .measure_dataread(measure_dataread),


    // adc interface
    .ADC_CONVST(ADC_CONVST_o),
    .ADC_SCK(ADC_SCK_o),
    .ADC_SDI(ADC_SDI_o),
    .ADC_SDO(ADC_SDO_i)
);


///////////////////////////////////////

adc_data_fifo adc_data_fifo_inst(
    .aclr(adc_reset),
    .data({adc_ch_dly, measure_dataread}),
//    .rdclk(read_outdata),
    .rdclk(clock),
    .rdreq(fifo_rdreq),
    .wrclk(adc_clk),
    .wrreq(fifo_wrreq),
    .q({fifo_ch_q, fifo_q}),
    .rdempty(fifo_rdempty),
    .wrfull(fifo_wrfull)
);


endmodule
