/*
//      adc addresses:
//      0x0200  for start and status
//      0x0204  for data

//
//      cap sensor address:
//      0x0300  1 bit pr sensor (Data read)
//      0x0304  Hysteresis sens 0-7 (4-bit pr sensor)
//
//      0x1000  I/O port  0..23
//      0x1004  I/O port 24..47
//      0x1008  I/O port 48..71
//      0x100C  I/O port 72..95
//      0x1010  I/O port 96..127
//      0x1014  I/O port 128..143

//      0x1100  DDR for I/O port  0..23
//      0x1104  DDR for I/O port  24..47
//      0x1108  DDR for I/O port  48..71
//      0x110C  DDR for I/O port  72..95
//      0x1110  DDR for I/O port  96..127
//      0x1114  DDR for I/O port  128..144
//      '1' bit in DDR register makes corresponding GPIO bit an output
//
//      0x1120  Portnums for I/O port  0..3
//      0x1124  Portnums for I/O port  4..7
//      0x1128  Portnums for I/O port  8..11
//      0x112C  Portnums for I/O port  12..15
//      0x1130  Portnums for I/O port  16..19
//      0x1134  Portnums for I/O port  20..23
//
//      0x1300  OpenDrainSelect for I/O port  0..23
//      0x1304  OpenDrainSelect for I/O port  24..47
//      0x1308  OpenDrainSelect for I/O port  48..71
//      0x130C  OpenDrainSelect for I/O port  72..95
//      0x1310  OpenDrainSelect for I/O port  96..127
//      0x1314  OpenDrainSelect for I/O port  128..143
//      '1' bit in OpenDrainSelect register makes corresponding GPIO an
//      open drain output.
//      If OpenDrain is selected for an I/O bit , the DDR register is ignored.
*/

module gpio_adr_decoder_reg(
    input                               CLOCK,
    input                               reg_clk,
    input                               reset_reg_N,
    input                               chip_sel,
    input                               write_reg,
    input                               read_reg,
    input   [AddrWidth-1:2]             busaddress,
    input   [BusWidth-1:0]              busdata_in,
    input   [MuxGPIOIOWidth-1:0]        iodatafromhm3[NumGPIO-1:0],
    input   [BusWidth-1:0]              busdata_fromhm2,
//
    inout   [GPIOWidth-1:0]             gpioport[NumGPIO-1:0],
//
    output  reg [MuxGPIOIOWidth-1:0]    iodatatohm3[NumGPIO-1:0],
    output  reg [BusWidth-1:0]          busdata_to_cpu,
// adc interface
    input                               adc_clk, // max 40mhz
    output                              ADC_CONVST_o,
    output                              ADC_SCK_o,
    output                              ADC_SDI_o,
    input                               ADC_SDO_i,
//	Touch sensor:
//    output  [11:0]                      calibval_0,
//    output  [13:0]                      counts_0,
    output  [NumSense-1:0]              touched,
    input   [1:0]                       buttons
);

parameter   AddrWidth       = 16;
parameter   BusWidth        = 32;
parameter   GPIOWidth       = 36;
parameter   MuxGPIOIOWidth  = 36;
parameter   NumIOAddrReg    = 6;
parameter   NumGPIO         = 2;

parameter   Capsense        = 1;
parameter   NumSense        = 4;
parameter   int Capsense_Pins[NumSense:0]   = '{40, 39, 38, 37, 36};
parameter   ADC             = "";
parameter   Mux_En          = 1;
// local param
parameter   IoRegWidth      = 24;
parameter   AdcOutShift     = 2;
parameter   ReadInShift     = 2;
parameter   WriteInShift    = 2;
parameter   PortNumWidth    = 8;
parameter   NumPinsPrIOAddr = 4;
parameter   Mux_regPrIOReg  = 6;
parameter   TotalNumregs    = Mux_regPrIOReg * NumIOAddrReg * NumPinsPrIOAddr;

    wire reset_in = ~reset_reg_N;
    wire [GPIOWidth-1:0] gpio_input_data[NumGPIO-1:0];


    reg [ReadInShift:0]         read_reg_r;
    reg [WriteInShift:0]        write_reg_r;
    reg [AddrWidth-1:0]         busaddress_r;
    reg [BusWidth-1:0]          busdata_in_r;
    reg [MuxGPIOIOWidth-1:0]    iodatafromhm3_r[NumGPIO-1:0];

    reg [AddrWidth-1:0]         local_address_r;

    reg [IoRegWidth-1:0]        io_reg[NumIOAddrReg-1:0];
    reg [IoRegWidth-1:0]        od_reg[NumIOAddrReg-1:0];
    reg [IoRegWidth-1:0]        ddr_reg[NumIOAddrReg-1:0];

    reg [BusWidth-1:0]          mux_reg[NumIOAddrReg-1:0][Mux_regPrIOReg-1:0];

    reg [PortNumWidth-1:0]      portselnum[TotalNumregs-1:0];


    wire [GPIOWidth-1:0]        io_reg_gpio[NumGPIO-1:0];
    wire [PortNumWidth-1:0]     mux_reg_index;
    wire [4:0]                  mux_reg_addr;
    wire [1:0]                  mux_reg_byte;

    wire [GPIOWidth-1:0]        out_ena[NumGPIO-1:0];
    wire [GPIOWidth-1:0]        od[NumGPIO-1:0];

    wire [PortNumWidth-1:0]		portnumsel[(GPIOWidth * NumGPIO)-1:0];

    wire read_address       = read_reg_r[ReadInShift];
    reg write_address;

//	wire io_address_valid = ((busaddress_r >= 16'h1000) && (busaddress_r < 16'h1020)) ? 1'b1 : 1'b0;
    wire ddr_address_valid  = ((busaddress_r >= 16'h1100) && (busaddress_r < 16'h1120)) ? 1'b1 : 1'b0;
    wire mux_address_valid  = ((busaddress_r >= 16'h1120) && (busaddress_r < 16'h1200)) ? 1'b1 : 1'b0;
    wire od_address_valid   = ((busaddress_r >= 16'h1300) && (busaddress_r < 16'h1320)) ? 1'b1 : 1'b0;

//	wire io_read_valid = (io_address_valid && read_address) ?  1'b1 : 1'b0;
//	wire ddr_read_valid = (ddr_address_valid && read_address) ?  1'b1 : 1'b0;
    wire mux_read_valid     = (mux_address_valid && read_address) ?  1'b1 : 1'b0;
//	wire od_read_valid = (od_address_valid && read_address) ?  1'b1 : 1'b0;

//	wire io_write_valid = (io_address_valid && write_address) ?  1'b1 : 1'b0;
//	wire ddr_write_valid = (ddr_address_valid && write_address) ?  1'b1 : 1'b0;
    wire mux_write_valid    = (mux_address_valid && write_address) ?  1'b1 : 1'b0;
//	wire od_write_valid = (od_address_valid && write_address) ?  1'b1 : 1'b0;

// ADC module:
    wire adc_address_valid  = ( (busaddress_r >= 16'h0200) && (busaddress_r <= 16'h0204)) ? 1'b1 : 1'b0;
    wire adc_read_valid     = (adc_address_valid && read_reg) ?  1'b1 : 1'b0;
    wire adc_write_valid    = (adc_address_valid && write_address) ?  1'b1 : 1'b0;
    wire [31:0]adc_data_out;

// Touch sensor:
    reg [BusWidth-1:0]  hysteresis_reg;
    reg [1:0]           sr_delay;
    reg reset_sr;
    reg [2:0]           sr_init_delay;
    reg reset_init_sr;
    wire [NumSense-1:0] sense;
    wire                charge;
    wire [3:0]          hysteresis[NumSense-1:0];

    wire sr_delay_act;
    wire sr_init_delay_act;
    wire sense_reset;
//	wire sense_reset = ~reset_reg_N;

    genvar sh;
    generate
        for(sh=0;sh<NumSense;sh=sh+1) begin : sense_hystloop
            assign hysteresis[sh] = hysteresis_reg[(4*sh)+:4];
        end
    endgenerate


    adc_ltc2308_fifo adc_ltc2308_fifo_inst
    (
        .clock(CLOCK) ,	// input  clock_sig
        .reset_n(reset_reg_N) ,	// input  reset_n_sig
        .addr(busaddress[2]) ,	// input  addr_sig
        .read_outdata(adc_read_valid) ,	// input  read_sig
        .write(adc_write_valid) ,	// input  write_sig
        .readdataout(adc_data_out) ,	// output [31:0] readdataout_sig
        .writedatain(busdata_in) ,	// input [31:0] writedatain_sig
    //ADC
        .adc_clk(adc_clk) ,	// input  adc_clk_sig
        .ADC_CONVST_o(ADC_CONVST_o) ,	// output  ADC_CONVST_o_sig
        .ADC_SCK_o(ADC_SCK_o) ,	// output  ADC_SCK_o_sig
        .ADC_SDI_o(ADC_SDI_o) ,	// output  ADC_SDI_o_sig
        .ADC_SDO_i(ADC_SDO_i) 	// input  ADC_SDO_i_sig
    );


// I/O stuff:

    always @(posedge reg_clk or posedge reset_in) begin
        if(reset_in) begin
            read_reg_r      <= 0;
            write_reg_r     <= 0;
            busaddress_r    <= 0;
            busdata_in_r    <= 0;
            iodatafromhm3_r <= '{NumGPIO{~0}};
        end else begin
            read_reg_r[ReadInShift:1]   <= read_reg_r[ReadInShift-1:0];
            read_reg_r[0]               <= read_reg;
            write_address               <= write_reg_r[WriteInShift-1];
            write_reg_r[WriteInShift:1] <= write_reg_r[WriteInShift-1:0];
            write_reg_r[0]              <= write_reg;
            busaddress_r                <= {{busaddress[AddrWidth-1:2]},{2'b0}};
            busdata_in_r                <= busdata_in;
            iodatafromhm3_r             <= iodatafromhm3;
            local_address_r             <= busaddress;
        end
    end

//	genvar numio, numgio;
    generate
        if (NumGPIO >= 1) begin
            assign io_reg_gpio[0] = {io_reg[1][11:0],io_reg[0][23:0]};
            assign out_ena[0] = {ddr_reg[1][11:0],ddr_reg[0][23:0]};
            assign od[0] = {od_reg[1][11:0],od_reg[0][23:0]};
        end
        if (NumGPIO >= 2) begin
            assign io_reg_gpio[1] = {io_reg[2][23:0],io_reg[1][23:12]};
            assign out_ena[1] = {ddr_reg[2][23:0],ddr_reg[1][23:12]};
            assign od[1] = {od_reg[2][23:0],od_reg[1][23:12]};
        end
        if (NumGPIO >= 3) begin
            assign io_reg_gpio[2] = {io_reg[4][11:0],io_reg[3][23:0]};
            assign out_ena[2] = {ddr_reg[4][11:0],ddr_reg[3][23:0]};
            assign od[2] = {od_reg[4][11:0],od_reg[3][23:0]};
        end
        if (NumGPIO == 4) begin
            assign io_reg_gpio[3] = {io_reg[5][23:0],io_reg[4][23:12]};
            assign out_ena[3] = {ddr_reg[5][23:0],ddr_reg[4][23:12]};
            assign od[3] = {od_reg[5][23:0],od_reg[4][23:12]};
        end

    endgenerate

    genvar ni,ps;
    generate for(ni=0;ni<NumIOAddrReg;ni=ni+1) begin : niinitloop
        for(ps=0;ps<Mux_regPrIOReg;ps=ps+1) begin : psinitloop
            always @(posedge reg_clk) begin
                portselnum[(ps*4)+((Mux_regPrIOReg*4)*ni)+0] <= mux_reg[ni][ps][0+:PortNumWidth];
                portselnum[(ps*4)+((Mux_regPrIOReg*4)*ni)+1] <= mux_reg[ni][ps][PortNumWidth+:PortNumWidth];
                portselnum[(ps*4)+((Mux_regPrIOReg*4)*ni)+2] <= mux_reg[ni][ps][(PortNumWidth*2)+:PortNumWidth];
                portselnum[(ps*4)+((Mux_regPrIOReg*4)*ni)+3] <= mux_reg[ni][ps][(PortNumWidth*3)+:PortNumWidth];
            end
        end
    end
    endgenerate

//  Send input I/O data to Hm3 core
    integer po;
    always @ (posedge reg_clk) begin
        for(po=0;po<NumGPIO;po=po+1) begin : pnloop
            iodatatohm3[po] <= gpio_input_data[po];
        end
    end

    assign portnumsel[(MuxGPIOIOWidth *NumGPIO)-1:0] = portselnum[(MuxGPIOIOWidth *NumGPIO)-1:0];

    assign mux_reg_index 	= busaddress_r - 16'h1120;
    assign mux_reg_addr		= (mux_reg_index[6:2]);
    assign mux_reg_byte		= (mux_reg_index[1:0]);

    generate if (Capsense >= 1) begin
        // Writes:
        always @( posedge reset_in or posedge write_address) begin
            if (reset_in) begin
                hysteresis_reg <= 32'h22222222;
                reset_sr <= 1'b0;
            end
            else if ( write_address ) begin
                if (busaddress_r == 10'h0304) begin
                    hysteresis_reg  <= busdata_in_r;
                    reset_sr <= 1'b1;
                end
                else begin
                    hysteresis_reg  <= hysteresis_reg;
                    reset_sr <= 1'b0;
                end
            end
        end
    end
    endgenerate

    always @(posedge reg_clk) begin
        sr_delay[0] <= reset_sr;
        sr_delay[1] <= sr_delay[0];
        sr_init_delay[0] <= reset_init_sr;
        sr_init_delay[1] <= sr_init_delay[0];
        sr_init_delay[2] <= sr_init_delay[1];
    end

    assign sr_delay_act = (sr_delay[1] == 1'b1 && sr_delay[0] == 1'b0)  ? 1'b1 : 1'b0;
    assign sr_init_delay_act = (sr_init_delay[2] == 1'b0 && sr_init_delay[0] == 1'b1) ? 1'b1 : 1'b0;
    assign sense_reset    = ~reset_reg_N | ~buttons[1] | sr_delay_act | sr_init_delay_act;

    genvar il;
    generate
        for(il=0;il<NumIOAddrReg;il=il+1) begin : reg_initloop
            always @( posedge reset_in or posedge write_address) begin
                if (reset_in) begin
                    io_reg[il] <= 0; ddr_reg[il] <= 0; od_reg[il] <= 0;
                end
                else if ( write_address ) begin
                    if (busaddress_r == (16'h1000 + (il*4))) begin io_reg[il] <= busdata_in_r[IoRegWidth-1:0]; end
                    else if (busaddress_r == (16'h1100 + (il*4))) begin ddr_reg[il] <= busdata_in_r[IoRegWidth-1:0]; end
                    else if (busaddress_r == (16'h1300 + (il*4))) begin od_reg[il] <= busdata_in_r[IoRegWidth-1:0]; end
                end
            end
        end
    endgenerate

    genvar mi, mo;
    generate
        for(mo=0;mo<NumIOAddrReg;mo=mo+1) begin : muxreg_oloop
            for(mi=0;mi<Mux_regPrIOReg;mi=mi+1) begin : muxreg_iloop
                always @( posedge reset_in or posedge write_address) begin
                    if (reset_in) begin
                        mux_reg[mo][mi] <= (((mo*24) + (mi*4)) + (((mo*24)+((mi*4)+1)) << PortNumWidth) +
                        (((mo*24)+((mi*4)+2)) << (PortNumWidth * 2)) + (((mo*24)+((mi*4)+3)) << (PortNumWidth * 3)));
                    end
                    else if ( write_address ) begin
                        if (busaddress_r == (16'h1120 + (mo*24) + (mi*4))) begin
                            mux_reg[mo][mi] <= busdata_in_r;
                        end
                    end
                end
            end
        end
    endgenerate

    wire [((GPIOWidth * NumGPIO)-1):0] gpio_out_data;
    genvar cl,ci0,ci1;
    generate
        if (Capsense >=1) begin
            for(cl=0;cl<(GPIOWidth * NumGPIO)-1;cl++) begin : capsenseloop
        //            .out_data({iodatafromhm3[1][GPIOWidth-1:5],4'bz,charge, iodatafromhm3[0]}) ,  // input [IOIOWidth-1:0] out_data_sig
                if(cl<=35) begin
                    if (Capsense_Pins[0] == cl) begin
                        assign gpio_out_data[cl] = charge;
                    end
                    else begin
                        for(ci0=1;ci0<NumSense+1;ci0++)begin : capsense0loop
                            if(Capsense_Pins[ci0] == cl) begin
                                assign gpio_out_data[cl] = 1'bz;
                            end
                            else begin
                                assign gpio_out_data[cl] = iodatafromhm3[0][cl];
                            end
                        end
                    end
                end
                else begin
                    if (Capsense_Pins[0] == cl) begin
                        assign gpio_out_data[cl] = charge;
                    end
                    else begin
                        for(ci1=1;ci1<NumSense+1;ci1++) begin : capsense1loop
                            if(Capsense_Pins[ci1] == cl) begin
                                assign gpio_out_data[cl] = 1'bz;
                            end
                            else begin
                                assign gpio_out_data[cl] = iodatafromhm3[1][cl-36];
                            end
                        end
                    end
                end
            end
            bidir_io #(.IOWidth(GPIOWidth * NumGPIO),.PortNumWidth(PortNumWidth),.Mux_En(Mux_En)) bidir_io_inst
            (
                .clk(reg_clk),
                .portselnum(portnumsel),
                .out_ena({out_ena[1],out_ena[0]}) ,	// input  out_ena_sig
                .od({od[1],od[0]}) ,	// input  od_sig
                .out_data(gpio_out_data) ,  // input [IOIOWidth-1:0] out_data_sig
                .gpioport({gpioport[1],gpioport[0]}) ,	// inout [IOIOWidth-1:0] gpioport_sig
                .data_from_gpio({gpio_input_data[1],gpio_input_data[0]}) 	// output [IOIOWidth-1:0] read_data_sig
            );
            end
        else begin
            bidir_io #(.IOWidth(GPIOWidth * NumGPIO),.PortNumWidth(PortNumWidth),.Mux_En(Mux_En)) bidir_io_inst
            (
                .clk(reg_clk),
                .portselnum(portnumsel),
                .out_ena({out_ena[1],out_ena[0]}) ,	// input  out_ena_sig
                .od({od[1],od[0]}) ,	// input  od_sig
                .out_data({iodatafromhm3[1], iodatafromhm3[0]}) ,  // input [IOIOWidth-1:0] out_data_sig
                .gpioport({gpioport[1],gpioport[0]}) ,	// inout [IOIOWidth-1:0] gpioport_sig
                .data_from_gpio({gpio_input_data[1],gpio_input_data[0]}) 	// output [IOIOWidth-1:0] read_data_sig
            );
        end
    endgenerate
    // Read:

    integer oo,om,oi;
    generate

    always @(posedge reset_in or posedge read_address)begin
        if (reset_in)begin
            busdata_to_cpu <= 32'b0;
            reset_init_sr <= 1'b0;
        end
        else if (read_address) begin
            if (Capsense >= 1) begin
                if (adc_address_valid) begin busdata_to_cpu <= adc_data_out;	end
                else if (busaddress_r == 'h0300) begin busdata_to_cpu <= touched; reset_init_sr <= 1'b1;	end
                else if (busaddress_r == 'h0304) begin busdata_to_cpu <= hysteresis_reg;	end
                else if(busaddress_r == 'h1000) begin busdata_to_cpu <= {8'b0,gpio_input_data[0][23:0]}; end
                else if(busaddress_r == 'h1004) begin busdata_to_cpu <= {8'b0,gpio_input_data[1][11:0],gpio_input_data[0][35:24]}; end
                else if(busaddress_r == 'h1008) begin busdata_to_cpu <= {8'b0,gpio_input_data[1][35:12]}; end
//			    else if(busaddress_r == 'h100c) begin busdata_to_cpu <= {8'b0,gpio_input_data[2][23:0]}; end
//			    else if(busaddress_r == 'h1010) begin busdata_to_cpu <= {8'b0,gpio_input_data[3][11:0],gpio_input_data[2][35:24]}; end
//			    else if(busaddress_r == 'h1014) begin busdata_to_cpu <= {8'b0,gpio_input_data[3][35:12]}; end
//			    else if ((busaddress_r >= 16'h1100) && (busaddress_r < 16'h1200)) begin
                else if (ddr_address_valid || od_address_valid) begin
                    for(oo=0;oo<NumIOAddrReg;oo=oo+1) begin : reggen_loop
                        if (busaddress_r == ('h1100 + (oo*4))) begin busdata_to_cpu <= ddr_reg[oo]; end
                        else if (busaddress_r == ('h1300 + (oo*4))) begin busdata_to_cpu <= od_reg[oo]; end
                    end
                end
                else if (mux_address_valid) begin
                    for(om=0;om<NumIOAddrReg;om=om+1) begin : mux_reggen_loop
                        for(oi=0;oi<Mux_regPrIOReg;oi=oi+1) begin : mux_reggen_loop
                            if (busaddress_r == ('h1120 + (om*24) + (oi*4))) begin busdata_to_cpu <= mux_reg[om][oi]; end
                        end
                    end
                end
                else begin busdata_to_cpu <= busdata_fromhm2; end
            end else begin
                if (adc_address_valid) begin busdata_to_cpu <= adc_data_out;	end
//			      else if (busaddress_r == 'h0300) begin busdata_to_cpu <= touched; reset_init_sr <= 1'b1;	end
//                else if (busaddress_r == 'h0304) begin busdata_to_cpu <= hysteresis_reg;	end
                else if(busaddress_r == 'h1000) begin busdata_to_cpu <= {8'b0,gpio_input_data[0][23:0]}; end
                else if(busaddress_r == 'h1004) begin busdata_to_cpu <= {8'b0,gpio_input_data[1][11:0],gpio_input_data[0][35:24]}; end
                else if(busaddress_r == 'h1008) begin busdata_to_cpu <= {8'b0,gpio_input_data[1][35:12]}; end
//			    else if(busaddress_r == 'h100c) begin busdata_to_cpu <= {8'b0,gpio_input_data[2][23:0]}; end
//			    else if(busaddress_r == 'h1010) begin busdata_to_cpu <= {8'b0,gpio_input_data[3][11:0],gpio_input_data[2][35:24]}; end
//			    else if(busaddress_r == 'h1014) begin busdata_to_cpu <= {8'b0,gpio_input_data[3][35:12]}; end
//			    else if ((busaddress_r >= 16'h1100) && (busaddress_r < 16'h1200)) begin
                else if (ddr_address_valid || od_address_valid) begin
                    for(oo=0;oo<NumIOAddrReg;oo=oo+1) begin : reggen_loop
                        if (busaddress_r == ('h1100 + (oo*4))) begin busdata_to_cpu <= ddr_reg[oo]; end
                        else if (busaddress_r == ('h1300 + (oo*4))) begin busdata_to_cpu <= od_reg[oo]; end
                    end
                end
                else if (mux_address_valid) begin
                    for(om=0;om<NumIOAddrReg;om=om+1) begin : mux_reggen_loop
                        for(oi=0;oi<Mux_regPrIOReg;oi=oi+1) begin : mux_reggen_loop
                            if (busaddress_r == ('h1120 + (om*24) + (oi*4))) begin busdata_to_cpu <= mux_reg[om][oi]; end
                        end
                    end
                end
                else begin busdata_to_cpu <= busdata_fromhm2; end
            end
        end
    end
    endgenerate

    generate if (Capsense >=1) begin
        assign sense = gpio_input_data[1][5:1];

                capsense capsense_inst
            (
                .clk(reg_clk) ,	// input  clk_sig
                .reset(sense_reset) ,	// input  reset_sig
                .sense(sense) ,	// input [num-1:0] sense_sig
                .hysteresis(hysteresis),
    //            .calibval_0(calibval_0),
    //            .counts_0(counts_0),
                .charge(charge) ,	// output  charge_sig
                .touched(touched) 	// input [num-1:0] touched_sig
            );

            defparam capsense_inst.num = NumSense;
            // States
            defparam capsense_inst.CHARGE = 1;
            defparam capsense_inst.DISCHARGE = 2;
            // freqwuency in Mhz  , times in us
            defparam capsense_inst.clockfrequency = 200;
            defparam capsense_inst.periodtime = 5;
        end
    endgenerate

endmodule

