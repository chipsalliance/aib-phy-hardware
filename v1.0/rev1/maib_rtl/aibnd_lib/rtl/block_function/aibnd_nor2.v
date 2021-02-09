// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibnd_nor2 schematic"

// Netlisted models

// Library - aibnd_lib, Cell - aibnd_nor2, View - schematic
// LAST TIME SAVED: May  4 15:13:02 2015
// NETLIST TIME: May 11 08:42:44 2015
//`timescale 1ns / 1ns 

module aibnd_nor2 ( clkout, clk, en, vccl_aibnd, vssl_aibnd );

output  clkout;

input  clk, en, vccl_aibnd, vssl_aibnd;

// List of primary aliased buses

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_nor2";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

assign clkout = ~( clk | en ) ;

endmodule


// End HDL models

