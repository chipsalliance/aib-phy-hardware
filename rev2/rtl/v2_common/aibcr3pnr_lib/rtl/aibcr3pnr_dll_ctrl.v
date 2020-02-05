// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        aibcr3pnr_dll_ctrl.v 
// Revision:    Revision: #1 
// Date:        2016/07/04 
//------------------------------------------------------------------------
// Description: dll reset control
//
//------------------------------------------------------------------------

module aibcr3pnr_dll_ctrl (
   input  wire         clk,                     //reference clock from pll
   input  wire         reinit,                  //initialization enable
   input  wire         entest,                  //test enable
   input  wire         ndllrst_in,              //reset from core
   input  wire         rb_dll_en,               //dll enable
   input  wire         rb_dll_rst_en,           //dll reset enable
   input  wire         atpg_en_n,               //atpg
   input  wire         test_clr_n,              //test clear
   output wire         dll_reset_n             //output for dll reset
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

wire         eni;
wire         dll_rst;

////////////////////////////////////////////////////////////////////
//                                                                //
//  reset and preset                                              //
//                                                                //
////////////////////////////////////////////////////////////////////

assign dll_rst = (rb_dll_rst_en) ?  ~ndllrst_in : 1'b0;                 //core reset at "1" if core_reset enabled
assign eni = ~entest & rb_dll_en & (~reinit) & (~dll_rst);              //dll enable and non-test
//hd_dpcmn_rst_n_sync unrst  ( .rst_n(eni), .rst_n_bypass(test_clr_n), .clk(clk),  .scan_mode_n(atpg_en_n), .rst_n_sync(dll_reset_n) ); 
aibcr3pnr_rstsync unrst ( .rst_n(eni), .rst_n_bypass(test_clr_n), .clk(clk),  .scan_mode_n(atpg_en_n), .rst_n_sync(dll_reset_n) ); 

endmodule // aibcr3pnr_dll_ctrl

