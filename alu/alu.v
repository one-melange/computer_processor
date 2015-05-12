module subtractor_csel(a, b, diff_out, carry_out);
	input [31:0] a, b;
	output [31:0] diff_out;
	output carry_out;
	wire [31:0] not_b, diff_out;
	wire carry_out;
	
	bitwise_not		negate_b(b, not_b);
	adder_csel		subtraction(a, not_b, 1, diff_out, carry_out);
	
endmodule //end 32-bit subtraction

module adder_csel(a, b, carry_in, sum_out, carry_out);
	input [31:0] a, b;
	input carry_in;
	output [31:0] sum_out;
	output carry_out;
	wire [31:0] temp_out_0, temp_out_1, sum_out;
	wire [21:0] carries;
	wire carry_out;
	
	ripple_carry_adder		rca_0(a[3:0], b[3:0], carry_in, sum_out[3:0], carries[0]);

	genvar i, j;
	generate
		for (i=1; i<8; i=i+1) begin: carry_select_block_loop
			ripple_carry_adder		rca_1(a[((4*i)+3):(4*i)], b[((4*i)+3):(4*i)], 0, temp_out_0[((4*i)+3):(4*i)], carries[(3*i)-2]);
			ripple_carry_adder		rca_2(a[((4*i)+3):(4*i)], b[((4*i)+3):(4*i)], 1, temp_out_1[((4*i)+3):(4*i)], carries[(3*i)-1]);
			
			for (j=(4*i); j<((4*i)+4); j=j+1) begin: sum_mux_loop
				mux2_1		sum_mux(temp_out_0[j], temp_out_1[j], carries[(3*i)-3], sum_out[j]);
			end
			
			mux2_1		carry_mux(carries[(3*i)-2], carries[(3*i)-1], carries[(3*i)-3], carries[(3*i)]);
		end
	endgenerate
	
	assign carry_out = carries[21];
	
endmodule //end 32-bit carry select adder

module ripple_carry_adder(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] s;
	output c_out;
	wire [4:0] carries;
	wire [3:0] s;
	wire c_out;
	
	assign carries[0] = c_in;
		
	genvar i; 
    generate 
		for (i=0; i<4; i=i+1) begin: rca_loop_1 
			full_adder		rcadder(a[i], b[i], carries[i], s[i], carries[i+1]); 
		end 
	endgenerate

	assign c_out = carries[4];
	
endmodule //end 4-bit ripple carry adder

module full_adder(a, b, c_in, s, c_out);
	input a, b, c_in;
	output s, c_out;
	wire [2:0] inter_out;
	wire s, c_out;
	
	xor(inter_out[0], a, b);
	and(inter_out[1], a, b);
	and(inter_out[2], inter_out[0], c_in);
	xor(s, inter_out[0], c_in);
	or(c_out, inter_out[1], inter_out[2]);

endmodule //end 1-bit full adder

module mux2_1(a, b, select, out);
	input a, b, select;
	output out;
	wire not_select, out;
	wire [1:0] inter_out;
	
	not(not_select, select);
	and(inter_out[0], not_select, a);
	and(inter_out[1], select, b);
	or(out, inter_out[0], inter_out[1]);
	
endmodule  //end 2:1 mux

//end adder + supporting modules

module arithmetic_right_shift(a, shift, lsb, out);
	input [31:0] a;
	input [4:0] shift;
	input lsb;
	output [31:0] out;
	wire [31:0] out, pre_shift, post_shift;
	
	bit_reversal			reverse_0(a, pre_shift);
	logical_left_shift		shifter(pre_shift, shift, lsb, post_shift);
	bit_reversal			reverse_1(post_shift, out);
	
endmodule //end 32-bit arithmetic right shift
	
module bit_reversal(a, out);
	input [31:0] a;
	output [31:0] out;
	wire [31:0] out, temp;
	
	assign temp = a;
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: reversal_loop
			assign out[i] = temp[31-i];
		end
	endgenerate
	
endmodule //end 32-bit input bit reverser

module logical_left_shift(a, shift, lsb, out);
	input [31:0] a;
	input [4:0] shift;
	input lsb;
	output [31:0] out;
	wire [31:0] out;
	wire [31:0] mux_wire [4:0];
	wire [31:0] shift_wire [4:0];
	
	sll_16		s16(a, lsb, shift_wire[4]);
	tsb_mux  	m16(a, shift_wire[4], shift[4], mux_wire[4]);
	
	sll_8  		s8(mux_wire[4], lsb, shift_wire[3]);
	tsb_mux  	m8(mux_wire[4], shift_wire[3], shift[3], mux_wire[3]);
	
	sll_4  		s4(mux_wire[3], lsb, shift_wire[2]);
	tsb_mux  	m4(mux_wire[3], shift_wire[2], shift[2], mux_wire[2]);
	
	sll_2  		s2(mux_wire[2], lsb, shift_wire[1]);
	tsb_mux  	m2(mux_wire[2], shift_wire[1], shift[1], mux_wire[1]);
	
	sll_1  		s1(mux_wire[1], lsb, shift_wire[0]);
	tsb_mux  	m1(mux_wire[1], shift_wire[0], shift[0], mux_wire[0]);
	
	assign out = mux_wire[0];

endmodule //end 32-bit logical left barrel shifter

module sll_16(a, lsb, out);
	input [31:0] a;
	input lsb;
	output[31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=16; i<32; i=i+1) begin: shift_sixteen_loop
			assign out[i] = a[i-16];
		end
	endgenerate
	
	genvar j;
	generate
		for(j=0; j<16; j=j+1) begin: shift_sixteen_sub_loop
			assign out[j] = lsb;
		end
	endgenerate

endmodule //end 16-bit logical left shift

module sll_8(a, lsb, out);
	input [31:0] a;
	input lsb;
	output[31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=8; i<32; i=i+1) begin: shift_eight_loop
			assign out[i] = a[i-8];
		end
	endgenerate
	
	genvar j;
	generate
		for(j=0; j<8; j=j+1) begin: shift_eight_sub_loop
			assign out[j] = lsb;
		end
	endgenerate

endmodule //end 8-bit logical left shift

module sll_4(a, lsb, out);
	input [31:0] a;
	input lsb;
	output[31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=4; i<32; i=i+1) begin: shift_four_loop
			assign out[i] = a[i-4];
		end
	endgenerate
	
	assign out[0] = lsb;
	assign out[1] = lsb;
	assign out[2] = lsb;
	assign out[3] = lsb;

endmodule //end 4-bit logical left shift

module sll_2(a, lsb, out);
	input [31:0] a;
	input lsb;
	output[31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=2; i<32; i=i+1) begin: shift_two_loop
			assign out[i] = a[i-2];
		end
	endgenerate
	
	assign out[0] = lsb;
	assign out[1] = lsb;

endmodule //end 2-bit logical left shift

module sll_1(a, lsb, out);
	input [31:0] a;
	input lsb;
	output [31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=1; i<32; i=i+1) begin: shift_one_loop
			assign out[i] = a[i-1];
		end
	endgenerate
	
	assign out[0] = lsb;

endmodule //end 1-bit logical left shift
	
module tsb_mux(a, b, select, out);
	input [31:0] a, b;
	input select;
	output [31:0] out;
	wire not_select;
	
	not(not_select, select);
	tsb 	buffer_a(a, not_select, out);
	tsb 	buffer_b(b, select, out);
	
endmodule //end mux based on tri-state buffers
	
module tsb(in, enable, out);
	input [31:0] in;
	input enable;
	output [31:0] out;
	wire [31:0] in, out;
	wire enable;
	
	assign out = (enable) ? in : 32'bz;
	
endmodule //end 32-bit tri-state buffer

//end barrel shifter + supporting modules

module bitwise_and(a, b, out);
	input [31:0] a, b;
	output [31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: and_loop
			and(out[i], a[i], b[i]);
		end
	endgenerate

endmodule //end 32-bit bitwise AND

module bitwise_or(a, b, out);
	input [31:0] a, b;
	output [31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: or_loop
			or(out[i], a[i], b[i]);
		end
	endgenerate
	
endmodule //end 32-bit bitwise OR

module bitwise_not(in, out);
	input [31:0] in;
	output [31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: not_loop
			assign out[i] = ~in[i];
		end
	endgenerate

endmodule //end 32-bit bitwise NOT

//end bitwise operators

module equal_or_less(in, equal, less);
   input [31:0] in;
   output equal, less;
   wire equal, less;
   
   or(equal, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24],
			in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16],
			in[15], in[14], in[13], in[12], in[11], in[10], in[9] , in[8] ,
			in[7] , in[6] , in[5] , in[4] , in[3] , in[2] , in[1] , in[0]);
				   
   assign less = in[31];
   
endmodule //end shorthand comparator module   

module tsb_1bit(in, enable, out);
	input in, enable;
	output out;
	wire in, enable, out;
	
	assign out = (enable) ? in : 1'bz;
	
endmodule //end 1-bit tri-state buffer
	
//end comparison modules

module opcode_decoder(code_in, code_out);
	input [4:0] code_in;
	output [5:0] code_out;
	wire [5:0] code_out;
	
	and(code_out[0], ~code_in[0], ~code_in[1], ~code_in[2], ~code_in[3], ~code_in[4]); //add
	and(code_out[1],  code_in[0], ~code_in[1], ~code_in[2], ~code_in[3], ~code_in[4]); //subtract
	and(code_out[2], ~code_in[0],  code_in[1], ~code_in[2], ~code_in[3], ~code_in[4]); //and
	and(code_out[3],  code_in[0],  code_in[1], ~code_in[2], ~code_in[3], ~code_in[4]); //or
	and(code_out[4], ~code_in[0], ~code_in[1],  code_in[2], ~code_in[3], ~code_in[4]); //sll
	and(code_out[5],  code_in[0], ~code_in[1],  code_in[2], ~code_in[3], ~code_in[4]); //sra
	
endmodule //end alu-opcode decoder
   
module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan);
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
   output [31:0] data_result;
   output isNotEqual, isLessThan;
   
   wire [5:0] decoded_op;
   wire csum_out, cdif_out;
   wire [31:0] results [5:0];
   wire equal, less;
   
   opcode_decoder					alu_decoder(ctrl_ALUopcode, decoded_op);
   
   adder_csel						alu_adder(data_operandA, data_operandB, 0, results[0], csum_out);
   subtractor_csel					alu_subtract(data_operandA, data_operandB, results[1], cdif_out);
   bitwise_and						alu_and(data_operandA, data_operandB, results[2]);
   bitwise_or						alu_or(data_operandA, data_operandB, results[3]);
   logical_left_shift					left_shift_l(data_operandA, ctrl_shiftamt, 0, results[4]);
   arithmetic_right_shift				right_shift_a(data_operandA, ctrl_shiftamt, data_operandA[31], results[5]);
   equal_or_less					quick_compare(results[1], equal, less);
   
   tsb			buffer_add(results[0], decoded_op[0], data_result);
   tsb			buffer_sub(results[1], decoded_op[1], data_result);
   tsb			buffer_and(results[2], decoded_op[2], data_result);
   tsb			buffer_or (results[3], decoded_op[3], data_result);
   tsb			buffer_sll(results[4], decoded_op[4], data_result);
   tsb			buffer_sra(results[5], decoded_op[5], data_result);
   tsb_1bit		buffer_equal(equal, decoded_op[1], isNotEqual);
   tsb_1bit		buffer_less (less , decoded_op[1], isLessThan);

endmodule