`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/02 21:51:23
// Design Name: 
// Module Name: top_tb
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


module top_tb;
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
	wire			fpga_txd;


	//------------------------------------
	//Precise clk divider
	wire	divide_clken;
	clk_divider_precise	
	#(
		//DEVIDE_CNT = 42.94967296 * fo
		
		.DEVIDE_CNT	(32'd175921860)	//256000bps * 16	
	//	.DEVIDE_CNT	(32'd87960930)	//128000bps * 16
	//	.DEVIDE_CNT	(32'd79164837)	//115200bps * 16
	//	.DEVIDE_CNT	(32'd6597070)	//9600bps * 16
	)
	u_precise_divider
	(
		//global
		.clk				(clk_ref),		//100MHz clock
		.rst_n				(sys_rst_n),    //global reset
		
		//user interface
		.divide_clk			(),
		.divide_clken		(divide_clken)
	);


	wire	clken_16bps = divide_clken;
	//---------------------------------
	//Data receive for PC to FPGA.
	wire			is_one_pic_done;
	wire	[18:0]	ram_addr;
	wire			rxd_flag;
	wire	[15:0]	rxd_data;
	Uart_receiver	u_uart_receiver
	(
		//gobal clock
		.clk			(clk_ref),
		.rst_n			(sys_rst_n),
		
		//uart interface
		.clken_16bps	(clken_16bps),	//clk_bps * 16
		.rxd			(fpga_rxd),		//uart txd interface
		
		//user interface
		.rxd_data		(rxd_data),		//uart data receive
		.rxd_flag		(rxd_flag),		//uart data receive done
		.ram_addr		(ram_addr),
		.is_one_pic_done(is_one_pic_done)
	);

	//---------------------------------
	//Data receive for PC to FPGA.
	/*
	uart_transfer	u_uart_transfer
	(
		//gobal clock
		.clk			(clk_ref),
		.rst_n			(sys_rst_n),
		
		//uaer interface
		.clken_16bps	(clken_16bps),	//clk_bps * 16
		.txd			(fpga_txd),  	//uart txd interface
			   
		//user interface   
		.txd_en			(rxd_flag),		//uart data transfer enable
		.txd_data		(rxd_data), 	//uart transfer data	
		.txd_flag		() 			//uart data transfer done
	);

*/

	//------------------------------------------------------------------------------------------
	//------------------------------------------------------------------------------------------
	//Precise clk divider:9600bps
	//------------------------------------
	//Precise clk divider
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
		#78;
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

	
	
	

endmodule