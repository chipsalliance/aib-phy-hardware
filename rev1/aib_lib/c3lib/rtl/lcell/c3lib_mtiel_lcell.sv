// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                            
// *****************************************************************************
//  Module Name :  c3lib_mtiel_lcell                                  
//  Date        :  Fri Feb 10 11:01:28 2017                                 
//  Description :  'Metal' tie LOW cell
// *****************************************************************************

module  c3lib_mtiel_lcell(

  output logic	out

); 

c3lib_mtie0_ds u_c3lib_mtie0_ds(

  .out	( out )

);

endmodule 

