// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_4b_b2tc, View - schematic
// LAST TIME SAVED: Oct 28 09:54:35 2014
// NETLIST TIME: Oct 29 14:53:12 2014

module aibnd_dcc_4b_b2tc ( therm, thermb, vcc_pl, vss_pl, q0, q1, q2,
     q3, rb_dcc_manual, rb_dcc_manual_mode );


inout  vcc_pl, vss_pl;

input  q0, q1, q2, q3, rb_dcc_manual_mode;

output [14:0]  thermb;
output [14:0]  therm;

input [3:0]  rb_dcc_manual;

wire b0b, b1b, b2b, b3b, net045, net046, net057, net058, net088, net089, b3, rb_dcc_manual_mode, q3, b1, q1, b0, q0, b2, q2, net086, net066, net087, net067, net072, net042, net075; // Conversion Sript Generated


assign therm[14] = !(b0b | b1b | b2b | b3b );
assign therm[3] = !(b2b & b3b);
assign therm[5] = !(net045 & b3b);
assign therm[6] = !(net046 & b3b);
assign therm[12] = !(net057 & net058);
assign therm[10] = !(net088 & net089);
assign b3 = rb_dcc_manual_mode ? rb_dcc_manual[3] : q3;
assign b1 = rb_dcc_manual_mode ? rb_dcc_manual[1] : q1;
assign b0 = rb_dcc_manual_mode ? rb_dcc_manual[0] : q0;
assign b2 = rb_dcc_manual_mode ? rb_dcc_manual[2] : q2;
assign b3b = !b3;
assign therm[7] = !thermb[7];
assign thermb[7] = !b3;
assign thermb[8] = !therm[8];
assign thermb[9] = !therm[9];
assign b0b = !b0;
assign b1b = !b1;
assign thermb[10] = !therm[10];
assign b2b = !b2;
assign thermb[0] = !therm[0];
assign thermb[1] = !therm[1];
assign thermb[2] = !therm[2];
assign thermb[3] = !therm[3];
assign thermb[4] = !therm[4];
assign thermb[5] = !therm[5];
assign thermb[6] = !therm[6];
assign net086 = !net066;
assign thermb[11] = !therm[11];
assign thermb[12] = !therm[12];
assign net087 = !net067;
assign thermb[13] = !therm[13];
assign thermb[14] = !therm[14];
assign therm[0] = !(b0b & b1b & b2b & b2b);
assign net089 = !(b2 & b3);
assign net045 = !(b1 & b2);
assign net072 = !(b0 & b1);
assign net042 = !(b1 & b2);
assign net075 = !(b0 & b2);
assign net067 = !(b1b & b2b);
assign therm[1] = !(b1b & b2b & b3b);
assign net057 = !(b0 & b2 & b3);
assign net066 = !(b0b & b1b & b2b);
assign net046 = !(b0 & b1 & b2);
assign therm[2] = !(net072 & b2b & b3b);
assign therm[4] = !(net075 & net042 & b3b);
assign net088 = !(b0 & b1 & b3);
assign net058 = !(b1 & b2 & b3);
assign therm[8] = !(net086 | b3b);
assign therm[9] = !(net087 | b3b);
assign therm[11] = !(b2b | b3b);
assign therm[13] = !(b1b | b2b | b3b);

endmodule

