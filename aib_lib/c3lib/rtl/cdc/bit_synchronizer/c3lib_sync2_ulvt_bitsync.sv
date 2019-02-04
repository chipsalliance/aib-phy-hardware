// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//----------------------------------------------------------------------------- 
//----------------------------------------------------------------------------- 
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
//----------------------------------------------------------------------------- 
//  Module Name :  c3lib_sync2_ulvt_bitsync                                  
//  Date        :  Fri Mar 18 08:42:01 2016                                 
//  Description :                                                    
//-----------------------------------------------------------------------------  

module c3lib_sync2_ulvt_bitsync #(

  parameter	DWIDTH            = 1,		// Width of bus to be sync'ed
  parameter	RESET_VAL         = 0		// Reset value is LOW if set to 0, otherwise HIGH

) (

  input  logic				clk, 
  input  logic				rst_n, 

  input  logic[ (DWIDTH-1) : 0 ]	data_in,
  output logic[ (DWIDTH-1) : 0 ]	data_out

); 

  generate

    if (RESET_VAL == 0)
      c3lib_sync2_reset_ulvt_gate u_c3lib_sync2_reset_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n ), .data_in( data_in ), .data_out( data_out ) );
    else
      c3lib_sync2_set_ulvt_gate u_c3lib_sync2_set_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n ), .data_in( data_in ), .data_out( data_out ) );

  endgenerate

endmodule 

