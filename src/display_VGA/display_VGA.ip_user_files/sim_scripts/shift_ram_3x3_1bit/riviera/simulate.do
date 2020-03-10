onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+shift_ram_3x3_1bit -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.shift_ram_3x3_1bit xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {shift_ram_3x3_1bit.udo}

run -all

endsim

quit -force
