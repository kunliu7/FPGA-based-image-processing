`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 13:54:52
// Design Name: 
// Module Name: Uart_receiver
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


module Uart_receiver
(
	input	clk,
	input	rst,
	input	clken_16bps,
	input	rxd,		
	
	output	reg[15:0]rxd_data,	
	output	reg		rxd_flag,	
	output	[18:0]	ram_addr,
	output	reg		is_one_pic_done
);


reg	rxd_sync;				
always@(posedge clk or posedge rst)
begin
	if(rst)
		rxd_sync <= 1;
	else
		rxd_sync <= rxd;
end

/*
//parameter of uart transfer
localparam	R_IDLE		=	2'd0;		//detect if the uart data is begin
localparam	R_START		=	2'd1;		//uart transfert start mark bit
localparam	R_SAMPLE	=	2'd2;		//uart 8 bit data receive
localparam	R_STOP		=	2'd3;		//uart transfer stop mark bit
reg	[1:0]	rxd_state;					//uart receive state
reg	[3:0]	rxd_cnt;					//uart 8 bit data counter
reg	[3:0]	smp_cnt;					//16 * clk_bps, the center for sample
localparam	SMP_TOP		=	4'd15;		//采样终点
localparam	SMP_CENTER	=	4'd7;		//采样中点

// 四状态机
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		smp_cnt <= 0;
		rxd_cnt <= 0;
		rxd_state <= R_IDLE;
		end
	else 
		case(rxd_state)
		R_IDLE:		//Wait for start bit
			begin
			rxd_cnt <= 0;
			smp_cnt <= 0;
			if(rxd_sync == 1'b0)			//uart rxd start bit 在IDLE状态下读到的1是开始位
				rxd_state <= R_START;
			else
				rxd_state <= R_IDLE;
			end
			
		R_START:
			begin
			if(clken_16bps == 1)			//clk_bps * 16 16倍波特率的时钟使能信号
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_CENTER && rxd_sync != 1'b0)	//invalid data	判为数据抖动 回到IDLE
					begin
					rxd_cnt <= 0;
					rxd_state <= R_IDLE;
					end
				else if(smp_cnt == SMP_TOP)	//Count for 16 clocks 读了16个时钟
					begin
					rxd_cnt <= 1;			// = 1 时 rxd_syncb被存至[0] start
					rxd_state <= R_SAMPLE;	//start mark bit is over
					end
				else
					begin
					rxd_cnt <= 0;
					rxd_state <= R_START;	//wait start mark bit over
					end
				end
			else							//invalid data 维持原样
				begin
				smp_cnt <= smp_cnt;
				rxd_state <= rxd_state;
				end
			end
			
		R_SAMPLE:	//Sample 8 bit of Uart: {LSB, MSB}
			begin
			if(clken_16bps == 1)			//clk_bps * 16
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					if(rxd_cnt < 4'd8)		//Totally 8 data
						begin
						rxd_cnt <= rxd_cnt + 1'b1;
						rxd_state <= R_SAMPLE;
						end
					else
						begin
						rxd_cnt <= 4'd9;	//Turn of stop bit
						rxd_state <= R_STOP;
						end
					end
				else
					begin
					rxd_cnt <= rxd_cnt;
					rxd_state <= rxd_state;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
			
		R_STOP:
			begin
			if(clken_16bps == 1)		//clk_bps * 16
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					rxd_state <= R_IDLE;
					rxd_cnt <= 0;		//Stop data bit is done
					end
				else
					begin
					rxd_cnt <= 9;		//Stop data bit
					rxd_state <= R_STOP;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
				
		endcase
end

//----------------------------------
//uart data receive in center point
reg	[7:0]	rxd_data_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rxd_data_r <= 0;
	else if(rxd_state == R_SAMPLE)
		begin
		if(clken_16bps == 1 && smp_cnt == SMP_CENTER)	//sample center point
			case(rxd_cnt)
			4'd1:	rxd_data_r[0] <= rxd_sync;
			4'd2:	rxd_data_r[1] <= rxd_sync;
			4'd3:	rxd_data_r[2] <= rxd_sync;
			4'd4:	rxd_data_r[3] <= rxd_sync;
			4'd5:	rxd_data_r[4] <= rxd_sync;
			4'd6:	rxd_data_r[5] <= rxd_sync;
			4'd7:	rxd_data_r[6] <= rxd_sync;
			4'd8:	rxd_data_r[7] <= rxd_sync;
			default:;
			endcase
		else
			rxd_data_r <= rxd_data_r;
		end
	else if(rxd_state == R_STOP)
		rxd_data_r <= rxd_data_r;
	else
		rxd_data_r <= 0;
end



reg [15:0]shift_data; //暂存8bit

//只有两个状态的状态机



reg rxd_flag_r;
reg [1:0]byte_cnt_state;
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		begin
			byte_cnt_state <= 0;
		end
	else if(clken_16bps == 1 && rxd_cnt == 4'd9 && smp_cnt == SMP_TOP) begin
		if(byte_cnt_state < 2'd2)
			byte_cnt_state <= byte_cnt_state + 1;
		else
			byte_cnt_state <= 0;
	end
	else 
		byte_cnt_state <= byte_cnt_state;
end



reg is_one_pic_done;

reg [15:0] rxd_data_r1;
reg rxd_flag_r1;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin

		shift_data <= 16'b0;
		end
	else if(is_one_pic_done) begin//已经发送完一张图片了

	end
	else if(clken_16bps == 1 && rxd_cnt == 4'd9 && smp_cnt == SMP_TOP)	//Start + 8 Bit + Stop Bit
		begin


		//读好一个byte了
		//--------------------------------
		shift_data <= {shift_data[7:0],rxd_data_r};

		end
	else
		begin
		//rxd_data_r1 <= rxd_data_r1;
		//rxd_flag_r1 <= 1'b0;
		shift_data <= shift_data;
		end
end



// 导到外面去以后 flag为1时才能存进ram
assign rxd_data = rxd_data_r;
assign rxd_flag = rxd_flag_r; //r1才是真正要输出的




//update rxd_data


//update rxd_flag
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		rxd_data_r <= 0;
		rxd_flag_r <= 0;
		end
	else begin 
		if(is_one_pic_done) begin
			rxd_data_r <= 0;
			rxd_flag_r <= 0;
		end	
		else begin
		if(byte_cnt_state == 2'b1)	//Start + 8 Bit + Stop Bit
			begin
			rxd_data_r <= shift_data;
			rxd_flag_r <= 1;
			end
		else
			begin
			rxd_data_r <= rxd_data_r;
			rxd_flag_r <= 0;
			end
		end
	end
end

*/


localparam	R_IDLE		=	4'd0;		
localparam	R_START1	=	4'd1;		
localparam	R_START2	=	4'd6;		
localparam	R_SAMPLE1	=	4'd2;		
localparam	R_SAMPLE2	=	4'd3;		
localparam	R_STOP1		=	4'd4;		
localparam	R_STOP2		=	4'd5;		

reg	[3:0]	rxd_state;					
reg	[4:0]	rxd_cnt;					
reg	[3:0]	smp_cnt;					
localparam	SMP_TOP		=	4'd15;
localparam	SMP_CENTER	=	4'd7;
always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
		smp_cnt <= 0;
		rxd_cnt <= 0;
		rxd_state <= R_IDLE;
		end
	else 
		case(rxd_state)
		R_IDLE:		
			begin
			rxd_cnt <= 0;
			smp_cnt <= 0;
			if(rxd_sync == 1'b0)			
				rxd_state <= R_START1;
			else
				rxd_state <= R_IDLE;
			end
			
		R_START1:
			begin
			if(clken_16bps == 1)			
				begin
				smp_cnt <= smp_cnt + 1'b1;
				//if(smp_cnt == SMP_CENTER && rxd_sync != 1'b0)	//invalid data	
				//	begin
				//	rxd_cnt <= 0;
				//	rxd_state <= R_IDLE;
				//	end
				//else 
				if(smp_cnt == SMP_TOP)	
					begin
					rxd_cnt <= 1; 			
					rxd_state <= R_SAMPLE1;	
					end
				else
					begin
					rxd_cnt <= 0;
					rxd_state <= R_START1;	
					end
				end
			else							
				begin
				smp_cnt <= smp_cnt;
				rxd_state <= rxd_state;
				end
			end
			
		R_SAMPLE1:	
			begin
			if(clken_16bps == 1)			
				begin
				smp_cnt <= smp_cnt + 1'b1; //smp_cnt只有4位 在Start中是15才能跳转到这里，再加一变成0
				if(smp_cnt == SMP_TOP)
					begin
					if(rxd_cnt < 5'd8)		
						begin
						rxd_cnt <= rxd_cnt + 1'b1;
						rxd_state <= R_SAMPLE1;
						end
					else
						begin
						rxd_cnt <= 5'd9;	
						rxd_state <= R_STOP1;
						end
					end
				else
					begin
					rxd_cnt <= rxd_cnt;
					rxd_state <= rxd_state;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
		
		R_STOP1:
			begin
			if(clken_16bps == 1)	
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					rxd_state <= R_START2; 
					rxd_cnt <= 5'd9;		
					end
				else
					begin
					rxd_cnt <= 5'd9;		
					rxd_state <= R_STOP1;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
		
		R_START2:
			begin
			if(clken_16bps == 1)			
				begin
				smp_cnt <= smp_cnt + 1'b1;
				//if(smp_cnt == SMP_CENTER && rxd_sync != 1'b0)	//invalid data	
				//	begin
				//	rxd_cnt <= 0;
				//	rxd_state <= R_IDLE;
				//	end
				//else 
				if(smp_cnt == SMP_TOP)	
					begin
					rxd_cnt <= 5'd10; 			//改！！！！！！！！！！！！！！！
					rxd_state <= R_SAMPLE2;	
					end
				else
					begin
					rxd_cnt <= 5'd9;
					rxd_state <= R_START2;	
					end
				end
			else							
				begin
				smp_cnt <= smp_cnt;
				rxd_state <= rxd_state;
				end
			end
		
		R_SAMPLE2:	
			begin
			if(clken_16bps == 1)			
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					if(rxd_cnt < 5'd17)		
						begin
						rxd_cnt <= rxd_cnt + 1'b1;
						rxd_state <= R_SAMPLE2;
						end
					else
						begin
						rxd_cnt <= 5'd18;	
						rxd_state <= R_STOP2;
						end
					end
				else
					begin
					rxd_cnt <= rxd_cnt;
					rxd_state <= rxd_state;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
		
		R_STOP2:
			begin
			if(clken_16bps == 1)		
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					rxd_state <= R_IDLE;
					rxd_cnt <= 0;		
					end
				else
					begin
					rxd_cnt <= 5'd19;		
					rxd_state <= R_STOP2;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
		default:;
		endcase
end

//----------------------------------
//uart data receive in center point
reg	[15:0]	rxd_data_r;
always@(posedge clk or posedge rst)
begin
	if(rst)
		rxd_data_r <= 0;
	else if((rxd_state == R_SAMPLE1)||(rxd_state == R_SAMPLE2)) //改
		begin
		if(clken_16bps == 1 && smp_cnt == SMP_CENTER)	
			case(rxd_cnt)
			/*
			5'd1:	rxd_data_r[0]  <= rxd_sync;
			5'd2:	rxd_data_r[1]  <= rxd_sync;
			5'd3:	rxd_data_r[2]  <= rxd_sync;
			5'd4:	rxd_data_r[3]  <= rxd_sync;
			5'd5:	rxd_data_r[4]  <= rxd_sync;
			5'd6:	rxd_data_r[5]  <= rxd_sync;
			5'd7:	rxd_data_r[6]  <= rxd_sync;
			5'd8:	rxd_data_r[7]  <= rxd_sync;
			
			5'd10:	rxd_data_r[8]  <= rxd_sync;
			5'd11:	rxd_data_r[9]  <= rxd_sync;
			5'd12:	rxd_data_r[10] <= rxd_sync;
			5'd13:	rxd_data_r[11] <= rxd_sync;
			5'd14:	rxd_data_r[12] <= rxd_sync;
			5'd15:	rxd_data_r[13] <= rxd_sync;
			5'd16:	rxd_data_r[14] <= rxd_sync;
			5'd17:	rxd_data_r[15] <= rxd_sync;		*/
			//先发的是高位！！！
			5'd1:	rxd_data_r[8]  <= rxd_sync;
			5'd2:	rxd_data_r[9]  <= rxd_sync;
			5'd3:	rxd_data_r[10] <= rxd_sync;
			5'd4:	rxd_data_r[11] <= rxd_sync;
			5'd5:	rxd_data_r[12] <= rxd_sync;
			5'd6:	rxd_data_r[13] <= rxd_sync;
			5'd7:	rxd_data_r[14] <= rxd_sync;
			5'd8:	rxd_data_r[15] <= rxd_sync;
			
			5'd10:	rxd_data_r[0]  <= rxd_sync;
			5'd11:	rxd_data_r[1]  <= rxd_sync;
			5'd12:	rxd_data_r[2]  <= rxd_sync;
			5'd13:	rxd_data_r[3]  <= rxd_sync;
			5'd14:	rxd_data_r[4]  <= rxd_sync;
			5'd15:	rxd_data_r[5]  <= rxd_sync;
			5'd16:	rxd_data_r[6]  <= rxd_sync;
			5'd17:	rxd_data_r[7]  <= rxd_sync;
			

/*
			5'd1:	rxd_data_r[15]  <= rxd_sync;
			5'd2:	rxd_data_r[14]  <= rxd_sync;
			5'd3:	rxd_data_r[13]  <= rxd_sync;
			5'd4:	rxd_data_r[12]  <= rxd_sync;
			5'd5:	rxd_data_r[11]  <= rxd_sync;
			5'd6:	rxd_data_r[10]  <= rxd_sync;
			5'd7:	rxd_data_r[9]  <= rxd_sync;
			5'd8:	rxd_data_r[9]  <= rxd_sync;
			
			5'd10:	rxd_data_r[7]  <= rxd_sync;
			5'd11:	rxd_data_r[6]  <= rxd_sync;
			5'd12:	rxd_data_r[5] <= rxd_sync;
			5'd13:	rxd_data_r[4] <= rxd_sync;
			5'd14:	rxd_data_r[3] <= rxd_sync;
			5'd15:	rxd_data_r[2] <= rxd_sync;
			5'd16:	rxd_data_r[1] <= rxd_sync;
			5'd17:	rxd_data_r[0] <= rxd_sync;
*/			
			default:;
			endcase
		else
			rxd_data_r <= rxd_data_r;
		end
	else if((rxd_state == R_STOP1)||(rxd_state == R_STOP2)||(rxd_state == R_START2)) //改
		rxd_data_r <= rxd_data_r;
	else
		rxd_data_r <= 16'hffff;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
		rxd_data <= 0;
		rxd_flag <= 0;
		end
	else if(clken_16bps == 1 &&  rxd_cnt == 5'd19 && smp_cnt == SMP_TOP)	
		begin
		rxd_data <= rxd_data_r;
		rxd_flag <= 1;
		end
	else
		begin
		rxd_data <= rxd_data_r;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		rxd_flag <= 0;
		end
end

//存储地址:
reg [18:0] ram_addr_r;
always@(posedge clk or posedge rst)
begin
	if(rst) begin
		is_one_pic_done <= 1'b0;
		ram_addr_r <= 19'b0;
		end
	else begin
		if(rxd_flag == 1'b1) begin
			is_one_pic_done <= 1'b0;
			ram_addr_r <= ram_addr_r + 1'b1;
		end
		else if(ram_addr_r >= 19'd269999) begin //一次性
			is_one_pic_done <= 1'b1;
			ram_addr_r <= ram_addr_r;
		end
		else begin
			ram_addr_r <= ram_addr_r;
			is_one_pic_done <= is_one_pic_done;
		end
	end
end




assign ram_addr = ram_addr_r;
 
endmodule

