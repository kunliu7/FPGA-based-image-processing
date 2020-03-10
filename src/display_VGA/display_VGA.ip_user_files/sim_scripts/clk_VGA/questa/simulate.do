onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_VGA_opt

do {wave.do}

view wave
view structure
view signals

do {clk_VGA.udo}

run -all

quit -force
