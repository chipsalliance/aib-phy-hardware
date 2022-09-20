// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapter #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(

input          dual_mode_select, // mode select: 0 follower and 1 leader
input          m_gen2_mode,      // Indicates generation mode (1: gen 2.0)
input          atpg_mode,        // Enables ATPG
input          adapt_rstn,       // Adapt asynchronous reset
input          tx_fifo_rstn,     // TX FIFO asynchronous reset
input          rx_fifo_rstn,     // RX FIFO asynchronous reset
input          csr_sdr_mode,     // SDR mode enable
//MAC data interface
output [319:0] data_out_f,  // FIFO read data to mac
output [79:0]  data_out,    // Register mode data to mac
input  [319:0] data_in_f,   // FIFO write data from MAC
input  [79:0]  data_in,     // Register mode write data from MAC

input          tx_clk_adapter, // TX DLL clock to adapter
input          m_wr_clk,       // Write domain clock used to store the data
input          m_rd_clk,       // Read domain clock for data output
input          fs_fwd_clk_div, // Divided far side forwarded clock 

//AIB IO data interface
output [79:0]  aibio_dout,   // to IO buffer
input  [79:0]  aibio_din,    // from IO buffer

input          rclk_adapt, // RX DLL clock to adapter

//Control and status from MAC interface
input   ms_rx_dcc_dll_lock_req, // Leader requests calibration of F2L datapath
input   ms_tx_dcc_dll_lock_req, // Leader requests calibration of L2F datapath
input   sl_tx_dcc_dll_lock_req, // Follower requests calibration of F2L datapath
input   sl_rx_dcc_dll_lock_req, // Follower requests calibration of L2F datapath
input   ms_tx_dcc_cal_doneint,  // Calibration of leader DCC is complete
input   sl_tx_dcc_cal_doneint,  // Calibration of follower DCC is complete
input   ms_rx_dll_lockint,      // Calibration of leader DLL is complete
input   sl_rx_dll_lockint,      // Calibration of follower DLL is complete
input   osc_fsm_ms_rstn,        // Oscillator FSM reset for master
input   osc_fsm_sl_rstn,        // Oscillator FSM reset for slave
input   cal_fsm_ms_rstn,        // Calibration FSM reset for master
input   cal_fsm_sl_rstn,        // Calibration FSM reset for slave
output  ms_tx_transfer_en,      // Calibration of leader TX datapath is complete
output  ms_rx_transfer_en,      // Calibration of leader RX datapath is complete
output  sl_tx_transfer_en,    // Calibration of follower TX datapath is complete
output  sl_rx_transfer_en,    // Calibration of follower RX datapath is complete

output [80:0]  ms_sideband,      // Leader  sideband data
output [72:0]  sl_sideband,      // Follower sideband data
output         m_rx_align_done,

//SR interface with AIB IO
input  wire    sr_clk_in, // Sideband clock input
input  wire    srd_in,    // Follower serial data input
input  wire    srl_in,    // Follower serial data load input

output         sr_clk_out, // Sideband clock output
output         std_out,    // Follower serial data output
output         stl_out,    // Follower serial data load output


//From AUX channel
input          i_osc_clk, // Oscillator clock from aux channel

//Sideband user interface
input [26:0] sl_external_cntl_26_0, //user defined bits26-0 for slave shift reg
input [2:0]  sl_external_cntl_30_28,//user defined bits30-28 for slave shift reg
input [25:0] sl_external_cntl_57_32,//user defined bits57-32 for slave shift reg
input [4:0]  ms_external_cntl_4_0,  //user defined bits 4:0 for master shift reg
input [57:0] ms_external_cntl_65_8, //user defined bits65-8 for master shift reg


  // CSR bits
output         fwd_clk_test_sync, // Forwarded clock test enable synchronized
input  [1:0]   csr_rx_fifo_mode, // RX FIFO mode configuration
input  [4:0]   rx_align_threshold, // RX FIFO WAM threshold
input  [1:0]   csr_tx_fifo_mode, // TX FIFO mode configuration
input          csr_rx_wa_en,     // RX Word alignment enable
input          csr_rx_wa_mode,   // Rx word alignment mode sticky bit
input          csr_tx_wm_en,     // TX Word mark insertion enable
input  [4:0]   csr_rx_mkbit,     // Configuration of Rx mark bit position
input  [4:0]   csr_tx_mkbit,     // Configuration of Tx mark bit position
input          csr_txswap_en,    // TX bit swap enable
input          csr_rxswap_en,    // RX bit swap enable
input  [3:0]   csr_tx_phcomp_rd_delay, // TX FIFO phase compensation
input  [3:0]   csr_rx_phcomp_rd_delay, // RX FIFO phase compensation
input          csr_tx_dbi_en,   // TX data bit inversion enable
input          csr_rx_dbi_en,   // RX data bit inversion enable
input  [1:0]   csr_lpbk_mode,   // Loop back mode configuration register
input          n_lpbk,          // Near side loopback indication
input          csr_fwd_clk_test, // Forwarded clock test enable

// BERT access interface
input  [ 5:0] bert_acc_addr,        // BERT access address
input         bert_acc_req,         // BERT access request
input         bert_acc_rdwr,        // BERT access read/write control
input  [31:0] bert_wdata_ff,        // BERT data to be written
output [31:0] rx_bert_rdata_ff,     // Read data from RX BERT interface
output [31:0] tx_bert_rdata_ff,     // Read data from TX BERT interface
output        bert_acc_rq_pend,     // BERT configuration load is pending

// TX BERT control interface
input [3:0] tx_bert_start, // Starts transmitting TX BERT bit sequence
input [3:0] tx_bert_rst,   // Resets TX BERT registers

// TX BERT status interface
output       bert_seed_good, // Indicates all BPRS seeds are not zero.
output [3:0] txbert_run_ff,  // Indicates  TX BERT is running

//  RX BERT control interface
input [3:0] rxbert_start,   // Starts checking input of RX BERT bit sequence
input [3:0] rxbert_rst,     // Resets RX BERT registers
input [3:0] rxbert_seed_in, // Enables the self-seeding in RX BERT

// RX BERT status interface
output [ 3:0] rxbert_run_ff,     // Indicates RX BERT is running
output [ 3:0] rxbert_biterr_ff,  // Error detected in RX BERT checker

// BERT enable
input tx_bert_en, // TX BERT enable

// Avalon clock and asynchronous reset
input i_cfg_avmm_clk,  
input i_cfg_avmm_rst_n

);

localparam FARSIDE_LPBK  =  2'b01;
localparam NEARSIDE_LPBK =  2'b10;

wire           is_master;
wire           ms_osc_transfer_en;
wire           sl_osc_transfer_en;

wire           sr_ms_load_out;

wire           rxrd_fifo_rstn;
wire           rxwr_rstn;
wire           rxwr_fifo_rstn;
wire           rxrd_rstn;
wire           txwr_rstn;
wire           txwr_fifo_rstn;
wire           txrd_rstn;
wire           txrd_fifo_rstn;

wire           sr_ms_data_out;
wire [80:0]    ms_data_fr_core, ms_data_to_core;
wire [72:0]    sl_data_fr_core, sl_data_to_core;
wire           sr_sl_data_out;
wire           sr_sl_load_out;
//
wire [319:0]   tx_adapt_din;
wire [319:0]   rx_adapt_dout;
wire [79:0]    tx_adapt_dout;

wire           sr_sl_clk_out;
wire           ms_tx_transfer_en_m, ms_rx_transfer_en_m;
wire           sl_tx_transfer_en_s, sl_rx_transfer_en_s;

wire           ms_rx_dll_lock, sl_rx_dll_lock;
wire           ms_tx_dcc_cal_done, sl_tx_dcc_cal_done;

reg  [79:0]    data_in_r, data_out_r;
reg  [319:0]   data_in_f_r, data_out_f_r;
wire [79:0]    data_out_int;
wire [319:0]   data_out_f_int;

wire       f_lpbk;
wire       f_lpbk_int;
wire       rxfifo_rd_clk;
wire       txfifo_wr_clk;
wire       m_rd_clk_g;
wire       m_wr_clk_g;
wire       csr_rx_wa_en_sync;
wire       csr_tx_wm_en_sync;
wire       rx_wa_mode_sync;

wire [3:0]  rx_rst_pulse;
wire [3:0]  rx_start_pulse;
wire [3:0]  seed_in_en;
wire [3:0]  rx_bertgen_en;
wire [5:0]  chk3_lane_sel_ff;
wire [5:0]  chk2_lane_sel_ff;
wire [5:0]  chk1_lane_sel_ff;
wire [5:0]  chk0_lane_sel_ff;
wire [2:0]  chk3_ptrn_sel_ff;
wire [2:0]  chk2_ptrn_sel_ff;
wire [2:0]  chk1_ptrn_sel_ff;
wire [2:0]  chk0_ptrn_sel_ff;
wire [48:0] rbert_bit_cnt_ff;
wire [15:0] biterr_cnt_chk3;
wire [15:0] biterr_cnt_chk2;
wire [15:0] biterr_cnt_chk1;
wire [15:0] biterr_cnt_chk0;
wire [127:0] rx_bert3_data; 
wire [127:0] rx_bert2_data; 
wire [127:0] rx_bert1_data; 
wire [127:0] rx_bert0_data; 
wire [3:0]  tx_start_pulse;
wire [3:0]  tx_rst_pulse;
wire [3:0]  tx_bertgen_en;
wire [3:0]  tx_seed_good;
wire [319:0] tx_bert_data_out;
wire        tx_bert_en_sync;
wire [ 2:0] gen0_ptrn_sel_ff;   
wire [ 2:0] gen1_ptrn_sel_ff;   
wire [ 2:0] gen2_ptrn_sel_ff;   
wire [ 2:0] gen3_ptrn_sel_ff;   
wire [ 1:0] lane39_gen_sel_ff;  
wire [ 1:0] lane38_gen_sel_ff; 
wire [ 1:0] lane37_gen_sel_ff; 
wire [ 1:0] lane36_gen_sel_ff;
wire [ 1:0] lane35_gen_sel_ff;
wire [ 1:0] lane34_gen_sel_ff;
wire [ 1:0] lane33_gen_sel_ff;
wire [ 1:0] lane32_gen_sel_ff;
wire [ 1:0] lane31_gen_sel_ff;
wire [ 1:0] lane30_gen_sel_ff;
wire [ 1:0] lane29_gen_sel_ff;
wire [ 1:0] lane28_gen_sel_ff;
wire [ 1:0] lane27_gen_sel_ff;
wire [ 1:0] lane26_gen_sel_ff;
wire [ 1:0] lane25_gen_sel_ff;
wire [ 1:0] lane24_gen_sel_ff;
wire [ 1:0] lane23_gen_sel_ff;
wire [ 1:0] lane22_gen_sel_ff;
wire [ 1:0] lane21_gen_sel_ff;
wire [ 1:0] lane20_gen_sel_ff;
wire [ 1:0] lane19_gen_sel_ff;
wire [ 1:0] lane18_gen_sel_ff;
wire [ 1:0] lane17_gen_sel_ff;
wire [ 1:0] lane16_gen_sel_ff;
wire [ 1:0] lane15_gen_sel_ff;
wire [ 1:0] lane14_gen_sel_ff;
wire [ 1:0] lane13_gen_sel_ff;
wire [ 1:0] lane12_gen_sel_ff;
wire [ 1:0] lane11_gen_sel_ff;
wire [ 1:0] lane10_gen_sel_ff;
wire [ 1:0] lane9_gen_sel_ff;
wire [ 1:0] lane8_gen_sel_ff;
wire [ 1:0] lane7_gen_sel_ff;
wire [ 1:0] lane6_gen_sel_ff;
wire [ 1:0] lane5_gen_sel_ff;
wire [ 1:0] lane4_gen_sel_ff;
wire [ 1:0] lane3_gen_sel_ff;
wire [ 1:0] lane2_gen_sel_ff;
wire [ 1:0] lane1_gen_sel_ff;
wire [ 1:0] lane0_gen_sel_ff;
wire [15:0] seed_ld_0;
wire [15:0] seed_ld_1;
wire [15:0] seed_ld_2;
wire [15:0] seed_ld_3;
wire [31:0] txwdata_sync_ff;

//////////////////////////////////////////////////////////////////
//    Flop in and Flop out reg mode data and FIFO mode data
//////////////////////////////////////////////////////////////////
assign data_out = data_out_r;
assign data_out_f = data_out_f_r;

clk_gate_cel cg_data_in_f(
.clkout (m_wr_clk_g),    // Clock gated
.clk    (m_wr_clk),      // Clock input
.en     (~f_lpbk_int),   // Clock enable
.te     (atpg_mode)      // Test enable
);

// Data Buffer for register mode input
always @(posedge tx_clk_adapter)
  begin: data_in_r_register
    data_in_r <= data_in;
  end // block: data_in_r_register

// Data Buffer for FIFO mode input
always @(posedge m_wr_clk_g)
  begin: data_in_f_r_register
    data_in_f_r <= data_in_f;
  end // block: data_in_f_r_register

// Data Buffer for register mode output
always @(posedge rclk_adapt or negedge rxwr_rstn)
  begin: data_out_r_register
    if(!rxwr_rstn)
      data_out_r[79:0] <= {80{1'b0}};
    else
      data_out_r[79:0] <= data_out_int[79:0]; 
  end // block: data_out_r_register

clk_gate_cel cg_data_out_f(
.clkout (m_rd_clk_g),    // Clock gated
.clk    (m_rd_clk),           // Clock input
.en     (~f_lpbk_int), // Clock enable
.te     (atpg_mode)               // Test enable
);

// Data Buffer for FIFO mode output
always @(posedge m_rd_clk_g or negedge rxrd_fifo_rstn)
  begin: data_out_f_r_register
    if(!rxrd_fifo_rstn)
      data_out_f_r <= {320{1'b0}};
    else
      data_out_f_r[319:0] <= data_out_f_int[319:0];
  end // data_out_f_r_register

///////////////////////////////////////////////////////////////////
//    Control and status relate to calibration state machine
///////////////////////////////////////////////////////////////////

assign ms_tx_transfer_en = dual_mode_select    ?
                           ms_tx_transfer_en_m :
                           ms_data_to_core[78];

assign ms_rx_transfer_en = dual_mode_select    ?
                           ms_rx_transfer_en_m :
                           ms_data_to_core[75];

assign sl_tx_transfer_en = dual_mode_select    ?
                   (n_lpbk ? ms_tx_transfer_en_m : sl_data_to_core[64]) :
                   sl_tx_transfer_en_s;

assign sl_rx_transfer_en = dual_mode_select    ?
                   (n_lpbk ? ms_rx_transfer_en_m : sl_data_to_core[70]) :
                   sl_rx_transfer_en_s;

assign ms_sideband[80:0] = ms_data_to_core[80:0];
assign sl_sideband[72:0] = sl_data_to_core[72:0];

assign is_master = (dual_mode_select == 1'b1) ? 1'b1 : 1'b0;

clk_mux sr_clk_mux_i(
// Inputs
.clk1   (i_osc_clk),     // s=1
.clk2   (sr_sl_clk_out), // s=0
.s      (is_master),
// Outputs
.clkout (sr_clk_out)
);

assign std_out    = is_master ? sr_ms_data_out : sr_sl_data_out;
assign stl_out    = is_master ? sr_ms_load_out : sr_sl_load_out;

assign ms_data_fr_core[80:0] = { ms_osc_transfer_en,
                                 1'b1,
                                 ms_tx_transfer_en_m,
                                 2'b11,
                                 ms_rx_transfer_en_m,
                                 ms_rx_dll_lock,
                                 5'b11111,
                                 ms_tx_dcc_cal_done,
                                 1'b0,
                                 1'b1,
                                 ms_external_cntl_65_8[57:0],
                                 1'b1,
                                 1'b0,
                                 1'b1,
                                 ms_external_cntl_4_0[4:0] }; 

assign sl_data_fr_core[72:0] = {sl_osc_transfer_en,
                                1'b0,
                                sl_rx_transfer_en_s,
                                sl_rx_dcc_dll_lock_req,
                                sl_rx_dll_lock,
                                3'b0,
                                sl_tx_transfer_en_s,
                                sl_tx_dcc_dll_lock_req,
                                1'b0,
                                1'b0,
                                1'b1,
                                1'b0,
                                1'b1,
                                sl_external_cntl_57_32[25:0],
                                sl_tx_dcc_cal_done,
                                sl_external_cntl_30_28[2:0],
                                1'b0,
                                sl_external_cntl_26_0[26:0]}; 

///////////////////////////////////////////////////////////////////
//     Loopback
///////////////////////////////////////////////////////////////////


assign f_lpbk     = (csr_lpbk_mode== FARSIDE_LPBK);
assign f_lpbk_int = f_lpbk & ~atpg_mode;

aib_bit_sync tx_berten_sync_i
(
.clk      (txfifo_wr_clk),  // RX FIFO write clock
.rst_n    (txwr_rstn), // RX FIFO write domain reset
.data_in  (tx_bert_en), // Input to be synchronized
.data_out (tx_bert_en_sync) // Synchronized output
);

// Farside loopback clock mux of RX FIFO read clock
clk_mux fs_lpb_rd_clk_mux(
// Inputs
.clk1   (fs_fwd_clk_div), // s=1
.clk2   (m_rd_clk),       // s=0
.s      (f_lpbk_int),
// Outputs
.clkout (rxfifo_rd_clk)
);

// Farside loopback clock mux of RX FIFO read clock
clk_mux fs_lpb_wr_clk_mux(
// Inputs
.clk1   (fs_fwd_clk_div), // s=1
.clk2   (m_wr_clk),     // s=0
.s      (f_lpbk_int),
// Outputs
.clkout (txfifo_wr_clk)
);

//Farside Loopback: Farside -> AIB IO RX -> AIB Adaptor RX out to TX Adaptor in 
assign tx_adapt_din =
            f_lpbk_int           ?
            rx_adapt_dout[319:0] :
           (tx_bert_en_sync ? tx_bert_data_out[319:0] : data_in_f_r[319:0]);

// FIFO output data
assign data_out_f_int = rx_adapt_dout;

aib_bit_sync csr_rx_wamen_sync
(
.clk      (rclk_adapt),      // RX FIFO write clock
.rst_n    (rxwr_rstn), // RX FIFO write domain reset
.data_in  (csr_rx_wa_en), // Input to be synchronized
.data_out (csr_rx_wa_en_sync) // Synchronized output
);

// Synchronizer for Rx Word alignment mode bit
aib_bit_sync csr_rx_wa_mode_sync
(
.clk      (rclk_adapt),      // RX FIFO write clock
.rst_n    (rxwr_rstn), // RX FIFO write domain reset
.data_in  (csr_rx_wa_mode),  // Input to be synchronized
.data_out (rx_wa_mode_sync)  // Synchronized output
);

// Adapt RX channel
aib_adapter_rxchnl aib_adapt_rxchnl(
   // Outputs
     .rx_adapt_dout(rx_adapt_dout[319:0]),
     .data_out(data_out_int),
     .align_done(m_rx_align_done),
   // Inputs
     .din(aibio_din[79:0]),   //from io buffer or near side loopback
     .rxfifo_wrclk(rclk_adapt),
     .rxfifo_rd_clk(rxfifo_rd_clk),
     .atpg_mode(atpg_mode),
     .m_gen2_mode(m_gen2_mode),
     .rxrd_fifo_rstn (rxrd_fifo_rstn),
     .rxwr_rstn      (rxwr_rstn),
     .rxwr_fifo_rstn (rxwr_fifo_rstn),
     .r_rx_fifo_mode(csr_rx_fifo_mode),
     .rx_align_threshold (rx_align_threshold[4:0]),
     .r_rx_phcomp_rd_delay(csr_rx_phcomp_rd_delay[3:0]),
     .r_rx_wa_en(csr_rx_wa_en_sync),
     .rx_wa_mode_sync (rx_wa_mode_sync),
     .r_rx_mkbit(csr_rx_mkbit[4:0]),
     .r_rxswap_en(csr_rxswap_en),
     .r_rx_dbi_en(csr_rx_dbi_en)
   );

// AIB IO data
assign aibio_dout = tx_adapt_dout;

// Synchronizer Tx Word mark insertion enable
aib_bit_sync csr_tx_wamen_sync
(
.clk      (txfifo_wr_clk),         // TX FIFO write clock
.rst_n    (txwr_rstn),  // TX FIFO write domain reset
.data_in  (csr_tx_wm_en),     // Input to be synchronized
.data_out (csr_tx_wm_en_sync) // Synchronized output
);

// Adapt TX channel
aib_adapter_txchnl aib_adapt_txchnl(
   // Outputs
     .dout(tx_adapt_dout[79:0]), 
   // Inputs
     .atpg_mode(atpg_mode),
     .m_gen2_mode(m_gen2_mode),
     .txwr_fifo_rstn (txwr_fifo_rstn),
     .txrd_rstn      (txrd_rstn),
     .txrd_fifo_rstn (txrd_fifo_rstn),   
     .txfifo_wr_clk(txfifo_wr_clk),
     .tx_clk_adapter(tx_clk_adapter),  //This includes reg mode clock during loopback.
     .tx_adapt_din(tx_adapt_din[319:0]),
     .data_in(data_in_r),
     .r_tx_fifo_mode(csr_tx_fifo_mode),
     .r_tx_phcomp_rd_delay(csr_tx_phcomp_rd_delay[3:0]),
     .r_tx_wm_en(csr_tx_wm_en_sync),
     .r_tx_mkbit(csr_tx_mkbit[4:0]),
     .r_txswap_en(csr_txswap_en),
     .r_tx_dbi_en(csr_tx_dbi_en)
   );

// Reset and calibration
aib_sr_fsm  aib_sm
   (
    .osc_clk(i_osc_clk),    //from aux 
    .sr_ms_clk_in(sr_clk_in), //input ms clock
    .ms_osc_transfer_en(ms_osc_transfer_en),
    .ms_rx_transfer_en(ms_rx_transfer_en_m),
    .ms_rx_dll_lock(ms_rx_dll_lock),
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
    .sl_osc_transfer_en(sl_osc_transfer_en),
    .sl_rx_transfer_en(sl_rx_transfer_en_s),
    .sl_tx_dcc_cal_done(sl_tx_dcc_cal_done),
    .sl_tx_transfer_en(sl_tx_transfer_en_s),
    .sl_rx_dll_lock(sl_rx_dll_lock),
    .sl_tx_dcc_dll_lock_req(sl_data_to_core[63]),
    .sl_rx_dcc_dll_lock_req(sl_data_to_core[69]),
    .sl_rx_dll_lockint(sl_rx_dll_lockint), //from slave internal
    .sl_rx_dll_locki(sl_data_to_core[68]),   //from sr interface
    .sl_tx_dcc_cal_donei(sl_data_to_core[31]), //from sr interface
    .sl_tx_dcc_cal_doneint(sl_tx_dcc_cal_doneint),  //from slave internal
    .sl_rx_transfer_eni(sl_data_to_core[70]),
    .sl_osc_transfer_eni(sl_data_to_core[72]),
    .ms_nsl(dual_mode_select), 
    .n_lpbk (n_lpbk),
    .osc_fsm_ms_rstn (osc_fsm_ms_rstn),
    .osc_fsm_sl_rstn (osc_fsm_sl_rstn),
    .cal_fsm_ms_rstn (cal_fsm_ms_rstn),
    .cal_fsm_sl_rstn (cal_fsm_sl_rstn)  
    );

// Leader sideband chain logic
aib_sr_master #(.MS_LENGTH(7'd81))
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
    .osc_fsm_ms_rstn (osc_fsm_ms_rstn),
    .osc_fsm_sl_rstn (osc_fsm_sl_rstn)
    );

// Follower sideband  chain logic
aib_sr_slave #(.SL_LENGTH(7'd73))
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
    .osc_fsm_sl_rstn(osc_fsm_sl_rstn)       
    );


aib_bert_cdc #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_cdc(
//------------------------------------------------------------------------------
//                    Interface with RX BERT
//------------------------------------------------------------------------------
// outputs
.rx_start_pulse   (rx_start_pulse[3:0]),
.rx_rst_pulse     (rx_rst_pulse[3:0]),
.seed_in_en       (seed_in_en[3:0]),
.chk3_lane_sel_ff (chk3_lane_sel_ff[5:0]), 
.chk2_lane_sel_ff (chk2_lane_sel_ff[5:0]), 
.chk1_lane_sel_ff (chk1_lane_sel_ff[5:0]), 
.chk0_lane_sel_ff (chk0_lane_sel_ff[5:0]), 
.chk3_ptrn_sel_ff (chk3_ptrn_sel_ff[2:0]), 
.chk2_ptrn_sel_ff (chk2_ptrn_sel_ff[2:0]), 
.chk1_ptrn_sel_ff (chk1_ptrn_sel_ff[2:0]), 
.chk0_ptrn_sel_ff (chk0_ptrn_sel_ff[2:0]), 
// inputs
.rxbert_bit_cnt   (rbert_bit_cnt_ff[48:0]),
.biterr_cnt_chk3  (biterr_cnt_chk3[15:0]), 
.biterr_cnt_chk2  (biterr_cnt_chk2[15:0]), 
.biterr_cnt_chk1  (biterr_cnt_chk1[15:0]), 
.biterr_cnt_chk0  (biterr_cnt_chk0[15:0]), 
.rx_bert3_data    (rx_bert3_data[127:0]), 
.rx_bert2_data    (rx_bert2_data[127:0]), 
.rx_bert1_data    (rx_bert1_data[127:0]), 
.rx_bert0_data    (rx_bert0_data[127:0]), 
.rx_bertgen_en    (rx_bertgen_en[3:0]),
//------------------------------------------------------------------------------
//                    Interface with TX BERT
//------------------------------------------------------------------------------
//outputs
.lane39_gen_sel_ff  (lane39_gen_sel_ff[1:0]),
.lane38_gen_sel_ff  (lane38_gen_sel_ff[1:0]),
.lane37_gen_sel_ff  (lane37_gen_sel_ff[1:0]),
.lane36_gen_sel_ff  (lane36_gen_sel_ff[1:0]),
.lane35_gen_sel_ff  (lane35_gen_sel_ff[1:0]),
.lane34_gen_sel_ff  (lane34_gen_sel_ff[1:0]),
.lane33_gen_sel_ff  (lane33_gen_sel_ff[1:0]),
.lane32_gen_sel_ff  (lane32_gen_sel_ff[1:0]),
.lane31_gen_sel_ff  (lane31_gen_sel_ff[1:0]),
.lane30_gen_sel_ff  (lane30_gen_sel_ff[1:0]),
.lane29_gen_sel_ff  (lane29_gen_sel_ff[1:0]),
.lane28_gen_sel_ff  (lane28_gen_sel_ff[1:0]),
.lane27_gen_sel_ff  (lane27_gen_sel_ff[1:0]),
.lane26_gen_sel_ff  (lane26_gen_sel_ff[1:0]),
.lane25_gen_sel_ff  (lane25_gen_sel_ff[1:0]),
.lane24_gen_sel_ff  (lane24_gen_sel_ff[1:0]),
.lane23_gen_sel_ff  (lane23_gen_sel_ff[1:0]),
.lane22_gen_sel_ff  (lane22_gen_sel_ff[1:0]),
.lane21_gen_sel_ff  (lane21_gen_sel_ff[1:0]),
.lane20_gen_sel_ff  (lane20_gen_sel_ff[1:0]),
.lane19_gen_sel_ff  (lane19_gen_sel_ff[1:0]),
.lane18_gen_sel_ff  (lane18_gen_sel_ff[1:0]),
.lane17_gen_sel_ff  (lane17_gen_sel_ff[1:0]),
.lane16_gen_sel_ff  (lane16_gen_sel_ff[1:0]),
.lane15_gen_sel_ff  (lane15_gen_sel_ff[1:0]),
.lane14_gen_sel_ff  (lane14_gen_sel_ff[1:0]),
.lane13_gen_sel_ff  (lane13_gen_sel_ff[1:0]),
.lane12_gen_sel_ff  (lane12_gen_sel_ff[1:0]),
.lane11_gen_sel_ff  (lane11_gen_sel_ff[1:0]),
.lane10_gen_sel_ff  (lane10_gen_sel_ff[1:0]),
.lane9_gen_sel_ff   (lane9_gen_sel_ff[1:0]),
.lane8_gen_sel_ff   (lane8_gen_sel_ff[1:0]),
.lane7_gen_sel_ff   (lane7_gen_sel_ff[1:0]),
.lane6_gen_sel_ff   (lane6_gen_sel_ff[1:0]),
.lane5_gen_sel_ff   (lane5_gen_sel_ff[1:0]),
.lane4_gen_sel_ff   (lane4_gen_sel_ff[1:0]),
.lane3_gen_sel_ff   (lane3_gen_sel_ff[1:0]),
.lane2_gen_sel_ff   (lane2_gen_sel_ff[1:0]),
.lane1_gen_sel_ff   (lane1_gen_sel_ff[1:0]),
.lane0_gen_sel_ff   (lane0_gen_sel_ff[1:0]),
.gen0_ptrn_sel_ff   (gen0_ptrn_sel_ff[2:0]),
.gen1_ptrn_sel_ff   (gen1_ptrn_sel_ff[2:0]),
.gen2_ptrn_sel_ff   (gen2_ptrn_sel_ff[2:0]),
.gen3_ptrn_sel_ff   (gen3_ptrn_sel_ff[2:0]),
.tx_start_pulse     (tx_start_pulse[3:0]),
.tx_rst_pulse       (tx_rst_pulse[3:0]),
.seed_ld_0          (seed_ld_0[15:0]),      
.seed_ld_1          (seed_ld_1[15:0]),      
.seed_ld_2          (seed_ld_2[15:0]),      
.seed_ld_3          (seed_ld_3[15:0]),      
.txwdata_sync_ff    (txwdata_sync_ff[31:0]),
//inputs
.tx_seed_good  (tx_seed_good[3:0]),
.tx_bertgen_en (tx_bertgen_en[3:0]),
//------------------------------------------------------------------------------
//                    BERT access interface
//------------------------------------------------------------------------------
// outputs
.rx_bert_rdata_ff (rx_bert_rdata_ff[31:0]), // Read data from RX BERT interface
.tx_bert_rdata_ff (tx_bert_rdata_ff[31:0]), // Read data from TX BERT interface
.bert_acc_rq_pend (bert_acc_rq_pend),     // BERT configuration load is pending
// inputs
.bert_acc_addr (bert_acc_addr[5:0]),  // BERT access address
.bert_acc_req  (bert_acc_req),        // BERT access request
.bert_acc_rdwr (bert_acc_rdwr),       // BERT access read/write control
.bert_wdata_ff (bert_wdata_ff[31:0]), // BERT data to be written
//------------------------------------------------------------------------------
//                        TX BERT control interface
//------------------------------------------------------------------------------
// inputs
.tx_bert_start (tx_bert_start[3:0]), // Starts transmitting TX BERT bit sequence
.tx_bert_rst   (tx_bert_rst[3:0]),   // Resets TX BERT registers
//------------------------------------------------------------------------------
//                        TX BERT status interface
//------------------------------------------------------------------------------
// outputs
.bert_seed_good (bert_seed_good),      // Indicates all BPRS seeds are not zero.
.txbert_run_ff  (txbert_run_ff[3:0]),  // Indicates  TX BERT is running
//------------------------------------------------------------------------------
//                        RX BERT control interface
//------------------------------------------------------------------------------
// inputs
.rxbert_start   (rxbert_start[3:0]), // Starts checking input of RX BERT bit seq
.rxbert_rst     (rxbert_rst[3:0]),     // Resets RX BERT registers
.rxbert_seed_in (rxbert_seed_in[3:0]), // Enables the self-seeding in RX BERT
//------------------------------------------------------------------------------
//                        RX BERT status interface
//------------------------------------------------------------------------------
// outputs
.rxbert_run_ff    (rxbert_run_ff[3:0]),    // Indicates RX BERT is running
.rxbert_biterr_ff (rxbert_biterr_ff[3:0]), // Error detected in RX BERT checker
//------------------------------------------------------------------------------
// clocks and resets
//------------------------------------------------------------------------------
// inputs
.i_cfg_avmm_clk   (i_cfg_avmm_clk),
.i_cfg_avmm_rst_n (i_cfg_avmm_rst_n),
.txfifo_wr_clk    (txfifo_wr_clk),
.txwr_rstn        (txwr_rstn),
.rxfifo_rd_clk    (rxfifo_rd_clk),
.rxrd_rstn        (rxrd_rstn)
);

aib_rx_bert #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_rx_bert(
// Inputs
.clk             (rxfifo_rd_clk),         // Rx BERT clock
.rstn            (rxrd_fifo_rstn),        // Active low asynchronous reset 
.rx_rst_pulse    (rx_rst_pulse[3:0]),     // Resets synchronously RX BERT logic
.rx_start_pulse  (rx_start_pulse[3:0]),   // Starts data comparison
.seed_in_en      (seed_in_en[3:0]),       // Seed input mode enable
.chk3_lane_sel_ff (chk3_lane_sel_ff[5:0]), // Lane selection to checker3
.chk2_lane_sel_ff (chk2_lane_sel_ff[5:0]), // Lane selection to checker2
.chk1_lane_sel_ff (chk1_lane_sel_ff[5:0]), // Lane selection to checker1
.chk0_lane_sel_ff (chk0_lane_sel_ff[5:0]), // Lane selection to checker0
.chk3_ptrn_sel_ff (chk3_ptrn_sel_ff[2:0]), // Pattern selection to checker 3
.chk2_ptrn_sel_ff (chk2_ptrn_sel_ff[2:0]), // Pattern selection to checker 2
.chk1_ptrn_sel_ff (chk1_ptrn_sel_ff[2:0]), // Pattern selection to checker 1
.chk0_ptrn_sel_ff (chk0_ptrn_sel_ff[2:0]), // Pattern selection to checker 0
.rx_bert_data_i   (rx_adapt_dout[319:0]),  // Data bits from RX FIFO
.sdr_mode         (csr_sdr_mode),          // Single data rate mode
.r_fifo_mode      (csr_rx_fifo_mode[1:0]), // RX FIFO mode
.m_gen2_mode      (m_gen2_mode),           // GEN2 mode selector
// Outputs
.rbert_bit_cnt_ff (rbert_bit_cnt_ff[48:0]),
.biterr_cnt_chk3  (biterr_cnt_chk3[15:0]), 
.biterr_cnt_chk2  (biterr_cnt_chk2[15:0]), 
.biterr_cnt_chk1  (biterr_cnt_chk1[15:0]), 
.biterr_cnt_chk0  (biterr_cnt_chk0[15:0]), 
.rx_bert3_data    (rx_bert3_data[127:0]), 
.rx_bert2_data    (rx_bert2_data[127:0]), 
.rx_bert1_data    (rx_bert1_data[127:0]), 
.rx_bert0_data    (rx_bert0_data[127:0]), 
.rbert_running_ff (rx_bertgen_en[3:0]) // RX BERT checker is running
);

aib_tx_bert #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_tx_bert(
// Inputs
.clk               (txfifo_wr_clk),         // TX BERT clock
.rstn              (txwr_fifo_rstn),        // Active low asynchronous reset
.tx_start_pulse    (tx_start_pulse[3:0]),   // Start pulse 
.tx_rst_pulse      (tx_rst_pulse[3:0]),     // Synchronous reset pulse
.gen0_ptrn_sel_ff  (gen0_ptrn_sel_ff[2:0]),
.gen1_ptrn_sel_ff  (gen1_ptrn_sel_ff[2:0]),
.gen2_ptrn_sel_ff  (gen2_ptrn_sel_ff[2:0]),
.gen3_ptrn_sel_ff  (gen3_ptrn_sel_ff[2:0]),
.lane39_gen_sel_ff (lane39_gen_sel_ff[1:0]),
.lane38_gen_sel_ff (lane38_gen_sel_ff[1:0]),
.lane37_gen_sel_ff (lane37_gen_sel_ff[1:0]),
.lane36_gen_sel_ff (lane36_gen_sel_ff[1:0]),
.lane35_gen_sel_ff (lane35_gen_sel_ff[1:0]),
.lane34_gen_sel_ff (lane34_gen_sel_ff[1:0]),
.lane33_gen_sel_ff (lane33_gen_sel_ff[1:0]),
.lane32_gen_sel_ff (lane32_gen_sel_ff[1:0]),
.lane31_gen_sel_ff (lane31_gen_sel_ff[1:0]),
.lane30_gen_sel_ff (lane30_gen_sel_ff[1:0]),
.lane29_gen_sel_ff (lane29_gen_sel_ff[1:0]),
.lane28_gen_sel_ff (lane28_gen_sel_ff[1:0]),
.lane27_gen_sel_ff (lane27_gen_sel_ff[1:0]),
.lane26_gen_sel_ff (lane26_gen_sel_ff[1:0]),
.lane25_gen_sel_ff (lane25_gen_sel_ff[1:0]),
.lane24_gen_sel_ff (lane24_gen_sel_ff[1:0]),
.lane23_gen_sel_ff (lane23_gen_sel_ff[1:0]),
.lane22_gen_sel_ff (lane22_gen_sel_ff[1:0]),
.lane21_gen_sel_ff (lane21_gen_sel_ff[1:0]),
.lane20_gen_sel_ff (lane20_gen_sel_ff[1:0]),
.lane19_gen_sel_ff (lane19_gen_sel_ff[1:0]),
.lane18_gen_sel_ff (lane18_gen_sel_ff[1:0]),
.lane17_gen_sel_ff (lane17_gen_sel_ff[1:0]),
.lane16_gen_sel_ff (lane16_gen_sel_ff[1:0]),
.lane15_gen_sel_ff (lane15_gen_sel_ff[1:0]),
.lane14_gen_sel_ff (lane14_gen_sel_ff[1:0]),
.lane13_gen_sel_ff (lane13_gen_sel_ff[1:0]),
.lane12_gen_sel_ff (lane12_gen_sel_ff[1:0]),
.lane11_gen_sel_ff (lane11_gen_sel_ff[1:0]),
.lane10_gen_sel_ff (lane10_gen_sel_ff[1:0]),
.lane9_gen_sel_ff  (lane9_gen_sel_ff[1:0]),
.lane8_gen_sel_ff  (lane8_gen_sel_ff[1:0]),
.lane7_gen_sel_ff  (lane7_gen_sel_ff[1:0]),
.lane6_gen_sel_ff  (lane6_gen_sel_ff[1:0]),
.lane5_gen_sel_ff  (lane5_gen_sel_ff[1:0]),
.lane4_gen_sel_ff  (lane4_gen_sel_ff[1:0]),
.lane3_gen_sel_ff  (lane3_gen_sel_ff[1:0]),
.lane2_gen_sel_ff  (lane2_gen_sel_ff[1:0]),
.lane1_gen_sel_ff  (lane1_gen_sel_ff[1:0]),
.lane0_gen_sel_ff  (lane0_gen_sel_ff[1:0]),
.seed_ld_0         (seed_ld_0[15:0]),       // Generator0 seed load
.seed_ld_1         (seed_ld_1[15:0]),       // Generator1 seed load
.seed_ld_2         (seed_ld_2[15:0]),       // Generator2 seed load
.seed_ld_3         (seed_ld_3[15:0]),       // Generator3 seed load
.txwdata_sync_ff   (txwdata_sync_ff[31:0]), // Data bus to load seed
.sdr_mode          (csr_sdr_mode),          // SDR mode enable
.tx_fifo_mode      (csr_tx_fifo_mode),      // TX FIFO mode field
.m_gen2_mode       (m_gen2_mode),           // GEN2 mode selector
// Outputs
.tx_seed_good     (tx_seed_good[3:0]),
.tx_bertgen_en    (tx_bertgen_en[3:0]),
.tx_bert_data_out (tx_bert_data_out[319:0]) // TX Bert output 
);


//------------------------------------------------------------------------------
//                     RX channel reset synchronizers
//------------------------------------------------------------------------------

// RX FIFO read reset synchronizer
aib_rst_sync rxrd_fifo_rstnsync
  (
    .clk(rxfifo_rd_clk),             // Destination clock of reset to be synced
    .i_rst_n(rx_fifo_rstn),     // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(rxrd_fifo_rstn) // Synchronized reset output
   );

// RX write reset synchronizer
aib_rst_sync rxwr_rstnsync
  (
    .clk(rclk_adapt),      // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),  // Asynchronous reset input
    .scan_mode(atpg_mode), // Scan bypass for reset
    .sync_rst_n(rxwr_rstn) // Synchronized reset output

   );

// RX FIFO write reset synchronizer
aib_rst_sync rxwr_fifo_rstnsync
  (
    .clk(rclk_adapt),         // Destination clock of reset to be synced
    .i_rst_n(rx_fifo_rstn),     // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(rxwr_fifo_rstn) // Synchronized reset output
   );

// RX read reset synchronizer
aib_rst_sync rxrd_rstnsync
  (
    .clk(rxfifo_rd_clk),        // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),  // Asynchronous reset input
    .scan_mode(atpg_mode), // Scan bypass for reset
    .sync_rst_n(rxrd_rstn) // Synchronized reset output
   );

//------------------------------------------------------------------------------
//                     TX channel reset synchronizers
//------------------------------------------------------------------------------

// TX write reset synchronizer
aib_rst_sync txwr_rstnsync
  (
    .clk(txfifo_wr_clk),         // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),   // Asynchronous reset input
    .scan_mode(atpg_mode),  // Scan bypass for reset
    .sync_rst_n(txwr_rstn)  // Synchronized reset output
   );

// TX FIFO write reset synchronizer
aib_rst_sync txwr_fifo_rstnsync
  (
    .clk(txfifo_wr_clk),             // Destination clock of reset to be synced
    .i_rst_n(tx_fifo_rstn),     // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(txwr_fifo_rstn) // Synchronized reset output
   );

// TX read reset synchronizer
aib_rst_sync txrd_rstnsync
  (
    .clk(tx_clk_adapter),    // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),  // Asynchronous reset input
    .scan_mode(atpg_mode), // Scan bypass for reset
    .sync_rst_n(txrd_rstn) // Synchronized reset output
   );

// TX FIFO read reset synchronizer
aib_rst_sync txrd_fifo_rstnsync
  (
    .clk(tx_clk_adapter),         // Destination clock of reset to be synced
    .i_rst_n(tx_fifo_rstn),     // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(txrd_fifo_rstn) // Synchronized reset output
   );

// Synchronizer for Forwarded clock test
aib_bit_sync #(.DWIDTH (1))
i_fwd_clk_test_sync
(
.clk      (tx_clk_adapter),               
.rst_n    (txrd_rstn),         
.data_in  (csr_fwd_clk_test), 
.data_out (fwd_clk_test_sync)
);


endmodule // aib_adapter
