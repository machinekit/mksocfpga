onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mem/dut/clk
add wave -noupdate /tb_mem/dut/reset_n
add wave -noupdate /tb_mem/com
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_address
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_byteenable
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_read
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_readdata
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_waitrequest
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_write
add wave -noupdate -group {av bus} -radix hexadecimal /tb_mem/dut/avs_writedata
add wave -noupdate -expand -group aw_bus /tb_mem/com
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awvalid
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awready
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awaddr
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awid
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awburst
add wave -noupdate -expand -group aw_bus -radix hexadecimal /tb_mem/dut/axs_awlen
add wave -noupdate -expand -group aw_bus -group {more aw} -radix hexadecimal /tb_mem/dut/axs_awsize
add wave -noupdate -expand -group aw_bus -group {more aw} -radix hexadecimal /tb_mem/dut/axs_awcache
add wave -noupdate -expand -group aw_bus -group {more aw} -radix hexadecimal /tb_mem/dut/axs_awlock
add wave -noupdate -expand -group aw_bus -group {more aw} -radix hexadecimal /tb_mem/dut/axs_awprot
add wave -noupdate -group {wr addr regs} /tb_mem/com
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwaddr[7]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwlen[7]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwaddr[3]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwlen[3]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwaddr[1]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal {/tb_mem/dut/xwlen[1]}
add wave -noupdate -group {wr addr regs} -radix hexadecimal /tb_mem/dut/xwaddval
add wave -noupdate -group {wr addr regs} -radix hexadecimal /tb_mem/dut/clrwaddval
add wave -noupdate -group {wr addr regs} -group more -radix hexadecimal /tb_mem/dut/xwaddr
add wave -noupdate -group {wr addr regs} -group more -radix hexadecimal /tb_mem/dut/xwlen
add wave -noupdate -expand -group {wdata bus} /tb_mem/com
add wave -noupdate -expand -group {wdata bus} /tb_mem/dut/axs_wvalid
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/axs_wready
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/axs_wlast
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/axs_wdata
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/axs_wid
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/axs_wstrb
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/wstate
add wave -noupdate -expand -group {wdata bus} -radix hexadecimal /tb_mem/dut/inc_waddr
add wave -noupdate -expand -group {wdata bus} /tb_mem/dut/ctl_write
add wave -noupdate -expand -group {wdata bus} -group ram_io -radix hexadecimal /tb_mem/dut/sc_ram0/clk
add wave -noupdate -expand -group {wdata bus} -group ram_io -radix hexadecimal /tb_mem/dut/sc_ram0/rd_addr
add wave -noupdate -expand -group {wdata bus} -group ram_io -radix hexadecimal /tb_mem/dut/sc_ram0/q
add wave -noupdate -expand -group {wdata bus} -group ram_io -radix hexadecimal /tb_mem/dut/sc_ram0/we
add wave -noupdate -expand -group {wdata bus} -group ram_io -radix hexadecimal /tb_mem/dut/sc_ram0/wr_addr
add wave -noupdate -radix hexadecimal /tb_mem/dut/sc_ram0/d
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[0]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[1]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[2]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[3]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[4]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[5]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[6]}
add wave -noupdate -group sc_ram -expand -group 0-7 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[7]}
add wave -noupdate -group sc_ram -group 48-51 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[48]}
add wave -noupdate -group sc_ram -group 48-51 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[49]}
add wave -noupdate -group sc_ram -group 48-51 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[50]}
add wave -noupdate -group sc_ram -group 48-51 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[51]}
add wave -noupdate -group sc_ram -group 80-83 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[80]}
add wave -noupdate -group sc_ram -group 80-83 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[81]}
add wave -noupdate -group sc_ram -group 80-83 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[82]}
add wave -noupdate -group sc_ram -group 80-83 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[83]}
add wave -noupdate -group sc_ram -group 64-67 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[64]}
add wave -noupdate -group sc_ram -group 64-67 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[65]}
add wave -noupdate -group sc_ram -group 64-67 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[66]}
add wave -noupdate -group sc_ram -group 64-67 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[67]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[256]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[257]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[258]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[259]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[260]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[261]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[262]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[263]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[264]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[265]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[266]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[267]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[268]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[269]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[270]}
add wave -noupdate -group sc_ram -expand -group 256-271 -radix hexadecimal {/tb_mem/dut/sc_ram0/mem[271]}
add wave -noupdate -group sc_ram -group {ram i/o} -radix hexadecimal /tb_mem/dut/scr_din
add wave -noupdate -group sc_ram -group {ram i/o} -radix hexadecimal /tb_mem/dut/scr_dout
add wave -noupdate -group sc_ram -group {ram i/o} -radix hexadecimal /tb_mem/dut/scr_rd_addr
add wave -noupdate -group sc_ram -group {ram i/o} -radix hexadecimal /tb_mem/dut/scr_we
add wave -noupdate -group sc_ram -group {ram i/o} -radix hexadecimal /tb_mem/dut/scr_wr_addr
add wave -noupdate -group {wr resp bus} /tb_mem/dut/axs_bvalid
add wave -noupdate -group {wr resp bus} /tb_mem/dut/axs_bready
add wave -noupdate -group {wr resp bus} -radix hexadecimal /tb_mem/dut/axs_bid
add wave -noupdate -group {wr resp bus} -radix hexadecimal /tb_mem/dut/axs_bresp
add wave -noupdate -group {wr resp bus} /tb_mem/dut/wrt_ok
add wave -noupdate -group {wr resp bus} /tb_mem/dut/wrt_resp
add wave -noupdate -group {data regs} -radix hexadecimal {/tb_mem/dut/xwdata[7]}
add wave -noupdate -group {data regs} -radix hexadecimal {/tb_mem/dut/xwdata[3]}
add wave -noupdate -group {data regs} -radix hexadecimal {/tb_mem/dut/xwdata[1]}
add wave -noupdate -group {data regs} -group more -radix hexadecimal /tb_mem/dut/xwdataval
add wave -noupdate -group {data regs} -group more -radix hexadecimal /tb_mem/dut/xwdata
add wave -noupdate -expand -group ar_bus /tb_mem/com
add wave -noupdate -expand -group ar_bus -radix hexadecimal /tb_mem/dut/axs_arvalid
add wave -noupdate -expand -group ar_bus -radix hexadecimal /tb_mem/dut/axs_arready
add wave -noupdate -expand -group ar_bus -radix hexadecimal /tb_mem/dut/axs_araddr
add wave -noupdate -expand -group ar_bus -radix hexadecimal /tb_mem/dut/axs_arid
add wave -noupdate -expand -group ar_bus -radix hexadecimal /tb_mem/dut/axs_arlen
add wave -noupdate -expand -group ar_bus -group more -radix hexadecimal /tb_mem/dut/axs_arburst
add wave -noupdate -expand -group ar_bus -group more -radix hexadecimal /tb_mem/dut/axs_arsize
add wave -noupdate -expand -group ar_bus -group more -radix hexadecimal /tb_mem/dut/axs_arcache
add wave -noupdate -expand -group ar_bus -group more -radix hexadecimal /tb_mem/dut/axs_arlock
add wave -noupdate -expand -group ar_bus -group more -radix hexadecimal /tb_mem/dut/axs_arprot
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xraddr[9]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xrlen[9]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xraddr[3]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xrlen[3]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xrlen[2]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xraddr[2]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xraddr[1]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal {/tb_mem/dut/xrlen[1]}
add wave -noupdate -expand -group {rd addr regs} -radix hexadecimal /tb_mem/dut/xraddval
add wave -noupdate -expand -group {rd addr regs} -group more -radix hexadecimal /tb_mem/dut/xraddr
add wave -noupdate -expand -group {rd addr regs} -group more -radix hexadecimal /tb_mem/dut/xrburst
add wave -noupdate -expand -group {rd addr regs} -group more -radix hexadecimal /tb_mem/dut/xrlen
add wave -noupdate -expand -group {rd addr regs} -group more -radix hexadecimal /tb_mem/dut/xrsize
add wave -noupdate -expand -group {rdata bus} /tb_mem/com
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/rstate
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/nextword
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/fcount_d
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/fcount
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/sc_ram0/rd_addr
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/sc_ram0/q
add wave -noupdate -expand -group {rdata bus} /tb_mem/dut/ppl_buff
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/axs_rdata
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/axs_rvalid
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/axs_rready
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/axs_rlast
add wave -noupdate -expand -group {rdata bus} -radix hexadecimal /tb_mem/dut/axs_rid
add wave -noupdate -expand -group {rdata bus} /tb_mem/cval
add wave -noupdate /tb_mem/dut/clk
add wave -noupdate -radix hexadecimal /tb_mem/dut/aso_data
add wave -noupdate -radix hexadecimal /tb_mem/dut/aso_valid
add wave -noupdate -radix hexadecimal /tb_mem/dut/aso_ready
add wave -noupdate /tb_mem/dut/sreq
add wave -noupdate -radix hexadecimal /tb_mem/dut/saddr
add wave -noupdate /tb_mem/dut/pgrant
add wave -noupdate -radix hexadecimal /tb_mem/dut/scr_rd_addr
add wave -noupdate -radix hexadecimal /tb_mem/dut/sgrant
add wave -noupdate -radix hexadecimal /tb_mem/dut/scr_dout
add wave -noupdate /tb_mem/dut/clk
add wave -noupdate /tb_mem/dut/reset_n
add wave -noupdate -radix hexadecimal /tb_mem/dut/sc_ram0/d
add wave -noupdate /tb_mem/dut/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2248420 ps} 0} {{Cursor 2} {1100978 ps} 0}
configure wave -namecolwidth 225
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2078530 ps} {2293927 ps}
