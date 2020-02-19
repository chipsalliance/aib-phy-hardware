// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                         
// *****************************************************************************
//  Module Name :  c3lib_sync2_set_ulvt_gate
//  Date        :  Wed May  4 11:15:32 2016                                 
//  Description :  Primitive wrapper for '2 stage synchronizer with preset on rst_n'
// *****************************************************************************

module c3lib_sync2_set_ulvt_gate( 

  clk, 
  rst_n, 
  data_in,
  data_out

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;
`ifdef BEHAVIORAL
  c3lib_sync_metastable_behav_gate #(

    .RESET_VAL	( 1 ),
    .SYNC_STAGES( 2 )

  ) u_c3lib_sync2_reset_lvt_gate ( 

    .clk	( clk      ),
    .rst_n	( rst_n    ),
    .data_in	( data_in  ),
    .data_out	( data_out )

  );
`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule 

