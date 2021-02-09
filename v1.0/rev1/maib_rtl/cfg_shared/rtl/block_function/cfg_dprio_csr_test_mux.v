// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//************************************************************
// Description:
//
// It's equivalent to C6514 cell in custom design
//************************************************************
module cfg_dprio_csr_test_mux
(
input  wire        rst_n,           // Active low hard reset
input  wire        clk,             // Clock
input  wire        cbdin,           // CSR configuration mode data input
input  wire        tcsrin,          // CSR test/scan mode data input
input  wire        csrdin,          // Previous CSR bit data output
input  wire        csr_seg,         // VSS for Seg0, VCC for seg[31:1]
input  wire        entest,          // enable test control input
input  wire        enscan,          // enable scan control input
input  wire        tverify,         // test verify control input
input  wire        load_csr,        // JTAG scan mode control input
input  wire        pipe_in,         // Input to the Pipeline register to suport 200MHz

output wire        csrdout,         // CSR input MUX Data output
output reg         pipe_out         // Pipelined register data output
);

reg                csr_reg;
wire               prog_mode;
wire               test_mode;
wire               scan_mode;
wire               verify_mode;
wire               jtag_mode;

// CSR register
always @(negedge rst_n or negedge clk)
  if (rst_n == 1'b0)
    begin
      csr_reg <= 1'b0;
    end
  else
    begin
      csr_reg <= cbdin;
    end
    
// CSR pipeline register
always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      pipe_out <= 1'b0;
    end
  else
    begin
      pipe_out <= pipe_in;
    end
    
// Mode decoding
assign prog_mode   = (~entest) & (~enscan) & (~tverify) & (~load_csr);
assign test_mode   = (entest)  & (~enscan) & (~tverify) & (~load_csr);
assign scan_mode   = (~entest) & (enscan)  & (~tverify) & (~load_csr);
assign verify_mode = (entest)  & (~enscan) & (tverify)  & (~load_csr);
assign jtag_mode   = (~entest) & (~enscan) & (~tverify) & (load_csr);

// csrdout muxing logic
assign csrdout     = (prog_mode == 1'b1)   ? csr_reg :
                     (test_mode == 1'b1)   ? tcsrin  :
                     (scan_mode == 1'b1)   ? ((~csr_seg & tcsrin) | (csr_seg & csrdin)) :
                     (verify_mode == 1'b1) ? ((~csr_seg & tcsrin) | (csr_seg & csrdin)) :
                     (jtag_mode == 1'b1)   ? ((~csr_seg & cbdin)  | (csr_seg & csrdin)) : 1'b0;
                   
endmodule                   
