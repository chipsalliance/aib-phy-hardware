// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_2ff_scan (
	input wire clk,
	input wire d,
	output wire o,
	input wire rb,
	input wire si,
	output wire so,
	input wire ssb
);

	wire mgm_d2_row1;
	wire mgm_d2_row2;
	wire mgm_d2_row3;
	
	wire q1, q2, q3, q4;

	assign o = !q1;
	//assign q1_inv = !q1;
	assign so = !q1 & !ssb;
	
	//assign d_inv	= !d;
	//assign si_inv	= !si_inv;
	//assign ssb_inv	= !ssb; 
	
	assign mgm_d2_row1 = !d & !si; 
	assign mgm_d2_row2 = !d & ssb;
	assign mgm_d2_row3 = !si & !ssb;
	
	assign mgm_d2 = mgm_d2_row1 | mgm_d2_row2 | mgm_d2_row3;	

aibnd_hgy_latch aibnd_hgy_latch_inst0 (
	.q (q1),
	.set (1'b0),
	.preset (!rb),
	.clk (clk),
	.d (!q4)
);

aibnd_hgy_latch aibnd_hgy_latch_inst1 (
	.q (q2),
	.set (1'b0),
	.preset (!rb),
	.clk (clk),
	.d (q3)
);

aibnd_hgy_latch aibnd_hgy_latch_inst2 (
	.q (q3),
	.set (1'b0),
	.preset (!rb),
	.clk (!clk),
	.d (mgm_d2)
);

aibnd_hgy_latch aibnd_hgy_latch_inst3 (
	.q (q4),
	.set (!rb),
	.preset (1'b0),
	.clk (!clk),
	.d (!q2)
);

endmodule



