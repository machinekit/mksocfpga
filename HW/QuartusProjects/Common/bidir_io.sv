module bidir_io
#(parameter IOWidth=36, parameter PortNumWidth=8, parameter Mux_En = 1)
(
    input   [PortNumWidth-1:0]  portselnum  [IOWidth-1:0],
    input   clk,
    input   [IOWidth-1:0]   out_ena,
    input   [IOWidth-1:0]   od,
    input   [IOWidth-1:0]   out_data,
    inout   [IOWidth-1:0]   gpioport,
    output  [IOWidth-1:0]   data_from_gpio
);

reg  [IOWidth-1:0] io_data_in;
reg  [IOWidth-1:0] outmuxdataout;

wire [IOWidth-1:0] od_data;

genvar loop;
generate
    for(loop=0;loop<IOWidth;loop=loop+1) begin : iogenloop
        assign od_data[loop] = od[loop] ? (outmuxdataout[loop] ? 1'b0 : 1'bz) : outmuxdataout[loop];
        assign gpioport[loop]  = out_ena[loop] ? od_data[loop] : 1'bZ;
        assign data_from_gpio[loop]  = io_data_in[loop];

        always @ (posedge clk)
        begin
            if (Mux_En == 1) begin
                io_data_in[loop] <= gpioport[portselnum[loop]];
                outmuxdataout[loop] <= out_data[portselnum[loop]];
            end
            else begin
                io_data_in[loop] <= gpioport[loop];
                outmuxdataout[loop] <= out_data[loop];
            end
        end
    end
endgenerate

endmodule
