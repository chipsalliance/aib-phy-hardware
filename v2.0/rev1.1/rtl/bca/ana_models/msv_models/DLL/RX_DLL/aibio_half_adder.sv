`timescale 1ps/1fs

module aibio_half_adder
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins----------//
		input a,
		input b,
		//------Output pins---------//
		output c,
		output s
		);

assign s = a^b;
assign c = a&&b;

endmodule
