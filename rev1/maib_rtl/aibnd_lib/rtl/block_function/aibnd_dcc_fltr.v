// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_fltr, View - schematic
// LAST TIME SAVED: Jan 14 13:07:12 2015
// NETLIST TIME: Jan 20 13:37:51 2015

module aibnd_dcc_fltr ( dcc_done, dir_dncnt, dir_upcnt, init_up,
     scan_out, vcc_pl, vss_pl, clk, clk_coding, dcc_req, full_dn,
     full_up, nrst_coding, rb_dcc_en, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, up );

output  dcc_done, dir_dncnt, dir_upcnt, init_up, scan_out;

inout  vcc_pl, vss_pl;

input  clk, clk_coding, dcc_req, full_dn, full_up, nrst_coding,
     rb_dcc_en, scan_clk_in, scan_in, scan_mode_n, scan_rst_n, up;

wire net040, scan_mode_n, net0112, scan_clk_in, stuck_overflow_mux, stuck_overflow, dither_overflow_mux, dither_overflow, clk_mux, clk, dcc_req_mux, dcc_req, scan_rst_n, net0113, net97, vss_pl, net085, dither_full, stuck_full, net039, dir_flip_up, full_up, full_dn, dir_flip_dn, net0103, dn, up_ff, upbuf, dcc_done, rb_dcc_en, dummy_dcc_done, dir_upcnt, dir_dncnt; // Conversion Sript Generated


assign net040 = scan_mode_n ? net0112 : scan_clk_in;
assign stuck_overflow_mux = scan_mode_n ? stuck_overflow : scan_clk_in;
assign dither_overflow_mux = scan_mode_n ? dither_overflow : scan_clk_in;
assign clk_mux = scan_mode_n ? clk : scan_clk_in;
assign dcc_req_mux = scan_mode_n ? dcc_req : scan_rst_n;
aibnd_dcc_ff x148 ( .so(so10), .se_n(scan_mode_n), .q(dither_full),
     .vcc_pl(vcc_pl), .rb(nrst_coding), .clk(dither_overflow_mux),
     .si(so9), .d(vcc_pl), .vss_pl(vss_pl));
aibnd_dcc_ff x145 ( .so(scan_out), .se_n(scan_mode_n), .q(stuck_full),
     .vcc_pl(vcc_pl), .rb(nrst_coding), .clk(stuck_overflow_mux),
     .si(so11), .d(vcc_pl), .vss_pl(vss_pl));
aibnd_dcc_ff xff0 ( .so(so6), .se_n(scan_mode_n), .si(so5),
     .q(dummy_dcc_done), .vcc_pl(vcc_pl), .rb(dcc_req_mux),
     .clk(clk_mux), .d(dcc_req), .vss_pl(vss_pl));
assign net0112 = !net0113;
aibnd_dcc_3bcnt x3bcnt_stuck ( .overflow_opp(vss_pl), .scan_out(so11),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .scan_in(so10), .ovrflow_check(net095),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .clk_coding(clk_coding),
     .overflow(stuck_overflow), .dir_flip(net093), .clk(clk_coding),
     .dir(net0113), .nrst(nrst_coding));
aibnd_dcc_3bcnt x3bcnt_dither ( .overflow_opp(vss_pl), .scan_out(so9),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .scan_in(so8), .ovrflow_check(net0108),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .clk_coding(clk_coding),
     .overflow(dither_overflow), .dir_flip(net0109), .clk(net040),
     .dir(vcc_pl), .nrst(nrst_coding));
aibnd_dcc_3bcnt x3bcnt_dn ( .overflow_opp(dir_upcnt), .scan_out(so8),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .scan_in(so7), .ovrflow_check(net026),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .clk_coding(clk_coding),
     .overflow(dir_dncnt), .dir_flip(dir_flip_dn), .clk(clk_mux),
     .dir(dn), .nrst(nrst_coding));
aibnd_dcc_3bcnt x3bcnt_up ( .overflow_opp(dir_dncnt), .scan_out(so7),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .scan_in(so6), .ovrflow_check(init_up),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .clk_coding(clk_coding),
     .overflow(dir_upcnt), .dir_flip(dir_flip_up), .clk(clk_mux),
     .dir(upbuf), .nrst(nrst_coding));
assign net97 = !(vss_pl | net085 | dither_full | stuck_full );
assign net039 = !(dir_flip_up | full_up | full_dn | dir_flip_dn );
assign net0103 = !net97;
assign net085 = !net039;
assign dn = !up_ff;
assign upbuf = !dn;
assign dcc_done = rb_dcc_en ? net0103 : dummy_dcc_done;
aibnd_sync_ff xff1 ( .so(so5), .se_n(scan_mode_n), .si(scan_in),
     .q(up_ff), //.vcc_pl(vcc_pl), 
     .rb(nrst_coding), .clk(clk_mux),
     .d(up)); 
     //.vss_pl(vss_pl));
assign net0113 = !(dir_upcnt | dir_dncnt);

endmodule

