`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/03 11:39:50
// Design Name: 
// Module Name: Uart_no_sample_receiver
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


module Uart_no_sample_receiver(
	//gobal clock
	input				clk,
	input				rst,
	
	//user interface
	input				clken_16bps,//clk_bps * 16
	
	//uart interface
	input				rxd,		//uart txd interface
	output		reg[15:0]	rxd_data,	//uart data receive
	output		reg		rxd_flag,	//uart data receive done 
	output 			[4:0]	rxd_cnt_show,
	output		[18:0]	ram_addr
);


/**************************************************************************
..IDLE...Start...............UART DATA........................End...IDLE...
________													 ______________
        |____< D0 >< D1 >< D2 >< D3 >< D4 >< D5 >< D6 >< D7 >
		Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7  Bit8  Bit9
**************************************************************************/

//---------------------------------
//sync the rxd data: rxd_sync
reg	rxd_sync;				
always@(posedge clk or posedge rst)
begin
	if(rst)
		rxd_sync <= 1;
	else
		rxd_sync <= rxd;
end

//---------------------------------------
//parameter of uart transfer
localparam	R_IDLE		=	4'd0;		//detect if the uart data is begin
localparam	R_START1	=	4'd1;		//uart transfert start mark bit
localparam	R_START2	=	4'd6;		//uart transfert start mark bit
localparam	R_SAMPLE1	=	4'd2;		//uart 8 bit data receive
localparam	R_SAMPLE2	=	4'd3;		//uart 8 bit data receive
localparam	R_STOP1		=	4'd4;		//uart transfer stop mark bit
localparam	R_STOP2		=	4'd5;		//uart transfer stop mark bit

//reg [3:0]	nxt_state;
reg	[3:0]	rxd_state;					//uart receive state
reg	[4:0]	rxd_cnt;					//uart 8 bit data counter
//reg	[3:0]	smp_cnt;					//16 * clk_bps, the center for sample
localparam	SMP_TOP		=	4'd1;
localparam	SMP_CENTER	=	4'd0;

assign rxd_cnt_show = rxd_cnt;
//一次性读取
always@(posedge clk or posedge rst)
begin

	if(rst) begin
		//rxd_state <= IDLE;
		rxd_cnt <= 5'd0;
		rxd_state <= R_IDLE;
		end
	else begin
		if(clken_16bps==1)begin
			case(rxd_state)
				R_IDLE:begin
					if(rxd_sync == 1'b0)begin
						rxd_state <= R_SAMPLE1;
						rxd_cnt <= 5'b1;
						end
					else begin
						rxd_state <= R_IDLE;
						rxd_cnt <= 5'b0;
						end
				end
		
				
				R_SAMPLE1:begin
					if(rxd_cnt < 5'd8 )begin
						rxd_cnt <= rxd_cnt + 1;
						rxd_state <= R_SAMPLE1;
						end
					else begin
						rxd_cnt <= 5'd9;
						rxd_state <= R_STOP1;
						end
					
				end
				
				R_STOP1:begin
					rxd_cnt <= 5'd9;
					rxd_state <= R_START2;
				end
				
				R_START2:begin
					rxd_cnt <= 5'd10;
					rxd_state <= R_SAMPLE2;
				end
			
				R_SAMPLE2:begin
					if(rxd_cnt < 5'd17 ) begin
						rxd_cnt <= rxd_cnt + 1;
						rxd_state <= R_SAMPLE2;
						end
					else begin
						rxd_cnt <= 5'd18;
						rxd_state <= R_STOP2;
						end
				end
				
				R_STOP2:begin
					rxd_cnt <= 5'd19;
					rxd_state <= R_IDLE;
				end
				
				default:;
				endcase
			end
		else begin
			rxd_state <= rxd_state;
			rxd_cnt <= rxd_cnt;
			end
		
	end

end

reg	[15:0]	rxd_data_r;
always@(posedge clk or posedge rst)
begin
	if(rst)
		rxd_data_r <= 0;
	else if((rxd_state == R_SAMPLE1)||(rxd_state == R_SAMPLE2)) //改
		begin
		if(clken_16bps == 1)	//sample center point
			case(rxd_cnt)
		
			5'd1:	rxd_data_r[8]  <= rxd_sync;
			5'd2:	rxd_data_r[9]  <= rxd_sync;
			5'd3:	rxd_data_r[10]  <= rxd_sync;
			5'd4:	rxd_data_r[11]  <= rxd_sync;
			5'd5:	rxd_data_r[12]  <= rxd_sync;
			5'd6:	rxd_data_r[13]  <= rxd_sync;
			5'd7:	rxd_data_r[14]  <= rxd_sync;
			5'd8:	rxd_data_r[15]  <= rxd_sync;
			
			5'd10:	rxd_data_r[0]  <= rxd_sync;
			5'd11:	rxd_data_r[1]  <= rxd_sync;
			5'd12:	rxd_data_r[2] <= rxd_sync;
			5'd13:	rxd_data_r[3] <= rxd_sync;
			5'd14:	rxd_data_r[4] <= rxd_sync;
			5'd15:	rxd_data_r[5] <= rxd_sync;
			5'd16:	rxd_data_r[6] <= rxd_sync;
			5'd17:	rxd_data_r[7] <= rxd_sync;
			
			default:
				rxd_data_r <= rxd_data_r;
			endcase
		else
			rxd_data_r <= rxd_data_r;
		end
	else if((rxd_state == R_STOP1)||(rxd_state == R_STOP2)||(rxd_state == R_START2)) //改
		rxd_data_r <= rxd_data_r;
	else
		rxd_data_r <= 0;
end





always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
		rxd_data <= 0;
		rxd_flag <= 0;
		end
	else if(clken_16bps == 1 && rxd_cnt == 5'd18)	
		begin
		rxd_data <= rxd_data_r;
		rxd_flag <= 1;
		end
	else
		begin
		rxd_data <= rxd_data;
		rxd_flag <= 0;
		end
end


reg [18:0] ram_addr_r;
always@(posedge clk or posedge rst)
begin
	if(rst) begin
		//is_one_pic_done <= 1'b0;
		ram_addr_r <= 19'b0;
		end
	else begin
		if(rxd_flag == 1'b1) begin
			//is_one_pic_done <= 1'b0;
			ram_addr_r <= ram_addr_r + 1'b1;
		end
		else if(ram_addr_r >= 19'd269999) begin //一次性
			//is_one_pic_done <= 1'b1;
			ram_addr_r <= ram_addr_r;
		end
		else begin
			ram_addr_r <= ram_addr_r;
			//is_one_pic_done <= is_one_pic_done;
		end
	end
end

endmodule
