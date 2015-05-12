module tsb(in, enable, out);
	input [31:0] in;
	input enable;
	output [31:0] out;
	wire [31:0] in, out;
	wire enable;
	
	assign out = (enable) ? in : 32'bz;
	
endmodule //end tri-state buffer

module dff_sr(in, enable, clock, reset, out);
	input in, enable, clock, reset;
	output out;
	reg out;
	
	always @ (posedge clock or posedge reset) begin
		if (reset) begin
			out <= 1'b0;
		end 
		else if (enable) begin
			out <= in;
		end	
	end
endmodule //end d flip flop w/ asynchronous reset

module read_decoder(in, out);
	input [4:0] in;
	output [31:0] out;
	
	wire [4:0] in;
	wire [31:0] out;
	
	and(out[0], ~in[0], ~in[1], ~in[2], ~in[3], ~in[4]);
	and(out[1],  in[0], ~in[1], ~in[2], ~in[3], ~in[4]);
	and(out[2], ~in[0],  in[1], ~in[2], ~in[3], ~in[4]);
	and(out[3],  in[0],  in[1], ~in[2], ~in[3], ~in[4]);
	and(out[4], ~in[0], ~in[1],  in[2], ~in[3], ~in[4]);
	and(out[5],  in[0], ~in[1],  in[2], ~in[3], ~in[4]);
	and(out[6], ~in[0],  in[1],  in[2], ~in[3], ~in[4]);
	and(out[7],  in[0],  in[1],  in[2], ~in[3], ~in[4]);
	and(out[8], ~in[0], ~in[1], ~in[2],  in[3], ~in[4]);
	and(out[9],  in[0], ~in[1], ~in[2],  in[3], ~in[4]);
	
	and(out[10], ~in[0],  in[1], ~in[2],  in[3], ~in[4]);
	and(out[11],  in[0],  in[1], ~in[2],  in[3], ~in[4]);
	and(out[12], ~in[0], ~in[1],  in[2],  in[3], ~in[4]);
	and(out[13],  in[0], ~in[1],  in[2],  in[3], ~in[4]);
	and(out[14], ~in[0],  in[1],  in[2],  in[3], ~in[4]);
	and(out[15],  in[0],  in[1],  in[2],  in[3], ~in[4]);
	and(out[16], ~in[0], ~in[1], ~in[2], ~in[3],  in[4]);
	and(out[17],  in[0], ~in[1], ~in[2], ~in[3],  in[4]);
	and(out[18], ~in[0],  in[1], ~in[2], ~in[3],  in[4]);
	and(out[19],  in[0],  in[1], ~in[2], ~in[3],  in[4]);
	and(out[20], ~in[0], ~in[1],  in[2], ~in[3],  in[4]);
	
	and(out[21],  in[0], ~in[1],  in[2], ~in[3],  in[4]);
	and(out[22], ~in[0],  in[1],  in[2], ~in[3],  in[4]);
	and(out[23],  in[0],  in[1],  in[2], ~in[3],  in[4]);
	and(out[24], ~in[0], ~in[1], ~in[2],  in[3],  in[4]);
	and(out[25],  in[0], ~in[1], ~in[2],  in[3],  in[4]);
	and(out[26], ~in[0],  in[1], ~in[2],  in[3],  in[4]);
	and(out[27],  in[0],  in[1], ~in[2],  in[3],  in[4]);
	and(out[28], ~in[0], ~in[1],  in[2],  in[3],  in[4]);
	and(out[29],  in[0], ~in[1],  in[2],  in[3],  in[4]);
	and(out[30], ~in[0],  in[1],  in[2],  in[3],  in[4]);
	and(out[31],  in[0],  in[1],  in[2],  in[3],  in[4]);
	
endmodule //end read-decoder for tri-state buffer banks

module write_decoder(in, enable, out);
	input [4:0] in;
	input enable;
	output [31:0] out;
	
	wire [4:0] in;
	wire enable;
	wire [31:0] out;
	
	and(out[0], ~in[0], ~in[1], ~in[2], ~in[3], ~in[4], enable);
	and(out[1],  in[0], ~in[1], ~in[2], ~in[3], ~in[4], enable);
	and(out[2], ~in[0],  in[1], ~in[2], ~in[3], ~in[4], enable);
	and(out[3],  in[0],  in[1], ~in[2], ~in[3], ~in[4], enable);
	and(out[4], ~in[0], ~in[1],  in[2], ~in[3], ~in[4], enable);
	and(out[5],  in[0], ~in[1],  in[2], ~in[3], ~in[4], enable);
	and(out[6], ~in[0],  in[1],  in[2], ~in[3], ~in[4], enable);
	and(out[7],  in[0],  in[1],  in[2], ~in[3], ~in[4], enable);
	and(out[8], ~in[0], ~in[1], ~in[2],  in[3], ~in[4], enable);
	and(out[9],  in[0], ~in[1], ~in[2],  in[3], ~in[4], enable);
	
	and(out[10], ~in[0],  in[1], ~in[2],  in[3], ~in[4], enable);
	and(out[11],  in[0],  in[1], ~in[2],  in[3], ~in[4], enable);
	and(out[12], ~in[0], ~in[1],  in[2],  in[3], ~in[4], enable);
	and(out[13],  in[0], ~in[1],  in[2],  in[3], ~in[4], enable);
	and(out[14], ~in[0],  in[1],  in[2],  in[3], ~in[4], enable);
	and(out[15],  in[0],  in[1],  in[2],  in[3], ~in[4], enable);
	and(out[16], ~in[0], ~in[1], ~in[2], ~in[3],  in[4], enable);
	and(out[17],  in[0], ~in[1], ~in[2], ~in[3],  in[4], enable);
	and(out[18], ~in[0],  in[1], ~in[2], ~in[3],  in[4], enable);
	and(out[19],  in[0],  in[1], ~in[2], ~in[3],  in[4], enable);
	and(out[20], ~in[0], ~in[1],  in[2], ~in[3],  in[4], enable);
	
	and(out[21],  in[0], ~in[1],  in[2], ~in[3],  in[4], enable);
	and(out[22], ~in[0],  in[1],  in[2], ~in[3],  in[4], enable);
	and(out[23],  in[0],  in[1],  in[2], ~in[3],  in[4], enable);
	and(out[24], ~in[0], ~in[1], ~in[2],  in[3],  in[4], enable);
	and(out[25],  in[0], ~in[1], ~in[2],  in[3],  in[4], enable);
	and(out[26], ~in[0],  in[1], ~in[2],  in[3],  in[4], enable);
	and(out[27],  in[0],  in[1], ~in[2],  in[3],  in[4], enable);
	and(out[28], ~in[0], ~in[1],  in[2],  in[3],  in[4], enable);
	and(out[29],  in[0], ~in[1],  in[2],  in[3],  in[4], enable);
	and(out[30], ~in[0],  in[1],  in[2],  in[3],  in[4], enable);
	and(out[31],  in[0],  in[1],  in[2],  in[3],  in[4], enable);

endmodule //end write decoder for registers

module register(in, enable, clock, reset, out);
   input [31:0] in;
   input enable, clock, reset;
   output [31:0] out;
   
   wire [31:0] in;
   wire enable, clock, reset;
   
   genvar i; 
   generate 
	for (i=0; i<32; i=i+1) begin: dff_loop_32 
		dff_sr  async_dff(in[i], enable, clock, reset, out[i]); 
	end 
   endgenerate
   
endmodule //end 32-bit wide register
   
module register_file(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);
   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;
   output [31:0] data_readRegA, data_readRegB;
   
   // enable wire for register
   wire [31:0] decoded_writeReg;
   
   // register output wires
   wire [31:0] wire_array [31:0];
   
   // wires choosing tri-states
   wire [31:0] decoded_tsb_setA;
   wire [31:0] decoded_tsb_setB;
   
   // write decoder
   write_decoder write_decoder(ctrl_writeReg, ctrl_writeEnable, decoded_writeReg); 
   
   // read decoders
   read_decoder read_decoderA(ctrl_readRegA, decoded_tsb_setA);
   read_decoder read_decoderB(ctrl_readRegB, decoded_tsb_setB);
   
   // 32 registers and 64 tri-state-buffers in sets of 32, with register outputs fed into tsbs
   genvar a;
   generate
	for (a=0; a<32; a=a+1) begin: register_loop_32
		register register(data_writeReg, decoded_writeReg[a], clock, ctrl_reset, wire_array[a]);
		tsb      tri_stateA(wire_array[a], decoded_tsb_setA[a], data_readRegA);
		tsb      tri_stateB(wire_array[a], decoded_tsb_setB[a], data_readRegB);
	end
   endgenerate
   
endmodule