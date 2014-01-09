// Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2013.4 (lin64) Build 353583 Mon Dec  9 17:26:26 MST 2013
// Date        : Wed Jan  8 18:54:01 2014
// Host        : dv1 running 64-bit Ubuntu 12.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jin/dev/vivado/uart.Icarus/uart.Icarus.srcs/sources_1/ip/hashclk/hashclk_stub.v
// Design      : hashclk
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module hashclk(clk_in1, clk_out1, clk_out2, daddr, dclk, den, din, dout, drdy, dwe)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,clk_out1,clk_out2,daddr[6:0],dclk,den,din[15:0],dout[15:0],drdy,dwe" */;
  input clk_in1;
  output clk_out1;
  output clk_out2;
  input [6:0]daddr;
  input dclk;
  input den;
  input [15:0]din;
  output [15:0]dout;
  output drdy;
  input dwe;
endmodule
