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
module cfg_dprio_ctrl_reg_nregs 
#(
   parameter BINDEX              = 0,   // Base Index (starting offset for this segment)
   parameter SEGMENT             = 0,
   parameter DATA_WIDTH          = 16,  // Data width
   parameter ADDR_WIDTH          = 16,  // Address width
   parameter NUM_CTRL_REGS       = 10,  // Number of n-bit control registers
   parameter NUM_ATPG_SCAN_CHAIN = 1,   // Number of ATPG scan chains
   parameter SECTOR_ROW          = 0,
   parameter SECTOR_COL          = 0
 )
( 
input  wire                                 clk,              // clock
input  wire                                 write,            // write enable input
input  wire [ADDR_WIDTH-1:0]                reg_addr,         // address input
input  wire [ADDR_WIDTH*NUM_CTRL_REGS-1:0]  target_addr,      // hardwired address value
input  wire [DATA_WIDTH-1:0]                writedata,        // write data input
input  wire                                 hold_csr,         // Hold CSR value  
input  wire                                 gated_cram,       // Gating CRAM output
input  wire                                 dprio_sel,        // 1'b1=choose csr_in
                                                              // 1'b0=choose dprio_in
input  wire                                 pma_csr_test_dis, // Disable PMA CSR test
input  wire [(DATA_WIDTH/8)-1:0]            byte_en,          // Byte enable
input  wire                                 broadcast_en,     // Broadcast enable (controlled by extra CSR bit)
input  wire [NUM_ATPG_SCAN_CHAIN-1:0]       csr_chain_in,     // ATPG scan input

output wire [NUM_ATPG_SCAN_CHAIN-1:0]       csr_chain_out,    // ATPG scan output
output wire [DATA_WIDTH*NUM_CTRL_REGS-1:0]  user_dataout      // CRAM connecting to custom logic
);

wire   [NUM_CTRL_REGS-1:0]         chain_in;
wire   [NUM_CTRL_REGS-1:0]         chain_out;

localparam NUM_REG_PER_CHAIN = NUM_CTRL_REGS/NUM_ATPG_SCAN_CHAIN;

  // Backdoor access
  `ifdef TOP_SIM
  `include "cfg_dprio_backdoor_access.vh"
  `endif

generate 
  genvar i;
  for (i=0; i < NUM_CTRL_REGS; i=i+1)
    begin: ctrl_reg_nbits
      cfg_dprio_ctrl_reg_nbits  
       #(
          .DATA_WIDTH(DATA_WIDTH),
          .ADDR_WIDTH(ADDR_WIDTH)
        ) ctrl_reg_nbits 
         (.clk (clk),
          .write (write),
          .reg_addr (reg_addr),
          .target_addr (target_addr[ADDR_WIDTH*(i+1)-1:ADDR_WIDTH*i]),
          .writedata (writedata), 
          .csr_in (chain_in[i]), 
          .hold_csr (hold_csr), 
          .gated_cram (gated_cram),
          .dprio_sel (dprio_sel),
          .pma_csr_test_dis (pma_csr_test_dis),
          .byte_en (byte_en),
          .broadcast_en (broadcast_en),
          .sig_out (user_dataout[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]), 
          .csr_out (chain_out[i])
         );
    end
endgenerate

generate
genvar j;
// First chain input and last chain output connection
assign chain_in[0]                          = csr_chain_in[0];
assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-1] = chain_out[NUM_CTRL_REGS-1];

// Chain 1
for (j=1; j < NUM_REG_PER_CHAIN; j=j+1)
  begin: chain_connection_0
    assign chain_in[j] = chain_out[j-1];
  end

// Chain 2
if (NUM_ATPG_SCAN_CHAIN > 1)
  begin: CHAIN_1
   if (NUM_ATPG_SCAN_CHAIN == 2)
    for (j=NUM_REG_PER_CHAIN+1; j < NUM_CTRL_REGS; j=j+1)
      begin: chain_connection_1
        assign chain_in[j] = chain_out[j-1];
      end
   else // More than 2
    for (j=NUM_REG_PER_CHAIN+1; j < 2*NUM_REG_PER_CHAIN; j=j+1)
      begin: chain_connection_1
        assign chain_in[j] = chain_out[j-1];
      end

    assign chain_in[NUM_REG_PER_CHAIN] = csr_chain_in[1];
    assign csr_chain_out[0]            = chain_out[NUM_REG_PER_CHAIN-1];
  end

// Chain 3
if (NUM_ATPG_SCAN_CHAIN > 2)
  begin: CHAIN_2
   if (NUM_ATPG_SCAN_CHAIN == 3)
    for (j=2*NUM_REG_PER_CHAIN+1; j < NUM_CTRL_REGS; j=j+1)
      begin: chain_connection_2
        assign chain_in[j] = chain_out[j-1];
      end
   else // More than 3
    for (j=2*NUM_REG_PER_CHAIN+1; j < 3*NUM_REG_PER_CHAIN; j=j+1)
      begin: chain_connection_2
        assign chain_in[j] = chain_out[j-1];
      end

    assign chain_in[2*NUM_REG_PER_CHAIN] = csr_chain_in[2];
    assign csr_chain_out[1]            = chain_out[2*NUM_REG_PER_CHAIN-1];
  end

// Chain 4
if (NUM_ATPG_SCAN_CHAIN > 3)
  begin: CHAIN_3
   if (NUM_ATPG_SCAN_CHAIN == 4)
    for (j=3*NUM_REG_PER_CHAIN+1; j < NUM_CTRL_REGS; j=j+1)
      begin: chain_connection_3
        assign chain_in[j] = chain_out[j-1];
      end
   else // More than 4
    for (j=3*NUM_REG_PER_CHAIN+1; j < 4*NUM_REG_PER_CHAIN; j=j+1)
      begin: chain_connection_3
        assign chain_in[j] = chain_out[j-1];
      end

    assign chain_in[3*NUM_REG_PER_CHAIN] = csr_chain_in[3];
    assign csr_chain_out[2]            = chain_out[3*NUM_REG_PER_CHAIN-1];
  end

endgenerate

endmodule

