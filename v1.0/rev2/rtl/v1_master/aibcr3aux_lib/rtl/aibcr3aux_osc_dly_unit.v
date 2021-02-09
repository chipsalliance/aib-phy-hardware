// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_dly_unit, View -
//schematic
// LAST TIME SAVED: Mar 19 10:27:32 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_dly_unit ( q, so, cdn, cp, d, se_n, si, vbb, vdd,
     vpp, vss );

output  q, so;

input  cdn, cp, d, se_n, si, vbb, vdd, vpp, vss;

wire net21;
wire net22;

// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_dly_unit";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_osc_ff x0 ( .cdn(cdn), .vbb(vbb), .vss(vss), .vdd(vdd),
     .vpp(vpp), .q(net21), .so(net22), .cp(cp), .d(d), .se_n(se_n),
     .si(si));
aibcr3aux_osc_ff x1 ( .cdn(cdn), .vbb(vbb), .vss(vss), .vdd(vdd),
     .vpp(vpp), .q(q), .so(so), .cp(cp), .d(net21), .se_n(se_n),
     .si(net22));

endmodule

