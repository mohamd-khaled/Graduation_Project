module TestLCD( clk, frame_1,frame_2,frame_3,frame_4,frame_5,sf_e, e, rs, rw, d, c, b, a );

	input [ 8 : 0 ] frame_1;
	input [ 8 : 0 ] frame_2;
	input [ 8 : 0 ] frame_3;
	input [ 8 : 0 ] frame_4;
	input [ 8 : 0 ] frame_5;
	input clk; // pin C9 is the 50-MHz on-board clock
	output reg sf_e; // 1 LCD access (0 StrataFlash access)
	output reg e; // enable (1)
	output reg rs; // Register Select (1 data bits for R/W)
	output reg rw; // Read/Write, 1/0
	output reg d; // 4th data bits (to from a nibble)
	output reg c; // 3rd data bits (to from a nibble)
	output reg b; // 2nd data bits (to from a nibble)
	output reg a; // 1st data bits (to from a nibble)
	
	reg [ 26 : 0 ] count = 0;	// 27-bit count, 0-(128M-1), over 2 secs
	reg [ 5 : 0 ] code;			// 6-bit different signals to give out
	reg refresh;					// refresh LCD rate @ about 25Hz
	wire [ 5 : 0] uo = 6'h23;
	wire [ 5 : 0] lo = 6'h21;
	wire [ 5 : 0] uz = 6'h23;
	wire [ 5 : 0] lz = 6'h20;
	
	always @ (posedge clk) begin
		count <= count +1;
		
		case ( count[ 26 : 21 ] )	// as top 6 bits change
// power-on init can be carried out before this loop to avoid the flickers
			0: code <= 6'h03;			// power-on init sequence
			1: code <= 6'h03;			// this is needed at least once
			2: code <= 6'h03;			// when LCD's powered on
			3: code <= 6'h02;			// it flickers existing char display
			
// Table 5-3, Function Set
// send 00 and upper nibble 0010, then 00 and lower nibble 10xx
			4: code <= 6'h02;			// Function Set, upper nibble 0010
			5: code <= 6'h08;			// lower nibble 1000 (10xx)
			
// Table 5-3, Entry Mode
// send 00 and upper nibble 0000, then 00 and lower nibble 0 1 I/D S
// last 2 bits of lower nibble: I/D bit (Incr 1, Decr 0), S bit (Shift 1, 0 no)
			6: code <= 6'h00; 		// see table, upper nibble 0000, then lower nibble:
			7: code <= 6'h06;			//  0110: Incr, Shift disabled
			
// Table 5-3, Display On/Off
// send 00 and upper nibble 0000, then 00 and lower nibble 1DCB:
// D: 1, show char represented by code in DDR, 0 don't, but code remains
// C: 1, show cursor, 0 don't
// B: 1, cursor blinks (if shown), 0 don't blink (if shown)
			8: code <= 6'h00;			// Display On/Off, upper nibble 0000
			9: code <= 6'h0C;			// lower nibble 1100 (1 D C B)
			
// Table 5-3 Clear Display, 00 and upper nibble 0000, 00 and lower nibble 0001
			10: code <= 6'h00;		// Clear Display, 00 and upper nibble 0000
			11: code <= 6'h01;		// then 00 and lower nibble 0001

// Characters are then given out, the cursor will advance to the right
// Table 5-3, Write Data to DD RAM (or CG RAM)
// Fig 5-4, 'H,' send 10 and upper nibble 0100, then 10 and lower nibble 1000
			12: code <= 6'h24;		// 'H' high nibble
			13: code <= 6'h2F;		// 'H' low nibble
			14: code <= 6'h27;		// e
			15: code <= 6'h25;
			16: code <= 6'h27;		// l
			17: code <= 6'h24;
			18: code <= 6'h27;		// l
			19: code <= 6'h20;
			20: code <= 6'h27;		// o
			21: code <= 6'h25;
			22: code <= 6'h27;		// ,
			23: code <= 6'h24;
			24: code <= 6'h23;		// ,
			25: code <= 6'h2D;
			
// Table 5-3, Set DD RAM (DDR) Address
// position the cursor onto the start of the 2nd line
// send 00 and upper nibble 1???, ??? is the highest 3 bits of the DDR
// address to move the cursor to, then 00 and lower 4 bits of the addr
// so ??? is 100 and then 0000 for h40
			26: code <= 6'b001100;	// pos cursor to 2nd line upper nibble h40 (...)
			27: code <= 6'b000000;	// lower nibble: h0
			
// Characters are then given out, the cursor will advance to the right

		28:begin
				if(frame_5[8] == 0)
				begin
					code <= uz;
				end
				else
				begin
					code <= uo;
				end	
			end
		29: begin
				if(frame_5[8] == 0)
				begin
					code <= lz;
				end
				else
				begin
					code <= lo;
				end	
			end
		30: begin
			case(frame_5[7:4])
				4'b0000: code <= 6'h23;
				4'b0001: code <= 6'h23;
				4'b0010: code <= 6'h23;
				4'b0011: code <= 6'h23;
				4'b0100: code <= 6'h23;
				4'b0101: code <= 6'h23;
				4'b0110: code <= 6'h23;
				4'b0111: code <= 6'h23;
				4'b1000: code <= 6'h23;
				4'b1001: code <= 6'h23;
				4'b1010: code <= 6'h24;
				4'b1011: code <= 6'h24;
				4'b1100: code <= 6'h24;
				4'b1101: code <= 6'h24;
				4'b1110: code <= 6'h24;
				4'b1111: code <= 6'h24;
			endcase	
			end
		
		31: begin
			case(frame_5[7:4])
				4'b0000: code <= 6'h20;
				4'b0001: code <= 6'h21;
				4'b0010: code <= 6'h22;
				4'b0011: code <= 6'h23;
				4'b0100: code <= 6'h24;
				4'b0101: code <= 6'h25;
				4'b0110: code <= 6'h26;
				4'b0111: code <= 6'h27;
				4'b1000: code <= 6'h28;
				4'b1001: code <= 6'h29;
				4'b1010: code <= 6'h21;
				4'b1011: code <= 6'h22;
				4'b1100: code <= 6'h23;
				4'b1101: code <= 6'h24;
				4'b1110: code <= 6'h25;
				4'b1111: code <= 6'h26;
			endcase	
			end
			32: begin
				case(frame_5[3:0])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			33: begin
				case(frame_5[3:0])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase	
				end
		34:begin
				if(frame_4[8] == 0)
				begin
					code <= uz;
				end
				else
				begin
					code <= uo;
				end	
			end
		35: begin
				if(frame_4[8] == 0)
				begin
					code <= lz;
				end
				else
				begin
					code <= lo;
				end	
			end
		36: begin
			case(frame_4[7:4])
				4'b0000: code <= 6'h23;
				4'b0001: code <= 6'h23;
				4'b0010: code <= 6'h23;
				4'b0011: code <= 6'h23;
				4'b0100: code <= 6'h23;
				4'b0101: code <= 6'h23;
				4'b0110: code <= 6'h23;
				4'b0111: code <= 6'h23;
				4'b1000: code <= 6'h23;
				4'b1001: code <= 6'h23;
				4'b1010: code <= 6'h24;
				4'b1011: code <= 6'h24;
				4'b1100: code <= 6'h24;
				4'b1101: code <= 6'h24;
				4'b1110: code <= 6'h24;
				4'b1111: code <= 6'h24;
			endcase	
			end
		
		37: begin
			case(frame_4[7:4])
				4'b0000: code <= 6'h20;
				4'b0001: code <= 6'h21;
				4'b0010: code <= 6'h22;
				4'b0011: code <= 6'h23;
				4'b0100: code <= 6'h24;
				4'b0101: code <= 6'h25;
				4'b0110: code <= 6'h26;
				4'b0111: code <= 6'h27;
				4'b1000: code <= 6'h28;
				4'b1001: code <= 6'h29;
				4'b1010: code <= 6'h21;
				4'b1011: code <= 6'h22;
				4'b1100: code <= 6'h23;
				4'b1101: code <= 6'h24;
				4'b1110: code <= 6'h25;
				4'b1111: code <= 6'h26;
			endcase	
			end
			38: begin
				case(frame_4[3:0])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			39: begin
				case(frame_4[3:0])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase	
				end
		40:begin
					if(frame_3[8] == 0)
					begin
						code <= uz;
					end
					else
					begin
						code <= uo;
					end	
				end
			41: begin
					if(frame_3[8] == 0)
					begin
						code <= lz;
					end
					else
					begin
						code <= lo;
					end	
				end
			42: begin
				case(frame_3[7:4])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				end
			
			43: begin
				case(frame_3[7:4])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase	
				end
			
			
			44: begin
				case(frame_3[3:0])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			45: begin
				case(frame_3[3:0])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase	
				end
			
			46:begin
					if(frame_2[8] == 0)
					begin
						code <= uz;
					end
					else
					begin
						code <= uo;
					end	
				end
			47: begin
					if(frame_2[8] == 0)
					begin
						code <= lz;
					end
					else
					begin
						code <= lo;
					end	
				end
			48: begin
				case(frame_2[7:4])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			49: begin
				case(frame_2[7:4])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase
				 end
			
			50: begin
				case(frame_2[3:0])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			51: begin
				case(frame_2[3:0])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase	
				 end
			52:begin
					if(frame_1[8] == 0)
					begin
						code <= uz;
					end
					else
					begin
						code <= uo;
					end	
				end
			53: begin
					if(frame_1[8] == 0)
					begin
						code <= lz;
					end
					else
					begin
						code <= lo;
					end	
				end
			54: begin
				case(frame_1[7:4])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase	
				 end
			
			55: begin
				case(frame_1[7:4])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase
				 end
			
			56: begin
				case(frame_1[3:0])
					4'b0000: code <= 6'h23;
					4'b0001: code <= 6'h23;
					4'b0010: code <= 6'h23;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h23;
					4'b0101: code <= 6'h23;
					4'b0110: code <= 6'h23;
					4'b0111: code <= 6'h23;
					4'b1000: code <= 6'h23;
					4'b1001: code <= 6'h23;
					4'b1010: code <= 6'h24;
					4'b1011: code <= 6'h24;
					4'b1100: code <= 6'h24;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h24;
					4'b1111: code <= 6'h24;
				endcase
				 end
			
			57: begin
				case(frame_1[3:0])
					4'b0000: code <= 6'h20;
					4'b0001: code <= 6'h21;
					4'b0010: code <= 6'h22;
					4'b0011: code <= 6'h23;
					4'b0100: code <= 6'h24;
					4'b0101: code <= 6'h25;
					4'b0110: code <= 6'h26;
					4'b0111: code <= 6'h27;
					4'b1000: code <= 6'h28;
					4'b1001: code <= 6'h29;
					4'b1010: code <= 6'h21;
					4'b1011: code <= 6'h22;
					4'b1100: code <= 6'h23;
					4'b1101: code <= 6'h24;
					4'b1110: code <= 6'h25;
					4'b1111: code <= 6'h26;
				endcase
				 end
// Table 5-3, Read Busy Flag and Address
// send 01 BF (Busy Flag) x x x, then 01xxxx
// idling
			default: code <= 6'h10;	// the rest un-used time
		endcase

// refresh (enable) the LCD when
// (it flips when counted upto 2M, and flips again after another 2M)
			refresh <= count[ 20 ]; // flip rate almost 25 (50Mhz / 2^21-2M)
			sf_e <= 1;
			{ e, rs, rw, d, c, b, a } <= { refresh, code };
			
	end // always

endmodule