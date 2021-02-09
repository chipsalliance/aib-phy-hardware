// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    :aib_adapt 
// Revision       :1.0
// ============================================================================


module aib_adapt (
output wire  [77:0]              data_out, //to mac
output wire  [39:0]              dout,     //to IO buffer 
output wire                      m_rxfifo_align_done,
input  wire  [39:0]	         din,      //from IO buffer	
input  wire  [77:0]              data_in,  //from mac

input          m_ns_fwd_clk,
input          m_ns_fwd_div2_clk,
input          m_ns_rcv_clk,
input          m_wr_clk,
input          m_rd_clk,
input          fs_fwd_clk,
input          fs_rcv_clk,
input          conf_done,
input          ms_rx_dcc_dll_lock_req,
input          ms_tx_dcc_dll_lock_req,
input          sl_tx_dcc_dll_lock_req,
input          sl_rx_dcc_dll_lock_req,
input          tx_dcc_cal_done,
input          rx_dll_lock,
output wire    ns_fwd_clk,
output wire    ns_fwd_div2_clk,
output wire    ns_rcv_clk,
output wire    conf_done_o,
output wire    m_fs_fwd_clk,
output reg     m_fs_fwd_div2_clk,
output wire    m_fs_rcv_clk,
output reg     m_fs_rcv_div2_clk,
output wire    ms_tx_transfer_en,
output wire    ms_rx_transfer_en,
output wire    sl_tx_transfer_en,
output wire    sl_rx_transfer_en,
output wire    tx_dcc_cal_req,
output wire    rx_dll_lock_req,
output wire    sr_clk_out,
output wire    std_out,
output wire    stl_out,
output wire    fs_mac_rdy,
output wire [80:0] ms_sideband,
output wire [72:0] sl_sideband,
output wire    ns_mac_rdyo,
output wire    ns_adapter_rstno,

input          adapter_rstni,
input          ns_adapter_rstn, //ns_adapter_rstn
input          ns_mac_rdy, //ns_mac_rdy 
input          dual_mode_select,
input          i_osc_clk, //from aux channel

input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register

  // AIB
  input  wire [1:0]                 i_aib_avmm1_data,
  input  wire                       i_aib_ssr_data,
  input  wire                       i_aib_ssr_load,
  input  wire                       sr_clk_in,
  input  wire                       srd_in,
  input  wire                       srl_in,
  input  wire                       aib_fs_mac_rdy,
  input  wire                       i_aib_tx_transfer_clk,    

  // Config
  input  wire                       i_adpt_hard_rst_n,        // Hard reset replaces i_csr_rdy_dly

  output wire                       o_adpt_cfg_clk,
  output wire                       o_adpt_cfg_rst_n,         // config reset to Adapter in next channel
  output wire [16:0]                o_adpt_cfg_addr,
  output wire [31:0]                o_adpt_cfg_wdata,
  output wire                       o_adpt_cfg_write,
  output wire                       o_adpt_cfg_read,
  output wire [3:0]                 o_adpt_cfg_byte_en,
  input  wire [31:0]                i_adpt_cfg_rdata,
  input  wire                       i_adpt_cfg_rdatavld,
  input  wire                       i_adpt_cfg_waitreq,

  // CRSSM AVMM
  input  wire [5:0]                 i_cfg_avmm_addr_id,
  input  wire                       i_cfg_avmm_clk,
  input  wire                       i_cfg_avmm_rst_n,         // config reset replaces i_csr_rdy
  input  wire [16:0]                i_cfg_avmm_addr,
  input  wire [31:0]                i_cfg_avmm_wdata,
  input  wire                       i_cfg_avmm_write,
  input  wire                       i_cfg_avmm_read,
  input  wire [3:0]                 i_cfg_avmm_byte_en,
  output wire [31:0]                o_cfg_avmm_rdata,
  output wire                       o_cfg_avmm_rdatavld,
  output wire                       o_cfg_avmm_waitreq,
  // AIB
  output  wire [7:0]                o_aib_csr_ctrl_0,
  output  wire [7:0]                o_aib_csr_ctrl_1,
  output  wire [7:0]                o_aib_csr_ctrl_10,
  output  wire [7:0]                o_aib_csr_ctrl_11,
  output  wire [7:0]                o_aib_csr_ctrl_12,
  output  wire [7:0]                o_aib_csr_ctrl_13,
  output  wire [7:0]                o_aib_csr_ctrl_14,
  output  wire [7:0]                o_aib_csr_ctrl_15,
  output  wire [7:0]                o_aib_csr_ctrl_16,
  output  wire [7:0]                o_aib_csr_ctrl_17,
  output  wire [7:0]                o_aib_csr_ctrl_18,
  output  wire [7:0]                o_aib_csr_ctrl_19,
  output  wire [7:0]                o_aib_csr_ctrl_2,
  output  wire [7:0]                o_aib_csr_ctrl_20,
  output  wire [7:0]                o_aib_csr_ctrl_21,
  output  wire [7:0]                o_aib_csr_ctrl_22,
  output  wire [7:0]                o_aib_csr_ctrl_23,
  output  wire [7:0]                o_aib_csr_ctrl_24,
  output  wire [7:0]                o_aib_csr_ctrl_25,
  output  wire [7:0]                o_aib_csr_ctrl_26,
  output  wire [7:0]                o_aib_csr_ctrl_27,
  output  wire [7:0]                o_aib_csr_ctrl_28,
  output  wire [7:0]                o_aib_csr_ctrl_29,
  output  wire [7:0]                o_aib_csr_ctrl_3,
  output  wire [7:0]                o_aib_csr_ctrl_30,
  output  wire [7:0]                o_aib_csr_ctrl_31,
  output  wire [7:0]                o_aib_csr_ctrl_32,
  output  wire [7:0]                o_aib_csr_ctrl_33,
  output  wire [7:0]                o_aib_csr_ctrl_34,
  output  wire [7:0]                o_aib_csr_ctrl_35,
  output  wire [7:0]                o_aib_csr_ctrl_36,
  output  wire [7:0]                o_aib_csr_ctrl_37,
  output  wire [7:0]                o_aib_csr_ctrl_38,
  output  wire [7:0]                o_aib_csr_ctrl_39,
  output  wire [7:0]                o_aib_csr_ctrl_4,
  output  wire [7:0]                o_aib_csr_ctrl_40,
  output  wire [7:0]                o_aib_csr_ctrl_41,
  output  wire [7:0]                o_aib_csr_ctrl_42,
  output  wire [7:0]                o_aib_csr_ctrl_43,
  output  wire [7:0]                o_aib_csr_ctrl_44,
  output  wire [7:0]                o_aib_csr_ctrl_45,
  output  wire [7:0]                o_aib_csr_ctrl_46,
  output  wire [7:0]                o_aib_csr_ctrl_47,
  output  wire [7:0]                o_aib_csr_ctrl_48,
  output  wire [7:0]                o_aib_csr_ctrl_49,
  output  wire [7:0]                o_aib_csr_ctrl_5,
  output  wire [7:0]                o_aib_csr_ctrl_50,
  output  wire [7:0]                o_aib_csr_ctrl_51,
  output  wire [7:0]                o_aib_csr_ctrl_52,
  output  wire [7:0]                o_aib_csr_ctrl_53,
  output  wire [7:0]                o_aib_csr_ctrl_6,
  output  wire [7:0]                o_aib_csr_ctrl_7,
  output  wire [7:0]                o_aib_csr_ctrl_8,
  output  wire [7:0]                o_aib_csr_ctrl_9,
  output  wire [7:0]                o_aib_dprio_ctrl_0,
  output  wire [7:0]                o_aib_dprio_ctrl_1,
  output  wire [7:0]                o_aib_dprio_ctrl_2,
  output  wire [7:0]                o_aib_dprio_ctrl_3,
  output  wire [7:0]                o_aib_dprio_ctrl_4,

  // DFT
  input   wire [1:0]                i_dftcore2dll,
  input   wire [12:0]               i_aibdftdll2core,
  output  wire [1:0]                o_aibdftcore2dll,
  output  wire [12:0]               o_dftdll2core,

  input   wire                      i_scan_mode_n,

  input   wire [`TCM_WRAP_CTRL_RNG] i_avmm1_tst_tcm_ctrl,
  input   wire                      i_avmm1_test_clk,
  input   wire                      i_avmm1_scan_clk,

  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_0_tst_tcm_ctrl,
  input   wire                      i_txchnl_0_test_clk,
  input   wire                      i_txchnl_0_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_1_tst_tcm_ctrl,
  input   wire                      i_txchnl_1_test_clk,
  input   wire                      i_txchnl_1_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_2_tst_tcm_ctrl,
  input   wire                      i_txchnl_2_test_clk,
  input   wire                      i_txchnl_2_scan_clk,

  input   wire [`TCM_WRAP_CTRL_RNG] i_rxchnl_tst_tcm_ctrl,
  input   wire                      i_rxchnl_test_clk,
  input   wire                      i_rxchnl_scan_clk,

  input   wire                      i_scan_rst_n,

  input   wire                      scan_clk,
  input   wire                      scan_enable,
  input   wire [19:0]               scan_in,
  output  wire [19:0]               scan_out);

wire        is_master, is_slave;
wire        dig_rstb;
wire        ms_osc_transfer_en;
wire        ms_osc_transfer_alive;
wire        ms_rx_async_rst;
wire        ms_rx_dll_lock_req;
wire        ms_rx_dll_lock;
wire        ms_tx_async_rst;
wire        ms_tx_dcc_cal_req;
wire        ms_tx_dcc_cal_done;
wire        sl_osc_transfer_en;
wire        sl_tx_dcc_cal_done;
wire        sl_tx_dcc_cal_req;
wire        sl_rx_async_rst;
wire        sl_rx_dll_lock_req;
wire        sl_rx_dll_lock;

wire        sr_ms_load_out;


wire        adpt_rstn;

wire        sr_ms_data_out;
wire [80:0] ms_data_fr_core, ms_data_to_core;
wire [72:0] sl_data_fr_core, sl_data_to_core;
wire        sr_sl_data_out;
wire        sr_sl_load_out;
wire        dcc_clk_out;
//
wire [79:0]      rx_fifo_data_out;
wire [39:0]      reg_dout;
wire [1:0]       r_rx_fifo_mode;
wire             r_rx_lpbk;
wire [1:0]       r_tx_fifo_mode;
wire [2:0]       r_rx_phcomp_rd_delay;
wire [2:0]       r_tx_phcomp_rd_delay;
wire [1:0]       r_tx_adapter_lpbk_mode;
wire [1:0]       r_tx_fifo_rd_clk_sel;
wire [2:0]       rxswap_en, txswap_en;

wire             rxfifo_wrclk;
wire             adpt_rstn_sync_fsfwdclk, adpt_rstn_sync_fsrcvclk;
wire             r_rx_double_read, r_rx_wa_en, r_rx_wr_adj_en;
wire             r_rx_rd_adj_en, r_tx_double_write, r_tx_wm_en;
wire             r_tx_wr_adj_en, r_tx_rd_adj_en, sr_sl_clk_out;
wire             o_aib_bsr_scan_shift_clk, o_adpt_hard_rst_n, r_rx_aib_lpbk_en;
wire             ms_tx_transfer_en_m, ms_rx_transfer_en_m;
wire             sl_tx_transfer_en_s, sl_rx_transfer_en_s;

assign o_aibdftcore2dll[1:0] = i_dftcore2dll[1:0];
assign o_dftdll2core[12:0] = i_aibdftdll2core[12:0];

assign ms_tx_transfer_en = dual_mode_select ? ms_tx_transfer_en_m : ms_data_to_core[78];
assign ms_rx_transfer_en = dual_mode_select ? ms_rx_transfer_en_m : ms_data_to_core[75];
assign sl_tx_transfer_en = !dual_mode_select ? sl_tx_transfer_en_s : sl_data_to_core[64];
assign sl_rx_transfer_en = !dual_mode_select ? sl_rx_transfer_en_s : sl_data_to_core[70];

assign o_adpt_cfg_clk = i_cfg_avmm_clk;
assign o_adpt_cfg_rst_n = i_cfg_avmm_rst_n;
assign o_adpt_cfg_addr[16:0] = i_cfg_avmm_addr[16:0];
assign o_adpt_cfg_wdata[31:0] = i_cfg_avmm_wdata[31:0];
assign o_adpt_cfg_byte_en[3:0] = i_cfg_avmm_byte_en[3:0];


assign m_fs_fwd_clk = fs_fwd_clk;
assign ns_rcv_clk = m_ns_rcv_clk;
assign ns_fwd_div2_clk = m_ns_fwd_div2_clk;
assign conf_done_o = conf_done;

aib_rstnsync adptrstn_sync_fsfwdclk
  (
    .clk(fs_fwd_clk),            // Destination clock of reset to be synced
    .i_rst_n(adpt_rstn),        // Asynchronous reset input
    .scan_mode(1'b0),      // Scan bypass for reset
    .sync_rst_n(adpt_rstn_sync_fsfwdclk)      // Synchronized reset output

   );


always @(posedge fs_fwd_clk or negedge adpt_rstn_sync_fsfwdclk)
begin
 if (!adpt_rstn_sync_fsfwdclk)
  begin
   m_fs_fwd_div2_clk <=1'b0;
  end
 else
  m_fs_fwd_div2_clk <= !m_fs_fwd_div2_clk;
end

assign m_fs_rcv_clk = fs_rcv_clk;

aib_rstnsync adptrstn_sync_fsrcvclk
  (
    .clk(fs_rcv_clk),            // Destination clock of reset to be synced
    .i_rst_n(adpt_rstn),        // Asynchronous reset input
    .scan_mode(1'b0),      // Scan bypass for reset
    .sync_rst_n(adpt_rstn_sync_fsrcvclk)      // Synchronized reset output

   );

always @(posedge fs_rcv_clk or negedge adpt_rstn_sync_fsrcvclk)
begin
 if (!adpt_rstn_sync_fsrcvclk)
  begin
   m_fs_rcv_div2_clk <=1'b0;
  end
 else
  m_fs_rcv_div2_clk <= !m_fs_rcv_div2_clk;
end

assign fs_mac_rdy = aib_fs_mac_rdy;
assign ms_sideband[80:0] = ms_data_to_core[80:0];
assign sl_sideband[72:0] = sl_data_to_core[72:0];

assign is_master = (dual_mode_select == 1'b1) ? 1'b1 : 1'b0;
assign is_slave = !is_master;

assign tx_dcc_cal_req = dual_mode_select ? ms_tx_dcc_cal_req : sl_tx_dcc_cal_req;
assign rx_dll_lock_req = dual_mode_select ? ms_rx_dll_lock_req : sl_rx_dll_lock_req;

assign adpt_rstn =  ns_adapter_rstn & adapter_rstni;

assign dig_rstb =  conf_done;

assign sr_clk_out = i_osc_clk; 
assign std_out = is_master ? sr_ms_data_out : sr_sl_data_out;
assign stl_out = is_master ? sr_ms_load_out : sr_sl_load_out;

assign ns_adapter_rstno = ns_adapter_rstn; 
assign ns_mac_rdyo = ns_mac_rdy;

assign ms_data_fr_core[80:0] = {ms_osc_transfer_en,1'b1,ms_tx_transfer_en_m,2'b11,ms_rx_transfer_en_m,ms_rx_dll_lock, 5'b11111,ms_tx_dcc_cal_done,1'b0,1'b1, ms_external_cntl_65_8[57:0], 1'b1, 1'b0, 1'b1, ms_external_cntl_4_0[4:0]}; 

assign sl_data_fr_core[72:0] = {sl_osc_transfer_en,1'b0,sl_rx_transfer_en_s,sl_rx_dcc_dll_lock_req, sl_rx_dll_lock,3'b0,sl_tx_transfer_en_s,sl_tx_dcc_dll_lock_req, 1'b0,1'b0,1'b1,1'b0, 1'b1, sl_external_cntl_57_32[25:0], sl_tx_dcc_cal_done, sl_external_cntl_30_28[2:0], 1'b0, sl_external_cntl_26_0[26:0]}; 

aib_adapt_rxchnl aib_adapt_rxchnl(
   // Outputs
     .data_out(data_out[77:0]),
     .rx_fifo_data_out_sel(rx_fifo_data_out[79:0]),
     .reg_dout(reg_dout[39:0]),
     .align_done(m_rxfifo_align_done),
     .rxfifo_wrclk(rxfifo_wrclk),
   // Inputs
     .atpg_mode(1'b0),
     .rxswap_en(rxswap_en[0]),
     .adapt_rstn(adpt_rstn),
     .din(din[39:0]),   //from io buffer
     .dout(dout[39:0]),  //loopback data from tx to io buffer
     .ns_fwd_clk(m_ns_fwd_clk), //loopback clock from tx
     .fs_fwd_clk(fs_fwd_clk), 
     .m_rd_clk(m_rd_clk), 
     .rx_fifo_latency_adj_en(1'b0),
     .r_rx_double_read(r_rx_double_read),
     .r_rx_fifo_mode(r_rx_fifo_mode[1:0]),
     .r_rx_lpbk(r_rx_lpbk),
     .r_rx_phcomp_rd_delay(r_rx_phcomp_rd_delay[2:0]),
     .r_rx_wa_en(r_rx_wa_en),
     .r_rx_wr_adj_en(r_rx_wr_adj_en), 
     .r_rx_rd_adj_en(r_rx_rd_adj_en)
   );

aib_adapt_txchnl aib_adapt_txchnl(
   // Outputs
     .dout(dout[39:0]), 
     .ns_fwd_clk(ns_fwd_clk),
   // Inputs
     .atpg_mode(1'b0),
     .txswap_en(txswap_en[0]),
     .adapt_rstn(adpt_rstn),
     .m_wr_clk(m_wr_clk),
     .m_ns_fwd_clk(m_ns_fwd_clk),
     .rxfifo_wrclk(rxfifo_wrclk),
     .data_in(data_in[77:0]),
     .rx_fifo_data_out(rx_fifo_data_out[79:0]), //loopback data from rx fifo mode
     .rx_reg_dout(reg_dout[39:0]),      //loopback data from rx reg mode
     .din(din[39:0]),              
     .m_rd_clk(m_rd_clk),         
     .fs_fwd_clk(fs_fwd_clk),       //loopback clock for rx reg mode loopback
     .r_tx_double_write(r_tx_double_write),
     .r_tx_fifo_mode(r_tx_fifo_mode[1:0]),
     .r_tx_adapter_lpbk_mode(r_tx_adapter_lpbk_mode[1:0]),
     .r_tx_phcomp_rd_delay(r_tx_phcomp_rd_delay[2:0]),
     .r_tx_wm_en(r_tx_wm_en),
     .r_tx_wr_adj_en(r_tx_wr_adj_en),
     .r_tx_rd_adj_en(r_tx_rd_adj_en),
     .r_tx_fifo_latency_adj_en(1'b0)
   );


aib_sm  aib_sm
   (
    .osc_clk(i_osc_clk),    //from aux 
    .sr_ms_clk_in(sr_clk_in), //input ms clock
    .ms_config_done(conf_done),   //master config done
    .ms_osc_transfer_en(ms_osc_transfer_en),
    .ms_rx_transfer_en(ms_rx_transfer_en_m),
    .ms_osc_transfer_alive(ms_osc_transfer_alive),
    .ms_rx_async_rst(ms_rx_async_rst),
    .ms_rx_dll_lock_req(ms_rx_dll_lock_req),
    .ms_rx_dll_lock(ms_rx_dll_lock),
    .ms_tx_async_rst(ms_tx_async_rst),
    .ms_tx_dcc_cal_req(ms_tx_dcc_cal_req),
    .sl_tx_dcc_cal_req(sl_tx_dcc_cal_req),
    .ms_tx_dcc_cal_done(ms_tx_dcc_cal_done),
    .ms_tx_transfer_en(ms_tx_transfer_en_m),
    .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
    .ms_rx_dll_lockint(rx_dll_lock),   
    .ms_tx_dcc_cal_doneint(tx_dcc_cal_done),
    .ms_tx_dcc_cal_donei(ms_data_to_core[68]),
    .ms_rx_dll_locki(ms_data_to_core[74]),   
    .ms_rx_transfer_eni(ms_data_to_core[75]),
    .ms_tx_transfer_eni(ms_data_to_core[78]),
    .ms_osc_transfer_eni(ms_data_to_core[80]),
    .sl_config_done(conf_done),   //slave config done
    .sl_osc_transfer_en(sl_osc_transfer_en),
    .sl_rx_transfer_en(sl_rx_transfer_en_s),
    .sl_tx_dcc_cal_done(sl_tx_dcc_cal_done),
    .sl_tx_transfer_en(sl_tx_transfer_en_s),
    .sl_rx_async_rst(sl_rx_async_rst),
    .sl_rx_dll_lock_req(sl_rx_dll_lock_req),
    .sl_rx_dll_lock(sl_rx_dll_lock),
    .sl_tx_dcc_dll_lock_req(sl_data_to_core[63]),
    .sl_rx_dcc_dll_lock_req(sl_data_to_core[69]),
    .sl_rx_dll_lockint(rx_dll_lock), //from slave internal
    .sl_rx_dll_locki(sl_data_to_core[68]),   //from sr interface
    .sl_tx_dcc_cal_donei(sl_data_to_core[31]), //from sr interface
    .sl_tx_dcc_cal_doneint(tx_dcc_cal_done),  //from slave internal
    .sl_rx_transfer_eni(sl_data_to_core[70]),
    .sl_osc_transfer_eni(sl_data_to_core[72]),
    .ms_nsl(dual_mode_select),       //
    .atpg_mode(1'b0),
    .reset_n(adpt_rstn)       //
    );

aib_sr_ms #(
            .MS_LENGTH(7'd81))
aib_sr_ms
   (
    .osc_clk(i_osc_clk),    //free running osc clock
    .ms_data_fr_core(ms_data_fr_core[80:0]),
    .ms_data_to_core(ms_data_to_core[80:0]),
    .sr_ms_data_out(sr_ms_data_out), //master serial data out
    .sr_ms_load_out(sr_ms_load_out), //master load out
    .sr_ms_data_in(srd_in), //master serial data out
    .sr_ms_load_in(srl_in), //master serial data load inupt
    .sr_ms_clk_in(sr_clk_in), //from input por
    .ms_nsl(dual_mode_select), 
    .atpg_mode(1'b0),
    .reset_n(conf_done)       
    );

aib_sr_sl #(
            .SL_LENGTH(7'd73))
aib_sr_sl
   (
    .sr_sl_clk_in(sr_clk_in),    //From input
    .sr_sl_clk_out(sr_sl_clk_out),    //to output
    .sl_data_fr_core(sl_data_fr_core[72:0]),
    .sl_data_to_core(sl_data_to_core[72:0]),
    .sr_sl_data_out(sr_sl_data_out), //slave serial data out
    .sr_sl_load_out(sr_sl_load_out), //slave load out
    .sr_sl_data_in(srd_in), //slave serial data out
    .sr_sl_load_in(srl_in), //slave serial data load inupt
    .sr_ms_clk_in(i_osc_clk), //input ms clock
    .ms_nsl(dual_mode_select), 
    .atpg_mode(1'b0),
    .reset_n(conf_done)       
    );

aib_adapt_avmm aib_adapt_avmm   (
       // Outputs
       .aib_bsr_scan_shift_clk                      (o_aib_bsr_scan_shift_clk),
       // CRSSM AVMM
       .cfg_avmm_rdata                              (o_cfg_avmm_rdata),
       .cfg_avmm_rdatavld                           (o_cfg_avmm_rdatavld),
       .cfg_avmm_waitreq                            (o_cfg_avmm_waitreq),
       .o_hard_rst_n                                (o_adpt_hard_rst_n),
       .adpt_cfg_write                              (o_adpt_cfg_write),
       .adpt_cfg_read                               (o_adpt_cfg_read),
       .r_aib_csr_ctrl_0                            (o_aib_csr_ctrl_0[7:0]),
       .r_aib_csr_ctrl_1                            (o_aib_csr_ctrl_1[7:0]),
       .r_aib_csr_ctrl_10                           (o_aib_csr_ctrl_10[7:0]),
       .r_aib_csr_ctrl_11                           (o_aib_csr_ctrl_11[7:0]),
       .r_aib_csr_ctrl_12                           (o_aib_csr_ctrl_12[7:0]),
       .r_aib_csr_ctrl_13                           (o_aib_csr_ctrl_13[7:0]),
       .r_aib_csr_ctrl_14                           (o_aib_csr_ctrl_14[7:0]),
       .r_aib_csr_ctrl_15                           (o_aib_csr_ctrl_15[7:0]),
       .r_aib_csr_ctrl_16                           (o_aib_csr_ctrl_16[7:0]),
       .r_aib_csr_ctrl_17                           (o_aib_csr_ctrl_17[7:0]),
       .r_aib_csr_ctrl_18                           (o_aib_csr_ctrl_18[7:0]),
       .r_aib_csr_ctrl_19                           (o_aib_csr_ctrl_19[7:0]),
       .r_aib_csr_ctrl_2                            (o_aib_csr_ctrl_2[7:0]),
       .r_aib_csr_ctrl_20                           (o_aib_csr_ctrl_20[7:0]),
       .r_aib_csr_ctrl_21                           (o_aib_csr_ctrl_21[7:0]),
       .r_aib_csr_ctrl_22                           (o_aib_csr_ctrl_22[7:0]),
       .r_aib_csr_ctrl_23                           (o_aib_csr_ctrl_23[7:0]),
       .r_aib_csr_ctrl_24                           (o_aib_csr_ctrl_24[7:0]),
       .r_aib_csr_ctrl_25                           (o_aib_csr_ctrl_25[7:0]),
       .r_aib_csr_ctrl_26                           (o_aib_csr_ctrl_26[7:0]),
       .r_aib_csr_ctrl_27                           (o_aib_csr_ctrl_27[7:0]),
       .r_aib_csr_ctrl_28                           (o_aib_csr_ctrl_28[7:0]),
       .r_aib_csr_ctrl_29                           (o_aib_csr_ctrl_29[7:0]),
       .r_aib_csr_ctrl_3                            (o_aib_csr_ctrl_3[7:0]),
       .r_aib_csr_ctrl_30                           (o_aib_csr_ctrl_30[7:0]),
       .r_aib_csr_ctrl_31                           (o_aib_csr_ctrl_31[7:0]),
       .r_aib_csr_ctrl_32                           (o_aib_csr_ctrl_32[7:0]),
       .r_aib_csr_ctrl_33                           (o_aib_csr_ctrl_33[7:0]),
       .r_aib_csr_ctrl_34                           (o_aib_csr_ctrl_34[7:0]),
       .r_aib_csr_ctrl_35                           (o_aib_csr_ctrl_35[7:0]),
       .r_aib_csr_ctrl_36                           (o_aib_csr_ctrl_36[7:0]),
       .r_aib_csr_ctrl_37                           (o_aib_csr_ctrl_37[7:0]),
       .r_aib_csr_ctrl_38                           (o_aib_csr_ctrl_38[7:0]),
       .r_aib_csr_ctrl_39                           (o_aib_csr_ctrl_39[7:0]),
       .r_aib_csr_ctrl_4                            (o_aib_csr_ctrl_4[7:0]),
       .r_aib_csr_ctrl_40                           (o_aib_csr_ctrl_40[7:0]),
       .r_aib_csr_ctrl_41                           (o_aib_csr_ctrl_41[7:0]),
       .r_aib_csr_ctrl_42                           (o_aib_csr_ctrl_42[7:0]),
       .r_aib_csr_ctrl_43                           (o_aib_csr_ctrl_43[7:0]),
       .r_aib_csr_ctrl_44                           (o_aib_csr_ctrl_44[7:0]),
       .r_aib_csr_ctrl_45                           (o_aib_csr_ctrl_45[7:0]),
       .r_aib_csr_ctrl_46                           (o_aib_csr_ctrl_46[7:0]),
       .r_aib_csr_ctrl_47                           (o_aib_csr_ctrl_47[7:0]),
       .r_aib_csr_ctrl_48                           (o_aib_csr_ctrl_48[7:0]),
       .r_aib_csr_ctrl_49                           (o_aib_csr_ctrl_49[7:0]),
       .r_aib_csr_ctrl_5                            (o_aib_csr_ctrl_5[7:0]),
       .r_aib_csr_ctrl_50                           (o_aib_csr_ctrl_50[7:0]),
       .r_aib_csr_ctrl_51                           (o_aib_csr_ctrl_51[7:0]),
       .r_aib_csr_ctrl_52                           (o_aib_csr_ctrl_52[7:0]),
       .r_aib_csr_ctrl_53                           (o_aib_csr_ctrl_53[7:0]),
       .r_aib_csr_ctrl_6                            (o_aib_csr_ctrl_6[7:0]),
       .r_aib_csr_ctrl_7                            (o_aib_csr_ctrl_7[7:0]),
       .r_aib_csr_ctrl_8                            (o_aib_csr_ctrl_8[7:0]),
       .r_aib_csr_ctrl_9                            (o_aib_csr_ctrl_9[7:0]),
       .r_aib_dprio_ctrl_0                          (o_aib_dprio_ctrl_0[7:0]),
       .r_aib_dprio_ctrl_1                          (o_aib_dprio_ctrl_1[7:0]),
       .r_aib_dprio_ctrl_2                          (o_aib_dprio_ctrl_2[7:0]),
       .r_aib_dprio_ctrl_3                          (o_aib_dprio_ctrl_3[7:0]),
       .r_aib_dprio_ctrl_4                          (o_aib_dprio_ctrl_4[7:0]),
       .r_rx_double_write                           (r_tx_double_write),
       .r_rx_fifo_mode                              (r_tx_fifo_mode[1:0]),
       .rxswap_en                                   (rxswap_en[2:0]),
       .r_rx_phcomp_rd_delay                        (r_tx_phcomp_rd_delay[2:0]),
       .r_rx_wm_en                                  (r_tx_wm_en),
       .r_rx_wr_adj_en                              (r_tx_wr_adj_en),
       .r_rx_rd_adj_en                              (r_tx_rd_adj_en),
       .r_tx_adapter_lpbk_mode                      (r_tx_adapter_lpbk_mode[1:0]),
       .r_rx_aib_lpbk_en                            (r_rx_aib_lpbk_en),
       .r_tx_double_read                            (r_rx_double_read),
       .r_tx_fifo_mode                              (r_rx_fifo_mode[1:0]),
       .txswap_en                                   (txswap_en[2:0]),
       .r_rx_lpbk                                   (r_rx_lpbk),
       .r_tx_fifo_rd_clk_sel                        (r_tx_fifo_rd_clk_sel),
       .r_tx_phcomp_rd_delay                        (r_rx_phcomp_rd_delay[2:0]),
       .r_tx_wa_en                                  (r_rx_wa_en),
       .r_tx_wr_adj_en                              (r_rx_wr_adj_en),
       .r_tx_rd_adj_en                              (r_rx_rd_adj_en),
       // Inputs
       .avmm1_tst_tcm_ctrl                          (i_avmm1_tst_tcm_ctrl),
       .avmm1_test_clk                              (i_avmm1_test_clk),
       .avmm1_scan_clk                              (i_avmm1_scan_clk),
       //.sr_testbus                                  (sr_testbus),
       .sr_testbus                                  (8'b0),
       .scan_rst_n                                  (i_scan_rst_n),
       .scan_mode_n                                 (i_scan_mode_n),
       .avmm_async_fabric_hssi_ssr_load             (1'b0),
       .avmm_hrdrst_fabric_osc_transfer_en_ssr_data (1'b0),
       .avmm_async_hssi_fabric_ssr_load             (1'b0),
       .aib_hssi_avmm1_data_in                      (i_aib_avmm1_data[1:0]),
       .sr_clock_tx_osc_clk_or_clkdiv               (1'b0),
       .aib_hssi_rx_sr_clk_in                       (sr_clk_in),
       .sr_clock_aib_rx_sr_clk                      (1'b0),
       .avmm1_async_hssi_fabric_ssr_load            (1'b0),
       .csr_rdy_dly_in                              (i_adpt_hard_rst_n),
       // CRSSM AVMM
       .cfg_avmm_addr_id                            (i_cfg_avmm_addr_id),
       .cfg_avmm_clk                                (i_cfg_avmm_clk),
       .cfg_avmm_rst_n                              (i_cfg_avmm_rst_n),
       .cfg_avmm_write                              (i_cfg_avmm_write),
       .cfg_avmm_read                               (i_cfg_avmm_read),
       .cfg_avmm_addr                               (i_cfg_avmm_addr),
       .cfg_avmm_wdata                              (i_cfg_avmm_wdata),
       .cfg_avmm_byte_en                            (i_cfg_avmm_byte_en),
       .adpt_cfg_rdata                              (i_adpt_cfg_rdata),
       .adpt_cfg_rdatavld                           (i_adpt_cfg_rdatavld),
       .adpt_cfg_waitreq                            (i_adpt_cfg_waitreq),
       .pld_chnl_cal_done                           (1'b0),
       .rx_chnl_dprio_status                        (8'b0),
       .rx_chnl_dprio_status_write_en_ack           (1'b0),
       .sr_dprio_status                             (8'b0),
       .sr_dprio_status_write_en_ack                (1'b0),
       .tx_chnl_dprio_status                        (8'b0),
       .tx_chnl_dprio_status_write_en_ack           (1'b0),
       .usermode_in                                 (1'b0)
);

endmodule // aib_channel
