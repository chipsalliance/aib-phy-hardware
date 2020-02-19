// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_clkrst, View - schematic
// LAST TIME SAVED: Dec 16 14:07:49 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_dcc_clkrst ( clk_coding, nrst, nrst_coding, scan_out,
     vcc_pl, vss_pl, clk, dcc_dft_nrst, dcc_dft_nrst_coding, dcc_done,
     dcc_req, dll_lock, rb_dcc_dft, rb_dcc_en, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n );

output  clk_coding, nrst, nrst_coding, scan_out;

inout  vcc_pl, vss_pl;

input  clk, dcc_dft_nrst, dcc_dft_nrst_coding, dcc_done, dcc_req,
     dll_lock, rb_dcc_dft, rb_dcc_en, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n;

wire net052, dcc_req, rb_dcc_en, net054, rb_dcc_dft, dcc_dft_nrst_coding, net051, nrst, dcc_dft_nrst, net021, dccen_dccreq, clkdiv_4_mux, scan_mode_n, clkdiv_4, scan_clk_in, dll_lock_mux, dll_lock, nrst_mux, scan_rst_n, clk_mux, clk, clkdiv_2_mux, clkdiv_2, dccen_dccreq_mux, clkdiv_8_mux, clkdiv_8, nrst_coding, clk_coding_mux, clk_coding_premux, net056, clkdiv_16, net050, net037, net026, clk_coding, net036, dcc_done; // Conversion Sript Generated



assign net052 = !(dcc_req & rb_dcc_en);
assign net054 = rb_dcc_dft ? dcc_dft_nrst_coding : net051;
assign nrst = rb_dcc_dft ? dcc_dft_nrst : net021;
assign dccen_dccreq = !net052;
assign clkdiv_4_mux = scan_mode_n ? clkdiv_4 : scan_clk_in;
assign dll_lock_mux = scan_mode_n ? dll_lock : scan_clk_in;
assign nrst_mux = scan_mode_n ? nrst : scan_rst_n;
assign clk_mux = scan_mode_n ? clk : scan_clk_in;
assign clkdiv_2_mux = scan_mode_n ? clkdiv_2 : scan_clk_in;
assign dccen_dccreq_mux = scan_mode_n ? dccen_dccreq : scan_rst_n;
assign clkdiv_8_mux = scan_mode_n ? clkdiv_8 : scan_clk_in;
assign nrst_coding = scan_mode_n ? net054 : scan_rst_n;
assign clk_coding_mux = scan_mode_n ? clk_coding_premux : scan_clk_in;
assign net056 = !clkdiv_16;
assign net050 = !clkdiv_8;
assign net037 = !clkdiv_2;
assign net026 = !clkdiv_4;
assign clk_coding = clk_coding_mux;
assign net036 = !(dcc_req & dll_lock & rb_dcc_en);
assign net021 = !(net036 | dcc_done);
aibnd_dcc_ff xreg0 ( .so(so1), .se_n(scan_mode_n), .si(so0),
     .q(clkdiv_2), .vcc_pl(vcc_pl), .rb(nrst_mux), .clk(clk_mux),
     .d(net037), .vss_pl(vss_pl));
aibnd_dcc_ff xreg2 ( .so(so3), .se_n(scan_mode_n), .si(so2),
     .q(clkdiv_8), .vcc_pl(vcc_pl), .rb(nrst_mux), .clk(clkdiv_4_mux),
     .d(net050), .vss_pl(vss_pl));
aibnd_dcc_ff xreg3 ( .so(so4), .se_n(scan_mode_n), .si(so3),
     .q(clkdiv_16), .vcc_pl(vcc_pl), .rb(nrst_mux), .clk(clkdiv_8_mux),
     .d(net056), .vss_pl(vss_pl));
aibnd_dcc_ff xreg4 ( .so(scan_out), .se_n(scan_mode_n), .si(so4),
     .q(clk_coding_premux), .vcc_pl(vcc_pl), .rb(nrst_mux),
     .clk(clk_mux), .d(clkdiv_16), .vss_pl(vss_pl));
aibnd_dcc_ff x134 ( .so(so0), .se_n(scan_mode_n), .si(scan_in),
     .q(net051), .vcc_pl(vcc_pl), .rb(dccen_dccreq_mux),
     .clk(dll_lock_mux), .d(vcc_pl), .vss_pl(vss_pl));
aibnd_dcc_ff xreg1 ( .so(so2), .se_n(scan_mode_n), .si(so1),
     .q(clkdiv_4), .vcc_pl(vcc_pl), .rb(nrst_mux), .clk(clkdiv_2_mux),
     .d(net026), .vss_pl(vss_pl));

endmodule

