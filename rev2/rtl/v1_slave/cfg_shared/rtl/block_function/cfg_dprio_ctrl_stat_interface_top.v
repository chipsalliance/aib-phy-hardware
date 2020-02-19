// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//**************************************************************************
// Description:
//
// There are 2 interfaces to access the DPRIO registers: Avalon-MM and CSR
//**************************************************************************
module cfg_dprio_ctrl_stat_interface_top 
#(
   parameter DATA_WIDTH        = 16,  // Data width
   parameter ADDR_WIDTH        = 10,  // Address width
   parameter NUM_CHNL          = 18,  // Number of DPRIO blocks interfacing with this interface
   parameter CSR_OUT_NEG_FF_EN = 1    // Enable negative FF on csr_out   
 )
(
// POR hard reset
input  wire                           npor,                 // NPOR from CB
input  wire                           plniotri,             // PLNIOTRI from CB
input  wire                           entest,               // ENTEST from CB

// Scan interface
input  wire                           scan_mode_n,          // active low scan mode enable
input  wire                           scan_shift_n,         // active low scan shift
input  wire                           refclk_dig,           // scan clock

output wire                           scan_mode_n_chnl,     // active low scan mode enable for top channel
output wire                           scan_shift_n_chnl,    // active low scan mode enable for top channel

// CSR interface
input   wire                          csr_rst_n,            // CSR reset
input   wire                          csr_clk,              // CSR clock
input   wire                          csr_in,               // Serial CSR input
input   wire                          csr_en,               // CSR enable

output  wire                          csr_out,              // Serial CSR output

// internal CSR interface to channels
input   wire                          csr_out_chnl,         // CSR output from top channel
 
output  wire                          csr_en_chnl,          // CSR enable to channels
output  wire                          csr_clk_chnl,         // CSR clock to channels
output  wire                          csr_in_chnl,          // CSR input to top channel

// CSR test mux interface
input  wire                           csr_cbdin,            // CSR configuration mode data input
input  wire                           csr_tcsrin,           // CSR test/scan mode data input
input  wire                           csr_din,              // Previous CSR bit data output
input  wire                           csr_seg,              // VSS for Seg0, VCC for seg[31:1]
input  wire                           csr_entest,           // enable test control input
input  wire                           csr_enscan,           // enable scan control input
input  wire                           csr_tverify,          // test verify control input
input  wire                           csr_load_csr,         // JTAG scan mode control input
input  wire                           csr_pipe_in,          // Input to the Pipeline register to suport 200MHz
 
output wire                           csr_dout,             // CSR input MUX Data output
output wire                           csr_pipe_out,         // Pipelined register data output
output wire                           csr_test_mode,        // CSR test mode for DPRIO module

// Control inputs to select the interface
input  wire                           interface_sel,        // Interface selection inputs
                                                            // 1'b1: select CSR interface
                                                            // 1'b0: select AVMM interface

// Avalon-MM interface
input  wire                           avmm_rst_n,           // Avalon-MM reset
input  wire                           avmm_clk,             // Avalon-MM clock
input  wire                           avmm_write,           // Avalon-MM write enable input
input  wire                           avmm_read,            // Avalon-MM read enable input
input  wire [(DATA_WIDTH/8)-1:0]      avmm_byte_en,         // Avalon-MM Byte enable
input  wire [ADDR_WIDTH-1:0]          avmm_reg_addr,        // Avalon-MM address input
input  wire [DATA_WIDTH-1:0]          avmm_writedata,       // Avalon-MM write data input

output wire [DATA_WIDTH-1:0]          avmm_readdata,        // Avalon-MM read data output

// IO interface to/from channels
input  wire [NUM_CHNL-1:0]            block_select,         // Signal to tell the central interface to select its readdata
input  wire [DATA_WIDTH*NUM_CHNL-1:0] readdata_chnl,        // Read data from channels
 
output wire                           dprio_rst_n,          // Active low reset to channel
output wire                           dprio_clk,            // Clock to channel
output wire                           mdio_dis_chnl,        // 1'b1=CRAM is from CSR 
                                                            // 1'b0=CRAM is from DPRIO register
output reg  [DATA_WIDTH-1:0]          writedata_chnl,       // Write data to channel
output reg  [ADDR_WIDTH-1:0]          reg_addr_chnl,        // Address to channel
output reg                            write_chnl,           // Write enable to channel
output reg                            read_chnl,            // Read enable to channel
output reg  [(DATA_WIDTH/8)-1:0]      byte_en_chnl          // Byte enable to channel
);

wire  [DATA_WIDTH-1:0]                readdata_chnl_int;
wire  [15:0]                          mdio_reg_addr;
wire  [15:0]                          mdio_write_data;
wire                                  mdio_wr;
wire                                  mdio_rd;
reg  [DATA_WIDTH-1:0]                 mdio_read_data;
reg  [DATA_WIDTH-1:0]                 mdio_read_data_reg;
integer                               i;

reg                                   avmm_write_reg;    
reg                                   avmm_read_reg;     
reg   [(DATA_WIDTH/8)-1:0]            avmm_byte_en_reg;  
reg   [ADDR_WIDTH-1:0]                avmm_reg_addr_reg; 
reg   [DATA_WIDTH-1:0]                avmm_writedata_reg;

wire                                  csr_out_int;
reg                                   csr_out_reg;
wire                                  csr_out_neg_bypass;

wire                                  hard_rst_n;
wire                                  interface_sel_int;

wire                                  csr_clk_int;
wire                                  dprio_clk_1_mo;

// Internet interface selection
assign interface_sel_int = interface_sel | csr_test_mode | (~csr_en);

// CSR test mode
assign csr_test_mode = csr_entest | csr_enscan | csr_tverify | csr_load_csr;

// Hard Reset logic
assign hard_rst_n = plniotri & ~entest & npor;

// Scan signal distribution
assign scan_mode_n_chnl  = scan_mode_n;
assign scan_shift_n_chnl = scan_shift_n;

// Singal to the channels
// mdio_dis output assignment
assign mdio_dis_chnl = interface_sel;

// Clock selection
//assign dprio_clk = (scan_mode_n == 1'b0)             ? refclk_dig : 
//                   (interface_sel_int == 1'b1)       ? csr_clk    : avmm_clk;
  cfg_cmn_clk_mux dprio_clk_1_mux (
    .clk1    (csr_clk),          // Select this clock when sel == 1'b1
    .clk2    (avmm_clk),         // Select this clock when sel == 1'b0
    .sel     (interface_sel_int),
    .clk_out (dprio_clk_1_mo)
  );

  cfg_cmn_clk_mux dprio_clk_2_mux (
    .clk1    (dprio_clk_1_mo),   // Select this clock when sel == 1'b1
    .clk2    (refclk_dig),       // Select this clock when sel == 1'b0
    .sel     (scan_mode_n),
    .clk_out (dprio_clk)
  );

//assign csr_clk_int = (scan_mode_n == 1'b0)            ? refclk_dig : csr_clk;
  cfg_cmn_clk_mux csr_clk_mux (
    .clk1    (csr_clk),          // Select this clock when sel == 1'b1
    .clk2    (refclk_dig),       // Select this clock when sel == 1'b0
    .sel     (scan_mode_n),
    .clk_out (csr_clk_int)
  );

// Reset selection
assign dprio_rst_n = (scan_mode_n == 1'b0) ? avmm_rst_n : hard_rst_n;


// Selection of signals to the channels
always @(*)
  begin
    case (interface_sel)
      1'b0:  // Avalon-MM interface
            begin
              writedata_chnl = avmm_writedata_reg;
              reg_addr_chnl  = avmm_reg_addr_reg;
              write_chnl     = avmm_write_reg;
              read_chnl      = avmm_read_reg;
              byte_en_chnl   = avmm_byte_en_reg;
            end
      1'b1: // CSR interface
            begin
              writedata_chnl = {DATA_WIDTH{1'b0}};
              reg_addr_chnl  = {ADDR_WIDTH{1'b0}};
              write_chnl     = 1'b0;
              read_chnl      = 1'b0;
              byte_en_chnl   = {(DATA_WIDTH/8){1'b0}};
            end
      default: // CSR
            begin
              writedata_chnl = {DATA_WIDTH{1'b0}};
              reg_addr_chnl  = {ADDR_WIDTH{1'b0}};
              write_chnl     = 1'b0;
              read_chnl      = 1'b0;
              byte_en_chnl   = {(DATA_WIDTH/8){1'b0}};
            end
    endcase
  end

// Selection of read data from channels
cfg_dprio_readdata_mux 
#(
   .DATA_WIDTH(DATA_WIDTH), // Data width
   .NUM_INPUT(NUM_CHNL)     // Number of n-bit input
 ) cfg_dprio_readdata_mux
( 
 .clk(dprio_clk),
 .rst_n(dprio_rst_n),
 .read(1'b1),
 .sel(block_select),             // 1-hot selection input
 .data_in(readdata_chnl),        // data input

 .data_out(readdata_chnl_int)    // data output
);

// Registering Avalon-MM interface IOs
assign avmm_readdata = readdata_chnl_int;

always @(negedge dprio_rst_n or posedge dprio_clk)
  if (dprio_rst_n == 1'b0)
    begin
      avmm_write_reg     <= 1'b0;    
      avmm_read_reg      <= 1'b0;     
      avmm_byte_en_reg   <= {(DATA_WIDTH/8){1'b0}};  
      avmm_reg_addr_reg  <= {ADDR_WIDTH{1'b0}}; 
      avmm_writedata_reg <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      avmm_write_reg     <= avmm_write;    
      avmm_read_reg      <= avmm_read;     
      avmm_byte_en_reg   <= avmm_byte_en;  
      avmm_reg_addr_reg  <= avmm_reg_addr; 
      avmm_writedata_reg <= avmm_writedata;    
    end

// CSR feedthough
assign csr_en_chnl     = csr_en;
assign csr_clk_chnl    = csr_clk_int;

assign csr_in_chnl     = csr_in;
assign csr_out_int     = csr_out_chnl;

// Negative FF for csr_out
always @ (negedge csr_rst_n or negedge csr_clk_int)
  if (csr_rst_n == 1'b0)
    begin
      csr_out_reg <= 1'b0;
    end
  else
    begin
      csr_out_reg <= csr_out_int;
    end

// Bypassing negative FF in scan_shift
assign csr_out_neg_bypass = (scan_shift_n == 1'b1) ? csr_out_reg : csr_out_int;

// csr_out assignment
assign csr_out = (CSR_OUT_NEG_FF_EN == 1) ? csr_out_neg_bypass : csr_out_int;

// CSR test mux
cfg_dprio_csr_test_mux cfg_dprio_csr_test_mux
(
 .rst_n(csr_rst_n),         // Active low hard reset
 .clk(csr_clk_int),         // Clock
 .cbdin(csr_cbdin),         // CSR configuration mode data input
 .tcsrin(csr_tcsrin),       // CSR test/scan mode data input
 .csrdin(csr_din),          // Previous CSR bit data output
 .csr_seg(csr_seg),         // VSS for Seg0(), VCC for seg[31:1]
 .entest(csr_entest),       // enable test control input
 .enscan(csr_enscan),       // enable scan control input
 .tverify(csr_tverify),     // test verify control input
 .load_csr(csr_load_csr),   // JTAG scan mode control input
 .pipe_in(csr_pipe_in),     // Input to the Pipeline register to suport 200MHz
 .csrdout(csr_dout),        // CSR input MUX Data output
 .pipe_out(csr_pipe_out)    // Pipelined register data output
);

endmodule
