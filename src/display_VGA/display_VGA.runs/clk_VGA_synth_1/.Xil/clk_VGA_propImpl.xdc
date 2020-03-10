set_property SRC_FILE_INFO {cfile:d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.xdc rfile:../../../display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
