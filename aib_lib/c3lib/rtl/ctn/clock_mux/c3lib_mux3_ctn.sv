// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_mux3_ctn                                  
//  Date        :  Wed May  4 08:13:25 2016                                 
//  Description :  3-to-1 clock mux w/ support fro scan
// *****************************************************************************

module c3lib_mux3_ctn( 

  input  logic	ck0,
  input	 logic	ck1,
  input	 logic	ck2,
  input  logic	s0,
  input	 logic	s1,
  output logic	ck_out

); 

  c3lib_ckmux4_lvt_gate c3lib_ckmux4_gate( 

    // Functional IOs
    .ck0	( ck0    ),
    .ck1	( ck1    ),
    .ck2	( ck2    ),
    .ck3	( 1'bx   ),
    .s0		( s0     ),
    .s1		( s1     ),
    .ck_out	( ck_out ),

    // Scan IOs
    .tst_override	( 1'b0 ),
    .tst_s0		( 1'b0 ),
    .tst_s1		( 1'b0 )

  ); 

endmodule 

