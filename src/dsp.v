`timescale 1ns / 1ps

`include "utils.v"

/*
 *  Dsp  implements  128 bit  XOR engine. 
 */
module DspXor4(a,b,out);
    input [127:0] a;
    input [127:0] b;
    output [127:0] out;
    DspXor dx0(a[`idx48(0)],b[`idx48(0)],out[`idx48(0)]);
    DspXor dx1(a[`idx48(1)],b[`idx48(1)],out[`idx48(1)]);
    DspXor dx2(a[127:96],b[127:96],out[127:96]);
endmodule

/*
 *  Dsp implements  48 bit  XOR engine. 
 */
module DspXor(input[47:0] X, input[47:0] C, output[47:0] P);
wire[29:0] A;
wire[17:0] B;
assign A= X[47:18];
assign B= X[17:0];

localparam ALUMODE = 4'b0100;
localparam OPMODE = 7'b0110011;
localparam INMODE=  4'b0000;

`ifdef ATLYS
DSP48A1 #(
`endif
`ifdef NEXYS4
DSP48E1 #(
`endif
      .A_INPUT("DIRECT"),               
      .B_INPUT("DIRECT"),               
      .USE_DPORT("FALSE"),              
      .USE_MULT("NONE"),            
      .USE_SIMD("ONE48"),           
      .AUTORESET_PATDET("NO_RESET"),    
      .MASK(48'b1),          
      .PATTERN(48'h000000000000),      
      .SEL_MASK("MASK"),               
      .SEL_PATTERN("PATTERN"),         
      .USE_PATTERN_DETECT("NO_PATDET"),
      .ACASCREG(0),                     
      .ADREG(0),                        
      .ALUMODEREG(0),                   
      .AREG(0),                        
      .BCASCREG(0),                    
      .BREG(0),                        
      .CARRYINREG(0),                  
      .CARRYINSELREG(0),               
      .CREG(0),                        
      .DREG(0),                        
      .INMODEREG(0),                   
      .MREG(0),                        
      .OPMODEREG(0),                   
      .PREG(0)                         
   )
   DSP_inst (
      .P(P),                           
      .ALUMODE(ALUMODE),               
      .CARRYINSEL(3'b000),         
      .CLK(1'b0),                  
      .INMODE(INMODE),             
      .OPMODE(OPMODE),             
      .A(A),                       
      .B(B),                       
      .C(C)                        
   );
endmodule

