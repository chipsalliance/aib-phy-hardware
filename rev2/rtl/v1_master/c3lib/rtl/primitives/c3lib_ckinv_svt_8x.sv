// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                      
// *****************************************************************************
//  Module Name :  c3lib_ckinv_svt_8x                                  
//  Date        :  Mon Sep 19 10:43:04 2016                                 
//  Description :  Clock inverter (LVT, 8x drive strength)
// *****************************************************************************

module c3lib_ckinv_svt_8x( 

  in,
  out

  ); 

input		in;
output		out;

`ifdef BEHAVIORAL
  assign out = ~in;

`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif
endmodule 

