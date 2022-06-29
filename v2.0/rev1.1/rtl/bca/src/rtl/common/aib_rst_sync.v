// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_rst_sync
  (
    input  clk,       // Destination clock of reset to be synced
    input  i_rst_n,   // Asynchronous reset input
    input  scan_mode, // Scan bypass for reset
    output sync_rst_n // Synchronized reset output
   
   );

wire prescan_sync_rst_n;

aib_bit_sync 
  #(.DWIDTH(1), .RESET_VAL(0)  ) 
i_sync_rst_n
  (
   .clk           (clk               ),
   .rst_n         (i_rst_n           ), 
   .data_in       (1'b1              ),
   .data_out      (prescan_sync_rst_n) 
   );

// Scan mux
dmux_cell rst_dmux_out(
.o  (sync_rst_n),         // Output
.d1 (i_rst_n),            // Data 1 (s=1)
.d2 (prescan_sync_rst_n), // Data 2 (s=0)
.s  (scan_mode)           // Data selection
);

endmodule // aib_rst_sync
