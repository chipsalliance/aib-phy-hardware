// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_2to4dec, View - schematic
// LAST TIME SAVED: Oct 21 18:17:27 2014
// NETLIST TIME: Apr  4 14:12:47 2015
// `timescale 1ns / 1ns 

module aibcr3_2to4dec ( nsel_out0b, nsel_out1b, nsel_out2b, nsel_out3b,
     psel_out0, psel_out1, psel_out2, psel_out3, vccl, vssl, enable,
     nsel_in, psel_in );

output  nsel_out0b, nsel_out1b, nsel_out2b, nsel_out3b, psel_out0,
     psel_out1, psel_out2, psel_out3;

inout  vccl, vssl;

input  enable;

input [1:0]  nsel_in;
input [1:0]  psel_in;

wire nsel_out2b, enable, nsel_out3b, pserl_out3b, nsel1_en, psel0_en, psel0_enb, nsel_out0b, psel_out1, psel_out1b, nsel0_en, nsel0_enb, psel_out2, pserl_out2b, psel_out3, psel_out0, nsel_out1b;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_2to4dec";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign nsel_out2b = !(nsel_in[1] & enable);
assign nsel_out3b = !(enable & nsel_in[0] & nsel_in[1]);
assign pserl_out3b = !(enable & psel_in[0] & psel_in[1]);
assign nsel1_en = !nsel_out2b;
assign psel0_en = !psel0_enb;
assign nsel_out0b = !enable;
assign psel_out1 = !psel_out1b;
assign nsel0_en = !nsel0_enb;
assign psel_out2 = !pserl_out2b;
assign psel_out3 = !pserl_out3b;
assign psel_out0 = enable;
assign psel_out1b = !(psel0_en | psel_out2);
assign nsel_out1b = !(nsel0_en | nsel1_en);
assign pserl_out2b = !(psel_in[1] & enable);
assign nsel0_enb = !(nsel_in[0] & enable);
assign psel0_enb = !(psel_in[0] & enable);

endmodule

