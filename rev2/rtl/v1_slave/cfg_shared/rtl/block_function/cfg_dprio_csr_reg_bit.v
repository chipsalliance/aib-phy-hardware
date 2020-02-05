// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//************************************************************
// Description:
//
//************************************************************

module cfg_dprio_csr_reg_bit 
(
input  wire      clk,        // clock
input  wire      csr_in,     // CSR serial input
input  wire      csr_en,     // CSR enable
output wire      csr_out,    // Gated CSR serial output
output wire      csr_chain   // Output to connect to CSR chain
);

//reg              csr_reg;
wire             csr_reg;

// Gated CSR output
assign csr_out = (csr_en == 1'b1) ? csr_reg : 1'b0;

// Output to connect to the chain
assign csr_chain = csr_reg;

// DPRIO 1-bit register
//always @ (posedge clk)
//  begin
//    csr_reg <= csr_in;
//  end
  cfg_cmn_non_scan_reg csr_ns_reg (
    .din  (csr_in),
    .clk  (clk),
    .dout (csr_reg)
  );

endmodule

