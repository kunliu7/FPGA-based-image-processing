`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/18 19:03:11
// Design Name: 
// Module Name: sobel_edge_detect_tb
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

//`include "headfile.v"
module sobel_edge_detect_tb;
	reg clk;
	reg pic_ena;
	reg vs;
	reg hs;
	reg [7:0]median_filter_data = 8'b1111_1111;

	
	wire post_vs;
	wire post_hs;
	wire post_pic_ena;



	wire sobel_detect_data_bit;

	sobel_edge_detect U_sobel_detect(
		.clk(clk),	
		.rst(1'b0),
		
		.pic_ena(1'b1),	//图片使能，表示这个clk在处理图片
		.vs(1'b1),
		.hs(1'b1),
		
		.threshold(16'd150),
		.median_filter_data(median_filter_data),
		.sobel_detect_data_bit(sobel_detect_data_bit),
		
		.post_vs(post_vs),
		.post_hs(post_hs),
		.post_pic_ena(post_pic_ena)
    );
	
	integer i;
	integer j;
	initial
    begin
		
		#5;
		for(j = 0; j <= 2000; j = j + 1)
		begin
			clk = 0;
			//median_value = vcount;
			#1;
			clk = 1;
			#1;
			/*
			for(i = 1; i <= 20; i = i + 1)
			begin

				clk = ~clk;
				median_value = i[7:0] + vcount;
				#1;
				clk = ~clk;
				#5;

			end
			*/
		end
    end	
	


endmodule
