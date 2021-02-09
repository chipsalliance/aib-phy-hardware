// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                       
// *****************************************************************************
//  Module Name :  c3lib_mtie0_ds                                  
//  Date        :  Fri Feb 10 09:57:07 2017                                 
//  Description :  Tie LOW cell (value can be changed via top metal layer)
// *****************************************************************************

module  c3lib_mtie0_ds( 

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

