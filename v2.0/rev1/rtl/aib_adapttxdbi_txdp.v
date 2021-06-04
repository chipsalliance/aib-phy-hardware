// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------

module aib_adapttxdbi_txdp (

   input  wire                  rst_n,
   input  wire                  clk,
   input  wire [79:0]		data_in,	
   input  wire                  dbi_en,		

   output wire [79:0]           data_out	 
   );

   wire [3:0]  dbi_calc;
   wire [79:0] last_din;
   reg  [79:0] dbi_data_out;
   assign last_din = data_out;

   assign data_out = dbi_en? dbi_data_out : data_in;
   assign dbi_calc = {dbi_value(data_in[77:59], last_din[77:59]), dbi_value(data_in[58:40], last_din[58:40]),
                      dbi_value(data_in[37:19], last_din[37:19]), dbi_value(data_in[18:0],  last_din[18:0])};
   always @(posedge clk or negedge rst_n)
   begin
    if (!rst_n)
     begin
      dbi_data_out <= 80'h0;
     end
    else
      dbi_data_out <= {dbi_calc[3:2], {19{dbi_calc[3]}} ^ data_in[77:59], 
                                      {19{dbi_calc[2]}} ^ data_in[58:40], 
                       dbi_calc[1:0], {19{dbi_calc[1]}} ^ data_in[37:19], 
                                      {19{dbi_calc[0]}} ^ data_in[18:0]}; 
   end

   function  dbi_value (
      input [18:0] cur_d,                 
      input [18:0] prv_d); 
      integer          i;
      reg [4:0] tmp;
      reg [18:0] dbi_bit;

      tmp = 5'd0;
      for (i='d0; i<18; i=i+1'b1) begin
         dbi_bit[i] = cur_d[i] ^ prv_d[i]; 
         tmp = tmp + dbi_bit[i];
      end
      dbi_value = (tmp > 9) ? 1 : 0;

   endfunction


endmodule
