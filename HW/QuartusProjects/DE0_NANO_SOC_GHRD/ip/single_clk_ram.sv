// create a RAM module, that quartus can work with easily
// see Recommended HDL Coding Styles
module single_clk_ram
#(parameter ADDW = 16,
            DATW = 32
)(
   input                      clk,
   output reg   [DATW-1:0]    q,
   input        [DATW-1:0]    d,
   input        [ADDW-1:0]    wr_addr,
   input        [ADDW-1:0]    rd_addr,
   input      [DATW/8-1:0]    we
   );
   localparam DEEP = 2**ADDW;
   integer j;
// create a memory composed of bytes/words
// addr byte3  byte2  byte1  byte0
// 0     fe     ed     be     ef
// 1     ca     fe     da     21
// mem[1] refers to the full word at address 1 - 32'h cafe_da21
// mem[0] [3] refers to byte 3 at address 0 - 8'h fe
   logic   [DATW/8-1:0] [7:0] mem [DEEP];
   logic   [7:0] writelane[DATW/8];
   generate
      genvar i;
      for (i=0; i<DATW/8; i++) begin: A
         assign writelane[i] = d[8*i+7:8*i];
      end
   endgenerate 

   always @ (posedge clk) begin
      q <= 32'h0;
      for (j=0; j<DATW/8; j=j+1)begin
         if (we[j])  mem [wr_addr] [j] <= writelane[j] ;
         q <= mem[rd_addr];
      end
   end
endmodule
