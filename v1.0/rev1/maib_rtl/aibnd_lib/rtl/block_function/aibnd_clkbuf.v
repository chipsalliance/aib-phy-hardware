// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_clkbuf, View - schematic
// LAST TIME SAVED: Oct 28 12:28:02 2014
// NETLIST TIME: Oct 29 14:53:12 2014

module aibnd_clkbuf ( clkout, vccl, vssl, clkin );

output  clkout;

inout  vccl, vssl;

input  clkin;

wire clkin, clkout; // Conversion Sript Generated

assign clkout = !clkin;

endmodule

