// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation.

module aib_avalon (
// Avalon access signals
input [5:0]   cfg_avmm_addr_id,  // Index of channel based on MSBs of address
input         cfg_avmm_clk,      // Access clock
input         cfg_avmm_rst_n,    // Avalon interface async reset
input         cfg_avmm_write,    // Write enable
input         cfg_avmm_read,     // Read enable
input [16:0]  cfg_avmm_addr,     // Address bus
input [31:0]  cfg_avmm_wdata,    // Write data bus 
input [3:0]   cfg_avmm_byte_en,  // Bytes enable
output [31:0] cfg_avmm_rdata,    // Read data bus
output        cfg_avmm_rdatavld, // Indicates read data is valid
output        cfg_avmm_waitreq,  // Forces host to hold access control signals

//Adapt control CSR
output [31:0] rx_adapt_0, // RX0 adapter register 
output [31:0] rx_adapt_1, // RX1 adapter register 
output [31:0] tx_adapt_0, // TX0 adapter register
output [31:0] tx_adapt_1, // TX1 adapter register

// BERT access interface
output  [ 5:0] bert_acc_addr,        // BERT access address
output         bert_acc_req,         // BERT access request
output         bert_acc_rdwr,        // BERT access read/write control
output  [31:0] bert_wdata_ff,        // BERT data to be written
input   [31:0] rx_bert_rdata_ff,     // Read data from RX BERT interface
input   [31:0] tx_bert_rdata_ff,     // Read data from TX BERT interface
input          bert_acc_rq_pend,     // BERT configuration load is pending

// TX BERT control interface
output [3:0] tx_bert_start, // Starts transmitting TX BERT bit sequence
output [3:0] tx_bert_rst,   // Resets TX BERT registers

// TX BERT status interface
input       bert_seed_good, // Indicates all BPRS seeds are not zero.
input [3:0] txbert_run_ff,  // Indicates  TX BERT is running

//  RX BERT control interface
output [3:0] rxbert_start,   // Starts checking input of RX BERT bit sequence
output [3:0] rxbert_rst,     // Resets RX BERT registers
output [3:0] rxbert_seed_in, // Enables the self-seeding in RX BERT

// RX BERT status interface
input [ 3:0] rxbert_run_ff,    // Indicates RX BERT is running
input [ 3:0] rxbert_biterr_ff, // Error detected in RX BERT checker

// BERT enable
output tx_bert_en, // TX BERT enable

//AIB IO control CSR
output [31:0] redund_0, // Redundancy IO register 0
output [31:0] redund_1, // Redundancy IO register 1
output [31:0] redund_2, // Redundancy IO register 2
output [31:0] redund_3, // Redundancy IO register 3

// AIBIO common registers
output [ 2:0] iocmn_pll_freq,
output        iocmn_tx_lpbk_en,
output        iocmn_rx_lpbk_en,
output        iocmn_en_digmon,
output [15:0] iocmn_digmon_sel_code,
output        iocmn_en_anamon,
output [ 2:0] iocmn_anamon_sel_code,
output [1:0]  dll_sel_avg_ff,

// AIBIO TX/RX registers
output [7:0] iotxrx_tx_drvnpd_code,
output [7:0] iotxrx_tx_drvnpu_code,
output [7:0] iotxrx_tx_drvppu_code,
output       io_ctrl1_tx_wkpu_ff,
output       io_ctrl1_tx_wkpd_ff,
output       io_ctrl1_rx_wkpu_ff,
output       io_ctrl1_rx_wkpd_ff,
output [3:0] iotxrx_tx_deskew_ff,
output [3:0] iotxrx_rx_deskew_ff,
output       iotxrx_tx_deskew_en_ff,
output       iotxrx_tx_deskew_step_ff,
output       iotxrx_tx_deskew_ovrd_ff,
output       iotxrx_rx_deskew_en_ff,
output       iotxrx_rx_deskew_step_ff,
output       iotxrx_rx_deskew_ovrd_ff,

// AIBIO VREF registers
output [6:0] vref_p_code_gen1,
output [6:0] vref_n_code_gen1,
output [6:0] vref_p_code_gen2,
output [6:0] vref_n_code_gen2,
output [4:0] vref_calvref_code,
output       vref_calcode_ovrd_ff,
output       vref_caldone_ovrd_ff,
input        vref_cal_done_sync,

// AIBIO RX DLL
output [1:0] rdll_dll_inclk_sel,
output [3:0] rdll_dll_lockthresh_code,
output [1:0] rdll_dll_lockctrl_code,
output [2:0] rdll_cdrctrl_code,
output       rdll_ovrd_pi_adpclk_code,
output       rddl_adp_lock_ovrd_ff,
output       rddl_soc_lock_ovrd_ff,
output [3:0] rdll_pi_adpclk_code,
output       rdll_ovrd_pi_socclk_code,
output [3:0] rdll_pi_socclk_code,
output [4:0] rdll_digview_sel,
output       cdr_picode_update,
output [6:0] cdr_picode_even_ff,
output [6:0] cdr_picode_odd_ff,
output       cdr_ovrd_sel_ff,
output       cdr_lock_ovrd_ff,
output [1:0] cdr_clk_sel_ff,
input        rx_adp_clk_lock,
input        rx_soc_clk_lock,
input  [3:0] rx_adp_clkph_code,
input  [3:0] rx_soc_clkph_code,

// AIBIO CDR
input        aibio_cdr_lock,

// AIBIO TXDLL
output [1:0] tdll_dll_inclk_sel,
output [3:0] tdll_dll_lockthresh_code,
output [1:0] tdll_dll_lockctrl_code,
output       tdll_ovrd_pi_adpclk_code,
output       tddl_adp_lock_ovrd_ff,
output       tddl_soc_lock_ovrd_ff,
output [3:0] tdll_pi_adpclk_code,
output       tdll_ovrd_pi_socclk_code,
output [3:0] tdll_pi_socclk_code,
output [4:0] tdll_digview_sel,
input        tx_adp_clk_lock,
input        tx_soc_clk_lock,
input        [3:0] tx_adp_clkph_code,
input        [3:0] tx_soc_clkph_code,

// AIBIO RXCLK CBB
output [2:0] iorclk_dcc_bias_code,
output [2:0] iorclk_ibias_ctrl_nored,
output [2:0] iorclk_ibias_ctrl_red,
input        rx_dcc_lock,


// AIBIO DCS CBB
output [1:0] dcs1_clkdiv_sel,
output       dcs1_sel_clkp,
output       dcs1_sel_clkn,
output       dcs1_en_single_ended,
output       dcs1_sel_ovrd_ff,
output       dcs1_lock_ovrd_ff,
output       dcs1_chopen_ovrd_ff,
output [4:0] dcs2_npusel_code_ff, 
output [4:0] dcs2_npdsel_code_ff, 
output [4:0] dcs2_ppusel_code_ff, 
output [4:0] dcs2_ppdsel_code_ff, 
input        dcs1_lock,


// AIBIO RCOMP1 register
output        rcomp_calsel_g2_ovrd_ff,
output        rcomp_calcode_g2_ovrd_ff,
output  [6:0] rcomp_calcode_g2_ff,
output        rcomp_calsel_g1_ovrd_ff,
output        rcomp_calcode_g1_ovrd_ff,
output  [6:0] rcomp_calcode_g1_ff,
input         rcomp_cal_done_g2_sync,
input         rcomp_cal_done_g1_sync,

// AIBIO RCOMP2 register
input   [6:0] rcomp_calcode_g2,
input   [6:0] rcomp_calcode_g1,

// AIBIO NTL register
output  [15:0] ntl2_count_ff,
output         ntl1_done_ovrd_ff,
output         ntl1_tx_dodd_ovrd_ff,
output         ntl1_tx_deven_ovrd_ff,
output         ntl1_rxen_ovrd_ff,
output         ntl1_txen_ovrd_ff,
output         ntl1_en_ovrd_ff,
output         ntl1_en_ff,
output  [ 6:0] ntl1_pad_num_ff,
output         ntl1_txen_async_ovrd_ff,
output         ntl1_rxen_async_ovrd_ff,
input          ntl1_done_sync,
input   [15:0] ntl2_cnt_val_sync,

// AIB adapter clock divider interface
output tx_clk_div_ld_ff,  // Loads Tx clock divider selection
output tx_clk_div_1_ff,   // Tx Clock divided by 1 selection
output tx_clk_div_2_ff,   // Tx Clock divided by 2 selection
output tx_clk_div_4_ff,   // Tx Clock divided by 4 selection
output rx_clk_div_ld_ff,  // Loads Rx clock divider selection
output rx_clk_div_1_ff,   // Rx Clock divided by 1 selection
output rx_clk_div_2_ff,   // Rx Clock divided by 2 selection
output rx_clk_div_4_ff,   // Rx Clock divided by 4 selection
input  tx_clk_div_ld_ack, // TX clock divider load ack
input  rx_clk_div_ld_ack, // RX clock divider load ack

// Analog Interface Clock dividers control signals
output rxoff_cal_div_ld_ff,  // Loads RXOFF Cal divider selection
output rxoff_cal_div_1_ff,   // RXOFF Cal clock divided by 1
output rxoff_cal_div_2_ff,   // RXOFF Cal clock divided by 2
output rxoff_cal_div_4_ff,   // RXOFF Cal clock divided by 4
output rxoff_cal_div_8_ff,   // RXOFF Cal clock divided by 8
output rxoff_cal_div_16_ff,  // RXOFF Cal clock divided by 16
output rxoff_cal_div_32_ff,  // RXOFF Cal clock divided by 32
output rxoff_cal_div_64_ff,  // RXOFF Cal clock divided by 64
output sysclk_div_ld_ff,     // SYS clock divider selection
output sysclk_div_1_ff,      // SYS clock divided by 1
output sysclk_div_2_ff,      // SYS clock divided by 2
output sysclk_div_4_ff,      // SYS clock divided by 4
output sysclk_div_8_ff,      // SYS clock divided by 8
output sysclk_div_16_ff,     // SYS clock divided by 16
output gen1rcomp_div_ld_ff,  // GEN1 RCOMP divider selection
output gen1rcomp_div_1_ff,   // GEN1 RCOMP clock divided by 1
output gen1rcomp_div_2_ff,   // GEN1 RCOMP clock divided by 2
output gen1rcomp_div_4_ff,   // GEN1 RCOMP clock divided by 4
output gen1rcomp_div_8_ff,   // GEN1 RCOMP clock divided by 8
output gen1rcomp_div_16_ff,  // GEN1 RCOMP clock divided by 16
output gen1rcomp_div_32_ff,  // GEN1 RCOMP clock divided by 32
output gen2rcomp_div_ld_ff,  // GEN2 RCOMP divider selection
output gen2rcomp_div_1_ff,   // GEN2 RCOMP clock divided by 1
output gen2rcomp_div_2_ff,   // GEN2 RCOMP clock divided by 2
output gen2rcomp_div_4_ff,   // GEN2 RCOMP clock divided by 4
output gen2rcomp_div_8_ff,   // GEN2 RCOMP clock divided by 8
output gen2rcomp_div_16_ff,  // GEN2 RCOMP clock divided by 16
output gen2rcomp_div_32_ff,  // GEN2 RCOMP clock divided by 32
output dcs_div_ld_ff,        // DCS divider selection
output dcs_div_1_ff,         // DCS clock divided by 1
output dcs_div_2_ff,         // DCS clock divided by 2
output dcs_div_4_ff,         // DCS clock divided by 4
output dcs_div_8_ff,         // DCS clock divided by 8
output dcs_div_16_ff,        // DCS clock divided by 16
output dcs_div_32_ff,        // DCS clock divided by 32
output dcs_div_64_ff,        // DCS clock divided by 32
output dcs_div_128_ff,       // DCS clock divided by 32
output dcs_div_256_ff,       // DCS clock divided by 32
input  rxoff_cal_div_ld_ack, // RXOFF Cal divider load ack
input  sysclk_div_ld_ack,    // SYS clock divider load ack
input  gen1rcomp_div_ld_ack, // GEN1 RCOMP clock divider load ack
input  gen2rcomp_div_ld_ack, // GEN2 RCOMP clock divider load ack
input  dcs_div_ld_ack,       // dcs clock divider load ack

input  atpg_mode    // ATPG mode
);

wire        cfg_csr_clk;          // CSR clock
wire        cfg_csr_reset;        // CSR reset
wire        cfg_csr_read;         // CSR read enable
wire        cfg_csr_write;        // CSR write enable
wire [31:0] cfg_csr_wdata;        // CSR write data bus
wire [31:0] cfg_csr_rdata;        // CSR read data bus
wire [7:0]  cfg_csr_addr;         // CSR address bus
wire [3:0]  cfg_csr_byteen;       // CSR byte enables
wire        cfg_adapt_addr_match; // Address is in adapter range
wire        cfg_io_addr_match;    // Address is in IO analog range
wire [31:0] cfg_adapt_rdata;      // Adapt read data bus
wire [31:0] cfg_io_rdata;         // IO analog read bus
wire        cfg_only_id_match;
wire        cfg_only_addr_match;
wire        cfg_only_write ;
wire        cfg_only_read;  

// Base addresses
localparam AIB_BASE_BOT = 11'h200;
localparam AIB_BASE_MID = 11'h300;
localparam AIB_BASE_TOP = 11'h400;

// Configuration registers for Adapter and AIBIO
assign cfg_only_id_match = (cfg_avmm_addr_id[5:0] == cfg_avmm_addr[16:11]);

assign cfg_only_addr_match  =
        (cfg_avmm_addr[10:0] >= AIB_BASE_BOT) &
        (cfg_avmm_addr[10:0] < AIB_BASE_TOP)  &
         cfg_only_id_match;

assign cfg_adapt_addr_match = (cfg_avmm_addr[10:0] >= AIB_BASE_BOT) &
                              (cfg_avmm_addr[10:0] < AIB_BASE_MID); 

assign cfg_io_addr_match    = (cfg_avmm_addr[10:0] >= AIB_BASE_MID) &
                              (cfg_avmm_addr[10:0] < AIB_BASE_TOP); 

assign cfg_only_write       = cfg_only_addr_match & cfg_avmm_write;
assign cfg_only_read        = cfg_only_addr_match & cfg_avmm_read;
assign cfg_csr_rdata        = cfg_adapt_rdata     | cfg_io_rdata;

aib_avalon_if #( .AVMM_ADDR_WIDTH(8), .RDL_ADDR_WIDTH (8))
  adapt_cfg_rdl_intf (
.avmm_clk           (cfg_avmm_clk),       // AVMM Slave interface
.avmm_rst_n         (cfg_avmm_rst_n),     // input logic
.i_avmm_write       (cfg_only_write),     // input logic
.i_avmm_read        (cfg_only_read),      // input logic
.i_avmm_addr        (cfg_avmm_addr[7:0]), // input logic  
.i_avmm_wdata       (cfg_avmm_wdata),     // input   logic  [31:0]
.i_avmm_byte_en     (cfg_avmm_byte_en),   // input   logic  [3:0]
.o_avmm_rdata       (cfg_avmm_rdata),     // output  logic  [31:0]
.o_avmm_rdatavalid  (cfg_avmm_rdatavld),  // output  logic
.o_avmm_waitrequest (cfg_avmm_waitreq),   // output  logic
.clk                (cfg_csr_clk),        // RDL-generated memory map interface
.reset              (cfg_csr_reset),      // output  logic
.writedata          (cfg_csr_wdata),      // output  logic  [31:0]
.read               (cfg_csr_read),       // output  logic
.write              (cfg_csr_write),      // output  logic
.byteenable         (cfg_csr_byteen),     // output  logic  [3:0]
.readdata           (cfg_csr_rdata),      // input   logic  [31:0]
.address            (cfg_csr_addr)        // output  logic  [RDL_ADDR_WIDTH-1:0]
);

aib_avalon_adapt_reg adapt_csr (
.rx_0(rx_adapt_0),
.rx_1(rx_adapt_1),
.tx_0(tx_adapt_0),
.tx_1(tx_adapt_1),
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

// BERT enable
.tx_bert_en (tx_bert_en), // TX BERT enable

//--------------------------------------
.clk(cfg_csr_clk),
.reset(cfg_csr_reset),
.writedata(cfg_csr_wdata),
.read((cfg_csr_read & cfg_adapt_addr_match)),
.write((cfg_csr_write &cfg_adapt_addr_match)),
.byteenable(cfg_csr_byteen),
.readdata(cfg_adapt_rdata),
.address(cfg_csr_addr[7:0]),
// Tx clock divider
.tx_clk_div_ld_ff  (tx_clk_div_ld_ff),
.tx_clk_div_ld_ack (tx_clk_div_ld_ack),
.tx_clk_div_1_ff   (tx_clk_div_1_ff),
.tx_clk_div_2_ff   (tx_clk_div_2_ff),
.tx_clk_div_4_ff   (tx_clk_div_4_ff),
// Rx clock divider
.rx_clk_div_ld_ff  (rx_clk_div_ld_ff),
.rx_clk_div_ld_ack (rx_clk_div_ld_ack),
.rx_clk_div_1_ff   (rx_clk_div_1_ff),
.rx_clk_div_2_ff   (rx_clk_div_2_ff),
.rx_clk_div_4_ff   (rx_clk_div_4_ff)
);

aib_avalon_io_regs io_csr (
.redund_0(redund_0),
.redund_1(redund_1),
.redund_2(redund_2),
.redund_3(redund_3),
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
// Inputs
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
.tddl_adp_lock_ovrd_ff    (tddl_adp_lock_ovrd_ff),
.tddl_soc_lock_ovrd_ff    (tddl_soc_lock_ovrd_ff),
.tdll_pi_adpclk_code      (tdll_pi_adpclk_code[3:0]),
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
.dcs1_clkdiv_sel      (dcs1_clkdiv_sel[1:0]),
.dcs1_sel_clkp        (dcs1_sel_clkp),
.dcs1_sel_clkn        (dcs1_sel_clkn),
.dcs1_en_single_ended (dcs1_en_single_ended),
.dcs1_sel_ovrd_ff     (dcs1_sel_ovrd_ff),
.dcs1_lock_ovrd_ff    (dcs1_lock_ovrd_ff),
.dcs1_chopen_ovrd_ff  (dcs1_chopen_ovrd_ff),
.dcs2_npusel_code_ff  (dcs2_npusel_code_ff[4:0]),
.dcs2_npdsel_code_ff  (dcs2_npdsel_code_ff[4:0]),
.dcs2_ppusel_code_ff  (dcs2_ppusel_code_ff[4:0]),
.dcs2_ppdsel_code_ff  (dcs2_ppdsel_code_ff[4:0]),
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
.ntl1_done_sync    (ntl1_done_sync),
.ntl2_cnt_val_sync (ntl2_cnt_val_sync[15:0]),
// Clock dividers control signals
// Outputs
.rxoff_cal_div_ld_ff (rxoff_cal_div_ld_ff),  
.rxoff_cal_div_1_ff  (rxoff_cal_div_1_ff),  
.rxoff_cal_div_2_ff  (rxoff_cal_div_2_ff),  
.rxoff_cal_div_4_ff  (rxoff_cal_div_4_ff),  
.rxoff_cal_div_8_ff  (rxoff_cal_div_8_ff), 
.rxoff_cal_div_16_ff  (rxoff_cal_div_16_ff), 
.rxoff_cal_div_32_ff  (rxoff_cal_div_32_ff), 
.rxoff_cal_div_64_ff  (rxoff_cal_div_64_ff),  
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
// Other signals
.clk(cfg_csr_clk),
.reset(cfg_csr_reset),
.writedata(cfg_csr_wdata),
.read((cfg_csr_read & cfg_io_addr_match)),
.write((cfg_csr_write & cfg_io_addr_match)),
.byteenable(cfg_csr_byteen),
.readdata(cfg_io_rdata),
.address(cfg_csr_addr[7:0]),
.atpg_mode (atpg_mode) // ATPG mode
);

endmodule // aib_avalon
