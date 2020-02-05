// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                              
// *****************************************************************************
//  Module Name :  c3lib_ckg_posedge_ctn                                  
//  Date        :  Tue May  3 15:43:53 2016                                 
//  Description :  Clock gate (clk_en timed to rising edge of clk)
// *****************************************************************************

module c3lib_ckg_posedge_ctn(

  input  logic	tst_en,
  input  logic	clk_en,
  input  logic	clk,
  output logic	gated_clk

); 

c3lib_ckg_lvt_8x c3lib_ckg_lvt_8x(

  .tst_en	( tst_en    ),
  .clk_en	( clk_en    ),
  .clk		( clk       ),
  .gated_clk	( gated_clk )

); 

endmodule 

