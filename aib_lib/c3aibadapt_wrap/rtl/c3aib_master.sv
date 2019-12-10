// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// Mapping file to map single channel opensource IP IO ports to AIB specification 1.1

`timescale 1ps/1fs

module c3aib_master (
 //================================================================================================
 // Reset Inteface
    input                                      i_adpt_hard_rst_n, // AIB adaptor hard reset
    output                                     o_adpt_hard_rst_n, // connected with i_adpt_hard_rst_n and used to pass through to channel n+1 for PnR purpose

 // reset for XCVRIF
    output                                     fs_mac_rdy,    //o_rx_xcvrif_rst_n,  receiving path reset, 
    output                                     o_tx_xcvrif_rst_n, // chiplet xcvr transmitting path reset, the reset is controlled by remote chiplet which is FPGA

 //===============================================================================================
    output                                     ms_osc_transfer_alive,   //o_ehip_init_status[2]
    output                                     ms_tx_transfer_en,   //o_ehip_init_status[1]
    output                                     sl_tx_transfer_en,   //o_ehip_init_status[0]

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
    input                                      m_ns_fwd_clk, // i_rx_pma_clk.Rx path clk for data receiving,
    input                                      m_ns_fwd_div2_clk, // i_rx_pma_div2_clk, Divided by 2 clock on Rx pathinput

    input                                      i_osc_clk, // Oscillator clock generated from AIB AUX
    input [64:0]                               i_chnl_ssr, // Slow shift chain path
    input [39:0]                               data_in ,   // i_rx_pma_data, Directed bump rx data sync path

 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
    input                                      m_ns_rcv_clk, //i_tx_pma_clk, sent over to the other chiplet to be used for the clock
                                                                    // as the data transmission
    output                                     o_osc_clk, // this is the clock used for shift register path
    output [60:0]                              o_chnl_ssr, // Slow shift chain path
    output                                     m_fs_fwd_clk, //o_tx_transfer_clk, clock used for tx data transmission
    output                                     m_fs_fwd_div2_clk, // o_tx_transfer_div2_clk, half rate of tx data transmission clock
    output [39:0]                              data_out, //o_tx_pma_data, Directed bump tx data sync path

 //=================================================================================================
 //AIB open source IP enhancement. The following ports are added to b compliance with AIB specification 1.1
    input                                      ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive data. use aibio49
    input                                      ns_adapt_rstn, //From Mac. To reset near site adapt reset state machine and far site sm. Not implemented currently.
                                                              //Use aibio56

    output [80:0]                              ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
    output [72:0]                              sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet.    
 //=================================================================================================
 //// EMIB, AIB IO bumps

    inout  [19:0]                              iopad_tx,
    inout  [19:0]                              iopad_rx,
    inout                                      iopad_ns_fwd_clkb,
    inout                                      iopad_ns_fwd_clk,
    inout                                      iopad_ns_fwd_div2_clkb,
    inout                                      iopad_ns_fwd_div2_clk,
    inout                                      iopad_fs_fwd_clkb,
    inout                                      iopad_fs_fwd_clk,
    inout                                      iopad_fs_mac_rdy,
    inout                                      iopad_ns_mac_rdy,
    inout                                      iopad_ns_adapter_rstn,
    inout                                      iopad_fs_rcv_clk,
    inout                                      iopad_fs_rcv_clkb,
    inout                                      iopad_fs_adapter_rstn,
    inout                                      iopad_fs_sr_clkb,
    inout                                      iopad_fs_sr_clk,
    inout                                      iopad_ns_sr_clk,
    inout                                      iopad_ns_sr_clkb,
    inout                                      iopad_ns_rcv_clkb,
    inout                                      iopad_ns_rcv_clk,
    inout                                      iopad_ns_rcv_div2_clkb,
    inout                                      iopad_ns_rcv_div2_clk,
    inout                                      iopad_fs_sr_load,
    inout                                      iopad_fs_sr_data,
    inout                                      iopad_ns_sr_load,
    inout                                      iopad_ns_sr_data,
    inout                                      iopad_unused_aib45,
    inout                                      iopad_unused_aib46,
    inout                                      iopad_unused_aib47,
    inout                                      iopad_unused_aib50,
    inout                                      iopad_unused_aib51,
    inout                                      iopad_unused_aib52,
    inout                                      iopad_unused_aib58,
    inout                                      iopad_unused_aib60,
    inout                                      iopad_unused_aib61,
    inout                                      iopad_unused_aib62,
    inout                                      iopad_unused_aib63,
    inout                                      iopad_unused_aib64,
    inout                                      iopad_unused_aib66,
    inout                                      iopad_unused_aib67,
    inout                                      iopad_unused_aib68,
    inout                                      iopad_unused_aib69,
    inout                                      iopad_unused_aib70,
    inout                                      iopad_unused_aib71,
    inout                                      iopad_unused_aib72,
    inout                                      iopad_unused_aib73,
    inout                                      iopad_unused_aib74,
    inout                                      iopad_unused_aib75,
    inout                                      iopad_unused_aib76,
    inout                                      iopad_unused_aib77,
    inout                                      iopad_unused_aib78,
    inout                                      iopad_unused_aib79,
    inout                                      iopad_unused_aib80,
    inout                                      iopad_unused_aib81,
    inout                                      iopad_unused_aib88,
    inout                                      iopad_unused_aib89,
    inout                                      iopad_unused_aib90,
    inout                                      iopad_unused_aib91,

  //================================================================================================
  // DFT related interface
  // DFT CLK  All go to c3dfx_aibadaptwrap_tcb.
  // the below four clock is from one common source.  JZ 03/28/2018,
  // so comment out three of them, and tie all to i_scan_clk JS 03/28/18
    input                                      i_scan_clk, // Four scan clock from common test pin for scan shifting

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
    
wire [2:0]  o_ehip_init_status;
wire        i_rx_pma_clk;
wire        i_rx_pma_div2_clk;
wire [39:0] i_rx_pma_data;
wire        i_tx_pma_clk;
wire        o_tx_transfer_clk;
wire        o_tx_transfer_div2_clk;
wire [39:0] o_tx_pma_data;
wire        o_rx_xcvrif_rst_n;
wire        HI, LO;
assign      HI = 1'b1;
assign      LO = 1'b0;

assign {ms_osc_transfer_alive, ms_tx_transfer_en, sl_tx_transfer_en} = o_ehip_init_status[2:0];
assign  i_rx_pma_clk = m_ns_fwd_clk;
assign  i_rx_pma_div2_clk = m_ns_fwd_div2_clk;
assign  i_rx_pma_data = data_in;
assign  i_tx_pma_clk = m_ns_rcv_clk;
assign  m_fs_fwd_clk = o_tx_transfer_clk;
assign  m_fs_fwd_div2_clk = o_tx_transfer_div2_clk;
assign  data_out =  o_tx_pma_data;
assign  fs_mac_rdy = o_rx_xcvrif_rst_n;

    c3aibadapt_wrap u_c3aibadapt_wrap (/*AUTOINST*/
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
                         .ns_mac_rdy            (ns_mac_rdy),
                         .ns_adapt_rstn         (ns_adapt_rstn),
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
                         .io_aib0               (iopad_tx[0]),
                         .io_aib1               (iopad_tx[1]),
                         .io_aib10              (iopad_tx[10]),
                         .io_aib11              (iopad_tx[11]),
                         .io_aib12              (iopad_tx[12]),
                         .io_aib13              (iopad_tx[13]),
                         .io_aib14              (iopad_tx[14]),
                         .io_aib15              (iopad_tx[15]),
                         .io_aib16              (iopad_tx[16]),
                         .io_aib17              (iopad_tx[17]),
                         .io_aib18              (iopad_tx[18]),
                         .io_aib19              (iopad_tx[19]),
                         .io_aib2               (iopad_tx[2]),
                         .io_aib20              (iopad_rx[0]),
                         .io_aib21              (iopad_rx[1]),
                         .io_aib22              (iopad_rx[2]),
                         .io_aib23              (iopad_rx[3]),
                         .io_aib24              (iopad_rx[4]),
                         .io_aib25              (iopad_rx[5]),
                         .io_aib26              (iopad_rx[6]),
                         .io_aib27              (iopad_rx[7]),
                         .io_aib28              (iopad_rx[8]),
                         .io_aib29              (iopad_rx[9]),
                         .io_aib3               (iopad_tx[3]),
                         .io_aib30              (iopad_rx[10]),
                         .io_aib31              (iopad_rx[11]),
                         .io_aib32              (iopad_rx[12]),
                         .io_aib33              (iopad_rx[13]),
                         .io_aib34              (iopad_rx[14]),
                         .io_aib35              (iopad_rx[15]),
                         .io_aib36              (iopad_rx[16]),
                         .io_aib37              (iopad_rx[17]),
                         .io_aib38              (iopad_rx[18]),
                         .io_aib39              (iopad_rx[19]),
                         .io_aib4               (iopad_tx[4]),
                         .io_aib40              (iopad_ns_fwd_clkb),
                         .io_aib41              (iopad_ns_fwd_clk),
                         .io_aib42              (iopad_fs_fwd_clkb),
                         .io_aib43              (iopad_fs_fwd_clk),
                         .io_aib44              (iopad_fs_mac_rdy),
                         .io_aib45              (iopad_unused_aib45),
                       //.io_aib45              (HI), //From Tim's 3/26 aib_bump_map
                         .io_aib46              (iopad_unused_aib46),
                         .io_aib47              (iopad_unused_aib47),
                         .io_aib48              (iopad_ns_rcv_div2_clk),
                         .io_aib49              (iopad_ns_mac_rdy),
                         .io_aib5               (iopad_tx[5]),
                         .io_aib50              (iopad_unused_aib50),
                         .io_aib51              (iopad_unused_aib51),
                         .io_aib52              (iopad_unused_aib52),
                         .io_aib53              (iopad_ns_fwd_div2_clk),
                         .io_aib54              (iopad_ns_fwd_div2_clkb),
                         .io_aib55              (iopad_ns_rcv_div2_clkb),
                         .io_aib56              (iopad_ns_adapter_rstn),
                         .io_aib57              (iopad_fs_rcv_clk),
                         .io_aib58              (iopad_unused_aib58),
                       //.io_aib58              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib59              (iopad_fs_rcv_clkb),
                         .io_aib6               (iopad_tx[6]),
                         .io_aib60              (iopad_unused_aib60),
                         .io_aib61              (iopad_unused_aib61),
                       //.io_aib61              (HI), //From Tim's 3/26 aib_bump_map
                         .io_aib62              (iopad_unused_aib62),
                         .io_aib63              (iopad_unused_aib63),
                       //.io_aib63              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib64              (iopad_unused_aib64),
                       //.io_aib64              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib65              (iopad_fs_adapter_rstn),
                         .io_aib66              (iopad_unused_aib66),
                         .io_aib67              (iopad_unused_aib67),
                       //.io_aib67              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib68              (iopad_unused_aib68),
                         .io_aib69              (iopad_unused_aib69),
                         .io_aib7               (iopad_tx[7]),
                         .io_aib70              (iopad_unused_aib70),
                         .io_aib71              (iopad_unused_aib71),
                         .io_aib72              (iopad_unused_aib72),
                         .io_aib73              (iopad_unused_aib73),
                         .io_aib74              (iopad_unused_aib74),
                       //.io_aib72              (LO), //From Tim's 3/26 aib_bump_map
                       //.io_aib73              (LO), //From Tim's 3/26 aib_bump_map
                       //.io_aib74              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib75              (iopad_unused_aib75),
                         .io_aib76              (iopad_unused_aib76),
                         .io_aib77              (iopad_unused_aib77),
                         .io_aib78              (iopad_unused_aib78),
                         .io_aib79              (iopad_unused_aib79),
                         .io_aib80              (iopad_unused_aib80),
                         .io_aib81              (iopad_unused_aib81),
                       //.io_aib78              (LO), //From Tim's 3/26 aib_bump_map
                       //.io_aib79              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib8               (iopad_tx[8]),
                       //.io_aib80              (LO), //From Tim's 3/26 aib_bump_map
                       //.io_aib81              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib82              (iopad_fs_sr_clkb),
                         .io_aib83              (iopad_fs_sr_clk),
                         .io_aib84              (iopad_ns_sr_clkb),
                         .io_aib85              (iopad_ns_sr_clk),
                         .io_aib86              (iopad_ns_rcv_clkb),
                         .io_aib87              (iopad_ns_rcv_clk),
                         .io_aib88              (iopad_unused_aib88),
                         .io_aib89              (iopad_unused_aib89),
                       //.io_aib88              (LO), //From Tim's 3/26 aib_bump_map
                       //.io_aib89              (LO), //From Tim's 3/26 aib_bump_map
                         .io_aib9               (iopad_tx[9]),
                         .io_aib90              (iopad_unused_aib90),
                         .io_aib91              (iopad_unused_aib91),
                         .io_aib92              (iopad_fs_sr_load),
                         .io_aib93              (iopad_fs_sr_data),
                         .io_aib94              (iopad_ns_sr_load),
                         .io_aib95              (iopad_ns_sr_data),
                         // Inputs
                         .i_adpt_hard_rst_n     (i_adpt_hard_rst_n),
                         .i_channel_id          (i_channel_id[5:0]),
                         .i_cfg_avmm_clk        (i_cfg_avmm_clk),
                         .i_cfg_avmm_rst_n      (i_cfg_avmm_rst_n),
                         .i_cfg_avmm_addr       (i_cfg_avmm_addr[16:0]),
                         .i_cfg_avmm_byte_en    (i_cfg_avmm_byte_en[3:0]),
                         .i_cfg_avmm_read       (i_cfg_avmm_read),
                         .i_cfg_avmm_write      (i_cfg_avmm_write),
                         .i_cfg_avmm_wdata      (i_cfg_avmm_wdata[31:0]),
                         .i_adpt_cfg_rdatavld   (i_adpt_cfg_rdatavld),
                         .i_adpt_cfg_rdata      (i_adpt_cfg_rdata[31:0]),
//                       .i_adpt_cfg_waitreq    (i_adpt_cfg_waitreq),
                         .i_adpt_cfg_waitreq    (HI),
                         .i_rx_pma_clk          (i_rx_pma_clk),
                         .i_rx_pma_div2_clk     (i_rx_pma_div2_clk),
                         .i_osc_clk             (i_osc_clk),
                         .i_chnl_ssr            (i_chnl_ssr[64:0]),
                         .i_rx_pma_data         (i_rx_pma_data[39:0]),
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
                         .i_aibdftdll2adjch     (i_aibdftdll2adjch));

endmodule 
