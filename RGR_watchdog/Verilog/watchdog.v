module watchdog_timer (i_clk, i_clrwdt, i_wait_period, i_rst_period, o_fail_safe, o_hardware_rst, counter_1, counter_2, counter_3);
	input i_clk;
	input i_clrwdt;				// clear watchdog, the CPU should provide this signal in a predermined period
	input [31:0] i_wait_period;		// how long WDT wait for system feedback
	input [31:0] i_rst_period;		// determine the period of active logic level at reset pin
	output reg o_fail_safe;
	output reg o_hardware_rst;
	
	output reg [31:0] counter_1;		// fail safe condition
	output reg [31:0] counter_2;		// hardware reset condition
	output reg [31:0] counter_3;		// sets period of active logic level at reset pin

	
	always @* begin				//asynchronous clear watchdog
		if (i_clrwdt) begin
			counter_1 <= i_wait_period;
			counter_2 <= i_wait_period;
			counter_3 <= i_rst_period;
			o_fail_safe <= 0;
			o_hardware_rst <= 0;
		end	
	end
	
	always @(posedge i_clk) begin
		if (counter_1 == 32'd0)		// begin fail save state
			o_fail_safe <= 1;
		else if (counter_1 != 32'd0)
			counter_1 <= counter_1 - 1;
		
		if (counter_2 == 32'd0)		// begin hardware reset
			o_hardware_rst <= 1;
		else if (counter_1 == 32'd0 && counter_2 != 32'd0)
			counter_2 <= counter_2 - 1;
		
		if (counter_3 == 32'd0) begin	//stop hardware reset, let the CPU work again
			o_fail_safe <= 0;
			o_hardware_rst <= 0;
			counter_1 <= i_wait_period;
			counter_2 <= i_wait_period;
			counter_3 <= i_rst_period;
		end else if (counter_2 == 32'd0 && counter_3 != 32'd0)
			counter_3 <= counter_3 - 1;
	end

endmodule
