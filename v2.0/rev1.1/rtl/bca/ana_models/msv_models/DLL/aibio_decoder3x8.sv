`timescale 1ps/1fs

module aibio_decoder3x8
		(
		//---------Supply pins---------//
		input vddcq,
		input vss,
		//--------Input pins----------//
		input [2:0] i,
		//--------Output pins---------//
		output reg [7:0] o
		);

always @(i)
	case(i)
   	3'b000 : o = 8'b0000_0001;
      3'b001 : o = 8'b0000_0010;
		3'b010 : o = 8'b0000_0100;
      3'b011 : o = 8'b0000_1000;
   	3'b100 : o = 8'b0001_0000;
      3'b101 : o = 8'b0010_0000;
		3'b110 : o = 8'b0100_0000;
      3'b111 : o = 8'b1000_0000;
      default : o = 8'b0000_0000;
	endcase

endmodule
