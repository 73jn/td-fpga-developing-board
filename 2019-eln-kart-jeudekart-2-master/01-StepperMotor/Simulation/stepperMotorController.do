onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate /steppermotorcontroller_tb/i_tb/testinfo
add wave -noupdate -expand -group {Reset and clock} /steppermotorcontroller_tb/reset
add wave -noupdate -expand -group {Reset and clock} /steppermotorcontroller_tb/clock
add wave -noupdate /steppermotorcontroller_tb/stepperend
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/i_tb/i2cdone
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/scl
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/sda
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/sclin
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/sdain
add wave -noupdate -group {I2C signals} /steppermotorcontroller_tb/sdaout
add wave -noupdate -group {I2C sequence} /steppermotorcontroller_tb/i_dut/writeregs
add wave -noupdate -group {I2C sequence} /steppermotorcontroller_tb/i_dut/datavalid
add wave -noupdate -group {I2C sequence} -radix hexadecimal /steppermotorcontroller_tb/i_dut/addr
add wave -noupdate -group {I2C sequence} -radix hexadecimal /steppermotorcontroller_tb/i_dut/datain
add wave -noupdate -group {I2C sequence} -radix hexadecimal /steppermotorcontroller_tb/i_dut/dataout
add wave -noupdate -group {I2C sequence} -radix hexadecimal /steppermotorcontroller_tb/i_tb/i2cdatain
add wave -noupdate -group {Register data} -radix decimal /steppermotorcontroller_tb/i_dut/clockdivider
add wave -noupdate -group {Register data} -radix unsigned /steppermotorcontroller_tb/i_dut/targetangle
add wave -noupdate -group {Register data} /steppermotorcontroller_tb/i_dut/restart
add wave -noupdate -group {Register data} /steppermotorcontroller_tb/i_dut/hworientation
add wave -noupdate -group {Register data} /steppermotorcontroller_tb/i_dut/stepperendbus
add wave -noupdate -expand -group {Motor controls} /steppermotorcontroller_tb/i_dut/restart
add wave -noupdate -expand -group {Motor controls} /steppermotorcontroller_tb/i_dut/stepperendor
add wave -noupdate -expand -group {Motor controls} -radix unsigned -subitemconfig {/steppermotorcontroller_tb/i_dut/targetangle(11) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(10) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(9) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(8) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(7) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(6) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(5) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(4) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(3) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(2) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(1) {-radix unsigned} /steppermotorcontroller_tb/i_dut/targetangle(0) {-radix unsigned}} /steppermotorcontroller_tb/i_dut/targetangle
add wave -noupdate -expand -group {Motor controls} -format Analog-Step -height 74 -max 999.99999999999989 -radix unsigned /steppermotorcontroller_tb/i_dut/actualangle
add wave -noupdate -expand -group {Motor controls} /steppermotorcontroller_tb/i_dut/reached
add wave -noupdate -expand -group {Motor controls} /steppermotorcontroller_tb/i_dut/stepen
add wave -noupdate -expand -group Coils /steppermotorcontroller_tb/coil1
add wave -noupdate -expand -group Coils /steppermotorcontroller_tb/coil2
add wave -noupdate -expand -group Coils /steppermotorcontroller_tb/coil3
add wave -noupdate -expand -group Coils /steppermotorcontroller_tb/coil4
add wave -noupdate -expand -group {Coils verification} /steppermotorcontroller_tb/i_tb/turn1to4
add wave -noupdate -expand -group {Coils verification} /steppermotorcontroller_tb/i_tb/ontime
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {3150 us}
