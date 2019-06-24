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
    wire  [80:0]        ms_sideband;
    wire  [72:0]        sl_sideband;              
    wire  [20-1:0]      iopad_tx;              
    wire  [20-1:0]      iopad_rx;             
    wire                iopad_ns_fwd_clkb;   
    wire                iopad_ns_fwd_clk;   
    wire                iopad_fs_fwd_clkb; 
    wire                iopad_fs_fwd_clk;  
    wire                iopad_fs_mac_rdy;    
    wire                iopad_ns_mac_rdy;   
    wire                iopad_ns_adapt_rstn;
    wire                iopad_fs_rcv_clk;  
    wire                iopad_fs_rcv_clkb;
    wire                iopad_fs_adapt_rstn; 
    wire                iopad_fs_sr_clkb;   
    wire                iopad_fs_sr_clk;   
    wire                iopad_ns_sr_clk;  
    wire                iopad_ns_sr_clkb;
    wire                iopad_ns_rcv_clkb;
    wire                iopad_ns_rcv_clk; 
    wire                iopad_fs_sr_load; 
    wire                iopad_fs_sr_data; 
    wire                iopad_ns_sr_load;
    wire                iopad_ns_sr_data;

    wire                HI, LO;
    assign              HI = 1'b1;
    assign              LO = 1'b0;

/*//////////////////////////////////////////////////////////////////////////
   iopad_tx  loopback to iopad_rx  --transfer data    -> receiving data
   iopad_ns_fwd_clk/clkb loopback to iopad_fs_rcv_clk/clkb  --transfer clk     -> receiving clk
   iopad_ns_sr_clk/clkb  loopback to iopad_fs_sr_clk/clkb  --transfer sr_clk  -> receiving sr_clk
   iopad_ns_sr_load      loopback iopad_fs_sr_load        --ssr_load_out     -> ssr_load_in

   The following pins are tied to high so that the loopback test will work:
   iopad_fs_sr_data 
   iopad_fs_adapt_rstn 
   
*///////////////////////////////////////////////////////////////////////////   
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
                         .o_tx_pma_data         (o_tx_pma_data[39:0]),
                         .data_out              (o_tx_elane_data[77:0]),
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
                         .iopad_tx              (iopad_tx), 
                         .iopad_rx              (iopad_tx), 
                         .iopad_ns_fwd_clkb     (iopad_ns_fwd_clkb),
                         .iopad_ns_fwd_clk      (iopad_ns_fwd_clk),
                         .iopad_fs_fwd_clkb     (iopad_ns_fwd_clkb),
                         .iopad_fs_fwd_clk      (iopad_ns_fwd_clk),
                         .iopad_fs_mac_rdy      (iopad_ns_mac_rdy),
                         .iopad_ns_mac_rdy      (iopad_ns_mac_rdy),
                         .iopad_ns_adapt_rstn   (iopad_ns_adapt_rstn),
                         .iopad_fs_rcv_clk      (iopad_ns_fwd_clk),
                         .iopad_fs_rcv_clkb     (iopad_ns_fwd_clkb),
                         .iopad_fs_adapt_rstn   (HI),
                         .iopad_fs_sr_clkb      (iopad_ns_sr_clkb),
                         .iopad_fs_sr_clk       (iopad_ns_sr_clk),
                         .iopad_ns_sr_clk       (iopad_ns_sr_clk),
                         .iopad_ns_sr_clkb      (iopad_ns_sr_clkb),
                         .iopad_ns_rcv_clkb     (iopad_ns_rcv_clkb),
                         .iopad_ns_rcv_clk      (iopad_ns_rcv_clk),
                         .iopad_fs_sr_load      (iopad_ns_sr_load),
                         .iopad_fs_sr_data      (HI),
                         .iopad_ns_sr_load      (iopad_ns_sr_load),
                         .iopad_ns_sr_data      (iopad_ns_sr_data),

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
                         .i_adpt_cfg_waitreq    (1'b1),
                         .m_ns_fwd_clk          (i_rx_pma_clk),
                         .m_ns_fwd_div2_clk     (i_rx_pma_div2_clk),
                         .i_osc_clk             (i_osc_clk),
                         .i_chnl_ssr            (top_io.i_chnl_ssr[64:0]),
                         .i_rx_pma_data         (top_io.i_rx_pma_data[39:0]),
                         .i_rx_elane_clk        (i_rx_elane_clk),
                         .data_in               (top_io.i_rx_elane_data[77:0]),
                         .m_ns_rcv_clk          (i_tx_pma_clk),
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
                         .i_aibdftdll2adjch     (13'h0));

endmodule 
