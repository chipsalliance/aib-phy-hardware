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
module cfg_dprio_ctrl_reg_nbits 
#(
   parameter DATA_WIDTH = 16,  // Data width
   parameter ADDR_WIDTH = 16   // Address width
 )
( 
input  wire                      clk,              // clock
input  wire                      write,            // write enable input
input  wire [ADDR_WIDTH-1:0]     reg_addr,         // address input
input  wire [ADDR_WIDTH-1:0]     target_addr,      // hardwired address value
input  wire [DATA_WIDTH-1:0]     writedata,        // write data input
input  wire                      csr_in,           // serial CSR input
input  wire                      hold_csr,         // Hold CSR value  
input  wire                      gated_cram,       // Gating CRAM output
input  wire                      dprio_sel,        // 1'b1=choose csr_in
                                                   // 1'b0=choose dprio_in
input  wire                      pma_csr_test_dis, // Disable PMA CSR test
input  wire [(DATA_WIDTH/8)-1:0] byte_en,          // Byte enable
input  wire                      broadcast_en,     // Broadcast enable (controlled by extra CSR bit)

output wire [DATA_WIDTH-1:0]     sig_out,          // signal output
output wire                      csr_out           // serial CSR output
);

wire   [DATA_WIDTH-1:0]      signal_in_int;
wire   [DATA_WIDTH:0]        chain;
wire   [DATA_WIDTH-1:0]      byte_en_int;

// Data to ctrl_reg_bit
assign signal_in_int = (write && ((!broadcast_en && (reg_addr == target_addr)) || broadcast_en)) ? writedata : chain[DATA_WIDTH:1];

// Enable signals to ctrl_reg_bit
generate
  genvar i;
  for (i=0; i < (DATA_WIDTH/8); i=i+1)
    begin: byte_enable
      assign byte_en_int[(i*8)+7:(i*8)] = {8{byte_en[i]}};
    end
endgenerate

generate 
  genvar j;
  for (j=0; j < DATA_WIDTH; j=j+1)
    begin: ctrl_reg_bit
cfg_dprio_ctrl_reg_bit  ctrl_reg_bit (
                                       .clk (clk), 
                                       .dprio_in (signal_in_int[j]), 
                                       .csr_in (chain[j]), 
                                       .dprio_sel (dprio_sel),
                                       .bit_en (byte_en_int[j]),
                                       .hold_csr (hold_csr), 
                                       .gated_cram (gated_cram),
                                       .pma_csr_test_dis(pma_csr_test_dis),
                                       .sig_out (sig_out[j]), 
                                       .csr_out (chain[j+1])
                                      );
    end
endgenerate

// Connecting the csr_in and csr_out
assign csr_out  = chain[DATA_WIDTH];
assign chain[0] = csr_in;

endmodule

