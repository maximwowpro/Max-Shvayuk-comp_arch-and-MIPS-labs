module register_file_mips     ( i_clk, r_1_en, addr_r_1, r_data_1, 
				r_2_en, addr_r_2, r_data_2, 
				w_en, addr_w, w_data, 
				arst );

parameter n_bit  = 31;			//how many bit are there in one register
parameter n_reg  = 4 ;			//how many bits we should to adress all registers

input i_clk, arst;

input  r_1_en;				//"1" - read from channel 1 enable, "0" - disable
input  [n_reg : 0] addr_r_1;		//number of register (0 - 31) to read data to channel 1
output wire [n_bit : 0] r_data_1;	//bus for transmiting channel 1 read data

input  r_2_en;				//"1" - read from channel 2 enable, "0" - disable
input  [n_reg : 0] addr_r_2;		//number of register (0 - 31) to read data to channel 2
output wire [n_bit : 0] r_data_2;	//bus for transmiting channel 2 read data

input  w_en;				//"1" - write enable, "0" - disable
input  [n_reg : 0] addr_w;		//number of register (0 - 31) to write data
input  [n_bit : 0] w_data;		//bus for transmiting write data

reg [n_bit : 0] matrix [n_bit : 0];

integer counter = 32'd0;

assign r_data_1 = (r_1_en ? matrix[addr_r_1] : 32'd0);
assign r_data_2 = (r_2_en ? matrix[addr_r_2] : 32'd0);

always @ (posedge i_clk)
begin
	matrix[0] = 32'd0;	// implementation of zero register
	
	if (arst) begin
		for (counter = 32'd0; counter < 32'd32; counter = counter + 32'd1) begin
			matrix[counter] <= 32'd0;
		end
	end else begin
		if (w_en) begin
			if (~| addr_w)
				matrix[addr_w] <= matrix[addr_w];	// zero register
			else 
				matrix[addr_w] <= w_data;
		end
	end
end

endmodule
