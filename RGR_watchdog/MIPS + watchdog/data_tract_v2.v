module data_tract_mips( i_clk, i_reset, 
			i_r_1_en, i_r_2_en, i_w_en, i_reg_dst,
			is_branch, is_jump,
			i_alu_op_type_1, i_alu_op_type_2, i_alu_op_type_3, i_alu_is_signed, i_alu_src,
			i_mem_write, 
			i_mem_to_reg,
			i_wdt_wait_period_w_en,
			o_current_instruction );

input i_clk ;
input i_reset;
input i_r_1_en, i_r_2_en, i_w_en, i_reg_dst;
input i_mem_write, i_mem_to_reg;

input is_branch, is_jump;

input [5:4] i_alu_op_type_1;
input [3:2] i_alu_op_type_2;
input       i_alu_op_type_3;
input i_alu_is_signed, i_alu_src;
input i_wdt_wait_period_w_en;

output [31:0] o_current_instruction;

wire wdt_reset;						// state of this wire will be assigned later
wire RESET = wdt_reset | i_reset;

// PROGRAM COUNTER IMPLEMENTATION
wire [31:0] pc_current_instruction_addr;		// PC output, current instruction address
wire [31:0] pc_instruction_addr_input;			// PC input, next instruction address
wire [31:0] pc_current_instruction_addr_plus_4;		// adress of the next instruction in the memory (if branch or jump instruction will not occur
wire [31:0] pc_mux_branch_output;			// output of the first (branch) mux

wire [31:0] pc_addr_beq;
wire [31:0] pc_addr_jump_full;
wire pc_control_is_branch;				// state of this wire will be assigned later
wire alu_out_slt;					// state of this wire will be assigned later
wire alu_zero_flag;					// state of this wire will be assigned later

assign pc_current_instruction_addr_plus_4 = pc_current_instruction_addr + 32'd4;

program_counter_mips program_counter (.clk (i_clk), 
				      .instruction (pc_instruction_addr_input), 
				      .ptr (pc_current_instruction_addr), 
				      .in_reset (RESET) );

mux_32_bit mux_pc_branch (.in_control (pc_control_is_branch),
			  .in_0 (pc_current_instruction_addr_plus_4),
			  .in_1 (pc_addr_beq),
			  .out_result (pc_mux_branch_output) );

mux_32_bit mux_pc_jump (.in_control (is_jump),
			.in_0 (pc_mux_branch_output),
			.in_1 (pc_addr_jump_full),
			.out_result (pc_instruction_addr_input) );



// INSTRUCTION MEMORY IMPLEMENTATION
wire [31:0] current_instruction;
assign o_current_instruction = current_instruction;

instruction_memory_mips instruction_memory (.in_addr (pc_current_instruction_addr),
					    .out_instruction (current_instruction) );



// JUMP INSTRUCTION IMPLEMENTATION
wire [31:28] addr_jump_1_part;
wire [27:0] addr_jump_2_part;
//wire [31:0] pc_addr_jump_full;

assign addr_jump_1_part = pc_current_instruction_addr_plus_4[31:28];
assign addr_jump_2_part = (current_instruction[25:0] << 2'd2);
assign pc_addr_jump_full = {addr_jump_1_part, addr_jump_2_part};



// BEQ INSTRUCTION IMPLEMENTATION (non-full)
assign pc_control_is_branch = (is_branch & alu_out_slt) | (is_branch & alu_zero_flag);

wire [31:0] extended_immediate;

assign pc_addr_beq = (extended_immediate << 2) + pc_current_instruction_addr_plus_4;

sign_extender_mips sign_extender_immediate (.in (current_instruction[15:0]), .out (extended_immediate) );





// REGISTER FILE IMPLEMENTATION
wire [31:0] rf_r_data_1;
wire [31:0] rf_r_data_2;
wire [4:0]  rf_w_addr;

wire [31:0] rf_w_data;

register_file_mips register_file (.i_clk(i_clk),
				  .r_1_en (i_r_1_en), .addr_r_1 (current_instruction[25:21]), .r_data_1 (rf_r_data_1),
				  .r_2_en (i_r_2_en), .addr_r_2 (current_instruction[20:16]), .r_data_2 (rf_r_data_2),
				  .w_en (i_w_en), .addr_w (rf_w_addr), .w_data (rf_w_data),
				  .arst (RESET) );

mux_5_bit mux_rf_w_addr (.in_control (i_reg_dst),
			 .in_0 (current_instruction[20:16]),
			 .in_1 (current_instruction[15:11]),
			 .out_result (rf_w_addr) );

			 
			 
/* ALU IMPLEMENTATION */
wire [31:0] alu_result;
wire [31:0] alu_2_operand;

alu_mips alu (.in_op_type_1 (i_alu_op_type_1), .in_op_type_2 (i_alu_op_type_2), .in_op_type_3 (i_alu_op_type_3), .is_signed (i_alu_is_signed),
	      .in_1 (rf_r_data_1), .in_2 (alu_2_operand),
	      .out_result (alu_result), 
	      .out_slt (alu_out_slt),
	      .out_zero_flag(alu_zero_flag) );

mux_32_bit mux_alu_src (.in_control (i_alu_src),
			.in_0 (rf_r_data_2),
			.in_1 (extended_immediate),
			.out_result (alu_2_operand) );



/* DATA MEMORY IMPLMENTATION */
wire [31:0] data_memory_out_val;

data_memory_mips data_memory (.in_clk(i_clk), .in_reset(RESET), 
			      .in_we(i_mem_write),
			      .in_addr(alu_result), .in_write_data(rf_r_data_2), 
			      .out_read_data(data_memory_out_val) );

mux_32_bit mux_mem_to_reg (.in_control (i_mem_to_reg),
			.in_0 (alu_result),
			.in_1 (data_memory_out_val),
			.out_result (rf_w_data) );


// watchdog timer implementation
wire clr_wdt;
wire [31:0] wdt_rst_period;

assign clr_wdt = ~| current_instruction;
assign wdt_rst_period = 32'd1;

watchdog_timer watchdog(.i_clk(i_clk),
			.i_clrwdt(clr_wdt),
			.i_wait_period(alu_result),
			.i_wait_period_w_en(i_wdt_wait_period_w_en),
			.i_rst_period(wdt_rst_period),
			.o_hardware_rst(wdt_reset) );
			


endmodule
