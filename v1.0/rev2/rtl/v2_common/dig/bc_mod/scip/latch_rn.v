// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

module latch_rn (
	input d,
	input clk,
	input rn,
	output reg q
);

`ifdef BEHAVIORAL
always @(*) begin
	if (!rn) begin
		q <= 0;
	end else begin
		if (clk)
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
