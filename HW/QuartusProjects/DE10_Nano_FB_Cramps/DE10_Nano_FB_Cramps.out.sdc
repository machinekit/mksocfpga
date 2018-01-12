## Generated SDC file "DE10_Nano_FB_Cramps.out.sdc"

## Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.2 Build 193 02/01/2016 SJ Standard Edition"

## DATE    "Tue Aug 29 13:25:32 2017"

##
## DEVICE  "5CSEBA6U23I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {fpga_clk1_50} -period "50.0 MHz" [get_ports {FPGA_CLK1_50}]
create_clock -name {fpga_clk2_50} -period "50.0 MHz" [get_ports {FPGA_CLK2_50}]
create_clock -name {fpga_clk3_50} -period "50.0 MHz" [get_ports {FPGA_CLK3_50}]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {soc_system:u0|soc_system_pll_stream:pll_stream|altera_pll:altera_pll_i|general[0].gpll~FRACTIONAL_PLL_O_VCOPH0} -source [get_pins {u0|pll_stream|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50.000 -multiply_by 12 -divide_by 2 -master_clock {fpga_clk1_50} [get_pins {u0|pll_stream|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {soc_system:u0|soc_system_pll_stream:pll_stream|altera_pll:altera_pll_i|outclk_wire[0]} -source [get_pins {u0|pll_stream|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -master_clock {soc_system:u0|soc_system_pll_stream:pll_stream|altera_pll:altera_pll_i|general[0].gpll~FRACTIONAL_PLL_O_VCOPH0} [get_pins {u0|pll_stream|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {soc_system:u0|soc_system_pll_stream:pll_stream|altera_pll:altera_pll_i|outclk_wire[1]} -source [get_pins {u0|pll_stream|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 4 -master_clock {soc_system:u0|soc_system_pll_stream:pll_stream|altera_pll:altera_pll_i|general[0].gpll~FRACTIONAL_PLL_O_VCOPH0} [get_pins {u0|pll_stream|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {fpga_clk1_50}] -rise_to [get_clocks {fpga_clk1_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {fpga_clk1_50}] -rise_to [get_clocks {fpga_clk1_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {fpga_clk1_50}] -fall_to [get_clocks {fpga_clk1_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {fpga_clk1_50}] -fall_to [get_clocks {fpga_clk1_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {fpga_clk1_50}] -rise_to [get_clocks {fpga_clk1_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {fpga_clk1_50}] -rise_to [get_clocks {fpga_clk1_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {fpga_clk1_50}] -fall_to [get_clocks {fpga_clk1_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {fpga_clk1_50}] -fall_to [get_clocks {fpga_clk1_50}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

