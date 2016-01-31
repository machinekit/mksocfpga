vlib work
vmap work work

vlog ../verification_lib/verbosity_pkg.sv
vlog ../single_clk_ram.sv
vlog ../demo_axi_memory.sv
vlog tb_mem.sv

vsim -novopt tb_mem

#add waveforms
do mem.do

run 10 us
