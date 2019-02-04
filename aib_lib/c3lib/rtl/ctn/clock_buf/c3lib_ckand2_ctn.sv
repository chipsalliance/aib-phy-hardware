// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckand2_ctn                                  
//  Date        :  Tue May  3 16:12:10 2016                                 
//  Description :                                                    
// *****************************************************************************

module c3lib_ckand2_ctn(

  input  logic	clk_in0,
  input	 logic	clk_in1,
  output logic	clk_out

); 

c3lib_and2_svt_4x u_c3lib_and2_svt_4x(

  .in0	( clk_in0 ),
  .in1	( clk_in1 ),
  .out	( clk_out )

);

endmodule 

