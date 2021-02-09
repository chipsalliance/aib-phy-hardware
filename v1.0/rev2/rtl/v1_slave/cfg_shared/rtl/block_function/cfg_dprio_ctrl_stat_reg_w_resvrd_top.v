// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//*****************************************************************
// Description:
//
//*****************************************************************
module cfg_dprio_ctrl_stat_reg_w_resvrd_top 
#(
   parameter DATA_WIDTH             = 16,  // Data width
   parameter ADDR_WIDTH             = 11,  // Address width
   parameter NUM_TX_CTRL_REGS       = 5,   // Number of n-bit TX control registers
   parameter NUM_TX_RSVD_CTRL_REGS  = 5,   // Number of n-bit TX Reserved control registers
   parameter NUM_RX_CTRL_REGS       = 10,  // Number of n-bit RX control registers
   parameter NUM_RX_RSVD_CTRL_REGS  = 10,  // Number of n-bit RX Reserved control registers
   parameter NUM_CM_CTRL_REGS       = 10,  // Number of n-bit Common control registers
   parameter NUM_CM_RSVD_CTRL_REGS  = 10,  // Number of n-bit Common Reserved control registers
   parameter NUM_EXTRA_CSR_REG      = 1,   // Number of extra 16-bit register for CSR
   parameter NUM_STATUS_REGS        = 5,   // Number of n-bit status registers
   parameter NUM_STATUS_RSVD_REGS   = 5,   // Number of n-bit Reserved status registers
   parameter CSR_OUT_NEG_FF_EN      = 0,   // Enable negative FF on csr_out   
   parameter BYPASS_STAT_SYNC       = 0,   // Parameter to bypass the Synchronization SM in case of individual status bits      
   parameter USE_AVMM_INTF          = 0,   // Specify if AVMM Interface is used.  Bypass clock selection if using AVMM Interface
   parameter FORCE_INTER_SEL_CVP_EN = 0,   // 1: Enable logic to force interface_sel in CVP mode   
   parameter NUM_ATPG_SCAN_CHAIN    = 1,   // Number of ATPG scan chains
   parameter DIS_CVP_CLK_FREQ_MHZ    = 250, // Dis cvp clock freq in MHz
   parameter STAT_REG_CLK_FREQ_MHZ   = 250  // Status register clock freq in MHz

 )
( 
// Scan interface
input  wire                                     scan_mode_n,     // active low scan mode enable
input  wire                                     scan_shift_n,    // active low scan shift

// CSR interface
input  wire                                     csr_clk,         // CSR clock
input  wire                                     csr_in,          // Serial CSR input
input  wire                                     csr_en,          // CSR enable
input  wire [NUM_ATPG_SCAN_CHAIN-1:0]           atpg_scan_in,    // ATPG scan input

output wire [NUM_ATPG_SCAN_CHAIN-1:0]           atpg_scan_out,   // ATPG scan output
output wire                                     csr_out,         // Serial CSR output
output wire [DATA_WIDTH*NUM_EXTRA_CSR_REG-1:0]  extra_csr,       // Extra CSR output
// DPRIO interface
input  wire                                     dprio_rst_n,     // DPRIO reset
input  wire                                     dprio_clk,       // DPRIO clock
input  wire                                     write,           // write enable input
input  wire                                     read,            // read enable input
input  wire [(DATA_WIDTH/8)-1:0]                byte_en,         // Byte enable
input  wire [ADDR_WIDTH-1:0]                    reg_addr,        // address input
input  wire [DATA_WIDTH-1:0]                    writedata,       // write data input
input  wire                                     csr_test_mode,   // CSR test mode from CSR test mux
input  wire                                     mdio_dis,        // 1'b1=output CRAM
                                                                 // 1'b0=output MDIO control register
input  wire                                     pma_csr_test_dis,// Disable PMA CSR test

output wire [DATA_WIDTH-1:0]                    readdata,        // Read data to route back to central Avalon-MM
output wire                                     block_select,    // Signal to tell the central interface to select its readdata

// control and status interface for custom logic
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0]  user_datain, // status from custom logic
input  wire [NUM_STATUS_REGS-1:0]             write_en_ack,    // write data acknowlege from user logic

output wire [NUM_STATUS_REGS-1:0]             write_en,        // write data enable to user logic
output wire [DATA_WIDTH*NUM_TX_CTRL_REGS-1:0] tx_user_dataout, // CRAM connecting to custom TX logic
output wire [DATA_WIDTH*NUM_RX_CTRL_REGS-1:0] rx_user_dataout, // CRAM connecting to custom RX logic
output wire [DATA_WIDTH*NUM_CM_CTRL_REGS-1:0] cm_user_dataout  // CRAM connecting to custom Common logic
);

localparam TOTAL_NUM_CTRL_REGS = NUM_TX_CTRL_REGS + NUM_RX_CTRL_REGS + NUM_CM_CTRL_REGS;

wire        [DATA_WIDTH*NUM_STATUS_REGS-1:0]     user_datain_int;
wire        [NUM_STATUS_REGS-1:0]                write_en_ack_int;    // write data acknowlege from user logic
wire                                             csr_int;             // CSR in
wire        [ADDR_WIDTH-1:0]                     base_addr;           // base address value from CSR
wire        mdio_dis_int;
wire        mdio_dis_int_1;
wire        power_iso_en_csr_ctrl;
wire        dprio_broadcast_en_csr_ctrl;
wire        force_inter_sel_csr_ctrl;
wire        cvp_inter_sel_csr_ctrl;
wire        hold_csr;
wire        gated_cram;
wire        dprio_clk_int;
wire        dprio_clk_int_sel;
wire        interface_sel_int;
wire [NUM_ATPG_SCAN_CHAIN-1:0]                     csr_chain_out_int;   // ATPG scan output
wire [NUM_ATPG_SCAN_CHAIN-1:0]                     csr_chain_out;       // ATPG scan output
wire [NUM_ATPG_SCAN_CHAIN-1:0]                     csr_chain_in;        // ATPG scan input
wire        extra_csr_in;
wire        extra_csr_out;
wire        csr_clk_int;
wire        csr_clk_int_sel;

// Internet interface selection
assign interface_sel_int = mdio_dis_int | csr_test_mode | (~csr_en);

// Clock selection
assign dprio_clk_int_sel = (scan_mode_n == 1'b0)           ? dprio_clk: 
                           (interface_sel_int == 1'b1)     ? csr_clk : dprio_clk;

assign csr_clk_int_sel   = (scan_mode_n == 1'b0)           ? dprio_clk : csr_clk;

// Bypass clock selecton if using common AVMM Interface.  Simlar clock selection existed there
assign dprio_clk_int     = (USE_AVMM_INTF == 1) ? dprio_clk : dprio_clk_int_sel;
assign csr_clk_int       = (USE_AVMM_INTF == 1) ? csr_clk : csr_clk_int_sel;

// Control signal to hold CSR value
assign hold_csr = csr_en & (~csr_test_mode);

// Control signal to gate CRAM output
assign gated_cram = csr_en & scan_shift_n;

// Base address for DPRIO 
assign base_addr  = extra_csr[ADDR_WIDTH-1:0];

// Extra CSR control for power ISO, broadcasting, and forcing mdio_dis
assign power_iso_en_csr_ctrl        = extra_csr[15];
assign dprio_broadcast_en_csr_ctrl  = extra_csr[14];
assign force_inter_sel_csr_ctrl     = extra_csr[13];
assign cvp_inter_sel_csr_ctrl       = extra_csr[12];

// Forcing mdio_dis using extra CSR
assign mdio_dis_int = (force_inter_sel_csr_ctrl == 1'b1) ? 1'b1 : mdio_dis_int_1;

// Power isolation for user_datain and write_en_ack
assign user_datain_int = (csr_en && !power_iso_en_csr_ctrl) ? user_datain  : {(DATA_WIDTH*NUM_STATUS_REGS){1'b0}};
assign write_en_ack_int= (csr_en && !power_iso_en_csr_ctrl) ? write_en_ack : {NUM_STATUS_REGS{1'b0}};

generate
  if (FORCE_INTER_SEL_CVP_EN == 1)
    begin: ENABLE_CVP_FORCE_LOGIC
    // CVP enable to control the mdio_dis
    cfg_dprio_dis_ctrl_cvp
#(
   .CLK_FREQ_MHZ(DIS_CVP_CLK_FREQ_MHZ)
 )
    cfg_dprio_dis_ctrl_cvp
    (
     .rst_n        (csr_en),                 // reset
     .clk          (dprio_clk_int),          // clock
     .dprio_dis_in (mdio_dis),               // dprio_dis in
     .csr_cvp_en   (cvp_inter_sel_csr_ctrl),  // CSR enable
     .dprio_dis_out(mdio_dis_int_1)          // dprio_dis out
    );
    end
  else
    begin: DISABLE_CVP_FORCE_LOGIC
      assign mdio_dis_int_1 = mdio_dis;
    end
endgenerate

// DPRIO register module
cfg_dprio_ctrl_stat_reg_w_resvrd_chnl 
#(
  .DATA_WIDTH             (DATA_WIDTH           ) ,  // Data width
  .ADDR_WIDTH             (ADDR_WIDTH           ) ,  // Address width
  .NUM_TX_CTRL_REGS       (NUM_TX_CTRL_REGS     ) ,  // Number of n-bit TX control registers
  .NUM_TX_RSVD_CTRL_REGS  (NUM_TX_RSVD_CTRL_REGS) ,  // Number of n-bit TX Reserved control registers
  .NUM_RX_CTRL_REGS       (NUM_RX_CTRL_REGS     ) ,  // Number of n-bit RX control registers
  .NUM_RX_RSVD_CTRL_REGS  (NUM_RX_RSVD_CTRL_REGS) ,  // Number of n-bit RX Reserved control registers
  .NUM_CM_CTRL_REGS       (NUM_CM_CTRL_REGS     ) ,  // Number of n-bit Common control registers
  .NUM_CM_RSVD_CTRL_REGS  (NUM_CM_RSVD_CTRL_REGS) ,  // Number of n-bit Common Reserved control registers
  .TOTAL_NUM_CTRL_REGS    (TOTAL_NUM_CTRL_REGS  ) ,  // Total number of real n-bit control registers
  .NUM_STATUS_REGS        (NUM_STATUS_REGS      ) ,  // Number of n-bit status registers
  .NUM_STATUS_RSVD_REGS   (NUM_STATUS_RSVD_REGS ) ,  // Number of n-bit Reserved status registers
  .BYPASS_STAT_SYNC       (BYPASS_STAT_SYNC     ) ,  // Parameter to bypass the Synchronization SM in case of individual status bits  
  .NUM_ATPG_SCAN_CHAIN    (NUM_ATPG_SCAN_CHAIN  ) ,  // Number of ATPG scan chains
  .CLK_FREQ_MHZ           (STAT_REG_CLK_FREQ_MHZ)
 ) ctrl_stat_reg_chnl
(
 .scan_mode_n(scan_mode_n),                   // active low scan mode enable
 .scan_shift_n(scan_shift_n),                 // active low scan shift
 .rst_n(dprio_rst_n),                         // reset
 .clk(dprio_clk_int),                         // clock
 .write(write),                               // write enable input
 .read(read),                                 // read enable input
 .reg_addr(reg_addr),                         // address input
 .base_addr(base_addr),                       // base address value from CSR
 .writedata(writedata),                       // write data input
 //.csr_in(csr_in),                             // CSR in
 .hold_csr(hold_csr),                         // Hold CSR value
 .gated_cram(gated_cram),                     // Gating CRAM output
 .dprio_sel(interface_sel_int),               // 1'b1=select CSR interface
                                              // 1'b0=select AVMM interface
 .pma_csr_test_dis(pma_csr_test_dis),         // Disable PMA CSR test                                              
 .byte_en(byte_en),                           // Byte enable
 .broadcast_en(dprio_broadcast_en_csr_ctrl),  // Broadcast enable (controlled by extra CSR bit)
 .user_datain(user_datain_int),               // status from custom logic
 .write_en_ack(write_en_ack_int),             // write data acknowlege from user logic
 .csr_chain_in(csr_chain_in),                 // ATPG scan input
 .csr_chain_out(csr_chain_out_int),           // ATPG scan output
 .write_en(write_en),                         // write data enable to user logic
 .readdata(readdata),                         // Read data to route back to central Avalon-MM
 .tx_user_dataout(tx_user_dataout),           // CRAM connecting to custom TX logic
 .rx_user_dataout(rx_user_dataout),           // CRAM connecting to custom RX logic
 .cm_user_dataout(cm_user_dataout),           // CRAM connecting to custom Common logic
 //.csr_out(csr_int),                           // serial CSR output
 .block_select(block_select)                  // Block select
);

// CSR register module
cfg_dprio_csr_reg_nregs 
#(
   .DATA_WIDTH(DATA_WIDTH),                 // Data width
   .NUM_EXTRA_CSR_REG(NUM_EXTRA_CSR_REG),   // Number of extra 16-bit register for CSR
   .CSR_OUT_NEG_FF_EN(CSR_OUT_NEG_FF_EN)    // Enable negative FF on csr_out
 ) csr_reg_nregs
( 
 .clk(csr_clk_int),           // clock
 .csr_in(extra_csr_in),       // serial CSR in
 .csr_en(csr_en),             // CSR enable
 .scan_shift_n(scan_shift_n), // active low scan shift
 
 .csr_reg(extra_csr),         // CRAM connecting to custom logic
 .csr_out(extra_csr_out)      // serial CSR output
);

// Connect extra CSR regs to the ATPG chain
generate
  assign extra_csr_in     = csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-1];
  assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-1] = extra_csr_out;
  if (NUM_ATPG_SCAN_CHAIN > 1)
    begin: MORE_THAN_ONE_ATPG_CHAIN
      assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-2:0] = csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-2:0];
    end
endgenerate

// atpg_scan_in/out, csr_out connection
assign atpg_scan_out = csr_chain_out;
assign csr_out = atpg_scan_out[NUM_ATPG_SCAN_CHAIN-1];

generate
  genvar i;
  assign csr_chain_in[0] = (scan_mode_n == 1'b1) ? csr_in : atpg_scan_in[0];
  for (i=1; i<NUM_ATPG_SCAN_CHAIN; i=i+1)
    begin: CSR_CHAIN_IN_CON
      assign csr_chain_in[i] = (scan_mode_n == 1'b1) ? atpg_scan_out[i-1] : atpg_scan_in[i];
    end
endgenerate

endmodule
