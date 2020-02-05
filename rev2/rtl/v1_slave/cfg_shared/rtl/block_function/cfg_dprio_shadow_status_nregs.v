// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//************************************************************
// Description:
//
// Shadow status registers used in user logic to send status
// to DPRIO
//************************************************************

module cfg_dprio_shadow_status_nregs 
#(
   parameter DATA_WIDTH        = 16,  // Data width
   parameter NUM_STATUS_REGS   = 5,   // Number of n-bit status registers
   parameter CLK_FREQ_MHZ      = 250,  // Clock freq in MHz
   parameter TOGGLE_TYPE = 1,
   parameter VID = 1
 )
(
input  wire [NUM_STATUS_REGS-1:0]             rst_n,         // reset
input  wire [NUM_STATUS_REGS-1:0]             clk,           // clock
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0]  stat_data_in,  // status data input
input  wire [NUM_STATUS_REGS-1:0]             write_en,      // write data enable from DPRIO

output wire [NUM_STATUS_REGS-1:0]             write_en_ack,  // write data enable acknowlege to DPRIO
output wire [DATA_WIDTH*NUM_STATUS_REGS-1:0]  stat_data_out  // status data output
);

generate 
  genvar i;
  for (i=0; i < NUM_STATUS_REGS; i=i+1)
    begin: shadow_status_nregs
      cfg_dprio_shadow_status_regs 
        #(
           .DATA_WIDTH(DATA_WIDTH),  // Data width
           .CLK_FREQ_MHZ(CLK_FREQ_MHZ),
           .TOGGLE_TYPE(TOGGLE_TYPE),
           .VID(VID)
         ) cfg_dprio_shadow_status_regs
         (
          .rst_n         (rst_n[i]),                                       // reset
          .clk           (clk[i]),                                         // clock
          .stat_data_in  (stat_data_in[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),  // status data input
          .write_en      (write_en[i]),                                    // write data enable
          .write_en_ack  (write_en_ack[i]),                                // write data enable acknowlege
          .stat_data_out (stat_data_out[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i])  // status data output
         );
  end
endgenerate

endmodule
