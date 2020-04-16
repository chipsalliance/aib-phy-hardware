// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2018 Intel Corporation. .  
//
//-----------------------------------------------------------------------------
// 3/25/2019. The following signals are pulled out for phase compensation FIFO
// usage.
//-----------------------------------------------------------------------------
// i_tx_elane_clk, o_tx_elane_data 
// i_rx_elane_clk, i_rx_elane_data,
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
// 10/31/2019
// Pull out i_tx_elane_clk, o_tx_elane_data ,  
//          i_rx_elane_clk, i_rx_elane_data,
// Added    ns_adapt_rstn
//
//
//-----------------------------------------------------------------------------
module c3aibadapt_wrap 
(
 //================================================================================================
 // Reset Inteface
    input                                      i_adpt_hard_rst_n, // AIB adaptor hard reset
    output                                     o_adpt_hard_rst_n, // connected with i_adpt_hard_rst_n and used to pass through to channel n+1 for PnR purpose

 // reset for XCVRIF
    output                                     o_rx_xcvrif_rst_n, // chiplet xcvr receiving path reset, the reset is controlled by remote chiplet which is FPGA in this case
    output                                     o_tx_xcvrif_rst_n, // chiplet xcvr transmitting path reset, the reset is controlled by remote chiplet which is FPGA

 //===============================================================================================
    output [2:0]                               o_ehip_init_status, //indicating the status, bit[2] is osc_transfer_alive, bit[0] tx_transfer_en and bit[1] rx_transfer_en
 //===============================================================================================
 // Configuration Interface which includes two paths
 
 // Path directly from chip programming controller
    input [5:0]                                i_channel_id, // channel ID to program
    input                                      i_cfg_avmm_clk, 
    input                                      i_cfg_avmm_rst_n, 
    input [16:0]                               i_cfg_avmm_addr, // address to be programmed
    input [3:0]                                i_cfg_avmm_byte_en, // byte enable
    input                                      i_cfg_avmm_read, // Asserted to indicate the Cfg read access
    input                                      i_cfg_avmm_write, // Asserted to indicate the Cfg write access
    input [31:0]                               i_cfg_avmm_wdata, // data to be programmed
 
    output                                     o_cfg_avmm_rdatavld,// Assert to indicate data available for Cfg read access 
    output [31:0]                              o_cfg_avmm_rdata, // data returned for Cfg read access
    output                                     o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg access

 //Configuration Channel pass through Path from other channel, depends on how the PNR physical block look like, user can either
 //connect up with the cfg_avmm path directly or use this feedthrough path to the next adaptor
    output                                     o_adpt_cfg_clk, // take i_cfg_avmm_clk as input and pass to channel n+1
    output                                     o_adpt_cfg_rst_n, // take i_cfg_avmm_rst_n as input and pass to the channel n+1
    output [16:0]                              o_adpt_cfg_addr, // take i_cfg_avmm_addr as input and pass to the channel n+1
    output [3:0]                               o_adpt_cfg_byte_en, // take i_cfg_avmm_byte_en as input and pass to the channel n+1
    output                                     o_adpt_cfg_read, // take i_cfg_avmm_read as input and pass to the channel n+1
    output                                     o_adpt_cfg_write, // take i_cfg_avmm_write as input and pass to the channel n+1
    output [31:0]                              o_adpt_cfg_wdata, // take i_cfg_avmm_wdata as input and pass to the channel n+1
 
    input                                      i_adpt_cfg_rdatavld, // CfgRd request data valid from channel n+1
    input [31:0]                               i_adpt_cfg_rdata, // Data returned for CfgRd access from channel n+1
    input                                      i_adpt_cfg_waitreq, // Asserted to indicate not ready for the Cfg access from channel n+1

 //===============================================================================================
 // Data Path
 // Rx Path clocks/data, from master (current chiplet) to slave (FPGA)
    input                                      i_rx_pma_clk, // Rx path clk for data receiving, may generated from xcvr pll
    input                                      i_rx_pma_div2_clk, // Divided by 2 clock on Rx pathinput                          
    
    input                                      i_osc_clk, // Oscillator clock generated from AIB AUX
    input [64:0]                               i_chnl_ssr, // Slow shift chain path
    input [39:0]                               i_rx_pma_data, // Directed bump rx data sync path
 
    input                                      i_rx_elane_clk, //Clock for phase compensation fifo
    input [77:0]                               i_rx_elane_data, //data in for phase compensation fifo
 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
    input                                      i_tx_pma_clk, // this clock is sent over to the other chiplet to be used for the clock
                                                                    // as the data transmission
    output                                     o_osc_clk, // this is the clock used for shift register path
    output [60:0]                              o_chnl_ssr, // Slow shift chain path
    output                                     o_tx_transfer_clk, // clock used for tx data transmission
    output                                     o_tx_transfer_div2_clk, // half rate of tx data transmission clock
    output [39:0]                              o_tx_pma_data, // Directed bump tx data sync path

    input                                      i_tx_elane_clk, //Clock for phase compensation fifo
    output [77:0]                              o_tx_elane_data,  //data out for phase compensation fifo
   //=================================================================================================
 //AIB open source IP enhancement. The following ports are added to b compliance with AIB specification 1.1
    input                                      ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive data. use aibio49
    input                                      ns_adapt_rstn, //From Mac. To reset near site adapt reset state machine and far site sm. Not implemented currently.
                                                              //Use aibio56
    output [80:0]                              ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
    output [72:0]                              sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet. 
    output                                     ms_rx_transfer_en, //master link rx transfer enable
    output                                     ms_tx_transfer_en, //master link tx transfer enable
    output                                     sl_rx_transfer_en, //slave link rx transfer enable
    output                                     sl_tx_transfer_en, //slave link tx transfer enable
    output                                     m_rxfifo_align_done, //Indicates the receiving data word alignment is detected during 2xFIFO mode when asserted to high. 
 //=================================================================================================
 //// EMIB, AIB IO bumps
 
    inout                                      io_aib0, 
    inout                                      io_aib1, 
    inout                                      io_aib10, 
    inout                                      io_aib11, 
    inout                                      io_aib12, 
    inout                                      io_aib13, 
    inout                                      io_aib14, 
    inout                                      io_aib15, 
    inout                                      io_aib16, 
    inout                                      io_aib17, 
    inout                                      io_aib18, 
    inout                                      io_aib19, 
    inout                                      io_aib2, 
    inout                                      io_aib20, 
    inout                                      io_aib21, 
    inout                                      io_aib22, 
    inout                                      io_aib23, 
    inout                                      io_aib24, 
    inout                                      io_aib25, 
    inout                                      io_aib26, 
    inout                                      io_aib27, 
    inout                                      io_aib28, 
    inout                                      io_aib29, 
    inout                                      io_aib3, 
    inout                                      io_aib30, 
    inout                                      io_aib31, 
    inout                                      io_aib32, 
    inout                                      io_aib33, 
    inout                                      io_aib34, 
    inout                                      io_aib35, 
    inout                                      io_aib36, 
    inout                                      io_aib37, 
    inout                                      io_aib38, 
    inout                                      io_aib39, 
    inout                                      io_aib4, 
    inout                                      io_aib40, 
    inout                                      io_aib41, 
    inout                                      io_aib42, 
    inout                                      io_aib43, 
    inout                                      io_aib44, 
    inout                                      io_aib45, 
    inout                                      io_aib46, 
    inout                                      io_aib47, 
    inout                                      io_aib48, 
    inout                                      io_aib49, 
    inout                                      io_aib5, 
    inout                                      io_aib50, 
    inout                                      io_aib51, 
    inout                                      io_aib52, 
    inout                                      io_aib53, 
    inout                                      io_aib54, 
    inout                                      io_aib55, 
    inout                                      io_aib56, 
    inout                                      io_aib57, 
    inout                                      io_aib58, 
    inout                                      io_aib59, 
    inout                                      io_aib6, 
    inout                                      io_aib60, 
    inout                                      io_aib61, 
    inout                                      io_aib62, 
    inout                                      io_aib63, 
    inout                                      io_aib64, 
    inout                                      io_aib65, 
    inout                                      io_aib66, 
    inout                                      io_aib67, 
    inout                                      io_aib68, 
    inout                                      io_aib69, 
    inout                                      io_aib7, 
    inout                                      io_aib70, 
    inout                                      io_aib71, 
    inout                                      io_aib72, 
    inout                                      io_aib73, 
    inout                                      io_aib74, 
    inout                                      io_aib75, 
    inout                                      io_aib76, 
    inout                                      io_aib77, 
    inout                                      io_aib78, 
    inout                                      io_aib79, 
    inout                                      io_aib8, 
    inout                                      io_aib80, 
    inout                                      io_aib81, 
    inout                                      io_aib82, 
    inout                                      io_aib83, 
    inout                                      io_aib84, 
    inout                                      io_aib85, 
    inout                                      io_aib86, 
    inout                                      io_aib87, 
    inout                                      io_aib88, 
    inout                                      io_aib89, 
    inout                                      io_aib9, 
    inout                                      io_aib90, 
    inout                                      io_aib91, 
    inout                                      io_aib92, 
    inout                                      io_aib93, 
    inout                                      io_aib94, 
    inout                                      io_aib95, 

  //================================================================================================
  // DFT related interface
  // DFT CLK  All go to c3dfx_aibadaptwrap_tcb.
  // the below four clock is from one common source.  JZ 03/28/2018, 
  // so comment out three of them, and tie all to i_scan_clk JS 03/28/18
    input                                      i_scan_clk, // Four scan clock from common test pin for scan shifting 
//    input                                      i_scan_clk2, // Scan shift clock. Same as i_scan_clk1 ~150MHz 
//    input                                      i_scan_clk3, // Scan shift clock. Same as i_scan_clk1 ~150MHz 
//    input                                      i_scan_clk4, // Scan shift clock. Same as i_scan_clk1 ~150MHz 
  
    input                                      i_test_clk_1g, // Capture Clock used for SAF and at speed test. 
    input                                      i_test_clk_500m,// Capture clock divided down from i_test_clk_1g 
    input                                      i_test_clk_250m,// Capture clock divided down from i_test_clk_1g
    input                                      i_test_clk_125m,// Capture clock divided down from i_test_clk_1g 
    input                                      i_test_clk_62m, // Capture clock divided down from i_test_clk_1g 

  //i_test_c3adapt_tcb_jtag and i_test_c3adapt_tcb_jtag_common connected to c3dfx_aibadaptwrap_tcb 
  //but not used inside the c3dfx_aibadaptwrap_tcb block  JZ 03/28/2018
  //commented out the two signals below JS 03/28/18

//    input [`AIBADAPTWRAPTCB_JTAG_IN_RNG]       i_test_c3adapt_tcb_jtag,//Not Used 
//    input [`AIBADAPTWRAPTCB_JTAG_COMMON_RNG]   i_test_c3adapt_tcb_jtag_common,//Not Used
 
    input [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG] i_test_c3adapt_tcb_static_common,//Used for ATPG mode control how to drive TCM
    input [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]   i_test_c3adapt_scan_in,//From top level codec scan in. 17 bit 
    output [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  o_test_c3adapt_scan_out,//To top level TCB codec for output compression 17bit 
                                                                       //bit [10:0] full scan.
                                                                       //    [11]   i_atpg_scan_out0
                                                                       //    [12]   i_atpg_scan_out1
                                                                       //    [16:13]i_atpg_bsr3-0_scan_out
    output [`AIBADAPTWRAPTCB_JTAG_OUT_RNG]     o_test_c3adapttcb_jtag, //13 bit dftdll2core Go to toplevel tcb block.
// DFT JTAG
  // i_tck not used JZ 04/01/18 commented by by JS 04/02/18
 //    input                                      i_tck,   
    input                                      i_jtag_rstb_in, // JTAG controlleable reset the AIB IO circuitry
    input                                      i_jtag_rstb_en_in, // JTAG controlleable override to reset the AIB IO circuitry
    input                                      i_jtag_clkdr_in, // Enable AIB IO boundary scan clock (clock gate control) 
    input                                      i_jtag_clksel_in, // Select between i_jtag_clkdr_in and functional clk
                                                                  // for TRANSMIT_EN signal launch 
    input                                      i_jtag_intest_in, // Enable in test operation 
    input                                      i_jtag_mode_in, // Selects between AIB BSR register or functional path 
    input                                      i_jtag_weakpdn_in, // Enable weak pull down. Connect to all AIB IO cell 
    input                                      i_jtag_weakpu_in, // Enable weak pull up. Connect to all AIB IO cell 
    input                                      i_jtag_bs_scanen_in, // Drives AIB IO jtag_tx_scanen_in or BSR shift control 
    input                                      i_jtag_bs_chain_in, // TDI 
    input                                      i_jtag_last_bs_chain_in,//From last channel. This has the opposite routing direction
                                                                       //as i_jtag_bs_chain_in
// Feed through pass to next adaptor. User can implement different way depends
// on their P&R flow
    output                                     o_jtag_clkdr_out, 
    output                                     o_jtag_clksel_out, 
    output                                     o_jtag_intest_out, 
    output                                     o_jtag_mode_out, 
    output                                     o_jtag_rstb_en_out, 
    output                                     o_jtag_rstb_out, 
    output                                     o_jtag_weakpdn_out, 
    output                                     o_jtag_weakpu_out, 

    output                                     o_jtag_bs_chain_out, 
    output                                     o_jtag_bs_scanen_out, 
    output                                     o_jtag_last_bs_chain_out,

//Interface with AUX
    input                                      i_por_aib_vcchssi, //output of por circuit 
    input                                      i_por_aib_vccl, //From AUX. From S10 
    output                                     o_por_aib_vcchssi, // Feed through pass to next channel 
    output                                     o_por_aib_vccl, // 

// To Red BSR Redundency. Connection between channels
    input                                      i_red_idataselb_in_chain1,// 
    input                                      i_red_idataselb_in_chain2,// 
    input                                      i_red_shift_en_in_chain1,// 
    input                                      i_red_shift_en_in_chain2,// 
    input                                      i_txen_in_chain1, // Redundency signal 
    input                                      i_txen_in_chain2, // Redundency signal
    input                                      i_directout_data_chain1_in,//  
    input                                      i_directout_data_chain2_in,// 

    output                                     o_red_idataselb_out_chain1,// 
    output                                     o_red_idataselb_out_chain2,// 
    output                                     o_red_shift_en_out_chain1,// 
    output                                     o_red_shift_en_out_chain2,// 
    output                                     o_txen_out_chain1, 
    output                                     o_txen_out_chain2,
    output                                     o_directout_data_chain1_out,
    output                                     o_directout_data_chain2_out,


// Go to next Channel AIB
    input [12:0]                               i_aibdftdll2adjch, // DCC/DLL observability from previous channel
    output [12:0]                              o_aibdftdll2adjch  // DCC/DLL observability Go to next channel 
 );

    //List the detail bit assignment corresponding to the AIB spec 1.1
    assign ms_tx_transfer_en = ms_sideband[78];
    assign ms_rx_transfer_en = ms_sideband[75];
    assign sl_rx_transfer_en = sl_sideband[70];
    assign sl_tx_transfer_en = sl_sideband[64];
    wire ms_osc_transfer_en = ms_sideband[80];
    wire ms_rx_dll_lock = ms_sideband[74];
    wire ms_tx_dcc_cal_done = ms_sideband[68];
    wire sl_osc_transfer_en = sl_sideband[72]; 
    wire sl_rx_dll_dcc_lock_req = sl_sideband[69];
    wire sl_rx_dll_lock = sl_sideband[69];
    wire sl_tx_dll_dcc_lock_req = sl_sideband[63];
    wire sl_tx_dcc_cal_done = sl_sideband[31];
 
    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire                adpt_aib_avmm1_data;    // From c3aibadapt of c3aibadapt.v
    wire                adpt_aib_avmm2_data;    // From c3aibadapt of c3aibadapt.v
    wire                adpt_aib_fsr_data;      // From c3aibadapt of c3aibadapt.v
    wire                adpt_aib_fsr_load;      // From c3aibadapt of c3aibadapt.v
    wire                adpt_aib_ssr_data;      // From c3aibadapt of c3aibadapt.v
    wire                adpt_aib_ssr_load;      // From c3aibadapt of c3aibadapt.v
    wire [1:0]          aib_adpt_avmm1_data;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire [1:0]          aib_adpt_avmm2_data;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_adpt_fsr_data;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_adpt_fsr_load;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_adpt_ssr_data;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_adpt_ssr_load;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_bsr_scan_shift_clk; // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_0;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_1;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_10;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_11;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_12;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_13;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_14;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_15;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_16;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_17;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_18;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_19;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_2;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_20;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_21;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_22;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_23;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_24;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_25;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_26;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_27;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_28;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_29;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_3;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_30;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_31;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_32;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_33;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_34;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_35;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_36;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_37;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_38;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_39;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_4;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_40;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_41;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_42;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_43;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_44;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_45;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_46;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_47;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_48;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_49;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_5;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_50;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_51;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_52;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_53;        // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_6;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_7;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_8;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_csr_ctrl_9;         // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_dprio_ctrl_0;       // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_dprio_ctrl_1;       // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_dprio_ctrl_2;       // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_dprio_ctrl_3;       // From c3aibadapt of c3aibadapt.v
    wire [7:0]          aib_dprio_ctrl_4;       // From c3aibadapt of c3aibadapt.v
    wire                aib_h_clk;              // From c3aibadapt of c3aibadapt.v
    wire                aib_internal1_clk;      // From c3aibadapt of c3aibadapt.v
    wire                aib_internal2_clk;      // From c3aibadapt of c3aibadapt.v
    wire                aib_pld_pma_txdetectrx; // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_pld_sclk;           // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_rsvd_direct_async;  // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_adpt_rst_n;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire [39:0]         aib_rx_data;            // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_dcd_cal_done;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_rx_dcd_cal_req;     // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_elane_rst_n;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_rx_fifo_latency_pls;// From c3aibadapt of c3aibadapt.v
    wire                aib_rx_pma_div2_clk;    // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_pma_div66_clk;   // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_sr_clk;          // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_rx_transfer_clk;    // From c3aibadapt of c3aibadapt.v
    wire                aib_rx_xcvrif_rst_n;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_adpt_rst_n;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire [39:0]         aib_tx_data;            // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_dcd_cal_done;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_dcd_cal_req;     // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_dll_lock;        // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_dll_lock_req;    // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_elane_rst_n;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_fifo_latency_pls;// From c3aibadapt of c3aibadapt.v
    wire                aib_tx_pma_clk;         // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_pma_div2_clk;    // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_pma_div66_clk;   // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_sr_clk;          // From c3aibadapt of c3aibadapt.v
    wire                aib_tx_sr_clk_in;       // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_transfer_clk;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_tx_xcvrif_rst_n;    // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                aib_xcvrif_rx_rdy;      // From c3aibadapt of c3aibadapt.v
    wire                aib_xcvrif_tx_rdy;      // From c3aibadapt of c3aibadapt.v
    wire [1:0]          aibdftcore2dll;         // From c3aibadapt of c3aibadapt.v
    wire [12:0]         aibdftdll2core;         // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                atpg_bsr0_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr0_scan_out;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                atpg_bsr1_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr1_scan_out;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                atpg_bsr2_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr2_scan_out;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                atpg_bsr3_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr3_scan_out;     // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                atpg_bsr_scan_shift_n;  // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                pld_pma_coreclkin;      // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire [4:0]          shared_direct_async_in; // From c3aibadapt of c3aibadapt.v
    wire [2:0]          shared_direct_async_out;// From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                w_atpg_scan_in0;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_atpg_scan_in1;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_atpg_scan_out0;       // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                w_atpg_scan_out1;       // From xaibcr3_top_wrp of aibcr3_top_wrp.v
    wire                w_avmm1_scan_clk;       // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_avmm1_test_clk;       // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_avmm1_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [1:0]          w_dftcore2dll;          // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [12:0]         w_dftdll2core;          // From c3aibadapt of c3aibadapt.v
    wire                w_global_pipe_scanen;   // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_rxchnl_scan_clk;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_rxchnl_test_clk;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_rxchnl_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_scan_mode_n;          // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_scan_rst_n;           // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_scan_shift_n;         // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_0_scan_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_0_test_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_sr_0_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_1_scan_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_1_test_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_sr_1_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_2_scan_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_2_test_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_sr_2_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_3_scan_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_sr_3_test_clk;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_sr_3_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_0_scan_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_0_test_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_txchnl_0_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_1_scan_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_1_test_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_txchnl_1_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_2_scan_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_txchnl_2_test_clk;    // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_txchnl_2_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    // End of automatics

    /*c3aibadapt AUTO_TEMPLATE(
    .i_aib_rx_adpt_rst_n                    (aib_rx_adpt_rst_n),
    .i_aib_tx_adpt_rst_n                    (aib_tx_adpt_rst_n),
    .i_aib_avmm1_data                       (aib_adpt_avmm1_data[]),
    .i_aib_avmm2_data                       (aib_adpt_avmm2_data[]),
    .o_aib_avmm1_data                       (adpt_aib_avmm1_data[]),
    .o_aib_avmm2_data                       (adpt_aib_avmm2_data[]),
    .i_aib_shared_direct_async              (shared_direct_async_out[]),
    .o_aib_shared_direct_async              (shared_direct_async_in[]),  
    .i_aib_fsr_data                         (aib_adpt_fsr_data[]),
    .i_aib_fsr_load                         (aib_adpt_fsr_load),
    .o_aib_fsr_data                         (adpt_aib_fsr_data[]),
    .o_aib_fsr_load                         (adpt_aib_fsr_load),
    .i_aib_rx_elane_rst_n                   (aib_rx_elane_rst_n),
    .i_aib_tx_elane_rst_n                   (aib_tx_elane_rst_n),
    .o_aib_rsvd_direct_async                (aib_rsvd_direct_async),
    .o_aib_rx_pma_div2_clk                  (aib_rx_pma_div2_clk),
    .o_aib_tx_pma_div2_clk                  (aib_tx_pma_div2_clk),
    .o_aib_rx_pma_div66_clk                 (aib_rx_pma_div66_clk),
    .o_aib_tx_pma_div66_clk                 (aib_tx_pma_div66_clk),
    .i_aib_core_clk                         (pld_pma_coreclkin),
    .o_aib_h_clk                            (aib_h_clk),
    .o_aib_bsr_scan_shift_clk               (aib_bsr_scan_shift_clk),
    .o_aib_internal1_clk                    (aib_internal1_clk),
    .o_aib_internal2_clk                    (aib_internal2_clk),
    .o_aib_xcvrif_tx_rdy                    (aib_xcvrif_tx_rdy),
    .o_aib_xcvrif_rx_rdy                    (aib_xcvrif_rx_rdy),
    .i_aib_rx_xcvrif_rst_n                  (aib_rx_xcvrif_rst_n),
    .i_aib_rsvd_direct_async                (aib_pld_pma_txdetectrx),
    .i_aib_tx_xcvrif_rst_n                  (aib_tx_xcvrif_rst_n),
    .o_aib_rx_fifo_latency_pls              (aib_rx_fifo_latency_pls[]),
    .i_aib_sclk                             (aib_pld_sclk),
    .o_aib_tx_fifo_latency_pls              (aib_tx_fifo_latency_pls[]),
    .o_aib_tx_pma_clk                       (aib_tx_pma_clk),                   // full-rate TX PMA clock
    .o_aib_rx_data                          (aib_rx_data[]),
    .i_aib_rx_dcd_cal_done                  (aib_rx_dcd_cal_done),
    .o_aib_rx_dcd_cal_req                   (aib_rx_dcd_cal_req),
    .i_aib_rx_sr_clk                        (aib_rx_sr_clk),
    .o_aib_rx_transfer_clk                  (aib_rx_transfer_clk),
    .i_aib_ssr_data                         (aib_adpt_ssr_data[]),
    .o_aib_ssr_data                         (adpt_aib_ssr_data[]),
    .i_aib_ssr_load                         (aib_adpt_ssr_load),
    .o_aib_ssr_load                         (adpt_aib_ssr_load),
    .i_aib_tx_data                          (aib_tx_data[]),
    .i_aib_tx_dcd_cal_done                  (aib_tx_dcd_cal_done),
    .o_aib_tx_dcd_cal_req                   (aib_tx_dcd_cal_req),
    .i_aib_tx_dll_lock                      (aib_tx_dll_lock),
    .o_aib_tx_dll_lock_req                  (aib_tx_dll_lock_req),
    .i_aib_tx_sr_clk                        (aib_tx_sr_clk_in),
    .o_aib_tx_sr_clk                        (aib_tx_sr_clk),
    .i_aib_tx_transfer_clk                  (aib_tx_transfer_clk),
    .o_aib_csr_ctrl_\(.*\)                  (aib_csr_ctrl_\1[]),
    .o_aib_dprio_ctrl_\(.*\)                (aib_dprio_ctrl_\1[]),
    .i_adpt_hard_rst_n                      (i_adpt_hard_rst_n),
    .o_adpt_hard_rst_n                      (o_adpt_hard_rst_n),

    .i_cfg_avmm_addr_id                     (i_channel_id[]),
    .i_cfg_avmm_rst_n                       (i_cfg_avmm_rst_n),
    .i_cfg_avmm_clk                         (i_cfg_avmm_clk),
    .i_cfg_avmm_addr                        (i_cfg_avmm_addr[]),
    .i_cfg_avmm_write                       (i_cfg_avmm_write),
    .i_cfg_avmm_read                        (i_cfg_avmm_read),
    .i_cfg_avmm_wdata                       (i_cfg_avmm_wdata[]),
    .i_cfg_avmm_byte_en                     (i_cfg_avmm_byte_en[]),
    .o_cfg_avmm_rdata                       (o_cfg_avmm_rdata[]),
    .o_cfg_avmm_rdatavld                    (o_cfg_avmm_rdatavld),
    .o_cfg_avmm_waitreq                     (o_cfg_avmm_waitreq),

    .o_adpt_cfg_clk                         (o_adpt_cfg_clk),
    .o_adpt_cfg_addr                        (o_adpt_cfg_addr[]),
    .o_adpt_cfg_byte_en                     (o_adpt_cfg_byte_en[]),
    .o_adpt_cfg_write                       (o_adpt_cfg_write),
    .o_adpt_cfg_read                        (o_adpt_cfg_read),
    .o_adpt_cfg_wdata                       (o_adpt_cfg_wdata[]),
    .i_adpt_cfg_rdata                       (i_adpt_cfg_rdata[]),
    .i_adpt_cfg_rdatavld                    (i_adpt_cfg_rdatavld),
    .i_adpt_cfg_waitreq                     (i_adpt_cfg_waitreq),

    .o_adpt_cfg_rst_n                       (o_adpt_cfg_rst_n),
    .o_user_mode                            (),
    .i_scan_mode_n                          (w_scan_mode_n),
    .i_rxchnl_tst_tcm_ctrl                  (w_rxchnl_tst_tcm_ctrl[]),
    .i_rxchnl_test_clk                      (w_rxchnl_test_clk),
    .i_rxchnl_scan_clk                      (w_rxchnl_scan_clk),
    .i_txchnl_0_tst_tcm_ctrl                (w_txchnl_0_tst_tcm_ctrl[]),
    .i_txchnl_0_test_clk                    (w_txchnl_0_test_clk),
    .i_txchnl_0_scan_clk                    (w_txchnl_0_scan_clk),
    .i_txchnl_1_tst_tcm_ctrl                (w_txchnl_1_tst_tcm_ctrl[]),
    .i_txchnl_1_test_clk                    (w_txchnl_1_test_clk),
    .i_txchnl_1_scan_clk                    (w_txchnl_1_scan_clk),
    .i_txchnl_2_tst_tcm_ctrl                (w_txchnl_2_tst_tcm_ctrl[]),
    .i_txchnl_2_test_clk                    (w_txchnl_2_test_clk),
    .i_txchnl_2_scan_clk                    (w_txchnl_2_scan_clk),
    .i_sr_0_tst_tcm_ctrl                    (w_sr_0_tst_tcm_ctrl[]),
    .i_sr_0_test_clk                        (w_sr_0_test_clk),
    .i_sr_0_scan_clk                        (w_sr_0_scan_clk),
    .i_sr_1_tst_tcm_ctrl                    (w_sr_1_tst_tcm_ctrl[]),
    .i_sr_1_test_clk                        (w_sr_1_test_clk),
    .i_sr_1_scan_clk                        (w_sr_1_scan_clk),
    .i_sr_2_tst_tcm_ctrl                    (w_sr_2_tst_tcm_ctrl[]),
    .i_sr_2_test_clk                        (w_sr_2_test_clk),
    .i_sr_2_scan_clk                        (w_sr_2_scan_clk),
    .i_sr_3_tst_tcm_ctrl                    (w_sr_3_tst_tcm_ctrl[]),
    .i_sr_3_test_clk                        (w_sr_3_test_clk),
    .i_sr_3_scan_clk                        (w_sr_3_scan_clk),
    .i_avmm1_tst_tcm_ctrl                   (w_avmm1_tst_tcm_ctrl[]),
    .i_avmm1_test_clk                       (w_avmm1_test_clk),
    .i_avmm1_scan_clk                       (w_avmm1_scan_clk),
    .i_user_mode                            (1'b0),
    .i_scan_rst_n                           (w_scan_rst_n),
    .i_dftcore2dll                          (w_dftcore2dll[]),               // from TCB
    .o_dftdll2core                          (w_dftdll2core[]),               // to TCB
    .o_aibdftcore2dll                       (aibdftcore2dll[]),
    .i_aibdftdll2core                       (aibdftdll2core[]),

    .o_ehip_fsr                             (),
    .i_ehip_fsr                             ({@"vl-width"{1'b0}}),
    .o_ehip_ssr                             (),
    .o_ehip_init_status                     (o_ehip_init_status[]),
    .o_tx_ehip_data                         (),
    .i_rx_ehip_data                         ({@"vl-width"{1'b0}}),
    .i_fpll_shared_direct_async             (5'b00000),                    //Currently used by Adapter to probe internal signals
    .o_fpll_shared_direct_async             (),                            //Currently used by Adapter to select probe internal signals
    .i_rx_chnl_rsvd                         (1'b0),                        //Currently used by Adapter to probe internal signal
    .i_ehip_ssr                             ({@"vl-width"{1'b0}}),
    .o_rx_elane_rst_n                       (),
    .o_tx_elane_rst_n                       (),
    .i_rsvd_direct_async                    (1'b0),                        // 

    .i_\(.*\)_cfg_waitreq                   (1'b1),
    .o_xcvrif_\(.*\)                        (),
    .i_xcvrif_\(.*\)                        ({@"vl-width"{1'b0}}),
    .o_elane_\(.*\)                         (),
    .i_elane_\(.*\)                         ({@"vl-width"{1'b0}}),
    .o_ehip_\(.*\)                          (),
    .i_ehip_\(.*\)                          ({@"vl-width"{1'b0}}),

    .o_tx_elane_data                        (o_tx_elane_data),
    .i_rx_elane_data                        (i_rx_elane_data),

    .i_rx_rsfec_clk                         (1'b1),
    .i_rx_rsfec_frd_clk                     (1'b1),
    .i_tx_rsfec_clk                         (1'b1),
    .o_tx_rsfec_data                        (),
    .i_rx_rsfec_data                        ({@"vl-width"{1'b0}}),

    .i_rx_elane_clk                         (i_rx_elane_clk),
    .i_tx_elane_clk                         (i_tx_elane_clk),
 // .i_rx_pma_div66_clk                     (1'b1),
    .i_rx_pma_div66_clk                     (ns_mac_rdy),    //Added for AIB spec 1.1 enhancement. 6/12/19
    .i_tx_pma_div66_clk                     (ns_adapt_rstn), //Added per tim 10/27/2019
    .i_rx_ehip_clk                          (1'b1),
     
    .i_tx_ehip_clk                          (1'b1),
    .i_rx_ehip_frd_clk                      (1'b1),
    .i_xcvrif_tx_latency_pls                ({@"vl-width"{1'b0}}),
    .i_xcvrif_rx_latency_pls                ({@"vl-width"{1'b0}}),
    .i_feedthru_clk                         ({@"vl-width"{i_rx_pma_clk}}),
    .o_xcvrif_core_clk                      (),                                         
    .i_xcvrif_tx_rdy                        (1'b1),
    .i_xcvrif_rx_rdy                        (1'b1),
    .o_rx_xcvrif_rst_n                      (o_rx_xcvrif_rst_n),
    .o_rsvd_direct_async                    (),
    .o_tx_xcvrif_rst_n                      (o_tx_xcvrif_rst_n),
    .o_chnl_fsr                             (), 
    .i_chnl_fsr                             ({@"vl-width"{1'b0}}), 
    );
    */
    
    c3aibadapt c3aibadapt (/*AUTOINST*/
                           // Outputs
                           .o_adpt_hard_rst_n   (o_adpt_hard_rst_n), // Templated
                           .o_user_mode         (),              // Templated
                           .o_adpt_cfg_clk      (o_adpt_cfg_clk), // Templated
                           .o_adpt_cfg_rst_n    (o_adpt_cfg_rst_n), // Templated
                           .o_adpt_cfg_addr     (o_adpt_cfg_addr[16:0]), // Templated
                           .o_adpt_cfg_wdata    (o_adpt_cfg_wdata[31:0]), // Templated
                           .o_adpt_cfg_write    (o_adpt_cfg_write), // Templated
                           .o_adpt_cfg_read     (o_adpt_cfg_read), // Templated
                           .o_adpt_cfg_byte_en  (o_adpt_cfg_byte_en[3:0]), // Templated
                           .o_cfg_avmm_rdata    (o_cfg_avmm_rdata[31:0]), // Templated
                           .o_cfg_avmm_rdatavld (o_cfg_avmm_rdatavld), // Templated
                           .o_cfg_avmm_waitreq  (o_cfg_avmm_waitreq), // Templated
                           .o_elane_cfg_clk     (),              // Templated
                           .o_elane_cfg_rst_n   (),              // Templated
                           .o_elane_cfg_active  (),              // Templated
                           .o_elane_cfg_write   (),              // Templated
                           .o_elane_cfg_read    (),              // Templated
                           .o_elane_cfg_addr    (),              // Templated
                           .o_elane_cfg_wdata   (),              // Templated
                           .o_elane_cfg_byte_en (),              // Templated
                           .o_xcvrif_sclk       (),              // Templated
                           .o_xcvrif_cfg_clk    (),              // Templated
                           .o_xcvrif_cfg_rst_n  (),              // Templated
                           .o_xcvrif_cfg_active (),              // Templated
                           .o_xcvrif_cfg_write  (),              // Templated
                           .o_xcvrif_cfg_read   (),              // Templated
                           .o_xcvrif_cfg_addr   (),              // Templated
                           .o_xcvrif_cfg_wdata  (),              // Templated
                           .o_xcvrif_cfg_byte_en(),              // Templated
                           .o_aib_avmm1_data    (adpt_aib_avmm1_data), // Templated
                           .o_aib_avmm2_data    (adpt_aib_avmm2_data), // Templated
                           .o_aib_shared_direct_async(shared_direct_async_in[4:0]), // Templated
                           .o_aib_fsr_data      (adpt_aib_fsr_data), // Templated
                           .o_aib_fsr_load      (adpt_aib_fsr_load), // Templated
                           .o_aib_rsvd_direct_async(aib_rsvd_direct_async), // Templated
                           .o_aib_rx_pma_div2_clk(aib_rx_pma_div2_clk), // Templated
                           .o_aib_tx_pma_div2_clk(aib_tx_pma_div2_clk), // Templated
                           .o_aib_rx_pma_div66_clk(aib_rx_pma_div66_clk), // Templated
                           .o_aib_tx_pma_div66_clk(aib_tx_pma_div66_clk), // Templated
                           .o_aib_h_clk         (aib_h_clk),     // Templated
                           .o_aib_bsr_scan_shift_clk(aib_bsr_scan_shift_clk), // Templated
                           .o_aib_internal1_clk (aib_internal1_clk), // Templated
                           .o_aib_internal2_clk (aib_internal2_clk), // Templated
                           .o_aib_xcvrif_tx_rdy (aib_xcvrif_tx_rdy), // Templated
                           .o_aib_xcvrif_rx_rdy (aib_xcvrif_rx_rdy), // Templated
                           .o_aib_rx_fifo_latency_pls(aib_rx_fifo_latency_pls), // Templated
                           .o_aib_tx_fifo_latency_pls(aib_tx_fifo_latency_pls), // Templated
                           .o_aib_tx_pma_clk    (aib_tx_pma_clk), // Templated
                           .o_aib_rx_data       (aib_rx_data[39:0]), // Templated
                           .o_aib_rx_dcd_cal_req(aib_rx_dcd_cal_req), // Templated
                           .o_aib_rx_transfer_clk(aib_rx_transfer_clk), // Templated
                           .o_aib_ssr_data      (adpt_aib_ssr_data), // Templated
                           .o_aib_ssr_load      (adpt_aib_ssr_load), // Templated
                           .o_aib_tx_dcd_cal_req(aib_tx_dcd_cal_req), // Templated
                           .o_aib_tx_dll_lock_req(aib_tx_dll_lock_req), // Templated
                           .o_aib_tx_sr_clk     (aib_tx_sr_clk), // Templated
                           .o_aib_csr_ctrl_0    (aib_csr_ctrl_0[7:0]), // Templated
                           .o_aib_csr_ctrl_1    (aib_csr_ctrl_1[7:0]), // Templated
                           .o_aib_csr_ctrl_10   (aib_csr_ctrl_10[7:0]), // Templated
                           .o_aib_csr_ctrl_11   (aib_csr_ctrl_11[7:0]), // Templated
                           .o_aib_csr_ctrl_12   (aib_csr_ctrl_12[7:0]), // Templated
                           .o_aib_csr_ctrl_13   (aib_csr_ctrl_13[7:0]), // Templated
                           .o_aib_csr_ctrl_14   (aib_csr_ctrl_14[7:0]), // Templated
                           .o_aib_csr_ctrl_15   (aib_csr_ctrl_15[7:0]), // Templated
                           .o_aib_csr_ctrl_16   (aib_csr_ctrl_16[7:0]), // Templated
                           .o_aib_csr_ctrl_17   (aib_csr_ctrl_17[7:0]), // Templated
                           .o_aib_csr_ctrl_18   (aib_csr_ctrl_18[7:0]), // Templated
                           .o_aib_csr_ctrl_19   (aib_csr_ctrl_19[7:0]), // Templated
                           .o_aib_csr_ctrl_2    (aib_csr_ctrl_2[7:0]), // Templated
                           .o_aib_csr_ctrl_20   (aib_csr_ctrl_20[7:0]), // Templated
                           .o_aib_csr_ctrl_21   (aib_csr_ctrl_21[7:0]), // Templated
                           .o_aib_csr_ctrl_22   (aib_csr_ctrl_22[7:0]), // Templated
                           .o_aib_csr_ctrl_23   (aib_csr_ctrl_23[7:0]), // Templated
                           .o_aib_csr_ctrl_24   (aib_csr_ctrl_24[7:0]), // Templated
                           .o_aib_csr_ctrl_25   (aib_csr_ctrl_25[7:0]), // Templated
                           .o_aib_csr_ctrl_26   (aib_csr_ctrl_26[7:0]), // Templated
                           .o_aib_csr_ctrl_27   (aib_csr_ctrl_27[7:0]), // Templated
                           .o_aib_csr_ctrl_28   (aib_csr_ctrl_28[7:0]), // Templated
                           .o_aib_csr_ctrl_29   (aib_csr_ctrl_29[7:0]), // Templated
                           .o_aib_csr_ctrl_3    (aib_csr_ctrl_3[7:0]), // Templated
                           .o_aib_csr_ctrl_30   (aib_csr_ctrl_30[7:0]), // Templated
                           .o_aib_csr_ctrl_31   (aib_csr_ctrl_31[7:0]), // Templated
                           .o_aib_csr_ctrl_32   (aib_csr_ctrl_32[7:0]), // Templated
                           .o_aib_csr_ctrl_33   (aib_csr_ctrl_33[7:0]), // Templated
                           .o_aib_csr_ctrl_34   (aib_csr_ctrl_34[7:0]), // Templated
                           .o_aib_csr_ctrl_35   (aib_csr_ctrl_35[7:0]), // Templated
                           .o_aib_csr_ctrl_36   (aib_csr_ctrl_36[7:0]), // Templated
                           .o_aib_csr_ctrl_37   (aib_csr_ctrl_37[7:0]), // Templated
                           .o_aib_csr_ctrl_38   (aib_csr_ctrl_38[7:0]), // Templated
                           .o_aib_csr_ctrl_39   (aib_csr_ctrl_39[7:0]), // Templated
                           .o_aib_csr_ctrl_4    (aib_csr_ctrl_4[7:0]), // Templated
                           .o_aib_csr_ctrl_40   (aib_csr_ctrl_40[7:0]), // Templated
                           .o_aib_csr_ctrl_41   (aib_csr_ctrl_41[7:0]), // Templated
                           .o_aib_csr_ctrl_42   (aib_csr_ctrl_42[7:0]), // Templated
                           .o_aib_csr_ctrl_43   (aib_csr_ctrl_43[7:0]), // Templated
                           .o_aib_csr_ctrl_44   (aib_csr_ctrl_44[7:0]), // Templated
                           .o_aib_csr_ctrl_45   (aib_csr_ctrl_45[7:0]), // Templated
                           .o_aib_csr_ctrl_46   (aib_csr_ctrl_46[7:0]), // Templated
                           .o_aib_csr_ctrl_47   (aib_csr_ctrl_47[7:0]), // Templated
                           .o_aib_csr_ctrl_48   (aib_csr_ctrl_48[7:0]), // Templated
                           .o_aib_csr_ctrl_49   (aib_csr_ctrl_49[7:0]), // Templated
                           .o_aib_csr_ctrl_5    (aib_csr_ctrl_5[7:0]), // Templated
                           .o_aib_csr_ctrl_50   (aib_csr_ctrl_50[7:0]), // Templated
                           .o_aib_csr_ctrl_51   (aib_csr_ctrl_51[7:0]), // Templated
                           .o_aib_csr_ctrl_52   (aib_csr_ctrl_52[7:0]), // Templated
                           .o_aib_csr_ctrl_53   (aib_csr_ctrl_53[7:0]), // Templated
                           .o_aib_csr_ctrl_6    (aib_csr_ctrl_6[7:0]), // Templated
                           .o_aib_csr_ctrl_7    (aib_csr_ctrl_7[7:0]), // Templated
                           .o_aib_csr_ctrl_8    (aib_csr_ctrl_8[7:0]), // Templated
                           .o_aib_csr_ctrl_9    (aib_csr_ctrl_9[7:0]), // Templated
                           .o_aib_dprio_ctrl_0  (aib_dprio_ctrl_0[7:0]), // Templated
                           .o_aib_dprio_ctrl_1  (aib_dprio_ctrl_1[7:0]), // Templated
                           .o_aib_dprio_ctrl_2  (aib_dprio_ctrl_2[7:0]), // Templated
                           .o_aib_dprio_ctrl_3  (aib_dprio_ctrl_3[7:0]), // Templated
                           .o_aib_dprio_ctrl_4  (aib_dprio_ctrl_4[7:0]), // Templated
                           .o_aibdftcore2dll    (aibdftcore2dll[1:0]), // Templated
                           .o_dftdll2core       (w_dftdll2core[12:0]), // Templated
                           .o_ehip_usr_clk      (),              // Templated
                           .o_ehip_usr_read     (),              // Templated
                           .o_ehip_usr_addr     (),              // Templated
                           .o_ehip_usr_write    (),              // Templated
                           .o_ehip_usr_wdata    (),              // Templated
                           .o_ehip_cfg_clk      (),              // Templated
                           .o_ehip_cfg_rst_n    (),              // Templated
                           .o_ehip_cfg_read     (),              // Templated
                           .o_ehip_cfg_write    (),              // Templated
                           .o_ehip_cfg_addr     (),              // Templated
                           .o_ehip_cfg_byte_en  (),              // Templated
                           .o_ehip_cfg_wdata    (),              // Templated
                           .o_ehip_fsr          (),              // Templated
                           .o_ehip_ssr          (),              // Templated
                           .o_ehip_init_status  (o_ehip_init_status[2:0]), // Templated
                           .o_tx_ehip_data      (),              // Templated
                           .o_tx_rsfec_data     (),              // Templated
                           .o_tx_pma_data       (o_tx_pma_data[39:0]),
                           .o_tx_elane_data     (o_tx_elane_data[77:0]),   // Templated
                           .o_fpll_shared_direct_async(),        // Templated
                           .o_rx_elane_rst_n    (),              // Templated
                           .o_tx_elane_rst_n    (),              // Templated
                           .o_chnl_ssr          (o_chnl_ssr[60:0]),
                           .o_chnl_fsr          (),              // Templated
                           .ms_sideband         (ms_sideband[80:0]),
                           .sl_sideband         (sl_sideband[72:0]),
                           .m_rxfifo_align_done (m_rxfifo_align_done),
                           .o_xcvrif_core_clk   (),              // Templated
                           .o_rx_xcvrif_rst_n   (o_rx_xcvrif_rst_n), // Templated
                           .o_rsvd_direct_async (),              // Templated
                           .o_tx_xcvrif_rst_n   (o_tx_xcvrif_rst_n), // Templated
                           .o_tx_transfer_clk   (o_tx_transfer_clk),
                           .o_tx_transfer_div2_clk(o_tx_transfer_div2_clk),
                           // Inputs
                           .i_aib_rx_adpt_rst_n (aib_rx_adpt_rst_n), // Templated
                           .i_aib_tx_adpt_rst_n (aib_rx_adpt_rst_n), // Edit 6/16/19 Enhancement request: use only 1 AIB signal for resetting AIB adapter  
                           .i_aib_avmm1_data    (aib_adpt_avmm1_data[1:0]), // Templated
                           .i_aib_avmm2_data    (aib_adpt_avmm2_data[1:0]), // Templated
                           .i_aib_shared_direct_async(shared_direct_async_out[2:0]), // Templated
                           .i_aib_fsr_data      (aib_adpt_fsr_data), // Templated
                           .i_aib_fsr_load      (aib_adpt_fsr_load), // Templated
                           .i_aib_rx_elane_rst_n(aib_rx_elane_rst_n), // Templated
                           .i_aib_tx_elane_rst_n(aib_tx_elane_rst_n), // Templated
                           .i_aib_core_clk      (pld_pma_coreclkin), // Templated
                           .i_aib_rx_xcvrif_rst_n(aib_rx_xcvrif_rst_n), // Templated
                           .i_aib_rsvd_direct_async(aib_pld_pma_txdetectrx), // Templated
                           .i_aib_tx_xcvrif_rst_n(aib_tx_xcvrif_rst_n), // Templated
                           .i_aib_sclk          (aib_pld_sclk),  // Templated
                           .i_aib_rx_dcd_cal_done(aib_rx_dcd_cal_done), // Templated
                           .i_aib_rx_sr_clk     (aib_rx_sr_clk), // Templated
                           .i_aib_ssr_data      (aib_adpt_ssr_data), // Templated
                           .i_aib_ssr_load      (aib_adpt_ssr_load), // Templated
                           .i_aib_tx_data       (aib_tx_data[39:0]), // Templated
                           .i_aib_tx_dcd_cal_done(aib_tx_dcd_cal_done), // Templated
                           .i_aib_tx_dll_lock   (aib_tx_dll_lock), // Templated
                           .i_aib_tx_sr_clk     (aib_tx_sr_clk_in), // Templated
                           .i_aib_tx_transfer_clk(aib_tx_transfer_clk), // Templated
                           .i_user_mode         (1'b0),          // Templated
                           .i_adpt_hard_rst_n   (i_adpt_hard_rst_n), // Templated
                           .i_adpt_cfg_rdata    (i_adpt_cfg_rdata[31:0]), // Templated
                           .i_adpt_cfg_rdatavld (i_adpt_cfg_rdatavld), // Templated
                           .i_adpt_cfg_waitreq  (i_adpt_cfg_waitreq), // Templated
                           .i_cfg_avmm_addr_id  (i_channel_id[5:0]), // Templated
                           .i_cfg_avmm_clk      (i_cfg_avmm_clk), // Templated
                           .i_cfg_avmm_rst_n    (i_cfg_avmm_rst_n), // Templated
                           .i_cfg_avmm_addr     (i_cfg_avmm_addr[16:0]), // Templated
                           .i_cfg_avmm_wdata    (i_cfg_avmm_wdata[31:0]), // Templated
                           .i_cfg_avmm_write    (i_cfg_avmm_write), // Templated
                           .i_cfg_avmm_read     (i_cfg_avmm_read), // Templated
                           .i_cfg_avmm_byte_en  (i_cfg_avmm_byte_en[3:0]), // Templated
                           .i_fpll_shared_direct_async(5'b00000), // Templated
                           .i_rx_chnl_rsvd      (1'b0),          // Templated
                           .i_rsvd_direct_async (1'b0),          // Templated
                           .i_rx_elane_clk      (i_rx_elane_clk),          // Templated
                           .i_tx_elane_clk      (i_tx_elane_clk),          // Templated
                           .i_rx_pma_div66_clk  (ns_mac_rdy),       //Added per tim 10/27/2019 
                           .i_tx_pma_div66_clk  (ns_adapt_rstn),    //Added per tim 10/27/2019    
                           .i_feedthru_clk      ({6{i_rx_pma_clk}}), // Templated
                           .i_elane_cfg_rdata   ({32{1'b0}}),    // Templated
                           .i_elane_cfg_rdatavld({1{1'b0}}),     // Templated
                           .i_elane_cfg_waitreq (1'b1),          // Templated
                           .i_rx_pma_clk        (i_rx_pma_clk),
                           .i_rx_pma_div2_clk   (i_rx_pma_div2_clk),
                           .i_tx_pma_clk        (i_tx_pma_clk),
                           .i_xcvrif_tx_rdy     (1'b1),          // Templated
                           .i_xcvrif_rx_rdy     (1'b1),          // Templated
                           .i_xcvrif_rx_latency_pls({1{1'b0}}),  // Templated
                           .i_xcvrif_tx_latency_pls({1{1'b0}}),  // Templated
                           .i_xcvrif_cfg_rdata  ({32{1'b0}}),    // Templated
                           .i_xcvrif_cfg_rdatavld({1{1'b0}}),    // Templated
                           .i_xcvrif_cfg_waitreq(1'b1),          // Templated
                           .i_scan_mode_n       (w_scan_mode_n), // Templated
                           .i_avmm1_tst_tcm_ctrl(w_avmm1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_avmm1_test_clk    (w_avmm1_test_clk), // Templated
                           .i_avmm1_scan_clk    (w_avmm1_scan_clk), // Templated
                           .i_txchnl_0_tst_tcm_ctrl(w_txchnl_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_txchnl_0_test_clk (w_txchnl_0_test_clk), // Templated
                           .i_txchnl_0_scan_clk (w_txchnl_0_scan_clk), // Templated
                           .i_txchnl_1_tst_tcm_ctrl(w_txchnl_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_txchnl_1_test_clk (w_txchnl_1_test_clk), // Templated
                           .i_txchnl_1_scan_clk (w_txchnl_1_scan_clk), // Templated
                           .i_txchnl_2_tst_tcm_ctrl(w_txchnl_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_txchnl_2_test_clk (w_txchnl_2_test_clk), // Templated
                           .i_txchnl_2_scan_clk (w_txchnl_2_scan_clk), // Templated
                           .i_rxchnl_tst_tcm_ctrl(w_rxchnl_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_rxchnl_test_clk   (w_rxchnl_test_clk), // Templated
                           .i_rxchnl_scan_clk   (w_rxchnl_scan_clk), // Templated
                           .i_sr_0_tst_tcm_ctrl (w_sr_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_sr_0_test_clk     (w_sr_0_test_clk), // Templated
                           .i_sr_0_scan_clk     (w_sr_0_scan_clk), // Templated
                           .i_sr_1_tst_tcm_ctrl (w_sr_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_sr_1_test_clk     (w_sr_1_test_clk), // Templated
                           .i_sr_1_scan_clk     (w_sr_1_scan_clk), // Templated
                           .i_sr_2_tst_tcm_ctrl (w_sr_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_sr_2_test_clk     (w_sr_2_test_clk), // Templated
                           .i_sr_2_scan_clk     (w_sr_2_scan_clk), // Templated
                           .i_sr_3_tst_tcm_ctrl (w_sr_3_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                           .i_sr_3_test_clk     (w_sr_3_test_clk), // Templated
                           .i_sr_3_scan_clk     (w_sr_3_scan_clk), // Templated
                           .i_scan_rst_n        (w_scan_rst_n),  // Templated
                           .i_dftcore2dll       (w_dftcore2dll[1:0]), // Templated
                           .i_aibdftdll2core    (aibdftdll2core[12:0]), // Templated
                           .i_ehip_usr_rdata    ({8{1'b0}}),     // Templated
                           .i_ehip_usr_rdatavld ({1{1'b0}}),     // Templated
                           .i_ehip_usr_wrdone   ({1{1'b0}}),     // Templated
                           .i_ehip_cfg_rdata    ({32{1'b0}}),    // Templated
                           .i_ehip_cfg_rdatavld ({1{1'b0}}),     // Templated
                           .i_ehip_cfg_waitreq  (1'b1),          // Templated
                           .i_rx_ehip_data      ({78{1'b0}}),    // Templated
                           .i_ehip_ssr          ({8{1'b0}}),     // Templated
                           .i_ehip_fsr          ({4{1'b0}}),     // Templated
                           .i_rx_rsfec_clk      (1'b1),          // Templated
                           .i_rx_rsfec_data     ({78{1'b0}}),    // Templated
                           .i_tx_rsfec_clk      (1'b1),          // Templated
                           .i_rx_rsfec_frd_clk  (1'b1),          // Templated
                           .i_rx_pma_data       (i_rx_pma_data[39:0]),
                           .i_rx_elane_data     (i_rx_elane_data[77:0]),    // Templated
                           .i_chnl_fsr          ({3{1'b0}}),     // Templated
                           .i_chnl_ssr          (i_chnl_ssr[64:0]),
                           .i_rx_ehip_clk       (1'b1),          // Templated
                           .i_tx_ehip_clk       (1'b1),          // Templated
                           .i_rx_ehip_frd_clk   (1'b1));          // Templated

/*c3dfx_aibadaptwrap_tcb AUTO_TEMPLATE (

  //c3dfx_aibadaptwrap interface
  .i_tck                                    (1'b0),  //not used
  .i_scan_clk1                              (i_scan_clk),
  .i_scan_clk2                              (i_scan_clk),
  .i_scan_clk3                              (i_scan_clk),
  .i_scan_clk4                              (i_scan_clk),
  .i_test_clk_1g                            (i_test_clk_1g),
  .i_test_clk_500m                          (i_test_clk_500m),
  .i_test_clk_250m                          (i_test_clk_250m),
  .i_test_clk_125m                          (i_test_clk_125m),
  .i_test_clk_62m                           (i_test_clk_62m),
  .i_tst_aibadaptwraptcb_jtag               (2'h0),
  .i_tst_aibadaptwraptcb_jtag_common        (2'h0),
  .i_tst_aibadaptwraptcb_static_common      (i_test_c3adapt_tcb_static_common[]),
  .i_tst_aibadaptwrap_scan_in               (i_test_c3adapt_scan_in[]),
  .o_tst_aibadaptwraptcb_jtag               (o_test_c3adapttcb_jtag[]),
  .o_tst_aibadaptwrap_scan_out              (o_test_c3adapt_scan_out[]),
  // Add inter block test signals below
  .o_dftcore2dll                            (w_dftcore2dll[]),
  .i_dftdll2core                            (w_dftdll2core[]),
  .o_rxchnl_tst_tcm_ctrl                    (w_rxchnl_tst_tcm_ctrl[]),
  .o_rxchnl_test_clk                        (w_rxchnl_test_clk),
  .o_rxchnl_scan_clk                        (w_rxchnl_scan_clk),

  .o_sr_0_tst_tcm_ctrl                      (w_sr_0_tst_tcm_ctrl[]),
  .o_sr_0_test_clk                          (w_sr_0_test_clk),
  .o_sr_0_scan_clk                          (w_sr_0_scan_clk),
  .o_sr_1_tst_tcm_ctrl                      (w_sr_1_tst_tcm_ctrl[]),
  .o_sr_1_test_clk                          (w_sr_1_test_clk),
  .o_sr_1_scan_clk                          (w_sr_1_scan_clk),
  .o_sr_2_tst_tcm_ctrl                      (w_sr_2_tst_tcm_ctrl[]),
  .o_sr_2_test_clk                          (w_sr_2_test_clk),
  .o_sr_2_scan_clk                          (w_sr_2_scan_clk),
  .o_sr_3_tst_tcm_ctrl                      (w_sr_3_tst_tcm_ctrl[]),
  .o_sr_3_test_clk                          (w_sr_3_test_clk),
  .o_sr_3_scan_clk                          (w_sr_3_scan_clk),
  .o_avmm1_tst_tcm_ctrl                     (w_avmm1_tst_tcm_ctrl[]),
  .o_avmm1_test_clk                         (w_avmm1_test_clk),
  .o_avmm1_scan_clk                         (w_avmm1_scan_clk),
  .o_txchnl_0_tst_tcm_ctrl                  (w_txchnl_0_tst_tcm_ctrl[]),
  .o_txchnl_0_test_clk                      (w_txchnl_0_test_clk),
  .o_txchnl_0_scan_clk                      (w_txchnl_0_scan_clk),
  .o_txchnl_1_tst_tcm_ctrl                  (w_txchnl_1_tst_tcm_ctrl[]),
  .o_txchnl_1_test_clk                      (w_txchnl_1_test_clk),
  .o_txchnl_1_scan_clk                      (w_txchnl_1_scan_clk),
  .o_txchnl_2_tst_tcm_ctrl                  (w_txchnl_2_tst_tcm_ctrl[]),
  .o_txchnl_2_test_clk                      (w_txchnl_2_test_clk),
  .o_txchnl_2_scan_clk                      (w_txchnl_2_scan_clk),
  .o_scan_mode_n                            (w_scan_mode_n),
  .o_scan_rst_n                             (w_scan_rst_n),
  .o_scan_shift_n                           (w_scan_shift_n),

  .o_global_pipe_scanen                     (w_global_pipe_scanen),
  .o_atpg_scan_in0                          (w_atpg_scan_in0),
  .o_atpg_scan_in1                          (w_atpg_scan_in1),
  .i_atpg_scan_out0                         (w_atpg_scan_out0),
  .i_atpg_scan_out1                         (w_atpg_scan_out1),
  .o_atpg_scan_clk_in0                      (),
  .o_atpg_scan_clk_in1                      (),
  .o_atpg_bsr0_scan_in                      (atpg_bsr0_scan_in[]),
  .o_atpg_bsr0_scan_shift_clk               (),                   
  .i_atpg_bsr0_scan_out                     (atpg_bsr0_scan_out[]),
  .o_atpg_bsr1_scan_in                      (atpg_bsr1_scan_in[]),
  .o_atpg_bsr1_scan_shift_clk               (),                   
  .i_atpg_bsr1_scan_out                     (atpg_bsr1_scan_out[]),
  .o_atpg_bsr2_scan_in                      (atpg_bsr2_scan_in[]),
  .o_atpg_bsr2_scan_shift_clk               (),                   
  .i_atpg_bsr2_scan_out                     (atpg_bsr2_scan_out[]),
  .o_atpg_bsr3_scan_in                      (atpg_bsr3_scan_in[]),
  .o_atpg_bsr3_scan_shift_clk               (),                   
  .i_atpg_bsr3_scan_out                     (atpg_bsr3_scan_out[]),
  .o_atpg_bsr_scan_shift_n                  (atpg_bsr_scan_shift_n[]),
);
 */

    c3dfx_aibadaptwrap_tcb c3dfx_aibadaptwrap_tcb (/*AUTOINST*/
                                                   // Outputs
                                                   .o_tst_aibadaptwraptcb_jtag(o_test_c3adapttcb_jtag[`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), // Templated
                                                   .o_tst_aibadaptwrap_scan_out(o_test_c3adapt_scan_out[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                                   .o_dftcore2dll       (w_dftcore2dll[1:0]), // Templated
                                                   .o_avmm1_tst_tcm_ctrl(w_avmm1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_avmm1_test_clk    (w_avmm1_test_clk), // Templated
                                                   .o_avmm1_scan_clk    (w_avmm1_scan_clk), // Templated
                                                   .o_rxchnl_tst_tcm_ctrl(w_rxchnl_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_rxchnl_test_clk   (w_rxchnl_test_clk), // Templated
                                                   .o_rxchnl_scan_clk   (w_rxchnl_scan_clk), // Templated
                                                   .o_sr_0_tst_tcm_ctrl (w_sr_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_sr_0_test_clk     (w_sr_0_test_clk), // Templated
                                                   .o_sr_0_scan_clk     (w_sr_0_scan_clk), // Templated
                                                   .o_sr_1_tst_tcm_ctrl (w_sr_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_sr_1_test_clk     (w_sr_1_test_clk), // Templated
                                                   .o_sr_1_scan_clk     (w_sr_1_scan_clk), // Templated
                                                   .o_sr_2_tst_tcm_ctrl (w_sr_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_sr_2_test_clk     (w_sr_2_test_clk), // Templated
                                                   .o_sr_2_scan_clk     (w_sr_2_scan_clk), // Templated
                                                   .o_sr_3_tst_tcm_ctrl (w_sr_3_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_sr_3_test_clk     (w_sr_3_test_clk), // Templated
                                                   .o_sr_3_scan_clk     (w_sr_3_scan_clk), // Templated
                                                   .o_txchnl_0_tst_tcm_ctrl(w_txchnl_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_txchnl_0_test_clk (w_txchnl_0_test_clk), // Templated
                                                   .o_txchnl_0_scan_clk (w_txchnl_0_scan_clk), // Templated
                                                   .o_txchnl_1_tst_tcm_ctrl(w_txchnl_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_txchnl_1_test_clk (w_txchnl_1_test_clk), // Templated
                                                   .o_txchnl_1_scan_clk (w_txchnl_1_scan_clk), // Templated
                                                   .o_txchnl_2_tst_tcm_ctrl(w_txchnl_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), // Templated
                                                   .o_txchnl_2_test_clk (w_txchnl_2_test_clk), // Templated
                                                   .o_txchnl_2_scan_clk (w_txchnl_2_scan_clk), // Templated
                                                   .o_scan_mode_n       (w_scan_mode_n), // Templated
                                                   .o_scan_rst_n        (w_scan_rst_n),  // Templated
                                                   .o_scan_shift_n      (w_scan_shift_n), // Templated
                                                   .o_global_pipe_scanen(w_global_pipe_scanen), // Templated
                                                   .o_atpg_scan_in0     (w_atpg_scan_in0), // Templated
                                                   .o_atpg_scan_in1     (w_atpg_scan_in1), // Templated
                                                   .o_atpg_scan_clk_in0 (),              // Templated
                                                   .o_atpg_scan_clk_in1 (),              // Templated
                                                   .o_atpg_bsr0_scan_in (atpg_bsr0_scan_in), // Templated
                                                   .o_atpg_bsr0_scan_shift_clk(),        // Templated
                                                   .o_atpg_bsr1_scan_in (atpg_bsr1_scan_in), // Templated
                                                   .o_atpg_bsr1_scan_shift_clk(),        // Templated
                                                   .o_atpg_bsr2_scan_in (atpg_bsr2_scan_in), // Templated
                                                   .o_atpg_bsr2_scan_shift_clk(),        // Templated
                                                   .o_atpg_bsr3_scan_in (atpg_bsr3_scan_in), // Templated
                                                   .o_atpg_bsr3_scan_shift_clk(),        // Templated
                                                   .o_atpg_bsr_scan_shift_n(atpg_bsr_scan_shift_n), // Templated
                                                   // Inputs
                                                   .i_tck               (1'b0),          // Templated
                                                   .i_scan_clk1         (i_scan_clk),    // Templated
                                                   .i_scan_clk2         (i_scan_clk),    // Templated
                                                   .i_scan_clk3         (i_scan_clk),    // Templated
                                                   .i_scan_clk4         (i_scan_clk),    // Templated
                                                   .i_test_clk_1g       (i_test_clk_1g), // Templated
                                                   .i_test_clk_500m     (i_test_clk_500m), // Templated
                                                   .i_test_clk_250m     (i_test_clk_250m), // Templated
                                                   .i_test_clk_125m     (i_test_clk_125m), // Templated
                                                   .i_test_clk_62m      (i_test_clk_62m), // Templated
                                                   .i_tst_aibadaptwraptcb_jtag(2'h0),    // Templated
                                                   .i_tst_aibadaptwraptcb_jtag_common(2'h0), // Templated
                                                   .i_tst_aibadaptwraptcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), // Templated
                                                   .i_tst_aibadaptwrap_scan_in(i_test_c3adapt_scan_in[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), // Templated
                                                   .i_dftdll2core       (w_dftdll2core[12:0]), // Templated
                                                   .i_atpg_scan_out0    (w_atpg_scan_out0), // Templated
                                                   .i_atpg_scan_out1    (w_atpg_scan_out1), // Templated
                                                   .i_atpg_bsr0_scan_out(atpg_bsr0_scan_out), // Templated
                                                   .i_atpg_bsr1_scan_out(atpg_bsr1_scan_out), // Templated
                                                   .i_atpg_bsr2_scan_out(atpg_bsr2_scan_out), // Templated
                                                   .i_atpg_bsr3_scan_out(atpg_bsr3_scan_out)); // Templated
 

   /*aibcr3_top_wrp AUTO_TEMPLATE (
    .aib\(.*\)    (io_aib\1[]),
    .r_aib_csr_ctrl_\(.*\)                    (aib_csr_ctrl_\1[]),
    .r_aib_dprio_ctrl_\(.*\)                  (aib_dprio_ctrl_\1[]),
    .iaibdftcore2dll                          (aibdftcore2dll),
    .iaibdftdll2adjch                         (i_aibdftdll2adjch[]),
    .iatpg_pipeline_global_en                 (w_global_pipe_scanen),
    .iatpg_scan_clk_in0                       (aib_rx_transfer_clk),
    .iatpg_scan_clk_in1                       (aib_rx_transfer_clk),
    .iatpg_scan_in0                           (w_atpg_scan_in0[]),
    .iatpg_scan_in1                           (w_atpg_scan_in1[]),
    .iatpg_scan_mode_n                        (w_scan_mode_n),
    .iatpg_scan_rst_n                         (w_scan_rst_n),
    .iatpg_scan_shift_n                       (w_scan_shift_n),
    .iatpg_bsr0_scan_in                       (atpg_bsr0_scan_in[]),
    .iatpg_bsr0_scan_shift_clk                (aib_bsr_scan_shift_clk),      // FB#442878
    .oatpg_bsr0_scan_out                      (atpg_bsr0_scan_out[]),
    .iatpg_bsr1_scan_in                       (atpg_bsr1_scan_in[]),
    .iatpg_bsr1_scan_shift_clk                (aib_bsr_scan_shift_clk),      // FB#442878
    .oatpg_bsr1_scan_out                      (atpg_bsr1_scan_out[]),
    .iatpg_bsr2_scan_in                       (atpg_bsr2_scan_in[]),
    .iatpg_bsr2_scan_shift_clk                (aib_bsr_scan_shift_clk),      // FB#442878
    .oatpg_bsr2_scan_out                      (atpg_bsr2_scan_out[]),
    .iatpg_bsr3_scan_in                       (atpg_bsr3_scan_in[]),
    .iatpg_bsr3_scan_shift_clk                (aib_bsr_scan_shift_clk),      // FB#442878
    .oatpg_bsr3_scan_out                      (atpg_bsr3_scan_out[]),
    .iatpg_bsr_scan_shift_n                   (atpg_bsr_scan_shift_n),
    .ihssi_avmm1_data_out                     (adpt_aib_avmm1_data[]),
    .ihssi_avmm2_data_out                     (adpt_aib_avmm2_data[]),
    .ihssi_dcc_req                            (aib_rx_dcd_cal_req),
    .ihssi_fsr_data_out                       (adpt_aib_fsr_data[]),
    .ihssi_fsr_load_out                       (adpt_aib_fsr_load),
    .ihssi_pld_8g_rxelecidle                  (aib_rsvd_direct_async),
    .ihssi_pld_pcs_rx_clk_out                 (aib_rx_pma_div2_clk),
    .ihssi_pld_pcs_tx_clk_out                 (aib_tx_pma_div2_clk),
    .ihssi_pld_pma_clkdiv_rx_user             (aib_rx_pma_div66_clk),
    .ihssi_pld_pma_clkdiv_tx_user             (aib_tx_pma_div66_clk),
    .ihssi_pld_pma_hclk                       (aib_h_clk),
    .ihssi_pld_pma_internal_clk1              (aib_internal1_clk),
    .ihssi_pld_pma_internal_clk2              (aib_internal2_clk),
    .ihssi_pld_pma_pfdmode_lock               (aib_xcvrif_tx_rdy),
    .ihssi_pld_pma_rxpll_lock                 (aib_xcvrif_rx_rdy),
    .ihssi_pld_rx_hssi_fifo_latency_pulse     (aib_rx_fifo_latency_pls[]),
    .ihssi_pld_tx_hssi_fifo_latency_pulse     (aib_tx_fifo_latency_pls[]),
    .ihssi_pma_aib_tx_clk                     (aib_tx_pma_clk),
    .ihssi_rx_data_out                        (aib_rx_data[]),
    .ihssi_rx_transfer_clk                    (aib_rx_transfer_clk),
    .ihssi_sr_clk_out                         (aib_tx_sr_clk),
    .ihssi_ssr_data_out                       (adpt_aib_ssr_data[]),
    .ihssi_ssr_load_out                       (adpt_aib_ssr_load),
    .ihssi_tx_dcd_cal_req                     (aib_tx_dcd_cal_req),
    .ihssi_tx_dll_lock_req                    (aib_tx_dll_lock_req),
    .ired_idataselb_in_chain1                 (i_red_idataselb_in_chain1[]),
    .ired_idataselb_in_chain2                 (i_red_idataselb_in_chain2[]),
    .irstb                                    (i_adpt_hard_rst_n),
    .ishared_direct_async_in                  (shared_direct_async_in[]),
    .itxen_in_chain1                          (i_txen_in_chain1[]),
    .itxen_in_chain2                          (i_txen_in_chain2[]),

    .ijtag_last_bs_in_chain                   (i_jtag_last_bs_chain_in[]),
    .ojtag_last_bs_out_chain                  (o_jtag_last_bs_chain_out[]),
    .ijtag_tx_scan_in_chain                   (i_jtag_bs_chain_in[]),
    .ojtag_rx_scan_out_chain                  (o_jtag_bs_chain_out[]),
    .idirectout_data_in_chain1                (i_directout_data_chain1_in[]),
    .odirectout_data_out_chain1               (o_directout_data_chain1_out[]),
    .idirectout_data_in_chain2                (i_directout_data_chain2_in[]),
    .odirectout_data_out_chain2               (o_directout_data_chain2_out[]),
    .jtag_tx_scanen_in                        (i_jtag_bs_scanen_in[]),
    .jtag_tx_scanen_out                       (o_jtag_bs_scanen_out[]),
    .ijtag_clkdr_in_chain                     (i_jtag_clkdr_in[]),
    .ojtag_clkdr_out_chain                    (o_jtag_clkdr_out[]),
    .jtag_clksel                              (i_jtag_clksel_in[]),
    .jtag_clksel_out                          (o_jtag_clksel_out[]),
    .jtag_intest                              (i_jtag_intest_in[]),
    .jtag_intest_out                          (o_jtag_intest_out[]),
    .jtag_mode_in                             (i_jtag_mode_in[]),
    .jtag_mode_out                            (o_jtag_mode_out[]),
    .jtag_rstb_en                             (i_jtag_rstb_en_in[]),
    .jtag_rstb_en_out                         (o_jtag_rstb_en_out[]),
    .jtag_rstb                                (i_jtag_rstb_in[]),
    .jtag_rstb_out                            (o_jtag_rstb_out[]),
    .jtag_weakpdn                             (i_jtag_weakpdn_in[]),
    .jtag_weakpdn_out                         (o_jtag_weakpdn_out[]),
    .jtag_weakpu                              (i_jtag_weakpu_in[]),
    .jtag_weakpu_out                          (o_jtag_weakpu_out[]),

    .oaibdftdll2adjch                         (o_aibdftdll2adjch[]),
    .oaibdftdll2core                          (aibdftdll2core[]),
    .oatpg_scan_out0                          (w_atpg_scan_out0[]),
    .oatpg_scan_out1                          (w_atpg_scan_out1[]),
    .ohssi_adapter_rx_pld_rst_n               (aib_rx_adpt_rst_n),
    .ohssi_adapter_tx_pld_rst_n               (aib_tx_adpt_rst_n),
    .ohssi_avmm1_data_in                      (aib_adpt_avmm1_data[]),
    .ohssi_avmm2_data_in                      (aib_adpt_avmm2_data[]),
    .ohssi_fsr_data_in                        (aib_adpt_fsr_data[]),
    .ohssi_fsr_load_in                        (aib_adpt_fsr_load),
    .ohssi_pcs_rx_pld_rst_n                   (aib_rx_elane_rst_n),
    .ohssi_pcs_tx_pld_rst_n                   (aib_tx_elane_rst_n),
    .ohssi_pld_pma_coreclkin                  (pld_pma_coreclkin),
    .ohssi_pld_pma_coreclkin_n                (),
    .ohssi_pld_pma_rxpma_rstb                 (aib_rx_xcvrif_rst_n),
    .ohssi_pld_pma_txdetectrx                 (aib_pld_pma_txdetectrx[]),
    .ohssi_pld_pma_txpma_rstb                 (aib_tx_xcvrif_rst_n),
    .ohssi_pld_sclk                           (aib_pld_sclk),
    .ohssi_sr_clk_in                          (aib_rx_sr_clk),
    .ohssi_ssr_data_in                        (aib_adpt_ssr_data[]),
    .ohssi_ssr_load_in                        (aib_adpt_ssr_load),
    .ohssi_tx_data_in                         (aib_tx_data[]),
    .ohssi_tx_dcd_cal_done                    (aib_tx_dcd_cal_done),
    .ohssi_tx_dll_lock                        (aib_tx_dll_lock),
    .ohssi_tx_sr_clk_in                       (aib_tx_sr_clk_in),
    .ohssi_tx_transfer_clk                    (aib_tx_transfer_clk),
    .ohssirx_dcc_done                         (aib_rx_dcd_cal_done),
    .ored_idataselb_out_chain1                (o_red_idataselb_out_chain1[]),
    .ored_idataselb_out_chain2                (o_red_idataselb_out_chain2[]),
    .osc_clkin                                (i_osc_clk),
    .osc_clkout                               (o_osc_clk),
    .oshared_direct_async_out                 (shared_direct_async_out[]),
    .otxen_out_chain1                         (o_txen_out_chain1[]),
    .otxen_out_chain2                         (o_txen_out_chain2[]),
    .por_aib_vcchssi                          (i_por_aib_vcchssi[]),
    .por_aib_vcchssi_out                      (o_por_aib_vcchssi[]),
    .por_aib_vccl                             (i_por_aib_vccl[]),
    .por_aib_vccl_out                         (o_por_aib_vccl[]),
    .ired_shift_en_in_chain1                  (i_red_shift_en_in_chain1[]),
    .ired_shift_en_in_chain2                  (i_red_shift_en_in_chain2[]),
    .ored_shift_en_out_chain1                 (o_red_shift_en_out_chain1[]),
    .ored_shift_en_out_chain2                 (o_red_shift_en_out_chain2[]),
    );
    */

    aibcr3_top_wrp xaibcr3_top_wrp (/*AUTOINST*/
                                    // Outputs
                                    .jtag_clksel_out    (o_jtag_clksel_out), // Templated
                                    .jtag_intest_out    (o_jtag_intest_out), // Templated
                                    .jtag_mode_out      (o_jtag_mode_out), // Templated
                                    .jtag_rstb_en_out   (o_jtag_rstb_en_out), // Templated
                                    .jtag_rstb_out      (o_jtag_rstb_out), // Templated
                                    .jtag_tx_scanen_out (o_jtag_bs_scanen_out), // Templated
                                    .jtag_weakpdn_out   (o_jtag_weakpdn_out), // Templated
                                    .jtag_weakpu_out    (o_jtag_weakpu_out), // Templated
                                    .oatpg_bsr0_scan_out(atpg_bsr0_scan_out), // Templated
                                    .oatpg_bsr1_scan_out(atpg_bsr1_scan_out), // Templated
                                    .oatpg_bsr2_scan_out(atpg_bsr2_scan_out), // Templated
                                    .oatpg_bsr3_scan_out(atpg_bsr3_scan_out), // Templated
                                    .oatpg_scan_out0    (w_atpg_scan_out0), // Templated
                                    .oatpg_scan_out1    (w_atpg_scan_out1), // Templated
                                    .odirectout_data_out_chain1(o_directout_data_chain1_out), // Templated
                                    .odirectout_data_out_chain2(o_directout_data_chain2_out), // Templated
                                    .ohssi_adapter_rx_pld_rst_n(aib_rx_adpt_rst_n), // Templated
                                    .ohssi_adapter_tx_pld_rst_n(aib_tx_adpt_rst_n), // Templated
                                    .ohssi_fsr_data_in  (aib_adpt_fsr_data), // Templated
                                    .ohssi_fsr_load_in  (aib_adpt_fsr_load), // Templated
                                    .ohssi_pcs_rx_pld_rst_n(aib_rx_elane_rst_n), // Templated
                                    .ohssi_pcs_tx_pld_rst_n(aib_tx_elane_rst_n), // Templated
                                    .ohssi_pld_pma_coreclkin(pld_pma_coreclkin), // Templated
                                    .ohssi_pld_pma_coreclkin_n(),        // Templated
                                    .ohssi_pld_pma_rxpma_rstb(aib_rx_xcvrif_rst_n), // Templated
                                    .ohssi_pld_pma_txdetectrx(aib_pld_pma_txdetectrx), // Templated
                                    .ohssi_pld_pma_txpma_rstb(aib_tx_xcvrif_rst_n), // Templated
                                    .ohssi_pld_sclk     (aib_pld_sclk),  // Templated
                                    .ohssi_sr_clk_in    (aib_rx_sr_clk), // Templated
                                    .ohssi_ssr_data_in  (aib_adpt_ssr_data), // Templated
                                    .ohssi_ssr_load_in  (aib_adpt_ssr_load), // Templated
                                    .ohssi_tx_dcd_cal_done(aib_tx_dcd_cal_done), // Templated
                                    .ohssi_tx_dll_lock  (aib_tx_dll_lock), // Templated
                                    .ohssi_tx_sr_clk_in (aib_tx_sr_clk_in), // Templated
                                    .ohssi_tx_transfer_clk(aib_tx_transfer_clk), // Templated
                                    .ohssirx_dcc_done   (aib_rx_dcd_cal_done), // Templated
                                    .ojtag_clkdr_out_chain(o_jtag_clkdr_out), // Templated
                                    .ojtag_last_bs_out_chain(o_jtag_last_bs_chain_out), // Templated
                                    .ojtag_rx_scan_out_chain(o_jtag_bs_chain_out), // Templated
                                    .ored_idataselb_out_chain1(o_red_idataselb_out_chain1), // Templated
                                    .ored_idataselb_out_chain2(o_red_idataselb_out_chain2), // Templated
                                    .ored_shift_en_out_chain1(o_red_shift_en_out_chain1), // Templated
                                    .ored_shift_en_out_chain2(o_red_shift_en_out_chain2), // Templated
                                    .osc_clkout         (o_osc_clk),     // Templated
                                    .otxen_out_chain1   (o_txen_out_chain1), // Templated
                                    .otxen_out_chain2   (o_txen_out_chain2), // Templated
                                    .por_aib_vcchssi_out(o_por_aib_vcchssi), // Templated
                                    .por_aib_vccl_out   (o_por_aib_vccl), // Templated
                                    .oaibdftdll2adjch   (o_aibdftdll2adjch[12:0]), // Templated
                                    .oaibdftdll2core    (aibdftdll2core[12:0]), // Templated
                                    .oshared_direct_async_out(shared_direct_async_out[2:0]), // Templated
                                    .ohssi_avmm1_data_in(aib_adpt_avmm1_data[1:0]), // Templated
                                    .ohssi_avmm2_data_in(aib_adpt_avmm2_data[1:0]), // Templated
                                    .ohssi_tx_data_in   (aib_tx_data[39:0]), // Templated
                                    // Inouts
                                    .aib0               (io_aib0),       // Templated
                                    .aib1               (io_aib1),       // Templated
                                    .aib2               (io_aib2),       // Templated
                                    .aib3               (io_aib3),       // Templated
                                    .aib4               (io_aib4),       // Templated
                                    .aib5               (io_aib5),       // Templated
                                    .aib6               (io_aib6),       // Templated
                                    .aib7               (io_aib7),       // Templated
                                    .aib8               (io_aib8),       // Templated
                                    .aib9               (io_aib9),       // Templated
                                    .aib10              (io_aib10),      // Templated
                                    .aib11              (io_aib11),      // Templated
                                    .aib12              (io_aib12),      // Templated
                                    .aib13              (io_aib13),      // Templated
                                    .aib14              (io_aib14),      // Templated
                                    .aib15              (io_aib15),      // Templated
                                    .aib16              (io_aib16),      // Templated
                                    .aib17              (io_aib17),      // Templated
                                    .aib18              (io_aib18),      // Templated
                                    .aib19              (io_aib19),      // Templated
                                    .aib20              (io_aib20),      // Templated
                                    .aib21              (io_aib21),      // Templated
                                    .aib22              (io_aib22),      // Templated
                                    .aib23              (io_aib23),      // Templated
                                    .aib24              (io_aib24),      // Templated
                                    .aib25              (io_aib25),      // Templated
                                    .aib26              (io_aib26),      // Templated
                                    .aib27              (io_aib27),      // Templated
                                    .aib28              (io_aib28),      // Templated
                                    .aib29              (io_aib29),      // Templated
                                    .aib30              (io_aib30),      // Templated
                                    .aib31              (io_aib31),      // Templated
                                    .aib32              (io_aib32),      // Templated
                                    .aib33              (io_aib33),      // Templated
                                    .aib34              (io_aib34),      // Templated
                                    .aib35              (io_aib35),      // Templated
                                    .aib36              (io_aib36),      // Templated
                                    .aib37              (io_aib37),      // Templated
                                    .aib38              (io_aib38),      // Templated
                                    .aib39              (io_aib39),      // Templated
                                    .aib40              (io_aib40),      // Templated
                                    .aib41              (io_aib41),      // Templated
                                    .aib42              (io_aib42),      // Templated
                                    .aib43              (io_aib43),      // Templated
                                    .aib44              (io_aib44),      // Templated
                                    .aib45              (io_aib45),      // Templated
                                    .aib46              (io_aib46),      // Templated
                                    .aib47              (io_aib47),      // Templated
                                    .aib48              (io_aib48),      // Templated
                                    .aib49              (io_aib49),      // Templated
                                    .aib50              (io_aib50),      // Templated
                                    .aib51              (io_aib51),      // Templated
                                    .aib52              (io_aib52),      // Templated
                                    .aib53              (io_aib53),      // Templated
                                    .aib54              (io_aib54),      // Templated
                                    .aib55              (io_aib55),      // Templated
                                    .aib56              (io_aib56),      // Templated
                                    .aib57              (io_aib57),      // Templated
                                    .aib58              (io_aib58),      // Templated
                                    .aib59              (io_aib59),      // Templated
                                    .aib60              (io_aib60),      // Templated
                                    .aib61              (io_aib61),      // Templated
                                    .aib62              (io_aib62),      // Templated
                                    .aib63              (io_aib63),      // Templated
                                    .aib64              (io_aib64),      // Templated
                                    .aib65              (io_aib65),      // Templated
                                    .aib66              (io_aib66),      // Templated
                                    .aib67              (io_aib67),      // Templated
                                    .aib68              (io_aib68),      // Templated
                                    .aib69              (io_aib69),      // Templated
                                    .aib70              (io_aib70),      // Templated
                                    .aib71              (io_aib71),      // Templated
                                    .aib72              (io_aib72),      // Templated
                                    .aib73              (io_aib73),      // Templated
                                    .aib74              (io_aib74),      // Templated
                                    .aib75              (io_aib75),      // Templated
                                    .aib76              (io_aib76),      // Templated
                                    .aib77              (io_aib77),      // Templated
                                    .aib78              (io_aib78),      // Templated
                                    .aib79              (io_aib79),      // Templated
                                    .aib80              (io_aib80),      // Templated
                                    .aib81              (io_aib81),      // Templated
                                    .aib82              (io_aib82),      // Templated
                                    .aib83              (io_aib83),      // Templated
                                    .aib84              (io_aib84),      // Templated
                                    .aib85              (io_aib85),      // Templated
                                    .aib86              (io_aib86),      // Templated
                                    .aib87              (io_aib87),      // Templated
                                    .aib88              (io_aib88),      // Templated
                                    .aib89              (io_aib89),      // Templated
                                    .aib90              (io_aib90),      // Templated
                                    .aib91              (io_aib91),      // Templated
                                    .aib92              (io_aib92),      // Templated
                                    .aib93              (io_aib93),      // Templated
                                    .aib94              (io_aib94),      // Templated
                                    .aib95              (io_aib95),      // Templated
                                    // Inputs
                                    .iatpg_bsr0_scan_in (atpg_bsr0_scan_in), // Templated
                                    .iatpg_bsr0_scan_shift_clk(aib_bsr_scan_shift_clk), // Templated
                                    .iatpg_bsr1_scan_in (atpg_bsr1_scan_in), // Templated
                                    .iatpg_bsr1_scan_shift_clk(aib_bsr_scan_shift_clk), // Templated
                                    .iatpg_bsr2_scan_in (atpg_bsr2_scan_in), // Templated
                                    .iatpg_bsr2_scan_shift_clk(aib_bsr_scan_shift_clk), // Templated
                                    .iatpg_bsr3_scan_in (atpg_bsr3_scan_in), // Templated
                                    .iatpg_bsr3_scan_shift_clk(aib_bsr_scan_shift_clk), // Templated
                                    .iatpg_bsr_scan_shift_n(atpg_bsr_scan_shift_n), // Templated
                                    .iatpg_pipeline_global_en(w_global_pipe_scanen), // Templated
                                    .iatpg_scan_clk_in0 (aib_rx_transfer_clk), // Templated
                                    .iatpg_scan_clk_in1 (aib_rx_transfer_clk), // Templated
                                    .iatpg_scan_in0     (w_atpg_scan_in0), // Templated
                                    .iatpg_scan_in1     (w_atpg_scan_in1), // Templated
                                    .iatpg_scan_mode_n  (w_scan_mode_n), // Templated
                                    .iatpg_scan_rst_n   (w_scan_rst_n),  // Templated
                                    .iatpg_scan_shift_n (w_scan_shift_n), // Templated
                                    .idirectout_data_in_chain1(i_directout_data_chain1_in), // Templated
                                    .idirectout_data_in_chain2(i_directout_data_chain2_in), // Templated
                                    .ihssi_avmm1_data_out(adpt_aib_avmm1_data), // Templated
                                    .ihssi_avmm2_data_out(adpt_aib_avmm2_data), // Templated
                                    .ihssi_dcc_req      (aib_rx_dcd_cal_req), // Templated
                                    .ihssi_fsr_data_out (adpt_aib_fsr_data), // Templated
                                    .ihssi_fsr_load_out (adpt_aib_fsr_load), // Templated
                                    .ihssi_pld_8g_rxelecidle(aib_rsvd_direct_async), // Templated
                                    .ihssi_pld_pcs_rx_clk_out(aib_rx_pma_div2_clk), // Templated
                                    .ihssi_pld_pcs_tx_clk_out(aib_tx_pma_div2_clk), // Templated
                                    .ihssi_pld_pma_clkdiv_rx_user(aib_rx_pma_div66_clk), // Templated
                                    .ihssi_pld_pma_clkdiv_tx_user(aib_tx_pma_div66_clk), // Templated
                                    .ihssi_pld_pma_hclk (aib_h_clk),     // Templated
                                    .ihssi_pld_pma_internal_clk1(aib_internal1_clk), // Templated
                                    .ihssi_pld_pma_internal_clk2(aib_internal2_clk), // Templated
                                    .ihssi_pld_pma_pfdmode_lock(aib_xcvrif_tx_rdy), // Templated
                                    .ihssi_pld_pma_rxpll_lock(aib_xcvrif_rx_rdy), // Templated
                                    .ihssi_pld_rx_hssi_fifo_latency_pulse(aib_rx_fifo_latency_pls), // Templated
                                    .ihssi_pld_tx_hssi_fifo_latency_pulse(aib_tx_fifo_latency_pls), // Templated
                                    .ihssi_pma_aib_tx_clk(aib_tx_pma_clk), // Templated
                                    .ihssi_rx_transfer_clk(aib_rx_transfer_clk), // Templated
                                    .ihssi_sr_clk_out   (aib_tx_sr_clk), // Templated
                                    .ihssi_ssr_data_out (adpt_aib_ssr_data), // Templated
                                    .ihssi_ssr_load_out (adpt_aib_ssr_load), // Templated
                                    .ihssi_tx_dcd_cal_req(aib_tx_dcd_cal_req), // Templated
                                    .ihssi_tx_dll_lock_req(aib_tx_dll_lock_req), // Templated
                                    .ijtag_clkdr_in_chain(i_jtag_clkdr_in), // Templated
                                    .ijtag_last_bs_in_chain(i_jtag_last_bs_chain_in), // Templated
                                    .ijtag_tx_scan_in_chain(i_jtag_bs_chain_in), // Templated
                                    .ired_idataselb_in_chain1(i_red_idataselb_in_chain1), // Templated
                                    .ired_idataselb_in_chain2(i_red_idataselb_in_chain2), // Templated
                                    .ired_shift_en_in_chain1(i_red_shift_en_in_chain1), // Templated
                                    .ired_shift_en_in_chain2(i_red_shift_en_in_chain2), // Templated
                                    .irstb              (i_adpt_hard_rst_n), // Templated
                                    .itxen_in_chain1    (i_txen_in_chain1), // Templated
                                    .itxen_in_chain2    (i_txen_in_chain2), // Templated
                                    .jtag_clksel        (i_jtag_clksel_in), // Templated
                                    .jtag_intest        (i_jtag_intest_in), // Templated
                                    .jtag_mode_in       (i_jtag_mode_in), // Templated
                                    .jtag_rstb          (i_jtag_rstb_in), // Templated
                                    .jtag_rstb_en       (i_jtag_rstb_en_in), // Templated
                                    .jtag_tx_scanen_in  (i_jtag_bs_scanen_in), // Templated
                                    .jtag_weakpdn       (i_jtag_weakpdn_in), // Templated
                                    .jtag_weakpu        (i_jtag_weakpu_in), // Templated
                                    .osc_clkin          (i_osc_clk),     // Templated
                                    .por_aib_vcchssi    (i_por_aib_vcchssi), // Templated
                                    .por_aib_vccl       (i_por_aib_vccl), // Templated
                                    .r_aib_csr_ctrl_42  (aib_csr_ctrl_42[7:0]), // Templated
                                    .iaibdftdll2adjch   (i_aibdftdll2adjch[12:0]), // Templated
                                    .r_aib_csr_ctrl_40  (aib_csr_ctrl_40[7:0]), // Templated
                                    .r_aib_csr_ctrl_36  (aib_csr_ctrl_36[7:0]), // Templated
                                    .r_aib_csr_ctrl_43  (aib_csr_ctrl_43[7:0]), // Templated
                                    .r_aib_csr_ctrl_52  (aib_csr_ctrl_52[7:0]), // Templated
                                    .r_aib_csr_ctrl_49  (aib_csr_ctrl_49[7:0]), // Templated
                                    .r_aib_csr_ctrl_45  (aib_csr_ctrl_45[7:0]), // Templated
                                    .r_aib_csr_ctrl_48  (aib_csr_ctrl_48[7:0]), // Templated
                                    .r_aib_csr_ctrl_44  (aib_csr_ctrl_44[7:0]), // Templated
                                    .r_aib_csr_ctrl_47  (aib_csr_ctrl_47[7:0]), // Templated
                                    .ihssi_rx_data_out  (aib_rx_data[39:0]), // Templated
                                    .r_aib_csr_ctrl_34  (aib_csr_ctrl_34[7:0]), // Templated
                                    .r_aib_csr_ctrl_35  (aib_csr_ctrl_35[7:0]), // Templated
                                    .r_aib_dprio_ctrl_4 (aib_dprio_ctrl_4[7:0]), // Templated
                                    .iaibdftcore2dll    (aibdftcore2dll), // Templated
                                    .r_aib_dprio_ctrl_1 (aib_dprio_ctrl_1[7:0]), // Templated
                                    .r_aib_dprio_ctrl_0 (aib_dprio_ctrl_0[7:0]), // Templated
                                    .r_aib_csr_ctrl_20  (aib_csr_ctrl_20[7:0]), // Templated
                                    .r_aib_csr_ctrl_19  (aib_csr_ctrl_19[7:0]), // Templated
                                    .r_aib_csr_ctrl_50  (aib_csr_ctrl_50[7:0]), // Templated
                                    .r_aib_csr_ctrl_53  (aib_csr_ctrl_53[7:0]), // Templated
                                    .r_aib_csr_ctrl_13  (aib_csr_ctrl_13[7:0]), // Templated
                                    .r_aib_csr_ctrl_17  (aib_csr_ctrl_17[7:0]), // Templated
                                    .r_aib_csr_ctrl_23  (aib_csr_ctrl_23[7:0]), // Templated
                                    .r_aib_csr_ctrl_12  (aib_csr_ctrl_12[7:0]), // Templated
                                    .r_aib_csr_ctrl_26  (aib_csr_ctrl_26[7:0]), // Templated
                                    .r_aib_dprio_ctrl_2 (aib_dprio_ctrl_2[7:0]), // Templated
                                    .r_aib_csr_ctrl_29  (aib_csr_ctrl_29[7:0]), // Templated
                                    .r_aib_csr_ctrl_30  (aib_csr_ctrl_30[7:0]), // Templated
                                    .r_aib_csr_ctrl_24  (aib_csr_ctrl_24[7:0]), // Templated
                                    .r_aib_csr_ctrl_46  (aib_csr_ctrl_46[7:0]), // Templated
                                    .r_aib_csr_ctrl_39  (aib_csr_ctrl_39[7:0]), // Templated
                                    .r_aib_csr_ctrl_37  (aib_csr_ctrl_37[7:0]), // Templated
                                    .r_aib_csr_ctrl_38  (aib_csr_ctrl_38[7:0]), // Templated
                                    .ishared_direct_async_in(shared_direct_async_in[4:0]), // Templated
                                    .r_aib_csr_ctrl_31  (aib_csr_ctrl_31[7:0]), // Templated
                                    .r_aib_csr_ctrl_18  (aib_csr_ctrl_18[7:0]), // Templated
                                    .r_aib_dprio_ctrl_3 (aib_dprio_ctrl_3[7:0]), // Templated
                                    .r_aib_csr_ctrl_27  (aib_csr_ctrl_27[7:0]), // Templated
                                    .r_aib_csr_ctrl_41  (aib_csr_ctrl_41[7:0]), // Templated
                                    .r_aib_csr_ctrl_22  (aib_csr_ctrl_22[7:0]), // Templated
                                    .r_aib_csr_ctrl_51  (aib_csr_ctrl_51[7:0]), // Templated
                                    .r_aib_csr_ctrl_33  (aib_csr_ctrl_33[7:0]), // Templated
                                    .r_aib_csr_ctrl_32  (aib_csr_ctrl_32[7:0]), // Templated
                                    .r_aib_csr_ctrl_28  (aib_csr_ctrl_28[7:0]), // Templated
                                    .r_aib_csr_ctrl_21  (aib_csr_ctrl_21[7:0]), // Templated
                                    .r_aib_csr_ctrl_16  (aib_csr_ctrl_16[7:0]), // Templated
                                    .r_aib_csr_ctrl_15  (aib_csr_ctrl_15[7:0]), // Templated
                                    .r_aib_csr_ctrl_14  (aib_csr_ctrl_14[7:0]), // Templated
                                    .r_aib_csr_ctrl_11  (aib_csr_ctrl_11[7:0]), // Templated
                                    .r_aib_csr_ctrl_10  (aib_csr_ctrl_10[7:0]), // Templated
                                    .r_aib_csr_ctrl_9   (aib_csr_ctrl_9[7:0]), // Templated
                                    .r_aib_csr_ctrl_8   (aib_csr_ctrl_8[7:0]), // Templated
                                    .r_aib_csr_ctrl_7   (aib_csr_ctrl_7[7:0]), // Templated
                                    .r_aib_csr_ctrl_6   (aib_csr_ctrl_6[7:0]), // Templated
                                    .r_aib_csr_ctrl_5   (aib_csr_ctrl_5[7:0]), // Templated
                                    .r_aib_csr_ctrl_4   (aib_csr_ctrl_4[7:0]), // Templated
                                    .r_aib_csr_ctrl_3   (aib_csr_ctrl_3[7:0]), // Templated
                                    .r_aib_csr_ctrl_2   (aib_csr_ctrl_2[7:0]), // Templated
                                    .r_aib_csr_ctrl_1   (aib_csr_ctrl_1[7:0]), // Templated
                                    .r_aib_csr_ctrl_0   (aib_csr_ctrl_0[7:0]), // Templated
                                    .r_aib_csr_ctrl_25  (aib_csr_ctrl_25[7:0])); // Templated

endmodule

// Local Variables:
// verilog-library-directories:(".""../../c3aibadapt/rtl""../../aibcr3_lib/rtl""../../c3dfx/rtl/tcb")
// verilog-auto-inst-param-value: t
// End:
