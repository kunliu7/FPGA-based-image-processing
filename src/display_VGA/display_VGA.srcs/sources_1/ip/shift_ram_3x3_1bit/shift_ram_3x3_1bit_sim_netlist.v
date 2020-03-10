// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Mon Dec 17 17:15:04 2018
// Host        : Liukun running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/FPGA/display_VGA/display_VGA.srcs/sources_1/ip/shift_ram_3x3_1bit/shift_ram_3x3_1bit_sim_netlist.v
// Design      : shift_ram_3x3_1bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "shift_ram_3x3_1bit,c_shift_ram_v12_0_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_shift_ram_v12_0_9,Vivado 2016.2" *) 
(* NotValidForBitStream *)
module shift_ram_3x3_1bit
   (D,
    CLK,
    CE,
    SCLR,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 d_intf DATA" *) input [0:0]D;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) output [0:0]Q;

  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;
  wire SCLR;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* c_addr_width = "4" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "600" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_ram_3x3_1bit_c_shift_ram_v12_0_9 U0
       (.A({1'b0,1'b0,1'b0,1'b0}),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADDR_WIDTH = "4" *) (* C_AINIT_VAL = "0" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DEPTH = "600" *) (* C_ELABORATION_DIR = "./" *) (* C_HAS_A = "0" *) 
(* C_HAS_CE = "1" *) (* C_HAS_SCLR = "1" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_MEM_INIT_FILE = "no_coe_file_loaded" *) (* C_OPT_GOAL = "0" *) 
(* C_PARSER_TYPE = "0" *) (* C_READ_MIF = "0" *) (* C_REG_LAST_BIT = "1" *) 
(* C_SHIFT_TYPE = "0" *) (* C_SINIT_VAL = "0" *) (* C_SYNC_ENABLE = "0" *) 
(* C_SYNC_PRIORITY = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "1" *) 
(* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_shift_ram_v12_0_9" *) (* downgradeipidentifiedwarnings = "yes" *) 
module shift_ram_3x3_1bit_c_shift_ram_v12_0_9
   (A,
    D,
    CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [3:0]A;
  input [0:0]D;
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  output [0:0]Q;

  wire [3:0]A;
  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;
  wire SCLR;
  wire SINIT;
  wire SSET;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* c_addr_width = "4" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "600" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_ram_3x3_1bit_c_shift_ram_v12_0_9_viv i_synth
       (.A(A),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(SINIT),
        .SSET(SSET));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
fbDaBFHIKh52nacy9jMzYCMG1Qperci1BNhS3a905yYf8AeecKbmEQtlgupMzzq2Jx4PoYceu5dv
l8wFyM1beA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Utdt03S3Lz7i7p6dw60Xpdtn/qfD30vK9yxGkNw8JA+BhbYYcx2eoy6xX3s4i04F8mu4ZXW2yaRZ
QiRt02sJxlPynHgxFzZFQmLJ7VAzJcFAktOKXhWNwj9wLoAbrMTsjoWkKcK0jFv8BD3HlVd+njar
EYmkdb69Iz7LBFGQbpM=

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
4PT6F7RUlC6ulkKy8EHrmmm//6hC9n04KErb4TQM3+Jh/QcJmRo2+sfuzcdUkdDM5tVLyoL1zas1
82QYOJGjRNqJG3/ONBtWFb1AfoD+7KRaeqKM0ekCCP8CRxqTvi4BLAj7qKoZYocNy+9GHsu6grZb
IcibNZIQIW4p5GlkwaM=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oXpOej2si6vfmCwhxT9L2hA9y+uHvnEYR0CqR0g9lpI35C5OC1domnau9GAI8KKsKod2cMYkrO7N
p7BfJt68O4gx3HP2fnTtvSGQPi4hCU4JENf3ea0gZptV6Uug73DvcxlphHzEsfQvNDytZPzCDl9i
TYJRC3+nNJ17CrUuAjQw5TNZ5CEr0ab9sR5vNiV83iixbHVzhRlMWTba+N49pyQq7xLXTuw7KA6M
WgaNEcIO3uhOCpLBhnmF51V4crqXW3jbuHGHRN41+3s4eLXkbwxVGgIXBKdxNE2911IrZwlBIEVI
fGVkj/T3llHvdFKE2enmfnBtG67VsqyqSxxLDg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
p20y5FqSsxVqxQaw6mFQUmXW0btKlvrXp4sdgMO5NU7I0yS2G7wUu4HdQz9aEDl9Vee8yKfezePv
lKk2Xic9pdtgGsPnB+DEqIub2ViadwY4ObLTLleVBZgq2zcbDjSiOGkRKMcizquTL5/BcxMdOLUu
02Bsp3MFcDoxOYy8ciUkJiA5G1i57Yyiw9rCwr2Ta5+Yyi6RtbWM3lm8yQGLM4PubCTG8tkHfClF
WpFYFE54lHbdMNH+GNHfUIWynJ4avx4pyymRgZ/1Csh+uO1sG+rm9LtQ+fJIOKsR4UqptvUtNx5+
dQXdpnubb2XNE13HIgKarr4vtrXwnd05n+buJQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinx_2016_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Lqz0XM1L5SrgMWZTZt3KjAQO8hxce+rwEG22w1QNMgpWvLZsg6hKjbPLKUTF5//u48F5En6+esxI
KuJ8xEbRiHqjxj2/3FhHbQyfyNDY71VV8lk2FNFJtZH2lFJGOj9F80zlm3kmvhwdLSnrMDCci0t+
sOA1BiYTZJvdy5WvwhrJhOJ8uGLujb5oc2C8InL0jxeZPku4c4GpPs4ClG4Vaqujl1YuTHw9nwgT
2VoUpAezNIeVLFOBUSIkShA4NcbLqfGZPQcX1fNAoKz/yN4NE9vB82uLm5W3b2B2JjJoX2c1QSoK
msqvphRnK2MpZEXP0f4zktg/gfscI47gPQFk4w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
WcCtx6JO9lw0h3F6rAXejWM1cxNkEQU40WseS5UjQP+i414MBTo8zfNhMBrYEpgzWZCXCxu7Foel
lhMAhOD2hH2ob2bnPnLtSsjn/ZTSPY1mtF3kINopK6oR7QZrpJiEl9fjUW9pwr1lsiri3GbYgltr
HgHQoU5i7JPui3FEGkZWGMJ5hAWmDIuCoSYGGCPJzUzixwmPZJUTpZcZ8I4UxKRFDtqOvPQ/EFKa
BfJUDixeIW3rJ6mrzPQyvBOqyc/z0uANXlimi6e6jQm0UtiuLXra/q7IysZazxt4lhwmCffefi49
43hOu/VQnq2trUS+8POf+FqI1mRHKBgzVTcOgQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP05_001", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
SwoH5DTFO1AI5ctTxd9tVSIMbSDtJj+tkzdpa6bilJSvHbz/c5iZf2SmhgzL+3nPeeijufsxKIYK
05gnzUke9IkIrjk6EaNvYXh1mDD2kNxD0vkqNbEQ1uM6/kc4zwVmiaq7bp4Hx2+Xr6WQhAVsuF1z
eLQzGp0DtCWf6TO7oqVOGCloTql7w1zv/IIM1ny8iiBz+xxFnefXHLfNNWj8R81bh30aCONGK6Lu
pWiAjY+eHTexnJnTmJqbjfduhGUZ4ZYeo6ALqGe8mUCW1/HBOdC6/gH0IC+9HL09NEckDiHhl9/R
zxUeG7Midl9MXNVvuhtgIUoTtPCVzB2VRxeapQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21552)
`pragma protect data_block
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
maB+EgMm
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
