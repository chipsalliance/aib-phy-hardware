// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cmn_clkmux2
(
        output  wire    clk_o,
        input   wire    clk_0,
        input   wire    clk_1,
        input   wire    clk_sel
);

c3aibadapt_cmn_clkmux2_cell adapt_cmn_clkmux2_cell
    (
        .S(clk_sel),
        .I0(clk_0),
        .I1(clk_1),
        .Z(clk_o)
    );

endmodule // c3aibadapt_cmn_clkmux2
