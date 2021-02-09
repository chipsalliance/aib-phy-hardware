// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------

module aib_adaptrxdbi_rxdp (

   input  wire                  rst_n,
   input  wire                  clk,
   input  wire [79:0]		data_in,	
   input  wire                  dbi_en,		

   output wire [79:0]		data_out	 
   );

   wire [3:0] dbi_calc;
   reg  [79:0] last_din, dbi_data_out;

   assign data_out = dbi_en? dbi_data_out : data_in;
   assign dbi_calc = {data_in[79], data_in[59], data_in[39], data_in[19]};
   always @(posedge clk or negedge rst_n)
   begin
    if (!rst_n)
     begin
      dbi_data_out <= 80'h0;
     end
    else
      dbi_data_out <= {dbi_calc[3], {19{dbi_calc[3]}} ^ data_in[78:60], 
                       dbi_calc[2], {19{dbi_calc[2]}} ^ data_in[58:40], 
                       dbi_calc[1], {19{dbi_calc[1]}} ^ data_in[38:20], 
                       dbi_calc[0], {19{dbi_calc[0]}} ^ data_in[18:0]}; 
   end


endmodule
