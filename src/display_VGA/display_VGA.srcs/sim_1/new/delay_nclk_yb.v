`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 21:38:32
// Design Name: 
// Module Name: delay_nclk_yb
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


module delay_nclk_yb;

	reg clk = 0;
	//reg rst;
	//reg vs;
	//reg hs;
	reg [7:0]grey_data = 0;
	//reg pic_ena;
	wire [7:0] median_filter_data;
	
	

	median_filter U_med(
		.clk(clk_40m),
		.rst(1'b0),
		.vs(1'b1),
		.hs(1'b1),
		.grey_data(grey_data),
		.pic_ena(1'b1),
		.median_filter_data(median_filter_data),
		.post_vs(),
		.post_hs(),
		.post_pic_ena()
	);
	

//	genvar i;
	
	//for(i=0;i<2000;i = i + 1)
//	begin
//		5 clk = ~clk;
//	end
	always #1 clk = ~clk;
	always @(negedge clk)
	begin
		grey_data = grey_data + 8'b0000_0001;
	end
	
	
endmodule
