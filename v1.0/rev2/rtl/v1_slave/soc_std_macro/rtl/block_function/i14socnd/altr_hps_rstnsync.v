// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright  2011 Altera Corporation. .
//
//****************************************************************************************

//---------------------------------------------------------------------------------------
// Description: For rst_n, asynchronously assertion and sychronously de-assertion (AASD)
// Assumptions: i_rst_n is assumed to be bypassed with scan_clk during scan_mode
//---------------------------------------------------------------------------------------

module altr_hps_rstnsync
  (
    input wire 	clk,		// Destination clock of reset to be synced
    input wire 	i_rst_n,        // Asynchronous reset input
    input wire	scan_mode,	// Scan bypass for reset
    output wire sync_rst_n	// Synchronized reset output
   
   );

   reg	first_stg_rst_n;					     
   wire prescan_sync_rst_n;
   
   always @(posedge clk or negedge i_rst_n)
     if (!i_rst_n)
       first_stg_rst_n <= 1'b0;
     else
       first_stg_rst_n <= 1'b1;

   altr_hps_bitsync 
     #(.DWIDTH(1), .RESET_VAL(0)                      ) 
   i_sync_rst_n
     (
      .clk           (clk               ),
      .rst_n         (i_rst_n           ), 
      .data_in       (first_stg_rst_n   ),
      .data_out      (prescan_sync_rst_n) 
      );

   // Added scan bypass mux (Fogbugz #26486)
   altr_hps_mux21 
   	i_rstsync_mux 
	(
		.mux_in0	(prescan_sync_rst_n),
		.mux_in1	(i_rst_n),
		.mux_sel	(scan_mode),
		.mux_out	(sync_rst_n)
	);
      
   endmodule
   
