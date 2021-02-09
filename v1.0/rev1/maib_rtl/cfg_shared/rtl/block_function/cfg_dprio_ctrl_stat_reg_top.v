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
module cfg_dprio_ctrl_stat_reg_top 
#(
   parameter BINDEX                  = 0,   // Base index
   parameter SEGMENT                 = 0,   // CSR segment
   parameter DATA_WIDTH              = 16,  // Data width
   parameter ADDR_WIDTH              = 10,  // Address width
   parameter NUM_CTRL_REGS           = 20,  // Number of n-bit control registers
   parameter NUM_EXTRA_CSR_REG       = 1,   // Number of extra 16-bit register for CSR
   parameter NUM_STATUS_REGS         = 5,   // Number of n-bit status registers
   parameter CSR_OUT_NEG_FF_EN       = 0,   // Enable negative FF on csr_out   
   parameter BYPASS_STAT_SYNC        = 0,   // Parameter to bypass the Synchronization SM in case of individual status bits
   parameter USE_AVMM_INTF           = 0,   // Specify if AVMM Interface is used.  Bypass clock selection if using AVMM Interface.
   parameter FORCE_INTER_SEL_CVP_EN  = 0,   // 1: Enable logic to force interface_sel in CVP mode
   parameter NUM_ATPG_SCAN_CHAIN     = 1,   // Number of ATPG scan chains
   parameter NUM_CSR_ATPG_SCAN_CHAIN = 0,   // Set this to 2 to enable 2 separate scan chain for CSR;
                                            // ELSE, SET THIS TO 0 to connect the last csr chain from DPRIO to CSR.
                                            // DEFAULT IS 0, REUSE NF DESIGN!
   parameter DIS_CVP_CLK_FREQ_MHZ    = 250, // Dis cvp clock freq in MHz
   parameter STAT_REG_CLK_FREQ_MHZ   = 250, // Status register clock freq in MHz
   parameter SECTOR_ROW              = 0,
   parameter SECTOR_COL              = 0,
   parameter DIS_CVP_TOGGLE_TYPE     = 1,
   parameter DIS_CVP_VID             = 1,
   parameter STAT_REG_TOGGLE_TYPE     = 1,
   parameter STAT_REG_VID             = 1
 )
( 
// Scan interface
input  wire                                     scan_mode_n,                      // active low scan mode enable
input  wire                                     scan_shift_n,                     // active low scan shift

// CSR interface
input  wire                                     csr_clk,           // CSR clock
input  wire                                     csr_in,            // Serial CSR input
input  wire                                     csr_en,            // CSR enable
//input  wire [NUM_ATPG_SCAN_CHAIN-1:0]           atpg_scan_in,      // ATPG scan input
input  wire [NUM_ATPG_SCAN_CHAIN + NUM_CSR_ATPG_SCAN_CHAIN - 1 : 0]     atpg_scan_in,      // ATPG scan input

//output wire [NUM_ATPG_SCAN_CHAIN-1:0]           atpg_scan_out,     // ATPG scan output
output wire [NUM_ATPG_SCAN_CHAIN + NUM_CSR_ATPG_SCAN_CHAIN - 1 : 0]     atpg_scan_out,     // ATPG scan output

output wire                                     csr_out,           // Serial CSR output
output wire [DATA_WIDTH*NUM_EXTRA_CSR_REG-1:0]  extra_csr,         // Extra CSR output
                                                                   // Only used bits not currently used internally (extra_csr[15:0])
// DPRIO interface
input  wire                                     dprio_rst_n,       // DPRIO reset
input  wire                                     dprio_clk,         // DPRIO clock
input  wire                                     write,             // write enable input
input  wire                                     read,              // read enable input
input  wire [(DATA_WIDTH/8)-1:0]                byte_en,           // Byte enable
input  wire [ADDR_WIDTH-1:0]                    reg_addr,          // address input
input  wire [DATA_WIDTH-1:0]                    writedata,         // write data input
input  wire                                     csr_test_mode,     // CSR test mode from CSR test mux
input  wire                                     mdio_dis,          // 1'b1=output CRAM
                                                                   // 1'b0=output MDIO control register
input  wire                                     pma_csr_test_dis,  // Disable PMA CSR test

output wire [DATA_WIDTH-1:0]                    readdata,          // Read data to route back to central Avalon-MM
output wire                                     block_select,      // Signal to tell the central interface to select its readdata

// control and status interface for custom logic
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0]    user_datain,       // status from custom logic
input  wire [NUM_STATUS_REGS-1:0]               write_en_ack,      // write data acknowlege from user logic
 
output wire [NUM_STATUS_REGS-1:0]               write_en,          // write data enable to user logic
output wire [DATA_WIDTH*NUM_CTRL_REGS-1:0]      user_dataout       // CRAM connecting to custom logic
);

localparam TOTAL_ATPG_SCAN_CHAIN   = NUM_ATPG_SCAN_CHAIN + NUM_CSR_ATPG_SCAN_CHAIN;
localparam NUM_CSR_REG_PER_CHAIN   = NUM_EXTRA_CSR_REG / NUM_CSR_ATPG_SCAN_CHAIN;
localparam TOTAL_CSR_REG_PER_CHAIN = NUM_CSR_REG_PER_CHAIN * DATA_WIDTH;

wire        [DATA_WIDTH*NUM_STATUS_REGS-1:0]       user_datain_int;
wire        [NUM_STATUS_REGS-1:0]                  write_en_ack_int;    // write data acknowlege from user logic
wire                                               csr_int;             // CSR in
wire        [ADDR_WIDTH-1:0]                       base_addr;           // base address value from CSR
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
wire        [NUM_ATPG_SCAN_CHAIN - 1 : 0]          csr_chain_out_int;   // ATPG scan output
wire        [TOTAL_ATPG_SCAN_CHAIN - 1 : 0]        csr_chain_out;       // ATPG scan output
wire        [TOTAL_ATPG_SCAN_CHAIN - 1 : 0]        csr_chain_in;        // ATPG scan input
wire                                               extra_csr_in;
wire                                               extra_csr_out;
wire        csr_clk_int;
wire        csr_clk_int_sel;

// Internet interface selection
assign interface_sel_int = mdio_dis_int | csr_test_mode | (~csr_en);

// Clock selection
//assign dprio_clk_int_sel = (scan_mode_n == 1'b0)           ? dprio_clk: 
//                           (interface_sel_int == 1'b1)     ? csr_clk : dprio_clk;
  cfg_cmn_clk_mux dprio_clk_mux (
    .clk1    (csr_clk),          // Select this clock when sel == 1'b1
    .clk2    (dprio_clk),        // Select this clock when sel == 1'b0
    .sel     (scan_mode_n & interface_sel_int),
    .clk_out (dprio_clk_int_sel)
  );

//assign csr_clk_int_sel   = (scan_mode_n == 1'b0)           ? dprio_clk : csr_clk;
  cfg_cmn_clk_mux csr_clk_mux (
    .clk1    (csr_clk),          // Select this clock when sel == 1'b1
    .clk2    (dprio_clk),        // Select this clock when sel == 1'b0
    .sel     (scan_mode_n),
    .clk_out (csr_clk_int_sel)
  );

// Bypass clock selecton if using common AVMM Interface.  Simlar clock selection existed there
assign dprio_clk_int     = (USE_AVMM_INTF == 1) ? dprio_clk : dprio_clk_int_sel;
assign csr_clk_int       = (USE_AVMM_INTF == 1) ? csr_clk : csr_clk_int_sel;


// Control signal to hold CSR value
assign hold_csr = csr_en & (~csr_test_mode);

// Control signal to gate CRAM output
assign gated_cram = csr_en & scan_shift_n;

// Base address for DPRIO 
assign base_addr  = extra_csr[ADDR_WIDTH-1:0];

// Extra CSR control for power ISO and broadcasting
assign power_iso_en_csr_ctrl       = extra_csr[15];
assign dprio_broadcast_en_csr_ctrl = extra_csr[14];
assign force_inter_sel_csr_ctrl    = extra_csr[13];
assign cvp_inter_sel_csr_ctrl      = extra_csr[12];

// Forcing mdio_dis using extra CSR
assign mdio_dis_int = (force_inter_sel_csr_ctrl == 1'b1) ? 1'b1 : mdio_dis_int_1;

// Power isolation for user_datain
assign user_datain_int = (csr_en && !power_iso_en_csr_ctrl) ? user_datain  : {(DATA_WIDTH*NUM_STATUS_REGS){1'b0}};
assign write_en_ack_int= (csr_en && !power_iso_en_csr_ctrl) ? write_en_ack : {NUM_STATUS_REGS{1'b0}};

generate
  if (FORCE_INTER_SEL_CVP_EN == 1)
    begin: ENABLE_CVP_FORCE_LOGIC
    // CVP enable to control the mdio_dis
    cfg_dprio_dis_ctrl_cvp
#(
   .CLK_FREQ_MHZ(DIS_CVP_CLK_FREQ_MHZ),
   .TOGGLE_TYPE(DIS_CVP_TOGGLE_TYPE),
   .VID(DIS_CVP_VID)
 ) 
    cfg_dprio_dis_ctrl_cvp
    (
     .rst_n        (csr_en),                 // reset
     .clk          (dprio_clk_int),          // clock
     .dprio_dis_in (mdio_dis),               // dprio_dis in
     .csr_cvp_en   (cvp_inter_sel_csr_ctrl), // CSR enable
     .dprio_dis_out(mdio_dis_int_1)          // dprio_dis out
    );
    end
  else
    begin: DISABLE_CVP_FORCE_LOGIC
      assign mdio_dis_int_1 = mdio_dis;
    end
endgenerate

// DPRIO register module
cfg_dprio_ctrl_stat_reg_chnl 
#(
   .BINDEX(BINDEX),                            // Base index
   .SEGMENT(SEGMENT),                          // CSR segment
   .DATA_WIDTH(DATA_WIDTH),                    // Data width
   .ADDR_WIDTH(ADDR_WIDTH),                    // Address width
   .NUM_CTRL_REGS(NUM_CTRL_REGS),              // Number of n-bit control registers
   .NUM_STATUS_REGS(NUM_STATUS_REGS),          // Number of n-bit status registers
   .BYPASS_STAT_SYNC(BYPASS_STAT_SYNC),        // Parameter to bypass the Synchronization SM in case of individual status bits
   .NUM_ATPG_SCAN_CHAIN(NUM_ATPG_SCAN_CHAIN),  // Number of ATPG scan chains
   .CLK_FREQ_MHZ(STAT_REG_CLK_FREQ_MHZ),
   .SECTOR_ROW(SECTOR_ROW),
   .SECTOR_COL(SECTOR_COL),
   .TOGGLE_TYPE(STAT_REG_TOGGLE_TYPE),
   .VID(STAT_REG_VID)
 ) ctrl_stat_reg_chnl
( 
 .rst_n(dprio_rst_n),                         // DPRIO reset
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
 .csr_chain_in(csr_chain_in[NUM_ATPG_SCAN_CHAIN-1:0]),              // ATPG scan input
 .csr_chain_out(csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-1:0]),        // ATPG scan output
 .write_en(write_en),                         // write data enable to user logic
 .readdata(readdata),                         // Read data to route back to central Avalon-MM
 .user_dataout(user_dataout),                 // CRAM connecting to custom logic
 //.csr_out(csr_int),                           // serial CSR output
 .block_select(block_select)                  // Block select
);

// extra CSR register module
//cfg_dprio_csr_reg_nregs 
//#(
//   .DATA_WIDTH(DATA_WIDTH),                 // Data width
//   .NUM_EXTRA_CSR_REG(NUM_EXTRA_CSR_REG),   // Number of extra 16-bit register for CSR
//   .CSR_OUT_NEG_FF_EN(CSR_OUT_NEG_FF_EN)    // Enable negative FF on csr_out
// ) csr_reg_nregs
//( 
// .clk(csr_clk_int),           // clock
// .csr_in(extra_csr_in),       // serial CSR in
// .csr_en(csr_en),             // CSR enable
// .scan_shift_n(scan_shift_n), // active low scan shift
 
// .csr_reg(extra_csr),         // CRAM connecting to custom logic
// .csr_out(extra_csr_out)      // serial CSR output
//);

generate
  genvar j;
  if (NUM_CSR_ATPG_SCAN_CHAIN == 0)
    begin: single_csr_chain
      cfg_dprio_csr_reg_nregs
        #(
          .BINDEX  (BINDEX + DATA_WIDTH * NUM_CTRL_REGS),
          .SEGMENT (SEGMENT),
          .DATA_WIDTH(DATA_WIDTH),                 // Data width
          .NUM_EXTRA_CSR_REG(NUM_EXTRA_CSR_REG),   // Number of extra 16-bit register for CSR
          .CSR_OUT_NEG_FF_EN(CSR_OUT_NEG_FF_EN),   // Enable negative FF on csr_out
          .SECTOR_ROW(SECTOR_ROW),
          .SECTOR_COL(SECTOR_COL)
        ) csr_reg_nregs (
          .clk(csr_clk_int),                       // clock
          .csr_in(extra_csr_in),                   // serial CSR in
          .csr_en(csr_en),                         // CSR enable
          .scan_shift_n(scan_shift_n),             // active low scan shift

          .csr_reg(extra_csr),                     // CRAM connecting to custom logic
          .csr_out(extra_csr_out)                  // serial CSR output
        );
    end
  else
    for (j=0; j<NUM_CSR_ATPG_SCAN_CHAIN; j=j+1)
      begin: multi_csr_chains
        cfg_dprio_csr_reg_nregs
          #(
            .BINDEX  ((BINDEX + DATA_WIDTH * NUM_CTRL_REGS) + (DATA_WIDTH * NUM_CSR_REG_PER_CHAIN * j)),
            .SEGMENT (SEGMENT),
            .DATA_WIDTH(DATA_WIDTH),                                 // Data width
            .NUM_EXTRA_CSR_REG(NUM_CSR_REG_PER_CHAIN),               // Number of extra 16-bit register for CSR
            .CSR_OUT_NEG_FF_EN(CSR_OUT_NEG_FF_EN),                   // Enable negative FF on csr_out
            .SECTOR_ROW(SECTOR_ROW),
            .SECTOR_COL(SECTOR_COL)
          ) csr_reg_nregs (
            .clk(csr_clk_int),                                       // clock
//            .csr_in(extra_csr_in[j - 1]),                            // serial CSR in
            .csr_in(csr_chain_in[j + NUM_ATPG_SCAN_CHAIN]),                            // serial CSR in
            .csr_en(csr_en),                                         // CSR enable
            .scan_shift_n(scan_shift_n),                             // active low scan shift

            .csr_reg(extra_csr[TOTAL_CSR_REG_PER_CHAIN * (j + 1) - 1 : TOTAL_CSR_REG_PER_CHAIN * j]),
                                                                     // CRAM connecting to custom logic
//            .csr_out(extra_csr_out[j - 1])                           // serial CSR output
            .csr_out(csr_chain_out[j + NUM_ATPG_SCAN_CHAIN])                           // serial CSR output
          );
      end
endgenerate

// Connect extra CSR regs to the ATPG chain
generate
  genvar k;
  if (NUM_CSR_ATPG_SCAN_CHAIN == 0)
    begin: chain_csr_with_dprio
      assign extra_csr_in                         = csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-1];
      assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-1] = extra_csr_out;
      if (NUM_ATPG_SCAN_CHAIN > 1)
        begin: MORE_THAN_ONE_ATPG_CHAIN
          assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-2:0] = csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-2:0];
        end
    end
  else
    if (NUM_ATPG_SCAN_CHAIN > 0)
      begin: MORE_THAN_ONE_ATPG_CHAIN
        assign csr_chain_out[NUM_ATPG_SCAN_CHAIN-1:0] = csr_chain_out_int[NUM_ATPG_SCAN_CHAIN-1:0];
      end
endgenerate

// atpg_scan_in/out, csr_out connection
assign atpg_scan_out = csr_chain_out;
assign csr_out       = atpg_scan_out[TOTAL_ATPG_SCAN_CHAIN - 1];

generate
  genvar i;
  assign csr_chain_in[0] = (scan_mode_n == 1'b1) ? csr_in : atpg_scan_in[0];
  for (i=1; i<TOTAL_ATPG_SCAN_CHAIN; i=i+1)
    begin: CSR_CHAIN_IN_CON
      assign csr_chain_in[i] = (scan_mode_n == 1'b1) ? atpg_scan_out[i-1] : atpg_scan_in[i];
    end
endgenerate

endmodule
