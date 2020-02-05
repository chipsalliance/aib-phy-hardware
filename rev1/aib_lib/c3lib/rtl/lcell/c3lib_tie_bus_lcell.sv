// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                             
// *****************************************************************************
//  Module Name :  c3lib_tie_bus_lcell                                  
//  Date        :  Mon May  2 09:20:22 2016                                 
//  Description :  Tie cells for 
// *****************************************************************************

module c3lib_tie_bus_lcell #(

  parameter TIE_VALUE = 4'b0011

) (

  output logic[ ($bits(TIE_VALUE) - 1) : 0 ]	out

); 

genvar i;

generate
  for( i=0; i < $bits(TIE_VALUE); i += 1) begin : TIE_BUS_FOR_LOOP

    if (TIE_VALUE[i]) begin : TIE_BUS_BIT_HIGH
      c3lib_tie1_svt_1x u_c3lib_tie1_svt_1x( .out	( out[i] ) );
    end

    else begin : TIE_BUS_BIT_LOW
      c3lib_tie0_svt_1x u_c3lib_tie0_svt_1x( .out	( out[i] ) );
    end

  end
endgenerate

endmodule 

