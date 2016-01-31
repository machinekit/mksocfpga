# request TCL package from ACDS 13.0
#package require -exact qsys 13.0

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1

#------------------------------------------------------------------------------ 
# module demo_axi_memory
#------------------------------------------------------------------------------
set_module_property DESCRIPTION                  "Demonstration AXI3 memory with optional Avalon-ST port"
set_module_property NAME                         demo_axi_memory
set_module_property VERSION                      1.0
set_module_property GROUP                        "Memories and Memory Controllers/On-Chip"
set_module_property AUTHOR                       "Altera"
set_module_property DISPLAY_NAME                 "Demo AXI Slave Memory"
set_module_property EDITABLE                     false
#set_module_property ANALYZE_HDL                  false
set_module_property HIDE_FROM_SOPC               true
set_module_property VALIDATION_CALLBACK          validate
set_module_property ELABORATION_CALLBACK         elaborate

# 
# module assignments
# 
set_module_assignment embeddedsw.dts.group memory
set_module_assignment embeddedsw.dts.name demo_axi_memory
set_module_assignment embeddedsw.dts.params.address_width 14
set_module_assignment embeddedsw.dts.params.data_width 32
set_module_assignment embeddedsw.dts.vendor altr

#------------------------------------------------------------------------------
# file sets
#------------------------------------------------------------------------------ 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL demo_axi_memory
add_fileset_file single_clk_ram.sv VERILOG PATH single_clk_ram.sv
add_fileset_file demo_axi_memory.sv SYSTEM_VERILOG PATH demo_axi_memory.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL demo_axi_memory
add_fileset_file verbosity_pkg.sv SYSTEM_VERILOG PATH verification_lib/verbosity_pkg.sv
add_fileset_file single_clk_ram.sv VERILOG PATH single_clk_ram.sv
add_fileset_file demo_axi_memory.sv SYSTEM_VERILOG PATH demo_axi_memory.sv

#Verilog simulation files provided for VHDL output; requires mixed-language simulator and license
add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL demo_axi_memory
add_fileset_file verbosity_pkg.sv SYSTEM_VERILOG PATH verification_lib/verbosity_pkg.sv
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file single_clk_ram.sv VERILOG PATH single_clk_ram.sv
add_fileset_file demo_axi_memory.sv SYSTEM_VERILOG PATH demo_axi_memory.sv

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
add_parameter          AXI_ID_W INTEGER             14
set_parameter_property AXI_ID_W DISPLAY_NAME        "AXI ID Signal Widths"
set_parameter_property AXI_ID_W DESCRIPTION         "Width of ID tag signals"
set_parameter_property AXI_ID_W UNITS               bits
set_parameter_property AXI_ID_W ALLOWED_RANGES      {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}
set_parameter_property AXI_ID_W HDL_PARAMETER       true
set_parameter_property AXI_ID_W GROUP               "AXI Port Widths"

add_parameter          AXI_ADDRESS_W INTEGER        12
set_parameter_property AXI_ADDRESS_W DISPLAY_NAME   "AXI Address Width"
set_parameter_property AXI_ADDRESS_W DESCRIPTION    "Memory address width"
set_parameter_property AXI_ADDRESS_W UNITS          bits
set_parameter_property AXI_ADDRESS_W ALLOWED_RANGES 4:16
set_parameter_property AXI_ADDRESS_W HDL_PARAMETER  true
set_parameter_property AXI_ADDRESS_W GROUP          "AXI Port Widths"

add_parameter          AXI_DATA_W INTEGER           32
set_parameter_property AXI_DATA_W DISPLAY_NAME      "AXI Data Width"
set_parameter_property AXI_DATA_W DESCRIPTION       "Width of memory data buses"
set_parameter_property AXI_DATA_W UNITS             bits
set_parameter_property AXI_DATA_W ALLOWED_RANGES    {8 16 32 64 128 256 512 1024}
set_parameter_property AXI_DATA_W HDL_PARAMETER     true
set_parameter_property AXI_DATA_W GROUP             "AXI Port Widths"

add_parameter          AXI_NUMBYTES INTEGER         4
set_parameter_property AXI_NUMBYTES DERIVED         true
set_parameter_property AXI_NUMBYTES DISPLAY_NAME    "Data Width in bytes"
set_parameter_property AXI_NUMBYTES DESCRIPTION     "Number of bytes in one word; Data Width/8"
set_parameter_property AXI_NUMBYTES UNITS           bytes
set_parameter_property AXI_NUMBYTES HDL_PARAMETER   true
set_parameter_property AXI_NUMBYTES GROUP           "AXI Port Widths"

add_parameter          ENABLE_STREAM_OUTPUT BOOLEAN      true
set_parameter_property ENABLE_STREAM_OUTPUT DISPLAY_NAME "Include Avalon Streaming Source and 
Avalon-MM Slave CSR Interfaces"
set_parameter_property ENABLE_STREAM_OUTPUT DESCRIPTION  "Include the optional Avalon-ST
Source and associated Avalon MM Slave Control Port (default), or hide these two interfaces"
set_parameter_property ENABLE_STREAM_OUTPUT GROUP        "Streaming Port Control"
#By making it a parameter in the HDL, the unneeded logic can be eliminated in the Verilog code
set_parameter_property ENABLE_STREAM_OUTPUT HDL_PARAMETER  true

add_parameter          AV_ADDRESS_W  INTEGER        2
set_parameter_property AV_ADDRESS_W  DISPLAY_NAME   "Avalon CSR Address Width"
set_parameter_property AV_ADDRESS_W  DESCRIPTION    "Address width of Avalon slave interface"
set_parameter_property AV_ADDRESS_W  UNITS          bits
set_parameter_property AV_ADDRESS_W  ALLOWED_RANGES 1:3
set_parameter_property AV_ADDRESS_W  HDL_PARAMETER  true
set_parameter_property AV_ADDRESS_W  GROUP          "Avalon Slave CSR Port Widths"

add_parameter          AV_DATA_W     INTEGER        16
set_parameter_property AV_DATA_W     DISPLAY_NAME   "Avalon CSR Data Width"
set_parameter_property AV_DATA_W     DESCRIPTION    "Data width of Avalon slave interface"
set_parameter_property AV_DATA_W     UNITS          bits
set_parameter_property AV_DATA_W     ALLOWED_RANGES {8 16 32}
set_parameter_property AV_DATA_W     HDL_PARAMETER  true
set_parameter_property AV_DATA_W     GROUP          "Avalon Slave CSR Port Widths"

add_parameter          AV_NUMBYTES INTEGER         2
set_parameter_property AV_NUMBYTES DERIVED         true
set_parameter_property AV_NUMBYTES DISPLAY_NAME    "Data Width in bytes"
set_parameter_property AV_NUMBYTES DESCRIPTION     "Number of bytes in one word; Data Width/8"
set_parameter_property AV_NUMBYTES UNITS           bytes
set_parameter_property AV_NUMBYTES HDL_PARAMETER   true
set_parameter_property AV_NUMBYTES GROUP           "Avalon Slave CSR Port Widths"

#------------------------------------------------------------------------------
#  AXI Slave connection point
#------------------------------------------------------------------------------
set SLAVE_INTERFACE  "RAM"
add_interface $SLAVE_INTERFACE axi slave


#------------------------------------------------------------------------------
# Interface Properties
#------------------------------------------------------------------------------
set_interface_assignment RAM embeddedsw.configuration.isMemoryDevice 1

set_interface_property $SLAVE_INTERFACE associatedClock             "clk"
set_interface_property $SLAVE_INTERFACE associatedReset             "reset"
set_interface_property $SLAVE_INTERFACE readAcceptanceCapability     1
set_interface_property $SLAVE_INTERFACE writeAcceptanceCapability    1
set_interface_property $SLAVE_INTERFACE combinedAcceptanceCapability 1
set_interface_property $SLAVE_INTERFACE readDataReorderingDepth      1
set_interface_property $SLAVE_INTERFACE ENABLED                      true


#------------------------------------------------------------------------------
# Interface Ports					  
#------------------------------------------------------------------------------
#                  <interface>      <port>       <type>  <dir>  <width>
add_interface_port $SLAVE_INTERFACE axs_arid     arid    Input  AXI_ID_W
add_interface_port $SLAVE_INTERFACE axs_araddr   araddr  Input  AXI_ADDRESS_W
add_interface_port $SLAVE_INTERFACE axs_arlen    arlen   Input  4
add_interface_port $SLAVE_INTERFACE axs_arsize   arsize  Input  3
add_interface_port $SLAVE_INTERFACE axs_arburst  arburst Input  2
add_interface_port $SLAVE_INTERFACE axs_arlock   arlock  Input  2
add_interface_port $SLAVE_INTERFACE axs_arcache  arcache Input  4
add_interface_port $SLAVE_INTERFACE axs_arprot   arprot  Input  3
add_interface_port $SLAVE_INTERFACE axs_arvalid  arvalid Input  1
add_interface_port $SLAVE_INTERFACE axs_arready  arready Output 1

add_interface_port $SLAVE_INTERFACE axs_rid      rid     Output AXI_ID_W  
add_interface_port $SLAVE_INTERFACE axs_rdata    rdata   Output AXI_DATA_W
add_interface_port $SLAVE_INTERFACE axs_rresp    rresp   Output 2
add_interface_port $SLAVE_INTERFACE axs_rlast    rlast   Output 1
add_interface_port $SLAVE_INTERFACE axs_rvalid   rvalid  Output 1
add_interface_port $SLAVE_INTERFACE axs_rready   rready  Input  1

add_interface_port $SLAVE_INTERFACE axs_awid     awid    Input  AXI_ID_W
add_interface_port $SLAVE_INTERFACE axs_awaddr   awaddr  Input  AXI_ADDRESS_W
add_interface_port $SLAVE_INTERFACE axs_awcache  awcache Input  4
add_interface_port $SLAVE_INTERFACE axs_awlen    awlen   Input  4
add_interface_port $SLAVE_INTERFACE axs_awprot   awprot  Input  3
add_interface_port $SLAVE_INTERFACE axs_awsize   awsize  Input  3
add_interface_port $SLAVE_INTERFACE axs_awburst  awburst Input  2
add_interface_port $SLAVE_INTERFACE axs_awlock   awlock  Input  2
add_interface_port $SLAVE_INTERFACE axs_awvalid  awvalid Input  1
add_interface_port $SLAVE_INTERFACE axs_awready  awready Output 1

add_interface_port $SLAVE_INTERFACE axs_wready   wready  Output 1
add_interface_port $SLAVE_INTERFACE axs_wid      wid     Input  AXI_ID_W
add_interface_port $SLAVE_INTERFACE axs_wdata    wdata   Input  AXI_DATA_W
add_interface_port $SLAVE_INTERFACE axs_wlast    wlast   Input  1
add_interface_port $SLAVE_INTERFACE axs_wvalid   wvalid  Input  1
add_interface_port $SLAVE_INTERFACE axs_wstrb    wstrb   Input  AXI_NUMBYTES

add_interface_port $SLAVE_INTERFACE axs_bresp    bresp   Output 2
add_interface_port $SLAVE_INTERFACE axs_bid      bid     Output AXI_ID_W
add_interface_port $SLAVE_INTERFACE axs_bvalid   bvalid  Output 1
add_interface_port $SLAVE_INTERFACE axs_bready   bready  Input  1


#---------------------------------------------------------------------
# Clock & Reset connection points
#---------------------------------------------------------------------
set CLOCK_INTERFACE  "clk"
add_interface      $CLOCK_INTERFACE clock end

set RESET_INTERFACE  "reset"
add_interface          $RESET_INTERFACE  reset            end
set_interface_property $RESET_INTERFACE  associatedClock  clk
set_interface_property $RESET_INTERFACE  synchronousEdges DEASSERT

#                      <interface>       <port>     <type>    <dir>  <width>
add_interface_port     $CLOCK_INTERFACE  clk        clk       Input   1
add_interface_port     $RESET_INTERFACE  reset_n    reset_n   Input   1

#---------------------------------------------------------------------
#  Avalon Streaming Source connection point
#---------------------------------------------------------------------
set STREAMING_INTERFACE "streaming"
add_interface $STREAMING_INTERFACE avalon_streaming start

set_interface_property $STREAMING_INTERFACE associatedClock           "clk"
set_interface_property $STREAMING_INTERFACE associatedReset           "reset"
set_interface_property $STREAMING_INTERFACE dataBitsPerSymbol          8
set_interface_property $STREAMING_INTERFACE errorDescriptor            ""
set_interface_property $STREAMING_INTERFACE firstSymbolInHighOrderBits true
set_interface_property $STREAMING_INTERFACE maxChannel                 0
set_interface_property $STREAMING_INTERFACE readyLatency               0
set_interface_property $STREAMING_INTERFACE ENABLED                    true

#                      <interface>          <port>     <type> <dir>  <width>
add_interface_port     $STREAMING_INTERFACE aso_data   data   Output  8
add_interface_port     $STREAMING_INTERFACE aso_valid  valid  Output  1
add_interface_port     $STREAMING_INTERFACE aso_ready  ready  Input   1

#---------------------------------------------------------------------
#  Avalon MM Slave connection point
#---------------------------------------------------------------------
set CSR_INTERFACE "streaming_csr"
add_interface $CSR_INTERFACE avalon end

set_interface_property $CSR_INTERFACE       associatedClock           "clk"
set_interface_property $CSR_INTERFACE       associatedReset           "reset"
set_interface_property $CSR_INTERFACE       holdTime                  0
set_interface_property $CSR_INTERFACE       readLatency               0
set_interface_property $CSR_INTERFACE       readWaitTime              1
set_interface_property $CSR_INTERFACE       setupTime                 0
set_interface_property $CSR_INTERFACE       timingUnits               Cycles
set_interface_property $CSR_INTERFACE       writeWaitTime             0
set_interface_property $CSR_INTERFACE       maximumPendingReadTransactions 0

#                   <interface>      <port>           <type>        <dir>  <width>
add_interface_port  $CSR_INTERFACE   avs_waitrequest  waitrequest   Output  1
add_interface_port  $CSR_INTERFACE   avs_readdata     readdata      Output  AV_DATA_W
add_interface_port  $CSR_INTERFACE   avs_read         read          Input   1
add_interface_port  $CSR_INTERFACE   avs_write        write         Input   1
add_interface_port  $CSR_INTERFACE   avs_address      address       Input   AV_ADDRESS_W
add_interface_port  $CSR_INTERFACE   avs_writedata    writedata     Input   AV_DATA_W
add_interface_port  $CSR_INTERFACE   avs_byteenable   byteenable    Input   AV_NUMBYTES



#---------------------------------------------------------------------
proc validate {} {
   if { [get_parameter_value ENABLE_STREAM_OUTPUT] && 
       ([get_parameter_value AXI_ADDRESS_W] > [get_parameter_value AV_DATA_W]) } {
   send_message error "If the optional Avalon streaming port is enabled, the Avalon CSR port Data Width 
   must be equal to or greater than the AXI Address Width"
   }
}
#---------------------------------------------------------------------

proc elaborate {} {
    if { [ get_parameter_value ENABLE_STREAM_OUTPUT ] == "false" } {
       set_port_property aso_data        termination       true
       set_port_property aso_valid       termination       true
       set_port_property aso_ready       termination       true
       set_port_property aso_ready       termination_value 0

       set_port_property avs_waitrequest termination       true
       set_port_property avs_readdata    termination       true
       set_port_property avs_read        termination       true
       set_port_property avs_read        termination_value 0
       set_port_property avs_write       termination       true
       set_port_property avs_write       termination_value 0
       set_port_property avs_address     termination       true
       set_port_property avs_address     termination_value 0
       set_port_property avs_writedata   termination       true
       set_port_property avs_writedata   termination_value 0
       set_port_property avs_byteenable  termination       true
       set_port_property avs_byteenable  termination_value 0

       set_display_item_property "Avalon Slave CSR Port Widths"  visible  false

#     else clause below is needed because GUI items are not automatically reset to 
#     default on re-elaboration (i.e. the Avalon Slave CSR Port Widths group in the GUI
#     disappears when ENABLE_STREAM_OUTPUT goes false, but doesn't reappear when
#     ENABLE_STREAM_OUTPUT toggles back to true). 
#     In contrast, whenever elaboration is triggered, the termination states (above) 
#     are first reset to their default value (false), and then set according to the
#     code in the elaborate procedure. So they always track the state of ENABLE_STREAM_
#     OUTPUT without having to be included in the else statement.

      } else {
       set_display_item_property "Avalon Slave CSR Port Widths"  visible  true
      }

#   Calculate the Data Bus Width in bytes
    set bytewidth_var [ expr [ get_parameter_value AXI_DATA_W] /8 ]
    set_parameter_value AXI_NUMBYTES $bytewidth_var

#   Repeat for the Avalon Slave Bus
    set bytewidth_var [ expr [ get_parameter_value AV_DATA_W] /8 ]
    set_parameter_value AV_NUMBYTES $bytewidth_var
}


