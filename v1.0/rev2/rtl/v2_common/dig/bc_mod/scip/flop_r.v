// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

module flop_r (
	input d,
	input clk,
	input r,
	output reg q
);

`ifdef BEHAVIORAL
always @(posedge clk or posedge r) begin
	if (r) begin
		q <= 0;
	end else begin
		q <= d;
	end
end
`else
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule
