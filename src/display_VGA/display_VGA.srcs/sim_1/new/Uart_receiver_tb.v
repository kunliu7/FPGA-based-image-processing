`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 21:19:50
// Design Name: 
// Module Name: Uart_receiver_tb
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


module Uart_receiver_tb;//(
	//input clk,
	//input rst,
	//input rxd,
	//output [15:0]led

//);

	reg clk;
	reg rst;
	reg rxd;
	wire [15:0]led;
	wire rxd_flag;
	
	wire divide_clken;
	
	clk_divider_precise 
	#(
		//DEVIDE_CNT = 42.94967296 * fo
	//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
	//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
	//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
		.DEVIDE_CNT(32'd6597070)	//9600bps * 16
	)
	U_clk_divider_precise
	(
		.clk(clk), //!!!!!原始100MHZ的clk！！！！
		.rst_n(~rst),
		
		.divide_clk(),//禁止使用分频后的时钟 详情见网页收藏夹
		.divide_clken(divide_clken) //对于全局时钟clk 100MHZ的时钟使能
	);

	
	
	Uart_receiver U_receiver
	(
		.clk(clk),
		.rst_n(~rst),
		.clken_16bps(divide_clken),//clk_bps * 16
		.rxd(rxd),		//uart txd interface
		
		.rxd_data(led),	//uart data received
		.rxd_flag(rxd_flag)	//uart data receive done 
	);
	
	integer j,i;
	initial
    begin
		//choose = 4'b0;
		rxd = 1'b0;
		rst = 1'b1;
		#5;
		for(j = 0; j <= 2000; j = j + 1)
		begin
			for(i = 0;i < 10; i = i + 1)
			begin
				if (i == 0)
					rxd = 1;
				else
					;
			
			end
			clk = 0;
			//if(j)
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

/*
module uart_test(
	input clk,
	input rst,
	input rxd,
	output [15:0]led
    );
	
	wire divide_clken;
	//reg [7:0]rxd_data ;
	//assign led [7:0] =  rxd_data[7:0];
	
	uart_receiver U_receiver
	(
		//gobal clock
		.clk(clk),
		.rst_n(~rst),
		
		//user interface
		.clken_16bps(divide_clken),//clk_bps * 16
		
		//uart interface
		.rxd(rxd),		//uart txd interface
		.rxd_data(led [7:0]),	//uart data receive
		.rxd_flag()	//uart data receive done 
	);
	
	precise_divider 
	#(
		//DEVIDE_CNT = 42.94967296 * fo
	//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
	//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
	//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
		.DEVIDE_CNT(32'd6597070)	//9600bps * 16
	)
	U_divider
	(
		//global clock
		.clk(clk),
		.rst_n(~rst),
		
		//user interface
		.divide_clk(),
		.divide_clken(divide_clken)
	);
	
	
endmodule
*/