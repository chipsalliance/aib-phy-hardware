// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckmux4_lvt_gate                                  
//  Date        :  Thu May 12 10:44:58 2016                                 
//  Description :  4-to-1 clock mux w/ no scan support
// *****************************************************************************

module  c3lib_ckmux4_lvt_gate( 

  ck0,
  ck1,
  ck2,
  ck3,
  s0,
  s1,
  ck_out,

  // Scan IOs
  tst_override,
  tst_s0,
  tst_s1

); 

// Functional IOs
input		ck0;
input		ck1;
input		ck2;
input		ck3;
input		s0;
input		s1;
output		ck_out;

// Scan IOs
input		tst_override;
input		tst_s0;
input		tst_s1;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  var	logic	int_fp_ck_out;
  var	logic	int_tst_ck_out;
  var	logic	int_ck_out;

  always_comb begin
    unique case ( { s1, s0 } )
      2'b00   : int_fp_ck_out = ck0;
      2'b01   : int_fp_ck_out = ck1;
      2'b10   : int_fp_ck_out = ck2;
      2'b11   : int_fp_ck_out = ck3;
      default : int_fp_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_s1, tst_s0 } )
      2'b00   : int_tst_ck_out = ck0;
      2'b01   : int_tst_ck_out = ck1;
      2'b10   : int_tst_ck_out = ck2;
      2'b11   : int_tst_ck_out = ck3;
      default : int_tst_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_override } )
      1'b0    : int_ck_out = int_fp_ck_out;
      1'b1    : int_ck_out = int_tst_ck_out;
      default : int_ck_out = 1'bx;
    endcase
  end
  assign ck_out = int_ck_out;
`endif

endmodule 

