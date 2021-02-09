// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright @ 2018 Intel Corporation.   
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  $Header: TBD
//  $Date:   TBD
//-----------------------------------------------------------------------------
// Description: Top level AIB wrapper includes 24 channel AIB + AIB AUX
//
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
// 10/29/2019 
// 1) Pull out phasecom FIFO interface clock and data:
//    i_rx_elane_clk,i_rx_elane_data,i_tx_elane_clk,o_tx_elane_data
// 2) Pull out ns_adapt_rstn
// 3) instantiated optimized aibcr3aux_top_master
// 11/24/2019 changed microbump name to fit board layout
// 11/25/2019 Need to pull out m_rxfifo_align_done
// 04/22/2020 Shrink aux pad 74/75 and 85/87 to device_detect and por.
//-----------------------------------------------------------------------------

module aib_top_v2s
  # (
     parameter TOTAL_CHNL_NUM = 24
     )
  (
     //================================================================================================
   // Reset Inteface
   input                                                          i_conf_done, // AIB adaptor hard reset
   input                                                          dual_mode_select, //1 is master mode, 0 is slave mode
   // reset for XCVRIF
   output [TOTAL_CHNL_NUM-1:0]                                    fs_mac_rdy, // chiplet xcvr receiving path reset, the reset is controlled by remote chiplet which is FPGA in this case
   
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
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_fwd_clk, // Rx path clk for data receiving, may generated from xcvr pll
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_fwd_div2_clk, // Divided by 2 clock on Rx pathinput                          
    
// input [TOTAL_CHNL_NUM*65-1:0]                                  i_chnl_ssr, // Slow shift chain path, tie to 0s if not used
// input [TOTAL_CHNL_NUM*40-1:0]                                  i_rx_pma_data, // Directed bump rx data sync path
 
   input [TOTAL_CHNL_NUM-1:0]                                     m_wr_clk, //Clock for phase compensation fifo
   input [TOTAL_CHNL_NUM*78-1:0]                                  data_in, //data in for phase compensation fifo

 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
   input [TOTAL_CHNL_NUM-1:0]                                     m_ns_rcv_clk, // this clock is sent over to the other chiplet to be used for the clock as the data transmission
// output [TOTAL_CHNL_NUM*61-1:0]                                 o_chnl_ssr, // Slow shift chain path, left unconnected if not used
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_fwd_clk, // clock used for tx data transmission
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_fwd_div2_clk, // half rate of tx data transmission clock
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_rcv_clk,
   output [TOTAL_CHNL_NUM-1:0]                                    m_fs_rcv_div2_clk,
// output [TOTAL_CHNL_NUM*40-1:0]                                 o_tx_pma_data, // Directed bump tx data sync path
   input  [TOTAL_CHNL_NUM-1:0]                                    m_rd_clk, //Clock for phase compensation fifo
   output [TOTAL_CHNL_NUM*78-1:0]                                 data_out, // data out for phase compensation fifo

 //=================================================================================================
 // AIB open source IP enhancement. The following ports are added to
 // be compliance with AIB specification 1.1
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive data. use aibio49
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_adapter_rstn, //From Mac. To reset near adapt reset sm and far side reset sm. aibio56
   output [TOTAL_CHNL_NUM*81-1:0]                                 ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
   output [TOTAL_CHNL_NUM*73-1:0]                                 sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet.
   output [TOTAL_CHNL_NUM-1:0]                                    m_rxfifo_align_done,  //Newly added rx data fifo alignment done signal.
   output [TOTAL_CHNL_NUM-1:0]                                    ms_tx_transfer_en,
   output [TOTAL_CHNL_NUM-1:0]                                    ms_rx_transfer_en,
   output [TOTAL_CHNL_NUM-1:0]                                    sl_tx_transfer_en,
   output [TOTAL_CHNL_NUM-1:0]                                    sl_rx_transfer_en,
   input [TOTAL_CHNL_NUM-1:0]                                     sl_tx_dcc_dll_lock_req,
   input [TOTAL_CHNL_NUM-1:0]                                     sl_rx_dcc_dll_lock_req,
   //=================================================================================================
   // Inout signals for AIB ubump
   inout [95:0]                                                   s0_ch0_aib, 
   inout [95:0]                                                   s0_ch1_aib,
   inout [95:0]                                                   s0_ch2_aib,
   inout [95:0]                                                   s0_ch3_aib, 
   inout [95:0]                                                   s0_ch4_aib, 
   inout [95:0]                                                   s0_ch5_aib, 
   inout [95:0]                                                   s1_ch0_aib, 
   inout [95:0]                                                   s1_ch1_aib, 
   inout [95:0]                                                   s1_ch2_aib, 
   inout [95:0]                                                   s1_ch3_aib, 
   inout [95:0]                                                   s1_ch4_aib,
   inout [95:0]                                                   s1_ch5_aib,
   inout [95:0]                                                   s2_ch0_aib,
   inout [95:0]                                                   s2_ch1_aib,
   inout [95:0]                                                   s2_ch2_aib,
   inout [95:0]                                                   s2_ch3_aib,
   inout [95:0]                                                   s2_ch4_aib,
   inout [95:0]                                                   s2_ch5_aib,
   inout [95:0]                                                   s3_ch0_aib,
   inout [95:0]                                                   s3_ch1_aib, 
   inout [95:0]                                                   s3_ch2_aib,
   inout [95:0]                                                   s3_ch3_aib,
   inout [95:0]                                                   s3_ch4_aib,
   inout [95:0]                                                   s3_ch5_aib,
// inout [95:0]                                                   io_aib_aux,
   
// inout                                                          io_aib_aux74,  //Device select pin
// inout                                                          io_aib_aux75,  //Device select passive resundancy
   inout                                                          device_detect,
// inout                                                          io_aib_aux85,  //Power on Reset pin
// inout                                                          io_aib_aux87,  //Power on reset passive redundancy pin
   inout                                                          por,
// inout                                                          io_aux_bg_ext_2k, //connect to external 2k resistor, C4 bump

   //======================================================================================
   // Interface with AIB control block
   // reset for AIB AUX
   input                                                          m_power_on_reset, 
   output                                                         m_device_detect,
   input                                                          m_device_detect_ovrd,
   
   // from control block register file
// input [31:0]                                                   i_aibaux_ctrl_bus0, //1st set of register bits from register file
// input [31:0]                                                   i_aibaux_ctrl_bus1, //2nd set of register bits from register file
// input [31:0]                                                   i_aibaux_ctrl_bus2, //3rd set of register bits from register file
// input [9:0]                                                    i_aibaux_osc_fuse_trim, //control by Fuse/OTP from User

   //
   input                                                          i_osc_clk,     // test clock from c4 bump, may tie low for User if not used
// output                                                         o_aibaux_osc_clk, // osc clk output to test C4 bump to characterize the oscillator, User may use this clock to connect with i_test_clk_1g
    //======================================================================================
   // DFT signals
   input                                                          scan_clk,
   input                                                          scan_enable,
//   input  [TOTAL_CHNL_NUM-1:0][19:0]                              scan_in,
// splitting scan_in because of the lvs tool issue. 7/29/2020
   input  [19:0]                                                  scan_in_ch0,
   input  [19:0]                                                  scan_in_ch1,
   input  [19:0]                                                  scan_in_ch2,
   input  [19:0]                                                  scan_in_ch3,
   input  [19:0]                                                  scan_in_ch4,
   input  [19:0]                                                  scan_in_ch5,
   input  [19:0]                                                  scan_in_ch6,
   input  [19:0]                                                  scan_in_ch7,
   input  [19:0]                                                  scan_in_ch8,
   input  [19:0]                                                  scan_in_ch9,
   input  [19:0]                                                  scan_in_ch10,
   input  [19:0]                                                  scan_in_ch11,
   input  [19:0]                                                  scan_in_ch12,
   input  [19:0]                                                  scan_in_ch13,
   input  [19:0]                                                  scan_in_ch14,
   input  [19:0]                                                  scan_in_ch15,
   input  [19:0]                                                  scan_in_ch16,
   input  [19:0]                                                  scan_in_ch17,
   input  [19:0]                                                  scan_in_ch18,
   input  [19:0]                                                  scan_in_ch19,
   input  [19:0]                                                  scan_in_ch20,
   input  [19:0]                                                  scan_in_ch21,
   input  [19:0]                                                  scan_in_ch22,
   input  [19:0]                                                  scan_in_ch23,
// output [TOTAL_CHNL_NUM-1:0][19:0]                              scan_out,
   output [19:0]                                                  scan_out_ch0,
   output [19:0]                                                  scan_out_ch1,
   output [19:0]                                                  scan_out_ch2,
   output [19:0]                                                  scan_out_ch3,
   output [19:0]                                                  scan_out_ch4,
   output [19:0]                                                  scan_out_ch5,
   output [19:0]                                                  scan_out_ch6,
   output [19:0]                                                  scan_out_ch7,
   output [19:0]                                                  scan_out_ch8,
   output [19:0]                                                  scan_out_ch9,
   output [19:0]                                                  scan_out_ch10,
   output [19:0]                                                  scan_out_ch11,
   output [19:0]                                                  scan_out_ch12,
   output [19:0]                                                  scan_out_ch13,
   output [19:0]                                                  scan_out_ch14,
   output [19:0]                                                  scan_out_ch15,
   output [19:0]                                                  scan_out_ch16,
   output [19:0]                                                  scan_out_ch17,
   output [19:0]                                                  scan_out_ch18,
   output [19:0]                                                  scan_out_ch19,
   output [19:0]                                                  scan_out_ch20,
   output [19:0]                                                  scan_out_ch21,
   output [19:0]                                                  scan_out_ch22,
   output [19:0]                                                  scan_out_ch23,
   input                                                          i_scan_clk,
// input                                                          i_test_clk_1g,  //1GHz free running direct accessed ATPG at speed clock.
// input                                                          i_test_clk_125m,//Divided down from i_test_clk_1g. 
// input                                                          i_test_clk_250m,//Divided down from i_test_clk_1g.
// input                                                          i_test_clk_500m,//Divided down from i_test_clk_1g.
// input                                                          i_test_clk_62m, //Divided down from i_test_clk_1g.
                                                                                  //The divided down clock is for different clock domain at
                                                                                  //speed test.
   //Channel ATPG signals from/to CODEC
// input [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  i_test_c3adapt_scan_in, //scan in hook from Codec 
// input [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]                     i_test_c3adapt_tcb_static_common, //TCM Controls for ATPG scan test. 
// i_test_scan_reset, i_test_scan_enable, i_test_scan_mode
   input                                                          i_test_scan_en,     //Terminate i_test_c3adapt_tcb_static_common, only pull out Scan enable 
   input                                                          i_test_scan_mode,
// output [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] o_test_c3adapt_scan_out, //scan out hook to Codec
  
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

   //output TCB 
   output                                                         o_jtag_tdo //last boundary scan chain output, TDO 
  
   );

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire                aibaux_osc_clk;         // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_por_vcchssi;     // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_por_vccl;        // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v

    
    c3aibadapt_wrap_top_v2s u_c3aibadapt_wrap_top
      (/*AUTOINST*/
       // Outputs
       .i_por_aib_vcchssi(aibaux_por_vcchssi), 
       .i_por_aib_vccl(aibaux_por_vccl),

       .fs_mac_rdy                      (fs_mac_rdy[TOTAL_CHNL_NUM-1:0]),
       .o_cfg_avmm_rdatavld             (o_cfg_avmm_rdatavld),
       .o_cfg_avmm_rdata                (o_cfg_avmm_rdata[31:0]),
       .o_cfg_avmm_waitreq              (o_cfg_avmm_waitreq),
//     .o_osc_clk                       (),                      // Templated
//     .o_chnl_ssr                      (),
       .m_fs_fwd_clk                    (m_fs_fwd_clk[TOTAL_CHNL_NUM-1:0]),
       .m_fs_fwd_div2_clk               (m_fs_fwd_div2_clk[TOTAL_CHNL_NUM-1:0]),
       .m_fs_rcv_clk                    (m_fs_rcv_clk[TOTAL_CHNL_NUM-1:0]),
       .m_fs_rcv_div2_clk               (m_fs_rcv_div2_clk),
//     .o_tx_pma_data                   (),
       .ns_mac_rdy                      (ns_mac_rdy[TOTAL_CHNL_NUM-1:0]),
       .ns_adapter_rstn                 (ns_adapter_rstn[TOTAL_CHNL_NUM-1:0]),
       .m_rxfifo_align_done             (m_rxfifo_align_done), 
       .ms_sideband                     (ms_sideband[TOTAL_CHNL_NUM*81-1:0]),
       .sl_sideband                     (sl_sideband[TOTAL_CHNL_NUM*73-1:0]),
       .ms_tx_transfer_en               (ms_tx_transfer_en[TOTAL_CHNL_NUM-1:0]),
       .ms_rx_transfer_en               (ms_rx_transfer_en[TOTAL_CHNL_NUM-1:0]),
       .sl_tx_transfer_en               (sl_tx_transfer_en[TOTAL_CHNL_NUM-1:0]),
       .sl_rx_transfer_en               (sl_rx_transfer_en[TOTAL_CHNL_NUM-1:0]),
       .ms_tx_dcc_dll_lock_req          (24'h0),
       .ms_rx_dcc_dll_lock_req          (24'h0),
       .sl_tx_dcc_dll_lock_req          (sl_tx_dcc_dll_lock_req[TOTAL_CHNL_NUM-1:0]),
       .sl_rx_dcc_dll_lock_req          (sl_rx_dcc_dll_lock_req[TOTAL_CHNL_NUM-1:0]),

       .o_test_c3adapt_scan_out         (),
       .o_test_c3adapttcb_jtag          (),                      // Templated
       .o_jtag_last_bs_chain_out        (o_jtag_tdo),     // Templated
       .o_red_idataselb_out_chain1      (red_idataselb_in_chain1), // Templated
       .o_red_idataselb_out_chain2      (red_idataselb_in_chain2), // Templated
       .o_red_shift_en_out_chain1       (red_shift_en_in_chain1), // Templated
       .o_red_shift_en_out_chain2       (red_shift_en_in_chain2), // Templated
       .o_txen_out_chain1               (o_txen_out_chain1),
       .o_txen_out_chain2               (o_txen_out_chain2),
       .o_directout_data_chain1_out     (o_directout_data_chain1_out),
       .o_directout_data_chain2_out     (o_directout_data_chain2_out),
       .scan_clk                        (scan_clk),
       .scan_enable                     (scan_enable),
   //  .scan_in                         (scan_in),
       .scan_in_ch0                     (scan_in_ch0),
       .scan_in_ch1                     (scan_in_ch1),
       .scan_in_ch2                     (scan_in_ch2),
       .scan_in_ch3                     (scan_in_ch3),
       .scan_in_ch4                     (scan_in_ch4),
       .scan_in_ch5                     (scan_in_ch5),
       .scan_in_ch6                     (scan_in_ch6),
       .scan_in_ch7                     (scan_in_ch7),
       .scan_in_ch8                     (scan_in_ch8),
       .scan_in_ch9                     (scan_in_ch9),
       .scan_in_ch10                    (scan_in_ch10),
       .scan_in_ch11                    (scan_in_ch11),
       .scan_in_ch12                    (scan_in_ch12),
       .scan_in_ch13                    (scan_in_ch13),
       .scan_in_ch14                    (scan_in_ch14),
       .scan_in_ch15                    (scan_in_ch15),
       .scan_in_ch16                    (scan_in_ch16),
       .scan_in_ch17                    (scan_in_ch17),
       .scan_in_ch18                    (scan_in_ch18),
       .scan_in_ch19                    (scan_in_ch19),
       .scan_in_ch20                    (scan_in_ch20),
       .scan_in_ch21                    (scan_in_ch21),
       .scan_in_ch22                    (scan_in_ch22),
       .scan_in_ch23                    (scan_in_ch23),
   //  .scan_out                        (scan_out),
       .scan_out_ch0                    (scan_out_ch0),
       .scan_out_ch1                    (scan_out_ch1),
       .scan_out_ch2                    (scan_out_ch2),
       .scan_out_ch3                    (scan_out_ch3),
       .scan_out_ch4                    (scan_out_ch4),
       .scan_out_ch5                    (scan_out_ch5),
       .scan_out_ch6                    (scan_out_ch6),
       .scan_out_ch7                    (scan_out_ch7),
       .scan_out_ch8                    (scan_out_ch8),
       .scan_out_ch9                    (scan_out_ch9),
       .scan_out_ch10                   (scan_out_ch10),
       .scan_out_ch11                   (scan_out_ch11),
       .scan_out_ch12                   (scan_out_ch12),
       .scan_out_ch13                   (scan_out_ch13),
       .scan_out_ch14                   (scan_out_ch14),
       .scan_out_ch15                   (scan_out_ch15),
       .scan_out_ch16                   (scan_out_ch16),
       .scan_out_ch17                   (scan_out_ch17),
       .scan_out_ch18                   (scan_out_ch18),
       .scan_out_ch19                   (scan_out_ch19),
       .scan_out_ch20                   (scan_out_ch20),
       .scan_out_ch21                   (scan_out_ch21),
       .scan_out_ch22                   (scan_out_ch22),
       .scan_out_ch23                   (scan_out_ch23),
   //  .o_aibdftdll2adjch               (),
       // Inouts
       .io_aib_ch0                      (s0_ch0_aib[95:0]),
       .io_aib_ch1                      (s0_ch1_aib[95:0]),
       .io_aib_ch2                      (s0_ch2_aib[95:0]),
       .io_aib_ch3                      (s0_ch3_aib[95:0]),
       .io_aib_ch4                      (s0_ch4_aib[95:0]),
       .io_aib_ch5                      (s0_ch5_aib[95:0]),
       .io_aib_ch6                      (s1_ch0_aib[95:0]),
       .io_aib_ch7                      (s1_ch1_aib[95:0]),
       .io_aib_ch8                      (s1_ch2_aib[95:0]),
       .io_aib_ch9                      (s1_ch3_aib[95:0]),
       .io_aib_ch10                     (s1_ch4_aib[95:0]),
       .io_aib_ch11                     (s1_ch5_aib[95:0]),
       .io_aib_ch12                     (s2_ch0_aib[95:0]),
       .io_aib_ch13                     (s2_ch1_aib[95:0]),
       .io_aib_ch14                     (s2_ch2_aib[95:0]),
       .io_aib_ch15                     (s2_ch3_aib[95:0]),
       .io_aib_ch16                     (s2_ch4_aib[95:0]),
       .io_aib_ch17                     (s2_ch5_aib[95:0]),
       .io_aib_ch18                     (s3_ch0_aib[95:0]),
       .io_aib_ch19                     (s3_ch1_aib[95:0]),
       .io_aib_ch20                     (s3_ch2_aib[95:0]),
       .io_aib_ch21                     (s3_ch3_aib[95:0]),
       .io_aib_ch22                     (s3_ch4_aib[95:0]),
       .io_aib_ch23                     (s3_ch5_aib[95:0]),
       // Inputs
       .conf_done                       (i_conf_done),
       .dual_mode_select                (dual_mode_select),
       .i_cfg_avmm_clk                  (i_cfg_avmm_clk),
       .i_cfg_avmm_rst_n                (i_cfg_avmm_rst_n),
       .i_cfg_avmm_addr                 (i_cfg_avmm_addr[16:0]),
       .i_cfg_avmm_byte_en              (i_cfg_avmm_byte_en[3:0]),
       .i_cfg_avmm_read                 (i_cfg_avmm_read),
       .i_cfg_avmm_write                (i_cfg_avmm_write),
       .i_cfg_avmm_wdata                (i_cfg_avmm_wdata[31:0]),
       .m_ns_fwd_clk                    (m_ns_fwd_clk[TOTAL_CHNL_NUM-1:0]),
       .m_ns_fwd_div2_clk               (m_ns_fwd_div2_clk[TOTAL_CHNL_NUM-1:0]),
       .m_wr_clk                        (m_wr_clk[TOTAL_CHNL_NUM-1:0]),
       .data_in                         (data_in[TOTAL_CHNL_NUM*78-1:0]),
       .i_osc_clk                       (aibaux_osc_clk),        // Templated
//     .i_chnl_ssr                      ({24{65'h0}}),
//     .i_rx_pma_data                   ({24{40'h0}}),
       .m_ns_rcv_clk                    (m_ns_rcv_clk[TOTAL_CHNL_NUM-1:0]),
       .m_rd_clk                        (m_rd_clk[TOTAL_CHNL_NUM-1:0]),
       .data_out                        (data_out[TOTAL_CHNL_NUM*78-1:0]),
       .i_scan_clk                      (i_scan_clk),
       .i_test_clk_125m                 (1'b0),
       .i_test_clk_1g                   (1'b0),
       .i_test_clk_250m                 (1'b0),
       .i_test_clk_500m                 (1'b0),
       .i_test_clk_62m                  (1'b0),
       .i_test_c3adapt_scan_in          ({24{17'h0}}),
       .i_test_c3adapt_tcb_static_common({58'h0, i_test_scan_en, i_test_scan_mode}),
       .i_jtag_rstb_in                  (i_jtag_rstb),  // Templated
       .i_jtag_rstb_en_in               (i_jtag_rstb_en), // Templated
       .i_jtag_clkdr_in                 (i_jtag_clkdr), // Templated
       .i_jtag_clksel_in                (i_jtag_clksel), // Templated
       .i_jtag_intest_in                (i_jtag_intest), // Templated
       .i_jtag_mode_in                  (i_jtag_mode),  // Templated
       .i_jtag_weakpdn_in               (i_jtag_weakpdn), // Templated
       .i_jtag_weakpu_in                (i_jtag_weakpu), // Templated
       .i_jtag_bs_scanen_in             (i_jtag_tx_scanen), // Templated
       .i_jtag_bs_chain_in              (i_jtag_tdi) // Templated
        );       // Templated

aib_aux_dual  aib_aux_dual
   (
    // AIB IO Bidirectional 
    .device_detect(device_detect),
    .por(por),

//  .device_detect_ms(ms_device_detect),
    .i_osc_clk(i_osc_clk),
    .m_i_por_ovrd(1'b0),
    .m_i_device_detect_ovrd(m_device_detect_ovrd),
    .m_o_power_on_reset(),
    .m_o_device_detect(m_device_detect),
    .o_por_vcchssi(aibaux_por_vcchssi),
    .o_por_vccl(aibaux_por_vccl),
    .osc_clkout(aibaux_osc_clk),
    .m_i_power_on_reset(m_power_on_reset),
    .ms_nsl(dual_mode_select)
    );

    
endmodule // aib_top

