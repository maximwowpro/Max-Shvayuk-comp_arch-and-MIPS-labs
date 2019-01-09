`timescale 1ns / 1ps

module watchdog_tb;

parameter PERIOD = 2;

reg i_clk;
reg i_clrwdt;
reg [31:0] i_wait_period;
reg [31:0] i_rst_period;
wire o_fail_safe, o_hardware_rst;
wire [31:0] counter_1;
wire [31:0] counter_2;
wire [31:0] counter_3;
watchdog_timer obj (.i_clk(i_clk), 
		    .i_clrwdt(i_clrwdt), 
		    .i_wait_period(i_wait_period),
		    .i_rst_period(i_rst_period),
		    .o_fail_safe(o_fail_safe),
		    .o_hardware_rst(o_hardware_rst),
		    .counter_1(counter_1),
		    .counter_2(counter_2),
		    .counter_3(counter_3));
		    
initial begin
	i_clk = 0;
	i_wait_period = 5;
	i_rst_period = 3;
	forever #(PERIOD/2) i_clk = ~i_clk;
end

initial begin
	#1i_clrwdt = 0;
	
	#2i_clrwdt = 1;	#1i_clrwdt = 0;
	
	#40
	
	#1i_clrwdt = 1;	#2i_clrwdt = 0;
	
	#40 $finish;
end










endmodule
