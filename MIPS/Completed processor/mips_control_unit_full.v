module control_unit_full_mips (	  i_reset,
				  i_op_code,
				  i_funct,
				  o_is_jump, 
				  o_r_1_en, o_r_2_en, o_w_en,
				  o_reg_dst,
				  o_alu_src,
				  o_is_branch,
				  o_mem_write,
				  o_mem_to_reg,
				  o_alu_op_type_1,
				  o_alu_op_type_2,
				  o_alu_op_type_3,
				  o_alu_is_signed );

input i_reset;
input [5:0] i_op_code;
input [5:0] i_funct;

output o_is_jump;
output o_r_1_en;
output o_r_2_en;
output o_w_en;
output o_reg_dst;
output o_alu_src;
output o_is_branch;
output o_mem_write;
output o_mem_to_reg;
output [1:0] o_alu_op_type_1;
output [1:0] o_alu_op_type_2;
output o_alu_op_type_3;
output o_alu_is_signed;

wire [1:0] alu_op_code;

control_unit_main_mips control_main(.i_reset(i_reset),
				    .i_op_code(i_op_code),
				    .o_is_jump(o_is_jump),
				    .o_r_1_en(o_r_1_en), .o_r_2_en(o_r_2_en), .o_w_en(o_w_en),
				    .o_reg_dst(o_reg_dst),
				    .o_alu_src(o_alu_src),
				    .o_alu_op_code(alu_op_code),
				    .o_is_branch(o_is_branch),
				    .o_mem_write(o_mem_write),
				    .o_mem_to_reg(o_mem_to_reg) );

control_unit_alu_mips control_alu(.i_reset(i_reset),
				  .i_alu_op_code(alu_op_code),
				  .i_funct(i_funct),
				  .o_op_type_1(o_alu_op_type_1),
				  .o_op_type_2(o_alu_op_type_2),
				  .o_op_type_3(o_alu_op_type_3),
				  .o_is_signed(o_alu_is_signed) );

endmodule
