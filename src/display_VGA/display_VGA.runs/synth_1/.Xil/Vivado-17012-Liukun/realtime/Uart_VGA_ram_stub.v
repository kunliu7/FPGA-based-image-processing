// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_3,Vivado 2016.2" *)
module Uart_VGA_ram(clka, ena, wea, addra, dina, douta, clkb, enb, web, addrb, dinb, doutb);
  input clka;
  input ena;
  input [0:0]wea;
  input [18:0]addra;
  input [15:0]dina;
  output [15:0]douta;
  input clkb;
  input enb;
  input [0:0]web;
  input [18:0]addrb;
  input [15:0]dinb;
  output [15:0]doutb;
endmodule
