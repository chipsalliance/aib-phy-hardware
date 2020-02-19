// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_lvlsync4.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//-----------------------------------------------------------------------------
// Description : 4-stage level sync module
//-----------------------------------------------------------------------------
module cdclib_lvlsync4
   #(
      parameter EN_PULSE_MODE    = 0, // Enable Pulse mode i.e O/P data pulses for change in I/P
      parameter DWIDTH           = 1, // Sync Data input 
      parameter ACTIVE_LEVEL     = 1, // 1: Active high; 0: Active low      
      parameter WR_CLK_FREQ_MHZ     = 1000,   // Clock frequency (in MHz)    
      parameter RD_CLK_FREQ_MHZ     = 1000,   // Clock frequency (in MHz)    
      parameter VID          = 1     // 1: VID, 0: preVID
    )
   (
   // Inputs
   input  wire               wr_clk,      // write clock
   input  wire               rd_clk,      // read clock
   input  wire               wr_rst_n,    // async reset for write clock domain
   input  wire               rd_rst_n,    // async reset for read clock domain
   input  wire  [DWIDTH-1:0] data_in,     // data in
   // Outputs
   output wire  [DWIDTH-1:0] data_out     // data out
   );

// 4-stage synchronizer   
localparam SYNCSTAGE = 4;

// level-sync module
cdclib_lvlsync 
   #(
      .EN_PULSE_MODE(EN_PULSE_MODE), // Enable Pulse mode i.e O/P data pulses for change in I/P
      .DWIDTH(DWIDTH),               // Sync Data input 
      .SYNCSTAGE(SYNCSTAGE),         // Sync stages
      .ACTIVE_LEVEL(ACTIVE_LEVEL),   // Active level
      .WR_CLK_FREQ_MHZ(WR_CLK_FREQ_MHZ),
      .RD_CLK_FREQ_MHZ(RD_CLK_FREQ_MHZ),
      .VID	(VID)
    ) cdclib_lvlsync4
   (
   // Inputs
   .wr_clk(wr_clk),       // write clock
   .rd_clk(rd_clk),       // read clock
   .wr_rst_n(wr_rst_n),   // async reset for write clock domain
   .rd_rst_n(rd_rst_n),   // async reset for read clock domain
   .data_in(data_in),     // data in
   // Outputs
   .data_out(data_out)    // data out
   );

endmodule //cdclib_lvlsync3
