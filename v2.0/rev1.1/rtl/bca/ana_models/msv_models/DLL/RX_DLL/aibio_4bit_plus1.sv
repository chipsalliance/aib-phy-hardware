`timescale 1ps/1fs

module aibio_4bit_plus1
		(
		//-------Supply pins------//
		input vddcq,
		input vss,
		//-------Input pins--------//
		input [3:0] i_code,
		//-------Output pins-------//
		output [3:0] o_code
		);

wire net13;
wire net14;
wire net15;
wire net27;

aibio_half_adder I0
		(
		.vddcq(vddcq),
		.vss(vss),
		.a(i_code[0]),
		.b(1'b1),
		.c(net13),
		.s(o_code[0])
		);

aibio_half_adder I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.a(i_code[1]),
		.b(net13),
		.c(net14),
		.s(o_code[1])
		);

aibio_half_adder I2
		(
		.vddcq(vddcq),
		.vss(vss),
		.a(i_code[2]),
		.b(net14),
		.c(net15),
		.s(o_code[2])
		);

aibio_half_adder I3
		(
		.vddcq(vddcq),
		.vss(vss),
		.a(i_code[3]),
		.b(net15),
		.c(net27),
		.s(o_code[3])
		);

endmodule
