// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: GTIE Generator
// 
// GTIE Generator takes a width and a constant values, and generates
// the necessary GTIEH and GTIEL instances to match.
// 
//------------------------------------------------------------------------


module altr_hps_gtie_generator #(
        parameter TIE_WIDTH = 1,
        parameter [TIE_WIDTH-1:0] TIE_VALUE = 'd0
    ) ( 
        output wire  [TIE_WIDTH-1 : 0] z_out     // output
    );
    genvar i;
    generate for(i = 0; i < TIE_WIDTH; i = i + 1) begin : gtie
        
        if (TIE_VALUE[i] == 1'b1) begin
            // tie high
            altr_hps_gtieh u_gtieh (
               .z_out (z_out[i])
            );                      
        end else begin
            // tie low
            altr_hps_gtiel u_gtiel (
               .z_out (z_out[i])
            );
        
        end // if
      end // for
           
    endgenerate // generate

endmodule // altr_hps_gtie_generator
