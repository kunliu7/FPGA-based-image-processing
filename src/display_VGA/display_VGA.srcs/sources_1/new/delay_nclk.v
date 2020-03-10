`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 20:46:42
// Design Name: 
// Module Name: delay_nclk
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


module delay_nclk
#(
	parameter N = 1 	//延迟多少个clk
)
(
	input clk,
	input rst,
    input hs,
    input vs,
    input ena,
    output post_hs,
    output post_vs,
    output post_ena
    );
		
	reg [N - 1:0] ena_r;
	reg [N - 1:0] vs_r;
	reg [N - 1:0] hs_r;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			ena_r <= 0;
			vs_r <= 0;
			hs_r <= 0;
		end
		else
		begin
			ena_r <= {ena_r[N - 2:0],ena};
			vs_r <= {vs_r[N - 2:0],vs};
			hs_r <= {hs_r[N - 2:0],hs};
		end
	end
	
	assign post_hs = hs_r[N - 1];
	assign post_vs = vs_r[N - 1];
	assign post_ena = ena_r[N - 1];
	
endmodule
