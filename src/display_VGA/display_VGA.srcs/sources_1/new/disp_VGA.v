`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/03 21:09:06
// Design Name: Liukun
// Module Name: disp_VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 		目标：根据choose选择各种模式显示
//		经过查看时序报告反复验证，output = ？：的多层嵌套的方法会造成较大的延迟，导致时序违例
//		如果是只要最终处理的结果的话则没有以上问题
//		但如果需要把每步处理的过程根据按钮全部显示出来的话，就需要用新的方法 : 状态机
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "headfile.v"

module disp_VGA(
	input clk,
	input rxd,
	input rst, // effective when 1
	input [3:0]choose,//choose mode,binary code, 
	output  HSYNC,
	output  VSYNC,
	output [12-1:0] VGA_data,
	output [15:0]led
);
	reg sys_rst;
	

	wire [11:0] hcount;	//计数
	wire [11:0] vcount;
	wire clk_40m;
	wire clk_80m;
	wire clk_100m;
	
	wire divide_clken;
	wire [15:0]Uart_data;
	//wire [15:0]Uart_data;//16bit 做了转换
	wire rxd_flag;
	assign led = Uart_data;
	
	
	wire [11:0]post_data;
	wire post_clken;
	wire [18:0]ram_addr;//!!!!!!!!!!!!!!!
	
	//wire [19:0]ram_addr;//!!!!!!!!!!!!!!!
	//wire [7:0]ram_data;
	
	// PLL分频 clk100M --> clk_25m
	clk_VGA U_Clk(
		.clk(clk),
		.clk_40m(clk_40m),
		.clk_80m(clk_80m),
		.clk_100m(clk_100m),
		.rst_n(~rst)
	); 

	always@ (posedge clk_100m or posedge rst) begin
		if(rst)
			sys_rst <= 1;
		else
			sys_rst <= rst;
	
	end
	//!!!!!!!!!!!怀疑上面有延迟
	
	/*
	//--------------------..........................................
	wire					bps_en_rx,bps_clk_rx;
	wire			[15:0]	rx_data;
	
	
	
	//UART接收波特率时钟控制模块 例化
	Baud #
	(
	.BPS_PARA				(16'd10417		)//256000:391
	)
	Baud_rx
	(	
	.clk_in					(clk_100m		),	//系统时钟
	.rst_n_in				(~sys_rst		),	//系统复位，低有效
	.bps_en					(bps_en_rx		),	//接收时钟使能
	.bps_clk				(bps_clk_rx		)	//接收时钟输出
	);
	 
	//UART接收数据模块 例化
	Uart_Rx Uart_Rx_uut
	(
	.clk_in					(clk_100m		),	//系统时钟
	.rst_n_in				(~sys_rst		),	//系统复位，低有效
	.bps_en					(bps_en_rx		),	//接收时钟使能
	.bps_clk				(bps_clk_rx		),	//接收时钟输入
	.rs232_rx				(rxd			),	//UART接收输入
	.rx_data				(rx_data		),	//接收到的数据
	.ram_addr				(ram_addr		)
	);
	
	assign led = rx_data;
	assign Uart_data = rx_data;
	//---------------------.............................................*/
	
	wire divide_clk;

	clk_divider_precise 
	#(
		
	//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
	//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
	//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
		//.DEVIDE_CNT(32'd6597070)	//9600bps * 16
		.DEVIDE_CNT(32'd175921860)	//256000bps * 16
		//.DEVIDE_CNT(32'd6597070) //9600
	)
	U_clk_divider_precise
	(
		.clk(clk_100m), //!!!!!原始100MHZ的clk！！！！
		.rst(sys_rst),
		
		.divide_clk(),//禁止使用分频后的时钟 详情见网页收藏夹
		.divide_clken(divide_clken) //对于全局时钟clk 100MHZ的时钟使能 
	);

	wire is_one_pic_done;
	
	Uart_receiver_1byte U_receiver
	(
		.clk(clk_100m),
		.rst_n(~sys_rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 只有当clken为1时才可采样
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),		//uart data receive done 
		.ram_addr(ram_addr)
		//.is_one_pic_done(is_one_pic_done)
	);
	
	/*
	Uart_no_sample_receiver U_receiver(
	//gobal clock
		.clk(clk_100m),
		.rst(rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 只有当clken为1时才可采样
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),		//uart data receive done 
		.ram_addr(ram_addr)
	);*/
	
	/*
	Uart_receiver_1byte U_receiver_1byte(
	//gobal clock
		.clk(clk_100m),
		.rst_n(~rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 只有当clken为1时才可采样
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),			//uart data receive done 
		.ram_addr(ram_addr)
		//.is_one_pic_done(is_one_pic_done)
	);
	*/
	
	//assign VGA_data = {Uart_data[15:12],Uart_data[10:7],Uart_data[4:1]};
	
	//图像处理的clk 和 VGA的clk 不一样！！！
	//wire [15:0]pre_data;
	//wire pre_clken;
	//assign pre_data = Uart_data;
	//assign pre_clken = rxd_flag;
	wire [18:0]VGA_data_addr;
	wire pic_ena;
/*
	Uart_VGA_ram U_Uart_VGA_ram (
		.clka(clk_100m),    	// input wire clka  全局时钟！！！
		.ena(1'b1),      		// input wire ena  //直觉觉得需要延迟
		.wea(rxd_flag),      	// input wire [0 : 0] wea
		.addra(ram_addr),  		// input wire [18 : 0] addra
		.dina(Uart_data),    	// input wire [15 : 0] dina
		
		
		//.clkb(),    	// input wire clkb	一个clk上升沿 wea决定了只能是读还是写
		//.enb(),      	// input wire enb
		//.addrb(),  	// input wire [18 : 0] addrb
		//.doutb()  	// output wire [15 : 0] doutb
		//防止冲突，上升沿写入，下降沿读出？？？？？？可行吗
		.clkb(clk_40m),    		// input wire clkb	一个clk上升沿 wea决定了只能是读还是写
		.enb(1'b1),      		// input wire enb
		.addrb(VGA_data_addr),  // input wire [18 : 0] addrb
		.doutb(ram_data)  		// output wire [15 : 0] doutb
	);*/
	/*
	reg rxd_flag_r;
	reg [18:0]ram_addr_r;
	reg [15:0]Uart_data_r;
	
	always@(posedge clk_100m or posedge rst)
	begin
		if(rst) begin
			rxd_flag_r <= 0;
			ram_addr_r <= 0;
			Uart_data_r <= 0;
		end
		else begin
			rxd_flag_r <= rxd_flag;
			ram_addr_r <= ram_addr;
			Uart_data_r <= Uart_data;			
		end
			
	end
	*/
	//wire [15:0] ram_data_r;
	wire [15:0]	ram_data;
	
	Uart_VGA_ram U_Uart_VGA_ram(
	//Uart_VGA_ram U_Uart_VGA_ram (
	  .clka(clk_100m),    	// input wire clka
	  .ena(1'b1),      		// input wire ena
	  .wea(rxd_flag),     	 // input wire [0 : 0] wea
	  .addra(ram_addr),  		// input wire [18 : 0] addra
	  .dina(Uart_data),   	 // input wire [15 : 0] dina
	  .douta(),  			// output wire [15 : 0] douta
	  
	  .clkb(clk_40m),  	 	 // input wire clkb
	  .enb(1'b1),     	 	// input wire enb
	  .web(1'b0),     		 // input wire [0 : 0] web
	  .addrb(VGA_data_addr),  // input wire [18 : 0] addrb
	  .dinb(),   				 // input wire [15 : 0] dinb
	  .doutb(ram_data)  		// output wire [15 : 0] doutb
	);
	
	
	/*
	always@(posedge clk_40m or posedge rst) begin
		if(rst) begin
			ram_data <= 0;
		end
		else begin
			ram_data <= ram_data_r;
		end
	end
	asyn_ram  
	#(
		.DWIDTH(5'd16),	//data width				
		.AWIDTH(19'd270000)		//address width 
	)
	my_ram
	(	
		.wr_clk(clk_100m),//input wr_clk,	
		.wr_data(Uart_data),//input [DWIDTH-1:0] wr_data,	
		.wr_en(rxd_flag),//input wr_en,	
		.wr_addr(ram_addr),//input [AWIDTH-1:0] wr_addr,		
		
		.rd_clk(clk_40m),//input  rd_clk,	
		.rd_data(ram_data),//output [DWIDTH-1:0] rd_data,	
		.rd_en(1'b0),//input  rd_en,	
		.rd_addr(VGA_data_addr)//input [AWIDTH-1:0] rd_addr
	); */
	/*
	always@(posedge clk_40m or posedge rst) begin
		if(rst) begin
				VGA_data <= 12'hff0;
		end
		else begin
			if(pic_ena)
				VGA_data <= {ram_data_r[15:12],ram_data_r[10:7],ram_data_r[4:1]};
			else
				VGA_data <= 12'hff0;
		end
	end
	*/
	//assign VGA_data = pic_ena ? {ram_data[15:12],ram_data[10:7],ram_data[4:1]}: 12'hfff;
	
	wire pre_HSYNC;
	wire pre_VSYNC;
		
	// 计数扫描
	scan U_scan(
		.clk(clk_40m), //VGA时钟！！！！
		.rst(sys_rst),
		
		.HSYNC(pre_HSYNC),
		.VSYNC(pre_VSYNC),
		.hcount(hcount),
		.vcount(vcount),
		.pic_ena(pic_ena),
		.VGA_data_addr(VGA_data_addr)
	);
	
	
	process_pic U_process_pic(
		.clk(clk_40m),
		.rst(sys_rst),
		.pre_clken(pic_ena),
		.pre_data(ram_data),
		.choose(choose),
		
		.pre_HSYNC(pre_HSYNC),
		.pre_VSYNC(pre_VSYNC),
		
		.post_data(VGA_data),
		.post_clken(post_clken),
		.post_HSYNC(HSYNC),//HSYNC),
		.post_VSYNC(VSYNC)//VSYNC)
		//.ram_addr(ram_addr)
	);
	
/*
	VGA_display U_VGA_display(
		.clk(clk_40m),
		.rst(rst),
		.ram_data(ram_data),
		.hcount(hcount),
		.vcount(vcount),
		
		
		.VGA_data(VGA_data),//---> 输出
		.VGA_data_addr(VGA_data_addr)
    );
	//assign VGA_data = post_data;
	*/

endmodule





		// 这种方法确定很不行 是延迟跟不上？
		/*
	assign HSYNC = pic_ena0 ? 
	(choose == 4'b0001 ? 
		hs0:
	(choose == 4'b0010 ? 
		hs1: // 3{tmp_data_gety[7:4]}不能用 会报错
	(choose == 4'b0011 ?  
		hs2:  0 ))): 0;
  
	assign VSYNC = pic_ena0 ? 
	(choose == 4'b0001 ? 
		vs0:
	(choose == 4'b0010 ? 
		vs1: // 3{tmp_data_gety[7:4]}不能用 会报错
	(choose == 4'b0011 ?  
		vs2:  0 ))): 0;
*/
	
  
  /*
always@(negedge clk_40m)
	begin
	if(VGA_data_ena && pic_ena)
		VGA_data = {RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1]};
	else
		VGA_data = 0;
	end
  
  */
  
/*	
always @ (*)
  begin	
  if	 ((hcount > `HSYNC_B) && (hcount <= `HSYNC_B + 10'd100) && VGA_data_ena)			
  VGA_data = 12'hf00;//{4‘b1,4‘b0,4‘b0};//12'hE0;			//红色	
  else if((hcount > `HSYNC_B + 10'd100) && (hcount <= `HSYNC_B + 10'd200) && VGA_data_ena)			
  VGA_data = 12'h0f0;//{4‘b0,4‘b1,4‘b0};//12'hFC;			//green色	
  else if((hcount > `HSYNC_B + 10'd200) && (hcount <= `HSYNC_B + 10'd300) && VGA_data_ena)			
  VGA_data = 12'h00f;//{4‘b0,4‘b0,4‘b1};//12'h03;			//蓝色	
  else if((hcount > `HSYNC_B + 10'd300) && (hcount <= `HSYNC_B + 10'd400) && VGA_data_ena)			
  VGA_data = 12'hff0;//{4‘b1,4‘b1,4‘b0};//12'h1C;			//绿色	
  else if((hcount > `HSYNC_B + 10'd400) && (hcount <= `HSYNC_B + 10'd500) && VGA_data_ena)			
  VGA_data = 12'h0ff;//{4‘b1,4‘b1,4‘b0};//12'h1C;			//	
  else if((hcount > `HSYNC_B + 10'd500) && (hcount <= `HSYNC_B + 10'd600) && VGA_data_ena)			
  VGA_data = 12'h000;//{4‘b1,4‘b1,4‘b0};//12'h1C;			//	
  else if((hcount > `HSYNC_B + 10'd600) && (hcount <= `HSYNC_B + 10'd700) && VGA_data_ena)			
  VGA_data = 12'h111;//{4‘b1,4‘b1,4‘b0};//12'h1C;			//	
  else		
  VGA_data = 12'hfff;//{4‘b0,4‘b1,4‘b1};12'h00;				//黑色	
  end
*/	


  /*  
clk_VGA instance_name
 (
 // Clock in ports
  .clk(clk),      // input clk
  // Clock out ports
  .clk_25m(clk_25m),     // output clk_25m
  // Status and control signals
  .rst(rst));       // input rst
  
  
blk_mem_VGA your_instance_name (
    .clka(clka),    // input wire clka
    .addra(addra),  // input wire [18 : 0] addra
    .douta(douta)  // output wire [7 : 0] douta
  );    */

  /*
  always @(posedge CLK, negedge RST)  //VGA 显示部分	
  if(!RST)		begin red<=1'b0; green<=1'b0; blue<=1'b0;end
  else begin 			 
  if((CH>Ha+Hb)&&(CH<=Ha+Hb+7'd80))			 
  begin red<=1'b1; green<=1'b0; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+7'd80)&&(CH<=Ha+Hb+8'd160))			 
  begin red<=1'b0; green<=1'b0; blue<=1'b1;
  end			 
  if((CH>Ha+Hb+8'd160)&&(CH<=Ha+Hb+9'd240))			 
  begin red<=1'b1; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd240)&&(CH<=Ha+Hb+9'd320))			 
  begin red<=1'b1; green<=1'b0; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd320)&&(CH<=Ha+Hb+9'd400))			 
  begin red<=1'b0; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd400)&&(CH<=Ha+Hb+9'd480))			 
  begin red<=1'b1; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd480)&&(CH<=Ha+Hb+10'd600))			
  begin red<=1'b0; green<=1'b1; blue<=1'b0;
  end		 
  end 

  
  always @ (*)
  begin	
  if((hsync_cnt > `HSYNC_B) && (hsync_cnt <= `HSYNC_B + 10'd200) && vga_data_en)			
  VGA_DATA_N = 8'hE0;			//红色	
  else if((hsync_cnt > `HSYNC_B + 10'd200) && (hsync_cnt <= `HSYNC_B + 10'd400) && vga_data_en)			
  VGA_DATA_N = 8'hFC;			//黄色	
  else if((hsync_cnt > `HSYNC_B + 10'd400) && (hsync_cnt <= `HSYNC_B + 10'd600) && vga_data_en)			
  VGA_DATA_N = 8'h03;			//蓝色	
  else if((hsync_cnt > `HSYNC_B + 10'd600) && (hsync_cnt <= `HSYNC_B + 10'd800) && vga_data_en)			
  VGA_DATA_N = 8'h1C;			//绿色	
  else		
  VGA_DATA_N = 8'h00;			//黑色	
  end
*/