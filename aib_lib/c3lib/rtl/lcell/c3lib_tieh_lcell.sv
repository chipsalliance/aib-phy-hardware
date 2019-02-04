// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
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

