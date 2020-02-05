// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019  Ayar Labs, Inc.
// Copyright (C) 2019 Intel Corporation. 

// Copyright (C) 2016 Altera Corporation. .  
// *****************************************************************************
//  Module Name :  c3lib_sync3_reset_ulvt_gate                                  
//  Date        :  Thu May 12 08:31:01 2016                                 
//  Description :  Primitive wrapper for '3 stage synchronizer with clear on rst_n'.
// *****************************************************************************

module  c3lib_sync3_reset_ulvt_gate( 

  clk, 
  rst_n, 
  data_in,
  data_out

  ); 

input	clk; 
input	rst_n; 
input	data_in;
output	data_out;

//  c3lib_sync_metastable_behav_gate #(
//
//    .RESET_VAL	( 0 ),
//    .SYNC_STAGES( 3 )
//
//  ) u_c3lib_sync2_reset_lvt_gate ( 
//
//    .clk	( clk      ),
//    .rst_n	( rst_n    ),
//    .data_in	( data_in  ),
//    .data_out	( data_out )
//
//  );
data_sync_for_aib # (
    .ActiveLow(1),
    .ResetVal(1'b0),
    .SyncRegWidth(3)
) u_c3lib_sync2_reset_lvt_gate (
    .clk    ( clk      ),
    .rst_in (rst_n ),
    .data_in(data_in),
    .data_out   ( data_out )
);

endmodule 

