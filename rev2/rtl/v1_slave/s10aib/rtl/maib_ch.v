// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//

module maib_ch (

//*****  symmetrical Microbump *******//
inout  wire [95:0]  iopad_aib,

//*****  MAC signals Corresponded to Microbump *******//
//MAC data interface
input  wire [79:0]  tx_parallel_data,     // This name mapped to quartus generated user interface signals. connect to pld_tx_fabric_data_in
output wire [79:0]  rx_parallel_data,     // This name mapped to quartus generated user interface signals. connect to pld_rx_fabric_data_out
input  wire         tx_coreclkin, // This name mapped to quartus generated user interface signals.connect to pld_tx_clk1_dcm. Half of m_fs_fwd_clk 
output wire         tx_clkout, // This name mapped to quartus generated user interface signals.connect to pld_pcs_tx_clk_out1_dcm.
input  wire         rx_coreclkin, // This name mapped to quartus generated user interface signals.connect to pld_rx_clk1_dcm. 
                                  // Also connect to pld_pma_coreclkin_rowclk which go to iopad_ns_rcv_clk.
output wire         rx_clkout, // connect to pld_pcs_rx_clk_out1_dcm. 1GHz. Available to MAC. Half of m_fs_fwd_clk.
input               m_ns_fwd_clk, // connect to pld_tx_clk2_dcm. This clock needs to be supplied if tx phase compensation fifo read clock
                                  // It is optional if FIFO read clock is from master.
output              m_fs_fwd_clk, // connect to pld_pcs_rx_clk_out2_dcm 

output wire         fs_mac_rdy,      //(use c3 pld_pma_clkdiv_rx_user pin). Drive by Master
input  wire         ns_mac_rdy,      //corresponding to nd pld_pma_rxpma_rstb. This signal should be high before ns_adapter_rstn go high.
input  wire         ns_adapter_rstn, //Reset Main adapter and pass over to the fs. 
input  wire         config_done,     //This is csr_rdy_in

input  wire         sl_rx_dcc_dll_lock_req, //Drive reset statemachine at the farside
input  wire         sl_tx_dcc_dll_lock_req, //Drive reset statemachine at the farside

//*** config bit **** ///
//sdr or ddr mode, dcc, dll bypass or not. register mode or not ***/

//**** ns ready status The following signals can be found from ms_sideband and sl_sideband. Listed explicitly for convinience***//
output wire         ms_osc_transfer_en,
output wire         ms_rx_transfer_en,
output wire         ms_tx_transfer_en,
output wire         sl_osc_transfer_en,
output wire         sl_rx_transfer_en, 
output wire         sl_tx_transfer_en,

//Put MS to SL sideband signal and SL to MS sideband signal
output wire [80:0]  ms_sideband,
output wire [72:0]  sl_sideband
//Put side band 80 bit  from ms and sl for debugging purpose
);                                              //Should be triggered for initialization

logic         csr_rdy_dly_in; //1 micro second after csr_rdy_in. Config done
logic         nfrzdrv_in;     //Before config done, this signal is zero to freeze PLD output to 1.
logic         usermode_in;
logic [93:0]  ssrout_parallel_out_latch;
logic [117:0] ssrin_parallel_in;

wire          HI, LO;
assign        HI = 1'b1;
assign        LO = 1'b0;



initial begin
  csr_rdy_dly_in = 1'b0;
  nfrzdrv_in = 1'b0;
  usermode_in = 1'b0;

  @(config_done)
  #1000ns;
  csr_rdy_dly_in = 1'b1;
  nfrzdrv_in = 1'b1;
  #1000ns;
  usermode_in = 1'b1;

end

assign ms_osc_transfer_en = ssrout_parallel_out_latch[80];
assign ms_tx_transfer_en  = ssrout_parallel_out_latch[78];
assign ms_rx_transfer_en  = ssrout_parallel_out_latch[75];
assign ms_sideband        = ssrout_parallel_out_latch[80:0];
assign sl_osc_transfer_en = ssrin_parallel_in[72];
assign sl_rx_transfer_en  = ssrin_parallel_in[70];
assign sl_tx_transfer_en  = ssrin_parallel_in[64];
assign sl_sideband        = ssrin_parallel_in[72:0];

ndaibadapt_wrap  ndut(

// EMIB inout
                      .io_aib0(iopad_aib[0]), 
                      .io_aib1(iopad_aib[1]), 
                      .io_aib10(iopad_aib[10]),
                      .io_aib11(iopad_aib[11]),
                      .io_aib12(iopad_aib[12]),
                      .io_aib13(iopad_aib[13]),
                      .io_aib14(iopad_aib[14]),
                      .io_aib15(iopad_aib[15]),
                      .io_aib16(iopad_aib[16]),
                      .io_aib17(iopad_aib[17]),
                      .io_aib18(iopad_aib[18]),
                      .io_aib19(iopad_aib[19]),
                      .io_aib2(iopad_aib[2]), 
                      .io_aib20(iopad_aib[20]),
                      .io_aib21(iopad_aib[21]),
                      .io_aib22(iopad_aib[22]),
                      .io_aib23(iopad_aib[23]),
                      .io_aib24(iopad_aib[24]),
                      .io_aib25(iopad_aib[25]),
                      .io_aib26(iopad_aib[26]),
                      .io_aib27(iopad_aib[27]),
                      .io_aib28(iopad_aib[28]),
                      .io_aib29(iopad_aib[29]),
                      .io_aib3(iopad_aib[3]), 
                      .io_aib30(iopad_aib[30]),
                      .io_aib31(iopad_aib[31]),
                      .io_aib32(iopad_aib[32]),
                      .io_aib33(iopad_aib[33]),
                      .io_aib34(iopad_aib[34]),
                      .io_aib35(iopad_aib[35]),
                      .io_aib36(iopad_aib[36]),
                      .io_aib37(iopad_aib[37]),
                      .io_aib38(iopad_aib[38]),
                      .io_aib39(iopad_aib[39]),
                      .io_aib4(iopad_aib[4]), 
                      .io_aib40(iopad_aib[40]),
                      .io_aib41(iopad_aib[41]),
                      .io_aib42(iopad_aib[42]),
                      .io_aib43(iopad_aib[43]),
                      .io_aib44(iopad_aib[44]),
                      .io_aib45(iopad_aib[45]),   //From Tim's 3/26 aib_bump_map
                      .io_aib46(iopad_aib[46]),   //spare[0]
                      .io_aib47(iopad_aib[47]),   //spare[1]
                      .io_aib48(iopad_aib[48]),   
                      .io_aib49(iopad_aib[49]),
                      .io_aib5(iopad_aib[5]), 
                      .io_aib50(iopad_aib[50]),    //From Tim's 3/26 aib_bump_map
                      .io_aib51(iopad_aib[51]),      //From Tim's 3/26 aib_bump_map
                      .io_aib52(iopad_aib[52]),      //From Tim's 3/26 aib_bump_map
                      .io_aib53(iopad_aib[53]),       //From Tim's 3/26 aib_bump_map    
                      .io_aib54(iopad_aib[54]),       //From Tim's 3/26 aib_bump_map
                      .io_aib55(iopad_aib[55]),       
                      .io_aib56(iopad_aib[56]),
                      .io_aib57(iopad_aib[57]),
                      .io_aib58(iopad_aib[58]),     //From Tim's 3/26 aib_bump_map
                      .io_aib59(iopad_aib[59]),
                      .io_aib6(iopad_aib[6]), 
                      .io_aib60(iopad_aib[60]),              //From Tim's 3/26 aib_bump_map
                      .io_aib61(iopad_aib[61]),     // From Tim's 3/26 aib_bump_map
                      .io_aib62(iopad_aib[62]),     // From Tim's 3/26 aib_bump_map
                      .io_aib63(iopad_aib[63]),     //unused
                      .io_aib64(iopad_aib[64]),     //unused
                      .io_aib65(iopad_aib[65]),
                      .io_aib66(iopad_aib[66]),              //From Tim's 3/26 aib_bump_map
                      .io_aib67(iopad_aib[67]),              //From Tim's 3/26 aib_bump_map
                      .io_aib68(iopad_aib[68]),              //From Tim's 3/26 aib_bump_map
                      .io_aib69(iopad_aib[69]),              //From Tim's 3/26 aib_bump_map
                      .io_aib7(iopad_aib[7]), 
                      .io_aib70(iopad_aib[70]),              //From Tim's 3/26 aib_bump_map
                      .io_aib71(iopad_aib[71]),              //From Tim's 3/26 aib_bump_map
                      .io_aib72(iopad_aib[72]),     //From Tim's 3/26 aib_bump_map
                      .io_aib73(iopad_aib[73]),     //From Tim's 3/26 aib_bump_map
                      .io_aib74(iopad_aib[74]),     //From Tim's 3/26 aib_bump_map
                      .io_aib75(iopad_aib[75]),              //From Tim's 3/26 aib_bump_map
                      .io_aib76(iopad_aib[76]),              //From Tim's 3/26 aib_bump_map
                      .io_aib77(iopad_aib[77]),              //From Tim's 3/26 aib_bump_map
                      .io_aib78(iopad_aib[78]),     //unused
                      .io_aib79(iopad_aib[79]),     //unused
                      .io_aib8(iopad_aib[8]), 
                      .io_aib80(iopad_aib[80]),     //unused
                      .io_aib81(iopad_aib[81]),     //unused
                      .io_aib82(iopad_aib[82]),
                      .io_aib83(iopad_aib[83]),
                      .io_aib84(iopad_aib[84]),
                      .io_aib85(iopad_aib[85]),
                      .io_aib86(iopad_aib[86]),
                      .io_aib87(iopad_aib[87]),
                      .io_aib88(iopad_aib[88]),      //unused
                      .io_aib89(iopad_aib[89]),      //unused
                      .io_aib9(iopad_aib[9]), 
                      .io_aib90(iopad_aib[90]),      //From Tim's 3/26 aib_bump_map
                      .io_aib91(iopad_aib[91]),      //From Tim's 3/26 aib_bump_map
                      .io_aib92(iopad_aib[92]),
                      .io_aib93(iopad_aib[93]),
                      .io_aib94(iopad_aib[94]),
                      .io_aib95(iopad_aib[95]),

    // Adapter       input 
              	      .bond_rx_asn_ds_in_fifo_hold(1'b0),
              	      .bond_rx_asn_us_in_fifo_hold(1'b0),
              	      .bond_rx_fifo_ds_in_rden(1'b0),
              	      .bond_rx_fifo_ds_in_wren(1'b0),
              	      .bond_rx_fifo_us_in_rden(1'b0),
              	      .bond_rx_fifo_us_in_wren(1'b0),
                      .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock(1'b0),
                      .bond_rx_hrdrst_us_in_fabric_rx_dll_lock(1'b0),
                      .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req(1'b0),
                      .bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req(1'b0),
              	      .bond_tx_fifo_ds_in_dv(1'b0),
              	      .bond_tx_fifo_ds_in_rden(1'b0),
              	      .bond_tx_fifo_ds_in_wren(1'b0),
              	      .bond_tx_fifo_us_in_dv(1'b0),
              	      .bond_tx_fifo_us_in_rden(1'b0),
              	      .bond_tx_fifo_us_in_wren(1'b0),
                      .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done(1'b0),
                      .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done(1'b0),
                      .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req(1'b0),
                      .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req(1'b0),
    
    // Config  input (These are required for reset(), look properly and configure as is in previous project
                      .csr_config(3'h1),
                      .csr_clk_in(1'b0),
                      .csr_in(3'h0),
                      .csr_pipe_in(3'h0),
                      .csr_rdy_dly_in(csr_rdy_dly_in),
                      .csr_rdy_in(config_done),
                      .nfrzdrv_in(nfrzdrv_in),
                      .usermode_in(usermode_in),
    
    // PLD input
              	      .hip_aib_fsr_in(4'h0),
              	      .hip_aib_ssr_in(40'h0),
              	      .hip_avmm_read(1'b0),
              	      .hip_avmm_reg_addr(21'h0),
              	      .hip_avmm_write(1'b0),
              	      .hip_avmm_writedata(8'h0),
              	      .pld_10g_krfec_rx_clr_errblk_cnt(1'b0),
              	      .pld_10g_rx_align_clr(1'b0),
              	      .pld_10g_rx_clr_ber_count(1'b0),
              	      .pld_10g_tx_bitslip(7'h0),
              	      .pld_10g_tx_burst_en(1'b0),
              	      .pld_10g_tx_diag_status(2'b0),
              	      .pld_10g_tx_wordslip(1'b0),
              	      .pld_8g_a1a2_size(1'b0),
              	      .pld_8g_bitloc_rev_en(1'b0),
              	      .pld_8g_byte_rev_en(1'b0),
              	      .pld_8g_eidleinfersel(3'h0),
              	      .pld_8g_encdt(1'b0),
              	      .pld_8g_tx_boundary_sel(5'h0),
              	      .pld_adapter_rx_pld_rst_n(ns_adapter_rstn),
              	      .pld_adapter_tx_pld_rst_n(ns_adapter_rstn),
              	      .pld_avmm1_clk_rowclk(1'b0),
              	      .pld_avmm1_read(1'b0),
              	      .pld_avmm1_reg_addr(10'h0),
              	      .pld_avmm1_request(1'b0),
              	      .pld_avmm1_write(1'b0),
              	      .pld_avmm1_writedata(8'h0),
              	      .pld_avmm1_reserved_in(9'h0),
              	      .pld_avmm2_clk_rowclk(1'b0),
              	      .pld_avmm2_read(1'b0),
              	      .pld_avmm2_reg_addr(9'h0),
              	      .pld_avmm2_request(1'b0),
              	      .pld_avmm2_write(1'b0),
              	      .pld_avmm2_writedata(8'h0),
              	      .pld_avmm2_reserved_in(10'h0),
              	      .pld_bitslip(1'b0),
              	      .pld_fpll_shared_direct_async_in(2'b0),
              	      .pld_fpll_shared_direct_async_in_rowclk(1'b0),
              	      .pld_fpll_shared_direct_async_in_dcm(1'b0),
              	      .pld_ltr(1'b0),
              	      .pr_channel_freeze_n(1'b1),
              	      .pld_pcs_rx_pld_rst_n(1'b0),
              	      .pld_pcs_tx_pld_rst_n(1'b0),
              	      .pld_pma_adapt_start(1'b0),
              	      .pld_pma_coreclkin_rowclk(rx_coreclkin),
              	      .pld_pma_csr_test_dis(1'b0),
              	      .pld_pma_early_eios(1'b0),
              	      .pld_pma_eye_monitor(6'b0),
              	      .pld_pma_fpll_cnt_sel(4'b0),
              	      .pld_pma_fpll_extswitch(1'b0),
              	      .pld_pma_fpll_lc_csr_test_dis(1'b0),
              	      .pld_pma_fpll_num_phase_shifts(3'b0),
              	      .pld_pma_fpll_pfden(1'b0),
              	      .pld_pma_fpll_up_dn_lc_lf_rstn(1'b0),
              	      .pld_pma_ltd_b(1'b0),
              	      .pld_pma_nrpi_freeze(1'b0),
              	      .pld_pma_pcie_switch(2'h0),
              	      .pld_pma_ppm_lock(1'b0),
              	      .pld_pma_reserved_out(5'b0),
              	      .pld_pma_rs_lpbk_b(1'b0),
              	      .pld_pma_rxpma_rstb(ns_mac_rdy),
              	      .pld_pma_tx_bitslip(1'b0),
              	      .pld_pma_txdetectrx(1'b0),
              	      .pld_pma_txpma_rstb(1'b0),
              	      .pld_pmaif_rxclkslip(1'b0),
              	      .pld_polinv_rx(1'b0),
              	      .pld_polinv_tx(1'b0),
              	      .pld_rx_clk1_rowclk(1'b0),
              	      .pld_rx_clk2_rowclk(1'b0),
              	      .pld_rx_dll_lock_req(sl_rx_dcc_dll_lock_req),
              	      .pld_rx_fabric_fifo_align_clr(1'b0),
             `ifdef SS_EN_ND_FIFO_ELASTIC_BUF // For Testing ND FIFO Elastic Mode
              	      .pld_rx_fabric_fifo_rd_en(1'b1),
             `else
                      .pld_rx_fabric_fifo_rd_en(1'b0),
             `endif
              	      .pld_rx_prbs_err_clr(1'b0),
              	      .pld_sclk1_rowclk(1'b0),
              	      .pld_sclk2_rowclk(1'b0),
              	      .pld_syncsm_en(1'b0),
              	      .pld_tx_clk1_rowclk(tx_coreclkin),
              	      .pld_tx_clk2_rowclk(m_ns_fwd_clk),
              	      .pld_tx_fabric_data_in(tx_parallel_data),  //Loopback from rx
              	      .pld_txelecidle(1'b0),
                      .pld_tx_dll_lock_req(sl_tx_dcc_dll_lock_req),
                      .pld_tx_fifo_latency_adj_en(1'b0),
                      .pld_rx_fifo_latency_adj_en(1'b0),
                      .pld_aib_fabric_rx_dll_lock_req(1'b0),
                      .pld_aib_fabric_tx_dcd_cal_req(1'b0),
                      .pld_aib_hssi_tx_dcd_cal_req(1'b0),
                      .pld_aib_hssi_tx_dll_lock_req(1'b0),
                      .pld_aib_hssi_rx_dcd_cal_req(1'b0),
                      .pld_tx_ssr_reserved_in(3'b11), 
                      .pld_rx_ssr_reserved_in(2'b00), 
                      .pld_pma_tx_qpi_pulldn(1'b0),
                      .pld_pma_tx_qpi_pullup(1'b1),    
                      .pld_pma_rx_qpi_pullup(1'b1),
                      .pld_pma_aib_tx_clk(1'b0),
    
    // PLD DCM input
                      .pld_rx_clk1_dcm(rx_coreclkin),
                      .pld_tx_clk1_dcm(tx_coreclkin),
                      .pld_tx_clk2_dcm(m_ns_fwd_clk),
    
    // uC AVMM
    
    // DFT input
                      .dft_adpt_aibiobsr_fastclkn(1'b1),
                      .adapter_scan_rst_n(1'b1),
                      .adapter_scan_mode_n(1'b1),
                      .adapter_scan_shift_n(1'b1),
                      .adapter_scan_shift_clk(1'b0),
                      .adapter_scan_user_clk0(1'b0),         // 125MHz
                      .adapter_scan_user_clk1(1'b0),         // 250MHz
                      .adapter_scan_user_clk2(1'b0),         // 500MHz
                      .adapter_scan_user_clk3(1'b0),         // 1GHz
                      .adapter_clk_sel_n(1'b0),
                      .adapter_occ_enable(1'b0),
                      .adapter_global_pipe_se(1'b1),
                      .adapter_config_scan_in(4'h0),
                      .adapter_scan_in_occ1(2'h0),
                      .adapter_scan_in_occ2(5'h0),
                      .adapter_scan_in_occ3(1'b0),
                      .adapter_scan_in_occ4(1'b0),
                      .adapter_scan_in_occ5(2'h0),
                      .adapter_scan_in_occ6(11'h0),
                      .adapter_scan_in_occ7(1'b0),
                      .adapter_scan_in_occ8(1'b0),
                      .adapter_scan_in_occ9(1'b0),
                      .adapter_scan_in_occ10(1'b0),
                      .adapter_scan_in_occ11(1'b0),
                      .adapter_scan_in_occ12(1'b0),
                      .adapter_scan_in_occ13(1'b0),
                      .adapter_scan_in_occ14(1'b0),
                      .adapter_scan_in_occ15(1'b0),
                      .adapter_scan_in_occ16(1'b0),
                      .adapter_scan_in_occ17(1'b0),
                      .adapter_scan_in_occ18(2'h0),
                      .adapter_scan_in_occ19(1'h0),
                      .adapter_scan_in_occ20(1'h0),
                      .adapter_scan_in_occ21(2'h0),
                      .adapter_non_occ_scan_in(1'b0),
                      .adapter_occ_scan_in(1'b0),
                      .dft_fabric_iaibdftcore2dll(3'h0),
    
    
    // DFT output
                      .adapter_config_scan_out(),
                      .adapter_scan_out_occ1(),
                      .adapter_scan_out_occ2(),
                      .adapter_scan_out_occ3(),
                      .adapter_scan_out_occ4(),
                      .adapter_scan_out_occ5(),
                      .adapter_scan_out_occ6(),
                      .adapter_scan_out_occ7(),
                      .adapter_scan_out_occ8(),
                      .adapter_scan_out_occ9(),
                      .adapter_scan_out_occ10(),
                      .adapter_scan_out_occ11(),
                      .adapter_scan_out_occ12(),
                      .adapter_scan_out_occ13(),
                      .adapter_scan_out_occ14(),
                      .adapter_scan_out_occ15(),
                      .adapter_scan_out_occ16(),
                      .adapter_scan_out_occ17(),
                      .adapter_scan_out_occ18(),
                      .adapter_scan_out_occ19(),
                      .adapter_scan_out_occ20(),
                      .adapter_scan_out_occ21(),
                      .adapter_non_occ_scan_out(),
                      .adapter_occ_scan_out(),
                      .dft_fabric_oaibdftdll2core(),
    
    // Adapter output
                      .bond_rx_asn_ds_out_fifo_hold(),
                      .bond_rx_asn_us_out_fifo_hold(),
                      .bond_rx_fifo_ds_out_rden(),
                      .bond_rx_fifo_ds_out_wren(),
                      .bond_rx_fifo_us_out_rden(),
                      .bond_rx_fifo_us_out_wren(),
                      .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock(),
                      .bond_rx_hrdrst_us_out_fabric_rx_dll_lock(),
                      .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req(),
                      .bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req(),
                      .bond_tx_fifo_ds_out_dv(),
                      .bond_tx_fifo_ds_out_rden(),
                      .bond_tx_fifo_ds_out_wren(),
                      .bond_tx_fifo_us_out_dv(),
                      .bond_tx_fifo_us_out_rden(),
                      .bond_tx_fifo_us_out_wren(),
                      .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done(),
                      .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done(),
                      .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req(),
                      .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req(),
    // Config output
                      .csr_clk_out(),
                      .csr_out(),
                      .csr_pipe_out(),
                      .csr_rdy_dly_out(),
                      .csr_rdy_out(),
                      .nfrzdrv_out(),
                      .usermode_out(),
    // PLD  output
                      .hip_aib_fsr_out(),
                      .hip_aib_ssr_out(),
                      .hip_avmm_readdata(),
                      .hip_avmm_readdatavalid(),
                      .hip_avmm_writedone(),
                      .hip_avmm_reserved_out(),
                      .pld_10g_krfec_rx_blk_lock(),
                      .pld_10g_krfec_rx_diag_data_status(),
                      .pld_10g_krfec_rx_frame(),
                      .pld_10g_krfec_tx_frame(),
                      .pld_krfec_tx_alignment(),
                      .pld_10g_rx_crc32_err(),
                      .pld_rx_fabric_fifo_insert(),
                      .pld_rx_fabric_fifo_del(),

                      .pld_10g_rx_frame_lock(),
                      .pld_10g_rx_hi_ber(),
                      .pld_10g_tx_burst_en_exe(),
                      .pld_8g_a1a2_k1k2_flag(),
                      .pld_8g_empty_rmf(),
                      .pld_8g_full_rmf(),
                      .pld_8g_rxelecidle(),
                      .pld_8g_signal_detect_out(),
                      .pld_8g_wa_boundary(),
                      .pld_avmm1_busy(),
                      .pld_avmm1_cmdfifo_wr_full(),
                      .pld_avmm1_cmdfifo_wr_pfull(),
                      .pld_avmm1_readdata(),
                      .pld_avmm1_readdatavalid(),
                      .pld_avmm1_reserved_out(),
                      .pld_avmm2_busy(),
                      .pld_avmm2_cmdfifo_wr_full(),
                      .pld_avmm2_cmdfifo_wr_pfull(),
                      .pld_avmm2_readdata(),
                      .pld_avmm2_readdatavalid(),
                      .pld_avmm2_reserved_out(),
                      .pld_chnl_cal_done(),
                      .pld_fpll_shared_direct_async_out(),
                      .pld_fpll_shared_direct_async_out_hioint(),
                      .pld_fpll_shared_direct_async_out_dcm(),
                      .pld_fsr_load(),
                      .pld_pcs_rx_clk_out1_hioint(),
                      .pld_pcs_rx_clk_out2_hioint(),
                      .pld_pcs_tx_clk_out1_hioint(),
                      .pld_pcs_tx_clk_out2_hioint(),
                      .pld_pll_cal_done(),
                      .pld_pma_adapt_done(),
                      .pld_pma_clkdiv_rx_user(fs_mac_rdy),
                      .pld_pma_clkdiv_tx_user(),
                      .pld_pma_fpll_clk0bad(),
                      .pld_pma_fpll_clk1bad(),
                      .pld_pma_fpll_clksel(),
                      .pld_pma_fpll_phase_done(),
                      .pld_pma_hclk_hioint(),
                      .pld_pma_internal_clk1_hioint(),
                      .pld_pma_internal_clk2_hioint(),
                      .pld_pma_pcie_sw_done(),
                      .pld_pma_pfdmode_lock(),
                      .pld_pma_reserved_in(),
                      .pld_pma_rx_detect_valid(),
                      .pld_pma_rx_found(),
                      .pld_pma_rxpll_lock(),
                      .pld_pma_signal_ok(),
                      .pld_pma_testbus(),
                      .pld_pmaif_mask_tx_pll(),
                      .pld_rx_fabric_align_done(),
                      .pld_rx_fabric_data_out(rx_parallel_data),
                      .pld_rx_fabric_fifo_empty(),
                      .pld_rx_fabric_fifo_full(),
                      .pld_rx_fabric_fifo_latency_pulse(),
                      .pld_rx_fabric_fifo_pempty(),
                      .pld_rx_fabric_fifo_pfull(),
                      .pld_rx_hssi_fifo_empty(),
                      .pld_rx_hssi_fifo_full(),
                      .pld_rx_hssi_fifo_latency_pulse(),
                      .pld_rx_prbs_done(),
                      .pld_rx_prbs_err(),
                      .pld_sr_clk_out(pld_ns_clk),
                      .pld_ssr_load(),
                      .pld_test_data(),
                      .pld_tx_fabric_fifo_empty(),
                      .pld_tx_fabric_fifo_full(),
                      .pld_tx_fabric_fifo_latency_pulse(),
                      .pld_tx_fabric_fifo_pempty(),
                      .pld_tx_fabric_fifo_pfull(),
                      .pld_tx_hssi_align_done(),
                      .pld_tx_hssi_fifo_empty(),
                      .pld_tx_hssi_fifo_full(),
                      .pld_tx_hssi_fifo_latency_pulse(),
                      .pld_hssi_osc_transfer_en(),
                      .pld_hssi_rx_transfer_en(),
                      .pld_fabric_tx_transfer_en(),
                      .pld_aib_fabric_rx_dll_lock(),
                      .pld_aib_fabric_tx_dcd_cal_done(),
                      .pld_aib_hssi_rx_dcd_cal_done(),
                      .pld_aib_hssi_tx_dcd_cal_done(),
                      .pld_aib_hssi_tx_dll_lock(),
                      .pld_hssi_asn_dll_lock_en(),
                      .pld_fabric_asn_dll_lock_en(),	
                      .pld_tx_ssr_reserved_out(),
                      .pld_rx_ssr_reserved_out(),
                      .ssrin_parallel_in(ssrin_parallel_in[117:0]),
                      .ssrout_parallel_out_latch(ssrout_parallel_out_latch[93:0]),
                          
                          // PLD DCM output
                      .pld_pcs_rx_clk_out1_dcm(rx_clkout),
                      .pld_pcs_rx_clk_out2_dcm(m_fs_fwd_clk),
                      .pld_pcs_tx_clk_out1_dcm(tx_clkout),
                      .pld_pcs_tx_clk_out2_dcm(),

    //JTAG input
                      .iatpg_pipeline_global_en(1'b0),
                      .iatpg_scan_clk_in0(1'b1),
                      .iatpg_scan_clk_in1(1'b1),
                      .iatpg_scan_in0(1'b0),
                      .iatpg_scan_in1(1'b0),
                      .iatpg_scan_shift_n(1'b1),
                      .iatpg_scan_mode_n(1'b1),
                      .iatpg_scan_rst_n(1'b1),
                      .ijtag_clkdr_in_chain(1'b0),
                      .ijtag_last_bs_in_chain(1'b0),
                      .ijtag_tx_scan_in_chain(1'b0),
                      .ired_directin_data_in_chain1(1'b0),
                      .ired_directin_data_in_chain2(1'b0),
                      .ired_irxen_in_chain1(3'h0),
                      .ired_irxen_in_chain2(3'h0),
                      .ired_shift_en_in_chain1(1'b0),
                      .ired_shift_en_in_chain2(1'b0),
                      .jtag_clksel(1'b0),
                      .jtag_intest(1'b0),
                      .jtag_mode_in(1'b0),
                      .jtag_rstb(1'b1),
                      .jtag_rstb_en(1'b0),
                      .jtag_tx_scanen_in(1'b0),
                      .jtag_weakpdn(1'b0),
                      .jtag_weakpu(1'b0),

    //Jtag output 
                      .jtag_clksel_out(),
                      .jtag_intest_out(),
                      .jtag_mode_out(),
                      .jtag_rstb_en_out(),
                      .jtag_rstb_out(),
                      .jtag_tx_scanen_out(),
                      .jtag_weakpdn_out(),
                      .jtag_weakpu_out(),
                      .oatpg_scan_out0(),
                      .oatpg_scan_out1(),
                      .ojtag_clkdr_out_chain(),
                      .ojtag_last_bs_out_chain(),
                      .ojtag_rx_scan_out_chain(),
                      .ored_directin_data_out0_chain1(),
                      .ored_directin_data_out0_chain2(),
                      .ored_rxen_out_chain1(),
                      .ored_rxen_out_chain2(),
                      .ored_shift_en_out_chain1(),
                      .ored_shift_en_out_chain2()
);
    
endmodule
