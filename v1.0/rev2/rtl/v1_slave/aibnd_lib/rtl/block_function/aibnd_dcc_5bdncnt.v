// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_5bdncnt, View - schematic
// LAST TIME SAVED: Dec 16 14:18:22 2014
// NETLIST TIME: Dec 17 10:24:04 2014

module aibnd_dcc_5bdncnt ( full, q0, q1, q2, q3, q4, scan_out, vcc_pl,
     vss_pl, clk, dir, hold_state, nrst, scan_clk_in, scan_in,
     scan_mode_n );

output  full, q0, q1, q2, q3, q4, scan_out;

inout  vcc_pl, vss_pl;

input  clk, dir, hold_state, nrst, scan_clk_in, scan_in, scan_mode_n;

wire net095, net048, net035, net041, q2b, net016, net089, q0, net0102, full, net069, net040, net045, q4, net036, net047, net090, net039, net042, net076, q1b, q0b, net078, net031, net085, net058, net057, net038, net034, net092, net063, net049, q1, net021, q3b, q4b, net084, net032, net068, net096, net097, net064, net075, net098, net079, net037, net056, dir, clk, hld, holdb, net087, net081, net059, net017, hold_state, ck, net072, q3, q2, ck_mux, scan_mode_n, scan_clk_in, net061, net060, net018, net099, net091; // Conversion Sript Generated



assign net095 = !(net048 | net035);
assign net041 = !(q2b | net016);
assign net089 = !(q0 | net0102);
assign full = !(net069 | net040);
assign net045 = !(q4 & net036);
assign net047 = !(q4 & net045);
assign net090 = !(net039 & net042);
assign net076 = !(q1b & q0b);
assign net040 = !(q1b & q0b);
assign net078 = !(net031 & net085);
assign net058 = !(q1b & q0b);
assign net057 = !(net078 & net038);
assign net034 = !(q1b & q0b);
assign net092 = !(net063 & net049);
assign net063 = !(q1 & q0);
assign net021 = !(q3b & q4b);
assign net084 = !net047;
assign net036 = !net032;
assign net0102 = !net068;
assign net042 = !net095;
assign net085 = !net058;
assign net031 = !net096;
assign net016 = !net076;
assign net097 = !net064;
assign net039 = !net041;
assign net035 = !net021;
assign net064 = !(q4b & q3b & q2b);
assign net075 = !(q2b & q1b & q0b);
assign net069 = !(q4b & q3b & q2b);
assign net048 = !(q2b & q1b & q0b);
assign net096 = !(q4 & q3b & q2b);
assign net098 = !(net034 | net097);
assign net079 = !(q3b | net037);
assign net032 = !(q3b & q2b & q1b & q1b);
assign net068 = !(q4b & q3b & q2b & q2b);
assign net056 = !(dir & clk);
assign hld = !(dir & holdb);
assign q0b = !net087;
assign q4b = !net081;
assign net049 = !net098;
assign net038 = !net079;
assign net037 = !net075;
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
assign ck_mux = scan_mode_n ? ck : scan_clk_in;
assign net061 = hld ? q4 : net084;
assign net060 = hld ? q3 : net057;
assign net018 = hld ? q0 : net089;
assign net099 = hld ? q1 : net092;
assign net091 = hld ? q2 : net090;
aibnd_dcc_ff_pst x102 ( .se_n(scan_mode_n), .so(so3), .si(so2),
     .q(net059), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net060),
     .vss_pl(vss_pl));
aibnd_dcc_ff_pst x103 ( .se_n(scan_mode_n), .so(scan_out), .si(so3),
     .q(net081), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net061),
     .vss_pl(vss_pl));
aibnd_dcc_ff_pst xreg2 ( .se_n(scan_mode_n), .so(so2), .si(so1),
     .q(net017), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net091),
     .vss_pl(vss_pl));
aibnd_dcc_ff_pst xreg0 ( .se_n(scan_mode_n), .so(so0), .si(scan_in),
     .q(net087), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net018),
     .vss_pl(vss_pl));
aibnd_dcc_ff_pst xreg1 ( .se_n(scan_mode_n), .so(so1), .si(so0),
     .q(net072), .vcc_pl(vcc_pl), .rb(nrst), .clk(ck_mux), .d(net099),
     .vss_pl(vss_pl));

endmodule

