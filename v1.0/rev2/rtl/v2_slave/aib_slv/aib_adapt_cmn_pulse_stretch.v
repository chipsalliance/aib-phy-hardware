// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//
//------------------------------------------------------------------------

module aib_adapt_cmn_pulse_stretch 
  #(
    parameter RESET_VAL = 'd0   // reset value
    )
  (
    input  wire         clk,         // clock
    input  wire         rst_n,       // async reset
    input  wire [2:0]   num_stages,  // number of stages required
    input  wire         data_in,     // data in
    output  reg         data_out     // stretched data out             
   );

   reg                  data_d1, data_d2, data_d3, data_d4;
   reg                  data_d5, data_d6, data_d7;
   reg                  data_out_comb;

   localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning
      
   always @* begin
      data_out_comb = data_in;
      
      case (num_stages)
        3'b000: data_out_comb = data_in;
        3'b001: data_out_comb = data_d1 | data_in;
        3'b010: data_out_comb = data_d2 | data_d1 | data_in;
        3'b011: data_out_comb = data_d3 | data_d2 | data_d1 | data_in;
        3'b100: data_out_comb = data_d4 | data_d3 | data_d2 | data_d1 | data_in;
        3'b101: data_out_comb = data_d5 | data_d4 | data_d3 | data_d2 | data_d1 | data_in;
        3'b110: data_out_comb = data_d6 | data_d5 | data_d4 | data_d3 | data_d2 | data_d1 | data_in;
        3'b111: data_out_comb = data_d7 | data_d6 | data_d5 | data_d4 | data_d3 | data_d2 | data_d1 | data_in;
        default: data_out_comb = data_in;
      endcase // case(num_stages)
   end // always @ *

   always @(negedge rst_n or posedge clk) begin
      if (~rst_n) begin
         data_d1 <= reset_value;
         data_d2 <= reset_value;
         data_d3 <= reset_value;
         data_d4 <= reset_value;
         data_d5 <= reset_value;
         data_d6 <= reset_value;
         data_d7 <= reset_value;
         data_out <= reset_value;
      end
      else begin
         data_d1 <= data_in;
         data_d2 <= data_d1;
         data_d3 <= data_d2;
         data_d4 <= data_d3;
         data_d5 <= data_d4;
         data_d6 <= data_d5;
         data_d7 <= data_d6;
         data_out <= data_out_comb;
      end
   end // always @ (negedge rst_n or posedge clk)
      
endmodule 
