// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    :aib_adapt 2.0
// Revision       :1.0
// ============================================================================


module aib_adapt_2doto (

input          dual_mode_select,
input          m_gen2_mode,
input          atpg_mode,
input          adapt_rstn,
input          tx_fifo_rstn,
input          rx_fifo_rstn,
//MAC data interface
output [319:0] data_out_f,            //FIFO read data to mac
output [79:0]  data_out,              //register mode data to mac
input  [319:0] data_in_f,             //from mac, FIFO write data
input  [79:0]  data_in,

input          m_ns_fwd_clk,
input          m_ns_rcv_clk,
input          m_wr_clk,
input          m_rd_clk,
output         m_fs_fwd_clk,
output         m_fs_rcv_clk,

//AIB IO data interface
output [79:0]  aibio_dout,            //to IO buffer
input  [79:0]  aibio_din,             //from IO buffer

input          fs_fwd_clk,
input          fs_rcv_clk,
output         ns_fwd_clk,            //send to dcc
output         ns_rcv_clk,

//MAC other signal interface
input          m_ns_adapter_rstn, 
input          m_ns_mac_rdy, 
output         m_fs_mac_rdy,

//AIB IO other signal interface
output         ns_mac_rdyo,
input          fs_mac_rdyi,
output         ns_adapter_rstno,
input          adapter_rstni,

//Control and status from MAC interface
input          conf_done,       // was i_adpt_hard_rst_n
input          ms_rx_dcc_dll_lock_req,
input          ms_tx_dcc_dll_lock_req,
input          sl_tx_dcc_dll_lock_req,
input          sl_rx_dcc_dll_lock_req,
input          ms_tx_dcc_cal_doneint,
input          sl_tx_dcc_cal_doneint,
input          ms_rx_dll_lockint,
input          sl_rx_dll_lockint,
output         ms_tx_transfer_en,
output         ms_rx_transfer_en,
output         sl_tx_transfer_en,
output         sl_rx_transfer_en,

//Interface to DCC and DLL module
output         ms_rx_dll_lock_req,
output         sl_rx_dll_lock_req,
output         ms_tx_dcc_cal_req,
output         sl_tx_dcc_cal_req,

output [80:0]  ms_sideband,
output [72:0]  sl_sideband,
output         m_rx_align_done,

//SR interface with AIB IO

input  wire    sr_clk_in,
input  wire    srd_in,
input  wire    srl_in,

output         sr_clk_out,
output         std_out,
output         stl_out,


//From AUX channel
input          i_osc_clk, //from aux channel

//Sideband user interface
input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register


  // CSR bit
input  [1:0]   csr_rx_fifo_mode,                 
input  [1:0]   csr_tx_fifo_mode,                 
input          csr_rx_wa_en,
input          csr_tx_wm_en,
input  [4:0]   csr_rx_mkbit,
input  [4:0]   csr_tx_mkbit,
input          csr_txswap_en,
input          csr_rxswap_en,
input  [3:0]   csr_tx_phcomp_rd_delay,
input  [3:0]   csr_rx_phcomp_rd_delay,
input          csr_tx_dbi_en,
input          csr_rx_dbi_en,
input  [1:0]   csr_lpbk_mode
);

wire           is_master, is_slave;
wire           dig_rstb;
wire           ms_osc_transfer_en;
wire           ms_osc_transfer_alive;
wire           ms_rx_async_rst;
wire           ms_tx_async_rst;
wire           sl_osc_transfer_en;
wire           sl_rx_async_rst;

wire           sr_ms_load_out;


wire           adpt_rstn;

wire           sr_ms_data_out;
wire [80:0]    ms_data_fr_core, ms_data_to_core;
wire [72:0]    sl_data_fr_core, sl_data_to_core;
wire           sr_sl_data_out;
wire           sr_sl_load_out;
wire           dcc_clk_out;
//
wire [319:0]   tx_adapt_din, rx_adapt_dout;
wire [79:0]    tx_adapt_dout, rx_adapt_din;
wire [1:0]     r_rx_fifo_mode;
wire [1:0]     r_tx_fifo_mode;

wire           sr_sl_clk_out;
wire           ms_tx_transfer_en_m, ms_rx_transfer_en_m;
wire           sl_tx_transfer_en_s, sl_rx_transfer_en_s;

wire           ms_rx_dll_lock, sl_rx_dll_lock;
wire           ms_tx_dcc_cal_done, sl_tx_dcc_cal_done;

reg  [79:0]    data_in_r, data_out_r;
reg  [319:0]   data_in_f_r, data_out_f_r;
wire [79:0]    data_out_int;
wire [319:0]   data_out_f_int;

//////////////////////////////////////////////////////////////////
//    Flop in and Flop out reg mode data and FIFO mode data
//////////////////////////////////////////////////////////////////
assign data_out = data_out_r;
assign data_out_f = data_out_f_r;

always @(posedge m_ns_fwd_clk) data_in_r  <= data_in;
always @(posedge m_wr_clk) data_in_f_r    <= data_in_f;

always @(posedge m_fs_fwd_clk) data_out_r <= data_out_int; 
always @(posedge m_rd_clk) data_out_f_r   <= data_out_f_int; 


///////////////////////////////////////////////////////////////////
//    Control and status relate to calibration state machine
///////////////////////////////////////////////////////////////////

assign ms_tx_transfer_en = dual_mode_select ? ms_tx_transfer_en_m : ms_data_to_core[78];
assign ms_rx_transfer_en = dual_mode_select ? ms_rx_transfer_en_m : ms_data_to_core[75];
assign sl_tx_transfer_en = !dual_mode_select ? sl_tx_transfer_en_s : sl_data_to_core[64];
assign sl_rx_transfer_en = !dual_mode_select ? sl_rx_transfer_en_s : sl_data_to_core[70];


assign m_fs_rcv_clk = fs_rcv_clk;
assign ns_rcv_clk = m_ns_rcv_clk;

assign m_fs_mac_rdy = fs_mac_rdyi;
assign ms_sideband[80:0] = ms_data_to_core[80:0];
assign sl_sideband[72:0] = sl_data_to_core[72:0];

assign is_master = (dual_mode_select == 1'b1) ? 1'b1 : 1'b0;
assign is_slave = !is_master;

assign tx_dcc_cal_req = dual_mode_select ? ms_tx_dcc_cal_req : sl_tx_dcc_cal_req;
assign rx_dll_lock_req = dual_mode_select ? ms_rx_dll_lock_req : sl_rx_dll_lock_req;

assign adpt_rstn =  m_ns_adapter_rstn & adapter_rstni;

assign dig_rstb =  conf_done;

assign sr_clk_out = is_master ? i_osc_clk : sr_sl_clk_out;
assign std_out = is_master ? sr_ms_data_out : sr_sl_data_out;
assign stl_out = is_master ? sr_ms_load_out : sr_sl_load_out;

assign ns_adapter_rstno = m_ns_adapter_rstn; 
assign ns_mac_rdyo = m_ns_mac_rdy;

assign ms_data_fr_core[80:0] = {ms_osc_transfer_en,1'b1,ms_tx_transfer_en_m,2'b11,ms_rx_transfer_en_m,ms_rx_dll_lock, 5'b11111,ms_tx_dcc_cal_done,1'b0,1'b1, ms_external_cntl_65_8[57:0], 1'b1, 1'b0, 1'b1, ms_external_cntl_4_0[4:0]}; 

assign sl_data_fr_core[72:0] = {sl_osc_transfer_en,1'b0,sl_rx_transfer_en_s,sl_rx_dcc_dll_lock_req, sl_rx_dll_lock,3'b0,sl_tx_transfer_en_s,sl_tx_dcc_dll_lock_req, 1'b0,1'b0,1'b1,1'b0, 1'b1, sl_external_cntl_57_32[25:0], sl_tx_dcc_cal_done, sl_external_cntl_30_28[2:0], 1'b0, sl_external_cntl_26_0[26:0]}; 

///////////////////////////////////////////////////////////////////
//     Loopback
///////////////////////////////////////////////////////////////////
wire f_lpbk, n_lpbk;

localparam FARSIDE_LPBK  =  2'b01;
localparam NEARSIDE_LPBK =  2'b10;

assign f_lpbk = (csr_lpbk_mode== FARSIDE_LPBK);
assign n_lpbk = (csr_lpbk_mode== NEARSIDE_LPBK);

//Farside Loopback: Farside -> AIB IO RX -> AIB Adaptor RX out to TX Adaptor in 
assign tx_adapt_din = f_lpbk ? rx_adapt_dout : data_in_f_r;
assign tx_wr_clk  = f_lpbk ? m_rd_clk : m_wr_clk;
assign tx_rd_clk  = f_lpbk ? fs_fwd_clk : m_ns_fwd_clk;  //for read clock and register mode forward clock
assign ns_fwd_clk = tx_rd_clk;  //Send to dcc block.

//Nearside Loopback: TX MAC -> TX Adapter out -> RX Adapter in -> RX MAC
assign rx_adapt_din = n_lpbk ? tx_adapt_dout : aibio_din;
assign rx_wr_clk    = n_lpbk ? m_ns_fwd_clk : fs_fwd_clk;
assign m_fs_fwd_clk = rx_wr_clk;


assign data_out_f_int = rx_adapt_dout;
aib_adapt_rxchnl aib_adapt_rxchnl(
   // Outputs
     .data_out_f(rx_adapt_dout[319:0]),
     .data_out(data_out_int),
     .align_done(m_rx_align_done),
   // Inputs
     .din(rx_adapt_din),   //from io buffer or near side loopback
     .rxfifo_wrclk(rx_wr_clk),
     .m_rd_clk(m_rd_clk),
     .atpg_mode(atpg_mode),
     .m_gen2_mode(m_gen2_mode),
     .adapt_rstn(adapt_rstn),
     .rx_fifo_rstn(rx_fifo_rstn),
     .r_rx_fifo_mode(csr_rx_fifo_mode),
     .r_rx_phcomp_rd_delay(csr_rx_phcomp_rd_delay),
     .r_rx_wa_en(csr_rx_wa_en),
     .r_rx_mkbit(csr_rx_mkbit),
     .r_rxswap_en(csr_rxswap_en),
     .r_rx_dbi_en(csr_rx_dbi_en)
   );

assign aibio_dout = tx_adapt_dout;
aib_adapt_txchnl aib_adapt_txchnl(
   // Outputs
     .dout(tx_adapt_dout[79:0]), 
   //.ns_fwd_clk(ns_fwd_clk),
   // Inputs
     .atpg_mode(atpg_mode),
     .m_gen2_mode(m_gen2_mode),
     .adapt_rstn(adpt_rstn),
     .tx_fifo_rstn(tx_fifo_rstn),
     .m_wr_clk(tx_wr_clk),
     .m_ns_fwd_clk(tx_rd_clk),  //This includes reg mode clock during loopback.
     .data_in_f(tx_adapt_din[319:0]),
     .data_in(data_in_r),
     .r_tx_fifo_mode(csr_tx_fifo_mode),
     .r_tx_phcomp_rd_delay(csr_tx_phcomp_rd_delay),
     .r_tx_wm_en(csr_tx_wm_en),
     .r_tx_mkbit(csr_tx_mkbit),
     .r_txswap_en(csr_txswap_en),
     .r_tx_dbi_en(csr_tx_dbi_en)
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
    .ms_rx_dll_lockint(ms_rx_dll_lockint),   
    .ms_tx_dcc_cal_doneint(ms_tx_dcc_cal_doneint),
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
    .sl_rx_dll_lockint(sl_rx_dll_lockint), //from slave internal
    .sl_rx_dll_locki(sl_data_to_core[68]),   //from sr interface
    .sl_tx_dcc_cal_donei(sl_data_to_core[31]), //from sr interface
    .sl_tx_dcc_cal_doneint(sl_tx_dcc_cal_doneint),  //from slave internal
    .sl_rx_transfer_eni(sl_data_to_core[70]),
    .sl_osc_transfer_eni(sl_data_to_core[72]),
    .sl_fifo_tx_async_rst(),
    .ms_nsl(dual_mode_select),       //
    .atpg_mode(atpg_mode),
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
    .atpg_mode(atpg_mode),
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
    .sr_ms_clk_in(sr_clk_in), //input ms clock
    .ms_nsl(dual_mode_select), 
    .atpg_mode(atpg_mode),
    .reset_n(conf_done)       
    );
endmodule // aib_channel
