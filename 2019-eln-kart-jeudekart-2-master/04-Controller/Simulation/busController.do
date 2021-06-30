onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {Reset & clock} /buscontroller_tb/reset
add wave -noupdate -group {Reset & clock} /buscontroller_tb/clock
add wave -noupdate -expand -group RS232 -radix hexadecimal /buscontroller_tb/i_tb/rs232rxbyte
add wave -noupdate -expand -group RS232 /buscontroller_tb/bt_txd
add wave -noupdate -expand -group RS232 /buscontroller_tb/bt_rxd
add wave -noupdate -expand -group RS232 -radix hexadecimal /buscontroller_tb/i_tb/rs232txbyte
add wave -noupdate -expand -group RS232 /buscontroller_tb/bt_reset
add wave -noupdate -group Registers /buscontroller_tb/i_dut/commandvalid
add wave -noupdate -group Registers -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/i_rxregs/registerset(15) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(14) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(13) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(12) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(11) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(10) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(9) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(8) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(7) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(6) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(5) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(4) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(3) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(2) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(1) {-radix hexadecimal} /buscontroller_tb/i_dut/i_rxregs/registerset(0) {-radix hexadecimal}} /buscontroller_tb/i_dut/i_rxregs/registerset
add wave -noupdate -group {I2C Sequence} /buscontroller_tb/i_dut/sendi2c
add wave -noupdate -group {I2C Sequence} -radix unsigned /buscontroller_tb/i_dut/i_i2cseq/sequenceid
add wave -noupdate -group {I2C Sequence} -format Analog-Step -height 30 -max 128.0 -radix unsigned /buscontroller_tb/i_dut/i_i2cseq/sequencecounter
add wave -noupdate -group {I2C Sequence} -format Analog-Step -height 20 -max 15.0 -radix unsigned /buscontroller_tb/i_dut/i_i2cseq/regrxaddr
add wave -noupdate -group {I2C Sequence} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/txdata(9) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(8) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/txdata(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_dut/txdata
add wave -noupdate -group {I2C Sequence} /buscontroller_tb/i_dut/txwr
add wave -noupdate -group {I2C Sequence} -radix hexadecimal /buscontroller_tb/i_dut/regrxaddr
add wave -noupdate -group {I2C Sequence} -radix hexadecimal /buscontroller_tb/i_dut/regrxdata
add wave -noupdate -group {I2C write} /buscontroller_tb/sclin
add wave -noupdate -group {I2C write} /buscontroller_tb/sdain
add wave -noupdate -group {I2C write} /buscontroller_tb/i_tb/sdaout
add wave -noupdate -group {I2C write} /buscontroller_tb/i_tb/ackout
add wave -noupdate -group {I2C write} -radix hexadecimal /buscontroller_tb/i_tb/i2cchipaddress
add wave -noupdate -group {I2C write} -radix hexadecimal /buscontroller_tb/i_tb/i2crxaddress
add wave -noupdate -group {I2C write} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_tb/i2crxbyte(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/i2crxbyte(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_tb/i2crxbyte
add wave -noupdate -group {I2C write} /buscontroller_tb/i_tb/i2cread1
add wave -noupdate -group {I2C write} /buscontroller_tb/i_tb/i2cread
add wave -noupdate -group {I2C write} /buscontroller_tb/i_tb/i2cdatavalid
add wave -noupdate -group {I2C write} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_tb/registersin(15) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(14) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(13) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(12) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(11) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(10) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(9) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(8) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(7) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(6) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(5) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(4) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(3) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(2) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(1) {-radix hexadecimal} /buscontroller_tb/i_tb/registersin(0) {-radix hexadecimal}} /buscontroller_tb/i_tb/registersin
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_tb/registersout(15) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(14) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(13) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(12) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(11) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(10) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(9) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(8) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_tb/registersout(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_tb/registersout
add wave -noupdate -group {I2C read} /buscontroller_tb/i_tb/i2cdatavalidshifted
add wave -noupdate -group {I2C read} -radix hexadecimal /buscontroller_tb/i_tb/i2ctxbyte
add wave -noupdate -group {I2C read} /buscontroller_tb/i_dut/i_i2cseq/rxnewdata
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/rxdata(9) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(8) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(7) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(6) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(5) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(4) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(3) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(2) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(1) {-radix hexadecimal} /buscontroller_tb/i_dut/rxdata(0) {-radix hexadecimal}} /buscontroller_tb/i_dut/rxdata
add wave -noupdate -group {I2C read} /buscontroller_tb/i_dut/i_i2cseq/rxstate
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/i_i2cseq/txaddress(4) {-radix hexadecimal} /buscontroller_tb/i_dut/i_i2cseq/txaddress(3) {-radix hexadecimal} /buscontroller_tb/i_dut/i_i2cseq/txaddress(2) {-radix hexadecimal} /buscontroller_tb/i_dut/i_i2cseq/txaddress(1) {-radix hexadecimal} /buscontroller_tb/i_dut/i_i2cseq/txaddress(0) {-radix hexadecimal}} /buscontroller_tb/i_dut/i_i2cseq/txaddress
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/regtxaddr(3) {-radix hexadecimal} /buscontroller_tb/i_dut/regtxaddr(2) {-radix hexadecimal} /buscontroller_tb/i_dut/regtxaddr(1) {-radix hexadecimal} /buscontroller_tb/i_dut/regtxaddr(0) {-radix hexadecimal}} /buscontroller_tb/i_dut/regtxaddr
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/regtxdata(15) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(14) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(13) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(12) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(11) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(10) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(9) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(8) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/regtxdata(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_dut/regtxdata
add wave -noupdate -group {I2C read} /buscontroller_tb/i_dut/updatetxreg
add wave -noupdate -group {I2C read} -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/i_txregs/registerset(15) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(14) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(13) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(12) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(11) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(10) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(9) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(8) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_txregs/registerset(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_dut/i_txregs/registerset
add wave -noupdate -group {RS232 write} /buscontroller_tb/i_dut/sendstatus
add wave -noupdate -group {RS232 write} -radix unsigned /buscontroller_tb/i_dut/statusdivide
add wave -noupdate -group {RS232 write} -radix unsigned /buscontroller_tb/i_dut/i_txif/registercounter
add wave -noupdate -group {RS232 write} -radix unsigned /buscontroller_tb/i_dut/i_txif/writeitemcounter
add wave -noupdate -group {RS232 write} /buscontroller_tb/i_dut/ctltxwr
add wave -noupdate -radix unsigned /buscontroller_tb/i_dut/i_seqram/addressreg
add wave -noupdate /buscontroller_tb/i_dut/i_seqram/loadnewsequence
add wave -noupdate /buscontroller_tb/i_dut/i_seqram/run_stop
add wave -noupdate /buscontroller_tb/i_dut/i_seqram/ramwriteenable
add wave -noupdate -radix unsigned /buscontroller_tb/i_dut/i_seqram/ramwriteaddress
add wave -noupdate -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/i_seqram/ramwritedata(15) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(14) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(13) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(12) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(11) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(10) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(9) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(8) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(7) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(6) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(5) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(4) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(3) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(2) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(1) {-radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/ramwritedata(0) {-radix hexadecimal}} /buscontroller_tb/i_dut/i_seqram/ramwritedata
add wave -noupdate -radix hexadecimal -subitemconfig {/buscontroller_tb/i_dut/i_seqram/sequenceset(15) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(14) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(13) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(12) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(11) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(10) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(9) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(8) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(7) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(6) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(5) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(4) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(3) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(2) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(1) {-height 15 -radix hexadecimal} /buscontroller_tb/i_dut/i_seqram/sequenceset(0) {-height 15 -radix hexadecimal}} /buscontroller_tb/i_dut/i_seqram/sequenceset
add wave -noupdate -radix unsigned /buscontroller_tb/i_dut/i_seqram/ramreadaddress
add wave -noupdate /buscontroller_tb/i_dut/i_seqctl/newcommand
add wave -noupdate -radix hexadecimal /buscontroller_tb/i_dut/command
add wave -noupdate -radix hexadecimal /buscontroller_tb/i_dut/argument
add wave -noupdate /buscontroller_tb/i_dut/act
add wave -noupdate /buscontroller_tb/i_dut/done
add wave -noupdate -format Analog-Step -height 20 -max 4096.0 -radix unsigned /buscontroller_tb/i_dut/i_seqctl/timercounter
add wave -noupdate -radix decimal /buscontroller_tb/i_dut/i_seqctl/speedreg
add wave -noupdate -radix unsigned /buscontroller_tb/i_dut/i_seqctl/anglereg
add wave -noupdate -radix hexadecimal /buscontroller_tb/i_dut/i_seqctl/ledsreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 297
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
WaveRestoreZoom {0 ps} {16800 us}
