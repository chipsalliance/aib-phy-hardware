// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module io_8phs_calibrate_x48 (
input  [7:0] phs_in,
input  [3:0] phy_clk_phs_ctrl,
input        cenable,
input  [5:0] f_gray_pair0,
input  [5:0] f_gray_pair1,
input  [5:0] f_gray_pair2,
input  [5:0] f_gray_pair3,
input  [5:0] r_gray_pair0,
input  [5:0] r_gray_pair1,
input  [5:0] r_gray_pair2,
input  [5:0] r_gray_pair3,
input        rst_n,
input        sample_clk,
output [7:0] phs_calibrate,
output [7:0] phs_and_sample,
output [3:0] phs_sample
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire         spc;
wire         snc;
wire   [7:0] adjusted_phase;

assign spc = ~cenable;
assign snc =  cenable;

`ifdef TEST_DUTY_CYCLE_CORRECTION
  assign #40 adjusted_phase[0] = phs_in[0];
  assign #30 adjusted_phase[1] = phs_in[1];
  assign #1  adjusted_phase[2] = phs_in[2];
  assign #10 adjusted_phase[3] = phs_in[3];
  assign #10 adjusted_phase[4] = phs_in[4];
  assign #40 adjusted_phase[5] = phs_in[5];
  assign #20 adjusted_phase[6] = phs_in[6];
  assign #50 adjusted_phase[7] = phs_in[7];
`else
  assign adjusted_phase[0] = phs_in[0];
  assign adjusted_phase[1] = phs_in[1];
  assign adjusted_phase[2] = phs_in[2];
  assign adjusted_phase[3] = phs_in[3];
  assign adjusted_phase[4] = phs_in[4];
  assign adjusted_phase[5] = phs_in[5];
  assign adjusted_phase[6] = phs_in[6];
  assign adjusted_phase[7] = phs_in[7];
`endif

io_phs_check xphs_check (
.rst_n           ( rst_n                 ),
.sample_clk      ( sample_clk            ),
.ph_in           ( phs_calibrate[7:0] ),
.ph_and_sample   ( phs_and_sample[7:0]   ),
.ph_sample       ( phs_sample[3:0]       )
);

io_phs_pair_couple_x48 xpair0 (
.c_in_p          ( adjusted_phase[0]     ),
.c_in_n          ( adjusted_phase[4]     ),
.phy_clk_phs_ctrl( phy_clk_phs_ctrl[0]   ),
.snc             ( snc                   ),
.spc             ( spc                   ),
.r_gray          ( r_gray_pair0[5:0]     ),
.f_gray          ( f_gray_pair0[5:0]     ),
.c_out_p         ( phs_calibrate[0]      ),
.c_out_n         ( phs_calibrate[4]      )
);

io_phs_pair_couple_x48 xpair1 (
.c_in_p          ( adjusted_phase[1]     ),
.c_in_n          ( adjusted_phase[5]     ),
.phy_clk_phs_ctrl( phy_clk_phs_ctrl[1]   ),
.snc             ( snc                   ),
.spc             ( spc                   ),
.r_gray          ( r_gray_pair1[5:0]     ),
.f_gray          ( f_gray_pair1[5:0]     ),
.c_out_p         ( phs_calibrate[1]      ),
.c_out_n         ( phs_calibrate[5]      )
);

io_phs_pair_couple_x48 xpair2 (
.c_in_p          ( adjusted_phase[2]     ),
.c_in_n          ( adjusted_phase[6]     ),
.phy_clk_phs_ctrl( phy_clk_phs_ctrl[2]   ),
.snc             ( snc                   ),
.spc             ( spc                   ),
.r_gray          ( r_gray_pair2[5:0]     ),
.f_gray          ( f_gray_pair2[5:0]     ),
.c_out_p         ( phs_calibrate[2]      ),
.c_out_n         ( phs_calibrate[6]      )
);

io_phs_pair_couple_x48 xpair3 (
.c_in_p          ( adjusted_phase[3]     ),
.c_in_n          ( adjusted_phase[7]     ),
.phy_clk_phs_ctrl( phy_clk_phs_ctrl[3]   ),
.snc             ( snc                   ),
.spc             ( spc                   ),
.r_gray          ( r_gray_pair3[5:0]     ),
.f_gray          ( f_gray_pair3[5:0]     ),
.c_out_p         ( phs_calibrate[3]      ),
.c_out_n         ( phs_calibrate[7]      )
);

endmodule


