# Copyright (C) 1991-2012 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: 
# Generated on: Thu Jan 10 12:11:48 2013

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "c5sx_soc"]} {
		puts "Project c5sx_soc is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists c5sx_soc]} {
		project_open -revision c5sx_soc c5sx_soc_top
	} else {
		project_new -revision c5sx_soc c5sx_soc
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {

	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_rzq -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[4] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[5] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[5] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[5] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[6] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[6] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[6] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[7] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[7] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[7] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[8] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[8] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[8] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[9] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[9] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[9] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[10] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[10] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[10] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[11] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[11] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[11] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[12] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[12] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[12] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[13] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[13] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[13] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[14] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[14] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[14] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[15] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[15] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[15] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[16] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[16] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[16] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[17] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[17] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[17] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[18] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[18] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[18] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[19] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[19] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[19] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[20] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[20] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[20] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[21] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[21] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[21] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[22] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[22] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[22] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[23] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[23] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[23] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[24] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[24] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[24] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[25] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[25] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[25] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[26] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[26] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[26] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[27] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[27] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[27] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[28] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[28] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[28] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[29] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[29] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[29] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[30] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[30] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[30] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[31] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[31] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[31] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[32] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[32] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[32] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[33] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[33] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[33] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[34] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[34] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[34] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[35] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[35] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[35] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[36] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[36] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[36] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[37] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[37] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[37] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[38] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[38] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[38] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dq[39] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[39] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dq[39] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_p[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_p[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_p[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_p[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_p[4] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_p[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_n[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_n[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_n[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_n[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_dqs_n[4] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dqs_n[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_clk_p -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to ddr3_hps_clk_p -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_hps_clk_n -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to ddr3_hps_clk_n -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[10] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[10] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[11] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[11] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[12] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[12] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[13] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[13] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[14] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[14] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[3] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[4] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[5] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[5] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[6] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[6] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[7] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[7] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[8] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[8] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_a[9] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_a[9] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_ba[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_ba[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_ba[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_ba[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_ba[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_ba[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_casn -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_casn -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_cke -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_cke -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_csn -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_csn -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_odt -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_odt -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_rasn -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_rasn -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_wen -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_wen -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_resetn -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_hps_resetn -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dm[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dm[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dm[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dm[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dm[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dm[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dm[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dm[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_hps_dm[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_hps_dm[4] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[4].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[4] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[4] -tag __hps_sdram_p0
	set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to u0|hps_0|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0
	set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to u0|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_hps_a
	set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_hps_ba
	set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_hps_dm
	set_location_assignment PIN_F26 -to ddr3_hps_a[0]
	set_location_assignment PIN_G30 -to ddr3_hps_a[1]
	set_location_assignment PIN_F28 -to ddr3_hps_a[2]
	set_location_assignment PIN_F30 -to ddr3_hps_a[3]
	set_location_assignment PIN_J25 -to ddr3_hps_a[4]
	set_location_assignment PIN_J27 -to ddr3_hps_a[5]
	set_location_assignment PIN_F29 -to ddr3_hps_a[6]
	set_location_assignment PIN_E28 -to ddr3_hps_a[7]
	set_location_assignment PIN_H27 -to ddr3_hps_a[8]
	set_location_assignment PIN_G26 -to ddr3_hps_a[9]
	set_location_assignment PIN_D29 -to ddr3_hps_a[10]
	set_location_assignment PIN_C30 -to ddr3_hps_a[11]
	set_location_assignment PIN_B30 -to ddr3_hps_a[12]
	set_location_assignment PIN_C29 -to ddr3_hps_a[13]
	set_location_assignment PIN_H25 -to ddr3_hps_a[14]
	set_location_assignment PIN_E29 -to ddr3_hps_ba[0]
	set_location_assignment PIN_J24 -to ddr3_hps_ba[1]
	set_location_assignment PIN_J23 -to ddr3_hps_ba[2]
	set_location_assignment PIN_K28 -to ddr3_hps_dm[0]
	set_location_assignment PIN_M28 -to ddr3_hps_dm[1]
	set_location_assignment PIN_R28 -to ddr3_hps_dm[2]
	set_location_assignment PIN_W30 -to ddr3_hps_dm[3]
#	set_location_assignment PIN_W27 -to ddr3_hps_dm[4]
	set_location_assignment PIN_K23 -to ddr3_hps_dq[0]
	set_location_assignment PIN_K22 -to ddr3_hps_dq[1]
	set_location_assignment PIN_H30 -to ddr3_hps_dq[2]
	set_location_assignment PIN_G28 -to ddr3_hps_dq[3]
	set_location_assignment PIN_L25 -to ddr3_hps_dq[4]
	set_location_assignment PIN_L24 -to ddr3_hps_dq[5]
	set_location_assignment PIN_J30 -to ddr3_hps_dq[6]
	set_location_assignment PIN_J29 -to ddr3_hps_dq[7]
	set_location_assignment PIN_K26 -to ddr3_hps_dq[8]
	set_location_assignment PIN_L26 -to ddr3_hps_dq[9]
	set_location_assignment PIN_K29 -to ddr3_hps_dq[10]
	set_location_assignment PIN_K27 -to ddr3_hps_dq[11]
	set_location_assignment PIN_M26 -to ddr3_hps_dq[12]
	set_location_assignment PIN_M27 -to ddr3_hps_dq[13]
	set_location_assignment PIN_L28 -to ddr3_hps_dq[14]
	set_location_assignment PIN_M30 -to ddr3_hps_dq[15]
	set_location_assignment PIN_U26 -to ddr3_hps_dq[16]
	set_location_assignment PIN_T26 -to ddr3_hps_dq[17]
	set_location_assignment PIN_N29 -to ddr3_hps_dq[18]
	set_location_assignment PIN_N28 -to ddr3_hps_dq[19]
	set_location_assignment PIN_P26 -to ddr3_hps_dq[20]
	set_location_assignment PIN_P27 -to ddr3_hps_dq[21]
	set_location_assignment PIN_N27 -to ddr3_hps_dq[22]
	set_location_assignment PIN_R29 -to ddr3_hps_dq[23]
	set_location_assignment PIN_P24 -to ddr3_hps_dq[24]
	set_location_assignment PIN_P25 -to ddr3_hps_dq[25]
	set_location_assignment PIN_T29 -to ddr3_hps_dq[26]
	set_location_assignment PIN_T28 -to ddr3_hps_dq[27]
	set_location_assignment PIN_R27 -to ddr3_hps_dq[28]
	set_location_assignment PIN_R26 -to ddr3_hps_dq[29]
	set_location_assignment PIN_V30 -to ddr3_hps_dq[30]
	set_location_assignment PIN_W29 -to ddr3_hps_dq[31]
	set_location_assignment PIN_N18 -to ddr3_hps_dqs_p[0]
	set_location_assignment PIN_N25 -to ddr3_hps_dqs_p[1]
	set_location_assignment PIN_R19 -to ddr3_hps_dqs_p[2]
	set_location_assignment PIN_R22 -to ddr3_hps_dqs_p[3]
	set_location_assignment PIN_E27 -to ddr3_hps_casn
	set_location_assignment PIN_L29 -to ddr3_hps_cke
	set_location_assignment PIN_L23 -to ddr3_hps_clk_n
	set_location_assignment PIN_M23 -to ddr3_hps_clk_p
	set_location_assignment PIN_H24 -to ddr3_hps_csn
	set_location_assignment PIN_H28 -to ddr3_hps_odt
	set_location_assignment PIN_D30 -to ddr3_hps_rasn
	set_location_assignment PIN_P30 -to ddr3_hps_resetn
	set_location_assignment PIN_C28 -to ddr3_hps_wen
	set_location_assignment PIN_D27 -to ddr3_hps_rzq
	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk_50_hps
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk_25_hps
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rst_n_hps
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to warm_rst_n_hps
	
	set_location_assignment PIN_D25 -to clk_50_hps
	set_location_assignment PIN_F25 -to clk_25_hps
	set_location_assignment PIN_C27 -to warm_rst_n_hps	
	set_location_assignment PIN_F23 -to rst_n_hps
	
	set_instance_assignment -name IO_STANDARD "1.5-V" -to user_dipsw_hps
	set_location_assignment PIN_V20 -to user_dipsw_hps[0]
	set_location_assignment PIN_P22 -to user_dipsw_hps[1]
	set_location_assignment PIN_P29 -to user_dipsw_hps[2]
	set_location_assignment PIN_N30 -to user_dipsw_hps[3]
	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to user_led_hps
	set_location_assignment PIN_A24 -to user_led_hps[0]
	set_location_assignment PIN_G21 -to user_led_hps[1]
	set_location_assignment PIN_C24 -to user_led_hps[2]
	set_location_assignment PIN_E23 -to user_led_hps[3]

	set_instance_assignment -name IO_STANDARD "1.5-V" -to user_pb_hps
	set_location_assignment PIN_T30 -to user_pb_hps[0]
	set_location_assignment PIN_U28 -to user_pb_hps[1]
	set_location_assignment PIN_T21 -to user_pb_hps[2]
	set_location_assignment PIN_U20 -to user_pb_hps[3]
	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx
	set_location_assignment PIN_B25 -to uart_rx
	set_location_assignment PIN_C25 -to uart_tx

	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to i2c_scl_hps
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to i2c_sda_hps	
	set_location_assignment PIN_H23 -to i2c_scl_hps
	set_location_assignment PIN_A25 -to i2c_sda_hps

	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to spi1_csn	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to spi_csn
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to spi_miso
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to spi_mosi
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to spi_sck	
	set_location_assignment PIN_B22 -to hps_gsensor_int
	set_location_assignment PIN_H20 -to spi_csn
	set_location_assignment PIN_B23 -to spi_miso
	set_location_assignment PIN_C22 -to spi_mosi
	set_location_assignment PIN_A23 -to spi_sck

	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to qspi_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to qspi_io
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to qspi_ss0
	set_location_assignment PIN_D19 -to qspi_clk
	set_location_assignment PIN_C20 -to qspi_io[0]
	set_location_assignment PIN_H18 -to qspi_io[1]
	set_location_assignment PIN_A19 -to qspi_io[2]
	set_location_assignment PIN_E19 -to qspi_io[3]
	set_location_assignment PIN_A18 -to qspi_ss0

	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_cmd
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_pwren
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_dat	
	set_location_assignment PIN_B16 -to sd_dat[3]
	set_location_assignment PIN_A16 -to sd_clk
	set_location_assignment PIN_F18 -to sd_cmd
	set_location_assignment PIN_G18 -to sd_dat[0]
	set_location_assignment PIN_C17 -to sd_dat[1]
	set_location_assignment PIN_D17 -to sd_dat[2]
	set_location_assignment PIN_B17 -to sd_pwren

	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb_data
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb_nxt
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb_stp
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb_dir
	
	set_location_assignment PIN_N16 -to usb_clk
	set_location_assignment PIN_E16 -to usb_data[0]
	set_location_assignment PIN_G16 -to usb_data[1]
	set_location_assignment PIN_D16 -to usb_data[2]
	set_location_assignment PIN_D14 -to usb_data[3]
	set_location_assignment PIN_A15 -to usb_data[4]
	set_location_assignment PIN_C14 -to usb_data[5]
	set_location_assignment PIN_D15 -to usb_data[6]
	set_location_assignment PIN_M17 -to usb_data[7]
	set_location_assignment PIN_A14 -to usb_nxt
	set_location_assignment PIN_E14 -to usb_dir
	set_location_assignment PIN_C15 -to usb_stp
	
	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_gtx_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_mdc
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_mdio
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_rx_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_rx_dv

	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_rxd
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_tx_en
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_txd	
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to enet_hps_intn
	
	set_location_assignment PIN_H19 -to enet_hps_gtx_clk
	set_location_assignment PIN_F20 -to enet_hps_txd[0]
	set_location_assignment PIN_J19 -to enet_hps_txd[1]
	set_location_assignment PIN_F21 -to enet_hps_txd[2]
	set_location_assignment PIN_F19 -to enet_hps_txd[3]
	set_location_assignment PIN_A21 -to enet_hps_rxd[0]	
	set_location_assignment PIN_E21 -to enet_hps_mdio
	set_location_assignment PIN_B21 -to enet_hps_mdc
	set_location_assignment PIN_K17 -to enet_hps_rx_dv	
	set_location_assignment PIN_A20 -to enet_hps_tx_en	
	set_location_assignment PIN_G20 -to enet_hps_rx_clk
	set_location_assignment PIN_B20 -to enet_hps_rxd[1]
	set_location_assignment PIN_B18 -to enet_hps_rxd[2]
	set_location_assignment PIN_D21 -to enet_hps_rxd[3]
	set_location_assignment PIN_C19 -to enet_hps_intn	


	set_instance_assignment -name IO_STANDARD "2.5 V" -to clk_100m_fpga
	set_instance_assignment -name IO_STANDARD "2.5 V" -to clk_50m_fpga
	set_location_assignment PIN_Y26 -to clk_100m_fpga
	set_location_assignment PIN_K14 -to clk_50m_fpga

	set_instance_assignment -name IO_STANDARD "1.5 V" -to clk_top1
	set_instance_assignment -name IO_STANDARD "1.5 V" -to clk_bot1
	set_location_assignment PIN_AA16 -to clk_top1
	set_location_assignment PIN_AF14 -to clk_bot1	

#	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to cpu_resetn	
#	set_location_assignment PIN_AD27 -to cpu_resetn
	
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_a
	set_location_assignment PIN_AJ14 -to ddr3_fpga_a[0]
	set_location_assignment PIN_AK14 -to ddr3_fpga_a[1]
	set_location_assignment PIN_AH12 -to ddr3_fpga_a[2]
	set_location_assignment PIN_AJ12 -to ddr3_fpga_a[3]
	set_location_assignment PIN_AG15 -to ddr3_fpga_a[4]
	set_location_assignment PIN_AH15 -to ddr3_fpga_a[5]
	set_location_assignment PIN_AK12 -to ddr3_fpga_a[6]
	set_location_assignment PIN_AK13 -to ddr3_fpga_a[7]
	set_location_assignment PIN_AH13 -to ddr3_fpga_a[8]
	set_location_assignment PIN_AH14 -to ddr3_fpga_a[9]
	set_location_assignment PIN_AJ9 -to ddr3_fpga_a[10]
	set_location_assignment PIN_AK9 -to ddr3_fpga_a[11]
	set_location_assignment PIN_AK7 -to ddr3_fpga_a[12]
	set_location_assignment PIN_AK8 -to ddr3_fpga_a[13]
	set_location_assignment PIN_AG12 -to ddr3_fpga_a[14]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_ba
	set_location_assignment PIN_AH10 -to ddr3_fpga_ba[0]
	set_location_assignment PIN_AJ11 -to ddr3_fpga_ba[1]
	set_location_assignment PIN_AK11 -to ddr3_fpga_ba[2]
	set_location_assignment PIN_AH7 -to ddr3_fpga_casn
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_casn
	set_location_assignment PIN_AJ21 -to ddr3_fpga_cke
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_cke
	set_location_assignment PIN_AA15 -to ddr3_fpga_clk_n
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_clk_n
	set_location_assignment PIN_AA14 -to ddr3_fpga_clk_p
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_clk_p
	set_location_assignment PIN_AB15 -to ddr3_fpga_csn
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_csn
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_dm
	set_location_assignment PIN_AH17 -to ddr3_fpga_dm[0]
	set_location_assignment PIN_AG23 -to ddr3_fpga_dm[1]
	set_location_assignment PIN_AK23 -to ddr3_fpga_dm[2]
	set_location_assignment PIN_AJ27 -to ddr3_fpga_dm[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_dq
	set_location_assignment PIN_AF18 -to ddr3_fpga_dq[0]
	set_location_assignment PIN_AE17 -to ddr3_fpga_dq[1]
	set_location_assignment PIN_AG16 -to ddr3_fpga_dq[2]
	set_location_assignment PIN_AF16 -to ddr3_fpga_dq[3]
	set_location_assignment PIN_AH20 -to ddr3_fpga_dq[4]
	set_location_assignment PIN_AG21 -to ddr3_fpga_dq[5]
	set_location_assignment PIN_AJ16 -to ddr3_fpga_dq[6]
	set_location_assignment PIN_AH18 -to ddr3_fpga_dq[7]
	set_location_assignment PIN_AK18 -to ddr3_fpga_dq[8]
	set_location_assignment PIN_AJ17 -to ddr3_fpga_dq[9]
	set_location_assignment PIN_AG18 -to ddr3_fpga_dq[10]
	set_location_assignment PIN_AK19 -to ddr3_fpga_dq[11]
	set_location_assignment PIN_AG20 -to ddr3_fpga_dq[12]
	set_location_assignment PIN_AF19 -to ddr3_fpga_dq[13]
	set_location_assignment PIN_AJ20 -to ddr3_fpga_dq[14]
	set_location_assignment PIN_AH24 -to ddr3_fpga_dq[15]
	set_location_assignment PIN_AE19 -to ddr3_fpga_dq[16]
	set_location_assignment PIN_AE18 -to ddr3_fpga_dq[17]
	set_location_assignment PIN_AG22 -to ddr3_fpga_dq[18]
	set_location_assignment PIN_AK22 -to ddr3_fpga_dq[19]
	set_location_assignment PIN_AF21 -to ddr3_fpga_dq[20]
	set_location_assignment PIN_AF20 -to ddr3_fpga_dq[21]
	set_location_assignment PIN_AH23 -to ddr3_fpga_dq[22]
	set_location_assignment PIN_AK24 -to ddr3_fpga_dq[23]
	set_location_assignment PIN_AF24 -to ddr3_fpga_dq[24]
	set_location_assignment PIN_AF23 -to ddr3_fpga_dq[25]
	set_location_assignment PIN_AJ24 -to ddr3_fpga_dq[26]
	set_location_assignment PIN_AK26 -to ddr3_fpga_dq[27]
	set_location_assignment PIN_AE23 -to ddr3_fpga_dq[28]
	set_location_assignment PIN_AE22 -to ddr3_fpga_dq[29]
	set_location_assignment PIN_AG25 -to ddr3_fpga_dq[30]
	set_location_assignment PIN_AK27 -to ddr3_fpga_dq[31]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_dqs_n
	set_location_assignment PIN_W16 -to ddr3_fpga_dqs_n[0]
	set_location_assignment PIN_W17 -to ddr3_fpga_dqs_n[1]
	set_location_assignment PIN_AA18 -to ddr3_fpga_dqs_n[2]
	set_location_assignment PIN_AD19 -to ddr3_fpga_dqs_n[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_dqs_p
	set_location_assignment PIN_V16 -to ddr3_fpga_dqs_p[0]
	set_location_assignment PIN_V17 -to ddr3_fpga_dqs_p[1]
	set_location_assignment PIN_Y17 -to ddr3_fpga_dqs_p[2]
	set_location_assignment PIN_AC20 -to ddr3_fpga_dqs_p[3]
	set_location_assignment PIN_AE16 -to ddr3_fpga_odt
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_odt
	set_location_assignment PIN_AH8 -to ddr3_fpga_rasn
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_rasn
	set_location_assignment PIN_AK21 -to ddr3_fpga_resetn
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_resetn
	set_location_assignment PIN_AJ6 -to ddr3_fpga_wen
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_fpga_wen
	set_location_assignment PIN_AG17 -to ddr3_fpga_rzq
	set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_fpga_rzq
	
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_b[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_blank_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_g[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_hs
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_r[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to  -to vga_sync_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to -to vga_vs 	
	
	set_location_assignment PIN_AE28 -to vga_b[0]
	set_location_assignment PIN_Y23 -to vga_b[1]
	set_location_assignment PIN_Y24 -to vga_b[2]
	set_location_assignment PIN_AG28 -to vga_b[3]
	set_location_assignment PIN_AF28 -to vga_b[4]
	set_location_assignment PIN_V23 -to vga_b[5]
	set_location_assignment PIN_W24 -to vga_b[6]
	set_location_assignment PIN_AF29 -to vga_b[7]
	set_location_assignment PIN_AH3 -to vga_blank_n
	set_location_assignment PIN_W20 -to vga_clk
	set_location_assignment PIN_Y21 -to vga_g[0]
	set_location_assignment PIN_AA25 -to vga_g[1]
	set_location_assignment PIN_AB26 -to vga_g[2]
	set_location_assignment PIN_AB22 -to vga_g[3]
	set_location_assignment PIN_AB23 -to vga_g[4]
	set_location_assignment PIN_AA24 -to vga_g[5]
	set_location_assignment PIN_AB25 -to vga_g[6]
	set_location_assignment PIN_AE27 -to vga_g[7]
	set_location_assignment PIN_AD12 -to vga_hs
	set_location_assignment PIN_AA12 -to vga_r[0]
	set_location_assignment PIN_AB12 -to vga_r[1]
	set_location_assignment PIN_AF6 -to vga_r[2]
	set_location_assignment PIN_AG6 -to vga_r[3]
	set_location_assignment PIN_AG5 -to vga_r[4]
	set_location_assignment PIN_AH5 -to vga_r[5]
	set_location_assignment PIN_AJ1 -to vga_r[6]
	set_location_assignment PIN_AJ2 -to vga_r[7]
	set_location_assignment PIN_AG2 -to vga_sync_n
	set_location_assignment PIN_AC12 -to vga_vs 

	set_location_assignment PIN_AC27 -to aud_adcdat
	set_location_assignment PIN_AG30 -to aud_adclrck
	set_location_assignment PIN_AE7 -to aud_bclk
	set_location_assignment PIN_AG3 -to aud_dacdat
	set_location_assignment PIN_AH4 -to aud_daclrck
	set_location_assignment PIN_AH30 -to aud_i2c_sclk
	set_location_assignment PIN_AF30 -to aud_i2c_sdat
	set_location_assignment PIN_AD26 -to aud_mute
	set_location_assignment PIN_AC9 -to aud_xck

	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to fan_ctrl	
	set_location_assignment PIN_AG27 -to fan_ctrl
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to irda_rxd	
	set_location_assignment PIN_AH2 -to irda_rxd
	
	
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkin_n[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkin_n[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkin_p[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkin_p[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkout_n[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkout_n[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkout_p[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clkout_p[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clk_in0
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_clk_out0	
	
	set_instance_assignment -name IO_STANDARD HCSL -to hsmc_ref_clk_n
	set_instance_assignment -name IO_STANDARD HCSL -to hsmc_ref_clk_p
	
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[5]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[6]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[7]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[8]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[9]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[10]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[11]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[12]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[13]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[14]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[15]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_n[16]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[5]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[6]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[7]
	set_instance_assignment -name IO_STANDARD "2.5 V"-to hsmc_rx_p[8]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[9]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[10]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[11]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[12]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[13]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[14]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[15]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_rx_p[16]	
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_scl
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_sda	
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[5]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[6]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[7]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[8]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[9]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[10]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[11]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[12]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[13]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[14]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[15]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_n[16]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[5]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[6]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[7]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[8]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[9]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[10]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[11]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[12]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[13]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[14]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[15]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmc_tx_p[16]	
	
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[0]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[1]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[2]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[3]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[4]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[5]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[6]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_n[7]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[0]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[1]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[2]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[3]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[4]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[5]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[6]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_rx_p[7]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[0]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[1]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[2]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[3]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[4]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[5]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[6]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_n[7]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[0]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[1]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[2]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[3]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[4]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[5]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[6]
	set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmc_gxb_tx_p[7]

	set_location_assignment PIN_AB27 -to hsmc_clkin_n[1]
	set_location_assignment PIN_AA26 -to hsmc_clkin_p[1]
	set_location_assignment PIN_G15 -to hsmc_clkin_n[2]
	set_location_assignment PIN_H15 -to hsmc_clkin_p[2]
	set_location_assignment PIN_E6 -to hsmc_clkout_n[1]
	set_location_assignment PIN_E7 -to hsmc_clkout_p[1]
	set_location_assignment PIN_A10 -to hsmc_clkout_n[2]
	set_location_assignment PIN_A11 -to hsmc_clkout_p[2]
	set_location_assignment PIN_J14 -to hsmc_clk_in0
	set_location_assignment PIN_AD29 -to hsmc_clk_out0

	
	set_location_assignment PIN_AE1 -to hsmc_gxb_rx_n[0]
	set_location_assignment PIN_AC1 -to hsmc_gxb_rx_n[1]
	set_location_assignment PIN_AA1 -to hsmc_gxb_rx_n[2]
	set_location_assignment PIN_W1 -to hsmc_gxb_rx_n[3]
	set_location_assignment PIN_U1 -to hsmc_gxb_rx_n[4]
	set_location_assignment PIN_R1 -to hsmc_gxb_rx_n[5]
	set_location_assignment PIN_N1 -to hsmc_gxb_rx_n[6]
	set_location_assignment PIN_L1 -to hsmc_gxb_rx_n[7]
	set_location_assignment PIN_AE2 -to hsmc_gxb_rx_p[0]
	set_location_assignment PIN_AC2 -to hsmc_gxb_rx_p[1]
	set_location_assignment PIN_AA2 -to hsmc_gxb_rx_p[2]
	set_location_assignment PIN_W2 -to hsmc_gxb_rx_p[3]
	set_location_assignment PIN_U2 -to hsmc_gxb_rx_p[4]
	set_location_assignment PIN_R2 -to hsmc_gxb_rx_p[5]
	set_location_assignment PIN_N2 -to hsmc_gxb_rx_p[6]
	set_location_assignment PIN_L2 -to hsmc_gxb_rx_p[7]
	set_location_assignment PIN_AD3 -to hsmc_gxb_tx_n[0]
	set_location_assignment PIN_AB3 -to hsmc_gxb_tx_n[1]
	set_location_assignment PIN_Y3 -to hsmc_gxb_tx_n[2]
	set_location_assignment PIN_V3 -to hsmc_gxb_tx_n[3]
	set_location_assignment PIN_T3 -to hsmc_gxb_tx_n[4]
	set_location_assignment PIN_P3 -to hsmc_gxb_tx_n[5]
	set_location_assignment PIN_M3 -to hsmc_gxb_tx_n[6]
	set_location_assignment PIN_K3 -to hsmc_gxb_tx_n[7]
	set_location_assignment PIN_AD4 -to hsmc_gxb_tx_p[0]
	set_location_assignment PIN_AB4 -to hsmc_gxb_tx_p[1]
	set_location_assignment PIN_Y4 -to hsmc_gxb_tx_p[2]
	set_location_assignment PIN_V4 -to hsmc_gxb_tx_p[3]
	set_location_assignment PIN_T4 -to hsmc_gxb_tx_p[4]
	set_location_assignment PIN_P4 -to hsmc_gxb_tx_p[5]
	set_location_assignment PIN_M4 -to hsmc_gxb_tx_p[6]
	set_location_assignment PIN_K4 -to hsmc_gxb_tx_p[7]
	set_location_assignment PIN_W7 -to hsmc_ref_clk_n
	set_location_assignment PIN_W8 -to hsmc_ref_clk_p

	set_location_assignment PIN_G12 -to hsmc_rx_p[0]
	set_location_assignment PIN_G11 -to hsmc_rx_n[0]	
	set_location_assignment PIN_K12 -to hsmc_rx_p[1]
	set_location_assignment PIN_J12 -to hsmc_rx_n[1]	
	set_location_assignment PIN_G10 -to hsmc_rx_p[2]
	set_location_assignment PIN_F10 -to hsmc_rx_n[2]			
	set_location_assignment PIN_J10 -to hsmc_rx_p[3]	
	set_location_assignment PIN_J9 -to hsmc_rx_n[3]	
	set_location_assignment PIN_K7 -to hsmc_rx_p[4]		
	set_location_assignment PIN_K8 -to hsmc_rx_n[4]	
	set_location_assignment PIN_J7 -to hsmc_rx_p[5]		
	set_location_assignment PIN_H7 -to hsmc_rx_n[5]	
	set_location_assignment PIN_H8 -to hsmc_rx_p[6]
	set_location_assignment PIN_G8 -to hsmc_rx_n[6]	
	set_location_assignment PIN_F9 -to hsmc_rx_p[7]
	set_location_assignment PIN_F8 -to hsmc_rx_n[7]
	set_location_assignment PIN_F11 -to hsmc_rx_p[8]
	set_location_assignment PIN_E11 -to hsmc_rx_n[8]
	set_location_assignment PIN_B6 -to hsmc_rx_p[9]	
	set_location_assignment PIN_B5 -to hsmc_rx_n[9]	
	set_location_assignment PIN_E9 -to hsmc_rx_p[10]	
	set_location_assignment PIN_D9 -to hsmc_rx_n[10]		
	set_location_assignment PIN_E12 -to hsmc_rx_p[11]	
	set_location_assignment PIN_D12 -to hsmc_rx_n[11]		
	set_location_assignment PIN_D11 -to hsmc_rx_p[12]	
	set_location_assignment PIN_D10 -to hsmc_rx_n[12]	
	set_location_assignment PIN_C13 -to hsmc_rx_p[13]	
	set_location_assignment PIN_B12 -to hsmc_rx_n[13]	
	set_location_assignment PIN_F13 -to hsmc_rx_p[14]	
	set_location_assignment PIN_E13 -to hsmc_rx_n[14]	
	set_location_assignment PIN_H14 -to hsmc_rx_p[15]	
	set_location_assignment PIN_G13 -to hsmc_rx_n[15]
	set_location_assignment PIN_F15 -to hsmc_rx_p[16]	
	set_location_assignment PIN_F14 -to hsmc_rx_n[16]	
	
	
	set_location_assignment PIN_A9 -to hsmc_tx_p[0]
	set_location_assignment PIN_A8 -to hsmc_tx_n[0]	
	set_location_assignment PIN_E8 -to hsmc_tx_p[1]
	set_location_assignment PIN_D7 -to hsmc_tx_n[1]	
	set_location_assignment PIN_G7 -to hsmc_tx_p[2]
	set_location_assignment PIN_F6 -to hsmc_tx_n[2]	
	set_location_assignment PIN_D6 -to hsmc_tx_p[3]	
	set_location_assignment PIN_C5 -to hsmc_tx_n[3]		
	set_location_assignment PIN_D5 -to hsmc_tx_p[4]	
	set_location_assignment PIN_C4 -to hsmc_tx_n[4]	
	set_location_assignment PIN_E3 -to hsmc_tx_p[5]	
	set_location_assignment PIN_E2 -to hsmc_tx_n[5]
	set_location_assignment PIN_E4 -to hsmc_tx_p[6]
	set_location_assignment PIN_D4 -to hsmc_tx_n[6]
	set_location_assignment PIN_C3 -to hsmc_tx_p[7]	
	set_location_assignment PIN_B3 -to hsmc_tx_n[7]
	set_location_assignment PIN_D1 -to hsmc_tx_n[8]
	set_location_assignment PIN_E1 -to hsmc_tx_p[8]
	set_location_assignment PIN_D2 -to hsmc_tx_p[9]
	set_location_assignment PIN_C2 -to hsmc_tx_n[9]	
	set_location_assignment PIN_B1 -to hsmc_tx_p[10]
	set_location_assignment PIN_B2 -to hsmc_tx_n[10]
	set_location_assignment PIN_A4 -to hsmc_tx_p[11]
	set_location_assignment PIN_A3 -to hsmc_tx_n[11]		
	set_location_assignment PIN_A6 -to hsmc_tx_p[12]
	set_location_assignment PIN_A5 -to hsmc_tx_n[12]	
	set_location_assignment PIN_C7 -to hsmc_tx_p[13]
	set_location_assignment PIN_B7 -to hsmc_tx_n[13]		
	set_location_assignment PIN_C8 -to hsmc_tx_p[14]
	set_location_assignment PIN_B8 -to hsmc_tx_n[14]	
	set_location_assignment PIN_C12 -to hsmc_tx_p[15]
	set_location_assignment PIN_B11 -to hsmc_tx_n[15]		
	set_location_assignment PIN_B13 -to hsmc_tx_p[16]
	set_location_assignment PIN_A13 -to hsmc_tx_n[16]		

	set_location_assignment PIN_C10 -to hsmc_d[0]
	set_location_assignment PIN_C9 -to hsmc_d[2]
	set_location_assignment PIN_H13 -to hsmc_d[1]
	set_location_assignment PIN_H12 -to hsmc_d[3]

	set_location_assignment PIN_AA28 -to hsmc_scl
	set_location_assignment PIN_AE29 -to hsmc_sda
	
	set_location_assignment PIN_W25 -to user_dipsw_fpga[0]
	set_location_assignment PIN_V25 -to user_dipsw_fpga[1]
	set_location_assignment PIN_AC28 -to user_dipsw_fpga[2]
	set_location_assignment PIN_AC29 -to user_dipsw_fpga[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to user_dipsw_fpga[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to user_dipsw_fpga[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to user_dipsw_fpga[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to user_dipsw_fpga[3]
	set_location_assignment PIN_AF10 -to user_led_fpga[0]
	set_location_assignment PIN_AD10 -to user_led_fpga[1]
	set_location_assignment PIN_AE11 -to user_led_fpga[2]
	set_location_assignment PIN_AD7 -to user_led_fpga[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_led_fpga[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_led_fpga[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_led_fpga[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_led_fpga[3]
	set_location_assignment PIN_AE9 -to user_pb_fpga[0]
	set_location_assignment PIN_AE12 -to user_pb_fpga[1]
	set_location_assignment PIN_AD9 -to user_pb_fpga[2]
	set_location_assignment PIN_AD11 -to user_pb_fpga[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_pb_fpga[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_pb_fpga[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_pb_fpga[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to user_pb_fpga[1]


	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
