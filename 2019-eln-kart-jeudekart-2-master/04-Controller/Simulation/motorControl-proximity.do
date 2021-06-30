onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider BlueTooth
add wave -noupdate /motorcontrol_tb/bt_rxd
add wave -noupdate /motorcontrol_tb/bt_txd
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_tester/rs232txbyte
add wave -noupdate -radix unsigned /motorcontrol_tb/i_dut/i_commandinterface/addr
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/i_commandinterface/busdatain
add wave -noupdate /motorcontrol_tb/bt_reset
add wave -noupdate -divider {Proximity sensor}
add wave -noupdate /motorcontrol_tb/i_dut/sendstatus
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/ambientlight
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/proximity
add wave -noupdate -divider {I2C controller}
add wave -noupdate -format Analog-Step -height 20 -max 30.0 -radix unsigned /motorcontrol_tb/i_dut/i_i2cinterface/i_i2ccontroller/sequencecounter
add wave -noupdate -format Analog-Step -height 20 -max 5.0 -radix unsigned /motorcontrol_tb/i_dut/i_i2cinterface/i_i2ccontroller/readcounter
add wave -noupdate -format Analog-Step -height 20 -max 80.0 -radix unsigned /motorcontrol_tb/i_dut/i_commandinterface/i_serialportbusinterface/sequencecounter
add wave -noupdate -format Analog-Step -height 20 -max 5.0 -radix unsigned /motorcontrol_tb/i_dut/i_commandinterface/i_serialportbusinterface/writeitemcounter
add wave -noupdate -divider {I2C interface}
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/i_i2cinterface/txdata
add wave -noupdate /motorcontrol_tb/i_dut/i_i2cinterface/txsend
add wave -noupdate /motorcontrol_tb/i_dut/i_i2cinterface/txbusy
add wave -noupdate /motorcontrol_tb/i_dut/i_i2cinterface/rxdatavalid
add wave -noupdate -radix hexadecimal -subitemconfig {/motorcontrol_tb/i_dut/i_i2cinterface/rxdata(9) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(8) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(7) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(6) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(5) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(4) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(3) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(2) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(1) {-height 15 -radix hexadecimal} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata(0) {-height 15 -radix hexadecimal}} /motorcontrol_tb/i_dut/i_i2cinterface/rxdata
add wave -noupdate -divider {I2C protocol}
add wave -noupdate /motorcontrol_tb/i_sensor/currentstate
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_sensor/memoryaddress
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_sensor/currentword
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/i_i2cinterface/i_i2ccontroller/dataword
add wave -noupdate /motorcontrol_tb/sclin
add wave -noupdate /motorcontrol_tb/sdain
add wave -noupdate -divider Status
add wave -noupdate -radix hexadecimal /motorcontrol_tb/i_dut/i_commandinterface/txdata
add wave -noupdate /motorcontrol_tb/i_dut/i_commandinterface/txwr
add wave -noupdate /motorcontrol_tb/i_dut/i_commandinterface/txfull
add wave -noupdate -divider {Battery level}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000979474 ps} 0}
configure wave -namecolwidth 391
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
configure wave -timelineunits ms
update
WaveRestoreZoom {9988268701 ps} {10099752806 ps}
