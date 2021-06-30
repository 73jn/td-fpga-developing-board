onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /kartcontrol_tb/i_tester/testitemcount
add wave -noupdate /kartcontrol_tb/i_tester/testitemcomment
add wave -noupdate -group {Reset & clock} /kartcontrol_tb/reset
add wave -noupdate -group {Reset & clock} /kartcontrol_tb/clock
add wave -noupdate -group RS232 /kartcontrol_tb/bt_txd
add wave -noupdate -group RS232 -radix hexadecimal /kartcontrol_tb/i_tester/rs232rxbyte
add wave -noupdate -group RS232 /kartcontrol_tb/bt_rxd
add wave -noupdate -group RS232 -radix hexadecimal /kartcontrol_tb/i_tester/rs232txbyte
add wave -noupdate -group RS232 /kartcontrol_tb/i_tester/receivedaddress
add wave -noupdate -group RS232 /kartcontrol_tb/i_tester/receiveddata
add wave -noupdate -group I2C -radix hexadecimal /kartcontrol_tb/i_dcm/addr
add wave -noupdate -group I2C -radix hexadecimal -subitemconfig {/kartcontrol_tb/i_dcm/datain(7) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(6) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(5) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(4) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(3) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(2) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(1) {-radix hexadecimal} /kartcontrol_tb/i_dcm/datain(0) {-radix hexadecimal}} /kartcontrol_tb/i_dcm/datain
add wave -noupdate -group I2C /kartcontrol_tb/i_dcm/datavalid
add wave -noupdate -group I2C /kartcontrol_tb/i_dcm/writedata
add wave -noupdate -group Registers -radix hexadecimal -subitemconfig {/kartcontrol_tb/i_mst/i_rxregs/registerset(15) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(14) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(13) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(12) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(11) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(10) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(9) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(8) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(7) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(6) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(5) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(4) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(3) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(2) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(1) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_rxregs/registerset(0) {-radix hexadecimal}} /kartcontrol_tb/i_mst/i_rxregs/registerset
add wave -noupdate -group Registers -radix hexadecimal -subitemconfig {/kartcontrol_tb/i_mst/i_txregs/registerset(15) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(14) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(13) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(12) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(11) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(10) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(9) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(8) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(7) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(6) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(5) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(4) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(3) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(2) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(1) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_txregs/registerset(0) {-radix hexadecimal}} /kartcontrol_tb/i_mst/i_txregs/registerset
add wave -noupdate -expand -group Sequence -radix hexadecimal -subitemconfig {/kartcontrol_tb/i_mst/i_seqram/sequenceset(15) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(14) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(13) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(12) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(11) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(10) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(9) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(8) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(7) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(6) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(5) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(4) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(3) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(2) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(1) {-radix hexadecimal} /kartcontrol_tb/i_mst/i_seqram/sequenceset(0) {-radix hexadecimal}} /kartcontrol_tb/i_mst/i_seqram/sequenceset
add wave -noupdate -expand -group Sequence /kartcontrol_tb/i_mst/act
add wave -noupdate -expand -group Sequence /kartcontrol_tb/i_mst/running
add wave -noupdate -expand -group Sequence -radix unsigned /kartcontrol_tb/i_mst/i_seqram/ramreadaddress
add wave -noupdate -expand -group Sequence -radix hexadecimal /kartcontrol_tb/i_mst/command
add wave -noupdate -expand -group Sequence -radix hexadecimal /kartcontrol_tb/i_mst/argument
add wave -noupdate -expand -group Sequence /kartcontrol_tb/i_mst/i_seqctl/newcommand
add wave -noupdate -expand -group Sequence /kartcontrol_tb/i_mst/done
add wave -noupdate -expand -group Sequence -radix hexadecimal /kartcontrol_tb/i_mst/i_seqctl/sequenceregister
add wave -noupdate -expand -group Sequence -format Analog-Step -height 30 -max 200.0 -radix decimal /kartcontrol_tb/i_mst/motorposition
add wave -noupdate -expand -group Sequence -format Analog-Step -height 30 -max 300.0 -radix hexadecimal /kartcontrol_tb/i_mst/i_seqctl/timercounter
add wave -noupdate -group {DC motor} /kartcontrol_tb/i_dcm/btconnected
add wave -noupdate -group {DC motor} /kartcontrol_tb/i_dcm/restart
add wave -noupdate -group {DC motor} -radix hexadecimal /kartcontrol_tb/i_dcm/prescaler
add wave -noupdate -group {DC motor} -radix decimal /kartcontrol_tb/i_dcm/speed
add wave -noupdate -group {DC motor} /kartcontrol_tb/i_dcm/hworientation
add wave -noupdate -group {DC motor} /kartcontrol_tb/forwards
add wave -noupdate -group {DC motor} /kartcontrol_tb/pwm
add wave -noupdate -group {Stepper motor} -radix unsigned /kartcontrol_tb/i_stm/clockdivider
add wave -noupdate -group {Stepper motor} -radix unsigned /kartcontrol_tb/i_stm/targetangle
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/stepperend
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/i_stm/stepperendbus
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/i_stm/restart
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/i_stm/hworientation
add wave -noupdate -group {Stepper motor} -radix unsigned /kartcontrol_tb/i_stm/actualangle
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/i_stm/reached
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/coil1
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/coil2
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/coil3
add wave -noupdate -group {Stepper motor} /kartcontrol_tb/coil4
add wave -noupdate -expand -group Kart /kartcontrol_tb/bt_connected
add wave -noupdate -expand -group Kart -format Analog-Step -height 30 -max 1.0 /kartcontrol_tb/i_tester/motorspeed
add wave -noupdate -expand -group Kart -format Analog-Step -height 30 -max 300.0 /kartcontrol_tb/i_tester/kartdistance
add wave -noupdate -expand -group Kart /kartcontrol_tb/hallpulses(1)
add wave -noupdate -expand -group Kart -format Analog-Step -height 30 -max 200.0 -radix unsigned /kartcontrol_tb/i_stm/actualangle
add wave -noupdate -expand -group Kart /kartcontrol_tb/leds
add wave -noupdate -expand -group Kart /kartcontrol_tb/i_tester/batteryvoltage
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 312
configure wave -valuecolwidth 63
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
WaveRestoreZoom {0 ps} {31500 us}
