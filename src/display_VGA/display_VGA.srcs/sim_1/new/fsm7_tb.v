`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/02 16:11:34
// Design Name: 
// Module Name: fsm9_tb
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


module fsm7_tb;



	//------------------------------------------
	//clock generate module
	reg	clk;  
	reg	rst_n;
	parameter PERIOD = 10;	//100MHz
	initial	
	begin
		clk = 0;
		forever	#(PERIOD/2)	
		clk = ~clk;
	end

	task task_reset;
	begin
		rst_n = 0;
		repeat(2) @(negedge clk);
		rst_n = 1;
	end
	endtask
	wire	clk_ref = clk;
	wire	sys_rst_n = rst_n;
	
	

	//------------------------------------
	//uart interface
	reg				fpga_rxd;
	//wire			fpga_txd;

	
	wire	divide_clken2;
	clk_divider_precise
	#(
		//DEVIDE_CNT = 42.94967296 * fo
		//.DEVIDE_CNT	(32'd412317)	//9600bps
		.DEVIDE_CNT	(32'd10995116)	//256000bps
	)
	u_precise_divider2
	(
		//global
		.clk				(clk_ref),		//100MHz clock
		.rst_n				(sys_rst_n),    //global reset
		
		//user interface
		.divide_clk			(),
		.divide_clken		(divide_clken2)
	);


	//uart data txd simulate
	wire	uart_bps_en = 	divide_clken2;
	task 	task_uart_txd;
	input	[7:0]	uart_data;
	begin
		//8'hCB = 8'b1100_1011	
		@(posedge uart_bps_en);  fpga_rxd = 0;	//Start
		@(posedge uart_bps_en);  fpga_rxd = uart_data[0];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[1];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[2];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[3];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[4];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[5];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[6];
		@(posedge uart_bps_en);  fpga_rxd = uart_data[7];
		@(posedge uart_bps_en);  fpga_rxd = 1;	//End
		//#78;
	end
	endtask


	//---------------------------------------------
	//system initialization
	task task_sysinit;
	begin
		fpga_rxd = 1;
	end
	endtask

	//---------------------------------------
	//testbench of the RTL
	integer i;
	initial
	begin
		task_sysinit;
		task_reset;
		for(i=0 ;i< 32'hffff_ffff; i=i+1)
		begin
		
		task_uart_txd(8'hCB);	
		task_uart_txd(8'h0A);
		
				
		task_uart_txd(8'h09);
		task_uart_txd(8'h0F);	
		
		end
		/*
		task_uart_txd(8'h0F);
		task_uart_txd(8'h09);	
		

		task_uart_txd(8'h01);	
		task_uart_txd(8'h02);	
		
		
		task_uart_txd(8'h07);		
		task_uart_txd(8'h04);	*/

	end

	wire [11:0]VGA_data;
		wire [15:0]led;
		wire HSYNC;
		wire VSYNC;
	disp_VGA U_disp_VGA(
	 .clk(clk),
	 .rxd(fpga_rxd),
	 .rst(1'b0), // effective when 1
	 .choose(4'b0001),//choose mode,binary code, 
	 .HSYNC(HSYNC),
	 .VSYNC(VSYNC),
	 .VGA_data(VGA_data),//,
	 .led(led)
	);
	
	

endmodule

