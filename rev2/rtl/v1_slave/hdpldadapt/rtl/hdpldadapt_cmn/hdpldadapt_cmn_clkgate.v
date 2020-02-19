// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkgate
(
	input	wire		clk,
	input	wire		en,
	input	wire		te,
	output	wire		clkout
);

	wire	clk_n;
	wire	clken;
	reg	latch_clken;

	assign clk_n = ~clk;
	assign clken = en || te;

        always @(clk_n or clken)
        begin
		if (clk_n)
                begin
                        latch_clken <= clken;
                end
        end

	assign clkout = clk & latch_clken;

endmodule // hdpldadapt_cmn_clkgate
