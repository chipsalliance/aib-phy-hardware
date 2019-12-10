// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
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

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  c3lib_sync_metastable_behav_gate #(

    .RESET_VAL	( 0 ),
    .SYNC_STAGES( 3 )

  ) u_c3lib_sync2_reset_lvt_gate ( 

    .clk	( clk      ),
    .rst_n	( rst_n    ),
    .data_in	( data_in  ),
    .data_out	( data_out )

  );

`endif

endmodule 

