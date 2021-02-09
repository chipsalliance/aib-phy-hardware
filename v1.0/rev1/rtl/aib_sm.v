// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_sm
// Description    : Behavioral model of reset and calibration
// Revision       : 1.0
// ============================================================================
//
module aib_sm 
   (
    input                  osc_clk,    //from aux 
    input                  sr_ms_clk_in, //input ms clock
    input                  ms_config_done,   //master config done
    output reg             ms_osc_transfer_en,
    output reg             ms_rx_transfer_en,
    output reg             ms_osc_transfer_alive,
    output reg             ms_rx_async_rst,
    output reg             ms_rx_dll_lock_req,
    output reg             ms_rx_dll_lock,
    output reg             ms_tx_async_rst,
    output reg             ms_tx_dcc_cal_req,
    output reg             ms_tx_dcc_cal_done,
    output reg             ms_tx_transfer_en,
    input                  ms_rx_dcc_dll_lock_req,
    input                  ms_tx_dcc_dll_lock_req,
    input                  ms_rx_dll_lockint,   
    input                  ms_tx_dcc_cal_doneint,
    input                  ms_tx_dcc_cal_donei,
    input                  ms_rx_dll_locki,   
    input                  ms_rx_transfer_eni,
    input                  ms_tx_transfer_eni,
    input                  ms_osc_transfer_eni,
    input                  sl_config_done,   //slave config done
    output reg             sl_osc_transfer_en,
    output reg             sl_rx_transfer_en,
    output reg             sl_fifo_tx_async_rst,
    output reg             sl_tx_dcc_cal_req,
    output reg             sl_tx_dcc_cal_done,
    output reg             sl_tx_transfer_en,
    output reg             sl_rx_async_rst,
    output reg             sl_rx_dll_lock_req,
    output reg             sl_rx_dll_lock,
    input                  sl_tx_dcc_dll_lock_req,
    input                  sl_rx_dcc_dll_lock_req,
    input                  sl_rx_dll_lockint, //from slave internal
    input                  sl_rx_dll_locki,   //from sr interface
    input                  sl_tx_dcc_cal_donei, //from sr interface
    input                  sl_tx_dcc_cal_doneint,  //from slave internal
    input                  sl_rx_transfer_eni,
    input                  sl_osc_transfer_eni,
    input                  ms_nsl, //"1", this is a Master. "0", this is a Slave
    input                  atpg_mode,
    input                  reset_n       //ms_adapter_rstn & sl_adapter_rstn

    );

parameter     ms_wait_rx_osc_rdy = 2'd0, //osc sync states
              ms_osc_xfer_en = 2'd1,
              ms_osc_xfer_alive = 2'd2,

              sl_wait_rx_osc_rdy = 2'd0,
              sl_osc_xfer_en = 2'd1,

              ms_wait_rx_xfer_req = 3'd0, //slave tx to master rx cal states
              ms_wait_remt_tx_dcc_cal_done = 3'd1,
              ms_send_ms_rx_dll_lock_req = 3'd2,
              ms_rx_dll_lock_st = 3'd3,
              ms_rx_xfer_en = 3'd4,

              sl_wait_tx_xfer_req = 3'd0,
              sl_send_tx_dcc_cal_req = 3'd1,
              sl_wait_remt_rx_dll_lock = 3'd2,
              sl_wait_remt_rx_transfer_en = 3'd3,
              sl_tx_xfer_en = 3'd4,
              
              ms_wait_tx_xfer_req = 3'd0, //master tx to slave rx cal states
              ms_send_tx_dcc_cal_req = 3'd1,
              ms_wait_remt_rx_dll_lock = 3'd2,
              ms_wait_remt_rx_transfer_en = 3'd3,
              ms_tx_xfer_en = 3'd4,

              sl_wait_rx_xfer_req = 3'd0,
              sl_send_rx_dll_lock_req = 3'd1,
              sl_rx_dll_lock_st = 3'd2,
              sl_rx_xfer_en = 3'd3,
              sl_rx_xfer_alive = 3'd4;
              

reg [1:0] msosc_curst, msosc_nxst;
reg [1:0] slosc_curst, slosc_nxst;

reg [2:0] msrxcal_curst, msrxcal_nxst;
reg [2:0] sltxcal_curst, sltxcal_nxst;

reg [2:0] mstxcal_curst, mstxcal_nxst;
reg [2:0] slrxcal_curst, slrxcal_nxst;

wire is_master, is_slave;
wire ms_reset_n, sl_reset_n;
wire ms_reset_n_sync, sl_reset_n_sync;


wire ms_config_done_sync;
wire ms_rx_dcc_dll_lock_req_sync, ms_rx_dll_lock_sync;
wire ms_tx_dcc_dll_lock_req_sync;
wire sl_rx_dcc_dll_lock_req_sync, sl_rx_transfer_en_sync;
wire sl_tx_dcc_cal_reqw;

wire sl_osc_transfer_en_sync, sl_config_done_sync;
wire sl_tx_dcc_dll_lock_req_sync, sl_tx_dcc_cal_done_slsync;
wire ms_osc_transfer_en_sync, ms_rx_transfer_en_sync, ms_tx_transfer_en_sync;

wire ms_osc_transfer_enw, ms_osc_transfer_alivew, ms_rx_async_rstw;
wire ms_rx_dll_lock_reqw, ms_rx_dll_lockw;
wire ms_rx_transfer_enw, ms_tx_dcc_cal_reqw, ms_tx_dcc_cal_donew;
wire ms_tx_async_rstw, ms_tx_transfer_enw;

wire sl_osc_transfer_enw, sl_fifo_tx_async_rstw;
wire sl_tx_dcc_cal_donew, sl_tx_transfer_enw;
wire sl_rx_async_rstw, sl_rx_dll_lock_reqw, sl_rx_dll_lockw;
wire sl_rx_transfer_enw;

assign ms_reset_n = reset_n & ms_config_done;
assign sl_reset_n = reset_n & sl_config_done;

aib_rstnsync ms_aib_rstnsync
  (
    .clk(osc_clk),            // Destination clock of reset to be synced
    .i_rst_n(ms_reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(ms_reset_n_sync)      // Synchronized reset output

   );

aib_rstnsync ms_confdone_rstnsync
  (
    .clk(osc_clk),            // Destination clock of reset to be synced
    .i_rst_n(ms_config_done),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(ms_config_done_sync)      // Synchronized reset output

   );

aib_rstnsync sl_aib_rstnsync
  (
    .clk(sr_ms_clk_in),            // Destination clock of reset to be synced
    .i_rst_n(sl_reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(sl_reset_n_sync)      // Synchronized reset output

   );

aib_rstnsync sl_confdone_rstnsync
  (
    .clk(sr_ms_clk_in),            // Destination clock of reset to be synced
    .i_rst_n(sl_config_done),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(sl_config_done_sync)      // Synchronized reset output

   );


       aib_bitsync i_sloscxferen_sync
           (
           .clk(osc_clk),
           .rst_n(ms_config_done_sync), 
           .data_in(sl_osc_transfer_eni),
           .data_out(sl_osc_transfer_en_sync)
           );


       aib_bitsync i_sltxdlldcclockreq_sync
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(sl_tx_dcc_dll_lock_req),
           .data_out(sl_tx_dcc_dll_lock_req_sync)
           );

       aib_bitsync i_msrxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(ms_rx_dcc_dll_lock_req),
           .data_out(ms_rx_dcc_dll_lock_req_sync)
           );


       aib_bitsync i_msrxdlllock
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(ms_rx_dll_lockint),
           .data_out(ms_rx_dll_lock_sync)
           );

       aib_bitsync i_sltxdcccaldone
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(sl_tx_dcc_cal_donei),
           .data_out(sl_tx_dcc_cal_done_sync)
           );


       aib_bitsync i_slrxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(sl_rx_dcc_dll_lock_req),
           .data_out(sl_rx_dcc_dll_lock_req_sync)
           );

       aib_bitsync i_mstxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(ms_tx_dcc_dll_lock_req),
           .data_out(ms_tx_dcc_dll_lock_req_sync)
           );

       aib_bitsync i_mstxdcccaldone
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(ms_tx_dcc_cal_doneint),
           .data_out(ms_tx_dcc_cal_done_sync)
           );

       aib_bitsync i_slrxdlllock
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(sl_rx_dll_locki),
           .data_out(sl_rx_dll_lock_sync)
           );

       aib_bitsync i_slrxtranseren
           (
           .clk(osc_clk),
           .rst_n(ms_reset_n_sync), 
           .data_in(sl_rx_transfer_eni),
           .data_out(sl_rx_transfer_en_sync)
           );


       aib_bitsync i_msoscxferen_sync
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_config_done_sync), 
           .data_in(ms_osc_transfer_eni),
           .data_out(ms_osc_transfer_en_sync)
           );



       aib_bitsync i_slsltxdcccaldone
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(sl_tx_dcc_cal_doneint),
           .data_out(sl_tx_dcc_cal_done_slsync)
           );

       aib_bitsync i_slmsrxdlllock
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(ms_rx_dll_locki),
           .data_out(ms_rx_dll_lock_slsync)
           );

       aib_bitsync i_msrxtransferen
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(ms_rx_transfer_eni),
           .data_out(ms_rx_transfer_en_sync)
           );

       aib_bitsync i_slmstxdcccaldone
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(ms_tx_dcc_cal_donei),
           .data_out(ms_tx_dcc_cal_done_slsync)
           );

       aib_bitsync i_slslrxdlllock
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(sl_rx_dll_lockint),
           .data_out(sl_rx_dll_lock_slsync)
           );


       aib_bitsync i_mstxtransferen
           (
           .clk(sr_ms_clk_in),
           .rst_n(sl_reset_n_sync), 
           .data_in(ms_tx_transfer_eni),
           .data_out(ms_tx_transfer_en_sync)
           );


   assign is_master = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign is_slave = !is_master;


assign ms_osc_transfer_enw = (msosc_curst[1:0]== ms_osc_xfer_en) ? 1'b1 : 
                             (msosc_curst[1:0]== ms_wait_rx_osc_rdy) ? 1'b0 : ms_osc_transfer_en;
assign ms_osc_transfer_alivew = (msosc_curst[1:0]== ms_osc_xfer_alive) ? 1'b1 : 
                                (msosc_curst[1:0]== ms_wait_rx_osc_rdy) ? 1'b0 : ms_osc_transfer_alive;
assign ms_rx_async_rstw = (msrxcal_curst[2:0] != ms_wait_rx_xfer_req) ? 1'b1 : 
                          (msrxcal_curst[2:0] == ms_wait_rx_xfer_req) ? 1'b0 : ms_rx_async_rst;

assign ms_rx_dll_lock_reqw = (msrxcal_curst[2:0] == ms_send_ms_rx_dll_lock_req) ? 1'b1 : 
                             (msrxcal_curst[2:0] == ms_wait_rx_xfer_req) ? 1'b0 : ms_rx_dll_lock_req;

assign ms_rx_dll_lockw = (msrxcal_curst[2:0] == ms_rx_dll_lock_st) ? 1'b1 : 
                             (msrxcal_curst[2:0] == ms_wait_rx_xfer_req) ? 1'b0 : ms_rx_dll_lock;

assign ms_rx_transfer_enw = (msrxcal_curst[2:0] == ms_rx_xfer_en) ? 1'b1 : 
                             (msrxcal_curst[2:0] == ms_wait_rx_xfer_req) ? 1'b0 : ms_rx_transfer_en;

assign ms_tx_async_rstw = (mstxcal_curst[2:0] != ms_wait_tx_xfer_req) ? 1'b1 : 
                          (mstxcal_curst[2:0] == ms_wait_tx_xfer_req) ? 1'b0 : ms_tx_async_rst;

assign ms_tx_dcc_cal_reqw = (mstxcal_curst[2:0] == ms_send_tx_dcc_cal_req) ? 1'b1 : 
                          (mstxcal_curst[2:0] == ms_wait_tx_xfer_req) ? 1'b0 : ms_tx_dcc_cal_req;

assign ms_tx_dcc_cal_donew = (mstxcal_curst[2:0] == ms_wait_remt_rx_dll_lock) ? 1'b1 : 
                          (mstxcal_curst[2:0] == ms_wait_tx_xfer_req) ? 1'b0 : ms_tx_dcc_cal_done;

assign ms_tx_transfer_enw = (mstxcal_curst[2:0] == ms_tx_xfer_en) ? 1'b1 : 
                          (mstxcal_curst[2:0] == ms_wait_tx_xfer_req) ? 1'b0 : ms_tx_transfer_en;

assign sl_osc_transfer_enw = (slosc_curst[1:0]== sl_osc_xfer_en) ? 1'b1 : 
                             (slosc_curst[1:0]== sl_wait_rx_osc_rdy) ? 1'b0 : sl_osc_transfer_en;
assign sl_fifo_tx_async_rstw = (sltxcal_curst[2:0] != sl_wait_tx_xfer_req) ? 1'b1 : 
                               (sltxcal_curst[2:0] == sl_wait_tx_xfer_req) ? 1'b0 : sl_fifo_tx_async_rst;

assign sl_tx_dcc_cal_reqw = (sltxcal_curst[2:0] == sl_send_tx_dcc_cal_req) ? 1'b1 : 
                               (sltxcal_curst[2:0] == sl_wait_tx_xfer_req) ? 1'b0 : sl_tx_dcc_cal_req;

assign sl_tx_dcc_cal_donew = (sltxcal_curst[2:0] == sl_wait_remt_rx_dll_lock) ? 1'b1 : 
                               (sltxcal_curst[2:0] == sl_wait_tx_xfer_req) ? 1'b0 : sl_tx_dcc_cal_done;

assign sl_tx_transfer_enw = (sltxcal_curst[2:0] == sl_tx_xfer_en) ? 1'b1 : 
                               (sltxcal_curst[2:0] == sl_wait_tx_xfer_req) ? 1'b0 : sl_tx_transfer_en;

assign sl_rx_async_rstw = (slrxcal_curst[2:0] != sl_wait_rx_xfer_req) ? 1'b1 : 
                               (slrxcal_curst[2:0] == sl_wait_rx_xfer_req) ? 1'b0 : sl_rx_async_rst;

assign sl_rx_dll_lock_reqw = (slrxcal_curst[2:0] == sl_send_rx_dll_lock_req) ? 1'b1 : 
                               (slrxcal_curst[2:0] == sl_wait_rx_xfer_req) ? 1'b0 : sl_rx_dll_lock_req;

assign sl_rx_dll_lockw = (slrxcal_curst[2:0] == sl_rx_dll_lock_st) ? 1'b1 : 
                               (slrxcal_curst[2:0] == sl_wait_rx_xfer_req) ? 1'b0 : sl_rx_dll_lock;

assign sl_rx_transfer_enw = (slrxcal_curst[2:0] == sl_rx_xfer_en) ? 1'b1 : 
                               (slrxcal_curst[2:0] == sl_wait_rx_xfer_req) ? 1'b0 : sl_rx_transfer_en;

always @ (posedge osc_clk or negedge ms_reset_n_sync) 
begin
  if(!ms_reset_n_sync)
    begin
     ms_rx_async_rst <= 1'b0;
     ms_rx_dll_lock_req <= 1'b0;
     ms_rx_dll_lock <= 1'b0;
     ms_rx_transfer_en <= 1'b0;
     ms_tx_async_rst <= 1'b0;
     ms_tx_dcc_cal_req <= 1'b0;
     ms_tx_dcc_cal_done <= 1'b0;
     ms_tx_transfer_en <= 1'b0;
    end
  else
    begin
     ms_rx_async_rst <= ms_rx_async_rstw;
     ms_rx_dll_lock_req <= ms_rx_dll_lock_reqw;
     ms_rx_dll_lock <= ms_rx_dll_lockw;
     ms_rx_transfer_en <= ms_rx_transfer_enw;
     ms_tx_async_rst <= ms_tx_async_rstw;
     ms_tx_dcc_cal_req <= ms_tx_dcc_cal_reqw;
     ms_tx_dcc_cal_done <= ms_tx_dcc_cal_donew;
     ms_tx_transfer_en <= ms_tx_transfer_enw;
    end
end

always @ (posedge sr_ms_clk_in or negedge sl_reset_n_sync) 
begin
  if(!sl_reset_n_sync)
    begin
     sl_tx_dcc_cal_done <= 1'b0;
     sl_tx_dcc_cal_req <= 1'b0;
     sl_tx_transfer_en <= 1'b0;
     sl_rx_async_rst <= 1'b0;
     sl_rx_dll_lock_req <= 1'b0;
     sl_rx_dll_lock <= 1'b0;
     sl_rx_transfer_en <= 1'b0;
    end
  else
    begin
     sl_tx_dcc_cal_done <= sl_tx_dcc_cal_donew;
     sl_tx_dcc_cal_req <= sl_tx_dcc_cal_reqw;
     sl_tx_transfer_en <= sl_tx_transfer_enw;
     sl_rx_async_rst <= sl_rx_async_rstw;
     sl_rx_dll_lock_req <= sl_rx_dll_lock_reqw;
     sl_rx_dll_lock <= sl_rx_dll_lockw;
     sl_rx_transfer_en <= sl_rx_transfer_enw;
    end
end



//Master oscillator sync. sequence
always @ (posedge osc_clk or negedge ms_config_done_sync)
begin
  if(!ms_config_done_sync)
    begin
     msosc_curst[1:0] <= 2'b0;
     ms_osc_transfer_en <= 1'b0;
     ms_osc_transfer_alive <= 1'b0;
    end
  else
    begin
     msosc_curst[1:0] <= msosc_nxst[1:0];
     ms_osc_transfer_en <= ms_osc_transfer_enw;
     ms_osc_transfer_alive <= ms_osc_transfer_alivew;
    end
end

always @(*)
 begin
      case (msosc_curst)
      ms_wait_rx_osc_rdy:   begin
                   if (is_master )
                    msosc_nxst  = ms_osc_xfer_en;
                   else
                    msosc_nxst = ms_wait_rx_osc_rdy;
                   end
      ms_osc_xfer_en:    begin
                   if (sl_osc_transfer_en_sync)
                    msosc_nxst = ms_osc_xfer_alive;
                   else
                    msosc_nxst = ms_osc_xfer_en;
                   end
      ms_osc_xfer_alive:        begin
                    msosc_nxst = ms_osc_xfer_alive;
                    end
      default:     begin
                    msosc_nxst = ms_wait_rx_osc_rdy;
                   end
      endcase
 end

//Slave oscillator sync. sequence
always @ (posedge sr_ms_clk_in or negedge sl_config_done_sync)
begin
  if(!sl_config_done_sync)
    begin
     slosc_curst[1:0] <= 2'b0;
     sl_osc_transfer_en <= 1'b0;
    end
  else
    begin
     slosc_curst[1:0] <= slosc_nxst[1:0];
     sl_osc_transfer_en <= sl_osc_transfer_enw;
    end
end

always @(*)
 begin
      case (slosc_curst)
      sl_wait_rx_osc_rdy:   begin
                   if (is_slave & ms_osc_transfer_en_sync)
                    slosc_nxst  = sl_osc_xfer_en;
                   else
                    slosc_nxst = sl_wait_rx_osc_rdy;
                   end
      sl_osc_xfer_en:        begin
                    slosc_nxst = sl_osc_xfer_en;
                    end
      default:     begin
                    slosc_nxst = sl_wait_rx_osc_rdy;
                   end
      endcase
 end


//Slave_TX to Master_RX calibration sequence
always @ (posedge osc_clk or negedge ms_reset_n_sync)
begin
  if(!ms_reset_n_sync)
    begin
     msrxcal_curst[2:0] <= 3'b0;
    end
  else
    begin
     msrxcal_curst[2:0] <= msrxcal_nxst[2:0];
    end
end

always @(*)
 begin
      case (msrxcal_curst)
      ms_wait_rx_xfer_req:   begin
                   if (is_master &  ms_osc_transfer_alive & (sl_tx_dcc_dll_lock_req_sync & ms_rx_dcc_dll_lock_req_sync))
                    msrxcal_nxst  = ms_wait_remt_tx_dcc_cal_done;
                   else
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   end
      ms_wait_remt_tx_dcc_cal_done:        begin
                   if (!ms_rx_dcc_dll_lock_req_sync | !sl_tx_dcc_dll_lock_req_sync)
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   else if (sl_tx_dcc_cal_done_sync )
                    msrxcal_nxst = ms_send_ms_rx_dll_lock_req;
                   else
                    msrxcal_nxst = ms_wait_remt_tx_dcc_cal_done;
                   end
      ms_send_ms_rx_dll_lock_req:        begin
                   if (!ms_rx_dcc_dll_lock_req_sync | !sl_tx_dcc_dll_lock_req_sync)
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   else if (ms_rx_dll_lock_sync ) 
                    msrxcal_nxst = ms_rx_dll_lock_st;
                   else
                    msrxcal_nxst = ms_send_ms_rx_dll_lock_req;
                   end
      ms_rx_dll_lock_st:        begin
                   if (!ms_rx_dcc_dll_lock_req_sync | !sl_tx_dcc_dll_lock_req_sync)
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   else
                    msrxcal_nxst = ms_rx_xfer_en;
                   end
      ms_rx_xfer_en:        begin
                   if (~(sl_tx_dcc_dll_lock_req_sync & ms_rx_dcc_dll_lock_req_sync )) 
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   else
                    msrxcal_nxst = ms_rx_xfer_en;
                   end
      default:     begin
                    msrxcal_nxst = ms_wait_rx_xfer_req;
                   end
      endcase
 end

always @ (posedge sr_ms_clk_in or negedge sl_reset_n_sync)
begin
  if(!sl_reset_n_sync)
    begin
     sltxcal_curst[2:0] <= 3'b0;
    end
  else
    begin
     sltxcal_curst[2:0] <= sltxcal_nxst[2:0];
    end
end

always @(*)
 begin
      case (sltxcal_curst)
      sl_wait_tx_xfer_req:   begin
                   if (is_slave & sl_osc_transfer_en & ~sl_tx_dcc_cal_done)
                    sltxcal_nxst  = sl_send_tx_dcc_cal_req;
                   else
                    sltxcal_nxst = sl_wait_tx_xfer_req;
                   end
      sl_send_tx_dcc_cal_req:        begin
                   if (sl_tx_dcc_cal_done_slsync)
                    sltxcal_nxst  = sl_wait_remt_rx_dll_lock;
                   else
                    sltxcal_nxst = sl_send_tx_dcc_cal_req;
                   end
      sl_wait_remt_rx_dll_lock:        begin
                   if (ms_rx_dll_lock_slsync)
                    sltxcal_nxst  = sl_wait_remt_rx_transfer_en;
                   else
                    sltxcal_nxst = sl_wait_remt_rx_dll_lock;
                   end
      sl_wait_remt_rx_transfer_en:        begin
                   if (ms_rx_transfer_en_sync)
                    sltxcal_nxst  = sl_tx_xfer_en;
                   else
                    sltxcal_nxst = sl_wait_remt_rx_transfer_en;
                   end
      sl_tx_xfer_en:        begin
                   if (~ms_rx_transfer_en_sync) //??? clarify, fig6-5
                    sltxcal_nxst  = sl_wait_tx_xfer_req;
                   else
                    sltxcal_nxst = sl_tx_xfer_en;
                   end
      default:     begin
                    sltxcal_nxst = sl_wait_tx_xfer_req;
                   end
      endcase
 end

//Master_TX to Slave_RX calibration sequence
always @ (posedge osc_clk or negedge ms_reset_n_sync)
begin
  if(!ms_reset_n_sync)
    begin
     mstxcal_curst[2:0] <= 3'b0;
    end
  else
    begin
     mstxcal_curst[2:0] <= mstxcal_nxst[2:0];
    end
end

always @(*)
 begin
      case (mstxcal_curst)
      ms_wait_tx_xfer_req:   begin
                   if (is_master &  ms_osc_transfer_alive & (sl_rx_dcc_dll_lock_req_sync & ms_tx_dcc_dll_lock_req_sync))
                    mstxcal_nxst  = ms_send_tx_dcc_cal_req;
                   else
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   end
      ms_send_tx_dcc_cal_req:    begin
                   if (!ms_tx_dcc_dll_lock_req_sync | !sl_rx_dcc_dll_lock_req_sync ) 
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   else if (ms_tx_dcc_cal_done_sync ) 
                    mstxcal_nxst = ms_wait_remt_rx_dll_lock;
                   else
                    mstxcal_nxst = ms_send_tx_dcc_cal_req;
                   end
      ms_wait_remt_rx_dll_lock:        begin
                   if (!ms_tx_dcc_dll_lock_req_sync | !sl_rx_dcc_dll_lock_req_sync ) 
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   else if (sl_rx_dll_lock_sync ) 
                    mstxcal_nxst = ms_wait_remt_rx_transfer_en;
                   else
                    mstxcal_nxst = ms_wait_remt_rx_dll_lock;
                   end
      ms_wait_remt_rx_transfer_en:        begin
                   if (!ms_tx_dcc_dll_lock_req_sync | !sl_rx_dcc_dll_lock_req_sync ) 
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   else if (sl_rx_transfer_en_sync ) 
                    mstxcal_nxst = ms_tx_xfer_en;
                   else
                    mstxcal_nxst = ms_wait_remt_rx_transfer_en;
                   end
      ms_tx_xfer_en:        begin
                   if (~(sl_rx_dcc_dll_lock_req_sync & ms_tx_dcc_dll_lock_req_sync) ) 
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   else
                    mstxcal_nxst = ms_tx_xfer_en;
                   end
      default:     begin
                    mstxcal_nxst = ms_wait_tx_xfer_req;
                   end
      endcase
 end

always @ (posedge sr_ms_clk_in or negedge sl_reset_n_sync)
begin
  if(!sl_reset_n_sync)
    begin
     slrxcal_curst[2:0] <= 3'b0;
    end
  else
    begin
     slrxcal_curst[2:0] <= slrxcal_nxst[2:0];
    end
end

always @(*)
 begin
      case (slrxcal_curst)
      sl_wait_rx_xfer_req:   begin
                   if (is_slave & sl_osc_transfer_en & ms_tx_dcc_cal_done_slsync & ~sl_rx_dll_lock)
                    slrxcal_nxst  = sl_send_rx_dll_lock_req;
                   else
                    slrxcal_nxst = sl_wait_rx_xfer_req;
                   end
      sl_send_rx_dll_lock_req:        begin
                   if (sl_rx_dll_lock_slsync)
                    slrxcal_nxst  = sl_rx_dll_lock_st;
                   else
                    slrxcal_nxst = sl_send_rx_dll_lock_req;
                   end
      sl_rx_dll_lock_st:        begin
                    slrxcal_nxst  = sl_rx_xfer_en;
                   end
      sl_rx_xfer_en:        begin
                   if (ms_tx_transfer_en_sync)
                    slrxcal_nxst  = sl_rx_xfer_alive;
                   else
                    slrxcal_nxst = sl_rx_xfer_en;
                   end
      sl_rx_xfer_alive:        begin
                   if (~ms_tx_transfer_en_sync)
                    slrxcal_nxst  = sl_wait_rx_xfer_req;
                   else
                    slrxcal_nxst = sl_rx_xfer_alive;
                   end
      default:     begin
                    slrxcal_nxst = sl_wait_rx_xfer_req;
                   end
      endcase
 end

endmodule // aib_sm
