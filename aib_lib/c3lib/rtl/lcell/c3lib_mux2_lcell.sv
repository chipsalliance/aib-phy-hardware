// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_mux2_lcell                                  
//  Date        :  Fri Apr 29 18:13:05 2016                                 
//  Description :  2-1 mux
// *****************************************************************************

module  c3lib_mux2_lcell( 

  input  logic	in0,
  input	 logic	in1,
  input  logic	sel,
  output logic	out

); 

c3lib_mux2_svt_2x u_c3lib_mux2_svt_2x( 

  .in0	( in0 ),
  .in1	( in1 ),
  .sel	( sel ),
  .out	( out )

);

endmodule 

