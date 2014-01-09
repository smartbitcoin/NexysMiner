/* salsa_slowsixteen.v
*
* Copyright (c) 2013 kramble
* Derived from scrypt.c Copyright 2009 Colin Percival, 2011 ArtForz
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
`timescale 1ns/1ps

`define IDX(x) (((x)+1)*(32)-1):((x)*(32))

module salsa (clk, B, Bx, Bo, X0out, Xaddr);

// Latency 16 clock cycles, approx 20nS propagation delay (SLOW!)

input clk;
// input feedback;
input [511:0]B;
input [511:0]Bx;
// output reg [511:0]Bo;	// Output is registered
output [511:0]Bo;			// Output is async
output [511:0]X0out;		// Becomes new X0
output [9:0] Xaddr;
wire [9:0] xa1, xa2, xa3, xa4, ya1, ya2, ya3, ya4;

reg [511:0]x1d1, x1d1a;
reg [511:0]x1d2, x1d2a;
reg [511:0]x1d3, x1d3a;
reg [511:0]x1d4, x1d4a;

reg [511:0]Xod1, Xod1a;
reg [511:0]Xod2, Xod2a;
reg [511:0]Xod3, Xod3a;
reg [511:0]Xod4, X0out;

reg [511:0]xxd1, xxd1a;
reg [511:0]xxd2, xxd2a;
reg [511:0]xxd3, xxd3a;
reg [511:0]xxd4, xxd4a;

reg [511:0]yyd1, yyd1a;
reg [511:0]yyd2, yyd2a;
reg [511:0]yyd3, yyd3a;
reg [511:0]yyd4, yyd4a;

wire [511:0]xx;			// Initial xor
wire [511:0]x1;			// Salasa core outputs
wire [511:0]x2;
wire [511:0]x3;
wire [511:0]xr;
wire [511:0]Xo;

// Four salsa iterations. NB use registered salsa_core so 4 clock cycles.
salsa_core salsax1 (clk, xx, x1, xa1);
salsa_core salsax2 (clk, x1, x2, xa2);
salsa_core salsax3 (clk, x2, x3, xa3);
salsa_core salsax4 (clk, x3, xr, xa4);

wire [511:0]yy;			// Initial xor
wire [511:0]y1;			// Salasa core outputs
wire [511:0]y2;
wire [511:0]y3;
wire [511:0]yr;

// Four salsa iterations. NB use registered salsa_core so 4 clock cycles.
salsa_core salsay1 (clk, yy, y1, ya1);
salsa_core salsay2 (clk, y1, y2, ya2);
salsa_core salsay3 (clk, y2, y3, ya3);
salsa_core salsay4 (clk, y3, yr, ya4);

assign Xaddr = yyd4[9:0] + ya4;

genvar i;
generate
	for (i = 0; i < 16; i = i + 1) begin : XX
		// Initial XOR. NB this adds to the propagation delay of the first salsa, may want register it.
		assign xx[`IDX(i)] = B[`IDX(i)] ^ Bx[`IDX(i)];
		assign Xo[`IDX(i)] = xxd4a[`IDX(i)] + xr[`IDX(i)];
		assign yy[`IDX(i)] = x1d4a[`IDX(i)] ^ Xo[`IDX(i)];
		assign Bo[`IDX(i)] = yyd4a[`IDX(i)] + yr[`IDX(i)];	// Async output
	end
endgenerate

always @ (posedge clk)
begin
	x1d1 <= Bx;
	x1d1a <= x1d1;
	x1d2 <= x1d1a;
	x1d2a <= x1d2;
	x1d3 <= x1d2a;
	x1d3a <= x1d3;
	x1d4 <= x1d3a;
	x1d4a <= x1d4;
	Xod1 <= Xo;
	Xod1a <= Xod1;
	Xod2 <= Xod1a;
	Xod2a <= Xod2;
	Xod3 <= Xod2a;
	Xod3a <= Xod3;
	Xod4 <= Xod3a;
	X0out <= Xod4;	// We output this to become new X0

	xxd1 <= xx;
	xxd1a <= xxd1;
	xxd2 <= xxd1a;
	xxd2a <= xxd2;
	xxd3 <= xxd2a;
	xxd3a <= xxd3;
	xxd4 <= xxd3a;
	xxd4a <= xxd4;

	yyd1 <= yy;
	yyd1a <= yyd1;
	yyd2 <= yyd1a;
	yyd2a <= yyd2;
	yyd3 <= yyd2a;
	yyd3a <= yyd3;
	yyd4 <= yyd3a;
	yyd4a <= yyd4;

end

endmodule