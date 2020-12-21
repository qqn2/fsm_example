onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ctrl_oven/emulate_count
add wave -noupdate /tb_ctrl_oven/time_chosen
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/clk
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/reset
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/half_power
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/full_power
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/start
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/s30
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/s60
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/s120
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/time_set
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/door_open
add wave -noupdate -expand -group Inputs /tb_ctrl_oven/timeout
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/full
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/half
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/finished
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/in_light
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/start_count
add wave -noupdate -expand -group Outputs /tb_ctrl_oven/stop_count
add wave -noupdate -expand -group FSM /tb_ctrl_oven/my_ctrl_oven/CS
add wave -noupdate -expand -group FSM /tb_ctrl_oven/my_ctrl_oven/NS
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_ctrl_oven/time_selected
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_ctrl_oven/stop_count
add wave -noupdate -group {Internal Signals} /tb_ctrl_oven/my_ctrl_oven/stop_count_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {811353 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 186
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
WaveRestoreZoom {0 ps} {850500 ps}
