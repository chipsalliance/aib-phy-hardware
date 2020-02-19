// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_osc_divby8, View - schematic
// LAST TIME SAVED: Mar 13 07:30:56 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_divby8 ( out_divby2, out_divby4, out_divby8,
     scan_out, vcc_aibcr3aux, vss_aibcr3aux, clkin, por, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n );

output  out_divby2, out_divby4, out_divby8, scan_out;

inout  vcc_aibcr3aux, vss_aibcr3aux;

input  clkin, por, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire out_divby2, net119, net114, out_divby4, net118, net113, net117, net120, out_divby8;

wire so0;
wire so1;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_osc_divby8";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign out_divby2 = ~net119;
assign net119 = ~net114;
assign out_divby4 = ~net118;
assign net118 = ~net113;
assign net117 = ~net120;
assign out_divby8 = ~net117;
aibcr3aux_osc_div2_asyn_clr xdiv8_1 ( .scan_shift_n(scan_shift_n),
     .scan_clk(scan_clk), .scan_out(so0), .scan_in(scan_in),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcr3aux), .vcc_aibcraux(vcc_aibcr3aux),
     .clkout(net114), .irstb(por), .clkin(clkin));
aibcr3aux_osc_div2_asyn_clr xdiv8_2 ( .scan_shift_n(scan_shift_n),
     .scan_clk(scan_clk), .scan_out(so1), .scan_in(so0),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcr3aux), .vcc_aibcraux(vcc_aibcr3aux),
     .clkout(net113), .irstb(por), .clkin(net114));
aibcr3aux_osc_div2_asyn_clr xdiv8_3 ( .scan_shift_n(scan_shift_n),
     .scan_clk(scan_clk), .scan_out(scan_out), .scan_in(so1),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcr3aux), .vcc_aibcraux(vcc_aibcr3aux),
     .clkout(net120), .irstb(por), .clkin(net113));

endmodule

