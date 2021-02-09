// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                            
// *****************************************************************************
//  Module Name :  c3lib_mux2_ctn                                  
//  Date        :  Fri Apr 29 16:30:04 2016                                 
//  Description :  2-to-1 clock mux w/ support fro scan
// *****************************************************************************

module c3lib_mux2_ctn(

  input  logic	ck0,
  input	 logic	ck1,
  input  logic	s0,
  output logic	ck_out

); 

  c3lib_ckmux4_lvt_gate c3lib_ckmux4_gate( 

    // Functional IOs
    .ck0	( ck0    ),
    .ck1	( ck1    ),
    .ck2	( 1'b0   ),
    .ck3	( 1'b0   ),
    .s0		( s0     ),
    .s1		( 1'b0   ),
    .ck_out	( ck_out ),

    // Scan IOs
    .tst_override	( 1'b0 ),
    .tst_s0		( 1'b0 ),
    .tst_s1		( 1'b0 )

  ); 

endmodule 

