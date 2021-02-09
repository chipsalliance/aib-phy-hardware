// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                         
// *****************************************************************************
//  Module Name :  c3lib_tie0_svt_1x                                  
//  Date        :  Thu May 12 08:55:31 2016                                 
//  Description :  Tie LOW cell
// *****************************************************************************

module c3lib_tie0_svt_1x( 

  out

  ); 

output	out;
`ifdef BEHAVIORAL
  assign out = 1'b0;
`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule 

