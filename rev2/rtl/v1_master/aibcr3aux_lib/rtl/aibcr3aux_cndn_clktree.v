// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_cndn_clktree, View -
//schematic
// LAST TIME SAVED: Apr 16 09:49:55 2015
// NETLIST TIME: Jun  3 17:00:05 2015
// `timescale 1ns / 1ns 

module aibcr3aux_cndn_clktree ( lstrbclk_l_0, lstrbclk_l_1,
     lstrbclk_l_2, lstrbclk_l_3, lstrbclk_l_4, lstrbclk_l_5,
     lstrbclk_l_6, lstrbclk_l_7, lstrbclk_l_8, lstrbclk_l_9,
     lstrbclk_l_10, lstrbclk_l_11, lstrbclk_mimic0, lstrbclk_mimic1,
     lstrbclk_mimic2, lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2,
     lstrbclk_r_3, lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6,
     lstrbclk_r_7, lstrbclk_r_8, lstrbclk_r_9, lstrbclk_r_10,
     lstrbclk_r_11, lstrbclk_rep, clkin, clkinb, csr_dly_ovrd,
     csr_dly_ovrden, ib50u_ring, ib50uc, iosc_fuse_trim, vcc_aibcr3aux,
     vss_aibcr3aux );

output  lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2, lstrbclk_l_3,
     lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6, lstrbclk_l_7,
     lstrbclk_l_8, lstrbclk_l_9, lstrbclk_l_10, lstrbclk_l_11,
     lstrbclk_mimic0, lstrbclk_mimic1, lstrbclk_mimic2, lstrbclk_r_0,
     lstrbclk_r_1, lstrbclk_r_2, lstrbclk_r_3, lstrbclk_r_4,
     lstrbclk_r_5, lstrbclk_r_6, lstrbclk_r_7, lstrbclk_r_8,
     lstrbclk_r_9, lstrbclk_r_10, lstrbclk_r_11, lstrbclk_rep;

input  clkin, clkinb, csr_dly_ovrden, ib50u_ring, ib50uc, vcc_aibcr3aux,
     vss_aibcr3aux;

input [9:0]  iosc_fuse_trim;
input [3:0]  csr_dly_ovrd;

wire clkint;
wire clkout_r;
wire lvl0_out;
wire clkout_l;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_cndn_clktree";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_inclkdly  xinclkdly ( .ib50uc(ib50uc),
     .ib50u_ring(ib50u_ring), .clkinb(clkinb),
     .csr_dly_ovrd(csr_dly_ovrd[3:0]), .csr_dly_ovrden(csr_dly_ovrden),
     .vssl_aibcr3aux(vss_aibcr3aux), .clkin(clkin),
     .vcc_aibcr3aux(vcc_aibcr3aux), .clkout(clkint),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]));
/*
aibcr3_clkbuf  xbuf_lvl1_r ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(clkout_r), .in(lvl0_out));
aibcr3_clkbuf  xbuf_lvl1_l ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(clkout_l), .in(lvl0_out));
aibcr3_preclkbuf  xbuf_lvl0 ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(lvl0_out), .in(clkint));
*/

assign clkout_r = lvl0_out;
assign clkout_l = lvl0_out;
assign lvl0_out = clkint;

aibcr3_aliasd aliasv23 ( .rb(lstrbclk_l_4), .ra(clkout_l));
aibcr3_aliasd aliasv5 ( .rb(lstrbclk_l_11), .ra(clkout_l));
aibcr3_aliasd aliasv27 ( .rb(lstrbclk_mimic2), .ra(clkout_r));
aibcr3_aliasd aliasv10 ( .rb(lstrbclk_r_7), .ra(clkout_r));
aibcr3_aliasd aliasv13 ( .rb(lstrbclk_r_10), .ra(clkout_r));
aibcr3_aliasd aliasv14 ( .rb(lstrbclk_r_6), .ra(clkout_r));
aibcr3_aliasd aliasv11 ( .rb(lstrbclk_r_11), .ra(clkout_r));
aibcr3_aliasd aliasv8 ( .rb(lstrbclk_r_1), .ra(clkout_r));
aibcr3_aliasd aliasv15 ( .rb(lstrbclk_r_2), .ra(clkout_r));
aibcr3_aliasd aliasv9 ( .rb(lstrbclk_r_3), .ra(clkout_r));
aibcr3_aliasd aliasv16 ( .rb(lstrbclk_r_0), .ra(clkout_r));
aibcr3_aliasd aliasv26 ( .rb(lstrbclk_mimic1), .ra(clkout_r));
aibcr3_aliasd aliasv17 ( .rb(lstrbclk_r_4), .ra(clkout_r));
aibcr3_aliasd aliasv7 ( .rb(lstrbclk_r_5), .ra(clkout_r));
aibcr3_aliasd aliasv12 ( .rb(lstrbclk_l_8), .ra(clkout_l));
aibcr3_aliasd aliasv20 ( .rb(lstrbclk_l_6), .ra(clkout_l));
aibcr3_aliasd aliasv18 ( .rb(lstrbclk_r_8), .ra(clkout_r));
aibcr3_aliasd aliasv25 ( .rb(lstrbclk_mimic0), .ra(clkout_l));
aibcr3_aliasd aliasv19 ( .rb(lstrbclk_l_10), .ra(clkout_l));
aibcr3_aliasd aliasv6 ( .rb(lstrbclk_r_9), .ra(clkout_r));
aibcr3_aliasd aliasv4 ( .rb(lstrbclk_l_7), .ra(clkout_l));
aibcr3_aliasd aliasv3 ( .rb(lstrbclk_l_3), .ra(clkout_l));
aibcr3_aliasd aliasv21 ( .rb(lstrbclk_l_2), .ra(clkout_l));
aibcr3_aliasd aliasv24 ( .rb(lstrbclk_rep), .ra(clkout_l));
aibcr3_aliasd aliasv22 ( .rb(lstrbclk_l_0), .ra(clkout_l));
aibcr3_aliasd aliasv2 ( .rb(lstrbclk_l_1), .ra(clkout_l));
aibcr3_aliasd aliasv0 ( .rb(lstrbclk_l_9), .ra(clkout_l));
aibcr3_aliasd aliasv1 ( .rb(lstrbclk_l_5), .ra(clkout_l));

endmodule

