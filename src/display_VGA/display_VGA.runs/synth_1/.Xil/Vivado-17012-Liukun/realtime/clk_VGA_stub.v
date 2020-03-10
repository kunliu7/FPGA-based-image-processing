// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_VGA(clk, clk_40m, clk_80m, clk_100m, rst_n);
  input clk;
  output clk_40m;
  output clk_80m;
  output clk_100m;
  input rst_n;
endmodule
