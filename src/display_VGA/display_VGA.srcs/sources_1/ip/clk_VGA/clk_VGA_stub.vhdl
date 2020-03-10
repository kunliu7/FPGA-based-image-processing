-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
-- Date        : Mon Dec 24 00:16:09 2018
-- Host        : Liukun running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/clk_VGA/clk_VGA_stub.vhdl
-- Design      : clk_VGA
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_VGA is
  Port ( 
    clk : in STD_LOGIC;
    clk_40m : out STD_LOGIC;
    clk_80m : out STD_LOGIC;
    clk_100m : out STD_LOGIC;
    rst_n : in STD_LOGIC
  );

end clk_VGA;

architecture stub of clk_VGA is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,clk_40m,clk_80m,clk_100m,rst_n";
begin
end;
