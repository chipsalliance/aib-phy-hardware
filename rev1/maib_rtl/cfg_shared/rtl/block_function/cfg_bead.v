// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module cfg_bead
  (
    // Bead interface
    input wire                   scan_clk_in,
    input wire                   scan_data_in,
    input wire                   capture_in,
    input wire                   update_in,
    input wire                   clr_n_in,

    // Bead interface
    output wire                  scan_data_out,

    // BEAD_CFG_IF
    output wire                  bead_val
  );

  wire                   bead_val_int;
  wire                   scan_reg_in_int;
  wire                   bead_in_int;

  assign bead_val_int = bead_val | clr_n_in;
  assign scan_reg_in_int = (capture_in)? bead_val_int : scan_data_in;
  assign bead_in_int = scan_data_out & clr_n_in;

  // Non resettablei & non scannable reg
//  always @(posedge scan_clk_in)
//    scan_data_out <= scan_reg_in_int;
  cfg_cmn_non_scan_reg bead_ns_reg (
    .din  (scan_reg_in_int),
    .clk  (scan_clk_in),
    .dout (scan_data_out)
  );

  // Non resettable latch
//  always @(*)
//    if (update_in)
//      bead_val <= bead_in_int;
  cfg_cmn_latch bead_latch (
    .din (bead_in_int),
    .clk (update_in),
    .dout(bead_val)
  );

endmodule // cfg_bead
