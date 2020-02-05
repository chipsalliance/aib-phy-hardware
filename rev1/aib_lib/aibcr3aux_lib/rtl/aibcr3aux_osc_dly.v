// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_osc_dly, View - schematic
// LAST TIME SAVED: Mar 19 12:31:17 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_dly ( clkout, q, scan_out, clk, rstb, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n, vcc_aibcr3aux,
     vss_aibcr3aux );

output  clkout, q, scan_out;

input  clk, rstb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n, vcc_aibcr3aux, vss_aibcr3aux;

wire net060, scan_rst_n, net059, rstb, net28, scan_clk, se_n, scan_shift_n, scanmodn, scan_mode_n, cdn, net30, net27, clk, cp, clkout;

wire net45;
wire net46;
wire net32;
wire net31;
wire net34;
wire net33;
wire net35;
wire net36;
wire net42;
wire net41;
wire net44;
wire net43;
wire net39;
wire net40;
wire net38;
wire net37;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_osc_dly";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_osc_ff x12 ( .cdn(vss_aibcr3aux), .vbb(vss_aibcr3aux),
     .vss(vss_aibcr3aux), .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux),
     .q(net45), .so(net46), .cp(vss_aibcr3aux), .d(vss_aibcr3aux),
     .se_n(vss_aibcr3aux), .si(vss_aibcr3aux));
aibcr3aux_osc_ff x11 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(q), .so(scan_out),
     .cdn(cdn), .cp(cp), .d(net32), .se_n(se_n), .si(net31));
aibcr3aux_osc_dly_unit x10 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net32), .so(net31),
     .cdn(cdn), .cp(cp), .d(net34), .se_n(se_n), .si(net33));
aibcr3aux_osc_dly_unit x9 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net34), .so(net33),
     .cdn(cdn), .cp(cp), .d(net35), .se_n(se_n), .si(net36));
aibcr3aux_osc_dly_unit x5 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net42), .so(net41),
     .cdn(cdn), .cp(cp), .d(net44), .se_n(se_n), .si(net43));
aibcr3aux_osc_dly_unit x6 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net39), .so(net40),
     .cdn(cdn), .cp(cp), .d(net42), .se_n(se_n), .si(net41));
aibcr3aux_osc_dly_unit x7 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net38), .so(net37),
     .cdn(cdn), .cp(cp), .d(net39), .se_n(se_n), .si(net40));
aibcr3aux_osc_dly_unit x8 ( .vbb(vss_aibcr3aux), .vss(vss_aibcr3aux),
     .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux), .q(net35), .so(net36),
     .cdn(cdn), .cp(cp), .d(net38), .se_n(se_n), .si(net37));
aibcr3aux_osc_dly_unit x0 ( .cdn(cdn), .vbb(vss_aibcr3aux),
     .vss(vss_aibcr3aux), .vdd(vcc_aibcr3aux), .vpp(vcc_aibcr3aux),
     .q(net44), .so(net43), .cp(cp), .d(vcc_aibcr3aux), .se_n(se_n),
     .si(scan_in));
assign net060 = scan_rst_n;
assign net059 = rstb;
assign net28 = scan_clk;
assign se_n = scan_shift_n;
assign scanmodn = scan_mode_n;
assign cdn = scanmodn ? net059 : net060;
assign net30 = scanmodn ? net27 : net28;
assign net27 = ~clk;
assign cp = net30;
assign clkout = ~cp;

endmodule

