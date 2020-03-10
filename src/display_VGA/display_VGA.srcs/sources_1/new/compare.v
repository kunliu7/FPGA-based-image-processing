`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 13:38:07
// Design Name: 
// Module Name: compare
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


module compare(
input clk,
input rst,
input [7:0] data1,
input [7:0] data2,
input [7:0] data3,
output reg [7:0] min,
output reg [7:0] middle,
output reg [7:0] max);

    always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			max <= 0;
			min <= 0;
			middle <= 0;
		end
		else
		begin
			if(data1 < data2)
			begin
				if(data2 < data3)
				begin
					min <= data1;
					middle <= data2;
					max <= data3;
				end
				else if(data3 < data1)
				begin
					min <= data3;
					middle <= data1;
					max <= data2;
				end
				else
				begin
					min <= data1;
					middle <= data3;
					max <= data2;
				end
			end
			else
			begin
				if(data1 < data3)
				begin
					min <= data2;
					middle <= data1;
					max <= data3;
				end
				else if(data3 < data2)
				begin
					min <= data3;
					middle <= data2;
					max <= data1;
				end
				else
				begin
					min <= data2;
					middle <= data3;
					max <= data1;
				end
			end
		end
	end
endmodule
