// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibnd_inv schematic"

// Netlisted models

// Library - aibnd_lib, Cell - aibnd_inv, View - schematic
// LAST TIME SAVED: Apr 22 17:45:05 2015
// NETLIST TIME: May 11 08:38:23 2015
//`timescale 1ns / 1ns 

module aibnd_inv ( clkout, clk, vccl_aibnd, vssl_aibnd );

output  clkout;

input  clk, vccl_aibnd, vssl_aibnd;

// List of primary aliased buses

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_inv";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

assign clkout = ~clk ; 

endmodule


// End HDL models

