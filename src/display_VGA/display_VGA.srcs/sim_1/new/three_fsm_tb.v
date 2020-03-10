`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/18 09:05:28
// Design Name: 
// Module Name: three_fsm_tb
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


module three_fsm_tb;
	reg clk;
	reg [3:0] choose;
	reg [15:0]hs_3fsm = 16'b1111_1111_1010_1010;
	reg [15:0]vs_3fsm = 16'b1111_1111_0001_0001;
	reg [15:0]pic_ena = 16'b1111_1111_1111_1111;
	wire [11:0]VGA_data;
	wire final_pic_ena;
	wire HSYNC,VSYNC;

	three_fsm U_3fsm(
		.clk(clk),
		.rst(1'b0),
		.choose(choose),	//选择
		.origin_data(16'b0111_1110_1001_0011),
		.grey_data(8'b1110_1111),
		.median_data(8'b0101_1111),
		.hs(hs_3fsm),		//4 bits 的choose 有16种 预留好	
		.vs(vs_3fsm),
		.pic_ena(pic_ena),
		.sobel_data(1'b1),
		.erode_data(1'b1),
		.dilate_data(1'b1),
		.post_hs(HSYNC),//[15:0]
		.post_vs(VSYNC),//[15:0]
		.post_pic_ena(final_pic_ena),//[15:0]
		.VGA_data(VGA_data)
	);
	
	
	//reg [7:0] median_value;

    //wire [11:0] sobel_value;

    //integer i;
	integer j;
	initial
    begin
		choose = 4'b0;
		#5;
		for(j = 0; j <= 3; j = j + 1)
		begin
			clk = 0;
			choose = choose + 1;
			#1;
			clk = 1;
			#5;
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
