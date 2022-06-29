`timescale 1ps/1fs

module aibio_se_to_diff
	(
	input vddcq,
	input vss,
	input i,
	output o,
	output o_b
	);

assign o = i;
assign o_b = ~i;

endmodule
