// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_sync_ff, View - schematic
// LAST TIME SAVED: Apr 28 12:41:55 2015
// NETLIST TIME: May 14 11:14:35 2015
// `timescale 1ns / 1ns 

module aibcr3_sync_ff ( Q, so,   
      CDN, CP, D, se_n, si );

output  Q, so;


input  CDN, CP, D, se_n, si;

wire Q, so, net047, se_n;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_sync_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign Q = so;
assign net047 = !se_n;
aibcr3_sync_3ff  xsync0 (  .SE(net047),     .D(D),  .Q(so), .CP(CP),  .SI(si),     .CDN(CDN));

endmodule

