`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 14:10:41
// Design Name: 
// Module Name: headfile
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


// Do not use strange name !

//-- VGA 800*600@60 
//-- CLK 100MHZ --> CLK 40MHZ
//-- VGA_DATA[11:0] rgb each 4 bits, 4*3 = 12

//-- Horizonal timing information
//-- Sync pluse   128  a
//-- back porch   88   b
//-- active       800  c
//-- front porch  40   d
//-- All line     1056 e

//-- Vertical timing information
//-- sync pluse   4    o
//-- back porch   23   p
//-- active time  600  q
//-- front porch  1    r
//-- All lines    628  s


//-- Horizonal timing information
`define HSYNC_A   12'd128  // 128
`define HSYNC_B   12'd216  // 128 + 88
`define HSYNC_C   12'd1016 // 128 + 88 + 800
`define HSYNC_D   12'd1056 // 128 + 88 + 800 + 40

//-- Vertical  timing information
`define VSYNC_O   12'd4    // 4 
`define VSYNC_P   12'd27   // 4 + 23
`define VSYNC_Q   12'd627  // 4 + 23 + 600
`define VSYNC_R   12'd628  // 4 + 23 + 600 + 1
`define VGA_BITS  12'd12

//-- Picture   timing information
//-- PIC_START_H + PIC_H < VSYNC_Q 
//-- Same as V
`define PIC_START_H 12'd50
`define PIC_START_V 12'd50 //测试 图像是否移动到了中间
`define PIC_H		12'd600
`define PIC_V		12'd450
`define THRESHOLD   16'd150

//-- Color Transform
//-- rgb[3:0] <= {screen_data[7:5], 1'b0};
//-- rgb[7:4] <= {screen_data[4:2], 1'b0};
//-- rgb[11:8]<= {screen_data[1:0], 2'b0};

//-- Status
`define STATUS_BITS 16'd4;
`define S_IDLE		4'b0000
`define S_ORIGIN	4'b0001
`define S_GREY		4'b0010
`define S_MEDIAN	4'b0011
`define S_SOBEL		4'b0100
`define S_ERODE		4'b0101
`define S_DILATE	4'b0110

`define PIC_SIZE	19'd270000
