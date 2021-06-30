onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pwmmodulator_tb/reset
add wave -noupdate /pwmmodulator_tb/clock
add wave -noupdate -divider Controls
add wave -noupdate /pwmmodulator_tb/normaldirection
add wave -noupdate /pwmmodulator_tb/testmode
add wave -noupdate -radix decimal /pwmmodulator_tb/speed
add wave -noupdate -divider Outputs
add wave -noupdate /pwmmodulator_tb/forward
add wave -noupdate /pwmmodulator_tb/pwm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 229
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
WaveRestoreZoom {0 ps} {3150 us}
