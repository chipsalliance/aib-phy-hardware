// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_txfifo_rd_dpath #(
parameter DINW   = 320,
parameter DOUTW  = 80,
parameter DEPTH  = 16,
parameter DEPTH4 = DEPTH * 4
)
(
output  [DOUTW-1:0]           rdata_sync_ff,   // Read data synchronized
input   [DEPTH4-1:0]          fifo_rd_en,      // FIFO element selector
input   [DEPTH-1:0][DINW-1:0] fifo_data_async, // FIFO data
input                         rd_clk,          // FIFO read clock
input                         rd_rst_n         // FIFO read asynchronous reset
);

wire [DEPTH4-1:0][DOUTW-1:0] fifo_out_sel;
wire [DOUTW-1:0]            fifo_rdata;
wire [DEPTH4-1 :0][79:0]    fifo_dword_async;

genvar k;
generate
  for(k=0; k < DEPTH; k = k+1)
    begin: fifo_dword_async_gen
      assign fifo_dword_async[(4*k)]    = fifo_data_async[k][79:0];
      assign fifo_dword_async[(4*k)+1]  = fifo_data_async[k][159:80];
      assign fifo_dword_async[(4*k)+2]  = fifo_data_async[k][239:160];
      assign fifo_dword_async[(4*k)+3]  = fifo_data_async[k][319:240];
    end // block: fifo_dword_async_gen
endgenerate

generate 
  for(k=0; k < DEPTH4; k = k+1)
    begin: fifo_and_sel
      aib_fifo_and_sel #(.DWIDTH (DOUTW))
      aib_fifo_and_sel(
      // Outputs
      .fifo_out_sel (fifo_out_sel[k]),
      // Inputs
      .fifo_rd_en   (fifo_rd_en[k]),
      .fifo_rd_in   (fifo_dword_async[k][DOUTW-1:0])
      );
    end // fifo_and_sel
endgenerate


aib_fifo_rdata_ored #(
.DEPTH (DEPTH4),
.DWIDTH (DOUTW)
)
aib_fifo_rdata_ored(
// Output
.fifo_rdata (fifo_rdata[DOUTW-1:0]),
//Input
.fifo_out_sel (fifo_out_sel)
);

aib_fifo_rdata_buf #(
.DWIDTH (DOUTW)
)
aib_fifo_rdata_buf(
// outputs
.fifo_rdata_ff (rdata_sync_ff[DOUTW-1:0]),
// Inputs
.fifo_rdata    (fifo_rdata[DOUTW-1:0]),
.rd_clk        (rd_clk),
.rd_rst_n      (rd_rst_n)
);

endmodule // aib_txfifo_rd_dpath
