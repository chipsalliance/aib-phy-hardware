// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1fs
`ifdef S10_MODEL
  `define NDADAPT_RTB top.s10_wrap.ndut.hdpldadapt
`endif
`include "c3dfx.vh"

module top;


    //------------------------------------------------------------------------------------------
    // Clock generation
    
    parameter CFG_AVMM_CLK_PERIOD = 4000;
    parameter OSC_CLK_PERIOD      = 1000;
`ifdef REGISTER_MOD
    parameter PMA_CLK_PERIOD      = 4000;
`else
    parameter PMA_CLK_PERIOD      = 1000;
`endif
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
    wire[19:0]         ms_iopad_tx;
    wire[19:0]         ms_iopad_rx;
    wire               ms_iopad_ns_fwd_clkb;
    wire               ms_iopad_ns_fwd_clk;
    wire               ms_iopad_fs_fwd_clkb;
    wire               ms_iopad_fs_fwd_clk;
    wire               ms_iopad_fs_mac_rdy;
    wire               ms_iopad_ns_mac_rdy;
    wire               ms_iopad_ns_adapter_rstn;
    wire               ms_iopad_fs_rcv_clk;
    wire               ms_iopad_fs_rcv_clkb;
    wire               ms_iopad_fs_adapter_rstn;
    wire               ms_iopad_fs_sr_clkb;
    wire               ms_iopad_fs_sr_clk;
    wire               ms_iopad_ns_sr_clk;
    wire               ms_iopad_ns_sr_clkb;
    wire               ms_iopad_ns_rcv_clkb;
    wire               ms_iopad_ns_rcv_clk;
    wire               ms_iopad_fs_sr_load;
    wire               ms_iopad_fs_sr_data;
    wire               ms_iopad_ns_sr_load;
    wire               ms_iopad_ns_sr_data;

`ifdef S10_MODEL
    wire               iopad_unused_aib45;
    wire               iopad_unused_aib46;
    wire               iopad_unused_aib47;
    wire               iopad_unused_aib50;
    wire               iopad_unused_aib51;
    wire               iopad_unused_aib52;
    wire               iopad_unused_aib58;
    wire               iopad_unused_aib60;
    wire               iopad_unused_aib61;
    wire               iopad_unused_aib62;
    wire               iopad_unused_aib63;
    wire               iopad_unused_aib64;
    wire               iopad_unused_aib66;
    wire               iopad_unused_aib67;
    wire               iopad_unused_aib68;
    wire               iopad_unused_aib69;
    wire               iopad_unused_aib70;
    wire               iopad_unused_aib71;
    wire               iopad_unused_aib72;
    wire               iopad_unused_aib73;
    wire               iopad_unused_aib74;
    wire               iopad_unused_aib75;
    wire               iopad_unused_aib76;
    wire               iopad_unused_aib77;
    wire               iopad_unused_aib78;
    wire               iopad_unused_aib79;
    wire               iopad_unused_aib80;
    wire               iopad_unused_aib81;
    wire               iopad_unused_aib88;
    wire               iopad_unused_aib89;
    wire               iopad_unused_aib90;
    wire               iopad_unused_aib91;
`endif

    
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
    
    c3aib_master dut (/*AUTOINST*/
                         // Outputs
                         .o_adpt_hard_rst_n     (o_adpt_hard_rst_n),
                         .fs_mac_rdy            (o_rx_xcvrif_rst_n),
                         .o_tx_xcvrif_rst_n     (o_tx_xcvrif_rst_n),
                         .sl_tx_transfer_en     (o_ehip_init_status[0]),
                         .ms_tx_transfer_en     (o_ehip_init_status[1]),
                         .ms_osc_transfer_alive (o_ehip_init_status[2]),
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
                         .m_fs_fwd_clk          (o_tx_transfer_clk),
                         .m_fs_fwd_div2_clk     (o_tx_transfer_div2_clk),
                         .data_out              (o_tx_pma_data[39:0]),
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
                         .iopad_tx              (ms_iopad_tx),
                         .iopad_rx              (ms_iopad_rx),
                         .iopad_ns_fwd_clkb     (ms_iopad_ns_fwd_clkb),
                         .iopad_ns_fwd_clk      (ms_iopad_ns_fwd_clk),
                         .iopad_ns_fwd_div2_clkb(ms_iopad_ns_fwd_div2_clkb),
                         .iopad_ns_fwd_div2_clk (ms_iopad_ns_fwd_div2_clk),
                         .iopad_fs_fwd_clkb     (ms_iopad_fs_fwd_clkb),
                         .iopad_fs_fwd_clk      (ms_iopad_fs_fwd_clk),
                         .iopad_fs_mac_rdy      (ms_iopad_fs_mac_rdy),
                         .iopad_ns_mac_rdy      (ms_iopad_ns_mac_rdy),
                         .iopad_ns_adapter_rstn (ms_iopad_ns_adapter_rstn),
                         .iopad_fs_rcv_clk      (ms_iopad_fs_rcv_clk),
                         .iopad_fs_rcv_clkb     (ms_iopad_fs_rcv_clkb),
                         .iopad_fs_adapter_rstn (ms_iopad_fs_adapter_rstn),
                         .iopad_fs_sr_clkb      (ms_iopad_fs_sr_clkb),
                         .iopad_fs_sr_clk       (ms_iopad_fs_sr_clk),
                         .iopad_ns_sr_clk       (ms_iopad_ns_sr_clk),
                         .iopad_ns_sr_clkb      (ms_iopad_ns_sr_clkb),
                         .iopad_ns_rcv_clkb     (ms_iopad_ns_rcv_clkb),
                         .iopad_ns_rcv_clk      (ms_iopad_ns_rcv_clk),
                         .iopad_ns_rcv_div2_clkb(ms_iopad_ns_rcv_div2_clkb),
                         .iopad_ns_rcv_div2_clk (ms_iopad_ns_rcv_div2_clk),
                         .iopad_fs_sr_load      (ms_iopad_fs_sr_load),
                         .iopad_fs_sr_data      (ms_iopad_fs_sr_data),
                         .iopad_ns_sr_load      (ms_iopad_ns_sr_load),
                         .iopad_ns_sr_data      (ms_iopad_ns_sr_data),
`ifdef S10_MODEL
                         .iopad_unused_aib45,
                         .iopad_unused_aib46,
                         .iopad_unused_aib47,
                         .iopad_unused_aib50,
                         .iopad_unused_aib51,
                         .iopad_unused_aib52,
                         .iopad_unused_aib58,
                         .iopad_unused_aib60,
                         .iopad_unused_aib61,
                         .iopad_unused_aib62,
                         .iopad_unused_aib63,
                         .iopad_unused_aib64,
                         .iopad_unused_aib66,
                         .iopad_unused_aib67,
                         .iopad_unused_aib68,
                         .iopad_unused_aib69,
                         .iopad_unused_aib70,
                         .iopad_unused_aib71,
                         .iopad_unused_aib72,
                         .iopad_unused_aib73,
                         .iopad_unused_aib74,
                         .iopad_unused_aib75,
                         .iopad_unused_aib76,
                         .iopad_unused_aib77,
                         .iopad_unused_aib78,
                         .iopad_unused_aib79,
                         .iopad_unused_aib80,
                         .iopad_unused_aib81,
                         .iopad_unused_aib88,
                         .iopad_unused_aib89,
                         .iopad_unused_aib90,
                         .iopad_unused_aib91,

`endif

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
                         .m_ns_fwd_clk          (i_rx_pma_clk),
                         .m_ns_fwd_div2_clk     (i_rx_pma_div2_clk),
                         .i_osc_clk             (i_osc_clk),
                         .i_chnl_ssr            (top_io.i_chnl_ssr[64:0]),
                         .data_in               (top_io.i_rx_pma_data[39:0]),
                         .m_ns_rcv_clk          (i_tx_pma_clk),
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
