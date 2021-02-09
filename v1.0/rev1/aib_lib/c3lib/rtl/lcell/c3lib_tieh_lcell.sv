// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                      
// *****************************************************************************
//  Module Name :  c3lib_tieh_lcell                                  
//  Date        :  Mon May  2 09:05:28 2016                                 
//  Description :  Tie HIGH cell
// *****************************************************************************

module  c3lib_tieh_lcell(

  output logic	out

); 

c3lib_tie1_svt_1x c3lib_tie1_svt_1x(

  .out	( out )

);

endmodule 

