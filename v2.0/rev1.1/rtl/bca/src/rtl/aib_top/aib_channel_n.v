// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_channel_n 
 #(
    parameter SCAN_STR_PER_CH = 10, // Scan data input and data output size
    parameter NBR_LANES = 40,       // Number  of lanes
    parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
    )
 ( 
// Power supply pins
inout vddc2,
inout vddc1,
inout vddtx,
inout vss,

inout  [101:0]           iopad_aib,  // IO pads to PHY
input  [NBR_LANES*8-1:0] data_in_f,  // FIFO data input
output [NBR_LANES*8-1:0] data_out_f, // FIFO data output

input  [NBR_LANES*2-1:0] data_in,  // REG mode data input
output [NBR_LANES*2-1:0] data_out, // REG mode data output

input          m_ns_fwd_clk, // Near side forwarded clock
input          m_ns_rcv_clk, // Near side receive clock
output         m_fs_rcv_clk, // Far side receive clock
output         m_fs_fwd_clk, // Far side forwarded clock
input          m_wr_clk,     // Write domain clock
input          m_rd_clk,     // Read domain clock
output         ns_fwd_clk,   // Near side  forward clock/Tx PHY clock output
output         ns_fwd_clk_div, // Tx Clock PHY divided for FIFO mode
output         fs_fwd_clk,   // Rx PHY clock output
output         fs_fwd_clk_div, // Rx Clock PHY divided for FIFO mode

input  ns_adapter_rstn,  // Resets the AIB Adapter
input  ns_mac_rdy,  // Indicates that the near side is ready or calibration and
                    // data transfer 
output fs_mac_rdy,  // Indicates that the far-side MAC isready to transmit data


input i_conf_done,            // Single control to reset all AIB hannels in the
                              // interface. LO=reset, HI=out of reset.
input ms_rx_dcc_dll_lock_req, // Initiates calibration of receive path for a
                              // leader interface
input ms_tx_dcc_dll_lock_req, // Initiates calibration of transmit path for a
                              // leader interface
input sl_tx_dcc_dll_lock_req, // Initiates calibration of receive path for a
                              // follower interface
input sl_rx_dcc_dll_lock_req, // Initiates calibration of transmit path for a
                              // follower interface

output         ms_tx_transfer_en, // Indicates that leader has completed
                                  // its TX path calibration and is
                                  // ready to receive data.
output         ms_rx_transfer_en, // Indicates that leader has completed
                                  // its RX path calibration and is
                                  // ready to receive data.
output         sl_tx_transfer_en, // Indicates that follower has
                                  // completed its TX path calibration
                                  // and is ready to receive data
output         sl_rx_transfer_en, // Indicates that follower has
                                  // completed its RX path calibration
                                  // and is ready to receive data
output         m_rx_align_done,   // Indicates that the receiving AIB
                                  // Adapter is aligned to incoming word
                                  // marked data
output [80:0]  sr_ms_tomac,       // Leader  sideband data
output [72:0]  sr_sl_tomac,       // Follower  sideband data

//Sideband user input
input [26:0]  sl_external_cntl_26_0,  // user defined bits 26:0 for slave shift
                                      // register
input [2:0]   sl_external_cntl_30_28, // user defined bits 30:28 for slave shift
                                      // register
input [25:0]  sl_external_cntl_57_32, // user defined bits 57:32 for slave shift
                                      // register
input [4:0]   ms_external_cntl_4_0,   // user defined bits 4:0 for master shift
                                      // register
input [57:0]  ms_external_cntl_65_8,  // user defined bits 65:8 for master shift
                                      // register


input          dual_mode_select, //Mater or Slave
input          m_gen2_mode,      //If 1, it is aib2.0

//Interface with aux channel
input          por,       //from aux channel
input          i_osc_clk, //from aux channel

//JTAG interface
output scan_out,          // last boundary scan chain output, TDO
input  jtag_clkdr_in,     // Test clock
input  i_jtag_clksel,     // JTAG clock selection
input  jtag_intest,       // Enable testing of data path
input  jtag_mode_in,      // Teste mode select
input  jtag_rstb,         // JTAG reset
input  jtag_rstb_en,      // JTAG reset enable
input  jtag_weakpdn,      // Enable weak pull-down on IO block
input  jtag_weakpu,       // Enable weak pull-up on IO block
input  jtag_tx_scanen_in, // JTAG shift DR, active high
input  scan_in,           // Test data input

//Scan IO ports
input          i_scan_clk,                // Scan clock
input          i_scan_clk_500m,           // Scan clock 500m
input          i_scan_clk_1000m,          // Scan clock 1000m
input          i_scan_en,                 // Scan enable
input          i_scan_mode,               // Scan mode
input  [SCAN_STR_PER_CH-1:0] i_scan_din,  // Scan data input
output [SCAN_STR_PER_CH-1:0] i_scan_dout, // Scan data output

// Avalon ports
input [5:0]  i_channel_id,       // channel ID to program
input        i_cfg_avmm_clk,     // Avalon interface clock
input        i_cfg_avmm_rst_n,   // Avalon interface reset
input [16:0] i_cfg_avmm_addr,    // address to be programmed
input [3:0]  i_cfg_avmm_byte_en, // byte enable
input        i_cfg_avmm_read,    // Asserted to indicate the Cfg read access
input        i_cfg_avmm_write,   // Asserted to indicate the Cfg write access
input [31:0] i_cfg_avmm_wdata,   // data to be programmed

output         o_cfg_avmm_rdatavld, // Assert to indicate data available for Cfg
                                    // read access
output [31:0]  o_cfg_avmm_rdata,    // data returned for Cfg read access
output         o_cfg_avmm_waitreq,   // asserted to indicate not ready for Cfg
                                    // access
//anaviewout signals                                    
output wire [3:0] txrx_anaviewout,
output wire       tx_dll_anaviewout,
output wire       rx_dll_anaviewout,
output wire       dcs_anaviewout,
output wire [1:0] digviewout
 );

// Far side loop back configuration
localparam FARSIDE_LPBK   =  2'b01;
localparam NEARSIDE_LPBK  =  2'b10;

integer i;
integer j;
integer m;
integer n;

wire        iopad_rstb;              // POwer-on reset or COnfiguration phase 

wire        adapt_std_out;
wire        adapt_stl_out;
wire        adapt_sr_clk_out;

wire        adapt_rstn;
wire        csr_async_rstn;
wire        csr_sync_rstn;
wire        tx_fifo_transfer_en;
wire        rx_fifo_transfer_en;

wire        rwrp_fs_adapter_rstn;
wire [31:0] rx_adapt_0;
wire [31:0] rx_adapt_1;
wire [31:0] tx_adapt_0;
wire [31:0] tx_adapt_1;
wire [31:0] redund_0; 
wire [31:0] redund_1; 
wire [31:0] redund_2; 
wire [31:0] redund_3;
reg  [79:0] aibio_din;
wire [79:0] aibio_dout;
wire        tclk_div_rstn;
wire        rclk_div_rstn;
wire        sys_div_rstn;
wire	    ck_sys;
wire        rcomp_cal_en_g1;
wire        rcomp_cal_en_g2;
wire        rcomp_out_g1;
wire        rcomp_out_g2;
wire [6:0]  rcomp_cal_code_g1;
wire [6:0]  rcomp_cal_code_g2;
wire        rcomp_cal_done_g1;
wire        rcomp_cal_done_g2;
wire        rcomp_cal_done;

//CSR for Adapter
wire [1:0] csr_rx_fifo_mode; // Rx Operation mode
wire [1:0] csr_tx_fifo_mode; // Tx Operation mode
wire       csr_rx_wa_en;     // RX word alignment detection enable
wire       csr_tx_wm_en;     // TX word marker insertion enable
wire [4:0] rx_align_threshold; // RX FIFO WAM threshold

wire [3:0] csr_tx_phcomp_rd_delay; // TX phase compensation FIFO read enable
                                   // delay
wire [3:0] csr_rx_phcomp_rd_delay; //RX phase compensation FIFO read enable
                                   // delay

wire       csr_tx_dbi_en;  //TX DBI enable
wire       csr_rx_dbi_en;  //RX DBI enable
wire [1:0] csr_lpbk_mode;  // Loopback mode.
wire       csr_rxswap_en;  // Switch Upper/Lower 39 bit in FIFO2x mode in
                           // Gen1 mode
wire       csr_txswap_en;  // Switch Upper/Lower 39 bit in FIFO2x mode in
                           // Gen1 mode
wire [4:0] csr_rx_mkbit;   // Marker bit position of 79:76
wire [4:0] csr_tx_mkbit;   // Marker bit position of 79:76
wire       csr_rx_wa_mode; // Rx word alignment mode sticky bit
wire       n_lpbk;         // DLL Near side loopback mode
wire       csr_sdr_mode;   // Single data rate mode
wire       tx_lpbk_mode;
wire       rx_lpbk_mode;
wire       csr_paden;
wire       csr_fwd_clk_test;
wire       fwd_clk_test_sync;
wire       f_lpbk;
wire       flpb_txpll_mux_sel;
wire       tclk_dll;


wire tx_fifo_rstn;    // TX FIFO reset
wire rx_fifo_rstn;    // RX FIFO reset
wire osc_fsm_rstn;    // Oscillator FSM reset 
wire osc_fsm_ms_rstn; // Oscillator FSM reset in SR master domain
wire osc_fsm_sl_rstn; // Oscillator FSM reset in SR slave domain
wire cal_fsm_ms_rstn; // Calibration  FSM reset for master
wire cal_fsm_sl_rstn; // Calibration  FSM reset for slave

reg [39:0] tx_data_in_even;
reg [39:0] tx_data_in_odd;
wire [39:0] rwrp_rx_data_even;
wire [39:0] rwrp_rx_data_odd;

wire tx_clk_div_ld;
wire tx_clk_div_1;
wire tx_clk_div_2;
wire tx_clk_div_4;
wire tx_clk_div_ld_ack;

wire rx_clk_div_ld;
wire rx_clk_div_1;
wire rx_clk_div_2;
wire rx_clk_div_4;
wire rx_clk_div_ld_ack;

// AIBIO common registers
wire [ 2:0] iocmn_pll_freq;        
wire        iocmn_tx_lpbk_en;      
wire        iocmn_rx_lpbk_en;      
wire        iocmn_en_digmon;       
wire [15:0] iocmn_digmon_sel_code; 
wire        iocmn_en_anamon;       
wire [ 2:0] iocmn_anamon_sel_code; 
wire [ 1:0] dll_sel_avg_ff;

// AIBIO TX/RX registers
wire [7:0] iotxrx_tx_drvnpd_code;
wire [7:0] iotxrx_tx_drvnpu_code;
wire [7:0] iotxrx_tx_drvppu_code;
wire       io_ctrl1_tx_wkpu_ff;
wire       io_ctrl1_tx_wkpd_ff;
wire       io_ctrl1_rx_wkpu_ff;
wire       io_ctrl1_rx_wkpd_ff;
wire [3:0] iotxrx_tx_deskew_ff;
wire [3:0] iotxrx_rx_deskew_ff;
wire       iotxrx_tx_deskew_en_ff;
wire       iotxrx_tx_deskew_step_ff;
wire       iotxrx_tx_deskew_ovrd_ff;
wire       iotxrx_rx_deskew_en_ff;
wire       iotxrx_rx_deskew_step_ff;
wire       iotxrx_rx_deskew_ovrd_ff;

// AIBIO VREF registers
wire [6:0] vref_p_code_gen1;
wire [6:0] vref_n_code_gen1;
wire [6:0] vref_p_code_gen2;
wire [6:0] vref_n_code_gen2;
wire [4:0] vref_calvref_code;
wire       vref_calcode_ovrd_ff;
wire       vref_caldone_ovrd_ff;
wire [4:0] vref_calvref_code_sync;
wire       vref_calcode_ovrd_sync;
wire       vref_caldone_ovrd_sync;
wire       vref_cal_done;
wire       vref_cal_done_sync;

// AIBIO RX DLL
wire [1:0] rdll_dll_inclk_sel;         
wire [3:0] rdll_dll_lockthresh_code;
wire [1:0] rdll_dll_lockctrl_code;
wire [2:0] rdll_cdrctrl_code;
wire       rdll_ovrd_pi_adpclk_code;
wire       rddl_adp_lock_ovrd_ff;
wire       rddl_soc_lock_ovrd_ff;
wire [3:0] rdll_pi_adpclk_code;
wire       rdll_ovrd_pi_socclk_code; 
wire [3:0] rdll_pi_socclk_code;
wire [4:0] rdll_digview_sel;           
wire       cdr_picode_update;
wire [6:0] cdr_picode_even_ff;
wire [6:0] cdr_picode_odd_ff;
wire       cdr_ovrd_sel_ff;
wire       cdr_lock_ovrd_ff;
wire [1:0] cdr_clk_sel_ff;
wire       rx_adp_clk_lock;
wire       rx_soc_clk_lock;
wire       [3:0] rx_adp_clkph_code;
wire       [3:0] rx_soc_clkph_code;
//Trim bits to select the cap and current code values
wire [2:0] tx_dll_trim_bits;
wire [2:0] rx_dll_trim_bits;
wire [3:0] tx_dll_biasctrl;
wire [3:0] rx_dll_biasctrl;
wire [2:0] pi_trim_bits;

// AIBIO CDR
wire       aibio_cdr_lock;

// AIBIO TXDLL
wire [1:0] tdll_dll_inclk_sel;      
wire [3:0] tdll_dll_lockthresh_code;
wire [1:0] tdll_dll_lockctrl_code;
wire       tdll_ovrd_pi_adpclk_code;
wire [3:0] tdll_pi_adpclk_code;
wire       tddl_adp_lock_ovrd_ff;
wire       tddl_soc_lock_ovrd_ff;
wire       tdll_ovrd_pi_socclk_code;  
wire [3:0] tdll_pi_socclk_code;       
wire [4:0] tdll_digview_sel;         
wire       tx_adp_clk_lock;
wire       tx_soc_clk_lock;
wire       [3:0] tx_adp_clkph_code;
wire       [3:0] tx_soc_clkph_code;

// AIBIO RXCLK CBB
wire [2:0]  iorclk_dcc_bias_code;
wire [2:0]  iorclk_ibias_ctrl_nored;
wire [2:0]  iorclk_ibias_ctrl_red;
wire        rx_dcc_lock;

// AIBIO DCS CBB
wire [1:0] dcs1_clkdiv_sel;
wire       dcs1_sel_clkp;
wire       dcs1_sel_clkn;
wire       dcs1_en_single_ended;
wire       dcs1_sel_ovrd_ff;
wire       dcs1_lock_ovrd_ff;
wire       dcs1_chopen_ovrd_ff;
wire [4:0] dcs2_npusel_code_ff;
wire [4:0] dcs2_npdsel_code_ff;
wire [4:0] dcs2_ppusel_code_ff;
wire [4:0] dcs2_ppdsel_code_ff;
wire       dcs1_sel_ovrd_sync;
wire       dcs1_lock_ovrd_sync;
wire       dcs1_chopen_ovrd_sync;
wire [4:0] dcs2_npusel_code_sync;
wire [4:0] dcs2_npdsel_code_sync;
wire [4:0] dcs2_ppusel_code_sync;
wire [4:0] dcs2_ppdsel_code_sync;
wire       dcs1_lock;


// AIBIO RCOMP1 register
wire       rcomp_calsel_g2_ovrd_ff;
wire       rcomp_calcode_g2_ovrd_ff;
wire [6:0] rcomp_calcode_g2_ff;
wire       rcomp_calsel_g1_ovrd_ff;
wire       rcomp_calcode_g1_ovrd_ff;
wire [6:0] rcomp_calcode_g1_ff;
wire       rcomp_cal_done_g2_sync;
wire       rcomp_cal_done_g1_sync;
wire       rcomp_calsel_g2_ovrd_sync;
wire       rcomp_caldone_g2_ovrd_sync;
wire [6:0] rcomp_calcode_g2_ff_sync;
wire       rcomp_calsel_g1_ovrd_sync;
wire       rcomp_caldone_g1_ovrd_sync;
wire [6:0] rcomp_calcode_g1_ff_sync;

// AIBIO RCOMP2 register
wire [6:0] rcomp_calcode_g2;
wire [6:0] rcomp_calcode_g1;

// AIBIO NTL register
wire [15:0] ntl2_count_ff;
wire        ntl1_done_ovrd_ff;
wire        ntl1_tx_dodd_ovrd_ff;
wire        ntl1_tx_deven_ovrd_ff;
wire        ntl1_rxen_ovrd_ff;
wire        ntl1_txen_ovrd_ff;
wire        ntl1_txen_async_ovrd_ff;
wire        ntl1_rxen_async_ovrd_ff;
wire        ntl1_en_ovrd_ff;
wire        ntl1_en_ff;
wire [ 6:0] ntl1_pad_num_ff;
wire        ntl1_done_sync;
wire [15:0] ntl2_count_sync;
wire        ntl1_done_ovrd_sync;
wire        ntl1_tx_dodd_ovrd_sync;
wire        ntl1_tx_deven_ovrd_sync;
wire        ntl1_rxen_ovrd_sync;
wire        ntl1_txen_ovrd_sync;
wire        ntl1_txen_async_ovrd_sync;
wire        ntl1_rxen_async_ovrd_sync;
wire        ntl1_en_ovrd_sync;
wire        ntl1_en_sync;
wire [ 6:0] ntl1_pad_num_sync;
wire [15:0] ntl2_cnt_val_sync;


wire [101:0] redund_sft_en; // Redundancy bits to shift IO data
wire [101:0] ana_async_data_out; // Async Analog top
wire [101:0] ana_rx_even_out;
wire [101:0] ana_rx_odd_out;
wire [1:0]   shift_en_clkbuf;

wire [101:0] rwrp_async_data_to_pad;
wire [101:0] rwrp_even_data_to_pad;
wire [101:0] rwrp_odd_data_to_pad;
wire         rwrp_fs_sr_clk;
wire         rwrp_fs_sr_data;
wire         rwrp_fs_sr_load;
wire [101:0] even_data_frm_red;
wire [101:0] odd_data_frm_red;

wire       tx_clk_adapter;
wire       tx_clk_adapter_buf;
wire       tx_clk_adapter_rtl;
wire       tx_dll_lock;
wire       phdet_cdr_out;
wire       rx_dll_lock;
wire       dc_gt_50;
wire [101:0] tx_bypass_serialiser;
wire [101:0] rx_en_to_pad;
wire [101:0] tx_en_to_pad;
wire [101:0] tx_async_en_to_pad;
wire [101:0] rx_async_en_to_pad;
wire [101:0] sdr_mode_en_to_pad;
wire [101:0] wkpu_en_out;
wire [101:0] wkpd_en_out;
wire [101:0] fault_stdby;
wire [101:0] wkpu_en;
wire [101:0] wkpd_en;
wire         rclk_adapt;
wire         rclk_adapt_buf;
wire         rclk_adapt_rtl;
wire         sr_clk_in_int;
wire         piclk_soc;
wire         piclk_soc_buf;
wire         piclk_soc_rtl;

wire         tx_clk_even;
wire         tx_clk_even_buf;
wire         piclk_odd;
wire         piclk_odd_buf;
wire         tx_adapt_phase_locked;
wire         tx_ana_phase_locked;
wire         rx_adapt_phase_locked;
wire         rx_ana_phase_locked;
wire [3:0]   dll_ckadapt_phase_sel_code;
wire [3:0]   dll_cksoc_phase_sel_code;
wire [3:0]   dll_piadapt_phase_sel_code;
wire [3:0]   dll_pisoc_phase_sel_code;
wire [6:0]   picode_even;
wire [6:0]   picode_odd;
wire         tx_start_phase;
wire         rx_start_phase;
wire         tx_soc_start_phase;
wire         rx_adapter_start_phase;
wire         cdr_start;
wire         cdr_phase_detect;
wire         cdr_lock;
wire         picode_update;
wire [101:0] rx_en_frm_red;
wire [101:0] tx_en_frm_red;
wire [101:0] rx_async_en_frm_red;
wire [101:0] tx_async_en_frm_red;
wire [15:0]  ntl_count_value;
wire         ntl1_done;
wire [89:0][4:0] offs_cal_code;
reg  [43:0][4:0] offs_cal_code_even;
reg  [43:0][4:0] offs_cal_code_odd;
wire             rx_offset_cal_run;
wire [43:0]  ana_rxdata_even;
wire [43:0]  ana_rxdata_odd;
reg  [87:0]  ana_rxdata;
wire [101:0][4:0]rx_ofscal_even; 
wire [101:0][4:0]rx_ofscal_odd;
wire [4:0] dcc_p_pdsel;
wire [4:0] dcc_p_pusel;
wire [4:0] dcc_n_pdsel;
wire [4:0] dcc_n_pusel;
wire 	   chopen;
wire 	   dcs_lock;
wire [3:0] dll_oddph1_sel; 
wire [3:0] dll_evenph1_sel;
wire [3:0] dll_oddph2_sel;
wire       co1_nc;
wire       co2_nc;
wire       co3_nc;
wire [4:0] rx_ofscal_g1;
wire [4:0] rx_ofscal_g2;

// BERT access interface
wire [ 5:0] bert_acc_addr;    // BERT access address            
wire        bert_acc_req;     // BERT access request            
wire        bert_acc_rdwr;    // BERT access read/write control         
wire [31:0] bert_wdata_ff;    // BERT data to be written        
wire [31:0] rx_bert_rdata_ff; // Read data from RX BERT interface
wire [31:0] tx_bert_rdata_ff; // Read data from TX BERT interface
wire        bert_acc_rq_pend; // BERT configuration load is pending

// TX BERT control interface
wire [3:0] tx_bert_start; // Starts transmitting TX BERT bit sequence
wire [3:0] tx_bert_rst;   // Resets TX BERT registers

// TX BERT status interface
wire       bert_seed_good; // Indicates all BPRS seeds are not zero.
wire [3:0] txbert_run_ff;     // Indicates  TX BERT is running

//  RX BERT control interface
wire [3:0] rxbert_start;   // Starts checking input of RX BERT bit sequence
wire [3:0] rxbert_rst;     // Resets RX BERT registers
wire [3:0] rxbert_seed_in; // Enables the self-seeding in RX BERT

// RX BERT status interface
wire [ 3:0] rxbert_run_ff;    // Indicates RX BERT is running
wire [ 3:0] rxbert_biterr_ff; // Error detected in RX BERT checker

wire tx_bert_en; // TX BERT enable

// Analog Interface Clock dividers control signals
wire rxoff_cal_div_ld_ff;  // Loads RXOFF Cal divider selection
wire rxoff_cal_div_1_ff;   // RXOFF Cal clock divided by 1
wire rxoff_cal_div_2_ff;   // RXOFF Cal clock divided by 2
wire rxoff_cal_div_4_ff;   // RXOFF Cal clock divided by 4
wire rxoff_cal_div_8_ff;   // RXOFF Cal clock divided by 8
wire rxoff_cal_div_16_ff;  // RXOFF Cal clock divided by 16
wire rxoff_cal_div_32_ff;  // RXOFF Cal clock divided by 32
wire rxoff_cal_div_64_ff;  // RXOFF Cal clock divided by 64
wire sysclk_div_ld_ff;     // SYS clock divider selection
wire sysclk_div_1_ff;      // SYS clock divided by 1
wire sysclk_div_2_ff;      // SYS clock divided by 2
wire sysclk_div_4_ff;      // SYS clock divided by 4
wire sysclk_div_8_ff;      // SYS clock divided by 8
wire sysclk_div_16_ff;     // SYS clock divided by 16
wire gen1rcomp_div_ld_ff;  // GEN1 RCOMP divider selection
wire gen1rcomp_div_1_ff;   // GEN1 RCOMP clock divided by 1
wire gen1rcomp_div_2_ff;   // GEN1 RCOMP clock divided by 2
wire gen1rcomp_div_4_ff;   // GEN1 RCOMP clock divided by 4
wire gen1rcomp_div_8_ff;   // GEN1 RCOMP clock divided by 8
wire gen1rcomp_div_16_ff;  // GEN1 RCOMP clock divided by 16
wire gen1rcomp_div_32_ff;  // GEN1 RCOMP clock divided by 32
wire gen2rcomp_div_ld_ff;  // GEN2 RCOMP divider selection
wire gen2rcomp_div_1_ff;   // GEN2 RCOMP clock divided by 1
wire gen2rcomp_div_2_ff;   // GEN2 RCOMP clock divided by 2
wire gen2rcomp_div_4_ff;   // GEN2 RCOMP clock divided by 4
wire gen2rcomp_div_8_ff;   // GEN2 RCOMP clock divided by 8
wire gen2rcomp_div_16_ff;  // GEN2 RCOMP clock divided by 16
wire gen2rcomp_div_32_ff;  // GEN2 RCOMP clock divided by 32
wire dcs_div_ld_ff;        // DCS divider selection
wire dcs_div_1_ff;         // DCS clock divided by 1
wire dcs_div_2_ff;         // DCS clock divided by 2
wire dcs_div_4_ff;         // DCS clock divided by 4
wire dcs_div_8_ff;         // DCS clock divided by 8
wire dcs_div_16_ff;        // DCS clock divided by 16
wire dcs_div_32_ff;        // DCS clock divided by 32
wire dcs_div_64_ff;        // DCS clock divided by 32
wire dcs_div_128_ff;       // DCS clock divided by 32
wire dcs_div_256_ff;       // DCS clock divided by 32
wire rxoff_cal_div_ld_ack; // RXOFF Cal divider load ack
wire sysclk_div_ld_ack;    // SYS clock divider load ack
wire gen1rcomp_div_ld_ack; // GEN1 RCOMP clock divider load ack
wire gen2rcomp_div_ld_ack; // GEN2 RCOMP clock divider load ack
wire dcs_div_ld_ack;       // DCS clock divider load ack

wire [  1:0] txdll_inclk_sel;
wire [  1:0] rxdll_inclk_sel;
wire         test_clk;
wire [103:0] txrx_dfx_en;
wire         tx_dll_dfx_en;
wire         rx_dll_dfx_en;
wire         dcs_dfx_en;
wire [  4:0] txrx_digviewsel;
//wire [  1:0] digviewout; //Should bring to phy_top and make it note, we have digviewout signal to monitor digital signals
wire [  2:0] txrx_anaviewsel;
wire [  4:0] onehot_anaviewsel;

// Wires for aib_bus_sync block
wire [36:0] bus_src_sync_data;
wire [36:0] bus_dest_sync_data;

aib_bus_sync #(.DWIDTH(37)) signal_sync (
.src_clk (ck_sys),
.dest_clk (i_cfg_avmm_clk),
.src_rst_n (sys_div_rstn),
.dest_rst_n (csr_sync_rstn),
.src_data (bus_src_sync_data[36:0]),
.dest_data_ff (bus_dest_sync_data[36:0])
);

aib_avalon avmm_config (
.cfg_avmm_addr_id(i_channel_id),
.cfg_avmm_clk(i_cfg_avmm_clk),
.cfg_avmm_rst_n(csr_sync_rstn),
.cfg_avmm_write(i_cfg_avmm_write),
.cfg_avmm_read(i_cfg_avmm_read),
.cfg_avmm_addr(i_cfg_avmm_addr),
.cfg_avmm_wdata(i_cfg_avmm_wdata),
.cfg_avmm_byte_en(i_cfg_avmm_byte_en),
.cfg_avmm_rdata(o_cfg_avmm_rdata),
.cfg_avmm_rdatavld(o_cfg_avmm_rdatavld),
.cfg_avmm_waitreq(o_cfg_avmm_waitreq),
//Adapt control CSR
.rx_adapt_0(rx_adapt_0),
.rx_adapt_1(rx_adapt_1),
.tx_adapt_0(tx_adapt_0),
.tx_adapt_1(tx_adapt_1),
.redund_0(redund_0),
.redund_1(redund_1),
.redund_2(redund_2),
.redund_3(redund_3),
//----------------------------------
//  BERT access interface
//----------------------------------
.bert_acc_addr    (bert_acc_addr[5:0]),   // BERT access address
.bert_acc_req     (bert_acc_req),         // BERT access request
.bert_acc_rdwr    (bert_acc_rdwr),        // BERT access read/write control
.bert_wdata_ff    (bert_wdata_ff[31:0]),  // BERT data to be written
.rx_bert_rdata_ff (rx_bert_rdata_ff[31:0]), // Read data from RX BERT interface
.tx_bert_rdata_ff (tx_bert_rdata_ff[31:0]), // Read data from TX BERT interface
.bert_acc_rq_pend (bert_acc_rq_pend),     // BERT configuration load is pending
//-----------------------------------
//  TX BERT control interface
//-----------------------------------
.tx_bert_start (tx_bert_start[3:0]), // Starts transmitting TX BERT bit sequence
.tx_bert_rst   (tx_bert_rst[3:0]),   // Resets TX BERT registers
//-----------------------------------
//  TX BERT status interface
//-----------------------------------
.bert_seed_good (bert_seed_good),  // Indicates no zero BPRS seeds.
.txbert_run_ff  (txbert_run_ff[3:0]), // Indicates  TX BERT is running
//------------------------------------
//  RX BERT control interface
//------------------------------------
.rxbert_start   (rxbert_start[3:0]),   // Starts checking RX BERT bit sequence
.rxbert_rst     (rxbert_rst[3:0]),     // Resets RX BERT registers
.rxbert_seed_in (rxbert_seed_in[3:0]), // Enables the self-seeding in RX BERT
//------------------------------------
//  RX BERT status interface
//------------------------------------
.rxbert_run_ff    (rxbert_run_ff[3:0]),     // Indicates RX BERT is running
.rxbert_biterr_ff (rxbert_biterr_ff[3:0]),  // Error detected in RX BERT check.

.tx_bert_en (tx_bert_en), // TX BERT enable

//--------------------------------------
// AIBIO common registers
//Outputs
.iocmn_pll_freq        (iocmn_pll_freq[2:0]),
.iocmn_tx_lpbk_en      (iocmn_tx_lpbk_en),
.iocmn_rx_lpbk_en      (iocmn_rx_lpbk_en),
.iocmn_en_digmon       (iocmn_en_digmon),
.iocmn_digmon_sel_code (iocmn_digmon_sel_code[15:0]),
.iocmn_en_anamon       (iocmn_en_anamon),
.iocmn_anamon_sel_code (iocmn_anamon_sel_code[2:0]),
.dll_sel_avg_ff        (dll_sel_avg_ff[1:0]),
// AIBIO TX/RX registers
//Outputs
.iotxrx_tx_drvnpd_code      (iotxrx_tx_drvnpd_code[7:0]),
.iotxrx_tx_drvnpu_code      (iotxrx_tx_drvnpu_code[7:0]),
.iotxrx_tx_drvppu_code      (iotxrx_tx_drvppu_code[7:0]),
.io_ctrl1_tx_wkpu_ff        (io_ctrl1_tx_wkpu_ff),
.io_ctrl1_tx_wkpd_ff        (io_ctrl1_tx_wkpd_ff),
.io_ctrl1_rx_wkpu_ff        (io_ctrl1_rx_wkpu_ff),
.io_ctrl1_rx_wkpd_ff        (io_ctrl1_rx_wkpd_ff),
.iotxrx_tx_deskew_ff        (iotxrx_tx_deskew_ff[3:0]),
.iotxrx_rx_deskew_ff        (iotxrx_rx_deskew_ff[3:0]),
.iotxrx_tx_deskew_en_ff     (iotxrx_tx_deskew_en_ff),
.iotxrx_tx_deskew_step_ff   (iotxrx_tx_deskew_step_ff),
.iotxrx_tx_deskew_ovrd_ff   (iotxrx_tx_deskew_ovrd_ff),
.iotxrx_rx_deskew_en_ff     (iotxrx_rx_deskew_en_ff),
.iotxrx_rx_deskew_step_ff   (iotxrx_rx_deskew_step_ff),
.iotxrx_rx_deskew_ovrd_ff   (iotxrx_rx_deskew_ovrd_ff),
// AIBIO VREF registers
//Outputs
.vref_p_code_gen1  (vref_p_code_gen1[6:0]),
.vref_n_code_gen1  (vref_n_code_gen1[6:0]),
.vref_p_code_gen2  (vref_p_code_gen2[6:0]),
.vref_n_code_gen2  (vref_n_code_gen2[6:0]),
.vref_calvref_code (vref_calvref_code[4:0]),
.vref_calcode_ovrd_ff (vref_calcode_ovrd_ff),
.vref_caldone_ovrd_ff (vref_caldone_ovrd_ff),
// Input
.vref_cal_done_sync (vref_cal_done_sync),
// AIBIO RX DLL
//Outputs
.rdll_dll_inclk_sel       (rdll_dll_inclk_sel[1:0]),
.rdll_dll_lockthresh_code (rdll_dll_lockthresh_code[3:0]),
.rdll_dll_lockctrl_code   (rdll_dll_lockctrl_code[1:0]),
.rdll_cdrctrl_code        (rdll_cdrctrl_code[2:0]),
.rdll_ovrd_pi_adpclk_code (rdll_ovrd_pi_adpclk_code),
.rddl_adp_lock_ovrd_ff    (rddl_adp_lock_ovrd_ff),
.rddl_soc_lock_ovrd_ff    (rddl_soc_lock_ovrd_ff),
.rdll_pi_adpclk_code      (rdll_pi_adpclk_code[3:0]),
.rdll_ovrd_pi_socclk_code (rdll_ovrd_pi_socclk_code),
.rdll_pi_socclk_code      (rdll_pi_socclk_code[3:0]),
.rdll_digview_sel         (rdll_digview_sel[4:0]),
.cdr_picode_update        (cdr_picode_update),
.cdr_picode_even_ff       (cdr_picode_even_ff[6:0]),
.cdr_picode_odd_ff        (cdr_picode_odd_ff[6:0]),
.cdr_ovrd_sel_ff          (cdr_ovrd_sel_ff),
.cdr_lock_ovrd_ff         (cdr_lock_ovrd_ff),
.cdr_clk_sel_ff           (cdr_clk_sel_ff[1:0]),
// Inputs
.rx_adp_clk_lock          (rx_adp_clk_lock),
.rx_soc_clk_lock          (rx_soc_clk_lock),
.rx_adp_clkph_code        (rx_adp_clkph_code[3:0]),
.rx_soc_clkph_code        (rx_soc_clkph_code[3:0]),
// AIBIO CDR
// Inputs
.aibio_cdr_lock                 (aibio_cdr_lock),
// AIBIO TXDLL
// Outputs
.tdll_dll_inclk_sel       (tdll_dll_inclk_sel[1:0]),
.tdll_dll_lockthresh_code (tdll_dll_lockthresh_code[3:0]),
.tdll_dll_lockctrl_code   (tdll_dll_lockctrl_code[1:0]),
.tdll_ovrd_pi_adpclk_code (tdll_ovrd_pi_adpclk_code),
.tdll_pi_adpclk_code      (tdll_pi_adpclk_code[3:0]),
.tddl_adp_lock_ovrd_ff    (tddl_adp_lock_ovrd_ff),
.tddl_soc_lock_ovrd_ff    (tddl_soc_lock_ovrd_ff),
.tdll_ovrd_pi_socclk_code (tdll_ovrd_pi_socclk_code),
.tdll_pi_socclk_code      (tdll_pi_socclk_code[3:0]),
.tdll_digview_sel         (tdll_digview_sel[4:0]),
// Inputs
.tx_adp_clk_lock          (tx_adp_clk_lock),
.tx_soc_clk_lock          (tx_soc_clk_lock),
.tx_adp_clkph_code        (tx_adp_clkph_code[3:0]),
.tx_soc_clkph_code        (tx_soc_clkph_code[3:0]),
// AIBIO RXCLK CBB
// Outputs
.iorclk_dcc_bias_code       (iorclk_dcc_bias_code[2:0]),
.iorclk_ibias_ctrl_nored    (iorclk_ibias_ctrl_nored[2:0]),
.iorclk_ibias_ctrl_red      (iorclk_ibias_ctrl_red[2:0]),
// Inputs
.rx_dcc_lock                (rx_dcc_lock),
// AIBIO DCS CBB
// Outputs
.dcs1_clkdiv_sel       (dcs1_clkdiv_sel[1:0]), 
.dcs1_sel_clkp         (dcs1_sel_clkp),        
.dcs1_sel_clkn         (dcs1_sel_clkn),        
.dcs1_en_single_ended  (dcs1_en_single_ended), 
.dcs1_sel_ovrd_ff      (dcs1_sel_ovrd_ff),
.dcs1_lock_ovrd_ff     (dcs1_lock_ovrd_ff),
.dcs1_chopen_ovrd_ff   (dcs1_chopen_ovrd_ff),
.dcs2_npusel_code_ff   (dcs2_npusel_code_ff[4:0]),
.dcs2_npdsel_code_ff   (dcs2_npdsel_code_ff[4:0]),
.dcs2_ppusel_code_ff   (dcs2_ppusel_code_ff[4:0]),
.dcs2_ppdsel_code_ff   (dcs2_ppdsel_code_ff[4:0]),
// Inputs
.dcs1_lock            (dcs1_lock),
// RCOMP register
// outputs
.rcomp_calsel_g2_ovrd_ff  (rcomp_calsel_g2_ovrd_ff),
.rcomp_calcode_g2_ovrd_ff (rcomp_calcode_g2_ovrd_ff),
.rcomp_calcode_g2_ff      (rcomp_calcode_g2_ff[6:0]),
.rcomp_calsel_g1_ovrd_ff  (rcomp_calsel_g1_ovrd_ff),
.rcomp_calcode_g1_ovrd_ff (rcomp_calcode_g1_ovrd_ff),
.rcomp_calcode_g1_ff      (rcomp_calcode_g1_ff[6:0]),
// inputs
.rcomp_cal_done_g2_sync   (rcomp_cal_done_g2_sync),
.rcomp_cal_done_g1_sync   (rcomp_cal_done_g1_sync),
// RCOMP2 register
//Inputs
.rcomp_calcode_g2         (rcomp_calcode_g2),
.rcomp_calcode_g1         (rcomp_calcode_g1),
// AIBIO NTL register
// outputs
.ntl2_count_ff           (ntl2_count_ff[15:0]),
.ntl1_done_ovrd_ff       (ntl1_done_ovrd_ff),
.ntl1_tx_dodd_ovrd_ff    (ntl1_tx_dodd_ovrd_ff),
.ntl1_tx_deven_ovrd_ff   (ntl1_tx_deven_ovrd_ff),
.ntl1_rxen_ovrd_ff       (ntl1_rxen_ovrd_ff),
.ntl1_txen_ovrd_ff       (ntl1_txen_ovrd_ff),
.ntl1_en_ovrd_ff         (ntl1_en_ovrd_ff),
.ntl1_en_ff              (ntl1_en_ff),
.ntl1_pad_num_ff         (ntl1_pad_num_ff[6:0]),
.ntl1_txen_async_ovrd_ff (ntl1_txen_async_ovrd_ff),
.ntl1_rxen_async_ovrd_ff (ntl1_rxen_async_ovrd_ff),
// inputs
.ntl1_done_sync (ntl1_done_sync),
.ntl2_cnt_val_sync (ntl2_cnt_val_sync[15:0]),
// Tx clock divider
.tx_clk_div_ld_ff  (tx_clk_div_ld),
.tx_clk_div_ld_ack (tx_clk_div_ld_ack),
.tx_clk_div_1_ff   (tx_clk_div_1),
.tx_clk_div_2_ff   (tx_clk_div_2),
.tx_clk_div_4_ff   (tx_clk_div_4),
// Rx clock divider
.rx_clk_div_ld_ff  (rx_clk_div_ld),
.rx_clk_div_ld_ack (rx_clk_div_ld_ack),
.rx_clk_div_1_ff   (rx_clk_div_1),
.rx_clk_div_2_ff   (rx_clk_div_2),
.rx_clk_div_4_ff   (rx_clk_div_4),
//Analog Interface Clock dividers control signals
// Outputs
.rxoff_cal_div_ld_ff (rxoff_cal_div_ld_ff),  
.rxoff_cal_div_1_ff  (rxoff_cal_div_1_ff),  
.rxoff_cal_div_2_ff  (rxoff_cal_div_2_ff),  
.rxoff_cal_div_4_ff  (rxoff_cal_div_4_ff),  
.rxoff_cal_div_8_ff  (rxoff_cal_div_8_ff),  
.rxoff_cal_div_16_ff (rxoff_cal_div_16_ff), 
.rxoff_cal_div_32_ff (rxoff_cal_div_32_ff), 
.rxoff_cal_div_64_ff (rxoff_cal_div_64_ff), 
.sysclk_div_ld_ff    (sysclk_div_ld_ff), 
.sysclk_div_1_ff     (sysclk_div_1_ff),  
.sysclk_div_2_ff     (sysclk_div_2_ff),  
.sysclk_div_4_ff     (sysclk_div_4_ff),  
.sysclk_div_8_ff     (sysclk_div_8_ff),  
.sysclk_div_16_ff    (sysclk_div_16_ff),     
.gen1rcomp_div_ld_ff (gen1rcomp_div_ld_ff),  
.gen1rcomp_div_1_ff  (gen1rcomp_div_1_ff),   
.gen1rcomp_div_2_ff  (gen1rcomp_div_2_ff),   
.gen1rcomp_div_4_ff  (gen1rcomp_div_4_ff),   
.gen1rcomp_div_8_ff  (gen1rcomp_div_8_ff),   
.gen1rcomp_div_16_ff (gen1rcomp_div_16_ff),  
.gen1rcomp_div_32_ff (gen1rcomp_div_32_ff),  
.gen2rcomp_div_ld_ff (gen2rcomp_div_ld_ff),  
.gen2rcomp_div_1_ff  (gen2rcomp_div_1_ff),   
.gen2rcomp_div_2_ff  (gen2rcomp_div_2_ff),   
.gen2rcomp_div_4_ff  (gen2rcomp_div_4_ff),   
.gen2rcomp_div_8_ff  (gen2rcomp_div_8_ff),   
.gen2rcomp_div_16_ff (gen2rcomp_div_16_ff),  
.gen2rcomp_div_32_ff (gen2rcomp_div_32_ff),  
.dcs_div_ld_ff       (dcs_div_ld_ff), 
.dcs_div_1_ff        (dcs_div_1_ff),  
.dcs_div_2_ff        (dcs_div_2_ff),  
.dcs_div_4_ff        (dcs_div_4_ff),  
.dcs_div_8_ff        (dcs_div_8_ff),  
.dcs_div_16_ff       (dcs_div_16_ff), 
.dcs_div_32_ff       (dcs_div_32_ff), 
.dcs_div_64_ff       (dcs_div_64_ff), 
.dcs_div_128_ff      (dcs_div_128_ff),
.dcs_div_256_ff      (dcs_div_256_ff),
// Inputs
.rxoff_cal_div_ld_ack (rxoff_cal_div_ld_ack), 
.sysclk_div_ld_ack    (sysclk_div_ld_ack),    
.gen1rcomp_div_ld_ack (gen1rcomp_div_ld_ack), 
.gen2rcomp_div_ld_ack (gen2rcomp_div_ld_ack), 
.dcs_div_ld_ack       (dcs_div_ld_ack), 
// ATPG
.atpg_mode (i_scan_mode)    // ATPG mode
);


// Redundancy bits
assign redund_sft_en[101:0] = { redund_3[5:0],
                                redund_2[31:0],
                                redund_1[31:0],
                                redund_0[31:0] };

////////////////////////////////////////////////////////////////////////////////
//                             CSR for Adapter
////////////////////////////////////////////////////////////////////////////////

assign csr_rx_fifo_mode[1:0] = rx_adapt_1[2:1]; // 2'b00 1xfifo, 2'b01 2xfifo,
                                                // 2'b10 4xfifo, 2'b11 reg mode

// Marker threshold to consider RX adapter aligned
assign rx_align_threshold[4:0] = rx_adapt_1[12:8];

 //2'b00 1xfifo, 2'b01 2xfifo, 2'b10 4xfifo, 2'b11 reg mode
assign csr_tx_fifo_mode[1:0] = tx_adapt_0[22:21];

// Rx and TX word alignment detection enable
assign csr_rx_wa_en = rx_adapt_1[0]; 
assign csr_tx_wm_en = tx_adapt_0[23];

// TX phase compensation FIFO read enable delay
assign csr_tx_phcomp_rd_delay[3:0] = tx_adapt_0[31:28];

//RX phase compensation FIFO read enable delay
assign csr_rx_phcomp_rd_delay[3:0]= rx_adapt_0[27:24]; 

assign csr_tx_dbi_en = tx_adapt_0[1]; //TX DBI enable
assign csr_rx_dbi_en = rx_adapt_0[1]; //RX DBI enable

// 2'b00 no loopback. 2'b01 farside loopback. 2'b10 nearside loopback
assign csr_lpbk_mode[1:0] = tx_adapt_1[15:14];
assign csr_sdr_mode       = tx_adapt_1[31];
assign csr_paden          = tx_adapt_1[30];

// Forwarded clock test enable
assign csr_fwd_clk_test   = tx_adapt_1[9];

// Switch Upper/Lower 39 bit in FIFO2x mode in Gen1 mode
assign csr_rxswap_en = rx_adapt_0[0];

// Switch Upper/Lower 39 bit in FIFO2x mode in Gen1 mode
assign csr_txswap_en = tx_adapt_0[0];

assign csr_rx_mkbit[4:0] = rx_adapt_1[7:3];   //Marker bit position of 79:76
assign csr_tx_mkbit[4:0] = tx_adapt_0[20:16]; //Marker bit position of 79:76

assign csr_rx_wa_mode = rx_adapt_1[31];

//------------------------------------------------------------------------------
// Reset logic
//------------------------------------------------------------------------------

// Reset used on avalon interface
assign csr_async_rstn = ((~por) & i_cfg_avmm_rst_n) |
                        i_scan_mode;

// CSR reset synchronizer
aib_rst_sync i_csr_async_rstn
(
.clk         (i_cfg_avmm_clk),   // Destination clock of reset to be synced
.i_rst_n     (csr_async_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),      // Scan enable
.sync_rst_n  (csr_sync_rstn)     // Synchronized reset output
);

// Adapter asynchronous reset
assign adapt_rstn =     i_conf_done          &
                     ((~por) | i_scan_mode)  &
                        i_cfg_avmm_rst_n     &
                        ns_adapter_rstn      &
                     (rwrp_fs_adapter_rstn | i_scan_mode);

assign iopad_rstb   =  i_conf_done & (~por) | i_scan_mode;


assign tx_fifo_transfer_en = ( dual_mode_select  ?
                               ms_tx_transfer_en :
                               sl_tx_transfer_en  ) | i_scan_mode;

assign rx_fifo_transfer_en = ( dual_mode_select  ?
                               ms_rx_transfer_en :
                               sl_rx_transfer_en  ) | i_scan_mode;


// Adapter reset n= i_conf_done & (~por) & i_cfg_avmm_rst_n &
//                 rwrp_fs_adapter_rstn & ns_adapter_rstn
assign tx_fifo_rstn = tx_fifo_transfer_en & adapt_rstn;
assign rx_fifo_rstn = rx_fifo_transfer_en & adapt_rstn;

// OSC FSM reset
assign osc_fsm_rstn = i_conf_done & ((~por) | i_scan_mode) &
                      i_cfg_avmm_rst_n;

// OSC FSM reset synchronizer
aib_rst_sync i_osc_fsm_ms_rstn
(
.clk         (i_osc_clk),   // Destination clock of reset to be synced
.i_rst_n     (osc_fsm_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),    // Scan enable
.sync_rst_n  (osc_fsm_ms_rstn) // Synchronized reset output
);

// OSC FSM reset synchronizer
aib_rst_sync i_osc_fsm_sl_rstn
(
.clk         (sr_clk_in_int),  // Destination clock of reset to be synced
.i_rst_n     (osc_fsm_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),    // Scan enable
.sync_rst_n  (osc_fsm_sl_rstn) // Synchronized reset output
);

// CAL FSM reset

// MS CAL FSM reset synchronizer
aib_rst_sync i_cal_fsm_ms_rstn
(
.clk         (i_osc_clk),   // Destination clock of reset to be synced
.i_rst_n     (adapt_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),    // Scan enable
.sync_rst_n  (cal_fsm_ms_rstn) // Synchronized reset output
);

// SL CAL FSM reset synchronizer
aib_rst_sync i_cal_fsm_sl_rstn
(
.clk         (sr_clk_in_int),  // Destination clock of reset to be synced
.i_rst_n     (adapt_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),    // Scan enable
.sync_rst_n  (cal_fsm_sl_rstn) // Synchronized reset output
);


//------------------------------------------------------------------------------

assign rcomp_cal_done = rcomp_cal_done_g1 | rcomp_cal_done_g2;
// Logic to separate even and odd bits
always @(*)
  begin: tx_data_in_even_odd_logic
    for(i=0;i<NBR_LANES;i=i+1)
      begin
        tx_data_in_even[i] = aibio_dout[2*i];
        tx_data_in_odd[i]  = aibio_dout[(2*i)+1];
      end
  end // block: tx_data_in_even_odd_logic

// Logic to group even and odd bits
always @(*)
  begin: aibio_din_logic
    for(j=0;j<NBR_LANES;j=j+1)
      begin
        aibio_din[2*j]     = rwrp_rx_data_even[j];
        aibio_din[(2*j)+1] = rwrp_rx_data_odd[j];
      end
  end // block: aibio_din_logic


aib_rst_sync tclkdiv_rst_sync
(
.clk         (ns_fwd_clk),         // Destination clock of reset to be synced
.i_rst_n     (csr_async_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),        // Scan enable
.sync_rst_n  (tclk_div_rstn)       // Synchronized reset output
);

aib_rst_sync rclkdiv_rst_sync
(
.clk         (piclk_soc_buf),         // Destination clock of reset to be synced
.i_rst_n     (csr_async_rstn),   // Asynchronous reset input
.scan_mode   (i_scan_mode),        // Scan enable
.sync_rst_n  (rclk_div_rstn)       // Synchronized reset output
);

aib_clk_div  txchn_clk_div (
// Inputs
.rst_n            (tclk_div_rstn), // Asynchronous reset
.clk              (ns_fwd_clk),    // Tx clock from IO logic to SoC
.scan_mode        (i_scan_mode),   // Scan enable
.clk_div_ld       (tx_clk_div_ld), // Tx Clock divider enable from avalon int.
.clk_div_1_onehot (tx_clk_div_1),  // Onehot enable for Tx clock divided by 1
.clk_div_2_onehot (tx_clk_div_2),  // Onehot enable for Tx clock divided by 2
.clk_div_4_onehot (tx_clk_div_4),  // Onehot enable for Tx clock divided by 4
   // Outputs
.clk_out           (ns_fwd_clk_div),   // Clock divided
.clk_div_ld_ack_ff (tx_clk_div_ld_ack) // Tx clock div load ack
);

aib_clk_div  rxchn_clk_div (
// Inputs
.rst_n            (rclk_div_rstn), // Asynchronous reset
.clk              (piclk_soc_buf),    // Rx clock from bump
.scan_mode        (i_scan_mode),   // Scan enable
.clk_div_ld       (rx_clk_div_ld), // Rx Clock divider enable from avalon int.
.clk_div_1_onehot (rx_clk_div_1),  // Onehot enable for Rx clock divided by 1
.clk_div_2_onehot (rx_clk_div_2),  // Onehot enable for Rx clock divided by 2
.clk_div_4_onehot (rx_clk_div_4),  // Onehot enable for Rx clock divided by 4
   // Outputs
.clk_out           (fs_fwd_clk_div),     // Clock divided
.clk_div_ld_ack_ff (rx_clk_div_ld_ack) // Tx clock div load ack
);

// DFT logic for internal generated clocks
clk_mux sr_clk_mux(
// Inputs
.clk1   (m_ns_fwd_clk),   // s=1
.clk2   (rwrp_fs_sr_clk), // s=0
.s      (i_scan_mode),
// Outputs
.clkout (sr_clk_in_int)
);

assign shift_en_clkbuf[0] = redund_sft_en[70];
assign shift_en_clkbuf[1] = redund_sft_en[71];

assign tx_bypass_serialiser[101:0] = tx_async_en_to_pad[101:0];

assign tx_start_phase         = tx_dll_lock;
assign rx_start_phase         = cdr_lock; 
assign tx_soc_start_phase     = tx_adapt_phase_locked;
assign rx_adapter_start_phase = rx_ana_phase_locked;
assign cdr_start              = rx_dll_lock | i_scan_mode; 
assign cdr_phase_detect       = phdet_cdr_out;
//------------------------------------------------------------------------------
//  ADAPTER INSTANCE
//------------------------------------------------------------------------------

assign m_fs_fwd_clk = rclk_adapt_buf; 
assign fs_fwd_clk   = piclk_soc_rtl;

aib_adapter #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_adapt (
// Inputs
.atpg_mode(i_scan_mode),
.dual_mode_select(dual_mode_select),
.m_gen2_mode(m_gen2_mode),
.adapt_rstn(adapt_rstn),
.tx_fifo_rstn(tx_fifo_rstn),
.rx_fifo_rstn(rx_fifo_rstn),
.data_in(data_in),  //from mac
.data_in_f(data_in_f),  //from mac
.aibio_din(aibio_din[79:0]),      //from IO buffer
.csr_sdr_mode (csr_sdr_mode), // SDR enable
// Outputs
.data_out_f(data_out_f), //to mac
.data_out(data_out), //to mac
.aibio_dout(aibio_dout[79:0]),   //to IO buffer

// Inputs
.tx_clk_adapter(tx_clk_adapter_rtl),
.m_wr_clk(m_wr_clk),
.m_rd_clk(m_rd_clk),
.fs_fwd_clk_div (fs_fwd_clk_div),

// Inputs
.rclk_adapt(rclk_adapt_rtl), 

// Outputs
.ms_tx_transfer_en(ms_tx_transfer_en),
.ms_rx_transfer_en(ms_rx_transfer_en),
.sl_tx_transfer_en(sl_tx_transfer_en),
.sl_rx_transfer_en(sl_rx_transfer_en),
// Inputs
.ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
.ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
.sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req),
.sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req),
.ms_tx_dcc_cal_doneint(rcomp_cal_done), //TBD, lockint will assert after the rcomp calibration done 
.sl_tx_dcc_cal_doneint(rcomp_cal_done), //TBD, lockint will assert after the rcomp calibration done 
.ms_rx_dll_lockint(rcomp_cal_done), //TBD, lockint will assert after the rcomp calibration done,
.sl_rx_dll_lockint(rcomp_cal_done), //TBD, lockint will assert after the rcomp calibration done, 
.osc_fsm_ms_rstn (osc_fsm_ms_rstn), 
.osc_fsm_sl_rstn (osc_fsm_sl_rstn), 
.cal_fsm_ms_rstn (cal_fsm_ms_rstn),  
.cal_fsm_sl_rstn (cal_fsm_sl_rstn), 

// Outputs
.ms_sideband(sr_ms_tomac),
.sl_sideband(sr_sl_tomac),
.m_rx_align_done(m_rx_align_done),

// Inputs
.sr_clk_in(sr_clk_in_int),      //SR clock in for master and slave from AIBIO
.srd_in(rwrp_fs_sr_data),
.srl_in(rwrp_fs_sr_load),

// Outputs
.sr_clk_out(adapt_sr_clk_out),
.std_out(adapt_std_out),
.stl_out(adapt_stl_out),

// Input
.i_osc_clk(i_osc_clk), //from aux channel

// Inputs
.sl_external_cntl_26_0(sl_external_cntl_26_0),  //user defined bits 26:0 for slave shift register
.sl_external_cntl_30_28(sl_external_cntl_30_28), //user defined bits 30:28 for slave shift register
.sl_external_cntl_57_32(sl_external_cntl_57_32), //user defined bits 57:32 for slave shift register
.ms_external_cntl_4_0(ms_external_cntl_4_0),   //user defined bits 4:0 for master shift register
.ms_external_cntl_65_8(ms_external_cntl_65_8),  //user defined bits 65:8 for master shift register

 // CSR bit
 // Inputs
.fwd_clk_test_sync (fwd_clk_test_sync), 
.csr_rx_fifo_mode(csr_rx_fifo_mode),
.rx_align_threshold (rx_align_threshold[4:0]),
.csr_tx_fifo_mode(csr_tx_fifo_mode),
.csr_rx_wa_en(csr_rx_wa_en),
.csr_rx_wa_mode(csr_rx_wa_mode),
.csr_tx_wm_en(csr_tx_wm_en),
.csr_rx_mkbit(csr_rx_mkbit),
.csr_tx_mkbit(csr_tx_mkbit),
.csr_rxswap_en(csr_rxswap_en),
.csr_txswap_en(csr_txswap_en),
.csr_tx_phcomp_rd_delay(csr_tx_phcomp_rd_delay[3:0]),
.csr_rx_phcomp_rd_delay(csr_rx_phcomp_rd_delay[3:0]),
.csr_tx_dbi_en(csr_tx_dbi_en),
.csr_rx_dbi_en(csr_rx_dbi_en),
.csr_lpbk_mode(csr_lpbk_mode),
.n_lpbk (n_lpbk),
.csr_fwd_clk_test (csr_fwd_clk_test),
//----------------------------------
//  BERT access interface
//----------------------------------
.bert_acc_addr    (bert_acc_addr[5:0]),   // BERT access address
.bert_acc_req     (bert_acc_req),         // BERT access request
.bert_acc_rdwr    (bert_acc_rdwr),        // BERT access read/write control
.bert_wdata_ff    (bert_wdata_ff[31:0]),  // BERT data to be written
.rx_bert_rdata_ff  (rx_bert_rdata_ff[31:0]), // Read data from BERT interface
.tx_bert_rdata_ff  (tx_bert_rdata_ff[31:0]), // Read data from BERT interface
.bert_acc_rq_pend (bert_acc_rq_pend),     // BERT configuration load is pending
//-----------------------------------
//  TX BERT control interface
//-----------------------------------
.tx_bert_start (tx_bert_start[3:0]), // Starts transmitting TX BERT bit sequence
.tx_bert_rst   (tx_bert_rst[3:0]),   // Resets TX BERT registers
//-----------------------------------
//  TX BERT status interface
//-----------------------------------
.bert_seed_good    (bert_seed_good),  // Indicates no zero BPRS seeds.
.txbert_run_ff     (txbert_run_ff[3:0]), // Indicates  TX BERT is running
//------------------------------------
//  RX BERT control interface
//------------------------------------
.rxbert_start   (rxbert_start[3:0]),   // Starts checking RX BERT bit sequence
.rxbert_rst     (rxbert_rst[3:0]),     // Resets RX BERT registers
.rxbert_seed_in (rxbert_seed_in[3:0]), // Enables the self-seeding in RX BERT
//------------------------------------
//  RX BERT status interface
//------------------------------------
.rxbert_run_ff    (rxbert_run_ff[3:0]),     // Indicates RX BERT is running
.rxbert_biterr_ff (rxbert_biterr_ff[3:0]),  // Error detected in RX BERT check.

// BERT enables
.tx_bert_en (tx_bert_en), // TX BERT enable

//--------------------------------------

// Avalon interface
.i_cfg_avmm_clk   (i_cfg_avmm_clk), // Avalon clock
.i_cfg_avmm_rst_n (csr_sync_rstn)   // Avalon asynchronous reset
);

//------------------------------------------------------------------------------
// REDUNDANCY WRAPPER INSTANCE
//------------------------------------------------------------------------------

// Wrapper with redundancy logic implementatioin
aib_redundancy_wrp_top #(.DATAWIDTH (40))
aib_redundancy_wrp_top(
// Inputs
.shift_en           (redund_sft_en[101:0]), // redundancy bits
.tx_data_in_even    (tx_data_in_even[39:0]), // TX even bits from adapter
.tx_data_in_odd     (tx_data_in_odd[39:0]),  // TX odd bits from adapter
.data_even_from_pad (ana_rx_even_out[101:0]),   // Rx even bits from analog top
.data_odd_from_pad  (ana_rx_odd_out[101:0]),    // Rx odd bits from analog top
.tx_lpbk_mode       (tx_lpbk_mode),  // TX loop back 
.rx_lpbk_mode       (rx_lpbk_mode),  // RX loop back
.sdr_mode_en        (csr_sdr_mode),  // SDR mode
.gen1mode_en        (~m_gen2_mode),  // gen1 mode
.csr_paden          (csr_paden),
.fwd_clk_test_sync   (fwd_clk_test_sync),
.io_ctrl1_tx_wkpu_ff (io_ctrl1_tx_wkpu_ff),
.io_ctrl1_tx_wkpd_ff (io_ctrl1_tx_wkpd_ff),
.io_ctrl1_rx_wkpu_ff (io_ctrl1_rx_wkpu_ff),
.io_ctrl1_rx_wkpd_ff (io_ctrl1_rx_wkpd_ff),
.iopad_rstb           (iopad_rstb),      // IO pad reset 
//Async Signals
.ns_adapter_rstn         (ns_adapter_rstn),
.ns_mac_rdy              (ns_mac_rdy),
.ns_sr_load              (adapt_stl_out), // SRS load  from adapter
.ns_sr_data              (adapt_std_out), // SRS data  from adapter
.ns_sr_clk               (adapt_sr_clk_out), // SRS clock from adapter
.ns_rcv_clk              (m_ns_rcv_clk),//  Near side received clock
.pad_to_adapter_async_in (ana_async_data_out[101:0]), // Async data from analog top
// Outputs
.async_data_to_pad   (rwrp_async_data_to_pad[101:0]),
.fs_rcv_clk_out      (m_fs_rcv_clk),
.fs_sr_clk_out       (rwrp_fs_sr_clk),
.fs_sr_data_out      (rwrp_fs_sr_data),
.fs_sr_load_out      (rwrp_fs_sr_load),
.fs_mac_rdy_out      (fs_mac_rdy),
.fs_adapter_rstn_out (rwrp_fs_adapter_rstn),
//To Analog block
.even_data_to_pad  (even_data_frm_red),
.odd_data_to_pad   (odd_data_frm_red),
.tx_en_to_pad      (tx_en_frm_red),
.rx_en_to_pad      (rx_en_frm_red),
.tx_async_en_to_pad(tx_async_en_frm_red),
.rx_async_en_to_pad(rx_async_en_frm_red),
.sdr_mode_en_to_pad(sdr_mode_en_to_pad),
.wkpu_en_out       (wkpu_en_out[101:0]),
.wkpd_en_out       (wkpd_en_out[101:0]),
.fault_stdby       (fault_stdby),
//To Adapter
.rx_data_out_even  (rwrp_rx_data_even[39:0]),
.rx_data_out_odd   (rwrp_rx_data_odd[39:0])
);

//------------------------------------------------------------------------------

aib_bit_sync #(.DWIDTH (16))
ntl2_count_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl2_count_ff[15:0]), 
.data_out (ntl2_count_sync[15:0])
);

aib_bit_sync #(.DWIDTH (1))
ntl1_done_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_done_ovrd_ff), 
.data_out (ntl1_done_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_tx_dodd_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_tx_dodd_ovrd_ff), 
.data_out (ntl1_tx_dodd_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_tx_deven_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_tx_deven_ovrd_ff), 
.data_out (ntl1_tx_deven_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_rxen_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_rxen_ovrd_ff), 
.data_out (ntl1_rxen_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_txen_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_txen_ovrd_ff), 
.data_out (ntl1_txen_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_txen_async_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_txen_async_ovrd_ff), 
.data_out (ntl1_txen_async_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_rxen_async_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_rxen_async_ovrd_ff), 
.data_out (ntl1_rxen_async_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_en_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_en_ovrd_ff), 
.data_out (ntl1_en_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
ntl1_en_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_en_ff), 
.data_out (ntl1_en_sync)
);


aib_bit_sync #(.DWIDTH (7))
ntl1_pad_num_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (ntl1_pad_num_ff[6:0]), 
.data_out (ntl1_pad_num_sync[6:0])
);

aib_bit_sync ntl1_done_sync_i
(
.clk(i_cfg_avmm_clk),
.rst_n(csr_async_rstn), 
.data_in(ntl1_done), 
.data_out(ntl1_done_sync)
);

aib_bit_sync  #(.DWIDTH (16))
ntl2_cnt_val_sync_i
(
.clk(i_cfg_avmm_clk),
.rst_n(csr_async_rstn), 
.data_in(ntl_count_value[15:0]), 
.data_out(ntl2_cnt_val_sync[15:0])
);

// Clock buffer
clk_buf_cel i_piclk_odd(
.clkout (piclk_odd_buf),
.clk    (piclk_odd)
);

clk_buf_cel i_rclk_adapt(
.clkout (rclk_adapt_buf),
.clk    (rclk_adapt)
);

clk_buf_cel i_piclk_soc(
.clkout (piclk_soc_buf),
.clk    (piclk_soc)
);

clk_buf_cel i_tx_clk_even(
.clkout (tx_clk_even_buf),
.clk    (tx_clk_even)
);

clk_buf_cel i_tx_clk_adapter(
.clkout (tx_clk_adapter_buf),
.clk    (tx_clk_adapter)
);

clk_resize_cel i_tx_clk_resize(
.clkout (tx_clk_adapter_rtl),
.clk    (tx_clk_adapter_buf)
);

clk_resize_cel i_rclk_resize(
.clkout (rclk_adapt_rtl),
.clk    (rclk_adapt_buf)
);

clk_resize_cel i_piclk_resize(
.clkout (piclk_soc_rtl),
.clk    (piclk_soc_buf)
);
//------------------------------------------------------------------------------
// NTL FSM
//------------------------------------------------------------------------------
aib_ntl_fsm i_aib_ntl_fsm(
.sys_clk(ck_sys),
.rst_n(sys_div_rstn),
.ntl_en(ntl1_en_sync), 
.ntl_ovrd_en(ntl1_en_ovrd_sync), 
.ntl_count_ovrd(ntl2_count_sync[15:0]), 
.ntl_tx_en_ovrd({102{ntl1_txen_ovrd_sync}}),
.ntl_rx_en_ovrd({102{ntl1_rxen_ovrd_sync}}),
.ntl_async_tx_en_ovrd({102{ntl1_txen_async_ovrd_sync}}), 
.ntl_async_rx_en_ovrd({102{ntl1_rxen_async_ovrd_sync}}), 
.ntl_tx_data_even_ovrd({102{ntl1_tx_deven_ovrd_sync}}), 
.ntl_tx_data_odd_ovrd({102{ntl1_tx_dodd_ovrd_sync}}), 
.ntl_done_ovrd(ntl1_done_ovrd_sync), 
.tx_en(tx_en_frm_red),
.rx_en(rx_en_frm_red),
.tx_async_en(tx_async_en_frm_red),
.rx_async_en(rx_async_en_frm_red),
.pad_num(ntl1_pad_num_sync[6:0]), //7-bits, from AVMM
.tx_data_even(even_data_frm_red),
.tx_data_odd(odd_data_frm_red),
.rx_data_even(ana_rx_even_out), //From Analog
.rx_data_odd(ana_rx_odd_out),
.ntl_count_value(ntl_count_value[15:0]), //16bits
.pad_tx_en(tx_en_to_pad),
.pad_rx_en(rx_en_to_pad),
.pad_async_tx_en(tx_async_en_to_pad),
.pad_async_rx_en(rx_async_en_to_pad),
.pad_tx_data_even(rwrp_even_data_to_pad[101:0]),
.pad_tx_data_odd(rwrp_odd_data_to_pad[101:0]),
.ntl_done(ntl1_done)
);

//====================================
//Clock Divider for Div-1,2,4,8,16,32
//====================================
aib_rst_sync sysdiv_rst_sync
(
.clk         (m_ns_fwd_clk), // Destination clock of reset to be synced
.i_rst_n     (osc_fsm_rstn),     // Asynchronous reset input
.scan_mode   (i_scan_mode),  // Scan mode
.sync_rst_n  (sys_div_rstn)  // Synchronized reset output
);

aib_clk_div_sys i_aib_clk_div(
.rst_n(sys_div_rstn), //TBD
.clk(m_ns_fwd_clk),
.scan_mode(i_scan_mode),
.clk_div_ld(sysclk_div_ld_ff),         
.clk_div_1_onehot(sysclk_div_1_ff),   
.clk_div_2_onehot(sysclk_div_2_ff),   
.clk_div_4_onehot(sysclk_div_4_ff),   
.clk_div_8_onehot(sysclk_div_8_ff),   
.clk_div_16_onehot(sysclk_div_16_ff),  
.clk_out(ck_sys),
.clk_div_ld_ack_ff(sysclk_div_ld_ack) 
);


//------------------------------------------------------------------------------
// CLOCK PHASE ADJUSTMENT FSM
//------------------------------------------------------------------------------
phase_adjust_fsm_top i_phase_adjust_fsm(
.m_ns_fwd_clk(m_ns_fwd_clk),
.tx_clk_adapter(tx_clk_adapter_buf),
.tx_clk_even(tx_clk_even_buf),
.rx_clk_ana(piclk_odd_buf),
.rclk_adapt(rclk_adapt_buf),
.fs_fwd_clk(piclk_soc_buf),
.ck_sys(ck_sys), 
.reset_n(sys_div_rstn), 
.phase_tx_adapt_ovrd_sel(tdll_ovrd_pi_adpclk_code),
.phase_tx_adapt_locked_ovrd(tddl_adp_lock_ovrd_ff),
.phase_tx_adapt_code_ovrd(tdll_pi_adpclk_code[3:0]),
.phase_tx_soc_ovrd_sel(tdll_ovrd_pi_socclk_code),
.phase_tx_soc_locked_ovrd(tddl_soc_lock_ovrd_ff),
.phase_tx_soc_code_ovrd(tdll_pi_socclk_code[3:0]),
.phase_rx_adapt_ovrd_sel(rdll_ovrd_pi_adpclk_code),
.phase_rx_adapt_locked_ovrd (rddl_adp_lock_ovrd_ff),
.phase_rx_adapt_code_ovrd(rdll_pi_adpclk_code[3:0]), 
.phase_rx_soc_ovrd_sel(rdll_ovrd_pi_socclk_code), 
.phase_rx_soc_locked_ovrd(rddl_soc_lock_ovrd_ff), 
.phase_rx_soc_code_ovrd(rdll_pi_socclk_code[3:0]),
.tx_adapt_start_phase_lock(tx_start_phase), 
.tx_ana_start_phase_lock(tx_soc_start_phase), // DCC calibration Done
.rx_adapt_start_phase_lock(rx_adapter_start_phase), 
.rx_ana_start_phase_lock(rx_start_phase), 
.tx_en(1'b1), 
.rx_en(1'b1), 
.sel_avg(dll_sel_avg_ff),
.tx_adapt_phase_locked(tx_adapt_phase_locked), 
.tx_ana_phase_locked(tx_ana_phase_locked), 
.rx_adapt_phase_locked(rx_adapt_phase_locked), //Once it is done, DLL lock done
.rx_ana_phase_locked(rx_ana_phase_locked),
.tx_adapt_phase_sel_code(dll_ckadapt_phase_sel_code[3:0]),
.tx_ana_phase_sel_code(dll_cksoc_phase_sel_code[3:0]),
.rx_adapt_phase_sel_code(dll_piadapt_phase_sel_code[3:0]),
.rx_ana_phase_sel_code(dll_pisoc_phase_sel_code[3:0])
);

//------------------------------------------------------------------------------
// CDR FSM
//------------------------------------------------------------------------------
aib_cdr_fsm i_cdr_fsm(
.sys_clk(ck_sys), 
.rst_n(cdr_start), 
.scan_mode(i_scan_mode), 
.phase_detect(cdr_phase_detect), //RX DLL Output
.rx_en(1'b1), 
.cdr_ovrd_sel(cdr_ovrd_sel_ff), 
.cdr_lock_ovrd(cdr_lock_ovrd_ff), 
.picode_update_ovrd(cdr_picode_update), 
.picode_even_ovrd(cdr_picode_even_ff[6:0]),
.picode_odd_ovrd(cdr_picode_odd_ff[6:0]), 
.clk_sel(cdr_clk_sel_ff[1:0]), 
.cdr_lock(cdr_lock),
.picode_update(picode_update),
.picode_even(picode_even[6:0]),
.picode_odd(picode_odd[6:0])
);
//------------------------------------------------------------------------------
// RX OFFSET Calibration FSM
//------------------------------------------------------------------------------

genvar k;
generate  
 for(k=0; k<22; k=k+1)
  begin
   assign ana_rxdata_even[1+(2*k)] = ana_rx_even_out[58+(2*k)];
   assign ana_rxdata_even[2*k]     = ana_rx_even_out[58+(2*k)+1];
   assign ana_rxdata_odd[1+(2*k)]  = ana_rx_odd_out[58+(2*k)];
   assign ana_rxdata_odd[2*k]      = ana_rx_odd_out[58+(2*k)+1];
  end
endgenerate
// Logic to group even and odd bits
always @(*)
 begin 
  for(n=0;n<44;n=n+1)
   begin
    ana_rxdata[2*n]     = ana_rxdata_even[n];
    ana_rxdata[(2*n)+1] = ana_rxdata_odd[n];
   end
 end

// Calibration CSR bit synchronizers
aib_bit_sync #(.DWIDTH (5))
calvref_code_sync_i
(
.clk      (ck_sys),                     
.rst_n    (sys_div_rstn),               
.data_in  (vref_calvref_code[4:0]),     
.data_out (vref_calvref_code_sync[4:0]) 
);

aib_bit_sync #(.DWIDTH (1))
calcode_ovrd_sync_i
(
.clk      (ck_sys),      // RX FIFO write clock
.rst_n    (sys_div_rstn), // RX FIFO write domain reset
.data_in  (vref_calcode_ovrd_ff),  // Input to be synchronized
.data_out (vref_calcode_ovrd_sync) // Synchronized output
);

aib_bit_sync #(.DWIDTH (1))
caldone_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (vref_caldone_ovrd_ff), 
.data_out (vref_caldone_ovrd_sync)
);

rx_offset_cal_fsm_top i_rxoffset(
.sys_clk(ck_sys), 
.rst_n(sys_div_rstn), 
.rx_offset_ovrd_sel(vref_calcode_ovrd_sync), 
.rx_offset_cal_done_ovrd(vref_caldone_ovrd_sync),  
.rx_offset_cal_code_ovrd(vref_calvref_code_sync[4:0]),
.start_cal(rx_adapt_phase_locked), //rxoffset should start only after rx dll is locked
.ana_rxdata({rcomp_out_g2,rcomp_out_g1,ana_rxdata}), 
.scan_mode(i_scan_mode),
.clk_div_ld(rxoff_cal_div_ld_ff), 
.clk_div_1_onehot(rxoff_cal_div_1_ff), 
.clk_div_2_onehot(rxoff_cal_div_2_ff), 
.clk_div_4_onehot(rxoff_cal_div_4_ff), 
.clk_div_8_onehot(rxoff_cal_div_8_ff),
.clk_div_16_onehot(rxoff_cal_div_16_ff), 
.clk_div_32_onehot(rxoff_cal_div_32_ff), 
.clk_div_64_onehot(rxoff_cal_div_64_ff), 
.rxoffset_cal_done(vref_cal_done), 
.rx_offset_cal_run (rx_offset_cal_run),
.rxoffset_cal_code(offs_cal_code),
.rxoffset_clk_div_ld_ack_ff(rxoff_cal_div_ld_ack) 
);

aib_bit_sync #(.DWIDTH (1))
rxcaldone_sync_i
(
.clk      (i_cfg_avmm_clk),        
.rst_n    (csr_async_rstn),          
.data_in  (vref_cal_done),  
.data_out (vref_cal_done_sync) 
);

// Logic to separate even and odd bits
always @(*)
 begin: offs_cal_code_even_odd_logic
  for(m=0;m<44;m=m+1)
   begin
    offs_cal_code_even[m][4:0] = offs_cal_code[2*m][4:0];
    offs_cal_code_odd[m][4:0]  = offs_cal_code[(2*m)+1][4:0];
   end
end 

generate
 for(k=0; k<58; k=k+1)
  begin
   assign rx_ofscal_even[k][4:0] = 5'b1_0000;
   assign rx_ofscal_odd[k][4:0]  = 5'b1_0000;
  end
endgenerate

generate
 for(k=0; k<22; k=k+1)
  begin
   assign rx_ofscal_even[58+(2*k)][4:0]   = offs_cal_code_even[1+(2*k)][4:0];
   assign rx_ofscal_even[58+(2*k)+1][4:0] = offs_cal_code_even[(2*k)][4:0];
   assign rx_ofscal_odd[58+(2*k)][4:0]    = offs_cal_code_odd[1+(2*k)][4:0];
   assign rx_ofscal_odd[58+(2*k)+1][4:0]  = offs_cal_code_odd[(2*k)][4:0];
  end
endgenerate
assign rx_ofscal_g1 = offs_cal_code[88][4:0];
assign rx_ofscal_g2 = offs_cal_code[89][4:0];
//------------------------------------------------------------------------------
// RCOMP Calibration FSM
//------------------------------------------------------------------------------

aib_bit_sync #(.DWIDTH (1))
rcomp_calsel_g2_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calsel_g2_ovrd_ff), 
.data_out (rcomp_calsel_g2_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
rcomp_calcode_g2_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calcode_g2_ovrd_ff), 
.data_out (rcomp_caldone_g2_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (7))
rcomp_calcode_g2_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calcode_g2_ff[6:0]), 
.data_out (rcomp_calcode_g2_ff_sync[6:0])
);


aib_bit_sync #(.DWIDTH (1))
rcomp_calsel_g1_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calsel_g1_ovrd_ff), 
.data_out (rcomp_calsel_g1_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
rcomp_calcode_g1_ovrd_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calcode_g1_ovrd_ff), 
.data_out (rcomp_caldone_g1_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (7))
rcomp_calcode_g1_sync_i
(
.clk      (ck_sys),               
.rst_n    (sys_div_rstn),         
.data_in  (rcomp_calcode_g1_ff[6:0]), 
.data_out (rcomp_calcode_g1_ff_sync[6:0])
);

rcomp_calibration_fsm i_rcomp_g2(
.sys_clk(ck_sys),
.rst_n(sys_div_rstn),
.rcomp_cal_ovrd_sel(rcomp_calsel_g2_ovrd_sync), 
.rcomp_cal_done_ovrd(rcomp_caldone_g2_ovrd_sync), 
.rcomp_cal_code_ovrd(rcomp_calcode_g2_ff_sync[6:0]),
.start_cal(vref_cal_done),    
.pad_data(rcomp_out_g2),  
.gen1mode_en(m_gen2_mode), 
.scan_mode(i_scan_mode), 
.clk_div_ld(gen2rcomp_div_ld_ff), 
.clk_div_1_onehot(gen2rcomp_div_1_ff), 
.clk_div_2_onehot(gen2rcomp_div_2_ff), 
.clk_div_4_onehot(gen2rcomp_div_4_ff), 
.clk_div_8_onehot(gen2rcomp_div_8_ff), 
.clk_div_16_onehot(gen2rcomp_div_16_ff),
.clk_div_32_onehot(gen2rcomp_div_32_ff),
.rcomp_cal_done(rcomp_cal_done_g2),
.rcomp_cal_en(rcomp_cal_en_g2), 
.rcomp_cal_code(rcomp_cal_code_g2),  
.rcomp_clk_div_ld_ack_ff(gen2rcomp_div_ld_ack) 
);

rcomp_calibration_fsm i_rcomp_g1(
.sys_clk(ck_sys),
.rst_n(sys_div_rstn),
.start_cal(vref_cal_done), 
.rcomp_cal_ovrd_sel(rcomp_calsel_g1_ovrd_sync), 
.rcomp_cal_done_ovrd(rcomp_caldone_g1_ovrd_sync), 
.rcomp_cal_code_ovrd(rcomp_calcode_g1_ff_sync), 
.pad_data(rcomp_out_g1),  
.gen1mode_en(~m_gen2_mode), 
.scan_mode(i_scan_mode), 
.clk_div_ld(gen1rcomp_div_ld_ff), 
.clk_div_1_onehot(gen1rcomp_div_1_ff), 
.clk_div_2_onehot(gen1rcomp_div_2_ff), 
.clk_div_4_onehot(gen1rcomp_div_4_ff), 
.clk_div_8_onehot(gen1rcomp_div_8_ff), 
.clk_div_16_onehot(gen1rcomp_div_16_ff),
.clk_div_32_onehot(gen1rcomp_div_32_ff),
.rcomp_cal_done(rcomp_cal_done_g1), 
.rcomp_cal_en(rcomp_cal_en_g1), 
.rcomp_cal_code(rcomp_cal_code_g1),  
.rcomp_clk_div_ld_ack_ff(gen1rcomp_div_ld_ack) 
);

aib_bit_sync #(.DWIDTH (1))
rcomp_cal_done_g1_sync_i
(
.clk      (i_cfg_avmm_clk),               
.rst_n    (csr_async_rstn),         
.data_in  (rcomp_cal_done_g1), 
.data_out (rcomp_cal_done_g1_sync)
);

aib_bit_sync #(.DWIDTH (1))
rcomp_cal_done_g2_sync_i
(
.clk      (i_cfg_avmm_clk),               
.rst_n    (csr_async_rstn),         
.data_in  (rcomp_cal_done_g2), 
.data_out (rcomp_cal_done_g2_sync)
);

//------------------------------------------------------------------------------

aib_bit_sync #(.DWIDTH (1))
dcs1_sel_ovrd_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs1_sel_ovrd_ff), 
.data_out (dcs1_sel_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
dcs1_lock_ovrd_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs1_lock_ovrd_ff), 
.data_out (dcs1_lock_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (1))
dcs1_chopen_ovrd_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs1_chopen_ovrd_ff), 
.data_out (dcs1_chopen_ovrd_sync)
);

aib_bit_sync #(.DWIDTH (5))
dcs_npusel_code_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs2_npusel_code_ff[4:0]), 
.data_out (dcs2_npusel_code_sync[4:0])
);

aib_bit_sync #(.DWIDTH (5))
dcs_npdsel_code_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs2_npdsel_code_ff[4:0]), 
.data_out (dcs2_npdsel_code_sync[4:0])
);

aib_bit_sync #(.DWIDTH (5))
dcs_ppusel_code_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs2_ppusel_code_ff[4:0]), 
.data_out (dcs2_ppusel_code_sync[4:0])
);

aib_bit_sync #(.DWIDTH (5))
dcs_ppdsel_code_sync_i
(
.clk      (ck_sys),
.rst_n    (sys_div_rstn),
.data_in  (dcs2_ppdsel_code_ff[4:0]), 
.data_out (dcs2_ppdsel_code_sync[4:0])
);

//------------------------------------------------------------------------------
// DCs FSM
//------------------------------------------------------------------------------
aib_dcs_fsm i_dcs_fsm(
.sys_clk(ck_sys),
.rst_n(sys_div_rstn), 
.duty_gt_50(dc_gt_50),
.dcs_en(sys_div_rstn), 
.dcs_ovrd_sel(dcs1_sel_ovrd_sync),
.dcs_ovrd_lock(dcs1_lock_ovrd_sync), 
.dcs_ovrd_chopen(dcs1_chopen_ovrd_sync),
.dcs_ovrd_p_pdsel(dcs2_ppdsel_code_sync[4:0]),
.dcs_ovrd_p_pusel(dcs2_ppusel_code_sync[4:0]),
.dcs_ovrd_n_pdsel(dcs2_npdsel_code_sync[4:0]),
.dcs_ovrd_n_pusel(dcs2_npusel_code_sync[4:0]),
.scan_mode(i_scan_mode),
.clk_div_ld(dcs_div_ld_ff),
.clk_div_1_onehot(dcs_div_1_ff),
.clk_div_2_onehot(dcs_div_2_ff),
.clk_div_4_onehot(dcs_div_4_ff),
.clk_div_8_onehot(dcs_div_8_ff),
.clk_div_16_onehot(dcs_div_16_ff),
.clk_div_32_onehot(dcs_div_32_ff),
.clk_div_64_onehot(dcs_div_64_ff),
.clk_div_128_onehot(dcs_div_128_ff),
.clk_div_256_onehot(dcs_div_256_ff),
.dcc_p_pdsel(dcc_p_pdsel),
.dcc_p_pusel(dcc_p_pusel),
.dcc_n_pdsel(dcc_n_pdsel),
.dcc_n_pusel(dcc_n_pusel),
.chopen(chopen),
.dcs_lock(dcs_lock),
.clk_div_ld_ack_ff(dcs_div_ld_ack)
);

//------------------------------------------------------------------------------
// AIB IO ANALOG TOP INSTANCE
//------------------------------------------------------------------------------

// Clock MUX for far side loop back
// When in far side loop back mode, TX DLL input is  m_rd_clk
// instead of TX PLL clock (m_ns_fwd_clk)

assign f_lpbk = (csr_lpbk_mode == FARSIDE_LPBK);
assign tx_lpbk_mode = iocmn_tx_lpbk_en | (csr_lpbk_mode == NEARSIDE_LPBK);
assign rx_lpbk_mode = iocmn_rx_lpbk_en | (csr_lpbk_mode == NEARSIDE_LPBK);
assign n_lpbk = tx_lpbk_mode | rx_lpbk_mode;

assign flpb_txpll_mux_sel = f_lpbk & ~i_scan_mode;

clk_mux clk_mux_txpll(
// Inputs
.clk1   (piclk_soc_buf),    // s=1
.clk2   (m_ns_fwd_clk),  // s=0
.s      (flpb_txpll_mux_sel),
// Outputs
.clkout (tclk_dll)
);

clk_mux jtag_mux_txpll(
// Inputs
.clk1   (m_ns_fwd_clk),     // s=1
.clk2   (jtag_clkdr_in),  // s=0
.s      (i_scan_mode),
// Outputs
.clkout (test_clk)
);

// -----------------------------------------------------------------------------
// Concatenation logic for the aib bus sync block
// -----------------------------------------------------------------------------

assign bus_src_sync_data[36:0] = { rx_dll_lock,
                                   cdr_lock,
                                   rx_adapt_phase_locked,
                                   rx_ana_phase_locked,
                                   tx_adapt_phase_locked,
                                   tx_ana_phase_locked,
                                   dll_piadapt_phase_sel_code[3:0],
                                   dll_pisoc_phase_sel_code[3:0],
                                   dll_ckadapt_phase_sel_code[3:0],
                                   dll_cksoc_phase_sel_code[3:0],
                                   rcomp_cal_code_g1[6:0],
                                   rcomp_cal_code_g2[6:0],
                                   dcs_lock };

assign rx_dcc_lock       = bus_dest_sync_data [36];
assign aibio_cdr_lock    = bus_dest_sync_data [35];
assign rx_adp_clk_lock   = bus_dest_sync_data [34];
assign rx_soc_clk_lock   = bus_dest_sync_data [33];
assign tx_adp_clk_lock   = bus_dest_sync_data [32];
assign tx_soc_clk_lock   = bus_dest_sync_data [31];
assign rx_adp_clkph_code = bus_dest_sync_data [30:27];
assign rx_soc_clkph_code = bus_dest_sync_data [26:23];
assign tx_adp_clkph_code = bus_dest_sync_data [22:19];
assign tx_soc_clkph_code = bus_dest_sync_data [18:15];
assign rcomp_calcode_g1  = bus_dest_sync_data [14:8];
assign rcomp_calcode_g2  = bus_dest_sync_data [7:1];
assign dcs1_lock         = bus_dest_sync_data [0];

// -----------------------------------------------------------------------------
// Logic to select scan clock or JTAG clock
// -----------------------------------------------------------------------------

assign txdll_inclk_sel[1:0] =
                       (i_scan_mode | i_jtag_clksel) ?
                        2'b11                        : // SCAN/JTAG selection
                        tdll_dll_inclk_sel[1:0];       // functional selection

assign rxdll_inclk_sel[1:0] =
                       (i_scan_mode | i_jtag_clksel) ?
                        2'b11                        : // SCAN/JTAG selection
                        rdll_dll_inclk_sel[1:0];       // functional selection


assign {co1_nc,dll_oddph1_sel[3:0]}  = (dll_cksoc_phase_sel_code[3:0] +
                                        4'b1000);

assign {co2_nc,dll_evenph1_sel[3:0]} = (dll_cksoc_phase_sel_code[3:0] +
                                        4'b0110);

assign {co3_nc,dll_oddph2_sel[3:0]}  = (dll_cksoc_phase_sel_code[3:0] +
                                       (4'b1000 + 4'b0110));


//------------------------------------------------------------------------------
//                           DFX (Analog test) logic
//------------------------------------------------------------------------------
aib_dfx_mon aib_dfx_mon(
// Inputs
.en_digmon       (iocmn_en_digmon),
.digmon_sel_code (iocmn_digmon_sel_code[15:0]),
.en_anamon       (iocmn_en_anamon),
.anamon_sel_code (iocmn_anamon_sel_code[2:0]),
// Outputs
.txrx_dfx_en       (txrx_dfx_en[103:0]),
.tx_dll_dfx_en     (tx_dll_dfx_en),
.rx_dll_dfx_en     (rx_dll_dfx_en),
.dcs_dfx_en        (dcs_dfx_en),
.txrx_digviewsel   (txrx_digviewsel[4:0]),
.txrx_anaviewsel   (txrx_anaviewsel[2:0]),
.onehot_anaviewsel (onehot_anaviewsel[4:0])
);
//------------------------------------------------------------------------------
//                              Bias control and cap control logic
//------------------------------------------------------------------------------
aib_dll_ctrl_logic tx_dll_ctrl_logic(
.freq_range_sel(iocmn_pll_freq[2:0]), 
.trim_ctrl_bits(tx_dll_trim_bits)  
);

aib_dll_ctrl_logic rx_dll_ctrl_logic(
.freq_range_sel(iocmn_pll_freq[2:0]), 
.trim_ctrl_bits(rx_dll_trim_bits[2:0])  //3-bits
);
assign tx_dll_biasctrl = {3'b000,tx_dll_trim_bits[2]};
assign rx_dll_biasctrl = {3'b000,rx_dll_trim_bits[2]};

aib_dll_ctrl_logic pi_ctrl_logic
(
.freq_range_sel(iocmn_pll_freq[2:0]),
.trim_ctrl_bits(pi_trim_bits[2:0])   
);



assign wkpu_en[101:0] = (wkpu_en_out[101:0] & {102{(~i_scan_mode)}}) |
                        ({102{jtag_weakpu}});

assign wkpd_en[101:0] =
              (wkpd_en_out[101:0] & {102{(~i_scan_mode)}}) |
              (fault_stdby[101:0] & {102{(~i_scan_mode)}}) |
              {{102{jtag_weakpdn}}};

//------------------------------------------------------------------------------
//                              Analog wrapper
//------------------------------------------------------------------------------
// Wrapper for analog modules
aibio_ana_top aibio_ana_top(
.iopad (iopad_aib[101:0]), // IO Pads
// Analog signals
.vddc2 (vddc2),
.vddc1 (vddc1),
.vddtx (vddtx),
.vss   (vss),
//=========================================
// Outputs
.rx_even_out     (ana_rx_even_out[101:0]), //To Adapter
.rx_odd_out      (ana_rx_odd_out[101:0]),
.async_data_out  (ana_async_data_out[101:0]),
// Inputs
.tx_datain_even  (rwrp_even_data_to_pad[101:0]), //From Adapter
.tx_datain_odd   (rwrp_odd_data_to_pad[101:0]),
.async_data_in   (rwrp_async_data_to_pad[101:0]),
.shift_en_clkbuf (shift_en_clkbuf),           
//====================================
// Inputs
.test_clk          (test_clk),
.jtag_clk          (jtag_clkdr_in),
.jtag_tx_scanen_in (jtag_tx_scanen_in),
.jtag_din          (scan_in),
.jtag_mode_in      (jtag_mode_in),
.jtag_rstb_en      (jtag_rstb_en),
.jtag_rstb         (jtag_rstb),
.jtag_intest       (jtag_intest),
// Outputs
.jtag_dout         (scan_out),
//====================================
// Outputs
.txrx_anaviewout  (txrx_anaviewout[3:0]),
// Inputs
.rx_calen         (rx_offset_cal_run),     
.rcomp_cal_en_g1  (rcomp_cal_en_g1), 
.rcomp_cal_en_g2  (rcomp_cal_en_g2), 
.rx_ofscal_g1     (rx_ofscal_g1[4:0]), 
.rx_ofscal_g2     (rx_ofscal_g2[4:0]), 
.rcomp_out_g2     (rcomp_out_g2),     
.rcomp_out_g1     (rcomp_out_g1),     
.rcomp_cal_code_g1 (rcomp_cal_code_g1),     
.rcomp_cal_code_g2 (rcomp_cal_code_g2),     
.rx_en            (rx_en_to_pad),
.gen1mode_en      (~m_gen2_mode), 
.gen2mode_en      (m_gen2_mode), 
.rx_ofscal_even   (rx_ofscal_even), 
.rx_ofscal_odd    (rx_ofscal_odd),  
.rx_deskew        (iotxrx_rx_deskew_ff[3:0]),
.txrx_dfx_en      (txrx_dfx_en[103:0]),   
.txrx_digviewsel  (txrx_digviewsel[4:0]),
.txrx_anaviewsel  (txrx_anaviewsel[2:0]), 
.onehot_anaviewsel (onehot_anaviewsel[4:0]), 
.tx_en            (tx_en_to_pad), 
.tx_async_en      (tx_async_en_to_pad), 
.rx_async_en      (rx_async_en_to_pad), 
.sdr_mode_en      (sdr_mode_en_to_pad),
.wkpu_en          (wkpu_en[101:0]), 
.wkpd_en          (wkpd_en[101:0]),
.fault_stdby      (fault_stdby[101:0]),
.tx_bypass_serialiser (tx_bypass_serialiser),
.txdrv_npd_sel    (iotxrx_tx_drvnpd_code[7:0]), 
.txdrv_npu_sel    (iotxrx_tx_drvnpu_code[7:0]), 
.txdrv_ppu_sel    (iotxrx_tx_drvppu_code[7:0]), 
.tx_deskew        (iotxrx_tx_deskew_ff[3:0]),
.iotxrx_tx_deskew_en_ff     (iotxrx_tx_deskew_en_ff),
.iotxrx_tx_deskew_step_ff   (iotxrx_tx_deskew_step_ff),
.iotxrx_tx_deskew_ovrd_ff   (iotxrx_tx_deskew_ovrd_ff),
.iotxrx_rx_deskew_en_ff     (iotxrx_rx_deskew_en_ff),
.iotxrx_rx_deskew_step_ff   (iotxrx_rx_deskew_step_ff),
.iotxrx_rx_deskew_ovrd_ff   (iotxrx_rx_deskew_ovrd_ff),
//===========================================
//TX DLL
//------Output pins------//
.tx_dll_lock       (tx_dll_lock), 
.clk_soc           (ns_fwd_clk),
.clk_adapter       (tx_clk_adapter),
.tx_clk_even       (tx_clk_even),
.tx_dll_anaviewout (tx_dll_anaviewout),
//------Input pins------//
.ck_in               (tclk_dll),
.ck_sys              (ck_sys), 
.tx_dll_en           (i_conf_done),
.rx_dll_en           (dcs_lock), //DCs fsm will start by conf_done signal and DCs lock will enable the rx_dll block
.tx_dll_reset        (por),
.rx_dll_reset        (por),
.tx_inp_clksel       (txdll_inclk_sel[1:0]), 
.rx_inp_clksel       (rxdll_inclk_sel[1:0]), 
.tx_dll_biasctrl     (tx_dll_biasctrl[3:0]), 
.rx_dll_biasctrl     (rx_dll_biasctrl[3:0]), 
.tx_dll_capctrl      ({3'b00,tx_dll_trim_bits[1:0]}),
.rx_dll_capctrl      ({3'b00,rx_dll_trim_bits[1:0]}),
.dll_cksoc_code      (4'b0000),
.dll_ckadapter_code  (dll_ckadapt_phase_sel_code[3:0]),
.dll_even_phase1_sel (dll_cksoc_phase_sel_code[3:0]),
.dll_odd_phase1_sel  (dll_oddph1_sel[3:0]),
.dll_even_phase2_sel (dll_evenph1_sel[3:0]),
.dll_odd_phase2_sel  (dll_oddph2_sel[3:0]),
.tx_dll_lockthresh   (tdll_dll_lockthresh_code[3:0]),
.rx_dll_lockthresh   (rdll_dll_lockthresh_code[3:0]),
.tx_dll_lockctrl     (tdll_dll_lockctrl_code[1:0]),
.rx_dll_lockctrl     (rdll_dll_lockctrl_code[1:0]),
.tx_dll_dfx_en       (tx_dll_dfx_en), 
.rx_dll_dfx_en       (rx_dll_dfx_en), 
.sdr_mode            (csr_sdr_mode),
.tx_dll_digview_sel  (tdll_digview_sel[4:0]), 
.rx_dll_digview_sel  (rdll_digview_sel[4:0]), 
//RX DLL
//------Input pins------//
.picode_update      (picode_update), 
.pi_biasctrl        ({3'b000,pi_trim_bits[2]}),
.pi_capctrl         ({3'b000,pi_trim_bits[1:0]}),
.cdr_ctrl           ({1'b0,rdll_cdrctrl_code[2:0]}), 
.dll_piodd_code     ({1'b0,picode_odd[6:0]}),
.dll_pieven_code    ({1'b0,picode_even[6:0]}),
.dll_pisoc_code     (dll_pisoc_phase_sel_code[3:0]),
.dll_piadapter_code (dll_piadapt_phase_sel_code[3:0]),
.n_lpbk             (n_lpbk),
//------Output pins------//
.phdet_cdr_out      (phdet_cdr_out),
.rx_dll_lock        (rx_dll_lock),
.piclk_adapter      (rclk_adapt),
.piclk_soc          (piclk_soc),
.piclk_odd          (piclk_odd),
.rx_dll_anaviewout  (rx_dll_anaviewout),
.digviewout         (digviewout),
//VREF_CBB
//------Input pins------//
.vref_en     (iopad_rstb), 
.calvref_en  (rx_adapt_phase_locked), 
.vref_bin_0  (vref_p_code_gen1[6:0]), //Expected default value gen1 mode is 7'h40 and in Gen2 mode 7'h7F
.vref_bin_1  (vref_n_code_gen1[6:0]), 
.vref_bin_2  (vref_p_code_gen2[6:0]), 
.vref_bin_3  (vref_n_code_gen2[6:0]), 
.calvref_bin (vref_calvref_code[4:0]), 
//Rx Clk CBB
//------Input pins------//
.dcc_p_pdsel        (dcc_p_pdsel),  
.dcc_p_pusel        (dcc_p_pusel),  
.dcc_n_pdsel        (dcc_n_pdsel),  
.dcc_n_pusel        (dcc_n_pusel),  
.rxclk_en           (iopad_rstb),   
.ibias_ctrl_red     (iorclk_ibias_ctrl_red[2:0]),    
.ibias_ctrl_nored   (iorclk_ibias_ctrl_nored[2:0]), 
.ibias_ctrl_cdr     (iorclk_dcc_bias_code[2:0]), 
//DCS CBB
//------Input pins------//
.clkdiv          (dcs1_clkdiv_sel[1:0]),
.reset           (~sys_div_rstn), 
.sel_clkp        (dcs1_sel_clkp),
.sel_clkn        (dcs1_sel_clkn),
.en_single_ended (dcs1_en_single_ended),
.chopen          (chopen), 
.dcs_dfx_en      (dcs_dfx_en),
//------Output pins------//
.dc_gt_50         (dc_gt_50),
.dcs_anaviewout   (dcs_anaviewout),
// Scan mode
.i_scan_mode (i_scan_mode)
);


endmodule // aib_channel_n
