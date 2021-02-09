// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_osc_monitor, View -
//schematic
// LAST TIME SAVED: Mar 13 07:35:17 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_monitor ( out_divby16, out_divby32, out_divby64,
     scan_out, vcc_aibcr3aux, vss_aibcr3aux, clkin, por, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n );

output  out_divby16, out_divby32, out_divby64, scan_out;

inout  vcc_aibcr3aux, vss_aibcr3aux;

input  clkin, por, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire s0;
wire net30;
wire net31;
wire divby8;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_osc_monitor";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_osc_divby8 xdiv8_1 ( .scan_shift_n(scan_shift_n),
     .scan_out(s0), .scan_clk(scan_clk), .scan_in(scan_in),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcr3aux(vss_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out_divby2(net30), .out_divby4(net31), .out_divby8(divby8),
     .clkin(clkin), .por(por));
aibcr3aux_osc_divby8 xdiv8_2 ( .scan_shift_n(scan_shift_n),
     .scan_out(scan_out), .scan_clk(scan_clk), .scan_in(s0),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcr3aux(vss_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out_divby2(out_divby16), .out_divby4(out_divby32),
     .out_divby8(out_divby64), .clkin(divby8), .por(por));

endmodule

