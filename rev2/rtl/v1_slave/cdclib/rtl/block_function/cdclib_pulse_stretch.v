// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hd_pcs10g_pulse_stretch.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2014/08/24 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module cdclib_pulse_stretch 
   #(
      parameter RESET_VAL        = 0, // Reset value 
      parameter HIGH_PULSE       = 1  // High or low pulse
    )
  (
    input  wire         clk,         // clock
    input  wire         rst_n,       // async reset
    input  wire [1:0]   r_num_stages,  // number of stages required
    input  wire         data_in,     // data in
    output  reg         data_out     // stretched data out             
   );

   wire                         reset_value;
   assign reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning

   reg                  data_d1, data_d2, data_d3, data_d4;
   reg                  data_out_comb;
      
   always @* begin
      data_out_comb = data_in;
      
      case (r_num_stages)
        2'b00: data_out_comb = data_in;
        2'b01: data_out_comb = HIGH_PULSE ? data_d1 | data_in : data_d1 & data_in;
        2'b10: data_out_comb = HIGH_PULSE ? data_d2 | data_d1 | data_in : data_d2 & data_d1 & data_in ;
        2'b11: data_out_comb = HIGH_PULSE ? data_d3 | data_d2 | data_d1 | data_in : data_d3 & data_d2 & data_d1 & data_in;
        default: data_out_comb = data_in;
      endcase // case(r_num_stages)
   end // always @ *

   always @(negedge rst_n or posedge clk) begin
      if (~rst_n) begin
         data_d1 <= reset_value;
         data_d2 <= reset_value;
         data_d3 <= reset_value;
         data_d4 <= reset_value;
         data_out <= reset_value;
      end
      else begin
         data_d1 <= data_in;
         data_d2 <= data_d1;
         data_d3 <= data_d2;
         data_d4 <= data_d3;
         data_out <= data_out_comb;
      end
   end // always @ (negedge rst_n or posedge clk)
      
endmodule // cdclib_pulse_stretch
