`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/07 15:55:34
// Design Name: 
// Module Name: disp_VGA_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module disp_VGA_tb;
reg clk_40m = 0;
reg [18:0]addr = 18'd0;
wire [15:0]RGB_from_ROM;
blk_mem_VGA U_Pic (
  .clka(clk_40m),    // input wire clka
  .addra(addr),  // input wire [18 : 0] addra
  .douta(RGB_from_ROM)  // output wire [15 : 0] douta
);

	integer i;
	//integer j;
	//integer k;
	
    initial
    begin
      for(i = 0; i <= 2; i = i + 600)
          begin
            addr = i[15:0];
            #2;
            clk_40m = ~clk_40m;
          end
    end

endmodule
