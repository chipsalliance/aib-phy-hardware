// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                       
// *****************************************************************************
//  Module Name :  c3lib_buf_svt_4x                                  
//  Date        :  Thu May 12 10:45:36 2016                                 
//  Description :  Buffer (SVT, 4x drive strength)
// *****************************************************************************

module c3lib_buf_svt_4x( 

  in,
  out

); 

input		in;
output		out;

`ifdef BEHAVIORAL
  assign out = in;
`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule 

