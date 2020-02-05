// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_2to4dec, View - schematic
// LAST TIME SAVED: Dec 11 15:13:26 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_2to4dec ( nsel_out0b, nsel_out1b, nsel_out2b, nsel_out3b,
     psel_out0, psel_out1, psel_out2, psel_out3, enable, nsel_in,
     psel_in, vccl_aibnd, vssl_aibnd );

output  nsel_out0b, nsel_out1b, nsel_out2b, nsel_out3b, psel_out0,
     psel_out1, psel_out2, psel_out3;

input  enable, vccl_aibnd, vssl_aibnd;

input [1:0]  psel_in;
input [1:0]  nsel_in;

wire psel_out1, psel0_en, psel_out2, nsel0_en, enable, psel_out3, nsel1_en, nsel_out2b, nsel_out1b, nsel_out3b, psel_out0, nsel_out0b; // Conversion Sript Generated



assign psel_out1 = psel0_en | psel_out2;
assign nsel0_en = nsel_in[0] & enable;
assign psel_out2 = psel_in[1] & enable;
assign psel0_en = psel_in[0] & enable;
assign psel_out3 = enable & psel_in[0] & psel_in[1];
assign nsel1_en = !nsel_out2b;
assign nsel_out2b = !(nsel_in[1] & enable);
assign nsel_out1b = !(nsel0_en | nsel1_en);
assign nsel_out3b = !(enable & nsel_in[0] & nsel_in[1]);
assign psel_out0 = !nsel_out0b;
assign nsel_out0b = !enable;

endmodule

