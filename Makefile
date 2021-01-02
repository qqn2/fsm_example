CLIBS := -work work
COPT := -cover sbcef2 -nocoverfec -covercells
C35PATH := C:/softslin/AMS_410_CDS/vital/c35/lib_questa107/c35_CORELIB

corelib:
	vlib c35_CORELIB
	vmap c35_CORELIB $(C35PATH)
clean :
	vlib work
compile_design : 
	vcom $(CLIBS) counter_oven.vhd
	vcom $(CLIBS) ctrl_oven.vhd
compile_netlist_binary : 
	vcom $(CLIBS) counter_oven.vhd
	vcom $(CLIBS) ctrl_oven_syn_binary.vhd
	vlog +define+TOP_TB+SYNTHESIS+SYNTHESIS_BINARY $(CLIBS) tb.sv
compile_netlist_grey :
	vcom $(CLIBS) counter_oven.vhd
	vcom $(CLIBS) ctrl_oven_syn_grey.vhd
	vlog +define+TOP_TB+SYNTHESIS+SYNTHESIS_GREY $(CLIBS) tb.sv
compile_netlist_onehot :  
	vcom $(CLIBS) counter_oven.vhd
	vcom $(CLIBS) ctrl_oven_syn_onehot.vhd
	vlog +define+TOP_TB+SYNTHESIS+SYNTHESIS_ONEHOT $(CLIBS) tb.sv
compile_testbench :
	vlog $(CLIBS) tb.sv
compile_tb_top:
	vlog +define+TOP_TB $(CLIBS) tb.sv
simu_top:
	vopt work.tb_ctrl_oven +acc -o juicy $(COPT)
	vsim juicy -vopt -coverage -do "do wave_top.do ; run 10000ns"
simu_ctrl:
	vopt work.tb_ctrl_oven +acc -o juicy2 $(COPT)
	vsim juicy2 -vopt -coverage -do "do wave_ctrl_tb.do; run 10000ns"
simu_netlist:
	vopt work.tb_ctrl_oven +acc -o juicy3 $(COPT)
	vsim juicy3 -vopt -coverage -do "do wave_top.do ; run 10000ns"
all_ctrl : 
	make clean compile_design compile_testbench simu_ctrl
all_top : 
	make clean compile_design compile_tb_top simu_top
all_syn_bin :
	make clean corelib compile_netlist_binary simu_netlist
all_syn_grey : 
	make clean corelib compile_netlist_grey simu_netlist
all_syn_onehot :
	make clean corelib compile_netlist_onehot simu_netlist