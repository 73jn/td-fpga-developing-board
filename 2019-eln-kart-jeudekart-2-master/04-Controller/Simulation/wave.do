onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /steppermotorcontroller_tb/reset
add wave -noupdate /steppermotorcontroller_tb/clock
add wave -noupdate -divider RS232
add wave -noupdate /steppermotorcontroller_tb/bt_rxd
add wave -noupdate /steppermotorcontroller_tb/bt_txd
add wave -noupdate /steppermotorcontroller_tb/scl
add wave -noupdate /steppermotorcontroller_tb/sda
add wave -noupdate -divider {I2C Bus}
add wave -noupdate /steppermotorcontroller_tb/i_dut/writeregs
add wave -noupdate -radix unsigned /steppermotorcontroller_tb/i_dut/prescaler
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/targetangle
add wave -noupdate /steppermotorcontroller_tb/i_dut/stepen
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/actualangle
add wave -noupdate /steppermotorcontroller_tb/i_dut/stepperendor
add wave -noupdate /steppermotorcontroller_tb/i_dut/i_i2c/rxstate
add wave -noupdate /steppermotorcontroller_tb/i_dut/isselected
add wave -noupdate /steppermotorcontroller_tb/i_dut/i_i2c/i2cbytevalid
add wave -noupdate /steppermotorcontroller_tb/i_dut/i_i2c/ensdaout
add wave -noupdate /steppermotorcontroller_tb/i_dut/datavalid
add wave -noupdate /steppermotorcontroller_tb/i_dut/i_i2c/writemode
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/addr
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/datain
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_dut/dataout
add wave -noupdate -divider regs
add wave -noupdate /steppermotorcontroller_tb/i_mst/rxrd
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_mst/rxdata
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_mst/i_i2cseq/txaddress
add wave -noupdate /steppermotorcontroller_tb/i_mst/i_i2cseq/rxstate
add wave -noupdate /steppermotorcontroller_tb/i_mst/updatetxreg
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_mst/regtxaddr
add wave -noupdate -radix hexadecimal /steppermotorcontroller_tb/i_mst/regtxdata
add wave -noupdate -radix hexadecimal -subitemconfig {/steppermotorcontroller_tb/i_mst/i_txregs/registerset(15) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(14) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(13) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(12) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(11) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(10) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(9) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(8) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(7) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(6) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(5) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(4) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(3) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(2) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(1) {-height 15 -radix hexadecimal} /steppermotorcontroller_tb/i_mst/i_txregs/registerset(0) {-height 15 -radix hexadecimal}} /steppermotorcontroller_tb/i_mst/i_txregs/registerset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2415434229 ps} 0} {{Cursor 2} {2035058458 ps} 0}
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
WaveRestoreZoom {2374951327 ps} {2459973451 ps}
