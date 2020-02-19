// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_rst_n_sync.v.rca $
// Revision:    $Revision: #2 $
// Date:        $Date: 2015/03/23 $
//------------------------------------------------------------------------
// Description: Active low reset synchronizer core which is replaced by
// special cells in synthesis
//------------------------------------------------------------------------
module cdclib_rst_n_sync_core
  ( input  wire rst_n,     // Asynchronous reset
    input  wire clk,       // Clock to synchronize rst_n to
    input  wire tie_high,  // Tie high input
    output wire rst_n_sync // Synchronized rst_n deassertion output  
  );

//reg rst_n_sync1;

// Reset synchronizer
// Assertion is asynchronous
// De-assertion is synchronous to clk
//always @(negedge rst_n or posedge clk)
//  begin
//    if (rst_n == 1'b0)
//      begin
//        rst_n_sync1 <= 1'b0; 
//        rst_n_sync  <= 1'b0; 
//      end
//    else
//      begin
//        rst_n_sync1 <= tie_high; 
//        rst_n_sync  <= rst_n_sync1; 
//      end 
//  end 

cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
 (
  .clk		(clk),
  .rst_n	(rst_n),
  .data_in	(tie_high),
  .data_out	(rst_n_sync)
 );


endmodule
