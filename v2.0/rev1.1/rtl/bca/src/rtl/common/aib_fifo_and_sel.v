// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_fifo_and_sel #(
parameter DWIDTH = 80
)
(
output [DWIDTH-1:0] fifo_out_sel, // FIFO output ANDed with read enable
input               fifo_rd_en,   // FIFO read enable
input  [DWIDTH-1:0] fifo_rd_in    // FIFO data in write domain
);

// AND logic selects the asynchronous bus only when data is stable
assign fifo_out_sel = fifo_rd_in[DWIDTH-1:0] & {DWIDTH{fifo_rd_en}};

endmodule // aib_fifo_and_sel
