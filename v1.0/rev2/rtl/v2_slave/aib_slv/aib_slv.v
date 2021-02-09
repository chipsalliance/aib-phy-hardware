// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
module aib_slv 
(
 //================================================================================================
 // Path directly from chip programming controller
    input [5:0]                                i_channel_id, // channel ID to program
    input                                      i_cfg_avmm_clk, 
    input                                      i_cfg_avmm_rst_n, 
    input [16:0]                               i_cfg_avmm_addr, // address to be programmed
    input [3:0]                                i_cfg_avmm_byte_en, // byte enable
    input                                      i_cfg_avmm_read, // Asserted to indicate the Cfg read access
    input                                      i_cfg_avmm_write, // Asserted to indicate the Cfg write access
    input [31:0]                               i_cfg_avmm_wdata, // data to be programmed
 
    output wire                                o_cfg_avmm_rdatavld,// Assert to indicate data available for Cfg read access 
    output wire[31:0]                          o_cfg_avmm_rdata, // data returned for Cfg read access
    output wire                                o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg access

 //Configuration Channel pass through Path from other channel, depends on how the PNR physical block look like, user can either
 //connect up with the cfg_avmm path directly or use this feedthrough path to the next adaptor
    output wire                                o_adpt_cfg_clk, // take i_cfg_avmm_clk as input and pass to channel n+1
    output wire                                o_adpt_cfg_rst_n, // take i_cfg_avmm_rst_n as input and pass to the channel n+1
    output wire [16:0]                         o_adpt_cfg_addr, // take i_cfg_avmm_addr as input and pass to the channel n+1
    output wire [3:0]                          o_adpt_cfg_byte_en, // take i_cfg_avmm_byte_en as input and pass to the channel n+1
    output wire                                o_adpt_cfg_read, // take i_cfg_avmm_read as input and pass to the channel n+1
    output wire                                o_adpt_cfg_write, // take i_cfg_avmm_write as input and pass to the channel n+1
    output wire [31:0]                         o_adpt_cfg_wdata, // take i_cfg_avmm_wdata as input and pass to the channel n+1
 
    input                                      i_adpt_cfg_rdatavld, // CfgRd request data valid from channel n+1
    input [31:0]                               i_adpt_cfg_rdata, // Data returned for CfgRd access from channel n+1
    input                                      i_adpt_cfg_waitreq, // Asserted to indicate not ready for the Cfg access from channel n+1

 //===============================================================================================
 // Data Path
    input [77:0]                               data_in, //data input from MAC, For transmitting across the AIB link
    output wire [77:0]                         data_out,  //data output to MAC, Received through the AIB link
    input                                      m_ns_fwd_clk, //For transmitting data from the near side to the far side
    input                                      m_ns_fwd_div2_clk, //m_ns_fwd_clk divide by 2
    output wire                                m_fs_fwd_clk, //Received from the far side
    output wire                                m_fs_fwd_div2_clk, //m_fs_fwd_clk divide by 2
    output wire                                m_fs_rcv_clk, //Received from the far side
    output wire                                m_fs_rcv_div2_clk, //m_fs_rcv_clk divide by 2
    input                                      m_ns_rcv_clk, //Receive-domain clock forwarded from the near side to the far side for transmitting data from the far side
    output wire                                conf_done_o, //feed through of conf_done, for p&r

    input                                      ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive data.
    output wire                                fs_mac_rdy,  //Indicates that the far-side MAC is ready to transmit data
    input                                      ns_adapter_rstn,  //From Mac. Resets the AIB Adapter

    input                                      ms_rx_dcc_dll_lock_req,  //From Mac. master mode functional input
    input                                      ms_tx_dcc_dll_lock_req,  //From Mac. master mode functional input
    input                                      sl_rx_dcc_dll_lock_req,  //From Mac. slave mode functional input
    input                                      sl_tx_dcc_dll_lock_req,  //From Mac. slave mode functional input

    output wire                                ms_tx_transfer_en,  
    output wire                                ms_rx_transfer_en,  
    output wire                                sl_tx_transfer_en,  
    output wire                                sl_rx_transfer_en,  

    input [26:0]                               sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register, These are slave mode functional inputs.
    input [2:0]                                sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register, These are slave mode functional inputs.
    input [25:0]                               sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register, These are slave mode functional inputs.
    input [4:0]                                ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register, These are master mode functional inputs.
    input [57:0]                               ms_external_cntl_65_8,   //user defined bits 65:8 for master shift register, These are master mode functional inputs.

    input                                      i_osc_clk, // free running clock from MAC
    input                                      m_wr_clk,  //data_in reference clock for FIFO 1x or FIFO 2x modes 
    input                                      m_rd_clk,  //data_out reference clock for FIFO 1x or FIFO 2x modes 
    output wire                                o_osc_clk, // output to next channel
    output wire [80:0]                         ms_sideband, //Captured Master sideband shift register bits
    output wire [72:0]                         sl_sideband, //Captured Slave sideband shift register bits
    input                                      dual_mode_select,  //Selection for adapter to be master or slave
    output wire                                      m_rx_fifo_align_done,  //indication of the receiving data word alignment detection.
    input                                      conf_done, // it was i_adpt_hard_rst_n, AIB adaptor hard reset
    
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
    input                                      i_scan_clk, // Four scan clock from common test pin for scan shifting 
    input                                      i_test_clk_1g, // Capture Clock used for SAF and at speed test. 
    input                                      i_test_clk_500m,// Capture clock divided down from i_test_clk_1g 
    input                                      i_test_clk_250m,// Capture clock divided down from i_test_clk_1g
    input                                      i_test_clk_125m,// Capture clock divided down from i_test_clk_1g 
    input                                      i_test_clk_62m, // Capture clock divided down from i_test_clk_1g 

    input [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG] i_test_c3adapt_tcb_static_common,//Used for ATPG mode control how to drive TCM
    input [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]   i_test_c3adapt_scan_in,//From top level codec scan in. 17 bit 
    output wire [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  o_test_c3adapt_scan_out,//To top level TCB codec for output compression 17bit 
                                                                       //bit [10:0] full scan.
                                                                       //    [11]   i_atpg_scan_out0
                                                                       //    [12]   i_atpg_scan_out1
                                                                       //    [16:13]i_atpg_bsr3-0_scan_out
    output wire [`AIBADAPTWRAPTCB_JTAG_OUT_RNG]     o_test_c3adapttcb_jtag, //13 bit dftdll2core Go to toplevel tcb block.
// DFT JTAG
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
// Feed through pass to next adaptor. User can implement different way depends
// on their P&R flow
    output wire                                o_jtag_clkdr_out, 
    output wire                                o_jtag_clksel_out, 
    output wire                                o_jtag_intest_out, 
    output wire                                o_jtag_mode_out, 
    output wire                                o_jtag_rstb_en_out, 
    output wire                                o_jtag_rstb_out, 
    output wire                                o_jtag_weakpdn_out, 
    output wire                                o_jtag_weakpu_out, 

    output wire                                o_jtag_bs_chain_out, 
    output wire                                o_jtag_bs_scanen_out, 
    output wire                                o_jtag_last_bs_chain_out,

//Interface with AUX
    input                                      i_por_aib_vcchssi, //output of por circuit 
    input                                      i_por_aib_vccl, //From AUX. From S10 
    output wire                                o_por_aib_vcchssi, // Feed through pass to next channel 
    output wire                                o_por_aib_vccl, // 


// Go to next Channel AIB
//  input  [12:0]                               i_aibdftdll2adjch, // DCC/DLL observability from previous channel
//  output wire [12:0]                          o_aibdftdll2adjch,  // DCC/DLL observability Go to next channel 
    input   wire                      scan_clk,
    input   wire                      scan_enable,
    input   wire [19:0]               scan_in,
    output  wire [19:0]               scan_out
 );

    wire                fs_fwd_clk;
    wire                ns_fwd_clk;
    wire                ns_fwd_div2_clk;
    wire                ns_rcv_clk;
    wire                aib_fs_mac_rdy;
    wire [39:0]         din;
    wire                tx_dcc_cal_done;
    wire                rx_dll_lock;
    wire                ns_mac_rdyo;
    wire                ns_adapter_rstno;
    wire                osc_clk_adpt;

    wire                aib_adpt_ssr_data;      // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_adpt_ssr_load;      // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                sr_clk_in;              // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_bsr_scan_shift_clk; // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_0;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_1;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_10;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_11;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_12;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_13;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_14;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_15;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_16;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_17;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_18;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_19;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_2;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_20;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_21;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_22;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_23;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_24;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_25;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_26;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_27;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_28;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_29;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_3;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_30;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_31;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_32;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_33;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_34;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_35;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_36;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_37;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_38;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_39;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_4;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_40;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_41;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_42;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_43;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_44;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_45;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_46;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_47;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_48;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_49;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_5;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_50;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_51;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_52;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_53;        // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_6;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_7;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_8;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_csr_ctrl_9;         // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_dprio_ctrl_0;       // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_dprio_ctrl_1;       // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_dprio_ctrl_2;       // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_dprio_ctrl_3;       // From aib_adapt of aib_adapt.v
    wire [7:0]          aib_dprio_ctrl_4;       // From aib_adapt of aib_adapt.v
    wire                aib_internal1_clk;      // From aib_adapt of aib_adapt.v
    wire                aib_internal2_clk;      // From aib_adapt of aib_adapt.v
    wire [39:0]         dout;            // From aib_adapt of aib_adapt.v
    wire                aib_rx_dcd_cal_done;    // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_rx_xcvrif_rst_n;    // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_tx_adpt_rst_n;      // From aib_iotop_wrp of aib_iotop_wrp.v
    wire [39:0]         aib_tx_data;            // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_tx_dcd_cal_done;    // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_tx_sr_clk_in;       // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                aib_tx_transfer_clk;    // From aib_iotop_wrp of aib_iotop_wrp.v
    wire [12:0]         aibdftdll2core;         // From aib_iotop_wrp of aib_iotop_wrp.v
    wire [12:0]         w_dftdll2core;
    wire                atpg_bsr0_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr0_scan_out;     // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                atpg_bsr1_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr1_scan_out;     // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                atpg_bsr2_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr2_scan_out;     // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                atpg_bsr3_scan_in;      // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                atpg_bsr3_scan_out;     // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                atpg_bsr_scan_shift_n;  // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [4:0]          shared_direct_async_in; // From aib_adapt of aib_adapt.v
    wire [2:0]          shared_direct_async_out;// From aib_iotop_wrp of aib_iotop_wrp.v
    wire                w_atpg_scan_in0;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_atpg_scan_in1;        // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_atpg_scan_out0;       // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                w_atpg_scan_out1;       // From aib_iotop_wrp of aib_iotop_wrp.v
    wire                w_avmm1_scan_clk;       // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire                w_avmm1_test_clk;       // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [`TCM_WRAP_CTRL_RNG] w_avmm1_tst_tcm_ctrl;// From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [1:0]          w_dftcore2dll;          // From c3dfx_aibadaptwrap_tcb of c3dfx_aibadaptwrap_tcb.v
    wire [1:0]          aibdftcore2dll;         
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
    
    aib_adapt aib_adapt (
                           // Outputs
                           .o_adpt_cfg_clk      (o_adpt_cfg_clk), 
                           .o_adpt_cfg_rst_n    (o_adpt_cfg_rst_n), 
                           .o_adpt_cfg_addr     (o_adpt_cfg_addr[16:0]), 
                           .o_adpt_cfg_wdata    (o_adpt_cfg_wdata[31:0]), 
                           .o_adpt_cfg_write    (o_adpt_cfg_write), 
                           .o_adpt_cfg_read     (o_adpt_cfg_read), 
                           .o_adpt_cfg_byte_en  (o_adpt_cfg_byte_en[3:0]), 
                           .o_cfg_avmm_rdata    (o_cfg_avmm_rdata[31:0]), 
                           .o_cfg_avmm_rdatavld (o_cfg_avmm_rdatavld), 
                           .o_cfg_avmm_waitreq  (o_cfg_avmm_waitreq), 
                           .dout                (dout[39:0]), 
                           .data_out            (data_out[77:0]), 
                           .m_rxfifo_align_done (m_rx_fifo_align_done), 
                           .m_fs_fwd_clk        (m_fs_fwd_clk), 
                           .m_fs_fwd_div2_clk   (m_fs_fwd_div2_clk), 
                           .m_ns_rcv_clk        (m_ns_rcv_clk), 
                           .m_fs_rcv_clk        (m_fs_rcv_clk), 
                           .m_fs_rcv_div2_clk   (m_fs_rcv_div2_clk), 
                           .ms_tx_transfer_en   (ms_tx_transfer_en), 
                           .ms_rx_transfer_en   (ms_rx_transfer_en), 
                           .sl_tx_transfer_en   (sl_tx_transfer_en), 
                           .sl_rx_transfer_en   (sl_rx_transfer_en), 
                           .tx_dcc_cal_req      (tx_dcc_cal_req), 
                           .rx_dll_lock_req     (rx_dll_lock_req), 
                           .sr_clk_out          (sr_clk_out), 
                           .std_out             (std_out), 
                           .stl_out             (stl_out), 
                           .o_aib_csr_ctrl_0    (aib_csr_ctrl_0[7:0]), 
                           .o_aib_csr_ctrl_1    (aib_csr_ctrl_1[7:0]), 
                           .o_aib_csr_ctrl_10   (aib_csr_ctrl_10[7:0]), 
                           .o_aib_csr_ctrl_11   (aib_csr_ctrl_11[7:0]), 
                           .o_aib_csr_ctrl_12   (aib_csr_ctrl_12[7:0]), 
                           .o_aib_csr_ctrl_13   (aib_csr_ctrl_13[7:0]), 
                           .o_aib_csr_ctrl_14   (aib_csr_ctrl_14[7:0]), 
                           .o_aib_csr_ctrl_15   (aib_csr_ctrl_15[7:0]), 
                           .o_aib_csr_ctrl_16   (aib_csr_ctrl_16[7:0]), 
                           .o_aib_csr_ctrl_17   (aib_csr_ctrl_17[7:0]), 
                           .o_aib_csr_ctrl_18   (aib_csr_ctrl_18[7:0]), 
                           .o_aib_csr_ctrl_19   (aib_csr_ctrl_19[7:0]), 
                           .o_aib_csr_ctrl_2    (aib_csr_ctrl_2[7:0]), 
                           .o_aib_csr_ctrl_20   (aib_csr_ctrl_20[7:0]), 
                           .o_aib_csr_ctrl_21   (aib_csr_ctrl_21[7:0]), 
                           .o_aib_csr_ctrl_22   (aib_csr_ctrl_22[7:0]), 
                           .o_aib_csr_ctrl_23   (aib_csr_ctrl_23[7:0]), 
                           .o_aib_csr_ctrl_24   (aib_csr_ctrl_24[7:0]), 
                           .o_aib_csr_ctrl_25   (aib_csr_ctrl_25[7:0]), 
                           .o_aib_csr_ctrl_26   (aib_csr_ctrl_26[7:0]), 
                           .o_aib_csr_ctrl_27   (aib_csr_ctrl_27[7:0]), 
                           .o_aib_csr_ctrl_28   (aib_csr_ctrl_28[7:0]), 
                           .o_aib_csr_ctrl_29   (aib_csr_ctrl_29[7:0]), 
                           .o_aib_csr_ctrl_3    (aib_csr_ctrl_3[7:0]), 
                           .o_aib_csr_ctrl_30   (aib_csr_ctrl_30[7:0]), 
                           .o_aib_csr_ctrl_31   (aib_csr_ctrl_31[7:0]), 
                           .o_aib_csr_ctrl_32   (aib_csr_ctrl_32[7:0]), 
                           .o_aib_csr_ctrl_33   (aib_csr_ctrl_33[7:0]), 
                           .o_aib_csr_ctrl_34   (aib_csr_ctrl_34[7:0]), 
                           .o_aib_csr_ctrl_35   (aib_csr_ctrl_35[7:0]), 
                           .o_aib_csr_ctrl_36   (aib_csr_ctrl_36[7:0]), 
                           .o_aib_csr_ctrl_37   (aib_csr_ctrl_37[7:0]), 
                           .o_aib_csr_ctrl_38   (aib_csr_ctrl_38[7:0]), 
                           .o_aib_csr_ctrl_39   (aib_csr_ctrl_39[7:0]), 
                           .o_aib_csr_ctrl_4    (aib_csr_ctrl_4[7:0]), 
                           .o_aib_csr_ctrl_40   (aib_csr_ctrl_40[7:0]), 
                           .o_aib_csr_ctrl_41   (aib_csr_ctrl_41[7:0]), 
                           .o_aib_csr_ctrl_42   (aib_csr_ctrl_42[7:0]), 
                           .o_aib_csr_ctrl_43   (aib_csr_ctrl_43[7:0]), 
                           .o_aib_csr_ctrl_44   (aib_csr_ctrl_44[7:0]), 
                           .o_aib_csr_ctrl_45   (aib_csr_ctrl_45[7:0]), 
                           .o_aib_csr_ctrl_46   (aib_csr_ctrl_46[7:0]), 
                           .o_aib_csr_ctrl_47   (aib_csr_ctrl_47[7:0]), 
                           .o_aib_csr_ctrl_48   (aib_csr_ctrl_48[7:0]), 
                           .o_aib_csr_ctrl_49   (aib_csr_ctrl_49[7:0]), 
                           .o_aib_csr_ctrl_5    (aib_csr_ctrl_5[7:0]), 
                           .o_aib_csr_ctrl_50   (aib_csr_ctrl_50[7:0]), 
                           .o_aib_csr_ctrl_51   (aib_csr_ctrl_51[7:0]), 
                           .o_aib_csr_ctrl_52   (aib_csr_ctrl_52[7:0]), 
                           .o_aib_csr_ctrl_53   (aib_csr_ctrl_53[7:0]), 
                           .o_aib_csr_ctrl_6    (aib_csr_ctrl_6[7:0]), 
                           .o_aib_csr_ctrl_7    (aib_csr_ctrl_7[7:0]), 
                           .o_aib_csr_ctrl_8    (aib_csr_ctrl_8[7:0]), 
                           .o_aib_csr_ctrl_9    (aib_csr_ctrl_9[7:0]), 
                           .o_aib_dprio_ctrl_0  (aib_dprio_ctrl_0[7:0]), 
                           .o_aib_dprio_ctrl_1  (aib_dprio_ctrl_1[7:0]), 
                           .o_aib_dprio_ctrl_2  (aib_dprio_ctrl_2[7:0]), 
                           .o_aib_dprio_ctrl_3  (aib_dprio_ctrl_3[7:0]), 
                           .o_aib_dprio_ctrl_4  (aib_dprio_ctrl_4[7:0]), 
                           .o_aibdftcore2dll    (aibdftcore2dll[1:0]),
                           .o_dftdll2core       (w_dftdll2core[12:0]),
                           .ms_sideband         (ms_sideband[80:0]),
                           .sl_sideband         (sl_sideband[72:0]),
                           .ns_mac_rdyo         (ns_mac_rdyo),
                           .ns_adapter_rstno    (ns_adapter_rstno),
                           // Inputs
                           .i_aib_avmm1_data    (2'b00),  
                           .i_aib_ssr_data      (aib_adpt_ssr_data), 
                           .i_aib_ssr_load      (aib_adpt_ssr_load), 
                           .aib_fs_mac_rdy      (aib_fs_mac_rdy), 
                           .sr_clk_in           (sr_clk_in), 
                           .srd_in              (srd_in), 
                           .srl_in              (srl_in), 
                           .din                 (din[39:0]), 
                           .data_in             (data_in[77:0]), 
                           .m_ns_fwd_clk        (m_ns_fwd_clk), 
                           .m_ns_fwd_div2_clk   (m_ns_fwd_div2_clk), 
                           .m_wr_clk            (m_wr_clk), 
                           .m_rd_clk            (m_rd_clk), 
                           .fs_fwd_clk          (fs_fwd_clk), 
                           .fs_rcv_clk          (fs_rcv_clk), 
                           .conf_done           (conf_done), 
                           .conf_done_o         (conf_done_o), 
                           .ns_fwd_clk          (ns_fwd_clk), 
                           .ns_fwd_div2_clk     (ns_fwd_div2_clk), 
                           .ns_rcv_clk          (ns_rcv_clk), 
                           .ms_rx_dcc_dll_lock_req         (ms_rx_dcc_dll_lock_req), 
                           .ms_tx_dcc_dll_lock_req         (ms_tx_dcc_dll_lock_req), 
                           .sl_tx_dcc_dll_lock_req         (sl_tx_dcc_dll_lock_req), 
                           .sl_rx_dcc_dll_lock_req         (sl_rx_dcc_dll_lock_req), 
                           .tx_dcc_cal_done                (tx_dcc_cal_done), 
                           .rx_dll_lock                    (rx_dll_lock), 
                           .adapter_rstni                  (ohssi_adapter_rx_pld_rst_n), 
                           .ns_adapter_rstn                (ns_adapter_rstn), 
                           .ns_mac_rdy                     (ns_mac_rdy), 
                           .fs_mac_rdy                     (fs_mac_rdy), 
                           .dual_mode_select               (dual_mode_select), 
                           .i_osc_clk                      (osc_clk_adpt), 
                           .sl_external_cntl_26_0          (sl_external_cntl_26_0[26:0]), 
                           .sl_external_cntl_30_28         (sl_external_cntl_30_28[2:0]), 
                           .sl_external_cntl_57_32         (sl_external_cntl_57_32[25:0]), 
                           .ms_external_cntl_4_0           (ms_external_cntl_4_0[4:0]), 
                           .ms_external_cntl_65_8          (ms_external_cntl_65_8[57:0]), 
                           .i_aib_tx_transfer_clk(aib_tx_transfer_clk), 
                           .i_adpt_hard_rst_n   (conf_done), 
                           .i_adpt_cfg_rdata    (i_adpt_cfg_rdata[31:0]), 
                           .i_adpt_cfg_rdatavld (i_adpt_cfg_rdatavld), 
                           .i_adpt_cfg_waitreq  (i_adpt_cfg_waitreq), 
                           .i_cfg_avmm_addr_id  (i_channel_id[5:0]), 
                           .i_cfg_avmm_clk      (i_cfg_avmm_clk), 
                           .i_cfg_avmm_rst_n    (i_cfg_avmm_rst_n), 
                           .i_cfg_avmm_addr     (i_cfg_avmm_addr[16:0]), 
                           .i_cfg_avmm_wdata    (i_cfg_avmm_wdata[31:0]), 
                           .i_cfg_avmm_write    (i_cfg_avmm_write), 
                           .i_cfg_avmm_read     (i_cfg_avmm_read), 
                           .i_cfg_avmm_byte_en  (i_cfg_avmm_byte_en[3:0]), 
                           .i_dftcore2dll       (w_dftcore2dll[1:0]),
                           .i_aibdftdll2core    (aibdftdll2core[12:0]),
                           .i_scan_mode_n       (w_scan_mode_n), 
                           .i_avmm1_tst_tcm_ctrl(w_avmm1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                           .i_avmm1_test_clk    (w_avmm1_test_clk), 
                           .i_avmm1_scan_clk    (w_avmm1_scan_clk), 
                           .i_txchnl_0_tst_tcm_ctrl(w_txchnl_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                           .i_txchnl_0_test_clk (w_txchnl_0_test_clk), 
                           .i_txchnl_0_scan_clk (w_txchnl_0_scan_clk), 
                           .i_txchnl_1_tst_tcm_ctrl(w_txchnl_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                           .i_txchnl_1_test_clk (w_txchnl_1_test_clk), 
                           .i_txchnl_1_scan_clk (w_txchnl_1_scan_clk), 
                           .i_txchnl_2_tst_tcm_ctrl(w_txchnl_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                           .i_txchnl_2_test_clk (w_txchnl_2_test_clk), 
                           .i_txchnl_2_scan_clk (w_txchnl_2_scan_clk), 
                           .i_rxchnl_tst_tcm_ctrl(w_rxchnl_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                           .i_rxchnl_test_clk   (w_rxchnl_test_clk), 
                           .i_rxchnl_scan_clk   (w_rxchnl_scan_clk), 
                           .i_scan_rst_n        (w_scan_rst_n),  
                           .scan_clk            (scan_clk),  
                           .scan_enable         (scan_enable),  
                           .scan_in             (scan_in[19:0]),  
                           .scan_out            (scan_out[19:0]));  


    c3dfx_aibadaptwrap_tcb c3dfx_aibadaptwrap_tcb (
                                                   // Outputs
                                                   .o_tst_aibadaptwraptcb_jtag(o_test_c3adapttcb_jtag[`AIBADAPTWRAPTCB_JTAG_OUT_RNG]), 
                                                   .o_tst_aibadaptwrap_scan_out(o_test_c3adapt_scan_out[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), 
                                                   .o_dftcore2dll       (w_dftcore2dll[1:0]), 
                                                   .o_avmm1_tst_tcm_ctrl(w_avmm1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_avmm1_test_clk    (w_avmm1_test_clk), 
                                                   .o_avmm1_scan_clk    (w_avmm1_scan_clk), 
                                                   .o_rxchnl_tst_tcm_ctrl(w_rxchnl_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_rxchnl_test_clk   (w_rxchnl_test_clk), 
                                                   .o_rxchnl_scan_clk   (w_rxchnl_scan_clk), 
                                                   .o_sr_0_tst_tcm_ctrl (w_sr_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_sr_0_test_clk     (w_sr_0_test_clk), 
                                                   .o_sr_0_scan_clk     (w_sr_0_scan_clk), 
                                                   .o_sr_1_tst_tcm_ctrl (w_sr_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_sr_1_test_clk     (w_sr_1_test_clk), 
                                                   .o_sr_1_scan_clk     (w_sr_1_scan_clk), 
                                                   .o_sr_2_tst_tcm_ctrl (w_sr_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_sr_2_test_clk     (w_sr_2_test_clk), 
                                                   .o_sr_2_scan_clk     (w_sr_2_scan_clk), 
                                                   .o_sr_3_tst_tcm_ctrl (w_sr_3_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_sr_3_test_clk     (w_sr_3_test_clk), 
                                                   .o_sr_3_scan_clk     (w_sr_3_scan_clk), 
                                                   .o_txchnl_0_tst_tcm_ctrl(w_txchnl_0_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_txchnl_0_test_clk (w_txchnl_0_test_clk), 
                                                   .o_txchnl_0_scan_clk (w_txchnl_0_scan_clk), 
                                                   .o_txchnl_1_tst_tcm_ctrl(w_txchnl_1_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_txchnl_1_test_clk (w_txchnl_1_test_clk), 
                                                   .o_txchnl_1_scan_clk (w_txchnl_1_scan_clk), 
                                                   .o_txchnl_2_tst_tcm_ctrl(w_txchnl_2_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG]), 
                                                   .o_txchnl_2_test_clk (w_txchnl_2_test_clk), 
                                                   .o_txchnl_2_scan_clk (w_txchnl_2_scan_clk), 
                                                   .o_scan_mode_n       (w_scan_mode_n), 
                                                   .o_scan_rst_n        (w_scan_rst_n),  
                                                   .o_scan_shift_n      (w_scan_shift_n), 
                                                   .o_global_pipe_scanen(w_global_pipe_scanen), 
                                                   .o_atpg_scan_in0     (w_atpg_scan_in0), 
                                                   .o_atpg_scan_in1     (w_atpg_scan_in1), 
                                                   .o_atpg_scan_clk_in0 (),              
                                                   .o_atpg_scan_clk_in1 (),              
                                                   .o_atpg_bsr0_scan_in (atpg_bsr0_scan_in), 
                                                   .o_atpg_bsr0_scan_shift_clk(),        
                                                   .o_atpg_bsr1_scan_in (atpg_bsr1_scan_in), 
                                                   .o_atpg_bsr1_scan_shift_clk(),        
                                                   .o_atpg_bsr2_scan_in (atpg_bsr2_scan_in), 
                                                   .o_atpg_bsr2_scan_shift_clk(),        
                                                   .o_atpg_bsr3_scan_in (atpg_bsr3_scan_in), 
                                                   .o_atpg_bsr3_scan_shift_clk(),        
                                                   .o_atpg_bsr_scan_shift_n(atpg_bsr_scan_shift_n), 
                                                   // Inputs
                                                   .i_tck               (1'b0),          
                                                   .i_scan_clk1         (i_scan_clk),    
                                                   .i_scan_clk2         (i_scan_clk),    
                                                   .i_scan_clk3         (i_scan_clk),    
                                                   .i_scan_clk4         (i_scan_clk),    
                                                   .i_test_clk_1g       (i_test_clk_1g), 
                                                   .i_test_clk_500m     (i_test_clk_500m), 
                                                   .i_test_clk_250m     (i_test_clk_250m), 
                                                   .i_test_clk_125m     (i_test_clk_125m), 
                                                   .i_test_clk_62m      (i_test_clk_62m), 
                                                   .i_tst_aibadaptwraptcb_jtag(2'h0),    
                                                   .i_tst_aibadaptwraptcb_jtag_common(2'h0), 
                                                   .i_tst_aibadaptwraptcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]), 
                                                   .i_tst_aibadaptwrap_scan_in(i_test_c3adapt_scan_in[`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]), 
                                                   .i_dftdll2core       (w_dftdll2core[12:0]), 
                                                   .i_atpg_scan_out0    (1'b0), 
                                                   .i_atpg_scan_out1    (1'b0), 
                                                   .i_atpg_bsr0_scan_out(1'b0), 
                                                   .i_atpg_bsr1_scan_out(1'b0), 
                                                   .i_atpg_bsr2_scan_out(1'b0), 
                                                   .i_atpg_bsr3_scan_out(1'b0)); 
 

    aib_iotop_wrp aib_iotop_wrp (
                                    // Outputs
                                    .osc_clkout         (o_osc_clk), 
                                    .osc_clk_adpt       (osc_clk_adpt), 
                                    .jtag_clksel_out    (o_jtag_clksel_out), 
                                    .jtag_intest_out    (o_jtag_intest_out), 
                                    .jtag_mode_out      (o_jtag_mode_out), 
                                    .jtag_rstb_en_out   (o_jtag_rstb_en_out), 
                                    .jtag_rstb_out      (o_jtag_rstb_out), 
                                    .jtag_tx_scanen_out (o_jtag_bs_scanen_out), 
                                    .jtag_weakpdn_out   (o_jtag_weakpdn_out), 
                                    .jtag_weakpu_out    (o_jtag_weakpu_out), 
                                    .oatpg_bsr0_scan_out(atpg_bsr0_scan_out), 
                                    .oatpg_bsr1_scan_out(atpg_bsr1_scan_out), 
                                    .oatpg_bsr2_scan_out(atpg_bsr2_scan_out), 
                                    .oatpg_bsr3_scan_out(atpg_bsr3_scan_out), 
                                    .oatpg_scan_out0    (w_atpg_scan_out0), 
                                    .oatpg_scan_out1    (w_atpg_scan_out1), 
                                    .odirectout_data_out_chain1(o_directout_data_chain1_out), 
                                    .odirectout_data_out_chain2(o_directout_data_chain2_out), 
                                    .ohssi_adapter_rx_pld_rst_n(ohssi_adapter_rx_pld_rst_n),//aib56 
                                    .ohssi_pld_pma_coreclkin(fs_rcv_clk), 
                                    .ohssi_pld_pma_rxpma_rstb(aib_fs_mac_rdy), 
                                    .ohssi_sr_clk_in    (sr_clk_in), 
                                    .ohssi_ssr_data_in  (srd_in), 
                                    .ohssi_ssr_load_in  (srl_in), 
                                    .ohssi_tx_dcd_cal_done(),  //from dummy dcc output
                                    .ohssi_tx_dll_lock  (rx_dll_lock),  
                                    .ohssi_tx_transfer_clk(fs_fwd_clk),  //aib41
                                    .ohssirx_dcc_done   (tx_dcc_cal_done),  
                                    .ojtag_clkdr_out_chain(o_jtag_clkdr_out), 
                                    .ojtag_last_bs_out_chain(o_jtag_last_bs_chain_out), 
                                    .ojtag_rx_scan_out_chain(o_jtag_bs_chain_out), 
                                    .por_aib_vcchssi_out(o_por_aib_vcchssi), 
                                    .por_aib_vccl_out   (o_por_aib_vccl), 
                               //   .oaibdftdll2adjch   (o_aibdftdll2adjch), 
                                    .oaibdftdll2adjch   (), 
                                    .oaibdftdll2core    (aibdftdll2core[12:0]), 
                                    .ohssi_tx_data_in   (din[39:0]), 
                                    // Inouts
                                    .aib0               (io_aib0),       
                                    .aib1               (io_aib1),       
                                    .aib2               (io_aib2),       
                                    .aib3               (io_aib3),       
                                    .aib4               (io_aib4),       
                                    .aib5               (io_aib5),       
                                    .aib6               (io_aib6),       
                                    .aib7               (io_aib7),       
                                    .aib8               (io_aib8),       
                                    .aib9               (io_aib9),       
                                    .aib10              (io_aib10),      
                                    .aib11              (io_aib11),      
                                    .aib12              (io_aib12),      
                                    .aib13              (io_aib13),      
                                    .aib14              (io_aib14),      
                                    .aib15              (io_aib15),      
                                    .aib16              (io_aib16),      
                                    .aib17              (io_aib17),      
                                    .aib18              (io_aib18),      
                                    .aib19              (io_aib19),      
                                    .aib20              (io_aib20),      
                                    .aib21              (io_aib21),      
                                    .aib22              (io_aib22),      
                                    .aib23              (io_aib23),      
                                    .aib24              (io_aib24),      
                                    .aib25              (io_aib25),      
                                    .aib26              (io_aib26),      
                                    .aib27              (io_aib27),      
                                    .aib28              (io_aib28),      
                                    .aib29              (io_aib29),      
                                    .aib30              (io_aib30),      
                                    .aib31              (io_aib31),      
                                    .aib32              (io_aib32),      
                                    .aib33              (io_aib33),      
                                    .aib34              (io_aib34),      
                                    .aib35              (io_aib35),      
                                    .aib36              (io_aib36),      
                                    .aib37              (io_aib37),      
                                    .aib38              (io_aib38),      
                                    .aib39              (io_aib39),      
                                    .aib40              (io_aib40),      
                                    .aib41              (io_aib41),      
                                    .aib42              (io_aib42),      
                                    .aib43              (io_aib43),      
                                    .aib44              (io_aib44),      
                                    .aib45              (io_aib45), 
                                    .aib46              (io_aib46), 
                                    .aib47              (io_aib47), 
                                    .aib48              (io_aib48), 
                                    .aib49              (io_aib49),      
                                    .aib50              (io_aib50),      
                                    .aib51              (io_aib51),      
                                    .aib52              (io_aib52),      
                                    .aib53              (io_aib53),      
                                    .aib54              (io_aib54),      
                                    .aib55              (io_aib55), 
                                    .aib56              (io_aib56),      
                                    .aib57              (io_aib57),      
                                    .aib58              (io_aib58), 
                                    .aib59              (io_aib59),      
                                    .aib60              (io_aib60),      
                                    .aib61              (io_aib61), 
                                    .aib62              (io_aib62), 
                                    .aib63              (io_aib63), 
                                    .aib64              (io_aib64), 
                                    .aib65              (io_aib65),      
                                    .aib66              (io_aib66),      
                                    .aib67              (io_aib67), 
                                    .aib68              (io_aib68), 
                                    .aib69              (io_aib69), 
                                    .aib70              (io_aib70),      
                                    .aib71              (io_aib71),      
                                    .aib72              (io_aib72), 
                                    .aib73              (io_aib73), 
                                    .aib74              (io_aib74), 
                                    .aib75              (io_aib75),      
                                    .aib76              (io_aib76),      
                                    .aib77              (io_aib77),      
                                    .aib78              (io_aib78), 
                                    .aib79              (io_aib79), 
                                    .aib80              (io_aib80), 
                                    .aib81              (io_aib81), 
                                    .aib82              (io_aib82),      
                                    .aib83              (io_aib83),      
                                    .aib84              (io_aib84),      
                                    .aib85              (io_aib85),      
                                    .aib86              (io_aib86),      
                                    .aib87              (io_aib87),      
                                    .aib88              (io_aib88), 
                                    .aib89              (io_aib89), 
                                    .aib90              (io_aib90),      
                                    .aib91              (io_aib91),      
                                    .aib92              (io_aib92),      
                                    .aib93              (io_aib93),      
                                    .aib94              (io_aib94),      
                                    .aib95              (io_aib95),      
                                    // Inputs
                                    .iatpg_bsr0_scan_in (1'b0), 
                                    .iatpg_bsr0_scan_shift_clk(1'b0), 
                                    .iatpg_bsr1_scan_in (1'b0), 
                                    .iatpg_bsr1_scan_shift_clk(1'b0), 
                                    .iatpg_bsr2_scan_in (1'b0), 
                                    .iatpg_bsr2_scan_shift_clk(1'b0), 
                                    .iatpg_bsr3_scan_in (1'b0), 
                                    .iatpg_bsr3_scan_shift_clk(1'b0), 
                                    .iatpg_bsr_scan_shift_n(1'b1), 
                                    .iatpg_pipeline_global_en(1'b0), 
                                    .iatpg_scan_clk_in0 (1'b0), 
                                    .iatpg_scan_clk_in1 (1'b0), 
                                    .iatpg_scan_in0     (1'b0), 
                                    .iatpg_scan_in1     (1'b0), 
                                    .iatpg_scan_mode_n  (1'b1), 
                                    .iatpg_scan_rst_n   (1'b1),  
                                    .iatpg_scan_shift_n (1'b1), 
                                    .ihssi_dcc_req      (tx_dcc_cal_req),  
                                    .ihssi_pld_pma_clkdiv_rx_user(ns_mac_rdyo),  
                                    .ihssi_pld_pma_clkdiv_tx_user(ns_adapter_rstno),  
                                    .ihssi_pma_aib_tx_clk(ns_rcv_clk),
                                    .ihssi_rx_transfer_clk(ns_fwd_clk),
                                    .ihssi_sr_clk_out   (sr_clk_out),  
                                    .ihssi_ssr_data_out (std_out),  
                                    .ihssi_ssr_load_out (stl_out),  
                                    .ihssi_tx_dcd_cal_req(rx_dll_lock_req), //dummy, goes to ssr user define bit in the aib spec
                                    .ihssi_tx_dll_lock_req(rx_dll_lock_req), 
                                    .ijtag_clkdr_in_chain(i_jtag_clkdr_in), 
                                    .ijtag_last_bs_in_chain(i_jtag_last_bs_chain_in), 
                                    .ijtag_tx_scan_in_chain(i_jtag_bs_chain_in), 
                                    .irstb              (conf_done_o), 
                                    .jtag_clksel        (i_jtag_clksel_in), 
                                    .jtag_intest        (i_jtag_intest_in), 
                                    .jtag_mode_in       (i_jtag_mode_in), 
                                    .jtag_rstb          (i_jtag_rstb_in), 
                                    .jtag_rstb_en       (i_jtag_rstb_en_in), 
                                    .jtag_tx_scanen_in  (i_jtag_bs_scanen_in), 
                                    .jtag_weakpdn       (i_jtag_weakpdn_in), 
                                    .jtag_weakpu        (i_jtag_weakpu_in), 
                                    .osc_clkin          (i_osc_clk), 
                                    .por_aib_vcchssi    (i_por_aib_vcchssi), 
                                    .por_aib_vccl       (i_por_aib_vccl), 
                                    .r_aib_csr_ctrl_42  (aib_csr_ctrl_42[7:0]), 
                            //      .iaibdftdll2adjch   (i_aibdftdll2adjch),
                                    .iaibdftdll2adjch   (13'h0),
                                    .r_aib_csr_ctrl_40  (aib_csr_ctrl_40[7:0]), 
                                    .r_aib_csr_ctrl_36  (aib_csr_ctrl_36[7:0]), 
                                    .r_aib_csr_ctrl_43  (aib_csr_ctrl_43[7:0]), 
                                    .r_aib_csr_ctrl_52  (aib_csr_ctrl_52[7:0]), 
                                    .r_aib_csr_ctrl_49  (aib_csr_ctrl_49[7:0]), 
                                    .r_aib_csr_ctrl_45  (aib_csr_ctrl_45[7:0]), 
                                    .r_aib_csr_ctrl_48  (aib_csr_ctrl_48[7:0]), 
                                    .r_aib_csr_ctrl_44  (aib_csr_ctrl_44[7:0]), 
                                    .r_aib_csr_ctrl_47  (aib_csr_ctrl_47[7:0]), 
                                    .ihssi_rx_data_out  (dout[39:0]), 
                                    .r_aib_csr_ctrl_34  (aib_csr_ctrl_34[7:0]), 
                                    .r_aib_csr_ctrl_35  (aib_csr_ctrl_35[7:0]), 
                                    .r_aib_dprio_ctrl_4 (aib_dprio_ctrl_4[7:0]), 
                                    .iaibdftcore2dll    (aibdftcore2dll[1:0]), 
                                    .r_aib_dprio_ctrl_1 (aib_dprio_ctrl_1[7:0]), 
                                    .r_aib_dprio_ctrl_0 (aib_dprio_ctrl_0[7:0]), 
                                    .r_aib_csr_ctrl_20  (aib_csr_ctrl_20[7:0]), 
                                    .r_aib_csr_ctrl_19  (aib_csr_ctrl_19[7:0]), 
                                    .r_aib_csr_ctrl_50  (aib_csr_ctrl_50[7:0]), 
                                    .r_aib_csr_ctrl_53  (aib_csr_ctrl_53[7:0]), 
                                    .r_aib_csr_ctrl_13  (aib_csr_ctrl_13[7:0]), 
                                    .r_aib_csr_ctrl_17  (aib_csr_ctrl_17[7:0]), 
                                    .r_aib_csr_ctrl_23  (aib_csr_ctrl_23[7:0]), 
                                    .r_aib_csr_ctrl_12  (aib_csr_ctrl_12[7:0]), 
                                    .r_aib_csr_ctrl_26  (aib_csr_ctrl_26[7:0]), 
                                    .r_aib_dprio_ctrl_2 (aib_dprio_ctrl_2[7:0]), 
                                    .r_aib_csr_ctrl_29  (aib_csr_ctrl_29[7:0]), 
                                    .r_aib_csr_ctrl_30  (aib_csr_ctrl_30[7:0]), 
                                    .r_aib_csr_ctrl_24  (aib_csr_ctrl_24[7:0]), 
                                    .r_aib_csr_ctrl_46  (aib_csr_ctrl_46[7:0]), 
                                    .r_aib_csr_ctrl_39  (aib_csr_ctrl_39[7:0]), 
                                    .r_aib_csr_ctrl_37  (aib_csr_ctrl_37[7:0]), 
                                    .r_aib_csr_ctrl_38  (aib_csr_ctrl_38[7:0]), 
                                    .r_aib_csr_ctrl_31  (aib_csr_ctrl_31[7:0]), 
                                    .r_aib_csr_ctrl_18  (aib_csr_ctrl_18[7:0]), 
                                    .r_aib_dprio_ctrl_3 (aib_dprio_ctrl_3[7:0]), 
                                    .r_aib_csr_ctrl_27  (aib_csr_ctrl_27[7:0]), 
                                    .r_aib_csr_ctrl_41  (aib_csr_ctrl_41[7:0]), 
                                    .r_aib_csr_ctrl_22  (aib_csr_ctrl_22[7:0]), 
                                    .r_aib_csr_ctrl_51  (aib_csr_ctrl_51[7:0]), 
                                    .r_aib_csr_ctrl_33  (aib_csr_ctrl_33[7:0]), 
                                    .r_aib_csr_ctrl_32  (aib_csr_ctrl_32[7:0]), 
                                    .r_aib_csr_ctrl_28  (aib_csr_ctrl_28[7:0]), 
                                    .r_aib_csr_ctrl_21  (aib_csr_ctrl_21[7:0]), 
                                    .r_aib_csr_ctrl_16  (aib_csr_ctrl_16[7:0]), 
                                    .r_aib_csr_ctrl_15  (aib_csr_ctrl_15[7:0]), 
                                    .r_aib_csr_ctrl_14  (aib_csr_ctrl_14[7:0]), 
                                    .r_aib_csr_ctrl_11  (aib_csr_ctrl_11[7:0]), 
                                    .r_aib_csr_ctrl_10  (aib_csr_ctrl_10[7:0]), 
                                    .r_aib_csr_ctrl_9   (aib_csr_ctrl_9[7:0]), 
                                    .r_aib_csr_ctrl_8   (aib_csr_ctrl_8[7:0]), 
                                    .r_aib_csr_ctrl_7   (aib_csr_ctrl_7[7:0]), 
                                    .r_aib_csr_ctrl_6   (aib_csr_ctrl_6[7:0]), 
                                    .r_aib_csr_ctrl_5   (aib_csr_ctrl_5[7:0]), 
                                    .r_aib_csr_ctrl_4   (aib_csr_ctrl_4[7:0]), 
                                    .r_aib_csr_ctrl_3   (aib_csr_ctrl_3[7:0]), 
                                    .r_aib_csr_ctrl_2   (aib_csr_ctrl_2[7:0]), 
                                    .r_aib_csr_ctrl_1   (aib_csr_ctrl_1[7:0]), 
                                    .r_aib_csr_ctrl_0   (aib_csr_ctrl_0[7:0]), 
                                    .r_aib_csr_ctrl_25  (aib_csr_ctrl_25[7:0])); 

endmodule

