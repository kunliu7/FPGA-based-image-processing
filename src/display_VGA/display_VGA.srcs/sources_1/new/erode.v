`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/08 16:50:04
// Design Name: 
// Module Name: erode
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


module erode(
	input clk,
	input rst,
	input pic_ena,
	input vs,
	input hs,
	input sobel_detect_data_bit,
	output erode_data,
	output post_vs,
	output post_hs,
	output post_pic_ena
    );
	
	wire row2,row1;
	reg row3;
	
	shift_ram_3x3_1bit U_shift_ram_3x3_1bit1 (
		.D(row3),       // input wire [0 : 0] D
		.CLK(clk),    	// input wire CLK
		.CE(pic_ena),   // input wire CE
		.SCLR(1'b0),  	// input wire SCLR
		.Q(row2)        // output wire [0 : 0] Q
	);
	
	shift_ram_3x3_1bit U_shift_ram_3x3_1bit0 (
		.D(row2),       // input wire [0 : 0] D
		.CLK(clk),    	// input wire CLK
		.CE(pic_ena),   // input wire CE
		.SCLR(1'b0),  	// input wire SCLR
		.Q(row1)        // output wire [0 : 0] Q
	);
	
	// consume 1 clk
	always@(posedge clk or posedge rst) begin
		if(rst)
			row3 <= 0;
		else if(pic_ena)
			row3 <= sobel_detect_data_bit;
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
	reg  mp11,mp12,mp13;
	reg  mp21,mp22,mp23;
	reg  mp31,mp32,mp33;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			{mp11,mp12,mp13}<=0;
			{mp21,mp22,mp23}<=0;
			{mp31,mp32,mp33}<=0;
		end
		else if(read_matrix_ena) begin
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
	
	//	以上除了 IP core 的 width 是 1bit 以外，其它都和sobel、median一样
	// 分两步 流水线 加快速度
	// Step 1,对每一行&
	reg line1,line2,line3;
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			line1 <= 0;
			line2 <= 0;
			line3 <= 0;
		end
		else begin
			line1 <= mp11 & mp12 & mp13;
			line2 <= mp21 & mp22 & mp23;
			line3 <= mp31 & mp32 & mp33;
		end	
	end	
	
	// Step 2,对每一行&的结果再与
	reg line;
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			line <= 0;
		end
		else begin
			line <= line1 & line2 & line3;
		end	
	end	
	
	assign erode_data = line;
	delay_nclk #(.N(2))
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
endmodule
