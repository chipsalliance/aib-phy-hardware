`timescale 1ps/1fs

module aibio_3bit_bin_to_therm
		(
		//--------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins----------//
		input [2:0] b,
		//-------Outptu pins---------//
		output reg [6:0] t
		);

always @(b)
	case(b)
   	3'b000 : t = 7'b000_0000;
      3'b001 : t = 7'b000_0001;
		3'b010 : t = 7'b000_0011;
      3'b011 : t = 7'b000_0111;
   	3'b100 : t = 7'b000_1111;
      3'b101 : t = 7'b001_1111;
		3'b110 : t = 7'b011_1111;
      3'b111 : t = 7'b111_1111;
      default : t = 8'b0000_0000;
	endcase

endmodule

