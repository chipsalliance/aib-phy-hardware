// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                            
// *****************************************************************************
//  Module Name :  c3lib_tiel_lcell                                  
//  Date        :  Mon May  2 09:05:25 2016                                 
//  Description :  Tie LOW cell
// *****************************************************************************

module c3lib_tiel_lcell(

  output logic	out

); 

c3lib_tie0_svt_1x c3lib_tie0_svt_1x(

  .out	( out )

);

endmodule

