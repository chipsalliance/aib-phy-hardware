// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_rxfifo_rd_dpath #(
parameter DWIDTH  = 320,
parameter DEPTH   = 16,
parameter DEPTH4  = DEPTH*4
)
(
output  [DWIDTH-1:0] rdata_sync_ff, // Read data synchronized
input   [DEPTH4-1:0] fifo_rd_en,    // FIFO element selector
input   [1:0]        r_fifo_mode,   // FIFO mode
input                m_gen2_mode,   // Gen2 mode
input   [DEPTH-1 :0][DWIDTH-1:0] fifo_data_async, // FIFO data
input                rd_clk,        // FIFO read clock
input                rd_rst_n       // FIFO read asynchronous reset
);

wire [DEPTH4-1:0][79:0] fifo_out_sel;
wire [DEPTH4-1 :0][79:0]   fifo_dword_async;
wire [DWIDTH-1:0] fifo_rdata;



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
      aib_fifo_and_sel #(.DWIDTH (80))
      aib_fifo_and_sel(
      // Outputs
      .fifo_out_sel (fifo_out_sel[k]),
      // Inputs
      .fifo_rd_en   (fifo_rd_en[k]),
      .fifo_rd_in   (fifo_dword_async[k][80-1:0])
      );
    end // fifo_and_sel
endgenerate

aib_rxfifo_rdata_sel #(
.DEPTH (DEPTH),
.DWIDTH (DWIDTH)
)
aib_rxfifo_rdata_sel(
// Output
.fifo_rdata (fifo_rdata[DWIDTH-1:0]),
//Input
.r_fifo_mode  (r_fifo_mode[1:0]),       // FIFO mode
.m_gen2_mode  (m_gen2_mode),            // GEN2 mode
.fifo_out_sel (fifo_out_sel)
);

aib_fifo_rdata_buf #(
.DWIDTH (DWIDTH)
)
aib_fifo_rdata_buf(
// outputs
.fifo_rdata_ff (rdata_sync_ff[DWIDTH-1:0]),
// Inputs
.fifo_rdata    (fifo_rdata[DWIDTH-1:0]),
.rd_clk        (rd_clk),
.rd_rst_n      (rd_rst_n)
);

endmodule // aib_rxfifo_rd_dpath
