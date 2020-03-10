`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 01:09:06
// Design Name: 
// Module Name: Baud
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


module Baud #
(
parameter				BPS_PARA = 16'd10417 //当使用12MHz时钟时波特率参数选择1250对应9600的波特率
)
(
input					clk_in,		//系统时钟
input					rst_n_in,	//系统复位，低有效
input					bps_en,		//接收或发送时钟使能
output	reg				bps_clk		//接收或发送时钟输出
);	
 
reg				[12:0]	cnt;
//计数器计数满足波特率时钟要求
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) 
		cnt <= 1'b0;
	else if((cnt >= BPS_PARA-1)||(!bps_en)) //当时钟信号不使能（bps_en为低电平）时，计数器清零并停止计数
		cnt <= 1'b0;						//当时钟信号使能时，计数器对系统时钟计数，周期为BPS_PARA个系统时钟周期
	else 
		cnt <= cnt + 1'b1;
end
 
//产生相应波特率的时钟节拍，接收模块将以此节拍进行UART数据接收
always @ (posedge clk_in or negedge rst_n_in)
	begin
		if(!rst_n_in) 
			bps_clk <= 1'b0;
		else if(cnt == (BPS_PARA>>1)) 	//BPS_PARA右移一位等于除2，因计数器终值BPS_PARA为数据更替时间点，所以计数器中值时为数据最稳定时间点
			bps_clk <= 1'b1;	
		else 
			bps_clk <= 1'b0;
	end
 
endmodule
