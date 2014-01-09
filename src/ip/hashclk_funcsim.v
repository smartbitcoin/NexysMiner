// Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2013.4 (lin64) Build 353583 Mon Dec  9 17:26:26 MST 2013
// Date        : Wed Jan  8 18:54:01 2014
// Host        : dv1 running 64-bit Ubuntu 12.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/jin/dev/vivado/uart.Icarus/uart.Icarus.srcs/sources_1/ip/hashclk/hashclk_funcsim.v
// Design      : hashclk
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "hashclk,clk_wiz_v5_1,{component_name=hashclk,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=true,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=PLL,num_out_clk=2,clkin1_period=10.0,clkin2_period=10.0,use_power_down=false,use_reset=false,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *) 
(* NotValidForBitStream *)
module hashclk
   (clk_in1,
    clk_out1,
    clk_out2,
    daddr,
    dclk,
    den,
    din,
    dout,
    drdy,
    dwe);
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

(* IBUF_LOW_PWR *)   wire clk_in1;
  wire clk_out1;
  wire clk_out2;
  wire [6:0]daddr;
  wire dclk;
  wire den;
  wire [15:0]din;
  wire [15:0]dout;
  wire drdy;
  wire dwe;

hashclkhashclk_clk_wiz inst
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .daddr(daddr),
        .dclk(dclk),
        .den(den),
        .din(din),
        .dout(dout),
        .drdy(drdy),
        .dwe(dwe));
endmodule

module hashclkhashclk_clk_wiz
   (drdy,
    dout,
    clk_out1,
    clk_out2,
    clk_in1,
    dclk,
    den,
    dwe,
    din,
    daddr);
  output drdy;
  output [15:0]dout;
  output clk_out1;
  output clk_out2;
  input clk_in1;
  input dclk;
  input den;
  input dwe;
  input [15:0]din;
  input [6:0]daddr;

  wire \<const0> ;
  wire \<const1> ;
(* IBUF_LOW_PWR *)   wire clk_in1;
  wire clk_in1_hashclk;
  wire clk_out1;
  wire clk_out1_hashclk;
  wire clk_out2;
  wire clk_out2_hashclk;
  wire clkfbout_buf_hashclk;
  wire clkfbout_hashclk;
  wire [6:0]daddr;
  wire dclk;
  wire den;
  wire [15:0]din;
  wire [15:0]dout;
  wire drdy;
  wire dwe;
  wire NLW_plle2_adv_inst_CLKOUT2_UNCONNECTED;
  wire NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_plle2_adv_inst_LOCKED_UNCONNECTED;

GND GND
       (.G(\<const0> ));
VCC VCC
       (.P(\<const1> ));
(* BOX_TYPE = "PRIMITIVE" *) 
   BUFG clkf_buf
       (.I(clkfbout_hashclk),
        .O(clkfbout_buf_hashclk));
(* BOX_TYPE = "PRIMITIVE" *) 
   (* CAPACITANCE = "DONT_CARE" *) 
   (* IBUF_DELAY_VALUE = "0" *) 
   (* IFD_DELAY_VALUE = "AUTO" *) 
   IBUF #(
    .IOSTANDARD("DEFAULT")) 
     clkin1_ibufg
       (.I(clk_in1),
        .O(clk_in1_hashclk));
(* BOX_TYPE = "PRIMITIVE" *) 
   BUFG clkout1_buf
       (.I(clk_out1_hashclk),
        .O(clk_out1));
(* BOX_TYPE = "PRIMITIVE" *) 
   BUFG clkout2_buf
       (.I(clk_out2_hashclk),
        .O(clk_out2));
(* BOX_TYPE = "PRIMITIVE" *) 
   PLLE2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT(9),
    .CLKFBOUT_PHASE(0.000000),
    .CLKIN1_PERIOD(10.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE(15),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT1_DIVIDE(72),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .STARTUP_WAIT("FALSE")) 
     plle2_adv_inst
       (.CLKFBIN(clkfbout_buf_hashclk),
        .CLKFBOUT(clkfbout_hashclk),
        .CLKIN1(clk_in1_hashclk),
        .CLKIN2(\<const0> ),
        .CLKINSEL(\<const1> ),
        .CLKOUT0(clk_out1_hashclk),
        .CLKOUT1(clk_out2_hashclk),
        .CLKOUT2(NLW_plle2_adv_inst_CLKOUT2_UNCONNECTED),
        .CLKOUT3(NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT4(NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED),
        .DADDR(daddr),
        .DCLK(dclk),
        .DEN(den),
        .DI(din),
        .DO(dout),
        .DRDY(drdy),
        .DWE(dwe),
        .LOCKED(NLW_plle2_adv_inst_LOCKED_UNCONNECTED),
        .PWRDWN(\<const0> ),
        .RST(\<const0> ));
endmodule
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
