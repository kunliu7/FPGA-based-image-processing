proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param simulator.modelsimInstallPath C:/modeltech_pe_10.4c/win32pe
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/FPGA/display_VGA/display_VGA.cache/wt [current_project]
  set_property parent.project_path D:/FPGA/display_VGA/display_VGA.xpr [current_project]
  set_property ip_repo_paths d:/FPGA/display_VGA/display_VGA.cache/ip [current_project]
  set_property ip_output_repo d:/FPGA/display_VGA/display_VGA.cache/ip [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet D:/FPGA/display_VGA/display_VGA.runs/synth_1/disp_VGA.dcp
  add_files -quiet d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.dcp
  set_property netlist_only true [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.dcp]
  add_files -quiet d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_8bits/shift_ram_3x3_8bits.dcp
  set_property netlist_only true [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_8bits/shift_ram_3x3_8bits.dcp]
  add_files -quiet d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_1bit/shift_ram_3x3_1bit.dcp
  set_property netlist_only true [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_1bit/shift_ram_3x3_1bit.dcp]
  add_files -quiet D:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/Uart_VGA_ram/Uart_VGA_ram.dcp
  set_property netlist_only true [get_files D:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/Uart_VGA_ram/Uart_VGA_ram.dcp]
  read_xdc -mode out_of_context -ref clk_VGA -cells inst d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_ooc.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_VGA -cells inst d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_board.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_board.xdc]
  read_xdc -ref clk_VGA -cells inst d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA.xdc]
  read_xdc -mode out_of_context -ref shift_ram_3x3_8bits -cells U0 d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_8bits/shift_ram_3x3_8bits_ooc.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_8bits/shift_ram_3x3_8bits_ooc.xdc]
  read_xdc -mode out_of_context -ref shift_ram_3x3_1bit -cells U0 d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_1bit/shift_ram_3x3_1bit_ooc.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_1bit/shift_ram_3x3_1bit_ooc.xdc]
  read_xdc -mode out_of_context -ref Uart_VGA_ram -cells U0 d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/Uart_VGA_ram/Uart_VGA_ram_ooc.xdc
  set_property processing_order EARLY [get_files d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/Uart_VGA_ram/Uart_VGA_ram_ooc.xdc]
  read_xdc D:/FPGA/display_VGA/display_VGA.srcs/constrs_1/new/top_xdc.xdc
  link_design -top disp_VGA -part xc7a100tcsg324-1
  write_hwdef -file disp_VGA.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force disp_VGA_opt.dcp
  report_drc -file disp_VGA_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force disp_VGA_placed.dcp
  report_io -file disp_VGA_io_placed.rpt
  report_utilization -file disp_VGA_utilization_placed.rpt -pb disp_VGA_utilization_placed.pb
  report_control_sets -verbose -file disp_VGA_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force disp_VGA_routed.dcp
  report_drc -file disp_VGA_drc_routed.rpt -pb disp_VGA_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file disp_VGA_timing_summary_routed.rpt -rpx disp_VGA_timing_summary_routed.rpx
  report_power -file disp_VGA_power_routed.rpt -pb disp_VGA_power_summary_routed.pb -rpx disp_VGA_power_routed.rpx
  report_route_status -file disp_VGA_route_status.rpt -pb disp_VGA_route_status.pb
  report_clock_utilization -file disp_VGA_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force disp_VGA.mmi }
  write_bitstream -force disp_VGA.bit 
  catch { write_sysdef -hwdef disp_VGA.hwdef -bitfile disp_VGA.bit -meminfo disp_VGA.mmi -file disp_VGA.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

