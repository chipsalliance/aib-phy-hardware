// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//*****************************************************************
// Description:
//
//*****************************************************************
module cfg_dprio_csr_reg_nbits 
#(
   parameter DATA_WIDTH = 16  // Data width
 )
( 
input  wire                      clk,        // clock
input  wire                      csr_in,     // CSR serial in
input  wire                      csr_en,     // CSR enable  
output wire                      csr_out,    // CSR serial output
output wire [DATA_WIDTH-1:0]     csr_reg     // CSR output to DPRIO
);

wire   [DATA_WIDTH:0]        chain;

generate 
  genvar i;
  for (i=0; i < DATA_WIDTH; i=i+1)
    begin: csr_reg_bit
cfg_dprio_csr_reg_bit  csr_reg_bit (
                                   .clk (clk),
                                   .csr_in (chain[i]),
                                   .csr_en (csr_en), 
                                   .csr_chain (chain[i+1]),
                                   .csr_out (csr_reg[i])
                                  );
    end
endgenerate

// Connecting the csr_in and csr_out
assign csr_out  = chain[DATA_WIDTH];
assign chain[0] = csr_in;

endmodule
