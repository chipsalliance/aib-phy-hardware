// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckinv_lvt_12x                                  
//  Date        :  Thu May 12 10:45:08 2016                                 
//  Description :  Clock inverter (LVT, 12x drive strength)
// *****************************************************************************

module c3lib_ckinv_lvt_12x(

  in,
  out

  ); 

input		in;
output		out;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else
  assign out = ~in;
`endif

endmodule 

