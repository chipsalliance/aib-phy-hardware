// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_nand2_lcell                                  
//  Date        :  Fri Apr 29 18:00:52 2016                                 
//  Description :  2-input NAND gate
// *****************************************************************************

module  c3lib_nand2_lcell(

  // Functional IOs
  input  logic	in0,
  input	 logic	in1,
  output logic	out

); 

c3lib_nand2_svt_2x u_c3lib_nand2_svt_2x(

  .in0	( in0 ),
  .in1	( in1 ),
  .out	( out )

);

endmodule 

