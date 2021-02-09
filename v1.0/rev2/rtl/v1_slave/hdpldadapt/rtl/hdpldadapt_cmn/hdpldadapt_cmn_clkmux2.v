// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkmux2
(
        output  wire    clk_o,
        input   wire    clk_0,
        input   wire    clk_1,
        input   wire    clk_sel
);

hdpldadapt_cmn_clkmux2_cell hdpldadapt_cmn_clkmux2_cell
    (
        .s(clk_sel),
        .clk2(clk_0),
        .clk1(clk_1),
        .clkout(clk_o)
    );

endmodule // hdpldadapt_cmn_clkmux2
