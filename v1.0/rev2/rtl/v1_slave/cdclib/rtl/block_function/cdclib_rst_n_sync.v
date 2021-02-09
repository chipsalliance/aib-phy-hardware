// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_rst_n_sync.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2014/08/24 $
//------------------------------------------------------------------------
// Description: Active low reset synchronizer with bypass in scan mode
//
//------------------------------------------------------------------------
module cdclib_rst_n_sync
  ( input  wire rst_n,        // Asynchronous reset
    input  wire rst_n_bypass, // PLD reset input in scan mode
    input  wire clk,          // Clock to synchronize rst_n to
    input  wire scan_mode_n,  // Scan mode control
    output wire rst_n_sync    // Synchronized rst_n deassertion output  
  );

wire rst_n_sync_int;

// reset synchronizer core
cdclib_rst_n_sync_core cdclib_rst_n_sync_core
  ( 
    .rst_n(rst_n),              // Asynchronous reset
    .clk(clk),                  // Clock to synchronize rst_n to
    .tie_high(1'b1),            // Tie high input
    .rst_n_sync(rst_n_sync_int) // Synchronized rst_n deassertion output  
  );
 
// Reset synchronizer bypass
assign rst_n_sync = (scan_mode_n == 1'b0) ? rst_n_bypass : rst_n_sync_int;

endmodule
