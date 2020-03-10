`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 19:02:34
// Design Name: 
// Module Name: process_pic
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

module process_pic(
	input clk,
	input rst,
	input pre_clken,
	input [15:0]pre_data,
	input [3:0] choose,
	input pre_HSYNC,
	input pre_VSYNC,
	
	output [11:0]post_data,
	output post_clken,
	output [18:0]ram_addr,
	output post_HSYNC,
	output post_VSYNC
	
    );
	
	//转为灰度图
	//其实hs\vs废掉了
	wire vs0,hs0,vs1,hs1,pic_ena1;
	wire [7:0]grey_data;
	assign vs0 = pre_VSYNC;//!!!!!!!!!!!!!!!!!!!!!!!
	assign hs0 = pre_HSYNC;
	
	RGB2Grey U_2grey(
		.clk(clk),//全局时钟！！！
		.rst(rst),
		.ena(pre_clken),	
		.vs(vs0), 	//由原始counter生成的同步信号
		.hs(hs0),
		.RGB_data(pre_data),
		.post_vs(vs1),
		.post_hs(hs1),
		.post_ena(pic_ena1),
		.Y(grey_data)
	);
	
	
	
	wire [7:0] per_median_data = grey_data; //必须要这么做 才能在median的实例化中可行 否则线是断的
	//中值滤波
	wire [7:0]median_filter_data;
	wire vs2,hs2,pic_ena2;
	median_filter U_med(
		.clk(clk),
		.rst(rst),
		
		.vs(vs1),
		.hs(hs1),
		.pic_ena(pic_ena1),
		
		.grey_data(per_median_data),
		.median_filter_data(median_filter_data),
		
		.post_vs(vs2),
		.post_hs(hs2),
		.post_pic_ena(pic_ena2)
	);
	
	////assign HSYNC = hs5;
	//assign VSYNC = vs5;
	
	//传给VGA的数据有三个
	/*
  assign {VGA_data,HSYNC,VSYNC} = pic_ena ? 
	(choose == 4'b0001 ? 
		{RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1],hs[0],vs[0]}:
	(choose == 4'b0010 ? 
		{tmp_data_gety[7:4],tmp_data_gety[7:4],tmp_data_gety[7:4],hs[1],vs[1]}: // 3{tmp_data_gety[7:4]}不能用 会报错
	(choose == 4'b0011 ?  
		{median_filter_data[7:4],median_filter_data[7:4],median_filter_data[7:4],hs[2],vs[2]}:  14'b0 ))): 14'b0;
	
*/	
		//assign VGA_data = pic_ena?{3{median_filter_data[7:4]}}:12'b0;
	wire sobel_detect_data_bit;
	wire vs3,hs3,pic_ena3;
	sobel_edge_detect U_sobel_detect(
		.clk(clk),	
		.rst(rst),
		
		.pic_ena(pic_ena2),	//图片使能，表示这个clk在处理图片
		.vs(vs2),
		.hs(hs2),
		
		.threshold(`THRESHOLD),
		.median_filter_data(median_filter_data),
		.sobel_detect_data_bit(sobel_detect_data_bit),
		
		.post_vs(vs3),
		.post_hs(hs3),
		.post_pic_ena(pic_ena3)
    );
	
	wire erode_data;
	wire vs4,hs4,pic_ena4;
	erode U_erode(
		.clk(clk),	
		.rst(rst),
		
		.pic_ena(pic_ena3),	//图片使能，表示这个clk在处理图片
		.vs(vs3),
		.hs(hs3),
		.sobel_detect_data_bit(sobel_detect_data_bit),
		.erode_data(erode_data),
		
		.post_vs(vs4),
		.post_hs(hs4),
		.post_pic_ena(pic_ena4)
    );
	
	wire dilate_data;
	wire vs5,hs5,pic_ena5;
	dilate U_dilate(
		.clk(clk),	
		.rst(rst),
		
		.pic_ena(pic_ena4),	//图片使能，表示这个clk在处理图片
		.vs(vs4),
		.hs(hs4),
		
		.erode_data(erode_data),
		.dilate_data(dilate_data),
		
		.post_vs(vs5),
		.post_hs(hs5),
		.post_pic_ena(pic_ena5)
    );
	
	reg [15:0]hs_3fsm;
	reg [15:0]vs_3fsm;
	reg [15:0]pic_ena_3fsm;
	
	
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			hs_3fsm <= 0 ;
			vs_3fsm <= 0 ;
			pic_ena_3fsm <= 0 ;
		end
		else begin
			hs_3fsm <= {{9'b0},{hs5,hs4,hs3,hs2,hs1,hs0,1'b0}} ;
			vs_3fsm <= {{9'b0},{vs5,vs4,vs3,vs2,vs1,vs0,1'b0}} ;
			pic_ena_3fsm <= {{9'b0},{pic_ena5,pic_ena4,pic_ena3,pic_ena2,pic_ena1,pre_clken,1'b0}} ;
		end
	
	end
	/*	
	// 三段式状态机
	wire [15:0]hs_3fsm;
	wire [15:0]vs_3fsm;
	wire [15:0]pic_ena_3fsm;
	assign hs_3fsm = {{9'b0},{hs5,hs4,hs3,hs2,hs1,hs0,1'b0}} ;
	assign vs_3fsm = {{9'b0},{vs5,vs4,vs3,vs2,vs1,vs0,1'b0}} ;
	assign pic_ena_3fsm = {{9'b0},{pic_ena5,pic_ena4,pic_ena3,pic_ena2,pic_ena1,pre_clken,1'b0}} ;
	*/
	
	three_fsm U_3fsm(
		.clk(clk), 
		.rst(rst),
		.choose(choose),	//选择
		.origin_data(pre_data),
		.grey_data(grey_data),
		.median_data(median_filter_data),
		.hs(hs_3fsm),		//4 bits 的choose 有16种 预留好	
		.vs(vs_3fsm),
		.pic_ena(pic_ena_3fsm),
		.sobel_data(sobel_detect_data_bit),
		.erode_data(erode_data),
		.dilate_data(dilate_data),
		.post_hs(post_HSYNC),//[15:0]HSYNC
		.post_vs(post_VSYNC),//[15:0]VSYNC
		.post_pic_ena(post_clken),//[15:0]
		.VGA_data(post_data)//VGA_data)
	);
	
	//assign post_clken = final_pic_ena;
	//assign 
	//一次性的
	reg [18:0]addra;
	always @(posedge clk or posedge rst)begin	
		if(rst)
			addra <= 1'd0;
		else if(post_clken == 1'b1)
			addra <= addra + 1'b1;
		//else if(addra == 19'd270000 - 1'b1) ///!!!!!!!!!
		//	addra <= 1'd0;
		else
			addra <= addra;
	end		
	
	assign ram_addr = addra;
	
endmodule















	//test
	//wire dilate_value = dilate_data;
	
	//assign VGA_data = pic_ena3 ? {12{sobel_detect_data_bit}} : 12'hf0f;
	//assign VGA_data = pic_ena2 ? {3{median_filter_data[7:4]}}:12'hf0f;
	//assign VGA_data = pic_ena1 ? {grey_data[7:4],grey_data[7:4],grey_data[7:4]} : 12'hf0f;
	//assign VGA_data = pic_ena0 ? {RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1]} : 12'h000;
	/*
	assign {VGA_data} = pic_ena5 ? 
	(choose == 4'b0001 ? 
		{RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1]}:
	(choose == 4'b0010 ? 
		{grey_data[7:4],grey_data[7:4],grey_data[7:4]}: // 3{grey_data[7:4]}不能用 会报错
	(choose == 4'b0011 ?  
		{median_filter_data[7:4],median_filter_data[7:4],median_filter_data[7:4]}:
	(choose == 4'b0100 ?  
		{12{sobel_detect_data_bit}}:
	(choose == 4'b0101 ?  
		{12{erode_data}}:
	(choose == 4'b0110 ?  
		{12{dilate_data}}:  12'b0 )))))): 12'b0;
		*/
	//合并hs vs
	
	//不行
	/*
	assign {VGA_data,HSYNC,VSYNC} = pic_ena5 ? 
	(choose == 4'b0001 ? 
		{RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1],hs0,vs0}:
	(choose == 4'b0010 ? 
		{{3{grey_data[7:4]}},hs1,vs1}: // 3{grey_data[7:4]}不能用 会报错
	(choose == 4'b0011 ?  
		{{3{median_filter_data[7:4]}},hs2,vs2}:
	(choose == 4'b0100 ?  
		{{12{sobel_detect_data_bit}},hs3,vs3}:
	(choose == 4'b0101 ?  
		{{12{erode_data}},hs4,vs4}: 
	(choose == 4'b0110 ?  
		{{12{dilate_data}},hs5,vs5}:  12'b0 )))))): 12'b0;
		*/