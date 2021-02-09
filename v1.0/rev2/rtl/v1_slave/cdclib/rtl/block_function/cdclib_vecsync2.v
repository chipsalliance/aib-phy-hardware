// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_vecsync2.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//-----------------------------------------------------------------------------
// Description : 2-stage vector synchronizer
//-----------------------------------------------------------------------------
module cdclib_vecsync2 
   #(
      parameter DWIDTH           = 2, // Sync Data input 
      parameter WR_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter RD_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter VID          = 1     // 1: VID, 0: preVID
    )
   (
   // Inputs
   input  wire               wr_clk,        // write clock
   input  wire               rd_clk,        // read clock
   input  wire               wr_rst_n,      // async write reset
   input  wire               rd_rst_n,      // async read reset
   input  wire [DWIDTH-1:0]  data_in,       // data in
   // Outputs
   output wire  [DWIDTH-1:0] data_out       // data out
   );

// 2-stage synchronizer   
localparam SYNCSTAGE = 2;

// Vecsync module
cdclib_vecsync 
   #(
      .DWIDTH(DWIDTH),       // Sync Data input 
      .SYNCSTAGE(SYNCSTAGE),  // Sync stages
      .WR_CLK_FREQ_MHZ(WR_CLK_FREQ_MHZ),
      .RD_CLK_FREQ_MHZ(RD_CLK_FREQ_MHZ),
      .VID	(VID)
    ) cdclib_vecsync2
   (
   // Inputs
   .wr_clk(wr_clk),         // write clock
   .rd_clk(rd_clk),         // read clock
   .wr_rst_n(wr_rst_n),     // async write reset
   .rd_rst_n(rd_rst_n),     // async read reset
   .data_in(data_in),       // data in
   // Outputs
   .data_out(data_out)      // data out
   );

endmodule // cdclib_vecsync2

