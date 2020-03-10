// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_9,Vivado 2016.2" *)
module shift_ram_3x3_8bits(D, CLK, CE, SCLR, Q);
  input [7:0]D;
  input CLK;
  input CE;
  input SCLR;
  output [7:0]Q;
endmodule
