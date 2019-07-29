// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

    logic [2:0] csr_config;
    logic [2:0] csr_in;
    logic       nfrzdrv_in;
    logic       csr_rdy_in;
    logic       usermode_in;
    logic       sl_ns_mac_rdy;

    reg   csr_clk_in = 1'b0;
    reg   pld_rx_clk1_rowclk = 1'b0;
    reg   pld_rx_clk2_rowclk = 1'b0;
    reg   pld_tx_clk1_rowclk = 1'b0;
    reg   pld_tx_clk2_rowclk = 1'b0;
    reg   pld_rx_clk1_dcm = 1'b0;
    reg   pld_rx_clk2_dcm = 1'b0;
    reg   pld_tx_clk1_dcm = 1'b0;
    reg   pld_tx_clk2_dcm = 1'b0;


    //clock gen
    //Default set value
    initial
      begin
        csr_config = 3'h1;
        csr_in = 3'h0;
        csr_rdy_in     = 1'b0;
        sl_ns_mac_rdy  = 1'b0;
        pld_adapter_tx_pld_rst_n = 1'b0;
        pld_adapter_rx_pld_rst_n = 1'b0;
        usermode_in = 1'b0;
        @(dut.i_adpt_hard_rst_n)
        sl_ns_mac_rdy = 1'b1;
        csr_rdy_in = 1'b1;
        #100000;
        nfrzdrv_in = 1'b1;
        #100000;
        usermode_in = 1'b1;

        pld_adapter_rx_pld_rst_n = 1'b1;
        #100000; ///Wei
        pld_adapter_tx_pld_rst_n = 1'b1;
        #1000000;
        pld_tx_dll_lock_req = 1'b1;
        pld_rx_dll_lock_req = 1'b1;

      end  //initial begin


`ifdef S10_MODEL

  //Nadder Adapter Forces
  initial begin  // {
    @ (csr_rdy_in)

     //MAIB Configuration
     //
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_csr_ctrl[463:0]       = 464'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1200_7d1a_0000_0000_0004_0002_45d3_3b07_b000_0040_0002_0000_2699_0000_0000_0000_0000_0000_0000;
`ifdef REGISTER_MOD // For ND DCC/DLL bypass for low speed 
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_dprio_ctrl[39:0]      = 40'h400;
`else
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_dprio_ctrl[39:0]      = 40'h18000000;
`endif

//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_dprio_ctrl[39:0]      = 40'h0;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm1_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm1_dprio_ctrl[7:0]     = 8'h0;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm2_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm2_dprio_ctrl[7:0]     = 8'h0;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[55:0]       = 56'h00_0018_0000_0300;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_res_csr_ctrl[7:0]    = 8'h0;
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.rx_chnl_dprio_ctrl[167:0] = 168'hc8_17c8_c905_6c42_0040_4040_4c00_0303_0018_ca82_cf01;
`ifdef REGISTER_MOD
//Set rxfifo to be register mode bit 33:32 = 2'b11 r_double read is 0
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.rx_chnl_dprio_ctrl[167:0] = 168'hc8_1788_8805_6c42_0040_4040_4c00_0303_001b_ca82_0f01;
`else
//set r_rx_aib_clk1_sel == 2'b01 to let half clock out. bit 137:136
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.rx_chnl_dprio_ctrl[167:0] = 168'hc8_17c8_c905_6c42_0040_4040_4c00_0303_0018_ca82_4f01;
`endif
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.sr_dprio_ctrl[23:0]       = 24'h0;
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e086_11c5_00ce_2308_00cb_0300_6a22_ee00;
`ifdef REGISTER_MOD
//Set txfifo to be register mode bit [6:5] = 2'b11 r_tx_double_write is 0  bit 55. Turn off watermark r_tx_wm_en bit 77
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e086_15c5_00ce_0308_000b_0300_6a22_ee60;
`else
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e086_15c5_00ce_2308_008b_0300_6a22_ee00;
`endif
     force `NDADAPT_RTB.hdpldadapt_avmm.r_rx_async_pld_pma_ltd_b_rst_val          = 1'b0;
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[17] = 1'b1;  //r_sr_reserbits_in_en
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[18] = 1'b1;  //r_sr_reserbits_out_en
     //force `NDADAPT_RTB.hdpldadapt_sr.r_sr_reserbits_in_en = 1'b1;
     //force `NDADAPT_RTB.hdpldadapt_sr.r_sr_reserbits_out_en = 1'b1;
  end

`endif // S10_MODEL
