// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================

// This module maps aib_top port to AIB specification 1.1 in master mode 
// 06/22/2019


`timescale 1ps/1ps

module aib_top_wrapper_v2m
  # (
     parameter DATA_WIDTH = 78,
     parameter TOTAL_CHNL_NUM = 24
     )
  (
     //================================================================================================
   // Reset Inteface
   input                                                          i_conf_done, // AIB adaptor hard reset. It resets IO buffer

   // reset for XCVRIF
   output [TOTAL_CHNL_NUM-1:0]                                    fs_mac_rdy, //o_rx_xcvrif_rst_n,  receiving path reset
   
   //===============================================================================================
   // Configuration Interface which includes two paths
 
   // Path directly from chip programming controller
   input                                                          i_cfg_avmm_clk, 
   input                                                          i_cfg_avmm_rst_n, 
   input [16:0]                                                   i_cfg_avmm_addr, // address to be programmed
   input [3:0]                                                    i_cfg_avmm_byte_en, // byte enable
   input                                                          i_cfg_avmm_read, // Asserted to indicate the Cfg read access
   input                                                          i_cfg_avmm_write, // Asserted to indicate the Cfg write access
   input [31:0]                                                   i_cfg_avmm_wdata, // data to be programmed
 
   output                                                         o_cfg_avmm_rdatavld,// Assert to indicate data available for Cfg read access 
   output [31:0]                                                  o_cfg_avmm_rdata, // data returned for Cfg read access
   output                                                         o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg access

 //===============================================================================================
 // Data Path
 // Rx Path clocks/data, from master (current chiplet) to slave (FPGA)
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_fwd_clk, // i_rx_pma_clk.Rx path clk for data receiving,
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_fwd_div2_clk, // i_rx_pma_div2_clk, Divided by 2 clock on Rx pathinput
    
   input [TOTAL_CHNL_NUM*40-1:0]                                  data_in_reg_mode, // 40 bit data in for register mode
   input [TOTAL_CHNL_NUM*78-1:0]                                  data_in ,   // 78 bit data for 2x FIFO mode
   input [TOTAL_CHNL_NUM-1:0]                                     m_wr_clk,  //Clock for phase compensation fifo

 
 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_rcv_clk, //i_tx_pma_clk, sent over to the other chiplet to be used for the clock 
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_fwd_clk, //o_tx_transfer_clk, clock used for tx data transmission
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_fwd_div2_clk, // o_tx_transfer_div2_clk, half rate of tx data transmission clock
   output [TOTAL_CHNL_NUM*40-1:0]                                 data_out_reg_mode, // 40 bit data out for register mode
   output [TOTAL_CHNL_NUM*78-1:0]                                 data_out, // 78 bit data out for 2xFIFO mode.
   input  [TOTAL_CHNL_NUM-1:0]                                    m_rd_clk, //Clock for phase compensation fifo
 //=================================================================================================
 // AIB open source IP enhancement. The following ports are added to
 // be compliance with AIB specification 1.1
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive //     data. use aibio49
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_adapter_rstn, //From Mac. To reset near site adapt reset state machine and far site sm. Not implemented currently.

   output [TOTAL_CHNL_NUM*81-1:0]                                 ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
   output [TOTAL_CHNL_NUM*73-1:0]                                 sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet.
   output [TOTAL_CHNL_NUM-1:0]                                    ms_rx_transfer_en, //master link rx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    ms_tx_transfer_en, //master link tx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    sl_rx_transfer_en, //slave link rx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    sl_tx_transfer_en, //slave link tx transfer enable

   output [TOTAL_CHNL_NUM-1:0]                                    m_rxfifo_align_done,
   //=================================================================================================
   // Inout signals for AIB ubump
   inout  [TOTAL_CHNL_NUM*20-1:0]                                 iopad_tx,
   inout  [TOTAL_CHNL_NUM*20-1:0]                                 iopad_rx,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_fwd_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_fwd_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_fwd_div2_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_fwd_div2_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_fwd_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_fwd_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_mac_rdy,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_mac_rdy,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_adapter_rstn,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_rcv_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_rcv_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_adapter_rstn,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_sr_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_sr_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_sr_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_sr_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_rcv_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_rcv_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_rcv_div2_clkb,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_rcv_div2_clk,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_sr_load,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_fs_sr_data,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_sr_load,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_ns_sr_data,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib45,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib46,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib47,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib50,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib51,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib52,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib58,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib60,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib61,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib62,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib63,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib64,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib66,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib67,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib68,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib69,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib70,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib71,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib72,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib73,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib74,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib75,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib76,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib77,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib78,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib79,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib80,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib81,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib88,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib89,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib90,
   inout  [TOTAL_CHNL_NUM-1:0]                                    iopad_unused_aib91,


   inout                                                          iopad_power_on_reset_r, //iopad_aib_aux[87] power on redundency from slave
   inout                                                          iopad_power_on_reset,   //iopad_aib_aux[85] power on from slave.
   inout                                                          iopad_device_detect_r,  //iopad_aib_aux[75] device detect redundency to slave
   inout                                                          iopad_device_detect,    //iopad_aib_aux[74] device detect to slave

   //======================================================================================

   input                                                          m_por_ovrd, //test por override through c4 bump
   
   input                                                          i_osc_clk,     // test clock from c4 bump, may tie low for User if not used
    //======================================================================================
   // DFT signals
   input                                                          i_scan_clk,     //ATPG Scan shifting clock from Test Pad.  
   input                                                          i_test_scan_en,
   input                                                          i_test_scan_mode,
   input                                                          i_test_clk_1g,  //1GHz free running direct accessed ATPG at speed clock.
   input                                                          i_test_clk_125m,//Divided down from i_test_clk_1g. 
   input                                                          i_test_clk_250m,//Divided down from i_test_clk_1g.
   input                                                          i_test_clk_500m,//Divided down from i_test_clk_1g.
   input                                                          i_test_clk_62m, //Divided down from i_test_clk_1g.
                                                                                  //The divided down clock is for different clock domain at
                                                                                  //speed test.
   //Channel ATPG signals from/to CODEC
   input [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  i_test_c3adapt_scan_in, //scan in hook from Codec 
   output [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] o_test_c3adapt_scan_out, //scan out hook to Codec
  
   //Inputs from TCB (JTAG signals)
   input                                                          i_jtag_clkdr, // (from dbg_test_bscan block)Enable AIB IO boundary scan clock (clock gate control)
   input                                                          i_jtag_clksel, // (from dbg_test_bscan block)Select between i_jtag_clkdr_in and functional clk
   input                                                          i_jtag_intest, // (from dbg_test_bscan block)Enable in test operation
   input                                                          i_jtag_mode, // (from dbg_test_bscan block)Selects between AIB BSR register or functional path
   input                                                          i_jtag_rstb, // (from dbg_test_bscan block)JTAG controlleable reset the AIB IO circuitry
   input                                                          i_jtag_rstb_en, // (from dbg_test_bscan block)JTAG controlleable override to reset the AIB IO circuitry
   input                                                          i_jtag_tdi, // (from dbg_test_bscan block)TDI
   input                                                          i_jtag_tx_scanen,// (from dbg_test_bscan block)Drives AIB IO jtag_tx_scanen_in or BSR shift control  
   input                                                          i_jtag_weakpdn,  //(from dbg_test_bscan block)Enable AIB global pull down test. 
   input                                                          i_jtag_weakpu,  //(from dbg_test_bscan block)Enable AIB global pull up test. 
   output                                                         o_jtag_tdo, //last boundary scan chain output, TDO 
   output                                                         m_power_on_reset // S10 POR to User, can be left unconnected for User. In theory, MAc on master side
                                                                                    // should look at this signal to determine if "slave" is there and slave complete power up seq.

   );

wire                            HI, LO;
assign                          HI = 1'b1;
assign                          LO = 1'b0;

//assign  i_rx_pma_data = data_in;


    aib_top_v2m u_aib_top
             (
                    .i_conf_done                 (i_conf_done), 
                    .fs_mac_rdy                  (fs_mac_rdy),   
                    .i_cfg_avmm_clk              (i_cfg_avmm_clk), 
                    .i_cfg_avmm_rst_n            (i_cfg_avmm_rst_n), 
                    .i_cfg_avmm_addr             (i_cfg_avmm_addr[16:0]), 
                    .i_cfg_avmm_byte_en          (i_cfg_avmm_byte_en[3:0]), 
                    .i_cfg_avmm_read             (i_cfg_avmm_read), 
                    .i_cfg_avmm_write            (i_cfg_avmm_write), 
                    .i_cfg_avmm_wdata            (i_cfg_avmm_wdata[31:0]), 
                    .o_cfg_avmm_rdatavld         (o_cfg_avmm_rdatavld),
                    .o_cfg_avmm_rdata            (o_cfg_avmm_rdata), 
                    .o_cfg_avmm_waitreq          (o_cfg_avmm_waitreq), 
                    .m_ns_fwd_clk                (m_ns_fwd_clk), 
                    .m_ns_fwd_div2_clk           (m_ns_fwd_div2_clk), 
                    .m_wr_clk                    (m_wr_clk),
                    .data_in                     (data_in),
                    .data_in_reg_mode            (data_in_reg_mode),
                    .m_ns_rcv_clk                (m_ns_rcv_clk), 
                    .m_fs_fwd_clk                (m_fs_fwd_clk), 
                    .m_fs_fwd_div2_clk           (m_fs_fwd_div2_clk),        // Not used 
                    .m_rd_clk                    (m_rd_clk),
                    .data_out                    (data_out),
                    .data_out_reg_mode           (data_out_reg_mode),
		    .ns_mac_rdy                  (ns_mac_rdy),
                    .ns_adapter_rstn             (ns_adapter_rstn),
                    .ms_sideband                 (ms_sideband),
		    .sl_sideband                 (sl_sideband),
                    .m_rxfifo_align_done         (m_rxfifo_align_done),
                    .ms_tx_transfer_en           (ms_tx_transfer_en[TOTAL_CHNL_NUM-1:0]),
                    .ms_rx_transfer_en           (ms_rx_transfer_en[TOTAL_CHNL_NUM-1:0]),
                    .sl_tx_transfer_en           (sl_tx_transfer_en[TOTAL_CHNL_NUM-1:0]),
                    .sl_rx_transfer_en           (sl_rx_transfer_en[TOTAL_CHNL_NUM-1:0]),
    
                    .m0_ch0_aib                  ({  iopad_ns_sr_data[0],       iopad_ns_sr_load[0],       iopad_fs_sr_data[0],      iopad_fs_sr_load[0],
                                                   iopad_unused_aib91[0],     iopad_unused_aib90[0],     iopad_unused_aib89[0],    iopad_unused_aib88[0],
                                                     iopad_ns_rcv_clk[0],      iopad_ns_rcv_clkb[0],        iopad_ns_sr_clk[0],      iopad_ns_sr_clkb[0],
                                                      iopad_fs_sr_clk[0],       iopad_fs_sr_clkb[0],     iopad_unused_aib81[0],    iopad_unused_aib80[0],
                                                   iopad_unused_aib79[0],     iopad_unused_aib78[0],     iopad_unused_aib77[0],    iopad_unused_aib76[0],
                                                   iopad_unused_aib75[0],     iopad_unused_aib74[0],     iopad_unused_aib73[0],    iopad_unused_aib72[0],
                                                   iopad_unused_aib71[0],     iopad_unused_aib70[0],     iopad_unused_aib69[0],    iopad_unused_aib68[0],
                                                   iopad_unused_aib67[0],     iopad_unused_aib66[0],  iopad_fs_adapter_rstn[0],    iopad_unused_aib64[0],
                                                   iopad_unused_aib63[0],     iopad_unused_aib62[0],     iopad_unused_aib61[0],    iopad_unused_aib60[0],
                                                    iopad_fs_rcv_clkb[0],     iopad_unused_aib58[0],     iopad_fs_rcv_clk[0],   iopad_ns_adapter_rstn[0],
                                               iopad_ns_rcv_div2_clkb[0], iopad_ns_fwd_div2_clkb[0],  iopad_ns_fwd_div2_clk[0],    iopad_unused_aib52[0],
                                                   iopad_unused_aib51[0],     iopad_unused_aib50[0],       iopad_ns_mac_rdy[0], iopad_ns_rcv_div2_clk[0],
                                                   iopad_unused_aib47[0],     iopad_unused_aib46[0],     iopad_unused_aib45[0],      iopad_fs_mac_rdy[0],
                                                     iopad_fs_fwd_clk[0],      iopad_fs_fwd_clkb[0],       iopad_ns_fwd_clk[0],     iopad_ns_fwd_clkb[0],
                                                      iopad_rx[19:0],         iopad_tx[19:0]}),

                    .m0_ch1_aib                  ({  iopad_ns_sr_data[1],       iopad_ns_sr_load[1],       iopad_fs_sr_data[1],      iopad_fs_sr_load[1],
                                                   iopad_unused_aib91[1],     iopad_unused_aib90[1],     iopad_unused_aib89[1],    iopad_unused_aib88[1],
                                                     iopad_ns_rcv_clk[1],      iopad_ns_rcv_clkb[1],        iopad_ns_sr_clk[1],      iopad_ns_sr_clkb[1],
                                                      iopad_fs_sr_clk[1],       iopad_fs_sr_clkb[1],     iopad_unused_aib81[1],    iopad_unused_aib80[1],
                                                   iopad_unused_aib79[1],     iopad_unused_aib78[1],     iopad_unused_aib77[1],    iopad_unused_aib76[1],
                                                   iopad_unused_aib75[1],     iopad_unused_aib74[1],     iopad_unused_aib73[1],    iopad_unused_aib72[1],
                                                   iopad_unused_aib71[1],     iopad_unused_aib70[1],     iopad_unused_aib69[1],    iopad_unused_aib68[1],
                                                   iopad_unused_aib67[1],     iopad_unused_aib66[1],  iopad_fs_adapter_rstn[1],    iopad_unused_aib64[1],
                                                   iopad_unused_aib63[1],     iopad_unused_aib62[1],     iopad_unused_aib61[1],    iopad_unused_aib60[1],
                                                    iopad_fs_rcv_clkb[1],     iopad_unused_aib58[1],     iopad_fs_rcv_clk[1],   iopad_ns_adapter_rstn[1],
                                               iopad_ns_rcv_div2_clkb[1], iopad_ns_fwd_div2_clkb[1],  iopad_ns_fwd_div2_clk[1],    iopad_unused_aib52[1],
                                                   iopad_unused_aib51[1],     iopad_unused_aib50[1],       iopad_ns_mac_rdy[1], iopad_ns_rcv_div2_clk[1],
                                                   iopad_unused_aib47[1],     iopad_unused_aib46[1],     iopad_unused_aib45[1],      iopad_fs_mac_rdy[1],
                                                     iopad_fs_fwd_clk[1],      iopad_fs_fwd_clkb[1],       iopad_ns_fwd_clk[1],     iopad_ns_fwd_clkb[1],
                                                      iopad_rx[39:20],         iopad_tx[39:20]}),

    
                    .m0_ch2_aib                  ({  iopad_ns_sr_data[2],       iopad_ns_sr_load[2],       iopad_fs_sr_data[2],      iopad_fs_sr_load[2],
                                                   iopad_unused_aib91[2],     iopad_unused_aib90[2],     iopad_unused_aib89[2],    iopad_unused_aib88[2],
                                                     iopad_ns_rcv_clk[2],      iopad_ns_rcv_clkb[2],        iopad_ns_sr_clk[2],      iopad_ns_sr_clkb[2],
                                                      iopad_fs_sr_clk[2],       iopad_fs_sr_clkb[2],     iopad_unused_aib81[2],    iopad_unused_aib80[2],
                                                   iopad_unused_aib79[2],     iopad_unused_aib78[2],     iopad_unused_aib77[2],    iopad_unused_aib76[2],
                                                   iopad_unused_aib75[2],     iopad_unused_aib74[2],     iopad_unused_aib73[2],    iopad_unused_aib72[2],
                                                   iopad_unused_aib71[2],     iopad_unused_aib70[2],     iopad_unused_aib69[2],    iopad_unused_aib68[2],
                                                   iopad_unused_aib67[2],     iopad_unused_aib66[2],  iopad_fs_adapter_rstn[2],    iopad_unused_aib64[2],
                                                   iopad_unused_aib63[2],     iopad_unused_aib62[2],     iopad_unused_aib61[2],    iopad_unused_aib60[2],
                                                    iopad_fs_rcv_clkb[2],     iopad_unused_aib58[2],     iopad_fs_rcv_clk[2],   iopad_ns_adapter_rstn[2],
                                               iopad_ns_rcv_div2_clkb[2], iopad_ns_fwd_div2_clkb[2],  iopad_ns_fwd_div2_clk[2],    iopad_unused_aib52[2],
                                                   iopad_unused_aib51[2],     iopad_unused_aib50[2],       iopad_ns_mac_rdy[2], iopad_ns_rcv_div2_clk[2],
                                                   iopad_unused_aib47[2],     iopad_unused_aib46[2],     iopad_unused_aib45[2],      iopad_fs_mac_rdy[2],
                                                     iopad_fs_fwd_clk[2],      iopad_fs_fwd_clkb[2],       iopad_ns_fwd_clk[2],     iopad_ns_fwd_clkb[2],
                                                      iopad_rx[59:40],         iopad_tx[59:40]}),

                    .m0_ch3_aib                  ({  iopad_ns_sr_data[3],       iopad_ns_sr_load[3],       iopad_fs_sr_data[3],      iopad_fs_sr_load[3],
                                                   iopad_unused_aib91[3],     iopad_unused_aib90[3],     iopad_unused_aib89[3],    iopad_unused_aib88[3],
                                                     iopad_ns_rcv_clk[3],      iopad_ns_rcv_clkb[3],        iopad_ns_sr_clk[3],      iopad_ns_sr_clkb[3],
                                                      iopad_fs_sr_clk[3],       iopad_fs_sr_clkb[3],     iopad_unused_aib81[3],    iopad_unused_aib80[3],
                                                   iopad_unused_aib79[3],     iopad_unused_aib78[3],     iopad_unused_aib77[3],    iopad_unused_aib76[3],
                                                   iopad_unused_aib75[3],     iopad_unused_aib74[3],     iopad_unused_aib73[3],    iopad_unused_aib72[3],
                                                   iopad_unused_aib71[3],     iopad_unused_aib70[3],     iopad_unused_aib69[3],    iopad_unused_aib68[3],
                                                   iopad_unused_aib67[3],     iopad_unused_aib66[3],  iopad_fs_adapter_rstn[3],    iopad_unused_aib64[3],
                                                   iopad_unused_aib63[3],     iopad_unused_aib62[3],     iopad_unused_aib61[3],    iopad_unused_aib60[3],
                                                    iopad_fs_rcv_clkb[3],     iopad_unused_aib58[3],     iopad_fs_rcv_clk[3],   iopad_ns_adapter_rstn[3],
                                               iopad_ns_rcv_div2_clkb[3], iopad_ns_fwd_div2_clkb[3],  iopad_ns_fwd_div2_clk[3],    iopad_unused_aib52[3],
                                                   iopad_unused_aib51[3],     iopad_unused_aib50[3],       iopad_ns_mac_rdy[3], iopad_ns_rcv_div2_clk[3],
                                                   iopad_unused_aib47[3],     iopad_unused_aib46[3],     iopad_unused_aib45[3],      iopad_fs_mac_rdy[3],
                                                     iopad_fs_fwd_clk[3],      iopad_fs_fwd_clkb[3],       iopad_ns_fwd_clk[3],     iopad_ns_fwd_clkb[3],
                                                      iopad_rx[79:60],         iopad_tx[79:60]}),

                    .m0_ch4_aib                  ({  iopad_ns_sr_data[4],       iopad_ns_sr_load[4],       iopad_fs_sr_data[4],      iopad_fs_sr_load[4],
                                                   iopad_unused_aib91[4],     iopad_unused_aib90[4],     iopad_unused_aib89[4],    iopad_unused_aib88[4],
                                                     iopad_ns_rcv_clk[4],      iopad_ns_rcv_clkb[4],        iopad_ns_sr_clk[4],      iopad_ns_sr_clkb[4],
                                                      iopad_fs_sr_clk[4],       iopad_fs_sr_clkb[4],     iopad_unused_aib81[4],    iopad_unused_aib80[4],
                                                   iopad_unused_aib79[4],     iopad_unused_aib78[4],     iopad_unused_aib77[4],    iopad_unused_aib76[4],
                                                   iopad_unused_aib75[4],     iopad_unused_aib74[4],     iopad_unused_aib73[4],    iopad_unused_aib72[4],
                                                   iopad_unused_aib71[4],     iopad_unused_aib70[4],     iopad_unused_aib69[4],    iopad_unused_aib68[4],
                                                   iopad_unused_aib67[4],     iopad_unused_aib66[4],  iopad_fs_adapter_rstn[4],    iopad_unused_aib64[4],
                                                   iopad_unused_aib63[4],     iopad_unused_aib62[4],     iopad_unused_aib61[4],    iopad_unused_aib60[4],
                                                    iopad_fs_rcv_clkb[4],     iopad_unused_aib58[4],     iopad_fs_rcv_clk[4],   iopad_ns_adapter_rstn[4],
                                               iopad_ns_rcv_div2_clkb[4], iopad_ns_fwd_div2_clkb[4],  iopad_ns_fwd_div2_clk[4],    iopad_unused_aib52[4],
                                                   iopad_unused_aib51[4],     iopad_unused_aib50[4],       iopad_ns_mac_rdy[4], iopad_ns_rcv_div2_clk[4],
                                                   iopad_unused_aib47[4],     iopad_unused_aib46[4],     iopad_unused_aib45[4],      iopad_fs_mac_rdy[4],
                                                     iopad_fs_fwd_clk[4],      iopad_fs_fwd_clkb[4],       iopad_ns_fwd_clk[4],     iopad_ns_fwd_clkb[4],
                                                      iopad_rx[99:80],     iopad_tx[99:80]}),

                    .m0_ch5_aib                  ({  iopad_ns_sr_data[5],       iopad_ns_sr_load[5],       iopad_fs_sr_data[5],      iopad_fs_sr_load[5],
                                                   iopad_unused_aib91[5],     iopad_unused_aib90[5],     iopad_unused_aib89[5],    iopad_unused_aib88[5],
                                                     iopad_ns_rcv_clk[5],      iopad_ns_rcv_clkb[5],        iopad_ns_sr_clk[5],      iopad_ns_sr_clkb[5],
                                                      iopad_fs_sr_clk[5],       iopad_fs_sr_clkb[5],     iopad_unused_aib81[5],    iopad_unused_aib80[5],
                                                   iopad_unused_aib79[5],     iopad_unused_aib78[5],     iopad_unused_aib77[5],    iopad_unused_aib76[5],
                                                   iopad_unused_aib75[5],     iopad_unused_aib74[5],     iopad_unused_aib73[5],    iopad_unused_aib72[5],
                                                   iopad_unused_aib71[5],     iopad_unused_aib70[5],     iopad_unused_aib69[5],    iopad_unused_aib68[5],
                                                   iopad_unused_aib67[5],     iopad_unused_aib66[5],  iopad_fs_adapter_rstn[5],    iopad_unused_aib64[5],
                                                   iopad_unused_aib63[5],     iopad_unused_aib62[5],     iopad_unused_aib61[5],    iopad_unused_aib60[5],
                                                    iopad_fs_rcv_clkb[5],     iopad_unused_aib58[5],     iopad_fs_rcv_clk[5],   iopad_ns_adapter_rstn[5],
                                               iopad_ns_rcv_div2_clkb[5], iopad_ns_fwd_div2_clkb[5],  iopad_ns_fwd_div2_clk[5],    iopad_unused_aib52[5],
                                                   iopad_unused_aib51[5],     iopad_unused_aib50[5],       iopad_ns_mac_rdy[5], iopad_ns_rcv_div2_clk[5],
                                                   iopad_unused_aib47[5],     iopad_unused_aib46[5],     iopad_unused_aib45[5],      iopad_fs_mac_rdy[5],
                                                     iopad_fs_fwd_clk[5],      iopad_fs_fwd_clkb[5],       iopad_ns_fwd_clk[5],     iopad_ns_fwd_clkb[5],    
                                                      iopad_rx[119:100],     iopad_tx[119:100]}),

                    .m1_ch0_aib                  ({  iopad_ns_sr_data[6],       iopad_ns_sr_load[6],       iopad_fs_sr_data[6],      iopad_fs_sr_load[6],
                                                   iopad_unused_aib91[6],     iopad_unused_aib90[6],     iopad_unused_aib89[6],    iopad_unused_aib88[6],
                                                     iopad_ns_rcv_clk[6],      iopad_ns_rcv_clkb[6],        iopad_ns_sr_clk[6],      iopad_ns_sr_clkb[6],
                                                      iopad_fs_sr_clk[6],       iopad_fs_sr_clkb[6],     iopad_unused_aib81[6],    iopad_unused_aib80[6],
                                                   iopad_unused_aib79[6],     iopad_unused_aib78[6],     iopad_unused_aib77[6],    iopad_unused_aib76[6],
                                                   iopad_unused_aib75[6],     iopad_unused_aib74[6],     iopad_unused_aib73[6],    iopad_unused_aib72[6],
                                                   iopad_unused_aib71[6],     iopad_unused_aib70[6],     iopad_unused_aib69[6],    iopad_unused_aib68[6],
                                                   iopad_unused_aib67[6],     iopad_unused_aib66[6],  iopad_fs_adapter_rstn[6],    iopad_unused_aib64[6],
                                                   iopad_unused_aib63[6],     iopad_unused_aib62[6],     iopad_unused_aib61[6],    iopad_unused_aib60[6],
                                                    iopad_fs_rcv_clkb[6],     iopad_unused_aib58[6],     iopad_fs_rcv_clk[6],   iopad_ns_adapter_rstn[6],
                                               iopad_ns_rcv_div2_clkb[6], iopad_ns_fwd_div2_clkb[6],  iopad_ns_fwd_div2_clk[6],    iopad_unused_aib52[6],
                                                   iopad_unused_aib51[6],     iopad_unused_aib50[6],       iopad_ns_mac_rdy[6], iopad_ns_rcv_div2_clk[6],
                                                   iopad_unused_aib47[6],     iopad_unused_aib46[6],     iopad_unused_aib45[6],      iopad_fs_mac_rdy[6],
                                                     iopad_fs_fwd_clk[6],      iopad_fs_fwd_clkb[6],       iopad_ns_fwd_clk[6],     iopad_ns_fwd_clkb[6],    
                                                      iopad_rx[139:120],     iopad_tx[139:120]}),

                    .m1_ch1_aib                  ({  iopad_ns_sr_data[7],       iopad_ns_sr_load[7],       iopad_fs_sr_data[7],      iopad_fs_sr_load[7],
                                                   iopad_unused_aib91[7],     iopad_unused_aib90[7],     iopad_unused_aib89[7],    iopad_unused_aib88[7],
                                                     iopad_ns_rcv_clk[7],      iopad_ns_rcv_clkb[7],        iopad_ns_sr_clk[7],      iopad_ns_sr_clkb[7],
                                                      iopad_fs_sr_clk[7],       iopad_fs_sr_clkb[7],     iopad_unused_aib81[7],    iopad_unused_aib80[7],
                                                   iopad_unused_aib79[7],     iopad_unused_aib78[7],     iopad_unused_aib77[7],    iopad_unused_aib76[7],
                                                   iopad_unused_aib75[7],     iopad_unused_aib74[7],     iopad_unused_aib73[7],    iopad_unused_aib72[7],
                                                   iopad_unused_aib71[7],     iopad_unused_aib70[7],     iopad_unused_aib69[7],    iopad_unused_aib68[7],
                                                   iopad_unused_aib67[7],     iopad_unused_aib66[7],  iopad_fs_adapter_rstn[7],    iopad_unused_aib64[7],
                                                   iopad_unused_aib63[7],     iopad_unused_aib62[7],     iopad_unused_aib61[7],    iopad_unused_aib60[7],
                                                    iopad_fs_rcv_clkb[7],     iopad_unused_aib58[7],     iopad_fs_rcv_clk[7],   iopad_ns_adapter_rstn[7],
                                               iopad_ns_rcv_div2_clkb[7], iopad_ns_fwd_div2_clkb[7],  iopad_ns_fwd_div2_clk[7],    iopad_unused_aib52[7],
                                                   iopad_unused_aib51[7],     iopad_unused_aib50[7],       iopad_ns_mac_rdy[7], iopad_ns_rcv_div2_clk[7],
                                                   iopad_unused_aib47[7],     iopad_unused_aib46[7],     iopad_unused_aib45[7],      iopad_fs_mac_rdy[7],
                                                     iopad_fs_fwd_clk[7],      iopad_fs_fwd_clkb[7],       iopad_ns_fwd_clk[7],     iopad_ns_fwd_clkb[7],    
                                                      iopad_rx[159:140],     iopad_tx[159:140]}),

                    .m1_ch2_aib                  ({  iopad_ns_sr_data[8],       iopad_ns_sr_load[8],       iopad_fs_sr_data[8],      iopad_fs_sr_load[8],
                                                   iopad_unused_aib91[8],     iopad_unused_aib90[8],     iopad_unused_aib89[8],    iopad_unused_aib88[8],
                                                     iopad_ns_rcv_clk[8],      iopad_ns_rcv_clkb[8],        iopad_ns_sr_clk[8],      iopad_ns_sr_clkb[8],
                                                      iopad_fs_sr_clk[8],       iopad_fs_sr_clkb[8],     iopad_unused_aib81[8],    iopad_unused_aib80[8],
                                                   iopad_unused_aib79[8],     iopad_unused_aib78[8],     iopad_unused_aib77[8],    iopad_unused_aib76[8],
                                                   iopad_unused_aib75[8],     iopad_unused_aib74[8],     iopad_unused_aib73[8],    iopad_unused_aib72[8],
                                                   iopad_unused_aib71[8],     iopad_unused_aib70[8],     iopad_unused_aib69[8],    iopad_unused_aib68[8],
                                                   iopad_unused_aib67[8],     iopad_unused_aib66[8],  iopad_fs_adapter_rstn[8],    iopad_unused_aib64[8],
                                                   iopad_unused_aib63[8],     iopad_unused_aib62[8],     iopad_unused_aib61[8],    iopad_unused_aib60[8],
                                                    iopad_fs_rcv_clkb[8],     iopad_unused_aib58[8],     iopad_fs_rcv_clk[8],   iopad_ns_adapter_rstn[8],
                                               iopad_ns_rcv_div2_clkb[8], iopad_ns_fwd_div2_clkb[8],  iopad_ns_fwd_div2_clk[8],    iopad_unused_aib52[8],
                                                   iopad_unused_aib51[8],     iopad_unused_aib50[8],       iopad_ns_mac_rdy[8], iopad_ns_rcv_div2_clk[8],
                                                   iopad_unused_aib47[8],     iopad_unused_aib46[8],     iopad_unused_aib45[8],      iopad_fs_mac_rdy[8],
                                                     iopad_fs_fwd_clk[8],      iopad_fs_fwd_clkb[8],       iopad_ns_fwd_clk[8],     iopad_ns_fwd_clkb[8],    
                                                      iopad_rx[179:160],     iopad_tx[179:160]}),
                    .m1_ch3_aib                  ({  iopad_ns_sr_data[9],       iopad_ns_sr_load[9],       iopad_fs_sr_data[9],      iopad_fs_sr_load[9],
                                                   iopad_unused_aib91[9],     iopad_unused_aib90[9],     iopad_unused_aib89[9],    iopad_unused_aib88[9],
                                                     iopad_ns_rcv_clk[9],      iopad_ns_rcv_clkb[9],        iopad_ns_sr_clk[9],      iopad_ns_sr_clkb[9],
                                                      iopad_fs_sr_clk[9],       iopad_fs_sr_clkb[9],     iopad_unused_aib81[9],    iopad_unused_aib80[9],
                                                   iopad_unused_aib79[9],     iopad_unused_aib78[9],     iopad_unused_aib77[9],    iopad_unused_aib76[9],
                                                   iopad_unused_aib75[9],     iopad_unused_aib74[9],     iopad_unused_aib73[9],    iopad_unused_aib72[9],
                                                   iopad_unused_aib71[9],     iopad_unused_aib70[9],     iopad_unused_aib69[9],    iopad_unused_aib68[9],
                                                   iopad_unused_aib67[9],     iopad_unused_aib66[9],  iopad_fs_adapter_rstn[9],    iopad_unused_aib64[9],
                                                   iopad_unused_aib63[9],     iopad_unused_aib62[9],     iopad_unused_aib61[9],    iopad_unused_aib60[9],
                                                    iopad_fs_rcv_clkb[9],     iopad_unused_aib58[9],     iopad_fs_rcv_clk[9],   iopad_ns_adapter_rstn[9],
                                               iopad_ns_rcv_div2_clkb[9], iopad_ns_fwd_div2_clkb[9],  iopad_ns_fwd_div2_clk[9],    iopad_unused_aib52[9],
                                                   iopad_unused_aib51[9],     iopad_unused_aib50[9],       iopad_ns_mac_rdy[9], iopad_ns_rcv_div2_clk[9],
                                                   iopad_unused_aib47[9],     iopad_unused_aib46[9],     iopad_unused_aib45[9],      iopad_fs_mac_rdy[9],
                                                     iopad_fs_fwd_clk[9],      iopad_fs_fwd_clkb[9],       iopad_ns_fwd_clk[9],     iopad_ns_fwd_clkb[9],
                                                      iopad_rx[199:180],     iopad_tx[199:180]}),

                    .m1_ch4_aib                  ({  iopad_ns_sr_data[10],       iopad_ns_sr_load[10],       iopad_fs_sr_data[10],      iopad_fs_sr_load[10],
                                                   iopad_unused_aib91[10],     iopad_unused_aib90[10],     iopad_unused_aib89[10],    iopad_unused_aib88[10],
                                                     iopad_ns_rcv_clk[10],      iopad_ns_rcv_clkb[10],        iopad_ns_sr_clk[10],      iopad_ns_sr_clkb[10],
                                                      iopad_fs_sr_clk[10],       iopad_fs_sr_clkb[10],     iopad_unused_aib81[10],    iopad_unused_aib80[10],
                                                   iopad_unused_aib79[10],     iopad_unused_aib78[10],     iopad_unused_aib77[10],    iopad_unused_aib76[10],
                                                   iopad_unused_aib75[10],     iopad_unused_aib74[10],     iopad_unused_aib73[10],    iopad_unused_aib72[10],
                                                   iopad_unused_aib71[10],     iopad_unused_aib70[10],     iopad_unused_aib69[10],    iopad_unused_aib68[10],
                                                   iopad_unused_aib67[10],     iopad_unused_aib66[10],  iopad_fs_adapter_rstn[10],    iopad_unused_aib64[10],
                                                   iopad_unused_aib63[10],     iopad_unused_aib62[10],     iopad_unused_aib61[10],    iopad_unused_aib60[10],
                                                    iopad_fs_rcv_clkb[10],     iopad_unused_aib58[10],     iopad_fs_rcv_clk[10],   iopad_ns_adapter_rstn[10],
                                               iopad_ns_rcv_div2_clkb[10], iopad_ns_fwd_div2_clkb[10],  iopad_ns_fwd_div2_clk[10],    iopad_unused_aib52[10],
                                                   iopad_unused_aib51[10],     iopad_unused_aib50[10],       iopad_ns_mac_rdy[10], iopad_ns_rcv_div2_clk[10],
                                                   iopad_unused_aib47[10],     iopad_unused_aib46[10],     iopad_unused_aib45[10],      iopad_fs_mac_rdy[10],
                                                     iopad_fs_fwd_clk[10],      iopad_fs_fwd_clkb[10],       iopad_ns_fwd_clk[10],     iopad_ns_fwd_clkb[10],
                                                        iopad_rx[219:200],       iopad_tx[219:200]}),

                    .m1_ch5_aib                  ({  iopad_ns_sr_data[11],       iopad_ns_sr_load[11],       iopad_fs_sr_data[11],      iopad_fs_sr_load[11],
                                                   iopad_unused_aib91[11],     iopad_unused_aib90[11],     iopad_unused_aib89[11],    iopad_unused_aib88[11],
                                                     iopad_ns_rcv_clk[11],      iopad_ns_rcv_clkb[11],       iopad_ns_sr_clk[11],       iopad_ns_sr_clkb[11],
                                                      iopad_fs_sr_clk[11],       iopad_fs_sr_clkb[11],     iopad_unused_aib81[11],    iopad_unused_aib80[11],
                                                   iopad_unused_aib79[11],     iopad_unused_aib78[11],     iopad_unused_aib77[11],    iopad_unused_aib76[11],
                                                   iopad_unused_aib75[11],     iopad_unused_aib74[11],     iopad_unused_aib73[11],    iopad_unused_aib72[11],
                                                   iopad_unused_aib71[11],     iopad_unused_aib70[11],     iopad_unused_aib69[11],    iopad_unused_aib68[11],
                                                   iopad_unused_aib67[11],     iopad_unused_aib66[11],  iopad_fs_adapter_rstn[11],    iopad_unused_aib64[11],
                                                   iopad_unused_aib63[11],     iopad_unused_aib62[11],     iopad_unused_aib61[11],    iopad_unused_aib60[11],
                                                    iopad_fs_rcv_clkb[11],     iopad_unused_aib58[11],     iopad_fs_rcv_clk[11],   iopad_ns_adapter_rstn[11],
                                               iopad_ns_rcv_div2_clkb[11], iopad_ns_fwd_div2_clkb[11],  iopad_ns_fwd_div2_clk[11],    iopad_unused_aib52[11],
                                                   iopad_unused_aib51[11],     iopad_unused_aib50[11],       iopad_ns_mac_rdy[11], iopad_ns_rcv_div2_clk[11],
                                                   iopad_unused_aib47[11],     iopad_unused_aib46[11],     iopad_unused_aib45[11],      iopad_fs_mac_rdy[11],
                                                     iopad_fs_fwd_clk[11],      iopad_fs_fwd_clkb[11],       iopad_ns_fwd_clk[11],     iopad_ns_fwd_clkb[11],    
                                                        iopad_rx[239:220],       iopad_tx[239:220]}),

                    .m2_ch0_aib                  ({  iopad_ns_sr_data[12],       iopad_ns_sr_load[12],       iopad_fs_sr_data[12],      iopad_fs_sr_load[12],
                                                   iopad_unused_aib91[12],     iopad_unused_aib90[12],     iopad_unused_aib89[12],    iopad_unused_aib88[12],
                                                     iopad_ns_rcv_clk[12],      iopad_ns_rcv_clkb[12],        iopad_ns_sr_clk[12],      iopad_ns_sr_clkb[12],
                                                      iopad_fs_sr_clk[12],       iopad_fs_sr_clkb[12],     iopad_unused_aib81[12],    iopad_unused_aib80[12],
                                                   iopad_unused_aib79[12],     iopad_unused_aib78[12],     iopad_unused_aib77[12],    iopad_unused_aib76[12],
                                                   iopad_unused_aib75[12],     iopad_unused_aib74[12],     iopad_unused_aib73[12],    iopad_unused_aib72[12],
                                                   iopad_unused_aib71[12],     iopad_unused_aib70[12],     iopad_unused_aib69[12],    iopad_unused_aib68[12],
                                                   iopad_unused_aib67[12],     iopad_unused_aib66[12],  iopad_fs_adapter_rstn[12],    iopad_unused_aib64[12],
                                                   iopad_unused_aib63[12],     iopad_unused_aib62[12],     iopad_unused_aib61[12],    iopad_unused_aib60[12],
                                                    iopad_fs_rcv_clkb[12],     iopad_unused_aib58[12],     iopad_fs_rcv_clk[12],   iopad_ns_adapter_rstn[12],
                                               iopad_ns_rcv_div2_clkb[12], iopad_ns_fwd_div2_clkb[12],  iopad_ns_fwd_div2_clk[12],    iopad_unused_aib52[12],
                                                   iopad_unused_aib51[12],     iopad_unused_aib50[12],       iopad_ns_mac_rdy[12], iopad_ns_rcv_div2_clk[12],
                                                   iopad_unused_aib47[12],     iopad_unused_aib46[12],     iopad_unused_aib45[12],      iopad_fs_mac_rdy[12],
                                                     iopad_fs_fwd_clk[12],      iopad_fs_fwd_clkb[12],       iopad_ns_fwd_clk[12],     iopad_ns_fwd_clkb[12],    
                                                        iopad_rx[259:240],       iopad_tx[259:240]}),

                    .m2_ch1_aib                  ({  iopad_ns_sr_data[13],       iopad_ns_sr_load[13],       iopad_fs_sr_data[13],      iopad_fs_sr_load[13],
                                                   iopad_unused_aib91[13],     iopad_unused_aib90[13],     iopad_unused_aib89[13],    iopad_unused_aib88[13],
                                                     iopad_ns_rcv_clk[13],      iopad_ns_rcv_clkb[13],        iopad_ns_sr_clk[13],      iopad_ns_sr_clkb[13],
                                                      iopad_fs_sr_clk[13],       iopad_fs_sr_clkb[13],     iopad_unused_aib81[13],    iopad_unused_aib80[13],
                                                   iopad_unused_aib79[13],     iopad_unused_aib78[13],     iopad_unused_aib77[13],    iopad_unused_aib76[13],
                                                   iopad_unused_aib75[13],     iopad_unused_aib74[13],     iopad_unused_aib73[13],    iopad_unused_aib72[13],
                                                   iopad_unused_aib71[13],     iopad_unused_aib70[13],     iopad_unused_aib69[13],    iopad_unused_aib68[13],
                                                   iopad_unused_aib67[13],     iopad_unused_aib66[13],  iopad_fs_adapter_rstn[13],    iopad_unused_aib64[13],
                                                   iopad_unused_aib63[13],     iopad_unused_aib62[13],     iopad_unused_aib61[13],    iopad_unused_aib60[13],
                                                    iopad_fs_rcv_clkb[13],     iopad_unused_aib58[13],     iopad_fs_rcv_clk[13],   iopad_ns_adapter_rstn[13],
                                               iopad_ns_rcv_div2_clkb[13], iopad_ns_fwd_div2_clkb[13],  iopad_ns_fwd_div2_clk[13],    iopad_unused_aib52[13],
                                                   iopad_unused_aib51[13],     iopad_unused_aib50[13],       iopad_ns_mac_rdy[13], iopad_ns_rcv_div2_clk[13],
                                                   iopad_unused_aib47[13],     iopad_unused_aib46[13],     iopad_unused_aib45[13],      iopad_fs_mac_rdy[13],
                                                     iopad_fs_fwd_clk[13],      iopad_fs_fwd_clkb[13],       iopad_ns_fwd_clk[13],     iopad_ns_fwd_clkb[13],    
                                                        iopad_rx[279:260],  iopad_tx[279:260]}),

                    .m2_ch2_aib                  ({  iopad_ns_sr_data[14],       iopad_ns_sr_load[14],       iopad_fs_sr_data[14],      iopad_fs_sr_load[14],
                                                   iopad_unused_aib91[14],     iopad_unused_aib90[14],     iopad_unused_aib89[14],    iopad_unused_aib88[14],
                                                     iopad_ns_rcv_clk[14],      iopad_ns_rcv_clkb[14],        iopad_ns_sr_clk[14],      iopad_ns_sr_clkb[14],
                                                      iopad_fs_sr_clk[14],       iopad_fs_sr_clkb[14],     iopad_unused_aib81[14],    iopad_unused_aib80[14],
                                                   iopad_unused_aib79[14],     iopad_unused_aib78[14],     iopad_unused_aib77[14],    iopad_unused_aib76[14],
                                                   iopad_unused_aib75[14],     iopad_unused_aib74[14],     iopad_unused_aib73[14],    iopad_unused_aib72[14],
                                                   iopad_unused_aib71[14],     iopad_unused_aib70[14],     iopad_unused_aib69[14],    iopad_unused_aib68[14],
                                                   iopad_unused_aib67[14],     iopad_unused_aib66[14],  iopad_fs_adapter_rstn[14],    iopad_unused_aib64[14],
                                                   iopad_unused_aib63[14],     iopad_unused_aib62[14],     iopad_unused_aib61[14],    iopad_unused_aib60[14],
                                                    iopad_fs_rcv_clkb[14],     iopad_unused_aib58[14],     iopad_fs_rcv_clk[14],   iopad_ns_adapter_rstn[14],
                                               iopad_ns_rcv_div2_clkb[14], iopad_ns_fwd_div2_clkb[14],  iopad_ns_fwd_div2_clk[14],    iopad_unused_aib52[14],
                                                   iopad_unused_aib51[14],     iopad_unused_aib50[14],       iopad_ns_mac_rdy[14], iopad_ns_rcv_div2_clk[14],
                                                   iopad_unused_aib47[14],     iopad_unused_aib46[14],     iopad_unused_aib45[14],      iopad_fs_mac_rdy[14],
                                                     iopad_fs_fwd_clk[14],      iopad_fs_fwd_clkb[14],       iopad_ns_fwd_clk[14],     iopad_ns_fwd_clkb[14],    
                                                      iopad_rx[299:280],     iopad_tx[299:280]}),

                    .m2_ch3_aib                  ({  iopad_ns_sr_data[15],       iopad_ns_sr_load[15],       iopad_fs_sr_data[15],      iopad_fs_sr_load[15],
                                                   iopad_unused_aib91[15],     iopad_unused_aib90[15],     iopad_unused_aib89[15],    iopad_unused_aib88[15],
                                                     iopad_ns_rcv_clk[15],      iopad_ns_rcv_clkb[15],        iopad_ns_sr_clk[15],      iopad_ns_sr_clkb[15],
                                                      iopad_fs_sr_clk[15],       iopad_fs_sr_clkb[15],     iopad_unused_aib81[15],    iopad_unused_aib80[15],
                                                   iopad_unused_aib79[15],     iopad_unused_aib78[15],     iopad_unused_aib77[15],    iopad_unused_aib76[15],
                                                   iopad_unused_aib75[15],     iopad_unused_aib74[15],     iopad_unused_aib73[15],    iopad_unused_aib72[15],
                                                   iopad_unused_aib71[15],     iopad_unused_aib70[15],     iopad_unused_aib69[15],    iopad_unused_aib68[15],
                                                   iopad_unused_aib67[15],     iopad_unused_aib66[15],  iopad_fs_adapter_rstn[15],    iopad_unused_aib64[15],
                                                   iopad_unused_aib63[15],     iopad_unused_aib62[15],     iopad_unused_aib61[15],    iopad_unused_aib60[15],
                                                    iopad_fs_rcv_clkb[15],     iopad_unused_aib58[15],     iopad_fs_rcv_clk[15],   iopad_ns_adapter_rstn[15],
                                               iopad_ns_rcv_div2_clkb[15], iopad_ns_fwd_div2_clkb[15],  iopad_ns_fwd_div2_clk[15],    iopad_unused_aib52[15],
                                                   iopad_unused_aib51[15],     iopad_unused_aib50[15],       iopad_ns_mac_rdy[15], iopad_ns_rcv_div2_clk[15],
                                                   iopad_unused_aib47[15],     iopad_unused_aib46[15],     iopad_unused_aib45[15],      iopad_fs_mac_rdy[15],
                                                     iopad_fs_fwd_clk[15],      iopad_fs_fwd_clkb[15],       iopad_ns_fwd_clk[15],     iopad_ns_fwd_clkb[15],    
                                                      iopad_rx[319:300],     iopad_tx[319:300]}),

                    .m2_ch4_aib                  ({  iopad_ns_sr_data[16],       iopad_ns_sr_load[16],       iopad_fs_sr_data[16],      iopad_fs_sr_load[16],
                                                   iopad_unused_aib91[16],     iopad_unused_aib90[16],     iopad_unused_aib89[16],    iopad_unused_aib88[16],
                                                     iopad_ns_rcv_clk[16],      iopad_ns_rcv_clkb[16],       iopad_ns_sr_clk[16],       iopad_ns_sr_clkb[16],
                                                      iopad_fs_sr_clk[16],       iopad_fs_sr_clkb[16],     iopad_unused_aib81[16],    iopad_unused_aib80[16],
                                                   iopad_unused_aib79[16],     iopad_unused_aib78[16],     iopad_unused_aib77[16],    iopad_unused_aib76[16],
                                                   iopad_unused_aib75[16],     iopad_unused_aib74[16],     iopad_unused_aib73[16],    iopad_unused_aib72[16],
                                                   iopad_unused_aib71[16],     iopad_unused_aib70[16],     iopad_unused_aib69[16],    iopad_unused_aib68[16],
                                                   iopad_unused_aib67[16],     iopad_unused_aib66[16],  iopad_fs_adapter_rstn[16],    iopad_unused_aib64[16],
                                                   iopad_unused_aib63[16],     iopad_unused_aib62[16],     iopad_unused_aib61[16],    iopad_unused_aib60[16],
                                                    iopad_fs_rcv_clkb[16],     iopad_unused_aib58[16],     iopad_fs_rcv_clk[16],   iopad_ns_adapter_rstn[16],
                                               iopad_ns_rcv_div2_clkb[16], iopad_ns_fwd_div2_clkb[16],  iopad_ns_fwd_div2_clk[16],    iopad_unused_aib52[16],
                                                   iopad_unused_aib51[16],     iopad_unused_aib50[16],       iopad_ns_mac_rdy[16], iopad_ns_rcv_div2_clk[16],
                                                   iopad_unused_aib47[16],     iopad_unused_aib46[16],     iopad_unused_aib45[16],      iopad_fs_mac_rdy[16],
                                                     iopad_fs_fwd_clk[16],      iopad_fs_fwd_clkb[16],       iopad_ns_fwd_clk[16],     iopad_ns_fwd_clkb[16],    
                                                      iopad_rx[339:320],     iopad_tx[339:320]}),

                    .m2_ch5_aib                  ({  iopad_ns_sr_data[17],       iopad_ns_sr_load[17],       iopad_fs_sr_data[17],      iopad_fs_sr_load[17],
                                                   iopad_unused_aib91[17],     iopad_unused_aib90[17],     iopad_unused_aib89[17],    iopad_unused_aib88[17],
                                                     iopad_ns_rcv_clk[17],      iopad_ns_rcv_clkb[17],        iopad_ns_sr_clk[17],      iopad_ns_sr_clkb[17],
                                                      iopad_fs_sr_clk[17],       iopad_fs_sr_clkb[17],     iopad_unused_aib81[17],    iopad_unused_aib80[17],
                                                   iopad_unused_aib79[17],     iopad_unused_aib78[17],     iopad_unused_aib77[17],    iopad_unused_aib76[17],
                                                   iopad_unused_aib75[17],     iopad_unused_aib74[17],     iopad_unused_aib73[17],    iopad_unused_aib72[17],
                                                   iopad_unused_aib71[17],     iopad_unused_aib70[17],     iopad_unused_aib69[17],    iopad_unused_aib68[17],
                                                   iopad_unused_aib67[17],     iopad_unused_aib66[17],  iopad_fs_adapter_rstn[17],    iopad_unused_aib64[17],
                                                   iopad_unused_aib63[17],     iopad_unused_aib62[17],     iopad_unused_aib61[17],    iopad_unused_aib60[17],
                                                    iopad_fs_rcv_clkb[17],     iopad_unused_aib58[17],     iopad_fs_rcv_clk[17],   iopad_ns_adapter_rstn[17],
                                               iopad_ns_rcv_div2_clkb[17], iopad_ns_fwd_div2_clkb[17],  iopad_ns_fwd_div2_clk[17],    iopad_unused_aib52[17],
                                                   iopad_unused_aib51[17],     iopad_unused_aib50[17],       iopad_ns_mac_rdy[17], iopad_ns_rcv_div2_clk[17],
                                                   iopad_unused_aib47[17],     iopad_unused_aib46[17],     iopad_unused_aib45[17],      iopad_fs_mac_rdy[17],
                                                     iopad_fs_fwd_clk[17],      iopad_fs_fwd_clkb[17],       iopad_ns_fwd_clk[17],     iopad_ns_fwd_clkb[17],    
                                                      iopad_rx[359:340],     iopad_tx[359:340]}),

                    .m3_ch0_aib                  ({  iopad_ns_sr_data[18],       iopad_ns_sr_load[18],       iopad_fs_sr_data[18],      iopad_fs_sr_load[18],
                                                   iopad_unused_aib91[18],     iopad_unused_aib90[18],     iopad_unused_aib89[18],    iopad_unused_aib88[18],
                                                     iopad_ns_rcv_clk[18],      iopad_ns_rcv_clkb[18],        iopad_ns_sr_clk[18],      iopad_ns_sr_clkb[18],
                                                      iopad_fs_sr_clk[18],       iopad_fs_sr_clkb[18],     iopad_unused_aib81[18],    iopad_unused_aib80[18],
                                                   iopad_unused_aib79[18],     iopad_unused_aib78[18],     iopad_unused_aib77[18],    iopad_unused_aib76[18],
                                                   iopad_unused_aib75[18],     iopad_unused_aib74[18],     iopad_unused_aib73[18],    iopad_unused_aib72[18],
                                                   iopad_unused_aib71[18],     iopad_unused_aib70[18],     iopad_unused_aib69[18],    iopad_unused_aib68[18],
                                                   iopad_unused_aib67[18],     iopad_unused_aib66[18],  iopad_fs_adapter_rstn[18],    iopad_unused_aib64[18],
                                                   iopad_unused_aib63[18],     iopad_unused_aib62[18],     iopad_unused_aib61[18],    iopad_unused_aib60[18],
                                                    iopad_fs_rcv_clkb[18],     iopad_unused_aib58[18],     iopad_fs_rcv_clk[18],   iopad_ns_adapter_rstn[18],
                                               iopad_ns_rcv_div2_clkb[18], iopad_ns_fwd_div2_clkb[18],  iopad_ns_fwd_div2_clk[18],    iopad_unused_aib52[18],
                                                   iopad_unused_aib51[18],     iopad_unused_aib50[18],       iopad_ns_mac_rdy[18], iopad_ns_rcv_div2_clk[18],
                                                   iopad_unused_aib47[18],     iopad_unused_aib46[18],     iopad_unused_aib45[18],      iopad_fs_mac_rdy[18],
                                                     iopad_fs_fwd_clk[18],      iopad_fs_fwd_clkb[18],       iopad_ns_fwd_clk[18],     iopad_ns_fwd_clkb[18],
                                                      iopad_rx[379:360],     iopad_tx[379:360]}),

                    .m3_ch1_aib                  ({  iopad_ns_sr_data[19],       iopad_ns_sr_load[19],       iopad_fs_sr_data[19],      iopad_fs_sr_load[19],
                                                   iopad_unused_aib91[19],     iopad_unused_aib90[19],     iopad_unused_aib89[19],    iopad_unused_aib88[19],
                                                     iopad_ns_rcv_clk[19],      iopad_ns_rcv_clkb[19],        iopad_ns_sr_clk[19],      iopad_ns_sr_clkb[19],
                                                      iopad_fs_sr_clk[19],       iopad_fs_sr_clkb[19],     iopad_unused_aib81[19],    iopad_unused_aib80[19],
                                                   iopad_unused_aib79[19],     iopad_unused_aib78[19],     iopad_unused_aib77[19],    iopad_unused_aib76[19],
                                                   iopad_unused_aib75[19],     iopad_unused_aib74[19],     iopad_unused_aib73[19],    iopad_unused_aib72[19],
                                                   iopad_unused_aib71[19],     iopad_unused_aib70[19],     iopad_unused_aib69[19],    iopad_unused_aib68[19],
                                                   iopad_unused_aib67[19],     iopad_unused_aib66[19],  iopad_fs_adapter_rstn[19],    iopad_unused_aib64[19],
                                                   iopad_unused_aib63[19],     iopad_unused_aib62[19],     iopad_unused_aib61[19],    iopad_unused_aib60[19],
                                                    iopad_fs_rcv_clkb[19],     iopad_unused_aib58[19],     iopad_fs_rcv_clk[19],   iopad_ns_adapter_rstn[19],
                                               iopad_ns_rcv_div2_clkb[19], iopad_ns_fwd_div2_clkb[19],  iopad_ns_fwd_div2_clk[19],    iopad_unused_aib52[19],
                                                   iopad_unused_aib51[19],     iopad_unused_aib50[19],       iopad_ns_mac_rdy[19], iopad_ns_rcv_div2_clk[19],
                                                   iopad_unused_aib47[19],     iopad_unused_aib46[19],     iopad_unused_aib45[19],      iopad_fs_mac_rdy[19],
                                                     iopad_fs_fwd_clk[19],      iopad_fs_fwd_clkb[19],       iopad_ns_fwd_clk[19],     iopad_ns_fwd_clkb[19],    
                                                      iopad_rx[399:380],     iopad_tx[399:380]}),

                    .m3_ch2_aib                  ({  iopad_ns_sr_data[20],       iopad_ns_sr_load[20],       iopad_fs_sr_data[20],      iopad_fs_sr_load[20],
                                                   iopad_unused_aib91[20],     iopad_unused_aib90[20],     iopad_unused_aib89[20],    iopad_unused_aib88[20],
                                                     iopad_ns_rcv_clk[20],      iopad_ns_rcv_clkb[20],        iopad_ns_sr_clk[20],      iopad_ns_sr_clkb[20],
                                                      iopad_fs_sr_clk[20],       iopad_fs_sr_clkb[20],     iopad_unused_aib81[20],    iopad_unused_aib80[20],
                                                   iopad_unused_aib79[20],     iopad_unused_aib78[20],     iopad_unused_aib77[20],    iopad_unused_aib76[20],
                                                   iopad_unused_aib75[20],     iopad_unused_aib74[20],     iopad_unused_aib73[20],    iopad_unused_aib72[20],
                                                   iopad_unused_aib71[20],     iopad_unused_aib70[20],     iopad_unused_aib69[20],    iopad_unused_aib68[20],
                                                   iopad_unused_aib67[20],     iopad_unused_aib66[20],  iopad_fs_adapter_rstn[20],    iopad_unused_aib64[20],
                                                   iopad_unused_aib63[20],     iopad_unused_aib62[20],     iopad_unused_aib61[20],    iopad_unused_aib60[20],
                                                    iopad_fs_rcv_clkb[20],     iopad_unused_aib58[20],     iopad_fs_rcv_clk[20],   iopad_ns_adapter_rstn[20],
                                               iopad_ns_rcv_div2_clkb[20], iopad_ns_fwd_div2_clkb[20],  iopad_ns_fwd_div2_clk[20],    iopad_unused_aib52[20],
                                                   iopad_unused_aib51[20],     iopad_unused_aib50[20],       iopad_ns_mac_rdy[20], iopad_ns_rcv_div2_clk[20],
                                                   iopad_unused_aib47[20],     iopad_unused_aib46[20],     iopad_unused_aib45[20],      iopad_fs_mac_rdy[20],
                                                     iopad_fs_fwd_clk[20],      iopad_fs_fwd_clkb[20],       iopad_ns_fwd_clk[20],     iopad_ns_fwd_clkb[20],
                                                      iopad_rx[419:400],     iopad_tx[419:400]}),

                    .m3_ch3_aib                  ({  iopad_ns_sr_data[21],       iopad_ns_sr_load[21],       iopad_fs_sr_data[21],      iopad_fs_sr_load[21],
                                                   iopad_unused_aib91[21],     iopad_unused_aib90[21],     iopad_unused_aib89[21],    iopad_unused_aib88[21],
                                                     iopad_ns_rcv_clk[21],      iopad_ns_rcv_clkb[21],        iopad_ns_sr_clk[21],      iopad_ns_sr_clkb[21],
                                                      iopad_fs_sr_clk[21],       iopad_fs_sr_clkb[21],     iopad_unused_aib81[21],    iopad_unused_aib80[21],
                                                   iopad_unused_aib79[21],     iopad_unused_aib78[21],     iopad_unused_aib77[21],    iopad_unused_aib76[21],
                                                   iopad_unused_aib75[21],     iopad_unused_aib74[21],     iopad_unused_aib73[21],    iopad_unused_aib72[21],
                                                   iopad_unused_aib71[21],     iopad_unused_aib70[21],     iopad_unused_aib69[21],    iopad_unused_aib68[21],
                                                   iopad_unused_aib67[21],     iopad_unused_aib66[21],  iopad_fs_adapter_rstn[21],    iopad_unused_aib64[21],
                                                   iopad_unused_aib63[21],     iopad_unused_aib62[21],     iopad_unused_aib61[21],    iopad_unused_aib60[21],
                                                    iopad_fs_rcv_clkb[21],     iopad_unused_aib58[21],     iopad_fs_rcv_clk[21],   iopad_ns_adapter_rstn[21],
                                               iopad_ns_rcv_div2_clkb[21], iopad_ns_fwd_div2_clkb[21],  iopad_ns_fwd_div2_clk[21],    iopad_unused_aib52[21],
                                                   iopad_unused_aib51[21],     iopad_unused_aib50[21],       iopad_ns_mac_rdy[21], iopad_ns_rcv_div2_clk[21],
                                                   iopad_unused_aib47[21],     iopad_unused_aib46[21],     iopad_unused_aib45[21],      iopad_fs_mac_rdy[21],
                                                     iopad_fs_fwd_clk[21],      iopad_fs_fwd_clkb[21],       iopad_ns_fwd_clk[21],     iopad_ns_fwd_clkb[21],    
                                                      iopad_rx[439:420],     iopad_tx[439:420]}),

                    .m3_ch4_aib                  ({  iopad_ns_sr_data[22],       iopad_ns_sr_load[22],       iopad_fs_sr_data[22],      iopad_fs_sr_load[22],
                                                   iopad_unused_aib91[22],     iopad_unused_aib90[22],     iopad_unused_aib89[22],    iopad_unused_aib88[22],
                                                     iopad_ns_rcv_clk[22],      iopad_ns_rcv_clkb[22],        iopad_ns_sr_clk[22],      iopad_ns_sr_clkb[22],
                                                      iopad_fs_sr_clk[22],       iopad_fs_sr_clkb[22],     iopad_unused_aib81[22],    iopad_unused_aib80[22],
                                                   iopad_unused_aib79[22],     iopad_unused_aib78[22],     iopad_unused_aib77[22],    iopad_unused_aib76[22],
                                                   iopad_unused_aib75[22],     iopad_unused_aib74[22],     iopad_unused_aib73[22],    iopad_unused_aib72[22],
                                                   iopad_unused_aib71[22],     iopad_unused_aib70[22],     iopad_unused_aib69[22],    iopad_unused_aib68[22],
                                                   iopad_unused_aib67[22],     iopad_unused_aib66[22],    iopad_fs_adapter_rstn[22],    iopad_unused_aib64[22],
                                                   iopad_unused_aib63[22],     iopad_unused_aib62[22],     iopad_unused_aib61[22],    iopad_unused_aib60[22],
                                                    iopad_fs_rcv_clkb[22],     iopad_unused_aib58[22],       iopad_fs_rcv_clk[22],   iopad_ns_adapter_rstn[22],
                                               iopad_ns_rcv_div2_clkb[22], iopad_ns_fwd_div2_clkb[22],  iopad_ns_fwd_div2_clk[22],    iopad_unused_aib52[22],
                                                   iopad_unused_aib51[22],     iopad_unused_aib50[22],       iopad_ns_mac_rdy[22], iopad_ns_rcv_div2_clk[22],
                                                   iopad_unused_aib47[22],     iopad_unused_aib46[22],     iopad_unused_aib45[22],      iopad_fs_mac_rdy[22],
                                                     iopad_fs_fwd_clk[22],      iopad_fs_fwd_clkb[22],       iopad_ns_fwd_clk[22],     iopad_ns_fwd_clkb[22],    
                                                      iopad_rx[459:440],     iopad_tx[459:440]}),

                    .m3_ch5_aib                  ({  iopad_ns_sr_data[23],       iopad_ns_sr_load[23],       iopad_fs_sr_data[23],      iopad_fs_sr_load[23],
                                                   iopad_unused_aib91[23],     iopad_unused_aib90[23],     iopad_unused_aib89[23],    iopad_unused_aib88[23],
                                                     iopad_ns_rcv_clk[23],      iopad_ns_rcv_clkb[23],        iopad_ns_sr_clk[23],      iopad_ns_sr_clkb[23],
                                                      iopad_fs_sr_clk[23],       iopad_fs_sr_clkb[23],     iopad_unused_aib81[23],    iopad_unused_aib80[23],
                                                   iopad_unused_aib79[23],     iopad_unused_aib78[23],     iopad_unused_aib77[23],    iopad_unused_aib76[23],
                                                   iopad_unused_aib75[23],     iopad_unused_aib74[23],     iopad_unused_aib73[23],    iopad_unused_aib72[23],
                                                   iopad_unused_aib71[23],     iopad_unused_aib70[23],     iopad_unused_aib69[23],    iopad_unused_aib68[23],
                                                   iopad_unused_aib67[23],     iopad_unused_aib66[23],  iopad_fs_adapter_rstn[23],    iopad_unused_aib64[23],
                                                   iopad_unused_aib63[23],     iopad_unused_aib62[23],     iopad_unused_aib61[23],    iopad_unused_aib60[23],
                                                    iopad_fs_rcv_clkb[23],     iopad_unused_aib58[23],     iopad_fs_rcv_clk[23],   iopad_ns_adapter_rstn[23],
                                               iopad_ns_rcv_div2_clkb[23], iopad_ns_fwd_div2_clkb[23],  iopad_ns_fwd_div2_clk[23],    iopad_unused_aib52[23],
                                                   iopad_unused_aib51[23],     iopad_unused_aib50[23],       iopad_ns_mac_rdy[23], iopad_ns_rcv_div2_clk[23],
                                                   iopad_unused_aib47[23],     iopad_unused_aib46[23],     iopad_unused_aib45[23],      iopad_fs_mac_rdy[23],
                                                     iopad_fs_fwd_clk[23],      iopad_fs_fwd_clkb[23],       iopad_ns_fwd_clk[23],     iopad_ns_fwd_clkb[23],
                                                      iopad_rx[479:460],     iopad_tx[479:460]}),

    

                    .io_aib_aux74                (iopad_device_detect),
                    .io_aib_aux75                (iopad_device_detect_r),
                    .io_aib_aux85                (iopad_power_on_reset),
                    .io_aib_aux87                (iopad_power_on_reset_r),
	            .m_por_ovrd                  (m_por_ovrd),      
                    .i_osc_clk                   (i_osc_clk),  
//                  .o_aibaux_osc_clk            (o_aibaux_osc_clk),      
                    .i_scan_clk                  (i_scan_clk), 
                    .i_test_scan_en              (i_test_scan_en),
                    .i_test_scan_mode            (i_test_scan_mode),
                    .i_test_clk_125m             (i_test_clk_125m), 
                    .i_test_clk_1g               (i_test_clk_1g), 
                    .i_test_clk_250m             (i_test_clk_250m), 
                    .i_test_clk_500m             (i_test_clk_500m), 
                    .i_test_clk_62m              (i_test_clk_62m), 	      
                    .i_test_c3adapt_scan_in      (i_test_c3adapt_scan_in),
	            .o_test_c3adapt_scan_out     (o_test_c3adapt_scan_out),
                    .i_jtag_clkdr                (i_jtag_clkdr),   
                    .i_jtag_clksel               (i_jtag_clksel),   
                    .i_jtag_intest               (i_jtag_intest),   
                    .i_jtag_mode                 (i_jtag_mode),   
                    .i_jtag_rstb_en              (i_jtag_rstb_en),   
                    .i_jtag_rstb                 (i_jtag_rstb),   
                    .i_jtag_weakpdn              (i_jtag_weakpdn),   
                    .i_jtag_weakpu               (i_jtag_weakpu), 	      
                    .i_jtag_tdi                  (i_jtag_tdi),
                    .i_jtag_tx_scanen            (i_jtag_tx_scanen),
                    .o_jtag_tdo                  (o_jtag_tdo),
                    .m_power_on_reset            (m_power_on_reset)
               );

    
endmodule 

