// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_tie0_svt_1x                                  
//  Date        :  Thu May 12 08:55:31 2016                                 
//  Description :  Tie LOW cell
// *****************************************************************************

module c3lib_tie0_svt_1x( 

  out

  ); 

output	out;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  assign out = 1'b0;

`endif
endmodule 

