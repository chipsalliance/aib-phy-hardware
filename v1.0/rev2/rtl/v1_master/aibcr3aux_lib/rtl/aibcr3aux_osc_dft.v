// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_dft, View - schematic
// LAST TIME SAVED: Apr 30 15:17:02 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_dft ( osc2dft_out, scan_out, testpin_cntr_code,
     vcc_aibcraux, vss_aibcraux, counter, osc_clkin, scan_clk, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n, testpin_clk,
     testpin_enable, testpin_resetb );

output  scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  osc_clkin, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n, testpin_clk, testpin_enable, testpin_resetb;

output [5:0]  testpin_cntr_code;
output [8:6]  osc2dft_out;

input [2:0]  counter;

wire net167, net165, so3, vss_aibcraux, net050, scanmoden, scanrstn, net033, dff_clk, scanclk, net038, sync_in, net092, net162, net093, scanin, scan_in, scan_clk, scan_rst_n, scan_mode_n, testpin_resetb, testpin_clk, enable, resetb, scanshftn, scanshft, scan_shift_n;

wire so6;
wire so5;
wire so4;

// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_dft";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_osc_6bcntr x6bcntr ( .scan_shift_n(scanshftn),
     .scan_out(scan_out), .scan_clk(scanclk), .scan_in(so6),
     .scan_mode_n(scanmoden), .scan_rst_n(scanrstn),
     .vss_aibcraux(vss_aibcraux), .vcc_aibcraux(vcc_aibcraux),
     .out_bin(testpin_cntr_code[5:0]), .clk(osc_clkin),
     .cntr(counter[2:0]), .en(enable), .reset_n(resetb));
assign net167 = net165 ? vss_aibcraux : so3;
assign net050 = scanmoden ? net033 : scanrstn;
assign dff_clk = scanmoden ? net038 : scanclk;
assign sync_in = scanmoden ? net092 : scanclk;
assign net162 = scanmoden ? net093 : scanrstn;
assign scanin = scan_in;
assign scanclk = scan_clk;
assign scanrstn = scan_rst_n;
assign scanmoden = scan_mode_n;
assign net033 = testpin_resetb;
assign net038 = testpin_clk;
assign osc2dft_out[6] = enable;
assign osc2dft_out[8] = sync_in;
assign osc2dft_out[7] = resetb;
aibcr3aux_osc_sync xsync ( .scan_shift_n(scanshftn), .scan_out(so6),
     .scan_clk(scanclk), .scan_in(so5), .scan_mode_n(scanmoden),
     .scan_rst_n(scanrstn), .vss_aibcraux(vss_aibcraux),
     .vcc_aibcraux(vcc_aibcraux), .en_out(enable), .resetb_out(resetb),
     .clk(osc_clkin), .d(sync_in), .resetb(net162));
aibcr3aux_osc_ff x23 ( .cdn(net162), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(net092), .so(so4), .cp(dff_clk), .d(net167), .se_n(scanshftn),
     .si(so3));
aibcr3aux_osc_ff x22 ( .cdn(net162), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(net165), .so(so5), .cp(sync_in), .d(vcc_aibcraux),
     .se_n(scanshftn), .si(so4));
aibcr3_sync_2ff  xsync0 (      .SE(scanshft), .D(vcc_aibcraux),  .Q(net093),     .CP(dff_clk),  .SI(scanin), .CDN(net050));
aibcr3_sync_2ff  x27 (  .SE(scanshft),     .D(testpin_enable),  .Q(so3), .CP(dff_clk),      .SI(net093), .CDN(net162));
assign scanshftn = ~scanshft;
assign scanshft = ~scan_shift_n;

endmodule

