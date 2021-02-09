// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_clkgatesync, View -
//schematic
// LAST TIME SAVED: Mar 13 07:23:51 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_clkgatesync ( clkgatesyncout, scan_out,
     vcc_aibcraux, vss_aibcraux, ckin, en, rstb, scan_clk, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n );

output  clkgatesyncout, scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  ckin, en, rstb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire net023, ckin, clkgatesyncout, net027, net024, scanshft, scan_shift_n, scan_modn, scan_rstn, scan_out, dff_rstb, rstb, dff_clk, scan_ck, scan_mode_n, scan_clk, scan_rst_n;


// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_clkgatesync";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net023 = ~ckin;
assign clkgatesyncout = ~net027;
assign net027 = ~(net024 & ckin);
assign scanshft = ~scan_shift_n;
assign net024 = scan_modn ? scan_out : scan_rstn;
assign dff_rstb = scan_modn ? rstb : scan_rstn;
assign dff_clk = scan_modn ? net023 : scan_ck;
aibcr3_sync_2ff  xsync0 (      .SE(scanshft), .D(en),  .Q(scan_out),     .CP(dff_clk),  .SI(scan_in), .CDN(dff_rstb));
assign scan_modn = scan_mode_n;
assign scan_ck = scan_clk;
assign scan_rstn = scan_rst_n;

endmodule

