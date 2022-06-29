// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation.

module aib_avalon_adapt_reg (
output [31:0] rx_0, // Rx Adapt configuration register 0
output [31:0] rx_1, // Rx Adapt configuration register 1
output [31:0] tx_0, // Tx Adapt configuration register 0
output [31:0] tx_1, // Tx Adapt configuration register 1

//------------------------------------------------------------------------------
//                    BERT access interface
//------------------------------------------------------------------------------
output     [ 5:0] bert_acc_addr,        // BERT access address
output            bert_acc_req,         // BERT access request
output            bert_acc_rdwr,        // BERT access read/write control
output reg [31:0] bert_wdata_ff,        // BERT data to be written
input      [31:0] rx_bert_rdata_ff,     // Read data from RX BERT interface
input      [31:0] tx_bert_rdata_ff,     // Read data from TX BERT interface
input             bert_acc_rq_pend,     // BERT configuration load is pending

//------------------------------------------------------------------------------
//                        TX BERT control interface
//------------------------------------------------------------------------------
output [3:0] tx_bert_start, // Starts transmitting TX BERT bit sequence
output [3:0] tx_bert_rst,   // Resets TX BERT registers

//------------------------------------------------------------------------------
//                        TX BERT status interface
//------------------------------------------------------------------------------
input       bert_seed_good, // Indicates all BPRS seeds are not zero.
input [3:0] txbert_run_ff,  // Indicates  TX BERT is running

//------------------------------------------------------------------------------
//                        RX BERT control interface
//------------------------------------------------------------------------------
output [3:0] rxbert_start,   // Starts checking input of RX BERT bit sequence
output [3:0] rxbert_rst,     // Resets RX BERT registers
output [3:0] rxbert_seed_in, // Enables the self-seeding in RX BERT

//------------------------------------------------------------------------------
//                        RX BERT status interface
//------------------------------------------------------------------------------
input [ 3:0] rxbert_run_ff,    // Indicates RX BERT is running
input [ 3:0] rxbert_biterr_ff, // Error detected in RX BERT checker

// BERT enable
output tx_bert_en, // TX BERT enable

//------------------------------------------------------------------------------
//                             Bus Interface
//------------------------------------------------------------------------------
input             clk,               // Access Clock
input             reset,             // Asynchronous reset
input      [31:0] writedata,         // Write data bus
input             read,              // Read data bus
input             write,             // Write enable
input      [ 3:0] byteenable,        // Byte enable
input      [ 7:0] address,           // Address bus
input             tx_clk_div_ld_ack, // TX clock divider load ack
input             rx_clk_div_ld_ack, // RX clock divider load ack
output reg [31:0] readdata,          // Read data bus
output reg        tx_clk_div_ld_ff,  // Loads Tx clock divider selection
output reg        tx_clk_div_1_ff,   // Tx Clock divided by 1 selection
output reg        tx_clk_div_2_ff,   // Tx Clock divided by 2 selection
output reg        tx_clk_div_4_ff,   // Tx Clock divided by 4 selection
output reg        rx_clk_div_ld_ff,  // Loads Rx clock divider selection
output reg        rx_clk_div_1_ff,   // Rx Clock divided by 1 selection
output reg        rx_clk_div_2_ff,   // Rx Clock divided by 2 selection
output reg        rx_clk_div_4_ff    // Rx Clock divided by 4 selection
);

wire        reset_n;             // Active low reset
wire [ 3:0] we_rx_0;             // Rx0 register write enable
wire [ 3:0] we_rx_1;             // Tx1 register write enable
wire [ 3:0] we_tx_0;             // Rx0 register write enable
wire [ 3:0] we_tx_1;             // Tx1 register write enable
wire        tx_div_if_busy;      // Indicates Tx div CDC interface is busy
wire        rx_div_if_busy;      // Indicates rx div CDC interface is busy
wire        tx_clk_div_ack_sync; // Tx clock divider ack synchronized
wire        rx_clk_div_ack_sync; // Rx clock divider ack synchronized
wire        txclk_div_update;    // Tx clock divided update
wire        rxclk_div_update;    // Rx clock divided update
wire        txclk_div1_sel;      // Tx clock divided by 1 selection
wire        txclk_div2_sel;      // Tx clock divided by 2 selection
wire        txclk_div4_sel;      // Tx clock divided by 4 selection
wire        rxclk_div1_sel;      // Tx clock divided by 1 selection
wire        rxclk_div2_sel;      // Tx clock divided by 2 selection
wire        rxclk_div4_sel;      // Tx clock divided by 4 selection

reg  [31:0] rdata_comb; // combinatorial read data signal declaration
reg  [31:0] rx_0_ff;    // Rx Adapt configuration register 0
reg  [31:0] rx_1_ff;    // Rx Adapt configuration register 1
reg  [31:0] tx_0_ff;    // Tx Adapt configuration register 0
reg  [31:0] tx_1_ff;    // Tx Adapt configuration register 1

//------------------------------------------------------------------------------
//              BERT access request register - ADDR OFF = 0x20
//------------------------------------------------------------------------------
wire        bert_acc_rq_sel;         // Seed load register selection
wire        bert_acc_rq_wbyte_7_0;   // Seed load write into byte 7-0
wire        bert_acc_rq_wbyte_23_16; // Seed load write into byte 23-16
wire        bert_acc_rq_wbyte_31_24; // Seed load write into byte 31-24
wire [31:0] bert_acc_rq_rdata;       // Seed load read data

//------------------------------------------------------------------------------
//             BERT write data register - ADDR OFF = 0x24
//------------------------------------------------------------------------------
wire bert_wdata_sel;         // BERT configuration input register selection
wire bert_wdata_wbyte_7_0;   // BERT config input register write into byte 7-0
wire bert_wdata_wbyte_15_8;  // BERT config input register write into byte 15-8
wire bert_wdata_wbyte_23_16; // BERT conf. input register write into byte 23-16
wire bert_wdata_wbyte_31_24; // BERT conf. input register write into byte 31-24

//------------------------------------------------------------------------------
//             TX BERT control register - ADDR OFF = 0x28
//------------------------------------------------------------------------------
wire txbert_ctrl_sel;         // TX BERT control register selection
wire txbert_ctrl_wbyte_7_0;   // Write into byte 7-0 of TX BERT control register
wire txbert_ctrl_wbyte_23_16; // Write into byte 23-16 of TX BERT ctrl register

//------------------------------------------------------------------------------
//             TX BERT status register - ADDR OFF = 0x2C
//------------------------------------------------------------------------------
wire [31:0] txbert_st_rdata; // TX BERT status data

//------------------------------------------------------------------------------
//             RX BERT control register - ADDR OFF = 0x30
//------------------------------------------------------------------------------
wire rxbert_ctrl_sel;         // RX BERT control register selection
wire rxbert_ctrl_wbyte_7_0;   // Write into byte 7-0 of RX BERT control register
wire rxbert_ctrl_wbyte_23_16; // Write into byte 23-16 of RX BERT ctrl register
wire rxbert_ctrl_wbyte_31_24; // Write into byte 31-24 of RX BERT ctrl register

//------------------------------------------------------------------------------
//             RX BERT status register - ADDR OFF = 0x34
//------------------------------------------------------------------------------
wire [31:0] rxbert_st_rdata;   // RX BERT status data

// --------------------------------------------------------------------
// Local parameters to enable bits in registers: RX0, RX1, TX0 and TX1
// --------------------------------------------------------------------

localparam [31:0] RX0_PARAM = { 4'h0,   // reserved 31-28
                                4'hf,   // rx_phcomp 27-24
                                20'h0,  // Reserved 23-4
                                2'h3,   // rx_clk_div 3-2
                                1'h1,   // rx_dbi_en - bit 1
                                1'h1 }; // rxswap_en - bit 0

// RX1 register
localparam [31:0] RX1_PARAM ={ 1'h1,   // rx_wa_mode
                               18'h0,  // Reserved30-13
                               5'h1f,  // rx_align_threshold
                               1'h1,   // rx_marker_bit79
                               1'h1,   // rx_marker_bit78
                               1'h1,   // rx_marker_bit77
                               1'h1,   // rx_marker_bit76
                               1'h1,   // rx_marker_bit39
                               2'h3,   // rx_fifo_mode1-0
                               1'h1 }; // rx_wa_en

// TX0 register
localparam [31:0] TX0_PARAM = {  4'hf,   // tx_phcomp 30-28 
                                 1'h0,   // reserved 27
                                 1'h0,   // reserved 26
                                 2'h3,   // tx_clk_div
                                 1'h1,   // tx_wm_en
                                 2'h3,   // tx_fifo_mode 1-0
                                 1'h1,   // tx_marker_bit79
                                 1'h1,   // tx_marker_bit78
                                 1'h1,   // tx_marker_bit77
                                 1'h1,   // tx_marker_bit76
                                 1'h1,   // tx_marker_bit39
                                 14'h0,  // Reserved 15-2
                                 1'h1,   // tx_dbi_en
                                 1'h1 }; // txswap_en

// TX1 register
localparam [31:0] TX1_PARAM = { 1'h1,   // SDR bit
                                1'h1,   // PAD enable bit
                                14'h0,  // Reserved
                                2'h3,   // Loopback_mode 1-0
                                4'h0,   // Reserved
                                1'h1,   // fwd_clk_test
                                1'h1,   // TX BERT enable
                                8'h0 }; // Reserved

// Reset value of RX_0 register
localparam [31:0] RX0_RST = {5'b0,3'b10,24'b0} & RX0_PARAM;

// Reset value of RX_1 register
localparam [31:0] RX1_RST = {19'b0,5'b10,8'b0} & RX1_PARAM;

// Reset value of TX_0 register
localparam [31:0] TX0_RST = {4'b10,28'b0} & TX0_PARAM; 

// Reset value of TX_1 register
localparam [31:0] TX1_RST = {1'b0,1'b1,30'h0} & TX1_PARAM;

// Register address offsets
localparam [7:0] RX0_ADDR_OFF           = 8'h08;
localparam [7:0] RX1_ADDR_OFF           = 8'h10;
localparam [7:0] TX0_ADDR_OFF           = 8'h18;
localparam [7:0] TX1_ADDR_OFF           = 8'h1c;
localparam [7:0] BERT_ACC_RQ_ADDR_OFF   = 8'h20;
localparam [7:0] BERT_WDATA_ADDR_OFF    = 8'h24;
localparam [7:0] TXBERT_CTRL_ADDR_OFF   = 8'h28;
localparam [7:0] TXBERT_ST_ADDR_OFF     = 8'h2c;
localparam [7:0] TXBERT_RDATA_ADDR_OFF  = 8'h30;
localparam [7:0] RXBERT_CTRL_ADDR_OFF   = 8'h34;
localparam [7:0] RXBERT_ST_ADDR_OFF     = 8'h38;
localparam [7:0] RXBERT_RDATA0_ADDR_OFF = 8'h3c;

// Active low reset
assign reset_n = !reset;

// synchronous process for the read
always @(negedge reset_n or posedge clk)  
  begin: readdata_register
    if (!reset_n) // reset
      readdata[31:0] <= 32'h0;
    else
      readdata[31:0] <= rdata_comb[31:0];
  end // block: readdata_register

// ----------------------------------------------------
// A write byte enable for each register
// ----------------------------------------------------
assign we_rx_0[3:0] = write & (address[7:0] == RX0_ADDR_OFF) ?
                      byteenable[3:0]                 :
                      {4{1'b0}};

assign we_rx_1[3:0] = write & (address[7:0] == RX1_ADDR_OFF) ?
                      byteenable[3:0]                 :
                      {4{1'b0}};

assign we_tx_0[3:0] = write & (address[7:0] == TX0_ADDR_OFF) ?
                      byteenable[3:0]                 : 
                      {4{1'b0}};                        

assign we_tx_1[3:0] = write & (address[7:0] == TX1_ADDR_OFF) ?
                      byteenable[3:0]                 :
                      {4{1'b0}};

// RX0 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: rx_0_7_0_register
    if(!reset_n) // reset
      begin
        rx_0_ff[7:0] <= RX0_RST[7:0];
      end
    else if(we_rx_0[0]) // Write enable
      begin
        rx_0_ff[7:0] <=  writedata[7:0] & RX0_PARAM[7:0];
      end
    else // Keep value
      begin
        rx_0_ff[7:0] <=  rx_0_ff[7:0] & RX0_PARAM[7:0];
      end
  end // block: rx_0_7_0_register

// RX0 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: rx_0_15_8_register
    if(!reset_n) // reset
      begin
        rx_0_ff[15:8] <= RX0_RST[15:8];
      end
    else if(we_rx_0[1]) // Write enable
      begin
        rx_0_ff[15:8] <=  writedata[15:8] & RX0_PARAM[15:8];
      end
    else // Keep value
      begin
        rx_0_ff[15:8] <=  rx_0_ff[15:8] & RX0_PARAM[15:8];
      end
  end // block: rx_0_15_8_register

// RX0 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: rx_0_23_16_register
    if(!reset_n) // reset
      begin
        rx_0_ff[23:16] <= RX0_RST[23:16];
      end
    else if(we_rx_0[2]) // Write enable
      begin
        rx_0_ff[23:16] <=  writedata[23:16] & RX0_PARAM[23:16];
      end
    else // Keep value
      begin
        rx_0_ff[23:16] <=  rx_0_ff[23:16] & RX0_PARAM[23:16];
      end
  end // block: rx_0_23_16_register

// RX0 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: rx_0_31_24_register
    if(!reset_n) // reset
      begin
        rx_0_ff[31:24] <= RX0_RST[31:24];
      end
    else if(we_rx_0[3]) // Write enable
      begin
        rx_0_ff[31:24] <=  writedata[31:24] & RX0_PARAM[31:24];
      end
    else // Keep value
      begin
        rx_0_ff[31:24] <=  rx_0_ff[31:24] & RX0_PARAM[31:24];
      end
  end // block: rx_0_31_24_register

// RX1 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: rx_1_7_0_register
    if(!reset_n) // reset
      begin
        rx_1_ff[7:0] <= RX1_RST[7:0];
      end
    else if(we_rx_1[0]) // Write enable
      begin
        rx_1_ff[7:0] <=  writedata[7:0] & RX1_PARAM[7:0];
      end
    else // Keep value
      begin
        rx_1_ff[7:0] <=  rx_1_ff[7:0] & RX1_PARAM[7:0];
      end
  end // block: rx_1_7_0_register

// RX1 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: rx_1_15_8_register
    if(!reset_n) // reset
      begin
        rx_1_ff[15:8] <= RX1_RST[15:8];
      end
    else if(we_rx_1[1]) // Write enable
      begin
        rx_1_ff[15:8] <=  writedata[15:8] & RX1_PARAM[15:8];
      end
    else // Keep value
      begin
        rx_1_ff[15:8] <=  rx_1_ff[15:8] & RX1_PARAM[15:8];
      end
  end // block: rx_1_15_8_register

// RX1 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: rx_1_23_16_register
    if(!reset_n) // reset
      begin
        rx_1_ff[23:16] <= RX1_RST[23:16];
      end
    else if(we_rx_1[2]) // Write enable
      begin
        rx_1_ff[23:16] <=  writedata[23:16] & RX1_PARAM[23:16];
      end
    else // Keep value
      begin
        rx_1_ff[23:16] <=  rx_1_ff[23:16] & RX1_PARAM[23:16];
      end
  end // block: rx_1_23_16_register

// RX1 Register - byte 30-24
always @( negedge  reset_n or  posedge clk)
  begin: rx_1_30_24_register
    if(!reset_n) // reset
      begin
        rx_1_ff[30:24] <= RX1_RST[30:24];
      end
    else if(we_rx_1[3]) // Write enable
      begin
        rx_1_ff[30:24] <=  writedata[30:24] & RX1_PARAM[30:24];
      end
    else // Keep value
      begin
        rx_1_ff[30:24] <=  rx_1_ff[30:24] & RX1_PARAM[30:24];
      end
  end // block: rx_1_30_24_register


// RX1 Register - byte 31 - sticky bit rx_wa_mode
always @( negedge  reset_n or  posedge clk)
  begin: rx_1_31_register
    if(!reset_n) // reset
      begin
        rx_1_ff[31] <= RX1_RST[31];
      end
    else if(we_rx_1[3] && !rx_1_ff[31]) // Write enable
      begin
        rx_1_ff[31] <=  writedata[31] & RX1_PARAM[31];
      end
    else // Keep value
      begin
        rx_1_ff[31] <=  rx_1_ff[31] & RX1_PARAM[31];
      end
  end // block: rx_1_31_register

// TX0 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: tx_0_7_0_register
    if(!reset_n) // reset
      begin
        tx_0_ff[7:0] <= TX0_RST[7:0];
      end
    else if(we_tx_0[0]) // Write enable
      begin
        tx_0_ff[7:0] <=  writedata[7:0] & TX0_PARAM[7:0];
      end
    else // Keep value
      begin
        tx_0_ff[7:0] <=  tx_0_ff[7:0] & TX0_PARAM[7:0];
      end
  end // block: tx_0_7_0_register

// TX0 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: tx_0_15_8_register
    if(!reset_n) // reset
      begin
        tx_0_ff[15:8] <= TX0_RST[15:8];
      end
    else if(we_tx_0[1]) // Write enable
      begin
        tx_0_ff[15:8] <=  writedata[15:8] & TX0_PARAM[15:8];
      end
    else // Keep value
      begin
        tx_0_ff[15:8] <=  tx_0_ff[15:8] & TX0_PARAM[15:8];
      end
  end // block: tx_0_15_8_register

// TX0 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: tx_0_23_16_register
    if(!reset_n) // reset
      begin
        tx_0_ff[23:16] <= TX0_RST[23:16];
      end
    else if(we_tx_0[2]) // Write enable
      begin
        tx_0_ff[23:16] <=  writedata[23:16] & TX0_PARAM[23:16];
      end
    else // Keep value
      begin
        tx_0_ff[23:16] <=  tx_0_ff[23:16] & TX0_PARAM[23:16];
      end
  end // block: tx_0_23_16_register

// TX0 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: tx_0_31_24_register
    if(!reset_n) // reset
      begin
        tx_0_ff[31:24] <= TX0_RST[31:24];
      end
    else if(we_tx_0[3]) // Write enable
      begin
        tx_0_ff[31:24] <=  writedata[31:24] & TX0_PARAM[31:24];
      end
    else // Keep value
      begin
        tx_0_ff[31:24] <=  tx_0_ff[31:24] & TX0_PARAM[31:24];
      end
  end // block: tx_0_31_24_register

// TX1 Register - byte 7-0
always @( negedge  reset_n or  posedge clk)
  begin: tx_1_7_0_register
    if(!reset_n) // reset
      begin
        tx_1_ff[7:0] <= TX1_RST[7:0];
      end
    else if(we_tx_1[0]) // Write enable
      begin
        tx_1_ff[7:0] <=  writedata[7:0] & TX1_PARAM[7:0];
      end
    else // Keep value
      begin
        tx_1_ff[7:0] <=  tx_1_ff[7:0] & TX1_PARAM[7:0];
      end
  end // block: tx_1_7_0_register

// TX1 Register - byte 15-8
always @( negedge  reset_n or  posedge clk)
  begin: tx_1_15_8_register
    if(!reset_n) // reset
      begin
        tx_1_ff[15:8] <= TX1_RST[15:8];
      end
    else if(we_tx_1[1]) // Write enable
      begin
        tx_1_ff[15:8] <=  writedata[15:8] & TX1_PARAM[15:8];
      end
    else // Keep value
      begin
        tx_1_ff[15:8] <=  tx_1_ff[15:8] & TX1_PARAM[15:8];
      end
  end // block: tx_1_15_8_register

// TX1 Register - byte 23-16
always @( negedge  reset_n or  posedge clk)
  begin: tx_1_23_16_register
    if(!reset_n) // reset
      begin
        tx_1_ff[23:16] <= TX1_RST[23:16];
      end
    else if(we_tx_1[2]) // Write enable
      begin
        tx_1_ff[23:16] <=  writedata[23:16] & TX1_PARAM[23:16];
      end
    else // Keep value
      begin
        tx_1_ff[23:16] <=  tx_1_ff[23:16] & TX1_PARAM[23:16];
      end
  end // block: tx_1_23_16_register

// TX1 Register - byte 31-24
always @( negedge  reset_n or  posedge clk)
  begin: tx_1_31_24_register
    if(!reset_n) // reset
      begin
        tx_1_ff[31:24] <= TX1_RST[31:24];
      end
    else if(we_tx_1[3]) // Write enable
      begin
        tx_1_ff[31:24] <=  writedata[31:24] & TX1_PARAM[31:24];
      end
    else // Keep value
      begin
        tx_1_ff[31:24] <=  tx_1_ff[31:24] & TX1_PARAM[31:24];
      end
  end // block: tx_1_31_24_register

// Register output to optimize logic according to local parameters
// Reserved registers are optimized during synthesis 
assign  rx_0[31:0] = rx_0_ff[31:0] & RX0_PARAM[31:0];
assign  rx_1[31:0] = rx_1_ff[31:0] & RX1_PARAM[31:0];
assign  tx_0[31:0] = tx_0_ff[31:0] & TX0_PARAM[31:0];
assign  tx_1[31:0] = tx_1_ff[31:0] & TX1_PARAM[31:0];

assign  tx_bert_en = tx_1[8];

//------------------------------------------------------------------------------
//            BERT access request register - Address offset = 0x20
//------------------------------------------------------------------------------

assign bert_acc_rq_sel = (address[7:0] == BERT_ACC_RQ_ADDR_OFF);

assign bert_acc_rq_wbyte_7_0   = bert_acc_rq_sel & write & byteenable[0];
assign bert_acc_rq_wbyte_23_16 = bert_acc_rq_sel & write & byteenable[2];
assign bert_acc_rq_wbyte_31_24 = bert_acc_rq_sel & write & byteenable[3];

assign bert_acc_addr[5:0] = {6{bert_acc_rq_wbyte_7_0}}   & writedata[5:0];
assign bert_acc_req       =    bert_acc_rq_wbyte_31_24   & writedata[30];
assign bert_acc_rdwr      =    bert_acc_rq_wbyte_31_24   & writedata[29];

assign bert_acc_rq_rdata[31:0] = {bert_acc_rq_pend,31'h0};

//------------------------------------------------------------------------------
//         BERT configuration input register - Address offset = 0x24
//------------------------------------------------------------------------------

assign bert_wdata_sel = (address[7:0] == BERT_WDATA_ADDR_OFF);

assign bert_wdata_wbyte_7_0   = bert_wdata_sel & write & byteenable[0];
assign bert_wdata_wbyte_15_8  = bert_wdata_sel & write & byteenable[1];
assign bert_wdata_wbyte_23_16 = bert_wdata_sel & write & byteenable[2];
assign bert_wdata_wbyte_31_24 = bert_wdata_sel & write & byteenable[3];

always @(posedge clk or negedge  reset_n)
  begin
    if(!reset_n)
      begin
        bert_wdata_ff[7:0] <= 8'h0;
      end
    else if(!bert_acc_rq_pend && bert_wdata_wbyte_7_0)
      begin
        bert_wdata_ff[7:0] <= writedata[7:0];
      end
  end

always @(posedge clk or negedge  reset_n)
  begin
    if(!reset_n)
      begin
        bert_wdata_ff[15:8] <= 8'h0;
      end
    else if(!bert_acc_rq_pend && bert_wdata_wbyte_15_8)
      begin
        bert_wdata_ff[15:8] <= writedata[15:8];
      end
  end

always @(posedge clk or negedge  reset_n)
  begin
    if(!reset_n)
      begin
        bert_wdata_ff[23:16] <= 8'h0;
      end
    else if(!bert_acc_rq_pend && bert_wdata_wbyte_23_16)
      begin
        bert_wdata_ff[23:16] <= writedata[23:16];
      end
  end

always @(posedge clk or negedge  reset_n)
  begin
    if(!reset_n)
      begin
        bert_wdata_ff[31:24] <= 8'h0;
      end
    else if(!bert_acc_rq_pend && bert_wdata_wbyte_31_24)
      begin
        bert_wdata_ff[31:24] <= writedata[31:24];
      end
  end

//------------------------------------------------------------------------------
//             TX BERT control register - ADDR OFF = 0x28
//------------------------------------------------------------------------------
assign txbert_ctrl_sel         = (address[7:0] == TXBERT_CTRL_ADDR_OFF);
assign txbert_ctrl_wbyte_7_0   = txbert_ctrl_sel & write & byteenable[0];
assign txbert_ctrl_wbyte_23_16 = txbert_ctrl_sel & write & byteenable[2];

assign tx_bert_rst[3:0]   = writedata[3:0]   & {4{txbert_ctrl_wbyte_7_0}};
assign tx_bert_start[3:0] = writedata[19:16] & {4{txbert_ctrl_wbyte_23_16}};

//------------------------------------------------------------------------------
//             TX BERT status register - ADDR OFF = 0x2C
//------------------------------------------------------------------------------

assign txbert_st_rdata[31:0] = { bert_seed_good,
                                 27'h0,
                                 txbert_run_ff[3:0] };


//------------------------------------------------------------------------------
//             RX BERT control register - ADDR OFF = 0x34
//------------------------------------------------------------------------------
assign rxbert_ctrl_sel = (address[7:0] == RXBERT_CTRL_ADDR_OFF);
assign rxbert_ctrl_wbyte_7_0   = rxbert_ctrl_sel & write & byteenable[0];
assign rxbert_ctrl_wbyte_23_16 = rxbert_ctrl_sel & write & byteenable[2];
assign rxbert_ctrl_wbyte_31_24 = rxbert_ctrl_sel & write & byteenable[3];

assign rxbert_rst[3:0]     = writedata[3:0]   & {4{rxbert_ctrl_wbyte_7_0}};
assign rxbert_start[3:0]   = writedata[19:16] & {4{rxbert_ctrl_wbyte_23_16}};
assign rxbert_seed_in[3:0] = writedata[27:24] & {4{rxbert_ctrl_wbyte_31_24}};

//------------------------------------------------------------------------------
//             RX BERT status register - ADDR OFF = 0x38
//------------------------------------------------------------------------------

// RX BERT status read data
assign rxbert_st_rdata[31:0] = { 12'h0,
                                 rxbert_biterr_ff[3:0],
                                 12'h0,
                                 rxbert_run_ff[3:0] };

//------------------------------------------------------------------------------
//                        Register read logic 
//------------------------------------------------------------------------------


// read process
always @ (*)
  begin: rdata_comb_logic
    rdata_comb = 32'h0;
    if(read) // Read access
      begin
        case (address[7:0])  
          RX0_ADDR_OFF:           rdata_comb [31:0] = rx_0[31:0];
          RX1_ADDR_OFF:           rdata_comb [31:0] = rx_1[31:0];
          TX0_ADDR_OFF:           rdata_comb [31:0] = tx_0[31:0];
          TX1_ADDR_OFF:           rdata_comb [31:0] = tx_1[31:0];
          BERT_ACC_RQ_ADDR_OFF:   rdata_comb [31:0] = bert_acc_rq_rdata[31:0];
          BERT_WDATA_ADDR_OFF:    rdata_comb [31:0] = bert_wdata_ff[31:0];
          TXBERT_CTRL_ADDR_OFF:   rdata_comb [31:0] = 32'h0;
          TXBERT_ST_ADDR_OFF:     rdata_comb [31:0] = txbert_st_rdata[31:0];
          RXBERT_CTRL_ADDR_OFF:   rdata_comb [31:0] = 32'h0;
          RXBERT_ST_ADDR_OFF:     rdata_comb [31:0] = rxbert_st_rdata[31:0];
          RXBERT_RDATA0_ADDR_OFF: rdata_comb [31:0] = rx_bert_rdata_ff[31:0];
          TXBERT_RDATA_ADDR_OFF:  rdata_comb [31:0] = tx_bert_rdata_ff[31:0];
          default : rdata_comb = 32'h00000000;
        endcase
      end
  end // block: rdata_comb_logic

//------------------------------------------------------------------------------
// Tx Clock divider section logic
//------------------------------------------------------------------------------

aib_bit_sync tx_clock_div_ack_sync
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (tx_clk_div_ld_ack),  // Input to be synchronized
   .data_out (tx_clk_div_ack_sync) // Synchronized output
   );

assign txclk_div1_sel = (tx_0_ff[25:24] == 2'b01);
assign txclk_div2_sel = (tx_0_ff[25:24] == 2'b10);
assign txclk_div4_sel = (tx_0_ff[25:24] == 2'b11);

// Detects if CDC interface is busy
assign tx_div_if_busy = tx_clk_div_ld_ff ^ tx_clk_div_ack_sync;

assign txclk_div_update = (~tx_div_if_busy) &
                          ( (txclk_div1_sel ^ tx_clk_div_1_ff) |
                            (txclk_div2_sel ^ tx_clk_div_2_ff) |
                            (txclk_div4_sel ^ tx_clk_div_4_ff)   );

// Load register for TX clock divider selection
always @(posedge clk or negedge reset_n)
  begin: tx_clk_div_ld_register
    if(!reset_n)
      tx_clk_div_ld_ff <= 1'b0;
    else if(txclk_div_update) // Update selection
      tx_clk_div_ld_ff <= ~tx_clk_div_ld_ff;
  end // block: tx_clk_div_ld_register

// TX clock divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: tx_clk_div_1_register
    if(!reset_n)
      tx_clk_div_1_ff <= 1'b0;
    else if(txclk_div_update) // Update selection
      tx_clk_div_1_ff <= txclk_div1_sel;
  end // block: tx_clk_div_1_register

// TX clock divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: tx_clk_div_2_register
    if(!reset_n)
      tx_clk_div_2_ff <= 1'b0;
    else if(txclk_div_update) // Update selection
      tx_clk_div_2_ff <= txclk_div2_sel;
  end // block: tx_clk_div_2_register

// TX clock divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: tx_clk_div_4_register
    if(!reset_n)
      tx_clk_div_4_ff <= 1'b0;
    else if(txclk_div_update) // Update selection
      tx_clk_div_4_ff <= txclk_div4_sel;
  end // block: tx_clk_div_4_register

//------------------------------------------------------------------------------
// Rx Clock divider section logic
//------------------------------------------------------------------------------

aib_bit_sync rx_clock_div_ack_sync
  (
   .clk      (clk),                // Clock of destination domain
   .rst_n    (reset_n),            // Reset of destination domain
   .data_in  (rx_clk_div_ld_ack),  // Input to be synchronized
   .data_out (rx_clk_div_ack_sync) // Synchronized output
   );

assign rxclk_div1_sel = (rx_0_ff[3:2] == 2'b01);
assign rxclk_div2_sel = (rx_0_ff[3:2] == 2'b10);
assign rxclk_div4_sel = (rx_0_ff[3:2] == 2'b11);

// Detects if CDC interface is busy
assign rx_div_if_busy = rx_clk_div_ld_ff ^ rx_clk_div_ack_sync;

assign rxclk_div_update = (~rx_div_if_busy) &
                          ( (rxclk_div1_sel ^ rx_clk_div_1_ff) |
                            (rxclk_div2_sel ^ rx_clk_div_2_ff) |
                            (rxclk_div4_sel ^ rx_clk_div_4_ff)   );

// Load register for RX clock divider selection
always @(posedge clk or negedge reset_n)
  begin: rx_clk_div_ld_register
    if(!reset_n)
      rx_clk_div_ld_ff <= 1'b0;
    else if(rxclk_div_update) // Update selection
      rx_clk_div_ld_ff <= ~rx_clk_div_ld_ff;
  end // block: rx_clk_div_ld_register

// RX clock divided 1 selection register
always @(posedge clk or negedge reset_n)
  begin: rx_clk_div_1_register
    if(!reset_n)
      rx_clk_div_1_ff <= 1'b0;
    else if(rxclk_div_update) // Update selection
      rx_clk_div_1_ff <= rxclk_div1_sel;
  end // block: rx_clk_div_1_register

// RX clock divided 2 selection register
always @(posedge clk or negedge reset_n)
  begin: rx_clk_div_2_register
    if(!reset_n)
      rx_clk_div_2_ff <= 1'b0;
    else if(rxclk_div_update) // Update selection
      rx_clk_div_2_ff <= rxclk_div2_sel;
  end // block: tx_clk_div_2_register

// RX clock divided 4 selection register
always @(posedge clk or negedge reset_n)
  begin: rx_clk_div_4_register
    if(!reset_n)
      rx_clk_div_4_ff <= 1'b0;
    else if(rxclk_div_update) // Update selection
      rx_clk_div_4_ff <= rxclk_div4_sel;
  end // block: rx_clk_div_4_register

endmodule // aib_avalon_adapt_reg
