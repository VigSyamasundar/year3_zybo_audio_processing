vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm
vlib msim/dist_mem_gen_v8_0_11

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm
vmap dist_mem_gen_v8_0_11 msim/dist_mem_gen_v8_0_11

vlog -work xil_defaultlib -64 -incr -sv \
"D:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work dist_mem_gen_v8_0_11 -64 -incr \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../../ZyboAudio.srcs/sources_1/ip/dist_mem_gen_1/sim/dist_mem_gen_1.v" \


vlog -work xil_defaultlib "glbl.v"

