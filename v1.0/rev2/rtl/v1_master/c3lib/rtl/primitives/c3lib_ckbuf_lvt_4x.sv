// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                          
// *****************************************************************************
//  Module Name :  c3lib_ckbuf_lvt_4x                                  
//  Date        :  Thu May 12 10:45:26 2016                                 
//  Description :  Clock buffer (LVT, 4x drive strength)
// *****************************************************************************

module  c3lib_ckbuf_lvt_4x(

  in,
  out

  ); 

input  		in;
output 		out;
`ifdef BEHAVIORAL
  assign out = in;

`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif
endmodule 

