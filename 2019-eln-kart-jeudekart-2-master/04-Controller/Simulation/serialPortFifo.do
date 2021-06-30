onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serialportfifo_tb/reset
add wave -noupdate /serialportfifo_tb/clock
add wave -noupdate -divider {Rx path}
add wave -noupdate /serialportfifo_tb/i1/rs232rxstring
add wave -noupdate /serialportfifo_tb/i1/rs232rxbyte
add wave -noupdate /serialportfifo_tb/i1/rs232sendrxstring
add wave -noupdate /serialportfifo_tb/i1/rs232sendrxbyte
add wave -noupdate /serialportfifo_tb/i1/rs232sendrxstringdone
add wave -noupdate /serialportfifo_tb/rxd
add wave -noupdate /serialportfifo_tb/rxempty
add wave -noupdate /serialportfifo_tb/rxrd
add wave -noupdate -radix ascii /serialportfifo_tb/rxdata
add wave -noupdate /serialportfifo_tb/i1/rxdataregistered
add wave -noupdate -divider {Rx path internals}
add wave -noupdate /serialportfifo_tb/i0/rxwordvalid
add wave -noupdate -radix unsigned /serialportfifo_tb/i0/i1/writecounter
add wave -noupdate -radix unsigned /serialportfifo_tb/i0/i1/readcounter
add wave -noupdate -divider {Tx path}
add wave -noupdate /serialportfifo_tb/i1/fifotxstring
add wave -noupdate -radix unsigned /serialportfifo_tb/txdata
add wave -noupdate -radix ascii /serialportfifo_tb/txdata
add wave -noupdate /serialportfifo_tb/txwr
add wave -noupdate /serialportfifo_tb/txfull
add wave -noupdate /serialportfifo_tb/txd
add wave -noupdate /serialportfifo_tb/i1/rs232txbyte
add wave -noupdate -divider {Tx path internals}
add wave -noupdate -radix ascii /serialportfifo_tb/i0/txword
add wave -noupdate /serialportfifo_tb/i0/txsend
add wave -noupdate /serialportfifo_tb/i0/txbusy
add wave -noupdate /serialportfifo_tb/i0/txfifoempty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 273
configure wave -valuecolwidth 78
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2100 us}
