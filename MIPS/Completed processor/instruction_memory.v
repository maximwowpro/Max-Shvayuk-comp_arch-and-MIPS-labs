module instruction_memory_mips (in_addr, out_instruction);

parameter n_bit  = 31;
parameter memory_size  = 2047;

input [n_bit : 0] in_addr;

output wire [n_bit : 0] out_instruction;

reg [n_bit : 0] matrix [memory_size : 0];

initial $readmemb ( "mips_demo_program.bin" , matrix);

assign out_instruction = matrix[in_addr];


endmodule

