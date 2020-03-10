`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 13:38:56
// Design Name: 
// Module Name: median_filter
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


module median_filter(
	input clk,
	input rst,
	input vs,
	input hs,
	//input hcount,
	//input vcount,
	input [7:0]grey_data,
	input pic_ena,
	output [7:0]median_filter_data,
	output post_vs,
	output post_hs,
	output post_pic_ena
    );
	  
  wire [7:0]row1,row2;
  reg  [7:0]row3;
  //wire [7:0] row3 = grey_data[7:0] ;
  
 // wire shift_ena;
  //and and1(shift_ena,)
  
  //只用两个shift ram级联
  //vivado只有单行shift ram
	shift_ram_3x3_8bits U_shift_ram1 (
		.D(row3),        // input wire [7 : 0] D
		.CLK(clk),    // input wire CLK //这里debug了好久好久！！！！
		.CE(pic_ena),      // input wire CE	// 改成带使能的 时序报告的slack就过了！！！
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
			row3 <= grey_data;
		else
			row3 <= row3;
	end
	
	//因为消耗了1个时钟，所以同步信号要延迟
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
	//wire hs1,vs1,pic_ena1;
	wire read_matrix_ena = pic_ena_r1[0];//log 1
	assign read_matrix_hs = hs_r1[0];
	assign read_matrix_vs = vs_r1[0];
	//assign pic_ena1 = pic_ena_r1[1];
 
 
	//根据行、场同步信号读取3X3阵列
	//matrix_p_x_y
	reg [7:0] mp11,mp12,mp13;
	reg [7:0] mp21,mp22,mp23;
	reg [7:0] mp31,mp32,mp33;
	
	
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			{mp11,mp12,mp13}<=0;
			{mp21,mp22,mp23}<=0;
			{mp31,mp32,mp33}<=0;
		end
		//else if(read_matrix_hs)
		//begin
			else if(read_matrix_ena)
			begin
				{mp11,mp12,mp13}<={mp12,mp13,row1};
				{mp21,mp22,mp23}<={mp22,mp23,row2};
				{mp31,mp32,mp33}<={mp32,mp33,row3};
			end
			else
			begin
				{mp11,mp12,mp13}<={mp11,mp12,mp13};
				{mp21,mp22,mp23}<={mp21,mp22,mp23};
				{mp31,mp32,mp33}<={mp31,mp32,mp33};
			end
		//end
		//else
		//begin
			//{mp11,mp12,mp13}<={mp11,mp12,mp13};
			//{mp21,mp22,mp23}<={mp21,mp22,mp23};
			//{mp31,mp32,mp33}<={mp31,mp32,mp33};
			//{mp11,mp12,mp13}<=0;
			//{mp21,mp22,mp23}<=0;
			//{mp31,mp32,mp33}<=0;
		//end
		
	end
	
	wire matrix_frame_vs;
	wire matrix_frame_hs;
	wire matrix_frame_ena;
	assign matrix_frame_vs = vs_r1[1];
	assign matrix_frame_hs = hs_r1[1];
	assign matrix_frame_ena = pic_ena_r1[1];
	
	/*
	//再次延迟
	reg [1:0] pic_ena_r2;
	reg [1:0] vs_r2,hs_r2;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			pic_ena_r2 <= 0;
			vs_r2 <= 0;
			hs_r2 <= 0;
		end
		else
		begin
			pic_ena_r2 <= {pic_ena_r2[0],pic_ena1};
			vs_r2 <= {vs_r2[0],vs1};
			hs_r2 <= {hs_r2[0],hs1};
		end
	end
	wire hs2,vs2,pic_ena2;
	assign hs2 = hs_r2[1];
	assign vs2 = vs_r2[1];
	assign pic_ena2 = pic_ena_r2[1];
	*/
	
	//对读取的阵列作中值滤波运算
	//算法详见：
	wire [7:0]max [2:0];
	wire [7:0]min [2:0];
	wire [7:0]mid [2:0];
	
	//step1:每一行排序 1clk
	compare U_row1(
		.clk(clk),
		.rst(rst),
		.data1(mp11),
		.data2(mp12),
		.data3(mp13),
		.min(min[0]),
		.middle(mid[0]),
		.max(max[0])
		);
	
	compare U_row2(
		.clk(clk),
		.rst(rst),
		.data1(mp21),
		.data2(mp22),
		.data3(mp23),
		.min(min[1]),
		.middle(mid[1]),
		.max(max[1])
		);
	
	compare U_row3(
		.clk(clk),
		.rst(rst),
		.data1(mp31),
		.data2(mp32),
		.data3(mp33),
		.min(min[2]),
		.middle(mid[2]),
		.max(max[2])
		);
		
	//step2:小中取大 大中取小，中中取中
	// maxMin == max_of_Min数组
	wire [7:0]maxMin,minMax,midMid;
	compare U_col1(
		.clk(clk),
		.rst(rst),
		.data1(min[0]),
		.data2(min[1]),
		.data3(min[2]),
		.min(),
		.middle(),
		.max(maxMin)
		);
		
	compare U_col2(
		.clk(clk),
		.rst(rst),
		.data1(max[0]),
		.data2(max[1]),
		.data3(max[2]),
		.min(minMax),
		.middle(),
		.max()
		);
	
	compare U_col3(
		.clk(clk),
		.rst(rst),
		.data1(mid[0]),
		.data2(mid[1]),
		.data3(mid[2]),
		.min(),
		.middle(midMid),
		.max()
		);
		
	//step3:再对三个最值取中值
	compare U_col0(
		.clk(clk),
		.rst(rst),
		.data1(minMax),
		.data2(maxMin),
		.data3(midMid),
		.min(),
		.middle(median_filter_data),
		.max()
		);
		
	//取中值共需3步，三个延迟
		
		
	//上面的比较还需要3clk,需要延迟3clk
	//再次延迟
	reg [2:0] pic_ena_r3;
	reg [2:0] vs_r3,hs_r3;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			pic_ena_r3 <= 0;
			vs_r3 <= 0;
			hs_r3 <= 0;
		end
		else
		begin
			pic_ena_r3 <= {pic_ena_r3[1:0],matrix_frame_ena};
			vs_r3 <= {vs_r3[1:0],matrix_frame_vs};
			hs_r3 <= {hs_r3[1:0],matrix_frame_hs};
		end
	end
	//wire hs3,vs3,pic_ena3;
	//assign hs3 = hs_r3[0];
	//assign vs3 = vs_r3[0];
	//assign pic_ena3 = pic_ena_r3[0];


	//assign post_hs = hs_r3[3];
	//assign post_vs = vs_r3[3];
	//assign post_pic_ena = pic_ena_r3[3];
	
	assign post_hs = hs_r3[2];
	assign post_vs = vs_r3[2];
	assign post_pic_ena = pic_ena_r3[2];
	
endmodule

