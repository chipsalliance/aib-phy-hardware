// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
// This testsbench shows how to connect one channel AIB 
// in loopback mode. DCC/DLL are enabled. 
// The data path uses phase compensation FIFO.
// 03/25/2019

`timescale 1ps/1ps

module top;


    //------------------------------------------------------------------------------------------
    // Clock generation
    
    parameter CFG_AVMM_CLK_PERIOD = 4000;
    parameter OSC_CLK_PERIOD      = 1000;
    parameter PMA_CLK_PERIOD      = 1000;
        
    reg   i_cfg_avmm_clk = 1'b0;
    reg	  i_osc_clk = 1'b0;
    reg   i_rx_pma_clk = 1'b0;
    reg   i_rx_elane_clk = 1'b0;
    reg   i_rx_pma_div2_clk = 1'b0;
    reg   i_tx_pma_clk = 1'b0;
    reg   i_tx_elane_clk = 1'b0;
       
      //clock gen
      always #(CFG_AVMM_CLK_PERIOD/2) i_cfg_avmm_clk = ~i_cfg_avmm_clk;
      always #(OSC_CLK_PERIOD/2)      i_osc_clk      = ~i_osc_clk;
      always #(PMA_CLK_PERIOD/2)      i_rx_pma_clk   = ~i_rx_pma_clk;
      always #(PMA_CLK_PERIOD)        i_rx_pma_div2_clk = ~i_rx_pma_div2_clk;
      always #(PMA_CLK_PERIOD/2)      i_tx_pma_clk   = ~i_tx_pma_clk;
      always #(PMA_CLK_PERIOD)        i_rx_elane_clk   = ~i_rx_elane_clk;
      always #(PMA_CLK_PERIOD)        i_tx_elane_clk   = ~i_tx_elane_clk;

     //=================================================================================
    //Below are DFx related signals, temporarily tie them off to 0s, need to be changed later
    logic i_scan_clk,
          i_test_clk_125m,
          i_test_clk_1g,
          i_test_clk_250m,
          i_test_clk_500m,
          i_test_clk_62m;

    logic [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] i_test_c3adapt_scan_in;
    logic [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG] i_test_c3adapt_tcb_static_common;
    logic [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]   o_test_c3adapt_scan_out;
    logic [`AIBADAPTWRAPTCB_JTAG_OUT_RNG]      o_test_c3adapttcb_jtag;
    
    logic i_jtag_rstb_in,
          i_jtag_rstb_en_in,
          i_jtag_clkdr_in,
          i_jtag_clksel_in,
          i_jtag_intest_in,
          i_jtag_mode_in,
          i_jtag_weakpdn_in,
          i_jtag_weakpu_in,
          i_jtag_bs_scanen_in,
          i_jtag_bs_chain_in,
          i_jtag_last_bs_chain_in,
          i_por_aib_vcchssi,
          i_por_aib_vccl,
          i_red_idataselb_in_chain1,
          i_red_idataselb_in_chain2,
          i_red_shift_en_in_chain1,
          i_red_shift_en_in_chain2,
          i_txen_in_chain1,
          i_txen_in_chain2,
          i_directout_data_chain1_in,
          i_directout_data_chain2_in;

    initial begin
        i_scan_clk      = 1'b0;
        i_test_clk_125m = 1'b0;
        i_test_clk_1g   = 1'b0;
        i_test_clk_250m = 1'b0;
        i_test_clk_500m = 1'b0;
        i_test_clk_62m  = 1'b0;

        i_jtag_rstb_in = 1'b0;
        i_jtag_rstb_en_in = 1'b0;
        i_jtag_clkdr_in = 1'b0;
        i_jtag_clksel_in = 1'b0;
        i_jtag_intest_in = 1'b0;
        i_jtag_mode_in = 1'b0;
        i_jtag_weakpdn_in = 1'b0;
        i_jtag_weakpu_in = 1'b0;
        i_jtag_bs_scanen_in = 1'b0;
        i_jtag_bs_chain_in = 1'b0;
        i_jtag_last_bs_chain_in = 0;
        i_por_aib_vcchssi = 1'b0;
        i_por_aib_vccl = 1'b0;
        i_red_idataselb_in_chain1 = 1'b0;
        i_red_idataselb_in_chain2 = 1'b0;
        i_red_shift_en_in_chain1 = 1'b0;
        i_red_shift_en_in_chain2 = 1'b0;
        i_txen_in_chain1 = 1'b0;
        i_txen_in_chain2 = 1'b0;
        i_directout_data_chain1_in = 1'b0;
        i_directout_data_chain2_in = 1'b0;
        i_test_c3adapt_scan_in = 0;
        i_test_c3adapt_tcb_static_common = 0;
                
    end // initial begin

    //=================================================================================
    // AIB IOs
    wire      aib0; 
    wire      aib1; 
    wire      aib10;
    wire      aib11;
    wire      aib12;
    wire      aib13;
    wire      aib14;
    wire      aib15;
    wire      aib16;
    wire      aib17;
    wire      aib18;
    wire      aib19;
    wire      aib2; 
    wire      aib20;
    wire      aib21;
    wire      aib22;
    wire      aib23;
    wire      aib24;
    wire      aib25;
    wire      aib26;
    wire      aib27;
    wire      aib28;
    wire      aib29;
    wire      aib3; 
    wire      aib30;
    wire      aib31;
    wire      aib32;
    wire      aib33;
    wire      aib34;
    wire      aib35;
    wire      aib36;
    wire      aib37;
    wire      aib38;
    wire      aib39;
    wire      aib4; 
    wire      aib40;
    wire      aib41;
    wire      aib42;
    wire      aib43;
    wire      aib44;
    wire      aib45;
    wire      aib46;
    wire      aib47;
    wire      aib48;
    wire      aib49;
    wire      aib5; 
    wire      aib50;
    wire      aib51;
    wire      aib52;
    wire      aib53;
    wire      aib54;
    wire      aib55;
    wire      aib56;
    wire      aib57;
    wire      aib58;
    wire      aib59;
    wire      aib6; 
    wire      aib60;
    wire      aib61;
    wire      aib62;
    wire      aib63;
    wire      aib64;
    wire      aib65;
    wire      aib66;
    wire      aib67;
    wire      aib68;
    wire      aib69;
    wire      aib7; 
    wire      aib70;
    wire      aib71;
    wire      aib72;
    wire      aib73;
    wire      aib74;
    wire      aib75;
    wire      aib76;
    wire      aib77;
    wire      aib78;
    wire      aib79;
    wire      aib8; 
    wire      aib80;
    wire      aib81;
    wire      aib82;
    wire      aib83;
    wire      aib84;
    wire      aib85;
    wire      aib86;
    wire      aib87;
    wire      aib88;
    wire      aib89;
    wire      aib9; 
    wire      aib90;
    wire      aib91;
    wire      aib92;
    wire      aib93;
    wire      aib94;
    wire      aib95;

    wire      aib20_o;
    wire      aib21_o;
    wire      aib22_o;
    wire      aib23_o;
    wire      aib24_o;
    wire      aib25_o;
    wire      aib26_o;
    wire      aib27_o;
    wire      aib28_o;
    wire      aib29_o;
    wire      aib30_o;
    wire      aib31_o;
    wire      aib32_o;
    wire      aib33_o;
    wire      aib34_o;
    wire      aib35_o;
    wire      aib36_o;
    wire      aib37_o;
    wire      aib38_o;
    wire      aib39_o;

    wire      aib40_o;
    wire      aib41_o;
    wire      aib82_o;
    wire      aib83_o;
    
    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [16:0]         o_adpt_cfg_addr;        // From dut of c3aibadapt_wrap.v
    wire [3:0]          o_adpt_cfg_byte_en;     // From dut of c3aibadapt_wrap.v
    wire                o_adpt_cfg_clk;         // From dut of c3aibadapt_wrap.v
    wire                o_adpt_cfg_read;        // From dut of c3aibadapt_wrap.v
    wire                o_adpt_cfg_rst_n;       // From dut of c3aibadapt_wrap.v
    wire [31:0]         o_adpt_cfg_wdata;       // From dut of c3aibadapt_wrap.v
    wire                o_adpt_cfg_write;       // From dut of c3aibadapt_wrap.v
    wire                o_adpt_hard_rst_n;      // From dut of c3aibadapt_wrap.v
    wire [12:0]         o_aibdftdll2adjch;      // From dut of c3aibadapt_wrap.v
    wire [31:0]         o_cfg_avmm_rdata;       // From dut of c3aibadapt_wrap.v
    wire                o_cfg_avmm_rdatavld;    // From dut of c3aibadapt_wrap.v
    wire                o_cfg_avmm_waitreq;     // From dut of c3aibadapt_wrap.v
    wire [60:0]         o_chnl_ssr;             // From dut of c3aibadapt_wrap.v
    wire                o_directout_data_chain1_out;// From dut of c3aibadapt_wrap.v
    wire                o_directout_data_chain2_out;// From dut of c3aibadapt_wrap.v
    wire [2:0]          o_ehip_init_status;     // From dut of c3aibadapt_wrap.v
    wire                o_jtag_bs_chain_out;    // From dut of c3aibadapt_wrap.v
    wire                o_jtag_bs_scanen_out;   // From dut of c3aibadapt_wrap.v
    wire                o_jtag_clkdr_out;       // From dut of c3aibadapt_wrap.v
    wire                o_jtag_clksel_out;      // From dut of c3aibadapt_wrap.v
    wire                o_jtag_intest_out;      // From dut of c3aibadapt_wrap.v
    wire                o_jtag_last_bs_chain_out;// From dut of c3aibadapt_wrap.v
    wire                o_jtag_mode_out;        // From dut of c3aibadapt_wrap.v
    wire                o_jtag_rstb_en_out;     // From dut of c3aibadapt_wrap.v
    wire                o_jtag_rstb_out;        // From dut of c3aibadapt_wrap.v
    wire                o_jtag_weakpdn_out;     // From dut of c3aibadapt_wrap.v
    wire                o_jtag_weakpu_out;      // From dut of c3aibadapt_wrap.v
    wire                o_osc_clk;              // From dut of c3aibadapt_wrap.v
    wire                o_por_aib_vcchssi;      // From dut of c3aibadapt_wrap.v
    wire                o_por_aib_vccl;         // From dut of c3aibadapt_wrap.v
    wire                o_red_idataselb_out_chain1;// From dut of c3aibadapt_wrap.v
    wire                o_red_idataselb_out_chain2;// From dut of c3aibadapt_wrap.v
    wire                o_red_shift_en_out_chain1;// From dut of c3aibadapt_wrap.v
    wire                o_red_shift_en_out_chain2;// From dut of c3aibadapt_wrap.v
    wire                o_rx_xcvrif_rst_n;      // From dut of c3aibadapt_wrap.v
    wire [39:0]         o_tx_pma_data;          // From dut of c3aibadapt_wrap.v
    wire [77:0]         o_tx_elane_data;          // From dut of c3aibadapt_wrap.v
    wire                o_tx_transfer_clk;      // From dut of c3aibadapt_wrap.v
    wire                o_tx_transfer_div2_clk; // From dut of c3aibadapt_wrap.v
    wire                o_tx_xcvrif_rst_n;      // From dut of c3aibadapt_wrap.v
    wire                o_txen_out_chain1;      // From dut of c3aibadapt_wrap.v
    wire                o_txen_out_chain2;      // From dut of c3aibadapt_wrap.v
    wire                HI;
    wire                LO;
    wire  [80:0]        ms_sideband;
    wire  [72:0]        sl_sideband;              
    // End of automatics

    //-----------------------------------------------------------------------------------------
    // Interface instantiation

    dut_io top_io (.i_osc_clk (i_osc_clk), 
                   .i_rx_pma_clk (i_rx_pma_clk),
                   .i_rx_elane_clk(i_rx_elane_clk),
                   .i_tx_pma_clk (i_tx_pma_clk),
                   .i_cfg_avmm_clk (i_cfg_avmm_clk)
                   );

    //-----------------------------------------------------------------------------------------
    // Testbench instantiation
     `ifdef AIB_COMPFIFO // For Testing AIB compensation FIFO Mode
         test_compfifo t (top_io); 
     `else
    test t (top_io);
     `endif

    //-----------------------------------------------------------------------------------------
    // DUT instantiation
    
    c3aibadapt_wrap dut (/*AUTOINST*/
                         // Outputs
                         .o_adpt_hard_rst_n     (o_adpt_hard_rst_n),
                         .o_rx_xcvrif_rst_n     (o_rx_xcvrif_rst_n),
                         .o_tx_xcvrif_rst_n     (o_tx_xcvrif_rst_n),
                         .o_ehip_init_status    (o_ehip_init_status[2:0]),
                         .o_cfg_avmm_rdatavld   (o_cfg_avmm_rdatavld),
                         .o_cfg_avmm_rdata      (o_cfg_avmm_rdata[31:0]),
                         .o_cfg_avmm_waitreq    (o_cfg_avmm_waitreq),
                         .o_adpt_cfg_clk        (o_adpt_cfg_clk),
                         .o_adpt_cfg_rst_n      (o_adpt_cfg_rst_n),
                         .o_adpt_cfg_addr       (o_adpt_cfg_addr[16:0]),
                         .o_adpt_cfg_byte_en    (o_adpt_cfg_byte_en[3:0]),
                         .o_adpt_cfg_read       (o_adpt_cfg_read),
                         .o_adpt_cfg_write      (o_adpt_cfg_write),
                         .o_adpt_cfg_wdata      (o_adpt_cfg_wdata[31:0]),
                         .o_osc_clk             (o_osc_clk),
                         .o_chnl_ssr            (o_chnl_ssr[60:0]),
                         .o_tx_transfer_clk     (o_tx_transfer_clk),
                         .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk),
                         .o_tx_pma_data         (o_tx_pma_data[39:0]),
                         .o_tx_elane_data       (o_tx_elane_data[77:0]),
                         .ns_mac_rdy            (top_io.ns_mac_rdy),
                         .ms_sideband           (ms_sideband),
                         .sl_sideband           (sl_sideband),
                         .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]),
                         .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[`AIBADAPTWRAPTCB_JTAG_OUT_RNG]),
                         .o_jtag_clkdr_out      (o_jtag_clkdr_out),
                         .o_jtag_clksel_out     (o_jtag_clksel_out),
                         .o_jtag_intest_out     (o_jtag_intest_out),
                         .o_jtag_mode_out       (o_jtag_mode_out),
                         .o_jtag_rstb_en_out    (o_jtag_rstb_en_out),
                         .o_jtag_rstb_out       (o_jtag_rstb_out),
                         .o_jtag_weakpdn_out    (o_jtag_weakpdn_out),
                         .o_jtag_weakpu_out     (o_jtag_weakpu_out),
                         .o_jtag_bs_chain_out   (o_jtag_bs_chain_out),
                         .o_jtag_bs_scanen_out  (o_jtag_bs_scanen_out),
                         .o_jtag_last_bs_chain_out(o_jtag_last_bs_chain_out),
                         .o_por_aib_vcchssi     (o_por_aib_vcchssi),
                         .o_por_aib_vccl        (o_por_aib_vccl),
                         .o_red_idataselb_out_chain1(o_red_idataselb_out_chain1),
                         .o_red_idataselb_out_chain2(o_red_idataselb_out_chain2),
                         .o_red_shift_en_out_chain1(o_red_shift_en_out_chain1),
                         .o_red_shift_en_out_chain2(o_red_shift_en_out_chain2),
                         .o_txen_out_chain1     (o_txen_out_chain1),
                         .o_txen_out_chain2     (o_txen_out_chain2),
                         .o_directout_data_chain1_out(o_directout_data_chain1_out),
                         .o_directout_data_chain2_out(o_directout_data_chain2_out),
                         .o_aibdftdll2adjch     (o_aibdftdll2adjch[12:0]),
                         // Inouts
                         .io_aib0               (aib0 ),
                         .io_aib1               (aib1 ),
                         .io_aib10              (aib10),
                         .io_aib11              (aib11),
                         .io_aib12              (aib12),
                         .io_aib13              (aib13),
                         .io_aib14              (aib14),
                         .io_aib15              (aib15),
                         .io_aib16              (aib16),
                         .io_aib17              (aib17),
                         .io_aib18              (aib18),
                         .io_aib19              (aib19),
                         .io_aib2               (aib2 ),
                         .io_aib20              (aib0 ),
                         .io_aib21              (aib1 ),
                         .io_aib22              (aib2 ),
                         .io_aib23              (aib3 ),
                         .io_aib24              (aib4 ),
                         .io_aib25              (aib5 ),
                         .io_aib26              (aib6 ),
                         .io_aib27              (aib7 ),
                         .io_aib28              (aib8 ),
                         .io_aib29              (aib9 ),
                         .io_aib3               (aib3 ),
                         .io_aib30              (aib10),
                         .io_aib31              (aib11),
                         .io_aib32              (aib12),
                         .io_aib33              (aib13),
                         .io_aib34              (aib14),
                         .io_aib35              (aib15),
                         .io_aib36              (aib16),
                         .io_aib37              (aib17),
                         .io_aib38              (aib18),
                         .io_aib39              (aib19),
                         .io_aib4               (aib4 ),
                         .io_aib40              (aib40),
                         .io_aib41              (aib41),
                         .io_aib42              (aib40),
                         .io_aib43              (aib41),
                         .io_aib44              (),      //a71 u_pld_pma_rxpma_rstb
                         .io_aib45              (),      //a71 u_pld_pma_txpma_rstb
                         .io_aib46              (),      //a95 u_pld_pma_pfdmode_lock
                         .io_aib47              (),      //a96 u_pld_pma_rxpll_lock
                         .io_aib48              (),      //a17 i_pld_pcs_tx_clk_out
                         .io_aib49              (),      //a23 U_pld_pma_clkdiv_rx_user
                         .io_aib5               (aib5 ),
                         .io_aib50              (),      //a2 u_pld_pma_hclk
                         .io_aib51              (),      //a25 u_pld_pma_internal_clk2
                         .io_aib52              (),      //a26 i_pld_pma_internal_clk1
                         .io_aib53              (),      //a21 u_pld_pcs_rx_clk_out
                         .io_aib54              (),      //a22 u_pld_pcs_rx_clk_out_n
                         .io_aib55              (),      //a18 u_pld_pcs_tx_clkout_n
                         .io_aib56              (),      //a24 u_pld_pma_clkdiv_rx_user
                         .io_aib57              (),      //a27 u_pld_pma_coreclkin
                         .io_aib58              (),      //a15   u_pld_sclk
                         .io_aib59              (),      //a28  u_pld_pma_coreclkin_n     
                         .io_aib6               (aib6 ),
                         .io_aib60              (),      //a20 u_pld_rx_hssi_fifo_latency_pulse
                         .io_aib61              (1'b1),  //a1 u_adapter_tx_pld_rst_n
                         .io_aib62              (),      //a19 u_pld_tx_hssi_fifo_latency_pulse
                         .io_aib63              (),      //a16 u_pcs_rx_pld_rst_n
                         .io_aib64              (),      //a29 u_pcs_tx_pld_rst_n
                         .io_aib65              (1'b1),      //a30 u_adapter_rx_pld_rst_n
                         .io_aib66              (),   //a47 u_pld_8g_rxelecidle
                         .io_aib67              (),   //a48 u_pld_pma_txdetectrx
                         .io_aib68              (),   //a45 u_fpll_shared_direct_async_out[0]
                         .io_aib69              (),   //a46 u_fpll_shared_direct_async_out[1]
                         .io_aib7               (aib7 ),
                         .io_aib70              (),  //a44 u_fpll_shared_direct_async_out[3]
                         .io_aib71              (),  //a43 u_fpll_shared_direct_async_out[2]
                         .io_aib72              (),  //a3 u_fpll_shared_direct_async_in[0]
                         .io_aib73              (),  //a4 u_fpll_shared_direct_async_in[1]
                         .io_aib74              (),  //a5 u_fpll_shared_direct_async_in[2]
                         .io_aib75              (),  //a6 u_fpll_shared_direct_async_out[4]
                         .io_aib76              (),  //a13 u_avmm1_data_out
                         .io_aib77              (),  //a14 u_avmm2_data_out
                         .io_aib78              (),  //a33 u_avmm1_data_in[0]
                         .io_aib79              (),  //a34 u_avmm1_data_in[1]
                         .io_aib8               (aib8 ),
                         .io_aib80              (),  //a31 u_avmm2_data_in[0]
                         .io_aib81              (),  //a32 u_avmm2_data_in[1]
                         .io_aib82              (aib84),  //a38  u_sr_clk_n_in
                         .io_aib83              (aib85),  //a37  u_sr_clk_in
                         .io_aib84              (aib84),  //a12  u_sr_clk_n_out
                         .io_aib85              (aib85),  //a11  u_sr_clk_out
                         .io_aib86              (),       //a35  u_pma_aib_tx_clk
                         .io_aib87              (),       //a36  u_pma_aib_tx_clk_n
                         .io_aib88              (),       //a40  u_fsr_load_in 
                         .io_aib89              (),       //a39  u_fsr_data_in
                         .io_aib9               (aib9 ),
                         .io_aib90              (),   //a8 u_fsr_load_out
                         .io_aib91              (),   //a7 u_fsr_data_out
                         .io_aib92              (aib94), //a42 u_ssr_load_in
                         .io_aib93              (1'b1),  //a41 u_ssr_data_in
                         .io_aib94              (aib94),   //a10 u_ssr_load_out
                         .io_aib95              (),   //a9 u_ssr_data_out
                         // Inputs
                         .i_adpt_hard_rst_n     (top_io.i_adpt_hard_rst_n),
                         .i_channel_id          (top_io.i_channel_id[5:0]),
                         .i_cfg_avmm_clk        (i_cfg_avmm_clk),
                         .i_cfg_avmm_rst_n      (top_io.i_cfg_avmm_rst_n),
                         .i_cfg_avmm_addr       (top_io.i_cfg_avmm_addr[16:0]),
                         .i_cfg_avmm_byte_en    (top_io.i_cfg_avmm_byte_en[3:0]),
                         .i_cfg_avmm_read       (top_io.i_cfg_avmm_read),
                         .i_cfg_avmm_write      (top_io.i_cfg_avmm_write),
                         .i_cfg_avmm_wdata      (top_io.i_cfg_avmm_wdata[31:0]),
                         .i_adpt_cfg_rdatavld   (top_io.i_adpt_cfg_rdatavld),
                         .i_adpt_cfg_rdata      (top_io.i_adpt_cfg_rdata[31:0]),
//                       .i_adpt_cfg_waitreq    (top_io.i_adpt_cfg_waitreq),
                         .i_adpt_cfg_waitreq    (1'b1),
                         .i_rx_pma_clk          (i_rx_pma_clk),
                         .i_rx_pma_div2_clk     (i_rx_pma_div2_clk),
                         .i_osc_clk             (i_osc_clk),
                         .i_chnl_ssr            (top_io.i_chnl_ssr[64:0]),
                         .i_rx_pma_data         (top_io.i_rx_pma_data[39:0]),
                         .i_rx_elane_clk        (i_rx_elane_clk),
                         .i_rx_elane_data       (top_io.i_rx_elane_data[77:0]),
                         .i_tx_pma_clk          (i_tx_pma_clk),
                         .i_tx_elane_clk        (i_tx_elane_clk),
                         .i_scan_clk            (i_scan_clk),
                         .i_test_clk_1g         (i_test_clk_1g),
                         .i_test_clk_500m       (i_test_clk_500m),
                         .i_test_clk_250m       (i_test_clk_250m),
                         .i_test_clk_125m       (i_test_clk_125m),
                         .i_test_clk_62m        (i_test_clk_62m),
                         .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]),
                         .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]),
                         .i_jtag_rstb_in        (i_jtag_rstb_in),
                         .i_jtag_rstb_en_in     (i_jtag_rstb_en_in),
                         .i_jtag_clkdr_in       (i_jtag_clkdr_in),
                         .i_jtag_clksel_in      (i_jtag_clksel_in),
                         .i_jtag_intest_in      (i_jtag_intest_in),
                         .i_jtag_mode_in        (i_jtag_mode_in),
                         .i_jtag_weakpdn_in     (i_jtag_weakpdn_in),
                         .i_jtag_weakpu_in      (i_jtag_weakpu_in),
                         .i_jtag_bs_scanen_in   (i_jtag_bs_scanen_in),
                         .i_jtag_bs_chain_in    (i_jtag_bs_chain_in),
                         .i_jtag_last_bs_chain_in(i_jtag_last_bs_chain_in),
                         .i_por_aib_vcchssi     (i_por_aib_vcchssi),
                         .i_por_aib_vccl        (i_por_aib_vccl),
                         .i_red_idataselb_in_chain1(i_red_idataselb_in_chain1),
                         .i_red_idataselb_in_chain2(i_red_idataselb_in_chain2),
                         .i_red_shift_en_in_chain1(i_red_shift_en_in_chain1),
                         .i_red_shift_en_in_chain2(i_red_shift_en_in_chain2),
                         .i_txen_in_chain1      (i_txen_in_chain1),
                         .i_txen_in_chain2      (i_txen_in_chain2),
                         .i_directout_data_chain1_in(i_directout_data_chain1_in),
                         .i_directout_data_chain2_in(i_directout_data_chain2_in),
                         .i_aibdftdll2adjch     (i_aibdftdll2adjch[12:0]));
    
endmodule 
