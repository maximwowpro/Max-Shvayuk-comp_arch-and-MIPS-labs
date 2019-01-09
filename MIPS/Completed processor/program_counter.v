module program_counter_mips(clk, instruction, ptr, in_reset);

input clk ;
input in_reset;
input [31 : 0] instruction ;	//instruction

output [31 : 0] ptr;

reg [31:0] tmp_reg = 32'd0;		//pointer to instruction adress in memory. Default (begin) state = 32'd0

assign ptr = tmp_reg;

always @(posedge clk )
begin
	if (in_reset)
		tmp_reg <= 32'd0;
	else
		tmp_reg <= instruction;
end

endmodule
