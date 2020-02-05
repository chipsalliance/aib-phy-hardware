// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cmn_clkgate_high
(
	input	wire		cpn,
	input	wire		e,
	input	wire		te,
	output	wire		q
);

	wire	clk;
	wire	clken;
	reg	latch_clken;

	assign clk = cpn;
	assign clken = e || te;

        always @(clk or clken)
        begin
		if (clk)
                begin
                        latch_clken <= clken;
                end
        end

	assign q = clk | ~latch_clken;

endmodule // c3aibadapt_cmn_clkgate_high
