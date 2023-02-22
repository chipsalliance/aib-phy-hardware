// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

`timescale 1ps/1fs

`define NDADAPT_RTB top.s10_wrap.ndut.hdpldadapt
`include "c3dfx.vh"

module top;


    //------------------------------------------------------------------------------------------
    // Clock generation
    
    parameter CFG_AVMM_CLK_PERIOD = 4000;
    parameter OSC_CLK_PERIOD      = 1000;
    parameter PMA_CLK_PERIOD      = 1000;
    parameter USR_CLK_PERIOD      = 4000;
    parameter FWD_CLK_PERIOD      = 2000;
    
    reg   i_cfg_avmm_clk = 1'b0;
    reg	  i_osc_clk = 1'b0;
    reg   i_rx_pma_clk = 1'b0;
    reg   i_rx_pma_div2_clk = 1'b0;
    reg   i_tx_pma_clk = 1'b0;
    reg   tx_coreclkin = 1'b0;
    reg   rx_coreclkin = 1'b0;
    reg   sl_m_ns_fwd_clk = 1'b0; 
       
      //clock gen
      always #(CFG_AVMM_CLK_PERIOD/2) i_cfg_avmm_clk = ~i_cfg_avmm_clk;
        always #(OSC_CLK_PERIOD/2)      i_osc_clk      = ~i_osc_clk;
//      always #(PMA_CLK_PERIOD/2)      i_rx_pma_clk   = ~i_rx_pma_clk;
//      always #(PMA_CLK_PERIOD)        i_rx_pma_div2_clk = ~i_rx_pma_div2_clk;
//      always #(PMA_CLK_PERIOD/2)      i_tx_pma_clk   = ~i_tx_pma_clk;

     //=================================================================================
    //Below are DFx related signals, temporarily tie them off to 0s, need to be changed later
    logic [79:0] tx_parallel_data = 0;
    logic [79:0] rx_parallel_data;

    always #(USR_CLK_PERIOD/2) tx_coreclkin = ~tx_coreclkin;
    always #(USR_CLK_PERIOD/2) rx_coreclkin = ~rx_coreclkin;
    always #(FWD_CLK_PERIOD/2) sl_m_ns_fwd_clk = ~sl_m_ns_fwd_clk;
    int run_for_n_pkts;
    logic [79:0] xmit_q [$];
    int err_count;
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

`include "ndut_declare.sv"
`include "ndut_default.sv"
`include "nda_drv.sv"
`include "nda_port.sv"

endmodule 
