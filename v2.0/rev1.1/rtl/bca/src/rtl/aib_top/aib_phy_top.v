// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_phy_top #(
    parameter NBR_CHNLS = 24,       // Total number of channels 
    parameter NBR_BUMPS = 102,      // Number of BUMPs
    parameter NBR_PHASES = 4,       // Number of phases
    parameter NBR_LANES = 40,       // Number of lanes
    parameter MS_SSR_LEN = 81,      // Data size for leader side band
    parameter SL_SSR_LEN = 73,      // Data size for follower side band
    parameter SCAN_STR_PER_CH = 10 ,// Scan data input and data output size
    parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
    )
 ( 

// Power supply pins
inout vddc1,  // vddc1 power supply pin (low noise for clock circuits)
inout vddc2,  // vddc2 power supply pin for IOs circuits
inout vddtx,  // vddtx power supply pin for high-speed data
inout vss,    // Ground

// IO PADs
inout wire [NBR_BUMPS-1:0]   iopad_ch0_aib,  // IO pad channel 0
inout wire [NBR_BUMPS-1:0]   iopad_ch1_aib,  // IO pad channel 1
inout wire [NBR_BUMPS-1:0]   iopad_ch2_aib,  // IO pad channel 2
inout wire [NBR_BUMPS-1:0]   iopad_ch3_aib,  // IO pad channel 3
inout wire [NBR_BUMPS-1:0]   iopad_ch4_aib,  // IO pad channel 4
inout wire [NBR_BUMPS-1:0]   iopad_ch5_aib,  // IO pad channel 5
inout wire [NBR_BUMPS-1:0]   iopad_ch6_aib,  // IO pad channel 6
inout wire [NBR_BUMPS-1:0]   iopad_ch7_aib,  // IO pad channel 7
inout wire [NBR_BUMPS-1:0]   iopad_ch8_aib,  // IO pad channel 8
inout wire [NBR_BUMPS-1:0]   iopad_ch9_aib,  // IO pad channel 9
inout wire [NBR_BUMPS-1:0]   iopad_ch10_aib, // IO pad channel 10
inout wire [NBR_BUMPS-1:0]   iopad_ch11_aib, // IO pad channel 11
inout wire [NBR_BUMPS-1:0]   iopad_ch12_aib, // IO pad channel 12
inout wire [NBR_BUMPS-1:0]   iopad_ch13_aib, // IO pad channel 13
inout wire [NBR_BUMPS-1:0]   iopad_ch14_aib, // IO pad channel 14
inout wire [NBR_BUMPS-1:0]   iopad_ch15_aib, // IO pad channel 15
inout wire [NBR_BUMPS-1:0]   iopad_ch16_aib, // IO pad channel 16
inout wire [NBR_BUMPS-1:0]   iopad_ch17_aib, // IO pad channel 17
inout wire [NBR_BUMPS-1:0]   iopad_ch18_aib, // IO pad channel 18
inout wire [NBR_BUMPS-1:0]   iopad_ch19_aib, // IO pad channel 19
inout wire [NBR_BUMPS-1:0]   iopad_ch20_aib, // IO pad channel 20
inout wire [NBR_BUMPS-1:0]   iopad_ch21_aib, // IO pad channel 21
inout wire [NBR_BUMPS-1:0]   iopad_ch22_aib, // IO pad channel 22
inout wire [NBR_BUMPS-1:0]   iopad_ch23_aib, // IO pad channel 23

inout  iopad_device_detect,  // Indicates the presence of a valid leader
inout  iopad_power_on_reset, // Perfoms a power-on-reset in the adapter

input  [NBR_LANES*NBR_PHASES*2*NBR_CHNLS-1 :0] data_in_f,  // FIFO mode input
output [NBR_LANES*NBR_PHASES*2*NBR_CHNLS-1 :0] data_out_f, // FIFO mode output

input  [NBR_LANES*2*NBR_CHNLS-1 :0] data_in,  // Register mode data input
output [NBR_LANES*2*NBR_CHNLS-1 :0] data_out, // Register mode data output

input  [NBR_CHNLS-1:0]    m_ns_fwd_clk, // Clock for transmitting data from the
                                        // near side to the far side
input  [NBR_CHNLS-1:0]    m_ns_rcv_clk, // Receive-domain clock forwarded from
                                        // the near side to the far side for
                                        // transmitting data from the far side
output [NBR_CHNLS-1:0]    m_fs_rcv_clk, // Received from the far side and
                                        // converted from quasi-differential to
                                        // single-ended
output [NBR_CHNLS-1:0]    m_fs_fwd_clk, // Received from the far side and
                                        // converted from quasi-differential to 
                                        // single-ended
input  [NBR_CHNLS-1:0]    m_wr_clk,     // Clocks data_in_f
input  [NBR_CHNLS-1:0]    m_rd_clk,     // Clocks data_out_f
output [NBR_CHNLS-1:0]    ns_fwd_clk,   // Near side forwarded clock to SOC/MAC
output [NBR_CHNLS-1:0]    ns_fwd_clk_div, // Divided near side forwarded clock
                                          // to SoC/MAC
output [NBR_CHNLS-1:0]    fs_fwd_clk,     // Far side forwarded clock to TX MAC
output [NBR_CHNLS-1:0]    fs_fwd_clk_div, // Divided far side forwarded clock to
                                          // SoC/MAC

input  [NBR_CHNLS-1:0]    ns_adapter_rstn, // Resets the AIB Adapter
input  [NBR_CHNLS-1:0]    ns_mac_rdy,   // Indicates that the near side is ready
                                        // for calibration and data transfer
output [NBR_CHNLS-1:0]    fs_mac_rdy,   // Indicates that the far-side MAC is
                                        // ready to transmit data
input                     i_conf_done,  // Single control to reset all AIB
                                        // channels in the interface. LO=reset,
                                        // HI=out of reset.
input                     i_osc_clk,    // Free running oscillator clock for a
                                        // leader interface

input [NBR_CHNLS-1:0]  ms_rx_dcc_dll_lock_req, // Initiates calibration of      
                                               // receive path for a leader
                                               // interface
input  [NBR_CHNLS-1:0] ms_tx_dcc_dll_lock_req, // Initiates calibration of      
                                               // transmit path for a leader
                                               // interface
input  [NBR_CHNLS-1:0] sl_tx_dcc_dll_lock_req, // Initiates calibration of      
                                               // receive path for a follower
                                               // interface
input  [NBR_CHNLS-1:0] sl_rx_dcc_dll_lock_req, // Initiates calibration of      
                                               // transmit path for a follower
                                               // interface

output [NBR_CHNLS-1:0] ms_tx_transfer_en, // Indicates that leader has completed
                                          // its TX path calibration and is
                                          // ready to receive data.
output [NBR_CHNLS-1:0] ms_rx_transfer_en, // Indicates that leader has completed
                                          // its RX path calibration and is
                                          // ready to receive data.
output [NBR_CHNLS-1:0] sl_tx_transfer_en, // Indicates that follower has
                                          // completed its TX path calibration
                                          // and is ready to receive data
output [NBR_CHNLS-1:0] sl_rx_transfer_en, // Indicates that follower has
                                          // completed its RX path calibration
                                          // and is ready to receive data
output [NBR_CHNLS-1:0] m_rx_align_done,   // Indicates that the receiving AIB
                                          // Adapter is aligned to incoming word
                                          // marked data

output [MS_SSR_LEN*NBR_CHNLS-1:0] sr_ms_tomac, // Leader  sideband data
output [SL_SSR_LEN*NBR_CHNLS-1:0] sr_sl_tomac, // Follower  sideband data

input dual_mode_select, // Low: AIB interface is a Follower.
                        // High: AIB interface is a Leadee.
input m_gen2_mode,      // If LO when the AIB interface is released from reset, 
                        // the AIB interface is in Gen1 mode. If HI when the AIB
                        // interface is released from reset, the AIB interface
                        // is in Gen2 mode.

//Aux channel
input  m_por_ovrd, // Intended for standalone test without an AIB partner. 
                   // If LO, the Leader is not in reset. If HI and the AIB
                   // interface signal power_on_reset input is 1, the Leader is 
                   // held in reset. The Leader's power_on_reset input is
                   // required to have a weak pullup so that a no connect on
                   // that input will result in power_on_reset=HI.

input  m_device_detect_ovrd, // Intended for standalone test without an AIB
                             // partner. If LO, the Follower uses the AIB 
                             // interface device_detect input. If HI, the
                             // Follower outputs m_device_detect=1.
input  i_m_power_on_reset,   // Controls the power_on_reset signal sent to the
                             // Leader. Must be stable at power-up.

output m_device_detect, // A copy of the AIB interface signal device_detect from
                        // the Leader, qualified by m_device_detect_ovrd.

output o_m_power_on_reset, // A copy of the power_on_reset signal from the
                           // Follower, qualified by override from m_por_ovrd.

//JTAG signals
input  i_jtag_clkdr,     // Test clock
input  i_jtag_clksel,    // Select the JTAG clock or the operational clock for
                         // the register in the I/O block
input  i_jtag_intest,    // Enable testing of data path
input  i_jtag_mode,      // Teste mode select
input  i_jtag_rstb,      // JTAG reset
input  i_jtag_rstb_en,   // JTAG reset enable
input  i_jtag_tdi,       // Test data input
input  i_jtag_tx_scanen, // JTAG shift DR, active high
input  i_jtag_weakpdn,   // Enable weak pull-down on all AIB IO blocks
input  i_jtag_weakpu,    // Enable weak pull-up on all AIB IO blocks
output o_jtag_tdo,       // last boundary scan chain output, TDO

input  i_scan_clk,       // Scan clock
input  i_scan_clk_500m,  // Scan clock 500m
input  i_scan_clk_1000m, // Scan clock 1000m
input  i_scan_en,        // Scan enable
input  i_scan_mode,      // Scan mode
input  [(NBR_CHNLS*SCAN_STR_PER_CH):0] i_scan_din,  // Scan data input
output [(NBR_CHNLS*SCAN_STR_PER_CH):0] i_scan_dout, // Scan data output


//AVMM interface
input        i_cfg_avmm_clk,      // Avalon interface clock
input        i_cfg_avmm_rst_n,    // Avalon interface reset
input [16:0] i_cfg_avmm_addr,     // address to be programmed
input [3:0]  i_cfg_avmm_byte_en,  // byte enable
input        i_cfg_avmm_read,     // Asserted to indicate the Cfg read access
input        i_cfg_avmm_write,    // Asserted to indicate the Cfg write access
input [31:0] i_cfg_avmm_wdata,    // data to be programmed
output       o_cfg_avmm_rdatavld, // Assert to indicate data available for Cfg 
                                  // read access
output [31:0] o_cfg_avmm_rdata,   // data returned for Cfg read access
output        o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg
                                  // access


//Redundancy control signals for IO buffers
input [27*NBR_CHNLS-1:0]  sl_external_cntl_26_0,  // user defined bits 26:0 for
                                                  // slave shift register
input [3*NBR_CHNLS-1:0]   sl_external_cntl_30_28, // user defined bits 30:28 for
                                                  // slave shift register
input [26*NBR_CHNLS-1:0]  sl_external_cntl_57_32, // user defined bits 57:32 for
                                                  // slave shift register
input [5*NBR_CHNLS-1:0]   ms_external_cntl_4_0,   // user defined bits 4:0 for 
                                                  // master shift register
input [58*NBR_CHNLS-1:0]  ms_external_cntl_65_8   // user defined bits 65:8 for
                                                  // master shift register
);

wire [NBR_CHNLS-1:0] o_cfg_avmm_rdatavld_ch;
wire [NBR_CHNLS-1:0] o_cfg_avmm_waitreq_ch;
wire [NBR_CHNLS-1:0] o_jtag_tdo_ch; 

// Avalon read data bus of each channel
wire [31:0]  o_rdata_ch_0;
wire [31:0]  o_rdata_ch_1;
wire [31:0]  o_rdata_ch_2;
wire [31:0]  o_rdata_ch_3;
wire [31:0]  o_rdata_ch_4;
wire [31:0]  o_rdata_ch_5;
wire [31:0]  o_rdata_ch_6;
wire [31:0]  o_rdata_ch_7;
wire [31:0]  o_rdata_ch_8;
wire [31:0]  o_rdata_ch_9;
wire [31:0]  o_rdata_ch_10;
wire [31:0]  o_rdata_ch_11;
wire [31:0]  o_rdata_ch_12;
wire [31:0]  o_rdata_ch_13;
wire [31:0]  o_rdata_ch_14;
wire [31:0]  o_rdata_ch_15;
wire [31:0]  o_rdata_ch_16;
wire [31:0]  o_rdata_ch_17;
wire [31:0]  o_rdata_ch_18;
wire [31:0]  o_rdata_ch_19;
wire [31:0]  o_rdata_ch_20;
wire [31:0]  o_rdata_ch_21;
wire [31:0]  o_rdata_ch_22;
wire [31:0]  o_rdata_ch_23;
wire [ 3:0]  o_aux_spare_nc;

wire [1:0] clkdiv_adc0;
wire [2:0] adc0_muxsel;
wire       adc0_en;
wire       adc0_start;
wire       adc0_chopen;
wire       adc0_dfx_en;
wire [9:0] adc0_out;
wire       adc0_done;
wire       adc0_anaviewout_nc;

wire [1:0] clkdiv_adc1;
wire [2:0] adc1_muxsel;
wire       adc1_en;
wire       adc1_start;
wire       adc1_chopen;
wire       adc1_dfx_en;
wire [9:0] adc1_out;
wire       adc1_done;
wire       adc1_anaviewout_nc;

wire [1:0] clkdiv_adc2;
wire [2:0] adc2_muxsel;
wire       adc2_en;
wire       adc2_start;
wire       adc2_chopen;
wire       adc2_dfx_en;
wire [9:0] adc2_out;
wire       adc2_done;
wire       adc2_anaviewout_nc;

wire [1:0] clkdiv_adc3;
wire [2:0] adc3_muxsel;
wire       adc3_en;
wire       adc3_start;
wire       adc3_chopen;
wire       adc3_dfx_en;
wire [9:0] adc3_out;
wire       adc3_done;
wire       adc3_anaviewout_nc;

wire [1:0] clkdiv_adc4;
wire [2:0] adc4_muxsel;
wire       adc4_en;
wire       adc4_start;
wire       adc4_chopen;
wire       adc4_dfx_en;
wire [9:0] adc4_out;
wire       adc4_done;
wire       adc4_anaviewout_nc;

wire        pvtmona_en;
wire        pvtmona_dfx_en;
wire [ 2:0] pvtmona_digview_sel;
wire [ 2:0] pvtmona_ref_clkdiv;
wire [ 2:0] pvtmona_osc_clkdiv;
wire [ 2:0] pvtmona_osc_sel;
wire        pvtmona_count_start;
wire [ 9:0] pvtmona_osc_clk_count;
wire        pvtmona_count_done;
wire        pvtmona_digviewout_nc;
wire [ 3:0] o_pvtmona_spare_nc;

wire        pvtmonb_en;
wire        pvtmonb_dfx_en;
wire [ 2:0] pvtmonb_digview_sel;
wire [ 2:0] pvtmonb_ref_clkdiv;
wire [ 2:0] pvtmonb_osc_clkdiv;
wire [ 2:0] pvtmonb_osc_sel;
wire        pvtmonb_count_start;
wire [ 9:0] pvtmonb_osc_clk_count;
wire        pvtmonb_count_done;
wire        pvtmonb_digviewout_nc;
wire [ 3:0] o_pvtmonb_spare_nc;

wire        pvtmonc_en;
wire        pvtmonc_dfx_en;
wire [ 2:0] pvtmonc_digview_sel;
wire [ 2:0] pvtmonc_ref_clkdiv;
wire [ 2:0] pvtmonc_osc_clkdiv;
wire [ 2:0] pvtmonc_osc_sel;
wire        pvtmonc_count_start;
wire [ 9:0] pvtmonc_osc_clk_count;
wire        pvtmonc_count_done;
wire        pvtmonc_digviewout_nc;
wire [ 3:0] o_pvtmonc_spare_nc;

wire        pvtmond_en;
wire        pvtmond_dfx_en;
wire [ 2:0] pvtmond_digview_sel;
wire [ 2:0] pvtmond_ref_clkdiv;
wire [ 2:0] pvtmond_osc_clkdiv;
wire [ 2:0] pvtmond_osc_sel;
wire        pvtmond_count_start;
wire [ 9:0] pvtmond_osc_clk_count;
wire        pvtmond_count_done;
wire        pvtmond_digviewout_nc;
wire [ 3:0] o_pvtmond_spare_nc;

wire        pvtmone_en;
wire        pvtmone_dfx_en;
wire [ 2:0] pvtmone_digview_sel;
wire [ 2:0] pvtmone_ref_clkdiv;
wire [ 2:0] pvtmone_osc_clkdiv;
wire [ 2:0] pvtmone_osc_sel;
wire        pvtmone_count_start;
wire [ 9:0] pvtmone_osc_clk_count;
wire        pvtmone_count_done;
wire        pvtmone_digviewout_nc;
wire [ 3:0] o_pvtmone_spare_nc;

wire [2:0] auxch_rxbuf;

wire        avmm_rdatavld_top;
wire [31:0] avmm_rdata_top;
wire        avmm_waitreq_top;
wire [NBR_CHNLS*4-1:0] txrx_anaviewout;
wire [NBR_CHNLS-1:0]   tx_dll_anaviewout;
wire [NBR_CHNLS-1:0]   rx_dll_anaviewout;
wire [NBR_CHNLS-1:0]   dcs_anaviewout;
wire [(NBR_CHNLS*2)-1:0]   digviewout;
wire [6:0] adc_anain_0;
wire [6:0] adc_anain_1;
wire [6:0] adc_anain_2;
wire [6:0] adc_anain_3;
wire [6:0] adc_anain_4;
assign o_jtag_tdo = o_jtag_tdo_ch[23];

// Avalon glue logic to get channel outputs
aib_avmm_glue_logic aib_avmm_glue_logic(
// Inputs
.i_waitreq_ch      (o_cfg_avmm_waitreq_ch[23:0]),
.i_rdatavld_ch     (o_cfg_avmm_rdatavld_ch[23:0]),
.o_rdata_ch_0      (o_rdata_ch_0[31:0]),
.o_rdata_ch_1      (o_rdata_ch_1[31:0]),
.o_rdata_ch_2      (o_rdata_ch_2[31:0]),
.o_rdata_ch_3      (o_rdata_ch_3[31:0]),
.o_rdata_ch_4      (o_rdata_ch_4[31:0]),
.o_rdata_ch_5      (o_rdata_ch_5[31:0]),
.o_rdata_ch_6      (o_rdata_ch_6[31:0]),
.o_rdata_ch_7      (o_rdata_ch_7[31:0]),
.o_rdata_ch_8      (o_rdata_ch_8[31:0]),
.o_rdata_ch_9      (o_rdata_ch_9[31:0]),
.o_rdata_ch_10     (o_rdata_ch_10[31:0]),
.o_rdata_ch_11     (o_rdata_ch_11[31:0]),
.o_rdata_ch_12     (o_rdata_ch_12[31:0]),
.o_rdata_ch_13     (o_rdata_ch_13[31:0]),
.o_rdata_ch_14     (o_rdata_ch_14[31:0]),
.o_rdata_ch_15     (o_rdata_ch_15[31:0]),
.o_rdata_ch_16     (o_rdata_ch_16[31:0]),
.o_rdata_ch_17     (o_rdata_ch_17[31:0]),
.o_rdata_ch_18     (o_rdata_ch_18[31:0]),
.o_rdata_ch_19     (o_rdata_ch_19[31:0]),
.o_rdata_ch_20     (o_rdata_ch_20[31:0]),
.o_rdata_ch_21     (o_rdata_ch_21[31:0]),
.o_rdata_ch_22     (o_rdata_ch_22[31:0]),
.o_rdata_ch_23     (o_rdata_ch_23[31:0]),
.avmm_rdatavld_top (avmm_rdatavld_top),
.avmm_rdata_top    (avmm_rdata_top[31:0]), 
.avmm_waitreq_top  (avmm_waitreq_top),
// Outputs
.o_waitreq  (o_cfg_avmm_waitreq),
.o_rdatavld (o_cfg_avmm_rdatavld),
.o_rdata    (o_cfg_avmm_rdata[31:0])
);

aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) ) 
aib_channel0
 ( 
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch0_aib),

     .data_in_f(data_in_f[320*1-1:320*0]),
     .data_out_f(data_out_f[320*1-1:320*0]),
     .data_in(data_in[80*1-1:80*0]),
     .data_out(data_out[80*1-1:80*0]),

     .m_ns_fwd_clk(m_ns_fwd_clk[0]), 
     .m_fs_rcv_clk(m_fs_rcv_clk[0]), 
     .m_fs_fwd_clk(m_fs_fwd_clk[0]), 
     .m_ns_rcv_clk(m_ns_rcv_clk[0]), 
     .m_wr_clk(m_wr_clk[0]),
     .m_rd_clk(m_rd_clk[0]),
     .ns_fwd_clk(ns_fwd_clk[0]),
     .ns_fwd_clk_div (ns_fwd_clk_div[0]),
     .fs_fwd_clk (fs_fwd_clk[0]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[0]),

     .i_conf_done(i_conf_done), 
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[0]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[0]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[0]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[0]),
     .ms_tx_transfer_en(ms_tx_transfer_en[0]),
     .ms_rx_transfer_en(ms_rx_transfer_en[0]),
     .sl_tx_transfer_en(sl_tx_transfer_en[0]),
     .sl_rx_transfer_en(sl_rx_transfer_en[0]),
     .m_rx_align_done(m_rx_align_done[0]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*1-1:MS_SSR_LEN*0]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*1-1:SL_SSR_LEN*0]),

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
     .txrx_anaviewout(txrx_anaviewout[4*1-1:4*0]),
     .tx_dll_anaviewout(tx_dll_anaviewout[0]),
     .rx_dll_anaviewout(rx_dll_anaviewout[0]),
     .dcs_anaviewout(dcs_anaviewout[0]),
     .digviewout(digviewout[2*1-1:2*0]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[0]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(i_jtag_tdi),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*1)-1:(SCAN_STR_PER_CH*0)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*1)-1:(SCAN_STR_PER_CH*0)]),

     .i_channel_id(6'd0), 
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr), 
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en), 
     .i_cfg_avmm_read(i_cfg_avmm_read), 
     .i_cfg_avmm_write(i_cfg_avmm_write), 
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata), 

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[0]),
     .o_cfg_avmm_rdata(o_rdata_ch_0[31:0]), 
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[0])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) ) 
aib_channel1
 (   
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch1_aib),
     .data_in_f(data_in_f[320*2-1:320*1]),
     .data_out_f(data_out_f[320*2-1:320*1]),
     .data_in(data_in[80*2-1:80*1]),
     .data_out(data_out[80*2-1:80*1]),
     .m_ns_fwd_clk(m_ns_fwd_clk[1]),
     .m_fs_rcv_clk(m_fs_rcv_clk[1]),
     .m_fs_fwd_clk(m_fs_fwd_clk[1]),
     .m_ns_rcv_clk(m_ns_rcv_clk[1]),
     .m_wr_clk(m_wr_clk[1]),
     .m_rd_clk(m_rd_clk[1]),
     .ns_fwd_clk(ns_fwd_clk[1]),
     .ns_fwd_clk_div (ns_fwd_clk_div[1]),
     .fs_fwd_clk (fs_fwd_clk[1]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[1]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[1]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[1]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[1]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[1]),
     .ms_tx_transfer_en(ms_tx_transfer_en[1]),
     .ms_rx_transfer_en(ms_rx_transfer_en[1]),
     .sl_tx_transfer_en(sl_tx_transfer_en[1]),
     .sl_rx_transfer_en(sl_rx_transfer_en[1]),
     .m_rx_align_done(m_rx_align_done[1]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*2-1:MS_SSR_LEN*1]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*2-1:SL_SSR_LEN*1]),

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
     .txrx_anaviewout(txrx_anaviewout[4*2-1:4*1]),
     .tx_dll_anaviewout(tx_dll_anaviewout[1]),
     .rx_dll_anaviewout(rx_dll_anaviewout[1]),
     .dcs_anaviewout(dcs_anaviewout[1]),
     .digviewout(digviewout[2*2-1:2*1]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[1]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[0]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*2)-1:(SCAN_STR_PER_CH*1)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*2)-1:(SCAN_STR_PER_CH*1)]),

     .i_channel_id(6'd1),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[1]),
     .o_cfg_avmm_rdata(o_rdata_ch_1[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[1])
     );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel2
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch2_aib),
     .data_in_f(data_in_f[320*3-1:320*2]),
     .data_out_f(data_out_f[320*3-1:320*2]),
     .data_in(data_in[80*3-1:80*2]),
     .data_out(data_out[80*3-1:80*2]),
     .m_ns_fwd_clk(m_ns_fwd_clk[2]),
     .m_fs_rcv_clk(m_fs_rcv_clk[2]),
     .m_fs_fwd_clk(m_fs_fwd_clk[2]),
     .m_ns_rcv_clk(m_ns_rcv_clk[2]),
     .m_wr_clk(m_wr_clk[2]),
     .m_rd_clk(m_rd_clk[2]),
     .ns_fwd_clk(ns_fwd_clk[2]),
     .ns_fwd_clk_div (ns_fwd_clk_div[2]),
     .fs_fwd_clk (fs_fwd_clk[2]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[2]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[2]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[2]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[2]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[2]),
     .ms_tx_transfer_en(ms_tx_transfer_en[2]),
     .ms_rx_transfer_en(ms_rx_transfer_en[2]),
     .sl_tx_transfer_en(sl_tx_transfer_en[2]),
     .sl_rx_transfer_en(sl_rx_transfer_en[2]),
     .m_rx_align_done(m_rx_align_done[2]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*3-1:MS_SSR_LEN*2]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*3-1:SL_SSR_LEN*2]),

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
     .txrx_anaviewout(txrx_anaviewout[4*3-1:4*2]),
     .tx_dll_anaviewout(tx_dll_anaviewout[2]),
     .rx_dll_anaviewout(rx_dll_anaviewout[2]),
     .dcs_anaviewout(dcs_anaviewout[2]),
     .digviewout(digviewout[2*3-1:2*2]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[2]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[1]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*3)-1:(SCAN_STR_PER_CH*2)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*3)-1:(SCAN_STR_PER_CH*2)]),

     .i_channel_id(6'd2),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[2]),
     .o_cfg_avmm_rdata(o_rdata_ch_2[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[2])
     );



aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel3
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch3_aib),
     .data_in_f(data_in_f[320*4-1:320*3]),
     .data_out_f(data_out_f[320*4-1:320*3]),
     .data_in(data_in[80*4-1:80*3]),
     .data_out(data_out[80*4-1:80*3]),
     .m_ns_fwd_clk(m_ns_fwd_clk[3]),
     .m_fs_rcv_clk(m_fs_rcv_clk[3]),
     .m_fs_fwd_clk(m_fs_fwd_clk[3]),
     .m_ns_rcv_clk(m_ns_rcv_clk[3]),
     .m_wr_clk(m_wr_clk[3]),
     .m_rd_clk(m_rd_clk[3]),
     .ns_fwd_clk(ns_fwd_clk[3]),
     .ns_fwd_clk_div (ns_fwd_clk_div[3]),
     .fs_fwd_clk (fs_fwd_clk[3]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[3]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[3]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[3]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[3]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[3]),
     .ms_tx_transfer_en(ms_tx_transfer_en[3]),
     .ms_rx_transfer_en(ms_rx_transfer_en[3]),
     .sl_tx_transfer_en(sl_tx_transfer_en[3]),
     .sl_rx_transfer_en(sl_rx_transfer_en[3]),
     .m_rx_align_done(m_rx_align_done[3]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*4-1:MS_SSR_LEN*3]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*4-1:SL_SSR_LEN*3]),

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
     .txrx_anaviewout(txrx_anaviewout[4*4-1:4*3]),
     .tx_dll_anaviewout(tx_dll_anaviewout[3]),
     .rx_dll_anaviewout(rx_dll_anaviewout[3]),
     .dcs_anaviewout(dcs_anaviewout[3]),
     .digviewout(digviewout[2*4-1:2*3]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[3]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[2]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*4)-1:(SCAN_STR_PER_CH*3)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*4)-1:(SCAN_STR_PER_CH*3)]),

     .i_channel_id(6'd3),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[3]),
     .o_cfg_avmm_rdata(o_rdata_ch_3[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[3])
     );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel4
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch4_aib),
     .data_in_f(data_in_f[320*5-1:320*4]),
     .data_out_f(data_out_f[320*5-1:320*4]),
     .data_in(data_in[80*5-1:80*4]),
     .data_out(data_out[80*5-1:80*4]),
     .m_ns_fwd_clk(m_ns_fwd_clk[4]),
     .m_fs_rcv_clk(m_fs_rcv_clk[4]),
     .m_fs_fwd_clk(m_fs_fwd_clk[4]),
     .m_ns_rcv_clk(m_ns_rcv_clk[4]),
     .m_wr_clk(m_wr_clk[4]),
     .m_rd_clk(m_rd_clk[4]),
     .ns_fwd_clk(ns_fwd_clk[4]),
     .ns_fwd_clk_div (ns_fwd_clk_div[4]),
     .fs_fwd_clk (fs_fwd_clk[4]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[4]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[4]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[4]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[4]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[4]),
     .ms_tx_transfer_en(ms_tx_transfer_en[4]),
     .ms_rx_transfer_en(ms_rx_transfer_en[4]),
     .sl_tx_transfer_en(sl_tx_transfer_en[4]),
     .sl_rx_transfer_en(sl_rx_transfer_en[4]),
     .m_rx_align_done(m_rx_align_done[4]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*5-1:MS_SSR_LEN*4]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*5-1:SL_SSR_LEN*4]),

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
     .txrx_anaviewout(txrx_anaviewout[4*5-1:4*4]),
     .tx_dll_anaviewout(tx_dll_anaviewout[4]),
     .rx_dll_anaviewout(rx_dll_anaviewout[4]),
     .dcs_anaviewout(dcs_anaviewout[4]),
     .digviewout(digviewout[2*5-1:2*4]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[4]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[3]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*5)-1:(SCAN_STR_PER_CH*4)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*5)-1:(SCAN_STR_PER_CH*4)]),

     .i_channel_id(6'd4),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[4]),
     .o_cfg_avmm_rdata(o_rdata_ch_4[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[4])
     );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel5
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch5_aib),
     .data_in_f(data_in_f[320*6-1:320*5]),
     .data_out_f(data_out_f[320*6-1:320*5]),
     .data_in(data_in[80*6-1:80*5]),
     .data_out(data_out[80*6-1:80*5]),
     .m_ns_fwd_clk(m_ns_fwd_clk[5]),
     .m_fs_rcv_clk(m_fs_rcv_clk[5]),
     .m_fs_fwd_clk(m_fs_fwd_clk[5]),
     .m_ns_rcv_clk(m_ns_rcv_clk[5]),
     .m_wr_clk(m_wr_clk[5]),
     .m_rd_clk(m_rd_clk[5]),
     .ns_fwd_clk(ns_fwd_clk[5]),
     .ns_fwd_clk_div (ns_fwd_clk_div[5]),
     .fs_fwd_clk (fs_fwd_clk[5]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[5]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[5]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[5]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[5]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[5]),
     .ms_tx_transfer_en(ms_tx_transfer_en[5]),
     .ms_rx_transfer_en(ms_rx_transfer_en[5]),
     .sl_tx_transfer_en(sl_tx_transfer_en[5]),
     .sl_rx_transfer_en(sl_rx_transfer_en[5]),
     .m_rx_align_done(m_rx_align_done[5]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*6-1:MS_SSR_LEN*5]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*6-1:SL_SSR_LEN*5]),

     .dual_mode_select(dual_mode_select),
     .m_gen2_mode(m_gen2_mode),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*6-1:27*5]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*6-1:3*5]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*6-1:26*5]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*6-1:5*5]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*6-1:58*5]),
     .txrx_anaviewout(txrx_anaviewout[4*6-1:4*5]),
     .tx_dll_anaviewout(tx_dll_anaviewout[5]),
     .rx_dll_anaviewout(rx_dll_anaviewout[5]),
     .dcs_anaviewout(dcs_anaviewout[5]),
     .digviewout(digviewout[2*6-1:2*5]),


     .ns_adapter_rstn(ns_adapter_rstn[5]),
     .ns_mac_rdy(ns_mac_rdy[5]),
     .fs_mac_rdy(fs_mac_rdy[5]),
     .por(o_m_power_on_reset),
     .i_osc_clk(i_osc_clk),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[5]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[4]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*6)-1:(SCAN_STR_PER_CH*5)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*6)-1:(SCAN_STR_PER_CH*5)]),

     .i_channel_id(6'd5),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[5]),
     .o_cfg_avmm_rdata(o_rdata_ch_5[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[5])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel6
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch6_aib),
     .data_in_f(data_in_f[320*7-1:320*6]),
     .data_out_f(data_out_f[320*7-1:320*6]),
     .data_in(data_in[80*7-1:80*6]),
     .data_out(data_out[80*7-1:80*6]),
     .m_ns_fwd_clk(m_ns_fwd_clk[6]),
     .m_fs_rcv_clk(m_fs_rcv_clk[6]),
     .m_fs_fwd_clk(m_fs_fwd_clk[6]),
     .m_ns_rcv_clk(m_ns_rcv_clk[6]),
     .m_wr_clk(m_wr_clk[6]),
     .m_rd_clk(m_rd_clk[6]),
     .ns_fwd_clk(ns_fwd_clk[6]),
     .ns_fwd_clk_div (ns_fwd_clk_div[6]),
     .fs_fwd_clk (fs_fwd_clk[6]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[6]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[6]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[6]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[6]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[6]),
     .ms_tx_transfer_en(ms_tx_transfer_en[6]),
     .ms_rx_transfer_en(ms_rx_transfer_en[6]),
     .sl_tx_transfer_en(sl_tx_transfer_en[6]),
     .sl_rx_transfer_en(sl_rx_transfer_en[6]),
     .m_rx_align_done(m_rx_align_done[6]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*7-1:MS_SSR_LEN*6]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*7-1:SL_SSR_LEN*6]),

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
     .txrx_anaviewout(txrx_anaviewout[4*7-1:4*6]),
     .tx_dll_anaviewout(tx_dll_anaviewout[6]),
     .rx_dll_anaviewout(rx_dll_anaviewout[6]),
     .dcs_anaviewout(dcs_anaviewout[6]),
     .digviewout(digviewout[2*7-1:2*6]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[6]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[5]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*7)-1:(SCAN_STR_PER_CH*6)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*7)-1:(SCAN_STR_PER_CH*6)]),

     .i_channel_id(6'd6),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[6]),
     .o_cfg_avmm_rdata(o_rdata_ch_6[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[6])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel7
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch7_aib),
     .data_in_f(data_in_f[320*8-1:320*7]),
     .data_out_f(data_out_f[320*8-1:320*7]),
     .data_in(data_in[80*8-1:80*7]),
     .data_out(data_out[80*8-1:80*7]),
     .m_ns_fwd_clk(m_ns_fwd_clk[7]),
     .m_fs_rcv_clk(m_fs_rcv_clk[7]),
     .m_fs_fwd_clk(m_fs_fwd_clk[7]),
     .m_ns_rcv_clk(m_ns_rcv_clk[7]),
     .m_wr_clk(m_wr_clk[7]),
     .m_rd_clk(m_rd_clk[7]),
     .ns_fwd_clk(ns_fwd_clk[7]),
     .ns_fwd_clk_div (ns_fwd_clk_div[7]),
     .fs_fwd_clk (fs_fwd_clk[7]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[7]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[7]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[7]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[7]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[7]),
     .ms_tx_transfer_en(ms_tx_transfer_en[7]),
     .ms_rx_transfer_en(ms_rx_transfer_en[7]),
     .sl_tx_transfer_en(sl_tx_transfer_en[7]),
     .sl_rx_transfer_en(sl_rx_transfer_en[7]),
     .m_rx_align_done(m_rx_align_done[7]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*8-1:MS_SSR_LEN*7]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*8-1:SL_SSR_LEN*7]),

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
     .txrx_anaviewout(txrx_anaviewout[4*8-1:4*7]),
     .tx_dll_anaviewout(tx_dll_anaviewout[7]),
     .rx_dll_anaviewout(rx_dll_anaviewout[7]),
     .dcs_anaviewout(dcs_anaviewout[7]),
     .digviewout(digviewout[2*8-1:2*7]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[7]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[6]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*8)-1:(SCAN_STR_PER_CH*7)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*8)-1:(SCAN_STR_PER_CH*7)]),

     .i_channel_id(6'd7),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[7]),
     .o_cfg_avmm_rdata(o_rdata_ch_7[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[7])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel8
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch8_aib),
     .data_in_f(data_in_f[320*9-1:320*8]),
     .data_out_f(data_out_f[320*9-1:320*8]),
     .data_in(data_in[80*9-1:80*8]),
     .data_out(data_out[80*9-1:80*8]),
     .m_ns_fwd_clk(m_ns_fwd_clk[8]),
     .m_fs_rcv_clk(m_fs_rcv_clk[8]),
     .m_fs_fwd_clk(m_fs_fwd_clk[8]),
     .m_ns_rcv_clk(m_ns_rcv_clk[8]),
     .m_wr_clk(m_wr_clk[8]),
     .m_rd_clk(m_rd_clk[8]),
     .ns_fwd_clk(ns_fwd_clk[8]),
     .ns_fwd_clk_div (ns_fwd_clk_div[8]),
     .fs_fwd_clk (fs_fwd_clk[8]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[8]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[8]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[8]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[8]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[8]),
     .ms_tx_transfer_en(ms_tx_transfer_en[8]),
     .ms_rx_transfer_en(ms_rx_transfer_en[8]),
     .sl_tx_transfer_en(sl_tx_transfer_en[8]),
     .sl_rx_transfer_en(sl_rx_transfer_en[8]),
     .m_rx_align_done(m_rx_align_done[8]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*9-1:MS_SSR_LEN*8]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*9-1:SL_SSR_LEN*8]),

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
     .txrx_anaviewout(txrx_anaviewout[4*9-1:4*8]),
     .tx_dll_anaviewout(tx_dll_anaviewout[8]),
     .rx_dll_anaviewout(rx_dll_anaviewout[8]),
     .dcs_anaviewout(dcs_anaviewout[8]),
     .digviewout(digviewout[2*9-1:2*8]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[8]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[7]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*9)-1:(SCAN_STR_PER_CH*8)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*9)-1:(SCAN_STR_PER_CH*8)]),

     .i_channel_id(6'd8),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[8]),
     .o_cfg_avmm_rdata(o_rdata_ch_8[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[8])
     );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel9
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch9_aib),
     .data_in_f(data_in_f[320*10-1:320*9]),
     .data_out_f(data_out_f[320*10-1:320*9]),
     .data_in(data_in[80*10-1:80*9]),
     .data_out(data_out[80*10-1:80*9]),
     .m_ns_fwd_clk(m_ns_fwd_clk[9]),
     .m_fs_rcv_clk(m_fs_rcv_clk[9]),
     .m_fs_fwd_clk(m_fs_fwd_clk[9]),
     .m_ns_rcv_clk(m_ns_rcv_clk[9]),
     .m_wr_clk(m_wr_clk[9]),
     .m_rd_clk(m_rd_clk[9]),
     .ns_fwd_clk(ns_fwd_clk[9]),
     .ns_fwd_clk_div (ns_fwd_clk_div[9]),
     .fs_fwd_clk (fs_fwd_clk[9]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[9]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[9]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[9]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[9]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[9]),
     .ms_tx_transfer_en(ms_tx_transfer_en[9]),
     .ms_rx_transfer_en(ms_rx_transfer_en[9]),
     .sl_tx_transfer_en(sl_tx_transfer_en[9]),
     .sl_rx_transfer_en(sl_rx_transfer_en[9]),
     .m_rx_align_done(m_rx_align_done[9]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*10-1:MS_SSR_LEN*9]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*10-1:SL_SSR_LEN*9]),

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
     .txrx_anaviewout(txrx_anaviewout[4*10-1:4*9]),
     .tx_dll_anaviewout(tx_dll_anaviewout[9]),
     .rx_dll_anaviewout(rx_dll_anaviewout[9]),
     .dcs_anaviewout(dcs_anaviewout[9]),
     .digviewout(digviewout[2*10-1:2*9]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[9]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[8]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*10)-1:(SCAN_STR_PER_CH*9)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*10)-1:(SCAN_STR_PER_CH*9)]),

     .i_channel_id(6'd9),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[9]),
     .o_cfg_avmm_rdata(o_rdata_ch_9[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[9])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel10
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch10_aib),
     .data_in_f(data_in_f[320*11-1:320*10]),
     .data_out_f(data_out_f[320*11-1:320*10]),
     .data_in(data_in[80*11-1:80*10]),
     .data_out(data_out[80*11-1:80*10]),
     .m_ns_fwd_clk(m_ns_fwd_clk[10]),
     .m_fs_rcv_clk(m_fs_rcv_clk[10]),
     .m_fs_fwd_clk(m_fs_fwd_clk[10]),
     .m_ns_rcv_clk(m_ns_rcv_clk[10]),
     .m_wr_clk(m_wr_clk[10]),
     .m_rd_clk(m_rd_clk[10]),
     .ns_fwd_clk(ns_fwd_clk[10]),
     .ns_fwd_clk_div (ns_fwd_clk_div[10]),
     .fs_fwd_clk (fs_fwd_clk[10]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[10]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[10]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[10]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[10]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[10]),
     .ms_tx_transfer_en(ms_tx_transfer_en[10]),
     .ms_rx_transfer_en(ms_rx_transfer_en[10]),
     .sl_tx_transfer_en(sl_tx_transfer_en[10]),
     .sl_rx_transfer_en(sl_rx_transfer_en[10]),
     .m_rx_align_done(m_rx_align_done[10]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*11-1:MS_SSR_LEN*10]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*11-1:SL_SSR_LEN*10]),

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
     .txrx_anaviewout(txrx_anaviewout[4*11-1:4*10]),
     .tx_dll_anaviewout(tx_dll_anaviewout[10]),
     .rx_dll_anaviewout(rx_dll_anaviewout[10]),
     .dcs_anaviewout(dcs_anaviewout[10]),
     .digviewout(digviewout[2*11-1:2*10]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[10]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[9]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*11)-1:(SCAN_STR_PER_CH*10)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*11)-1:(SCAN_STR_PER_CH*10)]),

     .i_channel_id(6'd10),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[10]),
     .o_cfg_avmm_rdata(o_rdata_ch_10[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[10])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel11
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch11_aib),
     .data_in_f(data_in_f[320*12-1:320*11]),
     .data_out_f(data_out_f[320*12-1:320*11]),
     .data_in(data_in[80*12-1:80*11]),
     .data_out(data_out[80*12-1:80*11]),
     .m_ns_fwd_clk(m_ns_fwd_clk[11]),
     .m_fs_rcv_clk(m_fs_rcv_clk[11]),
     .m_fs_fwd_clk(m_fs_fwd_clk[11]),
     .m_ns_rcv_clk(m_ns_rcv_clk[11]),
     .m_wr_clk(m_wr_clk[11]),
     .m_rd_clk(m_rd_clk[11]),
     .ns_fwd_clk(ns_fwd_clk[11]),
     .ns_fwd_clk_div (ns_fwd_clk_div[11]),
     .fs_fwd_clk (fs_fwd_clk[11]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[11]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[11]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[11]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[11]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[11]),
     .ms_tx_transfer_en(ms_tx_transfer_en[11]),
     .ms_rx_transfer_en(ms_rx_transfer_en[11]),
     .sl_tx_transfer_en(sl_tx_transfer_en[11]),
     .sl_rx_transfer_en(sl_rx_transfer_en[11]),
     .m_rx_align_done(m_rx_align_done[11]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*12-1:MS_SSR_LEN*11]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*12-1:SL_SSR_LEN*11]),

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
     .txrx_anaviewout(txrx_anaviewout[4*12-1:4*11]),
     .tx_dll_anaviewout(tx_dll_anaviewout[11]),
     .rx_dll_anaviewout(rx_dll_anaviewout[11]),
     .dcs_anaviewout(dcs_anaviewout[11]),
     .digviewout(digviewout[2*12-1:2*11]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[11]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[10]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*12)-1:(SCAN_STR_PER_CH*11)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*12)-1:(SCAN_STR_PER_CH*11)]),

     .i_channel_id(6'd11),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[11]),
     .o_cfg_avmm_rdata(o_rdata_ch_11[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[11])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel12
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch12_aib),
     .data_in_f(data_in_f[320*13-1:320*12]),
     .data_out_f(data_out_f[320*13-1:320*12]),
     .data_in(data_in[80*13-1:80*12]),
     .data_out(data_out[80*13-1:80*12]),
     .m_ns_fwd_clk(m_ns_fwd_clk[12]),
     .m_fs_rcv_clk(m_fs_rcv_clk[12]),
     .m_fs_fwd_clk(m_fs_fwd_clk[12]),
     .m_ns_rcv_clk(m_ns_rcv_clk[12]),
     .m_wr_clk(m_wr_clk[12]),
     .m_rd_clk(m_rd_clk[12]),
     .ns_fwd_clk(ns_fwd_clk[12]),
     .ns_fwd_clk_div (ns_fwd_clk_div[12]),
     .fs_fwd_clk (fs_fwd_clk[12]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[12]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[12]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[12]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[12]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[12]),
     .ms_tx_transfer_en(ms_tx_transfer_en[12]),
     .ms_rx_transfer_en(ms_rx_transfer_en[12]),
     .sl_tx_transfer_en(sl_tx_transfer_en[12]),
     .sl_rx_transfer_en(sl_rx_transfer_en[12]),
     .m_rx_align_done(m_rx_align_done[12]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*13-1:MS_SSR_LEN*12]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*13-1:SL_SSR_LEN*12]),

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
     .txrx_anaviewout(txrx_anaviewout[4*13-1:4*12]),
     .tx_dll_anaviewout(tx_dll_anaviewout[12]),
     .rx_dll_anaviewout(rx_dll_anaviewout[12]),
     .dcs_anaviewout(dcs_anaviewout[12]),
     .digviewout(digviewout[2*13-1:2*12]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[12]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[11]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*13)-1:(SCAN_STR_PER_CH*12)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*13)-1:(SCAN_STR_PER_CH*12)]),

     .i_channel_id(6'd12),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[12]),
     .o_cfg_avmm_rdata(o_rdata_ch_12[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[12])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel13
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch13_aib),
     .data_in_f(data_in_f[320*14-1:320*13]),
     .data_out_f(data_out_f[320*14-1:320*13]),
     .data_in(data_in[80*14-1:80*13]),
     .data_out(data_out[80*14-1:80*13]),
     .m_ns_fwd_clk(m_ns_fwd_clk[13]),
     .m_fs_rcv_clk(m_fs_rcv_clk[13]),
     .m_fs_fwd_clk(m_fs_fwd_clk[13]),
     .m_ns_rcv_clk(m_ns_rcv_clk[13]),
     .m_wr_clk(m_wr_clk[13]),
     .m_rd_clk(m_rd_clk[13]),
     .ns_fwd_clk(ns_fwd_clk[13]),
     .ns_fwd_clk_div (ns_fwd_clk_div[13]),
     .fs_fwd_clk (fs_fwd_clk[13]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[13]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[13]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[13]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[13]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[13]),
     .ms_tx_transfer_en(ms_tx_transfer_en[13]),
     .ms_rx_transfer_en(ms_rx_transfer_en[13]),
     .sl_tx_transfer_en(sl_tx_transfer_en[13]),
     .sl_rx_transfer_en(sl_rx_transfer_en[13]),
     .m_rx_align_done(m_rx_align_done[13]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*14-1:MS_SSR_LEN*13]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*14-1:SL_SSR_LEN*13]),

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
     .txrx_anaviewout(txrx_anaviewout[4*14-1:4*13]),
     .tx_dll_anaviewout(tx_dll_anaviewout[13]),
     .rx_dll_anaviewout(rx_dll_anaviewout[13]),
     .dcs_anaviewout(dcs_anaviewout[13]),
     .digviewout(digviewout[2*14-1:2*13]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[13]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[12]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*14)-1:(SCAN_STR_PER_CH*13)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*14)-1:(SCAN_STR_PER_CH*13)]),

     .i_channel_id(6'd13),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[13]),
     .o_cfg_avmm_rdata(o_rdata_ch_13[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[13])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel14
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch14_aib),
     .data_in_f(data_in_f[320*15-1:320*14]),
     .data_out_f(data_out_f[320*15-1:320*14]),
     .data_in(data_in[80*15-1:80*14]),
     .data_out(data_out[80*15-1:80*14]),
     .m_ns_fwd_clk(m_ns_fwd_clk[14]),
     .m_fs_rcv_clk(m_fs_rcv_clk[14]),
     .m_fs_fwd_clk(m_fs_fwd_clk[14]),
     .m_ns_rcv_clk(m_ns_rcv_clk[14]),
     .m_wr_clk(m_wr_clk[14]),
     .m_rd_clk(m_rd_clk[14]),
     .ns_fwd_clk(ns_fwd_clk[14]),
     .ns_fwd_clk_div (ns_fwd_clk_div[14]),
     .fs_fwd_clk (fs_fwd_clk[14]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[14]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[14]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[14]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[14]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[14]),
     .ms_tx_transfer_en(ms_tx_transfer_en[14]),
     .ms_rx_transfer_en(ms_rx_transfer_en[14]),
     .sl_tx_transfer_en(sl_tx_transfer_en[14]),
     .sl_rx_transfer_en(sl_rx_transfer_en[14]),
     .m_rx_align_done(m_rx_align_done[14]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*15-1:MS_SSR_LEN*14]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*15-1:SL_SSR_LEN*14]),

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
     .txrx_anaviewout(txrx_anaviewout[4*15-1:4*14]),
     .tx_dll_anaviewout(tx_dll_anaviewout[14]),
     .rx_dll_anaviewout(rx_dll_anaviewout[14]),
     .dcs_anaviewout(dcs_anaviewout[14]),
     .digviewout(digviewout[2*15-1:2*14]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[14]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[13]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*15)-1:(SCAN_STR_PER_CH*14)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*15)-1:(SCAN_STR_PER_CH*14)]),

     .i_channel_id(6'd14),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[14]),
     .o_cfg_avmm_rdata(o_rdata_ch_14[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[14])

      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel15
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch15_aib),
     .data_in_f(data_in_f[320*16-1:320*15]),
     .data_out_f(data_out_f[320*16-1:320*15]),
     .data_in(data_in[80*16-1:80*15]),
     .data_out(data_out[80*16-1:80*15]),
     .m_ns_fwd_clk(m_ns_fwd_clk[15]),
     .m_fs_rcv_clk(m_fs_rcv_clk[15]),
     .m_fs_fwd_clk(m_fs_fwd_clk[15]),
     .m_ns_rcv_clk(m_ns_rcv_clk[15]),
     .m_wr_clk(m_wr_clk[15]),
     .m_rd_clk(m_rd_clk[15]),
     .ns_fwd_clk(ns_fwd_clk[15]),
     .ns_fwd_clk_div (ns_fwd_clk_div[15]),
     .fs_fwd_clk (fs_fwd_clk[15]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[15]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[15]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[15]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[15]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[15]),
     .ms_tx_transfer_en(ms_tx_transfer_en[15]),
     .ms_rx_transfer_en(ms_rx_transfer_en[15]),
     .sl_tx_transfer_en(sl_tx_transfer_en[15]),
     .sl_rx_transfer_en(sl_rx_transfer_en[15]),
     .m_rx_align_done(m_rx_align_done[15]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*16-1:MS_SSR_LEN*15]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*16-1:SL_SSR_LEN*15]),

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
     .txrx_anaviewout(txrx_anaviewout[4*16-1:4*15]),
     .tx_dll_anaviewout(tx_dll_anaviewout[15]),
     .rx_dll_anaviewout(rx_dll_anaviewout[15]),
     .dcs_anaviewout(dcs_anaviewout[15]),
     .digviewout(digviewout[2*16-1:2*15]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[15]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[14]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*16)-1:(SCAN_STR_PER_CH*15)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*16)-1:(SCAN_STR_PER_CH*15)]),

     .i_channel_id(6'd15),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[15]),
     .o_cfg_avmm_rdata(o_rdata_ch_15[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[15])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel16
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch16_aib),
     .data_in_f(data_in_f[320*17-1:320*16]),
     .data_out_f(data_out_f[320*17-1:320*16]),
     .data_in(data_in[80*17-1:80*16]),
     .data_out(data_out[80*17-1:80*16]),
     .m_ns_fwd_clk(m_ns_fwd_clk[16]),
     .m_fs_rcv_clk(m_fs_rcv_clk[16]),
     .m_fs_fwd_clk(m_fs_fwd_clk[16]),
     .m_ns_rcv_clk(m_ns_rcv_clk[16]),
     .m_wr_clk(m_wr_clk[16]),
     .m_rd_clk(m_rd_clk[16]),
     .ns_fwd_clk(ns_fwd_clk[16]),
     .ns_fwd_clk_div (ns_fwd_clk_div[16]),
     .fs_fwd_clk (fs_fwd_clk[16]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[16]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[16]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[16]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[16]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[16]),
     .ms_tx_transfer_en(ms_tx_transfer_en[16]),
     .ms_rx_transfer_en(ms_rx_transfer_en[16]),
     .sl_tx_transfer_en(sl_tx_transfer_en[16]),
     .sl_rx_transfer_en(sl_rx_transfer_en[16]),
     .m_rx_align_done(m_rx_align_done[16]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*17-1:MS_SSR_LEN*16]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*17-1:SL_SSR_LEN*16]),

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
     .txrx_anaviewout(txrx_anaviewout[4*17-1:4*16]),
     .tx_dll_anaviewout(tx_dll_anaviewout[16]),
     .rx_dll_anaviewout(rx_dll_anaviewout[16]),
     .dcs_anaviewout(dcs_anaviewout[16]),
     .digviewout(digviewout[2*17-1:2*16]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[16]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[15]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*17)-1:(SCAN_STR_PER_CH*16)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*17)-1:(SCAN_STR_PER_CH*16)]),

     .i_channel_id(6'd16),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[16]),
     .o_cfg_avmm_rdata(o_rdata_ch_16[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[16])
     );



aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel17
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch17_aib),
     .data_in_f(data_in_f[320*18-1:320*17]),
     .data_out_f(data_out_f[320*18-1:320*17]),
     .data_in(data_in[80*18-1:80*17]),
     .data_out(data_out[80*18-1:80*17]),
     .m_ns_fwd_clk(m_ns_fwd_clk[17]),
     .m_fs_rcv_clk(m_fs_rcv_clk[17]),
     .m_fs_fwd_clk(m_fs_fwd_clk[17]),
     .m_ns_rcv_clk(m_ns_rcv_clk[17]),
     .m_wr_clk(m_wr_clk[17]),
     .m_rd_clk(m_rd_clk[17]),
     .ns_fwd_clk(ns_fwd_clk[17]),
     .ns_fwd_clk_div (ns_fwd_clk_div[17]),
     .fs_fwd_clk (fs_fwd_clk[17]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[17]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[17]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[17]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[17]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[17]),
     .ms_tx_transfer_en(ms_tx_transfer_en[17]),
     .ms_rx_transfer_en(ms_rx_transfer_en[17]),
     .sl_tx_transfer_en(sl_tx_transfer_en[17]),
     .sl_rx_transfer_en(sl_rx_transfer_en[17]),
     .m_rx_align_done(m_rx_align_done[17]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*18-1:MS_SSR_LEN*17]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*18-1:SL_SSR_LEN*17]),

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
     .txrx_anaviewout(txrx_anaviewout[4*18-1:4*17]),
     .tx_dll_anaviewout(tx_dll_anaviewout[17]),
     .rx_dll_anaviewout(rx_dll_anaviewout[17]),
     .dcs_anaviewout(dcs_anaviewout[17]),
     .digviewout(digviewout[2*18-1:2*17]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[17]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[16]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*18)-1:(SCAN_STR_PER_CH*17)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*18)-1:(SCAN_STR_PER_CH*17)]),

     .i_channel_id(6'd17),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[17]),
     .o_cfg_avmm_rdata(o_rdata_ch_17[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[17])
     );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel18
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch18_aib),
     .data_in_f(data_in_f[320*19-1:320*18]),
     .data_out_f(data_out_f[320*19-1:320*18]),
     .data_in(data_in[80*19-1:80*18]),
     .data_out(data_out[80*19-1:80*18]),
     .m_ns_fwd_clk(m_ns_fwd_clk[18]),
     .m_fs_rcv_clk(m_fs_rcv_clk[18]),
     .m_fs_fwd_clk(m_fs_fwd_clk[18]),
     .m_ns_rcv_clk(m_ns_rcv_clk[18]),
     .m_wr_clk(m_wr_clk[18]),
     .m_rd_clk(m_rd_clk[18]),
     .ns_fwd_clk(ns_fwd_clk[18]),
     .ns_fwd_clk_div (ns_fwd_clk_div[18]),
     .fs_fwd_clk (fs_fwd_clk[18]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[18]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[18]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[18]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[18]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[18]),
     .ms_tx_transfer_en(ms_tx_transfer_en[18]),
     .ms_rx_transfer_en(ms_rx_transfer_en[18]),
     .sl_tx_transfer_en(sl_tx_transfer_en[18]),
     .sl_rx_transfer_en(sl_rx_transfer_en[18]),
     .m_rx_align_done(m_rx_align_done[18]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*19-1:MS_SSR_LEN*18]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*19-1:SL_SSR_LEN*18]),

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
     .txrx_anaviewout(txrx_anaviewout[4*19-1:4*18]),
     .tx_dll_anaviewout(tx_dll_anaviewout[18]),
     .rx_dll_anaviewout(rx_dll_anaviewout[18]),
     .dcs_anaviewout(dcs_anaviewout[18]),
     .digviewout(digviewout[2*19-1:2*18]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[18]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[17]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*19)-1:(SCAN_STR_PER_CH*18)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*19)-1:(SCAN_STR_PER_CH*18)]),

     .i_channel_id(6'd18),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[18]),
     .o_cfg_avmm_rdata(o_rdata_ch_18[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[18])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel19
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch19_aib),
     .data_in_f(data_in_f[320*20-1:320*19]),
     .data_out_f(data_out_f[320*20-1:320*19]),
     .data_in(data_in[80*20-1:80*19]),
     .data_out(data_out[80*20-1:80*19]),
     .m_ns_fwd_clk(m_ns_fwd_clk[19]),
     .m_fs_rcv_clk(m_fs_rcv_clk[19]),
     .m_fs_fwd_clk(m_fs_fwd_clk[19]),
     .m_ns_rcv_clk(m_ns_rcv_clk[19]),
     .m_wr_clk(m_wr_clk[19]),
     .m_rd_clk(m_rd_clk[19]),
     .ns_fwd_clk(ns_fwd_clk[19]),
     .ns_fwd_clk_div (ns_fwd_clk_div[19]),
     .fs_fwd_clk (fs_fwd_clk[19]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[19]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[19]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[19]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[19]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[19]),
     .ms_tx_transfer_en(ms_tx_transfer_en[19]),
     .ms_rx_transfer_en(ms_rx_transfer_en[19]),
     .sl_tx_transfer_en(sl_tx_transfer_en[19]),
     .sl_rx_transfer_en(sl_rx_transfer_en[19]),
     .m_rx_align_done(m_rx_align_done[19]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*20-1:MS_SSR_LEN*19]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*20-1:SL_SSR_LEN*19]),

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
     .txrx_anaviewout(txrx_anaviewout[4*20-1:4*19]),
     .tx_dll_anaviewout(tx_dll_anaviewout[19]),
     .rx_dll_anaviewout(rx_dll_anaviewout[19]),
     .dcs_anaviewout(dcs_anaviewout[19]),
     .digviewout(digviewout[2*20-1:2*19]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[19]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[18]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*20)-1:(SCAN_STR_PER_CH*19)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*20)-1:(SCAN_STR_PER_CH*19)]),

     .i_channel_id(6'd19),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[19]),
     .o_cfg_avmm_rdata(o_rdata_ch_19[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[19])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel20
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch20_aib),
     .data_in_f(data_in_f[320*21-1:320*20]),
     .data_out_f(data_out_f[320*21-1:320*20]),
     .data_in(data_in[80*21-1:80*20]),
     .data_out(data_out[80*21-1:80*20]),
     .m_ns_fwd_clk(m_ns_fwd_clk[20]),
     .m_fs_rcv_clk(m_fs_rcv_clk[20]),
     .m_fs_fwd_clk(m_fs_fwd_clk[20]),
     .m_ns_rcv_clk(m_ns_rcv_clk[20]),
     .m_wr_clk(m_wr_clk[20]),
     .m_rd_clk(m_rd_clk[20]),
     .ns_fwd_clk(ns_fwd_clk[20]),
     .ns_fwd_clk_div (ns_fwd_clk_div[20]),
     .fs_fwd_clk (fs_fwd_clk[20]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[20]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[20]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[20]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[20]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[20]),
     .ms_tx_transfer_en(ms_tx_transfer_en[20]),
     .ms_rx_transfer_en(ms_rx_transfer_en[20]),
     .sl_tx_transfer_en(sl_tx_transfer_en[20]),
     .sl_rx_transfer_en(sl_rx_transfer_en[20]),
     .m_rx_align_done(m_rx_align_done[20]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*21-1:MS_SSR_LEN*20]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*21-1:SL_SSR_LEN*20]),

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
     .txrx_anaviewout(txrx_anaviewout[4*21-1:4*20]),
     .tx_dll_anaviewout(tx_dll_anaviewout[20]),
     .rx_dll_anaviewout(rx_dll_anaviewout[20]),
     .dcs_anaviewout(dcs_anaviewout[20]),
     .digviewout(digviewout[2*21-1:2*20]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[20]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[19]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*21)-1:(SCAN_STR_PER_CH*20)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*21)-1:(SCAN_STR_PER_CH*20)]),

     .i_channel_id(6'd20),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[20]),
     .o_cfg_avmm_rdata(o_rdata_ch_20[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[20])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel21
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch21_aib),
     .data_in_f(data_in_f[320*22-1:320*21]),
     .data_out_f(data_out_f[320*22-1:320*21]),
     .data_in(data_in[80*22-1:80*21]),
     .data_out(data_out[80*22-1:80*21]),
     .m_ns_fwd_clk(m_ns_fwd_clk[21]),
     .m_fs_rcv_clk(m_fs_rcv_clk[21]),
     .m_fs_fwd_clk(m_fs_fwd_clk[21]),
     .m_ns_rcv_clk(m_ns_rcv_clk[21]),
     .m_wr_clk(m_wr_clk[21]),
     .m_rd_clk(m_rd_clk[21]),
     .ns_fwd_clk(ns_fwd_clk[21]),
     .ns_fwd_clk_div (ns_fwd_clk_div[21]),
     .fs_fwd_clk (fs_fwd_clk[21]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[21]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[21]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[21]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[21]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[21]),
     .ms_tx_transfer_en(ms_tx_transfer_en[21]),
     .ms_rx_transfer_en(ms_rx_transfer_en[21]),
     .sl_tx_transfer_en(sl_tx_transfer_en[21]),
     .sl_rx_transfer_en(sl_rx_transfer_en[21]),
     .m_rx_align_done(m_rx_align_done[21]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*22-1:MS_SSR_LEN*21]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*22-1:SL_SSR_LEN*21]),

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
     .txrx_anaviewout(txrx_anaviewout[4*22-1:4*21]),
     .tx_dll_anaviewout(tx_dll_anaviewout[21]),
     .rx_dll_anaviewout(rx_dll_anaviewout[21]),
     .dcs_anaviewout(dcs_anaviewout[21]),
     .digviewout(digviewout[2*22-1:2*21]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[21]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[20]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*22)-1:(SCAN_STR_PER_CH*21)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*22)-1:(SCAN_STR_PER_CH*21)]),

     .i_channel_id(6'd21),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[21]),
     .o_cfg_avmm_rdata(o_rdata_ch_21[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[21])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel22
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch22_aib),
     .data_in_f(data_in_f[320*23-1:320*22]),
     .data_out_f(data_out_f[320*23-1:320*22]),
     .data_in(data_in[80*23-1:80*22]),
     .data_out(data_out[80*23-1:80*22]),
     .m_ns_fwd_clk(m_ns_fwd_clk[22]),
     .m_fs_rcv_clk(m_fs_rcv_clk[22]),
     .m_fs_fwd_clk(m_fs_fwd_clk[22]),
     .m_ns_rcv_clk(m_ns_rcv_clk[22]),
     .m_wr_clk(m_wr_clk[22]),
     .m_rd_clk(m_rd_clk[22]),
     .ns_fwd_clk(ns_fwd_clk[22]),
     .ns_fwd_clk_div (ns_fwd_clk_div[22]),
     .fs_fwd_clk (fs_fwd_clk[22]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[22]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[22]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[22]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[22]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[22]),
     .ms_tx_transfer_en(ms_tx_transfer_en[22]),
     .ms_rx_transfer_en(ms_rx_transfer_en[22]),
     .sl_tx_transfer_en(sl_tx_transfer_en[22]),
     .sl_rx_transfer_en(sl_rx_transfer_en[22]),
     .m_rx_align_done(m_rx_align_done[22]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*23-1:MS_SSR_LEN*22]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*23-1:SL_SSR_LEN*22]),

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
     .txrx_anaviewout(txrx_anaviewout[4*23-1:4*22]),
     .tx_dll_anaviewout(tx_dll_anaviewout[22]),
     .rx_dll_anaviewout(rx_dll_anaviewout[22]),
     .dcs_anaviewout(dcs_anaviewout[22]),
     .digviewout(digviewout[2*23-1:2*22]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[22]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[21]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*23)-1:(SCAN_STR_PER_CH*22)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*23)-1:(SCAN_STR_PER_CH*22)]),

     .i_channel_id(6'd22),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[22]),
     .o_cfg_avmm_rdata(o_rdata_ch_22[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[22])
      );


aib_channel_n #( .NBR_LANES (NBR_LANES),
                 .SCAN_STR_PER_CH (SCAN_STR_PER_CH),
                 .BERT_BUF_MODE_EN (BERT_BUF_MODE_EN) )  
aib_channel23
 (
     .vddc2 (vddc2),
     .vddc1 (vddc1),
     .vddtx (vddtx),
     .vss   (vss),
     
     .iopad_aib(iopad_ch23_aib),
     .data_in_f(data_in_f[320*24-1:320*23]),
     .data_out_f(data_out_f[320*24-1:320*23]),
     .data_in(data_in[80*24-1:80*23]),
     .data_out(data_out[80*24-1:80*23]),
     .m_ns_fwd_clk(m_ns_fwd_clk[23]),
     .m_fs_rcv_clk(m_fs_rcv_clk[23]),
     .m_fs_fwd_clk(m_fs_fwd_clk[23]),
     .m_ns_rcv_clk(m_ns_rcv_clk[23]),
     .m_wr_clk(m_wr_clk[23]),
     .m_rd_clk(m_rd_clk[23]),
     .ns_fwd_clk(ns_fwd_clk[23]),
     .ns_fwd_clk_div (ns_fwd_clk_div[23]),
     .fs_fwd_clk (fs_fwd_clk[23]),    
     .fs_fwd_clk_div (fs_fwd_clk_div[23]),

     .i_conf_done(i_conf_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[23]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[23]),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[23]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[23]),
     .ms_tx_transfer_en(ms_tx_transfer_en[23]),
     .ms_rx_transfer_en(ms_rx_transfer_en[23]),
     .sl_tx_transfer_en(sl_tx_transfer_en[23]),
     .sl_rx_transfer_en(sl_rx_transfer_en[23]),
     .m_rx_align_done(m_rx_align_done[23]),


     .sr_ms_tomac(sr_ms_tomac[MS_SSR_LEN*24-1:MS_SSR_LEN*23]),
     .sr_sl_tomac(sr_sl_tomac[SL_SSR_LEN*24-1:SL_SSR_LEN*23]),

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
     .txrx_anaviewout(txrx_anaviewout[4*24-1:4*23]),
     .tx_dll_anaviewout(tx_dll_anaviewout[23]),
     .rx_dll_anaviewout(rx_dll_anaviewout[23]),
     .dcs_anaviewout(dcs_anaviewout[23]),
     .digviewout(digviewout[2*24-1:2*23]),

//JTAG interface
     .jtag_clkdr_in(i_jtag_clkdr),
     .i_jtag_clksel(i_jtag_clksel),
     .scan_out(o_jtag_tdo_ch[23]),
     .jtag_intest(i_jtag_intest),
     .jtag_mode_in(i_jtag_mode),
     .jtag_rstb(i_jtag_rstb),
     .jtag_rstb_en(i_jtag_rstb_en),
     .jtag_weakpdn(i_jtag_weakpdn),
     .jtag_weakpu(i_jtag_weakpu),
     .jtag_tx_scanen_in(i_jtag_tx_scanen),
     .scan_in(o_jtag_tdo_ch[22]),
     .i_scan_clk(i_scan_clk),
     .i_scan_clk_500m(i_scan_clk_500m),
     .i_scan_clk_1000m(i_scan_clk_1000m),
     .i_scan_en(i_scan_en),
     .i_scan_mode(i_scan_mode),
     .i_scan_din(i_scan_din[(SCAN_STR_PER_CH*24)-1:(SCAN_STR_PER_CH*23)]),
     .i_scan_dout(i_scan_dout[(SCAN_STR_PER_CH*24)-1:(SCAN_STR_PER_CH*23)]),

     .i_channel_id(6'd23),
     .i_cfg_avmm_clk(i_cfg_avmm_clk),
     .i_cfg_avmm_rst_n(i_cfg_avmm_rst_n),
     .i_cfg_avmm_addr(i_cfg_avmm_addr),
     .i_cfg_avmm_byte_en(i_cfg_avmm_byte_en),
     .i_cfg_avmm_read(i_cfg_avmm_read),
     .i_cfg_avmm_write(i_cfg_avmm_write),
     .i_cfg_avmm_wdata(i_cfg_avmm_wdata),

     .o_cfg_avmm_rdatavld(o_cfg_avmm_rdatavld_ch[23]),
     .o_cfg_avmm_rdata(o_rdata_ch_23[31:0]),
     .o_cfg_avmm_waitreq(o_cfg_avmm_waitreq_ch[23])
      );

// Auxiliary channel
aibio_auxch_cbb aibio_auxch_cbb
(
//----supply pins----//
.vddc  (vddc2),
.vss   (vss),
//-----input pins-------------//
.dual_mode_sel        (dual_mode_select),
.i_m_power_on_reset   (i_m_power_on_reset),
.m_por_ovrd           (m_por_ovrd),
.m_device_detect_ovrd (m_device_detect_ovrd),
.rxbuf_cfg            (auxch_rxbuf[2:0]),             
.powergood            (vddc2),      
.gen1mode_en          (~m_gen2_mode),
//-----inout pins-----------------//
.xx_power_on_reset    (iopad_power_on_reset),
.xx_device_detect     (iopad_device_detect),
//-------output pins--------------//
.o_m_power_on_reset   (o_m_power_on_reset),
.m_device_detect      (m_device_detect),
//--------spare pins---------------//
.i_aux_spare          (4'h0),                // Spares pins
.o_aux_spare          (o_aux_spare_nc[3:0])  // Spares pins
);
assign adc_anain_0[6:0] = {dcs_anaviewout[0],  rx_dll_anaviewout[0],  tx_dll_anaviewout[0],  txrx_anaviewout[4*1-1:4*0]};
assign adc_anain_1[6:0] = {dcs_anaviewout[5],  rx_dll_anaviewout[5],  tx_dll_anaviewout[5],  txrx_anaviewout[4*6-1:4*5]};
assign adc_anain_2[6:0] = {dcs_anaviewout[11], rx_dll_anaviewout[11], tx_dll_anaviewout[11], txrx_anaviewout[4*12-1:4*11]};
assign adc_anain_3[6:0] = {dcs_anaviewout[17], rx_dll_anaviewout[17], tx_dll_anaviewout[17], txrx_anaviewout[4*18-1:4*17]};
assign adc_anain_4[6:0] = {dcs_anaviewout[23], rx_dll_anaviewout[23], tx_dll_anaviewout[23], txrx_anaviewout[4*24-1:4*23]};
//------------------------------------------------------------------------------
//                          ADC0 for channel 0-3
//------------------------------------------------------------------------------
aibio_adc_cbb i_adc_cbb_0(  
//------Supply pins------//
.vddc(vddc2),  
.vssx(vss), 
//------Input pins------//
.adcclk(i_cfg_avmm_clk), 
.clkdiv(clkdiv_adc0[1:0]),            
.adc_anain({1'b0,adc_anain_0}),//ch0             
.adc_anamux_sel(adc0_muxsel[2:0]),    
.adc_en(adc0_en),            
.reset(i_cfg_avmm_rst_n),             
.adc_start(adc0_start),         
.chopen(adc0_chopen),            
.adc_dfx_en(adc0_dfx_en),        
.adc_anaviewsel(3'b000),    
//------Output pins------//
.adcout(adc0_out[9:0]),  
.adcdone(adc0_done),
.adc_anaviewout(adc0_anaviewout_nc),
//------Spare pins------//
.i_adc_spare(4'b0000),  // Spare pins
.o_adc_spare()   
);

//------------------------------------------------------------------------------
//                          ADC1 for channel 5-7
//------------------------------------------------------------------------------
aibio_adc_cbb i_adc_cbb_1(  
//------Supply pins------//
.vddc(vddc2),  
.vssx(vss), 
//------Input pins------//
.adcclk(i_cfg_avmm_clk), 
.clkdiv(clkdiv_adc1[1:0]),            
.adc_anain({1'b0,adc_anain_1}),//ch5, we should keep LSB as constant value             
.adc_anamux_sel(adc1_muxsel[2:0]),    
.adc_en(adc1_en),            
.reset(i_cfg_avmm_rst_n),             
.adc_start(adc1_start),         
.chopen(adc1_chopen),            
.adc_dfx_en(adc1_dfx_en),        
.adc_anaviewsel(3'b000),    
//------Output pins------//
.adcout(adc1_out[9:0]),  
.adcdone(adc1_done),
.adc_anaviewout(adc1_anaviewout_nc),
//------Spare pins------//
.i_adc_spare(4'b0000),  // Spare pins
.o_adc_spare()   
);

//------------------------------------------------------------------------------
//                          ADC2 for channel 8-11
//------------------------------------------------------------------------------
aibio_adc_cbb i_adc_cbb_2(  
//------Supply pins------//
.vddc(vddc2),  
.vssx(vss), 
//------Input pins------//
.adcclk(i_cfg_avmm_clk), 
.clkdiv(clkdiv_adc2[1:0]),            
.adc_anain({1'b0,adc_anain_2}),//ch11             
.adc_anamux_sel(adc2_muxsel[2:0]),    
.adc_en(adc2_en),            
.reset(i_cfg_avmm_rst_n),             
.adc_start(adc2_start),         
.chopen(adc2_chopen),            
.adc_dfx_en(adc2_dfx_en),        
.adc_anaviewsel(3'b000),    
//------Output pins------//
.adcout(adc2_out[9:0]),  
.adcdone(adc2_done),
.adc_anaviewout(adc2_anaviewout_nc),
//------Spare pins------//
.i_adc_spare(4'b0000),  // Spare pins
.o_adc_spare()   
);

//------------------------------------------------------------------------------
//                          ADC3 for channel 12-15
//------------------------------------------------------------------------------
aibio_adc_cbb i_adc_cbb_3(  
//------Supply pins------//
.vddc(vddc2),  
.vssx(vss), 
//------Input pins------//
.adcclk(i_cfg_avmm_clk), 
.clkdiv(clkdiv_adc3[1:0]),            
.adc_anain({1'b0,adc_anain_3}),//ch17             
.adc_anamux_sel(adc3_muxsel[2:0]),    
.adc_en(adc3_en),            
.reset(i_cfg_avmm_rst_n),             
.adc_start(adc3_start),         
.chopen(adc3_chopen),            
.adc_dfx_en(adc3_dfx_en),        
.adc_anaviewsel(3'b000),    
//------Output pins------//
.adcout(adc3_out[9:0]),  
.adcdone(adc3_done),
.adc_anaviewout(adc3_anaviewout_nc),
//------Spare pins------//
.i_adc_spare(4'b0000),  // Spare pins
.o_adc_spare()   
);
//------------------------------------------------------------------------------
//                          ADC4 for channel 16-19
//------------------------------------------------------------------------------
aibio_adc_cbb i_adc_cbb_4(  
//------Supply pins------//
.vddc(vddc2),  
.vssx(vss), 
//------Input pins------//
.adcclk(i_cfg_avmm_clk), 
.clkdiv(clkdiv_adc4[1:0]),            
.adc_anain({1'b0,adc_anain_4}),//ch23             
.adc_anamux_sel(adc4_muxsel[2:0]),    
.adc_en(adc4_en),            
.reset(i_cfg_avmm_rst_n),             
.adc_start(adc4_start),         
.chopen(adc4_chopen),            
.adc_dfx_en(adc4_dfx_en),        
.adc_anaviewsel(3'b000),    
//------Output pins------//
.adcout(adc4_out[9:0]),  
.adcdone(adc4_done),
.adc_anaviewout(adc4_anaviewout_nc),
//------Spare pins------//
.i_adc_spare(4'b0000),  // Spare pins
.o_adc_spare()   
);    



aib_avmm_top aib_avmm_top_i(
// Inputs
.i_cfg_avmm_clk     (i_cfg_avmm_clk),
.i_cfg_avmm_rst_n   (i_cfg_avmm_rst_n),
.i_cfg_avmm_addr    (i_cfg_avmm_addr[16:0]), 
.i_cfg_avmm_byte_en (i_cfg_avmm_byte_en[3:0]), 
.i_cfg_avmm_read    (i_cfg_avmm_read), 
.i_cfg_avmm_write   (i_cfg_avmm_write), 
.i_cfg_avmm_wdata   (i_cfg_avmm_wdata[31:0]),
// Scan mode input 
.i_scan_mode (i_scan_mode),
// Outputs
// ADC0 signals
.clkdiv_adc0    (clkdiv_adc0[1:0]),
.adc0_muxsel    (adc0_muxsel[2:0]),
.adc0_en        (adc0_en),
.adc0_start     (adc0_start),
.adc0_chopen    (adc0_chopen),
.adc0_dfx_en    (adc0_dfx_en),
.adc0_out       (adc0_out[9:0]),
.adc0_done      (adc0_done),
// ADC1 signals
.clkdiv_adc1    (clkdiv_adc1[1:0]),
.adc1_muxsel    (adc1_muxsel[2:0]),
.adc1_en        (adc1_en),
.adc1_start     (adc1_start),
.adc1_chopen    (adc1_chopen),
.adc1_dfx_en    (adc1_dfx_en),
.adc1_out       (adc1_out[9:0]),
.adc1_done      (adc1_done),
// ADC2 signals
.clkdiv_adc2    (clkdiv_adc2[1:0]),
.adc2_muxsel    (adc2_muxsel[2:0]),
.adc2_en        (adc2_en),
.adc2_start     (adc2_start),
.adc2_chopen    (adc2_chopen),
.adc2_dfx_en    (adc2_dfx_en),
.adc2_out       (adc2_out[9:0]),
.adc2_done      (adc2_done),
// ADC3 signals
.clkdiv_adc3    (clkdiv_adc3[1:0]),
.adc3_muxsel    (adc3_muxsel[2:0]),
.adc3_en        (adc3_en),
.adc3_start     (adc3_start),
.adc3_chopen    (adc3_chopen),
.adc3_dfx_en    (adc3_dfx_en),
.adc3_out       (adc3_out[9:0]),
.adc3_done      (adc3_done),
// ADC4 signals
.clkdiv_adc4    (clkdiv_adc4[1:0]),
.adc4_muxsel    (adc4_muxsel[2:0]),
.adc4_en        (adc4_en),
.adc4_start     (adc4_start),
.adc4_chopen    (adc4_chopen),
.adc4_dfx_en    (adc4_dfx_en),
.adc4_out       (adc4_out[9:0]),
.adc4_done      (adc4_done),
// AIBIO PVTMONA CBB
.pvtmona_en                (pvtmona_en),
.pvtmona_dfx_en            (pvtmona_dfx_en),
.pvtmona_digview_sel       (pvtmona_digview_sel[2:0]),
.pvtmona_ref_clkdiv        (pvtmona_ref_clkdiv[2:0]),
.pvtmona_osc_clkdiv        (pvtmona_osc_clkdiv[2:0]),
.pvtmona_osc_sel           (pvtmona_osc_sel[2:0]),
.pvtmona_count_start       (pvtmona_count_start),
.pvtmona_osc_clk_count     (pvtmona_osc_clk_count[9:0]),
.pvtmona_count_done        (pvtmona_count_done),
// AIBIO PVTMONB CBB
.pvtmonb_en                (pvtmonb_en),
.pvtmonb_dfx_en            (pvtmonb_dfx_en),
.pvtmonb_digview_sel       (pvtmonb_digview_sel[2:0]),
.pvtmonb_ref_clkdiv        (pvtmonb_ref_clkdiv[2:0]),
.pvtmonb_osc_clkdiv        (pvtmonb_osc_clkdiv[2:0]),
.pvtmonb_osc_sel           (pvtmonb_osc_sel[2:0]),
.pvtmonb_count_start       (pvtmonb_count_start),
.pvtmonb_osc_clk_count     (pvtmonb_osc_clk_count[9:0]),
.pvtmonb_count_done        (pvtmonb_count_done),
// AIBIO PVTMONC CBB
.pvtmonc_en                (pvtmonc_en),
.pvtmonc_dfx_en            (pvtmonc_dfx_en),
.pvtmonc_digview_sel       (pvtmonc_digview_sel[2:0]),
.pvtmonc_ref_clkdiv        (pvtmonc_ref_clkdiv[2:0]),
.pvtmonc_osc_clkdiv        (pvtmonc_osc_clkdiv[2:0]),
.pvtmonc_osc_sel           (pvtmonc_osc_sel[2:0]),
.pvtmonc_count_start       (pvtmonc_count_start),
.pvtmonc_osc_clk_count     (pvtmonc_osc_clk_count[9:0]),
.pvtmonc_count_done        (pvtmonc_count_done),
// AIBIO PVTMONB CBB
.pvtmond_en                (pvtmond_en),
.pvtmond_dfx_en            (pvtmond_dfx_en),
.pvtmond_digview_sel       (pvtmond_digview_sel[2:0]),
.pvtmond_ref_clkdiv        (pvtmond_ref_clkdiv[2:0]),
.pvtmond_osc_clkdiv        (pvtmond_osc_clkdiv[2:0]),
.pvtmond_osc_sel           (pvtmond_osc_sel[2:0]),
.pvtmond_count_start       (pvtmond_count_start),
.pvtmond_osc_clk_count     (pvtmond_osc_clk_count[9:0]),
.pvtmond_count_done        (pvtmond_count_done),
// AIBIO PVTMONB CBB
.pvtmone_en                (pvtmone_en),
.pvtmone_dfx_en            (pvtmone_dfx_en),
.pvtmone_digview_sel       (pvtmone_digview_sel[2:0]),
.pvtmone_ref_clkdiv        (pvtmone_ref_clkdiv[2:0]),
.pvtmone_osc_clkdiv        (pvtmone_osc_clkdiv[2:0]),
.pvtmone_osc_sel           (pvtmone_osc_sel[2:0]),
.pvtmone_count_start       (pvtmone_count_start),
.pvtmone_osc_clk_count     (pvtmone_osc_clk_count[9:0]),
.pvtmone_count_done        (pvtmone_count_done),
// Auxiliary channel register output 
.auxch_rxbuf    (auxch_rxbuf[2:0]),
// Avalon outputs
.avmm_rdatavld_top (avmm_rdatavld_top),
.avmm_rdata_top    (avmm_rdata_top[31:0]), 
.avmm_waitreq_top  (avmm_waitreq_top)
);

aibio_pvtmon_cbb i_pvtmon_cbb_0(
.vddc(vddc2),
.vss(vss),
.clk_sys(i_cfg_avmm_clk),
.count_start(pvtmona_count_start),
.en(pvtmona_en),
.osc_sel(pvtmona_osc_sel[2:0]), //3-bits
.oscclkdiv(pvtmona_osc_clkdiv[2:0]), //3-bits
.refclkdiv(pvtmona_ref_clkdiv[2:0]), //3-bits
.pvtmon_dfx_en(pvtmona_dfx_en),
.pvtmon_digview_sel(pvtmona_digview_sel[2:0]), //3-bits
.count_done(pvtmona_count_done),
.codeout(pvtmona_osc_clk_count[9:0]), //10bits
.pvtmon_digviewout(pvtmona_digviewout_nc),
.i_pvtmon_spare(4'b0000), //4-bits
.o_pvtmon_spare(o_pvtmona_spare_nc[3:0]) //4-bits
);

aibio_pvtmon_cbb i_pvtmon_cbb_1(
.vddc(vddc2),
.vss(vss),
.clk_sys(i_cfg_avmm_clk),
.count_start(pvtmonb_count_start),
.en(pvtmonb_en),
.osc_sel(pvtmonb_osc_sel[2:0]), //3-bits
.oscclkdiv(pvtmonb_osc_clkdiv[2:0]), //3-bits
.refclkdiv(pvtmonb_ref_clkdiv[2:0]), //3-bits
.pvtmon_dfx_en(pvtmonb_dfx_en),
.pvtmon_digview_sel(pvtmonb_digview_sel[2:0]), //3-bits
.count_done(pvtmonb_count_done),
.codeout(pvtmonb_osc_clk_count[9:0]), //10bits
.pvtmon_digviewout(pvtmonb_digviewout_nc),
.i_pvtmon_spare(4'b0000), //4-bits
.o_pvtmon_spare(o_pvtmonb_spare_nc[3:0]) //4-bits
);

aibio_pvtmon_cbb i_pvtmon_cbb_2(
.vddc(vddc2),
.vss(vss),
.clk_sys(i_cfg_avmm_clk),
.count_start(pvtmonc_count_start),
.en(pvtmonc_en),
.osc_sel(pvtmonc_osc_sel[2:0]), //3-bits
.oscclkdiv(pvtmonc_osc_clkdiv[2:0]), //3-bits
.refclkdiv(pvtmonc_ref_clkdiv[2:0]), //3-bits
.pvtmon_dfx_en(pvtmonc_dfx_en),
.pvtmon_digview_sel(pvtmonc_digview_sel[2:0]), //3-bits
.count_done(pvtmonc_count_done),
.codeout(pvtmonc_osc_clk_count[9:0]), //10bits
.pvtmon_digviewout(pvtmonc_digviewout_nc),
.i_pvtmon_spare(4'b0000), //4-bits should be grounded
.o_pvtmon_spare(o_pvtmonc_spare_nc[3:0]) //4-bits
);

aibio_pvtmon_cbb i_pvtmon_cbb_3(
.vddc(vddc2),
.vss(vss),
.clk_sys(i_cfg_avmm_clk),
.count_start(pvtmond_count_start),
.en(pvtmond_en),
.osc_sel(pvtmond_osc_sel[2:0]), //3-bits
.oscclkdiv(pvtmond_osc_clkdiv[2:0]), //3-bits
.refclkdiv(pvtmond_ref_clkdiv[2:0]), //3-bits
.pvtmon_dfx_en(pvtmond_dfx_en),
.pvtmon_digview_sel(pvtmond_digview_sel[2:0]), //3-bits
.count_done(pvtmond_count_done),
.codeout(pvtmond_osc_clk_count[9:0]), //10bits
.pvtmon_digviewout(pvtmond_digviewout_nc),
.i_pvtmon_spare(4'b0000), //4-bits
.o_pvtmon_spare(o_pvtmond_spare_nc[3:0]) //4-bits
);

aibio_pvtmon_cbb i_pvtmon_cbb_4(
.vddc(vddc2),
.vss(vss),
.clk_sys(i_cfg_avmm_clk),
.count_start(pvtmone_count_start),
.en(pvtmone_en),
.osc_sel(pvtmone_osc_sel[2:0]), //3-bits
.oscclkdiv(pvtmone_osc_clkdiv[2:0]), //3-bits
.refclkdiv(pvtmone_ref_clkdiv[2:0]), //3-bits
.pvtmon_dfx_en(pvtmone_dfx_en),
.pvtmon_digview_sel(pvtmone_digview_sel[2:0]), //3-bits
.count_done(pvtmone_count_done),
.codeout(pvtmone_osc_clk_count[9:0]), //10bits
.pvtmon_digviewout(pvtmone_digviewout_nc),
.i_pvtmon_spare(4'b0000), //4-bits
.o_pvtmon_spare(o_pvtmone_spare_nc[3:0]) //4-bits
);


endmodule // aib_phy_top
