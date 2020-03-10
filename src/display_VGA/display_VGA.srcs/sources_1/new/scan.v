`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 14:06:32
// Design Name: 
// Module Name: scan
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


module scan(
	input clk,
	input rst,
	
	output HSYNC,
	output VSYNC,
	output reg [11:0]hcount,
	output reg [11:0]vcount,
	output pic_ena,
	output [18:0] VGA_data_addr
    );
	
	//reg hcount_r;
	//reg vcount_r;
	
	
	assign HSYNC = (hcount < `HSYNC_A) ? 0 : 1;
	assign VSYNC = (vcount < `VSYNC_O) ? 0 : 1;
	
	always@(posedge clk or posedge rst)
	begin
		if(rst || hcount == `HSYNC_D - 1)
			begin
				hcount <= 0;
			end
		else
			begin
				hcount <= hcount + 1;
			end
	end
		
		
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			vcount <= 0;
		end
		else if(hcount == `HSYNC_D - 1)
		begin
			if(vcount == `VSYNC_R - 1)
			begin
				vcount <= 0;
			end
			else
			begin
				vcount <= vcount + 1;
			end
		end
	end
	
	wire VGA_data_ena;
	assign VGA_data_ena = ((hcount > `HSYNC_B && hcount <`HSYNC_C) && (vcount > `VSYNC_P && vcount < `VSYNC_Q))? 1:0;	
	
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
	
	assign VGA_data_addr = addra;
	
endmodule
