// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_lsbuf, View - schematic
// LAST TIME SAVED: Dec 11 09:20:16 2014
// NETLIST TIME: Dec 16 13:30:37 2014

module aibcr3aux_osc_lsbuf ( out, vccl, vccreg, vss, vssreg, in );

output  out;

inout  vccl, vccreg, vss, vssreg;

input  in;

wire in2b, in2, out, inb, in;



assign in2b = ~in2;
assign out = ~in2b;
assign in2 = ~inb;
assign inb = ~in;

endmodule

