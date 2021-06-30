onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_tb/reset
add wave -noupdate /fifo_tb/clock
add wave -noupdate -divider Inputs
add wave -noupdate -radix hexadecimal /fifo_tb/datain
add wave -noupdate /fifo_tb/write
add wave -noupdate /fifo_tb/full
add wave -noupdate -divider Internals
add wave -noupdate -radix unsigned /fifo_tb/i_dut/writecounter
add wave -noupdate -radix unsigned /fifo_tb/i_dut/readcounter
add wave -noupdate /fifo_tb/i_dut/fifostate
add wave -noupdate -radix hexadecimal -subitemconfig {/fifo_tb/i_dut/memoryarray(0) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(1) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(2) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(3) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(4) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(5) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(6) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(7) {-height 15 -radix hexadecimal}} -expand -subitemconfig {/fifo_tb/i_dut/memoryarray(0) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(1) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(2) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(3) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(4) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(5) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(6) {-height 15 -radix hexadecimal} /fifo_tb/i_dut/memoryarray(7) {-height 15 -radix hexadecimal}} /fifo_tb/i_dut/memoryarray
add wave -noupdate -divider Outputs
add wave -noupdate -radix hexadecimal /fifo_tb/dataout
add wave -noupdate /fifo_tb/empty
add wave -noupdate /fifo_tb/read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1407775 ps} 0}
configure wave -namecolwidth 180
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
WaveRestoreZoom {0 ps} {2854739 ps}
