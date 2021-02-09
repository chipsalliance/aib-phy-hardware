// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_fine_dly, View - schematic
// LAST TIME SAVED: Oct 29 11:08:08 2014
// NETLIST TIME: Oct 29 15:43:12 2014

module aibnd_dcc_fine_dly ( out_p, therm_dn, therm_up, thermb_dn,
     thermb_up, vcc_pl, vss_pl, fout_p );

output  out_p;

inout  vcc_pl, vss_pl;

input  fout_p;

output [14:0]  therm_dn;
output [14:0]  thermb_dn;
output [14:0]  thermb_up;
output [14:0]  therm_up;

// Buses in the design

wire  [0:2]  net040;

aibnd_dcc_dly_inv inn1[2:0] ( .o1(cap_node1), .a(cap_node),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_dly_inv inn3[2:0] ( .o1(out_p), .a(net040[0:2]),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_dly_inv inn2[2:0] ( .o1(cap_node2), .a(cap_node1),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_dly_inv inn5[2:0] ( .o1(cap_node3), .a(cap_node2),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_dly_inv inn4[2:0] ( .o1(net040[0:2]), .a(cap_node3),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_dly_inv inn0[2:0] ( .o1(cap_node), .a(fout_p),
     .vcc_io(vcc_pl), .vss_io(vss_pl));
aibnd_dcc_fine_dly_x1 x119[14:0] ( .dout(cap_node2),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_up[14:0]),
     .sp(thermb_up[14:0]));
aibnd_dcc_fine_dly_x1 x118[14:0] ( .dout(cap_node2),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_dn[14:0]),
     .sp(thermb_dn[14:0]));
aibnd_dcc_fine_dly_x1 x114[14:0] ( .dout(cap_node1),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_dn[14:0]),
     .sp(thermb_dn[14:0]));
aibnd_dcc_fine_dly_x1 x116[14:0] ( .dout(cap_node3),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_up[14:0]),
     .sp(thermb_up[14:0]));
aibnd_dcc_fine_dly_x1 x115[14:0] ( .dout(cap_node1),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_up[14:0]),
     .sp(thermb_up[14:0]));
aibnd_dcc_fine_dly_x1 xup[14:0] ( .dout(cap_node), .vcc_regphy(vcc_pl),
     .vss_io(vss_pl), .sn(therm_up[14:0]), .sp(thermb_up[14:0]));
aibnd_dcc_fine_dly_x1 xdn[14:0] ( .dout(cap_node), .vcc_regphy(vcc_pl),
     .vss_io(vss_pl), .sn(therm_dn[14:0]), .sp(thermb_dn[14:0]));
aibnd_dcc_fine_dly_x1 x117[14:0] ( .dout(cap_node3),
     .vcc_regphy(vcc_pl), .vss_io(vss_pl), .sn(therm_dn[14:0]),
     .sp(thermb_dn[14:0]));

endmodule

