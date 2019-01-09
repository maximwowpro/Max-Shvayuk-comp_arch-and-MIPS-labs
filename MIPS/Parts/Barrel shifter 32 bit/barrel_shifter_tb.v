`timescale 1ns / 1ps

module barrel_shifter_tb #(parameter n=31) ();

reg  [n : 0] in;
reg  [5 : 0] sh;
reg  shift_LeftRight, rotate_LeftRight;
wire [n : 0] out;

barrel_shifter shifter_obj(.in (in), .sh (sh), .shift_LeftRight (shift_LeftRight), .rotate_LeftRight (rotate_LeftRight), .out (out));

initial
begin
	#1 in=32'b11111111111111110000000000000000; sh=5'b00000; rotate_LeftRight=1'b1; shift_LeftRight=1'bx;
		#1 sh=5'b00001;
		#1 sh=5'b00010;
		#1 sh=5'b00011;
		#1 sh=5'b00100;
		#1 sh=5'b00101;
		#1 sh=5'b00110;
		#1 sh=5'b00111;
		
	#1 sh=5'b00000; in=32'b11111111111111110000000000000000; rotate_LeftRight=1'b0;
		#1 sh=5'b00001;
		#1 sh=5'b00010;
		#1 sh=5'b00011;
		#1 sh=5'b00100;
		#1 sh=5'b00101;
		#1 sh=5'b00110;

	#1 sh=5'b00000; in=32'b11111111111111110000000000000000; rotate_LeftRight=1'bx; shift_LeftRight=1'b0;
		#1 sh=5'b00001;
		#1 sh=5'b00010;
		#1 sh=5'b00011;
		#1 sh=5'b00100;
		#1 sh=5'b00101;
		#1 sh=5'b00110;

	#1 sh=5'b00000; in=32'b11111111111111110000000000000000; shift_LeftRight=1'b1;
		#1 sh=5'b00001;
		#1 sh=5'b00010;
		#1 sh=5'b00011;
		#1 sh=5'b00100;
		#1 sh=5'b00101;
		#1 sh=5'b00110;

end

initial
	#32 $finish;

	initial begin
	// Initialize Inputs
	in = 0;
	sh = 0;
	shift_LeftRight = 0;
	rotate_LeftRight = 0;

	// Wait 100 ns for global reset to finish
	#100;

end

endmodule
