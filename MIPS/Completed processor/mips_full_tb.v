`timescale 1ns / 1ps

module testbench;

parameter PERIOD = 2;

reg clk, reset;

mips_full_processor mips(.i_clk(clk), .i_reset(reset) );

initial begin
	#5
	reset = 1;
	#4
	reset = 0;
end


initial begin
	forever #(PERIOD/2) clk = ~clk;
end

initial begin
	#130
	$finish;
end

initial begin
	clk = 0;
	reset = 0;
end

endmodule
