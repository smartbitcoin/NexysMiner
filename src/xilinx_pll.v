
`timescale 1ns / 1ps

module main_pll (CLKIN_IN, 
             CLKIN_IBUFG_OUT, 
             CLK0_OUT, 
             CLKFX_OUT, 
			 CLKDV_OUT,
             LOCKED_OUT);

  input CLKIN_IN;
  output CLKIN_IBUFG_OUT;
  output CLK0_OUT;
  output CLKFX_OUT;
  output CLKDV_OUT;
  output LOCKED_OUT;     
  
  wire CLKDV_BUF, CLKFX_BUF;
  BUFG  CLKDV_BUFG_INST (.I(CLKDV_BUF), .O(CLKDV_OUT));
  BUFG  CLKFX_BUFG_INST (.I(CLKFX_BUF), .O(CLKFX_OUT));
  
  hashclk clk( .clk_in1(CLKIN_IN),
               .clk_out1(CLKFX_BUF),
               .clk_out2(CLKDV_BUF)
               );
             
endmodule
