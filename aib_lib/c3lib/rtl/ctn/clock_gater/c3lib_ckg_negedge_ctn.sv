// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckg_negedge_ctn                                  
//  Date        :  Tue May  3 16:34:28 2016                                 
//  Description :                                                    
// *****************************************************************************

module c3lib_ckg_negedge_ctn( 

  input  logic	tst_en,
  input  logic	clk_en,
  input  logic	clk,
  output logic	gated_clk

); 

var	logic	inv_clk;
var	logic	inv_gated_clk;

c3lib_ckinv_svt_8x u_c3lib_ckinv_svt_8x(

  .in	( clk     ),
  .out	( inv_clk )

); 

c3lib_ckg_lvt_8x u_c3lib_ckg_lvt_8x(

  .tst_en	( tst_en        ),
  .clk_en	( clk_en        ),
  .clk		( inv_clk       ),
  .gated_clk	( inv_gated_clk )

); 

c3lib_ckinv_svt_8x u_gated_clk_c3lib_ckinv_svt_8x(

  .in	( inv_gated_clk ),
  .out	( gated_clk     )

); 

endmodule 

