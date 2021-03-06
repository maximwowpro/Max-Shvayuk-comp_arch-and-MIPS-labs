/* 
 * I use a part of code, writen by Dhaval Kaneria.
 * http://kaneriadhaval.blogspot.com/
 */


module barrel_shifter (in, sh, shift_LeftRight, rotate_LeftRight, out);

parameter n=31;

input [n:0] in;
input [4:0] sh;
input shift_LeftRight, rotate_LeftRight;
output reg [n:0] out;

/* 
 * @* means that changing of any signal, which is inside the "always" block 
 * leads to repeat the "always" block 
 */
always @*
begin
	if (~shift_LeftRight)
		out=in<<sh;		/* simple logic shift left  */
	else if (shift_LeftRight)
		out = in>>sh;		/* simple logic shift right */
	else
		begin
			case(sh)	/* cyclic shift 	    */
				5'b00001:
				out= (~rotate_LeftRight) ? {in[n-1:0],in[n]}:{in[0],in[n:1]};
				5'b00010:
				out= (~rotate_LeftRight) ? {in[n-2:0],in[n:n-1]}:{in[1:0],in[n:2]};
				5'b00011:
				out= (~rotate_LeftRight) ? {in[n-3:0],in[n:n-2]}:{in[2:0],in[n:3]};
				5'b00100:
				out= (~rotate_LeftRight) ? {in[n-4:0],in[n:n-3]}:{in[3:0],in[n:4]};
				5'b00101:
				out= (~rotate_LeftRight) ? {in[n-5:0],in[n:n-4]}:{in[4:0],in[n:5]};
				5'b00110:
				out= (~rotate_LeftRight) ? {in[n-6:0],in[n:n-5]}:{in[5:0],in[n:6]};
				5'b00111:
				out= (~rotate_LeftRight) ? {in[n-7:0],in[n:n-6]}:{in[6:0],in[n:7]};
				5'b01000:
				out= (~rotate_LeftRight) ? {in[n-8:0],in[n:n-7]}:{in[7:0],in[n:8]};
				5'b01001:
				out= (~rotate_LeftRight) ? {in[n-9:0],in[n:n-8]}:{in[8:0],in[n:9]};
				5'b01010:
				out= (~rotate_LeftRight) ? {in[n-10:0],in[n:n-9]}:{in[9:0],in[n:10]};
				5'b01011:
				out= (~rotate_LeftRight) ? {in[n-11:0],in[n:n-10]}:{in[10:0],in[n:11]};
				5'b01100:
				out= (~rotate_LeftRight) ? {in[n-12:0],in[n:n-11]}:{in[11:0],in[n:12]};
				5'b01101:
				out= (~rotate_LeftRight) ? {in[n-13:0],in[n:n-12]}:{in[12:0],in[n:13]};
				5'b01110:
				out= (~rotate_LeftRight) ? {in[n-14:0],in[n:n-13]}:{in[13:0],in[n:14]};
				5'b01111:
				out= (~rotate_LeftRight) ? {in[n-15:0],in[n:n-14]}:{in[14:0],in[n:15]};
				5'b10000:
				out= (~rotate_LeftRight) ? {in[n-16:0],in[n:n-15]}:{in[15:0],in[n:16]};
				5'b10001:
				out= (~rotate_LeftRight) ? {in[n-17:0],in[n:n-16]}:{in[16:0],in[n:17]};
				5'b10010:
				out= (~rotate_LeftRight) ? {in[n-18:0],in[n:n-17]}:{in[17:0],in[n:18]};
				5'b10011:
				out= (~rotate_LeftRight) ? {in[n-19:0],in[n:n-18]}:{in[18:0],in[n:19]};
				5'b10100:
				out= (~rotate_LeftRight) ? {in[n-20:0],in[n:n-19]}:{in[19:0],in[n:20]};
				5'b10101:
				out= (~rotate_LeftRight) ? {in[n-21:0],in[n:n-20]}:{in[20:0],in[n:21]};
				5'b10110:
				out= (~rotate_LeftRight) ? {in[n-22:0],in[n:n-21]}:{in[21:0],in[n:22]};
				5'b10111:
				out= (~rotate_LeftRight) ? {in[n-23:0],in[n:n-22]}:{in[22:0],in[n:23]};
				5'b11000:
				out= (~rotate_LeftRight) ? {in[n-24:0],in[n:n-23]}:{in[23:0],in[n:24]};
				5'b11001:
				out= (~rotate_LeftRight) ? {in[n-25:0],in[n:n-24]}:{in[24:0],in[n:25]};
				5'b11010:
				out= (~rotate_LeftRight) ? {in[n-26:0],in[n:n-25]}:{in[25:0],in[n:26]};
				5'b11011:
				out= (~rotate_LeftRight) ? {in[n-27:0],in[n:n-26]}:{in[26:0],in[n:27]};
				5'b11100:
				out= (~rotate_LeftRight) ? {in[n-28:0],in[n:n-27]}:{in[27:0],in[n:28]};
				5'b11101:
				out= (~rotate_LeftRight) ? {in[n-29:0],in[n:n-28]}:{in[28:0],in[n:29]};
				5'b11110:
				out= (~rotate_LeftRight) ? {in[n-30:0],in[n:n-29]}:{in[29:0],in[n:30]};
				5'b11111:
				out= (~rotate_LeftRight) ? {in[n-31:0],in[n:n-30]}:{in[30:0],in[n:31]};

				default:
				out=in;
			endcase
		end
	
end
endmodule
