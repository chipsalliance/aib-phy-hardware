// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                           
// *****************************************************************************
//  Module Name :  c3lib_dff_scan_lcell                                  
//  Date        :  Wed Aug 31 15:13:49 2016                                 
//  Description :                                                    
// *****************************************************************************

module c3lib_dff_scan_lcell( 

  clk, 
  rst_n, 
  data_in,
  data_out,

  scan_in,
  scan_en

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;

input		scan_in;
input		scan_en;

  c3lib_dff0_scan_reset_svt_2x u_c3lib_dff0_scan_reset_svt_2x( 

    .data_in	( data_in  ),
    .clk	( clk      ),
    .data_out	( data_out ),
    .rst_n	( rst_n    ),
    .scan_en	( scan_en  ),
    .scan_in	( scan_in  )

  );

endmodule 

