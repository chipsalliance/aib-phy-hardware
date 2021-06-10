// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:6/10/2020 Check Chapter 2.2.4 of AIB 2.0 Specification for the following implementation. 
// https://github.com/chipsalliance/AIB-specification/blob/master/AIB_Specification%202_0.pdf       
//------------------------------------------------------------------------

//The purpose of the DBI is for less signal switching at DDR pin.
module aib_adapttxdbi_txdp (

   input  wire                  rst_n,
   input  wire                  clk,
   input  wire [79:0]		data_in,	
   input  wire                  dbi_en,		

   output wire [79:0]           data_out	 
   );

   wire [3:0]  dbi_calc;   //dbi_calc[1:0] takes DDR data pin TX[19], dbi_calc[3:2] takes DDR data pin TX[39]
   reg  [79:0] dbi_data_out, next_dbi_data_out;

   assign data_out = dbi_en? dbi_data_out : data_in;

   wire [39:0] idat0, idat1, data_out0, data_out1;
   wire [39:0] prev_dat0, prev_dat1; 
   wire [37:0] dbi_dat_lo, dbi_dat_hi;

   genvar i;
   generate
      for (i=0; i<40; i=i+1) begin:data_in_gen
         assign idat0[i] = data_in[2*i];              //Even data group 78, 76, 74 ..0;
         assign idat1[i] = data_in[2*i+1];            //Odd  data group 79, 77, 75 ..1;

         assign prev_dat0[i] = next_dbi_data_out[2*i];  //Prev Even data group. Used for get dbi[1] and dib[3] calculation
         assign prev_dat1[i] = dbi_data_out[2*i+1];     //Prev Odd  data group. Used for get dbi[0] and dib[2] calculation
      end
   endgenerate

   assign dbi_calc = {dbi_value(idat1[38:20], prev_dat0[38:20]), dbi_value(idat0[38:20], prev_dat1[38:20]),
                      dbi_value(idat1[18:0],  prev_dat0[18:0]),  dbi_value(idat0[18:0],  prev_dat1[18:0])};
   genvar j;
   generate
   for (j=0; j<19; j=j+1) begin:data_out_gen
      assign dbi_dat_lo[2*j]   = idat0[j]^dbi_calc[0];
      assign dbi_dat_lo[2*j+1] = idat1[j]^dbi_calc[1];
      assign dbi_dat_hi[2*j]   = idat0[j+20]^dbi_calc[2];
      assign dbi_dat_hi[2*j+1] = idat1[j+20]^dbi_calc[3];
   end
   endgenerate

   assign next_dbi_data_out = {dbi_calc[3:2], dbi_dat_hi,
                               dbi_calc[1:0], dbi_dat_lo};
   always @(posedge clk or negedge rst_n)
   begin
    if (!rst_n)
     begin
      dbi_data_out <= 80'h0;
     end
    else
      dbi_data_out <= next_dbi_data_out;
   end

   function  dbi_value (
      input [18:0] cur_d,                 
      input [18:0] prv_d); 
      integer          i;
      reg [4:0] tmp;
      reg [18:0] dbi_bit;

      tmp = 5'd0;
      for (i=0; i<19; i=i+1) begin
         dbi_bit[i] = cur_d[i] ^ prv_d[i]; 
         tmp = tmp + dbi_bit[i];
      end
      dbi_value = (tmp > 9) ? 1 : 0;

   endfunction


endmodule
