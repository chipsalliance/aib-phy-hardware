// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_5b_b2tc, View - schematic
// LAST TIME SAVED: Dec 16 14:16:33 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_dcc_5b_b2tc ( scan_out, therm_ff, thermb_ff, vcc_pl,
     vss_pl, clk, nrst_coding, q0, q1, q2, q3, q4, rb_dcc_manual,
     rb_dcc_manual_mode, scan_in, scan_mode_n );

output  scan_out;

inout  vcc_pl, vss_pl;

input  clk, nrst_coding, q0, q1, q2, q3, q4, rb_dcc_manual_mode,
     scan_in, scan_mode_n;

output [30:0]  thermb_ff;
output [30:0]  therm_ff;

input [4:0]  rb_dcc_manual;

wire b3, rb_dcc_manual_mode, q3, b1, q1, b0, q0, b2, q2, b4, q4, b3b, b0b, b1b, b2b, b4b; // Conversion Sript Generated

// Buses in the design

wire  [30:0]  therm_prebuf;

wire  [30:0]  thermb;

wire  [30:0]  therm;

wire  [29:0]  so;



assign b3 = rb_dcc_manual_mode ? rb_dcc_manual[3] : q3;
assign b1 = rb_dcc_manual_mode ? rb_dcc_manual[1] : q1;
assign b0 = rb_dcc_manual_mode ? rb_dcc_manual[0] : q0;
assign b2 = rb_dcc_manual_mode ? rb_dcc_manual[2] : q2;
assign b4 = rb_dcc_manual_mode ? rb_dcc_manual[4] : q4;
aibnd_dcc_ff xreg1[30:0] ( therm_prebuf[30:0], {scan_out, so[29],
     so[28], so[27], so[26], so[25], so[24], so[23], so[22], so[21],
     so[20], so[19], so[18], so[17], so[16], so[15], so[14], so[13],
     so[12], so[11], so[10], so[9], so[8], so[7], so[6], so[5], so[4],
     so[3], so[2], so[1], so[0]}, vcc_pl, vss_pl, clk, therm[30:0],
     nrst_coding, scan_mode_n, {so[29], so[28], so[27], so[26], so[25],
     so[24], so[23], so[22], so[21], so[20], so[19], so[18], so[17],
     so[16], so[15], so[14], so[13], so[12], so[11], so[10], so[9],
     so[8], so[7], so[6], so[5], so[4], so[3], so[2], so[1], so[0],
     scan_in});
assign therm_ff[30:0] = !thermb_ff[30:0];
assign thermb_ff[30:0] = !therm_prebuf[30:0];
assign b3b = !b3;
assign b0b = !b0;
assign b1b = !b1;
assign b2b = !b2;
assign b4b = !b4;
aibnd_dcc_5b_b2tc_x1 x118 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[0]), .thermb(thermb[0]), .q4(b4b), .q3(b3b),
     .q2(b2b), .q1(b1b), .q0(b0), .therm_p1(therm[1]));
aibnd_dcc_5b_b2tc_x1 x149 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[17]), .thermb(thermb[17]), .q4(b4), .q3(b3b),
     .q2(b2b), .q1(b1), .q0(b0b), .therm_p1(therm[18]));
aibnd_dcc_5b_b2tc_x1 x148 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[18]), .thermb(thermb[18]), .q4(b4), .q3(b3b),
     .q2(b2b), .q1(b1), .q0(b0), .therm_p1(therm[19]));
aibnd_dcc_5b_b2tc_x1 x147 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[19]), .thermb(thermb[19]), .q4(b4), .q3(b3b),
     .q2(b2), .q1(b1b), .q0(b0b), .therm_p1(therm[20]));
aibnd_dcc_5b_b2tc_x1 x146 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[20]), .thermb(thermb[20]), .q4(b4), .q3(b3b),
     .q2(b2), .q1(b1b), .q0(b0), .therm_p1(therm[21]));
aibnd_dcc_5b_b2tc_x1 x144 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[21]), .thermb(thermb[21]), .q4(b4), .q3(b3b),
     .q2(b2), .q1(b1), .q0(b0b), .therm_p1(therm[22]));
aibnd_dcc_5b_b2tc_x1 x145 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[16]), .thermb(thermb[16]), .q4(b4), .q3(b3b),
     .q2(b2b), .q1(b1b), .q0(b0), .therm_p1(therm[17]));
aibnd_dcc_5b_b2tc_x1 x127 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[8]), .thermb(thermb[8]), .q4(b4b), .q3(b3), .q2(b2b),
     .q1(b1b), .q0(b0), .therm_p1(therm[9]));
aibnd_dcc_5b_b2tc_x1 x126 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[9]), .thermb(thermb[9]), .q4(b4b), .q3(b3), .q2(b2b),
     .q1(b1), .q0(b0b), .therm_p1(therm[10]));
aibnd_dcc_5b_b2tc_x1 x125 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[7]), .thermb(thermb[7]), .q4(b4b), .q3(b3), .q2(b2b),
     .q1(b1b), .q0(b0b), .therm_p1(therm[8]));
aibnd_dcc_5b_b2tc_x1 x124 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[6]), .thermb(thermb[6]), .q4(b4b), .q3(b3b), .q2(b2),
     .q1(b1), .q0(b0), .therm_p1(therm[7]));
aibnd_dcc_5b_b2tc_x1 x143 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[23]), .thermb(thermb[23]), .q4(b4), .q3(b3),
     .q2(b2b), .q1(b1b), .q0(b0b), .therm_p1(therm[24]));
aibnd_dcc_5b_b2tc_x1 x142 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[25]), .thermb(thermb[25]), .q4(b4), .q3(b3),
     .q2(b2b), .q1(b1), .q0(b0b), .therm_p1(therm[26]));
aibnd_dcc_5b_b2tc_x1 x141 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[24]), .thermb(thermb[24]), .q4(b4), .q3(b3),
     .q2(b2b), .q1(b1b), .q0(b0), .therm_p1(therm[25]));
aibnd_dcc_5b_b2tc_x1 x139 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[26]), .thermb(thermb[26]), .q4(b4), .q3(b3),
     .q2(b2b), .q1(b1), .q0(b0), .therm_p1(therm[27]));
aibnd_dcc_5b_b2tc_x1 x140 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[22]), .thermb(thermb[22]), .q4(b4), .q3(b3b),
     .q2(b2), .q1(b1), .q0(b0), .therm_p1(therm[23]));
aibnd_dcc_5b_b2tc_x1 x138 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[27]), .thermb(thermb[27]), .q4(b4), .q3(b3), .q2(b2),
     .q1(b1b), .q0(b0b), .therm_p1(therm[28]));
aibnd_dcc_5b_b2tc_x1 x136 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[30]), .thermb(thermb[30]), .q4(b4), .q3(b3), .q2(b2),
     .q1(b1), .q0(b0), .therm_p1(vss_pl));
aibnd_dcc_5b_b2tc_x1 x134 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[29]), .thermb(thermb[29]), .q4(b4), .q3(b3), .q2(b2),
     .q1(b1), .q0(b0b), .therm_p1(therm[30]));
aibnd_dcc_5b_b2tc_x1 x131 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[12]), .thermb(thermb[12]), .q4(b4b), .q3(b3),
     .q2(b2), .q1(b1b), .q0(b0), .therm_p1(therm[13]));
aibnd_dcc_5b_b2tc_x1 x130 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[13]), .thermb(thermb[13]), .q4(b4b), .q3(b3),
     .q2(b2), .q1(b1), .q0(b0b), .therm_p1(therm[14]));
aibnd_dcc_5b_b2tc_x1 x129 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[11]), .thermb(thermb[11]), .q4(b4b), .q3(b3),
     .q2(b2), .q1(b1b), .q0(b0b), .therm_p1(therm[12]));
aibnd_dcc_5b_b2tc_x1 x123 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[4]), .thermb(thermb[4]), .q4(b4b), .q3(b3b), .q2(b2),
     .q1(b1b), .q0(b0), .therm_p1(therm[5]));
aibnd_dcc_5b_b2tc_x1 x122 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[5]), .thermb(thermb[5]), .q4(b4b), .q3(b3b), .q2(b2),
     .q1(b1), .q0(b0b), .therm_p1(therm[6]));
aibnd_dcc_5b_b2tc_x1 x121 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[3]), .thermb(thermb[3]), .q4(b4b), .q3(b3b), .q2(b2),
     .q1(b1b), .q0(b0b), .therm_p1(therm[4]));
aibnd_dcc_5b_b2tc_x1 x119 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[1]), .thermb(thermb[1]), .q4(b4b), .q3(b3b),
     .q2(b2b), .q1(b1), .q0(b0b), .therm_p1(therm[2]));
aibnd_dcc_5b_b2tc_x1 x120 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[2]), .thermb(thermb[2]), .q4(b4b), .q3(b3b),
     .q2(b2b), .q1(b1), .q0(b0), .therm_p1(therm[3]));
aibnd_dcc_5b_b2tc_x1 x137 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[28]), .thermb(thermb[28]), .q4(b4), .q3(b3), .q2(b2),
     .q1(b1b), .q0(b0), .therm_p1(therm[29]));
aibnd_dcc_5b_b2tc_x1 x133 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[15]), .thermb(thermb[15]), .q4(b4), .q3(b3b),
     .q2(b2b), .q1(b1b), .q0(b0b), .therm_p1(therm[16]));
aibnd_dcc_5b_b2tc_x1 x132 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[14]), .thermb(thermb[14]), .q4(b4b), .q3(b3),
     .q2(b2), .q1(b1), .q0(b0), .therm_p1(therm[15]));
aibnd_dcc_5b_b2tc_x1 x128 ( .vss_pl(vss_pl), .vcc_pl(vcc_pl),
     .therm(therm[10]), .thermb(thermb[10]), .q4(b4b), .q3(b3),
     .q2(b2b), .q1(b1), .q0(b0), .therm_p1(therm[11]));

endmodule

