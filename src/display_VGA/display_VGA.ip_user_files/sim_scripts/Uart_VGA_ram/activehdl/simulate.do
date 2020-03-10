onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Uart_VGA_ram -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.Uart_VGA_ram xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Uart_VGA_ram.udo}

run -all

endsim

quit -force
