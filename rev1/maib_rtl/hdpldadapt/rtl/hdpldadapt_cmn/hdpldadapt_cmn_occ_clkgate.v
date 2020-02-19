// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_occ_clkgate
(
	input	wire		clk,
	input	wire		clk_enable_i,
	output	wire		clk_o
);

hdpldadapt_cmn_clkgate hdpldadapt_cmn_clkgate
    (
        .clk(clk),
        .en(clk_enable_i),
        .te(1'b0),
        .clkout(clk_o)
    );

endmodule // hdpldadapt_cmn_occ_clkgate
