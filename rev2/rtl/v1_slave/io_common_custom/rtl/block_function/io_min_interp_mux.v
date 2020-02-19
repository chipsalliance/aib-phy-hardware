// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

module io_min_interp_mux (

input      [3:0] phy_clk_phs, // half of 8 phase 1.6GHz clock
input            svcc,        // for soft tie high
output           c_out        // 1 of the 3 output phases
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INVERTER_DELAY = 15;
parameter  FINGER_DELAY   = 45;

wire  out_vl;

//--------------------------------------------------------------------------------------------------
//  Finger Mux delay for phs[0]
//--------------------------------------------------------------------------------------------------

assign #FINGER_DELAY out_vl = phy_clk_phs[1];
assign #(2 * INVERTER_DELAY) c_out = out_vl;

endmodule

