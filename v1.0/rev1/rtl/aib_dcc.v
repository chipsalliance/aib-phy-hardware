// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_dcc
// Description    : Behavioral model of DCC
// Revision       : 1.0
// ============================================================================
module aib_dcc

   (
    // AIB IO Bidirectional 
    input                  clk_in,    
    input                  ms_dcc_cal_req, 
    input                  ms_tx_dcc_dll_lock_req, 
    input                  sl_dcc_cal_req, 
    input                  sl_rx_dcc_dll_lock_req, 
    output wire            ms_dcc_cal_done,
    output wire            sl_dcc_cal_done,
    output wire            clk_out,
    input                  ms_nsl,
    input                  atpg_mode,
    input                  reset_n       

    );

reg       ms_dcc_cal_done_r, sl_dcc_cal_done_r;
wire      ms_dcc_cal_donew, sl_dcc_cal_donew;
wire      ms_dcc_cal_req_sync, sl_dcc_cal_req_sync;
wire      reset_n_sync;

assign clk_out = clk_in;
assign ms_dcc_cal_done = ms_dcc_cal_done_r;
assign sl_dcc_cal_done = sl_dcc_cal_done_r;

assign ms_dcc_cal_donew = !ms_tx_dcc_dll_lock_req ? 1'b0 :
                          (ms_nsl & ms_dcc_cal_req_sync ) ? 1'b1 : ms_dcc_cal_done_r;
assign sl_dcc_cal_donew = !sl_rx_dcc_dll_lock_req ? 1'b0 :
                          (!ms_nsl & sl_dcc_cal_req_sync ) ? 1'b1 : sl_dcc_cal_done_r;

aib_rstnsync aib_rstnsync
  (
    .clk(clk_in),            // Destination clock of reset to be synced
    .i_rst_n(reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(reset_n_sync)      // Synchronized reset output

   );

       aib_bitsync i_mstxdlldcclockreq
           (
           .clk(clk_in),
           .rst_n(reset_n_sync), 
           .data_in(ms_dcc_cal_req),
           .data_out(ms_dcc_cal_req_sync)
           );

       aib_bitsync i_sltxdlldcclockreq
           (
           .clk(clk_in),
           .rst_n(reset_n_sync), 
           .data_in(sl_dcc_cal_req),
           .data_out(sl_dcc_cal_req_sync)
           );

always @(posedge clk_in or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    ms_dcc_cal_done_r <= 1'b0;
    sl_dcc_cal_done_r <= 1'b0;
   end
  else
   begin
    ms_dcc_cal_done_r <= ms_dcc_cal_donew;
    sl_dcc_cal_done_r <= sl_dcc_cal_donew;
   end
end



endmodule // aib_dcc
