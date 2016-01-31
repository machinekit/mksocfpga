# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1


set make_assignments 1
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

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_b[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_blank_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_g[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_hs
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_r[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_sync_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" to vga_vs 	
	
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

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_adcdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_adclrck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_bclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_dacdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_daclrck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_i2c_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_i2c_sdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_mute
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_xck

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

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_n[7]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_rx_p[7]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_n[7]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsmc_gxb_tx_p[7]

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
    
}   
    