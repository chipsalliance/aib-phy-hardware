// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright @ 2018 Intel Corporation. . 
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description: Top level AIB wrapper includes 24 channel AIB + AIB AUX
//
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//
//
//
//
//-----------------------------------------------------------------------------

module aib_top
  # (
     parameter TOTAL_CHNL_NUM = 24
     )
  (
     //================================================================================================
   // Reset Inteface
   input                                                          i_adpt_hard_rst_n, // AIB adaptor hard reset

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
    
   input [TOTAL_CHNL_NUM*65-1:0]                                  i_chnl_ssr, // Slow shift chain path, tie to 0s if not used
   input [TOTAL_CHNL_NUM*40-1:0]                                  i_rx_pma_data, // Directed bump rx data sync path
 
 // Tx Path clocks/data, from slave (FPGA) to master (current chiplet)
   input [TOTAL_CHNL_NUM-1:0]                                     i_tx_pma_clk, // this clock is sent over to the other chiplet to be used for the clock as the data transmission
   output [TOTAL_CHNL_NUM*61-1:0]                                 o_chnl_ssr, // Slow shift chain path, left unconnected if not used
   output [TOTAL_CHNL_NUM-1:0]                                    o_tx_transfer_clk, // clock used for tx data transmission
   output [TOTAL_CHNL_NUM-1:0]                                    o_tx_transfer_div2_clk, // half rate of tx data transmission clock
   output [TOTAL_CHNL_NUM*40-1:0]                                 o_tx_pma_data, // Directed bump tx data sync path
 //=================================================================================================
 // AIB open source IP enhancement. The following ports are added to
 // be compliance with AIB specification 1.1
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_mac_rdy,  //From Mac. To indicate MAC is ready to send and receive //     data. use aibio49
   input  [TOTAL_CHNL_NUM-1:0]                                    ns_adapt_rstn, //From Mac. To reset near site adapt reset state machine and far site sm. Not implemented currently.

   output [TOTAL_CHNL_NUM*81-1:0]                                 ms_sideband, //Status of serial shifting bit from this master chiplet to slave chiplet
   output [TOTAL_CHNL_NUM*73-1:0]                                 sl_sideband, //Status of serial shifting bit from slave chiplet to master chiplet.
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
   inout [95:0]                                                   io_aib_aux,
   
   inout                                                          io_aux_bg_ext_2k, //connect to external 2k resistor, C4 bump

   //======================================================================================
   // Interface with AIB control block
   // reset for AIB AUX
   input                                                          i_iocsr_rdy_aibaux, //same hard reset as in the channel, tie to chiplet config_done signal

   input                                                          i_aibaux_por_vccl_ovrd, //test por override through c4 bump
   
   // from control block register file
   input [31:0]                                                   i_aibaux_ctrl_bus0, //1st set of register bits from register file
   input [31:0]                                                   i_aibaux_ctrl_bus1, //2nd set of register bits from register file
   input [31:0]                                                   i_aibaux_ctrl_bus2, //3rd set of register bits from register file
   input [9:0]                                                    i_aibaux_osc_fuse_trim, //control by Fuse/OTP from User

   //
   input                                                          i_osc_bypclk,     // test clock from c4 bump, may tie low for User if not used
   output                                                         o_aibaux_osc_clk, // osc clk output to test C4 bump to characterize the oscillator, User may use this clock to connect with i_test_clk_1g
    //======================================================================================
   // DFT signals
   input                                                          i_scan_clk,     //ATPG Scan shifting clock from Test Pad.  
   input                                                          i_test_clk_1g,  //1GHz free running direct accessed ATPG at speed clock.
   input                                                          i_test_clk_125m,//Divided down from i_test_clk_1g. 
   input                                                          i_test_clk_250m,//Divided down from i_test_clk_1g.
   input                                                          i_test_clk_500m,//Divided down from i_test_clk_1g.
   input                                                          i_test_clk_62m, //Divided down from i_test_clk_1g.
                                                                                  //The divided down clock is for different clock domain at
                                                                                  //speed test.
   //Channel ATPG signals from/to CODEC
   input [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]  i_test_c3adapt_scan_in, //scan in hook from Codec 
   input [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]                     i_test_c3adapt_tcb_static_common, //TCM Controls for ATPG scan test. 
                                                                                                    //Scan enable/reset dll/dcc control 
   output [TOTAL_CHNL_NUM-1:0] [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] o_test_c3adapt_scan_out, //scan out hook to Codec
  
   //Inputs from TCB (JTAG signals)
   input                                                          i_jtag_clkdr, // (from dbg_test_bscan block)Enable AIB IO boundary scan clock (clock gate control)
   input                                                          i_jtag_clksel, // (from dbg_test_bscan block)Select between i_jtag_clkdr_in and functional clk
   input                                                          i_jtag_intest, // (from dbg_test_bscan block)Enable in test operation
   input                                                          i_jtag_mode, // (from dbg_test_bscan block)Selects between AIB BSR register or functional path
   input                                                          i_jtag_rstb, // (from dbg_test_bscan block)JTAG controlleable reset the AIB IO circuitry
   input                                                          i_jtag_rstb_en, // (from dbg_test_bscan block)JTAG controlleable override to reset the AIB IO circuitry
   input                                                          i_jtag_tx_scan, // (from dbg_test_bscan block)TDI
   input                                                          i_jtag_tx_scanen,// (from dbg_test_bscan block)Drives AIB IO jtag_tx_scanen_in or BSR shift control  
   input                                                          i_jtag_weakpdn,  //(from dbg_test_bscan block)Enable AIB global pull down test. 
   input                                                          i_jtag_weakpu,  //(from dbg_test_bscan block)Enable AIB global pull up test. 

   input [2:0]                                                    i_aibdft2osc,  //To AIB osc.[2] force reset [1] force enable [0] 33 MHz JTAG
   output [12:0]                                                  o_aibdft2osc,  //Observability of osc and DLL/DCC status 
                                                                                 //this signal go through C4 bump, User may muxed it out with their test signals
   
   //output TCB 
   output                                                         o_last_bs_out, //last boundary scan chain output, TDO 

   output                                                         o_por, // S10 POR to User, can be left unconnected for User
   output                                                         o_osc_monitor, //Output from oscillator, go to pinmux block before go to C4 test bump


   //AUX channel ATPG signals                                     //AUX has seperate scan chain. The TCM is outside of the aib_top.
   input                                                          i_aux_atpg_mode_n,   //ATPG scan mode 
   input                                                          i_aux_atpg_pipeline_global_en,  //scan_loes_mode
   input                                                          i_aux_atpg_rst_n,               //~scan_reset
   input                                                          i_aux_atpg_scan_clk,            //This is the output of TCM outside of aib_top.
   input                                                          i_aux_atpg_scan_in,             //scan chain in  
   input                                                          i_aux_atpg_scan_shift_n,        //~scan_enable
   output                                                         o_aux_atpg_scan_out             //scan chain out 
  
   );

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire                aibaux_jtag_bs_chain_out;// From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_bs_scanen_out;// From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_clkdr_out;  // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_clksel_out; // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_intest_out; // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_mode_out;   // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_rstb_en_out;// From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_rstb_out;   // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_weakpdn_out;// From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_jtag_weakpu_out; // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_last_bs_in;      // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                aibaux_osc_clk;         // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_por_vcchssi;     // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire                aibaux_por_vccl;        // From u_aibcr3aux_top_wrp of aibcr3aux_top_wrp.v
    wire [12:0]         o_aibdftdll2adjch;      // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                o_directout_data_chain1_out;// From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                o_directout_data_chain2_out;// From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                o_txen_out_chain1;      // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                o_txen_out_chain2;      // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                red_idataselb_in_chain1;// From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                red_idataselb_in_chain2;// From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                red_shift_en_in_chain1; // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    wire                red_shift_en_in_chain2; // From u_c3aibadapt_wrap_top of c3aibadapt_wrap_top.v
    // End of automatics

    /*
     c3aibadapt_wrap_top AUTO_TEMPLATE (
     .i_jtag_\(.*\)_in  (aibaux_jtag_\1_out[]),
     .o_jtag_last_bs_chain_out(aibaux_last_bs_in[]),
     .i_por_aib_\(.*\)  (aibaux_por_\1[]),
     .o_red_\(.*\)_out_\(.*\) (red_\1_in_\2[]),
     .i_osc_clk (aibaux_osc_clk),
     .o_test_c3adapttcb_jtag (), //no need to bring this one out
     .o_osc_clk (), //o_chnl_ssr is async path, no need to output this clock, it's internal use
     );
     */
    
    c3aibadapt_wrap_top u_c3aibadapt_wrap_top
      (/*AUTOINST*/
       // Outputs
       .o_rx_xcvrif_rst_n               (o_rx_xcvrif_rst_n[TOTAL_CHNL_NUM-1:0]),
       .o_cfg_avmm_rdatavld             (o_cfg_avmm_rdatavld),
       .o_cfg_avmm_rdata                (o_cfg_avmm_rdata[31:0]),
       .o_cfg_avmm_waitreq              (o_cfg_avmm_waitreq),
       .o_osc_clk                       (),                      // Templated
       .o_chnl_ssr                      (o_chnl_ssr[TOTAL_CHNL_NUM*61-1:0]),
       .o_tx_transfer_clk               (o_tx_transfer_clk[TOTAL_CHNL_NUM-1:0]),
       .o_tx_transfer_div2_clk          (o_tx_transfer_div2_clk[TOTAL_CHNL_NUM-1:0]),
       .o_tx_pma_data                   (o_tx_pma_data[TOTAL_CHNL_NUM*40-1:0]),
       .ns_mac_rdy                      (ns_mac_rdy[TOTAL_CHNL_NUM-1:0]),
       .ns_adapt_rstn                   (ns_adapt_rstn[TOTAL_CHNL_NUM-1:0]),
       .ms_sideband                     (ms_sideband[TOTAL_CHNL_NUM*81-1:0]),
       .sl_sideband                     (sl_sideband[TOTAL_CHNL_NUM*73-1:0]),
       .o_test_c3adapt_scan_out         (o_test_c3adapt_scan_out/*[TOTAL_CHNL_NUM-1:0][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]*/),
       .o_test_c3adapttcb_jtag          (),                      // Templated
       .o_jtag_last_bs_chain_out        (aibaux_last_bs_in),     // Templated
       .o_red_idataselb_out_chain1      (red_idataselb_in_chain1), // Templated
       .o_red_idataselb_out_chain2      (red_idataselb_in_chain2), // Templated
       .o_red_shift_en_out_chain1       (red_shift_en_in_chain1), // Templated
       .o_red_shift_en_out_chain2       (red_shift_en_in_chain2), // Templated
       .o_txen_out_chain1               (o_txen_out_chain1),
       .o_txen_out_chain2               (o_txen_out_chain2),
       .o_directout_data_chain1_out     (o_directout_data_chain1_out),
       .o_directout_data_chain2_out     (o_directout_data_chain2_out),
       .o_aibdftdll2adjch               (o_aibdftdll2adjch[12:0]),
       // Inouts
       .io_aib_ch0                      (io_aib_ch0[95:0]),
       .io_aib_ch1                      (io_aib_ch1[95:0]),
       .io_aib_ch2                      (io_aib_ch2[95:0]),
       .io_aib_ch3                      (io_aib_ch3[95:0]),
       .io_aib_ch4                      (io_aib_ch4[95:0]),
       .io_aib_ch5                      (io_aib_ch5[95:0]),
       .io_aib_ch6                      (io_aib_ch6[95:0]),
       .io_aib_ch7                      (io_aib_ch7[95:0]),
       .io_aib_ch8                      (io_aib_ch8[95:0]),
       .io_aib_ch9                      (io_aib_ch9[95:0]),
       .io_aib_ch10                     (io_aib_ch10[95:0]),
       .io_aib_ch11                     (io_aib_ch11[95:0]),
       .io_aib_ch12                     (io_aib_ch12[95:0]),
       .io_aib_ch13                     (io_aib_ch13[95:0]),
       .io_aib_ch14                     (io_aib_ch14[95:0]),
       .io_aib_ch15                     (io_aib_ch15[95:0]),
       .io_aib_ch16                     (io_aib_ch16[95:0]),
       .io_aib_ch17                     (io_aib_ch17[95:0]),
       .io_aib_ch18                     (io_aib_ch18[95:0]),
       .io_aib_ch19                     (io_aib_ch19[95:0]),
       .io_aib_ch20                     (io_aib_ch20[95:0]),
       .io_aib_ch21                     (io_aib_ch21[95:0]),
       .io_aib_ch22                     (io_aib_ch22[95:0]),
       .io_aib_ch23                     (io_aib_ch23[95:0]),
       // Inputs
       .i_adpt_hard_rst_n               (i_adpt_hard_rst_n),
       .i_cfg_avmm_clk                  (i_cfg_avmm_clk),
       .i_cfg_avmm_rst_n                (i_cfg_avmm_rst_n),
       .i_cfg_avmm_addr                 (i_cfg_avmm_addr[16:0]),
       .i_cfg_avmm_byte_en              (i_cfg_avmm_byte_en[3:0]),
       .i_cfg_avmm_read                 (i_cfg_avmm_read),
       .i_cfg_avmm_write                (i_cfg_avmm_write),
       .i_cfg_avmm_wdata                (i_cfg_avmm_wdata[31:0]),
       .i_rx_pma_clk                    (i_rx_pma_clk[TOTAL_CHNL_NUM-1:0]),
       .i_rx_pma_div2_clk               (i_rx_pma_div2_clk[TOTAL_CHNL_NUM-1:0]),
       .i_osc_clk                       (aibaux_osc_clk),        // Templated
       .i_chnl_ssr                      (i_chnl_ssr[TOTAL_CHNL_NUM*65-1:0]),
       .i_rx_pma_data                   (i_rx_pma_data[TOTAL_CHNL_NUM*40-1:0]),
       .i_tx_pma_clk                    (i_tx_pma_clk[TOTAL_CHNL_NUM-1:0]),
       .i_scan_clk                      (i_scan_clk),
       .i_test_clk_125m                 (i_test_clk_125m),
       .i_test_clk_1g                   (i_test_clk_1g),
       .i_test_clk_250m                 (i_test_clk_250m),
       .i_test_clk_500m                 (i_test_clk_500m),
       .i_test_clk_62m                  (i_test_clk_62m),
       .i_test_c3adapt_scan_in          (i_test_c3adapt_scan_in/*[TOTAL_CHNL_NUM-1:0][`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG]*/),
       .i_test_c3adapt_tcb_static_common(i_test_c3adapt_tcb_static_common[`AIBADAPTWRAPTCB_STATIC_COMMON_RNG]),
       .i_jtag_rstb_in                  (aibaux_jtag_rstb_out),  // Templated
       .i_jtag_rstb_en_in               (aibaux_jtag_rstb_en_out), // Templated
       .i_jtag_clkdr_in                 (aibaux_jtag_clkdr_out), // Templated
       .i_jtag_clksel_in                (aibaux_jtag_clksel_out), // Templated
       .i_jtag_intest_in                (aibaux_jtag_intest_out), // Templated
       .i_jtag_mode_in                  (aibaux_jtag_mode_out),  // Templated
       .i_jtag_weakpdn_in               (aibaux_jtag_weakpdn_out), // Templated
       .i_jtag_weakpu_in                (aibaux_jtag_weakpu_out), // Templated
       .i_jtag_bs_scanen_in             (aibaux_jtag_bs_scanen_out), // Templated
       .i_jtag_bs_chain_in              (aibaux_jtag_bs_chain_out), // Templated
       .i_por_aib_vcchssi               (aibaux_por_vcchssi),    // Templated
       .i_por_aib_vccl                  (aibaux_por_vccl));       // Templated

    /*aibcr3aux_top_wrp AUTO_TEMPLATE (
     .irstb              (i_iocsr_rdy_aibaux),
     .jtag_rx_scan_out   (aibaux_jtag_bs_chain_out[]),
     .jtag_tx_scanen_out (aibaux_jtag_bs_scanen_out[]),
     .jtag_\(.*\)_out (aibaux_jtag_\1_out[]),
     .jtag_\(.*\)_in  (i_jtag_\1[]), 
     .last_bs_out     (o_last_bs_out[]),
     .aib_aux_ctrl_bus\(.*\)  (i_aibaux_ctrl_bus\1[]), 
     .aib_aux\(.*\)   (io_aib_aux[\1]),
   
     .o_por_vcchssi   (aibaux_por_vcchssi),
     .o_por_vccl      (aibaux_por_vccl),
     .oosc_aibdft2osc (o_aibdft2osc[12:0]),
     .last_bs_in      (aibaux_last_bs_in),
     .o_dn_por        (o_por),  
     .i_actred1       (o_directout_data_chain1_out),
     .i_actred2       (o_directout_data_chain2_out),
     .iactred_txen1   (o_txen_out_chain1),
     .iactred_txen2   (o_txen_out_chain2),
     .ired_\(.*\)     (red_\1[]),
     .iaib_aibdll2dft (o_aibdftdll2adjch[12:0]),
     .osc_extrref     (io_aux_bg_ext_2k),
     .oosc_clkout     (aibaux_osc_clk),
     .oosc_clkout_dup (o_aibaux_osc_clk),
     .oosc_monitor    (o_osc_monitor[]),
     .oatpg_scan_out  (o_aux_atpg_scan_out[]),
     .iatpg\(.*\)     (i_aux_atpg\1[]),
     .iosc_fuse_trim  (i_aibaux_osc_fuse_trim[]),
     .iosc_aibdft2osc (i_aibdft2osc[2:0]),
     .c4por_vccl_ovrd (i_aibaux_por_vccl_ovrd),
     .iosc_bypclk     (i_osc_bypclk),
     //tie-off ports
     .i_jtr_\(.*\)    (1'b0),   //test pin on chiplet, not used
     .idft_bypass_en  (1'b0),
     .idft_out_async  (8'd0),
     .iosc_ic50u      (1'b0),
     .iosc_it50u      (1'b0),
     .i_cnocup        (50'd0),  //not used
     .i_tstmx         (8'h0),
     .i_cnocup_clkp   (1'b0),
     .i_io_out        (8'h0),
     //unconnected ports
     .o_io\(.*\)      (),    
     .o_jt_t\(.*\)    (), //test pin on chiplet, not used
     .o_por_vccl_1p8  (),
     .odft_in_async   (),
     .oosc_atb0       (),
     .oosc_atb1       (),
     .oosc_reserved   (),
     .o_dn_rst_n      (),  //not used
     .o_cnocdn\(.*\)  (), // not used
     );
     */

    aibcr3aux_top_wrp u_aibcr3aux_top_wrp
      (/*AUTOINST*/
       // Outputs
       .jtag_clkdr_out                  (aibaux_jtag_clkdr_out), // Templated
       .jtag_clksel_out                 (aibaux_jtag_clksel_out), // Templated
       .jtag_intest_out                 (aibaux_jtag_intest_out), // Templated
       .jtag_mode_out                   (aibaux_jtag_mode_out),  // Templated
       .jtag_rstb_en_out                (aibaux_jtag_rstb_en_out), // Templated
       .jtag_rstb_out                   (aibaux_jtag_rstb_out),  // Templated
       .jtag_rx_scan_out                (aibaux_jtag_bs_chain_out), // Templated
       .jtag_tx_scanen_out              (aibaux_jtag_bs_scanen_out), // Templated
       .jtag_weakpdn_out                (aibaux_jtag_weakpdn_out), // Templated
       .jtag_weakpu_out                 (aibaux_jtag_weakpu_out), // Templated
       .last_bs_out                     (o_last_bs_out),         // Templated
       .o_cnocdn_clkp                   (),                      // Templated
       .o_dn_por                        (o_por),                 // Templated
       .o_dn_rst_n                      (),                      // Templated
       .o_jt_tck                        (),                      // Templated
       .o_jt_tdi                        (),                      // Templated
       .o_jt_tms                        (),                      // Templated
       .o_por_vcchssi                   (aibaux_por_vcchssi),    // Templated
       .o_por_vccl                      (aibaux_por_vccl),       // Templated
       .o_por_vccl_1p8                  (),                      // Templated
       .oatpg_scan_out                  (o_aux_atpg_scan_out),   // Templated
       .oosc_atb0                       (),                      // Templated
       .oosc_atb1                       (),                      // Templated
       .oosc_clkout_dup                 (o_aibaux_osc_clk),      // Templated
       .oosc_clkout                     (aibaux_osc_clk),        // Templated
       .oosc_monitor                    (o_osc_monitor),         // Templated
       .odft_in_async                   (),                      // Templated
       .o_cnocdn                        (),                      // Templated
       .o_io_in                         (),                      // Templated
       .o_io_oe                         (),                      // Templated
       .oosc_aibdft2osc                 (o_aibdft2osc[12:0]),    // Templated
       .oosc_reserved                   (),                      // Templated
       // Inouts
       .aib_aux0                        (io_aib_aux[0]),         // Templated
       .aib_aux1                        (io_aib_aux[1]),         // Templated
       .aib_aux2                        (io_aib_aux[2]),         // Templated
       .aib_aux3                        (io_aib_aux[3]),         // Templated
       .aib_aux4                        (io_aib_aux[4]),         // Templated
       .aib_aux5                        (io_aib_aux[5]),         // Templated
       .aib_aux6                        (io_aib_aux[6]),         // Templated
       .aib_aux7                        (io_aib_aux[7]),         // Templated
       .aib_aux8                        (io_aib_aux[8]),         // Templated
       .aib_aux9                        (io_aib_aux[9]),         // Templated
       .aib_aux10                       (io_aib_aux[10]),        // Templated
       .aib_aux11                       (io_aib_aux[11]),        // Templated
       .aib_aux12                       (io_aib_aux[12]),        // Templated
       .aib_aux13                       (io_aib_aux[13]),        // Templated
       .aib_aux14                       (io_aib_aux[14]),        // Templated
       .aib_aux15                       (io_aib_aux[15]),        // Templated
       .aib_aux16                       (io_aib_aux[16]),        // Templated
       .aib_aux17                       (io_aib_aux[17]),        // Templated
       .aib_aux18                       (io_aib_aux[18]),        // Templated
       .aib_aux19                       (io_aib_aux[19]),        // Templated
       .aib_aux20                       (io_aib_aux[20]),        // Templated
       .aib_aux21                       (io_aib_aux[21]),        // Templated
       .aib_aux22                       (io_aib_aux[22]),        // Templated
       .aib_aux23                       (io_aib_aux[23]),        // Templated
       .aib_aux24                       (io_aib_aux[24]),        // Templated
       .aib_aux25                       (io_aib_aux[25]),        // Templated
       .aib_aux26                       (io_aib_aux[26]),        // Templated
       .aib_aux27                       (io_aib_aux[27]),        // Templated
       .aib_aux28                       (io_aib_aux[28]),        // Templated
       .aib_aux29                       (io_aib_aux[29]),        // Templated
       .aib_aux30                       (io_aib_aux[30]),        // Templated
       .aib_aux31                       (io_aib_aux[31]),        // Templated
       .aib_aux32                       (io_aib_aux[32]),        // Templated
       .aib_aux33                       (io_aib_aux[33]),        // Templated
       .aib_aux34                       (io_aib_aux[34]),        // Templated
       .aib_aux35                       (io_aib_aux[35]),        // Templated
       .aib_aux36                       (io_aib_aux[36]),        // Templated
       .aib_aux37                       (io_aib_aux[37]),        // Templated
       .aib_aux38                       (io_aib_aux[38]),        // Templated
       .aib_aux39                       (io_aib_aux[39]),        // Templated
       .aib_aux40                       (io_aib_aux[40]),        // Templated
       .aib_aux41                       (io_aib_aux[41]),        // Templated
       .aib_aux42                       (io_aib_aux[42]),        // Templated
       .aib_aux43                       (io_aib_aux[43]),        // Templated
       .aib_aux44                       (io_aib_aux[44]),        // Templated
       .aib_aux45                       (io_aib_aux[45]),        // Templated
       .aib_aux46                       (io_aib_aux[46]),        // Templated
       .aib_aux47                       (io_aib_aux[47]),        // Templated
       .aib_aux48                       (io_aib_aux[48]),        // Templated
       .aib_aux49                       (io_aib_aux[49]),        // Templated
       .aib_aux50                       (io_aib_aux[50]),        // Templated
       .aib_aux51                       (io_aib_aux[51]),        // Templated
       .aib_aux52                       (io_aib_aux[52]),        // Templated
       .aib_aux53                       (io_aib_aux[53]),        // Templated
       .aib_aux54                       (io_aib_aux[54]),        // Templated
       .aib_aux55                       (io_aib_aux[55]),        // Templated
       .aib_aux56                       (io_aib_aux[56]),        // Templated
       .aib_aux57                       (io_aib_aux[57]),        // Templated
       .aib_aux58                       (io_aib_aux[58]),        // Templated
       .aib_aux59                       (io_aib_aux[59]),        // Templated
       .aib_aux60                       (io_aib_aux[60]),        // Templated
       .aib_aux61                       (io_aib_aux[61]),        // Templated
       .aib_aux62                       (io_aib_aux[62]),        // Templated
       .aib_aux63                       (io_aib_aux[63]),        // Templated
       .aib_aux64                       (io_aib_aux[64]),        // Templated
       .aib_aux65                       (io_aib_aux[65]),        // Templated
       .aib_aux66                       (io_aib_aux[66]),        // Templated
       .aib_aux67                       (io_aib_aux[67]),        // Templated
       .aib_aux68                       (io_aib_aux[68]),        // Templated
       .aib_aux69                       (io_aib_aux[69]),        // Templated
       .aib_aux70                       (io_aib_aux[70]),        // Templated
       .aib_aux71                       (io_aib_aux[71]),        // Templated
       .aib_aux72                       (io_aib_aux[72]),        // Templated
       .aib_aux73                       (io_aib_aux[73]),        // Templated
       .aib_aux74                       (io_aib_aux[74]),        // Templated
       .aib_aux75                       (io_aib_aux[75]),        // Templated
       .aib_aux76                       (io_aib_aux[76]),        // Templated
       .aib_aux77                       (io_aib_aux[77]),        // Templated
       .aib_aux78                       (io_aib_aux[78]),        // Templated
       .aib_aux79                       (io_aib_aux[79]),        // Templated
       .aib_aux80                       (io_aib_aux[80]),        // Templated
       .aib_aux81                       (io_aib_aux[81]),        // Templated
       .aib_aux82                       (io_aib_aux[82]),        // Templated
       .aib_aux83                       (io_aib_aux[83]),        // Templated
       .aib_aux84                       (io_aib_aux[84]),        // Templated
       .aib_aux85                       (io_aib_aux[85]),        // Templated
       .aib_aux86                       (io_aib_aux[86]),        // Templated
       .aib_aux87                       (io_aib_aux[87]),        // Templated
       .aib_aux88                       (io_aib_aux[88]),        // Templated
       .aib_aux89                       (io_aib_aux[89]),        // Templated
       .aib_aux90                       (io_aib_aux[90]),        // Templated
       .aib_aux91                       (io_aib_aux[91]),        // Templated
       .aib_aux92                       (io_aib_aux[92]),        // Templated
       .aib_aux93                       (io_aib_aux[93]),        // Templated
       .aib_aux94                       (io_aib_aux[94]),        // Templated
       .aib_aux95                       (io_aib_aux[95]),        // Templated
       .osc_extrref                     (io_aux_bg_ext_2k),      // Templated
       // Inputs
       .c4por_vccl_ovrd                 (i_aibaux_por_vccl_ovrd), // Templated
       .i_actred1                       (o_directout_data_chain1_out), // Templated
       .i_actred2                       (o_directout_data_chain2_out), // Templated
       .i_cnocup_clkp                   (1'b0),                  // Templated
       .i_jtr_tck                       (1'b0),                  // Templated
       .i_jtr_tdo                       (1'b0),                  // Templated
       .i_jtr_tms                       (1'b0),                  // Templated
       .iactred_txen1                   (o_txen_out_chain1),     // Templated
       .iactred_txen2                   (o_txen_out_chain2),     // Templated
       .iatpg_mode_n                    (i_aux_atpg_mode_n),     // Templated
       .iatpg_pipeline_global_en        (i_aux_atpg_pipeline_global_en), // Templated
       .iatpg_rst_n                     (i_aux_atpg_rst_n),      // Templated
       .iatpg_scan_clk                  (i_aux_atpg_scan_clk),   // Templated
       .iatpg_scan_in                   (i_aux_atpg_scan_in),    // Templated
       .iatpg_scan_shift_n              (i_aux_atpg_scan_shift_n), // Templated
       .idft_bypass_en                  (1'b0),                  // Templated
       .iosc_bypclk                     (i_osc_bypclk),          // Templated
       .iosc_ic50u                      (1'b0),                  // Templated
       .iosc_it50u                      (1'b0),                  // Templated
       .ired_idataselb_in_chain1        (red_idataselb_in_chain1), // Templated
       .ired_idataselb_in_chain2        (red_idataselb_in_chain2), // Templated
       .ired_shift_en_in_chain1         (red_shift_en_in_chain1), // Templated
       .ired_shift_en_in_chain2         (red_shift_en_in_chain2), // Templated
       .irstb                           (i_iocsr_rdy_aibaux),    // Templated
       .jtag_clkdr_in                   (i_jtag_clkdr),          // Templated
       .jtag_clksel_in                  (i_jtag_clksel),         // Templated
       .jtag_intest_in                  (i_jtag_intest),         // Templated
       .jtag_mode_in                    (i_jtag_mode),           // Templated
       .jtag_rstb_en_in                 (i_jtag_rstb_en),        // Templated
       .jtag_rstb_in                    (i_jtag_rstb),           // Templated
       .jtag_tx_scan_in                 (i_jtag_tx_scan),        // Templated
       .jtag_tx_scanen_in               (i_jtag_tx_scanen),      // Templated
       .jtag_weakpdn_in                 (i_jtag_weakpdn),        // Templated
       .jtag_weakpu_in                  (i_jtag_weakpu),         // Templated
       .last_bs_in                      (aibaux_last_bs_in),     // Templated
       .iaib_aibdll2dft                 (o_aibdftdll2adjch[12:0]), // Templated
       .aib_aux_ctrl_bus0               (i_aibaux_ctrl_bus0[31:0]), // Templated
       .aib_aux_ctrl_bus1               (i_aibaux_ctrl_bus1[31:0]), // Templated
       .aib_aux_ctrl_bus2               (i_aibaux_ctrl_bus2[31:0]), // Templated
       .i_cnocup                        (50'd0),                 // Templated
       .i_io_out                        (8'h0),                  // Templated
       .i_tstmx                         (8'h0),                  // Templated
       .idft_out_async                  (8'd0),                  // Templated
       .iosc_aibdft2osc                 (i_aibdft2osc[2:0]),     // Templated
       .iosc_fuse_trim                  (i_aibaux_osc_fuse_trim[9:0])); // Templated
    
endmodule // aib_top

/* Local Variables:
 verilog-library-directories:(".""../../aibcr3aux_lib/rtl")
 verilog-auto-inst-param-value: t
End:
*/
