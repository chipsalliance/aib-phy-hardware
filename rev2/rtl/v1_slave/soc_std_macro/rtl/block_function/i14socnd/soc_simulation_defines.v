// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//use functional RTL (no cells delay) for memory macro - intel
`define INTC_FUNCTIONAL

//use fast-verilog model RTL for memory macro - synopsys
`define VIRAGE_FAST_VERILOG

//use functional RTL (no cells delay) for std_cell
`define FUNCTIONAL

//remove power ports from RTL macros
`define INTCNOPWR

//use functional RTL (no cells delay) for ip734tsehv (temperature sensor)
`define functional

//enforces STD_CELL MACRO to be always turned on
//`ifdef ALTR_HPS_INTEL_MACROS_OFF
		//DO NOT COMPILE WITH TICK - ALTR_HPS_INTEL_MACROS_OFF 
//`endif

//enforces MEMORY macro to be always turn on
//`ifdef ALTR_HPS_MEMORY_OFF
//		DO NOT COMPILE WITH TICK - ALTR_HPS_MEMORY_OFF
//`endif

`timescale 1ns/1ps
