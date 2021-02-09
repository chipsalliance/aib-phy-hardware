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
module cfg_dprio_status_reg_nregs 
#(
   parameter DATA_WIDTH      = 16,  // Data width
   parameter ADDR_WIDTH      = 16,  // Address width
   parameter NUM_STATUS_REGS = 10,  // Number of n-bit status registers
   parameter BYPASS_STAT_SYNC= 0,   // Parameter to bypass the Synchronization SM in case of individual status bits   
   parameter CLK_FREQ_MHZ    = 250,  // Clock freq in MHz
   parameter TOGGLE_TYPE     = 1,
   parameter VID             = 1
 )
( 
input  wire                                  rst_n,        // reset
input  wire                                  clk,          // clock
input  wire                                  read,         // read enable input
input  wire [ADDR_WIDTH-1:0]                 reg_addr,     // address input
input  wire [ADDR_WIDTH*NUM_STATUS_REGS-1:0] target_addr,  // hardwired address value
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0] user_datain,  // status from custom logic
input  wire [NUM_STATUS_REGS-1:0]            write_en_ack, // write data acknowlege from user logic

output wire [NUM_STATUS_REGS-1:0]            write_en,     // write data enable to user logic
output wire [DATA_WIDTH*NUM_STATUS_REGS-1:0] user_readdata // status register outputs
);

wire [DATA_WIDTH*NUM_STATUS_REGS-1:0] user_datain_int;     // status from custom logic

generate
genvar i;
  for (i=0; i < NUM_STATUS_REGS; i=i+1)
  begin: stat_reg_nbits
// Status register synchronizers
cfg_dprio_status_sync_regs 
#(
   .DATA_WIDTH(DATA_WIDTH),             // Data width
   .BYPASS_STAT_SYNC(BYPASS_STAT_SYNC), // Parameter to bypass the Synchronization SM in case of individual status bits
   .CLK_FREQ_MHZ (CLK_FREQ_MHZ),
   .TOGGLE_TYPE(TOGGLE_TYPE),
   .VID(VID)
 ) cfg_dprio_status_sync_regs
(
 .rst_n(rst_n),                                                    // reset
 .clk(clk),                                                        // clock
 .stat_data_in(user_datain[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),      // status data input
 .write_en_ack(write_en_ack[i]),                                   // write data acknowlege from user logic
 .write_en(write_en[i]),                                           // write data enable to user logic
 .stat_data_out(user_datain_int[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i])  // status data output
);

// Status register for reading
  cfg_dprio_status_reg_nbits 
#(
   .DATA_WIDTH(DATA_WIDTH),  // Data width
   .ADDR_WIDTH(ADDR_WIDTH)   // Address width
 ) cfg_dprio_status_reg_nbits
( 
 .rst_n(rst_n),                                                 // reset
 .clk(clk),                                                     // clock
 .read(read),                                                   // read enable input
 .reg_addr(reg_addr),                                           // address input
 .target_addr(target_addr[ADDR_WIDTH*(i+1)-1:ADDR_WIDTH*i]),    // hardwired address value
 .user_datain(user_datain_int[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),// status from custom logic

 .user_readdata(user_readdata[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]) // status register outputs
);
  end


endgenerate

endmodule
