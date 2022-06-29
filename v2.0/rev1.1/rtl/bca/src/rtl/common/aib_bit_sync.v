// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_bit_sync
  #(
    parameter DWIDTH = 1'b1,    // Sync Data input
    parameter [DWIDTH-1:0] RESET_VAL = {DWIDTH{1'b0}}  // Reset value
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );

   reg [DWIDTH-1:0]  dff2;
   reg [DWIDTH-1:0]  dff1;

   always @(posedge clk or negedge rst_n)
      if (!rst_n) begin
         dff2     <= RESET_VAL; 
         dff1     <= RESET_VAL; 
      end
      else begin
         dff2     <= dff1;
         dff1     <= data_in;
      end

   assign data_out = dff2;


endmodule // aib_bit_sync

