// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1fs
`define NDADAPT_RTB ndut.hdpldadapt
`include "c3dfx.vh"

module top;


    //------------------------------------------------------------------------------------------
    // Clock generation
    
    parameter CFG_AVMM_CLK_PERIOD = 4000;
    parameter OSC_CLK_PERIOD      = 1000;
    parameter PMA_CLK_PERIOD      = 1000;
        
    reg   i_cfg_avmm_clk = 1'b0;
    reg	  i_osc_clk = 1'b0;
    reg   i_rx_pma_clk = 1'b0;
    reg   i_rx_pma_div2_clk = 1'b0;
    reg   i_tx_pma_clk = 1'b0;
       
      //clock gen
      always #(CFG_AVMM_CLK_PERIOD/2) i_cfg_avmm_clk = ~i_cfg_avmm_clk;
      always #(OSC_CLK_PERIOD/2)      i_osc_clk      = ~i_osc_clk;
      always #(PMA_CLK_PERIOD/2)      i_rx_pma_clk   = ~i_rx_pma_clk;
      always #(PMA_CLK_PERIOD)        i_rx_pma_div2_clk = ~i_rx_pma_div2_clk;
      always #(PMA_CLK_PERIOD/2)      i_tx_pma_clk   = ~i_tx_pma_clk;

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
                   .i_tx_pma_clk (i_tx_pma_clk),
                   .i_cfg_avmm_clk (i_cfg_avmm_clk)
                   );
//  ndut_io maib_io ();

    //-----------------------------------------------------------------------------------------
    // Testbench instantiation
      test t (top_io);

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
                         .io_aib20              (aib20 ),
                         .io_aib21              (aib21 ),
                         .io_aib22              (aib22 ),
                         .io_aib23              (aib23 ),
                         .io_aib24              (aib24 ),
                         .io_aib25              (aib25 ),
                         .io_aib26              (aib26 ),
                         .io_aib27              (aib27 ),
                         .io_aib28              (aib28 ),
                         .io_aib29              (aib29 ),
                         .io_aib3               (aib3 ),
                         .io_aib30              (aib30),
                         .io_aib31              (aib31),
                         .io_aib32              (aib32),
                         .io_aib33              (aib33),
                         .io_aib34              (aib34),
                         .io_aib35              (aib35),
                         .io_aib36              (aib36),
                         .io_aib37              (aib37),
                         .io_aib38              (aib38),
                         .io_aib39              (aib39),
                         .io_aib4               (aib4 ),
                         .io_aib40              (aib40),
                         .io_aib41              (aib41),
                         .io_aib42              (aib40),
                         .io_aib43              (aib41),
                         .io_aib44              (aib44),
                         //.io_aib45              (aib45),
                         .io_aib45              (HI), //From Tim's 3/26 aib_bump_map
                         .io_aib46              (aib46),
                         .io_aib47              (aib47),
                         .io_aib48              (aib48),
                         .io_aib49              (aib49),
                         .io_aib5               (aib5 ),
                         .io_aib50              (aib50),
                         .io_aib51              (aib51),
                         .io_aib52              (aib52),
                         .io_aib53              (aib53),
                         .io_aib54              (aib54),
                         .io_aib55              (aib55),
                         .io_aib56              (aib56),
                         .io_aib57              (aib57),
                         //.io_aib58              (aib58),
                         .io_aib58              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib59              (aib59),
                         .io_aib6               (aib6 ),
                         .io_aib60              (aib60),
                         //.io_aib61              (aib61),
                         .io_aib61              (HI), //From Tim's 3/26 aib_bump_map
                         .io_aib62              (aib62),
                         //.io_aib63              (aib63),
                         .io_aib63              (LO), //From Tim's 3/26 aib_bump_map
                         //.io_aib64              (aib64),
                         .io_aib64              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib65              (aib65),
                         .io_aib66              (aib66),
                         //.io_aib67              (aib67),
                         .io_aib67              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib68              (aib68),
                         .io_aib69              (aib69),
                         .io_aib7               (aib7 ),
                         .io_aib70              (aib70),
                         .io_aib71              (aib71),
                         //.io_aib72              (aib72),
                         //.io_aib73              (aib73),
                         //.io_aib74              (aib74),
                         .io_aib72              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib73              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib74              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib75              (aib75),
                         .io_aib76              (aib76),
                         .io_aib77              (aib77),
                         //.io_aib78              (aib78),
                         //.io_aib79              (aib79),
                         //.io_aib80              (aib80),
                         //.io_aib81              (aib81),
                         .io_aib78              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib79              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib8               (aib8 ),
                         .io_aib80              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib81              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib82              (aib82),
                         .io_aib83              (aib83),
                         .io_aib84              (aib84),
                         .io_aib85              (aib85),
                         .io_aib86              (aib86),
                         .io_aib87              (aib87),
                         //.io_aib88              (aib88),
                         //.io_aib89              (aib89),
                         .io_aib88              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib89              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib9               (aib9 ),
                         .io_aib90              (aib90),
                         .io_aib91              (aib91),
                         .io_aib92              (aib92),
                         .io_aib93              (aib93),
                         .io_aib94              (aib94),
                         .io_aib95              (aib95),
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
                         .i_adpt_cfg_waitreq    (HI),
                         .i_rx_pma_clk          (i_rx_pma_clk),
                         .i_rx_pma_div2_clk     (i_rx_pma_div2_clk),
                         .i_osc_clk             (i_osc_clk),
                         .i_chnl_ssr            (top_io.i_chnl_ssr[64:0]),
                         .i_rx_pma_data         (top_io.i_rx_pma_data[39:0]),
                         .i_tx_pma_clk          (i_tx_pma_clk),
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
                         .i_aibdftdll2adjch     (13'h0));

`include "ndut_declare.sv"
`include "ndut_default.sv"
`include "nda_drv.sv"
`include "nda_port.sv"

endmodule 
