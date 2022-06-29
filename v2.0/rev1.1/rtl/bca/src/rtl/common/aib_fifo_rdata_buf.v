// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_fifo_rdata_buf #(
parameter DWIDTH  = 80  // FIFO Input data width
)
(
// Output
output reg [DWIDTH-1:0] fifo_rdata_ff, 
// Input
input [DWIDTH-1:0] fifo_rdata,
input            rd_clk,
input            rd_rst_n
);


always @(posedge rd_clk or negedge rd_rst_n)
  begin
    if(!rd_rst_n)
      fifo_rdata_ff <= {DWIDTH{1'b0}};
    else
      fifo_rdata_ff <= fifo_rdata;
  end

endmodule // aib_fifo_rdata_buf
