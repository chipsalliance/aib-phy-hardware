// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_dcc_top_dummy, View - schematic
// LAST TIME SAVED: Mar 10 15:22:01 2015
// NETLIST TIME: May 14 11:14:35 2015
// `timescale 1ns / 1ns 

module aibcr3_dcc_top_dummy ( clk_dcc, dcc_done, clk_dcd, dcc_req,
     vcc_aibcr, vcc_io, vss_aibcr );

output  clk_dcc, dcc_done;

input  clk_dcd, dcc_req, vcc_aibcr, vcc_io, vss_aibcr;

wire clk_dcc, clk_dcd;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_dcc_top_dummy";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

// aibcr3_sync_2ff  xsync0 (      .SE(vss_aibcr), .D(vcc_aibcr),  .Q(dcc_done),     .CP(clk_dcc),  .SI(vss_aibcr), .CDN(dcc_req));


assign tie_LO = 1'b0;
assign tie_HI = 1'b1;

aibcr3_ulvt16_2xarstsyncdff1_b2 x1 ( .SE (tie_LO), .SI (tie_LO), .Q(dcc_done), .D (tie_HI), .CK (clk_dcc), .CLR_N (dcc_req));

assign clk_dcc = clk_dcd;


endmodule

