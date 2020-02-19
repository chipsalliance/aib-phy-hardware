// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module cfg_bead_bus
 #(
    parameter FW_BEAD_LENGTH = 8,
    parameter RV_BEAD_LENGTH = 8,
    parameter FW_NEG_REG     = 1,
    parameter RV_NEG_REG     = 0,
    parameter BBUS_CHAIN     = 0,
    parameter BBUS_BINDEX    = 0,
    parameter SECTOR_ROW     = 0,
    parameter SECTOR_COL     = 0
  )
  (
    // Bead interface on forward path
    input wire                   scan_clk_in_fw,
    input wire                   scan_data_in_fw,
    input wire                   capture_in_fw,
    input wire                   update_in_fw,
    input wire                   clr_n_in_fw,

    // Bead interface on reverse path
    input wire                   scan_clk_in_rv,
    input wire                   scan_data_in_rv,
    input wire                   capture_in_rv,
    input wire                   update_in_rv,
    input wire                   clr_n_in_rv,

    // Bead interface on forward path
    output wire                  scan_clk_out_fw,
    output wire                  scan_data_out_fw,
    output wire                  capture_out_fw,
    output wire                  update_out_fw,
    output wire                  clr_n_out_fw,

    // Bead interface on reverse path
    output wire                  scan_clk_out_rv,
    output wire                  scan_data_out_rv,
    output wire                  capture_out_rv,
    output wire                  update_out_rv,
    output wire                  clr_n_out_rv,

    // BEAD_CFG_IF on forward path
    output wire [FW_BEAD_LENGTH-1:0]    bead_val_fw,
    output wire [RV_BEAD_LENGTH:0]      bead_val_rv
  );

  wire [FW_BEAD_LENGTH:0]      scan_data_int_fw;
  wire [RV_BEAD_LENGTH:0]      scan_data_int_rv;

  reg scan_data_out_neg_fw;
  reg scan_data_out_neg_rv;

  // Backdoor access
  `ifdef TOP_SIM
  `include "cfg_bead_backdoor_access.vh"
  `endif

  generate
    genvar h;
    if (FW_BEAD_LENGTH >= 1)
      begin: assign_fw
         assign scan_clk_out_fw = scan_clk_in_fw;
         assign capture_out_fw  = capture_in_fw;
         assign update_out_fw   = update_in_fw;
         assign clr_n_out_fw    = clr_n_in_fw;

         assign scan_data_int_fw[0] = scan_data_in_fw;
      end

    for (h=0; h<FW_BEAD_LENGTH; h=h+1)
      begin: bead_fw
        cfg_bead cfg_bead_fw
          (
            .scan_clk_in(scan_clk_in_fw),
            .scan_data_in(scan_data_int_fw[h]),
            .capture_in(capture_in_fw),
            .update_in(update_in_fw),
            .clr_n_in(clr_n_in_fw),
            .scan_data_out(scan_data_int_fw[h+1]),
            .bead_val(bead_val_fw[h])
          );
      end
  endgenerate

  generate
    if (RV_BEAD_LENGTH >= 1)
      begin: assign_rv
         assign scan_clk_out_rv = scan_clk_in_rv;
         assign capture_out_rv  = capture_in_rv;
         assign update_out_rv   = update_in_rv;
         assign clr_n_out_rv    = clr_n_in_rv;

         assign scan_data_int_rv[0]         = scan_data_in_rv;
         assign bead_val_rv[RV_BEAD_LENGTH] = 1'b0;
      end
    else
      begin: tied_off_rv
         assign scan_clk_out_rv = 1'b0;
         assign capture_out_rv  = 1'b0;
         assign update_out_rv   = 1'b0;
         assign clr_n_out_rv    = 1'b1;

         assign scan_data_int_rv[0] = 1'b0;
         assign bead_val_rv[0]      = 1'b0;
      end
  endgenerate

  generate
    genvar i;
    for (i=0; i<RV_BEAD_LENGTH; i=i+1)
      begin: bead_rv
        cfg_bead cfg_bead_rv
          (
            .scan_clk_in(scan_clk_in_rv),
            .scan_data_in(scan_data_int_rv[i]),
            .capture_in(capture_in_rv),
            .update_in(update_in_rv),
            .clr_n_in(clr_n_in_rv),
            .scan_data_out(scan_data_int_rv[i+1]),
            .bead_val(bead_val_rv[i])
          );
      end
  endgenerate

  generate
    if (FW_NEG_REG == 1)
      begin: neg_reg_fw
        always @(negedge scan_clk_in_fw)
          scan_data_out_neg_fw <= scan_data_int_fw[FW_BEAD_LENGTH];

        assign scan_data_out_fw = scan_data_out_neg_fw;
      end
    else
      assign scan_data_out_fw = scan_data_int_fw[FW_BEAD_LENGTH];
  endgenerate

  generate
    if (RV_NEG_REG == 1)
      begin: neg_reg_rv
        always @(negedge scan_clk_in_rv)
          scan_data_out_neg_rv <= scan_data_int_rv[RV_BEAD_LENGTH];

        assign scan_data_out_rv = scan_data_out_neg_rv;
      end
    else
      assign scan_data_out_rv = scan_data_int_rv[RV_BEAD_LENGTH];
  endgenerate

endmodule // cfg_bead_bus
