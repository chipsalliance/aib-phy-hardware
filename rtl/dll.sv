// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : dll
// Description    : Behavioral model of dll
// Revision       : 1.0
// ============================================================================
`timescale 1ps/1ps
module dll 
   (
   input       clkp, clkn,
   input       rstb,
   output wire     rx_clk_tree_in,
   input       ms_rx_dll_lock_req,
   output wire ms_rx_dll_lock,
   input       sl_rx_dll_lock_req,
   output wire sl_rx_dll_lock,
   input       ms_nsl,
   input       atpg_mode
    );


wire  rstb_sync;
reg   ms_rx_dll_lock_r, sl_rx_dll_lock_r;
wire  ms_rx_dll_lock_w, sl_rx_dll_lock_w;
wire  ms_rx_dll_lock_req_sync, sl_rx_dll_lock_req_sync;

assign ms_rx_dll_lock = ms_rx_dll_lock_r;
assign sl_rx_dll_lock = sl_rx_dll_lock_r;

assign ms_rx_dll_lock_w = !ms_rx_dll_lock_req_sync ? 1'b0 :
                          (ms_nsl & ms_rx_dll_lock_req_sync ) ? 1'b1 : ms_rx_dll_lock_r;
assign sl_rx_dll_lock_w = !sl_rx_dll_lock_req_sync ? 1'b0 :
                          (!ms_nsl & sl_rx_dll_lock_req_sync ) ? 1'b1 : sl_rx_dll_lock_r;


aib_rstnsync aib_rstnsync
  (
    .clk(clkp),            // Destination clock of reset to be synced
    .i_rst_n(rstb),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(rstb_sync)      // Synchronized reset output

   );

       aib_bitsync i_msrxdlllockreq
           (
           .clk(clkp),
           .rst_n(rstb_sync), 
           .data_in(ms_rx_dll_lock_req),
           .data_out(ms_rx_dll_lock_req_sync)
           );

       aib_bitsync i_slrxdlllockreq
           (
           .clk(clkp),
           .rst_n(rstb_sync), 
           .data_in(sl_rx_dll_lock_req),
           .data_out(sl_rx_dll_lock_req_sync)
           );

always @(posedge clkp or negedge rstb_sync) begin
  if (~rstb_sync)
   begin
    ms_rx_dll_lock_r <= 1'b0;
    sl_rx_dll_lock_r <= 1'b0;
   end
  else
   begin
    ms_rx_dll_lock_r <= ms_rx_dll_lock_w;
    sl_rx_dll_lock_r <= sl_rx_dll_lock_w;
   end
end

assign #(100) rx_clk_tree_in = clkp;
 
endmodule // dll

     
