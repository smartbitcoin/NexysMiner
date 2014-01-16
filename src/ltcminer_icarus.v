`include "utils.v"

module ltcminer_icarus (osc_clk, RxD, TxD, led,  dip);

	function integer clog2;		// Courtesy of razorfishsl, replaces $clog2()
		input integer value;
		begin
		value = value-1;
		for (clog2=0; value>0; clog2=clog2+1)
		value = value>>1;
		end
	endfunction

// NB SPEED_MHZ resolution is 5MHz steps to keep pll divide ratio sensible. Change the divider in xilinx_pll.v if you
// want other steps (1MHz is not sensible as it requires divide 100 which is not in the allowed range 1..32 for DCM_SP)
// New dyn_pll has 1MHz resolution and can be changed by sending a specific getwork packet (uses top bytes of target)

//`define USE_DYN_PLL		// Enable new dyn_pll

`ifdef SPEED_MHZ
	parameter SPEED_MHZ = `SPEED_MHZ;
`else
	parameter SPEED_MHZ = 25;						// Default to slow, use dynamic config to ramp up in realtime
`endif

`ifdef SPEED_LIMIT
	parameter SPEED_LIMIT = `SPEED_LIMIT;			// Fastest speed accepted by dyn_pll config
`else
	parameter SPEED_LIMIT = 100;					// Deliberately conservative, increase at own risk
`endif

`ifdef SPEED_MIN
	parameter SPEED_MIN = `SPEED_MIN;				// Slowest speed accepted by dyn_pll config (CARE can lock up if too low)
`else
	parameter SPEED_MIN = 10;
`endif

`ifdef SERIAL_CLK
	parameter comm_clk_frequency = `SERIAL_CLK;
`else
	parameter comm_clk_frequency = 12_500_000;		// 100MHz divide 8
`endif

`ifdef BAUD_RATE
	parameter BAUD_RATE = `BAUD_RATE;
`else
	parameter BAUD_RATE = 115_200;
`endif

`ifdef NEXYS4
		parameter LOCAL_MINERS = 2;						// One to four cores (configures ADDRBITS automatically)
`else 
		parameter LOCAL_MINERS = 1;						// One to four cores (configures ADDRBITS automatically)
`endif

`ifdef NEXYS4
	parameter ADDRBITS = 12 - clog2(LOCAL_MINERS);	// Automatically selects largest RAM that will fit LX150
`else
	parameter ADDRBITS = 11 - clog2(LOCAL_MINERS);	// Automatically selects largest RAM that will fit LX150
`endif


	localparam SLAVES = LOCAL_MINERS ;

	input osc_clk;
	wire hash_clk, uart_clk, pbkdf_clk;


`ifndef SIM
		//main_pll # (.SPEED_MHZ(SPEED_MHZ)) pll_blk (.CLKIN_IN(osc_clk), .CLKFX_OUT(hash_clk), .CLKDV_OUT(uart_clk));
		main_pll  pll_blk (.CLKIN_IN(osc_clk), .CLKFX_OUT(hash_clk), .CLKDV_OUT(uart_clk));
		//assign pbkdf_clk = uart_clk;
		assign pbkdf_clk = hash_clk;
`else
	assign hash_clk = osc_clk;
	assign uart_clk = osc_clk;
	assign pbkdf_clk = osc_clk;
`endif


	input dip;
	wire reset, nonce_chip;
	assign reset = dip;			// Not used
	
	// Work distribution is simply copying to all miners, so no logic
	// needed there, simply copy the RxD.
	input	RxD;
	output	TxD;

	// Results from the input buffers (in serial_hub.v) of each slave
	wire [SLAVES*32-1:0]	slave_nonces;
	wire [SLAVES*32-1:0]	slave_debug_sr;
	wire [SLAVES-1:0]		new_nonces;

	// Using the same transmission code as individual miners from serial.v
	wire		serial_send;
	wire		serial_busy;
	wire [31:0]	golden_nonce;
	serial_transmit #(.comm_clk_frequency(comm_clk_frequency), .baud_rate(BAUD_RATE)) sertx (.clk(uart_clk), .TxD(TxD), .send(serial_send), .busy(serial_busy), .word(golden_nonce));

	hub_core #(.SLAVES(SLAVES)) hc (.uart_clk(uart_clk), .new_nonces(new_nonces), .golden_nonce(golden_nonce), .serial_send(serial_send), .serial_busy(serial_busy), .slave_nonces(slave_nonces));

	// Common workdata input for local miners
	wire [255:0]	data1, data2;
	wire [127:0]	data3;
	wire [31:0]		target;
	reg  [31:0]		targetreg = 32'h000007ff;	// Start at sane value (overwritten by serial_receive)
	wire			rx_done;		// Signals hashcore to reset the nonce
									// NB in my implementation, it loads the nonce from data3 which should be fine as
									// this should be zero, but also supports testing using non-zero nonces.

	// Synchronise across clock domains from uart_clk to hash_clk
	// This probably looks amateurish (mea maxima culpa, novice verilogger at work), but should be OK
	reg rx_done_toggle = 1'b0;		// uart_clk domain
	always @ (posedge uart_clk)
		rx_done_toggle <= rx_done_toggle ^ rx_done;

	reg rx_done_toggle_d1 = 1'b0;	// hash_clk domain
	reg rx_done_toggle_d2 = 1'b0;
	reg rx_done_toggle_d3 = 1'b0;
	
	wire loadnonce;
	assign loadnonce = rx_done_toggle_d3 ^ rx_done_toggle_d2;

	always @ (posedge pbkdf_clk)
	begin
		rx_done_toggle_d1 <= rx_done_toggle;
		rx_done_toggle_d2 <= rx_done_toggle_d1;
		rx_done_toggle_d3 <= rx_done_toggle_d2;
		if (loadnonce)
			targetreg <= target;
	end
	// End of clock domain sync

	wire [31:0] mod_target;

	// Its better to always hard-wire the 16 MSB to zero ... if comms noise sets these bits it completely de-syncs,
	// generating a continuous stream of golden_nonces overwhelming the python driver which can't then reset the target.
	// assign mod_target = targetreg;				// Original 32 bit target
	assign mod_target = { 16'd0, targetreg[15:0] };	// Ignore top two bytes
	
	serial_receive #(.comm_clk_frequency(comm_clk_frequency), .baud_rate(BAUD_RATE)) serrx (.clk(uart_clk), .RxD(RxD), .data1(data1),
						.data2(data2), .data3(data3), .target(target), .rx_done(rx_done));

	parameter SBITS = 8;		// Shift data path width

	// Local miners now directly connected
	generate
		genvar i;
		for (i = 0; i < LOCAL_MINERS; i = i + 1)
		// begin: for_local_miners ... too verbose, so...
		begin: miners
			wire [31:0] nonce_out;	// Not used
			wire [2:0] nonce_core = i;
			wire gn_match;
			wire salsa_busy, salsa_result, salsa_reset, salsa_start, salsa_shift;
			wire [SBITS-1:0] salsa_din;
			wire [SBITS-1:0] salsa_dout;
			wire [3:0] dummy;	// So we can ignore top 4 bits of slave_debug_sr

			// Currently one pbkdfengine per salsaengine - TODO share the pbkdfengine for several salsaengines
			pbkdfengine #(.SBITS(SBITS)) P
				(.hash_clk(hash_clk), .pbkdf_clk(pbkdf_clk), .data1(data1), .data2(data2), .data3(data3), .target(mod_target),
				.nonce_msb({nonce_chip, nonce_core}), .nonce_out(nonce_out), .golden_nonce_out(slave_nonces[i*32+31:i*32]),
				.golden_nonce_match(gn_match), .loadnonce(loadnonce),
				.salsa_din(salsa_din), .salsa_dout(salsa_dout), .salsa_busy(salsa_busy), .salsa_result(salsa_result),
				.salsa_reset(salsa_reset), .salsa_start(salsa_start), .salsa_shift(salsa_shift));

			salsaengine #(.ADDRBITS(ADDRBITS), .SBITS(SBITS)) S
				(.hash_clk(hash_clk), .reset(salsa_reset), .din(salsa_din), .dout(salsa_dout),
				.shift(salsa_shift), .start(salsa_start), .busy(salsa_busy), .result(salsa_result) );
					
			// Synchronise across clock domains from pbkdf_clk to uart_clk for: assign new_nonces[i] = gn_match;
			reg gn_match_toggle = 1'b0;		// hash_clk domain
			always @ (posedge pbkdf_clk)
				gn_match_toggle <= gn_match_toggle ^ gn_match;

			reg gn_match_toggle_d1 = 1'b0;	// uart_clk domain
			reg gn_match_toggle_d2 = 1'b0;
			reg gn_match_toggle_d3 = 1'b0;

			assign new_nonces[i] = gn_match_toggle_d3 ^ gn_match_toggle_d2;

			always @ (posedge uart_clk)
			begin
				gn_match_toggle_d1 <= gn_match_toggle;
				gn_match_toggle_d2 <= gn_match_toggle_d1;
				gn_match_toggle_d3 <= gn_match_toggle_d2;
			end
			// End of clock domain sync
		end // for
	endgenerate

	output [3:0] led;
	assign led[0] = ~RxD;
	assign led[1] = ~TxD;
	// assign led[2] = ~TxD;
	// assign led[3] = ~ (TMP_SCL | TMP_SDA | TMP_ALERT);	// IDLE LED - held low (the TMP pins are PULLUP, this is a fudge to
															// avoid warning about unused inputs)
	
	//assign led[3] = ~first_dcm_locked | ~dcm_locked | dcm_status[2] | ~(TMP_SCL | TMP_SDA | TMP_ALERT);	// IDLE LED now dcm status

`define FLASHCLOCK		// Gives some feedback as the the actual clock speed

`ifdef FLASHCLOCK
	reg [26:0] hash_count = 0;
	reg [3:0] sync_hash_count = 0;
	always @ (posedge uart_clk)
		if (rx_done)
			sync_hash_count[0] <= ~sync_hash_count[0];
	always @ (posedge hash_clk)
	begin
		sync_hash_count[3:1] <= sync_hash_count[2:0];
		hash_count <= hash_count + 1'b1;
		if (sync_hash_count[3] != sync_hash_count[2])
			hash_count <= 0;
	end
	assign led[2] = hash_count[26];
`endif

	// Light up only from locally found nonces, not ext_port results
	pwm_fade pf (.clk(uart_clk), .trigger(|new_nonces[LOCAL_MINERS-1:0]), .drive(led[3]));
   
endmodule
