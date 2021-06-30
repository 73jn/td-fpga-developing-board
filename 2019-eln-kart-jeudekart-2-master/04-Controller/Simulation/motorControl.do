onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider BlueTooth
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_tester/rs232rxhexstring
add wave -noupdate /motorcontrol_tb/bt_rxd
add wave -noupdate /motorcontrol_tb/bt_txd
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_tester/rs232txbyte
add wave -noupdate /motorcontrol_tb/bt_reset
add wave -noupdate -divider Registers
add wave -noupdate /motorcontrol_tb/i_dut/dctestmode
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/dcspeed
add wave -noupdate /motorcontrol_tb/i_dut/stepperenddeglitched
add wave -noupdate -divider {DC motor}
add wave -noupdate -radix decimal -subitemconfig {/motorcontrol_tb/i_dut/dcspeed(4) {-radix decimal} /motorcontrol_tb/i_dut/dcspeed(3) {-radix decimal} /motorcontrol_tb/i_dut/dcspeed(2) {-radix decimal} /motorcontrol_tb/i_dut/dcspeed(1) {-radix decimal} /motorcontrol_tb/i_dut/dcspeed(0) {-radix decimal}} /motorcontrol_tb/i_dut/dcspeed
add wave -noupdate /motorcontrol_tb/i_dut/dctestmode
add wave -noupdate /motorcontrol_tb/dc_pwm
add wave -noupdate /motorcontrol_tb/dc_forwards
add wave -noupdate -divider {Stepper motor}
add wave -noupdate /motorcontrol_tb/i_dut/i_anglecontrol/reached
add wave -noupdate /motorcontrol_tb/stepper_end
add wave -noupdate /motorcontrol_tb/i_dut/stepperenddeglitched
add wave -noupdate /motorcontrol_tb/stepper_coil1
add wave -noupdate /motorcontrol_tb/stepper_coil2
add wave -noupdate /motorcontrol_tb/stepper_coil3
add wave -noupdate /motorcontrol_tb/stepper_coil4
add wave -noupdate -divider LEDs
add wave -noupdate /motorcontrol_tb/user_leds
add wave -noupdate -divider {Battery level}
add wave -noupdate -radix unsigned /motorcontrol_tb/i_dut/batterylevel
add wave -noupdate /motorcontrol_tb/i_dut/i_commandinterface/sendstatus
add wave -noupdate -divider Status
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/i_commandinterface/txdata
add wave -noupdate /motorcontrol_tb/i_dut/i_commandinterface/txwr
add wave -noupdate /motorcontrol_tb/i_dut/i_commandinterface/txfull
add wave -noupdate -radix unsigned /motorcontrol_tb/i_dut/i_commandinterface/i1/registercounter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 360
configure wave -valuecolwidth 78
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {5250 us}
