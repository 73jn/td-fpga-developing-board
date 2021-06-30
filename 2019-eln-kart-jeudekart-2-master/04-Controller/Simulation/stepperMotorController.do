onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /steppermotorcontroller_tb/reset
add wave -noupdate /steppermotorcontroller_tb/clock
add wave -noupdate -divider RS232
add wave -noupdate /steppermotorcontroller_tb/bt_rxd
add wave -noupdate /steppermotorcontroller_tb/bt_txd
add wave -noupdate -divider {I2C Bus}
add wave -noupdate /steppermotorcontroller_tb/scl
add wave -noupdate /steppermotorcontroller_tb/sda
add wave -noupdate -divider {I2C command decoding}
add wave -noupdate /steppermotorcontroller_tb/i_dut/i_i2c/rxstate
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/chipaddr
add wave -noupdate /steppermotorcontroller_tb/i_dut/isselected
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/addr
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/datain
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/dataout
add wave -noupdate /steppermotorcontroller_tb/i_dut/datavalid
add wave -noupdate /steppermotorcontroller_tb/i_dut/writeregs
add wave -noupdate -divider {DUT registers}
add wave -noupdate -radix hexadecimal -subitemconfig {/steppermotorcontroller_tb/i_dut/prescaler(15) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(14) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(13) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(12) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(11) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(10) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(9) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(8) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(7) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(6) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(5) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(4) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(3) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(2) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(1) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/prescaler(0) {-radix hexadecimal}} /steppermotorcontroller_tb/i_dut/prescaler
add wave -noupdate -radix hexadecimal -subitemconfig {/steppermotorcontroller_tb/i_dut/targetangle(15) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(14) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(13) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(12) {-radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(11) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(10) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(9) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(8) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(7) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(6) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(5) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(4) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(3) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(2) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(1) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_dut/targetangle(0) {-height 15 -radix hexadecimal}} /steppermotorcontroller_tb/i_dut/targetangle
add wave -noupdate /steppermotorcontroller_tb/i_dut/hworientation
add wave -noupdate -format Analog-Step -height 30 -max 4096.0 -radix hexadecimal /steppermotorcontroller_tb/i_dut/actualangle
add wave -noupdate /steppermotorcontroller_tb/i_dut/reached
add wave -noupdate /steppermotorcontroller_tb/i_dut/stepperendbus
add wave -noupdate -divider {I2C data reception}
add wave -noupdate -divider {Stepper motor}
add wave -noupdate /steppermotorcontroller_tb/stepperend
add wave -noupdate /steppermotorcontroller_tb/i_dut/stepperendor
add wave -noupdate /steppermotorcontroller_tb/i_dut/stepen
add wave -noupdate /steppermotorcontroller_tb/coil1
add wave -noupdate /steppermotorcontroller_tb/coil2
add wave -noupdate /steppermotorcontroller_tb/coil3
add wave -noupdate /steppermotorcontroller_tb/coil4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 300
configure wave -valuecolwidth 45
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
WaveRestoreZoom {0 ps} {15689789666 ps}
