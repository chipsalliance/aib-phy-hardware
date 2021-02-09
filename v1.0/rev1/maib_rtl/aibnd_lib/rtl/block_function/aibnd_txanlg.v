// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibnd_txanlg schematic"


// alias module. For internal use only.
//hdlFilesDir/cds_alias.v

// Library - aibnd_lib, Cell - aibnd_txanlg, View - schematic
// LAST TIME SAVED: Sep 10 18:08:54 2014
// NETLIST TIME: Sep 11 16:10:47 2014
//`timescale 1ps / 1ps 

module aibnd_txanlg ( txpadout, vccl_aibnd, vssl_aibnd, din, ndrv_enb, pdrv_en,
     weak_pulldownen, weak_pullupenb );

inout  txpadout;

input  din, weak_pulldownen, weak_pullupenb;
input vccl_aibnd, vssl_aibnd;
input [15:0]  ndrv_enb;
input [15:0]  pdrv_en;

// Buses in the design

wire  [15:0]  ngin;

wire  [15:0]  pgin;


wire txpadout;

//specify 
//    specparam CDS_LIBNAME  = "aibnd_lib";
//    specparam CDS_CELLNAME = "aibnd_txanlg";
//    specparam CDS_VIEWNAME = "schematic";
//endspecify

//need to gate txpadout with vccl and vssl in future
// wek_pulldownen Vs. (pdrv_en and ndrv_enb) are mutually exclusive in txdig. No X check.
// weak_pulldownen = 1 and weak_pullupenb =1 is weak pulldown.
// weak_pulldownen = 0 and weak_pullupenb =0 is weak pull up.
//Other condition is high Z.
assign (weak0, weak1) txpadout = ((weak_pulldownen & weak_pullupenb) == 1'b1) ? 1'b0: (((weak_pulldownen | weak_pullupenb) == 1'b0)? 1'b1: 1'bz);
assign txpadout = (|pdrv_en & din)? 1'b1: 1'bz;
assign txpadout = (~&ndrv_enb & ~din)? 1'b0: 1'bz;
endmodule


// End HDL models

