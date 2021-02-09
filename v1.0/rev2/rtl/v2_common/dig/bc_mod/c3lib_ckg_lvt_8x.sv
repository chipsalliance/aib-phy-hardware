// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation. 
// *****************************************************************************
//  Module Name :  c3lib_ckg_lvt_8x
//  Date        :  Thu May 12 10:45:17 2016
//  Description :  Posetive edge clock gater (LVT, 8x drive strength)
// *****************************************************************************

// Ayar modifications: Added default_nettype none block to try to guard against
// net name typos, switched to using a hardened clock gate cell because genus
// does not seem to be able to recognize it
`default_nettype none
module c3lib_ckg_lvt_8x(

  tst_en,
  clk_en,
  clk,
  gated_clk

);

    input wire tst_en;
    input wire clk_en;
    input wire clk;
    output wire gated_clk;

`ifdef BEHAVIORAL
    var logic latch_d;
    var logic latch_q;

    // Formulate control signal
    assign latch_d = clk_en | tst_en;

    // Latch control signal
    always_latch if (~clk) latch_q <= latch_d;

    // Actual clk gating gate
    assign gated_clk = clk & latch_q;
`else
    b15cilb01ah1n08x5 icg_cell (.clkout(gated_clk), .en(clk_en), .te(tst_en), .clk(clk));
`endif


endmodule
`default_nettype wire



