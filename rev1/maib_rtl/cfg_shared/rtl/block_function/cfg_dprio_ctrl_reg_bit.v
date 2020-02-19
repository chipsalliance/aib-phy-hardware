// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// v 2012 Altera Corporation. .
//
//****************************************************************************************

//************************************************************
// Description:
//
//************************************************************

module cfg_dprio_ctrl_reg_bit 
(
input  wire      clk,              // clock
input  wire      dprio_in,         // DPRIO input
input  wire      csr_in,           // serial input
input  wire      dprio_sel,        // 1'b1=choose csr_in
                                   // 1'b0=choose dprio_in
input  wire      bit_en,           // Write enable signal
input  wire      hold_csr,         // Hold CSR value
input  wire      gated_cram,       // Gating CRAM output
input  wire      pma_csr_test_dis, // Disable PMA CSR test

output wire      sig_out,          // CRAM output
output wire      csr_out           // csr output
);

wire             d_int;
wire             bit_en_int;
wire             d_wr_en;

// Enable bit_in during CSR shift
assign bit_en_int = (dprio_sel == 1'b1) ? 1'b1 : bit_en;

// Data in for combined DPRIO-CSR register
assign d_int = (pma_csr_test_dis == 1'b0) ? sig_out  :
               (dprio_sel == 1'b0)        ? dprio_in :
               (hold_csr == 1'b0)         ? csr_in   : csr_out;

// Combined DPRIO-CSR 1-bit register
//always @ (posedge clk)
//  if (bit_en_int)
//    begin
//      csr_out <= d_int;
//    end
assign d_wr_en = (bit_en_int == 1'b1) ? d_int : csr_out;
  cfg_cmn_non_scan_reg dprio_ns_reg (
    .din  (d_wr_en),
    .clk  (clk),
    .dout (csr_out)
  );

// CRAM output
assign sig_out = (gated_cram == 1'b1) ? csr_out : 1'b0;

endmodule
