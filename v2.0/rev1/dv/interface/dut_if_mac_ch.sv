// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1ps
interface dut_if_mac_ch #(parameter DWIDTH = 40) 
                ( input bit fwd_clk,   //During PMA mode, this is i_rx_pma_clk,
                  input bit wr_clk,    // during fifo mode, this is wr_clk
                  input bit rd_clk,
                  input bit osc_clk);   // Only used for leader 

  
    logic [DWIDTH*2-1:0]   data_in; 
    logic [DWIDTH*2-1:0]   data_out; 
    logic [DWIDTH*8-1:0]   data_in_f;
    logic [DWIDTH*8-1:0]   data_out_f;

    logic [81-1:0]         ms_sideband;    
    logic [73-1:0]         sl_sideband;    

    logic                  m_fs_fwd_clk;
    logic                  m_ns_fwd_clk;
    logic                  m_ns_rcv_clk;
    logic                  m_fs_rcv_clk;
    logic                  m_wr_clk;
    logic                  m_rd_clk;

    logic                  ns_adapter_rstn;
    logic                  ns_mac_rdy;
    logic                  fs_mac_rdy;


//  logic                  m_power_on_reset;
//  logic                  m_por_ovrd;
//  logic                  m_device_detect;
//  logic                  m_device_detect_ovrd;

    logic                  por;
    logic                  i_conf_done;
    logic                  sl_rx_dcc_dll_lock_req;
    logic                  sl_tx_dcc_dll_lock_req;
    logic                  ms_rx_dcc_dll_lock_req;
    logic                  ms_tx_dcc_dll_lock_req;
    logic                  ms_tx_transfer_en;
    logic                  ms_rx_transfer_en;
    logic                  sl_tx_transfer_en;
    logic                  sl_rx_transfer_en;
    logic [81-1:0]         sr_ms_tomac;
    logic [73-1:0]         sr_sl_tomac; 
    logic                  m_rx_align_done;

    genvar                 i;
    wire  [79:0]           wf3,wf2,wf1,wf0;
    wire  [79:0]           rf3,rf2,rf1,rf0;

    assign m_ns_fwd_clk = fwd_clk;
    assign m_ns_rcv_clk = fwd_clk;
    assign m_wr_clk     = wr_clk;
    assign m_rd_clk     = rd_clk;
    assign i_osc_clk    = osc_clk;

    assign {wf3,wf2,wf1,wf0} = data_in_f;
    assign {rf3,rf2,rf1,rf0} = data_out_f;

endinterface // dut_io
