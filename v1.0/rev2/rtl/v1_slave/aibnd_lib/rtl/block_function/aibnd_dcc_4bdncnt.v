// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_4bdncnt, View - schematic
// LAST TIME SAVED: Oct 27 19:03:25 2014
// NETLIST TIME: Oct 29 14:53:12 2014

module aibnd_dcc_4bdncnt ( full, q0, q1, q2, q3, vcc_pl, vss_pl, clk,
     dir, hold, nrst );

output  full, q0, q1, q2, q3;

inout  vcc_pl, vss_pl;

input  clk, dir, hold, nrst;

wire net066, q1, q0b, net035, q3, q0, net071, net042, q2, net063, net070, net039, net057, net034, q1b, net036, net092, net089, net065, net064, net090, net040, net062, q3b, q2b, ck, dir, clk, hld, holdb, net087, net059, net017, full, hold, net072, net060, net018, net099, net091; // Conversion Sript Generated


assign net066 = !(q1 & q0b);
assign net035 = !(q3 & q0);
assign net071 = !(q3 & q1);
assign net042 = !(q2 & q0);
assign net063 = !(q1 & q0);
assign net070 = !(q3 & q2);
assign net039 = !(q2 & q1);
assign net057 = !(net070 & net035 & net071);
assign net034 = !(q2 & q1b & q0b);
assign net036 = !(q3 & q1b & q0b);
assign net092 = !(net063 & net034 & net036);
assign net089 = !(net066 & net065 & net064);
assign net064 = !(q3 & q1b & q0b);
assign net090 = !(net042 & net039 & net040);
assign net065 = !(q2 & q1b & q0b);
aibnd_dcc_ff_pst x104 ( .q(net017), .vcc_pl(vcc_pl), .rb(nrst),
     .clk(ck), .d(net091), .vss_pl(vss_pl));
aibnd_dcc_ff_pst x106 ( .q(net087), .vcc_pl(vcc_pl), .rb(nrst),
     .clk(ck), .d(net018), .vss_pl(vss_pl));
aibnd_dcc_ff_pst x105 ( .q(net072), .vcc_pl(vcc_pl), .rb(nrst),
     .clk(ck), .d(net099), .vss_pl(vss_pl));
aibnd_dcc_ff_pst x103 ( .q(net059), .vcc_pl(vcc_pl), .rb(nrst),
     .clk(ck), .d(net060), .vss_pl(vss_pl));
assign net062 = !(q3b & q2b & q1b & q1b);
assign net040 = !(q3 & q2b & q1b & q1b);
assign ck = !(dir & clk);
assign hld = !(dir & holdb);
assign q0b = !net087;
assign q3b = !net059;
assign q2b = !net017;
assign full = !net062;
assign holdb = !hold;
assign q1b = !net072;
assign q3 = !q3b;
assign q2 = !q2b;
assign q0 = !q0b;
assign q1 = !q1b;
assign net060 = hld ? q3 : net057;
assign net018 = hld ? q0 : net089;
assign net099 = hld ? q1 : net092;
assign net091 = hld ? q2 : net090;

endmodule

