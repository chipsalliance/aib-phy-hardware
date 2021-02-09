// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_4bupcnt, View - schematic
// LAST TIME SAVED: Oct 27 16:24:12 2014
// NETLIST TIME: Oct 29 14:53:12 2014

module aibnd_dcc_4bupcnt ( full, q0, q1, q2, q3, vcc_pl, vss_pl, clk,
     dir, hold, nrst );

output  full, q0, q1, q2, q3;

inout  vcc_pl, vss_pl;

input  clk, dir, hold, nrst;

wire net066, q1b, q0b, net057, q3b, net038, net034, q1, net042, q3, q2, net063, q0, net040, net039, net065, net036, net092, net089, net064, net048, q2b, net090, net062, ck, dir, clk, hld, holdb, net087, net059, net017, full, hold, net072, net060, net018, net099, net091; // Conversion Sript Generated

assign net066 = !(q1b & q0b);
assign net057 = !(q3b & net038);
assign net034 = !(q1 & q0b);
assign net042 = !(q3 & q2);
assign net063 = !(q1b & q0);
assign net040 = !(q2 & q0b);
assign net039 = !(q2 & q1b);
assign net065 = !(q1 & q0b);
assign net038 = !(q2 & q1 & q0);
assign net036 = !(q3 & q2 & q1);
assign net092 = !(net063 & net034 & net036);
assign net089 = !(net066 & net065 & net064);
assign net064 = !(q3 & q2 & q1);
assign net048 = !(q2b & q1 & q0);
assign net090 = !(net042 & net039 & net040 & net040);
assign net062 = !(q3 & q2 & q1 & q1);
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
aibnd_dcc_ff x102 ( .q(net059), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck),
     .d(net060), .vss_pl(vss_pl));
aibnd_dcc_ff xreg2 ( .q(net017), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck),
     .d(net091), .vss_pl(vss_pl));
aibnd_dcc_ff xreg0 ( .q(net087), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck),
     .d(net018), .vss_pl(vss_pl));
aibnd_dcc_ff xreg1 ( .q(net072), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck),
     .d(net099), .vss_pl(vss_pl));
assign net060 = hld ? q3 : net057;
assign net018 = hld ? q0 : net089;
assign net099 = hld ? q1 : net092;
assign net091 = hld ? q2 : net090;

endmodule

