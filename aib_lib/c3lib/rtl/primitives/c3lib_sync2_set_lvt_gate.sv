// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_sync2_set_lvt_gate
//  Date        :  Wed May  4 11:15:36 2016                                 
//  Description :  Primitive wrapper for '2 stage synchronizer with preset on rst_n'
// *****************************************************************************

module c3lib_sync2_set_lvt_gate( 

  clk, 
  rst_n, 
  data_in,
  data_out

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  c3lib_sync_metastable_behav_gate #(

    .RESET_VAL	( 1 ),
    .SYNC_STAGES( 2 )

  ) u_c3lib_sync2_reset_lvt_gate ( 

    .clk	( clk      ),
    .rst_n	( rst_n    ),
    .data_in	( data_in  ),
    .data_out	( data_out )

  );

`endif

endmodule 

