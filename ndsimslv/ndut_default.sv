// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
    initial
        begin
         hip_aib_fsr_in[3:0]                = 4'b0;
         hip_aib_ssr_in[39:0]               = 40'h0;
         hip_avmm_read                      = 1'b0;
         hip_avmm_reg_addr[20:0]            = 21'h0;
         hip_avmm_write                     = 1'b0;
         hip_avmm_writedata[7:0]            = 8'h0;

         pld_pma_csr_test_dis               = 1'b0;
         pld_pma_fpll_lc_csr_test_dis       = 1'b0;

         ired_directin_data_in_chain1       = 1'b0;
         ired_directin_data_in_chain2       = 1'b0;
         ired_irxen_in_chain1[2:0]          = 3'b0;
         ired_irxen_in_chain2[2:0]          = 3'b0;
         ired_shift_en_in_chain1            = 1'b0;
         ired_shift_en_in_chain2            = 1'b0;
  
//       pld_adapter_tx_pld_rst_n           = 1'b1;
         pld_adapter_rx_pld_rst_n           = 1'b1;
         pld_aib_fabric_rx_dll_lock_req     = 1'b0;
         pld_aib_fabric_tx_dcd_cal_req      = 1'b0;
         pld_aib_hssi_rx_dcd_cal_req        = 1'b0;
         pld_aib_hssi_tx_dcd_cal_req        = 1'b0;
         pld_aib_hssi_tx_dll_lock_req       = 1'b0;

         pld_avmm1_request                  = 1'b0;
         pld_avmm1_reserved_in[8:0]         = 9'h0;
         pld_avmm2_request                  = 1'b0;
         pld_avmm2_reserved_in[9:0]         = 10'h0;

         pld_bitslip                            = 1'b0;
         pld_fpll_shared_direct_async_in[1:0]   = 2'b0;
         pld_fpll_shared_direct_async_in_dcm    = 1'b0;
         pld_fpll_shared_direct_async_in_rowclk = 1'b0;
         pld_ltr                            = 1'b0;
         pld_pcs_rx_pld_rst_n               = 1'b0;
         pld_pcs_tx_pld_rst_n               = 1'b0;
         pld_pma_adapt_start                = 1'b0;
         //pld_pma_coreclkin_rowclk                 = 1'b0;
         pld_pma_csr_test_dis               = 1'b0;
         pld_pma_early_eios                 = 1'b0;
         pld_pma_eye_monitor[5:0]           = 6'b0;
         pld_pma_fpll_cnt_sel[3:0]          = 4'b0;
         pld_pma_fpll_extswitch             = 1'b0;
         pld_pma_fpll_lc_csr_test_dis       = 1'b0;
         pld_pma_fpll_num_phase_shifts[2:0] = 3'b0;
         pld_pma_fpll_pfden                 = 1'b0;
         pld_pma_fpll_up_dn_lc_lf_rstn      = 1'b0;
         pld_pma_ltd_b                      = 1'b0;
         //pld_pma_nrpi_freeze              = 1'b0;
         pld_pma_pcie_switch[1:0]           = 1'b0;
         pld_pma_ppm_lock                   = 1'b0;
         pld_pma_reserved_out[4:0]          = 1'b0;
         pld_pma_rs_lpbk_b                  = 1'b0;
         pld_pma_rx_qpi_pullup              = 1'b0;
         pld_pma_rxpma_rstb                 = 1'b0;
         pld_pma_tx_bitslip                 = 1'b0;
         pld_pma_tx_qpi_pulldn              = 1'b0;
         pld_pma_txdetectrx                 = 1'b0;
         pld_pma_txpma_rstb                 = 1'b0;
         pld_pmaif_rxclkslip                = 1'b0;
         pld_polinv_rx                      = 1'b0;
         pld_polinv_tx                      = 1'b0;
         //pld_rx_clk1_dcm                  = 1'b0;
         //pld_rx_clk1_rowclk                       = 1'b0;
         //pld_rx_clk2_rowclk                       = 1'b0;
         pld_rx_dll_lock_req                = 1'b0;
         pld_rx_fabric_fifo_align_clr       = 1'b0;
     `ifdef SS_EN_ND_FIFO_ELASTIC_BUF // For Testing ND FIFO Elastic Mode
         pld_rx_fabric_fifo_rd_en           = 1'b1;
     `else
         pld_rx_fabric_fifo_rd_en           = 1'b0;
     `endif
         pld_rx_fifo_latency_adj_en         = 1'b0;
         pld_rx_prbs_err_clr                = 1'b0;
         pld_rx_ssr_reserved_in[1:0]        = 2'b00;  //This ensures fifo latency from Adapter is selected rather than xcvrif
         //pld_sclk1_rowclk                         = 1'b0;
         //pld_sclk2_rowclk                         = 1'b0;
         pld_syncsm_en                      = 1'b0;
         //pld_tx_clk1_dcm                  = 1'b0;
         //pld_tx_clk1_rowclk               = 1'b0;
         //pld_tx_clk2_dcm                  = 1'b0;
         //pld_tx_clk2_rowclk               = 1'b0;
         pld_tx_dll_lock_req                = 1'b0;
        // pld_tx_fabric_data_in[79:0]        = 80'h0;
         pld_tx_fifo_latency_adj_en         = 1'b0;
         pld_tx_ssr_reserved_in[2:0]        = 3'b11;
         pld_txelecidle                     = 1'b0;
         pr_channel_freeze_n                = 1'b1;


         //
         pld_8g_a1a2_size                   = 1'b0;
         pld_8g_bitloc_rev_en               = 1'b0;
         pld_8g_byte_rev_en                 = 1'b0;
         pld_8g_eidleinfersel[2:0]          = 3'h0;
         pld_8g_encdt                       = 1'b0;
         pld_8g_tx_boundary_sel[4:0]        = 5'h0;
         pld_10g_krfec_rx_clr_errblk_cnt    = 1'b0;
         pld_10g_rx_align_clr               = 1'b0;
         pld_10g_rx_clr_ber_count           = 1'b0;
         pld_10g_tx_bitslip[6:0]            = 7'h0;
         pld_10g_tx_burst_en                = 1'b0;
         pld_10g_tx_diag_status[1:0]        = 1'b0;
         pld_10g_tx_wordslip                = 1'b0;

//Added by JZ
         pld_avmm1_clk_rowclk               = 1'b0;
         pld_avmm1_read                     = 1'b0;
         pld_avmm1_reg_addr                 = 'h0;
         pld_avmm1_write                    = 1'b0;
         pld_avmm1_writedata                = 'h0;
         pld_avmm2_clk_rowclk               = 1'b0;
         pld_avmm2_read                     = 1'b0;
         pld_avmm2_reg_addr                 = 'h0;
         pld_avmm2_write                    = 1'b0;
         pld_avmm2_writedata                = 'h0;
      end
