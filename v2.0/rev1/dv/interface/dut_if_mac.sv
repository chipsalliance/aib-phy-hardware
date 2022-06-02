// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1ps
interface dut_if_mac #(parameter DWIDTH = 40, parameter TOTAL_CHNL_NUM = 24) 
                ( input bit fwd_clk,   //During PMA mode, this is i_rx_pma_clk,
                  input bit wr_clk,    
                  input bit rd_clk,
                  input bit osc_clk);  //Only used for leader 

  
    logic [TOTAL_CHNL_NUM*DWIDTH*2-1:0]   data_in; 
    logic [TOTAL_CHNL_NUM*DWIDTH*2-1:0]   data_out; 
    logic [TOTAL_CHNL_NUM*DWIDTH*8-1:0]   data_in_f;
    logic [TOTAL_CHNL_NUM*DWIDTH*8-1:0]   data_out_f;
    logic [TOTAL_CHNL_NUM*DWIDTH-1:0]     gen1_data_in;
    logic [TOTAL_CHNL_NUM*DWIDTH-1:0]     gen1_data_out;
    logic [TOTAL_CHNL_NUM*DWIDTH*2-1:0]   gen1_data_in_f;
    logic [TOTAL_CHNL_NUM*DWIDTH*2-1:0]   gen1_data_out_f;
    logic [TOTAL_CHNL_NUM*81-1:0]         ms_sideband;    
    logic [TOTAL_CHNL_NUM*73-1:0]         sl_sideband;    

    logic [TOTAL_CHNL_NUM-1:0]            m_fs_fwd_clk;
    logic [TOTAL_CHNL_NUM-1:0]            m_ns_fwd_clk;
    logic [TOTAL_CHNL_NUM-1:0]            m_ns_rcv_clk;
    logic [TOTAL_CHNL_NUM-1:0]            m_fs_rcv_clk;
    logic [TOTAL_CHNL_NUM-1:0]            m_wr_clk;
    logic [TOTAL_CHNL_NUM-1:0]            m_rd_clk;

    logic [TOTAL_CHNL_NUM-1:0]            ns_adapter_rstn;
    logic [TOTAL_CHNL_NUM-1:0]            fs_adapter_rstn;
    logic [TOTAL_CHNL_NUM-1:0]            ns_mac_rdy;
    logic [TOTAL_CHNL_NUM-1:0]            fs_mac_rdy;

    logic                                 i_m_power_on_reset;
    logic                                 o_m_power_on_reset;
    logic                                 m_por_ovrd;
    logic                                 m_device_detect;
    logic                                 m_device_detect_ovrd;
    logic                                 i_conf_done;
    logic [TOTAL_CHNL_NUM-1:0]            sl_rx_dcc_dll_lock_req;
    logic [TOTAL_CHNL_NUM-1:0]            sl_tx_dcc_dll_lock_req;
    logic [TOTAL_CHNL_NUM-1:0]            ms_rx_dcc_dll_lock_req;
    logic [TOTAL_CHNL_NUM-1:0]            ms_tx_dcc_dll_lock_req;
    logic [TOTAL_CHNL_NUM-1:0]            ms_tx_transfer_en;
    logic [TOTAL_CHNL_NUM-1:0]            ms_rx_transfer_en;
    logic [TOTAL_CHNL_NUM-1:0]            sl_tx_transfer_en;
    logic [TOTAL_CHNL_NUM-1:0]            sl_rx_transfer_en;
    logic [TOTAL_CHNL_NUM-1:0]            m_rx_align_done; 

    genvar                       i;

    assign m_ns_fwd_clk = {TOTAL_CHNL_NUM{fwd_clk}};
    assign m_ns_rcv_clk = {TOTAL_CHNL_NUM{fwd_clk}};
    assign m_wr_clk = {TOTAL_CHNL_NUM{wr_clk}};
    assign m_rd_clk = {TOTAL_CHNL_NUM{rd_clk}};
    assign i_osc_clk    = osc_clk;

endinterface // dut_io
