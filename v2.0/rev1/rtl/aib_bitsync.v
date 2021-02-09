// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_bitsync
  #(
    parameter DWIDTH = 1'b1,    // Sync Data input
    parameter RESET_VAL = 1'b0  // Reset value
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );


   // End users may pass in RESET_VAL with a width exceeding 1 bit
   // Evaluate the value first and use 1 bit value
   localparam RESET_VAL_1B = (RESET_VAL == 'd0) ? 1'b0 : 1'b1;

   reg [DWIDTH-1:0]  dff2;
   reg [DWIDTH-1:0]  dff1;

   always @(posedge clk or negedge rst_n)
      if (!rst_n) begin
         dff2     <= {DWIDTH{RESET_VAL_1B}}; 
         dff1     <= {DWIDTH{RESET_VAL_1B}}; 
      end
      else begin
         dff2     <= dff1;
         dff1     <= data_in;
      end

   assign data_out = dff2;


endmodule // aib_bitsync

