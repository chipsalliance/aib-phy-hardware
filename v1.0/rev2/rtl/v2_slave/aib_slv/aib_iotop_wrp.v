// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

module aib_iotop_wrp ( osc_clkout, osc_clk_adpt, jtag_clksel_out, jtag_intest_out,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     oaibdftdll2core, oaibdftdll2adjch, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, odirectout_data_out_chain1,
     ohssi_adapter_rx_pld_rst_n, odirectout_data_out_chain2, 
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_rxpma_rstb,
     ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_data_in,
     ohssi_tx_dcd_cal_done, ohssi_tx_dll_lock,
     ohssi_tx_transfer_clk, ohssirx_dcc_done, ojtag_clkdr_out_chain,
     ojtag_last_bs_out_chain, ojtag_rx_scan_out_chain,
     por_aib_vcchssi_out, por_aib_vccl_out, aib0, aib1, aib2, aib3,
     aib4, aib5, aib6, aib7, aib8, aib9, aib10, aib11, aib12, aib13,
     aib14, aib15, aib16, aib17, aib18, aib19, aib20, aib21, aib22,
     aib23, aib24, aib25, aib26, aib27, aib28, aib29, aib30, aib31,
     aib32, aib33, aib34, aib35, aib36, aib37, aib38, aib39, aib40,
     aib41, aib42, aib43, aib44, aib45, aib46, aib47, aib48, aib49,
     aib50, aib51, aib52, aib53, aib54, aib55, aib56, aib57, aib58,
     aib59, aib60, aib61, aib62, aib63, aib64, aib65, aib66, aib67,
     aib68, aib69, aib70, aib71, aib72, aib73, aib74, aib75, aib76,
     aib77, aib78, aib79, aib80, aib81, aib82, aib83, aib84, aib85,
     aib86, aib87, aib88, aib89, aib90, aib91, aib92, aib93, aib94,
     aib95, iaibdftcore2dll, iaibdftdll2adjch, iatpg_bsr0_scan_in,
     iatpg_bsr0_scan_shift_clk, iatpg_bsr1_scan_in,
     iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, 
     ihssi_dcc_req, 
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pma_aib_tx_clk,
     ihssi_rx_data_out, ihssi_rx_transfer_clk, ihssi_sr_clk_out,
     ihssi_ssr_data_out, ihssi_ssr_load_out, ihssi_tx_dcd_cal_req,
     ihssi_tx_dll_lock_req, ijtag_clkdr_in_chain,
     ijtag_last_bs_in_chain, ijtag_tx_scan_in_chain,
     irstb,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl, r_aib_csr_ctrl_0, r_aib_csr_ctrl_1,
     r_aib_csr_ctrl_2, r_aib_csr_ctrl_3, r_aib_csr_ctrl_4,
     r_aib_csr_ctrl_5, r_aib_csr_ctrl_6, r_aib_csr_ctrl_7,
     r_aib_csr_ctrl_8, r_aib_csr_ctrl_9, r_aib_csr_ctrl_10,
     r_aib_csr_ctrl_11, r_aib_csr_ctrl_12, r_aib_csr_ctrl_13,
     r_aib_csr_ctrl_14, r_aib_csr_ctrl_15, r_aib_csr_ctrl_16,
     r_aib_csr_ctrl_17, r_aib_csr_ctrl_18, r_aib_csr_ctrl_19,
     r_aib_csr_ctrl_20, r_aib_csr_ctrl_21, r_aib_csr_ctrl_22,
     r_aib_csr_ctrl_23, r_aib_csr_ctrl_24, r_aib_csr_ctrl_25,
     r_aib_csr_ctrl_26, r_aib_csr_ctrl_27, r_aib_csr_ctrl_28,
     r_aib_csr_ctrl_29, r_aib_csr_ctrl_30, r_aib_csr_ctrl_31,
     r_aib_csr_ctrl_32, r_aib_csr_ctrl_33, r_aib_csr_ctrl_34,
     r_aib_csr_ctrl_35, r_aib_csr_ctrl_36, r_aib_csr_ctrl_37,
     r_aib_csr_ctrl_38, r_aib_csr_ctrl_39, r_aib_csr_ctrl_40,
     r_aib_csr_ctrl_41, r_aib_csr_ctrl_42, r_aib_csr_ctrl_43,
     r_aib_csr_ctrl_44, r_aib_csr_ctrl_45, r_aib_csr_ctrl_46,
     r_aib_csr_ctrl_47, r_aib_csr_ctrl_48, r_aib_csr_ctrl_49,
     r_aib_csr_ctrl_50, r_aib_csr_ctrl_51, r_aib_csr_ctrl_52,
     r_aib_csr_ctrl_53, r_aib_dprio_ctrl_0, r_aib_dprio_ctrl_1,
     r_aib_dprio_ctrl_2, r_aib_dprio_ctrl_3, r_aib_dprio_ctrl_4 
     );

output  osc_clkout, osc_clk_adpt, jtag_clksel_out, jtag_intest_out, jtag_mode_out,
     jtag_rstb_en_out, jtag_rstb_out, jtag_tx_scanen_out,
     jtag_weakpdn_out, jtag_weakpu_out, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, odirectout_data_out_chain1,
     ohssi_adapter_rx_pld_rst_n, odirectout_data_out_chain2, 
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_rxpma_rstb,
     ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_dcd_cal_done,
     ohssi_tx_dll_lock, ohssi_tx_transfer_clk,
     ohssirx_dcc_done, ojtag_clkdr_out_chain, ojtag_last_bs_out_chain,
     ojtag_rx_scan_out_chain, 
     por_aib_vcchssi_out, por_aib_vccl_out;

inout  aib0, aib1, aib2, aib3, aib4, aib5, aib6, aib7, aib8, aib9,
     aib10, aib11, aib12, aib13, aib14, aib15, aib16, aib17, aib18,
     aib19, aib20, aib21, aib22, aib23, aib24, aib25, aib26, aib27,
     aib28, aib29, aib30, aib31, aib32, aib33, aib34, aib35, aib36,
     aib37, aib38, aib39, aib40, aib41, aib42, aib43, aib44, aib45,
     aib46, aib47, aib48, aib49, aib50, aib51, aib52, aib53, aib54,
     aib55, aib56, aib57, aib58, aib59, aib60, aib61, aib62, aib63,
     aib64, aib65, aib66, aib67, aib68, aib69, aib70, aib71, aib72,
     aib73, aib74, aib75, aib76, aib77, aib78, aib79, aib80, aib81,
     aib82, aib83, aib84, aib85, aib86, aib87, aib88, aib89, aib90,
     aib91, aib92, aib93, aib94, aib95;

input  iatpg_bsr0_scan_in, iatpg_bsr0_scan_shift_clk,
     iatpg_bsr1_scan_in, iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, 
     ihssi_dcc_req, 
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pma_aib_tx_clk,
     ihssi_rx_transfer_clk, ihssi_sr_clk_out, ihssi_ssr_data_out,
     ihssi_ssr_load_out, ihssi_tx_dcd_cal_req, ihssi_tx_dll_lock_req,
     ijtag_clkdr_in_chain, ijtag_last_bs_in_chain,
     ijtag_tx_scan_in_chain, 
     irstb,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl;

output [12:0]  oaibdftdll2adjch;
output [12:0]  oaibdftdll2core;
output [39:0]  ohssi_tx_data_in;

input [7:0]  r_aib_csr_ctrl_42;
input [12:0]  iaibdftdll2adjch;
input [7:0]  r_aib_csr_ctrl_40;
input [7:0]  r_aib_csr_ctrl_36;
input [7:0]  r_aib_csr_ctrl_43;
input [7:0]  r_aib_csr_ctrl_52;
input [7:0]  r_aib_csr_ctrl_49;
input [7:0]  r_aib_csr_ctrl_45;
input [7:0]  r_aib_csr_ctrl_48;
input [7:0]  r_aib_csr_ctrl_44;
input [7:0]  r_aib_csr_ctrl_47;
input [39:0]  ihssi_rx_data_out;
input [7:0]  r_aib_csr_ctrl_34;
input [7:0]  r_aib_csr_ctrl_35;
input [7:0]  r_aib_dprio_ctrl_4;
input [2:1]  iaibdftcore2dll;
input [7:0]  r_aib_dprio_ctrl_1;
input [7:0]  r_aib_dprio_ctrl_0;
input [7:0]  r_aib_csr_ctrl_20;
input [7:0]  r_aib_csr_ctrl_19;
input [7:0]  r_aib_csr_ctrl_50;
input [7:0]  r_aib_csr_ctrl_53;
input [7:0]  r_aib_csr_ctrl_13;
input [7:0]  r_aib_csr_ctrl_17;
input [7:0]  r_aib_csr_ctrl_23;
input [7:0]  r_aib_csr_ctrl_12;
input [7:0]  r_aib_csr_ctrl_26;
input [7:0]  r_aib_dprio_ctrl_2;
input [7:0]  r_aib_csr_ctrl_29;
input [7:0]  r_aib_csr_ctrl_30;
input [7:0]  r_aib_csr_ctrl_24;
input [7:0]  r_aib_csr_ctrl_46;
input [7:0]  r_aib_csr_ctrl_39;
input [7:0]  r_aib_csr_ctrl_37;
input [7:0]  r_aib_csr_ctrl_38;
input [7:0]  r_aib_csr_ctrl_31;
input [7:0]  r_aib_csr_ctrl_18;
input [7:0]  r_aib_dprio_ctrl_3;
input [7:0]  r_aib_csr_ctrl_27;
input [7:0]  r_aib_csr_ctrl_41;
input [7:0]  r_aib_csr_ctrl_22;
input [7:0]  r_aib_csr_ctrl_51;
input [7:0]  r_aib_csr_ctrl_33;
input [7:0]  r_aib_csr_ctrl_32;
input [7:0]  r_aib_csr_ctrl_28;
input [7:0]  r_aib_csr_ctrl_21;
input [7:0]  r_aib_csr_ctrl_16;
input [7:0]  r_aib_csr_ctrl_15;
input [7:0]  r_aib_csr_ctrl_14;
input [7:0]  r_aib_csr_ctrl_11;
input [7:0]  r_aib_csr_ctrl_10;
input [7:0]  r_aib_csr_ctrl_9;
input [7:0]  r_aib_csr_ctrl_8;
input [7:0]  r_aib_csr_ctrl_7;
input [7:0]  r_aib_csr_ctrl_6;
input [7:0]  r_aib_csr_ctrl_5;
input [7:0]  r_aib_csr_ctrl_4;
input [7:0]  r_aib_csr_ctrl_3;
input [7:0]  r_aib_csr_ctrl_2;
input [7:0]  r_aib_csr_ctrl_1;
input [7:0]  r_aib_csr_ctrl_0;
input [7:0]  r_aib_csr_ctrl_25;
 
wire NC_AIB76, NC_AIB77, NC_AIB53 ; 
wire NC_AIB68, NC_AIB69, NC_AIB47; 

assign  aib47 = NC_AIB47;
assign  aib48 = NC_AIB76;
assign  aib55 = NC_AIB77;
assign  aib62 = NC_AIB53;
assign  aib68 = NC_AIB68;
assign  aib69 = NC_AIB69;

    aibcr3_top_wrp xaibcr3_top_wrp (
                                    // Outputs
                                    .jtag_clksel_out    (jtag_clksel_out), 
                                    .jtag_intest_out    (jtag_intest_out), 
                                    .jtag_mode_out      (jtag_mode_out), 
                                    .jtag_rstb_en_out   (jtag_rstb_en_out), 
                                    .jtag_rstb_out      (jtag_rstb_out), 
                                    .jtag_tx_scanen_out (jtag_tx_scanen_out), 
                                    .jtag_weakpdn_out   (jtag_weakpdn_out), 
                                    .jtag_weakpu_out    (jtag_weakpu_out), 
                                    .oatpg_bsr0_scan_out(oatpg_bsr0_scan_out), 
                                    .oatpg_bsr1_scan_out(oatpg_bsr1_scan_out), 
                                    .oatpg_bsr2_scan_out(oatpg_bsr2_scan_out), 
                                    .oatpg_bsr3_scan_out(oatpg_bsr3_scan_out), 
                                    .oatpg_scan_out0    (oatpg_scan_out0), 
                                    .oatpg_scan_out1    (oatpg_scan_out1), 
                                    .odirectout_data_out_chain1(odirectout_data_out_chain1), 
                                    .odirectout_data_out_chain2(odirectout_data_out_chain2), 
                                    .ohssi_adapter_rx_pld_rst_n(ohssi_adapter_rx_pld_rst_n),  //
                                    .ohssi_adapter_tx_pld_rst_n(), 
                                    .ohssi_fsr_data_in  (), 
                                    .ohssi_fsr_load_in  (), 
                                    .ohssi_pcs_rx_pld_rst_n(), 
                                    .ohssi_pcs_tx_pld_rst_n(), 
                                    .ohssi_pld_pma_coreclkin(ohssi_pld_pma_coreclkin), 
                                    .ohssi_pld_pma_coreclkin_n(),        
                                    .ohssi_pld_pma_rxpma_rstb(ohssi_pld_pma_rxpma_rstb), 
                                    .ohssi_pld_pma_txdetectrx(), 
                                    .ohssi_pld_pma_txpma_rstb(), 
                                    .ohssi_pld_sclk     (),   //
                                    .ohssi_sr_clk_in    (ohssi_sr_clk_in), 
                                    .ohssi_ssr_data_in  (ohssi_ssr_data_in), 
                                    .ohssi_ssr_load_in  (ohssi_ssr_load_in), 
                                    .ohssi_tx_dcd_cal_done(ohssi_tx_dcd_cal_done), 
                                    .ohssi_tx_dll_lock  (ohssi_tx_dll_lock), 
                                    .ohssi_tx_sr_clk_in (osc_clk_adpt), 
                                    .ohssi_tx_transfer_clk(ohssi_tx_transfer_clk), 
                                    .ohssirx_dcc_done   (ohssirx_dcc_done), 
                                    .ojtag_clkdr_out_chain(ojtag_clkdr_out_chain), 
                                    .ojtag_last_bs_out_chain(ojtag_last_bs_out_chain), 
                                    .ojtag_rx_scan_out_chain(ojtag_rx_scan_out_chain), 
                                    .ored_idataselb_out_chain1(),  //
                                    .ored_idataselb_out_chain2(), 
                                    .ored_shift_en_out_chain1(), 
                                    .ored_shift_en_out_chain2(), 
                                    .osc_clkout         (osc_clkout),     
                                    .otxen_out_chain1   (), 
                                    .otxen_out_chain2   (),  //
                                    .por_aib_vcchssi_out(por_aib_vcchssi_out), 
                                    .por_aib_vccl_out   (por_aib_vccl_out), 
                                    .oaibdftdll2adjch   (oaibdftdll2adjch), 
                                    .oaibdftdll2core    (oaibdftdll2core),  
                                    .oshared_direct_async_out(), 
                                    .ohssi_avmm1_data_in(), 
                                    .ohssi_avmm2_data_in(),  //
                                    .ohssi_tx_data_in   (ohssi_tx_data_in), 
                                    // Inouts
                                    .aib0               (aib20),       
                                    .aib1               (aib21),       
                                    .aib2               (aib22),       
                                    .aib3               (aib23),       
                                    .aib4               (aib24),       
                                    .aib5               (aib25),       
                                    .aib6               (aib26),       
                                    .aib7               (aib27),       
                                    .aib8               (aib28),       
                                    .aib9               (aib29),       
                                    .aib10              (aib30),      
                                    .aib11              (aib31),      
                                    .aib12              (aib32),      
                                    .aib13              (aib33),      
                                    .aib14              (aib34),      
                                    .aib15              (aib35),      
                                    .aib16              (aib36),      
                                    .aib17              (aib37),      
                                    .aib18              (aib38),      
                                    .aib19              (aib39),      
                                    .aib20              (aib0),      
                                    .aib21              (aib1),      
                                    .aib22              (aib2),      
                                    .aib23              (aib3),      
                                    .aib24              (aib4),      
                                    .aib25              (aib5),      
                                    .aib26              (aib6),      
                                    .aib27              (aib7),      
                                    .aib28              (aib8),      
                                    .aib29              (aib9),      
                                    .aib30              (aib10),      
                                    .aib31              (aib11),      
                                    .aib32              (aib12),      
                                    .aib33              (aib13),      
                                    .aib34              (aib14),      
                                    .aib35              (aib15),      
                                    .aib36              (aib16),      
                                    .aib37              (aib17),      
                                    .aib38              (aib18),      
                                    .aib39              (aib19),      
                                    .aib40              (aib42),      
                                    .aib41              (aib43),      
                                    .aib42              (aib40),      
                                    .aib43              (aib41),      
                                    .aib44              (aib49),      
                                    .aib45              (aib46),      
                                    .aib46              (aib45),      
                                    .aib47              (),      
                                    .aib48              (aib58),      
                                    .aib49              (aib44),      
                                    .aib50              (aib61),      
                                    .aib51              (aib80),      
                                    .aib52              (aib81),      
                                    .aib53              (),      
                                    .aib54              (aib64),      
                                    .aib55              (aib79),      
                                    .aib56              (aib65),      
                                    .aib57              (aib87),      
                                    .aib58              (aib76),      
                                    .aib59              (aib86),      
                                    .aib60              (aib78),      
                                    .aib61              (aib50),      
                                    .aib62              (aib63),      
                                    .aib63              (aib77),      
                                    .aib64              (aib60),      
                                    .aib65              (aib56),      
                                    .aib66              (aib67),      
                                    .aib67              (aib66),      
                                    .aib68              (),      
                                    .aib69              (),      
                                    .aib70              (aib88),      
                                    .aib71              (aib89),      
                                    .aib72              (aib75),      
                                    .aib73              (aib91),      
                                    .aib74              (aib90),      
                                    .aib75              (aib72),      
                                    .aib76              (),      
                                    .aib77              (),      
                                    .aib78              (aib51),      
                                    .aib79              (aib52),      
                                    .aib80              (aib53),      
                                    .aib81              (aib54),      
                                    .aib82              (aib84),      
                                    .aib83              (aib85),      
                                    .aib84              (aib82),      
                                    .aib85              (aib83),      
                                    .aib86              (aib59),      
                                    .aib87              (aib57),      
                                    .aib88              (aib70),      
                                    .aib89              (aib71),      
                                    .aib90              (aib74),      
                                    .aib91              (aib73),      
                                    .aib92              (aib94),      
                                    .aib93              (aib95),      
                                    .aib94              (aib92),      
                                    .aib95              (aib93),      
                                    // Inputs
                                    .iatpg_bsr0_scan_in (iatpg_bsr0_scan_in), 
                                    .iatpg_bsr0_scan_shift_clk(iatpg_bsr0_scan_shift_clk), 
                                    .iatpg_bsr1_scan_in (iatpg_bsr1_scan_in), 
                                    .iatpg_bsr1_scan_shift_clk(iatpg_bsr1_scan_shift_clk), 
                                    .iatpg_bsr2_scan_in (iatpg_bsr2_scan_in), 
                                    .iatpg_bsr2_scan_shift_clk(iatpg_bsr2_scan_shift_clk), 
                                    .iatpg_bsr3_scan_in (iatpg_bsr3_scan_in), 
                                    .iatpg_bsr3_scan_shift_clk(iatpg_bsr3_scan_shift_clk), 
                                    .iatpg_bsr_scan_shift_n(iatpg_bsr_scan_shift_n), 
                                    .iatpg_pipeline_global_en(iatpg_pipeline_global_en), 
                                    .iatpg_scan_clk_in0 (iatpg_scan_clk_in0), 
                                    .iatpg_scan_clk_in1 (iatpg_scan_clk_in1), 
                                    .iatpg_scan_in0     (iatpg_scan_in0), 
                                    .iatpg_scan_in1     (iatpg_scan_in1), 
                                    .iatpg_scan_mode_n  (iatpg_scan_mode_n), 
                                    .iatpg_scan_rst_n   (iatpg_scan_rst_n),  
                                    .iatpg_scan_shift_n (iatpg_scan_shift_n), 
                                    .idirectout_data_in_chain1(1'b0), 
                                    .idirectout_data_in_chain2(1'b0), 
                                    .ihssi_avmm1_data_out(1'b0), 
                                    .ihssi_avmm2_data_out(1'b0), 
                                    .ihssi_dcc_req      (ihssi_dcc_req), 
                                    .ihssi_fsr_data_out (1'b0), 
                                    .ihssi_fsr_load_out (1'b0), 
                                    .ihssi_pld_8g_rxelecidle(1'b0), 
                                    .ihssi_pld_pcs_rx_clk_out(1'b0), 
                                    .ihssi_pld_pcs_tx_clk_out(1'b0), 
                                    .ihssi_pld_pma_clkdiv_rx_user(ihssi_pld_pma_clkdiv_rx_user), 
                                    .ihssi_pld_pma_clkdiv_tx_user(ihssi_pld_pma_clkdiv_tx_user), 
                                    .ihssi_pld_pma_hclk (1'b1), // output to aib61. Has to be "1" for cr3, which is rx, Wei     
                                    .ihssi_pld_pma_internal_clk1(1'b0), 
                                    .ihssi_pld_pma_internal_clk2(1'b0), 
                                    .ihssi_pld_pma_pfdmode_lock(1'b0), 
                                    .ihssi_pld_pma_rxpll_lock(1'b0), 
                                    .ihssi_pld_rx_hssi_fifo_latency_pulse(1'b0), 
                                    .ihssi_pld_tx_hssi_fifo_latency_pulse(1'b0), 
                                    .ihssi_pma_aib_tx_clk(ihssi_pma_aib_tx_clk), 
                                    .ihssi_rx_transfer_clk(ihssi_rx_transfer_clk), 
                                    .ihssi_sr_clk_out   (ihssi_sr_clk_out), 
                                    .ihssi_ssr_data_out (ihssi_ssr_data_out), 
                                    .ihssi_ssr_load_out (ihssi_ssr_load_out), 
                                    .ihssi_tx_dcd_cal_req(ihssi_tx_dcd_cal_req), 
                                    .ihssi_tx_dll_lock_req(ihssi_tx_dll_lock_req), 
                                    .ijtag_clkdr_in_chain(ijtag_clkdr_in_chain), 
                                    .ijtag_last_bs_in_chain(ijtag_last_bs_in_chain), 
                                    .ijtag_tx_scan_in_chain(ijtag_tx_scan_in_chain), 
                                    .ired_idataselb_in_chain1(1'b0), 
                                    .ired_idataselb_in_chain2(1'b0), 
                                    .ired_shift_en_in_chain1(1'b0), 
                                    .ired_shift_en_in_chain2(1'b0), 
                                    .irstb              (irstb), 
                                    .itxen_in_chain1    (1'b0), 
                                    .itxen_in_chain2    (1'b0), 
                                    .jtag_clksel        (jtag_clksel), 
                                    .jtag_intest        (jtag_intest), 
                                    .jtag_mode_in       (jtag_mode_in), 
                                    .jtag_rstb          (jtag_rstb), 
                                    .jtag_rstb_en       (jtag_rstb_en), 
                                    .jtag_tx_scanen_in  (jtag_tx_scanen_in), 
                                    .jtag_weakpdn       (jtag_weakpdn), 
                                    .jtag_weakpu        (jtag_weakpu), 
                                    .osc_clkin          (osc_clkin),     
                                    .por_aib_vcchssi    (por_aib_vcchssi), 
                                    .por_aib_vccl       (por_aib_vccl), 
                                    .r_aib_csr_ctrl_42  (r_aib_csr_ctrl_42[7:0]), 
                                    .iaibdftdll2adjch   (iaibdftdll2adjch[12:0]), 
                                    .r_aib_csr_ctrl_40  (r_aib_csr_ctrl_40[7:0]), 
                                    .r_aib_csr_ctrl_36  (r_aib_csr_ctrl_36[7:0]), 
                                    .r_aib_csr_ctrl_43  (r_aib_csr_ctrl_43[7:0]), 
                                    .r_aib_csr_ctrl_52  (r_aib_csr_ctrl_52[7:0]), 
                                    .r_aib_csr_ctrl_49  (r_aib_csr_ctrl_49[7:0]), 
                                    .r_aib_csr_ctrl_45  (r_aib_csr_ctrl_45[7:0]), 
                                    .r_aib_csr_ctrl_48  (r_aib_csr_ctrl_48[7:0]), 
                                    .r_aib_csr_ctrl_44  (r_aib_csr_ctrl_44[7:0]), 
                                    .r_aib_csr_ctrl_47  (r_aib_csr_ctrl_47[7:0]), 
                                    .ihssi_rx_data_out  (ihssi_rx_data_out), 
                                    .r_aib_csr_ctrl_34  (r_aib_csr_ctrl_34[7:0]), 
                                    .r_aib_csr_ctrl_35  (r_aib_csr_ctrl_35[7:0]), 
                                    .r_aib_dprio_ctrl_4 (r_aib_dprio_ctrl_4[7:0]), 
                                    .iaibdftcore2dll    (iaibdftcore2dll), 
                                    .r_aib_dprio_ctrl_1 (r_aib_dprio_ctrl_1[7:0]), 
                                    .r_aib_dprio_ctrl_0 (r_aib_dprio_ctrl_0[7:0]), 
                                    .r_aib_csr_ctrl_20  (r_aib_csr_ctrl_20[7:0]), 
                                    .r_aib_csr_ctrl_19  (r_aib_csr_ctrl_19[7:0]), 
                                    .r_aib_csr_ctrl_50  (r_aib_csr_ctrl_50[7:0]), 
                                    .r_aib_csr_ctrl_53  (r_aib_csr_ctrl_53[7:0]), 
                                    .r_aib_csr_ctrl_13  (r_aib_csr_ctrl_13[7:0]), 
                                    .r_aib_csr_ctrl_17  (r_aib_csr_ctrl_17[7:0]), 
                                    .r_aib_csr_ctrl_23  (r_aib_csr_ctrl_23[7:0]), 
                                    .r_aib_csr_ctrl_12  (r_aib_csr_ctrl_12[7:0]), 
                                    .r_aib_csr_ctrl_26  (r_aib_csr_ctrl_26[7:0]), 
                                    .r_aib_dprio_ctrl_2 (r_aib_dprio_ctrl_2[7:0]), 
                                    .r_aib_csr_ctrl_29  (r_aib_csr_ctrl_29[7:0]), 
                                    .r_aib_csr_ctrl_30  (r_aib_csr_ctrl_30[7:0]), 
                                    .r_aib_csr_ctrl_24  (r_aib_csr_ctrl_24[7:0]), 
                                    .r_aib_csr_ctrl_46  (r_aib_csr_ctrl_46[7:0]), 
                                    .r_aib_csr_ctrl_39  (r_aib_csr_ctrl_39[7:0]), 
                                    .r_aib_csr_ctrl_37  (r_aib_csr_ctrl_37[7:0]), 
                                    .r_aib_csr_ctrl_38  (r_aib_csr_ctrl_38[7:0]), 
                                    .ishared_direct_async_in(5'b0), 
                                    .r_aib_csr_ctrl_31  (r_aib_csr_ctrl_31[7:0]), 
                                    .r_aib_csr_ctrl_18  (r_aib_csr_ctrl_18[7:0]), 
                                    .r_aib_dprio_ctrl_3 (r_aib_dprio_ctrl_3[7:0]), 
                                    .r_aib_csr_ctrl_27  (r_aib_csr_ctrl_27[7:0]), 
                                    .r_aib_csr_ctrl_41  (r_aib_csr_ctrl_41[7:0]), 
                                    .r_aib_csr_ctrl_22  (r_aib_csr_ctrl_22[7:0]), 
                                    .r_aib_csr_ctrl_51  (r_aib_csr_ctrl_51[7:0]), 
                                    .r_aib_csr_ctrl_33  (r_aib_csr_ctrl_33[7:0]), 
                                    .r_aib_csr_ctrl_32  (r_aib_csr_ctrl_32[7:0]), 
                                    .r_aib_csr_ctrl_28  (r_aib_csr_ctrl_28[7:0]), 
                                    .r_aib_csr_ctrl_21  (r_aib_csr_ctrl_21[7:0]), 
                                    .r_aib_csr_ctrl_16  (r_aib_csr_ctrl_16[7:0]), 
                                    .r_aib_csr_ctrl_15  (r_aib_csr_ctrl_15[7:0]), 
                                    .r_aib_csr_ctrl_14  (r_aib_csr_ctrl_14[7:0]), 
                                    .r_aib_csr_ctrl_11  (r_aib_csr_ctrl_11[7:0]), 
                                    .r_aib_csr_ctrl_10  (r_aib_csr_ctrl_10[7:0]), 
                                    .r_aib_csr_ctrl_9   (r_aib_csr_ctrl_9[7:0]), 
                                    .r_aib_csr_ctrl_8   (r_aib_csr_ctrl_8[7:0]), 
                                    .r_aib_csr_ctrl_7   (r_aib_csr_ctrl_7[7:0]), 
                                    .r_aib_csr_ctrl_6   (r_aib_csr_ctrl_6[7:0]), 
                                    .r_aib_csr_ctrl_5   (r_aib_csr_ctrl_5[7:0]), 
                                    .r_aib_csr_ctrl_4   (r_aib_csr_ctrl_4[7:0]), 
                                    .r_aib_csr_ctrl_3   (r_aib_csr_ctrl_3[7:0]), 
                                    .r_aib_csr_ctrl_2   (r_aib_csr_ctrl_2[7:0]), 
                                    .r_aib_csr_ctrl_1   (r_aib_csr_ctrl_1[7:0]), 
                                    .r_aib_csr_ctrl_0   (r_aib_csr_ctrl_0[7:0]), 
                                    .r_aib_csr_ctrl_25  (r_aib_csr_ctrl_25[7:0])); 

endmodule
