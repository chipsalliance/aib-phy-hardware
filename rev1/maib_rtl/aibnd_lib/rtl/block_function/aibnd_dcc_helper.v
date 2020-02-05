// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_helper, View - schematic
// LAST TIME SAVED: May  7 14:55:59 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_helper ( clkout, clk_dcd, dcc_byp, launch, launchb,
     measure, measureb, rstb, vcc_io, vss_io );

output  clkout;

input  clk_dcd, dcc_byp, launch, launchb, measure, measureb, rstb,
     vcc_io, vss_io;

wire clk, sel, measure, launch, net074, clkout, datab, data, rb, reset, q, rstb, dcc_byp, net073; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_helper";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign clk = sel ? measure : launch;
aibnd_dcc_mux mbn2 ( .vcc_aibnd(vcc_io), .vss_aibnd(vss_io), .clk0(q),
     .s(net073), .clkout(net074), .clk1(clk_dcd));
assign clkout = net074;
an_io_phdet_ff_ln  x2 ( /*`ifndef INTCNOPWR .vcc(vcc_io), .vss(vss_io), `endif*/ .q(q), .clk_p(clk),
     .dn(datab), .dp(data), .rst_n(syncrstb));
assign datab = !data;
assign rb = !reset;
assign data = !q;
assign sel = !data;
assign reset = !rstb;
aibnd_2ff_scan  fyn1 ( .si(vss_io), .so(net035), .ssb(vcc_io),     .o(syncrstb), .d(vcc_io), .clk(launch) /*`ifndef INTCNOPWR , .vss(vss_io) , .vcc(vcc_io) `endif*/ , .rb(rb));
aibnd_2ff_scan  hgy0 ( .d(vss_io), .clk(measure), .o(net038) /*`ifndef INTCNOPWR , .vcc(vcc_io) `endif*/ , .rb(vss_io), .si(vss_io) /*`ifndef INTCNOPWR , .vss(vss_io) `endif*/ , .so(net036),     .ssb(vcc_io));
assign net073 = dcc_byp;

endmodule

