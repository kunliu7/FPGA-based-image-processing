`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	Tongji Univ.
// Engineer: 	Liukun
// 
// Create Date: 2018/12/08 16:48:46
// Design Name: 
// Module Name: RGB2Grey
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: RGB565 to Grey with YCrCb
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RGB2Grey(
	input clk,
	input ena,
	input vs,
	input hs,
	input rst,
	input [15:0]RGB_data,
	output [7:0]Y,
	output post_vs,
	output post_hs,
	output post_ena
    );
	wire [7:0] R0, B0, G0;
	reg [15:0] Y0;//big enough
	//先从RGB565 to RGB888
	//原因：没有直接从RGB565到YCrCb的算法
	
	//量化补偿
	assign R0 = {RGB_data[15:11],RGB_data[15:13]};
    assign G0 = {RGB_data[10:5],RGB_data[10:9]};
    assign B0 = {RGB_data[4:0],RGB_data[4:2]};
	
	reg sys_rst;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			sys_rst <= 0;
			
		end
		else
		begin
		//Verilog没有浮点数运算，都乘整数，再取高位
			sys_rst <= rst;
			
		end
	end
	
	//RGB888 with YCrCb
	reg [15:0] R,G,B; // have to be big enough
	always@(posedge clk or posedge sys_rst)
	begin
		if(sys_rst)
		begin
			R <= 0;
			
		end
		else
		begin
		//Verilog没有浮点数运算，都乘整数，再取高位
			R <= R0 * 77;
			
		end
	end
	
	always@(posedge clk or posedge sys_rst)
	begin
		if(sys_rst)
		begin
			
			G <= 0;
			
		end
		else
		begin
		//Verilog没有浮点数运算，都乘整数，再取高位
			
			G <= G0 * 150;
			
		end
	end
	
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			
			B <= 0;
		end
		else
		begin
		//Verilog没有浮点数运算，都乘整数，再取高位
			
			B <= B0 * 29;
		end
	end

	//get grey
	always@(posedge clk or posedge sys_rst)
	begin
		if(sys_rst)
		begin
			Y0 <= 0;
		end
		else
		begin
			Y0 <= R + G + B;
		end
	end
	
	
	//取高位
	assign Y = Y0[15:8];
	
	//计算一位的Y 需要两个clk 所以需要两个延迟
	delay_nclk #(.N(2))
	U_delay_2clk (
		.clk(clk),
		.rst(rst),
		.ena(ena),
		.vs(vs),
		.hs(hs),
		.post_vs(post_vs),
		.post_hs(post_hs),
		.post_ena(post_ena)
	);
	

endmodule
