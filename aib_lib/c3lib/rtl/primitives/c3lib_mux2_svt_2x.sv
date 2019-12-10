// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_mux2_svt_2x                                  
//  Date        :  Thu May 12 10:28:47 2016                                 
//  Description :  2-to-1 mux (SVT, 2x drive strength)
// *****************************************************************************

module  c3lib_mux2_svt_2x ( 

  in0,
  in1,
  sel,
  out

); 

input		in0;
input		in1;
input		sel;
output		out;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  var	logic	int_out;

  always_comb begin
    unique case ( sel )
      1'b0    : int_out = in0;
      1'b1    : int_out = in1;
      default : int_out = 1'bx;
    endcase
  end
  assign out = int_out;

`endif

endmodule 

