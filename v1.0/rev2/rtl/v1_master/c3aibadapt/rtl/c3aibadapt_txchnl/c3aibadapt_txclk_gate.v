// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txclk_gate
(
	input	wire		cp,
	input	wire		e,
	input	wire		te,
	output	wire		q
);

	wire	clk;
	wire	clk_n;
	wire	clken;
	reg	latch_clken;

	assign clk = cp;
	assign clk_n = ~cp;
	assign clken = e || te;

        always @(clk_n or clken)
        begin
		if (clk_n)
                begin
                        latch_clken <= clken;
                end
        end

	assign q = clk & latch_clken;

endmodule // c3aibadapt_txclk_gate
