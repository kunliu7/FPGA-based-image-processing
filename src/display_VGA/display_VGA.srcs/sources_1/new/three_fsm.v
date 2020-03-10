`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/17 18:17:57
// Design Name: 
// Module Name: three_fsm
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

// 三段式状态机
module three_fsm(
	input clk,
	input rst,
	input [3:0]choose,	//选择
	input [15:0]origin_data,
	input [7:0]grey_data,
	input [7:0]median_data,
	input [15:0]hs,		//4 bits 的choose 有16种 预留好	
	input [15:0]vs,
	input [15:0]pic_ena,
	input sobel_data,
	input erode_data,
	input dilate_data,
	output  post_hs,//[15:0]
	output  post_vs,//[15:0]
	output  post_pic_ena,//[15:0]
	output  [`VGA_BITS - 1:0]VGA_data
    );
	
	//三段式状态机
	//模板来自网络：https://www.cnblogs.com/sgh69/p/5743451.html
	//（1）第一个always模块，格式化描述次态寄存器迁移到现态寄存器
	reg [3:0]next_state;
	reg [3:0] current_state;
	
	
	
	
	always @ (posedge clk or posedge rst) begin//异步复位 or posedge rst
	if (rst)
		current_state <= `S_IDLE;//初始化按键没按下 //默认状态
	else 
		current_state <= next_state;    //注意，使用的是非阻塞赋值
	end
	
	//（2）第二个进程，组合逻辑always模块，描述状态转移条件判断用current_state
	
	//这里没有将 choose rst 放入端口 为什么不行？？？？？
	
	always @ (current_state or choose or rst) begin //电平触发      或者always @ *
		
		
		//next_state <= choose;//不知道行不行//`S_ORIGIN; //要初始化，使得系统复位后能进入正确的状态
		//next_state = `S_ORIGIN;
		if(rst)
			next_state = `S_IDLE;
		else begin
			//next_state = choose;
			case(choose)
				`S_ORIGIN: next_state = `S_ORIGIN;   //保持原态
			
				`S_GREY: next_state = `S_GREY;
				
				`S_MEDIAN: next_state = `S_MEDIAN;
						
				`S_SOBEL:next_state = `S_SOBEL;
								
				`S_ERODE: next_state = `S_ERODE;
				
				`S_DILATE:next_state = `S_DILATE;	
				
				default: 
					next_state = `S_ORIGIN;
				
			endcase
		end
		
	end
	 
	 
	 
	 
	 
	//(3)第三个进程，同步时序always模块，描述次态寄存器输出
	//3.1 VGA_data
	reg  post_hs_r;//[15:0]
	reg  post_vs_r;//[15:0]
	reg  post_pic_ena_r;//[15:0]
	reg  [`VGA_BITS - 1:0]VGA_data_r;
	
	assign post_hs = post_hs_r;
	assign post_vs = post_vs_r;
	assign post_pic_ena = post_pic_ena_r;
	assign VGA_data = VGA_data_r;
	
	//reg [3:0]choose1,choose2,choose3,choose4,choose5,choose6;
	
	
	always @ (posedge clk or posedge rst) begin //or posedge rst
		if(rst) begin //没有这句话会说ambiguous clk in event control 
			{post_hs_r,post_vs_r,post_pic_ena_r} <= 3'b0;//没用<= 被综合出了multi_driven_net
			VGA_data_r <= 12'b0;
		end
		else begin
			//post_hs <= hs[choose];
			//post_vs <= vs[choose];
			//post_pic_ena <= pic_ena[choose];
			//偷懒
			//{post_hs_r,post_vs_r,post_pic_ena_r}<=
			{post_hs_r,post_vs_r,post_pic_ena_r} <= {hs[choose],vs[choose],pic_ena[choose]};
			//VGA_data_r <= {origin_data[15:12],origin_data[10:7],origin_data[4:1]};//初态 从rst恢复
			//if(~pic_ena[choose])	begin
			//	VGA_data_r <= 12'b0;  //防止连丝
			//end
			//else begin
			//(* EQUIVALENT_REGISTER_REMOVAL="NO" *)
			case(next_state)
			`S_ORIGIN:
			begin
			if(~pic_ena[`S_ORIGIN])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {origin_data[15:12],origin_data[10:7],origin_data[4:1]}; //注意是非阻塞逻辑
			end				
			
			`S_GREY:
			begin
			if(~pic_ena[`S_GREY])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {grey_data[7:4],grey_data[7:4],grey_data[7:4]};
			end
				
			`S_MEDIAN:
			begin
			if(~pic_ena[`S_MEDIAN])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {median_data[7:4],median_data[7:4],median_data[7:4]};
			end
			
			`S_SOBEL:
			begin
			if(~pic_ena[`S_SOBEL])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{sobel_data}};
			end				
			
			`S_ERODE:
			begin
			if(~pic_ena[`S_ERODE])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{erode_data}};
			end
			
			`S_DILATE:
			begin
			if(~pic_ena[`S_DILATE])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{dilate_data}};
			end
			default: //default的作用是免除综合工具综合出锁存器。
				VGA_data_r <= 12'b1111_0000_1111;
			endcase
			//end
		end
	end

	
	
		
	//3.2 hs,vs,pic_ena
	//always @ (posedge clk or posedge rst) begin
		//post_hs
		//
		//{post_hs,post_vs,post_pic_ena} <= {hs[choose],vs[choose],pic_ena[choose]};
		/*
	case(next_state)
	`S_ORIGIN:
		VGA_data <= {origin_data[15:12],origin_data[10:7],origin_data[4:1]}; //注意是非阻塞逻辑
		
	`S_GREY:
		VGA_data <= {grey_data[7:4],grey_data[7:4],grey_data[7:4]};
		
	`S_MEDIAN:
		VGA_data <= {median_filter_data[7:4],median_filter_data[7:4],median_filter_data[7:4]};
	
	`S_SOBEL:
		VGA_data <= {12{sobel_data}};
		
	`S_ERODE:
		VGA_data <= {12{erode_data}};
		
	`S_DILATE:
		VGA_data <= {12{dilate_data}};
	default: //default的作用是免除综合工具综合出锁存器。
		VGA_data <= 12'b0;
		
	endcase
	*/
	//end
	/*
	reg  post_hs_r;//[15:0]
	reg  post_vs_r;//[15:0]
	reg  post_pic_ena_r;//[15:0]
	reg  [`VGA_BITS - 1:0]VGA_data_r;
	
	assign post_hs = post_hs_r;
	assign post_vs = post_vs_r;
	assign post_pic_ena = post_pic_ena_r;
	assign VGA_data = VGA_data_r;

	always @ (posedge clk or posedge rst) begin //or posedge rst
		if(rst) begin
			current_state <= `S_IDLE;
		end
		else begin
			current_state <= choose;
		end
	end

	always @ (posedge clk or posedge rst) begin //or posedge rst
		if(rst) begin //没有这句话会说ambiguous clk in event control 
			{post_hs_r,post_vs_r,post_pic_ena_r} <= 3'b0;//没用<= 被综合出了multi_driven_net
			VGA_data_r <= 12'b0;
		end
		else begin
			//post_hs <= hs[choose];
			//post_vs <= vs[choose];
			//post_pic_ena <= pic_ena[choose];
			//偷懒
			//{post_hs_r,post_vs_r,post_pic_ena_r}<=
			{post_hs_r,post_vs_r,post_pic_ena_r} <= {hs[choose],vs[choose],pic_ena[choose]};
			//VGA_data_r <= {origin_data[15:12],origin_data[10:7],origin_data[4:1]};//初态 从rst恢复
			//if(~pic_ena[choose])	begin
			//	VGA_data_r <= 12'b0;  //防止连丝
			//end
			//else begin
			//(* EQUIVALENT_REGISTER_REMOVAL="NO" *)
			case(current_state)
			`S_ORIGIN:
			begin
			if(~pic_ena[`S_ORIGIN])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {origin_data[15:12],origin_data[10:7],origin_data[4:1]}; //注意是非阻塞逻辑
			end				
			
			`S_GREY:
			begin
			if(~pic_ena[`S_GREY])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {grey_data[7:4],grey_data[7:4],grey_data[7:4]};
			end
				
			`S_MEDIAN:
			begin
			if(~pic_ena[`S_MEDIAN])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {median_data[7:4],median_data[7:4],median_data[7:4]};
			end
			
			`S_SOBEL:
			begin
			if(~pic_ena[`S_SOBEL])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{sobel_data}};
			end				
			
			`S_ERODE:
			begin
			if(~pic_ena[`S_ERODE])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{erode_data}};
			end
			
			`S_DILATE:
			begin
			if(~pic_ena[`S_DILATE])
				VGA_data_r <= 12'b0;
			else
				VGA_data_r <= {12{dilate_data}};
			end
			default: //default的作用是免除综合工具综合出锁存器。
				VGA_data_r <= 12'b1111_0000_1111;
			endcase
			//end
		end
	end*/
	
endmodule