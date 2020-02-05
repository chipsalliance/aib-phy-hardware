// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                           
// *****************************************************************************
//  Module Name :  c3lib_buf_lcell                                  
//  Date        :  Tue May  3 10:07:30 2016                                 
//  Description :                                                    
// *****************************************************************************

module c3lib_buf_lcell(

  input	 logic	in,
  output logic	out

); 

c3lib_buf_svt_4x u_c3lib_buf_svt_4x( 

  .in	( in  ),
  .out	( out )

); 

endmodule 

