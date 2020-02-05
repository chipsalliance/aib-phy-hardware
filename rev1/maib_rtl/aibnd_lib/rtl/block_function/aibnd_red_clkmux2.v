// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_red_clkmux2, View - schematic
// LAST TIME SAVED: Apr 27 12:38:24 2015
// NETLIST TIME: May 11 08:44:04 2015
//`timescale 1ns / 1ns 

module aibnd_red_clkmux2 ( clkout, clk1, clk2, s, vccl_aibnd,
     vssl_aibnd );

output  clkout;

input  clk1, clk2, s, vccl_aibnd, vssl_aibnd;

// List of primary aliased buses

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_red_clkmux2";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

assign clkout = s ?  clk1 : clk2 ;


endmodule


// End HDL models


