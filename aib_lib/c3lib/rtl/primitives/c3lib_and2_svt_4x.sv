// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_and2_svt_4x                                  
//  Date        :  Thu Sep 15 13:44:58 2016                                 
//  Description :  2-input AND gate (SVT, 4x drive strength)
// *****************************************************************************

module c3lib_and2_svt_4x( 

  in0,
  in1,
  out

  ); 

input		in0;
input		in1;
output		out;

  assign out = in0 & in1;

endmodule 

