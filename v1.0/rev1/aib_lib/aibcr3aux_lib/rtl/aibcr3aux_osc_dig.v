// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_osc_dig, View - schematic
// LAST TIME SAVED: May 19 07:42:34 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_dig ( oaib_dft2osc, oosc_clkout, oosc_monitor,
     scan_out, chicken_bit, comp_in, iaib_dft2osc, iosc_bypclk,
     iosc_bypclken, iosc_cr_dftcounter, iosc_cr_ld_cntr,
     iosc_monitoren, irstb, oscin_2x, pipeline_global_en, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n, vcc_aibcr3aux,
     vss_aibcr3aux );

output  oosc_clkout, oosc_monitor, scan_out;

input  chicken_bit, comp_in, iosc_bypclk, iosc_bypclken,
     iosc_monitoren, irstb, oscin_2x, pipeline_global_en, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n, vcc_aibcr3aux,
     vss_aibcr3aux;

output [12:0]  oaib_dft2osc;

input [2:0]  iosc_cr_dftcounter;
input [2:0]  iosc_cr_ld_cntr;
input [2:0]  iaib_dft2osc;

wire test_clk, net089, bypass_clk, net092, net091, net090, net136, net137, clkgateout, iosc_monitoren, scanclk, scan_clk, oosc_clkout, clkmux_out, oosc_monitor, mon_out, scanmoden, scan_mode_n, scanrstn, scan_rst_n, scanin, scan_in, scanshftn, scan_shift_n, net046, syncrstb_dly, net060, net0100, vss_aibcr3aux, testpin_en, resetb, net099, iosc_bypclk, chicken_bit, irstb, syncrstb, net032;

// Buses in the design

wire  [5:0]  cntr_code;

wire so0;
wire divout;
wire so3;
wire so2;
wire so1;
wire clkout_buf;
wire net140;
wire net139;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_osc_dig";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign test_clk = ~net089;
assign bypass_clk = ~net092;
assign net091 = ~net090;
assign net136 = ~net137;
assign net137 = ~(clkgateout & iosc_monitoren);
aibcr3aux_osc_div2_syn_clr xdiv2sync ( .scan_shift_n(scanshftn),
     .scan_out(so0), .scan_clk(scanclk), .scan_in(scanin),
     .scan_mode_n(scanmoden), .scan_rst_n(scanrstn),
     .vss_aibcraux(vss_aibcr3aux), .vcc_aibcraux(vcc_aibcr3aux),
     .syncrstb(syncrstb), .clkout(divout), .irstb(resetb),
     .clkin(oscin_2x));
aibcr3aux_osc_clkmux xclkmux ( .vss_aibcraux(vss_aibcr3aux),
     .vcc_aibcraux(vcc_aibcr3aux), .ina(clkgateout),
     .sel(iosc_bypclken), .out(clkmux_out), .inb(bypass_clk));
aibcr3aux_osc_dft xdft ( .scan_shift_n(scanshftn), .scan_out(scan_out),
     .scan_clk(scanclk), .scan_rst_n(scanrstn),
     .scan_mode_n(scanmoden), .scan_in(so3),
     .osc2dft_out(oaib_dft2osc[8:6]), .vss_aibcraux(vss_aibcr3aux),
     .vcc_aibcraux(vcc_aibcr3aux), .testpin_cntr_code(cntr_code[5:0]),
     .counter(iosc_cr_dftcounter[2:0]), .osc_clkin(clkmux_out),
     .testpin_clk(test_clk), .testpin_enable(testpin_en),
     .testpin_resetb(iaib_dft2osc[2]));
assign scanclk = scan_clk;
assign oosc_clkout = clkmux_out;
assign oosc_monitor = mon_out;
assign scanmoden = scan_mode_n;
assign oaib_dft2osc[5:0] = cntr_code[5:0];
assign scanrstn = scan_rst_n;
assign scanin = scan_in;
assign scanshftn = scan_shift_n;
aibcr3aux_osc_clkgatesync xclkgatesync ( .scan_shift_n(scanshftn),
     .scan_rst_n(scanrstn), .scan_out(so2), .scan_clk(scanclk),
     .clkgatesyncout(clkgateout), .scan_in(so1),
     .vss_aibcraux(vss_aibcr3aux), .vcc_aibcraux(vcc_aibcr3aux),
     .scan_mode_n(scanmoden), .ckin(clkout_buf), .en(syncrstb),
     .rstb(syncrstb_dly));
aibcr3aux_osc_monitor xmonitor ( .scan_shift_n(scanshftn),
     .scan_out(so3), .scan_clk(scanclk), .scan_in(so2),
     .scan_mode_n(scanmoden), .scan_rst_n(scanrstn),
     .vss_aibcr3aux(vss_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out_divby16(mon_out), .out_divby32(net140), .out_divby64(net139),
     .clkin(net136), .por(syncrstb_dly));
assign net046 = ~(syncrstb_dly & net060);
assign net0100 = ~vss_aibcr3aux;
assign net092 = ~net091;
assign oaib_dft2osc[12] = testpin_en;
aibcr3aux_osc_dly xdly ( .rstb(syncrstb), .clkout(clkout_buf),
     .vss_aibcr3aux(vss_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .q(syncrstb_dly), .scan_out(so1), .clk(divout),
     .scan_clk(scanclk), .scan_in(so0), .scan_mode_n(scanmoden),
     .scan_rst_n(scanrstn), .scan_shift_n(scanshftn));
assign net089 = ~iaib_dft2osc[0];
assign resetb = ~net099;
assign testpin_en = ~net046;
assign net090 = ~iosc_bypclk;
assign net032 = 1'b0;
assign net099 = ~(net032 | irstb);
assign oaib_dft2osc[10] = syncrstb;
assign oaib_dft2osc[11] = iaib_dft2osc[2];
assign oaib_dft2osc[9] = resetb;
assign net060 = iaib_dft2osc[1];

endmodule

