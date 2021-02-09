// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_5b_b2tc_x1, View - schematic
// LAST TIME SAVED: Nov 17 13:12:10 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_dcc_5b_b2tc_x1 ( therm, thermb, vcc_pl, vss_pl, q0, q1,
     q2, q3, q4, therm_p1 );

output  therm, thermb;

inout  vcc_pl, vss_pl;

input  q0, q1, q2, q3, q4, therm_p1;

wire net0353, q1, q0, therm, thermb, net0369, q4, q3, q2, net0565, therm_p1; // Conversion Sript Generated



assign net0353 = !(q1 & q0);
assign therm = !thermb;
assign net0369 = !(q4 & q3 & q2);
assign net0565 = !(net0369 | net0353);
assign thermb = !(net0565 | therm_p1);

endmodule

