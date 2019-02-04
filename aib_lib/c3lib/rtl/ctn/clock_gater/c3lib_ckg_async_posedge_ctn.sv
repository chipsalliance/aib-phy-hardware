// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckg_async_posedge_ctn                                  
//  Date        :  Wed May  4 08:24:30 2016                                 
//  Description :  Positive edge clock gater with async clk_en
//                  1. clk_en is synchronized clk
//                  2. The sync version of clk_en is latched on the positive
//                     of clk
//                  3. RESET_VAL determines the reset state of the clock
//                     gater (1'b0 => clock is blocked; 1'b1 => pass thru mode)
// *****************************************************************************

module c3lib_ckg_async_posedge_ctn #(

  parameter	RESET_VAL = 0	// Reset value is LOW if set to 0, otherwise HIGH

) ( 

  input  logic	tst_en,
  input  logic	clk_en,
  input  logic	rst_n, 
  input  logic	clk,
  output logic	gated_clk

); 

var	logic	clk_en_sync;

c3lib_bitsync #(

  .DWIDTH		( 1         ),
  .RESET_VAL		( RESET_VAL ),
  .DST_CLK_FREQ_MHZ	( 400       ),
  .SRC_DATA_FREQ_MHZ	( 1         )

) u_c3lib_bitsync (

  .clk		( clk         ),
  .rst_n	( rst_n       ), 
  .data_in	( clk_en      ),
  .data_out	( clk_en_sync )

); 

c3lib_ckg_lvt_8x u_c3lib_ckg_lvt_8x(

  .tst_en	( tst_en      ),
  .clk_en	( clk_en_sync ),
  .clk		( clk         ),
  .gated_clk	( gated_clk   )

); 

endmodule 

