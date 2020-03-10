`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 13:52:28
// Design Name: 
// Module Name: clk_divider_precise
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


module clk_divider_precise
#(
	//DEVIDE_CNT = 42.94967296 * fo
//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
	parameter		DEVIDE_CNT = 32'd6597070	//9600bps * 16
)
(
	input			clk,
	input			rst,
	
	output			divide_clk,
	output			divide_clken
);


reg	[31:0]	cnt;
always@(posedge clk or posedge rst)
begin
	if(rst)
		cnt <= 0;
	else
		cnt <= cnt + DEVIDE_CNT;		
end

reg	cnt_equal;
always@(posedge clk or posedge rst)
begin
	if(rst)
		cnt_equal <= 0;
	else if(cnt < 32'h7FFF_FFFF)
		cnt_equal <= 0;
	else
		cnt_equal <= 1;
end


reg	cnt_equal_r;
always@(posedge clk or posedge rst)
begin
	if(rst)
		cnt_equal_r <= 0;
	else
		cnt_equal_r <= cnt_equal;
end
assign	divide_clken = (~cnt_equal_r & cnt_equal) ? 1'b1 : 1'b0; 
assign	divide_clk = cnt_equal_r;


endmodule
