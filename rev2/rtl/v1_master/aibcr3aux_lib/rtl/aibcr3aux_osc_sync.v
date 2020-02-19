// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_sync, View - schematic
// LAST TIME SAVED: Apr 30 15:28:05 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_sync ( en_out, resetb_out, scan_out, vcc_aibcraux,
     vss_aibcraux, clk, d, resetb, scan_clk, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n );

output  en_out, resetb_out, scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  clk, d, resetb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire scanmoden, scan_mode_n, scanrstn, scan_rst_n, scanclk, scan_clk, scanin, scan_in, scanshftn, scan_shift_n, resetb_out, net062, dff_clk, net036, net044, resetb, clk;

wire so0;
wire scanshft;

// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_sync";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign scanmoden = scan_mode_n;
assign scanrstn = scan_rst_n;
assign scanclk = scan_clk;
assign scanin = scan_in;
assign scanshftn = scan_shift_n;
assign scanshft = ~scan_shift_n;
assign resetb_out = scanmoden ? net062 : scanrstn;
assign dff_clk = scanmoden ? net036 : scanclk;
/*aibcr3aux_osc_ff xreset_sync ( .cdn(net044), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(net062), .so(so0), .cp(dff_clk), .d(vcc_aibcraux),
     .se_n(scanshftn), .si(scanin));*/
assign net044 = scanmoden ? resetb : scanrstn;
/*aibcr3aux_osc_sync_ff x7 (  
     .CDN(resetb_out), .CP(dff_clk), .D(d), .Q(en_out),
       .so(scan_out),
     .se_n(scanshftn), .si(so0));*/
aibcr3_ulvt16_2xarstsyncdff1_b2 x99(.CLR_N(resetb_out), .CK(dff_clk), .D(d), .Q(en_out), .SE(scanshft), .SI(so0));
assign scan_out = en_out;
// reset synchronizer
aibcr3_ulvt16_2xarstsyncdff1_b2 x31(.CLR_N(net044),.CK(dff_clk), .D(vcc_aibcraux), .Q(net062), .SE(scanshft), .SI(scanin));
assign so0 = net062;


assign net036 = ~clk;

endmodule

