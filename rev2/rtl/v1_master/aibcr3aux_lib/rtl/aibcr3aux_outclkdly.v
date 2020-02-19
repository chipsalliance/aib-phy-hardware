// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_outclkdly, View - schematic
// LAST TIME SAVED: Mar 20 15:24:37 2015
// NETLIST TIME: Mar 20 23:46:52 2015

`ifdef TIMESCALE_EN
`timescale 1ps/1ps
`endif

module aibcr3aux_outclkdly
#(
 parameter PERIOD = 500
)
(
output clkout,

input  clkin, clkinb, csr_dly_ovrden, ib50u_ring, ib50uc, vcc_aibcr3aux,
     vssl_aibcr3aux,

input [9:0]  iosc_fuse_trim,
input [3:0]  csr_dly_ovrd

//wire net033 , vssl , nbias , vbias , net032 , nocon0
);



assign #PERIOD clkout =  clkin;

endmodule

