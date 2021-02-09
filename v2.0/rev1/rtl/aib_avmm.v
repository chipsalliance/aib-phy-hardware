// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation.
/////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------------------------------------------------------------
// Description: Channel Configuration Decoding
//
//
// Change log
// 1/26/2021
/////////////////////////////////////////////////////////////////////////////////////////

module aib_avmm (
  input [5:0]   cfg_avmm_addr_id, 
  input         cfg_avmm_clk,
  input         cfg_avmm_rst_n,
  input         cfg_avmm_write,
  input         cfg_avmm_read,
  input [16:0]  cfg_avmm_addr,
  input [31:0]  cfg_avmm_wdata,
  input [3:0]   cfg_avmm_byte_en,
  output [31:0] cfg_avmm_rdata,
  output        cfg_avmm_rdatavld,
  output        cfg_avmm_waitreq,

//Adapt control CSR
  output [31:0] rx_adapt_0,
  output [31:0] rx_adapt_1,
  output [31:0] tx_adapt_0,
  output [31:0] tx_adapt_1

//AIB IO control CSR
);

wire cfg_csr_clk, cfg_csr_reset;
wire cfg_csr_read,cfg_csr_write;
wire cfg_csr_rdatavld;
wire [31:0] cfg_csr_wdata, cfg_csr_rdata;
wire [6:0]  cfg_csr_addr;
wire [3:0]  cfg_csr_byteen; 

localparam AIB_BASE_BOT = 11'h200;
localparam AIB_BASE_TOP = 11'h400;

// Configuration registers for Adapter and AIBIO
assign cfg_only_id_match = (cfg_avmm_addr_id[5:0] == cfg_avmm_addr[16:11]);

assign cfg_only_addr_match = (cfg_avmm_addr[10:0] >= AIB_BASE_BOT) & (cfg_avmm_addr[10:0] < AIB_BASE_TOP) & cfg_only_id_match;
assign cfg_only_write      = cfg_only_addr_match & cfg_avmm_write;
assign cfg_only_read       = cfg_only_addr_match & cfg_avmm_read;


aib_avmm_rdl_intf #( .AVMM_ADDR_WIDTH(8), .RDL_ADDR_WIDTH (7))
  adapt_cfg_rdl_intf (
   .avmm_clk            (cfg_avmm_clk),        // input   logic  // AVMM Slave interface
   .avmm_rst_n          (cfg_avmm_rst_n),      // input   logic
   .i_avmm_write        (cfg_only_write),      // input   logic
   .i_avmm_read         (cfg_only_read),       // input   logic
   .i_avmm_addr         (cfg_avmm_addr[7:0]),  // input   logic  [AVMM_ADDR_WIDTH-1:0]
   .i_avmm_wdata        (cfg_avmm_wdata),      // input   logic  [31:0]
   .i_avmm_byte_en      (cfg_avmm_byte_en),    // input   logic  [3:0]
   .o_avmm_rdata        (cfg_avmm_rdata),      // output  logic  [31:0]
   .o_avmm_rdatavalid   (cfg_avmm_rdatavld),   // output  logic
   .o_avmm_waitrequest  (cfg_avmm_waitreq),    // output  logic
   .clk                 (cfg_csr_clk),         // output  logic  // RDL-generated memory map interface
   .reset               (cfg_csr_reset),       // output  logic
   .writedata           (cfg_csr_wdata),       // output  logic  [31:0]
   .read                (cfg_csr_read),        // output  logic
   .write               (cfg_csr_write),       // output  logic
   .byteenable          (cfg_csr_byteen),      // output  logic  [3:0]
   .readdata            (cfg_csr_rdata),       // input   logic  [31:0]
   .readdatavalid       (cfg_csr_rdatavld),    // input   logic
   .address             (cfg_csr_addr)         // output  logic  [RDL_ADDR_WIDTH-1:0]
);


aib_avmm_adapt_csr adapt_csr (
       .rx_0(rx_adapt_0),
       .rx_1(rx_adapt_1),
       .tx_0(tx_adapt_0),
       .tx_1(tx_adapt_1),

       .clk(cfg_csr_clk),
       .reset(cfg_csr_reset),
       .writedata(cfg_csr_wdata),
       .read(cfg_csr_read),
       .write(cfg_csr_write),
       .byteenable(cfg_csr_byteen),
       .readdata(cfg_csr_rdata),
       .readdatavalid(cfg_csr_rdatavld),
       .address(cfg_csr_addr)

);
//////////////////////////////////////
/* TBD by BCA                       */
///////////////////////////////////////

/*
aib_avmm_aibio_csr aibio_csr (
  .r_cfg_outbox_cfg_msg              (r_cfg_outbox_cfg_msg),
  .r_cfg_outbox_send_msg             (r_cfg_outbox_send_msg),
  .r_cfg_inbox_cfg_msg               (r_cfg_inbox_cfg_msg),
  .r_cfg_inbox_autoclear_dis         (r_cfg_inbox_autoclear_dis),
  .r_cfg_inbox_new_msg               (r_cfg_inbox_new_msg),
  .r_cfg_inbox_cfg_msg_i             (r_cfg_inbox_cfg_msg_i),
  .r_cfg_outbox_send_msg_i           (r_cfg_outbox_send_msg_i),
  .r_cfg_inbox_new_msg_i             (r_cfg_inbox_new_msg_i),
  .r_ifctl_usr_active                (w_ifctl_usr_active),
  .r_ifctl_mcast_addr                (r_ifctl_mcast_addr),
  .r_ifctl_mcast_en                  (r_ifctl_mcast_en),
  .r_ifctl_hwcfg_mode                (r_ifctl_hwcfg_mode),
  .r_ifctl_hwcfg_adpt_en             (r_ifctl_hwcfg_adpt_en),
  .r_ifctl_hwcfg_aib_en              (r_ifctl_hwcfg_aib_en),
  .r_rstctl_tx_elane_ovrval          (w_rstctl_tx_elane_ovrval),
  .r_rstctl_tx_elane_ovren           (w_rstctl_tx_elane_ovren),
  .r_rstctl_rx_elane_ovrval          (w_rstctl_rx_elane_ovrval),
  .r_rstctl_rx_elane_ovren           (w_rstctl_rx_elane_ovren),
  .r_rstctl_tx_xcvrif_ovrval         (w_rstctl_tx_xcvrif_ovrval),
  .r_rstctl_tx_xcvrif_ovren          (w_rstctl_tx_xcvrif_ovren),
  .r_rstctl_rx_xcvrif_ovrval         (w_rstctl_rx_xcvrif_ovrval),
  .r_rstctl_rx_xcvrif_ovren          (w_rstctl_rx_xcvrif_ovren),
  .r_rstctl_tx_adpt_ovrval           (w_rstctl_tx_adpt_ovrval),
  .r_rstctl_tx_adpt_ovren            (w_rstctl_tx_adpt_ovren),
                                                               
  .r_rstctl_rx_adpt_ovrval           (w_rstctl_rx_adpt_ovrval),
  .r_rstctl_rx_adpt_ovren            (w_rstctl_rx_adpt_ovren),
  .r_rstctl_tx_pld_div2_rst_opt      (w_rstctl_tx_pld_div2_rst_opt),
  .r_avmm_testbus_sel                (w_avmm_testbus_sel),
  .r_avmm_hrdrst_osc_clk_scg_en      (w_avmm_hrdrst_osc_clk_scg_en),
  .r_avmm_spare_rsvd                 (w_avmm_spare_rsvd),
  .r_avmm_spare_rsvd_prst            (w_avmm_spare_rsvd_prst),
  .r_sr_hip_en                       (w_sr_hip_en),
  .r_sr_reserbits_in_en              (w_sr_reserbits_in_en),
  .r_sr_reserbits_out_en             (w_sr_reserbits_out_en),
  .r_sr_parity_en                    (w_sr_parity_en),
  .r_sr_osc_clk_scg_en               (w_sr_osc_clk_scg_en),
  .r_sr_osc_clk_div_sel              (w_sr_osc_clk_div_sel),
  .r_sr_free_run_div_clk             (w_sr_free_run_div_clk),
  .r_avmm1_sr_test_enable            (w_sr_test_enable),
  .r_avmm1_osc_clk_scg_en            (w_avmm1_osc_clk_scg_en),
  .r_avmm1_avmm_clk_scg_en           (w_avmm1_avmm_clk_scg_en),
  .r_avmm1_avmm_clk_dcg_en           (w_avmm1_avmm_clk_dcg_en),
  .r_avmm1_free_run_div_clk          (w_avmm1_free_run_div_clk),
  .r_avmm1_rdfifo_full               (w_avmm1_rdfifo_full),
  .r_avmm1_rdfifo_stop_read          (w_avmm1_rdfifo_stop_read),
  .r_avmm1_rdfifo_stop_write         (w_avmm1_rdfifo_stop_write),
  .r_avmm1_rdfifo_empty              (w_avmm1_rdfifo_empty),
  .r_avmm1_use_rsvd_bit1             (w_avmm1_use_rsvd_bit1),
  .r_avmm2_osc_clk_scg_en            (w_avmm2_osc_clk_scg_en),
  .r_avmm2_avmm_clk_scg_en           (w_avmm2_avmm_clk_scg_en),
  .r_avmm2_avmm_clk_dcg_en           (w_avmm2_avmm_clk_dcg_en),
  .r_avmm2_free_run_div_clk          (w_avmm2_free_run_div_clk),
  .r_avmm2_rdfifo_full               (w_avmm2_rdfifo_full),
  .r_avmm2_rdfifo_stop_read          (w_avmm2_rdfifo_stop_read),
  .r_avmm2_rdfifo_stop_write         (w_avmm2_rdfifo_stop_write),
  .r_avmm2_rdfifo_empty              (w_avmm2_rdfifo_empty),
  .r_aib_csr0_aib_csr0_ctrl_0        (w_aib_csr_ctrl_0),
  .r_aib_csr0_aib_csr0_ctrl_1        (w_aib_csr_ctrl_1),
  .r_aib_csr0_aib_csr0_ctrl_2        (w_aib_csr_ctrl_2),
  .r_aib_csr0_aib_csr0_ctrl_3        (w_aib_csr_ctrl_3),
  .r_aib_csr1_aib_csr1_ctrl_4        (w_aib_csr_ctrl_4),
  .r_aib_csr1_aib_csr1_ctrl_5        (w_aib_csr_ctrl_5),
  .r_aib_csr1_aib_csr1_ctrl_6        (w_aib_csr_ctrl_6),
  .r_aib_csr1_aib_csr1_ctrl_7        (w_aib_csr_ctrl_7),
  .r_aib_csr2_aib_csr2_ctrl_8        (w_aib_csr_ctrl_8),
  .r_aib_csr2_aib_csr2_ctrl_9        (w_aib_csr_ctrl_9),
  .r_aib_csr2_aib_csr2_ctrl_10       (w_aib_csr_ctrl_10),
  .r_aib_csr2_aib_csr2_ctrl_11       (w_aib_csr_ctrl_11),
  .r_aib_csr3_aib_csr3_ctrl_12       (w_aib_csr_ctrl_12),
  .r_aib_csr3_aib_csr3_ctrl_13       (w_aib_csr_ctrl_13),
  .r_aib_csr3_aib_csr3_ctrl_14       (w_aib_csr_ctrl_14),
  .r_aib_csr3_aib_csr3_ctrl_15       (w_aib_csr_ctrl_15),
  .r_aib_csr4_aib_csr4_ctrl_16       (w_aib_csr_ctrl_16),
  .r_aib_csr4_aib_csr4_ctrl_17       (w_aib_csr_ctrl_17),
  .r_aib_csr4_aib_csr4_ctrl_18       (w_aib_csr_ctrl_18),
  .r_aib_csr4_aib_csr4_ctrl_19       (w_aib_csr_ctrl_19),
  .r_aib_csr5_aib_csr5_ctrl_20       (w_aib_csr_ctrl_20),
  .r_aib_csr5_aib_csr5_ctrl_21       (w_aib_csr_ctrl_21),
  .r_aib_csr5_aib_csr5_ctrl_22       (w_aib_csr_ctrl_22),
  .r_aib_csr5_aib_csr5_ctrl_23       (w_aib_csr_ctrl_23),
  .r_aib_csr6_aib_csr6_ctrl_24       (w_aib_csr_ctrl_24),
  .r_aib_csr6_aib_csr6_ctrl_25       (w_aib_csr_ctrl_25),
  .r_aib_csr6_aib_csr6_ctrl_26       (w_aib_csr_ctrl_26),
  .r_aib_csr6_aib_csr6_ctrl_27       (w_aib_csr_ctrl_27),
  .r_aib_csr7_aib_csr7_ctrl_28       (w_aib_csr_ctrl_28),
  .r_aib_csr7_aib_csr7_ctrl_29       (w_aib_csr_ctrl_29),
  .r_aib_csr7_aib_csr7_ctrl_30       (w_aib_csr_ctrl_30),
  .r_aib_csr7_aib_csr7_ctrl_31       (w_aib_csr_ctrl_31),
  .r_aib_csr8_aib_csr8_ctrl_32       (w_aib_csr_ctrl_32),
  .r_aib_csr8_aib_csr8_ctrl_33       (w_aib_csr_ctrl_33),
  .r_aib_csr8_aib_csr8_ctrl_34       (w_aib_csr_ctrl_34),
  .r_aib_csr8_aib_csr8_ctrl_35       (w_aib_csr_ctrl_35),
  .r_aib_csr9_aib_csr9_ctrl_36       (w_aib_csr_ctrl_36),
  .r_aib_csr9_aib_csr9_ctrl_37       (w_aib_csr_ctrl_37),
  .r_aib_csr9_aib_csr9_ctrl_38       (w_aib_csr_ctrl_38),
  .r_aib_csr9_aib_csr9_ctrl_39       (w_aib_csr_ctrl_39),
  .r_aib_csr10_aib_csr10_ctrl_4x     (w_aib_csr_ctrl10_4x),
  .r_aib_csr11_aib_csr11_ctrl_4x     (w_aib_csr_ctrl11_4x),
  .r_aib_csr12_aib_csr12_ctrl_4x     (w_aib_csr_ctrl12_4x),
  .r_aib_csr13_aib_csr13_ctrl_5x     (w_aib_csr_ctrl13_5x),
  .r_avmm_spare_rsvd_i               (w_avmm_spare_rsvd),
  .r_avmm_spare_rsvd_prst_i          (w_avmm_spare_rsvd_prst),

  .clk                               (cfg_csr_clk),
  .reset                             (cfg_csr_reset),
  .writedata                         (cfg_csr_wdata),
  .read                              (cfg_csr_read),
  .write                             (cfg_csr_write),
  .byteenable                        (cfg_csr_byteen),
  .readdata                          (cfg_csr_rdata),
  .readdatavalid                     (cfg_csr_rdatavld),
  .address                           (cfg_csr_addr));
*/

endmodule
