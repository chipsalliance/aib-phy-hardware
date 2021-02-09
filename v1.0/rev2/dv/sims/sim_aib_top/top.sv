// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================

// This testsbench shows how to connect 24 channel AIB (all channels are independent)
// in loopback mode. DCC/DLL are bypassed. The delay setting is static
// 03/13/2019


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
    wire  [24*40-1:0]   o_tx_pma_data_24ch;
    wire  [23:0]        o_tx_transfer_clk;      // From dut of c3aibadapt_wrap.v
    logic [23:0]        o_tx_transfer_div2_clk; // From dut of c3aibadapt_wrap.v
    wire                o_txen_out_chain1;      // From dut of c3aibadapt_wrap.v
    wire                o_txen_out_chain2;      // From dut of c3aibadapt_wrap.v
    wire  [81*24-1:0]   ms_sideband;
    wire  [73*24-1:0]   sl_sideband;              
    wire  [7:0]         iopad_unused_aux95_88;
    wire                iopad_power_on_reset_r; //iopad_aib_aux[87] power on redundency from slave
    wire                iopad_unused_aux86;
    wire                iopad_power_on_reset;   //iopad_aib_aux[85] power on from slave.
    wire  [8:0]         iopad_unused_aux84_76;
    wire                iopad_device_detect_r;  //iopad_aib_aux[75] device detect redundency to slave
    wire                iopad_device_detect;    //iopad_aib_aux[74] device detect to slave
    wire  [73:0]        iopad_unused_aux73_0;

    wire  [24*20-1:0]   iopad_tx;              
    wire  [24*20-1:0]   iopad_rx;             
    wire  [23:0]        iopad_ns_fwd_clkb;   
    wire  [23:0]        iopad_ns_fwd_clk;   
    wire  [23:0]        iopad_fs_fwd_clkb; 
    wire  [23:0]        iopad_fs_fwd_clk;  
    wire  [23:0]        iopad_fs_mac_rdy;    
    wire  [23:0]        iopad_ns_mac_rdy;   
    wire  [23:0]        iopad_ns_adapter_rstn;
    wire  [23:0]        iopad_fs_rcv_clk;  
    wire  [23:0]        iopad_fs_rcv_clkb;
    wire  [23:0]        iopad_fs_adapter_rstn; 
    wire  [23:0]        iopad_fs_sr_clkb;   
    wire  [23:0]        iopad_fs_sr_clk;   
    wire  [23:0]        iopad_ns_sr_clk;  
    wire  [23:0]        iopad_ns_sr_clkb;
    wire  [23:0]        iopad_ns_rcv_clkb;
    wire  [23:0]        iopad_ns_rcv_clk; 
    wire  [23:0]        iopad_fs_sr_load; 
    wire  [23:0]        iopad_fs_sr_data; 
    wire  [23:0]        iopad_ns_sr_load;
    wire  [23:0]        iopad_ns_sr_data;
    wire  [23:0]        HI24 = 24'hffffff;
/*//////////////////////////////////////////////////////////////////////////
   iopad_tx  loopback to iopad_rx  --transfer data    -> receiving data
   iopad_ns_fwd_clk/clkb loopback to iopad_fs_rcv_clk/clkb  --transfer clk     -> receiving clk
   iopad_ns_sr_clk/clkb  loopback to iopad_fs_sr_clk/clkb  --transfer sr_clk  -> receiving sr_clk
   iopad_ns_sr_load      loopback iopad_fs_sr_load        --ssr_load_out     -> ssr_load_in

   The following pins are tied to high so that the loopback test will work:
   iopad_fs_sr_data 
   iopad_fs_adapter_rstn 
   
*///////////////////////////////////////////////////////////////////////////   
//-----------------------------------------------------------------------------------------
// Interface instantiation

    dut_io top_io (.i_osc_clk (i_osc_clk), 
                   .i_rx_pma_clk (i_rx_pma_clk),
                   .i_tx_pma_clk (i_tx_pma_clk),
                   .i_cfg_avmm_clk (i_cfg_avmm_clk)
                   );

//-----------------------------------------------------------------------------------------
// Testbench instantiation
    test t (top_io);

    aib_top_wrapper_v1m u_aib_top_master
             (
                    .i_adpt_hard_rst_n           (top_io.i_adpt_hard_rst_n), 
                    .fs_mac_rdy                  (),   
                    .i_cfg_avmm_clk              (i_cfg_avmm_clk), 
                    .i_cfg_avmm_rst_n            (top_io.i_cfg_avmm_rst_n), 
                    .i_cfg_avmm_addr             (top_io.i_cfg_avmm_addr[16:0]), 
                    .i_cfg_avmm_byte_en          (top_io.i_cfg_avmm_byte_en[3:0]), 
                    .i_cfg_avmm_read             (top_io.i_cfg_avmm_read), 
                    .i_cfg_avmm_write            (top_io.i_cfg_avmm_write), 
                    .i_cfg_avmm_wdata            (top_io.i_cfg_avmm_wdata[31:0]), 
                    .o_cfg_avmm_rdatavld         (o_cfg_avmm_rdatavld),
                    .o_cfg_avmm_rdata            (o_cfg_avmm_rdata), 
                    .o_cfg_avmm_waitreq          (o_cfg_avmm_waitreq), 
                    .m_ns_fwd_clk                ({24{i_rx_pma_clk}}), 
                    .m_ns_fwd_div2_clk           ({24{i_rx_pma_div2_clk}}), 
                    .i_chnl_ssr                  ({65*24{1'b0}}),   
                    .data_in                     ({24{top_io.i_rx_pma_data[39:0]}}), 
                    .m_ns_rcv_clk                ({24{i_tx_pma_clk}}), 
                    .o_chnl_ssr                  (),        
                    .m_fs_fwd_clk                (o_tx_transfer_clk), 
                    .m_fs_fwd_div2_clk           (o_tx_transfer_div2_clk),        // Not used 
                    .data_out                    (o_tx_pma_data_24ch), 
		  //.ns_mac_rdy                  ({24{top_io.ns_mac_rdy}}),
                  //.ms_sideband                 (ms_sideband),
		  //.sl_sideband                 (sl_sideband),
                    .iopad_tx                    (iopad_tx),
                    .iopad_rx                    (iopad_tx),
                    .iopad_ns_fwd_clkb           (iopad_ns_fwd_clkb),
                    .iopad_ns_fwd_clk            (iopad_ns_fwd_clk),
                    .iopad_fs_fwd_clkb           (iopad_ns_fwd_clkb),
                    .iopad_fs_fwd_clk            (iopad_ns_fwd_clk),
                    .iopad_fs_mac_rdy            (iopad_ns_mac_rdy),
                    .iopad_ns_mac_rdy            (iopad_ns_mac_rdy),
                    .iopad_ns_adapter_rstn       (iopad_ns_adapter_rstn),
                    .iopad_fs_rcv_clk            (iopad_ns_fwd_clk),
                    .iopad_fs_rcv_clkb           (iopad_ns_fwd_clkb),
                    .iopad_fs_adapter_rstn       (HI24),
                    .iopad_fs_sr_clkb            (iopad_ns_sr_clkb),
                    .iopad_fs_sr_clk             (iopad_ns_sr_clk),
                    .iopad_ns_sr_clk             (iopad_ns_sr_clk),
                    .iopad_ns_sr_clkb            (iopad_ns_sr_clkb),
                    .iopad_ns_rcv_clkb           (iopad_ns_rcv_clkb),
                    .iopad_ns_rcv_clk            (iopad_ns_rcv_clk),
                    .iopad_fs_sr_load            (iopad_ns_sr_load),
                    .iopad_fs_sr_data            (HI24),
                    .iopad_ns_sr_load            (iopad_ns_sr_load),
                    .iopad_ns_sr_data            (iopad_ns_sr_data),
                 // .io_aib_aux                  (AIB_AUX),
                    .iopad_unused_aux95_88       (iopad_unused_aux95_88),
                    .iopad_power_on_reset_r      (iopad_power_on_reset_r),
                    .iopad_unused_aux86          (iopad_unused_aux86),
                    .iopad_power_on_reset        (iopad_power_on_reset),
                    .iopad_unused_aux84_76       (iopad_unused_aux84_76),
                    .iopad_device_detect_r       (iopad_device_detect_r),
                    .iopad_device_detect         (iopad_device_detect),
                    .iopad_unused_aux73_0        (iopad_unused_aux73_0),
                    .io_aux_bg_ext_2k            (io_aux_bg_ext_2k),
	            .i_iocsr_rdy_aibaux          (top_io.i_adpt_hard_rst_n),
	            .i_aibaux_por_vccl_ovrd      (1'b1),      
                    .i_aibaux_ctrl_bus0          (32'b0), 
//                  .i_aibaux_ctrl_bus1          (32'h805001e0),  //observe oosc dft[12:0] 
                    .i_aibaux_ctrl_bus1          (32'h00500020),  //observe oosc dft[12:0] 
                    .i_aibaux_ctrl_bus2          (32'b0), 
                    .i_aibaux_osc_fuse_trim      (10'b0), 
//                  .i_osc_bypclk                (i_osc_clk),  
                    .i_osc_bypclk                (1'b0),  
                    .o_aibaux_osc_clk            (),      
                    .i_scan_clk                  (1'b0), 
                    .i_test_clk_125m             (1'b0), 
                    .i_test_clk_1g               (1'b0), 
                    .i_test_clk_250m             (1'b0), 
                    .i_test_clk_500m             (1'b0), 
                    .i_test_clk_62m              (1'b0), 	      
                    .i_test_c3adapt_scan_in      ({24*17{1'b0}}),
//                  .i_test_c3adapt_tcb_static_common (60'h010_8421_0842_1000),
                    .i_test_c3adapt_tcb_static_common (60'h050_8421_0842_1000),
	            .o_test_c3adapt_scan_out     (),
                    .i_jtag_clkdr                (1'b0),   
                    .i_jtag_clksel               (1'b0),   
                    .i_jtag_intest               (1'b0),   
                    .i_jtag_mode                 (1'b0),   
                    .i_jtag_rstb_en              (1'b0),   
                    .i_jtag_rstb                 (1'b0),   
                    .i_jtag_weakpdn              (1'b0),   
                    .i_jtag_weakpu               (1'b0), 	      
                    .i_jtag_tx_scan              (1'b0),
                    .i_jtag_tx_scanen            (1'b0),
                    .i_aibdft2osc                ({1'b0, 1'b1, i_rx_pma_div2_clk}),
                    .o_aibdft2osc                (),
                    .o_last_bs_out               (),
                    .m_power_on_reset            (),
                    .o_osc_monitor               (),
                    .i_aux_atpg_mode_n           (1'b1),  //FIXME
                    .i_aux_atpg_pipeline_global_en (1'b0),  //FIXME
                    .i_aux_atpg_rst_n            (1'b1),  //FIXME
                    .i_aux_atpg_scan_clk         (1'b0),
                    .i_aux_atpg_scan_in          (1'b0),
                    .i_aux_atpg_scan_shift_n     (1'b1),  //FIXME
                    .o_aux_atpg_scan_out         ()    	      
               );

    
endmodule 

