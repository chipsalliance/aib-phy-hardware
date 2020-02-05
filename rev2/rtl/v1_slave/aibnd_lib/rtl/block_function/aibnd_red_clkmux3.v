// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_red_clkmux3, View - schematic
// LAST TIME SAVED: Apr 22 13:17:46 2015
// NETLIST TIME: May 11 08:48:38 2015
//`timescale 1ns / 1ns 

module aibnd_red_clkmux3 ( clkout, clk1, clk2, clk3, s1, s2, s3,
     vccl_aibnd, vssl_aibnd );

output  clkout;

input  clk1, clk2, clk3, s1, s2, s3, vccl_aibnd, vssl_aibnd;

reg clkout;

// List of primary aliased buses

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_red_clkmux3";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

always @ ( s1 or s2 or s3 or clk1 or clk2 or clk3 )
	case ( {s3,s2,s1} )
		3'b001 : clkout = clk1 ;
		3'b010 : clkout = clk2 ;
		3'b100 : clkout = clk3 ;
		default : clkout = 1'bx ;
	endcase
endmodule


// End HDL models

