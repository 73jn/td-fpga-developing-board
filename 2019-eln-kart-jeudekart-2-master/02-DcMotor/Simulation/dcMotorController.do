onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcmotorcontroller_tb/i_tb/testinfo
add wave -noupdate -expand -group {reset and clock} /dcmotorcontroller_tb/reset
add wave -noupdate -expand -group {reset and clock} /dcmotorcontroller_tb/clock
add wave -noupdate -group {I2C controls} /dcmotorcontroller_tb/sclin
add wave -noupdate -group {I2C controls} /dcmotorcontroller_tb/sdain
add wave -noupdate -group {I2C controls} /dcmotorcontroller_tb/i_dut/datavalid
add wave -noupdate -group {I2C controls} -radix hexadecimal /dcmotorcontroller_tb/i_dut/addr
add wave -noupdate -group {I2C controls} -radix hexadecimal /dcmotorcontroller_tb/i_dut/datain
add wave -noupdate -expand -group {Register data} -radix unsigned /dcmotorcontroller_tb/i_dut/prescaler
add wave -noupdate -expand -group {Register data} -radix decimal /dcmotorcontroller_tb/i_dut/speed
add wave -noupdate -expand -group {Register data} /dcmotorcontroller_tb/i_dut/hworientation(0)
add wave -noupdate -expand -group {Register data} /dcmotorcontroller_tb/i_dut/restart
add wave -noupdate -expand -group {Register data} /dcmotorcontroller_tb/i_dut/btconnected
add wave -noupdate /dcmotorcontroller_tb/i_dut/pwmen
add wave -noupdate -expand -group {DC motor control} /dcmotorcontroller_tb/forwards
add wave -noupdate -expand -group {DC motor control} /dcmotorcontroller_tb/pwm
add wave -noupdate -format Analog-Step -height 50 -max 14.999999999999998 -min -15.0 -radix decimal /dcmotorcontroller_tb/i_tb/motorspeed_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 263
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
