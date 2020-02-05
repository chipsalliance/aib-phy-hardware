// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================

`timescale 1ps/1ps
interface dut_io (input bit i_osc_clk, 
		  input bit i_rx_pma_clk,
                  input bit i_tx_pma_clk,
                  input bit i_cfg_avmm_clk);

  
    logic                        i_adpt_hard_rst_n;
    logic                        ns_mac_rdy;
    logic [6-1:0]                i_channel_id;
    logic                        i_cfg_avmm_rst_n;
    logic [16:0]                 i_cfg_avmm_addr;
    logic [ 3:0]                 i_cfg_avmm_byte_en;
    logic                        i_cfg_avmm_read;
    logic                        i_cfg_avmm_write;
    logic [31:0]                 i_cfg_avmm_wdata;
    logic                        i_adpt_cfg_rdatavld;
    logic                        i_adpt_cfg_waitreq;
    logic [31:0]                 i_adpt_cfg_rdata;
                        
    logic [31:0]                 o_cfg_avmm_rdata;
    logic                        o_cfg_avmm_rdatavld;
    logic                        o_cfg_avmm_waitreq;
    logic                        o_osc_clk;
 
    logic [65-1:0]               i_chnl_ssr;
    logic [40-1:0]               i_rx_pma_data;
    logic [65-1:0]               o_chnl_ssr;
    logic [40-1:0]               o_tx_pma_data;
    
    logic                         o_rx_xcvrif_rst_n;
    logic                         o_tx_xcvrif_rst_n;
    logic                         o_tx_transfer_clk;
    logic                         o_tx_transfer_div2_clk;
    
    //rx_pma_clk domain
    clocking cb_rx_pma @ (posedge i_rx_pma_clk);
	default input #1 output #1;
	output   i_rx_pma_data;	
    endclocking // cb

    //cfg_avmm_clk domain
    clocking cb_cfg_avmm @(posedge i_cfg_avmm_clk);
    	default input #1 output #1;
        output   i_channel_id;
        output   i_cfg_avmm_write;
        output   i_cfg_avmm_read;
        output   i_cfg_avmm_addr;
        output   i_cfg_avmm_byte_en;
        output   i_cfg_avmm_wdata;
        output   i_adpt_cfg_rdatavld;
        output   i_adpt_cfg_rdata;
        output   i_adpt_cfg_waitreq;
        
        input    o_cfg_avmm_waitreq;
        input    o_cfg_avmm_rdatavld;
        input    o_cfg_avmm_rdata;
        
    endclocking // cb

    //osc_clk domain
    clocking cb_osc @ (posedge i_osc_clk);
        
      	default input #1 output #1;
        output   i_chnl_ssr;
        input    o_chnl_ssr;
        
    endclocking
    
    modport TB (clocking cb_osc, 
		clocking cb_rx_pma,
                clocking cb_cfg_avmm,
		output i_adpt_hard_rst_n,
                output ns_mac_rdy,
                output i_cfg_avmm_rst_n);
    
endinterface // dut_io
