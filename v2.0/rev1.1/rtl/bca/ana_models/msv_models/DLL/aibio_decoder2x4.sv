`timescale 1ps/1fs

module aibio_decoder2x4
	(
	//----------Supply pins------------//
	input vddcq,
	input vss,
	//----------Input pins------------//
	input [1:0] i,
	//----------Output pins----------//
	output reg [3:0] o
	);

always @(i)
	case(i)
   	2'b00 : o = 4'b0001;
      2'b01 : o = 4'b0010;
		2'b10 : o = 4'b0100;
      2'b11 : o = 4'b1000;
      default : o = 4'b0000;
	endcase


endmodule

