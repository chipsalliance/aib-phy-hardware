// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkmux2_cell
(
        output  wire    clkout,
        input   wire    clk2,
        input   wire    clk1,
        input   wire    s
);

      assign clkout = s ? clk1 : clk2;

endmodule // hdpldadapt_cmn_clkmux2_cell
