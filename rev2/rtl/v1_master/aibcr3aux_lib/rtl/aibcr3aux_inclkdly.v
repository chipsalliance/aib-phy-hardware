// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_inclkdly, View - schematic
// LAST TIME SAVED: Mar 20 15:20:57 2015
// NETLIST TIME: Mar 20 15:26:36 2015

`ifdef TIMESCALE_EN
`timescale 1ps/1ps
`endif

module aibcr3aux_inclkdly
 
#(
 parameter PERIOD = 500
)
(
output clkout,

input  clkin, clkinb, csr_dly_ovrden, ib50u_ring, ib50uc, vcc_aibcr3aux,
     vssl_aibcr3aux,

input [3:0]  csr_dly_ovrd,
input [9:0]  iosc_fuse_trim
);
//wire vssl , net033 , nbias , vbias , nocon0 , net032 ;




 
assign #PERIOD clkout =  clkin;

endmodule


