`timescale  1ns/1ns
module tb_mem ();

parameter TB_ID_W           = 4;
parameter TB_AXI_ADDRESS_W  = 12;
parameter TB_AXI_SYMBOL_W   = 8;
parameter TB_AXI_NUMSYMBOLS = 4;
parameter TB_AV_ADDRESS_W   = 2;
parameter TB_AV_DATA_W      = 16;
parameter TB_AV_NUMBYTES    = 2;
parameter TB_ESO            = 1'b1;


localparam TB_AXI_DW = TB_AXI_SYMBOL_W * TB_AXI_NUMSYMBOLS;

`define BASEADD {TB_AXI_ADDRESS_W{1'b0}}
`define CTRL_START_ADD {{(TB_AXI_ADDRESS_W-2){1'b1}}, 2'b00}
`define CTRL_STOP_ADD  {{(TB_AXI_ADDRESS_W-2){1'b1}}, 2'b01}
`define STRM_CTRL_ADD  {{(TB_AXI_ADDRESS_W-2){1'b1}}, 2'b10}

import verbosity_pkg::*;

reg           clk, rstn;
string        com; //comments for simulation waveform display
reg   [TB_ID_W-1:0]           awid;
reg   [TB_AXI_ADDRESS_W-1:0]  awaddr;
reg   [ 3:0]  awlen;
reg   [ 2:0]  awsize;
reg   [ 1:0]  awburst;
reg   [ 1:0]  awlock;
reg   [ 3:0]  awcache;
reg   [ 2:0]  awprot;
reg           awvalid;
wire          awready;

reg   [TB_ID_W-1:0]  wid;
reg   [31:0]  wdata;
reg   [ 3:0]  wstrb;
reg           wlast;
reg           wvalid;
wire          wready;

reg           bready;
wire  [TB_ID_W-1:0]  bid;
wire  [ 1:0]  bresp;
wire          bvalid;

reg   [TB_ID_W-1:0]           arid;
reg   [TB_AXI_ADDRESS_W-1:0]  araddr;
reg   [ 3:0]  arlen;
reg   [ 2:0]  arsize;
reg   [ 1:0]  arburst;
reg   [ 1:0]  arlock;
reg   [ 3:0]  arcache;
reg   [ 2:0]  arprot;
reg           arvalid;
wire          arready;

reg           st_ready;
wire          st_valid;
wire [ 7:0]   st_data;


wire  [TB_ID_W-1:0]  rid;
wire  [31:0]  rdata, xrdata;
wire  [ 1:0]  rresp;
wire          rlast;
wire          rvalid;
reg           rready;

reg           write, read;
wire          waitreq, readval;
reg   [TB_AXI_ADDRESS_W-1:0]  address;
reg   [ 3:0]  byten;
reg   [ 3:0]  rdydelay, rdycnt;
integer       i;

reg                         av_write;
reg                         av_read;
reg  [TB_AV_ADDRESS_W-1:0]  av_addr;
reg  [TB_AV_NUMBYTES-1:0]   av_byten;
reg  [TB_AV_DATA_W-1:0]     av_wdata;
wire                        av_waitreq;
wire [TB_AV_DATA_W-1:0]     av_readdata;

demo_axi_memory 
   #(.AXI_ID_W       (TB_ID_W),
     .AXI_ADDRESS_W  (TB_AXI_ADDRESS_W),
     .AXI_DATA_W     (TB_AXI_DW),
     .AXI_NUMBYTES   (TB_AXI_NUMSYMBOLS),
     .AV_ADDRESS_W   (TB_AV_ADDRESS_W),
     .AV_DATA_W      (TB_AV_DATA_W),
     .AV_NUMBYTES    (TB_AV_NUMBYTES),
     .ENABLE_STREAM_OUTPUT (TB_ESO)
   ) dut(
     .clk              (clk),  
     .reset_n           (rstn),

     //AXI write address bus
	  .axs_awid              (awid),
	  .axs_awaddr            (awaddr),
	  .axs_awlen             (awlen),
	  .axs_awsize            (awsize),
	  .axs_awburst           (awburst),
	  .axs_awlock            (awlock),
	  .axs_awcache           (awcache),
	  .axs_awprot            (awprot),
	  .axs_awvalid           (awvalid),
	  .axs_awready           (awready),

	  .axs_wid               (wid),
	  .axs_wdata             (wdata),
	  .axs_wstrb             (wstrb),
	  .axs_wlast             (wlast),
	  .axs_wvalid            (wvalid),
	  .axs_wready            (wready),

	  .axs_bid               (bid),
	  .axs_bresp             (bresp),
	  .axs_bvalid            (bvalid),
	  .axs_bready            (bready),
	
	  .axs_arid              (arid),
	  .axs_araddr            (araddr),
	  .axs_arlen             (arlen),
	  .axs_arsize            (arsize),
	  .axs_arburst           (arburst),
	  .axs_arlock            (arlock),
	  .axs_arcache           (arcache),
	  .axs_arprot            (arprot),
	  .axs_arvalid           (arvalid),
	  .axs_arready           (arready),

	  .axs_rid               (rid),
	  .axs_rdata             (xrdata),
	  .axs_rresp             (rresp),
	  .axs_rlast             (rlast),
	  .axs_rvalid            (rvalid),
	  .axs_rready            (rready),

 	  .avs_write             (av_write),
 	  .avs_read              (av_read),
 	  .avs_waitrequest       (av_waitreq),
 	  .avs_address           (av_addr),
 	  .avs_byteenable        (av_byten),
 	  .avs_writedata         (av_wdata),
 	  .avs_readdata          (av_readdata),

	  .aso_valid             (st_valid),
	  .aso_data              (st_data),
	  .aso_ready             (st_ready)
   );
task xw_addr;
   input  [TB_ID_W-1:0] id;
   input  [TB_AXI_ADDRESS_W-1:0] addr;
   input  [ 3:0] alen;
   input  [ 2:0] asiz;
   begin
      @(posedge clk)
         awid     = id;
         awaddr   = addr;
         awlen    = alen;
         awsize   = asiz;
         awburst  = 2'h1; //incrementing address burst
         awlock   = 2'h0; //normal access
         awcache  = 4'h0; 
         awprot   = 3'h2; //normal, non-secure data access
         awvalid  = 1'b1;
      wait (awready);
      @(posedge clk) awvalid = 1'b0;
   end
endtask

task xw_data;
   input  [TB_ID_W-1:0] twid;
   input  [32:0] twdata;
   input  [ 3:0] twstrb;
   input         twlast;
   begin
      @(posedge clk)
         wid    = twid;
         wdata  = twdata;
         wstrb  = twstrb;
         wlast  = twlast;
         wvalid = 1'b1;
      #1 wait (wready);
      @(posedge clk) 
         wvalid = 1'b0;
         wlast  = 1'b0;
   end
endtask         

task xw_burst;
   input  [TB_ID_W-1:0] twid;
   input  [31:0] twdata;
   input  [ 3:0] twstrb;
   input  [ 3:0] twlen;
   input  [31:0] addend;
   begin: burstwrite
      reg [4:0] brstcnt;
      reg [3:0] localstrobes;
      reg [1:0] shiftval;
      case (twstrb)
         4'h1, 4'h2, 4'h4, 4'h8 : shiftval = 2'h1;
         4'h3, 4'hc             : shiftval = 2'h2;
         4'hf                   : shiftval = 2'h0;
         default                : $display("illegal strobe config");
      endcase
      localstrobes = twstrb;
      brstcnt = twlen + 1'b1;
      for (i=0; i<brstcnt; i=i+1) begin
      @(posedge clk)
      #1        //ugly, but it works...
         wid       = twid;
         wdata     = twdata + addend*i;
         wstrb     = localstrobes;
         wlast     = (i==brstcnt-1'b1);
         wvalid    = 1'b1;
         wait (wready);
         case (shiftval)
            2'h1: localstrobes = {localstrobes[2:0], localstrobes[3]};
            2'h2: localstrobes = {localstrobes[1:0], localstrobes[3:2]}; 
            default : localstrobes = localstrobes;
         endcase
      end
      @(posedge clk) 
         wvalid = 1'b0;
         wlast  = 1'b0;
   end
endtask 

//start with write of 1, 2, or 3 bytes, then continue with
//full word writes
task more_burst; 
   input  [TB_ID_W-1:0] twid;
   input  [31:0] twdata;
   input  [ 3:0] twstrb;
   input  [ 3:0] twlen;
   input  [31:0] addend;
   begin: burstwrite
      reg [4:0] brstcnt;
      reg [3:0] localstrobes;
      localstrobes = twstrb;
      brstcnt = twlen + 1'b1;

//first write of burst, strobes = 1000, 1100, 1110
      @(posedge clk) 
      #1        //ugly, but it works...
         wid       = twid;
         wdata     = twdata;
         wstrb     = twstrb;
         wlast     = (brstcnt==1);
         wvalid    = 1'b1;
         wait (wready);

//succeeding writes with strobes = 1111
      for (i=1; i<brstcnt; i=i+1) begin
      @(posedge clk)
      #1        //ugly, but it works...
         wid       = twid;
         wdata     = twdata + addend*i;
         wstrb     = 4'hf;
         wlast     = (i==brstcnt-1'b1);
         wvalid    = 1'b1;
         wait (wready);
      end
      @(posedge clk) 
         wvalid = 1'b0;
         wlast  = 1'b0;
   end
endtask

task xr_addr;
   input  [TB_ID_W-1:0] id;
   input  [TB_AXI_ADDRESS_W-1:0] addr;
   input  [ 3:0] alen;
   input  [ 2:0] asiz;
   begin
      @(posedge clk)
         arid     = id;
         araddr   = addr;
         arlen    = alen;
         arsize   = asiz;
         arburst  = 2'h1; //incrementing address burst
         arlock   = 2'h0; //normal access
         arcache  = 4'h0; 
         arprot   = 3'h2; //normal, non-secure data access
         arvalid  = 1'b1;
      wait (arready);
      @(posedge clk) arvalid = 1'b0;
   end
endtask

task av_wrtsk;
   input  [ 1:0] twaddr;
   input  [15:0] twdata;
   begin
      @(posedge clk)
         av_read   = 1'b0;
         av_write  = 1'b1;
         av_addr   = twaddr;
         av_wdata  = twdata;
         av_byten  = 2'h3;
      #1 wait (!av_waitreq);
      @(posedge clk) 
         av_write  = 1'b0;
         av_addr   = 2'h0;
         av_wdata  = 0;
         av_byten  = 2'h0;
   end
endtask         

task av_rdtsk;
   input  [ 1:0] traddr;
   begin
      @(posedge clk)
         av_read   = 1'b1;
         av_write  = 1'b0;
         av_addr   = traddr;
         av_byten  = 2'h3;
      @(posedge clk) 
         av_addr   = 2'h0;
         av_read   = 1'b0;
         av_byten  = 2'h0;
   end
endtask       

reg  [2:0]  dcnt;
reg  [2:0]  cval;
reg         always_rready;
always @ (posedge clk or negedge rstn) begin
   if (~rstn) rready = 1'b0;
   else if (rvalid && (~rready || (cval == 2'h0))) begin
      if (dcnt > 2'h0) dcnt <= dcnt - 1'b1;
      else rready = 1'b1;
   end
   else begin
      rready = always_rready;
      dcnt   = cval;
   end
end

   
always @(posedge clk or negedge rstn) begin
   if (~rstn)                 bready <= 1'b0;
   else if (bvalid & ~bready) bready <= 1'b1;
   else                       bready <= 1'b0;
end
      
always @(posedge clk or negedge rstn) begin
   if (~rstn)begin
      st_ready <= 1'b0;
      rdycnt   <= 4'h0;
   end
   else if (st_valid) begin
      if (rdycnt>0) begin
         rdycnt   <= rdycnt - 1'b1;
         st_ready <= 1'b0;
      end
      else begin
         rdycnt     <= rdydelay;
         st_ready   <= 1'b1;
      end
   end
   else begin
      st_ready    <= 1'b1;
      rdycnt      <= rdydelay;
   end
end
      




initial begin
   clk    = 1'b0;
   rstn   = 1'b0;
   #20 forever  clk = #5 ~clk;
end
initial begin
   set_verbosity(VERBOSITY_DEBUG); // set console verbosity level
   cval       =  2'h0;
   address    = 32'h0;
   byten      =  4'h0;
   read       =  1'h0;
   write      =  1'h0;
   wdata      = 32'h0;

   //axi waddr bus
   awid       =  {TB_ID_W{1'b0}};
   awaddr     =  {TB_AXI_ADDRESS_W{1'b0}};
   awlen      =  4'h0;
   awsize     =  3'h0;
   awburst    =  2'h0; 
   awlock     =  2'h0; 
   awcache    =  4'h0; 
   awprot     =  3'h0;
   awvalid    =  1'b0;

   //axi wdata bus
   wid        = {TB_ID_W{1'b0}};
   wdata      = 32'h0;
   wstrb      = 4'h0;
   wlast      = 1'b0;
   wvalid     = 1'b0;

   //axi raddr bus
   arid       =  {TB_ID_W{1'b0}};
   araddr     =  {TB_AXI_ADDRESS_W{1'b0}};
   arlen      =  4'h0;
   arsize     =  3'h0;
   arburst    =  2'h0; 
   arlock     =  2'h0; 
   arcache    =  4'h0; 
   arprot     =  3'h0;
   arvalid    =  1'b0;
   always_rready = 1'b0;

   //axi rdata bus
   rready     =  1'b0;

   st_ready   =  1'b0;
   rdydelay   =  4'h0;

   // av control bus
   av_write      =  1'b0;
   av_read       =  1'b0;
   av_addr       =  2'h0;
   av_byten      =  2'h3;
   av_wdata      =  0;


   #40  rstn  =  1'b1;
   //try a fast burst write of 8
   #40  com = "bw8";
        xw_addr(4'h3, `BASEADD + 8'h0, 4'h7, 3'h2);
        xw_burst(4'h3, 32'hbaad_0000, 4'hf, 4'h7, 8'h1);

   // do a single write to addr 53 (83 dec)
   //   xw_addr(aid[3:0], addr[11:0], alen[3:0], asiz[2:0]) 
   #40  com = "sw";
   //   xw_addr(aid[3:0], addr[11:0], alen[3:0], asiz[2:0]) 
        xw_addr(4'h1,  `BASEADD + 8'h53,     4'h0,      3'h2);
   //   xw_data(twid[3:0], twdata[31:0], twstrb[3:0], twlast)
        xw_data(4'h1,     32'hbabe_0007,   4'hf,       1'b1);

        com = "wd";
   //   do a xw_data for which no valid address is stored
        xw_data(4'h7, 32'hbabe_1394, 4'hf, 1'b1);
   //   then follow up with the address
   #40  com = "wa";
        xw_addr( 4'h7, `BASEADD + 12'h50, 4'h0, 3'h2);

   //try a slow burst write of 4
   #40  com = "slobw4";  
        xw_addr(4'h3, `BASEADD + 12'h40, 4'h3, 3'h2);
   //   xw_data(twid[3:0], twdata[31:0], twstrb[3:0], twlast)
        xw_data(4'h3, 32'h1cee_0000, 4'hf, 1'b0);
        xw_data(4'h3, 32'h1cee_0001, 4'hf, 1'b0);
        xw_data(4'h3, 32'h1cee_0002, 4'hf, 1'b0);
        xw_data(4'h3, 32'h1cee_0003, 4'hf, 1'b1);

   //try a fast burst write of 16
   #40  com = "bw16";  
        xw_addr(4'h3, `BASEADD + 12'h100, 4'hf, 3'h2);
        xw_burst(4'h3, 32'hbabe_9900, 4'hf, 4'hf, 8'h11);

   //try a fast burst write of 4
   #100  com = "bw4"; 
        xw_addr(4'h7, `BASEADD + 12'h30, 4'h3, 3'h2);
        xw_burst(4'h7, 32'h1c0d_0000, 4'hf, 4'h3, 8'h08);

   //   xr_addr(aid[3:0], addr[11:0], alen[3:0], asiz[2:0])
   //   single read
   #50  com = "sr"; 
        xr_addr(4'h2,     `BASEADD + 12'h30,     4'h0,       3'h2);

   //   burst read of 5
   #50  com = "br5"; 
        xr_addr(4'h3,     `BASEADD + 12'h00,     4'h4,       3'h2);
   //   burst read of 4
   #10  com = "br4"; 
        xr_addr(4'h9,     `BASEADD + 12'h30,     4'h3,       3'h2);

   #100 always_rready = 1'b1;
   //   burst read of 5 with rready always asserted
   #50  com = "br5_ar"; 
        xr_addr(4'h3,     `BASEADD + 12'h00,     4'h4,       3'h2);
   #100 always_rready = 1'b0;

   //   burst read of 4
   #10  com = "br4"; 
        xr_addr(4'h9,     `BASEADD + 12'h30,     4'h3,       3'h2);

   #200 cval = 2'h1; //slowish burst read (delay rready)
        com = "slobr4"; 
        xr_addr(4'h9,     `BASEADD + 12'h30,     4'h3,       3'h2);
   #100

   //   command registers
        com = "avwr"; 
        av_wrtsk(2'h0, 16'h010a);

   #40  av_wrtsk(2'h1, 16'h010f);

   #40  av_wrtsk(2'h2, 16'h0001);

   //   xr_addr(aid[3:0], addr[11:0], alen[3:0], asiz[2:0])
   //   single reads 
   #100 com = "avrd"; 
        av_rdtsk(2'h0);
        av_rdtsk(2'h1);
        av_rdtsk(2'h2);

//   burst read of 16 
        cval = 2'h0; //fast rready
   #100 com = "br16"; 
        xr_addr(4'h3,     `BASEADD + 12'h100,     4'hf,       3'h2);

//try a narrow burst write of 8
   #200  com = "bnw8_2";
        xw_addr(4'h3, `BASEADD + 8'h8, 4'h7, 3'h2);
        xw_burst(4'h3, 32'h1111_1111, 4'h1, 4'h7, 32'h4321_1111);

//try a burst, 1st transfer only 3 bytes, 4 on last 3 xfers
   #200  com = "mbw4_3";
        xw_addr(4'h3, `BASEADD + 8'h40, 4'h3, 3'h2);
        more_burst(4'h3, 32'hbebe_8420, 4'he, 4'h3, 32'h0000_1111);

#30000 $stop;
  end



endmodule

