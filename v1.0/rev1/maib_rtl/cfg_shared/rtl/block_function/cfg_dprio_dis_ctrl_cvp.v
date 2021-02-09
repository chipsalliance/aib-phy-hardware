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

module cfg_dprio_dis_ctrl_cvp
#(
   parameter CLK_FREQ_MHZ = 250, // Clock freq in MHz
   parameter TOGGLE_TYPE = 1,
   parameter VID = 1
 )
(
input  wire      rst_n,         // reset
input  wire      clk,           // clock
input  wire      dprio_dis_in,  // dprio_dis in
input  wire      csr_cvp_en,    // CSR enable
output wire      dprio_dis_out  // dprio_dis out
);

reg   dprio_dis_hold_1;
reg   dprio_dis_hold_2;
wire  dprio_dis_in_sync;
wire  dprio_dis_int;

// dprio_dis_in synchronizer
cdclib_bitsync2 
  #(
    .DWIDTH(1),    // Sync Data input 
    .RESET_VAL(1), // Reset value
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ) ,
    .TOGGLE_TYPE(TOGGLE_TYPE),
    .VID(VID)
    ) dprio_dis_in_sync_1
    (
     .clk(clk),                   // clock
     .rst_n(rst_n),               // async reset
     .data_in(dprio_dis_in),      // data in
     .data_out(dprio_dis_in_sync) // data out
    );

// Hold dprio_dis logic
always @ (negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      dprio_dis_hold_1 <= 1'b1;
      dprio_dis_hold_2 <= 1'b1;
    end
  else
    begin
      dprio_dis_hold_1 <= (dprio_dis_int) ? dprio_dis_in_sync : 1'b0;
      dprio_dis_hold_2 <= dprio_dis_hold_1;
    end

// internal dprio_dis
assign dprio_dis_int = dprio_dis_hold_1 | dprio_dis_hold_2;

// dprio_dis_out
assign dprio_dis_out = (csr_cvp_en == 1'b1) ? dprio_dis_int : dprio_dis_in;

endmodule

