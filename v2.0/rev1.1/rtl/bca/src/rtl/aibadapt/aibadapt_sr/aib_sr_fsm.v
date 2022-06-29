// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_sr_fsm 
   (
    input                  osc_clk,                //From Aux 
    input                  sr_ms_clk_in,           //Input ms clock
    output reg             ms_osc_transfer_en,     //Leader Clock has completed calibration
    output reg             ms_rx_transfer_en,      //Leader receive block has completed calibration
    output reg             ms_rx_dll_lock,         //Leader rx has completed its DLL lock
    output reg             ms_tx_dcc_cal_done,     //Leader has completed its DCC calibration.
    output reg             ms_tx_transfer_en,      //Leader transmit block has completed calibration
    input                  ms_rx_dcc_dll_lock_req, //Leader requests calibration of F2L datapath
    input                  ms_tx_dcc_dll_lock_req, //Leader requests calibration of L2F datapath
    input                  ms_rx_dll_lockint,      //Internal DLL Lock is omplete  
    input                  ms_tx_dcc_cal_doneint,  //Internal DCC calibration is complete
    input                  ms_tx_dcc_cal_donei,    //From sr interface
    input                  ms_rx_dll_locki,        //From sr interface   
    input                  ms_rx_transfer_eni,     //From sr interface
    input                  ms_tx_transfer_eni,     //From sr interface
    input                  ms_osc_transfer_eni,    //From sr interface
    output reg             sl_osc_transfer_en,     //Follower Clock has completed calibration
    output reg             sl_rx_transfer_en,      //Calibration of follower RX datapath is complete
    output reg             sl_tx_dcc_cal_done,     //Follower has completed its DCC calibration.
    output reg             sl_tx_transfer_en,      //Follower receive block has completed calibration
    output reg             sl_rx_dll_lock,         //Follower rx has completed its DLL lock.
    input                  sl_tx_dcc_dll_lock_req, //Follower requests calibration of F2L datapath
    input                  sl_rx_dcc_dll_lock_req, //Follower requests calibration of L2F datapath
    input                  sl_rx_dll_lockint,      //From slave internal
    input                  sl_rx_dll_locki,        //From sr interface
    input                  sl_tx_dcc_cal_donei,    //From sr interface
    input                  sl_tx_dcc_cal_doneint,  //From slave internal
    input                  sl_rx_transfer_eni,     //From sr interface
    input                  sl_osc_transfer_eni,    //From sr interface
    input                  ms_nsl, //"1", this is a Master. "0", this is a Slave
    input                  n_lpbk,                 // Nearside loopback
    input                  osc_fsm_ms_rstn,
    input                  osc_fsm_sl_rstn,
    input                  cal_fsm_ms_rstn,
    input                  cal_fsm_sl_rstn

    );

parameter     MS_WAIT_RX_OSC_RDY   = 2'd0, //osc sync states
              MS_OSC_XFER_EN       = 2'd1,
              MS_OSC_XFER_ALIVE    = 2'd2,

              SL_WAIT_RX_OSC_RDY   = 1'd0,
              SL_OSC_XFER_EN       = 1'd1,

              MS_WAIT_RX_XFER_REQ          = 3'd0, //slave tx to master rx cal states
              MS_WAIT_REMT_TX_DCC_CAL_DONE = 3'd1,
              MS_SEND_MS_RX_DLL_LOCK_REQ   = 3'd2,
              MS_RX_DLL_LOCK_ST            = 3'd3,
              MS_RX_XFER_EN		   = 3'd4,

              SL_WAIT_TX_XFER_REQ 	   = 3'd0,
              SL_SEND_TX_DCC_CAL_REQ 	   = 3'd1,
              SL_WAIT_REMT_RX_DLL_LOCK     = 3'd2,
              SL_WAIT_REMT_RX_TRANSFER_EN  = 3'd3,
              SL_TX_XFER_EN 		   = 3'd4,
              
              MS_WAIT_TX_XFER_REQ  	   = 3'd0, //master tx to slave rx cal states
              MS_SEND_TX_DCC_CAL_REQ       = 3'd1,
              MS_WAIT_REMT_RX_DLL_LOCK 	   = 3'd2,
              MS_WAIT_REMT_RX_TRANSFER_EN  = 3'd3,
              MS_TX_XFER_EN 		   = 3'd4,

              SL_WAIT_RX_XFER_REQ 	   = 3'd0,
              SL_SEND_RX_DLL_LOCK_REQ 	   = 3'd1,
              SL_RX_DLL_LOCK_ST 	   = 3'd2,
              SL_RX_XFER_EN 		   = 3'd3,
              SL_RX_XFER_ALIVE 		   = 3'd4;
              

reg [1:0] msosc_curst, msosc_nxst;
reg       slosc_curst, slosc_nxst;

reg [2:0] msrxcal_curst, msrxcal_nxst;
reg [2:0] sltxcal_curst, sltxcal_nxst;

reg [2:0] mstxcal_curst, mstxcal_nxst;
reg [2:0] slrxcal_curst, slrxcal_nxst;

reg   ms_osc_transfer_alive;  //Leader OSC alive

wire is_master, is_slave;

wire ms_rx_dcc_dll_lock_req_sync, ms_rx_dll_lock_sync;
wire ms_tx_dcc_dll_lock_req_sync;
wire sl_rx_dcc_dll_lock_req_sync, sl_rx_transfer_en_sync;

wire sl_osc_transfer_en_sync;
wire sl_tx_dcc_dll_lock_req_sync, sl_tx_dcc_cal_done_slsync;
wire ms_osc_transfer_en_sync, ms_rx_transfer_en_sync, ms_tx_transfer_en_sync;

wire ms_osc_transfer_enw, ms_osc_transfer_alivew;
wire ms_rx_dll_lockw;
wire ms_rx_transfer_enw, ms_tx_dcc_cal_donew;
wire ms_tx_transfer_enw;

wire sl_osc_transfer_enw;
wire sl_tx_dcc_cal_donew, sl_tx_transfer_enw;
wire sl_rx_dll_lockw;
wire sl_rx_transfer_enw;
wire sl_tx_dcc_cal_done_sync;
wire ms_tx_dcc_cal_done_sync;
wire sl_rx_dll_lock_sync;
wire ms_rx_dll_lock_slsync;
wire ms_tx_dcc_cal_done_slsync;
wire sl_rx_dll_lock_slsync;

       aib_bit_sync i_sloscxferen_sync
           (
           .clk(osc_clk),
           .rst_n(osc_fsm_ms_rstn), 
           .data_in(sl_osc_transfer_eni),
           .data_out(sl_osc_transfer_en_sync)
           );


       aib_bit_sync i_sltxdlldcclockreq_sync
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(sl_tx_dcc_dll_lock_req),
           .data_out(sl_tx_dcc_dll_lock_req_sync)
           );

       aib_bit_sync i_msrxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(ms_rx_dcc_dll_lock_req),
           .data_out(ms_rx_dcc_dll_lock_req_sync)
           );


       aib_bit_sync i_msrxdlllock
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(ms_rx_dll_lockint),
           .data_out(ms_rx_dll_lock_sync)
           );

       aib_bit_sync i_sltxdcccaldone
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(sl_tx_dcc_cal_donei),
           .data_out(sl_tx_dcc_cal_done_sync)
           );


       aib_bit_sync i_slrxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(sl_rx_dcc_dll_lock_req),
           .data_out(sl_rx_dcc_dll_lock_req_sync)
           );

       aib_bit_sync i_mstxdlldcclockreq
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(ms_tx_dcc_dll_lock_req),
           .data_out(ms_tx_dcc_dll_lock_req_sync)
           );

       aib_bit_sync i_mstxdcccaldone
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(ms_tx_dcc_cal_doneint),
           .data_out(ms_tx_dcc_cal_done_sync)
           );

       aib_bit_sync i_slrxdlllock
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(sl_rx_dll_locki),
           .data_out(sl_rx_dll_lock_sync)
           );

       aib_bit_sync i_slrxtranseren
           (
           .clk(osc_clk),
           .rst_n(cal_fsm_ms_rstn), 
           .data_in(sl_rx_transfer_eni),
           .data_out(sl_rx_transfer_en_sync)
           );


       aib_bit_sync i_msoscxferen_sync
           (
           .clk(sr_ms_clk_in),
           .rst_n(osc_fsm_sl_rstn), 
           .data_in(ms_osc_transfer_eni),
           .data_out(ms_osc_transfer_en_sync)
           );



       aib_bit_sync i_slsltxdcccaldone
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(sl_tx_dcc_cal_doneint),
           .data_out(sl_tx_dcc_cal_done_slsync)
           );

       aib_bit_sync i_slmsrxdlllock
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(ms_rx_dll_locki),
           .data_out(ms_rx_dll_lock_slsync)
           );

       aib_bit_sync i_msrxtransferen
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(ms_rx_transfer_eni),
           .data_out(ms_rx_transfer_en_sync)
           );

       aib_bit_sync i_slmstxdcccaldone
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(ms_tx_dcc_cal_donei),
           .data_out(ms_tx_dcc_cal_done_slsync)
           );

       aib_bit_sync i_slslrxdlllock
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(sl_rx_dll_lockint),
           .data_out(sl_rx_dll_lock_slsync)
           );


       aib_bit_sync i_mstxtransferen
           (
           .clk(sr_ms_clk_in),
           .rst_n(cal_fsm_sl_rstn), 
           .data_in(ms_tx_transfer_eni),
           .data_out(ms_tx_transfer_en_sync)
           );


   assign is_master = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign is_slave = !is_master;


assign ms_osc_transfer_enw = (msosc_curst[1:0]== MS_OSC_XFER_EN) ? 1'b1 : 
                             (msosc_curst[1:0]== MS_WAIT_RX_OSC_RDY) ? 1'b0 : ms_osc_transfer_en;
assign ms_osc_transfer_alivew = (msosc_curst[1:0]== MS_OSC_XFER_ALIVE) ? 1'b1 : 
                                (msosc_curst[1:0]== MS_WAIT_RX_OSC_RDY) ? 1'b0 : ms_osc_transfer_alive;

assign ms_rx_dll_lockw = (msrxcal_curst[2:0] == MS_RX_DLL_LOCK_ST) ? 1'b1 : 
                             (msrxcal_curst[2:0] == MS_WAIT_RX_XFER_REQ) ? 1'b0 : ms_rx_dll_lock;

assign ms_rx_transfer_enw = (msrxcal_curst[2:0] == MS_RX_XFER_EN) ? 1'b1 : 
                             (msrxcal_curst[2:0] == MS_WAIT_RX_XFER_REQ) ? 1'b0 : ms_rx_transfer_en;

assign ms_tx_dcc_cal_donew = (mstxcal_curst[2:0] == MS_WAIT_REMT_RX_DLL_LOCK) ? 1'b1 : 
                          (mstxcal_curst[2:0] == MS_WAIT_TX_XFER_REQ) ? 1'b0 : ms_tx_dcc_cal_done;

assign ms_tx_transfer_enw = (mstxcal_curst[2:0] == MS_TX_XFER_EN) ? 1'b1 : 
                          (mstxcal_curst[2:0] == MS_WAIT_TX_XFER_REQ) ? 1'b0 : ms_tx_transfer_en;

assign sl_osc_transfer_enw = (slosc_curst== SL_OSC_XFER_EN) ? 1'b1 : 
                             (slosc_curst== SL_WAIT_RX_OSC_RDY) ? 1'b0 : sl_osc_transfer_en;

assign sl_tx_dcc_cal_donew = (sltxcal_curst[2:0] == SL_WAIT_REMT_RX_DLL_LOCK) ? 1'b1 : 
                               (sltxcal_curst[2:0] == SL_WAIT_TX_XFER_REQ) ? 1'b0 : sl_tx_dcc_cal_done;

assign sl_tx_transfer_enw = (sltxcal_curst[2:0] == SL_TX_XFER_EN) ? 1'b1 : 
                               (sltxcal_curst[2:0] == SL_WAIT_TX_XFER_REQ) ? 1'b0 : sl_tx_transfer_en;

assign sl_rx_dll_lockw = (slrxcal_curst[2:0] == SL_RX_DLL_LOCK_ST) ? 1'b1 : 
                               (slrxcal_curst[2:0] == SL_WAIT_RX_XFER_REQ) ? 1'b0 : sl_rx_dll_lock;

assign sl_rx_transfer_enw = (slrxcal_curst[2:0] == SL_RX_XFER_EN) ? 1'b1 : 
                               (slrxcal_curst[2:0] == SL_WAIT_RX_XFER_REQ) ? 1'b0 : sl_rx_transfer_en;

always @ (posedge osc_clk or negedge cal_fsm_ms_rstn) 
begin
  if(!cal_fsm_ms_rstn)
    begin
     ms_rx_dll_lock <= 1'b0;
     ms_rx_transfer_en <= 1'b0;
     ms_tx_dcc_cal_done <= 1'b0;
     ms_tx_transfer_en <= 1'b0;
    end
  else
    begin
     ms_rx_dll_lock <= ms_rx_dll_lockw;
     ms_rx_transfer_en <= ms_rx_transfer_enw;
     ms_tx_dcc_cal_done <= ms_tx_dcc_cal_donew;
     ms_tx_transfer_en <= ms_tx_transfer_enw;
    end
end

always @ (posedge sr_ms_clk_in or negedge cal_fsm_sl_rstn) 
begin
  if(!cal_fsm_sl_rstn)
    begin
     sl_tx_dcc_cal_done <= 1'b0;
     sl_tx_transfer_en <= 1'b0;
     sl_rx_dll_lock <= 1'b0;
     sl_rx_transfer_en <= 1'b0;
    end
  else
    begin
     sl_tx_dcc_cal_done <= sl_tx_dcc_cal_donew;
     sl_tx_transfer_en <= sl_tx_transfer_enw;
     sl_rx_dll_lock <= sl_rx_dll_lockw;
     sl_rx_transfer_en <= sl_rx_transfer_enw;
    end
end



//Master oscillator sync. sequence
always @ (posedge osc_clk or negedge osc_fsm_ms_rstn)
begin
  if(!osc_fsm_ms_rstn)
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
      MS_WAIT_RX_OSC_RDY:
        begin
          if (is_master )
            msosc_nxst  = MS_OSC_XFER_EN;
          else
            msosc_nxst = MS_WAIT_RX_OSC_RDY;
        end
      MS_OSC_XFER_EN:
        begin
          if (sl_osc_transfer_en_sync | n_lpbk)
           msosc_nxst = MS_OSC_XFER_ALIVE;
          else
           msosc_nxst = MS_OSC_XFER_EN;
        end
      MS_OSC_XFER_ALIVE:
        begin
          msosc_nxst = MS_OSC_XFER_ALIVE;
        end
      default:
        begin
          msosc_nxst = MS_WAIT_RX_OSC_RDY;
        end
    endcase
 end

//Slave oscillator sync. sequence
always @ (posedge sr_ms_clk_in or negedge osc_fsm_sl_rstn)
begin
  if(!osc_fsm_sl_rstn)
    begin
     slosc_curst <= 1'b0;
     sl_osc_transfer_en <= 1'b0;
    end
  else
    begin
     slosc_curst <= slosc_nxst;
     sl_osc_transfer_en <= sl_osc_transfer_enw;
    end
end

always @(*)
  begin
    case (slosc_curst)
    SL_WAIT_RX_OSC_RDY:
      begin
        if (is_slave && ms_osc_transfer_en_sync)
         slosc_nxst  = SL_OSC_XFER_EN;
        else
         slosc_nxst = SL_WAIT_RX_OSC_RDY;
      end
    SL_OSC_XFER_EN:
      begin
        slosc_nxst = SL_OSC_XFER_EN;
      end
    endcase
  end


//Slave_TX to Master_RX calibration sequence
always @ (posedge osc_clk or negedge cal_fsm_ms_rstn)
begin
  if(!cal_fsm_ms_rstn)
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
      MS_WAIT_RX_XFER_REQ:
        begin
          if (is_master &&  ms_osc_transfer_alive &&
              ( (sl_tx_dcc_dll_lock_req_sync || n_lpbk) && ms_rx_dcc_dll_lock_req_sync))
            msrxcal_nxst  = MS_WAIT_REMT_TX_DCC_CAL_DONE;
          else
            msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
        end
      MS_WAIT_REMT_TX_DCC_CAL_DONE:
        begin
          if (!ms_rx_dcc_dll_lock_req_sync || !(sl_tx_dcc_dll_lock_req_sync || n_lpbk))
            msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
          else if (sl_tx_dcc_cal_done_sync || n_lpbk)
            msrxcal_nxst = MS_SEND_MS_RX_DLL_LOCK_REQ;
          else
            msrxcal_nxst = MS_WAIT_REMT_TX_DCC_CAL_DONE;
        end
      MS_SEND_MS_RX_DLL_LOCK_REQ:
        begin
          if (!ms_rx_dcc_dll_lock_req_sync || !(sl_tx_dcc_dll_lock_req_sync || n_lpbk))
            msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
          else if (ms_rx_dll_lock_sync) 
            msrxcal_nxst = MS_RX_DLL_LOCK_ST;
          else
            msrxcal_nxst = MS_SEND_MS_RX_DLL_LOCK_REQ;
        end
      MS_RX_DLL_LOCK_ST:
        begin
          if (!ms_rx_dcc_dll_lock_req_sync || !(sl_tx_dcc_dll_lock_req_sync || n_lpbk))
            msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
          else
            msrxcal_nxst = MS_RX_XFER_EN;
        end
      MS_RX_XFER_EN:        
        begin
          if (!( (sl_tx_dcc_dll_lock_req_sync || n_lpbk) && ms_rx_dcc_dll_lock_req_sync )) 
           msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
          else
           msrxcal_nxst = MS_RX_XFER_EN;
        end
      default:
        begin
          msrxcal_nxst = MS_WAIT_RX_XFER_REQ;
        end
    endcase
 end

always @ (posedge sr_ms_clk_in or negedge cal_fsm_sl_rstn)
begin
  if(!cal_fsm_sl_rstn)
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
      SL_WAIT_TX_XFER_REQ:
        begin
          if (is_slave && sl_osc_transfer_en && !sl_tx_dcc_cal_done)
           sltxcal_nxst  = SL_SEND_TX_DCC_CAL_REQ;
          else
           sltxcal_nxst = SL_WAIT_TX_XFER_REQ;
        end
      SL_SEND_TX_DCC_CAL_REQ:        
        begin
          if (sl_tx_dcc_cal_done_slsync)
           sltxcal_nxst  = SL_WAIT_REMT_RX_DLL_LOCK;
          else
           sltxcal_nxst = SL_SEND_TX_DCC_CAL_REQ;
        end
      SL_WAIT_REMT_RX_DLL_LOCK:
        begin
          if (ms_rx_dll_lock_slsync)
           sltxcal_nxst  = SL_WAIT_REMT_RX_TRANSFER_EN;
          else
           sltxcal_nxst = SL_WAIT_REMT_RX_DLL_LOCK;
        end
      SL_WAIT_REMT_RX_TRANSFER_EN:
        begin
          if (ms_rx_transfer_en_sync)
           sltxcal_nxst  = SL_TX_XFER_EN;
          else
           sltxcal_nxst = SL_WAIT_REMT_RX_TRANSFER_EN;
        end
      SL_TX_XFER_EN:
        begin
          if (!ms_rx_transfer_en_sync) //??? clarify, fig6-5
           sltxcal_nxst  = SL_WAIT_TX_XFER_REQ;
          else
           sltxcal_nxst = SL_TX_XFER_EN;
        end
      default:     
        begin
          sltxcal_nxst = SL_WAIT_TX_XFER_REQ;
        end
    endcase
  end

//Master_TX to Slave_RX calibration sequence
always @ (posedge osc_clk or negedge cal_fsm_ms_rstn)
begin
  if(!cal_fsm_ms_rstn)
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
      MS_WAIT_TX_XFER_REQ:
        begin
          if (is_master &&  ms_osc_transfer_alive &&
              ((sl_rx_dcc_dll_lock_req_sync || n_lpbk) && ms_tx_dcc_dll_lock_req_sync))
            mstxcal_nxst  = MS_SEND_TX_DCC_CAL_REQ;
          else
            mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
        end
      MS_SEND_TX_DCC_CAL_REQ:
        begin
          if (!ms_tx_dcc_dll_lock_req_sync || !(sl_rx_dcc_dll_lock_req_sync || n_lpbk) ) 
            mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
          else if (ms_tx_dcc_cal_done_sync) 
            mstxcal_nxst = MS_WAIT_REMT_RX_DLL_LOCK;
          else
            mstxcal_nxst = MS_SEND_TX_DCC_CAL_REQ;
        end
      MS_WAIT_REMT_RX_DLL_LOCK:        
        begin
          if (!ms_tx_dcc_dll_lock_req_sync || !(sl_rx_dcc_dll_lock_req_sync || n_lpbk) ) 
            mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
          else if (sl_rx_dll_lock_sync || n_lpbk) 
            mstxcal_nxst = MS_WAIT_REMT_RX_TRANSFER_EN;
          else
            mstxcal_nxst = MS_WAIT_REMT_RX_DLL_LOCK;
        end
      MS_WAIT_REMT_RX_TRANSFER_EN:
        begin
          if (!ms_tx_dcc_dll_lock_req_sync || !(sl_rx_dcc_dll_lock_req_sync || n_lpbk) ) 
            mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
          else if (sl_rx_transfer_en_sync || n_lpbk) 
            mstxcal_nxst = MS_TX_XFER_EN;
          else
            mstxcal_nxst = MS_WAIT_REMT_RX_TRANSFER_EN;
        end
      MS_TX_XFER_EN:
        begin
          if (!((sl_rx_dcc_dll_lock_req_sync || n_lpbk) && ms_tx_dcc_dll_lock_req_sync) ) 
            mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
          else
            mstxcal_nxst = MS_TX_XFER_EN;
        end
      default:
        begin
          mstxcal_nxst = MS_WAIT_TX_XFER_REQ;
        end
    endcase
 end

always @ (posedge sr_ms_clk_in or negedge cal_fsm_sl_rstn)
begin
  if(!cal_fsm_sl_rstn)
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
      SL_WAIT_RX_XFER_REQ:                                                                          
        begin                                                                                       
          if (is_slave && sl_osc_transfer_en && ms_tx_dcc_cal_done_slsync && !sl_rx_dll_lock) 
            slrxcal_nxst  = SL_SEND_RX_DLL_LOCK_REQ;                                        
          else                                                                             
            slrxcal_nxst = SL_WAIT_RX_XFER_REQ;                                             
        end                                                                              
      SL_SEND_RX_DLL_LOCK_REQ:
        begin                                                         
          if (sl_rx_dll_lock_slsync)                                                       
            slrxcal_nxst  = SL_RX_DLL_LOCK_ST;                                              
          else                                                                             
            slrxcal_nxst = SL_SEND_RX_DLL_LOCK_REQ;                                         
        end                                                                              
      SL_RX_DLL_LOCK_ST:
        begin                                                               
          slrxcal_nxst  = SL_RX_XFER_EN;                                                  
        end                                                                              
      SL_RX_XFER_EN:
        begin                                                                   
          if (ms_tx_transfer_en_sync)                                                      
            slrxcal_nxst  = SL_RX_XFER_ALIVE;                                               
          else                                                                             
            slrxcal_nxst = SL_RX_XFER_EN;                                                   
        end                                                                              
      SL_RX_XFER_ALIVE:
        begin                                                                
          if (!ms_tx_transfer_en_sync)                                                     
           slrxcal_nxst  = SL_WAIT_RX_XFER_REQ;                                            
          else                                                                             
           slrxcal_nxst = SL_RX_XFER_ALIVE;                                                
        end                                                                              
      default:
        begin                                                                            
          slrxcal_nxst = SL_WAIT_RX_XFER_REQ;                                             
        end                                                                              
    endcase
  end

endmodule // aib_sr_fsm
