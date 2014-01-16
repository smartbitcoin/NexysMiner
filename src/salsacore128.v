/* salsacore128.v
*
* Copyright (c) 2013 smartbitcoin
* Author:  smartbitcoin@gmail.com
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
* 
*/

`timescale 1ns / 1ps

`define I(x) (((x)+1)*(32)-1):((x)*(32))
`define xor4def  function [127:0] xor4; input [127:0] a; input [127:0] b; xor4 = a ^ b; endfunction

module rotateAdd(input[127:0] a1,  input[127:0] a2, input[127:0] xo, output[127:0] out);
parameter rb=7;
`xor4def
`define add4(a,b) {a[127:96]+b[127:96],a[95:64]+b[95:64],a[63:32]+b[63:32],a[31:0]+b[31:0]}
wire[127:0] x= `add4(a1,a2);
assign out = xor4( xo, {x[127-rb:96],x[127:127-rb+1],x[95-rb:64],x[95:95-rb+1],x[63-rb:32],x[63:63-rb+1],x[31-rb:0],x[31:31-rb+1]} );
endmodule

module rotateAddDsp(input[127:0] a1,  input[127:0] a2, input[127:0] xo, output[127:0] out);
parameter rb=7;
	`define add4(a,b) {a[127:96]+b[127:96],a[95:64]+b[95:64],a[63:32]+b[63:32],a[31:0]+b[31:0]}
	wire[127:0] x= `add4(a1,a2);
	DspXor4 dxor4( xo, {x[127-rb:96],x[127:127-rb+1],x[95-rb:64],x[95:95-rb+1],x[63-rb:32],x[63:63-rb+1],x[31-rb:0],x[31:31-rb+1]} ,out);
endmodule

module salsa_core (input clk,
                   input [511:0] xx,
                   output reg [511:0] out, 
                   output [9:0] Xaddr);
                   
wire [127:0] C1,C2,C3,C0,R1,R2,R3,R0;
reg [127:0] D1,D2,D3,D0;
`ifdef DSP
rotateAddDsp #(7 )  ra1( {xx[`I(0)],xx[`I(5)],xx[`I(10)], xx[`I(15)] },{xx[`I(12)],xx[`I(1)],xx[`I(6)],xx[`I(11)]},
                      {xx[`I(4)],xx[`I(9)],xx[`I(14)],xx[`I(03)]} ,{C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]} );
rotateAddDsp #(9)   ra2( {C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]}, {xx[`I(0)],xx[`I(5)],xx[`I(10)],xx[`I(15)]},
                      {xx[`I(8)],xx[`I(13)],xx[`I(2)],xx[`I(7)]} ,{C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]} );
rotateAddDsp #(13)  ra3( {C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]},{C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]},
                      {xx[`I(12)],xx[`I(1)],xx[`I(6)],xx[`I(11)]} ,{C3[`I(0)],C0[`I(1)],C1[`I(2)],C2[`I(3)]} );
rotateAddDsp #(18)  ra4( {C3[`I(0)],C0[`I(1)],C1[`I(2)],C2[`I(3)]},{C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]},
                      {xx[`I(0)],xx[`I(5)],xx[`I(10)],xx[`I(15)]} ,{C0[`I(0)],C1[`I(1)],C2[`I(2)],C3[`I(3)]} );
rotateAddDsp #(7 )  rb1( {D0[`I(0)],D1[`I(1)],D2[`I(2)],D3[`I(3)]},{D0[`I(3)],D1[`I(0)],D2[`I(1)],D3[`I(2)]},
                      {D0[`I(1)],D1[`I(2)],D2[`I(3)],D3[`I(0)]} ,{R0[`I(1)],R1[`I(2)],R2[`I(3)],R3[`I(0)]} );
`else
rotateAdd #(7 )  ra1( {xx[`I(0)],xx[`I(5)],xx[`I(10)], xx[`I(15)] },{xx[`I(12)],xx[`I(1)],xx[`I(6)],xx[`I(11)]},
                      {xx[`I(4)],xx[`I(9)],xx[`I(14)],xx[`I(03)]} ,{C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]} );
rotateAdd #(9)   ra2( {C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]}, {xx[`I(0)],xx[`I(5)],xx[`I(10)],xx[`I(15)]},
                      {xx[`I(8)],xx[`I(13)],xx[`I(2)],xx[`I(7)]} ,{C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]} );
rotateAdd #(13)  ra3( {C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]},{C1[`I(0)],C2[`I(1)],C3[`I(2)],C0[`I(3)]},
                      {xx[`I(12)],xx[`I(1)],xx[`I(6)],xx[`I(11)]} ,{C3[`I(0)],C0[`I(1)],C1[`I(2)],C2[`I(3)]} );
rotateAdd #(18)  ra4( {C3[`I(0)],C0[`I(1)],C1[`I(2)],C2[`I(3)]},{C2[`I(0)],C3[`I(1)],C0[`I(2)],C1[`I(3)]},
                      {xx[`I(0)],xx[`I(5)],xx[`I(10)],xx[`I(15)]} ,{C0[`I(0)],C1[`I(1)],C2[`I(2)],C3[`I(3)]} );
rotateAdd #(7 )  rb1( {D0[`I(0)],D1[`I(1)],D2[`I(2)],D3[`I(3)]},{D0[`I(3)],D1[`I(0)],D2[`I(1)],D3[`I(2)]},
                      {D0[`I(1)],D1[`I(2)],D2[`I(3)],D3[`I(0)]} ,{R0[`I(1)],R1[`I(2)],R2[`I(3)],R3[`I(0)]} );
`endif

rotateAdd #(9 )  rb2( {R0[`I(1)],R1[`I(2)],R2[`I(3)],R3[`I(0)]}, {D0[`I(0)],D1[`I(1)],D2[`I(2)],D3[`I(3)]},
                      {D0[`I(2)],D1[`I(3)],D2[`I(0)],D3[`I(1)]} ,{R0[`I(2)],R1[`I(3)],R2[`I(0)],R3[`I(1)]} );
rotateAdd #(13 ) rb3( {R0[`I(2)],R1[`I(3)],R2[`I(0)],R3[`I(1)]},{R0[`I(1)],R1[`I(2)],R2[`I(3)],R3[`I(0)]},
                      {D0[`I(3)],D1[`I(0)],D2[`I(1)],D3[`I(2)]} ,{R0[`I(3)],R1[`I(0)],R2[`I(1)],R3[`I(2)]} );
rotateAdd #(18 ) rb4( {R0[`I(3)],R1[`I(0)],R2[`I(1)],R3[`I(2)]}, {R0[`I(2)],R1[`I(3)],R2[`I(0)],R3[`I(1)]},
                      {D0[`I(0)],D1[`I(1)],D2[`I(2)],D3[`I(3)]} ,{R0[`I(0)],R1[`I(1)],R2[`I(2)],R3[`I(3)]} );
assign Xaddr = R0[9:0];	// Unregistered output
always @ (posedge clk)
begin
	{D3,D2,D1,D0} <= {C3,C2,C1,C0};
	out <= { R3,R2,R1,R0 };
end
endmodule

