// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
//
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
  clock_inv u_clock_inv (.out(out), .in(in));
`endif

endmodule 

