// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//----------------------------------------------------------------------------- 
//----------------------------------------------------------------------------- 
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
//----------------------------------------------------------------------------- 
//  Module Name :  c3lib_bitsync                                  
//  Date        :  Thu Mar 17 17:27:04 2016                                 
//  Description :                                                    
//-----------------------------------------------------------------------------  

module  c3lib_bitsync #(

  parameter	DWIDTH            = 1,		// Width of bus to be sync'ed
  parameter	RESET_VAL         = 0,		// Reset value is LOW if set to 0, otherwise HIGH
  parameter	DST_CLK_FREQ_MHZ  = 500,	// Clock frequency for destination domain in MHz
  parameter	SRC_DATA_FREQ_MHZ = 100		// Average source data 'frequency' in MHz

) (

  input  logic				clk, 
  input  logic				rst_n, 

  input  logic[ (DWIDTH-1) : 0 ]	data_in,
  output logic[ (DWIDTH-1) : 0 ]	data_out

); 

  generate

    if (DST_CLK_FREQ_MHZ > 500) begin : DST_CLK_GREATER_THAN_500MHZ

      if (RESET_VAL == 0) begin : ULVT_RESET
        c3lib_sync2_reset_ulvt_gate u_c3lib_sync2_reset_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n), .data_in( data_in), .data_out( data_out ) );
      end
      else begin : ULVT_SET
        c3lib_sync2_set_ulvt_gate u_c3lib_sync2_set_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n ), .data_in( data_in), .data_out( data_out ) );
      end

    end
    else begin : DST_CLK_LESS_THAN_OR_EQUAL_TO_500MHZ
  
      if (RESET_VAL == 0) begin : LVT_RESET
        c3lib_sync2_reset_lvt_gate u_c3lib_sync2_reset_lvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n ), .data_in( data_in ), .data_out( data_out ) );
      end
      else begin : LVT_SET
        c3lib_sync2_set_lvt_gate u_c3lib_sync2_set_lvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk ), .rst_n( rst_n ), .data_in( data_in ), .data_out( data_out ) );
      end

    end

  endgenerate

endmodule 

