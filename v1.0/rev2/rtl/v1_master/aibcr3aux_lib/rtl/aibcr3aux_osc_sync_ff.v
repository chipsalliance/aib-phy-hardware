// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_sync_ff, View -
//schematic
// LAST TIME SAVED: Jan 30 17:11:30 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_sync_ff ( Q, so,  
       CDN, CP, D, se_n, si );

output  Q, so;

//inout  inh_BN, inh_BP, inh_VN, inh_VP;

input  CDN, CP, D, se_n, si;

wire net95, se_n, so, Q;


// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_sync_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net95 = ~se_n;
aibcr3_sync_3ff xsync0 (  .SE(net95),     .D(D),  .Q(Q), .CP(CP),  .SI(si),     .CDN(CDN));
assign so = Q;

endmodule

