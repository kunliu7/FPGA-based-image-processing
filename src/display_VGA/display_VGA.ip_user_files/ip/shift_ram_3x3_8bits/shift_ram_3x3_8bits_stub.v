// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Tue Dec 18 12:44:19 2018
// Host        : Liukun running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_8bits/shift_ram_3x3_8bits_stub.v
// Design      : shift_ram_3x3_8bits
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_9,Vivado 2016.2" *)
module shift_ram_3x3_8bits(D, CLK, CE, SCLR, Q)
/* synthesis syn_black_box black_box_pad_pin="D[7:0],CLK,CE,SCLR,Q[7:0]" */;
  input [7:0]D;
  input CLK;
  input CE;
  input SCLR;
  output [7:0]Q;
endmodule
