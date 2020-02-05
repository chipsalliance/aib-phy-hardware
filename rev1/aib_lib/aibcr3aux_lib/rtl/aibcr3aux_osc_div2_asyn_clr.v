// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_osc_div2_asyn_clr, View -
//schematic
// LAST TIME SAVED: Mar 13 09:05:23 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_div2_asyn_clr ( clkout, scan_out, vcc_aibcraux,
     vss_aibcraux, clkin, irstb, scan_clk, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n );

output  clkout, scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  clkin, irstb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire net26, clkout, dff_clk, scan_modn, net019, clkin, dff_rstb, scan_rstn, irstb, scanshftn, scan_shift_n, scan_clk, scan_mode_n, scan_rst_n;


// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_osc_div2_asyn_clr";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net26 = ~clkout;
aibcr3aux_osc_ff x0 ( .cdn(dff_rstb), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(clkout), .so(scan_out), .cp(dff_clk), .d(net26),
     .se_n(scanshftn), .si(scan_in));
assign dff_clk = scan_modn ? clkin : net019;
assign dff_rstb = scan_modn ? irstb : scan_rstn;
assign scanshftn = scan_shift_n;
assign net019 = scan_clk;
assign scan_modn = scan_mode_n;
assign scan_rstn = scan_rst_n;

endmodule

