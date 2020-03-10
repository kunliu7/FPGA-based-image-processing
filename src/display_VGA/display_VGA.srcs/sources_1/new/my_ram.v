`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/01 23:40:30
// Design Name: 
// Module Name: my_ram
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

module asyn_ram #(
	parameter DWIDTH=5'd16,	//data width				
	AWIDTH=19'd270000		//address width 
	)
	(	
		input wr_clk,	
		input [DWIDTH-1:0] wr_data,	
		input wr_en,	
		input [AWIDTH-1:0] wr_addr,		
		
		input  rd_clk,	
		output [DWIDTH-1:0] rd_data,	
		input  rd_en,	
		input [AWIDTH-1:0] rd_addr
	); 
	reg[DWIDTH-1:0] rw_mem [19'd270000-1:0];
	//define the memory
	reg[AWIDTH-1:0] raddr;
	
	always@(posedge wr_clk)
		begin	
		if(wr_en) begin		
			rw_mem[wr_addr]<=wr_data;	
		end
	end 
	always@(posedge rd_clk)begin	
		if(rd_en) begin		
			raddr<=rd_addr;	
		end
		//else
		//	raddr<=raddr;
	end
	assign rd_data=rw_mem[raddr];
	
endmodule 

