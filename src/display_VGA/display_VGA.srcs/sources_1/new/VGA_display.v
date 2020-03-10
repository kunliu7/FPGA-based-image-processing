`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 19:30:27
// Design Name: 
// Module Name: VGA_display
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

module VGA_display(
	input clk,
	input rst,
	input [11:0]ram_data,
	input [15:0]hcount,
	input [15:0]vcount,
	
	output [11:0]VGA_data,
	output [18:0]VGA_data_addr,
	output pic_ena
    );
	
	wire VGA_data_ena;
	assign VGA_data_ena = ((hcount > `HSYNC_B && hcount <`HSYNC_C) && (vcount > `VSYNC_P && vcount < `VSYNC_Q))? 1:0;	

	// pic_ena决定此刻传入某模块的数据是否是图像数据
	//wire [5 : 0]pic_ena;
	//wire pic_ena;
	
	//有图像的区域：
	assign pic_ena = VGA_data_ena && (hcount >= `PIC_START_H + `HSYNC_B && hcount < `PIC_START_H +`HSYNC_B + `PIC_H) &&
		(vcount >= `VSYNC_P +`PIC_START_V && vcount < `PIC_START_V + `VSYNC_P + `PIC_V)? 1'b1 : 1'b0; 
	
	
	
	reg [18:0]addra;
	always @(posedge clk or posedge rst)begin
		if(rst)
			addra <= 19'd0;
		else if(pic_ena && addra == 19'd270000 - 1'b1)
			addra <= 19'd0;
		else if(pic_ena)
			addra <= addra + 1'b1;
		else
			addra <= addra;
	end

	assign VGA_data = pic_ena ? ram_data : 12'b0;
	
	assign VGA_data_addr = addra;
	
endmodule
