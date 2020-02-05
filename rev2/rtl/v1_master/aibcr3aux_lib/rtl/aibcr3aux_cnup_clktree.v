// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_cnup_clktree, View -
//schematic
// `timescale 1ns / 1ns 

module aibcr3aux_cnup_clktree ( strbclk0, strbclk1, strbclk2, strbclk3,
     strbclk4, strbclk5, strbclk6, strbclk7, strbclk8, strbclk9,
     strbclk10, strbclk11, strbclk12, strbclk13, strbclk14, strbclk15,
     strbclk16, strbclk17, strbclk18, strbclk19, strbclk20, strbclk21,
     strbclk22, strbclk23, strbclk24, strbclk25, clkin, clkinb,
     csr_dly_ovrd, csr_dly_ovrden, ib50u_ring, ib50uc, iosc_fuse_trim,
     vcc_aibcr3aux, vss_aibcr3aux );

output  strbclk0, strbclk1, strbclk2, strbclk3, strbclk4, strbclk5,
     strbclk6, strbclk7, strbclk8, strbclk9, strbclk10, strbclk11,
     strbclk12, strbclk13, strbclk14, strbclk15, strbclk16, strbclk17,
     strbclk18, strbclk19, strbclk20, strbclk21, strbclk22, strbclk23,
     strbclk24, strbclk25;

input  clkin, clkinb, csr_dly_ovrden, ib50u_ring, ib50uc, vcc_aibcr3aux,
     vss_aibcr3aux;

input [3:0]  csr_dly_ovrd;
input [9:0]  iosc_fuse_trim;

wire  clk25, net56;
wire clkout_r;
wire lvl0_out;
wire clkout_l;
wire net57;
wire net066;
wire clkb25;

assign clk25 = net56;

/*
aibcr3_clkbuf  xbuf_lvl1_r ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(clkout_r), .in(lvl0_out));
aibcr3_clkbuf  xbuf_lvl1_m ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(net56), .in(lvl0_out));
aibcr3_clkbuf  xbuf_lvl1_l ( .vss_pl(vss_aibcr3aux),
     .vcc_pl(vcc_aibcr3aux), .out(clkout_l), .in(lvl0_out));
*/

assign clkout_r = lvl0_out;
assign net56 = lvl0_out;
assign clkout_l = lvl0_out;

aibcr3_aliasd aliasv1 ( .rb(strbclk0), .ra(clkout_l));
aibcr3_aliasd aliasv18 ( .rb(strbclk23), .ra(net56));
aibcr3_aliasd aliasv10 ( .rb(strbclk16), .ra(clkout_r));
aibcr3_aliasd aliasv13 ( .rb(strbclk19), .ra(clkout_r));
aibcr3_aliasd aliasv14 ( .rb(strbclk17), .ra(clkout_r));
aibcr3_aliasd aliasv11 ( .rb(strbclk18), .ra(clkout_r));
aibcr3_aliasd aliasv8 ( .rb(strbclk12), .ra(clkout_r));
aibcr3_aliasd aliasv15 ( .rb(strbclk15), .ra(clkout_r));
aibcr3_aliasd aliasv9 ( .rb(strbclk14), .ra(clkout_r));
aibcr3_aliasd aliasv16 ( .rb(strbclk13), .ra(clkout_r));
aibcr3_aliasd aliasv17 ( .rb(strbclk11), .ra(clkout_r));
aibcr3_aliasd aliasv7 ( .rb(strbclk10), .ra(clkout_r));
aibcr3_aliasd aliasv25 ( .rb(strbclk21), .ra(net56));
aibcr3_aliasd aliasv6 ( .rb(strbclk25), .ra(net57));
aibcr3_aliasd aliasv24 ( .rb(strbclk20), .ra(net56));
aibcr3_aliasd aliasv19 ( .rb(strbclk9), .ra(clkout_l));
aibcr3_aliasd aliasv4 ( .rb(strbclk6), .ra(clkout_l));
aibcr3_aliasd aliasv5 ( .rb(strbclk8), .ra(clkout_l));
aibcr3_aliasd aliasv20 ( .rb(strbclk7), .ra(clkout_l));
aibcr3_aliasd aliasv2 ( .rb(strbclk2), .ra(clkout_l));
aibcr3_aliasd aliasv21 ( .rb(strbclk5), .ra(clkout_l));
aibcr3_aliasd aliasv12 ( .rb(strbclk22), .ra(net56));
aibcr3_aliasd aliasv3 ( .rb(strbclk4), .ra(clkout_l));
aibcr3_aliasd aliasv0 ( .rb(strbclk24), .ra(net56));
aibcr3_aliasd aliasv23 ( .rb(strbclk1), .ra(clkout_l));
aibcr3_aliasd aliasv22 ( .rb(strbclk3), .ra(clkout_l));

assign net066 = clkin;
assign lvl0_out = net066;

//sa_buf01_ulvt x6 ( .vssesa(vss_aibcr3aux), .vccesa(vcc_aibcr3aux),     .out(net066), .in(clkin));
//aibcr3_preclkbuf  xbuf_lvl0 ( .vss_pl(vss_aibcr3aux),
//     .vcc_pl(vcc_aibcr3aux), .out(lvl0_out), .in(net066));

aibcr3aux_outclkdly  xoutclkdly ( .ib50uc(ib50uc),
     .ib50u_ring(ib50u_ring), .clkinb(clkb25),
     .csr_dly_ovrd(csr_dly_ovrd[3:0]), .csr_dly_ovrden(csr_dly_ovrden),
     .vssl_aibcr3aux(vss_aibcr3aux), .clkin(clk25),
     .vcc_aibcr3aux(vcc_aibcr3aux), .clkout(net57),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]));

assign clkb25 = !net56;

// sa_invg2_ulvt x8 ( .vssesa(vss_aibcr3aux), .vccesa(vcc_aibcr3aux),     .out(clkb25), .in(net56));

endmodule

