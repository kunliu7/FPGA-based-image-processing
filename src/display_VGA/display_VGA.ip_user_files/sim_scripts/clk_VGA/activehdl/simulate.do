onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+clk_VGA -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.clk_VGA xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {clk_VGA.udo}

run -all

endsim

quit -force
