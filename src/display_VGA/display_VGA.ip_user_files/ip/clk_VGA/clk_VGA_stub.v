// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Mon Dec 24 00:16:09 2018
// Host        : Liukun running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_stub.v
// Design      : clk_VGA
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_VGA(clk, clk_40m, clk_80m, clk_100m, rst_n)
/* synthesis syn_black_box black_box_pad_pin="clk,clk_40m,clk_80m,clk_100m,rst_n" */;
  input clk;
  output clk_40m;
  output clk_80m;
  output clk_100m;
  input rst_n;
endmodule
