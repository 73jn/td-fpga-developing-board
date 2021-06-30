onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /coilcontrol_tb/reset
add wave -noupdate -format Logic /coilcontrol_tb/clock
add wave -noupdate -divider Controls
add wave -noupdate -format Logic /coilcontrol_tb/encoils
add wave -noupdate -format Logic /coilcontrol_tb/direction
add wave -noupdate -format Logic /coilcontrol_tb/step
add wave -noupdate -divider Coils
add wave -noupdate -format Logic /coilcontrol_tb/coil1
add wave -noupdate -format Logic /coilcontrol_tb/coil2
add wave -noupdate -format Logic /coilcontrol_tb/coil3
add wave -noupdate -format Logic /coilcontrol_tb/coil4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 233
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {22050 ns}
run 20 us
