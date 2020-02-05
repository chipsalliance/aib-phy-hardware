// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_red_clkmux2, View - schematic
// LAST TIME SAVED: Apr 27 12:38:24 2015
// NETLIST TIME: May 11 08:44:04 2015
//`timescale 1ns / 1ns 

module aibnd_clkmux2 ( mux_sel, oclk_in1, oclk_in0, oclk_out );

output  oclk_out;

input  oclk_in1, oclk_in0, mux_sel;

// List of primary aliased buses

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_red_clkmux2";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

assign oclk_out = mux_sel ?  oclk_in1 : oclk_in0 ;


endmodule


// End HDL models


