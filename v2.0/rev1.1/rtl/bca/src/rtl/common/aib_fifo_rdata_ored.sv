// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_fifo_rdata_ored #(
parameter DWIDTH  = 80,  // FIFO Input data width
parameter DEPTH    = 3   // FIFO Depth
)
(
// Output
output reg [DWIDTH-1:0] fifo_rdata, 
// Input
input [DEPTH-1:0][DWIDTH-1:0] fifo_out_sel
);

integer n;

always @(*) 
  begin
    fifo_rdata = {DWIDTH{1'b0}};
    for(n = 0; n < DEPTH; n = n + 1)
      begin
        fifo_rdata = fifo_rdata | fifo_out_sel[n];
      end
  end

endmodule // aib_fifo_rdata_ored
