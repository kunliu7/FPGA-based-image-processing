`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/17 19:15:04
// Design Name: 
// Module Name: get_addr
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

`include "headfile.v"

module get_addr(
	input clk,
	input rst,
	input pic_ena,
	input hcount,
	input vcount,
	output reg[18:0]addr
    );
	always @ (posedge clk or posedge rst)
		begin	
		if	 (rst)			
			addr <= 19'd0;
		else if(pic_ena)		
			addr <= hcount - `HSYNC_B - `PIC_START_H + (vcount- `VSYNC_P - `PIC_START_V) * `PIC_H;
		else		
			addr <= 19'd0;
	end
endmodule
