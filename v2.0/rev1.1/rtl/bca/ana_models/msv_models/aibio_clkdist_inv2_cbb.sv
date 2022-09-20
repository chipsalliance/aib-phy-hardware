`timescale 1ps/1fs

module aibio_clkdist_inv2_cbb
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

wire clkp_b_1;
wire clkp_b_2;
wire clkn_b_1;
wire clkn_b_2;

`ifdef POST_WORST
	localparam delay_1 = 100;
	localparam delay_2 = 16.5;
`else
	localparam delay_1 = 0.0;
	localparam delay_2 = 0.0;
`endif

assign #(delay_1) clkp_b_1 = ~clkp;
assign #(delay_2) clkp_b_2 = ~clkp_b_1;
assign #(delay_2) clkp_b = ~clkp_b_2;

assign #(delay_1) clkn_b_1 = ~clkn;
assign #(delay_2) clkn_b_2 = ~clkn_b_1;
assign #(delay_2) clkn_b = ~clkn_b_2;

/*
assign #(delay_clkp_b)clkp_b = ~clkp;
assign #(delay_clkn_b)clkn_b = ~clkn;
*/

endmodule
