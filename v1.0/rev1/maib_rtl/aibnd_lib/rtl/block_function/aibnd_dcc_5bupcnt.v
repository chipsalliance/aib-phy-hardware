// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_5bupcnt, View - schematic
// LAST TIME SAVED: Dec 16 14:20:54 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_dcc_5bupcnt ( full, q0, q1, q2, q3, q4, scan_out, vcc_pl,
     vss_pl, clk, dir, hold_state, nrst, scan_clk_in, scan_in,
     scan_mode_n );

output  full, q0, q1, q2, q3, q4, scan_out;

inout  vcc_pl, vss_pl;

input  clk, dir, hold_state, nrst, scan_clk_in, scan_in, scan_mode_n;

wire net041, q2b, net016, full, net069, net040, net090, net039, net048, net024, q4, q3, net043, net078, q3b, net038, net020, q1, q0, net084, q4b, net032, net057, net034, q0b, net089, net068, net063, q1b, net031, net037, net076, q2, net092, net036, ck_mux, scan_mode_n, ck, scan_clk_in, net056, dir, clk, hld, holdb, net087, net081, net059, net017, hold_state, net072, net061, net060, net018, net099, net091; // Conversion Sript Generated



assign net041 = !(q2b | net016);
assign full = !(net069 | net040);
assign net090 = !(net039 & net048);
assign net024 = !(q4 & q3);
assign net043 = !(net078 & q3b);
assign net038 = !(q3 & net020);
assign net040 = !(q1 & q0);
assign net084 = !(q4b & net032);
assign net057 = !(net043 & net038);
assign net034 = !(q1 & q0b);
assign net089 = !(q0 & net068);
assign net063 = !(q1b & q0);
assign net031 = !net057;
assign net020 = !net037;
assign net016 = !net076;
assign net039 = !net041;
assign net069 = !(q4 & q3 & q2);
assign net092 = !(net063 & net034 & net036);
assign net076 = !(net024 & q1 & q0);
assign net048 = !(q2b & q1 & q0);
assign ck_mux = scan_mode_n ? ck : scan_clk_in;
assign net032 = !(q3 & q2 & q1 & q1);
assign net037 = !(q4b & q2 & q1 & q1);
assign net036 = !(q4 & q3 & q2 & q2);
assign net078 = !(q3b & q2 & q1 & q1);
assign net068 = !(q4 & q3 & q2 & q2);
assign net056 = !(dir & clk);
assign hld = !(dir & holdb);
assign q0b = !net087;
assign q4b = !net081;
assign q3b = !net059;
assign q2b = !net017;
assign holdb = !hold_state;
assign ck = !net056;
assign q1b = !net072;
assign q4 = !q4b;
assign q3 = !q3b;
assign q2 = !q2b;
assign q0 = !q0b;
assign q1 = !q1b;
aibnd_dcc_ff x102 ( .so(so3), .se_n(scan_mode_n), .si(so2), .q(net059),
     .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net060),
     .vss_pl(vss_pl));
aibnd_dcc_ff x103 ( .so(scan_out), .se_n(scan_mode_n), .si(so3),
     .q(net081), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net061),
     .vss_pl(vss_pl));
aibnd_dcc_ff xreg2 ( .so(so2), .se_n(scan_mode_n), .si(so1),
     .q(net017), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net091),
     .vss_pl(vss_pl));
aibnd_dcc_ff xreg0 ( .so(so0), .se_n(scan_mode_n), .si(scan_in),
     .q(net087), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net018),
     .vss_pl(vss_pl));
aibnd_dcc_ff xreg1 ( .so(so1), .se_n(scan_mode_n), .si(so0),
     .q(net072), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net099),
     .vss_pl(vss_pl));
assign net061 = hld ? q4 : net084;
assign net060 = hld ? q3 : net031;
assign net018 = hld ? q0 : net089;
assign net099 = hld ? q1 : net092;
assign net091 = hld ? q2 : net090;

endmodule

