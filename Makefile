clean : 
	vdel work
compile : 
	vlib work
	vcom -work work counter_oven.vhd
	vcom -work work ctrl_oven.vhd
	vcom -work work top.vhd
	vlog -work work tb.sv
top:
	vlog +define+TOP_TB -work work tb.sv


simu_top:
	vopt work.tb_ctrl_oven +acc -o juicy -cover sbcef2 -nocoverfec -covercells
	vsim juicy -vopt -coverage -do "wave_top.do ; run 10000ns"

simu_ctrl:
	vopt work.tb_ctrl_oven +acc -o juicy2 -cover sbcef2 -nocoverfec -covercells
	vsim juicy2 -vopt -coverage -do "do wave_ctrl_tb.do; run 10000ns"
	
all_ctrl : 
	make compile simu_ctrl

all_top : 
	make compile top simu_top