`timescale 1ps/1fs

module aibio_clkdist_inv1_cbb
(
	//------Supply pins------//
	input vddcq,
	input vss,
	//------Input pins------//
	input clkp,
	input clkn,
	//------Output pins------//
	output clkp_b,
	output clkn_b
);

assign clkp_b = ~clkp;
assign clkn_b = ~clkn;

endmodule
