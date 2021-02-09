// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib
// Description    : Behavioral model of AIB 2.0 top level
// Revision       : 2.0
// ============================================================================
module aib_model_top #(
    parameter DATAWIDTH = 40,
    parameter TOTAL_CHNL_NUM = 24
    )
 ( 
inout wire [DATAWIDTH*TOTAL_CHNL_NUM-1:0]    iopad_tx,
inout wire [DATAWIDTH*TOTAL_CHNL_NUM-1:0]    iopad_rx,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_rcv_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_rcv_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_fwd_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_fwd_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_sr_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_sr_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_sr_load,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_sr_data,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_mac_rdy,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_ns_adapter_rstn,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_spare1,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_spare0,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_rcv_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_rcv_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_fwd_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_fwd_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_sr_clkb,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_sr_clk,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_sr_load,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_sr_data,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_mac_rdy,
inout wire [TOTAL_CHNL_NUM-1:0]              iopad_fs_adapter_rstn,

inout                                        device_detect,
inout                                        por,

input  [DATAWIDTH*8*TOTAL_CHNL_NUM-1 :0]     data_in_f, 
output [DATAWIDTH*8*TOTAL_CHNL_NUM-1 :0]     data_out_f, 

input  [DATAWIDTH*2*TOTAL_CHNL_NUM-1 :0]     data_in, 
output [DATAWIDTH*2*TOTAL_CHNL_NUM-1 :0]     data_out,

input  [TOTAL_CHNL_NUM-1:0]    m_ns_fwd_clk, 
input  [TOTAL_CHNL_NUM-1:0]    m_ns_rcv_clk,
output [TOTAL_CHNL_NUM-1:0]    m_fs_rcv_clk, 
output [TOTAL_CHNL_NUM-1:0]    m_fs_fwd_clk,
input  [TOTAL_CHNL_NUM-1:0]    m_wr_clk,
input  [TOTAL_CHNL_NUM-1:0]    m_rd_clk,

input  [TOTAL_CHNL_NUM-1:0]    ns_adapter_rstn,
input  [TOTAL_CHNL_NUM-1:0]    ns_mac_rdy,
output [TOTAL_CHNL_NUM-1:0]    fs_mac_rdy,
input                          i_conf_done,
input                          i_osc_clk,

input  [TOTAL_CHNL_NUM-1:0]    ms_rx_dcc_dll_lock_req,
input  [TOTAL_CHNL_NUM-1:0]    ms_tx_dcc_dll_lock_req,
input  [TOTAL_CHNL_NUM-1:0]    sl_tx_dcc_dll_lock_req,
input  [TOTAL_CHNL_NUM-1:0]    sl_rx_dcc_dll_lock_req,
output [TOTAL_CHNL_NUM-1:0]    ms_tx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    ms_rx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    sl_tx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    sl_rx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    m_rxfifo_align_done,
output [TOTAL_CHNL_NUM-1:0]    wa_error,
output [4*TOTAL_CHNL_NUM-1:0]  wa_error_cnt,
output [81*TOTAL_CHNL_NUM-1:0] sr_ms_tomac,
output [73*TOTAL_CHNL_NUM-1:0] sr_sl_tomac,
input                          dual_mode_select,
input                          m_gen2_mode,


//Aux channel
input                          m_por_ovrd,
input                          m_device_detect_ovrd,
input                          i_m_power_on_reset,
output                         m_device_detect,
output                         o_m_power_on_reset,
//JTAG signals
input                          i_jtag_clkdr, 
input                          i_jtag_clksel,
input                          i_jtag_intest,
input                          i_jtag_mode,
input                          i_jtag_rstb,
input                          i_jtag_rstb_en, 
input                          i_jtag_tdi,
input                          i_jtag_tx_scanen,
input                          i_jtag_weakpdn, 
input                          i_jtag_weakpu, 

//AVMM interface
input                          i_cfg_avmm_clk,
input                          i_cfg_avmm_rst_n,
input [16:0]                   i_cfg_avmm_addr, // address to be programmed
input [3:0]                    i_cfg_avmm_byte_en, // byte enable
input                          i_cfg_avmm_read, // Asserted to indicate the Cfg read access
input                          i_cfg_avmm_write, // Asserted to indicate the Cfg write access
input [31:0]                   i_cfg_avmm_wdata, // data to be programmed
output                         o_cfg_avmm_rdatavld,// Assert to indicate data available for Cfg read access
output [31:0]                  o_cfg_avmm_rdata, // data returned for Cfg read access
output                         o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg access
output                         o_jtag_tdo, //last boundary scan chain output, TDO

//Redundancy control signals for IO buffers

input [27*TOTAL_CHNL_NUM-1:0]  sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [3*TOTAL_CHNL_NUM-1:0]   sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [26*TOTAL_CHNL_NUM-1:0]  sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [5*TOTAL_CHNL_NUM-1:0]   ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [58*TOTAL_CHNL_NUM-1:0]  ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register

input          vccl_aib,
input          vssl_aib );

wire por_ms, osc_clk;
wire [TOTAL_CHNL_NUM-1:0] o_cfg_avmm_rdatavld_ch;
wire [TOTAL_CHNL_NUM-1:0] o_cfg_avmm_waitreq_ch;
wire [TOTAL_CHNL_NUM-1:0] o_jtag_tdo_ch; 
wire [31:0] o_rdata_ch[0:23];

assign o_jtag_tdo = o_jtag_tdo_ch[23];
/////////////////////////////////////////////////////////////////////////////////
//
// AVMM output generation
/////////////////////////////////////////////////////////////////////////////////
assign o_cfg_avmm_waitreq =  &o_cfg_avmm_waitreq_ch;
assign o_cfg_avmm_rdatavld = |o_cfg_avmm_rdatavld_ch;
assign o_cfg_avmm_rdata    = o_rdata_ch[23]|o_rdata_ch[22]|o_rdata_ch[21]|o_rdata_ch[20]|o_rdata_ch[19]|o_rdata_ch[18]|
                             o_rdata_ch[17]|o_rdata_ch[16]|o_rdata_ch[15]|o_rdata_ch[14]|o_rdata_ch[13]|o_rdata_ch[12]|
                             o_rdata_ch[11]|o_rdata_ch[10]|o_rdata_ch[9 ]|o_rdata_ch[8] |o_rdata_ch[7] |o_rdata_ch[6] |
                             o_rdata_ch[5 ]|o_rdata_ch[4 ]|o_rdata_ch[3 ]|o_rdata_ch[2] |o_rdata_ch[1] |o_rdata_ch[0];
                          

aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel0
 ( 
     .iopad_tx(iopad_tx[40*1-1:40*0]),
     .iopad_rx(iopad_rx[40*1-1:40*0]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[0]), 
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[0]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[0]), 
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[0]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[0]), 
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[0]),
     .iopad_ns_sr_load(iopad_ns_sr_load[0]), 
     .iopad_ns_sr_data(iopad_ns_sr_data[0]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[0]), 
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[0]),
     .iopad_spare1(iopad_spare1[0]), 
     .iopad_spare0(iopad_spare0[0]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[0]), 
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[0]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[0]), 
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[0]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[0]), 
     .iopad_fs_sr_clk(iopad_fs_sr_clk[0]),
     .iopad_fs_sr_load(iopad_fs_sr_load[0]), 
     .iopad_fs_sr_data(iopad_fs_sr_data[0]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[0]), 
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[0]),

     .data_in_f(data_in_f[320*1-1:320*0]),
     .data_out_f(data_out_f[320*1-1:320*0]),
     .data_in(data_in[80*1-1:80*0]),
     .data_out(data_out[80*1-1:80*0]),

     .m_ns_fwd_clk(m_ns_fwd_clk[0]), 
     .m_fs_rcv_clk(m_fs_rcv_clk[0]), 
     .m_fs_fwd_clk(m_fs_fwd_clk[0]), 
     .m_ns_rcv_clk(m_ns_rcv_clk[0]), 
     .m_wr_clk(m_wr_clk[0]),
     .m_rd_clk(m_wr_clk[0]),

     .i_conf_done(i_conf_done), 
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[0]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[0]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[0]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[0]),
     .ms_tx_transfer_en(ms_tx_transfer_en[0]),
     .ms_rx_transfer_en(ms_rx_transfer_en[0]),
     .sl_tx_transfer_en(sl_tx_transfer_en[0]),
     .sl_rx_transfer_en(sl_rx_transfer_en[0]),
     .m_rxfifo_align_done(m_rxfifo_align_done[0]),
     .wa_error(wa_error[0]),
     .wa_error_cnt(wa_error_cnt[4*1-1:4*0]),


     .sr_ms_tomac(sr_ms_tomac[81*1-1:81*0]),
     .sr_sl_tomac(sr_sl_tomac[73*1-1:73*0]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*1-1:27*0]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*1-1:3*0]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*1-1:26*0]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*1-1:5*0]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*1-1:58*0]),


     .ns_adapter_rstn(ns_adapter_rstn[0]),
     .ns_mac_rdy(ns_mac_rdy[0]),
     .fs_mac_rdy(fs_mac_rdy[0]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[0]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(i_jtag_tdi),

     .i_channel_id(6'd0), 
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr), 
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en), 
     .i_cfg_avmm_read(i_cfg_avmm_read), 
     .i_cfg_avmm_write(i_cfg_avmm_write), 
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata), 

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[0]),
     .o_cfg_avmm_rdata(o_rdata_ch[0]), 
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[0]), 

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel1
 (
     .iopad_tx(iopad_tx[40*2-1:40*1]),
     .iopad_rx(iopad_rx[40*2-1:40*1]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[1]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[1]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[1]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[1]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[1]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[1]),
     .iopad_ns_sr_load(iopad_ns_sr_load[1]),
     .iopad_ns_sr_data(iopad_ns_sr_data[1]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[1]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[1]),
     .iopad_spare1(iopad_spare1[1]),
     .iopad_spare0(iopad_spare0[1]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[1]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[1]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[1]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[1]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[1]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[1]),
     .iopad_fs_sr_load(iopad_fs_sr_load[1]),
     .iopad_fs_sr_data(iopad_fs_sr_data[1]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[1]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[1]),

     .data_in_f(data_in_f[320*2-1:320*1]),
     .data_out_f(data_out_f[320*2-1:320*1]),
     .data_in(data_in[80*2-1:80*1]),
     .data_out(data_out[80*2-1:80*1]),
     .m_ns_fwd_clk(m_ns_fwd_clk[1]),
     .m_fs_rcv_clk(m_fs_rcv_clk[1]),
     .m_fs_fwd_clk(m_fs_fwd_clk[1]),
     .m_ns_rcv_clk(m_ns_rcv_clk[1]),
     .m_wr_clk(m_wr_clk[1]),
     .m_rd_clk(m_wr_clk[1]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[1]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[1]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[1]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[1]),
     .ms_tx_transfer_en(ms_tx_transfer_en[1]),
     .ms_rx_transfer_en(ms_rx_transfer_en[1]),
     .sl_tx_transfer_en(sl_tx_transfer_en[1]),
     .sl_rx_transfer_en(sl_rx_transfer_en[1]),
     .m_rxfifo_align_done(m_rxfifo_align_done[1]),
     .wa_error(wa_error[1]),
     .wa_error_cnt(wa_error_cnt[4*2-1:4*1]),


     .sr_ms_tomac(sr_ms_tomac[81*2-1:81*1]),
     .sr_sl_tomac(sr_sl_tomac[73*2-1:73*1]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*2-1:27*1]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*2-1:3*1]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*2-1:26*1]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*2-1:5*1]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*2-1:58*1]),


     .ns_adapter_rstn(ns_adapter_rstn[1]),
     .ns_mac_rdy(ns_mac_rdy[1]),
     .fs_mac_rdy(fs_mac_rdy[1]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[1]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[0]),

     .i_channel_id(6'd1),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[1]),
     .o_cfg_avmm_rdata(o_rdata_ch[1]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[1]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel2
 (
     .iopad_tx(iopad_tx[40*3-1:40*2]),
     .iopad_rx(iopad_rx[40*3-1:40*2]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[2]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[2]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[2]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[2]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[2]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[2]),
     .iopad_ns_sr_load(iopad_ns_sr_load[2]),
     .iopad_ns_sr_data(iopad_ns_sr_data[2]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[2]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[2]),
     .iopad_spare1(iopad_spare1[2]),
     .iopad_spare0(iopad_spare0[2]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[2]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[2]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[2]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[2]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[2]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[2]),
     .iopad_fs_sr_load(iopad_fs_sr_load[2]),
     .iopad_fs_sr_data(iopad_fs_sr_data[2]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[2]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[2]),

     .data_in_f(data_in_f[320*3-1:320*2]),
     .data_out_f(data_out_f[320*3-1:320*2]),
     .data_in(data_in[80*3-1:80*2]),
     .data_out(data_out[80*3-1:80*2]),
     .m_ns_fwd_clk(m_ns_fwd_clk[2]),
     .m_fs_rcv_clk(m_fs_rcv_clk[2]),
     .m_fs_fwd_clk(m_fs_fwd_clk[2]),
     .m_ns_rcv_clk(m_ns_rcv_clk[2]),
     .m_wr_clk(m_wr_clk[2]),
     .m_rd_clk(m_wr_clk[2]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[2]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[2]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[2]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[2]),
     .ms_tx_transfer_en(ms_tx_transfer_en[2]),
     .ms_rx_transfer_en(ms_rx_transfer_en[2]),
     .sl_tx_transfer_en(sl_tx_transfer_en[2]),
     .sl_rx_transfer_en(sl_rx_transfer_en[2]),
     .m_rxfifo_align_done(m_rxfifo_align_done[2]),
     .wa_error(wa_error[2]),
     .wa_error_cnt(wa_error_cnt[4*3-1:4*2]),


     .sr_ms_tomac(sr_ms_tomac[81*3-1:81*2]),
     .sr_sl_tomac(sr_sl_tomac[73*3-1:73*2]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*3-1:27*2]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*3-1:3*2]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*3-1:26*2]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*3-1:5*2]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*3-1:58*2]),


     .ns_adapter_rstn(ns_adapter_rstn[2]),
     .ns_mac_rdy(ns_mac_rdy[2]),
     .fs_mac_rdy(fs_mac_rdy[2]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[2]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[1]),

     .i_channel_id(6'd2),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[2]),
     .o_cfg_avmm_rdata(o_rdata_ch[2]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[2]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );



aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel3
 (
     .iopad_tx(iopad_tx[40*4-1:40*3]),
     .iopad_rx(iopad_rx[40*4-1:40*3]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[3]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[3]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[3]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[3]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[3]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[3]),
     .iopad_ns_sr_load(iopad_ns_sr_load[3]),
     .iopad_ns_sr_data(iopad_ns_sr_data[3]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[3]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[3]),
     .iopad_spare1(iopad_spare1[3]),
     .iopad_spare0(iopad_spare0[3]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[3]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[3]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[3]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[3]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[3]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[3]),
     .iopad_fs_sr_load(iopad_fs_sr_load[3]),
     .iopad_fs_sr_data(iopad_fs_sr_data[3]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[3]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[3]),

     .data_in_f(data_in_f[320*4-1:320*3]),
     .data_out_f(data_out_f[320*4-1:320*3]),
     .data_in(data_in[80*4-1:80*3]),
     .data_out(data_out[80*4-1:80*3]),
     .m_ns_fwd_clk(m_ns_fwd_clk[3]),
     .m_fs_rcv_clk(m_fs_rcv_clk[3]),
     .m_fs_fwd_clk(m_fs_fwd_clk[3]),
     .m_ns_rcv_clk(m_ns_rcv_clk[3]),
     .m_wr_clk(m_wr_clk[3]),
     .m_rd_clk(m_wr_clk[3]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[3]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[3]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[3]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[3]),
     .ms_tx_transfer_en(ms_tx_transfer_en[3]),
     .ms_rx_transfer_en(ms_rx_transfer_en[3]),
     .sl_tx_transfer_en(sl_tx_transfer_en[3]),
     .sl_rx_transfer_en(sl_rx_transfer_en[3]),
     .m_rxfifo_align_done(m_rxfifo_align_done[3]),
     .wa_error(wa_error[3]),
     .wa_error_cnt(wa_error_cnt[4*4-1:4*3]),


     .sr_ms_tomac(sr_ms_tomac[81*4-1:81*3]),
     .sr_sl_tomac(sr_sl_tomac[73*4-1:73*3]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*4-1:27*3]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*4-1:3*3]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*4-1:26*3]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*4-1:5*3]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*4-1:58*3]),


     .ns_adapter_rstn(ns_adapter_rstn[3]),
     .ns_mac_rdy(ns_mac_rdy[3]),
     .fs_mac_rdy(fs_mac_rdy[3]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[3]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[2]),

     .i_channel_id(6'd3),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[3]),
     .o_cfg_avmm_rdata(o_rdata_ch[3]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[3]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel4
 (
     .iopad_tx(iopad_tx[40*5-1:40*4]),
     .iopad_rx(iopad_rx[40*5-1:40*4]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[4]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[4]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[4]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[4]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[4]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[4]),
     .iopad_ns_sr_load(iopad_ns_sr_load[4]),
     .iopad_ns_sr_data(iopad_ns_sr_data[4]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[4]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[4]),
     .iopad_spare1(iopad_spare1[4]),
     .iopad_spare0(iopad_spare0[4]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[4]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[4]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[4]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[4]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[4]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[4]),
     .iopad_fs_sr_load(iopad_fs_sr_load[4]),
     .iopad_fs_sr_data(iopad_fs_sr_data[4]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[4]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[4]),

     .data_in_f(data_in_f[320*5-1:320*4]),
     .data_out_f(data_out_f[320*5-1:320*4]),
     .data_in(data_in[80*5-1:80*4]),
     .data_out(data_out[80*5-1:80*4]),
     .m_ns_fwd_clk(m_ns_fwd_clk[4]),
     .m_fs_rcv_clk(m_fs_rcv_clk[4]),
     .m_fs_fwd_clk(m_fs_fwd_clk[4]),
     .m_ns_rcv_clk(m_ns_rcv_clk[4]),
     .m_wr_clk(m_wr_clk[4]),
     .m_rd_clk(m_wr_clk[4]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[4]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[4]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[4]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[4]),
     .ms_tx_transfer_en(ms_tx_transfer_en[4]),
     .ms_rx_transfer_en(ms_rx_transfer_en[4]),
     .sl_tx_transfer_en(sl_tx_transfer_en[4]),
     .sl_rx_transfer_en(sl_rx_transfer_en[4]),
     .m_rxfifo_align_done(m_rxfifo_align_done[4]),
     .wa_error(wa_error[4]),
     .wa_error_cnt(wa_error_cnt[4*5-1:4*4]),


     .sr_ms_tomac(sr_ms_tomac[81*5-1:81*4]),
     .sr_sl_tomac(sr_sl_tomac[73*5-1:73*4]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*5-1:27*4]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*5-1:3*4]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*5-1:26*4]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*5-1:5*4]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*5-1:58*4]),


     .ns_adapter_rstn(ns_adapter_rstn[4]),
     .ns_mac_rdy(ns_mac_rdy[4]),
     .fs_mac_rdy(fs_mac_rdy[4]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[4]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[3]),

     .i_channel_id(6'd4),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[4]),
     .o_cfg_avmm_rdata(o_rdata_ch[4]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[4]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel5
 (
     .iopad_tx(iopad_tx[40*6-1:40*5]),
     .iopad_rx(iopad_rx[40*6-1:40*5]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[5]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[5]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[5]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[5]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[5]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[5]),
     .iopad_ns_sr_load(iopad_ns_sr_load[5]),
     .iopad_ns_sr_data(iopad_ns_sr_data[5]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[5]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[5]),
     .iopad_spare1(iopad_spare1[5]),
     .iopad_spare0(iopad_spare0[5]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[5]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[5]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[5]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[5]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[5]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[5]),
     .iopad_fs_sr_load(iopad_fs_sr_load[5]),
     .iopad_fs_sr_data(iopad_fs_sr_data[5]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[5]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[5]),

     .data_in_f(data_in_f[320*6-1:320*5]),
     .data_out_f(data_out_f[320*6-1:320*5]),
     .data_in(data_in[80*6-1:80*5]),
     .data_out(data_out[80*6-1:80*5]),
     .m_ns_fwd_clk(m_ns_fwd_clk[5]),
     .m_fs_rcv_clk(m_fs_rcv_clk[5]),
     .m_fs_fwd_clk(m_fs_fwd_clk[5]),
     .m_ns_rcv_clk(m_ns_rcv_clk[5]),
     .m_wr_clk(m_wr_clk[5]),
     .m_rd_clk(m_wr_clk[5]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[5]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[5]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[5]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[5]),
     .ms_tx_transfer_en(ms_tx_transfer_en[5]),
     .ms_rx_transfer_en(ms_rx_transfer_en[5]),
     .sl_tx_transfer_en(sl_tx_transfer_en[5]),
     .sl_rx_transfer_en(sl_rx_transfer_en[5]),
     .m_rxfifo_align_done(m_rxfifo_align_done[5]),
     .wa_error(wa_error[5]),
     .wa_error_cnt(wa_error_cnt[4*6-1:4*5]),


     .sr_ms_tomac(sr_ms_tomac[81*6-1:81*5]),
     .sr_sl_tomac(sr_sl_tomac[73*6-1:73*5]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*6-1:27*5]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*6-1:3*5]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*6-1:26*5]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*6-1:5*5]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*6-1:58*5]),


     .ns_adapter_rstn(ns_adapter_rstn[5]),
     .ns_mac_rdy(ns_mac_rdy[5]),
     .fs_mac_rdy(fs_mac_rdy[5]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[5]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[4]),

     .i_channel_id(6'd5),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[5]),
     .o_cfg_avmm_rdata(o_rdata_ch[5]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[5]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel6
 (
     .iopad_tx(iopad_tx[40*7-1:40*6]),
     .iopad_rx(iopad_rx[40*7-1:40*6]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[6]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[6]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[6]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[6]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[6]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[6]),
     .iopad_ns_sr_load(iopad_ns_sr_load[6]),
     .iopad_ns_sr_data(iopad_ns_sr_data[6]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[6]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[6]),
     .iopad_spare1(iopad_spare1[6]),
     .iopad_spare0(iopad_spare0[6]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[6]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[6]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[6]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[6]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[6]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[6]),
     .iopad_fs_sr_load(iopad_fs_sr_load[6]),
     .iopad_fs_sr_data(iopad_fs_sr_data[6]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[6]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[6]),

     .data_in_f(data_in_f[320*7-1:320*6]),
     .data_out_f(data_out_f[320*7-1:320*6]),
     .data_in(data_in[80*7-1:80*6]),
     .data_out(data_out[80*7-1:80*6]),
     .m_ns_fwd_clk(m_ns_fwd_clk[6]),
     .m_fs_rcv_clk(m_fs_rcv_clk[6]),
     .m_fs_fwd_clk(m_fs_fwd_clk[6]),
     .m_ns_rcv_clk(m_ns_rcv_clk[6]),
     .m_wr_clk(m_wr_clk[6]),
     .m_rd_clk(m_wr_clk[6]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[6]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[6]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[6]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[6]),
     .ms_tx_transfer_en(ms_tx_transfer_en[6]),
     .ms_rx_transfer_en(ms_rx_transfer_en[6]),
     .sl_tx_transfer_en(sl_tx_transfer_en[6]),
     .sl_rx_transfer_en(sl_rx_transfer_en[6]),
     .m_rxfifo_align_done(m_rxfifo_align_done[6]),
     .wa_error(wa_error[6]),
     .wa_error_cnt(wa_error_cnt[4*7-1:4*6]),


     .sr_ms_tomac(sr_ms_tomac[81*7-1:81*6]),
     .sr_sl_tomac(sr_sl_tomac[73*7-1:73*6]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*7-1:27*6]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*7-1:3*6]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*7-1:26*6]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*7-1:5*6]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*7-1:58*6]),


     .ns_adapter_rstn(ns_adapter_rstn[6]),
     .ns_mac_rdy(ns_mac_rdy[6]),
     .fs_mac_rdy(fs_mac_rdy[6]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[6]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[5]),

     .i_channel_id(6'd6),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[6]),
     .o_cfg_avmm_rdata(o_rdata_ch[6]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[6]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel7
 (
     .iopad_tx(iopad_tx[40*8-1:40*7]),
     .iopad_rx(iopad_rx[40*8-1:40*7]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[7]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[7]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[7]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[7]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[7]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[7]),
     .iopad_ns_sr_load(iopad_ns_sr_load[7]),
     .iopad_ns_sr_data(iopad_ns_sr_data[7]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[7]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[7]),
     .iopad_spare1(iopad_spare1[7]),
     .iopad_spare0(iopad_spare0[7]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[7]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[7]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[7]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[7]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[7]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[7]),
     .iopad_fs_sr_load(iopad_fs_sr_load[7]),
     .iopad_fs_sr_data(iopad_fs_sr_data[7]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[7]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[7]),

     .data_in_f(data_in_f[320*8-1:320*7]),
     .data_out_f(data_out_f[320*8-1:320*7]),
     .data_in(data_in[80*8-1:80*7]),
     .data_out(data_out[80*8-1:80*7]),
     .m_ns_fwd_clk(m_ns_fwd_clk[7]),
     .m_fs_rcv_clk(m_fs_rcv_clk[7]),
     .m_fs_fwd_clk(m_fs_fwd_clk[7]),
     .m_ns_rcv_clk(m_ns_rcv_clk[7]),
     .m_wr_clk(m_wr_clk[7]),
     .m_rd_clk(m_wr_clk[7]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[7]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[7]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[7]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[7]),
     .ms_tx_transfer_en(ms_tx_transfer_en[7]),
     .ms_rx_transfer_en(ms_rx_transfer_en[7]),
     .sl_tx_transfer_en(sl_tx_transfer_en[7]),
     .sl_rx_transfer_en(sl_rx_transfer_en[7]),
     .m_rxfifo_align_done(m_rxfifo_align_done[7]),
     .wa_error(wa_error[7]),
     .wa_error_cnt(wa_error_cnt[4*8-1:4*7]),


     .sr_ms_tomac(sr_ms_tomac[81*8-1:81*7]),
     .sr_sl_tomac(sr_sl_tomac[73*8-1:73*7]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*8-1:27*7]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*8-1:3*7]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*8-1:26*7]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*8-1:5*7]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*8-1:58*7]),


     .ns_adapter_rstn(ns_adapter_rstn[7]),
     .ns_mac_rdy(ns_mac_rdy[7]),
     .fs_mac_rdy(fs_mac_rdy[7]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[7]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[6]),

     .i_channel_id(6'd7),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[7]),
     .o_cfg_avmm_rdata(o_rdata_ch[7]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[7]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel8
 (
     .iopad_tx(iopad_tx[40*9-1:40*8]),
     .iopad_rx(iopad_rx[40*9-1:40*8]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[8]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[8]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[8]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[8]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[8]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[8]),
     .iopad_ns_sr_load(iopad_ns_sr_load[8]),
     .iopad_ns_sr_data(iopad_ns_sr_data[8]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[8]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[8]),
     .iopad_spare1(iopad_spare1[8]),
     .iopad_spare0(iopad_spare0[8]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[8]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[8]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[8]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[8]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[8]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[8]),
     .iopad_fs_sr_load(iopad_fs_sr_load[8]),
     .iopad_fs_sr_data(iopad_fs_sr_data[8]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[8]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[8]),

     .data_in_f(data_in_f[320*9-1:320*8]),
     .data_out_f(data_out_f[320*9-1:320*8]),
     .data_in(data_in[80*9-1:80*8]),
     .data_out(data_out[80*9-1:80*8]),
     .m_ns_fwd_clk(m_ns_fwd_clk[8]),
     .m_fs_rcv_clk(m_fs_rcv_clk[8]),
     .m_fs_fwd_clk(m_fs_fwd_clk[8]),
     .m_ns_rcv_clk(m_ns_rcv_clk[8]),
     .m_wr_clk(m_wr_clk[8]),
     .m_rd_clk(m_wr_clk[8]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[8]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[8]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[8]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[8]),
     .ms_tx_transfer_en(ms_tx_transfer_en[8]),
     .ms_rx_transfer_en(ms_rx_transfer_en[8]),
     .sl_tx_transfer_en(sl_tx_transfer_en[8]),
     .sl_rx_transfer_en(sl_rx_transfer_en[8]),
     .m_rxfifo_align_done(m_rxfifo_align_done[8]),
     .wa_error(wa_error[8]),
     .wa_error_cnt(wa_error_cnt[4*9-1:4*8]),


     .sr_ms_tomac(sr_ms_tomac[81*9-1:81*8]),
     .sr_sl_tomac(sr_sl_tomac[73*9-1:73*8]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*9-1:27*8]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*9-1:3*8]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*9-1:26*8]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*9-1:5*8]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*9-1:58*8]),


     .ns_adapter_rstn(ns_adapter_rstn[8]),
     .ns_mac_rdy(ns_mac_rdy[8]),
     .fs_mac_rdy(fs_mac_rdy[8]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[8]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[7]),

     .i_channel_id(6'd8),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[8]),
     .o_cfg_avmm_rdata(o_rdata_ch[8]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[8]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel9
 (
     .iopad_tx(iopad_tx[40*10-1:40*9]),
     .iopad_rx(iopad_rx[40*10-1:40*9]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[9]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[9]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[9]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[9]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[9]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[9]),
     .iopad_ns_sr_load(iopad_ns_sr_load[9]),
     .iopad_ns_sr_data(iopad_ns_sr_data[9]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[9]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[9]),
     .iopad_spare1(iopad_spare1[9]),
     .iopad_spare0(iopad_spare0[9]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[9]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[9]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[9]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[9]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[9]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[9]),
     .iopad_fs_sr_load(iopad_fs_sr_load[9]),
     .iopad_fs_sr_data(iopad_fs_sr_data[9]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[9]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[9]),

     .data_in_f(data_in_f[320*10-1:320*9]),
     .data_out_f(data_out_f[320*10-1:320*9]),
     .data_in(data_in[80*10-1:80*9]),
     .data_out(data_out[80*10-1:80*9]),
     .m_ns_fwd_clk(m_ns_fwd_clk[9]),
     .m_fs_rcv_clk(m_fs_rcv_clk[9]),
     .m_fs_fwd_clk(m_fs_fwd_clk[9]),
     .m_ns_rcv_clk(m_ns_rcv_clk[9]),
     .m_wr_clk(m_wr_clk[9]),
     .m_rd_clk(m_wr_clk[9]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[9]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[9]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[9]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[9]),
     .ms_tx_transfer_en(ms_tx_transfer_en[9]),
     .ms_rx_transfer_en(ms_rx_transfer_en[9]),
     .sl_tx_transfer_en(sl_tx_transfer_en[9]),
     .sl_rx_transfer_en(sl_rx_transfer_en[9]),
     .m_rxfifo_align_done(m_rxfifo_align_done[9]),
     .wa_error(wa_error[9]),
     .wa_error_cnt(wa_error_cnt[4*10-1:4*9]),


     .sr_ms_tomac(sr_ms_tomac[81*10-1:81*9]),
     .sr_sl_tomac(sr_sl_tomac[73*10-1:73*9]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*10-1:27*9]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*10-1:3*9]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*10-1:26*9]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*10-1:5*9]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*10-1:58*9]),


     .ns_adapter_rstn(ns_adapter_rstn[9]),
     .ns_mac_rdy(ns_mac_rdy[9]),
     .fs_mac_rdy(fs_mac_rdy[9]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[9]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[8]),

     .i_channel_id(6'd9),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[9]),
     .o_cfg_avmm_rdata(o_rdata_ch[9]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[9]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel10
 (
     .iopad_tx(iopad_tx[40*11-1:40*10]),
     .iopad_rx(iopad_rx[40*11-1:40*10]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[10]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[10]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[10]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[10]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[10]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[10]),
     .iopad_ns_sr_load(iopad_ns_sr_load[10]),
     .iopad_ns_sr_data(iopad_ns_sr_data[10]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[10]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[10]),
     .iopad_spare1(iopad_spare1[10]),
     .iopad_spare0(iopad_spare0[10]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[10]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[10]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[10]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[10]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[10]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[10]),
     .iopad_fs_sr_load(iopad_fs_sr_load[10]),
     .iopad_fs_sr_data(iopad_fs_sr_data[10]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[10]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[10]),

     .data_in_f(data_in_f[320*11-1:320*10]),
     .data_out_f(data_out_f[320*11-1:320*10]),
     .data_in(data_in[80*11-1:80*10]),
     .data_out(data_out[80*11-1:80*10]),
     .m_ns_fwd_clk(m_ns_fwd_clk[10]),
     .m_fs_rcv_clk(m_fs_rcv_clk[10]),
     .m_fs_fwd_clk(m_fs_fwd_clk[10]),
     .m_ns_rcv_clk(m_ns_rcv_clk[10]),
     .m_wr_clk(m_wr_clk[10]),
     .m_rd_clk(m_wr_clk[10]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[10]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[10]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[10]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[10]),
     .ms_tx_transfer_en(ms_tx_transfer_en[10]),
     .ms_rx_transfer_en(ms_rx_transfer_en[10]),
     .sl_tx_transfer_en(sl_tx_transfer_en[10]),
     .sl_rx_transfer_en(sl_rx_transfer_en[10]),
     .m_rxfifo_align_done(m_rxfifo_align_done[10]),
     .wa_error(wa_error[10]),
     .wa_error_cnt(wa_error_cnt[4*11-1:4*10]),


     .sr_ms_tomac(sr_ms_tomac[81*11-1:81*10]),
     .sr_sl_tomac(sr_sl_tomac[73*11-1:73*10]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*11-1:27*10]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*11-1:3*10]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*11-1:26*10]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*11-1:5*10]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*11-1:58*10]),


     .ns_adapter_rstn(ns_adapter_rstn[10]),
     .ns_mac_rdy(ns_mac_rdy[10]),
     .fs_mac_rdy(fs_mac_rdy[10]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[10]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[9]),

     .i_channel_id(6'd10),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[10]),
     .o_cfg_avmm_rdata(o_rdata_ch[10]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[10]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel11
 (
     .iopad_tx(iopad_tx[40*12-1:40*11]),
     .iopad_rx(iopad_rx[40*12-1:40*11]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[11]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[11]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[11]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[11]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[11]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[11]),
     .iopad_ns_sr_load(iopad_ns_sr_load[11]),
     .iopad_ns_sr_data(iopad_ns_sr_data[11]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[11]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[11]),
     .iopad_spare1(iopad_spare1[11]),
     .iopad_spare0(iopad_spare0[11]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[11]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[11]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[11]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[11]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[11]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[11]),
     .iopad_fs_sr_load(iopad_fs_sr_load[11]),
     .iopad_fs_sr_data(iopad_fs_sr_data[11]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[11]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[11]),

     .data_in_f(data_in_f[320*12-1:320*11]),
     .data_out_f(data_out_f[320*12-1:320*11]),
     .data_in(data_in[80*12-1:80*11]),
     .data_out(data_out[80*12-1:80*11]),
     .m_ns_fwd_clk(m_ns_fwd_clk[11]),
     .m_fs_rcv_clk(m_fs_rcv_clk[11]),
     .m_fs_fwd_clk(m_fs_fwd_clk[11]),
     .m_ns_rcv_clk(m_ns_rcv_clk[11]),
     .m_wr_clk(m_wr_clk[11]),
     .m_rd_clk(m_wr_clk[11]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[11]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[11]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[11]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[11]),
     .ms_tx_transfer_en(ms_tx_transfer_en[11]),
     .ms_rx_transfer_en(ms_rx_transfer_en[11]),
     .sl_tx_transfer_en(sl_tx_transfer_en[11]),
     .sl_rx_transfer_en(sl_rx_transfer_en[11]),
     .m_rxfifo_align_done(m_rxfifo_align_done[11]),
     .wa_error(wa_error[11]),
     .wa_error_cnt(wa_error_cnt[4*12-1:4*11]),


     .sr_ms_tomac(sr_ms_tomac[81*12-1:81*11]),
     .sr_sl_tomac(sr_sl_tomac[73*12-1:73*11]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*12-1:27*11]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*12-1:3*11]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*12-1:26*11]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*12-1:5*11]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*12-1:58*11]),


     .ns_adapter_rstn(ns_adapter_rstn[11]),
     .ns_mac_rdy(ns_mac_rdy[11]),
     .fs_mac_rdy(fs_mac_rdy[11]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[11]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[10]),

     .i_channel_id(6'd11),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[11]),
     .o_cfg_avmm_rdata(o_rdata_ch[11]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[11]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel12
 (
     .iopad_tx(iopad_tx[40*13-1:40*12]),
     .iopad_rx(iopad_rx[40*13-1:40*12]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[12]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[12]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[12]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[12]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[12]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[12]),
     .iopad_ns_sr_load(iopad_ns_sr_load[12]),
     .iopad_ns_sr_data(iopad_ns_sr_data[12]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[12]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[12]),
     .iopad_spare1(iopad_spare1[12]),
     .iopad_spare0(iopad_spare0[12]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[12]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[12]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[12]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[12]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[12]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[12]),
     .iopad_fs_sr_load(iopad_fs_sr_load[12]),
     .iopad_fs_sr_data(iopad_fs_sr_data[12]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[12]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[12]),

     .data_in_f(data_in_f[320*13-1:320*12]),
     .data_out_f(data_out_f[320*13-1:320*12]),
     .data_in(data_in[80*13-1:80*12]),
     .data_out(data_out[80*13-1:80*12]),
     .m_ns_fwd_clk(m_ns_fwd_clk[12]),
     .m_fs_rcv_clk(m_fs_rcv_clk[12]),
     .m_fs_fwd_clk(m_fs_fwd_clk[12]),
     .m_ns_rcv_clk(m_ns_rcv_clk[12]),
     .m_wr_clk(m_wr_clk[12]),
     .m_rd_clk(m_wr_clk[12]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[12]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[12]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[12]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[12]),
     .ms_tx_transfer_en(ms_tx_transfer_en[12]),
     .ms_rx_transfer_en(ms_rx_transfer_en[12]),
     .sl_tx_transfer_en(sl_tx_transfer_en[12]),
     .sl_rx_transfer_en(sl_rx_transfer_en[12]),
     .m_rxfifo_align_done(m_rxfifo_align_done[12]),
     .wa_error(wa_error[12]),
     .wa_error_cnt(wa_error_cnt[4*13-1:4*12]),


     .sr_ms_tomac(sr_ms_tomac[81*13-1:81*12]),
     .sr_sl_tomac(sr_sl_tomac[73*13-1:73*12]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*13-1:27*12]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*13-1:3*12]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*13-1:26*12]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*13-1:5*12]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*13-1:58*12]),


     .ns_adapter_rstn(ns_adapter_rstn[12]),
     .ns_mac_rdy(ns_mac_rdy[12]),
     .fs_mac_rdy(fs_mac_rdy[12]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[12]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[11]),

     .i_channel_id(6'd12),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[12]),
     .o_cfg_avmm_rdata(o_rdata_ch[12]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[12]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel13
 (
     .iopad_tx(iopad_tx[40*14-1:40*13]),
     .iopad_rx(iopad_rx[40*14-1:40*13]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[13]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[13]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[13]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[13]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[13]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[13]),
     .iopad_ns_sr_load(iopad_ns_sr_load[13]),
     .iopad_ns_sr_data(iopad_ns_sr_data[13]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[13]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[13]),
     .iopad_spare1(iopad_spare1[13]),
     .iopad_spare0(iopad_spare0[13]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[13]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[13]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[13]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[13]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[13]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[13]),
     .iopad_fs_sr_load(iopad_fs_sr_load[13]),
     .iopad_fs_sr_data(iopad_fs_sr_data[13]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[13]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[13]),

     .data_in_f(data_in_f[320*14-1:320*13]),
     .data_out_f(data_out_f[320*14-1:320*13]),
     .data_in(data_in[80*14-1:80*13]),
     .data_out(data_out[80*14-1:80*13]),
     .m_ns_fwd_clk(m_ns_fwd_clk[13]),
     .m_fs_rcv_clk(m_fs_rcv_clk[13]),
     .m_fs_fwd_clk(m_fs_fwd_clk[13]),
     .m_ns_rcv_clk(m_ns_rcv_clk[13]),
     .m_wr_clk(m_wr_clk[13]),
     .m_rd_clk(m_wr_clk[13]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[13]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[13]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[13]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[13]),
     .ms_tx_transfer_en(ms_tx_transfer_en[13]),
     .ms_rx_transfer_en(ms_rx_transfer_en[13]),
     .sl_tx_transfer_en(sl_tx_transfer_en[13]),
     .sl_rx_transfer_en(sl_rx_transfer_en[13]),
     .m_rxfifo_align_done(m_rxfifo_align_done[13]),
     .wa_error(wa_error[13]),
     .wa_error_cnt(wa_error_cnt[4*14-1:4*13]),


     .sr_ms_tomac(sr_ms_tomac[81*14-1:81*13]),
     .sr_sl_tomac(sr_sl_tomac[73*14-1:73*13]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*14-1:27*13]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*14-1:3*13]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*14-1:26*13]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*14-1:5*13]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*14-1:58*13]),


     .ns_adapter_rstn(ns_adapter_rstn[13]),
     .ns_mac_rdy(ns_mac_rdy[13]),
     .fs_mac_rdy(fs_mac_rdy[13]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[13]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[12]),

     .i_channel_id(6'd13),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[13]),
     .o_cfg_avmm_rdata(o_rdata_ch[13]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[13]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel14
 (
     .iopad_tx(iopad_tx[40*15-1:40*14]),
     .iopad_rx(iopad_rx[40*15-1:40*14]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[14]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[14]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[14]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[14]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[14]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[14]),
     .iopad_ns_sr_load(iopad_ns_sr_load[14]),
     .iopad_ns_sr_data(iopad_ns_sr_data[14]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[14]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[14]),
     .iopad_spare1(iopad_spare1[14]),
     .iopad_spare0(iopad_spare0[14]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[14]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[14]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[14]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[14]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[14]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[14]),
     .iopad_fs_sr_load(iopad_fs_sr_load[14]),
     .iopad_fs_sr_data(iopad_fs_sr_data[14]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[14]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[14]),

     .data_in_f(data_in_f[320*15-1:320*14]),
     .data_out_f(data_out_f[320*15-1:320*14]),
     .data_in(data_in[80*15-1:80*14]),
     .data_out(data_out[80*15-1:80*14]),
     .m_ns_fwd_clk(m_ns_fwd_clk[14]),
     .m_fs_rcv_clk(m_fs_rcv_clk[14]),
     .m_fs_fwd_clk(m_fs_fwd_clk[14]),
     .m_ns_rcv_clk(m_ns_rcv_clk[14]),
     .m_wr_clk(m_wr_clk[14]),
     .m_rd_clk(m_wr_clk[14]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[14]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[14]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[14]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[14]),
     .ms_tx_transfer_en(ms_tx_transfer_en[14]),
     .ms_rx_transfer_en(ms_rx_transfer_en[14]),
     .sl_tx_transfer_en(sl_tx_transfer_en[14]),
     .sl_rx_transfer_en(sl_rx_transfer_en[14]),
     .m_rxfifo_align_done(m_rxfifo_align_done[14]),
     .wa_error(wa_error[14]),
     .wa_error_cnt(wa_error_cnt[4*15-1:4*14]),


     .sr_ms_tomac(sr_ms_tomac[81*15-1:81*14]),
     .sr_sl_tomac(sr_sl_tomac[73*15-1:73*14]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*15-1:27*14]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*15-1:3*14]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*15-1:26*14]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*15-1:5*14]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*15-1:58*14]),


     .ns_adapter_rstn(ns_adapter_rstn[14]),
     .ns_mac_rdy(ns_mac_rdy[14]),
     .fs_mac_rdy(fs_mac_rdy[14]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[14]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[13]),

     .i_channel_id(6'd14),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[14]),
     .o_cfg_avmm_rdata(o_rdata_ch[14]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[14]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel15
 (
     .iopad_tx(iopad_tx[40*16-1:40*15]),
     .iopad_rx(iopad_rx[40*16-1:40*15]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[15]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[15]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[15]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[15]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[15]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[15]),
     .iopad_ns_sr_load(iopad_ns_sr_load[15]),
     .iopad_ns_sr_data(iopad_ns_sr_data[15]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[15]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[15]),
     .iopad_spare1(iopad_spare1[15]),
     .iopad_spare0(iopad_spare0[15]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[15]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[15]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[15]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[15]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[15]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[15]),
     .iopad_fs_sr_load(iopad_fs_sr_load[15]),
     .iopad_fs_sr_data(iopad_fs_sr_data[15]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[15]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[15]),

     .data_in_f(data_in_f[320*16-1:320*15]),
     .data_out_f(data_out_f[320*16-1:320*15]),
     .data_in(data_in[80*16-1:80*15]),
     .data_out(data_out[80*16-1:80*15]),
     .m_ns_fwd_clk(m_ns_fwd_clk[15]),
     .m_fs_rcv_clk(m_fs_rcv_clk[15]),
     .m_fs_fwd_clk(m_fs_fwd_clk[15]),
     .m_ns_rcv_clk(m_ns_rcv_clk[15]),
     .m_wr_clk(m_wr_clk[15]),
     .m_rd_clk(m_wr_clk[15]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[15]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[15]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[15]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[15]),
     .ms_tx_transfer_en(ms_tx_transfer_en[15]),
     .ms_rx_transfer_en(ms_rx_transfer_en[15]),
     .sl_tx_transfer_en(sl_tx_transfer_en[15]),
     .sl_rx_transfer_en(sl_rx_transfer_en[15]),
     .m_rxfifo_align_done(m_rxfifo_align_done[15]),
     .wa_error(wa_error[15]),
     .wa_error_cnt(wa_error_cnt[4*16-1:4*15]),


     .sr_ms_tomac(sr_ms_tomac[81*16-1:81*15]),
     .sr_sl_tomac(sr_sl_tomac[73*16-1:73*15]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*16-1:27*15]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*16-1:3*15]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*16-1:26*15]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*16-1:5*15]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*16-1:58*15]),


     .ns_adapter_rstn(ns_adapter_rstn[15]),
     .ns_mac_rdy(ns_mac_rdy[15]),
     .fs_mac_rdy(fs_mac_rdy[15]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[15]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[14]),

     .i_channel_id(6'd15),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[15]),
     .o_cfg_avmm_rdata(o_rdata_ch[15]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[15]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel16
 (
     .iopad_tx(iopad_tx[40*17-1:40*16]),
     .iopad_rx(iopad_rx[40*17-1:40*16]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[16]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[16]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[16]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[16]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[16]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[16]),
     .iopad_ns_sr_load(iopad_ns_sr_load[16]),
     .iopad_ns_sr_data(iopad_ns_sr_data[16]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[16]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[16]),
     .iopad_spare1(iopad_spare1[16]),
     .iopad_spare0(iopad_spare0[16]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[16]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[16]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[16]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[16]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[16]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[16]),
     .iopad_fs_sr_load(iopad_fs_sr_load[16]),
     .iopad_fs_sr_data(iopad_fs_sr_data[16]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[16]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[16]),

     .data_in_f(data_in_f[320*17-1:320*16]),
     .data_out_f(data_out_f[320*17-1:320*16]),
     .data_in(data_in[80*17-1:80*16]),
     .data_out(data_out[80*17-1:80*16]),
     .m_ns_fwd_clk(m_ns_fwd_clk[16]),
     .m_fs_rcv_clk(m_fs_rcv_clk[16]),
     .m_fs_fwd_clk(m_fs_fwd_clk[16]),
     .m_ns_rcv_clk(m_ns_rcv_clk[16]),
     .m_wr_clk(m_wr_clk[16]),
     .m_rd_clk(m_wr_clk[16]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[16]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[16]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[16]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[16]),
     .ms_tx_transfer_en(ms_tx_transfer_en[16]),
     .ms_rx_transfer_en(ms_rx_transfer_en[16]),
     .sl_tx_transfer_en(sl_tx_transfer_en[16]),
     .sl_rx_transfer_en(sl_rx_transfer_en[16]),
     .m_rxfifo_align_done(m_rxfifo_align_done[16]),
     .wa_error(wa_error[16]),
     .wa_error_cnt(wa_error_cnt[4*17-1:4*16]),


     .sr_ms_tomac(sr_ms_tomac[81*17-1:81*16]),
     .sr_sl_tomac(sr_sl_tomac[73*17-1:73*16]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*17-1:27*16]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*17-1:3*16]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*17-1:26*16]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*17-1:5*16]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*17-1:58*16]),


     .ns_adapter_rstn(ns_adapter_rstn[16]),
     .ns_mac_rdy(ns_mac_rdy[16]),
     .fs_mac_rdy(fs_mac_rdy[16]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[16]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[15]),

     .i_channel_id(6'd16),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[16]),
     .o_cfg_avmm_rdata(o_rdata_ch[16]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[16]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );



aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel17
 (
     .iopad_tx(iopad_tx[40*18-1:40*17]),
     .iopad_rx(iopad_rx[40*18-1:40*17]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[17]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[17]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[17]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[17]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[17]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[17]),
     .iopad_ns_sr_load(iopad_ns_sr_load[17]),
     .iopad_ns_sr_data(iopad_ns_sr_data[17]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[17]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[17]),
     .iopad_spare1(iopad_spare1[17]),
     .iopad_spare0(iopad_spare0[17]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[17]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[17]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[17]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[17]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[17]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[17]),
     .iopad_fs_sr_load(iopad_fs_sr_load[17]),
     .iopad_fs_sr_data(iopad_fs_sr_data[17]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[17]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[17]),

     .data_in_f(data_in_f[320*18-1:320*17]),
     .data_out_f(data_out_f[320*18-1:320*17]),
     .data_in(data_in[80*18-1:80*17]),
     .data_out(data_out[80*18-1:80*17]),
     .m_ns_fwd_clk(m_ns_fwd_clk[17]),
     .m_fs_rcv_clk(m_fs_rcv_clk[17]),
     .m_fs_fwd_clk(m_fs_fwd_clk[17]),
     .m_ns_rcv_clk(m_ns_rcv_clk[17]),
     .m_wr_clk(m_wr_clk[17]),
     .m_rd_clk(m_wr_clk[17]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[17]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[17]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[17]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[17]),
     .ms_tx_transfer_en(ms_tx_transfer_en[17]),
     .ms_rx_transfer_en(ms_rx_transfer_en[17]),
     .sl_tx_transfer_en(sl_tx_transfer_en[17]),
     .sl_rx_transfer_en(sl_rx_transfer_en[17]),
     .m_rxfifo_align_done(m_rxfifo_align_done[17]),
     .wa_error(wa_error[17]),
     .wa_error_cnt(wa_error_cnt[4*18-1:4*17]),


     .sr_ms_tomac(sr_ms_tomac[81*18-1:81*17]),
     .sr_sl_tomac(sr_sl_tomac[73*18-1:73*17]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*18-1:27*17]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*18-1:3*17]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*18-1:26*17]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*18-1:5*17]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*18-1:58*17]),


     .ns_adapter_rstn(ns_adapter_rstn[17]),
     .ns_mac_rdy(ns_mac_rdy[17]),
     .fs_mac_rdy(fs_mac_rdy[17]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[17]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[16]),

     .i_channel_id(6'd17),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[17]),
     .o_cfg_avmm_rdata(o_rdata_ch[17]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[17]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel18
 (
     .iopad_tx(iopad_tx[40*19-1:40*18]),
     .iopad_rx(iopad_rx[40*19-1:40*18]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[18]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[18]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[18]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[18]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[18]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[18]),
     .iopad_ns_sr_load(iopad_ns_sr_load[18]),
     .iopad_ns_sr_data(iopad_ns_sr_data[18]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[18]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[18]),
     .iopad_spare1(iopad_spare1[18]),
     .iopad_spare0(iopad_spare0[18]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[18]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[18]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[18]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[18]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[18]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[18]),
     .iopad_fs_sr_load(iopad_fs_sr_load[18]),
     .iopad_fs_sr_data(iopad_fs_sr_data[18]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[18]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[18]),

     .data_in_f(data_in_f[320*19-1:320*18]),
     .data_out_f(data_out_f[320*19-1:320*18]),
     .data_in(data_in[80*19-1:80*18]),
     .data_out(data_out[80*19-1:80*18]),
     .m_ns_fwd_clk(m_ns_fwd_clk[18]),
     .m_fs_rcv_clk(m_fs_rcv_clk[18]),
     .m_fs_fwd_clk(m_fs_fwd_clk[18]),
     .m_ns_rcv_clk(m_ns_rcv_clk[18]),
     .m_wr_clk(m_wr_clk[18]),
     .m_rd_clk(m_wr_clk[18]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[18]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[18]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[18]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[18]),
     .ms_tx_transfer_en(ms_tx_transfer_en[18]),
     .ms_rx_transfer_en(ms_rx_transfer_en[18]),
     .sl_tx_transfer_en(sl_tx_transfer_en[18]),
     .sl_rx_transfer_en(sl_rx_transfer_en[18]),
     .m_rxfifo_align_done(m_rxfifo_align_done[18]),
     .wa_error(wa_error[18]),
     .wa_error_cnt(wa_error_cnt[4*19-1:4*18]),


     .sr_ms_tomac(sr_ms_tomac[81*19-1:81*18]),
     .sr_sl_tomac(sr_sl_tomac[73*19-1:73*18]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*19-1:27*18]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*19-1:3*18]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*19-1:26*18]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*19-1:5*18]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*19-1:58*18]),


     .ns_adapter_rstn(ns_adapter_rstn[18]),
     .ns_mac_rdy(ns_mac_rdy[18]),
     .fs_mac_rdy(fs_mac_rdy[18]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[18]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[17]),

     .i_channel_id(6'd18),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[18]),
     .o_cfg_avmm_rdata(o_rdata_ch[18]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[18]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel19
 (
     .iopad_tx(iopad_tx[40*20-1:40*19]),
     .iopad_rx(iopad_rx[40*20-1:40*19]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[19]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[19]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[19]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[19]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[19]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[19]),
     .iopad_ns_sr_load(iopad_ns_sr_load[19]),
     .iopad_ns_sr_data(iopad_ns_sr_data[19]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[19]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[19]),
     .iopad_spare1(iopad_spare1[19]),
     .iopad_spare0(iopad_spare0[19]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[19]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[19]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[19]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[19]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[19]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[19]),
     .iopad_fs_sr_load(iopad_fs_sr_load[19]),
     .iopad_fs_sr_data(iopad_fs_sr_data[19]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[19]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[19]),

     .data_in_f(data_in_f[320*20-1:320*19]),
     .data_out_f(data_out_f[320*20-1:320*19]),
     .data_in(data_in[80*20-1:80*19]),
     .data_out(data_out[80*20-1:80*19]),
     .m_ns_fwd_clk(m_ns_fwd_clk[19]),
     .m_fs_rcv_clk(m_fs_rcv_clk[19]),
     .m_fs_fwd_clk(m_fs_fwd_clk[19]),
     .m_ns_rcv_clk(m_ns_rcv_clk[19]),
     .m_wr_clk(m_wr_clk[19]),
     .m_rd_clk(m_wr_clk[19]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[19]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[19]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[19]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[19]),
     .ms_tx_transfer_en(ms_tx_transfer_en[19]),
     .ms_rx_transfer_en(ms_rx_transfer_en[19]),
     .sl_tx_transfer_en(sl_tx_transfer_en[19]),
     .sl_rx_transfer_en(sl_rx_transfer_en[19]),
     .m_rxfifo_align_done(m_rxfifo_align_done[19]),
     .wa_error(wa_error[19]),
     .wa_error_cnt(wa_error_cnt[4*20-1:4*19]),


     .sr_ms_tomac(sr_ms_tomac[81*20-1:81*19]),
     .sr_sl_tomac(sr_sl_tomac[73*20-1:73*19]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*20-1:27*19]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*20-1:3*19]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*20-1:26*19]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*20-1:5*19]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*20-1:58*19]),


     .ns_adapter_rstn(ns_adapter_rstn[19]),
     .ns_mac_rdy(ns_mac_rdy[19]),
     .fs_mac_rdy(fs_mac_rdy[19]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[19]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[18]),

     .i_channel_id(6'd19),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[19]),
     .o_cfg_avmm_rdata(o_rdata_ch[19]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[19]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel20
 (
     .iopad_tx(iopad_tx[40*21-1:40*20]),
     .iopad_rx(iopad_rx[40*21-1:40*20]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[20]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[20]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[20]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[20]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[20]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[20]),
     .iopad_ns_sr_load(iopad_ns_sr_load[20]),
     .iopad_ns_sr_data(iopad_ns_sr_data[20]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[20]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[20]),
     .iopad_spare1(iopad_spare1[20]),
     .iopad_spare0(iopad_spare0[20]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[20]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[20]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[20]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[20]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[20]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[20]),
     .iopad_fs_sr_load(iopad_fs_sr_load[20]),
     .iopad_fs_sr_data(iopad_fs_sr_data[20]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[20]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[20]),

     .data_in_f(data_in_f[320*21-1:320*20]),
     .data_out_f(data_out_f[320*21-1:320*20]),
     .data_in(data_in[80*21-1:80*20]),
     .data_out(data_out[80*21-1:80*20]),
     .m_ns_fwd_clk(m_ns_fwd_clk[20]),
     .m_fs_rcv_clk(m_fs_rcv_clk[20]),
     .m_fs_fwd_clk(m_fs_fwd_clk[20]),
     .m_ns_rcv_clk(m_ns_rcv_clk[20]),
     .m_wr_clk(m_wr_clk[20]),
     .m_rd_clk(m_wr_clk[20]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[20]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[20]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[20]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[20]),
     .ms_tx_transfer_en(ms_tx_transfer_en[20]),
     .ms_rx_transfer_en(ms_rx_transfer_en[20]),
     .sl_tx_transfer_en(sl_tx_transfer_en[20]),
     .sl_rx_transfer_en(sl_rx_transfer_en[20]),
     .m_rxfifo_align_done(m_rxfifo_align_done[20]),
     .wa_error(wa_error[20]),
     .wa_error_cnt(wa_error_cnt[4*21-1:4*20]),


     .sr_ms_tomac(sr_ms_tomac[81*21-1:81*20]),
     .sr_sl_tomac(sr_sl_tomac[73*21-1:73*20]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*21-1:27*20]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*21-1:3*20]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*21-1:26*20]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*21-1:5*20]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*21-1:58*20]),


     .ns_adapter_rstn(ns_adapter_rstn[20]),
     .ns_mac_rdy(ns_mac_rdy[20]),
     .fs_mac_rdy(fs_mac_rdy[20]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[20]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[19]),

     .i_channel_id(6'd20),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[20]),
     .o_cfg_avmm_rdata(o_rdata_ch[20]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[20]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel21
 (
     .iopad_tx(iopad_tx[40*22-1:40*21]),
     .iopad_rx(iopad_rx[40*22-1:40*21]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[21]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[21]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[21]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[21]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[21]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[21]),
     .iopad_ns_sr_load(iopad_ns_sr_load[21]),
     .iopad_ns_sr_data(iopad_ns_sr_data[21]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[21]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[21]),
     .iopad_spare1(iopad_spare1[21]),
     .iopad_spare0(iopad_spare0[21]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[21]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[21]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[21]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[21]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[21]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[21]),
     .iopad_fs_sr_load(iopad_fs_sr_load[21]),
     .iopad_fs_sr_data(iopad_fs_sr_data[21]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[21]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[21]),

     .data_in_f(data_in_f[320*22-1:320*21]),
     .data_out_f(data_out_f[320*22-1:320*21]),
     .data_in(data_in[80*22-1:80*21]),
     .data_out(data_out[80*22-1:80*21]),
     .m_ns_fwd_clk(m_ns_fwd_clk[21]),
     .m_fs_rcv_clk(m_fs_rcv_clk[21]),
     .m_fs_fwd_clk(m_fs_fwd_clk[21]),
     .m_ns_rcv_clk(m_ns_rcv_clk[21]),
     .m_wr_clk(m_wr_clk[21]),
     .m_rd_clk(m_wr_clk[21]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[21]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[21]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[21]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[21]),
     .ms_tx_transfer_en(ms_tx_transfer_en[21]),
     .ms_rx_transfer_en(ms_rx_transfer_en[21]),
     .sl_tx_transfer_en(sl_tx_transfer_en[21]),
     .sl_rx_transfer_en(sl_rx_transfer_en[21]),
     .m_rxfifo_align_done(m_rxfifo_align_done[21]),
     .wa_error(wa_error[21]),
     .wa_error_cnt(wa_error_cnt[4*22-1:4*21]),


     .sr_ms_tomac(sr_ms_tomac[81*22-1:81*21]),
     .sr_sl_tomac(sr_sl_tomac[73*22-1:73*21]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*22-1:27*21]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*22-1:3*21]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*22-1:26*21]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*22-1:5*21]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*22-1:58*21]),


     .ns_adapter_rstn(ns_adapter_rstn[21]),
     .ns_mac_rdy(ns_mac_rdy[21]),
     .fs_mac_rdy(fs_mac_rdy[21]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[21]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[20]),

     .i_channel_id(6'd21),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[21]),
     .o_cfg_avmm_rdata(o_rdata_ch[21]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[21]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel22
 (
     .iopad_tx(iopad_tx[40*23-1:40*22]),
     .iopad_rx(iopad_rx[40*23-1:40*22]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[22]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[22]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[22]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[22]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[22]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[22]),
     .iopad_ns_sr_load(iopad_ns_sr_load[22]),
     .iopad_ns_sr_data(iopad_ns_sr_data[22]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[22]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[22]),
     .iopad_spare1(iopad_spare1[22]),
     .iopad_spare0(iopad_spare0[22]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[22]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[22]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[22]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[22]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[22]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[22]),
     .iopad_fs_sr_load(iopad_fs_sr_load[22]),
     .iopad_fs_sr_data(iopad_fs_sr_data[22]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[22]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[22]),

     .data_in_f(data_in_f[320*23-1:320*22]),
     .data_out_f(data_out_f[320*23-1:320*22]),
     .data_in(data_in[80*23-1:80*22]),
     .data_out(data_out[80*23-1:80*22]),
     .m_ns_fwd_clk(m_ns_fwd_clk[22]),
     .m_fs_rcv_clk(m_fs_rcv_clk[22]),
     .m_fs_fwd_clk(m_fs_fwd_clk[22]),
     .m_ns_rcv_clk(m_ns_rcv_clk[22]),
     .m_wr_clk(m_wr_clk[22]),
     .m_rd_clk(m_wr_clk[22]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[22]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[22]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[22]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[22]),
     .ms_tx_transfer_en(ms_tx_transfer_en[22]),
     .ms_rx_transfer_en(ms_rx_transfer_en[22]),
     .sl_tx_transfer_en(sl_tx_transfer_en[22]),
     .sl_rx_transfer_en(sl_rx_transfer_en[22]),
     .m_rxfifo_align_done(m_rxfifo_align_done[22]),
     .wa_error(wa_error[22]),
     .wa_error_cnt(wa_error_cnt[4*23-1:4*22]),


     .sr_ms_tomac(sr_ms_tomac[81*23-1:81*22]),
     .sr_sl_tomac(sr_sl_tomac[73*23-1:73*22]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*23-1:27*22]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*23-1:3*22]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*23-1:26*22]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*23-1:5*22]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*23-1:58*22]),


     .ns_adapter_rstn(ns_adapter_rstn[22]),
     .ns_mac_rdy(ns_mac_rdy[22]),
     .fs_mac_rdy(fs_mac_rdy[22]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[22]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[21]),

     .i_channel_id(6'd22),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[22]),
     .o_cfg_avmm_rdata(o_rdata_ch[22]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[22]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel23
 (
     .iopad_tx(iopad_tx[40*24-1:40*23]),
     .iopad_rx(iopad_rx[40*24-1:40*23]),
     .iopad_ns_rcv_clkb(iopad_ns_rcv_clkb[23]),
     .iopad_ns_rcv_clk(iopad_ns_rcv_clk[23]),
     .iopad_ns_fwd_clk(iopad_ns_fwd_clk[23]),
     .iopad_ns_fwd_clkb(iopad_ns_fwd_clkb[23]),
     .iopad_ns_sr_clk(iopad_ns_sr_clk[23]),
     .iopad_ns_sr_clkb(iopad_ns_sr_clkb[23]),
     .iopad_ns_sr_load(iopad_ns_sr_load[23]),
     .iopad_ns_sr_data(iopad_ns_sr_data[23]),
     .iopad_ns_mac_rdy(iopad_ns_mac_rdy[23]),
     .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn[23]),
     .iopad_spare1(iopad_spare1[23]),
     .iopad_spare0(iopad_spare0[23]),
     .iopad_fs_rcv_clkb(iopad_fs_rcv_clkb[23]),
     .iopad_fs_rcv_clk(iopad_fs_rcv_clk[23]),
     .iopad_fs_fwd_clkb(iopad_fs_fwd_clkb[23]),
     .iopad_fs_fwd_clk(iopad_fs_fwd_clk[23]),
     .iopad_fs_sr_clkb(iopad_fs_sr_clkb[23]),
     .iopad_fs_sr_clk(iopad_fs_sr_clk[23]),
     .iopad_fs_sr_load(iopad_fs_sr_load[23]),
     .iopad_fs_sr_data(iopad_fs_sr_data[23]),
     .iopad_fs_mac_rdy(iopad_fs_mac_rdy[23]),
     .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn[23]),

     .data_in_f(data_in_f[320*24-1:320*23]),
     .data_out_f(data_out_f[320*24-1:320*23]),
     .data_in(data_in[80*24-1:80*23]),
     .data_out(data_out[80*24-1:80*23]),
     .m_ns_fwd_clk(m_ns_fwd_clk[23]),
     .m_fs_rcv_clk(m_fs_rcv_clk[23]),
     .m_fs_fwd_clk(m_fs_fwd_clk[23]),
     .m_ns_rcv_clk(m_ns_rcv_clk[23]),
     .m_wr_clk(m_wr_clk[23]),
     .m_rd_clk(m_wr_clk[23]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[23]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[23]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[23]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[23]),
     .ms_tx_transfer_en(ms_tx_transfer_en[23]),
     .ms_rx_transfer_en(ms_rx_transfer_en[23]),
     .sl_tx_transfer_en(sl_tx_transfer_en[23]),
     .sl_rx_transfer_en(sl_rx_transfer_en[23]),
     .m_rxfifo_align_done(m_rxfifo_align_done[23]),
     .wa_error(wa_error[23]),
     .wa_error_cnt(wa_error_cnt[4*24-1:4*23]),


     .sr_ms_tomac(sr_ms_tomac[81*24-1:81*23]),
     .sr_sl_tomac(sr_sl_tomac[73*24-1:73*23]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*24-1:27*23]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*24-1:3*23]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*24-1:26*23]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*24-1:5*23]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*24-1:58*23]),


     .ns_adapter_rstn(ns_adapter_rstn[23]),
     .ns_mac_rdy(ns_mac_rdy[23]),
     .fs_mac_rdy(fs_mac_rdy[23]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .scan_out(o_jtag_tdo_ch[23]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[22]),

     .i_channel_id(6'd23),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[23]),
     .o_cfg_avmm_rdata(o_rdata_ch[23]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[23]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );



aib_aux_channel  aib_aux_channel
   (
    // AIB IO Bidirectional
    .iopad_dev_dect(device_detect),
    .iopad_dev_dectrdcy(device_detect),
    .iopad_dev_por(por),
    .iopad_dev_porrdcy(por),

//  .device_detect_ms(ms_device_detect),
    .m_por_ovrd(m_por_ovrd),
    .m_device_detect_ovrd(m_device_detect_ovrd),
    .por_ms(o_m_power_on_reset),
    .m_device_detect(m_device_detect),
    .por_sl(i_m_power_on_reset),
//  .osc_clk(i_osc_clk),
    .ms_nsl(dual_mode_select),
    .irstb(1'b1) // Output buffer tri-state enable
    );


endmodule // aib
