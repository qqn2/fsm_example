corelib:
	vlib c35_CORELIB
	vmap c35_CORELIB C:/softslin/AMS_410_CDS/vital/c35/lib_questa107/c35_CORELIB
clean : 
	vlib work
compile_design : 
	vcom -work work counter_oven.vhd
	vcom -work work ctrl_oven.vhd
compile_netlist_binary : 
	vcom -work work counter_oven.vhd
	vcom -work work ctrl_oven_syn_binary.vhd
compile_netlist_grey :
	vcom -work work counter_oven.vhd
	vcom -work work ctrl_oven_syn_grey.vhd
compile_netlist_onehot :  
	vcom -work work counter_oven.vhd
	vcom -work work ctrl_oven_syn_onehot.vhd
compile_testbench :
	vcom -work work top.vhd
	vlog -work work tb.sv
top:
	vlog +define+TOP_TB -work work tb.sv
	
simu_top:
	vopt work.tb_ctrl_oven +acc -o juicy -cover sbcef2 -nocoverfec -covercells
	vsim juicy -vopt -coverage -do "do wave_top.do ; run 10000ns"
simu_ctrl:
	vopt work.tb_ctrl_oven +acc -o juicy2 -cover sbcef2 -nocoverfec -covercells
	vsim juicy2 -vopt -coverage -do "do wave_ctrl_tb.do; run 10000ns"
	# change config file later
simu_netlist:
	vopt work.tb_ctrl_oven +acc -o juicy3 -cover sbcef2 -nocoverfec -covercells
	vsim juicy3 -vopt -coverage -do "do wave_top.do ; run 10000ns"
all_ctrl : 
	make clean compile_design compile_testbench simu_ctrl
all_top : 
	make clean compile_design compile_testbench top simu_top
all_syn_bin :
	make clean corelib compile_netlist_binary compile_testbench top simu_netlist
all_syn_grey : 
	make clean corelib compile_netlist_grey compile_testbench top simu_netlist
all_syn_onehot :
	make clean corelib compile_netlist_onehot compile_testbench top simu_netlist