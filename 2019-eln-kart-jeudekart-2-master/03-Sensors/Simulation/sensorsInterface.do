onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate /sensorsinterface_tb/i_tb/testinfo
add wave -noupdate -group {reset and clock} /sensorsinterface_tb/clock
add wave -noupdate -group {reset and clock} /sensorsinterface_tb/reset
add wave -noupdate -group I2C /sensorsinterface_tb/sclin
add wave -noupdate -group I2C /sensorsinterface_tb/sdain
add wave -noupdate -group I2C -radix hexadecimal /sensorsinterface_tb/i_dut/addr
add wave -noupdate -group I2C -radix hexadecimal /sensorsinterface_tb/i_dut/dataout
add wave -noupdate -group I2C /sensorsinterface_tb/i_dut/datavalid
add wave -noupdate -group I2C /sensorsinterface_tb/i_dut/i_i2c/isselected
add wave -noupdate -group I2C /sensorsinterface_tb/i_dut/writedata
add wave -noupdate -group I2C -radix hexadecimal /sensorsinterface_tb/i_dut/datain
add wave -noupdate -group I2C /sensorsinterface_tb/i_tb/i2cregistersin
add wave -noupdate /sensorsinterface_tb/leds
add wave -noupdate -group {Hall sensor} -expand /sensorsinterface_tb/hallpulses
add wave -noupdate -group {Hall sensor} -radix unsigned -subitemconfig {/sensorsinterface_tb/i_dut/i_hall/counterset(1) {-radix unsigned} /sensorsinterface_tb/i_dut/i_hall/counterset(2) {-radix unsigned}} /sensorsinterface_tb/i_dut/i_hall/counterset
add wave -noupdate -group {Hall sensor} /sensorsinterface_tb/i_tb/duthallcounters
add wave -noupdate -group {Hall sensor} /sensorsinterface_tb/i_tb/tbhallcounters
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/i_dut/i_range/rangerstate
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/i_dut/i_range/sendpulseen
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/i_dut/i_range/restartpulsecounter
add wave -noupdate -group {Ultrasound ranger} -format Analog-Step -height 30 -max 1000.0 -radix unsigned /sensorsinterface_tb/i_dut/i_range/pulsecounter
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/distancestart
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/distancepulse
add wave -noupdate -group {Ultrasound ranger} -radix unsigned /sensorsinterface_tb/i_dut/rangerdistance
add wave -noupdate -group {Ultrasound ranger} /sensorsinterface_tb/i_tb/dutrangerdistance
add wave -noupdate -group {Ultrasound ranger} -radix unsigned /sensorsinterface_tb/i_tb/tbrangerdistance
add wave -noupdate -group {Proximity sensors} /sensorsinterface_tb/i_dut/proxystart
add wave -noupdate -group {Proximity sensors} /sensorsinterface_tb/proxyscl(1)
add wave -noupdate -group {Proximity sensors} /sensorsinterface_tb/proxysdaout(1)
add wave -noupdate -group {Proximity sensors} /sensorsinterface_tb/proxysdain
add wave -noupdate -group {Proximity sensors} -radix hexadecimal -subitemconfig {/sensorsinterface_tb/i_dut/proxylight(31) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(30) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(29) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(28) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(27) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(26) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(25) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(24) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(23) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(22) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(21) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(20) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(19) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(18) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(17) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(16) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(15) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(14) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(13) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(12) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(11) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(10) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(9) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(8) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(7) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(6) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(5) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(4) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(3) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(2) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(1) {-radix unsigned} /sensorsinterface_tb/i_dut/proxylight(0) {-radix unsigned}} /sensorsinterface_tb/i_dut/proxylight
add wave -noupdate -group {Proximity sensors} -radix hexadecimal -subitemconfig {/sensorsinterface_tb/i_dut/i_regs/lightset(1) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(15) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(14) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(13) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(12) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(11) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(10) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(9) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(8) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(7) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(6) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(5) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(4) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(3) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(2) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(1) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(1)(0) {-radix hexadecimal} /sensorsinterface_tb/i_dut/i_regs/lightset(2) {-radix hexadecimal}} /sensorsinterface_tb/i_dut/i_regs/lightset
add wave -noupdate -group {Proximity sensors} -radix hexadecimal /sensorsinterface_tb/i_dut/proxydistance
add wave -noupdate -group {Proximity sensors} -radix hexadecimal /sensorsinterface_tb/i_dut/i_regs/proximityset
add wave -noupdate -group {Proximity sensors} -radix hexadecimal /sensorsinterface_tb/i_dut/addr
add wave -noupdate -group {Proximity sensors} -radix hexadecimal /sensorsinterface_tb/i_dut/datain
add wave -noupdate -expand -group {End switches} /sensorsinterface_tb/endswitches
add wave -noupdate -expand -group {End switches} /sensorsinterface_tb/i_tb/dutendswitches
add wave -noupdate -expand -group {End switches} /sensorsinterface_tb/i_tb/tbendswitches
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 325
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1890 us}
