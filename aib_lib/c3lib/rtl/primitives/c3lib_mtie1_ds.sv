// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_mtie1_ds                                  
//  Date        :  Fri Feb 10 09:57:04 2017                                 
//  Description :  Tie LOW cell (value can be changed via top metal layer)
// *****************************************************************************

module  c3lib_mtie1_ds( 

  out

  ); 

output	out;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  assign out = 1'b1;

`endif

endmodule 

