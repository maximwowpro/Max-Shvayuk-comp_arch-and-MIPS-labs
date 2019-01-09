module control_unit_main_mips (	  i_reset,
				  i_op_code, 
				  o_is_jump, 
				  o_r_1_en, o_r_2_en, o_w_en,
				  o_reg_dst,
				  o_alu_src,
				  o_alu_op_code,
				  o_is_branch,
				  o_mem_write,
				  o_mem_to_reg );

input i_reset;

input [5:0] i_op_code;		/* op-code of instruction */

output reg o_is_jump;

output reg o_r_1_en, o_r_2_en, o_w_en;

output reg o_reg_dst;

output reg o_alu_src;

output reg [1:0] o_alu_op_code; /* control signals for ALU */

output reg o_is_branch;

output reg o_mem_write;

output reg o_mem_to_reg;


always @* begin	
	case (i_op_code)
		6'b000000: begin	/* R-type instruction */
			o_is_jump    = 0;
			o_r_1_en     = 1;
			o_r_2_en     = 1;
			o_w_en       = 1;
			o_reg_dst    = 1;
			o_alu_src    = 0;
			o_is_branch  = 0;
			o_mem_write  = 0;
			o_mem_to_reg = 0;
			o_alu_op_code = 2'b10; /* ALU behaviour defines by "funct" field */
		end
		
		6'b100011: begin	/* lw - load word instruction */
			o_is_jump    = 0;
			o_r_1_en     = 1;
			o_r_2_en     = 0;
			o_w_en       = 1;
			o_reg_dst    = 0;
			o_alu_src    = 1;
			o_is_branch  = 0;
			o_mem_write  = 0;
			o_mem_to_reg = 1;
			o_alu_op_code = 2'b00; /* ALU works as Adder */
		end
		
		6'b101011: begin	/* sw - store word instruction */
			o_is_jump    = 0;
			o_r_1_en     = 1;
			o_r_2_en     = 1;
			o_w_en       = 0;
			o_reg_dst    = 0;
			o_alu_src    = 1;
			o_is_branch  = 0;
			o_mem_write  = 1;
			o_mem_to_reg = 1;
			o_alu_op_code = 2'b00; /* ALU works as Adder */
		end
		
		6'b000100: begin	/* beq - branch if equal instruction */
			o_is_jump    = 0;
			o_r_1_en     = 1;
			o_r_2_en     = 1;
			o_w_en       = 0;
			o_reg_dst    = 0;
			o_alu_src    = 0;
			o_is_branch  = 1;
			o_mem_write  = 0;
			o_mem_to_reg = 0;
			o_alu_op_code = 2'b01; /* ALU works as Subtractor */
		end
		
		6'b000010: begin		/* j - unconditional jump instruction */
			o_is_jump    = 1;
			o_r_1_en     = 0;
			o_r_2_en     = 0;
			o_w_en       = 0;
			o_reg_dst    = 0;
			o_alu_src    = 0;
			o_is_branch  = 0;
			o_mem_write  = 0;
			o_mem_to_reg = 0;
			o_alu_op_code = 2'b00; 	/* we dont need ALU, so it can work anyhow */
		end
		
		6'b001000: begin		/* addi */
			o_is_jump    = 0;
			o_r_1_en     = 1;
			o_r_2_en     = 0;
			o_w_en       = 1;
			o_reg_dst    = 0;
			o_alu_src    = 1;
			o_is_branch  = 0;
			o_mem_write  = 0;
			o_mem_to_reg = 0;
			o_alu_op_code = 2'b00; 	/* ALU works as Adder */
		end
		
		default: begin
			o_is_jump    = 0;
			o_r_1_en     = 0;
			o_r_2_en     = 0;
			o_w_en       = 0;
			o_reg_dst    = 0;
			o_alu_src    = 0;
			o_is_branch  = 0;
			o_mem_write  = 0;
			o_mem_to_reg = 0;
			o_alu_op_code = 2'b00; /* ALU works as Subtractor */
		end
		
	endcase
end

endmodule















