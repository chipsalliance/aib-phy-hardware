// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2018 Intel Corporation. 
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description: Top level AIB wrapper which integrates 24 channels
//
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//  10/29/2019 
//  1) corrected routing unoptimized issue. Previously for ch6/ch12/ch18
//     .i_cfg_avmm_wdata   (chnl_aib_cfg_avmm_wdata_0[31:0]),
//
//  2)  Pull out phasecom FIFO interface clock and data:
//      i_rx_elane_clk,i_rx_elane_data,i_tx_elane_clk,o_tx_elane_data
//  3)  Pull out ns_adapt_rstn
//  2/12/2020 Pull out the following status signals
//     ms_rx_transfer_en, ms_tx_transfer_en, sl_rx_transfer_en, sl_tx_transfer_en
//-----------------------------------------------------------------------------
module c3aibadapt_wrap_top
  # (
     parameter TOTAL_CHNL_NUM = 24
     )
  (
  
   //================================================================================================
   // Reset Inteface
   input                                                          i_adpt_hard_rst_n, // AIB adaptor hard reset

   output [TOTAL_CHNL_NUM-1:0]                                    m_rxfifo_align_done,
   // reset for XCVRIF
   output [TOTAL_CHNL_NUM-1:0]                                    o_rx_xcvrif_rst_n, // chiplet xcvr receiving path reset, the reset is controlled by remote chiplet which is FPGA in this case
   
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
   input [TOTAL_CHNL_NUM-1:0]                                     i_rx_pma_clk, // Rx path clk for data receiving, may generated from xcvr pll
   input [TOTAL_CHNL_NUM-1:0]                                     i_rx_pma_div2_clk, // Divided by 2 clock on Rx pathinput                          
    
   input                                                          i_osc_clk, // Oscillator clock generated from AIB AUX
   input [TOTAL_CHNL_NUM*65-1:0]                                  i_chnl_ssr, // Slow shift chain path
   input [TOTAL_CHNL_NUM*40-1:0]                                  i_rx_pma_data, // Directed bump rx data sync path

   input [TOTAL_CHNL_NUM-1:0]                                     i_rx_elane_clk, //Clock for phase compensation fifo
   input [TOTAL_CHNL_NUM*78-1:0]                                  i_rx_elane_data, //data in for phase compensation fifo
 
 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
   input [TOTAL_CHNL_NUM-1:0]                                     i_tx_pma_clk, // this clock is sent over to the other chiplet to be used for the clock as the data transmission
   output                                                         o_osc_clk, // this is the clock used for shift register path
   output [TOTAL_CHNL_NUM*61-1:0]                                 o_chnl_ssr, // Slow shift chain path
   output [TOTAL_CHNL_NUM-1:0]                                    o_tx_transfer_clk, // clock used for tx data transmission
   output [TOTAL_CHNL_NUM-1:0]                                    o_tx_transfer_div2_clk, // half rate of tx data transmission clock
   output [TOTAL_CHNL_NUM*40-1:0]                                 o_tx_pma_data, // Directed bump tx data sync path
   input  [TOTAL_CHNL_NUM-1:0]                                    i_tx_elane_clk, //Clock for phase compensation fifo
   output [TOTAL_CHNL_NUM*78-1:0]                                 o_tx_elane_data, // data out for phase compensation fifo

 //=================================================================================================
 //AIB open source IP enhancement. The following ports are added to
 //be compliance with AIB specification 1.1
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive data. use aibio49
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_adapt_rstn, //From Mac. Reset near and far side reset state machine. Pin aibio56 
   output [TOTAL_CHNL_NUM*81-1:0]                                 ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
   output [TOTAL_CHNL_NUM*73-1:0]                                 sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet.
   output [TOTAL_CHNL_NUM-1:0]                                    ms_rx_transfer_en, //master link rx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    ms_tx_transfer_en, //master link tx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    sl_rx_transfer_en, //slave link rx transfer enable
   output [TOTAL_CHNL_NUM-1:0]                                    sl_tx_transfer_en, //slave link tx transfer enable

   //=================================================================================================
   // Inout signals for AIB ubump
   inout [95:0]                                                   io_aib_ch0, 
   inout [95:0]                                                   io_aib_ch1,
   inout [95:0]                                                   io_aib_ch2,
   inout [95:0]                                                   io_aib_ch3, 
   inout [95:0]                                                   io_aib_ch4, 
   inout [95:0]                                                   io_aib_ch5, 
   inout [95:0]                                                   io_aib_ch6, 
   inout [95:0]                                                   io_aib_ch7, 
   inout [95:0]                                                   io_aib_ch8, 
   inout [95:0]                                                   io_aib_ch9, 
   inout [95:0]                                                   io_aib_ch10, 
   inout [95:0]                                                   io_aib_ch11, 
   inout [95:0]                                                   io_aib_ch12, 
   inout [95:0]                                                   io_aib_ch13, 
   inout [95:0]                                                   io_aib_ch14, 
   inout [95:0]                                                   io_aib_ch15, 
   inout [95:0]                                                   io_aib_ch16, 
   inout [95:0]                                                   io_aib_ch17, 
   inout [95:0]                                                   io_aib_ch18, 
   inout [95:0]                                                   io_aib_ch19, 
   inout [95:0]                                                   io_aib_ch20, 
   inout [95:0]                                                   io_aib_ch21, 
   inout [95:0]                                                   io_aib_ch22, 
   inout [95:0]                                                   io_aib_ch23, 


   //======================================================================================
   // DFT signals
   input                                                          i_scan_clk, 
   input                                                          i_test_clk_125m,
   input                                                          i_test_clk_1g, 
   input                                                          i_test_clk_250m,
   input                                                          i_test_clk_500m,
   input                                                          i_test_clk_62m,

   input [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  i_test_c3adapt_scan_in, 
   input [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]                     i_test_c3adapt_tcb_static_common, //short all channels to one input
   output [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] o_test_c3adapt_scan_out,
   output [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_JTAG_OUT_RNG]    o_test_c3adapttcb_jtag, 
  
   //JTAG
   input                                                          i_jtag_rstb_in, // JTAG controlleable reset the AIB IO circuitry
   input                                                          i_jtag_rstb_en_in, // JTAG controlleable override to reset the AIB IO circuitry
   input                                                          i_jtag_clkdr_in, // Enable AIB IO boundary scan clock (clock gate control) 
   input                                                          i_jtag_clksel_in, // Select between i_jtag_clkdr_in and functional clk
   input                                                          i_jtag_intest_in, // Enable in test operation 
   input                                                          i_jtag_mode_in, // Selects between AIB BSR register or functional path 
   input                                                          i_jtag_weakpdn_in, // Enable weak pull down. Connect to all AIB IO cell 
   input                                                          i_jtag_weakpu_in, // Enable weak pull up. Connect to all AIB IO cell 
   input                                                          i_jtag_bs_scanen_in, // Drives AIB IO jtag_tx_scanen_in or BSR shift control 
   input                                                          i_jtag_bs_chain_in, // TDI 

   input                                                          i_por_aib_vcchssi, //output of por circuit 
   input                                                          i_por_aib_vccl,
   output                                                         o_jtag_last_bs_chain_out,
   
   // To Red BSR Redundency. Connection between channels
   output                                                         o_red_idataselb_out_chain1,// 
   output                                                         o_red_idataselb_out_chain2,// 
   output                                                         o_red_shift_en_out_chain1,// 
   output                                                         o_red_shift_en_out_chain2,// 
   output                                                         o_txen_out_chain1, // Redundency signal 
   output                                                         o_txen_out_chain2, // Redundency signal
   output                                                         o_directout_data_chain1_out,//  
   output                                                         o_directout_data_chain2_out,
   output [12:0]                                                  o_aibdftdll2adjch
   
   );

    localparam C3_AVMM_AIB0_ID  = 6'd0;
    localparam C3_AVMM_AIB1_ID  = 6'd1;
    localparam C3_AVMM_AIB2_ID  = 6'd2;
    localparam C3_AVMM_AIB3_ID  = 6'd3;
    localparam C3_AVMM_AIB4_ID  = 6'd4;
    localparam C3_AVMM_AIB5_ID  = 6'd5;
    localparam C3_AVMM_AIB6_ID  = 6'd6;
    localparam C3_AVMM_AIB7_ID  = 6'd7;
    localparam C3_AVMM_AIB8_ID  = 6'd8;
    localparam C3_AVMM_AIB9_ID  = 6'd9;
    localparam C3_AVMM_AIB10_ID = 6'd10;
    localparam C3_AVMM_AIB11_ID = 6'd11;
    localparam C3_AVMM_AIB12_ID = 6'd12;
    localparam C3_AVMM_AIB13_ID = 6'd13;
    localparam C3_AVMM_AIB14_ID = 6'd14;
    localparam C3_AVMM_AIB15_ID = 6'd15;
    localparam C3_AVMM_AIB16_ID = 6'd16;
    localparam C3_AVMM_AIB17_ID = 6'd17;
    localparam C3_AVMM_AIB18_ID = 6'd18;
    localparam C3_AVMM_AIB19_ID = 6'd19;
    localparam C3_AVMM_AIB20_ID = 6'd20;
    localparam C3_AVMM_AIB21_ID = 6'd21;
    localparam C3_AVMM_AIB22_ID = 6'd22;
    localparam C3_AVMM_AIB23_ID = 6'd23;
    
     /*AUTOWIRE*/
     // Beginning of automatic wires (for undeclared instantiated-module outputs)
     wire [22:0]        aib_adpt_chnl_hard_rst_n;// From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [16:0]        aib_cfg_avmm_addr_ch0;  // From u_c3aibadapt_0 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch1;  // From u_c3aibadapt_1 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch10; // From u_c3aibadapt_10 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch11; // From u_c3aibadapt_11 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch12; // From u_c3aibadapt_12 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch13; // From u_c3aibadapt_13 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch14; // From u_c3aibadapt_14 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch15; // From u_c3aibadapt_15 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch16; // From u_c3aibadapt_16 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch17; // From u_c3aibadapt_17 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch18; // From u_c3aibadapt_18 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch19; // From u_c3aibadapt_19 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch2;  // From u_c3aibadapt_2 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch20; // From u_c3aibadapt_20 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch21; // From u_c3aibadapt_21 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch22; // From u_c3aibadapt_22 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch3;  // From u_c3aibadapt_3 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch4;  // From u_c3aibadapt_4 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch5;  // From u_c3aibadapt_5 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch6;  // From u_c3aibadapt_6 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch7;  // From u_c3aibadapt_7 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch8;  // From u_c3aibadapt_8 of c3aibadapt_wrap.v
     wire [16:0]        aib_cfg_avmm_addr_ch9;  // From u_c3aibadapt_9 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch0;// From u_c3aibadapt_0 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch1;// From u_c3aibadapt_1 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch10;// From u_c3aibadapt_10 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch11;// From u_c3aibadapt_11 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch12;// From u_c3aibadapt_12 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch13;// From u_c3aibadapt_13 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch14;// From u_c3aibadapt_14 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch15;// From u_c3aibadapt_15 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch16;// From u_c3aibadapt_16 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch17;// From u_c3aibadapt_17 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch18;// From u_c3aibadapt_18 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch19;// From u_c3aibadapt_19 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch2;// From u_c3aibadapt_2 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch20;// From u_c3aibadapt_20 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch21;// From u_c3aibadapt_21 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch22;// From u_c3aibadapt_22 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch3;// From u_c3aibadapt_3 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch4;// From u_c3aibadapt_4 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch5;// From u_c3aibadapt_5 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch6;// From u_c3aibadapt_6 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch7;// From u_c3aibadapt_7 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch8;// From u_c3aibadapt_8 of c3aibadapt_wrap.v
     wire [3:0]         aib_cfg_avmm_byte_en_ch9;// From u_c3aibadapt_9 of c3aibadapt_wrap.v
     wire [22:0]        aib_cfg_avmm_clk;       // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [31:0]        aib_cfg_avmm_rdata_ch1; // From u_c3aibadapt_1 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch10;// From u_c3aibadapt_10 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch11;// From u_c3aibadapt_11 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch12;// From u_c3aibadapt_12 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch13;// From u_c3aibadapt_13 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch14;// From u_c3aibadapt_14 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch15;// From u_c3aibadapt_15 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch16;// From u_c3aibadapt_16 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch17;// From u_c3aibadapt_17 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch18;// From u_c3aibadapt_18 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch19;// From u_c3aibadapt_19 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch2; // From u_c3aibadapt_2 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch20;// From u_c3aibadapt_20 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch21;// From u_c3aibadapt_21 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch22;// From u_c3aibadapt_22 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch23;// From u_c3aibadapt_23 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch24;// From u_c3routing_chnl_edge of c3routing_chnl_edge.v
     wire [31:0]        aib_cfg_avmm_rdata_ch3; // From u_c3aibadapt_3 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch4; // From u_c3aibadapt_4 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch5; // From u_c3aibadapt_5 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch6; // From u_c3aibadapt_6 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch7; // From u_c3aibadapt_7 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch8; // From u_c3aibadapt_8 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_rdata_ch9; // From u_c3aibadapt_9 of c3aibadapt_wrap.v
     wire [24:1]        aib_cfg_avmm_rdatavld;  // From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [22:0]        aib_cfg_avmm_read;      // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [22:0]        aib_cfg_avmm_rst_n;     // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_cfg_avmm_waitreq;   // From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [31:0]        aib_cfg_avmm_wdata_ch0; // From u_c3aibadapt_0 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch1; // From u_c3aibadapt_1 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch10;// From u_c3aibadapt_10 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch11;// From u_c3aibadapt_11 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch12;// From u_c3aibadapt_12 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch13;// From u_c3aibadapt_13 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch14;// From u_c3aibadapt_14 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch15;// From u_c3aibadapt_15 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch16;// From u_c3aibadapt_16 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch17;// From u_c3aibadapt_17 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch18;// From u_c3aibadapt_18 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch19;// From u_c3aibadapt_19 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch2; // From u_c3aibadapt_2 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch20;// From u_c3aibadapt_20 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch21;// From u_c3aibadapt_21 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch22;// From u_c3aibadapt_22 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch3; // From u_c3aibadapt_3 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch4; // From u_c3aibadapt_4 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch5; // From u_c3aibadapt_5 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch6; // From u_c3aibadapt_6 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch7; // From u_c3aibadapt_7 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch8; // From u_c3aibadapt_8 of c3aibadapt_wrap.v
     wire [31:0]        aib_cfg_avmm_wdata_ch9; // From u_c3aibadapt_9 of c3aibadapt_wrap.v
     wire [22:0]        aib_cfg_avmm_write;     // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [12:0]        aib_dftdll2adjch_ch1;   // From u_c3aibadapt_1 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch10;  // From u_c3aibadapt_10 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch11;  // From u_c3aibadapt_11 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch12;  // From u_c3aibadapt_12 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch13;  // From u_c3aibadapt_13 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch14;  // From u_c3aibadapt_14 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch15;  // From u_c3aibadapt_15 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch16;  // From u_c3aibadapt_16 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch17;  // From u_c3aibadapt_17 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch18;  // From u_c3aibadapt_18 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch19;  // From u_c3aibadapt_19 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch2;   // From u_c3aibadapt_2 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch20;  // From u_c3aibadapt_20 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch21;  // From u_c3aibadapt_21 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch22;  // From u_c3aibadapt_22 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch23;  // From u_c3aibadapt_23 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch24;  // From u_c3routing_chnl_edge of c3routing_chnl_edge.v
     wire [12:0]        aib_dftdll2adjch_ch3;   // From u_c3aibadapt_3 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch4;   // From u_c3aibadapt_4 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch5;   // From u_c3aibadapt_5 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch6;   // From u_c3aibadapt_6 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch7;   // From u_c3aibadapt_7 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch8;   // From u_c3aibadapt_8 of c3aibadapt_wrap.v
     wire [12:0]        aib_dftdll2adjch_ch9;   // From u_c3aibadapt_9 of c3aibadapt_wrap.v
     wire [24:1]        aib_directout_data_chain1_out;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_directout_data_chain2_out;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_bs_chain_out;  // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_bs_scanen_out; // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_clkdr_out;     // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_clksel_out;    // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_intest_out;    // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_jtag_last_bs_chain_out;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_mode_out;      // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_rstb_en_out;   // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_rstb_out;      // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_weakpdn_out;   // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [23:0]        aib_jtag_weakpu_out;    // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [22:0]        aib_osc_clk;            // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [22:0]        aib_por_vcchssi;        // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [22:0]        aib_por_vccl;           // From u_c3aibadapt_0 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_red_idataselb_chain1;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_red_idataselb_chain2;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_red_shift_en_chain1;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_red_shift_en_chain2;// From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_txen_chain1;        // From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [24:1]        aib_txen_chain2;        // From u_c3aibadapt_1 of c3aibadapt_wrap.v, ...
     wire [2:0]         chnl_aib_adpt_hard_rst_n;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [16:0]        chnl_aib_cfg_avmm_addr_0;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v
     wire [16:0]        chnl_aib_cfg_avmm_addr_1;// From u_c3routing_chnl_1 of c3routing_chnl_aib.v
     wire [16:0]        chnl_aib_cfg_avmm_addr_2;// From u_c3routing_chnl_2 of c3routing_chnl_aib.v
     wire [3:0]         chnl_aib_cfg_avmm_byte_en_0;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v
     wire [3:0]         chnl_aib_cfg_avmm_byte_en_1;// From u_c3routing_chnl_1 of c3routing_chnl_aib.v
     wire [3:0]         chnl_aib_cfg_avmm_byte_en_2;// From u_c3routing_chnl_2 of c3routing_chnl_aib.v
     wire [2:0]         chnl_aib_cfg_avmm_clk;  // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [31:0]        chnl_aib_cfg_avmm_rdata_0;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v
     wire [31:0]        chnl_aib_cfg_avmm_rdata_1;// From u_c3routing_chnl_1 of c3routing_chnl_aib.v
     wire [31:0]        chnl_aib_cfg_avmm_rdata_2;// From u_c3routing_chnl_2 of c3routing_chnl_aib.v
     wire [2:0]         chnl_aib_cfg_avmm_rdatavld;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_cfg_avmm_read; // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_cfg_avmm_rst_n;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_cfg_avmm_waitreq;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [31:0]        chnl_aib_cfg_avmm_wdata_0;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v
     wire [31:0]        chnl_aib_cfg_avmm_wdata_1;// From u_c3routing_chnl_1 of c3routing_chnl_aib.v
     wire [31:0]        chnl_aib_cfg_avmm_wdata_2;// From u_c3routing_chnl_2 of c3routing_chnl_aib.v
     wire [2:0]         chnl_aib_cfg_avmm_write;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [12:0]        chnl_aib_dftdll2adjch_0;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v
     wire [12:0]        chnl_aib_dftdll2adjch_1;// From u_c3routing_chnl_1 of c3routing_chnl_aib.v
     wire [12:0]        chnl_aib_dftdll2adjch_2;// From u_c3routing_chnl_2 of c3routing_chnl_aib.v
     wire [2:0]         chnl_aib_directout_data_chain1_out;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_directout_data_chain2_out;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_jtag_bs_chain_out;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_jtag_last_bs_chain_out;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_osc_clk;       // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_red_idataselb_chain1;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_red_idataselb_chain2;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_red_shift_en_chain1;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_red_shift_en_chain2;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_txen_chain1;   // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_txen_chain2;   // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_vcchssi;       // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_aib_vccl;          // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_bs_scanen_out;// From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_clkdr_out;    // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_clksel_out;   // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_intest_out;   // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_mode_out;     // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_rstb_en_out;  // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_rstb_out;     // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_weakpdn_out;  // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     wire [2:0]         chnl_jtag_weakpu_out;   // From u_c3routing_chnl_0 of c3routing_chnl_aib.v, ...
     // End of automatics

    /*c3aibadapt_wrap AUTO_TEMPLATE "u_c3aibadapt_\(.*\)" ( 
     .i_\(.*\)_pma_clk   (i_\1_pma_clk[@]),
     .i_\(.*\)_pma_div2_clk  (i_\1_pma_div2_clk[@]),
     .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[@]), 
     .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[@]),
     .o_tx_xcvrif_rst_n  (),
     .o_ehip_init_status (),
     
     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[@]),
     .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch@[]),
     .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[@]),
     .o_adpt_cfg_clk     (aib_cfg_avmm_clk[@]), //clock connected using daisy chain scheme
     .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[@]),
     .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch@[]),
     .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch@[]),
     .o_adpt_cfg_read    (aib_cfg_avmm_read[@]),
     .o_adpt_cfg_write   (aib_cfg_avmm_write[@]),
     .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch@[]),
     .o_osc_clk          (aib_osc_clk[@]),
     .o_chnl_ssr         (o_chnl_ssr[@"(+ (* 61 @) 60)":@"(* 61 @)"]),
     
          
     .i_channel_id       (C3_AVMM_AIB@_ID),
     .i_cfg_avmm_clk     (aib_cfg_avmm_clk[@"(- @ 1)"]),
     .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[@"(- @ 1)"]),
     .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch@"(number-to-string(- @ 1))"[]),
     .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch@"(number-to-string(- @ 1))"[]),
     .i_cfg_avmm_read    (aib_cfg_avmm_read[@"(- @ 1)"]),
     .i_cfg_avmm_write   (aib_cfg_avmm_write[@"(- @ 1)"]),
     .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch@"(number-to-string(- @ 1))"[]),
     
     .i_osc_clk          (aib_osc_clk[@"(number-to-string(- @ 1))"]),
     .i_chnl_ssr         (i_chnl_ssr[@"(+ (* 65 @) 64)":@"(* 65 @)"]),
     .i_rx_pma_data      (i_rx_pma_data[@"(+ (* 40 @) 39)":@"(* 40 @)"]),
     .o_tx_transfer_clk  (o_tx_transfer_clk[@]),
     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[@]),
     .o_tx_pma_data      (o_tx_pma_data[@"(+ (* 40 @) 39)":@"(* 40 @)"]),
     
     .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[@"(- @ 1)"]),
     .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[@"(+ @ 1)"]),
     .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch@"(number-to-string(+ @ 1))"[]),
     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[@"(+ @ 1)"]),
     
     //DFT ports
     
     .i_scan_clk         (i_scan_clk),
     .i_test_clk_1g      (i_test_clk_1g),
     .i_test_clk_500m    (i_test_clk_500m),
     .i_test_clk_250m    (i_test_clk_250m),
     .i_test_clk_125m    (i_test_clk_125m),
     .i_test_clk_62m     (i_test_clk_62m),
     
     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[]),
     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[@][]),
     
     //Daisy chain, the input are connected to the output of the previous channel
     .i_jtag_rstb_in     (aib_jtag_rstb_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_clkdr_in    (aib_jtag_clkdr_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_clksel_in   (aib_jtag_clksel_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_intest_in   (aib_jtag_intest_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_mode_in     (aib_jtag_mode_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_weakpu_in   (aib_jtag_weakpu_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[@"(number-to-string(- @ 1))"]),
     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[@"(number-to-string(+ @ 1))"]),
     .i_por_aib_vcchssi  (aib_por_vcchssi[@"(number-to-string(- @ 1))"]),
     .i_por_aib_vccl     (aib_por_vccl[@"(number-to-string(- @ 1))"]),
     
     //Daisy chain, the inputs are connected to the output of the next channel
     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[@"(number-to-string(+ @ 1))"]),
     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[@"(number-to-string(+ @ 1))"]),
     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[@"(number-to-string(+ @ 1))"]),
     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[@"(number-to-string(+ @ 1))"]),
     .i_txen_in_chain1   (aib_txen_chain1[@"(number-to-string(+ @ 1))"]),
     .i_txen_in_chain2   (aib_txen_chain2[@"(number-to-string(+ @ 1))"]),
     .i_directout_data_chain1_in(aib_directout_data_chain1_out[@"(number-to-string(+ @ 1))"]),
     .i_directout_data_chain2_in(aib_directout_data_chain2_out[@"(number-to-string(+ @ 1))"]),
     .i_aibdftdll2adjch  (aib_dftdll2adjch_ch@"(number-to-string(+ @ 1))"[]),
     
     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[@][]),
     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[@][]),
     .o_jtag_clkdr_out   (aib_jtag_clkdr_out[@]),
     .o_jtag_clksel_out  (aib_jtag_clksel_out[@]),
     .o_jtag_intest_out  (aib_jtag_intest_out[@]),
     .o_jtag_mode_out    (aib_jtag_mode_out[@]),
     .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[@]),
     .o_jtag_rstb_out    (aib_jtag_rstb_out[@]),
     .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[@]),
     .o_jtag_weakpu_out  (aib_jtag_weakpu_out[@]),
     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[@]),
     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[@]),
     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[@]),
     .o_por_aib_vcchssi  (aib_por_vcchssi[@]),
     .o_por_aib_vccl     (aib_por_vccl[@]),
     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[@]),
     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[@]),
     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[@]),
     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[@]),
     .o_txen_out_chain1  (aib_txen_chain1[@]),
     .o_txen_out_chain2  (aib_txen_chain2[@]),
     .o_directout_data_chain1_out(aib_directout_data_chain1_out[@]),
     .o_directout_data_chain2_out(aib_directout_data_chain2_out[@]),
     .o_aibdftdll2adjch  (aib_dftdll2adjch_ch@[]),

     
     //inout signals
     .io_aib\(.*\)       (io_aib_ch@[\1]),
     );
     
    */   
    
    c3aibadapt_wrap u_c3aibadapt_0 (
                                    //for the daisy chain signals, channel 0 takes the input from outside
                                    .i_adpt_hard_rst_n  (i_adpt_hard_rst_n),
                                    .i_cfg_avmm_clk     (i_cfg_avmm_clk),
                                    .i_cfg_avmm_rst_n   (i_cfg_avmm_rst_n),
                                    .i_cfg_avmm_addr    (i_cfg_avmm_addr[16:0]),
                                    .i_cfg_avmm_byte_en (i_cfg_avmm_byte_en[3:0]),
                                    .i_cfg_avmm_read    (i_cfg_avmm_read),
                                    .i_cfg_avmm_write   (i_cfg_avmm_write),
                                    .i_cfg_avmm_wdata   (i_cfg_avmm_wdata[31:0]),
                                    .i_osc_clk          (i_osc_clk),
                                    .i_jtag_rstb_in     (i_jtag_rstb_in),
                                    .i_jtag_rstb_en_in  (i_jtag_rstb_en_in),
                                    .i_jtag_clkdr_in    (i_jtag_clkdr_in),
                                    .i_jtag_clksel_in   (i_jtag_clksel_in),   
                                    .i_jtag_intest_in   (i_jtag_intest_in),   
                                    .i_jtag_mode_in     (i_jtag_mode_in),     
                                    .i_jtag_weakpdn_in  (i_jtag_weakpdn_in),  
                                    .i_jtag_weakpu_in   (i_jtag_weakpu_in),   
                                    .i_jtag_bs_scanen_in(i_jtag_bs_scanen_in),
                                    .i_jtag_bs_chain_in (i_jtag_bs_chain_in), 
                                    .i_por_aib_vcchssi  (i_por_aib_vcchssi),
                                    .i_por_aib_vccl     (i_por_aib_vccl),
                                    
                                    .o_jtag_last_bs_chain_out(o_jtag_last_bs_chain_out),
                                    .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld),
                                    .o_cfg_avmm_rdata   (o_cfg_avmm_rdata[31:0]),
                                    .o_cfg_avmm_waitreq (o_cfg_avmm_waitreq),

                                    .o_red_idataselb_out_chain1(o_red_idataselb_out_chain1),
                                    .o_red_idataselb_out_chain2(o_red_idataselb_out_chain2),
                                    .o_red_shift_en_out_chain1 (o_red_shift_en_out_chain1),
                                    .o_red_shift_en_out_chain2 (o_red_shift_en_out_chain2),
                                    .o_txen_out_chain1         (o_txen_out_chain1),
                                    .o_txen_out_chain2         (o_txen_out_chain2),
                                    .o_directout_data_chain1_out(o_directout_data_chain1_out),
                                    .o_directout_data_chain2_out(o_directout_data_chain2_out),
                                    .o_aibdftdll2adjch          (o_aibdftdll2adjch[12:0]),
                                    
                                    /*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[0]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[0]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[0]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[0]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch0[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch0[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[0]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[0]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch0[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[0]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[60:0]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[0]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[0]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[39:0]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[0]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[0]),
                                    .ms_sideband        (ms_sideband[80:0]),
                                    .sl_sideband        (sl_sideband[72:0]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[0]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[0]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[0]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[0]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[0]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[0][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[0][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[0]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[0]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[0]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[0]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[0]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[0]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[0]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[0]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[0]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[0]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[0]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch0[0]), // Templated
                                    .io_aib1            (io_aib_ch0[1]), // Templated
                                    .io_aib10           (io_aib_ch0[10]), // Templated
                                    .io_aib11           (io_aib_ch0[11]), // Templated
                                    .io_aib12           (io_aib_ch0[12]), // Templated
                                    .io_aib13           (io_aib_ch0[13]), // Templated
                                    .io_aib14           (io_aib_ch0[14]), // Templated
                                    .io_aib15           (io_aib_ch0[15]), // Templated
                                    .io_aib16           (io_aib_ch0[16]), // Templated
                                    .io_aib17           (io_aib_ch0[17]), // Templated
                                    .io_aib18           (io_aib_ch0[18]), // Templated
                                    .io_aib19           (io_aib_ch0[19]), // Templated
                                    .io_aib2            (io_aib_ch0[2]), // Templated
                                    .io_aib20           (io_aib_ch0[20]), // Templated
                                    .io_aib21           (io_aib_ch0[21]), // Templated
                                    .io_aib22           (io_aib_ch0[22]), // Templated
                                    .io_aib23           (io_aib_ch0[23]), // Templated
                                    .io_aib24           (io_aib_ch0[24]), // Templated
                                    .io_aib25           (io_aib_ch0[25]), // Templated
                                    .io_aib26           (io_aib_ch0[26]), // Templated
                                    .io_aib27           (io_aib_ch0[27]), // Templated
                                    .io_aib28           (io_aib_ch0[28]), // Templated
                                    .io_aib29           (io_aib_ch0[29]), // Templated
                                    .io_aib3            (io_aib_ch0[3]), // Templated
                                    .io_aib30           (io_aib_ch0[30]), // Templated
                                    .io_aib31           (io_aib_ch0[31]), // Templated
                                    .io_aib32           (io_aib_ch0[32]), // Templated
                                    .io_aib33           (io_aib_ch0[33]), // Templated
                                    .io_aib34           (io_aib_ch0[34]), // Templated
                                    .io_aib35           (io_aib_ch0[35]), // Templated
                                    .io_aib36           (io_aib_ch0[36]), // Templated
                                    .io_aib37           (io_aib_ch0[37]), // Templated
                                    .io_aib38           (io_aib_ch0[38]), // Templated
                                    .io_aib39           (io_aib_ch0[39]), // Templated
                                    .io_aib4            (io_aib_ch0[4]), // Templated
                                    .io_aib40           (io_aib_ch0[40]), // Templated
                                    .io_aib41           (io_aib_ch0[41]), // Templated
                                    .io_aib42           (io_aib_ch0[42]), // Templated
                                    .io_aib43           (io_aib_ch0[43]), // Templated
                                    .io_aib44           (io_aib_ch0[44]), // Templated
                                    .io_aib45           (io_aib_ch0[45]), // Templated
                                    .io_aib46           (io_aib_ch0[46]), // Templated
                                    .io_aib47           (io_aib_ch0[47]), // Templated
                                    .io_aib48           (io_aib_ch0[48]), // Templated
                                    .io_aib49           (io_aib_ch0[49]), // Templated
                                    .io_aib5            (io_aib_ch0[5]), // Templated
                                    .io_aib50           (io_aib_ch0[50]), // Templated
                                    .io_aib51           (io_aib_ch0[51]), // Templated
                                    .io_aib52           (io_aib_ch0[52]), // Templated
                                    .io_aib53           (io_aib_ch0[53]), // Templated
                                    .io_aib54           (io_aib_ch0[54]), // Templated
                                    .io_aib55           (io_aib_ch0[55]), // Templated
                                    .io_aib56           (io_aib_ch0[56]), // Templated
                                    .io_aib57           (io_aib_ch0[57]), // Templated
                                    .io_aib58           (io_aib_ch0[58]), // Templated
                                    .io_aib59           (io_aib_ch0[59]), // Templated
                                    .io_aib6            (io_aib_ch0[6]), // Templated
                                    .io_aib60           (io_aib_ch0[60]), // Templated
                                    .io_aib61           (io_aib_ch0[61]), // Templated
                                    .io_aib62           (io_aib_ch0[62]), // Templated
                                    .io_aib63           (io_aib_ch0[63]), // Templated
                                    .io_aib64           (io_aib_ch0[64]), // Templated
                                    .io_aib65           (io_aib_ch0[65]), // Templated
                                    .io_aib66           (io_aib_ch0[66]), // Templated
                                    .io_aib67           (io_aib_ch0[67]), // Templated
                                    .io_aib68           (io_aib_ch0[68]), // Templated
                                    .io_aib69           (io_aib_ch0[69]), // Templated
                                    .io_aib7            (io_aib_ch0[7]), // Templated
                                    .io_aib70           (io_aib_ch0[70]), // Templated
                                    .io_aib71           (io_aib_ch0[71]), // Templated
                                    .io_aib72           (io_aib_ch0[72]), // Templated
                                    .io_aib73           (io_aib_ch0[73]), // Templated
                                    .io_aib74           (io_aib_ch0[74]), // Templated
                                    .io_aib75           (io_aib_ch0[75]), // Templated
                                    .io_aib76           (io_aib_ch0[76]), // Templated
                                    .io_aib77           (io_aib_ch0[77]), // Templated
                                    .io_aib78           (io_aib_ch0[78]), // Templated
                                    .io_aib79           (io_aib_ch0[79]), // Templated
                                    .io_aib8            (io_aib_ch0[8]), // Templated
                                    .io_aib80           (io_aib_ch0[80]), // Templated
                                    .io_aib81           (io_aib_ch0[81]), // Templated
                                    .io_aib82           (io_aib_ch0[82]), // Templated
                                    .io_aib83           (io_aib_ch0[83]), // Templated
                                    .io_aib84           (io_aib_ch0[84]), // Templated
                                    .io_aib85           (io_aib_ch0[85]), // Templated
                                    .io_aib86           (io_aib_ch0[86]), // Templated
                                    .io_aib87           (io_aib_ch0[87]), // Templated
                                    .io_aib88           (io_aib_ch0[88]), // Templated
                                    .io_aib89           (io_aib_ch0[89]), // Templated
                                    .io_aib9            (io_aib_ch0[9]), // Templated
                                    .io_aib90           (io_aib_ch0[90]), // Templated
                                    .io_aib91           (io_aib_ch0[91]), // Templated
                                    .io_aib92           (io_aib_ch0[92]), // Templated
                                    .io_aib93           (io_aib_ch0[93]), // Templated
                                    .io_aib94           (io_aib_ch0[94]), // Templated
                                    .io_aib95           (io_aib_ch0[95]), // Templated
                                    // Inputs
                                    .i_channel_id       (C3_AVMM_AIB0_ID), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[1]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch1[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[1]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[0]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[0]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[64:0]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[39:0]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[0]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[0]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[77:0]),
                                    .o_tx_elane_data    (o_tx_elane_data[77:0]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[0]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[0][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[1]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[1]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[1]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[1]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[1]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[1]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[1]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[1]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[1]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch1[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_1 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[1]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[1]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[1]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch1[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[1]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[1]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[1]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch1[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch1[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[1]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[1]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch1[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[1]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[121:61]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[1]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[1]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[79:40]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[1]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[1]),
                                    .ms_sideband        (ms_sideband[161:81]),
                                    .sl_sideband        (sl_sideband[145:73]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[1]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[1]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[1]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[1]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[1]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[1][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[1][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[1]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[1]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[1]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[1]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[1]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[1]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[1]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[1]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[1]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[1]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[1]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[1]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[1]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[1]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[1]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[1]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[1]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[1]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[1]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[1]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[1]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch1[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch1[0]), // Templated
                                    .io_aib1            (io_aib_ch1[1]), // Templated
                                    .io_aib10           (io_aib_ch1[10]), // Templated
                                    .io_aib11           (io_aib_ch1[11]), // Templated
                                    .io_aib12           (io_aib_ch1[12]), // Templated
                                    .io_aib13           (io_aib_ch1[13]), // Templated
                                    .io_aib14           (io_aib_ch1[14]), // Templated
                                    .io_aib15           (io_aib_ch1[15]), // Templated
                                    .io_aib16           (io_aib_ch1[16]), // Templated
                                    .io_aib17           (io_aib_ch1[17]), // Templated
                                    .io_aib18           (io_aib_ch1[18]), // Templated
                                    .io_aib19           (io_aib_ch1[19]), // Templated
                                    .io_aib2            (io_aib_ch1[2]), // Templated
                                    .io_aib20           (io_aib_ch1[20]), // Templated
                                    .io_aib21           (io_aib_ch1[21]), // Templated
                                    .io_aib22           (io_aib_ch1[22]), // Templated
                                    .io_aib23           (io_aib_ch1[23]), // Templated
                                    .io_aib24           (io_aib_ch1[24]), // Templated
                                    .io_aib25           (io_aib_ch1[25]), // Templated
                                    .io_aib26           (io_aib_ch1[26]), // Templated
                                    .io_aib27           (io_aib_ch1[27]), // Templated
                                    .io_aib28           (io_aib_ch1[28]), // Templated
                                    .io_aib29           (io_aib_ch1[29]), // Templated
                                    .io_aib3            (io_aib_ch1[3]), // Templated
                                    .io_aib30           (io_aib_ch1[30]), // Templated
                                    .io_aib31           (io_aib_ch1[31]), // Templated
                                    .io_aib32           (io_aib_ch1[32]), // Templated
                                    .io_aib33           (io_aib_ch1[33]), // Templated
                                    .io_aib34           (io_aib_ch1[34]), // Templated
                                    .io_aib35           (io_aib_ch1[35]), // Templated
                                    .io_aib36           (io_aib_ch1[36]), // Templated
                                    .io_aib37           (io_aib_ch1[37]), // Templated
                                    .io_aib38           (io_aib_ch1[38]), // Templated
                                    .io_aib39           (io_aib_ch1[39]), // Templated
                                    .io_aib4            (io_aib_ch1[4]), // Templated
                                    .io_aib40           (io_aib_ch1[40]), // Templated
                                    .io_aib41           (io_aib_ch1[41]), // Templated
                                    .io_aib42           (io_aib_ch1[42]), // Templated
                                    .io_aib43           (io_aib_ch1[43]), // Templated
                                    .io_aib44           (io_aib_ch1[44]), // Templated
                                    .io_aib45           (io_aib_ch1[45]), // Templated
                                    .io_aib46           (io_aib_ch1[46]), // Templated
                                    .io_aib47           (io_aib_ch1[47]), // Templated
                                    .io_aib48           (io_aib_ch1[48]), // Templated
                                    .io_aib49           (io_aib_ch1[49]), // Templated
                                    .io_aib5            (io_aib_ch1[5]), // Templated
                                    .io_aib50           (io_aib_ch1[50]), // Templated
                                    .io_aib51           (io_aib_ch1[51]), // Templated
                                    .io_aib52           (io_aib_ch1[52]), // Templated
                                    .io_aib53           (io_aib_ch1[53]), // Templated
                                    .io_aib54           (io_aib_ch1[54]), // Templated
                                    .io_aib55           (io_aib_ch1[55]), // Templated
                                    .io_aib56           (io_aib_ch1[56]), // Templated
                                    .io_aib57           (io_aib_ch1[57]), // Templated
                                    .io_aib58           (io_aib_ch1[58]), // Templated
                                    .io_aib59           (io_aib_ch1[59]), // Templated
                                    .io_aib6            (io_aib_ch1[6]), // Templated
                                    .io_aib60           (io_aib_ch1[60]), // Templated
                                    .io_aib61           (io_aib_ch1[61]), // Templated
                                    .io_aib62           (io_aib_ch1[62]), // Templated
                                    .io_aib63           (io_aib_ch1[63]), // Templated
                                    .io_aib64           (io_aib_ch1[64]), // Templated
                                    .io_aib65           (io_aib_ch1[65]), // Templated
                                    .io_aib66           (io_aib_ch1[66]), // Templated
                                    .io_aib67           (io_aib_ch1[67]), // Templated
                                    .io_aib68           (io_aib_ch1[68]), // Templated
                                    .io_aib69           (io_aib_ch1[69]), // Templated
                                    .io_aib7            (io_aib_ch1[7]), // Templated
                                    .io_aib70           (io_aib_ch1[70]), // Templated
                                    .io_aib71           (io_aib_ch1[71]), // Templated
                                    .io_aib72           (io_aib_ch1[72]), // Templated
                                    .io_aib73           (io_aib_ch1[73]), // Templated
                                    .io_aib74           (io_aib_ch1[74]), // Templated
                                    .io_aib75           (io_aib_ch1[75]), // Templated
                                    .io_aib76           (io_aib_ch1[76]), // Templated
                                    .io_aib77           (io_aib_ch1[77]), // Templated
                                    .io_aib78           (io_aib_ch1[78]), // Templated
                                    .io_aib79           (io_aib_ch1[79]), // Templated
                                    .io_aib8            (io_aib_ch1[8]), // Templated
                                    .io_aib80           (io_aib_ch1[80]), // Templated
                                    .io_aib81           (io_aib_ch1[81]), // Templated
                                    .io_aib82           (io_aib_ch1[82]), // Templated
                                    .io_aib83           (io_aib_ch1[83]), // Templated
                                    .io_aib84           (io_aib_ch1[84]), // Templated
                                    .io_aib85           (io_aib_ch1[85]), // Templated
                                    .io_aib86           (io_aib_ch1[86]), // Templated
                                    .io_aib87           (io_aib_ch1[87]), // Templated
                                    .io_aib88           (io_aib_ch1[88]), // Templated
                                    .io_aib89           (io_aib_ch1[89]), // Templated
                                    .io_aib9            (io_aib_ch1[9]), // Templated
                                    .io_aib90           (io_aib_ch1[90]), // Templated
                                    .io_aib91           (io_aib_ch1[91]), // Templated
                                    .io_aib92           (io_aib_ch1[92]), // Templated
                                    .io_aib93           (io_aib_ch1[93]), // Templated
                                    .io_aib94           (io_aib_ch1[94]), // Templated
                                    .io_aib95           (io_aib_ch1[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[0]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB1_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[0]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[0]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch0[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch0[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[0]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[0]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch0[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[2]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch2[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[2]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[1]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[1]), // Templated
                                    .i_osc_clk          (aib_osc_clk[0]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[129:65]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[79:40]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[1]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[1]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[155:78]),
                                    .o_tx_elane_data    (o_tx_elane_data[155:78]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[1]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[1][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[0]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[0]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[0]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[0]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[0]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[0]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[0]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[0]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[0]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[0]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[2]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[0]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[0]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[2]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[2]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[2]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[2]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[2]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[2]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[2]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[2]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch2[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_2 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[2]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[2]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[2]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch2[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[2]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[2]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[2]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch2[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch2[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[2]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[2]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch2[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[2]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[182:122]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[2]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[2]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[119:80]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[2]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[2]),
                                    .ms_sideband        (ms_sideband[242:162]),
                                    .sl_sideband        (sl_sideband[218:146]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[2]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[2]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[2]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[2]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[2]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[2][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[2][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[2]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[2]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[2]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[2]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[2]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[2]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[2]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[2]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[2]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[2]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[2]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[2]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[2]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[2]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[2]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[2]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[2]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[2]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[2]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[2]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[2]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch2[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch2[0]), // Templated
                                    .io_aib1            (io_aib_ch2[1]), // Templated
                                    .io_aib10           (io_aib_ch2[10]), // Templated
                                    .io_aib11           (io_aib_ch2[11]), // Templated
                                    .io_aib12           (io_aib_ch2[12]), // Templated
                                    .io_aib13           (io_aib_ch2[13]), // Templated
                                    .io_aib14           (io_aib_ch2[14]), // Templated
                                    .io_aib15           (io_aib_ch2[15]), // Templated
                                    .io_aib16           (io_aib_ch2[16]), // Templated
                                    .io_aib17           (io_aib_ch2[17]), // Templated
                                    .io_aib18           (io_aib_ch2[18]), // Templated
                                    .io_aib19           (io_aib_ch2[19]), // Templated
                                    .io_aib2            (io_aib_ch2[2]), // Templated
                                    .io_aib20           (io_aib_ch2[20]), // Templated
                                    .io_aib21           (io_aib_ch2[21]), // Templated
                                    .io_aib22           (io_aib_ch2[22]), // Templated
                                    .io_aib23           (io_aib_ch2[23]), // Templated
                                    .io_aib24           (io_aib_ch2[24]), // Templated
                                    .io_aib25           (io_aib_ch2[25]), // Templated
                                    .io_aib26           (io_aib_ch2[26]), // Templated
                                    .io_aib27           (io_aib_ch2[27]), // Templated
                                    .io_aib28           (io_aib_ch2[28]), // Templated
                                    .io_aib29           (io_aib_ch2[29]), // Templated
                                    .io_aib3            (io_aib_ch2[3]), // Templated
                                    .io_aib30           (io_aib_ch2[30]), // Templated
                                    .io_aib31           (io_aib_ch2[31]), // Templated
                                    .io_aib32           (io_aib_ch2[32]), // Templated
                                    .io_aib33           (io_aib_ch2[33]), // Templated
                                    .io_aib34           (io_aib_ch2[34]), // Templated
                                    .io_aib35           (io_aib_ch2[35]), // Templated
                                    .io_aib36           (io_aib_ch2[36]), // Templated
                                    .io_aib37           (io_aib_ch2[37]), // Templated
                                    .io_aib38           (io_aib_ch2[38]), // Templated
                                    .io_aib39           (io_aib_ch2[39]), // Templated
                                    .io_aib4            (io_aib_ch2[4]), // Templated
                                    .io_aib40           (io_aib_ch2[40]), // Templated
                                    .io_aib41           (io_aib_ch2[41]), // Templated
                                    .io_aib42           (io_aib_ch2[42]), // Templated
                                    .io_aib43           (io_aib_ch2[43]), // Templated
                                    .io_aib44           (io_aib_ch2[44]), // Templated
                                    .io_aib45           (io_aib_ch2[45]), // Templated
                                    .io_aib46           (io_aib_ch2[46]), // Templated
                                    .io_aib47           (io_aib_ch2[47]), // Templated
                                    .io_aib48           (io_aib_ch2[48]), // Templated
                                    .io_aib49           (io_aib_ch2[49]), // Templated
                                    .io_aib5            (io_aib_ch2[5]), // Templated
                                    .io_aib50           (io_aib_ch2[50]), // Templated
                                    .io_aib51           (io_aib_ch2[51]), // Templated
                                    .io_aib52           (io_aib_ch2[52]), // Templated
                                    .io_aib53           (io_aib_ch2[53]), // Templated
                                    .io_aib54           (io_aib_ch2[54]), // Templated
                                    .io_aib55           (io_aib_ch2[55]), // Templated
                                    .io_aib56           (io_aib_ch2[56]), // Templated
                                    .io_aib57           (io_aib_ch2[57]), // Templated
                                    .io_aib58           (io_aib_ch2[58]), // Templated
                                    .io_aib59           (io_aib_ch2[59]), // Templated
                                    .io_aib6            (io_aib_ch2[6]), // Templated
                                    .io_aib60           (io_aib_ch2[60]), // Templated
                                    .io_aib61           (io_aib_ch2[61]), // Templated
                                    .io_aib62           (io_aib_ch2[62]), // Templated
                                    .io_aib63           (io_aib_ch2[63]), // Templated
                                    .io_aib64           (io_aib_ch2[64]), // Templated
                                    .io_aib65           (io_aib_ch2[65]), // Templated
                                    .io_aib66           (io_aib_ch2[66]), // Templated
                                    .io_aib67           (io_aib_ch2[67]), // Templated
                                    .io_aib68           (io_aib_ch2[68]), // Templated
                                    .io_aib69           (io_aib_ch2[69]), // Templated
                                    .io_aib7            (io_aib_ch2[7]), // Templated
                                    .io_aib70           (io_aib_ch2[70]), // Templated
                                    .io_aib71           (io_aib_ch2[71]), // Templated
                                    .io_aib72           (io_aib_ch2[72]), // Templated
                                    .io_aib73           (io_aib_ch2[73]), // Templated
                                    .io_aib74           (io_aib_ch2[74]), // Templated
                                    .io_aib75           (io_aib_ch2[75]), // Templated
                                    .io_aib76           (io_aib_ch2[76]), // Templated
                                    .io_aib77           (io_aib_ch2[77]), // Templated
                                    .io_aib78           (io_aib_ch2[78]), // Templated
                                    .io_aib79           (io_aib_ch2[79]), // Templated
                                    .io_aib8            (io_aib_ch2[8]), // Templated
                                    .io_aib80           (io_aib_ch2[80]), // Templated
                                    .io_aib81           (io_aib_ch2[81]), // Templated
                                    .io_aib82           (io_aib_ch2[82]), // Templated
                                    .io_aib83           (io_aib_ch2[83]), // Templated
                                    .io_aib84           (io_aib_ch2[84]), // Templated
                                    .io_aib85           (io_aib_ch2[85]), // Templated
                                    .io_aib86           (io_aib_ch2[86]), // Templated
                                    .io_aib87           (io_aib_ch2[87]), // Templated
                                    .io_aib88           (io_aib_ch2[88]), // Templated
                                    .io_aib89           (io_aib_ch2[89]), // Templated
                                    .io_aib9            (io_aib_ch2[9]), // Templated
                                    .io_aib90           (io_aib_ch2[90]), // Templated
                                    .io_aib91           (io_aib_ch2[91]), // Templated
                                    .io_aib92           (io_aib_ch2[92]), // Templated
                                    .io_aib93           (io_aib_ch2[93]), // Templated
                                    .io_aib94           (io_aib_ch2[94]), // Templated
                                    .io_aib95           (io_aib_ch2[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[1]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB2_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[1]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[1]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch1[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch1[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[1]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[1]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch1[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[3]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch3[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[3]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[2]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[2]), // Templated
                                    .i_osc_clk          (aib_osc_clk[1]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[194:130]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[119:80]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[2]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[2]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[233:156]),
                                    .o_tx_elane_data    (o_tx_elane_data[233:156]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[2]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[2][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[1]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[1]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[1]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[1]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[1]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[1]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[1]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[1]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[1]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[1]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[3]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[1]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[1]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[3]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[3]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[3]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[3]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[3]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[3]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[3]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[3]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch3[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_3 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[3]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[3]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[3]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch3[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[3]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[3]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[3]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch3[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch3[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[3]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[3]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch3[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[3]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[243:183]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[3]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[3]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[159:120]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[3]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[3]),
                                    .ms_sideband        (ms_sideband[323:243]),
                                    .sl_sideband        (sl_sideband[291:219]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[3]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[3]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[3]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[3]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[3]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[3][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[3][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[3]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[3]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[3]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[3]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[3]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[3]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[3]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[3]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[3]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[3]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[3]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[3]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[3]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[3]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[3]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[3]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[3]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[3]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[3]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[3]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[3]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch3[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch3[0]), // Templated
                                    .io_aib1            (io_aib_ch3[1]), // Templated
                                    .io_aib10           (io_aib_ch3[10]), // Templated
                                    .io_aib11           (io_aib_ch3[11]), // Templated
                                    .io_aib12           (io_aib_ch3[12]), // Templated
                                    .io_aib13           (io_aib_ch3[13]), // Templated
                                    .io_aib14           (io_aib_ch3[14]), // Templated
                                    .io_aib15           (io_aib_ch3[15]), // Templated
                                    .io_aib16           (io_aib_ch3[16]), // Templated
                                    .io_aib17           (io_aib_ch3[17]), // Templated
                                    .io_aib18           (io_aib_ch3[18]), // Templated
                                    .io_aib19           (io_aib_ch3[19]), // Templated
                                    .io_aib2            (io_aib_ch3[2]), // Templated
                                    .io_aib20           (io_aib_ch3[20]), // Templated
                                    .io_aib21           (io_aib_ch3[21]), // Templated
                                    .io_aib22           (io_aib_ch3[22]), // Templated
                                    .io_aib23           (io_aib_ch3[23]), // Templated
                                    .io_aib24           (io_aib_ch3[24]), // Templated
                                    .io_aib25           (io_aib_ch3[25]), // Templated
                                    .io_aib26           (io_aib_ch3[26]), // Templated
                                    .io_aib27           (io_aib_ch3[27]), // Templated
                                    .io_aib28           (io_aib_ch3[28]), // Templated
                                    .io_aib29           (io_aib_ch3[29]), // Templated
                                    .io_aib3            (io_aib_ch3[3]), // Templated
                                    .io_aib30           (io_aib_ch3[30]), // Templated
                                    .io_aib31           (io_aib_ch3[31]), // Templated
                                    .io_aib32           (io_aib_ch3[32]), // Templated
                                    .io_aib33           (io_aib_ch3[33]), // Templated
                                    .io_aib34           (io_aib_ch3[34]), // Templated
                                    .io_aib35           (io_aib_ch3[35]), // Templated
                                    .io_aib36           (io_aib_ch3[36]), // Templated
                                    .io_aib37           (io_aib_ch3[37]), // Templated
                                    .io_aib38           (io_aib_ch3[38]), // Templated
                                    .io_aib39           (io_aib_ch3[39]), // Templated
                                    .io_aib4            (io_aib_ch3[4]), // Templated
                                    .io_aib40           (io_aib_ch3[40]), // Templated
                                    .io_aib41           (io_aib_ch3[41]), // Templated
                                    .io_aib42           (io_aib_ch3[42]), // Templated
                                    .io_aib43           (io_aib_ch3[43]), // Templated
                                    .io_aib44           (io_aib_ch3[44]), // Templated
                                    .io_aib45           (io_aib_ch3[45]), // Templated
                                    .io_aib46           (io_aib_ch3[46]), // Templated
                                    .io_aib47           (io_aib_ch3[47]), // Templated
                                    .io_aib48           (io_aib_ch3[48]), // Templated
                                    .io_aib49           (io_aib_ch3[49]), // Templated
                                    .io_aib5            (io_aib_ch3[5]), // Templated
                                    .io_aib50           (io_aib_ch3[50]), // Templated
                                    .io_aib51           (io_aib_ch3[51]), // Templated
                                    .io_aib52           (io_aib_ch3[52]), // Templated
                                    .io_aib53           (io_aib_ch3[53]), // Templated
                                    .io_aib54           (io_aib_ch3[54]), // Templated
                                    .io_aib55           (io_aib_ch3[55]), // Templated
                                    .io_aib56           (io_aib_ch3[56]), // Templated
                                    .io_aib57           (io_aib_ch3[57]), // Templated
                                    .io_aib58           (io_aib_ch3[58]), // Templated
                                    .io_aib59           (io_aib_ch3[59]), // Templated
                                    .io_aib6            (io_aib_ch3[6]), // Templated
                                    .io_aib60           (io_aib_ch3[60]), // Templated
                                    .io_aib61           (io_aib_ch3[61]), // Templated
                                    .io_aib62           (io_aib_ch3[62]), // Templated
                                    .io_aib63           (io_aib_ch3[63]), // Templated
                                    .io_aib64           (io_aib_ch3[64]), // Templated
                                    .io_aib65           (io_aib_ch3[65]), // Templated
                                    .io_aib66           (io_aib_ch3[66]), // Templated
                                    .io_aib67           (io_aib_ch3[67]), // Templated
                                    .io_aib68           (io_aib_ch3[68]), // Templated
                                    .io_aib69           (io_aib_ch3[69]), // Templated
                                    .io_aib7            (io_aib_ch3[7]), // Templated
                                    .io_aib70           (io_aib_ch3[70]), // Templated
                                    .io_aib71           (io_aib_ch3[71]), // Templated
                                    .io_aib72           (io_aib_ch3[72]), // Templated
                                    .io_aib73           (io_aib_ch3[73]), // Templated
                                    .io_aib74           (io_aib_ch3[74]), // Templated
                                    .io_aib75           (io_aib_ch3[75]), // Templated
                                    .io_aib76           (io_aib_ch3[76]), // Templated
                                    .io_aib77           (io_aib_ch3[77]), // Templated
                                    .io_aib78           (io_aib_ch3[78]), // Templated
                                    .io_aib79           (io_aib_ch3[79]), // Templated
                                    .io_aib8            (io_aib_ch3[8]), // Templated
                                    .io_aib80           (io_aib_ch3[80]), // Templated
                                    .io_aib81           (io_aib_ch3[81]), // Templated
                                    .io_aib82           (io_aib_ch3[82]), // Templated
                                    .io_aib83           (io_aib_ch3[83]), // Templated
                                    .io_aib84           (io_aib_ch3[84]), // Templated
                                    .io_aib85           (io_aib_ch3[85]), // Templated
                                    .io_aib86           (io_aib_ch3[86]), // Templated
                                    .io_aib87           (io_aib_ch3[87]), // Templated
                                    .io_aib88           (io_aib_ch3[88]), // Templated
                                    .io_aib89           (io_aib_ch3[89]), // Templated
                                    .io_aib9            (io_aib_ch3[9]), // Templated
                                    .io_aib90           (io_aib_ch3[90]), // Templated
                                    .io_aib91           (io_aib_ch3[91]), // Templated
                                    .io_aib92           (io_aib_ch3[92]), // Templated
                                    .io_aib93           (io_aib_ch3[93]), // Templated
                                    .io_aib94           (io_aib_ch3[94]), // Templated
                                    .io_aib95           (io_aib_ch3[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[2]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB3_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[2]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[2]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch2[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch2[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[2]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[2]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch2[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[4]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch4[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[4]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[3]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[3]), // Templated
                                    .i_osc_clk          (aib_osc_clk[2]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[259:195]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[159:120]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[3]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[3]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[311:234]),
                                    .o_tx_elane_data    (o_tx_elane_data[311:234]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[3]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[3][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[2]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[2]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[2]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[2]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[2]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[2]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[2]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[2]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[2]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[2]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[4]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[2]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[2]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[4]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[4]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[4]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[4]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[4]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[4]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[4]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[4]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch4[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_4 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[4]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[4]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[4]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch4[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[4]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[4]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[4]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch4[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch4[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[4]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[4]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch4[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[4]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[304:244]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[4]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[4]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[199:160]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[4]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[4]),
                                    .ms_sideband        (ms_sideband[404:324]),
                                    .sl_sideband        (sl_sideband[364:292]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[4]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[4]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[4]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[4]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[4]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[4][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[4][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[4]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[4]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[4]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[4]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[4]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[4]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[4]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[4]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[4]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[4]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[4]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[4]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[4]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[4]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[4]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[4]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[4]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[4]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[4]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[4]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[4]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch4[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch4[0]), // Templated
                                    .io_aib1            (io_aib_ch4[1]), // Templated
                                    .io_aib10           (io_aib_ch4[10]), // Templated
                                    .io_aib11           (io_aib_ch4[11]), // Templated
                                    .io_aib12           (io_aib_ch4[12]), // Templated
                                    .io_aib13           (io_aib_ch4[13]), // Templated
                                    .io_aib14           (io_aib_ch4[14]), // Templated
                                    .io_aib15           (io_aib_ch4[15]), // Templated
                                    .io_aib16           (io_aib_ch4[16]), // Templated
                                    .io_aib17           (io_aib_ch4[17]), // Templated
                                    .io_aib18           (io_aib_ch4[18]), // Templated
                                    .io_aib19           (io_aib_ch4[19]), // Templated
                                    .io_aib2            (io_aib_ch4[2]), // Templated
                                    .io_aib20           (io_aib_ch4[20]), // Templated
                                    .io_aib21           (io_aib_ch4[21]), // Templated
                                    .io_aib22           (io_aib_ch4[22]), // Templated
                                    .io_aib23           (io_aib_ch4[23]), // Templated
                                    .io_aib24           (io_aib_ch4[24]), // Templated
                                    .io_aib25           (io_aib_ch4[25]), // Templated
                                    .io_aib26           (io_aib_ch4[26]), // Templated
                                    .io_aib27           (io_aib_ch4[27]), // Templated
                                    .io_aib28           (io_aib_ch4[28]), // Templated
                                    .io_aib29           (io_aib_ch4[29]), // Templated
                                    .io_aib3            (io_aib_ch4[3]), // Templated
                                    .io_aib30           (io_aib_ch4[30]), // Templated
                                    .io_aib31           (io_aib_ch4[31]), // Templated
                                    .io_aib32           (io_aib_ch4[32]), // Templated
                                    .io_aib33           (io_aib_ch4[33]), // Templated
                                    .io_aib34           (io_aib_ch4[34]), // Templated
                                    .io_aib35           (io_aib_ch4[35]), // Templated
                                    .io_aib36           (io_aib_ch4[36]), // Templated
                                    .io_aib37           (io_aib_ch4[37]), // Templated
                                    .io_aib38           (io_aib_ch4[38]), // Templated
                                    .io_aib39           (io_aib_ch4[39]), // Templated
                                    .io_aib4            (io_aib_ch4[4]), // Templated
                                    .io_aib40           (io_aib_ch4[40]), // Templated
                                    .io_aib41           (io_aib_ch4[41]), // Templated
                                    .io_aib42           (io_aib_ch4[42]), // Templated
                                    .io_aib43           (io_aib_ch4[43]), // Templated
                                    .io_aib44           (io_aib_ch4[44]), // Templated
                                    .io_aib45           (io_aib_ch4[45]), // Templated
                                    .io_aib46           (io_aib_ch4[46]), // Templated
                                    .io_aib47           (io_aib_ch4[47]), // Templated
                                    .io_aib48           (io_aib_ch4[48]), // Templated
                                    .io_aib49           (io_aib_ch4[49]), // Templated
                                    .io_aib5            (io_aib_ch4[5]), // Templated
                                    .io_aib50           (io_aib_ch4[50]), // Templated
                                    .io_aib51           (io_aib_ch4[51]), // Templated
                                    .io_aib52           (io_aib_ch4[52]), // Templated
                                    .io_aib53           (io_aib_ch4[53]), // Templated
                                    .io_aib54           (io_aib_ch4[54]), // Templated
                                    .io_aib55           (io_aib_ch4[55]), // Templated
                                    .io_aib56           (io_aib_ch4[56]), // Templated
                                    .io_aib57           (io_aib_ch4[57]), // Templated
                                    .io_aib58           (io_aib_ch4[58]), // Templated
                                    .io_aib59           (io_aib_ch4[59]), // Templated
                                    .io_aib6            (io_aib_ch4[6]), // Templated
                                    .io_aib60           (io_aib_ch4[60]), // Templated
                                    .io_aib61           (io_aib_ch4[61]), // Templated
                                    .io_aib62           (io_aib_ch4[62]), // Templated
                                    .io_aib63           (io_aib_ch4[63]), // Templated
                                    .io_aib64           (io_aib_ch4[64]), // Templated
                                    .io_aib65           (io_aib_ch4[65]), // Templated
                                    .io_aib66           (io_aib_ch4[66]), // Templated
                                    .io_aib67           (io_aib_ch4[67]), // Templated
                                    .io_aib68           (io_aib_ch4[68]), // Templated
                                    .io_aib69           (io_aib_ch4[69]), // Templated
                                    .io_aib7            (io_aib_ch4[7]), // Templated
                                    .io_aib70           (io_aib_ch4[70]), // Templated
                                    .io_aib71           (io_aib_ch4[71]), // Templated
                                    .io_aib72           (io_aib_ch4[72]), // Templated
                                    .io_aib73           (io_aib_ch4[73]), // Templated
                                    .io_aib74           (io_aib_ch4[74]), // Templated
                                    .io_aib75           (io_aib_ch4[75]), // Templated
                                    .io_aib76           (io_aib_ch4[76]), // Templated
                                    .io_aib77           (io_aib_ch4[77]), // Templated
                                    .io_aib78           (io_aib_ch4[78]), // Templated
                                    .io_aib79           (io_aib_ch4[79]), // Templated
                                    .io_aib8            (io_aib_ch4[8]), // Templated
                                    .io_aib80           (io_aib_ch4[80]), // Templated
                                    .io_aib81           (io_aib_ch4[81]), // Templated
                                    .io_aib82           (io_aib_ch4[82]), // Templated
                                    .io_aib83           (io_aib_ch4[83]), // Templated
                                    .io_aib84           (io_aib_ch4[84]), // Templated
                                    .io_aib85           (io_aib_ch4[85]), // Templated
                                    .io_aib86           (io_aib_ch4[86]), // Templated
                                    .io_aib87           (io_aib_ch4[87]), // Templated
                                    .io_aib88           (io_aib_ch4[88]), // Templated
                                    .io_aib89           (io_aib_ch4[89]), // Templated
                                    .io_aib9            (io_aib_ch4[9]), // Templated
                                    .io_aib90           (io_aib_ch4[90]), // Templated
                                    .io_aib91           (io_aib_ch4[91]), // Templated
                                    .io_aib92           (io_aib_ch4[92]), // Templated
                                    .io_aib93           (io_aib_ch4[93]), // Templated
                                    .io_aib94           (io_aib_ch4[94]), // Templated
                                    .io_aib95           (io_aib_ch4[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[3]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB4_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[3]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[3]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch3[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch3[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[3]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[3]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch3[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[5]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch5[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[5]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[4]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[4]), // Templated
                                    .i_osc_clk          (aib_osc_clk[3]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[324:260]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[199:160]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[4]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[4]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[389:312]),
                                    .o_tx_elane_data    (o_tx_elane_data[389:312]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[4]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[4][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[3]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[3]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[3]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[3]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[3]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[3]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[3]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[3]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[3]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[3]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[5]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[3]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[3]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[5]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[5]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[5]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[5]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[5]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[5]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[5]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[5]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch5[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_5 (
                                    .i_adpt_cfg_rdatavld(chnl_aib_cfg_avmm_rdatavld[0]), 
                                    .i_adpt_cfg_rdata   (chnl_aib_cfg_avmm_rdata_0[31:0]),
                                    .i_adpt_cfg_waitreq (chnl_aib_cfg_avmm_waitreq[0]), 
                                    .i_jtag_last_bs_chain_in(chnl_aib_jtag_last_bs_chain_out[0]),
                                    .i_red_idataselb_in_chain1(chnl_aib_red_idataselb_chain1[0]), 
                                    .i_red_idataselb_in_chain2(chnl_aib_red_idataselb_chain2[0]), 
                                    .i_red_shift_en_in_chain1(chnl_aib_red_shift_en_chain1[0]), 
                                    .i_red_shift_en_in_chain2(chnl_aib_red_shift_en_chain2[0]), 
                                    .i_txen_in_chain1   (chnl_aib_txen_chain1[0]), 
                                    .i_txen_in_chain2   (chnl_aib_txen_chain2[0]), 
                                    .i_directout_data_chain1_in(chnl_aib_directout_data_chain1_out[0]), 
                                    .i_directout_data_chain2_in(chnl_aib_directout_data_chain2_out[0]), 
                                    .i_aibdftdll2adjch  (chnl_aib_dftdll2adjch_0[12:0]), 
                                    /*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[5]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[5]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[5]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch5[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[5]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[5]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[5]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch5[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch5[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[5]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[5]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch5[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[5]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[365:305]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[5]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[5]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[239:200]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[5]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[5]),
                                    .ms_sideband        (ms_sideband[485:405]),
                                    .sl_sideband        (sl_sideband[437:365]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[5]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[5]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[5]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[5]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[5]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[5][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[5][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[5]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[5]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[5]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[5]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[5]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[5]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[5]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[5]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[5]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[5]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[5]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[5]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[5]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[5]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[5]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[5]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[5]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[5]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[5]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[5]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[5]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch5[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch5[0]), // Templated
                                    .io_aib1            (io_aib_ch5[1]), // Templated
                                    .io_aib10           (io_aib_ch5[10]), // Templated
                                    .io_aib11           (io_aib_ch5[11]), // Templated
                                    .io_aib12           (io_aib_ch5[12]), // Templated
                                    .io_aib13           (io_aib_ch5[13]), // Templated
                                    .io_aib14           (io_aib_ch5[14]), // Templated
                                    .io_aib15           (io_aib_ch5[15]), // Templated
                                    .io_aib16           (io_aib_ch5[16]), // Templated
                                    .io_aib17           (io_aib_ch5[17]), // Templated
                                    .io_aib18           (io_aib_ch5[18]), // Templated
                                    .io_aib19           (io_aib_ch5[19]), // Templated
                                    .io_aib2            (io_aib_ch5[2]), // Templated
                                    .io_aib20           (io_aib_ch5[20]), // Templated
                                    .io_aib21           (io_aib_ch5[21]), // Templated
                                    .io_aib22           (io_aib_ch5[22]), // Templated
                                    .io_aib23           (io_aib_ch5[23]), // Templated
                                    .io_aib24           (io_aib_ch5[24]), // Templated
                                    .io_aib25           (io_aib_ch5[25]), // Templated
                                    .io_aib26           (io_aib_ch5[26]), // Templated
                                    .io_aib27           (io_aib_ch5[27]), // Templated
                                    .io_aib28           (io_aib_ch5[28]), // Templated
                                    .io_aib29           (io_aib_ch5[29]), // Templated
                                    .io_aib3            (io_aib_ch5[3]), // Templated
                                    .io_aib30           (io_aib_ch5[30]), // Templated
                                    .io_aib31           (io_aib_ch5[31]), // Templated
                                    .io_aib32           (io_aib_ch5[32]), // Templated
                                    .io_aib33           (io_aib_ch5[33]), // Templated
                                    .io_aib34           (io_aib_ch5[34]), // Templated
                                    .io_aib35           (io_aib_ch5[35]), // Templated
                                    .io_aib36           (io_aib_ch5[36]), // Templated
                                    .io_aib37           (io_aib_ch5[37]), // Templated
                                    .io_aib38           (io_aib_ch5[38]), // Templated
                                    .io_aib39           (io_aib_ch5[39]), // Templated
                                    .io_aib4            (io_aib_ch5[4]), // Templated
                                    .io_aib40           (io_aib_ch5[40]), // Templated
                                    .io_aib41           (io_aib_ch5[41]), // Templated
                                    .io_aib42           (io_aib_ch5[42]), // Templated
                                    .io_aib43           (io_aib_ch5[43]), // Templated
                                    .io_aib44           (io_aib_ch5[44]), // Templated
                                    .io_aib45           (io_aib_ch5[45]), // Templated
                                    .io_aib46           (io_aib_ch5[46]), // Templated
                                    .io_aib47           (io_aib_ch5[47]), // Templated
                                    .io_aib48           (io_aib_ch5[48]), // Templated
                                    .io_aib49           (io_aib_ch5[49]), // Templated
                                    .io_aib5            (io_aib_ch5[5]), // Templated
                                    .io_aib50           (io_aib_ch5[50]), // Templated
                                    .io_aib51           (io_aib_ch5[51]), // Templated
                                    .io_aib52           (io_aib_ch5[52]), // Templated
                                    .io_aib53           (io_aib_ch5[53]), // Templated
                                    .io_aib54           (io_aib_ch5[54]), // Templated
                                    .io_aib55           (io_aib_ch5[55]), // Templated
                                    .io_aib56           (io_aib_ch5[56]), // Templated
                                    .io_aib57           (io_aib_ch5[57]), // Templated
                                    .io_aib58           (io_aib_ch5[58]), // Templated
                                    .io_aib59           (io_aib_ch5[59]), // Templated
                                    .io_aib6            (io_aib_ch5[6]), // Templated
                                    .io_aib60           (io_aib_ch5[60]), // Templated
                                    .io_aib61           (io_aib_ch5[61]), // Templated
                                    .io_aib62           (io_aib_ch5[62]), // Templated
                                    .io_aib63           (io_aib_ch5[63]), // Templated
                                    .io_aib64           (io_aib_ch5[64]), // Templated
                                    .io_aib65           (io_aib_ch5[65]), // Templated
                                    .io_aib66           (io_aib_ch5[66]), // Templated
                                    .io_aib67           (io_aib_ch5[67]), // Templated
                                    .io_aib68           (io_aib_ch5[68]), // Templated
                                    .io_aib69           (io_aib_ch5[69]), // Templated
                                    .io_aib7            (io_aib_ch5[7]), // Templated
                                    .io_aib70           (io_aib_ch5[70]), // Templated
                                    .io_aib71           (io_aib_ch5[71]), // Templated
                                    .io_aib72           (io_aib_ch5[72]), // Templated
                                    .io_aib73           (io_aib_ch5[73]), // Templated
                                    .io_aib74           (io_aib_ch5[74]), // Templated
                                    .io_aib75           (io_aib_ch5[75]), // Templated
                                    .io_aib76           (io_aib_ch5[76]), // Templated
                                    .io_aib77           (io_aib_ch5[77]), // Templated
                                    .io_aib78           (io_aib_ch5[78]), // Templated
                                    .io_aib79           (io_aib_ch5[79]), // Templated
                                    .io_aib8            (io_aib_ch5[8]), // Templated
                                    .io_aib80           (io_aib_ch5[80]), // Templated
                                    .io_aib81           (io_aib_ch5[81]), // Templated
                                    .io_aib82           (io_aib_ch5[82]), // Templated
                                    .io_aib83           (io_aib_ch5[83]), // Templated
                                    .io_aib84           (io_aib_ch5[84]), // Templated
                                    .io_aib85           (io_aib_ch5[85]), // Templated
                                    .io_aib86           (io_aib_ch5[86]), // Templated
                                    .io_aib87           (io_aib_ch5[87]), // Templated
                                    .io_aib88           (io_aib_ch5[88]), // Templated
                                    .io_aib89           (io_aib_ch5[89]), // Templated
                                    .io_aib9            (io_aib_ch5[9]), // Templated
                                    .io_aib90           (io_aib_ch5[90]), // Templated
                                    .io_aib91           (io_aib_ch5[91]), // Templated
                                    .io_aib92           (io_aib_ch5[92]), // Templated
                                    .io_aib93           (io_aib_ch5[93]), // Templated
                                    .io_aib94           (io_aib_ch5[94]), // Templated
                                    .io_aib95           (io_aib_ch5[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[4]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB5_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[4]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[4]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch4[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch4[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[4]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[4]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch4[31:0]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[5]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[5]), // Templated
                                    .i_osc_clk          (aib_osc_clk[4]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[389:325]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[239:200]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[5]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[5]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[467:390]),
                                    .o_tx_elane_data    (o_tx_elane_data[467:390]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[5]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[5][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[4]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[4]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[4]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[4]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[4]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[4]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[4]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[4]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[4]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[4]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[4]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[4])); // Templated

    // Feedthrough block between two 6 AIB channel bundles
    /*c3routing_chnl_aib AUTO_TEMPLATE "u_c3routing_chnl_\(.*\)"
     (
     .i_clk         (aib_cfg_avmm_clk[@"(+ (* 6 @) 5)"]),
     .i_rst_n       (aib_cfg_avmm_rst_n[@"(+ (* 6 @) 5)"]),
     .i_addr        (aib_cfg_avmm_addr_ch@"(number-to-string(+ (* 6 @) 5))"[16:0]),
     .i_byte_en     (aib_cfg_avmm_byte_en_ch@"(number-to-string(+ (* 6 @) 5))"[3:0]),
     .i_read        (aib_cfg_avmm_read[@"(+ (* 6 @) 5)"]),
     .i_write       (aib_cfg_avmm_write[@"(+ (* 6 @) 5)"]),
     .i_wdata       (aib_cfg_avmm_wdata_ch@"(number-to-string(+ (* 6 @) 5))"[31:0]),
     
     .i_adpt_hard_rst_n(aib_adpt_chnl_hard_rst_n[@"(+ (* 6 @) 5)"]),
     .i_vccl        (aib_por_vccl[@"(+ (* 6 @) 5)"]),
     .i_vcchssi     (aib_por_vcchssi[@"(+ (* 6 @) 5)"]),
              
     .o_rdata       (chnl_aib_cfg_avmm_rdata_@[31:0]),
     .o_rdatavalid  (chnl_aib_cfg_avmm_rdatavld[@]),
     .o_waitreq     (chnl_aib_cfg_avmm_waitreq[@]),
     .o_aibdftdll2adjch (chnl_aib_dftdll2adjch_@[12:0]),
     .o_\(.*\)chain\(.*\) (chnl_aib_\1chain\2[@]),
     .i_osc_clk        (aib_osc_clk[@"(+ (* 6 @) 5)"]),
     
     .o_clk         (chnl_aib_cfg_avmm_clk[@]),
     .o_rst_n       (chnl_aib_cfg_avmm_rst_n[@]),
     .o_addr        (chnl_aib_cfg_avmm_addr_@[16:0]),
     .o_byte_en     (chnl_aib_cfg_avmm_byte_en_@[3:0]),
     .o_write       (chnl_aib_cfg_avmm_write[@]),
     .o_read        (chnl_aib_cfg_avmm_read[@]),
     .o_wdata       (chnl_aib_cfg_avmm_wdata_@[31:0]),
     .i_rdata       (aib_cfg_avmm_rdata_ch@"(number-to-string(+ (* 6 @) 6))"[31:0]),
     .i_rdatavalid  (aib_cfg_avmm_rdatavld[@"(+ (* 6 @) 6)"]),
     .i_waitreq     (aib_cfg_avmm_waitreq[@"(+ (* 6 @) 6)"]),
     .o_adpt_hard_rst_n (chnl_aib_adpt_hard_rst_n[@]),
     
     .i_red_\(.*\)_chain\(.*\) (aib_red_\1_chain\2[@"(+ (* 6 @) 6)"]),
     .i_txen_chain\(.*\)       (aib_txen_chain\1[@"(+ (* 6 @) 6)"]),

     .o_osc_clk         (chnl_aib_osc_clk[@]),                       
     .i_aibdftdll2adjch (aib_dftdll2adjch_ch@"(number-to-string(+ (* 6 @) 6))"[12:0]),
     .o_vccl            (chnl_aib_vccl[@]),
     .o_vcchssi         (chnl_aib_vcchssi[@]),
     .i_jtag_last_bs_chain_in (aib_jtag_last_bs_chain_out[@"(+ (* 6 @) 6)"]),
     .o_jtag_last_bs_chain_out(chnl_aib_jtag_last_bs_chain_out[@]),
     .i_directout_data_chain\(.*\)_in(aib_directout_data_chain\1_out[@"(+ (* 6 @) 6)"]),
     .o_directout_data_chain\(.*\)_out(chnl_aib_directout_data_chain\1_out[@]),
     
     .i_jtag_\(.*\)_in  (aib_jtag_\1_out[@"(+ (* 6 @) 5)"]),
     .o_jtag_\(.*\)_out (chnl_jtag_\1_out[@]),
     );
     */
      
    c3routing_chnl_aib u_c3routing_chnl_0 (/*AUTOINST*/
                                           // Outputs
                                           .o_rdata             (chnl_aib_cfg_avmm_rdata_0[31:0]), // Templated
                                           .o_rdatavalid        (chnl_aib_cfg_avmm_rdatavld[0]), // Templated
                                           .o_waitreq           (chnl_aib_cfg_avmm_waitreq[0]), // Templated
                                           .o_clk               (chnl_aib_cfg_avmm_clk[0]), // Templated
                                           .o_rst_n             (chnl_aib_cfg_avmm_rst_n[0]), // Templated
                                           .o_addr              (chnl_aib_cfg_avmm_addr_0[16:0]), // Templated
                                           .o_byte_en           (chnl_aib_cfg_avmm_byte_en_0[3:0]), // Templated
                                           .o_read              (chnl_aib_cfg_avmm_read[0]), // Templated
                                           .o_write             (chnl_aib_cfg_avmm_write[0]), // Templated
                                           .o_wdata             (chnl_aib_cfg_avmm_wdata_0[31:0]), // Templated
                                           .o_adpt_hard_rst_n   (chnl_aib_adpt_hard_rst_n[0]), // Templated
                                           .o_red_idataselb_chain1(chnl_aib_red_idataselb_chain1[0]), // Templated
                                           .o_red_idataselb_chain2(chnl_aib_red_idataselb_chain2[0]), // Templated
                                           .o_red_shift_en_chain1(chnl_aib_red_shift_en_chain1[0]), // Templated
                                           .o_red_shift_en_chain2(chnl_aib_red_shift_en_chain2[0]), // Templated
                                           .o_txen_chain1       (chnl_aib_txen_chain1[0]), // Templated
                                           .o_txen_chain2       (chnl_aib_txen_chain2[0]), // Templated
                                           .o_osc_clk           (chnl_aib_osc_clk[0]), // Templated
                                           .o_aibdftdll2adjch   (chnl_aib_dftdll2adjch_0[12:0]), // Templated
                                           .o_vccl              (chnl_aib_vccl[0]), // Templated
                                           .o_vcchssi           (chnl_aib_vcchssi[0]), // Templated
                                           .o_jtag_last_bs_chain_out(chnl_aib_jtag_last_bs_chain_out[0]), // Templated
                                           .o_directout_data_chain1_out(chnl_aib_directout_data_chain1_out[0]), // Templated
                                           .o_directout_data_chain2_out(chnl_aib_directout_data_chain2_out[0]), // Templated
                                           .o_jtag_bs_chain_out (chnl_aib_jtag_bs_chain_out[0]), // Templated
                                           .o_jtag_bs_scanen_out(chnl_jtag_bs_scanen_out[0]), // Templated
                                           .o_jtag_clkdr_out    (chnl_jtag_clkdr_out[0]), // Templated
                                           .o_jtag_clksel_out   (chnl_jtag_clksel_out[0]), // Templated
                                           .o_jtag_intest_out   (chnl_jtag_intest_out[0]), // Templated
                                           .o_jtag_mode_out     (chnl_jtag_mode_out[0]), // Templated
                                           .o_jtag_rstb_en_out  (chnl_jtag_rstb_en_out[0]), // Templated
                                           .o_jtag_rstb_out     (chnl_jtag_rstb_out[0]), // Templated
                                           .o_jtag_weakpdn_out  (chnl_jtag_weakpdn_out[0]), // Templated
                                           .o_jtag_weakpu_out   (chnl_jtag_weakpu_out[0]), // Templated
                                           // Inputs
                                           .i_clk               (aib_cfg_avmm_clk[5]), // Templated
                                           .i_rst_n             (aib_cfg_avmm_rst_n[5]), // Templated
                                           .i_addr              (aib_cfg_avmm_addr_ch5[16:0]), // Templated
                                           .i_byte_en           (aib_cfg_avmm_byte_en_ch5[3:0]), // Templated
                                           .i_read              (aib_cfg_avmm_read[5]), // Templated
                                           .i_write             (aib_cfg_avmm_write[5]), // Templated
                                           .i_wdata             (aib_cfg_avmm_wdata_ch5[31:0]), // Templated
                                           .i_adpt_hard_rst_n   (aib_adpt_chnl_hard_rst_n[5]), // Templated
                                           .i_red_idataselb_chain1(aib_red_idataselb_chain1[6]), // Templated
                                           .i_red_idataselb_chain2(aib_red_idataselb_chain2[6]), // Templated
                                           .i_red_shift_en_chain1(aib_red_shift_en_chain1[6]), // Templated
                                           .i_red_shift_en_chain2(aib_red_shift_en_chain2[6]), // Templated
                                           .i_txen_chain1       (aib_txen_chain1[6]), // Templated
                                           .i_txen_chain2       (aib_txen_chain2[6]), // Templated
                                           .i_osc_clk           (aib_osc_clk[5]), // Templated
                                           .i_aibdftdll2adjch   (aib_dftdll2adjch_ch6[12:0]), // Templated
                                           .i_vccl              (aib_por_vccl[5]), // Templated
                                           .i_vcchssi           (aib_por_vcchssi[5]), // Templated
                                           .i_rdata             (aib_cfg_avmm_rdata_ch6[31:0]), // Templated
                                           .i_rdatavalid        (aib_cfg_avmm_rdatavld[6]), // Templated
                                           .i_waitreq           (aib_cfg_avmm_waitreq[6]), // Templated
                                           .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[6]), // Templated
                                           .i_directout_data_chain1_in(aib_directout_data_chain1_out[6]), // Templated
                                           .i_directout_data_chain2_in(aib_directout_data_chain2_out[6]), // Templated
                                           .i_jtag_bs_chain_in  (aib_jtag_bs_chain_out[5]), // Templated
                                           .i_jtag_bs_scanen_in (aib_jtag_bs_scanen_out[5]), // Templated
                                           .i_jtag_clkdr_in     (aib_jtag_clkdr_out[5]), // Templated
                                           .i_jtag_clksel_in    (aib_jtag_clksel_out[5]), // Templated
                                           .i_jtag_intest_in    (aib_jtag_intest_out[5]), // Templated
                                           .i_jtag_mode_in      (aib_jtag_mode_out[5]), // Templated
                                           .i_jtag_rstb_en_in   (aib_jtag_rstb_en_out[5]), // Templated
                                           .i_jtag_rstb_in      (aib_jtag_rstb_out[5]), // Templated
                                           .i_jtag_weakpdn_in   (aib_jtag_weakpdn_out[5]), // Templated
                                           .i_jtag_weakpu_in    (aib_jtag_weakpu_out[5])); // Templated
    
    c3aibadapt_wrap u_c3aibadapt_6 (
                                    .i_osc_clk          (chnl_aib_osc_clk[0]),
                                    .i_cfg_avmm_clk     (chnl_aib_cfg_avmm_clk[0]), 
                                    .i_cfg_avmm_rst_n   (chnl_aib_cfg_avmm_rst_n[0]), 
                                    .i_cfg_avmm_addr    (chnl_aib_cfg_avmm_addr_0[16:0]),
                                    .i_cfg_avmm_byte_en (chnl_aib_cfg_avmm_byte_en_0[3:0]),
                                    .i_cfg_avmm_read    (chnl_aib_cfg_avmm_read[0]), 
                                    .i_cfg_avmm_write   (chnl_aib_cfg_avmm_write[0]),
                                    .i_cfg_avmm_wdata   (chnl_aib_cfg_avmm_wdata_0[31:0]), 
                                    .i_adpt_hard_rst_n  (chnl_aib_adpt_hard_rst_n[0]), 
                                    .i_jtag_rstb_in     (chnl_jtag_rstb_out[0]), 
                                    .i_jtag_rstb_en_in  (chnl_jtag_rstb_en_out[0]),
                                    .i_jtag_clkdr_in    (chnl_jtag_clkdr_out[0]), 
                                    .i_jtag_clksel_in   (chnl_jtag_clksel_out[0]),
                                    .i_jtag_intest_in   (chnl_jtag_intest_out[0]),
                                    .i_jtag_mode_in     (chnl_jtag_mode_out[0]), 
                                    .i_jtag_weakpdn_in  (chnl_jtag_weakpdn_out[0]),
                                    .i_jtag_weakpu_in   (chnl_jtag_weakpu_out[0]),
                                    .i_jtag_bs_scanen_in(chnl_jtag_bs_scanen_out[0]),
                                    .i_jtag_bs_chain_in (chnl_aib_jtag_bs_chain_out[0]),
                                    .i_por_aib_vcchssi  (chnl_aib_vcchssi[0]),
                                    .i_por_aib_vccl     (chnl_aib_vccl[0]), 
                                    /*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[6]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[6]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[6]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch6[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[6]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[6]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[6]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch6[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch6[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[6]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[6]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch6[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[6]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[426:366]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[6]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[6]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[279:240]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[6]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[6]),
                                    .ms_sideband        (ms_sideband[566:486]),
                                    .sl_sideband        (sl_sideband[510:438]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[6]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[6]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[6]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[6]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[6]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[6][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[6][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[6]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[6]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[6]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[6]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[6]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[6]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[6]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[6]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[6]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[6]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[6]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[6]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[6]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[6]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[6]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[6]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[6]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[6]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[6]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[6]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[6]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch6[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch6[0]), // Templated
                                    .io_aib1            (io_aib_ch6[1]), // Templated
                                    .io_aib10           (io_aib_ch6[10]), // Templated
                                    .io_aib11           (io_aib_ch6[11]), // Templated
                                    .io_aib12           (io_aib_ch6[12]), // Templated
                                    .io_aib13           (io_aib_ch6[13]), // Templated
                                    .io_aib14           (io_aib_ch6[14]), // Templated
                                    .io_aib15           (io_aib_ch6[15]), // Templated
                                    .io_aib16           (io_aib_ch6[16]), // Templated
                                    .io_aib17           (io_aib_ch6[17]), // Templated
                                    .io_aib18           (io_aib_ch6[18]), // Templated
                                    .io_aib19           (io_aib_ch6[19]), // Templated
                                    .io_aib2            (io_aib_ch6[2]), // Templated
                                    .io_aib20           (io_aib_ch6[20]), // Templated
                                    .io_aib21           (io_aib_ch6[21]), // Templated
                                    .io_aib22           (io_aib_ch6[22]), // Templated
                                    .io_aib23           (io_aib_ch6[23]), // Templated
                                    .io_aib24           (io_aib_ch6[24]), // Templated
                                    .io_aib25           (io_aib_ch6[25]), // Templated
                                    .io_aib26           (io_aib_ch6[26]), // Templated
                                    .io_aib27           (io_aib_ch6[27]), // Templated
                                    .io_aib28           (io_aib_ch6[28]), // Templated
                                    .io_aib29           (io_aib_ch6[29]), // Templated
                                    .io_aib3            (io_aib_ch6[3]), // Templated
                                    .io_aib30           (io_aib_ch6[30]), // Templated
                                    .io_aib31           (io_aib_ch6[31]), // Templated
                                    .io_aib32           (io_aib_ch6[32]), // Templated
                                    .io_aib33           (io_aib_ch6[33]), // Templated
                                    .io_aib34           (io_aib_ch6[34]), // Templated
                                    .io_aib35           (io_aib_ch6[35]), // Templated
                                    .io_aib36           (io_aib_ch6[36]), // Templated
                                    .io_aib37           (io_aib_ch6[37]), // Templated
                                    .io_aib38           (io_aib_ch6[38]), // Templated
                                    .io_aib39           (io_aib_ch6[39]), // Templated
                                    .io_aib4            (io_aib_ch6[4]), // Templated
                                    .io_aib40           (io_aib_ch6[40]), // Templated
                                    .io_aib41           (io_aib_ch6[41]), // Templated
                                    .io_aib42           (io_aib_ch6[42]), // Templated
                                    .io_aib43           (io_aib_ch6[43]), // Templated
                                    .io_aib44           (io_aib_ch6[44]), // Templated
                                    .io_aib45           (io_aib_ch6[45]), // Templated
                                    .io_aib46           (io_aib_ch6[46]), // Templated
                                    .io_aib47           (io_aib_ch6[47]), // Templated
                                    .io_aib48           (io_aib_ch6[48]), // Templated
                                    .io_aib49           (io_aib_ch6[49]), // Templated
                                    .io_aib5            (io_aib_ch6[5]), // Templated
                                    .io_aib50           (io_aib_ch6[50]), // Templated
                                    .io_aib51           (io_aib_ch6[51]), // Templated
                                    .io_aib52           (io_aib_ch6[52]), // Templated
                                    .io_aib53           (io_aib_ch6[53]), // Templated
                                    .io_aib54           (io_aib_ch6[54]), // Templated
                                    .io_aib55           (io_aib_ch6[55]), // Templated
                                    .io_aib56           (io_aib_ch6[56]), // Templated
                                    .io_aib57           (io_aib_ch6[57]), // Templated
                                    .io_aib58           (io_aib_ch6[58]), // Templated
                                    .io_aib59           (io_aib_ch6[59]), // Templated
                                    .io_aib6            (io_aib_ch6[6]), // Templated
                                    .io_aib60           (io_aib_ch6[60]), // Templated
                                    .io_aib61           (io_aib_ch6[61]), // Templated
                                    .io_aib62           (io_aib_ch6[62]), // Templated
                                    .io_aib63           (io_aib_ch6[63]), // Templated
                                    .io_aib64           (io_aib_ch6[64]), // Templated
                                    .io_aib65           (io_aib_ch6[65]), // Templated
                                    .io_aib66           (io_aib_ch6[66]), // Templated
                                    .io_aib67           (io_aib_ch6[67]), // Templated
                                    .io_aib68           (io_aib_ch6[68]), // Templated
                                    .io_aib69           (io_aib_ch6[69]), // Templated
                                    .io_aib7            (io_aib_ch6[7]), // Templated
                                    .io_aib70           (io_aib_ch6[70]), // Templated
                                    .io_aib71           (io_aib_ch6[71]), // Templated
                                    .io_aib72           (io_aib_ch6[72]), // Templated
                                    .io_aib73           (io_aib_ch6[73]), // Templated
                                    .io_aib74           (io_aib_ch6[74]), // Templated
                                    .io_aib75           (io_aib_ch6[75]), // Templated
                                    .io_aib76           (io_aib_ch6[76]), // Templated
                                    .io_aib77           (io_aib_ch6[77]), // Templated
                                    .io_aib78           (io_aib_ch6[78]), // Templated
                                    .io_aib79           (io_aib_ch6[79]), // Templated
                                    .io_aib8            (io_aib_ch6[8]), // Templated
                                    .io_aib80           (io_aib_ch6[80]), // Templated
                                    .io_aib81           (io_aib_ch6[81]), // Templated
                                    .io_aib82           (io_aib_ch6[82]), // Templated
                                    .io_aib83           (io_aib_ch6[83]), // Templated
                                    .io_aib84           (io_aib_ch6[84]), // Templated
                                    .io_aib85           (io_aib_ch6[85]), // Templated
                                    .io_aib86           (io_aib_ch6[86]), // Templated
                                    .io_aib87           (io_aib_ch6[87]), // Templated
                                    .io_aib88           (io_aib_ch6[88]), // Templated
                                    .io_aib89           (io_aib_ch6[89]), // Templated
                                    .io_aib9            (io_aib_ch6[9]), // Templated
                                    .io_aib90           (io_aib_ch6[90]), // Templated
                                    .io_aib91           (io_aib_ch6[91]), // Templated
                                    .io_aib92           (io_aib_ch6[92]), // Templated
                                    .io_aib93           (io_aib_ch6[93]), // Templated
                                    .io_aib94           (io_aib_ch6[94]), // Templated
                                    .io_aib95           (io_aib_ch6[95]), // Templated
                                    // Inputs
                                    .i_channel_id       (C3_AVMM_AIB6_ID), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[7]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch7[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[7]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[6]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[6]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[454:390]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[279:240]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[6]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[6]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[545:468]),
                                    .o_tx_elane_data    (o_tx_elane_data[545:468]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[6]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[6][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[7]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[7]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[7]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[7]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[7]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[7]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[7]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[7]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[7]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch7[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_7 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[7]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[7]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[7]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch7[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[7]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[7]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[7]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch7[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch7[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[7]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[7]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch7[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[7]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[487:427]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[7]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[7]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[319:280]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[7]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[7]),
                                    .ms_sideband        (ms_sideband[647:567]),
                                    .sl_sideband        (sl_sideband[583:511]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[7]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[7]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[7]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[7]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[7]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[7][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[7][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[7]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[7]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[7]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[7]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[7]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[7]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[7]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[7]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[7]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[7]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[7]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[7]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[7]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[7]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[7]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[7]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[7]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[7]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[7]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[7]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[7]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch7[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch7[0]), // Templated
                                    .io_aib1            (io_aib_ch7[1]), // Templated
                                    .io_aib10           (io_aib_ch7[10]), // Templated
                                    .io_aib11           (io_aib_ch7[11]), // Templated
                                    .io_aib12           (io_aib_ch7[12]), // Templated
                                    .io_aib13           (io_aib_ch7[13]), // Templated
                                    .io_aib14           (io_aib_ch7[14]), // Templated
                                    .io_aib15           (io_aib_ch7[15]), // Templated
                                    .io_aib16           (io_aib_ch7[16]), // Templated
                                    .io_aib17           (io_aib_ch7[17]), // Templated
                                    .io_aib18           (io_aib_ch7[18]), // Templated
                                    .io_aib19           (io_aib_ch7[19]), // Templated
                                    .io_aib2            (io_aib_ch7[2]), // Templated
                                    .io_aib20           (io_aib_ch7[20]), // Templated
                                    .io_aib21           (io_aib_ch7[21]), // Templated
                                    .io_aib22           (io_aib_ch7[22]), // Templated
                                    .io_aib23           (io_aib_ch7[23]), // Templated
                                    .io_aib24           (io_aib_ch7[24]), // Templated
                                    .io_aib25           (io_aib_ch7[25]), // Templated
                                    .io_aib26           (io_aib_ch7[26]), // Templated
                                    .io_aib27           (io_aib_ch7[27]), // Templated
                                    .io_aib28           (io_aib_ch7[28]), // Templated
                                    .io_aib29           (io_aib_ch7[29]), // Templated
                                    .io_aib3            (io_aib_ch7[3]), // Templated
                                    .io_aib30           (io_aib_ch7[30]), // Templated
                                    .io_aib31           (io_aib_ch7[31]), // Templated
                                    .io_aib32           (io_aib_ch7[32]), // Templated
                                    .io_aib33           (io_aib_ch7[33]), // Templated
                                    .io_aib34           (io_aib_ch7[34]), // Templated
                                    .io_aib35           (io_aib_ch7[35]), // Templated
                                    .io_aib36           (io_aib_ch7[36]), // Templated
                                    .io_aib37           (io_aib_ch7[37]), // Templated
                                    .io_aib38           (io_aib_ch7[38]), // Templated
                                    .io_aib39           (io_aib_ch7[39]), // Templated
                                    .io_aib4            (io_aib_ch7[4]), // Templated
                                    .io_aib40           (io_aib_ch7[40]), // Templated
                                    .io_aib41           (io_aib_ch7[41]), // Templated
                                    .io_aib42           (io_aib_ch7[42]), // Templated
                                    .io_aib43           (io_aib_ch7[43]), // Templated
                                    .io_aib44           (io_aib_ch7[44]), // Templated
                                    .io_aib45           (io_aib_ch7[45]), // Templated
                                    .io_aib46           (io_aib_ch7[46]), // Templated
                                    .io_aib47           (io_aib_ch7[47]), // Templated
                                    .io_aib48           (io_aib_ch7[48]), // Templated
                                    .io_aib49           (io_aib_ch7[49]), // Templated
                                    .io_aib5            (io_aib_ch7[5]), // Templated
                                    .io_aib50           (io_aib_ch7[50]), // Templated
                                    .io_aib51           (io_aib_ch7[51]), // Templated
                                    .io_aib52           (io_aib_ch7[52]), // Templated
                                    .io_aib53           (io_aib_ch7[53]), // Templated
                                    .io_aib54           (io_aib_ch7[54]), // Templated
                                    .io_aib55           (io_aib_ch7[55]), // Templated
                                    .io_aib56           (io_aib_ch7[56]), // Templated
                                    .io_aib57           (io_aib_ch7[57]), // Templated
                                    .io_aib58           (io_aib_ch7[58]), // Templated
                                    .io_aib59           (io_aib_ch7[59]), // Templated
                                    .io_aib6            (io_aib_ch7[6]), // Templated
                                    .io_aib60           (io_aib_ch7[60]), // Templated
                                    .io_aib61           (io_aib_ch7[61]), // Templated
                                    .io_aib62           (io_aib_ch7[62]), // Templated
                                    .io_aib63           (io_aib_ch7[63]), // Templated
                                    .io_aib64           (io_aib_ch7[64]), // Templated
                                    .io_aib65           (io_aib_ch7[65]), // Templated
                                    .io_aib66           (io_aib_ch7[66]), // Templated
                                    .io_aib67           (io_aib_ch7[67]), // Templated
                                    .io_aib68           (io_aib_ch7[68]), // Templated
                                    .io_aib69           (io_aib_ch7[69]), // Templated
                                    .io_aib7            (io_aib_ch7[7]), // Templated
                                    .io_aib70           (io_aib_ch7[70]), // Templated
                                    .io_aib71           (io_aib_ch7[71]), // Templated
                                    .io_aib72           (io_aib_ch7[72]), // Templated
                                    .io_aib73           (io_aib_ch7[73]), // Templated
                                    .io_aib74           (io_aib_ch7[74]), // Templated
                                    .io_aib75           (io_aib_ch7[75]), // Templated
                                    .io_aib76           (io_aib_ch7[76]), // Templated
                                    .io_aib77           (io_aib_ch7[77]), // Templated
                                    .io_aib78           (io_aib_ch7[78]), // Templated
                                    .io_aib79           (io_aib_ch7[79]), // Templated
                                    .io_aib8            (io_aib_ch7[8]), // Templated
                                    .io_aib80           (io_aib_ch7[80]), // Templated
                                    .io_aib81           (io_aib_ch7[81]), // Templated
                                    .io_aib82           (io_aib_ch7[82]), // Templated
                                    .io_aib83           (io_aib_ch7[83]), // Templated
                                    .io_aib84           (io_aib_ch7[84]), // Templated
                                    .io_aib85           (io_aib_ch7[85]), // Templated
                                    .io_aib86           (io_aib_ch7[86]), // Templated
                                    .io_aib87           (io_aib_ch7[87]), // Templated
                                    .io_aib88           (io_aib_ch7[88]), // Templated
                                    .io_aib89           (io_aib_ch7[89]), // Templated
                                    .io_aib9            (io_aib_ch7[9]), // Templated
                                    .io_aib90           (io_aib_ch7[90]), // Templated
                                    .io_aib91           (io_aib_ch7[91]), // Templated
                                    .io_aib92           (io_aib_ch7[92]), // Templated
                                    .io_aib93           (io_aib_ch7[93]), // Templated
                                    .io_aib94           (io_aib_ch7[94]), // Templated
                                    .io_aib95           (io_aib_ch7[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[6]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB7_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[6]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[6]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch6[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch6[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[6]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[6]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch6[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[8]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch8[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[8]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[7]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[7]), // Templated
                                    .i_osc_clk          (aib_osc_clk[6]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[519:455]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[319:280]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[7]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[7]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[623:546]),
                                    .o_tx_elane_data    (o_tx_elane_data[623:546]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[7]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[7][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[6]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[6]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[6]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[6]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[6]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[6]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[6]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[6]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[6]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[6]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[8]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[6]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[6]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[8]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[8]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[8]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[8]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[8]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[8]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[8]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[8]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch8[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_8 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[8]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[8]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[8]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch8[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[8]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[8]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[8]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch8[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch8[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[8]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[8]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch8[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[8]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[548:488]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[8]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[8]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[359:320]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[8]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[8]),
                                    .ms_sideband        (ms_sideband[728:648]),
                                    .sl_sideband        (sl_sideband[656:584]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[8]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[8]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[8]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[8]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[8]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[8][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[8][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[8]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[8]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[8]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[8]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[8]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[8]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[8]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[8]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[8]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[8]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[8]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[8]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[8]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[8]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[8]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[8]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[8]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[8]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[8]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[8]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[8]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch8[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch8[0]), // Templated
                                    .io_aib1            (io_aib_ch8[1]), // Templated
                                    .io_aib10           (io_aib_ch8[10]), // Templated
                                    .io_aib11           (io_aib_ch8[11]), // Templated
                                    .io_aib12           (io_aib_ch8[12]), // Templated
                                    .io_aib13           (io_aib_ch8[13]), // Templated
                                    .io_aib14           (io_aib_ch8[14]), // Templated
                                    .io_aib15           (io_aib_ch8[15]), // Templated
                                    .io_aib16           (io_aib_ch8[16]), // Templated
                                    .io_aib17           (io_aib_ch8[17]), // Templated
                                    .io_aib18           (io_aib_ch8[18]), // Templated
                                    .io_aib19           (io_aib_ch8[19]), // Templated
                                    .io_aib2            (io_aib_ch8[2]), // Templated
                                    .io_aib20           (io_aib_ch8[20]), // Templated
                                    .io_aib21           (io_aib_ch8[21]), // Templated
                                    .io_aib22           (io_aib_ch8[22]), // Templated
                                    .io_aib23           (io_aib_ch8[23]), // Templated
                                    .io_aib24           (io_aib_ch8[24]), // Templated
                                    .io_aib25           (io_aib_ch8[25]), // Templated
                                    .io_aib26           (io_aib_ch8[26]), // Templated
                                    .io_aib27           (io_aib_ch8[27]), // Templated
                                    .io_aib28           (io_aib_ch8[28]), // Templated
                                    .io_aib29           (io_aib_ch8[29]), // Templated
                                    .io_aib3            (io_aib_ch8[3]), // Templated
                                    .io_aib30           (io_aib_ch8[30]), // Templated
                                    .io_aib31           (io_aib_ch8[31]), // Templated
                                    .io_aib32           (io_aib_ch8[32]), // Templated
                                    .io_aib33           (io_aib_ch8[33]), // Templated
                                    .io_aib34           (io_aib_ch8[34]), // Templated
                                    .io_aib35           (io_aib_ch8[35]), // Templated
                                    .io_aib36           (io_aib_ch8[36]), // Templated
                                    .io_aib37           (io_aib_ch8[37]), // Templated
                                    .io_aib38           (io_aib_ch8[38]), // Templated
                                    .io_aib39           (io_aib_ch8[39]), // Templated
                                    .io_aib4            (io_aib_ch8[4]), // Templated
                                    .io_aib40           (io_aib_ch8[40]), // Templated
                                    .io_aib41           (io_aib_ch8[41]), // Templated
                                    .io_aib42           (io_aib_ch8[42]), // Templated
                                    .io_aib43           (io_aib_ch8[43]), // Templated
                                    .io_aib44           (io_aib_ch8[44]), // Templated
                                    .io_aib45           (io_aib_ch8[45]), // Templated
                                    .io_aib46           (io_aib_ch8[46]), // Templated
                                    .io_aib47           (io_aib_ch8[47]), // Templated
                                    .io_aib48           (io_aib_ch8[48]), // Templated
                                    .io_aib49           (io_aib_ch8[49]), // Templated
                                    .io_aib5            (io_aib_ch8[5]), // Templated
                                    .io_aib50           (io_aib_ch8[50]), // Templated
                                    .io_aib51           (io_aib_ch8[51]), // Templated
                                    .io_aib52           (io_aib_ch8[52]), // Templated
                                    .io_aib53           (io_aib_ch8[53]), // Templated
                                    .io_aib54           (io_aib_ch8[54]), // Templated
                                    .io_aib55           (io_aib_ch8[55]), // Templated
                                    .io_aib56           (io_aib_ch8[56]), // Templated
                                    .io_aib57           (io_aib_ch8[57]), // Templated
                                    .io_aib58           (io_aib_ch8[58]), // Templated
                                    .io_aib59           (io_aib_ch8[59]), // Templated
                                    .io_aib6            (io_aib_ch8[6]), // Templated
                                    .io_aib60           (io_aib_ch8[60]), // Templated
                                    .io_aib61           (io_aib_ch8[61]), // Templated
                                    .io_aib62           (io_aib_ch8[62]), // Templated
                                    .io_aib63           (io_aib_ch8[63]), // Templated
                                    .io_aib64           (io_aib_ch8[64]), // Templated
                                    .io_aib65           (io_aib_ch8[65]), // Templated
                                    .io_aib66           (io_aib_ch8[66]), // Templated
                                    .io_aib67           (io_aib_ch8[67]), // Templated
                                    .io_aib68           (io_aib_ch8[68]), // Templated
                                    .io_aib69           (io_aib_ch8[69]), // Templated
                                    .io_aib7            (io_aib_ch8[7]), // Templated
                                    .io_aib70           (io_aib_ch8[70]), // Templated
                                    .io_aib71           (io_aib_ch8[71]), // Templated
                                    .io_aib72           (io_aib_ch8[72]), // Templated
                                    .io_aib73           (io_aib_ch8[73]), // Templated
                                    .io_aib74           (io_aib_ch8[74]), // Templated
                                    .io_aib75           (io_aib_ch8[75]), // Templated
                                    .io_aib76           (io_aib_ch8[76]), // Templated
                                    .io_aib77           (io_aib_ch8[77]), // Templated
                                    .io_aib78           (io_aib_ch8[78]), // Templated
                                    .io_aib79           (io_aib_ch8[79]), // Templated
                                    .io_aib8            (io_aib_ch8[8]), // Templated
                                    .io_aib80           (io_aib_ch8[80]), // Templated
                                    .io_aib81           (io_aib_ch8[81]), // Templated
                                    .io_aib82           (io_aib_ch8[82]), // Templated
                                    .io_aib83           (io_aib_ch8[83]), // Templated
                                    .io_aib84           (io_aib_ch8[84]), // Templated
                                    .io_aib85           (io_aib_ch8[85]), // Templated
                                    .io_aib86           (io_aib_ch8[86]), // Templated
                                    .io_aib87           (io_aib_ch8[87]), // Templated
                                    .io_aib88           (io_aib_ch8[88]), // Templated
                                    .io_aib89           (io_aib_ch8[89]), // Templated
                                    .io_aib9            (io_aib_ch8[9]), // Templated
                                    .io_aib90           (io_aib_ch8[90]), // Templated
                                    .io_aib91           (io_aib_ch8[91]), // Templated
                                    .io_aib92           (io_aib_ch8[92]), // Templated
                                    .io_aib93           (io_aib_ch8[93]), // Templated
                                    .io_aib94           (io_aib_ch8[94]), // Templated
                                    .io_aib95           (io_aib_ch8[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[7]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB8_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[7]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[7]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch7[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch7[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[7]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[7]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch7[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[9]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch9[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[9]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[8]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[8]), // Templated
                                    .i_osc_clk          (aib_osc_clk[7]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[584:520]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[359:320]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[8]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[8]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[701:624]),
                                    .o_tx_elane_data    (o_tx_elane_data[701:624]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[8]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[8][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[7]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[7]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[7]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[7]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[7]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[7]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[7]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[7]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[7]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[7]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[9]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[7]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[7]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[9]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[9]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[9]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[9]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[9]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[9]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[9]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[9]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch9[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_9 (/*AUTOINST*/
                                    // Outputs
                                    .o_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[9]), // Templated
                                    .o_rx_xcvrif_rst_n  (o_rx_xcvrif_rst_n[9]), // Templated
                                    .o_tx_xcvrif_rst_n  (),              // Templated
                                    .o_ehip_init_status (),              // Templated
                                    .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[9]), // Templated
                                    .o_cfg_avmm_rdata   (aib_cfg_avmm_rdata_ch9[31:0]), // Templated
                                    .o_cfg_avmm_waitreq (aib_cfg_avmm_waitreq[9]), // Templated
                                    .o_adpt_cfg_clk     (aib_cfg_avmm_clk[9]), // Templated
                                    .o_adpt_cfg_rst_n   (aib_cfg_avmm_rst_n[9]), // Templated
                                    .o_adpt_cfg_addr    (aib_cfg_avmm_addr_ch9[16:0]), // Templated
                                    .o_adpt_cfg_byte_en (aib_cfg_avmm_byte_en_ch9[3:0]), // Templated
                                    .o_adpt_cfg_read    (aib_cfg_avmm_read[9]), // Templated
                                    .o_adpt_cfg_write   (aib_cfg_avmm_write[9]), // Templated
                                    .o_adpt_cfg_wdata   (aib_cfg_avmm_wdata_ch9[31:0]), // Templated
                                    .o_osc_clk          (aib_osc_clk[9]), // Templated
                                    .o_chnl_ssr         (o_chnl_ssr[609:549]), // Templated
                                    .o_tx_transfer_clk  (o_tx_transfer_clk[9]), // Templated
                                    .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[9]), // Templated
                                    .o_tx_pma_data      (o_tx_pma_data[399:360]), // Templated
                                    .ns_mac_rdy         (ns_mac_rdy[9]),
                                    .ns_adapt_rstn      (ns_adapt_rstn[9]),
                                    .ms_sideband        (ms_sideband[809:729]),
                                    .sl_sideband        (sl_sideband[729:657]),
                                    .m_rxfifo_align_done (m_rxfifo_align_done[9]),
                                    .ms_tx_transfer_en  (ms_tx_transfer_en[9]),
                                    .ms_rx_transfer_en  (ms_rx_transfer_en[9]),
                                    .sl_tx_transfer_en  (sl_tx_transfer_en[9]),
                                    .sl_rx_transfer_en  (sl_rx_transfer_en[9]),
                                    .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[9][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[9][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                    .o_jtag_clkdr_out   (aib_jtag_clkdr_out[9]), // Templated
                                    .o_jtag_clksel_out  (aib_jtag_clksel_out[9]), // Templated
                                    .o_jtag_intest_out  (aib_jtag_intest_out[9]), // Templated
                                    .o_jtag_mode_out    (aib_jtag_mode_out[9]), // Templated
                                    .o_jtag_rstb_en_out (aib_jtag_rstb_en_out[9]), // Templated
                                    .o_jtag_rstb_out    (aib_jtag_rstb_out[9]), // Templated
                                    .o_jtag_weakpdn_out (aib_jtag_weakpdn_out[9]), // Templated
                                    .o_jtag_weakpu_out  (aib_jtag_weakpu_out[9]), // Templated
                                    .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[9]), // Templated
                                    .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[9]), // Templated
                                    .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[9]), // Templated
                                    .o_por_aib_vcchssi  (aib_por_vcchssi[9]), // Templated
                                    .o_por_aib_vccl     (aib_por_vccl[9]), // Templated
                                    .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[9]), // Templated
                                    .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[9]), // Templated
                                    .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[9]), // Templated
                                    .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[9]), // Templated
                                    .o_txen_out_chain1  (aib_txen_chain1[9]), // Templated
                                    .o_txen_out_chain2  (aib_txen_chain2[9]), // Templated
                                    .o_directout_data_chain1_out(aib_directout_data_chain1_out[9]), // Templated
                                    .o_directout_data_chain2_out(aib_directout_data_chain2_out[9]), // Templated
                                    .o_aibdftdll2adjch  (aib_dftdll2adjch_ch9[12:0]), // Templated
                                    // Inouts
                                    .io_aib0            (io_aib_ch9[0]), // Templated
                                    .io_aib1            (io_aib_ch9[1]), // Templated
                                    .io_aib10           (io_aib_ch9[10]), // Templated
                                    .io_aib11           (io_aib_ch9[11]), // Templated
                                    .io_aib12           (io_aib_ch9[12]), // Templated
                                    .io_aib13           (io_aib_ch9[13]), // Templated
                                    .io_aib14           (io_aib_ch9[14]), // Templated
                                    .io_aib15           (io_aib_ch9[15]), // Templated
                                    .io_aib16           (io_aib_ch9[16]), // Templated
                                    .io_aib17           (io_aib_ch9[17]), // Templated
                                    .io_aib18           (io_aib_ch9[18]), // Templated
                                    .io_aib19           (io_aib_ch9[19]), // Templated
                                    .io_aib2            (io_aib_ch9[2]), // Templated
                                    .io_aib20           (io_aib_ch9[20]), // Templated
                                    .io_aib21           (io_aib_ch9[21]), // Templated
                                    .io_aib22           (io_aib_ch9[22]), // Templated
                                    .io_aib23           (io_aib_ch9[23]), // Templated
                                    .io_aib24           (io_aib_ch9[24]), // Templated
                                    .io_aib25           (io_aib_ch9[25]), // Templated
                                    .io_aib26           (io_aib_ch9[26]), // Templated
                                    .io_aib27           (io_aib_ch9[27]), // Templated
                                    .io_aib28           (io_aib_ch9[28]), // Templated
                                    .io_aib29           (io_aib_ch9[29]), // Templated
                                    .io_aib3            (io_aib_ch9[3]), // Templated
                                    .io_aib30           (io_aib_ch9[30]), // Templated
                                    .io_aib31           (io_aib_ch9[31]), // Templated
                                    .io_aib32           (io_aib_ch9[32]), // Templated
                                    .io_aib33           (io_aib_ch9[33]), // Templated
                                    .io_aib34           (io_aib_ch9[34]), // Templated
                                    .io_aib35           (io_aib_ch9[35]), // Templated
                                    .io_aib36           (io_aib_ch9[36]), // Templated
                                    .io_aib37           (io_aib_ch9[37]), // Templated
                                    .io_aib38           (io_aib_ch9[38]), // Templated
                                    .io_aib39           (io_aib_ch9[39]), // Templated
                                    .io_aib4            (io_aib_ch9[4]), // Templated
                                    .io_aib40           (io_aib_ch9[40]), // Templated
                                    .io_aib41           (io_aib_ch9[41]), // Templated
                                    .io_aib42           (io_aib_ch9[42]), // Templated
                                    .io_aib43           (io_aib_ch9[43]), // Templated
                                    .io_aib44           (io_aib_ch9[44]), // Templated
                                    .io_aib45           (io_aib_ch9[45]), // Templated
                                    .io_aib46           (io_aib_ch9[46]), // Templated
                                    .io_aib47           (io_aib_ch9[47]), // Templated
                                    .io_aib48           (io_aib_ch9[48]), // Templated
                                    .io_aib49           (io_aib_ch9[49]), // Templated
                                    .io_aib5            (io_aib_ch9[5]), // Templated
                                    .io_aib50           (io_aib_ch9[50]), // Templated
                                    .io_aib51           (io_aib_ch9[51]), // Templated
                                    .io_aib52           (io_aib_ch9[52]), // Templated
                                    .io_aib53           (io_aib_ch9[53]), // Templated
                                    .io_aib54           (io_aib_ch9[54]), // Templated
                                    .io_aib55           (io_aib_ch9[55]), // Templated
                                    .io_aib56           (io_aib_ch9[56]), // Templated
                                    .io_aib57           (io_aib_ch9[57]), // Templated
                                    .io_aib58           (io_aib_ch9[58]), // Templated
                                    .io_aib59           (io_aib_ch9[59]), // Templated
                                    .io_aib6            (io_aib_ch9[6]), // Templated
                                    .io_aib60           (io_aib_ch9[60]), // Templated
                                    .io_aib61           (io_aib_ch9[61]), // Templated
                                    .io_aib62           (io_aib_ch9[62]), // Templated
                                    .io_aib63           (io_aib_ch9[63]), // Templated
                                    .io_aib64           (io_aib_ch9[64]), // Templated
                                    .io_aib65           (io_aib_ch9[65]), // Templated
                                    .io_aib66           (io_aib_ch9[66]), // Templated
                                    .io_aib67           (io_aib_ch9[67]), // Templated
                                    .io_aib68           (io_aib_ch9[68]), // Templated
                                    .io_aib69           (io_aib_ch9[69]), // Templated
                                    .io_aib7            (io_aib_ch9[7]), // Templated
                                    .io_aib70           (io_aib_ch9[70]), // Templated
                                    .io_aib71           (io_aib_ch9[71]), // Templated
                                    .io_aib72           (io_aib_ch9[72]), // Templated
                                    .io_aib73           (io_aib_ch9[73]), // Templated
                                    .io_aib74           (io_aib_ch9[74]), // Templated
                                    .io_aib75           (io_aib_ch9[75]), // Templated
                                    .io_aib76           (io_aib_ch9[76]), // Templated
                                    .io_aib77           (io_aib_ch9[77]), // Templated
                                    .io_aib78           (io_aib_ch9[78]), // Templated
                                    .io_aib79           (io_aib_ch9[79]), // Templated
                                    .io_aib8            (io_aib_ch9[8]), // Templated
                                    .io_aib80           (io_aib_ch9[80]), // Templated
                                    .io_aib81           (io_aib_ch9[81]), // Templated
                                    .io_aib82           (io_aib_ch9[82]), // Templated
                                    .io_aib83           (io_aib_ch9[83]), // Templated
                                    .io_aib84           (io_aib_ch9[84]), // Templated
                                    .io_aib85           (io_aib_ch9[85]), // Templated
                                    .io_aib86           (io_aib_ch9[86]), // Templated
                                    .io_aib87           (io_aib_ch9[87]), // Templated
                                    .io_aib88           (io_aib_ch9[88]), // Templated
                                    .io_aib89           (io_aib_ch9[89]), // Templated
                                    .io_aib9            (io_aib_ch9[9]), // Templated
                                    .io_aib90           (io_aib_ch9[90]), // Templated
                                    .io_aib91           (io_aib_ch9[91]), // Templated
                                    .io_aib92           (io_aib_ch9[92]), // Templated
                                    .io_aib93           (io_aib_ch9[93]), // Templated
                                    .io_aib94           (io_aib_ch9[94]), // Templated
                                    .io_aib95           (io_aib_ch9[95]), // Templated
                                    // Inputs
                                    .i_adpt_hard_rst_n  (aib_adpt_chnl_hard_rst_n[8]), // Templated
                                    .i_channel_id       (C3_AVMM_AIB9_ID), // Templated
                                    .i_cfg_avmm_clk     (aib_cfg_avmm_clk[8]), // Templated
                                    .i_cfg_avmm_rst_n   (aib_cfg_avmm_rst_n[8]), // Templated
                                    .i_cfg_avmm_addr    (aib_cfg_avmm_addr_ch8[16:0]), // Templated
                                    .i_cfg_avmm_byte_en (aib_cfg_avmm_byte_en_ch8[3:0]), // Templated
                                    .i_cfg_avmm_read    (aib_cfg_avmm_read[8]), // Templated
                                    .i_cfg_avmm_write   (aib_cfg_avmm_write[8]), // Templated
                                    .i_cfg_avmm_wdata   (aib_cfg_avmm_wdata_ch8[31:0]), // Templated
                                    .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[10]), // Templated
                                    .i_adpt_cfg_rdata   (aib_cfg_avmm_rdata_ch10[31:0]), // Templated
                                    .i_adpt_cfg_waitreq (aib_cfg_avmm_waitreq[10]), // Templated
                                    .i_rx_pma_clk       (i_rx_pma_clk[9]), // Templated
                                    .i_rx_pma_div2_clk  (i_rx_pma_div2_clk[9]), // Templated
                                    .i_osc_clk          (aib_osc_clk[8]), // Templated
                                    .i_chnl_ssr         (i_chnl_ssr[649:585]), // Templated
                                    .i_rx_pma_data      (i_rx_pma_data[399:360]), // Templated
                                    .i_rx_elane_clk     (i_rx_elane_clk[9]),
                                    .i_tx_pma_clk       (i_tx_pma_clk[9]), // Templated
                                    .i_rx_elane_data    (i_rx_elane_data[779:702]),
                                    .o_tx_elane_data    (o_tx_elane_data[779:702]),
                                    .i_tx_elane_clk     (i_tx_elane_clk[9]),
                                    .i_scan_clk         (i_scan_clk),    // Templated
                                    .i_test_clk_1g      (i_test_clk_1g), // Templated
                                    .i_test_clk_500m    (i_test_clk_500m), // Templated
                                    .i_test_clk_250m    (i_test_clk_250m), // Templated
                                    .i_test_clk_125m    (i_test_clk_125m), // Templated
                                    .i_test_clk_62m     (i_test_clk_62m), // Templated
                                    .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                    .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[9][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                    .i_jtag_rstb_in     (aib_jtag_rstb_out[8]), // Templated
                                    .i_jtag_rstb_en_in  (aib_jtag_rstb_en_out[8]), // Templated
                                    .i_jtag_clkdr_in    (aib_jtag_clkdr_out[8]), // Templated
                                    .i_jtag_clksel_in   (aib_jtag_clksel_out[8]), // Templated
                                    .i_jtag_intest_in   (aib_jtag_intest_out[8]), // Templated
                                    .i_jtag_mode_in     (aib_jtag_mode_out[8]), // Templated
                                    .i_jtag_weakpdn_in  (aib_jtag_weakpdn_out[8]), // Templated
                                    .i_jtag_weakpu_in   (aib_jtag_weakpu_out[8]), // Templated
                                    .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[8]), // Templated
                                    .i_jtag_bs_chain_in (aib_jtag_bs_chain_out[8]), // Templated
                                    .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[10]), // Templated
                                    .i_por_aib_vcchssi  (aib_por_vcchssi[8]), // Templated
                                    .i_por_aib_vccl     (aib_por_vccl[8]), // Templated
                                    .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[10]), // Templated
                                    .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[10]), // Templated
                                    .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[10]), // Templated
                                    .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[10]), // Templated
                                    .i_txen_in_chain1   (aib_txen_chain1[10]), // Templated
                                    .i_txen_in_chain2   (aib_txen_chain2[10]), // Templated
                                    .i_directout_data_chain1_in(aib_directout_data_chain1_out[10]), // Templated
                                    .i_directout_data_chain2_in(aib_directout_data_chain2_out[10]), // Templated
                                    .i_aibdftdll2adjch  (aib_dftdll2adjch_ch10[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_10 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[10]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[10]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[10]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch10[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[10]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[10]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[10]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch10[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch10[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[10]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[10]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch10[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[10]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[670:610]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[10]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[10]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[439:400]), // Templated
                                     .ns_mac_rdy         (ns_mac_rdy[10]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[10]),
                                     .ms_sideband        (ms_sideband[890:810]),
                                     .sl_sideband        (sl_sideband[802:730]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[10]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[10]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[10]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[10]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[10]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[10][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[10][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[10]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[10]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[10]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[10]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[10]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[10]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[10]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[10]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[10]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[10]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[10]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[10]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[10]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[10]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[10]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[10]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[10]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[10]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[10]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[10]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[10]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch10[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch10[0]), // Templated
                                     .io_aib1           (io_aib_ch10[1]), // Templated
                                     .io_aib10          (io_aib_ch10[10]), // Templated
                                     .io_aib11          (io_aib_ch10[11]), // Templated
                                     .io_aib12          (io_aib_ch10[12]), // Templated
                                     .io_aib13          (io_aib_ch10[13]), // Templated
                                     .io_aib14          (io_aib_ch10[14]), // Templated
                                     .io_aib15          (io_aib_ch10[15]), // Templated
                                     .io_aib16          (io_aib_ch10[16]), // Templated
                                     .io_aib17          (io_aib_ch10[17]), // Templated
                                     .io_aib18          (io_aib_ch10[18]), // Templated
                                     .io_aib19          (io_aib_ch10[19]), // Templated
                                     .io_aib2           (io_aib_ch10[2]), // Templated
                                     .io_aib20          (io_aib_ch10[20]), // Templated
                                     .io_aib21          (io_aib_ch10[21]), // Templated
                                     .io_aib22          (io_aib_ch10[22]), // Templated
                                     .io_aib23          (io_aib_ch10[23]), // Templated
                                     .io_aib24          (io_aib_ch10[24]), // Templated
                                     .io_aib25          (io_aib_ch10[25]), // Templated
                                     .io_aib26          (io_aib_ch10[26]), // Templated
                                     .io_aib27          (io_aib_ch10[27]), // Templated
                                     .io_aib28          (io_aib_ch10[28]), // Templated
                                     .io_aib29          (io_aib_ch10[29]), // Templated
                                     .io_aib3           (io_aib_ch10[3]), // Templated
                                     .io_aib30          (io_aib_ch10[30]), // Templated
                                     .io_aib31          (io_aib_ch10[31]), // Templated
                                     .io_aib32          (io_aib_ch10[32]), // Templated
                                     .io_aib33          (io_aib_ch10[33]), // Templated
                                     .io_aib34          (io_aib_ch10[34]), // Templated
                                     .io_aib35          (io_aib_ch10[35]), // Templated
                                     .io_aib36          (io_aib_ch10[36]), // Templated
                                     .io_aib37          (io_aib_ch10[37]), // Templated
                                     .io_aib38          (io_aib_ch10[38]), // Templated
                                     .io_aib39          (io_aib_ch10[39]), // Templated
                                     .io_aib4           (io_aib_ch10[4]), // Templated
                                     .io_aib40          (io_aib_ch10[40]), // Templated
                                     .io_aib41          (io_aib_ch10[41]), // Templated
                                     .io_aib42          (io_aib_ch10[42]), // Templated
                                     .io_aib43          (io_aib_ch10[43]), // Templated
                                     .io_aib44          (io_aib_ch10[44]), // Templated
                                     .io_aib45          (io_aib_ch10[45]), // Templated
                                     .io_aib46          (io_aib_ch10[46]), // Templated
                                     .io_aib47          (io_aib_ch10[47]), // Templated
                                     .io_aib48          (io_aib_ch10[48]), // Templated
                                     .io_aib49          (io_aib_ch10[49]), // Templated
                                     .io_aib5           (io_aib_ch10[5]), // Templated
                                     .io_aib50          (io_aib_ch10[50]), // Templated
                                     .io_aib51          (io_aib_ch10[51]), // Templated
                                     .io_aib52          (io_aib_ch10[52]), // Templated
                                     .io_aib53          (io_aib_ch10[53]), // Templated
                                     .io_aib54          (io_aib_ch10[54]), // Templated
                                     .io_aib55          (io_aib_ch10[55]), // Templated
                                     .io_aib56          (io_aib_ch10[56]), // Templated
                                     .io_aib57          (io_aib_ch10[57]), // Templated
                                     .io_aib58          (io_aib_ch10[58]), // Templated
                                     .io_aib59          (io_aib_ch10[59]), // Templated
                                     .io_aib6           (io_aib_ch10[6]), // Templated
                                     .io_aib60          (io_aib_ch10[60]), // Templated
                                     .io_aib61          (io_aib_ch10[61]), // Templated
                                     .io_aib62          (io_aib_ch10[62]), // Templated
                                     .io_aib63          (io_aib_ch10[63]), // Templated
                                     .io_aib64          (io_aib_ch10[64]), // Templated
                                     .io_aib65          (io_aib_ch10[65]), // Templated
                                     .io_aib66          (io_aib_ch10[66]), // Templated
                                     .io_aib67          (io_aib_ch10[67]), // Templated
                                     .io_aib68          (io_aib_ch10[68]), // Templated
                                     .io_aib69          (io_aib_ch10[69]), // Templated
                                     .io_aib7           (io_aib_ch10[7]), // Templated
                                     .io_aib70          (io_aib_ch10[70]), // Templated
                                     .io_aib71          (io_aib_ch10[71]), // Templated
                                     .io_aib72          (io_aib_ch10[72]), // Templated
                                     .io_aib73          (io_aib_ch10[73]), // Templated
                                     .io_aib74          (io_aib_ch10[74]), // Templated
                                     .io_aib75          (io_aib_ch10[75]), // Templated
                                     .io_aib76          (io_aib_ch10[76]), // Templated
                                     .io_aib77          (io_aib_ch10[77]), // Templated
                                     .io_aib78          (io_aib_ch10[78]), // Templated
                                     .io_aib79          (io_aib_ch10[79]), // Templated
                                     .io_aib8           (io_aib_ch10[8]), // Templated
                                     .io_aib80          (io_aib_ch10[80]), // Templated
                                     .io_aib81          (io_aib_ch10[81]), // Templated
                                     .io_aib82          (io_aib_ch10[82]), // Templated
                                     .io_aib83          (io_aib_ch10[83]), // Templated
                                     .io_aib84          (io_aib_ch10[84]), // Templated
                                     .io_aib85          (io_aib_ch10[85]), // Templated
                                     .io_aib86          (io_aib_ch10[86]), // Templated
                                     .io_aib87          (io_aib_ch10[87]), // Templated
                                     .io_aib88          (io_aib_ch10[88]), // Templated
                                     .io_aib89          (io_aib_ch10[89]), // Templated
                                     .io_aib9           (io_aib_ch10[9]), // Templated
                                     .io_aib90          (io_aib_ch10[90]), // Templated
                                     .io_aib91          (io_aib_ch10[91]), // Templated
                                     .io_aib92          (io_aib_ch10[92]), // Templated
                                     .io_aib93          (io_aib_ch10[93]), // Templated
                                     .io_aib94          (io_aib_ch10[94]), // Templated
                                     .io_aib95          (io_aib_ch10[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[9]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB10_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[9]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[9]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch9[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch9[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[9]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[9]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch9[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[11]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch11[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[11]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[10]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[10]), // Templated
                                     .i_osc_clk         (aib_osc_clk[9]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[714:650]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[439:400]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[10]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[10]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[857:780]),
                                     .o_tx_elane_data    (o_tx_elane_data[857:780]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[10]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[10][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[9]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[9]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[9]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[9]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[9]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[9]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[9]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[9]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[9]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[9]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[11]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[9]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[9]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[11]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[11]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[11]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[11]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[11]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[11]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[11]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[11]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch11[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_11 (
                                     .i_adpt_cfg_rdatavld(chnl_aib_cfg_avmm_rdatavld[1]), 
                                     .i_adpt_cfg_rdata   (chnl_aib_cfg_avmm_rdata_1[31:0]),
                                     .i_adpt_cfg_waitreq (chnl_aib_cfg_avmm_waitreq[1]), 
                                     .i_jtag_last_bs_chain_in(chnl_aib_jtag_last_bs_chain_out[1]),
                                     .i_red_idataselb_in_chain1(chnl_aib_red_idataselb_chain1[1]), 
                                     .i_red_idataselb_in_chain2(chnl_aib_red_idataselb_chain2[1]), 
                                     .i_red_shift_en_in_chain1(chnl_aib_red_shift_en_chain1[1]), 
                                     .i_red_shift_en_in_chain2(chnl_aib_red_shift_en_chain2[1]), 
                                     .i_txen_in_chain1   (chnl_aib_txen_chain1[1]), 
                                     .i_txen_in_chain2   (chnl_aib_txen_chain2[1]), 
                                     .i_directout_data_chain1_in(chnl_aib_directout_data_chain1_out[1]), 
                                     .i_directout_data_chain2_in(chnl_aib_directout_data_chain2_out[1]), 
                                     .i_aibdftdll2adjch  (chnl_aib_dftdll2adjch_1[12:0]), 
                                     /*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[11]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[11]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[11]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch11[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[11]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[11]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[11]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch11[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch11[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[11]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[11]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch11[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[11]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[731:671]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[11]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[11]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[479:440]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[11]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[11]),
                                     .ms_sideband       (ms_sideband[971:891]),
                                     .sl_sideband        (sl_sideband[875:803]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[11]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[11]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[11]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[11]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[11]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[11][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[11][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[11]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[11]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[11]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[11]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[11]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[11]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[11]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[11]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[11]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[11]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[11]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[11]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[11]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[11]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[11]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[11]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[11]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[11]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[11]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[11]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[11]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch11[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch11[0]), // Templated
                                     .io_aib1           (io_aib_ch11[1]), // Templated
                                     .io_aib10          (io_aib_ch11[10]), // Templated
                                     .io_aib11          (io_aib_ch11[11]), // Templated
                                     .io_aib12          (io_aib_ch11[12]), // Templated
                                     .io_aib13          (io_aib_ch11[13]), // Templated
                                     .io_aib14          (io_aib_ch11[14]), // Templated
                                     .io_aib15          (io_aib_ch11[15]), // Templated
                                     .io_aib16          (io_aib_ch11[16]), // Templated
                                     .io_aib17          (io_aib_ch11[17]), // Templated
                                     .io_aib18          (io_aib_ch11[18]), // Templated
                                     .io_aib19          (io_aib_ch11[19]), // Templated
                                     .io_aib2           (io_aib_ch11[2]), // Templated
                                     .io_aib20          (io_aib_ch11[20]), // Templated
                                     .io_aib21          (io_aib_ch11[21]), // Templated
                                     .io_aib22          (io_aib_ch11[22]), // Templated
                                     .io_aib23          (io_aib_ch11[23]), // Templated
                                     .io_aib24          (io_aib_ch11[24]), // Templated
                                     .io_aib25          (io_aib_ch11[25]), // Templated
                                     .io_aib26          (io_aib_ch11[26]), // Templated
                                     .io_aib27          (io_aib_ch11[27]), // Templated
                                     .io_aib28          (io_aib_ch11[28]), // Templated
                                     .io_aib29          (io_aib_ch11[29]), // Templated
                                     .io_aib3           (io_aib_ch11[3]), // Templated
                                     .io_aib30          (io_aib_ch11[30]), // Templated
                                     .io_aib31          (io_aib_ch11[31]), // Templated
                                     .io_aib32          (io_aib_ch11[32]), // Templated
                                     .io_aib33          (io_aib_ch11[33]), // Templated
                                     .io_aib34          (io_aib_ch11[34]), // Templated
                                     .io_aib35          (io_aib_ch11[35]), // Templated
                                     .io_aib36          (io_aib_ch11[36]), // Templated
                                     .io_aib37          (io_aib_ch11[37]), // Templated
                                     .io_aib38          (io_aib_ch11[38]), // Templated
                                     .io_aib39          (io_aib_ch11[39]), // Templated
                                     .io_aib4           (io_aib_ch11[4]), // Templated
                                     .io_aib40          (io_aib_ch11[40]), // Templated
                                     .io_aib41          (io_aib_ch11[41]), // Templated
                                     .io_aib42          (io_aib_ch11[42]), // Templated
                                     .io_aib43          (io_aib_ch11[43]), // Templated
                                     .io_aib44          (io_aib_ch11[44]), // Templated
                                     .io_aib45          (io_aib_ch11[45]), // Templated
                                     .io_aib46          (io_aib_ch11[46]), // Templated
                                     .io_aib47          (io_aib_ch11[47]), // Templated
                                     .io_aib48          (io_aib_ch11[48]), // Templated
                                     .io_aib49          (io_aib_ch11[49]), // Templated
                                     .io_aib5           (io_aib_ch11[5]), // Templated
                                     .io_aib50          (io_aib_ch11[50]), // Templated
                                     .io_aib51          (io_aib_ch11[51]), // Templated
                                     .io_aib52          (io_aib_ch11[52]), // Templated
                                     .io_aib53          (io_aib_ch11[53]), // Templated
                                     .io_aib54          (io_aib_ch11[54]), // Templated
                                     .io_aib55          (io_aib_ch11[55]), // Templated
                                     .io_aib56          (io_aib_ch11[56]), // Templated
                                     .io_aib57          (io_aib_ch11[57]), // Templated
                                     .io_aib58          (io_aib_ch11[58]), // Templated
                                     .io_aib59          (io_aib_ch11[59]), // Templated
                                     .io_aib6           (io_aib_ch11[6]), // Templated
                                     .io_aib60          (io_aib_ch11[60]), // Templated
                                     .io_aib61          (io_aib_ch11[61]), // Templated
                                     .io_aib62          (io_aib_ch11[62]), // Templated
                                     .io_aib63          (io_aib_ch11[63]), // Templated
                                     .io_aib64          (io_aib_ch11[64]), // Templated
                                     .io_aib65          (io_aib_ch11[65]), // Templated
                                     .io_aib66          (io_aib_ch11[66]), // Templated
                                     .io_aib67          (io_aib_ch11[67]), // Templated
                                     .io_aib68          (io_aib_ch11[68]), // Templated
                                     .io_aib69          (io_aib_ch11[69]), // Templated
                                     .io_aib7           (io_aib_ch11[7]), // Templated
                                     .io_aib70          (io_aib_ch11[70]), // Templated
                                     .io_aib71          (io_aib_ch11[71]), // Templated
                                     .io_aib72          (io_aib_ch11[72]), // Templated
                                     .io_aib73          (io_aib_ch11[73]), // Templated
                                     .io_aib74          (io_aib_ch11[74]), // Templated
                                     .io_aib75          (io_aib_ch11[75]), // Templated
                                     .io_aib76          (io_aib_ch11[76]), // Templated
                                     .io_aib77          (io_aib_ch11[77]), // Templated
                                     .io_aib78          (io_aib_ch11[78]), // Templated
                                     .io_aib79          (io_aib_ch11[79]), // Templated
                                     .io_aib8           (io_aib_ch11[8]), // Templated
                                     .io_aib80          (io_aib_ch11[80]), // Templated
                                     .io_aib81          (io_aib_ch11[81]), // Templated
                                     .io_aib82          (io_aib_ch11[82]), // Templated
                                     .io_aib83          (io_aib_ch11[83]), // Templated
                                     .io_aib84          (io_aib_ch11[84]), // Templated
                                     .io_aib85          (io_aib_ch11[85]), // Templated
                                     .io_aib86          (io_aib_ch11[86]), // Templated
                                     .io_aib87          (io_aib_ch11[87]), // Templated
                                     .io_aib88          (io_aib_ch11[88]), // Templated
                                     .io_aib89          (io_aib_ch11[89]), // Templated
                                     .io_aib9           (io_aib_ch11[9]), // Templated
                                     .io_aib90          (io_aib_ch11[90]), // Templated
                                     .io_aib91          (io_aib_ch11[91]), // Templated
                                     .io_aib92          (io_aib_ch11[92]), // Templated
                                     .io_aib93          (io_aib_ch11[93]), // Templated
                                     .io_aib94          (io_aib_ch11[94]), // Templated
                                     .io_aib95          (io_aib_ch11[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[10]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB11_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[10]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[10]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch10[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch10[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[10]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[10]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch10[31:0]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[11]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[11]), // Templated
                                     .i_osc_clk         (aib_osc_clk[10]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[779:715]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[479:440]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[11]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[11]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[935:858]),
                                     .o_tx_elane_data    (o_tx_elane_data[935:858]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[11]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[11][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[10]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[10]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[10]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[10]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[10]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[10]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[10]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[10]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[10]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[10]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[10]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[10])); // Templated

    c3routing_chnl_aib u_c3routing_chnl_1 (/*AUTOINST*/
                                           // Outputs
                                           .o_rdata             (chnl_aib_cfg_avmm_rdata_1[31:0]), // Templated
                                           .o_rdatavalid        (chnl_aib_cfg_avmm_rdatavld[1]), // Templated
                                           .o_waitreq           (chnl_aib_cfg_avmm_waitreq[1]), // Templated
                                           .o_clk               (chnl_aib_cfg_avmm_clk[1]), // Templated
                                           .o_rst_n             (chnl_aib_cfg_avmm_rst_n[1]), // Templated
                                           .o_addr              (chnl_aib_cfg_avmm_addr_1[16:0]), // Templated
                                           .o_byte_en           (chnl_aib_cfg_avmm_byte_en_1[3:0]), // Templated
                                           .o_read              (chnl_aib_cfg_avmm_read[1]), // Templated
                                           .o_write             (chnl_aib_cfg_avmm_write[1]), // Templated
                                           .o_wdata             (chnl_aib_cfg_avmm_wdata_1[31:0]), // Templated
                                           .o_adpt_hard_rst_n   (chnl_aib_adpt_hard_rst_n[1]), // Templated
                                           .o_red_idataselb_chain1(chnl_aib_red_idataselb_chain1[1]), // Templated
                                           .o_red_idataselb_chain2(chnl_aib_red_idataselb_chain2[1]), // Templated
                                           .o_red_shift_en_chain1(chnl_aib_red_shift_en_chain1[1]), // Templated
                                           .o_red_shift_en_chain2(chnl_aib_red_shift_en_chain2[1]), // Templated
                                           .o_txen_chain1       (chnl_aib_txen_chain1[1]), // Templated
                                           .o_txen_chain2       (chnl_aib_txen_chain2[1]), // Templated
                                           .o_osc_clk           (chnl_aib_osc_clk[1]), // Templated
                                           .o_aibdftdll2adjch   (chnl_aib_dftdll2adjch_1[12:0]), // Templated
                                           .o_vccl              (chnl_aib_vccl[1]), // Templated
                                           .o_vcchssi           (chnl_aib_vcchssi[1]), // Templated
                                           .o_jtag_last_bs_chain_out(chnl_aib_jtag_last_bs_chain_out[1]), // Templated
                                           .o_directout_data_chain1_out(chnl_aib_directout_data_chain1_out[1]), // Templated
                                           .o_directout_data_chain2_out(chnl_aib_directout_data_chain2_out[1]), // Templated
                                           .o_jtag_bs_chain_out (chnl_aib_jtag_bs_chain_out[1]), // Templated
                                           .o_jtag_bs_scanen_out(chnl_jtag_bs_scanen_out[1]), // Templated
                                           .o_jtag_clkdr_out    (chnl_jtag_clkdr_out[1]), // Templated
                                           .o_jtag_clksel_out   (chnl_jtag_clksel_out[1]), // Templated
                                           .o_jtag_intest_out   (chnl_jtag_intest_out[1]), // Templated
                                           .o_jtag_mode_out     (chnl_jtag_mode_out[1]), // Templated
                                           .o_jtag_rstb_en_out  (chnl_jtag_rstb_en_out[1]), // Templated
                                           .o_jtag_rstb_out     (chnl_jtag_rstb_out[1]), // Templated
                                           .o_jtag_weakpdn_out  (chnl_jtag_weakpdn_out[1]), // Templated
                                           .o_jtag_weakpu_out   (chnl_jtag_weakpu_out[1]), // Templated
                                           // Inputs
                                           .i_clk               (aib_cfg_avmm_clk[11]), // Templated
                                           .i_rst_n             (aib_cfg_avmm_rst_n[11]), // Templated
                                           .i_addr              (aib_cfg_avmm_addr_ch11[16:0]), // Templated
                                           .i_byte_en           (aib_cfg_avmm_byte_en_ch11[3:0]), // Templated
                                           .i_read              (aib_cfg_avmm_read[11]), // Templated
                                           .i_write             (aib_cfg_avmm_write[11]), // Templated
                                           .i_wdata             (aib_cfg_avmm_wdata_ch11[31:0]), // Templated
                                           .i_adpt_hard_rst_n   (aib_adpt_chnl_hard_rst_n[11]), // Templated
                                           .i_red_idataselb_chain1(aib_red_idataselb_chain1[12]), // Templated
                                           .i_red_idataselb_chain2(aib_red_idataselb_chain2[12]), // Templated
                                           .i_red_shift_en_chain1(aib_red_shift_en_chain1[12]), // Templated
                                           .i_red_shift_en_chain2(aib_red_shift_en_chain2[12]), // Templated
                                           .i_txen_chain1       (aib_txen_chain1[12]), // Templated
                                           .i_txen_chain2       (aib_txen_chain2[12]), // Templated
                                           .i_osc_clk           (aib_osc_clk[11]), // Templated
                                           .i_aibdftdll2adjch   (aib_dftdll2adjch_ch12[12:0]), // Templated
                                           .i_vccl              (aib_por_vccl[11]), // Templated
                                           .i_vcchssi           (aib_por_vcchssi[11]), // Templated
                                           .i_rdata             (aib_cfg_avmm_rdata_ch12[31:0]), // Templated
                                           .i_rdatavalid        (aib_cfg_avmm_rdatavld[12]), // Templated
                                           .i_waitreq           (aib_cfg_avmm_waitreq[12]), // Templated
                                           .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[12]), // Templated
                                           .i_directout_data_chain1_in(aib_directout_data_chain1_out[12]), // Templated
                                           .i_directout_data_chain2_in(aib_directout_data_chain2_out[12]), // Templated
                                           .i_jtag_bs_chain_in  (aib_jtag_bs_chain_out[11]), // Templated
                                           .i_jtag_bs_scanen_in (aib_jtag_bs_scanen_out[11]), // Templated
                                           .i_jtag_clkdr_in     (aib_jtag_clkdr_out[11]), // Templated
                                           .i_jtag_clksel_in    (aib_jtag_clksel_out[11]), // Templated
                                           .i_jtag_intest_in    (aib_jtag_intest_out[11]), // Templated
                                           .i_jtag_mode_in      (aib_jtag_mode_out[11]), // Templated
                                           .i_jtag_rstb_en_in   (aib_jtag_rstb_en_out[11]), // Templated
                                           .i_jtag_rstb_in      (aib_jtag_rstb_out[11]), // Templated
                                           .i_jtag_weakpdn_in   (aib_jtag_weakpdn_out[11]), // Templated
                                           .i_jtag_weakpu_in    (aib_jtag_weakpu_out[11])); // Templated
                                  
    c3aibadapt_wrap u_c3aibadapt_12 (
                                     .i_osc_clk          (chnl_aib_osc_clk[1]),
                                     .i_cfg_avmm_clk     (chnl_aib_cfg_avmm_clk[1]), 
                                     .i_cfg_avmm_rst_n   (chnl_aib_cfg_avmm_rst_n[1]), 
                                     .i_cfg_avmm_addr    (chnl_aib_cfg_avmm_addr_1[16:0]),
                                     .i_cfg_avmm_byte_en (chnl_aib_cfg_avmm_byte_en_1[3:0]),
                                     .i_cfg_avmm_read    (chnl_aib_cfg_avmm_read[1]), 
                                     .i_cfg_avmm_write   (chnl_aib_cfg_avmm_write[1]),
                                     .i_cfg_avmm_wdata   (chnl_aib_cfg_avmm_wdata_1[31:0]), 
                                     .i_adpt_hard_rst_n  (chnl_aib_adpt_hard_rst_n[1]), 
                                     .i_jtag_rstb_in     (chnl_jtag_rstb_out[1]), 
                                     .i_jtag_rstb_en_in  (chnl_jtag_rstb_en_out[1]),
                                     .i_jtag_clkdr_in    (chnl_jtag_clkdr_out[1]), 
                                     .i_jtag_clksel_in   (chnl_jtag_clksel_out[1]),
                                     .i_jtag_intest_in   (chnl_jtag_intest_out[1]),
                                     .i_jtag_mode_in     (chnl_jtag_mode_out[1]), 
                                     .i_jtag_weakpdn_in  (chnl_jtag_weakpdn_out[1]),
                                     .i_jtag_weakpu_in   (chnl_jtag_weakpu_out[1]),
                                     .i_jtag_bs_scanen_in(chnl_jtag_bs_scanen_out[1]),
                                     .i_jtag_bs_chain_in (chnl_aib_jtag_bs_chain_out[1]),
                                     .i_por_aib_vcchssi  (chnl_aib_vcchssi[1]),
                                     .i_por_aib_vccl     (chnl_aib_vccl[1]), 
                                     /*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[12]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[12]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[12]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch12[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[12]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[12]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[12]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch12[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch12[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[12]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[12]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch12[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[12]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[792:732]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[12]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[12]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[519:480]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[12]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[12]),
                                     .ms_sideband        (ms_sideband[1052:972]),
                                     .sl_sideband        (sl_sideband[948:876]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[12]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[12]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[12]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[12]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[12]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[12][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[12][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[12]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[12]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[12]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[12]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[12]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[12]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[12]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[12]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[12]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[12]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[12]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[12]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[12]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[12]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[12]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[12]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[12]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[12]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[12]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[12]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[12]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch12[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch12[0]), // Templated
                                     .io_aib1           (io_aib_ch12[1]), // Templated
                                     .io_aib10          (io_aib_ch12[10]), // Templated
                                     .io_aib11          (io_aib_ch12[11]), // Templated
                                     .io_aib12          (io_aib_ch12[12]), // Templated
                                     .io_aib13          (io_aib_ch12[13]), // Templated
                                     .io_aib14          (io_aib_ch12[14]), // Templated
                                     .io_aib15          (io_aib_ch12[15]), // Templated
                                     .io_aib16          (io_aib_ch12[16]), // Templated
                                     .io_aib17          (io_aib_ch12[17]), // Templated
                                     .io_aib18          (io_aib_ch12[18]), // Templated
                                     .io_aib19          (io_aib_ch12[19]), // Templated
                                     .io_aib2           (io_aib_ch12[2]), // Templated
                                     .io_aib20          (io_aib_ch12[20]), // Templated
                                     .io_aib21          (io_aib_ch12[21]), // Templated
                                     .io_aib22          (io_aib_ch12[22]), // Templated
                                     .io_aib23          (io_aib_ch12[23]), // Templated
                                     .io_aib24          (io_aib_ch12[24]), // Templated
                                     .io_aib25          (io_aib_ch12[25]), // Templated
                                     .io_aib26          (io_aib_ch12[26]), // Templated
                                     .io_aib27          (io_aib_ch12[27]), // Templated
                                     .io_aib28          (io_aib_ch12[28]), // Templated
                                     .io_aib29          (io_aib_ch12[29]), // Templated
                                     .io_aib3           (io_aib_ch12[3]), // Templated
                                     .io_aib30          (io_aib_ch12[30]), // Templated
                                     .io_aib31          (io_aib_ch12[31]), // Templated
                                     .io_aib32          (io_aib_ch12[32]), // Templated
                                     .io_aib33          (io_aib_ch12[33]), // Templated
                                     .io_aib34          (io_aib_ch12[34]), // Templated
                                     .io_aib35          (io_aib_ch12[35]), // Templated
                                     .io_aib36          (io_aib_ch12[36]), // Templated
                                     .io_aib37          (io_aib_ch12[37]), // Templated
                                     .io_aib38          (io_aib_ch12[38]), // Templated
                                     .io_aib39          (io_aib_ch12[39]), // Templated
                                     .io_aib4           (io_aib_ch12[4]), // Templated
                                     .io_aib40          (io_aib_ch12[40]), // Templated
                                     .io_aib41          (io_aib_ch12[41]), // Templated
                                     .io_aib42          (io_aib_ch12[42]), // Templated
                                     .io_aib43          (io_aib_ch12[43]), // Templated
                                     .io_aib44          (io_aib_ch12[44]), // Templated
                                     .io_aib45          (io_aib_ch12[45]), // Templated
                                     .io_aib46          (io_aib_ch12[46]), // Templated
                                     .io_aib47          (io_aib_ch12[47]), // Templated
                                     .io_aib48          (io_aib_ch12[48]), // Templated
                                     .io_aib49          (io_aib_ch12[49]), // Templated
                                     .io_aib5           (io_aib_ch12[5]), // Templated
                                     .io_aib50          (io_aib_ch12[50]), // Templated
                                     .io_aib51          (io_aib_ch12[51]), // Templated
                                     .io_aib52          (io_aib_ch12[52]), // Templated
                                     .io_aib53          (io_aib_ch12[53]), // Templated
                                     .io_aib54          (io_aib_ch12[54]), // Templated
                                     .io_aib55          (io_aib_ch12[55]), // Templated
                                     .io_aib56          (io_aib_ch12[56]), // Templated
                                     .io_aib57          (io_aib_ch12[57]), // Templated
                                     .io_aib58          (io_aib_ch12[58]), // Templated
                                     .io_aib59          (io_aib_ch12[59]), // Templated
                                     .io_aib6           (io_aib_ch12[6]), // Templated
                                     .io_aib60          (io_aib_ch12[60]), // Templated
                                     .io_aib61          (io_aib_ch12[61]), // Templated
                                     .io_aib62          (io_aib_ch12[62]), // Templated
                                     .io_aib63          (io_aib_ch12[63]), // Templated
                                     .io_aib64          (io_aib_ch12[64]), // Templated
                                     .io_aib65          (io_aib_ch12[65]), // Templated
                                     .io_aib66          (io_aib_ch12[66]), // Templated
                                     .io_aib67          (io_aib_ch12[67]), // Templated
                                     .io_aib68          (io_aib_ch12[68]), // Templated
                                     .io_aib69          (io_aib_ch12[69]), // Templated
                                     .io_aib7           (io_aib_ch12[7]), // Templated
                                     .io_aib70          (io_aib_ch12[70]), // Templated
                                     .io_aib71          (io_aib_ch12[71]), // Templated
                                     .io_aib72          (io_aib_ch12[72]), // Templated
                                     .io_aib73          (io_aib_ch12[73]), // Templated
                                     .io_aib74          (io_aib_ch12[74]), // Templated
                                     .io_aib75          (io_aib_ch12[75]), // Templated
                                     .io_aib76          (io_aib_ch12[76]), // Templated
                                     .io_aib77          (io_aib_ch12[77]), // Templated
                                     .io_aib78          (io_aib_ch12[78]), // Templated
                                     .io_aib79          (io_aib_ch12[79]), // Templated
                                     .io_aib8           (io_aib_ch12[8]), // Templated
                                     .io_aib80          (io_aib_ch12[80]), // Templated
                                     .io_aib81          (io_aib_ch12[81]), // Templated
                                     .io_aib82          (io_aib_ch12[82]), // Templated
                                     .io_aib83          (io_aib_ch12[83]), // Templated
                                     .io_aib84          (io_aib_ch12[84]), // Templated
                                     .io_aib85          (io_aib_ch12[85]), // Templated
                                     .io_aib86          (io_aib_ch12[86]), // Templated
                                     .io_aib87          (io_aib_ch12[87]), // Templated
                                     .io_aib88          (io_aib_ch12[88]), // Templated
                                     .io_aib89          (io_aib_ch12[89]), // Templated
                                     .io_aib9           (io_aib_ch12[9]), // Templated
                                     .io_aib90          (io_aib_ch12[90]), // Templated
                                     .io_aib91          (io_aib_ch12[91]), // Templated
                                     .io_aib92          (io_aib_ch12[92]), // Templated
                                     .io_aib93          (io_aib_ch12[93]), // Templated
                                     .io_aib94          (io_aib_ch12[94]), // Templated
                                     .io_aib95          (io_aib_ch12[95]), // Templated
                                     // Inputs
                                     .i_channel_id      (C3_AVMM_AIB12_ID), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[13]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch13[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[13]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[12]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[12]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[844:780]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[519:480]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[12]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[12]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1013:936]),
                                     .o_tx_elane_data    (o_tx_elane_data[1013:936]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[12]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[12][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[13]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[13]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[13]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[13]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[13]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[13]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[13]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[13]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[13]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch13[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_13 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[13]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[13]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[13]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch13[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[13]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[13]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[13]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch13[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch13[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[13]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[13]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch13[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[13]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[853:793]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[13]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[13]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[559:520]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[13]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[13]),
                                     .ms_sideband        (ms_sideband[1133:1053]),
                                     .sl_sideband        (sl_sideband[1021:949]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[13]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[13]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[13]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[13]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[13]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[13][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[13][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[13]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[13]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[13]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[13]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[13]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[13]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[13]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[13]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[13]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[13]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[13]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[13]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[13]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[13]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[13]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[13]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[13]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[13]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[13]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[13]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[13]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch13[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch13[0]), // Templated
                                     .io_aib1           (io_aib_ch13[1]), // Templated
                                     .io_aib10          (io_aib_ch13[10]), // Templated
                                     .io_aib11          (io_aib_ch13[11]), // Templated
                                     .io_aib12          (io_aib_ch13[12]), // Templated
                                     .io_aib13          (io_aib_ch13[13]), // Templated
                                     .io_aib14          (io_aib_ch13[14]), // Templated
                                     .io_aib15          (io_aib_ch13[15]), // Templated
                                     .io_aib16          (io_aib_ch13[16]), // Templated
                                     .io_aib17          (io_aib_ch13[17]), // Templated
                                     .io_aib18          (io_aib_ch13[18]), // Templated
                                     .io_aib19          (io_aib_ch13[19]), // Templated
                                     .io_aib2           (io_aib_ch13[2]), // Templated
                                     .io_aib20          (io_aib_ch13[20]), // Templated
                                     .io_aib21          (io_aib_ch13[21]), // Templated
                                     .io_aib22          (io_aib_ch13[22]), // Templated
                                     .io_aib23          (io_aib_ch13[23]), // Templated
                                     .io_aib24          (io_aib_ch13[24]), // Templated
                                     .io_aib25          (io_aib_ch13[25]), // Templated
                                     .io_aib26          (io_aib_ch13[26]), // Templated
                                     .io_aib27          (io_aib_ch13[27]), // Templated
                                     .io_aib28          (io_aib_ch13[28]), // Templated
                                     .io_aib29          (io_aib_ch13[29]), // Templated
                                     .io_aib3           (io_aib_ch13[3]), // Templated
                                     .io_aib30          (io_aib_ch13[30]), // Templated
                                     .io_aib31          (io_aib_ch13[31]), // Templated
                                     .io_aib32          (io_aib_ch13[32]), // Templated
                                     .io_aib33          (io_aib_ch13[33]), // Templated
                                     .io_aib34          (io_aib_ch13[34]), // Templated
                                     .io_aib35          (io_aib_ch13[35]), // Templated
                                     .io_aib36          (io_aib_ch13[36]), // Templated
                                     .io_aib37          (io_aib_ch13[37]), // Templated
                                     .io_aib38          (io_aib_ch13[38]), // Templated
                                     .io_aib39          (io_aib_ch13[39]), // Templated
                                     .io_aib4           (io_aib_ch13[4]), // Templated
                                     .io_aib40          (io_aib_ch13[40]), // Templated
                                     .io_aib41          (io_aib_ch13[41]), // Templated
                                     .io_aib42          (io_aib_ch13[42]), // Templated
                                     .io_aib43          (io_aib_ch13[43]), // Templated
                                     .io_aib44          (io_aib_ch13[44]), // Templated
                                     .io_aib45          (io_aib_ch13[45]), // Templated
                                     .io_aib46          (io_aib_ch13[46]), // Templated
                                     .io_aib47          (io_aib_ch13[47]), // Templated
                                     .io_aib48          (io_aib_ch13[48]), // Templated
                                     .io_aib49          (io_aib_ch13[49]), // Templated
                                     .io_aib5           (io_aib_ch13[5]), // Templated
                                     .io_aib50          (io_aib_ch13[50]), // Templated
                                     .io_aib51          (io_aib_ch13[51]), // Templated
                                     .io_aib52          (io_aib_ch13[52]), // Templated
                                     .io_aib53          (io_aib_ch13[53]), // Templated
                                     .io_aib54          (io_aib_ch13[54]), // Templated
                                     .io_aib55          (io_aib_ch13[55]), // Templated
                                     .io_aib56          (io_aib_ch13[56]), // Templated
                                     .io_aib57          (io_aib_ch13[57]), // Templated
                                     .io_aib58          (io_aib_ch13[58]), // Templated
                                     .io_aib59          (io_aib_ch13[59]), // Templated
                                     .io_aib6           (io_aib_ch13[6]), // Templated
                                     .io_aib60          (io_aib_ch13[60]), // Templated
                                     .io_aib61          (io_aib_ch13[61]), // Templated
                                     .io_aib62          (io_aib_ch13[62]), // Templated
                                     .io_aib63          (io_aib_ch13[63]), // Templated
                                     .io_aib64          (io_aib_ch13[64]), // Templated
                                     .io_aib65          (io_aib_ch13[65]), // Templated
                                     .io_aib66          (io_aib_ch13[66]), // Templated
                                     .io_aib67          (io_aib_ch13[67]), // Templated
                                     .io_aib68          (io_aib_ch13[68]), // Templated
                                     .io_aib69          (io_aib_ch13[69]), // Templated
                                     .io_aib7           (io_aib_ch13[7]), // Templated
                                     .io_aib70          (io_aib_ch13[70]), // Templated
                                     .io_aib71          (io_aib_ch13[71]), // Templated
                                     .io_aib72          (io_aib_ch13[72]), // Templated
                                     .io_aib73          (io_aib_ch13[73]), // Templated
                                     .io_aib74          (io_aib_ch13[74]), // Templated
                                     .io_aib75          (io_aib_ch13[75]), // Templated
                                     .io_aib76          (io_aib_ch13[76]), // Templated
                                     .io_aib77          (io_aib_ch13[77]), // Templated
                                     .io_aib78          (io_aib_ch13[78]), // Templated
                                     .io_aib79          (io_aib_ch13[79]), // Templated
                                     .io_aib8           (io_aib_ch13[8]), // Templated
                                     .io_aib80          (io_aib_ch13[80]), // Templated
                                     .io_aib81          (io_aib_ch13[81]), // Templated
                                     .io_aib82          (io_aib_ch13[82]), // Templated
                                     .io_aib83          (io_aib_ch13[83]), // Templated
                                     .io_aib84          (io_aib_ch13[84]), // Templated
                                     .io_aib85          (io_aib_ch13[85]), // Templated
                                     .io_aib86          (io_aib_ch13[86]), // Templated
                                     .io_aib87          (io_aib_ch13[87]), // Templated
                                     .io_aib88          (io_aib_ch13[88]), // Templated
                                     .io_aib89          (io_aib_ch13[89]), // Templated
                                     .io_aib9           (io_aib_ch13[9]), // Templated
                                     .io_aib90          (io_aib_ch13[90]), // Templated
                                     .io_aib91          (io_aib_ch13[91]), // Templated
                                     .io_aib92          (io_aib_ch13[92]), // Templated
                                     .io_aib93          (io_aib_ch13[93]), // Templated
                                     .io_aib94          (io_aib_ch13[94]), // Templated
                                     .io_aib95          (io_aib_ch13[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[12]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB13_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[12]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[12]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch12[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch12[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[12]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[12]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch12[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[14]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch14[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[14]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[13]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[13]), // Templated
                                     .i_osc_clk         (aib_osc_clk[12]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[909:845]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[559:520]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[13]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[13]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1091:1014]),
                                     .o_tx_elane_data    (o_tx_elane_data[1091:1014]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[13]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[13][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[12]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[12]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[12]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[12]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[12]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[12]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[12]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[12]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[12]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[12]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[14]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[12]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[12]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[14]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[14]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[14]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[14]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[14]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[14]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[14]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[14]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch14[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_14 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[14]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[14]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[14]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch14[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[14]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[14]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[14]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch14[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch14[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[14]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[14]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch14[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[14]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[914:854]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[14]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[14]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[599:560]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[14]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[14]),
                                     .ms_sideband        (ms_sideband[1214:1134]),
                                     .sl_sideband        (sl_sideband[1094:1022]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[14]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[14]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[14]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[14]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[14]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[14][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[14][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[14]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[14]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[14]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[14]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[14]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[14]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[14]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[14]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[14]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[14]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[14]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[14]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[14]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[14]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[14]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[14]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[14]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[14]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[14]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[14]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[14]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch14[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch14[0]), // Templated
                                     .io_aib1           (io_aib_ch14[1]), // Templated
                                     .io_aib10          (io_aib_ch14[10]), // Templated
                                     .io_aib11          (io_aib_ch14[11]), // Templated
                                     .io_aib12          (io_aib_ch14[12]), // Templated
                                     .io_aib13          (io_aib_ch14[13]), // Templated
                                     .io_aib14          (io_aib_ch14[14]), // Templated
                                     .io_aib15          (io_aib_ch14[15]), // Templated
                                     .io_aib16          (io_aib_ch14[16]), // Templated
                                     .io_aib17          (io_aib_ch14[17]), // Templated
                                     .io_aib18          (io_aib_ch14[18]), // Templated
                                     .io_aib19          (io_aib_ch14[19]), // Templated
                                     .io_aib2           (io_aib_ch14[2]), // Templated
                                     .io_aib20          (io_aib_ch14[20]), // Templated
                                     .io_aib21          (io_aib_ch14[21]), // Templated
                                     .io_aib22          (io_aib_ch14[22]), // Templated
                                     .io_aib23          (io_aib_ch14[23]), // Templated
                                     .io_aib24          (io_aib_ch14[24]), // Templated
                                     .io_aib25          (io_aib_ch14[25]), // Templated
                                     .io_aib26          (io_aib_ch14[26]), // Templated
                                     .io_aib27          (io_aib_ch14[27]), // Templated
                                     .io_aib28          (io_aib_ch14[28]), // Templated
                                     .io_aib29          (io_aib_ch14[29]), // Templated
                                     .io_aib3           (io_aib_ch14[3]), // Templated
                                     .io_aib30          (io_aib_ch14[30]), // Templated
                                     .io_aib31          (io_aib_ch14[31]), // Templated
                                     .io_aib32          (io_aib_ch14[32]), // Templated
                                     .io_aib33          (io_aib_ch14[33]), // Templated
                                     .io_aib34          (io_aib_ch14[34]), // Templated
                                     .io_aib35          (io_aib_ch14[35]), // Templated
                                     .io_aib36          (io_aib_ch14[36]), // Templated
                                     .io_aib37          (io_aib_ch14[37]), // Templated
                                     .io_aib38          (io_aib_ch14[38]), // Templated
                                     .io_aib39          (io_aib_ch14[39]), // Templated
                                     .io_aib4           (io_aib_ch14[4]), // Templated
                                     .io_aib40          (io_aib_ch14[40]), // Templated
                                     .io_aib41          (io_aib_ch14[41]), // Templated
                                     .io_aib42          (io_aib_ch14[42]), // Templated
                                     .io_aib43          (io_aib_ch14[43]), // Templated
                                     .io_aib44          (io_aib_ch14[44]), // Templated
                                     .io_aib45          (io_aib_ch14[45]), // Templated
                                     .io_aib46          (io_aib_ch14[46]), // Templated
                                     .io_aib47          (io_aib_ch14[47]), // Templated
                                     .io_aib48          (io_aib_ch14[48]), // Templated
                                     .io_aib49          (io_aib_ch14[49]), // Templated
                                     .io_aib5           (io_aib_ch14[5]), // Templated
                                     .io_aib50          (io_aib_ch14[50]), // Templated
                                     .io_aib51          (io_aib_ch14[51]), // Templated
                                     .io_aib52          (io_aib_ch14[52]), // Templated
                                     .io_aib53          (io_aib_ch14[53]), // Templated
                                     .io_aib54          (io_aib_ch14[54]), // Templated
                                     .io_aib55          (io_aib_ch14[55]), // Templated
                                     .io_aib56          (io_aib_ch14[56]), // Templated
                                     .io_aib57          (io_aib_ch14[57]), // Templated
                                     .io_aib58          (io_aib_ch14[58]), // Templated
                                     .io_aib59          (io_aib_ch14[59]), // Templated
                                     .io_aib6           (io_aib_ch14[6]), // Templated
                                     .io_aib60          (io_aib_ch14[60]), // Templated
                                     .io_aib61          (io_aib_ch14[61]), // Templated
                                     .io_aib62          (io_aib_ch14[62]), // Templated
                                     .io_aib63          (io_aib_ch14[63]), // Templated
                                     .io_aib64          (io_aib_ch14[64]), // Templated
                                     .io_aib65          (io_aib_ch14[65]), // Templated
                                     .io_aib66          (io_aib_ch14[66]), // Templated
                                     .io_aib67          (io_aib_ch14[67]), // Templated
                                     .io_aib68          (io_aib_ch14[68]), // Templated
                                     .io_aib69          (io_aib_ch14[69]), // Templated
                                     .io_aib7           (io_aib_ch14[7]), // Templated
                                     .io_aib70          (io_aib_ch14[70]), // Templated
                                     .io_aib71          (io_aib_ch14[71]), // Templated
                                     .io_aib72          (io_aib_ch14[72]), // Templated
                                     .io_aib73          (io_aib_ch14[73]), // Templated
                                     .io_aib74          (io_aib_ch14[74]), // Templated
                                     .io_aib75          (io_aib_ch14[75]), // Templated
                                     .io_aib76          (io_aib_ch14[76]), // Templated
                                     .io_aib77          (io_aib_ch14[77]), // Templated
                                     .io_aib78          (io_aib_ch14[78]), // Templated
                                     .io_aib79          (io_aib_ch14[79]), // Templated
                                     .io_aib8           (io_aib_ch14[8]), // Templated
                                     .io_aib80          (io_aib_ch14[80]), // Templated
                                     .io_aib81          (io_aib_ch14[81]), // Templated
                                     .io_aib82          (io_aib_ch14[82]), // Templated
                                     .io_aib83          (io_aib_ch14[83]), // Templated
                                     .io_aib84          (io_aib_ch14[84]), // Templated
                                     .io_aib85          (io_aib_ch14[85]), // Templated
                                     .io_aib86          (io_aib_ch14[86]), // Templated
                                     .io_aib87          (io_aib_ch14[87]), // Templated
                                     .io_aib88          (io_aib_ch14[88]), // Templated
                                     .io_aib89          (io_aib_ch14[89]), // Templated
                                     .io_aib9           (io_aib_ch14[9]), // Templated
                                     .io_aib90          (io_aib_ch14[90]), // Templated
                                     .io_aib91          (io_aib_ch14[91]), // Templated
                                     .io_aib92          (io_aib_ch14[92]), // Templated
                                     .io_aib93          (io_aib_ch14[93]), // Templated
                                     .io_aib94          (io_aib_ch14[94]), // Templated
                                     .io_aib95          (io_aib_ch14[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[13]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB14_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[13]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[13]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch13[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch13[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[13]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[13]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch13[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[15]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch15[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[15]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[14]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[14]), // Templated
                                     .i_osc_clk         (aib_osc_clk[13]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[974:910]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[599:560]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[14]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[14]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1169:1092]),
                                     .o_tx_elane_data    (o_tx_elane_data[1169:1092]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[14]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[14][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[13]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[13]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[13]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[13]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[13]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[13]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[13]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[13]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[13]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[13]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[15]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[13]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[13]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[15]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[15]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[15]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[15]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[15]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[15]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[15]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[15]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch15[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_15 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[15]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[15]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[15]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch15[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[15]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[15]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[15]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch15[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch15[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[15]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[15]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch15[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[15]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[975:915]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[15]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[15]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[639:600]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[15]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[15]),
                                     .ms_sideband        (ms_sideband[1295:1215]),
                                     .sl_sideband        (sl_sideband[1167:1095]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[15]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[15]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[15]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[15]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[15]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[15][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[15][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[15]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[15]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[15]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[15]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[15]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[15]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[15]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[15]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[15]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[15]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[15]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[15]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[15]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[15]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[15]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[15]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[15]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[15]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[15]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[15]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[15]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch15[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch15[0]), // Templated
                                     .io_aib1           (io_aib_ch15[1]), // Templated
                                     .io_aib10          (io_aib_ch15[10]), // Templated
                                     .io_aib11          (io_aib_ch15[11]), // Templated
                                     .io_aib12          (io_aib_ch15[12]), // Templated
                                     .io_aib13          (io_aib_ch15[13]), // Templated
                                     .io_aib14          (io_aib_ch15[14]), // Templated
                                     .io_aib15          (io_aib_ch15[15]), // Templated
                                     .io_aib16          (io_aib_ch15[16]), // Templated
                                     .io_aib17          (io_aib_ch15[17]), // Templated
                                     .io_aib18          (io_aib_ch15[18]), // Templated
                                     .io_aib19          (io_aib_ch15[19]), // Templated
                                     .io_aib2           (io_aib_ch15[2]), // Templated
                                     .io_aib20          (io_aib_ch15[20]), // Templated
                                     .io_aib21          (io_aib_ch15[21]), // Templated
                                     .io_aib22          (io_aib_ch15[22]), // Templated
                                     .io_aib23          (io_aib_ch15[23]), // Templated
                                     .io_aib24          (io_aib_ch15[24]), // Templated
                                     .io_aib25          (io_aib_ch15[25]), // Templated
                                     .io_aib26          (io_aib_ch15[26]), // Templated
                                     .io_aib27          (io_aib_ch15[27]), // Templated
                                     .io_aib28          (io_aib_ch15[28]), // Templated
                                     .io_aib29          (io_aib_ch15[29]), // Templated
                                     .io_aib3           (io_aib_ch15[3]), // Templated
                                     .io_aib30          (io_aib_ch15[30]), // Templated
                                     .io_aib31          (io_aib_ch15[31]), // Templated
                                     .io_aib32          (io_aib_ch15[32]), // Templated
                                     .io_aib33          (io_aib_ch15[33]), // Templated
                                     .io_aib34          (io_aib_ch15[34]), // Templated
                                     .io_aib35          (io_aib_ch15[35]), // Templated
                                     .io_aib36          (io_aib_ch15[36]), // Templated
                                     .io_aib37          (io_aib_ch15[37]), // Templated
                                     .io_aib38          (io_aib_ch15[38]), // Templated
                                     .io_aib39          (io_aib_ch15[39]), // Templated
                                     .io_aib4           (io_aib_ch15[4]), // Templated
                                     .io_aib40          (io_aib_ch15[40]), // Templated
                                     .io_aib41          (io_aib_ch15[41]), // Templated
                                     .io_aib42          (io_aib_ch15[42]), // Templated
                                     .io_aib43          (io_aib_ch15[43]), // Templated
                                     .io_aib44          (io_aib_ch15[44]), // Templated
                                     .io_aib45          (io_aib_ch15[45]), // Templated
                                     .io_aib46          (io_aib_ch15[46]), // Templated
                                     .io_aib47          (io_aib_ch15[47]), // Templated
                                     .io_aib48          (io_aib_ch15[48]), // Templated
                                     .io_aib49          (io_aib_ch15[49]), // Templated
                                     .io_aib5           (io_aib_ch15[5]), // Templated
                                     .io_aib50          (io_aib_ch15[50]), // Templated
                                     .io_aib51          (io_aib_ch15[51]), // Templated
                                     .io_aib52          (io_aib_ch15[52]), // Templated
                                     .io_aib53          (io_aib_ch15[53]), // Templated
                                     .io_aib54          (io_aib_ch15[54]), // Templated
                                     .io_aib55          (io_aib_ch15[55]), // Templated
                                     .io_aib56          (io_aib_ch15[56]), // Templated
                                     .io_aib57          (io_aib_ch15[57]), // Templated
                                     .io_aib58          (io_aib_ch15[58]), // Templated
                                     .io_aib59          (io_aib_ch15[59]), // Templated
                                     .io_aib6           (io_aib_ch15[6]), // Templated
                                     .io_aib60          (io_aib_ch15[60]), // Templated
                                     .io_aib61          (io_aib_ch15[61]), // Templated
                                     .io_aib62          (io_aib_ch15[62]), // Templated
                                     .io_aib63          (io_aib_ch15[63]), // Templated
                                     .io_aib64          (io_aib_ch15[64]), // Templated
                                     .io_aib65          (io_aib_ch15[65]), // Templated
                                     .io_aib66          (io_aib_ch15[66]), // Templated
                                     .io_aib67          (io_aib_ch15[67]), // Templated
                                     .io_aib68          (io_aib_ch15[68]), // Templated
                                     .io_aib69          (io_aib_ch15[69]), // Templated
                                     .io_aib7           (io_aib_ch15[7]), // Templated
                                     .io_aib70          (io_aib_ch15[70]), // Templated
                                     .io_aib71          (io_aib_ch15[71]), // Templated
                                     .io_aib72          (io_aib_ch15[72]), // Templated
                                     .io_aib73          (io_aib_ch15[73]), // Templated
                                     .io_aib74          (io_aib_ch15[74]), // Templated
                                     .io_aib75          (io_aib_ch15[75]), // Templated
                                     .io_aib76          (io_aib_ch15[76]), // Templated
                                     .io_aib77          (io_aib_ch15[77]), // Templated
                                     .io_aib78          (io_aib_ch15[78]), // Templated
                                     .io_aib79          (io_aib_ch15[79]), // Templated
                                     .io_aib8           (io_aib_ch15[8]), // Templated
                                     .io_aib80          (io_aib_ch15[80]), // Templated
                                     .io_aib81          (io_aib_ch15[81]), // Templated
                                     .io_aib82          (io_aib_ch15[82]), // Templated
                                     .io_aib83          (io_aib_ch15[83]), // Templated
                                     .io_aib84          (io_aib_ch15[84]), // Templated
                                     .io_aib85          (io_aib_ch15[85]), // Templated
                                     .io_aib86          (io_aib_ch15[86]), // Templated
                                     .io_aib87          (io_aib_ch15[87]), // Templated
                                     .io_aib88          (io_aib_ch15[88]), // Templated
                                     .io_aib89          (io_aib_ch15[89]), // Templated
                                     .io_aib9           (io_aib_ch15[9]), // Templated
                                     .io_aib90          (io_aib_ch15[90]), // Templated
                                     .io_aib91          (io_aib_ch15[91]), // Templated
                                     .io_aib92          (io_aib_ch15[92]), // Templated
                                     .io_aib93          (io_aib_ch15[93]), // Templated
                                     .io_aib94          (io_aib_ch15[94]), // Templated
                                     .io_aib95          (io_aib_ch15[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[14]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB15_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[14]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[14]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch14[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch14[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[14]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[14]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch14[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[16]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch16[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[16]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[15]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[15]), // Templated
                                     .i_osc_clk         (aib_osc_clk[14]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1039:975]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[639:600]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[15]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[15]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1247:1170]),
                                     .o_tx_elane_data    (o_tx_elane_data[1247:1170]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[15]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[15][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[14]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[14]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[14]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[14]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[14]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[14]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[14]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[14]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[14]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[14]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[16]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[14]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[14]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[16]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[16]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[16]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[16]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[16]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[16]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[16]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[16]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch16[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_16 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[16]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[16]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[16]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch16[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[16]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[16]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[16]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch16[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch16[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[16]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[16]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch16[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[16]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1036:976]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[16]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[16]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[679:640]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[16]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[16]),
                                     .ms_sideband        (ms_sideband[1376:1296]),
                                     .sl_sideband        (sl_sideband[1240:1168]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[16]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[16]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[16]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[16]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[16]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[16][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[16][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[16]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[16]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[16]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[16]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[16]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[16]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[16]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[16]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[16]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[16]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[16]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[16]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[16]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[16]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[16]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[16]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[16]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[16]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[16]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[16]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[16]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch16[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch16[0]), // Templated
                                     .io_aib1           (io_aib_ch16[1]), // Templated
                                     .io_aib10          (io_aib_ch16[10]), // Templated
                                     .io_aib11          (io_aib_ch16[11]), // Templated
                                     .io_aib12          (io_aib_ch16[12]), // Templated
                                     .io_aib13          (io_aib_ch16[13]), // Templated
                                     .io_aib14          (io_aib_ch16[14]), // Templated
                                     .io_aib15          (io_aib_ch16[15]), // Templated
                                     .io_aib16          (io_aib_ch16[16]), // Templated
                                     .io_aib17          (io_aib_ch16[17]), // Templated
                                     .io_aib18          (io_aib_ch16[18]), // Templated
                                     .io_aib19          (io_aib_ch16[19]), // Templated
                                     .io_aib2           (io_aib_ch16[2]), // Templated
                                     .io_aib20          (io_aib_ch16[20]), // Templated
                                     .io_aib21          (io_aib_ch16[21]), // Templated
                                     .io_aib22          (io_aib_ch16[22]), // Templated
                                     .io_aib23          (io_aib_ch16[23]), // Templated
                                     .io_aib24          (io_aib_ch16[24]), // Templated
                                     .io_aib25          (io_aib_ch16[25]), // Templated
                                     .io_aib26          (io_aib_ch16[26]), // Templated
                                     .io_aib27          (io_aib_ch16[27]), // Templated
                                     .io_aib28          (io_aib_ch16[28]), // Templated
                                     .io_aib29          (io_aib_ch16[29]), // Templated
                                     .io_aib3           (io_aib_ch16[3]), // Templated
                                     .io_aib30          (io_aib_ch16[30]), // Templated
                                     .io_aib31          (io_aib_ch16[31]), // Templated
                                     .io_aib32          (io_aib_ch16[32]), // Templated
                                     .io_aib33          (io_aib_ch16[33]), // Templated
                                     .io_aib34          (io_aib_ch16[34]), // Templated
                                     .io_aib35          (io_aib_ch16[35]), // Templated
                                     .io_aib36          (io_aib_ch16[36]), // Templated
                                     .io_aib37          (io_aib_ch16[37]), // Templated
                                     .io_aib38          (io_aib_ch16[38]), // Templated
                                     .io_aib39          (io_aib_ch16[39]), // Templated
                                     .io_aib4           (io_aib_ch16[4]), // Templated
                                     .io_aib40          (io_aib_ch16[40]), // Templated
                                     .io_aib41          (io_aib_ch16[41]), // Templated
                                     .io_aib42          (io_aib_ch16[42]), // Templated
                                     .io_aib43          (io_aib_ch16[43]), // Templated
                                     .io_aib44          (io_aib_ch16[44]), // Templated
                                     .io_aib45          (io_aib_ch16[45]), // Templated
                                     .io_aib46          (io_aib_ch16[46]), // Templated
                                     .io_aib47          (io_aib_ch16[47]), // Templated
                                     .io_aib48          (io_aib_ch16[48]), // Templated
                                     .io_aib49          (io_aib_ch16[49]), // Templated
                                     .io_aib5           (io_aib_ch16[5]), // Templated
                                     .io_aib50          (io_aib_ch16[50]), // Templated
                                     .io_aib51          (io_aib_ch16[51]), // Templated
                                     .io_aib52          (io_aib_ch16[52]), // Templated
                                     .io_aib53          (io_aib_ch16[53]), // Templated
                                     .io_aib54          (io_aib_ch16[54]), // Templated
                                     .io_aib55          (io_aib_ch16[55]), // Templated
                                     .io_aib56          (io_aib_ch16[56]), // Templated
                                     .io_aib57          (io_aib_ch16[57]), // Templated
                                     .io_aib58          (io_aib_ch16[58]), // Templated
                                     .io_aib59          (io_aib_ch16[59]), // Templated
                                     .io_aib6           (io_aib_ch16[6]), // Templated
                                     .io_aib60          (io_aib_ch16[60]), // Templated
                                     .io_aib61          (io_aib_ch16[61]), // Templated
                                     .io_aib62          (io_aib_ch16[62]), // Templated
                                     .io_aib63          (io_aib_ch16[63]), // Templated
                                     .io_aib64          (io_aib_ch16[64]), // Templated
                                     .io_aib65          (io_aib_ch16[65]), // Templated
                                     .io_aib66          (io_aib_ch16[66]), // Templated
                                     .io_aib67          (io_aib_ch16[67]), // Templated
                                     .io_aib68          (io_aib_ch16[68]), // Templated
                                     .io_aib69          (io_aib_ch16[69]), // Templated
                                     .io_aib7           (io_aib_ch16[7]), // Templated
                                     .io_aib70          (io_aib_ch16[70]), // Templated
                                     .io_aib71          (io_aib_ch16[71]), // Templated
                                     .io_aib72          (io_aib_ch16[72]), // Templated
                                     .io_aib73          (io_aib_ch16[73]), // Templated
                                     .io_aib74          (io_aib_ch16[74]), // Templated
                                     .io_aib75          (io_aib_ch16[75]), // Templated
                                     .io_aib76          (io_aib_ch16[76]), // Templated
                                     .io_aib77          (io_aib_ch16[77]), // Templated
                                     .io_aib78          (io_aib_ch16[78]), // Templated
                                     .io_aib79          (io_aib_ch16[79]), // Templated
                                     .io_aib8           (io_aib_ch16[8]), // Templated
                                     .io_aib80          (io_aib_ch16[80]), // Templated
                                     .io_aib81          (io_aib_ch16[81]), // Templated
                                     .io_aib82          (io_aib_ch16[82]), // Templated
                                     .io_aib83          (io_aib_ch16[83]), // Templated
                                     .io_aib84          (io_aib_ch16[84]), // Templated
                                     .io_aib85          (io_aib_ch16[85]), // Templated
                                     .io_aib86          (io_aib_ch16[86]), // Templated
                                     .io_aib87          (io_aib_ch16[87]), // Templated
                                     .io_aib88          (io_aib_ch16[88]), // Templated
                                     .io_aib89          (io_aib_ch16[89]), // Templated
                                     .io_aib9           (io_aib_ch16[9]), // Templated
                                     .io_aib90          (io_aib_ch16[90]), // Templated
                                     .io_aib91          (io_aib_ch16[91]), // Templated
                                     .io_aib92          (io_aib_ch16[92]), // Templated
                                     .io_aib93          (io_aib_ch16[93]), // Templated
                                     .io_aib94          (io_aib_ch16[94]), // Templated
                                     .io_aib95          (io_aib_ch16[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[15]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB16_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[15]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[15]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch15[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch15[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[15]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[15]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch15[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[17]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch17[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[17]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[16]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[16]), // Templated
                                     .i_osc_clk         (aib_osc_clk[15]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1104:1040]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[679:640]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[16]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[16]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1325:1248]),
                                     .o_tx_elane_data    (o_tx_elane_data[1325:1248]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[16]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[16][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[15]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[15]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[15]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[15]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[15]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[15]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[15]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[15]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[15]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[15]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[17]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[15]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[15]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[17]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[17]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[17]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[17]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[17]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[17]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[17]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[17]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch17[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_17 (
                                     .i_adpt_cfg_rdatavld(chnl_aib_cfg_avmm_rdatavld[2]), 
                                     .i_adpt_cfg_rdata   (chnl_aib_cfg_avmm_rdata_2[31:0]),
                                     .i_adpt_cfg_waitreq (chnl_aib_cfg_avmm_waitreq[2]), 
                                     .i_jtag_last_bs_chain_in(chnl_aib_jtag_last_bs_chain_out[2]),
                                     .i_red_idataselb_in_chain1(chnl_aib_red_idataselb_chain1[2]), 
                                     .i_red_idataselb_in_chain2(chnl_aib_red_idataselb_chain2[2]), 
                                     .i_red_shift_en_in_chain1(chnl_aib_red_shift_en_chain1[2]), 
                                     .i_red_shift_en_in_chain2(chnl_aib_red_shift_en_chain2[2]), 
                                     .i_txen_in_chain1   (chnl_aib_txen_chain1[2]), 
                                     .i_txen_in_chain2   (chnl_aib_txen_chain2[2]), 
                                     .i_directout_data_chain1_in(chnl_aib_directout_data_chain1_out[2]), 
                                     .i_directout_data_chain2_in(chnl_aib_directout_data_chain2_out[2]), 
                                     .i_aibdftdll2adjch  (chnl_aib_dftdll2adjch_2[12:0]), 
                                     /*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[17]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[17]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[17]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch17[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[17]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[17]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[17]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch17[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch17[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[17]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[17]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch17[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[17]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1097:1037]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[17]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[17]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[719:680]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[17]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[17]),
                                     .ms_sideband        (ms_sideband[1457:1377]),
                                     .sl_sideband        (sl_sideband[1313:1241]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[17]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[17]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[17]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[17]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[17]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[17][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[17][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[17]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[17]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[17]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[17]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[17]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[17]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[17]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[17]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[17]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[17]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[17]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[17]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[17]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[17]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[17]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[17]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[17]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[17]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[17]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[17]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[17]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch17[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch17[0]), // Templated
                                     .io_aib1           (io_aib_ch17[1]), // Templated
                                     .io_aib10          (io_aib_ch17[10]), // Templated
                                     .io_aib11          (io_aib_ch17[11]), // Templated
                                     .io_aib12          (io_aib_ch17[12]), // Templated
                                     .io_aib13          (io_aib_ch17[13]), // Templated
                                     .io_aib14          (io_aib_ch17[14]), // Templated
                                     .io_aib15          (io_aib_ch17[15]), // Templated
                                     .io_aib16          (io_aib_ch17[16]), // Templated
                                     .io_aib17          (io_aib_ch17[17]), // Templated
                                     .io_aib18          (io_aib_ch17[18]), // Templated
                                     .io_aib19          (io_aib_ch17[19]), // Templated
                                     .io_aib2           (io_aib_ch17[2]), // Templated
                                     .io_aib20          (io_aib_ch17[20]), // Templated
                                     .io_aib21          (io_aib_ch17[21]), // Templated
                                     .io_aib22          (io_aib_ch17[22]), // Templated
                                     .io_aib23          (io_aib_ch17[23]), // Templated
                                     .io_aib24          (io_aib_ch17[24]), // Templated
                                     .io_aib25          (io_aib_ch17[25]), // Templated
                                     .io_aib26          (io_aib_ch17[26]), // Templated
                                     .io_aib27          (io_aib_ch17[27]), // Templated
                                     .io_aib28          (io_aib_ch17[28]), // Templated
                                     .io_aib29          (io_aib_ch17[29]), // Templated
                                     .io_aib3           (io_aib_ch17[3]), // Templated
                                     .io_aib30          (io_aib_ch17[30]), // Templated
                                     .io_aib31          (io_aib_ch17[31]), // Templated
                                     .io_aib32          (io_aib_ch17[32]), // Templated
                                     .io_aib33          (io_aib_ch17[33]), // Templated
                                     .io_aib34          (io_aib_ch17[34]), // Templated
                                     .io_aib35          (io_aib_ch17[35]), // Templated
                                     .io_aib36          (io_aib_ch17[36]), // Templated
                                     .io_aib37          (io_aib_ch17[37]), // Templated
                                     .io_aib38          (io_aib_ch17[38]), // Templated
                                     .io_aib39          (io_aib_ch17[39]), // Templated
                                     .io_aib4           (io_aib_ch17[4]), // Templated
                                     .io_aib40          (io_aib_ch17[40]), // Templated
                                     .io_aib41          (io_aib_ch17[41]), // Templated
                                     .io_aib42          (io_aib_ch17[42]), // Templated
                                     .io_aib43          (io_aib_ch17[43]), // Templated
                                     .io_aib44          (io_aib_ch17[44]), // Templated
                                     .io_aib45          (io_aib_ch17[45]), // Templated
                                     .io_aib46          (io_aib_ch17[46]), // Templated
                                     .io_aib47          (io_aib_ch17[47]), // Templated
                                     .io_aib48          (io_aib_ch17[48]), // Templated
                                     .io_aib49          (io_aib_ch17[49]), // Templated
                                     .io_aib5           (io_aib_ch17[5]), // Templated
                                     .io_aib50          (io_aib_ch17[50]), // Templated
                                     .io_aib51          (io_aib_ch17[51]), // Templated
                                     .io_aib52          (io_aib_ch17[52]), // Templated
                                     .io_aib53          (io_aib_ch17[53]), // Templated
                                     .io_aib54          (io_aib_ch17[54]), // Templated
                                     .io_aib55          (io_aib_ch17[55]), // Templated
                                     .io_aib56          (io_aib_ch17[56]), // Templated
                                     .io_aib57          (io_aib_ch17[57]), // Templated
                                     .io_aib58          (io_aib_ch17[58]), // Templated
                                     .io_aib59          (io_aib_ch17[59]), // Templated
                                     .io_aib6           (io_aib_ch17[6]), // Templated
                                     .io_aib60          (io_aib_ch17[60]), // Templated
                                     .io_aib61          (io_aib_ch17[61]), // Templated
                                     .io_aib62          (io_aib_ch17[62]), // Templated
                                     .io_aib63          (io_aib_ch17[63]), // Templated
                                     .io_aib64          (io_aib_ch17[64]), // Templated
                                     .io_aib65          (io_aib_ch17[65]), // Templated
                                     .io_aib66          (io_aib_ch17[66]), // Templated
                                     .io_aib67          (io_aib_ch17[67]), // Templated
                                     .io_aib68          (io_aib_ch17[68]), // Templated
                                     .io_aib69          (io_aib_ch17[69]), // Templated
                                     .io_aib7           (io_aib_ch17[7]), // Templated
                                     .io_aib70          (io_aib_ch17[70]), // Templated
                                     .io_aib71          (io_aib_ch17[71]), // Templated
                                     .io_aib72          (io_aib_ch17[72]), // Templated
                                     .io_aib73          (io_aib_ch17[73]), // Templated
                                     .io_aib74          (io_aib_ch17[74]), // Templated
                                     .io_aib75          (io_aib_ch17[75]), // Templated
                                     .io_aib76          (io_aib_ch17[76]), // Templated
                                     .io_aib77          (io_aib_ch17[77]), // Templated
                                     .io_aib78          (io_aib_ch17[78]), // Templated
                                     .io_aib79          (io_aib_ch17[79]), // Templated
                                     .io_aib8           (io_aib_ch17[8]), // Templated
                                     .io_aib80          (io_aib_ch17[80]), // Templated
                                     .io_aib81          (io_aib_ch17[81]), // Templated
                                     .io_aib82          (io_aib_ch17[82]), // Templated
                                     .io_aib83          (io_aib_ch17[83]), // Templated
                                     .io_aib84          (io_aib_ch17[84]), // Templated
                                     .io_aib85          (io_aib_ch17[85]), // Templated
                                     .io_aib86          (io_aib_ch17[86]), // Templated
                                     .io_aib87          (io_aib_ch17[87]), // Templated
                                     .io_aib88          (io_aib_ch17[88]), // Templated
                                     .io_aib89          (io_aib_ch17[89]), // Templated
                                     .io_aib9           (io_aib_ch17[9]), // Templated
                                     .io_aib90          (io_aib_ch17[90]), // Templated
                                     .io_aib91          (io_aib_ch17[91]), // Templated
                                     .io_aib92          (io_aib_ch17[92]), // Templated
                                     .io_aib93          (io_aib_ch17[93]), // Templated
                                     .io_aib94          (io_aib_ch17[94]), // Templated
                                     .io_aib95          (io_aib_ch17[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[16]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB17_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[16]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[16]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch16[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch16[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[16]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[16]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch16[31:0]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[17]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[17]), // Templated
                                     .i_osc_clk         (aib_osc_clk[16]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1169:1105]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[719:680]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[17]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[17]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1403:1326]),
                                     .o_tx_elane_data    (o_tx_elane_data[1403:1326]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[17]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[17][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[16]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[16]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[16]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[16]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[16]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[16]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[16]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[16]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[16]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[16]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[16]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[16])); // Templated

    c3routing_chnl_aib u_c3routing_chnl_2 (/*AUTOINST*/
                                           // Outputs
                                           .o_rdata             (chnl_aib_cfg_avmm_rdata_2[31:0]), // Templated
                                           .o_rdatavalid        (chnl_aib_cfg_avmm_rdatavld[2]), // Templated
                                           .o_waitreq           (chnl_aib_cfg_avmm_waitreq[2]), // Templated
                                           .o_clk               (chnl_aib_cfg_avmm_clk[2]), // Templated
                                           .o_rst_n             (chnl_aib_cfg_avmm_rst_n[2]), // Templated
                                           .o_addr              (chnl_aib_cfg_avmm_addr_2[16:0]), // Templated
                                           .o_byte_en           (chnl_aib_cfg_avmm_byte_en_2[3:0]), // Templated
                                           .o_read              (chnl_aib_cfg_avmm_read[2]), // Templated
                                           .o_write             (chnl_aib_cfg_avmm_write[2]), // Templated
                                           .o_wdata             (chnl_aib_cfg_avmm_wdata_2[31:0]), // Templated
                                           .o_adpt_hard_rst_n   (chnl_aib_adpt_hard_rst_n[2]), // Templated
                                           .o_red_idataselb_chain1(chnl_aib_red_idataselb_chain1[2]), // Templated
                                           .o_red_idataselb_chain2(chnl_aib_red_idataselb_chain2[2]), // Templated
                                           .o_red_shift_en_chain1(chnl_aib_red_shift_en_chain1[2]), // Templated
                                           .o_red_shift_en_chain2(chnl_aib_red_shift_en_chain2[2]), // Templated
                                           .o_txen_chain1       (chnl_aib_txen_chain1[2]), // Templated
                                           .o_txen_chain2       (chnl_aib_txen_chain2[2]), // Templated
                                           .o_osc_clk           (chnl_aib_osc_clk[2]), // Templated
                                           .o_aibdftdll2adjch   (chnl_aib_dftdll2adjch_2[12:0]), // Templated
                                           .o_vccl              (chnl_aib_vccl[2]), // Templated
                                           .o_vcchssi           (chnl_aib_vcchssi[2]), // Templated
                                           .o_jtag_last_bs_chain_out(chnl_aib_jtag_last_bs_chain_out[2]), // Templated
                                           .o_directout_data_chain1_out(chnl_aib_directout_data_chain1_out[2]), // Templated
                                           .o_directout_data_chain2_out(chnl_aib_directout_data_chain2_out[2]), // Templated
                                           .o_jtag_bs_chain_out (chnl_aib_jtag_bs_chain_out[2]), // Templated
                                           .o_jtag_bs_scanen_out(chnl_jtag_bs_scanen_out[2]), // Templated
                                           .o_jtag_clkdr_out    (chnl_jtag_clkdr_out[2]), // Templated
                                           .o_jtag_clksel_out   (chnl_jtag_clksel_out[2]), // Templated
                                           .o_jtag_intest_out   (chnl_jtag_intest_out[2]), // Templated
                                           .o_jtag_mode_out     (chnl_jtag_mode_out[2]), // Templated
                                           .o_jtag_rstb_en_out  (chnl_jtag_rstb_en_out[2]), // Templated
                                           .o_jtag_rstb_out     (chnl_jtag_rstb_out[2]), // Templated
                                           .o_jtag_weakpdn_out  (chnl_jtag_weakpdn_out[2]), // Templated
                                           .o_jtag_weakpu_out   (chnl_jtag_weakpu_out[2]), // Templated
                                           // Inputs
                                           .i_clk               (aib_cfg_avmm_clk[17]), // Templated
                                           .i_rst_n             (aib_cfg_avmm_rst_n[17]), // Templated
                                           .i_addr              (aib_cfg_avmm_addr_ch17[16:0]), // Templated
                                           .i_byte_en           (aib_cfg_avmm_byte_en_ch17[3:0]), // Templated
                                           .i_read              (aib_cfg_avmm_read[17]), // Templated
                                           .i_write             (aib_cfg_avmm_write[17]), // Templated
                                           .i_wdata             (aib_cfg_avmm_wdata_ch17[31:0]), // Templated
                                           .i_adpt_hard_rst_n   (aib_adpt_chnl_hard_rst_n[17]), // Templated
                                           .i_red_idataselb_chain1(aib_red_idataselb_chain1[18]), // Templated
                                           .i_red_idataselb_chain2(aib_red_idataselb_chain2[18]), // Templated
                                           .i_red_shift_en_chain1(aib_red_shift_en_chain1[18]), // Templated
                                           .i_red_shift_en_chain2(aib_red_shift_en_chain2[18]), // Templated
                                           .i_txen_chain1       (aib_txen_chain1[18]), // Templated
                                           .i_txen_chain2       (aib_txen_chain2[18]), // Templated
                                           .i_osc_clk           (aib_osc_clk[17]), // Templated
                                           .i_aibdftdll2adjch   (aib_dftdll2adjch_ch18[12:0]), // Templated
                                           .i_vccl              (aib_por_vccl[17]), // Templated
                                           .i_vcchssi           (aib_por_vcchssi[17]), // Templated
                                           .i_rdata             (aib_cfg_avmm_rdata_ch18[31:0]), // Templated
                                           .i_rdatavalid        (aib_cfg_avmm_rdatavld[18]), // Templated
                                           .i_waitreq           (aib_cfg_avmm_waitreq[18]), // Templated
                                           .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[18]), // Templated
                                           .i_directout_data_chain1_in(aib_directout_data_chain1_out[18]), // Templated
                                           .i_directout_data_chain2_in(aib_directout_data_chain2_out[18]), // Templated
                                           .i_jtag_bs_chain_in  (aib_jtag_bs_chain_out[17]), // Templated
                                           .i_jtag_bs_scanen_in (aib_jtag_bs_scanen_out[17]), // Templated
                                           .i_jtag_clkdr_in     (aib_jtag_clkdr_out[17]), // Templated
                                           .i_jtag_clksel_in    (aib_jtag_clksel_out[17]), // Templated
                                           .i_jtag_intest_in    (aib_jtag_intest_out[17]), // Templated
                                           .i_jtag_mode_in      (aib_jtag_mode_out[17]), // Templated
                                           .i_jtag_rstb_en_in   (aib_jtag_rstb_en_out[17]), // Templated
                                           .i_jtag_rstb_in      (aib_jtag_rstb_out[17]), // Templated
                                           .i_jtag_weakpdn_in   (aib_jtag_weakpdn_out[17]), // Templated
                                           .i_jtag_weakpu_in    (aib_jtag_weakpu_out[17])); // Templated
    
    c3aibadapt_wrap u_c3aibadapt_18 (
                                     .i_osc_clk          (chnl_aib_osc_clk[2]),
                                     .i_cfg_avmm_clk     (chnl_aib_cfg_avmm_clk[2]), 
                                     .i_cfg_avmm_rst_n   (chnl_aib_cfg_avmm_rst_n[2]), 
                                     .i_cfg_avmm_addr    (chnl_aib_cfg_avmm_addr_2[16:0]),
                                     .i_cfg_avmm_byte_en (chnl_aib_cfg_avmm_byte_en_2[3:0]),
                                     .i_cfg_avmm_read    (chnl_aib_cfg_avmm_read[2]), 
                                     .i_cfg_avmm_write   (chnl_aib_cfg_avmm_write[2]),
                                     .i_cfg_avmm_wdata   (chnl_aib_cfg_avmm_wdata_2[31:0]), 
                                     .i_adpt_hard_rst_n  (chnl_aib_adpt_hard_rst_n[2]), 
                                     .i_jtag_rstb_in     (chnl_jtag_rstb_out[2]), 
                                     .i_jtag_rstb_en_in  (chnl_jtag_rstb_en_out[2]),
                                     .i_jtag_clkdr_in    (chnl_jtag_clkdr_out[2]), 
                                     .i_jtag_clksel_in   (chnl_jtag_clksel_out[2]),
                                     .i_jtag_intest_in   (chnl_jtag_intest_out[2]),
                                     .i_jtag_mode_in     (chnl_jtag_mode_out[2]), 
                                     .i_jtag_weakpdn_in  (chnl_jtag_weakpdn_out[2]),
                                     .i_jtag_weakpu_in   (chnl_jtag_weakpu_out[2]),
                                     .i_jtag_bs_scanen_in(chnl_jtag_bs_scanen_out[2]),
                                     .i_jtag_bs_chain_in (chnl_aib_jtag_bs_chain_out[2]),
                                     .i_por_aib_vcchssi  (chnl_aib_vcchssi[2]),
                                     .i_por_aib_vccl     (chnl_aib_vccl[2]),
                                     /*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[18]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[18]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[18]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch18[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[18]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[18]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[18]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch18[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch18[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[18]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[18]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch18[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[18]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1158:1098]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[18]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[18]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[759:720]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[18]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[18]),
                                     .ms_sideband        (ms_sideband[1538:1458]),
                                     .sl_sideband        (sl_sideband[1386:1314]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[18]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[18]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[18]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[18]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[18]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[18][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[18][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[18]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[18]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[18]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[18]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[18]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[18]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[18]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[18]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[18]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[18]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[18]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[18]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[18]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[18]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[18]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[18]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[18]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[18]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[18]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[18]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[18]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch18[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch18[0]), // Templated
                                     .io_aib1           (io_aib_ch18[1]), // Templated
                                     .io_aib10          (io_aib_ch18[10]), // Templated
                                     .io_aib11          (io_aib_ch18[11]), // Templated
                                     .io_aib12          (io_aib_ch18[12]), // Templated
                                     .io_aib13          (io_aib_ch18[13]), // Templated
                                     .io_aib14          (io_aib_ch18[14]), // Templated
                                     .io_aib15          (io_aib_ch18[15]), // Templated
                                     .io_aib16          (io_aib_ch18[16]), // Templated
                                     .io_aib17          (io_aib_ch18[17]), // Templated
                                     .io_aib18          (io_aib_ch18[18]), // Templated
                                     .io_aib19          (io_aib_ch18[19]), // Templated
                                     .io_aib2           (io_aib_ch18[2]), // Templated
                                     .io_aib20          (io_aib_ch18[20]), // Templated
                                     .io_aib21          (io_aib_ch18[21]), // Templated
                                     .io_aib22          (io_aib_ch18[22]), // Templated
                                     .io_aib23          (io_aib_ch18[23]), // Templated
                                     .io_aib24          (io_aib_ch18[24]), // Templated
                                     .io_aib25          (io_aib_ch18[25]), // Templated
                                     .io_aib26          (io_aib_ch18[26]), // Templated
                                     .io_aib27          (io_aib_ch18[27]), // Templated
                                     .io_aib28          (io_aib_ch18[28]), // Templated
                                     .io_aib29          (io_aib_ch18[29]), // Templated
                                     .io_aib3           (io_aib_ch18[3]), // Templated
                                     .io_aib30          (io_aib_ch18[30]), // Templated
                                     .io_aib31          (io_aib_ch18[31]), // Templated
                                     .io_aib32          (io_aib_ch18[32]), // Templated
                                     .io_aib33          (io_aib_ch18[33]), // Templated
                                     .io_aib34          (io_aib_ch18[34]), // Templated
                                     .io_aib35          (io_aib_ch18[35]), // Templated
                                     .io_aib36          (io_aib_ch18[36]), // Templated
                                     .io_aib37          (io_aib_ch18[37]), // Templated
                                     .io_aib38          (io_aib_ch18[38]), // Templated
                                     .io_aib39          (io_aib_ch18[39]), // Templated
                                     .io_aib4           (io_aib_ch18[4]), // Templated
                                     .io_aib40          (io_aib_ch18[40]), // Templated
                                     .io_aib41          (io_aib_ch18[41]), // Templated
                                     .io_aib42          (io_aib_ch18[42]), // Templated
                                     .io_aib43          (io_aib_ch18[43]), // Templated
                                     .io_aib44          (io_aib_ch18[44]), // Templated
                                     .io_aib45          (io_aib_ch18[45]), // Templated
                                     .io_aib46          (io_aib_ch18[46]), // Templated
                                     .io_aib47          (io_aib_ch18[47]), // Templated
                                     .io_aib48          (io_aib_ch18[48]), // Templated
                                     .io_aib49          (io_aib_ch18[49]), // Templated
                                     .io_aib5           (io_aib_ch18[5]), // Templated
                                     .io_aib50          (io_aib_ch18[50]), // Templated
                                     .io_aib51          (io_aib_ch18[51]), // Templated
                                     .io_aib52          (io_aib_ch18[52]), // Templated
                                     .io_aib53          (io_aib_ch18[53]), // Templated
                                     .io_aib54          (io_aib_ch18[54]), // Templated
                                     .io_aib55          (io_aib_ch18[55]), // Templated
                                     .io_aib56          (io_aib_ch18[56]), // Templated
                                     .io_aib57          (io_aib_ch18[57]), // Templated
                                     .io_aib58          (io_aib_ch18[58]), // Templated
                                     .io_aib59          (io_aib_ch18[59]), // Templated
                                     .io_aib6           (io_aib_ch18[6]), // Templated
                                     .io_aib60          (io_aib_ch18[60]), // Templated
                                     .io_aib61          (io_aib_ch18[61]), // Templated
                                     .io_aib62          (io_aib_ch18[62]), // Templated
                                     .io_aib63          (io_aib_ch18[63]), // Templated
                                     .io_aib64          (io_aib_ch18[64]), // Templated
                                     .io_aib65          (io_aib_ch18[65]), // Templated
                                     .io_aib66          (io_aib_ch18[66]), // Templated
                                     .io_aib67          (io_aib_ch18[67]), // Templated
                                     .io_aib68          (io_aib_ch18[68]), // Templated
                                     .io_aib69          (io_aib_ch18[69]), // Templated
                                     .io_aib7           (io_aib_ch18[7]), // Templated
                                     .io_aib70          (io_aib_ch18[70]), // Templated
                                     .io_aib71          (io_aib_ch18[71]), // Templated
                                     .io_aib72          (io_aib_ch18[72]), // Templated
                                     .io_aib73          (io_aib_ch18[73]), // Templated
                                     .io_aib74          (io_aib_ch18[74]), // Templated
                                     .io_aib75          (io_aib_ch18[75]), // Templated
                                     .io_aib76          (io_aib_ch18[76]), // Templated
                                     .io_aib77          (io_aib_ch18[77]), // Templated
                                     .io_aib78          (io_aib_ch18[78]), // Templated
                                     .io_aib79          (io_aib_ch18[79]), // Templated
                                     .io_aib8           (io_aib_ch18[8]), // Templated
                                     .io_aib80          (io_aib_ch18[80]), // Templated
                                     .io_aib81          (io_aib_ch18[81]), // Templated
                                     .io_aib82          (io_aib_ch18[82]), // Templated
                                     .io_aib83          (io_aib_ch18[83]), // Templated
                                     .io_aib84          (io_aib_ch18[84]), // Templated
                                     .io_aib85          (io_aib_ch18[85]), // Templated
                                     .io_aib86          (io_aib_ch18[86]), // Templated
                                     .io_aib87          (io_aib_ch18[87]), // Templated
                                     .io_aib88          (io_aib_ch18[88]), // Templated
                                     .io_aib89          (io_aib_ch18[89]), // Templated
                                     .io_aib9           (io_aib_ch18[9]), // Templated
                                     .io_aib90          (io_aib_ch18[90]), // Templated
                                     .io_aib91          (io_aib_ch18[91]), // Templated
                                     .io_aib92          (io_aib_ch18[92]), // Templated
                                     .io_aib93          (io_aib_ch18[93]), // Templated
                                     .io_aib94          (io_aib_ch18[94]), // Templated
                                     .io_aib95          (io_aib_ch18[95]), // Templated
                                     // Inputs
                                     .i_channel_id      (C3_AVMM_AIB18_ID), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[19]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch19[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[19]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[18]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[18]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1234:1170]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[759:720]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[18]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[18]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1481:1404]),
                                     .o_tx_elane_data    (o_tx_elane_data[1481:1404]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[18]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[18][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[19]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[19]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[19]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[19]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[19]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[19]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[19]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[19]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[19]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch19[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_19 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[19]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[19]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[19]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch19[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[19]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[19]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[19]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch19[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch19[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[19]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[19]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch19[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[19]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1219:1159]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[19]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[19]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[799:760]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[19]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[19]),
                                     .ms_sideband        (ms_sideband[1619:1539]),
                                     .sl_sideband        (sl_sideband[1459:1387]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[19]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[19]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[19]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[19]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[19]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[19][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[19][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[19]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[19]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[19]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[19]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[19]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[19]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[19]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[19]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[19]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[19]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[19]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[19]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[19]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[19]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[19]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[19]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[19]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[19]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[19]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[19]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[19]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch19[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch19[0]), // Templated
                                     .io_aib1           (io_aib_ch19[1]), // Templated
                                     .io_aib10          (io_aib_ch19[10]), // Templated
                                     .io_aib11          (io_aib_ch19[11]), // Templated
                                     .io_aib12          (io_aib_ch19[12]), // Templated
                                     .io_aib13          (io_aib_ch19[13]), // Templated
                                     .io_aib14          (io_aib_ch19[14]), // Templated
                                     .io_aib15          (io_aib_ch19[15]), // Templated
                                     .io_aib16          (io_aib_ch19[16]), // Templated
                                     .io_aib17          (io_aib_ch19[17]), // Templated
                                     .io_aib18          (io_aib_ch19[18]), // Templated
                                     .io_aib19          (io_aib_ch19[19]), // Templated
                                     .io_aib2           (io_aib_ch19[2]), // Templated
                                     .io_aib20          (io_aib_ch19[20]), // Templated
                                     .io_aib21          (io_aib_ch19[21]), // Templated
                                     .io_aib22          (io_aib_ch19[22]), // Templated
                                     .io_aib23          (io_aib_ch19[23]), // Templated
                                     .io_aib24          (io_aib_ch19[24]), // Templated
                                     .io_aib25          (io_aib_ch19[25]), // Templated
                                     .io_aib26          (io_aib_ch19[26]), // Templated
                                     .io_aib27          (io_aib_ch19[27]), // Templated
                                     .io_aib28          (io_aib_ch19[28]), // Templated
                                     .io_aib29          (io_aib_ch19[29]), // Templated
                                     .io_aib3           (io_aib_ch19[3]), // Templated
                                     .io_aib30          (io_aib_ch19[30]), // Templated
                                     .io_aib31          (io_aib_ch19[31]), // Templated
                                     .io_aib32          (io_aib_ch19[32]), // Templated
                                     .io_aib33          (io_aib_ch19[33]), // Templated
                                     .io_aib34          (io_aib_ch19[34]), // Templated
                                     .io_aib35          (io_aib_ch19[35]), // Templated
                                     .io_aib36          (io_aib_ch19[36]), // Templated
                                     .io_aib37          (io_aib_ch19[37]), // Templated
                                     .io_aib38          (io_aib_ch19[38]), // Templated
                                     .io_aib39          (io_aib_ch19[39]), // Templated
                                     .io_aib4           (io_aib_ch19[4]), // Templated
                                     .io_aib40          (io_aib_ch19[40]), // Templated
                                     .io_aib41          (io_aib_ch19[41]), // Templated
                                     .io_aib42          (io_aib_ch19[42]), // Templated
                                     .io_aib43          (io_aib_ch19[43]), // Templated
                                     .io_aib44          (io_aib_ch19[44]), // Templated
                                     .io_aib45          (io_aib_ch19[45]), // Templated
                                     .io_aib46          (io_aib_ch19[46]), // Templated
                                     .io_aib47          (io_aib_ch19[47]), // Templated
                                     .io_aib48          (io_aib_ch19[48]), // Templated
                                     .io_aib49          (io_aib_ch19[49]), // Templated
                                     .io_aib5           (io_aib_ch19[5]), // Templated
                                     .io_aib50          (io_aib_ch19[50]), // Templated
                                     .io_aib51          (io_aib_ch19[51]), // Templated
                                     .io_aib52          (io_aib_ch19[52]), // Templated
                                     .io_aib53          (io_aib_ch19[53]), // Templated
                                     .io_aib54          (io_aib_ch19[54]), // Templated
                                     .io_aib55          (io_aib_ch19[55]), // Templated
                                     .io_aib56          (io_aib_ch19[56]), // Templated
                                     .io_aib57          (io_aib_ch19[57]), // Templated
                                     .io_aib58          (io_aib_ch19[58]), // Templated
                                     .io_aib59          (io_aib_ch19[59]), // Templated
                                     .io_aib6           (io_aib_ch19[6]), // Templated
                                     .io_aib60          (io_aib_ch19[60]), // Templated
                                     .io_aib61          (io_aib_ch19[61]), // Templated
                                     .io_aib62          (io_aib_ch19[62]), // Templated
                                     .io_aib63          (io_aib_ch19[63]), // Templated
                                     .io_aib64          (io_aib_ch19[64]), // Templated
                                     .io_aib65          (io_aib_ch19[65]), // Templated
                                     .io_aib66          (io_aib_ch19[66]), // Templated
                                     .io_aib67          (io_aib_ch19[67]), // Templated
                                     .io_aib68          (io_aib_ch19[68]), // Templated
                                     .io_aib69          (io_aib_ch19[69]), // Templated
                                     .io_aib7           (io_aib_ch19[7]), // Templated
                                     .io_aib70          (io_aib_ch19[70]), // Templated
                                     .io_aib71          (io_aib_ch19[71]), // Templated
                                     .io_aib72          (io_aib_ch19[72]), // Templated
                                     .io_aib73          (io_aib_ch19[73]), // Templated
                                     .io_aib74          (io_aib_ch19[74]), // Templated
                                     .io_aib75          (io_aib_ch19[75]), // Templated
                                     .io_aib76          (io_aib_ch19[76]), // Templated
                                     .io_aib77          (io_aib_ch19[77]), // Templated
                                     .io_aib78          (io_aib_ch19[78]), // Templated
                                     .io_aib79          (io_aib_ch19[79]), // Templated
                                     .io_aib8           (io_aib_ch19[8]), // Templated
                                     .io_aib80          (io_aib_ch19[80]), // Templated
                                     .io_aib81          (io_aib_ch19[81]), // Templated
                                     .io_aib82          (io_aib_ch19[82]), // Templated
                                     .io_aib83          (io_aib_ch19[83]), // Templated
                                     .io_aib84          (io_aib_ch19[84]), // Templated
                                     .io_aib85          (io_aib_ch19[85]), // Templated
                                     .io_aib86          (io_aib_ch19[86]), // Templated
                                     .io_aib87          (io_aib_ch19[87]), // Templated
                                     .io_aib88          (io_aib_ch19[88]), // Templated
                                     .io_aib89          (io_aib_ch19[89]), // Templated
                                     .io_aib9           (io_aib_ch19[9]), // Templated
                                     .io_aib90          (io_aib_ch19[90]), // Templated
                                     .io_aib91          (io_aib_ch19[91]), // Templated
                                     .io_aib92          (io_aib_ch19[92]), // Templated
                                     .io_aib93          (io_aib_ch19[93]), // Templated
                                     .io_aib94          (io_aib_ch19[94]), // Templated
                                     .io_aib95          (io_aib_ch19[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[18]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB19_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[18]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[18]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch18[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch18[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[18]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[18]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch18[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[20]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch20[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[20]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[19]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[19]), // Templated
                                     .i_osc_clk         (aib_osc_clk[18]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1299:1235]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[799:760]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[19]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[19]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1559:1482]),
                                     .o_tx_elane_data    (o_tx_elane_data[1559:1482]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[19]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[19][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[18]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[18]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[18]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[18]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[18]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[18]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[18]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[18]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[18]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[18]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[20]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[18]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[18]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[20]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[20]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[20]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[20]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[20]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[20]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[20]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[20]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch20[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_20 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[20]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[20]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[20]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch20[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[20]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[20]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[20]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch20[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch20[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[20]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[20]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch20[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[20]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1280:1220]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[20]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[20]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[839:800]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[20]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[20]),
                                     .ms_sideband        (ms_sideband[1700:1620]),
                                     .sl_sideband        (sl_sideband[1532:1460]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[20]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[20]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[20]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[20]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[20]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[20][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[20][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[20]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[20]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[20]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[20]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[20]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[20]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[20]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[20]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[20]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[20]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[20]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[20]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[20]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[20]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[20]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[20]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[20]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[20]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[20]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[20]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[20]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch20[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch20[0]), // Templated
                                     .io_aib1           (io_aib_ch20[1]), // Templated
                                     .io_aib10          (io_aib_ch20[10]), // Templated
                                     .io_aib11          (io_aib_ch20[11]), // Templated
                                     .io_aib12          (io_aib_ch20[12]), // Templated
                                     .io_aib13          (io_aib_ch20[13]), // Templated
                                     .io_aib14          (io_aib_ch20[14]), // Templated
                                     .io_aib15          (io_aib_ch20[15]), // Templated
                                     .io_aib16          (io_aib_ch20[16]), // Templated
                                     .io_aib17          (io_aib_ch20[17]), // Templated
                                     .io_aib18          (io_aib_ch20[18]), // Templated
                                     .io_aib19          (io_aib_ch20[19]), // Templated
                                     .io_aib2           (io_aib_ch20[2]), // Templated
                                     .io_aib20          (io_aib_ch20[20]), // Templated
                                     .io_aib21          (io_aib_ch20[21]), // Templated
                                     .io_aib22          (io_aib_ch20[22]), // Templated
                                     .io_aib23          (io_aib_ch20[23]), // Templated
                                     .io_aib24          (io_aib_ch20[24]), // Templated
                                     .io_aib25          (io_aib_ch20[25]), // Templated
                                     .io_aib26          (io_aib_ch20[26]), // Templated
                                     .io_aib27          (io_aib_ch20[27]), // Templated
                                     .io_aib28          (io_aib_ch20[28]), // Templated
                                     .io_aib29          (io_aib_ch20[29]), // Templated
                                     .io_aib3           (io_aib_ch20[3]), // Templated
                                     .io_aib30          (io_aib_ch20[30]), // Templated
                                     .io_aib31          (io_aib_ch20[31]), // Templated
                                     .io_aib32          (io_aib_ch20[32]), // Templated
                                     .io_aib33          (io_aib_ch20[33]), // Templated
                                     .io_aib34          (io_aib_ch20[34]), // Templated
                                     .io_aib35          (io_aib_ch20[35]), // Templated
                                     .io_aib36          (io_aib_ch20[36]), // Templated
                                     .io_aib37          (io_aib_ch20[37]), // Templated
                                     .io_aib38          (io_aib_ch20[38]), // Templated
                                     .io_aib39          (io_aib_ch20[39]), // Templated
                                     .io_aib4           (io_aib_ch20[4]), // Templated
                                     .io_aib40          (io_aib_ch20[40]), // Templated
                                     .io_aib41          (io_aib_ch20[41]), // Templated
                                     .io_aib42          (io_aib_ch20[42]), // Templated
                                     .io_aib43          (io_aib_ch20[43]), // Templated
                                     .io_aib44          (io_aib_ch20[44]), // Templated
                                     .io_aib45          (io_aib_ch20[45]), // Templated
                                     .io_aib46          (io_aib_ch20[46]), // Templated
                                     .io_aib47          (io_aib_ch20[47]), // Templated
                                     .io_aib48          (io_aib_ch20[48]), // Templated
                                     .io_aib49          (io_aib_ch20[49]), // Templated
                                     .io_aib5           (io_aib_ch20[5]), // Templated
                                     .io_aib50          (io_aib_ch20[50]), // Templated
                                     .io_aib51          (io_aib_ch20[51]), // Templated
                                     .io_aib52          (io_aib_ch20[52]), // Templated
                                     .io_aib53          (io_aib_ch20[53]), // Templated
                                     .io_aib54          (io_aib_ch20[54]), // Templated
                                     .io_aib55          (io_aib_ch20[55]), // Templated
                                     .io_aib56          (io_aib_ch20[56]), // Templated
                                     .io_aib57          (io_aib_ch20[57]), // Templated
                                     .io_aib58          (io_aib_ch20[58]), // Templated
                                     .io_aib59          (io_aib_ch20[59]), // Templated
                                     .io_aib6           (io_aib_ch20[6]), // Templated
                                     .io_aib60          (io_aib_ch20[60]), // Templated
                                     .io_aib61          (io_aib_ch20[61]), // Templated
                                     .io_aib62          (io_aib_ch20[62]), // Templated
                                     .io_aib63          (io_aib_ch20[63]), // Templated
                                     .io_aib64          (io_aib_ch20[64]), // Templated
                                     .io_aib65          (io_aib_ch20[65]), // Templated
                                     .io_aib66          (io_aib_ch20[66]), // Templated
                                     .io_aib67          (io_aib_ch20[67]), // Templated
                                     .io_aib68          (io_aib_ch20[68]), // Templated
                                     .io_aib69          (io_aib_ch20[69]), // Templated
                                     .io_aib7           (io_aib_ch20[7]), // Templated
                                     .io_aib70          (io_aib_ch20[70]), // Templated
                                     .io_aib71          (io_aib_ch20[71]), // Templated
                                     .io_aib72          (io_aib_ch20[72]), // Templated
                                     .io_aib73          (io_aib_ch20[73]), // Templated
                                     .io_aib74          (io_aib_ch20[74]), // Templated
                                     .io_aib75          (io_aib_ch20[75]), // Templated
                                     .io_aib76          (io_aib_ch20[76]), // Templated
                                     .io_aib77          (io_aib_ch20[77]), // Templated
                                     .io_aib78          (io_aib_ch20[78]), // Templated
                                     .io_aib79          (io_aib_ch20[79]), // Templated
                                     .io_aib8           (io_aib_ch20[8]), // Templated
                                     .io_aib80          (io_aib_ch20[80]), // Templated
                                     .io_aib81          (io_aib_ch20[81]), // Templated
                                     .io_aib82          (io_aib_ch20[82]), // Templated
                                     .io_aib83          (io_aib_ch20[83]), // Templated
                                     .io_aib84          (io_aib_ch20[84]), // Templated
                                     .io_aib85          (io_aib_ch20[85]), // Templated
                                     .io_aib86          (io_aib_ch20[86]), // Templated
                                     .io_aib87          (io_aib_ch20[87]), // Templated
                                     .io_aib88          (io_aib_ch20[88]), // Templated
                                     .io_aib89          (io_aib_ch20[89]), // Templated
                                     .io_aib9           (io_aib_ch20[9]), // Templated
                                     .io_aib90          (io_aib_ch20[90]), // Templated
                                     .io_aib91          (io_aib_ch20[91]), // Templated
                                     .io_aib92          (io_aib_ch20[92]), // Templated
                                     .io_aib93          (io_aib_ch20[93]), // Templated
                                     .io_aib94          (io_aib_ch20[94]), // Templated
                                     .io_aib95          (io_aib_ch20[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[19]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB20_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[19]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[19]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch19[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch19[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[19]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[19]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch19[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[21]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch21[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[21]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[20]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[20]), // Templated
                                     .i_osc_clk         (aib_osc_clk[19]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1364:1300]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[839:800]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[20]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[20]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1637:1560]),
                                     .o_tx_elane_data    (o_tx_elane_data[1637:1560]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[20]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[20][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[19]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[19]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[19]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[19]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[19]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[19]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[19]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[19]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[19]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[19]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[21]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[19]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[19]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[21]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[21]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[21]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[21]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[21]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[21]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[21]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[21]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch21[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_21 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[21]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[21]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[21]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch21[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[21]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[21]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[21]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch21[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch21[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[21]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[21]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch21[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[21]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1341:1281]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[21]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[21]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[879:840]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[21]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[21]),
                                     .ms_sideband        (ms_sideband[1781:1701]),
                                     .sl_sideband        (sl_sideband[1605:1533]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[21]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[21]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[21]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[21]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[21]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[21][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[21][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[21]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[21]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[21]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[21]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[21]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[21]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[21]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[21]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[21]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[21]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[21]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[21]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[21]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[21]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[21]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[21]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[21]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[21]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[21]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[21]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[21]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch21[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch21[0]), // Templated
                                     .io_aib1           (io_aib_ch21[1]), // Templated
                                     .io_aib10          (io_aib_ch21[10]), // Templated
                                     .io_aib11          (io_aib_ch21[11]), // Templated
                                     .io_aib12          (io_aib_ch21[12]), // Templated
                                     .io_aib13          (io_aib_ch21[13]), // Templated
                                     .io_aib14          (io_aib_ch21[14]), // Templated
                                     .io_aib15          (io_aib_ch21[15]), // Templated
                                     .io_aib16          (io_aib_ch21[16]), // Templated
                                     .io_aib17          (io_aib_ch21[17]), // Templated
                                     .io_aib18          (io_aib_ch21[18]), // Templated
                                     .io_aib19          (io_aib_ch21[19]), // Templated
                                     .io_aib2           (io_aib_ch21[2]), // Templated
                                     .io_aib20          (io_aib_ch21[20]), // Templated
                                     .io_aib21          (io_aib_ch21[21]), // Templated
                                     .io_aib22          (io_aib_ch21[22]), // Templated
                                     .io_aib23          (io_aib_ch21[23]), // Templated
                                     .io_aib24          (io_aib_ch21[24]), // Templated
                                     .io_aib25          (io_aib_ch21[25]), // Templated
                                     .io_aib26          (io_aib_ch21[26]), // Templated
                                     .io_aib27          (io_aib_ch21[27]), // Templated
                                     .io_aib28          (io_aib_ch21[28]), // Templated
                                     .io_aib29          (io_aib_ch21[29]), // Templated
                                     .io_aib3           (io_aib_ch21[3]), // Templated
                                     .io_aib30          (io_aib_ch21[30]), // Templated
                                     .io_aib31          (io_aib_ch21[31]), // Templated
                                     .io_aib32          (io_aib_ch21[32]), // Templated
                                     .io_aib33          (io_aib_ch21[33]), // Templated
                                     .io_aib34          (io_aib_ch21[34]), // Templated
                                     .io_aib35          (io_aib_ch21[35]), // Templated
                                     .io_aib36          (io_aib_ch21[36]), // Templated
                                     .io_aib37          (io_aib_ch21[37]), // Templated
                                     .io_aib38          (io_aib_ch21[38]), // Templated
                                     .io_aib39          (io_aib_ch21[39]), // Templated
                                     .io_aib4           (io_aib_ch21[4]), // Templated
                                     .io_aib40          (io_aib_ch21[40]), // Templated
                                     .io_aib41          (io_aib_ch21[41]), // Templated
                                     .io_aib42          (io_aib_ch21[42]), // Templated
                                     .io_aib43          (io_aib_ch21[43]), // Templated
                                     .io_aib44          (io_aib_ch21[44]), // Templated
                                     .io_aib45          (io_aib_ch21[45]), // Templated
                                     .io_aib46          (io_aib_ch21[46]), // Templated
                                     .io_aib47          (io_aib_ch21[47]), // Templated
                                     .io_aib48          (io_aib_ch21[48]), // Templated
                                     .io_aib49          (io_aib_ch21[49]), // Templated
                                     .io_aib5           (io_aib_ch21[5]), // Templated
                                     .io_aib50          (io_aib_ch21[50]), // Templated
                                     .io_aib51          (io_aib_ch21[51]), // Templated
                                     .io_aib52          (io_aib_ch21[52]), // Templated
                                     .io_aib53          (io_aib_ch21[53]), // Templated
                                     .io_aib54          (io_aib_ch21[54]), // Templated
                                     .io_aib55          (io_aib_ch21[55]), // Templated
                                     .io_aib56          (io_aib_ch21[56]), // Templated
                                     .io_aib57          (io_aib_ch21[57]), // Templated
                                     .io_aib58          (io_aib_ch21[58]), // Templated
                                     .io_aib59          (io_aib_ch21[59]), // Templated
                                     .io_aib6           (io_aib_ch21[6]), // Templated
                                     .io_aib60          (io_aib_ch21[60]), // Templated
                                     .io_aib61          (io_aib_ch21[61]), // Templated
                                     .io_aib62          (io_aib_ch21[62]), // Templated
                                     .io_aib63          (io_aib_ch21[63]), // Templated
                                     .io_aib64          (io_aib_ch21[64]), // Templated
                                     .io_aib65          (io_aib_ch21[65]), // Templated
                                     .io_aib66          (io_aib_ch21[66]), // Templated
                                     .io_aib67          (io_aib_ch21[67]), // Templated
                                     .io_aib68          (io_aib_ch21[68]), // Templated
                                     .io_aib69          (io_aib_ch21[69]), // Templated
                                     .io_aib7           (io_aib_ch21[7]), // Templated
                                     .io_aib70          (io_aib_ch21[70]), // Templated
                                     .io_aib71          (io_aib_ch21[71]), // Templated
                                     .io_aib72          (io_aib_ch21[72]), // Templated
                                     .io_aib73          (io_aib_ch21[73]), // Templated
                                     .io_aib74          (io_aib_ch21[74]), // Templated
                                     .io_aib75          (io_aib_ch21[75]), // Templated
                                     .io_aib76          (io_aib_ch21[76]), // Templated
                                     .io_aib77          (io_aib_ch21[77]), // Templated
                                     .io_aib78          (io_aib_ch21[78]), // Templated
                                     .io_aib79          (io_aib_ch21[79]), // Templated
                                     .io_aib8           (io_aib_ch21[8]), // Templated
                                     .io_aib80          (io_aib_ch21[80]), // Templated
                                     .io_aib81          (io_aib_ch21[81]), // Templated
                                     .io_aib82          (io_aib_ch21[82]), // Templated
                                     .io_aib83          (io_aib_ch21[83]), // Templated
                                     .io_aib84          (io_aib_ch21[84]), // Templated
                                     .io_aib85          (io_aib_ch21[85]), // Templated
                                     .io_aib86          (io_aib_ch21[86]), // Templated
                                     .io_aib87          (io_aib_ch21[87]), // Templated
                                     .io_aib88          (io_aib_ch21[88]), // Templated
                                     .io_aib89          (io_aib_ch21[89]), // Templated
                                     .io_aib9           (io_aib_ch21[9]), // Templated
                                     .io_aib90          (io_aib_ch21[90]), // Templated
                                     .io_aib91          (io_aib_ch21[91]), // Templated
                                     .io_aib92          (io_aib_ch21[92]), // Templated
                                     .io_aib93          (io_aib_ch21[93]), // Templated
                                     .io_aib94          (io_aib_ch21[94]), // Templated
                                     .io_aib95          (io_aib_ch21[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[20]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB21_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[20]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[20]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch20[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch20[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[20]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[20]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch20[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[22]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch22[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[22]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[21]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[21]), // Templated
                                     .i_osc_clk         (aib_osc_clk[20]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1429:1365]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[879:840]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[21]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[21]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1715:1638]),
                                     .o_tx_elane_data    (o_tx_elane_data[1715:1638]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[21]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[21][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[20]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[20]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[20]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[20]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[20]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[20]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[20]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[20]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[20]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[20]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[22]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[20]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[20]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[22]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[22]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[22]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[22]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[22]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[22]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[22]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[22]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch22[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_22 (/*AUTOINST*/
                                     // Outputs
                                     .o_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[22]), // Templated
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[22]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[22]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch22[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[22]), // Templated
                                     .o_adpt_cfg_clk    (aib_cfg_avmm_clk[22]), // Templated
                                     .o_adpt_cfg_rst_n  (aib_cfg_avmm_rst_n[22]), // Templated
                                     .o_adpt_cfg_addr   (aib_cfg_avmm_addr_ch22[16:0]), // Templated
                                     .o_adpt_cfg_byte_en(aib_cfg_avmm_byte_en_ch22[3:0]), // Templated
                                     .o_adpt_cfg_read   (aib_cfg_avmm_read[22]), // Templated
                                     .o_adpt_cfg_write  (aib_cfg_avmm_write[22]), // Templated
                                     .o_adpt_cfg_wdata  (aib_cfg_avmm_wdata_ch22[31:0]), // Templated
                                     .o_osc_clk         (aib_osc_clk[22]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1402:1342]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[22]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[22]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[919:880]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[22]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[22]),
                                     .ms_sideband        (ms_sideband[1862:1782]),
                                     .sl_sideband        (sl_sideband[1678:1606]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[22]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[22]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[22]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[22]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[22]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[22][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[22][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[22]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[22]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[22]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[22]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[22]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[22]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[22]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[22]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[22]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[22]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[22]), // Templated
                                     .o_por_aib_vcchssi (aib_por_vcchssi[22]), // Templated
                                     .o_por_aib_vccl    (aib_por_vccl[22]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[22]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[22]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[22]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[22]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[22]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[22]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[22]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[22]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch22[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch22[0]), // Templated
                                     .io_aib1           (io_aib_ch22[1]), // Templated
                                     .io_aib10          (io_aib_ch22[10]), // Templated
                                     .io_aib11          (io_aib_ch22[11]), // Templated
                                     .io_aib12          (io_aib_ch22[12]), // Templated
                                     .io_aib13          (io_aib_ch22[13]), // Templated
                                     .io_aib14          (io_aib_ch22[14]), // Templated
                                     .io_aib15          (io_aib_ch22[15]), // Templated
                                     .io_aib16          (io_aib_ch22[16]), // Templated
                                     .io_aib17          (io_aib_ch22[17]), // Templated
                                     .io_aib18          (io_aib_ch22[18]), // Templated
                                     .io_aib19          (io_aib_ch22[19]), // Templated
                                     .io_aib2           (io_aib_ch22[2]), // Templated
                                     .io_aib20          (io_aib_ch22[20]), // Templated
                                     .io_aib21          (io_aib_ch22[21]), // Templated
                                     .io_aib22          (io_aib_ch22[22]), // Templated
                                     .io_aib23          (io_aib_ch22[23]), // Templated
                                     .io_aib24          (io_aib_ch22[24]), // Templated
                                     .io_aib25          (io_aib_ch22[25]), // Templated
                                     .io_aib26          (io_aib_ch22[26]), // Templated
                                     .io_aib27          (io_aib_ch22[27]), // Templated
                                     .io_aib28          (io_aib_ch22[28]), // Templated
                                     .io_aib29          (io_aib_ch22[29]), // Templated
                                     .io_aib3           (io_aib_ch22[3]), // Templated
                                     .io_aib30          (io_aib_ch22[30]), // Templated
                                     .io_aib31          (io_aib_ch22[31]), // Templated
                                     .io_aib32          (io_aib_ch22[32]), // Templated
                                     .io_aib33          (io_aib_ch22[33]), // Templated
                                     .io_aib34          (io_aib_ch22[34]), // Templated
                                     .io_aib35          (io_aib_ch22[35]), // Templated
                                     .io_aib36          (io_aib_ch22[36]), // Templated
                                     .io_aib37          (io_aib_ch22[37]), // Templated
                                     .io_aib38          (io_aib_ch22[38]), // Templated
                                     .io_aib39          (io_aib_ch22[39]), // Templated
                                     .io_aib4           (io_aib_ch22[4]), // Templated
                                     .io_aib40          (io_aib_ch22[40]), // Templated
                                     .io_aib41          (io_aib_ch22[41]), // Templated
                                     .io_aib42          (io_aib_ch22[42]), // Templated
                                     .io_aib43          (io_aib_ch22[43]), // Templated
                                     .io_aib44          (io_aib_ch22[44]), // Templated
                                     .io_aib45          (io_aib_ch22[45]), // Templated
                                     .io_aib46          (io_aib_ch22[46]), // Templated
                                     .io_aib47          (io_aib_ch22[47]), // Templated
                                     .io_aib48          (io_aib_ch22[48]), // Templated
                                     .io_aib49          (io_aib_ch22[49]), // Templated
                                     .io_aib5           (io_aib_ch22[5]), // Templated
                                     .io_aib50          (io_aib_ch22[50]), // Templated
                                     .io_aib51          (io_aib_ch22[51]), // Templated
                                     .io_aib52          (io_aib_ch22[52]), // Templated
                                     .io_aib53          (io_aib_ch22[53]), // Templated
                                     .io_aib54          (io_aib_ch22[54]), // Templated
                                     .io_aib55          (io_aib_ch22[55]), // Templated
                                     .io_aib56          (io_aib_ch22[56]), // Templated
                                     .io_aib57          (io_aib_ch22[57]), // Templated
                                     .io_aib58          (io_aib_ch22[58]), // Templated
                                     .io_aib59          (io_aib_ch22[59]), // Templated
                                     .io_aib6           (io_aib_ch22[6]), // Templated
                                     .io_aib60          (io_aib_ch22[60]), // Templated
                                     .io_aib61          (io_aib_ch22[61]), // Templated
                                     .io_aib62          (io_aib_ch22[62]), // Templated
                                     .io_aib63          (io_aib_ch22[63]), // Templated
                                     .io_aib64          (io_aib_ch22[64]), // Templated
                                     .io_aib65          (io_aib_ch22[65]), // Templated
                                     .io_aib66          (io_aib_ch22[66]), // Templated
                                     .io_aib67          (io_aib_ch22[67]), // Templated
                                     .io_aib68          (io_aib_ch22[68]), // Templated
                                     .io_aib69          (io_aib_ch22[69]), // Templated
                                     .io_aib7           (io_aib_ch22[7]), // Templated
                                     .io_aib70          (io_aib_ch22[70]), // Templated
                                     .io_aib71          (io_aib_ch22[71]), // Templated
                                     .io_aib72          (io_aib_ch22[72]), // Templated
                                     .io_aib73          (io_aib_ch22[73]), // Templated
                                     .io_aib74          (io_aib_ch22[74]), // Templated
                                     .io_aib75          (io_aib_ch22[75]), // Templated
                                     .io_aib76          (io_aib_ch22[76]), // Templated
                                     .io_aib77          (io_aib_ch22[77]), // Templated
                                     .io_aib78          (io_aib_ch22[78]), // Templated
                                     .io_aib79          (io_aib_ch22[79]), // Templated
                                     .io_aib8           (io_aib_ch22[8]), // Templated
                                     .io_aib80          (io_aib_ch22[80]), // Templated
                                     .io_aib81          (io_aib_ch22[81]), // Templated
                                     .io_aib82          (io_aib_ch22[82]), // Templated
                                     .io_aib83          (io_aib_ch22[83]), // Templated
                                     .io_aib84          (io_aib_ch22[84]), // Templated
                                     .io_aib85          (io_aib_ch22[85]), // Templated
                                     .io_aib86          (io_aib_ch22[86]), // Templated
                                     .io_aib87          (io_aib_ch22[87]), // Templated
                                     .io_aib88          (io_aib_ch22[88]), // Templated
                                     .io_aib89          (io_aib_ch22[89]), // Templated
                                     .io_aib9           (io_aib_ch22[9]), // Templated
                                     .io_aib90          (io_aib_ch22[90]), // Templated
                                     .io_aib91          (io_aib_ch22[91]), // Templated
                                     .io_aib92          (io_aib_ch22[92]), // Templated
                                     .io_aib93          (io_aib_ch22[93]), // Templated
                                     .io_aib94          (io_aib_ch22[94]), // Templated
                                     .io_aib95          (io_aib_ch22[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[21]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB22_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[21]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[21]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch21[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch21[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[21]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[21]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch21[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[23]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch23[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[23]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[22]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[22]), // Templated
                                     .i_osc_clk         (aib_osc_clk[21]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1494:1430]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[919:880]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[22]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[22]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1793:1716]),
                                     .o_tx_elane_data    (o_tx_elane_data[1793:1716]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[22]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[22][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[21]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[21]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[21]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[21]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[21]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[21]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[21]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[21]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[21]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[21]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[23]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[21]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[21]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[23]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[23]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[23]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[23]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[23]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[23]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[23]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[23]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch23[12:0])); // Templated
    c3aibadapt_wrap u_c3aibadapt_23 (
                                     .o_adpt_hard_rst_n (),
                                     //last channel config daisy chain stopped
                                     .o_adpt_cfg_clk    (),
                                     .o_adpt_cfg_rst_n  (),
                                     .o_adpt_cfg_addr   (),
                                     .o_adpt_cfg_byte_en(),
                                     .o_adpt_cfg_read   (),
                                     .o_adpt_cfg_write  (),
                                     .o_adpt_cfg_wdata  (),
                                     .o_osc_clk         (),
                                     .o_por_aib_vcchssi (),
                                     .o_por_aib_vccl    (),                                     
                                     
                                     /*AUTOINST*/
                                     // Outputs
                                     .o_rx_xcvrif_rst_n (o_rx_xcvrif_rst_n[23]), // Templated
                                     .o_tx_xcvrif_rst_n (),              // Templated
                                     .o_ehip_init_status(),              // Templated
                                     .o_cfg_avmm_rdatavld(aib_cfg_avmm_rdatavld[23]), // Templated
                                     .o_cfg_avmm_rdata  (aib_cfg_avmm_rdata_ch23[31:0]), // Templated
                                     .o_cfg_avmm_waitreq(aib_cfg_avmm_waitreq[23]), // Templated
                                     .o_chnl_ssr        (o_chnl_ssr[1463:1403]), // Templated
                                     .o_tx_transfer_clk (o_tx_transfer_clk[23]), // Templated
                                     .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk[23]), // Templated
                                     .o_tx_pma_data     (o_tx_pma_data[959:920]), // Templated
                                     .ns_mac_rdy        (ns_mac_rdy[23]),
                                     .ns_adapt_rstn      (ns_adapt_rstn[23]),
                                     .ms_sideband        (ms_sideband[1943:1863]),
                                     .sl_sideband        (sl_sideband[1751:1679]),
                                     .m_rxfifo_align_done (m_rxfifo_align_done[23]),
                                     .ms_tx_transfer_en  (ms_tx_transfer_en[23]),
                                     .ms_rx_transfer_en  (ms_rx_transfer_en[23]),
                                     .sl_tx_transfer_en  (sl_tx_transfer_en[23]),
                                     .sl_rx_transfer_en  (sl_rx_transfer_en[23]),
                                     .o_test_c3adapt_scan_out(o_test_c3adapt_scan_out[23][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .o_test_c3adapttcb_jtag(o_test_c3adapttcb_jtag[23][`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                     .o_jtag_clkdr_out  (aib_jtag_clkdr_out[23]), // Templated
                                     .o_jtag_clksel_out (aib_jtag_clksel_out[23]), // Templated
                                     .o_jtag_intest_out (aib_jtag_intest_out[23]), // Templated
                                     .o_jtag_mode_out   (aib_jtag_mode_out[23]), // Templated
                                     .o_jtag_rstb_en_out(aib_jtag_rstb_en_out[23]), // Templated
                                     .o_jtag_rstb_out   (aib_jtag_rstb_out[23]), // Templated
                                     .o_jtag_weakpdn_out(aib_jtag_weakpdn_out[23]), // Templated
                                     .o_jtag_weakpu_out (aib_jtag_weakpu_out[23]), // Templated
                                     .o_jtag_bs_chain_out(aib_jtag_bs_chain_out[23]), // Templated
                                     .o_jtag_bs_scanen_out(aib_jtag_bs_scanen_out[23]), // Templated
                                     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[23]), // Templated
                                     .o_red_idataselb_out_chain1(aib_red_idataselb_chain1[23]), // Templated
                                     .o_red_idataselb_out_chain2(aib_red_idataselb_chain2[23]), // Templated
                                     .o_red_shift_en_out_chain1(aib_red_shift_en_chain1[23]), // Templated
                                     .o_red_shift_en_out_chain2(aib_red_shift_en_chain2[23]), // Templated
                                     .o_txen_out_chain1 (aib_txen_chain1[23]), // Templated
                                     .o_txen_out_chain2 (aib_txen_chain2[23]), // Templated
                                     .o_directout_data_chain1_out(aib_directout_data_chain1_out[23]), // Templated
                                     .o_directout_data_chain2_out(aib_directout_data_chain2_out[23]), // Templated
                                     .o_aibdftdll2adjch (aib_dftdll2adjch_ch23[12:0]), // Templated
                                     // Inouts
                                     .io_aib0           (io_aib_ch23[0]), // Templated
                                     .io_aib1           (io_aib_ch23[1]), // Templated
                                     .io_aib10          (io_aib_ch23[10]), // Templated
                                     .io_aib11          (io_aib_ch23[11]), // Templated
                                     .io_aib12          (io_aib_ch23[12]), // Templated
                                     .io_aib13          (io_aib_ch23[13]), // Templated
                                     .io_aib14          (io_aib_ch23[14]), // Templated
                                     .io_aib15          (io_aib_ch23[15]), // Templated
                                     .io_aib16          (io_aib_ch23[16]), // Templated
                                     .io_aib17          (io_aib_ch23[17]), // Templated
                                     .io_aib18          (io_aib_ch23[18]), // Templated
                                     .io_aib19          (io_aib_ch23[19]), // Templated
                                     .io_aib2           (io_aib_ch23[2]), // Templated
                                     .io_aib20          (io_aib_ch23[20]), // Templated
                                     .io_aib21          (io_aib_ch23[21]), // Templated
                                     .io_aib22          (io_aib_ch23[22]), // Templated
                                     .io_aib23          (io_aib_ch23[23]), // Templated
                                     .io_aib24          (io_aib_ch23[24]), // Templated
                                     .io_aib25          (io_aib_ch23[25]), // Templated
                                     .io_aib26          (io_aib_ch23[26]), // Templated
                                     .io_aib27          (io_aib_ch23[27]), // Templated
                                     .io_aib28          (io_aib_ch23[28]), // Templated
                                     .io_aib29          (io_aib_ch23[29]), // Templated
                                     .io_aib3           (io_aib_ch23[3]), // Templated
                                     .io_aib30          (io_aib_ch23[30]), // Templated
                                     .io_aib31          (io_aib_ch23[31]), // Templated
                                     .io_aib32          (io_aib_ch23[32]), // Templated
                                     .io_aib33          (io_aib_ch23[33]), // Templated
                                     .io_aib34          (io_aib_ch23[34]), // Templated
                                     .io_aib35          (io_aib_ch23[35]), // Templated
                                     .io_aib36          (io_aib_ch23[36]), // Templated
                                     .io_aib37          (io_aib_ch23[37]), // Templated
                                     .io_aib38          (io_aib_ch23[38]), // Templated
                                     .io_aib39          (io_aib_ch23[39]), // Templated
                                     .io_aib4           (io_aib_ch23[4]), // Templated
                                     .io_aib40          (io_aib_ch23[40]), // Templated
                                     .io_aib41          (io_aib_ch23[41]), // Templated
                                     .io_aib42          (io_aib_ch23[42]), // Templated
                                     .io_aib43          (io_aib_ch23[43]), // Templated
                                     .io_aib44          (io_aib_ch23[44]), // Templated
                                     .io_aib45          (io_aib_ch23[45]), // Templated
                                     .io_aib46          (io_aib_ch23[46]), // Templated
                                     .io_aib47          (io_aib_ch23[47]), // Templated
                                     .io_aib48          (io_aib_ch23[48]), // Templated
                                     .io_aib49          (io_aib_ch23[49]), // Templated
                                     .io_aib5           (io_aib_ch23[5]), // Templated
                                     .io_aib50          (io_aib_ch23[50]), // Templated
                                     .io_aib51          (io_aib_ch23[51]), // Templated
                                     .io_aib52          (io_aib_ch23[52]), // Templated
                                     .io_aib53          (io_aib_ch23[53]), // Templated
                                     .io_aib54          (io_aib_ch23[54]), // Templated
                                     .io_aib55          (io_aib_ch23[55]), // Templated
                                     .io_aib56          (io_aib_ch23[56]), // Templated
                                     .io_aib57          (io_aib_ch23[57]), // Templated
                                     .io_aib58          (io_aib_ch23[58]), // Templated
                                     .io_aib59          (io_aib_ch23[59]), // Templated
                                     .io_aib6           (io_aib_ch23[6]), // Templated
                                     .io_aib60          (io_aib_ch23[60]), // Templated
                                     .io_aib61          (io_aib_ch23[61]), // Templated
                                     .io_aib62          (io_aib_ch23[62]), // Templated
                                     .io_aib63          (io_aib_ch23[63]), // Templated
                                     .io_aib64          (io_aib_ch23[64]), // Templated
                                     .io_aib65          (io_aib_ch23[65]), // Templated
                                     .io_aib66          (io_aib_ch23[66]), // Templated
                                     .io_aib67          (io_aib_ch23[67]), // Templated
                                     .io_aib68          (io_aib_ch23[68]), // Templated
                                     .io_aib69          (io_aib_ch23[69]), // Templated
                                     .io_aib7           (io_aib_ch23[7]), // Templated
                                     .io_aib70          (io_aib_ch23[70]), // Templated
                                     .io_aib71          (io_aib_ch23[71]), // Templated
                                     .io_aib72          (io_aib_ch23[72]), // Templated
                                     .io_aib73          (io_aib_ch23[73]), // Templated
                                     .io_aib74          (io_aib_ch23[74]), // Templated
                                     .io_aib75          (io_aib_ch23[75]), // Templated
                                     .io_aib76          (io_aib_ch23[76]), // Templated
                                     .io_aib77          (io_aib_ch23[77]), // Templated
                                     .io_aib78          (io_aib_ch23[78]), // Templated
                                     .io_aib79          (io_aib_ch23[79]), // Templated
                                     .io_aib8           (io_aib_ch23[8]), // Templated
                                     .io_aib80          (io_aib_ch23[80]), // Templated
                                     .io_aib81          (io_aib_ch23[81]), // Templated
                                     .io_aib82          (io_aib_ch23[82]), // Templated
                                     .io_aib83          (io_aib_ch23[83]), // Templated
                                     .io_aib84          (io_aib_ch23[84]), // Templated
                                     .io_aib85          (io_aib_ch23[85]), // Templated
                                     .io_aib86          (io_aib_ch23[86]), // Templated
                                     .io_aib87          (io_aib_ch23[87]), // Templated
                                     .io_aib88          (io_aib_ch23[88]), // Templated
                                     .io_aib89          (io_aib_ch23[89]), // Templated
                                     .io_aib9           (io_aib_ch23[9]), // Templated
                                     .io_aib90          (io_aib_ch23[90]), // Templated
                                     .io_aib91          (io_aib_ch23[91]), // Templated
                                     .io_aib92          (io_aib_ch23[92]), // Templated
                                     .io_aib93          (io_aib_ch23[93]), // Templated
                                     .io_aib94          (io_aib_ch23[94]), // Templated
                                     .io_aib95          (io_aib_ch23[95]), // Templated
                                     // Inputs
                                     .i_adpt_hard_rst_n (aib_adpt_chnl_hard_rst_n[22]), // Templated
                                     .i_channel_id      (C3_AVMM_AIB23_ID), // Templated
                                     .i_cfg_avmm_clk    (aib_cfg_avmm_clk[22]), // Templated
                                     .i_cfg_avmm_rst_n  (aib_cfg_avmm_rst_n[22]), // Templated
                                     .i_cfg_avmm_addr   (aib_cfg_avmm_addr_ch22[16:0]), // Templated
                                     .i_cfg_avmm_byte_en(aib_cfg_avmm_byte_en_ch22[3:0]), // Templated
                                     .i_cfg_avmm_read   (aib_cfg_avmm_read[22]), // Templated
                                     .i_cfg_avmm_write  (aib_cfg_avmm_write[22]), // Templated
                                     .i_cfg_avmm_wdata  (aib_cfg_avmm_wdata_ch22[31:0]), // Templated
                                     .i_adpt_cfg_rdatavld(aib_cfg_avmm_rdatavld[24]), // Templated
                                     .i_adpt_cfg_rdata  (aib_cfg_avmm_rdata_ch24[31:0]), // Templated
                                     .i_adpt_cfg_waitreq(aib_cfg_avmm_waitreq[24]), // Templated
                                     .i_rx_pma_clk      (i_rx_pma_clk[23]), // Templated
                                     .i_rx_pma_div2_clk (i_rx_pma_div2_clk[23]), // Templated
                                     .i_osc_clk         (aib_osc_clk[22]), // Templated
                                     .i_chnl_ssr        (i_chnl_ssr[1559:1495]), // Templated
                                     .i_rx_pma_data     (i_rx_pma_data[959:920]), // Templated
                                     .i_rx_elane_clk     (i_rx_elane_clk[23]),
                                     .i_tx_pma_clk      (i_tx_pma_clk[23]), // Templated
                                     .i_rx_elane_data    (i_rx_elane_data[1871:1794]),
                                     .o_tx_elane_data    (o_tx_elane_data[1871:1794]),
                                     .i_tx_elane_clk     (i_tx_elane_clk[23]),
                                     .i_scan_clk        (i_scan_clk),    // Templated
                                     .i_test_clk_1g     (i_test_clk_1g), // Templated
                                     .i_test_clk_500m   (i_test_clk_500m), // Templated
                                     .i_test_clk_250m   (i_test_clk_250m), // Templated
                                     .i_test_clk_125m   (i_test_clk_125m), // Templated
                                     .i_test_clk_62m    (i_test_clk_62m), // Templated
                                     .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                     .i_test_c3adapt_scan_in(i_test_c3adapt_scan_in[23][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                     .i_jtag_rstb_in    (aib_jtag_rstb_out[22]), // Templated
                                     .i_jtag_rstb_en_in (aib_jtag_rstb_en_out[22]), // Templated
                                     .i_jtag_clkdr_in   (aib_jtag_clkdr_out[22]), // Templated
                                     .i_jtag_clksel_in  (aib_jtag_clksel_out[22]), // Templated
                                     .i_jtag_intest_in  (aib_jtag_intest_out[22]), // Templated
                                     .i_jtag_mode_in    (aib_jtag_mode_out[22]), // Templated
                                     .i_jtag_weakpdn_in (aib_jtag_weakpdn_out[22]), // Templated
                                     .i_jtag_weakpu_in  (aib_jtag_weakpu_out[22]), // Templated
                                     .i_jtag_bs_scanen_in(aib_jtag_bs_scanen_out[22]), // Templated
                                     .i_jtag_bs_chain_in(aib_jtag_bs_chain_out[22]), // Templated
                                     .i_jtag_last_bs_chain_in(aib_jtag_last_bs_chain_out[24]), // Templated
                                     .i_por_aib_vcchssi (aib_por_vcchssi[22]), // Templated
                                     .i_por_aib_vccl    (aib_por_vccl[22]), // Templated
                                     .i_red_idataselb_in_chain1(aib_red_idataselb_chain1[24]), // Templated
                                     .i_red_idataselb_in_chain2(aib_red_idataselb_chain2[24]), // Templated
                                     .i_red_shift_en_in_chain1(aib_red_shift_en_chain1[24]), // Templated
                                     .i_red_shift_en_in_chain2(aib_red_shift_en_chain2[24]), // Templated
                                     .i_txen_in_chain1  (aib_txen_chain1[24]), // Templated
                                     .i_txen_in_chain2  (aib_txen_chain2[24]), // Templated
                                     .i_directout_data_chain1_in(aib_directout_data_chain1_out[24]), // Templated
                                     .i_directout_data_chain2_in(aib_directout_data_chain2_out[24]), // Templated
                                     .i_aibdftdll2adjch (aib_dftdll2adjch_ch24[12:0])); // Templated
                                
    /*
     c3routing_chnl_edge AUTO_TEMPLATE (
     .o_rdata               (aib_cfg_avmm_rdata_ch24[31:0]),
     .o_rdatavalid          (aib_cfg_avmm_rdatavld[24]),
     .o_waitreq             (aib_cfg_avmm_waitreq[24]),
     .o_aibdftdll2adjch     (aib_dftdll2adjch_ch24[12:0]),
     .o_red_shift_en_out_chain1 (aib_red_shift_en_chain1[24]),
     .o_red_shift_en_out_chain2 (aib_red_shift_en_chain2[24]),
     .o_\(.*\)              (aib_\1[24]),
     .i_jtag_last_bs_chain_in(aib_jtag_bs_chain_out[23]),
     .o_jtag_last_bs_chain_out(aib_jtag_last_bs_chain_out[24]),
     
     .i_jtag\(.*\)_in       (aib_jtag\1_out[23]),
     );
     
     */

    // Last channel routing edge signal feedthrough
    c3routing_chnl_edge u_c3routing_chnl_edge
      (/*AUTOINST*/
       // Outputs
       .o_rdata                         (aib_cfg_avmm_rdata_ch24[31:0]), // Templated
       .o_rdatavalid                    (aib_cfg_avmm_rdatavld[24]), // Templated
       .o_waitreq                       (aib_cfg_avmm_waitreq[24]), // Templated
       .o_aibdftdll2adjch               (aib_dftdll2adjch_ch24[12:0]), // Templated
       .o_red_idataselb_chain1          (aib_red_idataselb_chain1[24]), // Templated
       .o_red_idataselb_chain2          (aib_red_idataselb_chain2[24]), // Templated
       .o_txen_chain1                   (aib_txen_chain1[24]),   // Templated
       .o_txen_chain2                   (aib_txen_chain2[24]),   // Templated
       .o_red_shift_en_out_chain1       (aib_red_shift_en_chain1[24]), // Templated
       .o_red_shift_en_out_chain2       (aib_red_shift_en_chain2[24]), // Templated
       .o_jtag_last_bs_chain_out        (aib_jtag_last_bs_chain_out[24]), // Templated
       .o_directout_data_chain1_out     (aib_directout_data_chain1_out[24]), // Templated
       .o_directout_data_chain2_out     (aib_directout_data_chain2_out[24]), // Templated
       // Inputs
       .i_jtag_last_bs_chain_in         (aib_jtag_bs_chain_out[23]), // Templated
       .i_jtag_bs_scanen_in             (aib_jtag_bs_scanen_out[23]), // Templated
       .i_jtag_clkdr_in                 (aib_jtag_clkdr_out[23]), // Templated
       .i_jtag_clksel_in                (aib_jtag_clksel_out[23]), // Templated
       .i_jtag_intest_in                (aib_jtag_intest_out[23]), // Templated
       .i_jtag_mode_in                  (aib_jtag_mode_out[23]), // Templated
       .i_jtag_rstb_en_in               (aib_jtag_rstb_en_out[23]), // Templated
       .i_jtag_rstb_in                  (aib_jtag_rstb_out[23]), // Templated
       .i_jtag_weakpdn_in               (aib_jtag_weakpdn_out[23]), // Templated
       .i_jtag_weakpu_in                (aib_jtag_weakpu_out[23])); // Templated
   
endmodule

/* Local Variables:
 verilog-library-directories:(".")
 verilog-auto-inst-param-value: t
 eval: (setq verilog-auto-output-ignore-regexp (concat 
  "^\\("
 "aib_.*" 
 "\\)$"
 ))
 eval: (setq verilog-auto-input-ignore-regexp (concat
 "^\\("
 "aib_.*"
 "\\)$"
 ))
End:
*/
