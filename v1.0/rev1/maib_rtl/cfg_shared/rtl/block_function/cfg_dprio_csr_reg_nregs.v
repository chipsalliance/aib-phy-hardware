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
module cfg_dprio_csr_reg_nregs 
#(
   parameter BINDEX            = 0,   // Base index
   parameter SEGMENT           = 0,   // CSR segment
   parameter DATA_WIDTH        = 16,  // Data width
   parameter NUM_EXTRA_CSR_REG = 1,   // Number of extra 16-bit register for CSR
   parameter CSR_OUT_NEG_FF_EN = 0,   // Enable negative FF on csr_out
   parameter SECTOR_ROW        = 0,
   parameter SECTOR_COL        = 0
 )
( 
input  wire                                    clk,          // clock
input  wire                                    csr_in,       // serial CSR in
input  wire                                    csr_en,       // CSR enable
input  wire                                    scan_shift_n, // ATPG scan shift control to gate of CSR output

output wire [DATA_WIDTH*NUM_EXTRA_CSR_REG-1:0] csr_reg,      // CRAM connecting to custom logic
output wire                                    csr_out       // serial CSR output
);

wire   [NUM_EXTRA_CSR_REG:0]         chain;
wire                                 csr_out_int;
reg                                  csr_out_reg;
wire                                 csr_en_int;
wire                                 csr_out_neg_bypass;

  // Backdoor access
  `ifdef TOP_SIM
  `include "cfg_csr_backdoor_access.vh"
  `endif

// Gated CSR output during ATPG scan shift
assign csr_en_int = csr_en & scan_shift_n;

// Generate number of required CSR bits
generate 
  genvar i;
  for (i=0; i < NUM_EXTRA_CSR_REG; i=i+1)
    begin: csr_reg_nregs
cfg_dprio_csr_reg_nbits  
 #(
   .DATA_WIDTH(DATA_WIDTH)
   ) csr_reg_nbits 
     (.clk (clk),
      .csr_in (chain[i]), 
      .csr_en (csr_en_int),
      .csr_out (chain[i+1]),
      .csr_reg (csr_reg[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i])
      );
    end
endgenerate

// Connecting the si and so
assign csr_out_int  = chain[NUM_EXTRA_CSR_REG];
assign chain[0]     = csr_in;

// Negative FF for csr_out
always @ (negedge clk)
  begin
    csr_out_reg <= csr_out_int;
  end

// Bypassing negative FF in scan_shift
assign csr_out_neg_bypass = (scan_shift_n == 1'b1) ? csr_out_reg : csr_out_int;

// csr_out assignment
assign csr_out = (CSR_OUT_NEG_FF_EN == 1) ? csr_out_neg_bypass : csr_out_int;

endmodule

