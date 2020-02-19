// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibnd_rxanlg schematic"


// alias module. For internal use only.
//hdlFilesDir/cds_alias.v

// Netlisted models

// Library - aibnd_lib, Cell - aibnd_rxinv, View - schematic
// LAST TIME SAVED: Oct  1 14:27:50 2014
// NETLIST TIME: Oct 27 17:27:56 2014
//`timescale 1ns / 1ns 

module aibnd_rxanlg ( oclkn, oclkp, odat, odat_async, iopad, vccl_aibnd,
     vssl_aibnd, clk_en, data_en, iclkn );

output  oclkn, oclkp, odat, odat_async;

inout  iopad;
input vccl_aibnd, vssl_aibnd;
input  clk_en, data_en, iclkn;

wire clk_enb, clk_en_buf, preoclkpb, preoclkpbb, preoclkpbbb, preoclkp, oclkpb;
wire preoclknb, preoclknbb, preoclknbbb, preoclkn, oclknb;
wire data_enb, data_en_buf, preodatb, preodatbb, preodatbbb, preodat, odatb, preodatn, odat_inv_b, odat_inv;
//specify 
//    specparam CDS_LIBNAME  = "aibnd_lib";
//    specparam CDS_CELLNAME = "aibnd_rxanlg";
//    specparam CDS_VIEWNAME = "schematic";
//endspecify
assign clk_enb = ~clk_en;
assign clk_en_buf = ~clk_enb;

assign preoclkpb = ~iopad;
assign preoclkpbb = ~preoclkpb;
assign preoclkpbbb = ~preoclkpbb;
assign preoclkp = ~preoclkpbbb;
assign oclkpb = ~(preoclkp & clk_en_buf); 
assign oclkp = ~oclkpb;
//assign oclkp = (clk_en_buf == 1'b1) ? iopad : ((clk_en_buf == 1'b0)? 1'b0: 1'bx);

assign preoclknb = ~iclkn;
assign preoclknbb = ~preoclknb;
assign preoclknbbb = ~preoclknbb;
assign preoclkn = ~ preoclknbbb;
assign oclknb = ~(clk_enb | preoclkn);
assign oclkn = ~oclknb;
//assign oclkn = (clk_enb == 1'b0) ? iclkn : ((clk_enb == 1'b1)? 1'b1: 1'bx);
// REMARK: oclkp and oclkn should be mutually exclusive when clk_en = 1 or 0; Need assertion to check.
// Need to gate VCCL power supply in future.
assign data_enb = ~data_en;
assign data_en_buf = ~data_enb;
assign preodatb = ~iopad;
assign preodatbb = ~preodatb;
assign preodatbbb = ~preodatbb;
assign preodat = ~preodatbbb;
assign odatb = ~( preodat & data_en_buf);
assign odat = ~odatb;
//assign odat = (data_en_buf == 1'b1)? iopad : (data_en_buf == 1'b0)? 1'b0: 1'bx;
//Need to gate VCCL power supply in future.

assign preodatn = preodatbbb;
assign odat_inv_b = ~(preodatn | data_enb);
assign odat_inv = ~odat_inv_b;
assign odat_async = ~odat_inv;
//assign odat_async = (data_enb == 1'b0)? iopad : (data_enb == 1'b1)? 1'b0:1'bx;
//Need to gate VCCL power supply in future
endmodule


// End HDL models

