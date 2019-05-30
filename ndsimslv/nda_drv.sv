// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
    // Clock generation

    parameter CFG_CSR_CLK_PERIOD        = 20000;
    parameter PLD_PMA_ROWCLK_PERIOD     = 2000;
    parameter PLD_SCLK_ROWCLK_PERIOD    = 3817;
    parameter PLD_RX_CLK1_ROWCLK_PERIOD = 1000; 
    parameter PLD_RX_CLK2_ROWCLK_PERIOD = 2000; 
    parameter PLD_TX_CLK1_ROWCLK_PERIOD = 1000;
    parameter PLD_TX_CLK2_ROWCLK_PERIOD = 64000;
    parameter PLD_RX_CLK1_DCM_PERIOD    = 2000;
    parameter PLD_TX_CLK1_DCM_PERIOD    = 64000;
    parameter PLD_TX_CLK2_DCM_PERIOD    = 1000;
  
    logic [2:0] csr_config;
    logic [2:0] csr_in;
//    logic [2:0] csr_pipe_in;
//    logic       nfrzdrv_in;
    logic       csr_rdy_in;
    logic       csr_rdy_dly_in;
    logic       usermode_in;

    reg   csr_clk_in = 1'b0;
//    reg   pld_avmm1_clk_rowclk = 1'b0;
//    reg   pld_avmm2_clk_rowclk = 1'b0;
//    reg   pld_pma_coreclkin_rowclk = 1'b0;
//    reg   pld_sclk1_rowclk = 1'b0;
//    reg   pld_sclk2_rowclk = 1'b0;
    reg   pld_rx_clk1_rowclk = 1'b0;
    reg   pld_rx_clk2_rowclk = 1'b0;
    reg   pld_tx_clk1_rowclk = 1'b0;
    reg   pld_tx_clk2_rowclk = 1'b0;
    reg   pld_rx_clk1_dcm = 1'b0;
    reg   pld_rx_clk2_dcm = 1'b0;
    reg   pld_tx_clk1_dcm = 1'b0;
    reg   pld_tx_clk2_dcm = 1'b0;


//    logic [2:0] csr_config,
//                csr_in,
//                csr_pipe_in;
    logic       nfrzdrv_in;

    //clock gen
    always #(CFG_CSR_CLK_PERIOD/2)        csr_clk_in               = ~csr_clk_in;
    always #(CFG_CSR_CLK_PERIOD/2)        pld_avmm1_clk_rowclk     = ~pld_avmm1_clk_rowclk;
    always #(CFG_CSR_CLK_PERIOD/2)        pld_avmm2_clk_rowclk     = ~pld_avmm2_clk_rowclk;
    always #(PLD_PMA_ROWCLK_PERIOD/2)     pld_pma_coreclkin_rowclk = ~pld_pma_coreclkin_rowclk;
    always #(PLD_SCLK_ROWCLK_PERIOD/2)    pld_sclk1_rowclk         = ~pld_sclk1_rowclk;
    always #(PLD_SCLK_ROWCLK_PERIOD/2)    pld_sclk2_rowclk         = ~pld_sclk2_rowclk;
    always #(PLD_RX_CLK1_ROWCLK_PERIOD/2) pld_rx_clk1_rowclk       = ~pld_rx_clk1_rowclk;    //FIXME  it does not start right away
    always #(PLD_RX_CLK2_ROWCLK_PERIOD/2) pld_rx_clk2_rowclk       = ~pld_rx_clk2_rowclk;    
    always #(PLD_TX_CLK1_ROWCLK_PERIOD/2) pld_tx_clk1_rowclk       = ~pld_tx_clk1_rowclk;    //FIXME  it does not start right away
    always #(PLD_TX_CLK2_ROWCLK_PERIOD/2) pld_tx_clk2_rowclk       = ~pld_tx_clk2_rowclk;
    always #(PLD_RX_CLK1_DCM_PERIOD/2)    pld_rx_clk1_dcm          = ~pld_rx_clk1_dcm; 
    always #(PLD_TX_CLK1_DCM_PERIOD/2)    pld_tx_clk1_dcm          = ~pld_tx_clk1_dcm; 
    always #(PLD_TX_CLK2_DCM_PERIOD/2)    pld_tx_clk2_dcm          = ~pld_tx_clk2_dcm; 

    //Default set value
    initial
      begin
        csr_config = 3'h1;
        csr_in = 3'h0;
        csr_pipe_in = 3'h0;
        csr_rdy_in     = 1'b0;
        csr_rdy_dly_in = 1'b0;

        pld_adapter_tx_pld_rst_n = 1'b0;
        pld_adapter_rx_pld_rst_n = 1'b0;
        usermode_in = 1'b0;
        @(dut.i_adpt_hard_rst_n)
        csr_rdy_in = 1'b1;
        #100000;
        csr_rdy_dly_in = 1'b1;
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




