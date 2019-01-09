module mips_full_processor(i_clk, i_reset);

input i_clk ;
input i_reset;

wire r_1_en, r_2_en, w_en, reg_dst;
wire mem_write, mem_to_reg, alu_src;

wire is_branch, is_jump;

wire [5:4] alu_op_type_1;
wire [3:2] alu_op_type_2;
wire 	   alu_op_type_3;
wire	   alu_is_signed;

wire [31:0] current_instruction;

control_unit_full_mips control_unit(.i_reset(i_reset),
				    .i_op_code(current_instruction[31:26] ),
				    .i_funct(current_instruction[5:0] ),
				    .o_is_jump(is_jump),
				    .o_r_1_en(r_1_en), .o_r_2_en(r_2_en), .o_w_en(w_en),
				    .o_reg_dst(reg_dst),
				    .o_alu_src(alu_src),
				    .o_is_branch(is_branch),
				    .o_mem_write(mem_write),
				    .o_mem_to_reg(mem_to_reg),
				    .o_alu_op_type_1(alu_op_type_1),
				    .o_alu_op_type_2(alu_op_type_2),
				    .o_alu_op_type_3(alu_op_type_3),
				    .o_alu_is_signed(alu_is_signed) );
				    
data_tract_mips data_tract(.i_clk(i_clk),
			   .i_reset(i_reset),
			   .i_r_1_en(r_1_en), .i_r_2_en(r_2_en), .i_w_en(w_en), .i_reg_dst(reg_dst),
			   .is_branch(is_branch), .is_jump(is_jump),
			   .i_alu_op_type_1(alu_op_type_1), 
			   .i_alu_op_type_2(alu_op_type_2), 
			   .i_alu_op_type_3(alu_op_type_3), 
			   .i_alu_is_signed(alu_is_signed), 
			   .i_alu_src(alu_src),
			   .i_mem_write(mem_write),
			   .i_mem_to_reg(mem_to_reg),
			   .o_current_instruction(current_instruction) );



endmodule
