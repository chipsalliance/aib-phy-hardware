// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation.

module aib_avalon_io_regs (
output [31:0] redund_0, // Redundancy register 0.
output [31:0] redund_1, // Redundancy register 1.
output [31:0] redund_2, // Redundancy register 2.
output [31:0] redund_3, // Redundancy register 3.

// AIBIO common registers
output     [ 2:0] iocmn_pll_freq,
output            iocmn_tx_lpbk_en,
output            iocmn_rx_lpbk_en,
output            iocmn_en_digmon,
output     [15:0] iocmn_digmon_sel_code,
output            iocmn_en_anamon,
output     [ 2:0] iocmn_anamon_sel_code,
output reg [ 1:0] dll_sel_avg_ff,

// AIBIO TX/RX registers
output     [7:0] iotxrx_tx_drvnpd_code,
output     [7:0] iotxrx_tx_drvnpu_code,
output     [7:0] iotxrx_tx_drvppu_code,
output reg       io_ctrl1_tx_wkpu_ff,
output reg       io_ctrl1_tx_wkpd_ff,
output reg       io_ctrl1_rx_wkpu_ff,
output reg       io_ctrl1_rx_wkpd_ff,
output reg [3:0] iotxrx_tx_deskew_ff,
output reg [3:0] iotxrx_rx_deskew_ff,
output reg       iotxrx_tx_deskew_en_ff,
output reg       iotxrx_tx_deskew_step_ff,
output reg       iotxrx_tx_deskew_ovrd_ff,
output reg       iotxrx_rx_deskew_en_ff,
output reg       iotxrx_rx_deskew_step_ff,
output reg       iotxrx_rx_deskew_ovrd_ff,

// AIBIO VREF registers
output [6:0] vref_p_code_gen1,
output [6:0] vref_n_code_gen1,
output [6:0] vref_p_code_gen2,
output [6:0] vref_n_code_gen2,
output [4:0] vref_calvref_code,
output reg   vref_calcode_ovrd_ff,
output reg   vref_caldone_ovrd_ff,
input        vref_cal_done_sync,

// AIBIO RX DLL
output [1:0] rdll_dll_inclk_sel,
output [3:0] rdll_dll_lockthresh_code,
output [1:0] rdll_dll_lockctrl_code,
output [2:0] rdll_cdrctrl_code,
output       rdll_ovrd_pi_adpclk_code,
output reg   rddl_adp_lock_ovrd_ff,
output reg   rddl_soc_lock_ovrd_ff,
output [3:0] rdll_pi_adpclk_code,
output       rdll_ovrd_pi_socclk_code,
output [3:0] rdll_pi_socclk_code,
output [4:0] rdll_digview_sel,
output       cdr_picode_update,
output reg [6:0] cdr_picode_even_ff,
output reg [6:0] cdr_picode_odd_ff,
output reg       cdr_ovrd_sel_ff,
output reg       cdr_lock_ovrd_ff,
output reg [1:0] cdr_clk_sel_ff,
input wire   rx_adp_clk_lock,
input wire   rx_soc_clk_lock,
input wire   [3:0] rx_adp_clkph_code,
input wire   [3:0] rx_soc_clkph_code,

// AIBIO CDR
input wire aibio_cdr_lock,

// AIBIO TXDLL
output [1:0] tdll_dll_inclk_sel,
output [3:0] tdll_dll_lockthresh_code,
output [1:0] tdll_dll_lockctrl_code,
output       tdll_ovrd_pi_adpclk_code,
output reg   tddl_adp_lock_ovrd_ff,
output reg   tddl_soc_lock_ovrd_ff,
output [3:0] tdll_pi_adpclk_code,
output       tdll_ovrd_pi_socclk_code,
output [3:0] tdll_pi_socclk_code,
output [4:0] tdll_digview_sel,
input wire   tx_adp_clk_lock,
input wire   tx_soc_clk_lock,
input wire   [3:0] tx_adp_clkph_code,
input wire   [3:0] tx_soc_clkph_code,

// AIBIO RXCLK CBB
output [ 2:0] iorclk_dcc_bias_code,
output [ 2:0] iorclk_ibias_ctrl_nored,
output [ 2:0] iorclk_ibias_ctrl_red,
input wire    rx_dcc_lock,

// AIBIO DCS CBB
output [1:0]     dcs1_clkdiv_sel,
output           dcs1_sel_clkp,
output           dcs1_sel_clkn,
output           dcs1_en_single_ended,
output reg       dcs1_sel_ovrd_ff,
output reg       dcs1_lock_ovrd_ff,
output reg       dcs1_chopen_ovrd_ff,
output reg [4:0] dcs2_npusel_code_ff,
output reg [4:0] dcs2_npdsel_code_ff,
output reg [4:0] dcs2_ppusel_code_ff,
output reg [4:0] dcs2_ppdsel_code_ff,
input wire       dcs1_lock,

// AIBIO RCOMP1 register
output reg       rcomp_calsel_g2_ovrd_ff,
output reg       rcomp_calcode_g2_ovrd_ff,
output reg [6:0] rcomp_calcode_g2_ff,
output reg       rcomp_calsel_g1_ovrd_ff,
output reg       rcomp_calcode_g1_ovrd_ff,
output reg [6:0] rcomp_calcode_g1_ff,
input            rcomp_cal_done_g2_sync,
input            rcomp_cal_done_g1_sync,

// AIBIO RCOMP2 register
input wire [6:0] rcomp_calcode_g2,
input wire [6:0] rcomp_calcode_g1,

// AIBIO NTL register
output reg [15:0] ntl2_count_ff,
output reg        ntl1_done_ovrd_ff,
output reg        ntl1_tx_dodd_ovrd_ff,
output reg        ntl1_tx_deven_ovrd_ff,
output reg        ntl1_rxen_ovrd_ff,
output reg        ntl1_txen_ovrd_ff,
output reg        ntl1_en_ovrd_ff,
output reg        ntl1_en_ff,
output reg [ 6:0] ntl1_pad_num_ff,
output reg        ntl1_txen_async_ovrd_ff,
output reg        ntl1_rxen_async_ovrd_ff,
input             ntl1_done_sync,
input      [15:0] ntl2_cnt_val_sync,

// Clock dividers control signals
output reg  rxoff_cal_div_ld_ff,  // Loads RXOFF Cal divider selection
output reg  rxoff_cal_div_1_ff,   // RXOFF Cal clock divided by 1
output reg  rxoff_cal_div_2_ff,   // RXOFF Cal clock divided by 2
output reg  rxoff_cal_div_4_ff,   // RXOFF Cal clock divided by 4
output reg  rxoff_cal_div_8_ff,   // RXOFF Cal clock divided by 8
output reg  rxoff_cal_div_16_ff,  // RXOFF Cal clock divided by 16
output reg  rxoff_cal_div_32_ff,  // RXOFF Cal clock divided by 32
output reg  rxoff_cal_div_64_ff,  // RXOFF Cal clock divided by 64
output reg  sysclk_div_ld_ff,     // SYS clock divider selection
output reg  sysclk_div_1_ff,      // SYS clock divided by 1
output reg  sysclk_div_2_ff,      // SYS clock divided by 2
output reg  sysclk_div_4_ff,      // SYS clock divided by 4
output reg  sysclk_div_8_ff,      // SYS clock divided by 8
output reg  sysclk_div_16_ff,     // SYS clock divided by 16
output reg  gen1rcomp_div_ld_ff,  // GEN1 RCOMP divider selection
output reg  gen1rcomp_div_1_ff,   // GEN1 RCOMP clock divided by 1
output reg  gen1rcomp_div_2_ff,   // GEN1 RCOMP clock divided by 2
output reg  gen1rcomp_div_4_ff,   // GEN1 RCOMP clock divided by 4
output reg  gen1rcomp_div_8_ff,   // GEN1 RCOMP clock divided by 8
output reg  gen1rcomp_div_16_ff,  // GEN1 RCOMP clock divided by 16
output reg  gen1rcomp_div_32_ff,  // GEN1 RCOMP clock divided by 32
output reg  gen2rcomp_div_ld_ff,  // GEN2 RCOMP divider selection
output reg  gen2rcomp_div_1_ff,   // GEN2 RCOMP clock divided by 1
output reg  gen2rcomp_div_2_ff,   // GEN2 RCOMP clock divided by 2
output reg  gen2rcomp_div_4_ff,   // GEN2 RCOMP clock divided by 4
output reg  gen2rcomp_div_8_ff,   // GEN2 RCOMP clock divided by 8
output reg  gen2rcomp_div_16_ff,  // GEN2 RCOMP clock divided by 16
output reg  gen2rcomp_div_32_ff,  // GEN2 RCOMP clock divided by 32
output reg  dcs_div_ld_ff,        // DCS divider selection
output reg  dcs_div_1_ff,         // DCS clock divided by 1
output reg  dcs_div_2_ff,         // DCS clock divided by 2
output reg  dcs_div_4_ff,         // DCS clock divided by 4
output reg  dcs_div_8_ff,         // DCS clock divided by 8
output reg  dcs_div_16_ff,        // DCS clock divided by 16
output reg  dcs_div_32_ff,        // DCS clock divided by 32
output reg  dcs_div_64_ff,        // DCS clock divided by 32
output reg  dcs_div_128_ff,       // DCS clock divided by 32
output reg  dcs_div_256_ff,       // DCS clock divided by 32
input       rxoff_cal_div_ld_ack, // RXOFF Cal divider load ack
input       sysclk_div_ld_ack,    // SYS clock divider load ack
input       gen1rcomp_div_ld_ack, // GEN1 RCOMP clock divider load ack
input       gen2rcomp_div_ld_ack, // GEN2 RCOMP clock divider load ack
input       dcs_div_ld_ack,       // DCS clock divider load acknowledge

//Bus Interface
input             clk,          // Access clock.
input             reset,        // Asynchronous reset.
input      [31:0] writedata,    // Write data bus.
input             read,         // Read control signal.
input             write,        // Write control signal.
input      [ 3:0] byteenable,   // Byte enables.
input      [ 7:0] address,      // Address bus.
input             atpg_mode,    // ATPG mode
output reg [31:0] readdata      // Read data bus.
);

// Local parameters to enable bits in registers: REDUNDANCY0, REDUNDANCY1,
// REDUNDANCY2 and REDUNDANCY3
localparam [31:0] RED_PARAM_0 = 32'hffff_ffff;
localparam [31:0] RED_PARAM_1 = 32'hfff3_ffff;
localparam [31:0] RED_PARAM_2 = 32'hffff_ffff;
localparam [31:0] RED_PARAM_3 = 32'h0000_003f;

// Register offset addresses
localparam [7:0] REDUND0_ADDR_OFF   = 8'h20;
localparam [7:0] REDUND1_ADDR_OFF   = 8'h24;
localparam [7:0] REDUND2_ADDR_OFF   = 8'h28;
localparam [7:0] REDUND3_ADDR_OFF   = 8'h2c;
localparam [7:0] IOCOMMON1_ADDR_OFF = 8'h30;
localparam [7:0] IOCOMMON2_ADDR_OFF = 8'h34;
localparam [7:0] VREFCODE_ADDR_OFF  = 8'h38;
localparam [7:0] CALVREF_ADDR_OFF   = 8'h3c;
localparam [7:0] RX_DLL1_ADDR_OFF   = 8'h40;
localparam [7:0] RX_DLL2_ADDR_OFF   = 8'h44;
localparam [7:0] CDR_ADDR_OFF       = 8'h48;
localparam [7:0] TX_DLL1_ADDR_OFF   = 8'h4c;
localparam [7:0] TX_DLL2_ADDR_OFF   = 8'h50;
localparam [7:0] RXCLK_CBB_ADDR_OFF = 8'h58;
localparam [7:0] DCS1_ADDR_OFF      = 8'h64;
localparam [7:0] DCS2_ADDR_OFF      = 8'h68;
localparam [7:0] IOTXRX1_ADDR_OFF   = 8'h7c;
localparam [7:0] IOTXRX2_ADDR_OFF   = 8'h80;
localparam [7:0] FSMDIV_ADDR_OFF    = 8'h84;
localparam [7:0] RCOMP_ADDR_OFF     = 8'h88;
localparam [7:0] RCOMP2_ADDR_OFF    = 8'h8c;
localparam [7:0] NTL1_ADDR_OFF      = 8'h90;
localparam [7:0] NTL2_ADDR_OFF      = 8'h94;

wire        reset_n;       // Active low asynchronous reset              
wire [3:0]  we_redund_0;   // Write enable for redundancy register 0     
wire [3:0]  we_redund_1;   // Write enable for redundancy register 1     
wire [3:0]  we_redund_2;   // Write enable for redundancy register 2     
wire [3:0]  we_redund_3;   // Write enable for redundancy register 3     
wire [31:0] rdata_comb;    // combinatorial read data signal declaration 
wire        redund_0_read; // Redund0 register read
wire        redund_1_read; // Redund1 register read
wire        redund_2_read; // Redund2 register read
wire        redund_3_read; // Redund3 register read
wire        redund_0_sel;  // Redund0 register selection
wire        redund_1_sel;  // Redund1 register selection
wire        redund_2_sel;  // Redund2 register selection
wire        redund_3_sel;  // Redund3 register selection
reg  [31:0] redund_0_ff;   // Redundancy register 0
reg  [31:0] redund_1_ff;   // Redundancy register 1
reg  [31:0] redund_2_ff;   // Redundancy register 2
reg  [31:0] redund_3_ff;   // Redundancy register 3

// Common1 register
wire        iocommon1_sel;
wire        iocommon1_wbyte_7_0;
wire        iocommon1_wbyte_15_8;
wire        iocommon1_wbyte_23_16;
wire        iocommon1_wbyte_31_24;
wire        iocommon1_read;
wire [31:0] iocommon1_data;
reg  [ 2:0] pll_freq_ff;
reg         tx_lpbk_en_ff;
reg         rx_lpbk_en_ff;
reg         en_digmon_ff;
reg         iocmn_en_anamon_ff;
reg  [15:0] digmon_sel_code_ff;

// Common2 register
wire        iocommon2_sel;
wire        iocommon2_wbyte_7_0;
wire        iocommon2_read;
wire [31:0] iocommon2_data;
reg  [ 2:0] anamon_sel_code_ff;

// AIBIO TX/RX1 register 
wire        iotxrx1_sel;
wire        iotxrx1_read;
wire        iotxrx1_wbyte_7_0;
wire        iotxrx1_wbyte_15_8;
wire        iotxrx1_wbyte_23_16;
wire        iotxrx1_wbyte_31_24;
wire [31:0] iotxrx1_data;
reg  [ 7:0] iotxrx_tx_drvppu_code_ff;
reg  [ 7:0] iotxrx_tx_drvnpu_code_ff;
reg  [ 7:0] iotxrx_tx_drvnpd_code_ff;

// AIBIO TX/RX2 register
wire        iotxrx2_sel;
wire        iotxrx2_read;
wire        iotxrx2_wbyte_23_16;
wire        iotxrx2_wbyte_31_24;
wire [31:0] iotxrx2_data;

// VREFCODE  register
wire        vrefcode_sel;         
wire        vrefcode_read;        
wire        vrefcode_wbyte_7_0;   
wire        vrefcode_wbyte_15_8;  
wire        vrefcode_wbyte_23_16; 
wire        vrefcode_wbyte_31_24; 
wire [31:0] vrefcode_data;
reg  [ 6:0] vref_p_code_gen1_ff;
reg  [ 6:0] vref_n_code_gen1_ff;
reg  [ 6:0] vref_p_code_gen2_ff;
reg  [ 6:0] vref_n_code_gen2_ff;

//  CALVREF  register
wire        calvref_sel;
wire        calvref_read;
wire        calvref_wbyte_7_0;
wire        calvref_wbyte_31_24;
wire [31:0] calvref_data;
reg  [ 4:0] vref_calvref_code_ff;

// AIBIO RX DLL 1 register
wire        rx_dll1_sel;
wire        rx_dll1_read;
wire        rx_dll1_wbyte_7_0;  
wire        rx_dll1_wbyte_15_8; 
wire        rx_dll1_wbyte_23_16;
wire [31:0] rx_dll1_data;
reg  [ 1:0] rdll_dll_lockctrl_code_ff;
reg  [ 1:0] rdll_dll_inclk_sel_ff;
reg  [ 3:0] rdll_dll_lockthresh_code_ff;
reg  [ 2:0] rdll_cdrctrl_code_ff;

// AIBIO RX DLL 2 register
wire        rx_dll2_sel;
wire        rx_dll2_read;
wire        rx_dll2_wbyte_7_0;  
wire        rx_dll2_wbyte_23_16;
wire        rx_dll2_wbyte_31_24;
wire [31:0] rx_dll2_data;
reg         rdll_ovrd_pi_socclk_code_ff;
reg         rdll_ovrd_pi_adpclk_code_ff;
reg  [ 3:0] rdll_pi_socclk_code_ff;
reg  [ 3:0] rdll_pi_adpclk_code_ff;
reg  [ 4:0] rdll_digview_sel_ff;

// AIBIO CDR register
wire        cdr_sel;
wire        cdr_read;
wire        cdr_wbyte_7_0;
wire        cdr_wbyte_15_8;
wire        cdr_wbyte_23_16;
wire        cdr_wbyte_31_24;
wire [31:0] cdr_data;
reg         cdr_picode_update_ff;

// AIBIO TX DLL 1 register
wire        tx_dll1_sel;
wire        tx_dll1_read;
wire        tx_dll1_wbyte_7_0;
wire        tx_dll1_wbyte_15_8;
wire        tx_dll1_wbyte_31_24;
wire [31:0] tx_dll1_data;
reg  [ 1:0] tdll_dll_lockctrl_code_ff;
reg  [ 1:0] tdll_dll_inclk_sel_ff;
reg  [ 3:0] tdll_pi_adpclk_code_ff;
reg  [ 3:0] tdll_dll_lockthresh_code_ff;

// AIBIO TX DLL 2 register
wire        tx_dll2_sel;
wire        tx_dll2_read;
wire        tx_dll2_wbyte_7_0;
wire        tx_dll2_wbyte_15_8;
wire        tx_dll2_wbyte_31_24;
wire [31:0] tx_dll2_data;
reg         tdll_ovrd_pi_adpclk_code_ff;
reg         tdll_ovrd_pi_socclk_code_ff;
reg  [ 3:0] tdll_pi_socclk_code_ff;
reg  [ 4:0] tdll_digview_sel_ff;

// AIBIO RXCLK CBB register
wire        rxclk_cbb_sel;
wire        rxclk_cbb_read;
wire        rxclk_cbb_wbyte_7_0;
wire        rxclk_cbb_wbyte_31_24;
wire [31:0] rxclk_cbb_data;
reg  [ 2:0] iorclk_dcc_bias_code_ff;
reg  [ 2:0] iorclk_ibias_ctrl_nored_ff;
reg  [ 2:0] iorclk_ibias_ctrl_red_ff;

// AIBIO DCS1 CBB register
wire        dcs1_sel;
wire        dcs1_read;
wire        dcs1_wbyte_7_0;
wire        dcs1_wbyte_31_24;
wire [31:0] dcs1_data;
reg         dcs1_en_single_ended_ff;
reg         dcs1_sel_clkn_ff;
reg         dcs1_sel_clkp_ff;
reg  [ 1:0] dcs1_clkdiv_sel_ff;


// AIBIO DCS2 CBB register
wire        dcs2_sel;
wire        dcs2_read;
wire        dcs2_wbyte_7_0;
wire        dcs2_wbyte_15_8;
wire        dcs2_wbyte_23_16;
wire        dcs2_wbyte_31_24;
wire [31:0] dcs2_data;

// FSMDIV register
wire        fsmdiv_sel;
wire        fsmdiv_read;
wire        fsmdiv_wbyte_7_0;
wire        fsmdiv_wbyte_15_8;
wire        fsmdiv_wbyte_23_16;
wire        fsmdiv_wbyte_31_24;
wire [31:0] fsmdiv_data;
reg  [ 2:0] fsmdiv_rxoff_div_ff;
reg  [ 2:0] fsmdiv_sys_div_ff;
reg  [ 2:0] fsmdiv_rcompg1_div_ff;
reg  [ 2:0] fsmdiv_rcompg2_div_ff;
reg  [ 3:0] fsmdiv_dcs_div_ff;

// AIBIO RCOMP register
wire        rcomp_sel;
wire        rcomp_read;
wire        rcomp_wbyte_7_0;  
wire        rcomp_wbyte_15_8; 
wire        rcomp_wbyte_23_16;
wire        rcomp_wbyte_31_24;
wire [31:0] rcomp_data;

// AIBIO RCOMP register
wire        rcomp2_sel;
wire        rcomp2_read;
wire [31:0] rcomp2_data;

// NTL1 register
wire        ntl1_sel;
wire        ntl1_read;
wire        ntl1_wbyte_7_0;
wire        ntl1_wbyte_15_8;
wire        ntl1_wbyte_23_16;
wire [31:0] ntl1_data;

// NTL2 register
wire        ntl2_sel;
wire        ntl2_read;
wire        ntl2_wbyte_7_0;
wire        ntl2_wbyte_15_8;
wire [31:0] ntl2_data;

// Clock divider internal signals
wire        rxoff_cal_div_if_busy;  // Indicates CDC interface is busy
wire        rxoff_cal_div_ack_sync; // Ack from CDC interface
wire        rxoff_cal_div_update;   // Update request to CDC interface
wire        rxoff_cal_div1_sel;     // ROFF CAL clock divided by 1  selection
wire        rxoff_cal_div2_sel;     // ROFF CAL clock divided by 2  selection
wire        rxoff_cal_div4_sel;     // ROFF CAL clock divided by 4  selection
wire        rxoff_cal_div8_sel;     // ROFF CAL clock divided by 8  selection
wire        rxoff_cal_div16_sel;    // ROFF CAL clock divided by 16 selection
wire        rxoff_cal_div32_sel;    // ROFF CAL clock divided by 32 selection
wire        rxoff_cal_div64_sel;    // ROFF CAL clock divided by 64 selection
wire        sysclk_div_if_busy;     // CDC interface is busy
wire        sysclk_div_update;      // Update request to CDC interface
wire        sysclk_div1_sel;        // Syc clock divided by 1 selection
wire        sysclk_div2_sel;        // Sys clock divided by 2 selection
wire        sysclk_div4_sel;        // Sys clock divided by 4 selection
wire        sysclk_div8_sel;        // Sys clock divided by 8 selection
wire        sysclk_div16_sel;       // Sys clock divided by 16 selection
wire        gen1rcomp_div_if_busy;  // CDC interface is busy
wire        gen1rcomp_div_update;   // Update request to CDC interface
wire        gen1rcomp_div1_sel;     // GEN1 RCOMP clock divided by 1 selection
wire        gen1rcomp_div2_sel;     // GEN1 RCOMP clock  divided by 2 selection
wire        gen1rcomp_div4_sel;     // GEN1 RCOMP clock  divided by 4 selection
wire        gen1rcomp_div8_sel;     // GEN1 RCOMP clock  divided by 8 selection
wire        gen1rcomp_div16_sel;    // GEN1 RCOMP clock  divided by 16 selection
wire        gen1rcomp_div32_sel;    // GEN1 RCOMP clock  divided by 32 selection
wire        gen2rcomp_div_if_busy;  // CDC interface is busy
wire        gen2rcomp_div_update;   // Update request to CDC interface
wire        gen2rcomp_div1_sel;     // GEN2 RCOMP clock divided by 1 selection
wire        gen2rcomp_div2_sel;     // GEN2 RCOMP clock  divided by 2 selection
wire        gen2rcomp_div4_sel;     // GEN2 RCOMP clock  divided by 4 selection
wire        gen2rcomp_div8_sel;     // GEN2 RCOMP clock  divided by 8 selection
wire        gen2rcomp_div16_sel;    // GEN2 RCOMP clock  divided by 16 selection
wire        gen2rcomp_div32_sel;    // GEN2 RCOMP clock  divided by 32 selection
wire        dcs_div_if_busy;        // CDC interface is busy
wire        dcs_div_update;         // Update request to CDC interface
wire        dcs_div1_sel;           // DCS clock divided by 1 selection
wire        dcs_div2_sel;           // DCS clock  divided by 2 selection
wire        dcs_div4_sel;           // DCS clock  divided by 4 selection
wire        dcs_div8_sel;           // DCS clock  divided by 8 selection
wire        dcs_div16_sel;          // DCS clock  divided by 16 selection
wire        dcs_div32_sel;          // DCS clock  divided by 32 selection
wire        dcs_div64_sel;          // DCS clock  divided by 64 selection
wire        dcs_div128_sel;         // DCS clock  divided by 128 selection
wire        dcs_div256_sel;         // DCS clock  divided by 256 selection
wire        sysclk_div_ack_sync;
wire        gen1rcomp_div_ack_sync;
wire        gen2rcomp_div_ack_sync;
wire        dcs_div_ack_sync;

// Active low asynchronous reset
assign reset_n = ~reset;

// synchronous process for the read
// Read data register
always @(negedge reset_n or posedge clk) 
  begin: readdata_register
    if (!reset_n) // reset
      readdata[31:0] <= 32'h0;
    else 
      readdata[31:0] <= rdata_comb[31:0];
  end // block: readdata_register

//-------------------------------------------------------
// A write byte enable for each register
//-------------------------------------------------------
assign redund_0_sel = (address == REDUND0_ADDR_OFF);
assign redund_1_sel = (address == REDUND1_ADDR_OFF);
assign redund_2_sel = (address == REDUND2_ADDR_OFF);
assign redund_3_sel = (address == REDUND3_ADDR_OFF);

assign redund_0_read = redund_0_sel & read;
assign redund_1_read = redund_1_sel & read;
assign redund_2_read = redund_2_sel & read;
assign redund_3_read = redund_3_sel & read;

assign  we_redund_0 = write & redund_0_sel ?
                      byteenable[3:0]      :
                      {4{1'b0}};

assign  we_redund_1 = write & redund_1_sel ?
                      byteenable[3:0]      :
                      {4{1'b0}};

assign  we_redund_2 = write & redund_2_sel ?
                      byteenable[3:0]      :
                      {4{1'b0}};

assign  we_redund_3 = write & redund_3_sel ?
                      byteenable[3:0]      : 
                      {4{1'b0}};

// Redundancy 0 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: redund_0_7_0_register
    if (!reset_n) // reset
      begin
        redund_0_ff[7:0] <= 8'h00;
      end
    else if (we_redund_0[0]) // Write enable
      begin
        redund_0_ff[7:0] <= writedata[7:0] & RED_PARAM_0[7:0];
      end
    else // Keep value
      begin
        redund_0_ff[7:0] <= redund_0_ff[7:0] & RED_PARAM_0[7:0];
      end
  end // block: redund_0_7_0_register

// Redundancy 0 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: redund_0_15_8_register
    if (!reset_n) // reset
      begin
        redund_0_ff[15:8] <= 8'h00;
      end
    else if (we_redund_0[1]) // Write enable
      begin
        redund_0_ff[15:8] <= writedata[15:8] & RED_PARAM_0[15:8];
      end
    else // Keep value
      begin
        redund_0_ff[15:8] <= redund_0_ff[15:8] & RED_PARAM_0[15:8];
      end
  end // block: redund_0_15_8_register

// Redundancy 0 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: redund_0_23_16_register
    if (!reset_n) // reset
      begin
        redund_0_ff[23:16] <= 8'h00;
      end
    else if (we_redund_0[2]) // Write enable
      begin
        redund_0_ff[23:16] <= writedata[23:16] & RED_PARAM_0[23:16];
      end
    else // Keep value
      begin
        redund_0_ff[23:16] <= redund_0_ff[23:16] & RED_PARAM_0[23:16];
      end
  end // block: redund_0_23_16_register

// Redundancy 0 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: redund_0_31_24_register
    if (!reset_n) // reset
      begin
        redund_0_ff[31:24] <= 8'h00;
      end
    else if (we_redund_0[3]) // Write enable
      begin
        redund_0_ff[31:24] <= writedata[31:24] & RED_PARAM_0[31:24];
      end
    else // Keep value
      begin
        redund_0_ff[31:24] <= redund_0_ff[31:24] & RED_PARAM_0[31:24];
      end
  end // block: redund_0_31_24_register

// Redundancy 1 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: redund_1_7_0_register
    if (!reset_n) // reset
      begin
        redund_1_ff[7:0] <= 8'h00;
      end
    else if (we_redund_1[0]) // Write enable
      begin
        redund_1_ff[7:0] <= writedata[7:0] & RED_PARAM_1[7:0];
      end
    else // Keep value
      begin
        redund_1_ff[7:0] <= redund_1_ff[7:0] & RED_PARAM_1[7:0];
      end
  end // block: redund_1_7_0_register

// Redundancy 1 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: redund_1_15_8_register
    if (!reset_n) // reset
      begin
        redund_1_ff[15:8] <= 8'h00;
      end
    else if (we_redund_1[1]) // Write enable
      begin
        redund_1_ff[15:8] <= writedata[15:8] & RED_PARAM_1[15:8];
      end
    else // Keep value
      begin
        redund_1_ff[15:8] <= redund_1_ff[15:8] & RED_PARAM_1[15:8];
      end
  end // block: redund_1_15_8_register

// Redundancy 1 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: redund_1_23_16_register
    if (!reset_n) // reset
      begin
        redund_1_ff[23:16] <= 8'h00;
      end
    else if (we_redund_1[2]) // Write enable
      begin
        redund_1_ff[23:16] <= writedata[23:16] & RED_PARAM_1[23:16];
      end
    else // Keep value
      begin
        redund_1_ff[23:16] <= redund_1_ff[23:16] & RED_PARAM_1[23:16];
      end
  end // block: redund_1_23_16_register

// Redundancy 1 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: redund_1_31_24_register
    if (!reset_n) // reset
      begin
        redund_1_ff[31:24] <= 8'h00;
      end
    else if (we_redund_1[3]) // Write enable
      begin
        redund_1_ff[31:24] <= writedata[31:24] & RED_PARAM_1[31:24];
      end
    else // Keep value
      begin
        redund_1_ff[31:24] <= redund_1_ff[31:24] & RED_PARAM_1[31:24];
      end
  end // block: redund_1_31_24_register

// Redundancy 2 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: redund_2_7_0_register
    if (!reset_n) // reset
      begin
        redund_2_ff[7:0] <= 8'h00;
      end
    else if (we_redund_2[0]) // Write enable
      begin
        redund_2_ff[7:0] <= writedata[7:0] & RED_PARAM_2[7:0];
      end
    else // Keep value
      begin
        redund_2_ff[7:0] <= redund_2_ff[7:0] & RED_PARAM_2[7:0];
      end
  end // block: redund_2_7_0_register

// Redundancy 2 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: redund_2_15_8_register
    if (!reset_n) // reset
      begin
        redund_2_ff[15:8] <= 8'h00;
      end
    else if (we_redund_2[1]) // Write enable
      begin
        redund_2_ff[15:8] <= writedata[15:8] & RED_PARAM_2[15:8];
      end
    else // Keep value
      begin
        redund_2_ff[15:8] <= redund_2_ff[15:8] & RED_PARAM_2[15:8];
      end
  end // block: redund_2_15_8_register

// Redundancy 2 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: redund_2_23_16_register
    if (!reset_n) // reset
      begin
        redund_2_ff[23:16] <= 8'h00;
      end
    else if (we_redund_2[2]) // Write enable
      begin
        redund_2_ff[23:16] <= writedata[23:16] & RED_PARAM_2[23:16];
      end
    else // Keep value
      begin
        redund_2_ff[23:16] <= redund_2_ff[23:16] & RED_PARAM_2[23:16];
      end
  end // block: redund_2_23_16_register

// Redundancy 2 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: redund_2_31_24_register
    if (!reset_n) // reset
      begin
        redund_2_ff[31:24] <= 8'h00;
      end
    else if (we_redund_2[3]) // Write enable
      begin
        redund_2_ff[31:24] <= writedata[31:24] & RED_PARAM_2[31:24];
      end
    else // Keep value
      begin
        redund_2_ff[31:24] <= redund_2_ff[31:24] & RED_PARAM_2[31:24];
      end
  end // block: redund_2_31_24_register

// Redundancy 3 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: redund_3_7_0_register
    if (!reset_n) // reset
      begin
        redund_3_ff[7:0] <= 8'h00;
      end
    else if (we_redund_3[0]) // Write enable
      begin
        redund_3_ff[7:0] <= writedata[7:0] & RED_PARAM_3[7:0];
      end
    else // Keep value
      begin
        redund_3_ff[7:0] <= redund_3_ff[7:0] & RED_PARAM_3[7:0];
      end
  end // block: redund_3_7_0_register

// Redundancy 3 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: redund_3_15_8_register
    if (!reset_n) // reset
      begin
        redund_3_ff[15:8] <= 8'h00;
      end
    else if (we_redund_3[1]) // Write enable
      begin
        redund_3_ff[15:8] <= writedata[15:8] & RED_PARAM_3[15:8];
      end
    else // Keep value
      begin
        redund_3_ff[15:8] <= redund_3_ff[15:8] & RED_PARAM_3[15:8];
      end
  end // block: redund_3_15_8_register

// Redundancy 3 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: redund_3_23_16_register
    if (!reset_n) // reset
      begin
        redund_3_ff[23:16] <= 8'h00;
      end
    else if (we_redund_3[2]) // Write enable
      begin
        redund_3_ff[23:16] <= writedata[23:16] & RED_PARAM_3[23:16];
      end
    else // Keep value
      begin
        redund_3_ff[23:16] <= redund_3_ff[23:16] & RED_PARAM_3[23:16];
      end
  end // block: redund_3_23_16_register

// Redundancy 3 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: redund_3_31_24_register
    if (!reset_n) // reset
      begin
        redund_3_ff[31:24] <= 8'h00;
      end
    else if (we_redund_3[3]) // Write enable
      begin
        redund_3_ff[31:24] <= writedata[31:24] & RED_PARAM_3[31:24];
      end
    else // Keep value
      begin
        redund_3_ff[31:24] <= redund_3_ff[31:24] & RED_PARAM_3[31:24];
      end
  end // block: redund_3_31_24_register


// Redundancy register output to optimize logic according to local
// parameters 
assign redund_0[31:0] = redund_0_ff[31:0] & RED_PARAM_0[31:0];
assign redund_1[31:0] = redund_1_ff[31:0] & RED_PARAM_1[31:0];
assign redund_2[31:0] = redund_2_ff[31:0] & RED_PARAM_2[31:0];
assign redund_3[31:0] = redund_3_ff[31:0] & RED_PARAM_3[31:0];

//------------------------------------------------------------------------------
//                            AIBIO Common registers
//------------------------------------------------------------------------------

//--------------------------
// Common1 register logic
//--------------------------

assign iocommon1_sel  = (address == IOCOMMON1_ADDR_OFF);
assign iocommon1_read = iocommon1_sel & read;

assign iocommon1_wbyte_7_0   = write & iocommon1_sel & byteenable[0];
assign iocommon1_wbyte_15_8  = write & iocommon1_sel & byteenable[1];
assign iocommon1_wbyte_23_16 = write & iocommon1_sel & byteenable[2];
assign iocommon1_wbyte_31_24 = write & iocommon1_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: iocommon1_byte_7_0_register
    if(!reset_n)
      pll_freq_ff[2:0] <= 3'd2;
    else if(iocommon1_wbyte_7_0)
      pll_freq_ff[2:0] <= writedata[2:0];
  end // block: iocommon1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: iocommon1_byte_15_8_register
    if(!reset_n)
      begin
        tx_lpbk_en_ff       <= 1'h0;
        rx_lpbk_en_ff       <= 1'h0;
        en_digmon_ff        <= 1'h0;
        iocmn_en_anamon_ff  <= 1'h0;
        dll_sel_avg_ff[1:0] <= 2'b01;
      end
    else if(iocommon1_wbyte_15_8)
      begin
        tx_lpbk_en_ff       <= writedata[8];
        rx_lpbk_en_ff       <= writedata[9];
        en_digmon_ff        <= writedata[10];
        iocmn_en_anamon_ff  <= writedata[11];
        dll_sel_avg_ff[1:0] <= writedata[13:12];
      end
  end // block: iocommon1_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: iocommon1_byte_23_16_register
    if(!reset_n)
      begin
        digmon_sel_code_ff[7:0] <= 8'h0;
      end
    else if(iocommon1_wbyte_23_16)
      begin
        digmon_sel_code_ff[7:0] <= writedata[23:16];
      end
  end // block: iocommon1_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: iocommon1_byte_31_24_register
    if(!reset_n)
      begin
        digmon_sel_code_ff[15:8] <= 8'h0;
      end
    else if(iocommon1_wbyte_31_24)
      begin
        digmon_sel_code_ff[15:8] <= writedata[31:24];
      end
  end // block: iocommon1_byte_31_24_register

assign iocommon1_data[31:0] = { digmon_sel_code_ff[15:0],
                                2'h0,
                                dll_sel_avg_ff[1:0],
                                iocmn_en_anamon_ff,
                                en_digmon_ff,
                                rx_lpbk_en_ff,
                                tx_lpbk_en_ff,
                                5'h0,
                                pll_freq_ff[2:0] };

//--------------------------
// Common2 register logic
//--------------------------

assign iocommon2_sel  = (address == IOCOMMON2_ADDR_OFF);
assign iocommon2_read = iocommon2_sel & read;

assign iocommon2_wbyte_7_0   = write & iocommon2_sel & byteenable[0];

always @(posedge clk or negedge reset_n)
  begin: iocommon2_byte_7_0_register
    if(!reset_n)
      begin
        anamon_sel_code_ff[2:0] <= 3'h0;
      end
    else if(iocommon2_wbyte_7_0)
      begin
        anamon_sel_code_ff[2:0] <= writedata[2:0];
      end
  end // block: iocommon2_byte_7_0_register

assign iocommon2_data[31:0] = { 29'h0, anamon_sel_code_ff[2:0] };


// Logic to avoid that analog control signals change during scan.
assign iocmn_pll_freq[2:0]         = (atpg_mode ? 3'd2 : pll_freq_ff[2:0]);
assign iocmn_tx_lpbk_en            = (~atpg_mode) & tx_lpbk_en_ff;
assign iocmn_rx_lpbk_en            = (~atpg_mode) & rx_lpbk_en_ff;
assign iocmn_en_digmon             = (~atpg_mode) & en_digmon_ff;

assign iocmn_digmon_sel_code[15:0] = {16{(~atpg_mode)}} &
                                     digmon_sel_code_ff[15:0];

assign iocmn_en_anamon            = (~atpg_mode) & iocmn_en_anamon_ff;
assign iocmn_anamon_sel_code[2:0] = {3{(~atpg_mode)}} &
                                     anamon_sel_code_ff[2:0];

//--------------------------
// AIBIO TX/RX register logic
//--------------------------

//--------------------------
//  VREFCODE  register logic
//--------------------------

assign vrefcode_sel  = (address == VREFCODE_ADDR_OFF);
assign vrefcode_read = vrefcode_sel & read;

assign vrefcode_wbyte_7_0   = write & vrefcode_sel & byteenable[0];
assign vrefcode_wbyte_15_8  = write & vrefcode_sel & byteenable[1];
assign vrefcode_wbyte_23_16 = write & vrefcode_sel & byteenable[2];
assign vrefcode_wbyte_31_24 = write & vrefcode_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: vrefcode_byte_7_0_register
    if(!reset_n)
      begin
        vref_p_code_gen1_ff[6:0] <= 7'h7f;
      end
    else if(vrefcode_wbyte_7_0)
      begin
        vref_p_code_gen1_ff[6:0] <= writedata[6:0];
      end
  end // block: vrefcode_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: vrefcode_byte_15_8_register
    if(!reset_n)
      begin
        vref_n_code_gen1_ff[6:0] <= 7'h7f;
      end
    else if(vrefcode_wbyte_15_8)
      begin
        vref_n_code_gen1_ff[6:0] <= writedata[14:8];
      end
  end // block: vrefcode_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: vrefcode_byte_23_16_register
    if(!reset_n)
      begin
        vref_p_code_gen2_ff[6:0] <= 7'h40;
      end
    else if(vrefcode_wbyte_23_16)
      begin
        vref_p_code_gen2_ff[6:0] <= writedata[22:16];
      end
  end // block: vrefcode_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: vrefcode_byte_31_24_register
    if(!reset_n)
      begin
        vref_n_code_gen2_ff[6:0] <= 7'h40;
      end
    else if(vrefcode_wbyte_31_24)
      begin
        vref_n_code_gen2_ff[6:0] <= writedata[30:24];
      end
  end // block: vrefcode_byte_31_24_register

assign vrefcode_data[31:0] = { 1'h0,
                               vref_n_code_gen2_ff[6:0],
                               1'h0,
                               vref_p_code_gen2_ff[6:0],
                               1'h0,
                               vref_n_code_gen1_ff[6:0],
                               1'h0,
                               vref_p_code_gen1_ff[6:0] };

// Logic to avoid that analog control signals change during scan.
assign vref_p_code_gen1 = vref_p_code_gen1_ff[6:0] & {7{(~atpg_mode)}};
assign vref_n_code_gen1 = vref_n_code_gen1_ff[6:0] & {7{(~atpg_mode)}};
assign vref_p_code_gen2 = vref_p_code_gen2_ff[6:0] & {7{(~atpg_mode)}};
assign vref_n_code_gen2 = vref_n_code_gen2_ff[6:0] & {7{(~atpg_mode)}};

//--------------------------
//  CALVREF  register logic
//--------------------------
assign calvref_sel  = (address == CALVREF_ADDR_OFF);
assign calvref_read = calvref_sel & read;

assign calvref_wbyte_7_0   = write & calvref_sel & byteenable[0];
assign calvref_wbyte_31_24 = write & calvref_sel & byteenable[1];

always @(posedge clk or negedge reset_n)
  begin: calvref_byte_7_0_register
    if(!reset_n)
      begin
        vref_calvref_code_ff[4:0] <= 5'h0;
      end
    else if(calvref_wbyte_7_0)
      begin
        vref_calvref_code_ff[4:0] <= writedata[4:0];
      end
  end // block: calvref_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: calvref_byte_31_24_register
    if(!reset_n)
      begin
        vref_calcode_ovrd_ff <= 1'h0;
        vref_caldone_ovrd_ff <= 1'h0;
      end
    else if(calvref_wbyte_31_24)
      begin
        vref_calcode_ovrd_ff <= writedata[30];
        vref_caldone_ovrd_ff <= writedata[29];
      end
  end // block: calvref_byte_31_24_register


assign calvref_data[31:0] = { vref_cal_done_sync,
                              vref_calcode_ovrd_ff,
                              vref_caldone_ovrd_ff,
                              24'h0,
                              vref_calvref_code_ff[4:0] };

// Logic to avoid that analog control signals change during scan.
assign vref_calvref_code = vref_calvref_code_ff[4:0] & {5{(~atpg_mode)}};

//--------------------------
// AIBIO RX DLL 1 register
//--------------------------
assign rx_dll1_sel  = (address == RX_DLL1_ADDR_OFF);
assign rx_dll1_read = rx_dll1_sel & read;

assign rx_dll1_wbyte_7_0   = write & rx_dll1_sel & byteenable[0];
assign rx_dll1_wbyte_15_8  = write & rx_dll1_sel & byteenable[1];
assign rx_dll1_wbyte_23_16 = write & rx_dll1_sel & byteenable[2];

always @(posedge clk or negedge reset_n)
  begin: rx_dll1_byte_7_0_register
    if(!reset_n)
      begin
        rdll_cdrctrl_code_ff[2:0]     <= 3'h0;
      end
    else if(rx_dll1_wbyte_7_0)
      begin
        rdll_cdrctrl_code_ff[2:0]     <= writedata[2:0];
      end
  end // block: rx_dll1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: rx_dll1_byte_15_8_register
    if(!reset_n)
      begin
        rdll_dll_lockthresh_code_ff[3:0] <= 4'h0;
      end
    else if(rx_dll1_wbyte_15_8)
      begin
        rdll_dll_lockthresh_code_ff[3:0] <= writedata[11:8];
      end
  end // block: rx_dll1_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: rx_dll1_byte_23_16_register
    if(!reset_n)
      begin
        rdll_dll_inclk_sel_ff[1:0]     <= 2'h0;
        rdll_dll_lockctrl_code_ff[1:0] <= 2'h0; 
      end
    else if(rx_dll1_wbyte_23_16)
      begin
        rdll_dll_inclk_sel_ff[1:0]     <= writedata[21:20];
        rdll_dll_lockctrl_code_ff[1:0] <= writedata[23:22];
      end
  end // block: rx_dll1_byte_23_16_register

assign rx_dll1_data[31:0] = { 8'b0,
                              rdll_dll_lockctrl_code_ff[1:0],  
                              rdll_dll_inclk_sel_ff[1:0],      
                              8'h0,
                              rdll_dll_lockthresh_code_ff[3:0],
                              5'h0,  
                              rdll_cdrctrl_code_ff[2:0]   };

assign rdll_dll_lockctrl_code  = rdll_dll_lockctrl_code_ff[1:0] & 
                                 {2{(~atpg_mode)}};  

assign rdll_dll_inclk_sel      = rdll_dll_inclk_sel_ff[1:0] & {2{(~atpg_mode)}};

assign rdll_dll_lockthresh_code  = rdll_dll_lockthresh_code_ff[3:0] & 
                                   {4{(~atpg_mode)}};
                                 
assign rdll_cdrctrl_code       = rdll_cdrctrl_code_ff[2:0] & {3{(~atpg_mode)}};


//--------------------------
// AIBIO RX DLL 2 register
//--------------------------
assign rx_dll2_sel  = (address == RX_DLL2_ADDR_OFF);
assign rx_dll2_read = rx_dll2_sel & read;

assign rx_dll2_wbyte_7_0   = write & rx_dll2_sel & byteenable[0];
assign rx_dll2_wbyte_23_16 = write & rx_dll2_sel & byteenable[2];
assign rx_dll2_wbyte_31_24 = write & rx_dll2_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: rx_dll2_byte_7_0_register
    if(!reset_n)
      begin
        rdll_digview_sel_ff[4:0] <= 5'h0;
      end
    else if(rx_dll2_wbyte_7_0)
      begin
        rdll_digview_sel_ff[4:0] <= writedata[4:0];
      end
  end // block: rx_dll2_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: rx_dll2_byte_23_16_register
    if(!reset_n)
      begin
        rdll_pi_adpclk_code_ff[3:0] <= 4'h0;
        rdll_pi_socclk_code_ff[3:0] <= 4'h0;
      end
    else if(rx_dll2_wbyte_23_16)
      begin
        rdll_pi_adpclk_code_ff[3:0] <= writedata[19:16];
        rdll_pi_socclk_code_ff[3:0] <= writedata[23:20];
      end
  end // block: rx_dll2_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: rx_dll2_byte_31_24_register
    if(!reset_n)
      begin
        rddl_adp_lock_ovrd_ff       <= 1'h0;
        rddl_soc_lock_ovrd_ff       <= 1'h0;
        rdll_ovrd_pi_adpclk_code_ff <= 1'h0;
        rdll_ovrd_pi_socclk_code_ff <= 1'h0;
      end
    else if(rx_dll2_wbyte_31_24)
      begin
        rddl_adp_lock_ovrd_ff        <= writedata[28];
        rddl_soc_lock_ovrd_ff        <= writedata[29];
        rdll_ovrd_pi_adpclk_code_ff  <= writedata[30];
        rdll_ovrd_pi_socclk_code_ff  <= writedata[31];
      end
  end // block: rx_dll2_byte_31_24_register

assign rx_dll2_data[31:0] = { rdll_ovrd_pi_socclk_code_ff,
                              rdll_ovrd_pi_adpclk_code_ff,
                              rddl_soc_lock_ovrd_ff,
                              rddl_adp_lock_ovrd_ff,
                              rx_adp_clk_lock,
                              rx_soc_clk_lock,
                              2'h0,
                              rdll_pi_socclk_code_ff[3:0],
                              rdll_pi_adpclk_code_ff[3:0],
                              rx_adp_clkph_code[3:0],
                              rx_soc_clkph_code[3:0],
                              3'h0,
                              rdll_digview_sel_ff[4:0] };

// Logic to avoid that analog control signals change during scan.
assign rdll_ovrd_pi_socclk_code = rdll_ovrd_pi_socclk_code_ff & (~atpg_mode);
assign rdll_ovrd_pi_adpclk_code = rdll_ovrd_pi_adpclk_code_ff & (~atpg_mode);

assign rdll_pi_socclk_code    = rdll_pi_socclk_code_ff[3:0] & {4{(~atpg_mode)}};
assign rdll_pi_adpclk_code    = rdll_pi_adpclk_code_ff[3:0] & {4{(~atpg_mode)}};
assign rdll_digview_sel       = rdll_digview_sel_ff[4:0]    & {5{(~atpg_mode)}};

//--------------------------
// AIBIO CDR register
//--------------------------
assign cdr_sel  = (address == CDR_ADDR_OFF);
assign cdr_read = cdr_sel & read;

assign cdr_wbyte_7_0   = write & cdr_sel & byteenable[0];
assign cdr_wbyte_15_8  = write & cdr_sel & byteenable[1];
assign cdr_wbyte_23_16 = write & cdr_sel & byteenable[2];
assign cdr_wbyte_31_24 = write & cdr_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: cdr_byte_7_0_register
    if(!reset_n)
      begin
        cdr_picode_even_ff[6:0] <= 7'h0;
      end
    else if(cdr_wbyte_7_0)
      begin
        cdr_picode_even_ff[6:0] <= writedata[6:0];
      end
  end // block: cdr_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: cdr_byte_15_8_register
    if(!reset_n)
      begin
        cdr_picode_odd_ff[6:0] <= 7'h0;
      end
    else if(cdr_wbyte_15_8)
      begin
        cdr_picode_odd_ff[6:0] <= writedata[14:8];
      end
  end // block: cdr_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: cdr_byte_23_16_register
    if(!reset_n)
      begin
        cdr_clk_sel_ff[1:0]     <= 2'h0;
      end
    else if(cdr_wbyte_23_16)
      begin
        cdr_clk_sel_ff[1:0] <= writedata[17:16];
      end
  end // block: cdr_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: cdr_byte_31_24_register
    if(!reset_n)
      begin
        cdr_picode_update_ff <= 1'h0;
        cdr_ovrd_sel_ff      <= 1'h0;
        cdr_lock_ovrd_ff     <= 1'h0;
      end
    else if(cdr_wbyte_31_24)
      begin
        cdr_picode_update_ff <= writedata[31];
        cdr_ovrd_sel_ff      <= writedata[30];
        cdr_lock_ovrd_ff     <= writedata[29];
      end
  end // block: cdr_byte_31_24_register


assign cdr_data[31:0] = { cdr_picode_update_ff,
                          cdr_ovrd_sel_ff,
                          cdr_lock_ovrd_ff,
                          aibio_cdr_lock,
                          10'h0,
                          cdr_clk_sel_ff[1:0],
                          1'b0,
                          cdr_picode_odd_ff[6:0],
                          1'b0,
                          cdr_picode_even_ff[6:0]  };

assign cdr_picode_update = cdr_picode_update_ff    & ~atpg_mode;

//--------------------------
// AIBIO TX DLL 1 register
//--------------------------
assign tx_dll1_sel  = (address == TX_DLL1_ADDR_OFF);
assign tx_dll1_read = tx_dll1_sel & read;

assign tx_dll1_wbyte_7_0   = write & tx_dll1_sel & byteenable[0];
assign tx_dll1_wbyte_15_8  = write & tx_dll1_sel & byteenable[1];
assign tx_dll1_wbyte_31_24 = write & tx_dll1_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: tx_dll1_byte_7_0_register
    if(!reset_n)
      begin
        tdll_dll_lockthresh_code_ff[3:0] <= 4'h0;
      end
    else if(tx_dll1_wbyte_7_0)
      begin
        tdll_dll_lockthresh_code_ff[3:0] <= writedata[7:4];
      end
  end // block: tx_dll1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: tx_dll1_byte_15_8_register
    if(!reset_n)
      begin
        tdll_pi_adpclk_code_ff[3:0]   <= 4'h0;
      end
    else if(tx_dll1_wbyte_15_8)
      begin
        tdll_pi_adpclk_code_ff[3:0]   <= writedata[11:8];
      end
  end // block: tx_dll1_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: tx_dll1_byte_31_24_register
    if(!reset_n)
      begin
        tdll_dll_inclk_sel_ff[1:0]     <= 2'h0;
        tdll_dll_lockctrl_code_ff[1:0] <= 2'h0;
      end
    else if(tx_dll1_wbyte_31_24)
      begin
        tdll_dll_inclk_sel_ff[1:0]     <= writedata[25:24];
        tdll_dll_lockctrl_code_ff[1:0] <= writedata[29:28];
      end
  end // block: tx_dll1_byte_31_24_register

assign tx_dll1_data[31:0] = { 2'h0,
                              tdll_dll_lockctrl_code_ff[1:0],
                              2'h0,
                              tdll_dll_inclk_sel_ff[1:0],
                              12'h0,
                              tdll_pi_adpclk_code_ff[3:0],
                              tdll_dll_lockthresh_code_ff[3:0],
                              4'h0   };
                              

// Logic to avoid that analog control signals change during scan.
assign tdll_dll_lockctrl_code   = tdll_dll_lockctrl_code_ff[1:0] &
                                  {2{(~atpg_mode)}};

assign tdll_dll_inclk_sel       = tdll_dll_inclk_sel_ff[1:0] &
                                  {2{(~atpg_mode)}};

assign tdll_pi_adpclk_code      = tdll_pi_adpclk_code_ff[3:0]  &
                                  {4{(~atpg_mode)}};

assign tdll_dll_lockthresh_code = tdll_dll_lockthresh_code_ff[3:0] &
                                  {4{(~atpg_mode)}};

//--------------------------
// AIBIO TX DLL 2 register
//--------------------------
assign tx_dll2_sel  = (address == TX_DLL2_ADDR_OFF);
assign tx_dll2_read = tx_dll2_sel & read;

assign tx_dll2_wbyte_7_0   = write & tx_dll2_sel & byteenable[0];
assign tx_dll2_wbyte_15_8  = write & tx_dll2_sel & byteenable[1];
assign tx_dll2_wbyte_31_24 = write & tx_dll2_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: tx_dll2_byte_7_0_register
    if(!reset_n)
      begin
        tdll_pi_socclk_code_ff[3:0] <= 4'h0;
      end
    else if(tx_dll2_wbyte_7_0)
      begin
        tdll_pi_socclk_code_ff[3:0] <= writedata[3:0];
      end
  end // block: tx_dll2_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: tx_dll2_byte_15_8_register
    if(!reset_n)
      begin
        tdll_digview_sel_ff[4:0] <= 8'h0;
      end
    else if(tx_dll2_wbyte_15_8)
      begin
        tdll_digview_sel_ff[4:0] <= writedata[12:8];
      end
  end // block: tx_dll32byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: tx_dll2_byte_31_24_register
    if(!reset_n)
      begin
        tddl_soc_lock_ovrd_ff       <= 1'b0;
        tddl_adp_lock_ovrd_ff       <= 1'b0;
        tdll_ovrd_pi_socclk_code_ff <= 1'h0;
        tdll_ovrd_pi_adpclk_code_ff <= 1'h0;
      end
    else if(tx_dll2_wbyte_31_24)
      begin
        tddl_soc_lock_ovrd_ff       <= writedata[26];
        tddl_adp_lock_ovrd_ff       <= writedata[27];
        tdll_ovrd_pi_socclk_code_ff <= writedata[28];
        tdll_ovrd_pi_adpclk_code_ff <= writedata[31];
      end
  end // block: tx_dll2_byte_31_24_register

assign tx_dll2_data[31:0] = { tdll_ovrd_pi_adpclk_code_ff,
                              2'h0,
                              tdll_ovrd_pi_socclk_code_ff,
                              tddl_adp_lock_ovrd_ff,
                              tddl_soc_lock_ovrd_ff,
                              tx_adp_clk_lock,
                              tx_soc_clk_lock,
                              tx_adp_clkph_code[3:0],
                              tx_soc_clkph_code[3:0],
                              3'h0,
                              tdll_digview_sel_ff[4:0],
                              4'h0,
                              tdll_pi_socclk_code_ff[3:0]   };

assign tdll_ovrd_pi_adpclk_code = tdll_ovrd_pi_adpclk_code_ff & (~atpg_mode);
assign tdll_ovrd_pi_socclk_code = tdll_ovrd_pi_socclk_code_ff & (~atpg_mode);

assign tdll_pi_socclk_code = tdll_pi_socclk_code_ff[3:0] & {4{(~atpg_mode)}};

assign tdll_digview_sel[4:0] = tdll_digview_sel_ff[4:0] & {5{(~atpg_mode)}};

//--------------------------
// AIBIO RXCLK CBB register
//--------------------------
assign rxclk_cbb_sel  = (address == RXCLK_CBB_ADDR_OFF);
assign rxclk_cbb_read = rxclk_cbb_sel & read;

assign rxclk_cbb_wbyte_7_0   = write & rxclk_cbb_sel & byteenable[0];
assign rxclk_cbb_wbyte_31_24 = write & rxclk_cbb_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: rxclk_cbb_byte_31_24_register
    if(!reset_n)
      begin
        iorclk_dcc_bias_code_ff[2:0]  <= 3'h4;
      end
    else if(rxclk_cbb_wbyte_31_24)
      begin
        iorclk_dcc_bias_code_ff[2:0]  <= writedata[26:24];
      end
  end // block: rxclk_cbb_byte_31_24_register

always @(posedge clk or negedge reset_n)
  begin: rxclk_cbb_byte_7_0_register
    if(!reset_n)
      begin
        iorclk_ibias_ctrl_nored_ff[2:0] <= 3'h4;
        iorclk_ibias_ctrl_red_ff[2:0]   <= 3'h4;
      end
    else if(rxclk_cbb_wbyte_7_0)
      begin
        iorclk_ibias_ctrl_nored_ff[2:0] <= writedata[6:4];
        iorclk_ibias_ctrl_red_ff[2:0]   <= writedata[2:0];
      end
  end // block: rxclk_cbb_byte_7_0_register

assign rxclk_cbb_data[31:0] = { rx_dcc_lock,
                                4'h0,
                                iorclk_dcc_bias_code_ff[2:0],
                                17'h0,
                                iorclk_ibias_ctrl_nored_ff[2:0],
                                1'h0,
                                iorclk_ibias_ctrl_red_ff[2:0]  };

// Logic to avoid that analog control signals change during scan.
assign iorclk_dcc_bias_code[2:0] = iorclk_dcc_bias_code_ff[2:0]  &
                                   { 3{(~atpg_mode)}};

assign iorclk_ibias_ctrl_nored[2:0] = iorclk_ibias_ctrl_nored_ff[2:0]  &
                                      { 3{(~atpg_mode)}};

assign iorclk_ibias_ctrl_red[2:0] = iorclk_ibias_ctrl_red_ff[2:0]  &
                                    { 3{(~atpg_mode)}};

//--------------------------
// AIBIO DCS1 CBB register
//--------------------------
assign dcs1_sel  = (address == DCS1_ADDR_OFF);
assign dcs1_read = dcs1_sel & read;

assign dcs1_wbyte_7_0   = write & dcs1_sel & byteenable[0];
assign dcs1_wbyte_31_24 = write & dcs1_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: dcs1_byte_7_0_register
    if(!reset_n)
      begin
        dcs1_sel_clkp_ff         <= 1'b0;
        dcs1_sel_clkn_ff         <= 1'b0;
        dcs1_clkdiv_sel_ff[1:0]  <= 2'h0;
        dcs1_en_single_ended_ff  <= 1'b0;
      end
    else if(dcs1_wbyte_7_0)
      begin
        dcs1_sel_clkn_ff        <= writedata[0];
        dcs1_sel_clkp_ff        <= writedata[1];
        dcs1_clkdiv_sel_ff[1:0] <= writedata[3:2];
        dcs1_en_single_ended_ff <= writedata[4];
      end
  end // block: dcs1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: dcs1_byte_31_24_register
    if(!reset_n)
      begin
        dcs1_sel_ovrd_ff    <= 1'h0;
        dcs1_lock_ovrd_ff   <= 1'h0;
        dcs1_chopen_ovrd_ff <= 1'h0;
      end
    else if(dcs1_wbyte_31_24)
      begin
        dcs1_sel_ovrd_ff    <= writedata[31];
        dcs1_lock_ovrd_ff   <= writedata[30];
        dcs1_chopen_ovrd_ff <= writedata[29];
      end
  end // block: dcs1_byte_31_24_register

assign dcs1_data[31:0] = { dcs1_sel_ovrd_ff,
                           dcs1_lock_ovrd_ff,
                           dcs1_chopen_ovrd_ff,
                           dcs1_lock,
                           23'h0,
                           dcs1_en_single_ended_ff,
                           dcs1_clkdiv_sel_ff[1:0],
                           dcs1_sel_clkp_ff,
                           dcs1_sel_clkn_ff     };

// Logic to avoid that analog control signals change during scan.
assign dcs1_en_single_ended = dcs1_en_single_ended_ff & (~atpg_mode);
assign dcs1_sel_clkn        = dcs1_sel_clkn_ff        & (~atpg_mode);
assign dcs1_sel_clkp        = dcs1_sel_clkp_ff        & (~atpg_mode);
assign dcs1_clkdiv_sel      = dcs1_clkdiv_sel_ff[1:0] & {2{(~atpg_mode)}};

//--------------------------
// AIBIO DCS2 CBB register
//--------------------------
assign dcs2_sel  = (address == DCS2_ADDR_OFF);
assign dcs2_read = dcs2_sel & read;

assign dcs2_wbyte_7_0   = write & dcs2_sel & byteenable[0];
assign dcs2_wbyte_15_8  = write & dcs2_sel & byteenable[1];
assign dcs2_wbyte_23_16 = write & dcs2_sel & byteenable[2];
assign dcs2_wbyte_31_24 = write & dcs2_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: dcs2_byte_7_0_register
    if(!reset_n)
      begin
        dcs2_ppdsel_code_ff[4:0] <= 5'h0;
      end
    else if(dcs2_wbyte_7_0)
      begin
        dcs2_ppdsel_code_ff[4:0] <= writedata[4:0];
      end
  end // block: dcs2_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: dcs2_byte_15_8_register
    if(!reset_n)
      begin
        dcs2_ppusel_code_ff[4:0] <= 5'h0;
      end
    else if(dcs2_wbyte_15_8)
      begin
        dcs2_ppusel_code_ff[4:0] <= writedata[12:8];
      end
  end // block: dcs2_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: dcs2_byte_23_16_register
    if(!reset_n)
      begin
        dcs2_npdsel_code_ff[4:0] <= 5'h0;
      end
    else if(dcs2_wbyte_23_16)
      begin
        dcs2_npdsel_code_ff[4:0] <= writedata[20:16];
      end
  end // block: dcs2_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: dcs2_byte_31_24_register
    if(!reset_n)
      begin
        dcs2_npusel_code_ff[4:0] <= 5'h0;
      end
    else if(dcs2_wbyte_31_24)
      begin
        dcs2_npusel_code_ff[4:0] <= writedata[28:24];
      end
  end // block: dcs2_byte_31_24_register

assign dcs2_data[31:0] = { 3'h0,
                           dcs2_npusel_code_ff[4:0],
                           3'h0,
                           dcs2_npdsel_code_ff[4:0],
                           3'h0,
                           dcs2_ppusel_code_ff[4:0],
                           3'h0,
                           dcs2_ppdsel_code_ff[4:0] };

//--------------------------
// AIBIO TXRX1 register
//--------------------------
assign iotxrx1_sel  = (address == IOTXRX1_ADDR_OFF);
assign iotxrx1_read = iotxrx1_sel & read;

assign iotxrx1_wbyte_7_0   = write & iotxrx1_sel & byteenable[0];
assign iotxrx1_wbyte_15_8  = write & iotxrx1_sel & byteenable[1];
assign iotxrx1_wbyte_23_16 = write & iotxrx1_sel & byteenable[2];
assign iotxrx1_wbyte_31_24 = write & iotxrx1_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: iotxrx1_byte_7_0_register
    if(!reset_n)
      begin
        iotxrx_tx_drvnpd_code_ff[7:0] <= 8'h0;
      end
    else if(iotxrx1_wbyte_7_0)
      begin
        iotxrx_tx_drvnpd_code_ff[7:0] <= writedata[7:0];
      end
  end // block: iotxrx1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: iotxrx1_byte_15_8_register
    if(!reset_n)
      begin
        iotxrx_tx_drvnpu_code_ff[7:0] <= 8'h0;
      end
    else if(iotxrx1_wbyte_15_8)
      begin
        iotxrx_tx_drvnpu_code_ff[7:0] <= writedata[15:8];
      end
  end // block: iotxrx1_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: iotxrx1_byte_23_16_register
    if(!reset_n)
      begin
        iotxrx_tx_drvppu_code_ff[7:0] <= 8'h0;
      end
    else if(iotxrx1_wbyte_23_16)
      begin
        iotxrx_tx_drvppu_code_ff[7:0] <= writedata[23:16];
      end
  end // block: iotxrx1_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: iotxrx1_byte_31_24_register
    if(!reset_n)
      begin
        io_ctrl1_tx_wkpu_ff <= 1'b0;
        io_ctrl1_tx_wkpd_ff <= 1'b0;
        io_ctrl1_rx_wkpu_ff <= 1'b0;
        io_ctrl1_rx_wkpd_ff <= 1'b0;
      end
    else if(iotxrx1_wbyte_31_24)
      begin
        io_ctrl1_tx_wkpu_ff <= writedata[31];
        io_ctrl1_tx_wkpd_ff <= writedata[30];
        io_ctrl1_rx_wkpu_ff <= writedata[29];
        io_ctrl1_rx_wkpd_ff <= writedata[28];
      end
  end // block: iotxrx1_byte_31_24_register

assign  iotxrx1_data[31:0] = { io_ctrl1_tx_wkpu_ff,
                               io_ctrl1_tx_wkpd_ff,
                               io_ctrl1_rx_wkpu_ff,
                               io_ctrl1_rx_wkpd_ff,
                               4'h0,
                               iotxrx_tx_drvppu_code_ff[7:0],
                               iotxrx_tx_drvnpu_code_ff[7:0],
                               iotxrx_tx_drvnpd_code_ff[7:0]  };

// Logic to avoid that analog control signals change during scan
assign iotxrx_tx_drvppu_code      = iotxrx_tx_drvppu_code_ff[7:0]  & 
                                    {8{(~atpg_mode)}};

assign iotxrx_tx_drvnpu_code      = iotxrx_tx_drvnpu_code_ff[7:0]  & 
                                    {8{(~atpg_mode)}};

assign iotxrx_tx_drvnpd_code      = iotxrx_tx_drvnpd_code_ff[7:0]  &
                                    {8{(~atpg_mode)}};

//--------------------------
// AIBIO TXRX2 register
//--------------------------
assign iotxrx2_sel  = (address == IOTXRX2_ADDR_OFF);
assign iotxrx2_read = iotxrx2_sel & read;

assign iotxrx2_wbyte_23_16  = write & iotxrx2_sel & byteenable[2];
assign iotxrx2_wbyte_31_24  = write & iotxrx2_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: iotxrx2_byte_23_16_register
    if(!reset_n)
      begin
        iotxrx_tx_deskew_ff[3:0] <= 4'h0;
        iotxrx_tx_deskew_en_ff   <= 1'b1;
        iotxrx_tx_deskew_step_ff <= 1'b1;
        iotxrx_tx_deskew_ovrd_ff <= 1'b0;
      end
    else if(iotxrx2_wbyte_23_16)
      begin
        iotxrx_tx_deskew_ff[3:0] <= writedata[19:16];
        iotxrx_tx_deskew_en_ff   <= writedata[23];
        iotxrx_tx_deskew_step_ff <= writedata[22];
        iotxrx_tx_deskew_ovrd_ff <= writedata[21];
      end
  end // block: iotxrx2_byte_23_6_register

always @(posedge clk or negedge reset_n)
  begin: iotxrx2_byte_31_24_register
    if(!reset_n)
      begin
        iotxrx_rx_deskew_ff[3:0] <= 4'h0;
        iotxrx_rx_deskew_en_ff   <= 1'b1;
        iotxrx_rx_deskew_step_ff <= 1'b1;
        iotxrx_rx_deskew_ovrd_ff <= 1'b0;
      end
    else if(iotxrx2_wbyte_31_24)
      begin
        iotxrx_rx_deskew_ff[3:0] <= writedata[27:24];
        iotxrx_rx_deskew_en_ff   <= writedata[31];
        iotxrx_rx_deskew_step_ff <= writedata[30];
        iotxrx_rx_deskew_ovrd_ff <= writedata[29];
      end
  end // block: iotxrx2_byte_31_24_register

assign iotxrx2_data[31:0] = { iotxrx_rx_deskew_en_ff,
                              iotxrx_rx_deskew_step_ff,
                              iotxrx_rx_deskew_ovrd_ff,
                              1'h0,
                              iotxrx_rx_deskew_ff[3:0],
                              iotxrx_tx_deskew_en_ff,
                              iotxrx_tx_deskew_step_ff,
                              iotxrx_tx_deskew_ovrd_ff,
                              1'h0,
                              iotxrx_tx_deskew_ff[3:0],
                              16'h0   };

//--------------------------
// FSMDIV register
//--------------------------
assign fsmdiv_sel  = (address == FSMDIV_ADDR_OFF);
assign fsmdiv_read = fsmdiv_sel & read;

assign fsmdiv_wbyte_7_0    = write & fsmdiv_sel & byteenable[0];
assign fsmdiv_wbyte_15_8   = write & fsmdiv_sel & byteenable[1];
assign fsmdiv_wbyte_23_16  = write & fsmdiv_sel & byteenable[2];
assign fsmdiv_wbyte_31_24  = write & fsmdiv_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: fsmdiv_byte_7_0_register
    if(!reset_n)
      begin
        fsmdiv_rxoff_div_ff[2:0] <= 3'h1;
      end
    else if(fsmdiv_wbyte_7_0)
      begin
        fsmdiv_rxoff_div_ff[2:0] <= writedata[2:0];
      end
  end // block: fsmdiv_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: fsmdiv_byte_15_8_register
    if(!reset_n)
      begin
        fsmdiv_sys_div_ff[2:0] <= 3'h2;
      end
    else if(fsmdiv_wbyte_15_8)
      begin
        fsmdiv_sys_div_ff[2:0] <= writedata[10:8];
      end
  end // block: fsmdiv_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: fsmdiv_byte_23_16_register
    if(!reset_n)
      begin
        fsmdiv_rcompg1_div_ff[2:0] <= 3'h1;
      end
    else if(fsmdiv_wbyte_23_16)
      begin
        fsmdiv_rcompg1_div_ff[2:0] <= writedata[18:16];
      end
  end // block: fsmdiv_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: fsmdiv_byte_31_24_register
    if(!reset_n)
      begin
        fsmdiv_rcompg2_div_ff[2:0] <= 3'h1;
        fsmdiv_dcs_div_ff[3:0]     <= 4'b0111;
      end
    else if(fsmdiv_wbyte_31_24)
      begin
        fsmdiv_rcompg2_div_ff[2:0] <= writedata[26:24];
        fsmdiv_dcs_div_ff[3:0]     <= writedata[30:27];
      end
  end // block: fsmdiv_byte_31_24_register

assign fsmdiv_data[31:0] = { 1'h0,
                             fsmdiv_dcs_div_ff[3:0],
                             fsmdiv_rcompg2_div_ff[2:0],
                             5'h0,
                             fsmdiv_rcompg1_div_ff[2:0],
                             5'h0,
                             fsmdiv_sys_div_ff[2:0],
                             5'h0,
                             fsmdiv_rxoff_div_ff[2:0]};

//--------------------------
// AIBIO RCOMP1 register
//--------------------------
assign rcomp_sel  = (address == RCOMP_ADDR_OFF);
assign rcomp_read = rcomp_sel & read;

assign rcomp_wbyte_7_0   = write & rcomp_sel & byteenable[0];
assign rcomp_wbyte_15_8  = write & rcomp_sel & byteenable[1];
assign rcomp_wbyte_23_16 = write & rcomp_sel & byteenable[2];
assign rcomp_wbyte_31_24 = write & rcomp_sel & byteenable[3];

always @(posedge clk or negedge reset_n)
  begin: rcomp_byte_7_0_register
    if(!reset_n)
      begin
        rcomp_calcode_g1_ff[6:0] <= 7'h0;
      end
    else if(rcomp_wbyte_7_0)
      begin
        rcomp_calcode_g1_ff[6:0] <= writedata[6:0];
      end
  end // block: rcomp_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: rcomp_byte_15_8_register
    if(!reset_n)
      begin
        rcomp_calcode_g1_ovrd_ff <= 1'h0;
        rcomp_calsel_g1_ovrd_ff  <= 1'h0;
      end
    else if(rcomp_wbyte_15_8)
      begin
        rcomp_calcode_g1_ovrd_ff <= writedata[13];
        rcomp_calsel_g1_ovrd_ff  <= writedata[14];
      end
  end // block: rcomp_byte_15_8_register

always @(posedge clk or negedge reset_n)
  begin: rcomp_byte_23_16_register
    if(!reset_n)
      begin
        rcomp_calcode_g2_ff[6:0] <= 7'h0;
      end
    else if(rcomp_wbyte_23_16)
      begin
        rcomp_calcode_g2_ff[6:0] <= writedata[22:16];
      end
  end // block: rcomp_byte_23_16_register

always @(posedge clk or negedge reset_n)
  begin: rcomp_byte_31_24_register
    if(!reset_n)
      begin
        rcomp_calcode_g2_ovrd_ff <= 1'h0;
        rcomp_calsel_g2_ovrd_ff  <= 1'h0;
      end
    else if(rcomp_wbyte_31_24)
      begin
        rcomp_calcode_g2_ovrd_ff <= writedata[29];
        rcomp_calsel_g2_ovrd_ff  <= writedata[30];
      end
  end // block: rcomp_byte_31_24_register


assign rcomp_data[31:0] = { rcomp_cal_done_g2_sync,
                            rcomp_calsel_g2_ovrd_ff,
                            rcomp_calcode_g2_ovrd_ff,
                            6'h0,
                            rcomp_calcode_g2_ff[6:0],
                            rcomp_cal_done_g1_sync,
                            rcomp_calsel_g1_ovrd_ff,
                            rcomp_calcode_g1_ovrd_ff,
                            6'h0,
                            rcomp_calcode_g1_ff[6:0] };

//--------------------------
// AIBIO RCOMP2 register
//--------------------------
assign rcomp2_sel  = (address == RCOMP2_ADDR_OFF);
assign rcomp2_read = rcomp2_sel & read;

assign rcomp2_data[31:0] = { 17'h0,
                             rcomp_calcode_g2[6:0],
                             1'h0,
                             rcomp_calcode_g1[6:0] };

//--------------------------
// AIBIO NTL1 register
//--------------------------
assign ntl1_sel  = (address == NTL1_ADDR_OFF);
assign ntl1_read = ntl1_sel & read;

assign ntl1_wbyte_7_0   = write & ntl1_sel & byteenable[0];
assign ntl1_wbyte_15_8  = write & ntl1_sel & byteenable[1];
assign ntl1_wbyte_23_16 = write & ntl1_sel & byteenable[2];

always @(posedge clk or negedge reset_n)
  begin: ntl1_byte_7_0_register
    if(!reset_n)
      begin
        ntl1_pad_num_ff[6:0] <= 7'h0;
      end
    else if(ntl1_wbyte_7_0)
      begin
        ntl1_pad_num_ff[6:0] <= writedata[6:0];
      end
  end // block: ntl1_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: ntl1_byte_15_8_register
    if(!reset_n)
      begin
        ntl1_en_ff <= 1'b0;
      end
    else if(ntl1_wbyte_15_8)
      begin
        ntl1_en_ff <= writedata[15];
      end
  end // block: ntl1_byte_15_8_register


always @(posedge clk or negedge reset_n)
  begin: ntl1_byte_23_16_register
    if(!reset_n)
      begin
        ntl1_en_ovrd_ff         <= 1'b0;
        ntl1_txen_ovrd_ff       <= 1'b0;
        ntl1_rxen_ovrd_ff       <= 1'b0;
        ntl1_tx_deven_ovrd_ff   <= 1'b0;
        ntl1_tx_dodd_ovrd_ff    <= 1'b0;
        ntl1_done_ovrd_ff       <= 1'b0;
        ntl1_txen_async_ovrd_ff <= 1'b0;
        ntl1_rxen_async_ovrd_ff <= 1'b0;
      end
    else if(ntl1_wbyte_23_16)
      begin
        ntl1_en_ovrd_ff         <= writedata[16];
        ntl1_txen_ovrd_ff       <= writedata[17];
        ntl1_rxen_ovrd_ff       <= writedata[18];
        ntl1_tx_deven_ovrd_ff   <= writedata[19];
        ntl1_tx_dodd_ovrd_ff    <= writedata[20];
        ntl1_done_ovrd_ff       <= writedata[21];
        ntl1_txen_async_ovrd_ff <= writedata[22];
        ntl1_rxen_async_ovrd_ff <= writedata[23];
      end
  end // block: ntl1_byte_23_16_register

assign ntl1_data[31:0] = { ntl1_done_sync,
                           7'h0,
                           ntl1_rxen_async_ovrd_ff,
                           ntl1_txen_async_ovrd_ff,
                           ntl1_done_ovrd_ff,
                           ntl1_tx_dodd_ovrd_ff,
                           ntl1_tx_deven_ovrd_ff,
                           ntl1_rxen_ovrd_ff,
                           ntl1_txen_ovrd_ff,
                           ntl1_en_ovrd_ff,
                           ntl1_en_ff,
                           8'h0,
                           ntl1_pad_num_ff[6:0]  };

//--------------------------
// AIBIO NTL2 register
//--------------------------
assign ntl2_sel  = (address == NTL2_ADDR_OFF);
assign ntl2_read = ntl2_sel & read;

assign ntl2_wbyte_7_0   = write & ntl2_sel & byteenable[0];
assign ntl2_wbyte_15_8  = write & ntl2_sel & byteenable[1];

always @(posedge clk or negedge reset_n)
  begin: ntl2_byte_7_0_register
    if(!reset_n)
      begin
        ntl2_count_ff[7:0] <= 8'h0;
      end
    else if(ntl2_wbyte_7_0)
      begin
        ntl2_count_ff[7:0] <= writedata[7:0];
      end
  end // block: ntl2_byte_7_0_register

always @(posedge clk or negedge reset_n)
  begin: ntl2_byte_15_8register
    if(!reset_n)
      begin
        ntl2_count_ff[15:8] <= 8'h0;
      end
    else if(ntl2_wbyte_15_8)
      begin
        ntl2_count_ff[15:8] <= writedata[15:8];
      end
  end // block: ntl2_byte_15_8_register

assign ntl2_data[31:0] = { ntl2_cnt_val_sync[15:0],
                           ntl2_count_ff[15:0]      };

// Internal read data bus
assign rdata_comb[31:0] =
           (redund_0_read  ? redund_0[31:0]       : 32'h0) |
           (redund_1_read  ? redund_1[31:0]       : 32'h0) |
           (redund_2_read  ? redund_2[31:0]       : 32'h0) |
           (redund_3_read  ? redund_3[31:0]       : 32'h0) |
           (iocommon1_read ? iocommon1_data[31:0] : 32'h0) |
           (iocommon2_read ? iocommon2_data[31:0] : 32'h0) |
           (vrefcode_read  ? vrefcode_data[31:0]  : 32'h0) |
           (calvref_read   ? calvref_data[31:0]   : 32'h0) |
           (rx_dll1_read   ? rx_dll1_data[31:0]   : 32'h0) |
           (rx_dll2_read   ? rx_dll2_data[31:0]   : 32'h0) |
           (cdr_read       ? cdr_data[31:0]       : 32'h0) |
           (tx_dll1_read   ? tx_dll1_data[31:0]   : 32'h0) |
           (tx_dll2_read   ? tx_dll2_data[31:0]   : 32'h0) |
           (rxclk_cbb_read ? rxclk_cbb_data[31:0] : 32'h0) |
           (dcs1_read      ? dcs1_data[31:0]      : 32'h0) |
           (dcs2_read      ? dcs2_data[31:0]      : 32'h0) |
           (iotxrx1_read   ? iotxrx1_data[31:0]   : 32'h0) |
           (iotxrx2_read   ? iotxrx2_data[31:0]   : 32'h0) |
           (fsmdiv_read    ? fsmdiv_data[31:0]    : 32'h0) |
           (rcomp_read     ? rcomp_data[31:0]     : 32'h0) |
           (rcomp2_read    ? rcomp2_data[31:0]    : 32'h0) |
           (ntl1_read      ? ntl1_data[31:0]      : 32'h0) |
           (ntl2_read      ? ntl2_data[31:0]      : 32'h0);

//------------------------------------------------------------------------------
//            RX offset calibration clock divider logic
//------------------------------------------------------------------------------
// Clock divisions: 1,2,4,8,16,32 and 64

aib_bit_sync rxoff_cal_div_ack_sync_i
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (rxoff_cal_div_ld_ack),  // Input to be synchronized
   .data_out (rxoff_cal_div_ack_sync) // Synchronized output
   );

assign rxoff_cal_div1_sel  = (fsmdiv_rxoff_div_ff[2:0] == 3'b001);
assign rxoff_cal_div2_sel  = (fsmdiv_rxoff_div_ff[2:0] == 3'b010);
assign rxoff_cal_div4_sel  = (fsmdiv_rxoff_div_ff[2:0] == 3'b011);
assign rxoff_cal_div8_sel  = (fsmdiv_rxoff_div_ff[2:0] == 3'b100);
assign rxoff_cal_div16_sel = (fsmdiv_rxoff_div_ff[2:0] == 3'b101);
assign rxoff_cal_div32_sel = (fsmdiv_rxoff_div_ff[2:0] == 3'b110);
assign rxoff_cal_div64_sel = (fsmdiv_rxoff_div_ff[2:0] == 3'b111);


// Detects if CDC interface is busy
assign rxoff_cal_div_if_busy = rxoff_cal_div_ld_ff ^ rxoff_cal_div_ack_sync;

assign rxoff_cal_div_update = (~rxoff_cal_div_if_busy) &
                          ( (rxoff_cal_div1_sel  ^ rxoff_cal_div_1_ff ) |
                            (rxoff_cal_div2_sel  ^ rxoff_cal_div_2_ff ) |
                            (rxoff_cal_div4_sel  ^ rxoff_cal_div_4_ff ) |
                            (rxoff_cal_div8_sel  ^ rxoff_cal_div_8_ff ) |
                            (rxoff_cal_div16_sel ^ rxoff_cal_div_16_ff) |
                            (rxoff_cal_div32_sel ^ rxoff_cal_div_32_ff) |
                            (rxoff_cal_div64_sel ^ rxoff_cal_div_64_ff)   );

// Load register for RX offset calibration clock divider selection
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_ld_register
    if(!reset_n)
      rxoff_cal_div_ld_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_ld_ff <= ~rxoff_cal_div_ld_ff;
  end // block: rxoff_cal_div_ld_register

// RX offset calibration clock divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_1_register
    if(!reset_n)
      rxoff_cal_div_1_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_1_ff <= rxoff_cal_div1_sel;
  end // block: rxoff_cal_div_1_register

// RX offset calibration clock divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_2_register
    if(!reset_n)
      rxoff_cal_div_2_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_2_ff <= rxoff_cal_div2_sel;
  end // block: rxoff_cal_div_2_register

// RX offset calibration clock divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_4_register
    if(!reset_n)
      rxoff_cal_div_4_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_4_ff <= rxoff_cal_div4_sel;
  end // block: rxoff_cal_div_4_register

// RX offset calibration clock divided 8 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_8_register
    if(!reset_n)
      rxoff_cal_div_8_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_8_ff <= rxoff_cal_div8_sel;
  end // block: rxoff_cal_div_8_register

// RX offset calibration clock divided 16 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_16_register
    if(!reset_n)
      rxoff_cal_div_16_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_16_ff <= rxoff_cal_div16_sel;
  end // block: rxoff_cal_div_16_register

// RX offset calibration clock divided 32 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_32_register
    if(!reset_n)
      rxoff_cal_div_32_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_32_ff <= rxoff_cal_div32_sel;
  end // block: rxoff_cal_div_32_register

// RX offset calibration clock divided 64 selection register
always @(posedge clk or negedge reset_n)
  begin: rxoff_cal_div_64_register
    if(!reset_n)
      rxoff_cal_div_64_ff <= 1'b0;
    else if(rxoff_cal_div_update) // Update selection
      rxoff_cal_div_64_ff <= rxoff_cal_div64_sel;
  end // block: rxoff_cal_div_64_register
  
//------------------------------------------------------------------------------
//                        Sys clock divider  logic
//------------------------------------------------------------------------------
// Clock divisions: 1,2,4,8 and 16

aib_bit_sync sysclk_div_ack_sync_i
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (sysclk_div_ld_ack),  // Input to be synchronized
   .data_out (sysclk_div_ack_sync) // Synchronized output
   );

assign sysclk_div1_sel  = (fsmdiv_sys_div_ff[2:0] == 3'b001);
assign sysclk_div2_sel  = (fsmdiv_sys_div_ff[2:0] == 3'b010);
assign sysclk_div4_sel  = (fsmdiv_sys_div_ff[2:0] == 3'b011);
assign sysclk_div8_sel  = (fsmdiv_sys_div_ff[2:0] == 3'b100);
assign sysclk_div16_sel = (fsmdiv_sys_div_ff[2:0] == 3'b101);

// Detects if CDC interface is busy
assign sysclk_div_if_busy = sysclk_div_ld_ff ^ sysclk_div_ack_sync;

assign sysclk_div_update = (~sysclk_div_if_busy) &
                          ( (sysclk_div1_sel  ^ sysclk_div_1_ff ) |
                            (sysclk_div2_sel  ^ sysclk_div_2_ff ) |
                            (sysclk_div4_sel  ^ sysclk_div_4_ff ) |
                            (sysclk_div8_sel  ^ sysclk_div_8_ff ) |
                            (sysclk_div16_sel ^ sysclk_div_16_ff)   );

// Load register for Sys clock divider selection
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_ld_register
    if(!reset_n)
      sysclk_div_ld_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_ld_ff <= ~sysclk_div_ld_ff;
  end // block: sysclk_div_ld_register

// Sys clock divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_1_register
    if(!reset_n)
      sysclk_div_1_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_1_ff <= sysclk_div1_sel;
  end // block: sysclk_div_1_register

// Sys clock divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_2_register
    if(!reset_n)
      sysclk_div_2_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_2_ff <= sysclk_div2_sel;
  end // block: sysclk_div_2_register

// Sys clock divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_4_register
    if(!reset_n)
      sysclk_div_4_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_4_ff <= sysclk_div4_sel;
  end // block: sysclk_div_4_register

// Sys clock divided 8 selection register
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_8_register
    if(!reset_n)
      sysclk_div_8_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_8_ff <= sysclk_div8_sel;
  end // block: sysclk_div_8_register

// Sys clock divided 16 selection register
always @(posedge clk or negedge reset_n)
  begin: sysclk_div_16_register
    if(!reset_n)
      sysclk_div_16_ff <= 1'b0;
    else if(sysclk_div_update) // Update selection
      sysclk_div_16_ff <= sysclk_div16_sel;
  end // block: sysclk_div_16_register

//------------------------------------------------------------------------------
//                 Gen1 RCOMP clock divider 
//------------------------------------------------------------------------------
// Clock divisions: 1,2,4,8, 16 and 32

aib_bit_sync gen1rcomp_div_ack_sync_i
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (gen1rcomp_div_ld_ack),  // Input to be synchronized
   .data_out (gen1rcomp_div_ack_sync) // Synchronized output
   );

assign gen1rcomp_div1_sel  = (fsmdiv_rcompg1_div_ff[2:0] == 3'b001);
assign gen1rcomp_div2_sel  = (fsmdiv_rcompg1_div_ff[2:0] == 3'b010);
assign gen1rcomp_div4_sel  = (fsmdiv_rcompg1_div_ff[2:0] == 3'b011);
assign gen1rcomp_div8_sel  = (fsmdiv_rcompg1_div_ff[2:0] == 3'b100);
assign gen1rcomp_div16_sel = (fsmdiv_rcompg1_div_ff[2:0] == 3'b101);
assign gen1rcomp_div32_sel = (fsmdiv_rcompg1_div_ff[2:0] == 3'b110);

// Detects if CDC interface is busy
assign gen1rcomp_div_if_busy = gen1rcomp_div_ld_ff ^ gen1rcomp_div_ack_sync;

assign gen1rcomp_div_update = (~gen1rcomp_div_if_busy) &
                          ( (gen1rcomp_div1_sel  ^ gen1rcomp_div_1_ff ) |
                            (gen1rcomp_div2_sel  ^ gen1rcomp_div_2_ff ) |
                            (gen1rcomp_div4_sel  ^ gen1rcomp_div_4_ff ) |
                            (gen1rcomp_div8_sel  ^ gen1rcomp_div_8_ff ) |
                            (gen1rcomp_div16_sel ^ gen1rcomp_div_16_ff) |
                            (gen1rcomp_div32_sel ^ gen1rcomp_div_32_ff)   );

// Load register for GEN1 RCOMP divider selection
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_ld_register
    if(!reset_n)
      gen1rcomp_div_ld_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_ld_ff <= ~gen1rcomp_div_ld_ff;
  end // block: gen1rcomp_div_ld_register

// GEN1 RCOMP divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_1_register
    if(!reset_n)
      gen1rcomp_div_1_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_1_ff <= gen1rcomp_div1_sel;
  end // block: gen1rcomp_div_1_register

// GEN1 RCOMP divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_2_register
    if(!reset_n)
      gen1rcomp_div_2_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_2_ff <= gen1rcomp_div2_sel;
  end // block: gen1rcomp_div_2_register

// GEN1 RCOMP divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_4_register
    if(!reset_n)
      gen1rcomp_div_4_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_4_ff <= gen1rcomp_div4_sel;
  end // block: gen1rcomp_div_4_register

// GEN1 RCOMP divided 8 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_8_register
    if(!reset_n)
      gen1rcomp_div_8_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_8_ff <= gen1rcomp_div8_sel;
  end // block: gen1rcomp_div_8_register

// GEN1 RCOMP divided 16 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_16_register
    if(!reset_n)
      gen1rcomp_div_16_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_16_ff <= gen1rcomp_div16_sel;
  end // block: gen1rcomp_div_16_register

// GEN1 RCOMP divided 32 selection register
always @(posedge clk or negedge reset_n)
  begin: gen1rcomp_div_32_register
    if(!reset_n)
      gen1rcomp_div_32_ff <= 1'b0;
    else if(gen1rcomp_div_update) // Update selection
      gen1rcomp_div_32_ff <= gen1rcomp_div32_sel;
  end // block: gen1rcomp_div_32_register

//------------------------------------------------------------------------------
// Gen2 RCOMP clock divider  
//------------------------------------------------------------------------------
// Clock divisions: 1,2,4,8, 16 and 32

aib_bit_sync gen2rcomp_div_ack_sync_i
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (gen2rcomp_div_ld_ack),  // Input to be synchronized
   .data_out (gen2rcomp_div_ack_sync) // Synchronized output
   );

assign gen2rcomp_div1_sel  = (fsmdiv_rcompg2_div_ff[2:0] == 3'b001);
assign gen2rcomp_div2_sel  = (fsmdiv_rcompg2_div_ff[2:0] == 3'b010);
assign gen2rcomp_div4_sel  = (fsmdiv_rcompg2_div_ff[2:0] == 3'b011);
assign gen2rcomp_div8_sel  = (fsmdiv_rcompg2_div_ff[2:0] == 3'b100);
assign gen2rcomp_div16_sel = (fsmdiv_rcompg2_div_ff[2:0] == 3'b101);
assign gen2rcomp_div32_sel = (fsmdiv_rcompg2_div_ff[2:0] == 3'b110);

// Detects if CDC interface is busy
assign gen2rcomp_div_if_busy = gen2rcomp_div_ld_ff ^ gen2rcomp_div_ack_sync;

assign gen2rcomp_div_update = (~gen2rcomp_div_if_busy) &
                          ( (gen2rcomp_div1_sel  ^ gen2rcomp_div_1_ff ) |
                            (gen2rcomp_div2_sel  ^ gen2rcomp_div_2_ff ) |
                            (gen2rcomp_div4_sel  ^ gen2rcomp_div_4_ff ) |
                            (gen2rcomp_div8_sel  ^ gen2rcomp_div_8_ff ) |
                            (gen2rcomp_div16_sel ^ gen2rcomp_div_16_ff) |
                            (gen2rcomp_div32_sel ^ gen2rcomp_div_32_ff)   );

// Load register for GEN2 RCOMP divider selection
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_ld_register
    if(!reset_n)
      gen2rcomp_div_ld_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_ld_ff <= ~gen2rcomp_div_ld_ff;
  end // block: gen2rcomp_div_ld_register

// GEN2 RCOMP divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_1_register
    if(!reset_n)
      gen2rcomp_div_1_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_1_ff <= gen2rcomp_div1_sel;
  end // block: gen2rcomp_div_1_register

// GEN2 RCOMP divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_2_register
    if(!reset_n)
      gen2rcomp_div_2_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_2_ff <= gen2rcomp_div2_sel;
  end // block: gen2rcomp_div_2_register

// GEN2 RCOMP divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_4_register
    if(!reset_n)
      gen2rcomp_div_4_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_4_ff <= gen2rcomp_div4_sel;
  end // block: gen2rcomp_div_4_register

// GEN2 RCOMP divided 8 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_8_register
    if(!reset_n)
      gen2rcomp_div_8_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_8_ff <= gen2rcomp_div8_sel;
  end // block: gen2rcomp_div_8_register

// GEN2 RCOMP divided 16 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_16_register
    if(!reset_n)
      gen2rcomp_div_16_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_16_ff <= gen2rcomp_div16_sel;
  end // block: gen2rcomp_div_16_register

// GEN2 RCOMP divided 32 selection register
always @(posedge clk or negedge reset_n)
  begin: gen2rcomp_div_32_register
    if(!reset_n)
      gen2rcomp_div_32_ff <= 1'b0;
    else if(gen2rcomp_div_update) // Update selection
      gen2rcomp_div_32_ff <= gen2rcomp_div32_sel;
  end // block: gen2rcomp_div_32_register

//------------------------------------------------------------------------------
// DCS clock divider  
//------------------------------------------------------------------------------
// Clock divisions: 1,2,4,8,16,32,64,128 and 256

aib_bit_sync dcs_div_ack_sync_i
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (dcs_div_ld_ack),  // Input to be synchronized
   .data_out (dcs_div_ack_sync) // Synchronized output
   );

assign dcs_div1_sel   = (fsmdiv_dcs_div_ff[3:0] == 4'b0001);
assign dcs_div2_sel   = (fsmdiv_dcs_div_ff[3:0] == 4'b0010);
assign dcs_div4_sel   = (fsmdiv_dcs_div_ff[3:0] == 4'b0011);
assign dcs_div8_sel   = (fsmdiv_dcs_div_ff[3:0] == 4'b0100);
assign dcs_div16_sel  = (fsmdiv_dcs_div_ff[3:0] == 4'b0101);
assign dcs_div32_sel  = (fsmdiv_dcs_div_ff[3:0] == 4'b0110);
assign dcs_div64_sel  = (fsmdiv_dcs_div_ff[3:0] == 4'b0111);
assign dcs_div128_sel = (fsmdiv_dcs_div_ff[3:0] == 4'b1000);
assign dcs_div256_sel = (fsmdiv_dcs_div_ff[3:0] == 4'b1001);

// Detects if CDC interface is busy
assign dcs_div_if_busy = dcs_div_ld_ff ^ dcs_div_ack_sync;

assign dcs_div_update = (~dcs_div_if_busy) &
                     ( (dcs_div1_sel   ^ dcs_div_1_ff )  | 
                       (dcs_div2_sel   ^ dcs_div_2_ff )  | 
                       (dcs_div4_sel   ^ dcs_div_4_ff )  | 
                       (dcs_div8_sel   ^ dcs_div_8_ff )  | 
                       (dcs_div16_sel  ^ dcs_div_16_ff)  | 
                       (dcs_div32_sel  ^ dcs_div_32_ff)  |
                       (dcs_div64_sel  ^ dcs_div_64_ff)  |
                       (dcs_div128_sel ^ dcs_div_128_ff) |
                       (dcs_div256_sel ^ dcs_div_256_ff)  );

// Load register for DCS divider selection
always @(posedge clk or negedge reset_n)
  begin: dcs_div_ld_register
    if(!reset_n)
      dcs_div_ld_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_ld_ff <= ~dcs_div_ld_ff;
  end // block: dcs_div_ld_register

// DCS  divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_1_register
    if(!reset_n)
      dcs_div_1_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_1_ff <= dcs_div1_sel;
  end // block: dcs_div_1_register

// DCS  divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_2_register
    if(!reset_n)
      dcs_div_2_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_2_ff <= dcs_div2_sel;
  end // block: dcs_div_2_register

// DCS  divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_4_register
    if(!reset_n)
      dcs_div_4_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_4_ff <= dcs_div4_sel;
  end // block: dcs_div_4_register

// DCS divided 8 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_8_register
    if(!reset_n)
      dcs_div_8_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_8_ff <= dcs_div8_sel;
  end // block: dcs_div_8_register

// DCS divided 16 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_16_register
    if(!reset_n)
      dcs_div_16_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_16_ff <= dcs_div16_sel;
  end // block: dcs_div_16_register

// DCS divided 32 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_32_register
    if(!reset_n)
      dcs_div_32_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_32_ff <= dcs_div32_sel;
  end // block: dcs_div_32_register

// DCS divided 64 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_64_register
    if(!reset_n)
      dcs_div_64_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_64_ff <= dcs_div64_sel;
  end // block: dcs_div_64_register

// DCS divided 128 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_128_register
    if(!reset_n)
      dcs_div_128_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_128_ff <= dcs_div128_sel;
  end // block: dcs_div_128_register

// DCS divided 256 selection register
always @(posedge clk or negedge reset_n)
  begin: dcs_div_256_register
    if(!reset_n)
      dcs_div_256_ff <= 1'b0;
    else if(dcs_div_update) // Update selection
      dcs_div_256_ff <= dcs_div256_sel;
  end // block: dcs_div_256_register
  
endmodule // aib_avalon_io_regs
