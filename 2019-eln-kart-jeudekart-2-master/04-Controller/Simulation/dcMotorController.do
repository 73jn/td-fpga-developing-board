onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcmotorcontroller_tb/reset
add wave -noupdate /dcmotorcontroller_tb/clock
add wave -noupdate -divider RS232
add wave -noupdate /dcmotorcontroller_tb/bt_txd
add wave -noupdate /dcmotorcontroller_tb/bt_rxd
add wave -noupdate -divider {I2C Bus}
add wave -noupdate /dcmotorcontroller_tb/scl
add wave -noupdate /dcmotorcontroller_tb/sda
add wave -noupdate -divider {I2C command decoding}
add wave -noupdate -radix hexadecimal /dcmotorcontroller_tb/i_dut/chipaddr
add wave -noupdate /dcmotorcontroller_tb/i_dut/isselected
add wave -noupdate -radix hexadecimal /dcmotorcontroller_tb/i_dut/addr
add wave -noupdate -radix hexadecimal -subitemconfig {/dcmotorcontroller_tb/i_dut/datain(7) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(6) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(5) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(4) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(3) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(2) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(1) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/datain(0) {-radix hexadecimal}} /dcmotorcontroller_tb/i_dut/datain
add wave -noupdate /dcmotorcontroller_tb/i_dut/datavalid
add wave -noupdate /dcmotorcontroller_tb/i_dut/writedata
add wave -noupdate -divider {DUT registers}
add wave -noupdate -radix unsigned /dcmotorcontroller_tb/i_dut/prescaler
add wave -noupdate -radix decimal -subitemconfig {/dcmotorcontroller_tb/i_dut/speed(4) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/speed(3) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/speed(2) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/speed(1) {-radix hexadecimal} /dcmotorcontroller_tb/i_dut/speed(0) {-radix hexadecimal}} /dcmotorcontroller_tb/i_dut/speed
add wave -noupdate /dcmotorcontroller_tb/i_dut/hworientation
add wave -noupdate -divider {DC motor}
add wave -noupdate /dcmotorcontroller_tb/i_dut/pwmen
add wave -noupdate /dcmotorcontroller_tb/i_dut/pwm
add wave -noupdate /dcmotorcontroller_tb/i_dut/forwards
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
WaveRestoreZoom {0 ps} {15750 us}
