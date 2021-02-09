// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_ff, View - schematic
// LAST TIME SAVED: Jan 28 09:22:23 2015
// NETLIST TIME: Jun  3 17:00:05 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_ff ( q, so, vbb, vdd, vpp, vss, cdn, cp, d, se_n,
     si );

output  q, so;

inout  vbb, vdd, vpp, vss;

input  cdn, cp, d, se_n, si;

wire so, q, net68, se_n, si, SE;


// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign SE = ~se_n;
// aibcr3_ff_r x0 (   .CDN(cdn), .CP(cp), .D(net68), .Q(q));
aibcr3_svt16_scdffcdn_cust x0 (.CDN(cdn), .CK(cp), .D(d), .Q(q), .SI(si), .SE(SE), .scQ(so));

endmodule

