module control_unit_alu_mips  ( i_reset,
				i_alu_op_code,
				i_funct,
				o_op_type_1,
				o_op_type_2,
				o_op_type_3,
				o_is_signed );

input i_reset;

input  [1:0] i_alu_op_code;	/* ALU op-code */

input  [5:0] i_funct;

output [1:0] o_op_type_1;

output [1:0] o_op_type_2;

output o_op_type_3;

output reg o_is_signed;


reg [4:0] alu_control_reg;


assign o_op_type_1 = alu_control_reg[4:3];
assign o_op_type_2 = alu_control_reg[2:1];
assign o_op_type_3 = alu_control_reg[0];


always @* begin
	case (i_alu_op_code)
		2'b00: begin	/* Adder */
			alu_control_reg = 5'b10_00_0;
		end
		
		2'b01: begin	/* Subtractor */
			alu_control_reg = 5'b10_01_0;
			o_is_signed = 1;
		end
		
		2'b10: begin	/* ALU behaviour defines by "funct" field */
			case (i_funct)
				6'h0 : alu_control_reg = 5'b00_00_0;	/* sll */
				6'h2 : alu_control_reg = 5'b00_00_1;	/* srl */
				6'h3 : alu_control_reg = 5'b00_10_1;	/* sra */
				6'h20: begin /* add (signed) */
					alu_control_reg = 5'b10_00_0;
					o_is_signed = 1;
				       end
				6'h21: begin /* addu (unsigned) */
					alu_control_reg = 5'b10_00_0;
					o_is_signed = 0;
				       end
				6'h22: alu_control_reg = 5'b10_01_0;	/* sub */
				6'h24: alu_control_reg = 5'b11_00_0;	/* AND */
				6'h25: alu_control_reg = 5'b11_01_0;	/* OR  */
				6'h26: alu_control_reg = 5'b11_11_0;	/* XOR */
				6'h27: alu_control_reg = 5'b11_10_0;	/* NOR */
				6'h2A: alu_control_reg = 5'b01_00_0;	/* SLT */
			endcase
		end
		
		2'b11: begin	/* forbidden value - I set it as Adder */
			alu_control_reg = 5'b10_00_0;
		end
	endcase
	
	
end

endmodule
