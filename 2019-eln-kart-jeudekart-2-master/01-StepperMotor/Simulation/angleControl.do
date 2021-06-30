onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate /anglecontrol_tb/reset
add wave -noupdate /anglecontrol_tb/clock
add wave -noupdate -divider Controls
add wave -noupdate /anglecontrol_tb/clockwise
add wave -noupdate -radix unsigned /anglecontrol_tb/sensorleft
add wave -noupdate -radix unsigned /anglecontrol_tb/target
add wave -noupdate /anglecontrol_tb/stepperend
add wave -noupdate /anglecontrol_tb/enstep
add wave -noupdate -divider Outputs
add wave -noupdate /anglecontrol_tb/coil1
add wave -noupdate /anglecontrol_tb/coil2
add wave -noupdate /anglecontrol_tb/coil3
add wave -noupdate /anglecontrol_tb/coil4
add wave -noupdate -radix decimal /anglecontrol_tb/actual
add wave -noupdate -format Analog-Step -height 30 -max 20.0 -radix decimal /anglecontrol_tb/actual
add wave -noupdate /anglecontrol_tb/reached
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
WaveRestoreZoom {0 ps} {525 us}
