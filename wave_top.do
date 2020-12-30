onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/clk
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/reset
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/half_power
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/full_power
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/start
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/s30
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/s60
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/s120
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/time_set
add wave -noupdate -group Inputs /tb_ctrl_oven/my_top/door_open
add wave -noupdate -group Outputs /tb_ctrl_oven/my_top/full
add wave -noupdate -group Outputs /tb_ctrl_oven/my_top/half
add wave -noupdate -group Outputs /tb_ctrl_oven/my_top/finished
add wave -noupdate -group Outputs /tb_ctrl_oven/my_top/in_light
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_top/ctrl_start_count
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_top/ctrl_stop_count
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_top/top_counter_oven/aboveth
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_top/top_counter_oven/counter
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_top/top_counter_oven/counter_next
add wave -noupdate -group {FSM (ctrl and counter)} /tb_ctrl_oven/my_top/top_counter_oven/CS
add wave -noupdate -group {FSM (ctrl and counter)} /tb_ctrl_oven/my_top/top_counter_oven/NS
add wave -noupdate -group {FSM (ctrl and counter)} /tb_ctrl_oven/my_top/top_ctrl_oven/CS
add wave -noupdate -group {FSM (ctrl and counter)} /tb_ctrl_oven/my_top/top_ctrl_oven/NS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2530767 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 348
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {13755008 ps}
