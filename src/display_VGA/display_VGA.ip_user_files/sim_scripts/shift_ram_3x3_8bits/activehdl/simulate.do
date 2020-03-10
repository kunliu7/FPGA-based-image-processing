onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+shift_ram_3x3_8bits -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.shift_ram_3x3_8bits xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {shift_ram_3x3_8bits.udo}

run -all

endsim

quit -force
