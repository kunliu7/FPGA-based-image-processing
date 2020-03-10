`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 23:39:14
// Design Name: 
// Module Name: sobel_edge_detect
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


module sobel_edge_detect(
	input clk,	
	input rst,
	input pic_ena,	//图片使能，表示这个clk在处理图片
	input vs,
	input hs,
	input  [15:0]threshold,
	input  [7:0]median_filter_data,
	output sobel_detect_data_bit,
	output post_vs,
	output post_hs,
	output post_pic_ena
    );
	//pipline method
	//for simple, |G| = |Gx| + |Gy|
	//1.
	//2.
	//3.
	//4.
	
	wire [7:0]row1,row2;
	reg  [7:0]row3;
  
	//只用两个shift ram级联
	//vivado只有单行shift ram
	shift_ram_3x3_8bits U_shift_ram1 (
		.D(row3),        // input wire [7 : 0] D
		.CLK(clk),    // input wire CLK //这里debug了好久好久！！！！
		.CE(pic_ena),      // input wire CE	//这里也换成使能的，减少slack
		.SCLR(1'b0),  // input wire SCLR
		.Q(row2)        // output wire [7 : 0] Q
	);
  
	shift_ram_3x3_8bits U_shift_ram0 (
		.D(row2),        // input wire [7 : 0] D
		.CLK(clk),    // input wire CLK
		.CE(pic_ena),      // input wire CE
		.SCLR(1'b0),  // input wire SCLR
		.Q(row1)        // output wire [7 : 0] Q
	);
	
	// 数据进入shift ram 消耗1时钟
	
	always@(posedge clk or posedge rst)
	begin
		if(rst)
			row3 <= 0;
		else if(pic_ena)
			row3 <= median_filter_data;
		else
			row3 <= row3;
	end
	
	//延迟方法如下：
	//log 2 clocks signal sync
	reg [1:0] pic_ena_r1;
	reg [1:0] vs_r1,hs_r1;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			pic_ena_r1 <= 0;
			vs_r1 <= 0;
			hs_r1 <= 0;
		end
		else
		begin
			pic_ena_r1 <= {pic_ena_r1[0],pic_ena};
			vs_r1 <= {vs_r1[0],vs};
			hs_r1 <= {hs_r1[0],hs};
		end
	end
	
	wire read_matrix_ena = pic_ena_r1[0];//取[0],表示log 1，是读入shift ram的，
										//之后会取[1]表示log 2，是读出矩阵的延迟
	assign read_matrix_hs = hs_r1[0];
	assign read_matrix_vs = vs_r1[0];
 
	//根据行、场同步信号读取3X3阵列
	//matrix_p_x_y
	reg [7:0] mp11,mp12,mp13;
	reg [7:0] mp21,mp22,mp23;
	reg [7:0] mp31,mp32,mp33;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)begin
			{mp11,mp12,mp13}<=0;
			{mp21,mp22,mp23}<=0;
			{mp31,mp32,mp33}<=0;
		end
		else if(read_matrix_ena)begin
			{mp11,mp12,mp13}<={mp12,mp13,row1};
			{mp21,mp22,mp23}<={mp22,mp23,row2};
			{mp31,mp32,mp33}<={mp32,mp33,row3};
		end
		else begin
			{mp11,mp12,mp13}<={mp11,mp12,mp13};
			{mp21,mp22,mp23}<={mp21,mp22,mp23};
			{mp31,mp32,mp33}<={mp31,mp32,mp33};
		end	
	end
	
	//Sobel Edge Detect 
	//Step 1 	列，2 clk 算完一个3X3的Gx 
	/*
	Gx = | -1  0  +1 |
		 | -2  0  +2 |
		 | -1  0  +1 |
	*/
	reg [9:0] gx1, gx2, Gx; //gx1 + ; gx2 - ;
	always @(posedge clk or posedge rst) begin
		if(rst)	begin
			gx1 <= 0;
			gx2 <= 0;
			Gx <= 0;
		end
		else begin
			gx1 <= mp13 + (mp23 << 1) + mp33;	// +
			gx2 <= mp11 + (mp21 << 1) + mp31; 	// -
			Gx <= (gx1 >= gx2) ? gx1 - gx2 : gx2 - gx1 ; // |Gx| = |gx1 - gx2| 
		end
	end
	
	//同理 算列
	reg [9:0] gy1, gy2, Gy; //gx1 + ; gx2 - ;
	always @(posedge clk or posedge rst) begin
		if(rst)	begin
			gy1 <= 0;
			gy2 <= 0;
			Gy <= 0;
		end
		else begin
			gy1 <= mp11 + (mp12 << 1) + mp13;	// +
			gy2 <= mp31 + (mp32 << 1) + mp33; 	// -
			Gy <= (gy1 >= gy2) ? gy1 - gy2 : gy2 - gy1 ; // |Gx| = |gx1 - gx2| 
		end
	end
	
	// Step 2, 0 clk
	wire [10:0] G; //宽度 为 10 ，因为Gx 和 Gy 都只有9位，肯定不会超
	assign G = Gy + Gx ;//simplified
	
	// Step 3, threshold, 1 clk
	reg sobel_detect_data_bit_r;
	assign sobel_detect_data_bit = sobel_detect_data_bit_r;
	always @(posedge clk or posedge rst) begin
		if(rst)
			sobel_detect_data_bit_r <= 1'b0;
		else if (G >= threshold)
			sobel_detect_data_bit_r <= 1'b1;
		else
			sobel_detect_data_bit_r <= 1'b0;
	end
	
	//delay 3 clk
	delay_nclk #(.N(3))
		U_delay_2clk (
		.clk(clk),
		.rst(rst),
		.ena(pic_ena_r1[1]),
		.vs(vs_r1[1]),
		.hs(hs_r1[1]),
		.post_vs(post_vs),
		.post_hs(post_hs),
		.post_ena(post_pic_ena)
	);
	
	/*
	always @(posedge clk or posedge rst) begin
		
		
		
	end
	
	always @(posedge clk or posedge rst)
	*/
endmodule
