// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// 2011 Altera Corporation. .
//
//****************************************************************************************

//---------------------------------------------------------------------------------------
// Description: For rst_n, asynchronously assertion and sychronously de-assertion (AASD)
//
//---------------------------------------------------------------------------------------

module altr_hps_rstnsync4
  (
    input wire 		clk,
    input wire 		i_rst_n,          
    input wire		scan_mode,
    output wire 	sync_rst_n			     
   
   );

   reg 		first_stg_rst_n;					     
   wire		prescan_sync_rst_n;
   
   always @(posedge clk or negedge i_rst_n)
     if (!i_rst_n)
       first_stg_rst_n <= 1'b0;
     else
       first_stg_rst_n <= 1'b1;

   altr_hps_bitsync4 
     #(.DWIDTH(1), .RESET_VAL(0)                       ) 
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
	   .mux_in0  (prescan_sync_rst_n),
	   .mux_in1  (i_rst_n),
	   .mux_sel	 (scan_mode),  
	   .mux_out  (sync_rst_n)
   );
   
   endmodule
   
