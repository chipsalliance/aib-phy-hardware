// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapter_rxchnl(
   // Outputs
output wire [319:0] rx_adapt_dout, // FIFO mode data output
output wire [79:0]  data_out,   // Register mode data output
output wire         align_done, // Word Mark alignment done
   // Inputs
input        atpg_mode,      // Scan enabled
input        m_gen2_mode,    // Generation 2.0 mode
input        rxrd_fifo_rstn, // RX FIFO read reset
input        rxwr_rstn,      // RX write reset
input        rxwr_fifo_rstn, // RX FIFO write reset
input [79:0] din,            // Data input from io buffer
input        rxfifo_rd_clk,  // Read clock
input        rxfifo_wrclk,   // FIFO write clock
input [1:0]  r_rx_fifo_mode, // FIFO mode register
input [4:0]  rx_align_threshold, // RX FIFO WAM threshold
input [3:0]  r_rx_phcomp_rd_delay, // Phase compensation register
input        r_rx_wa_en,      // RX word aligment enable
input        rx_wa_mode_sync, // Rx word alignment mode bit
input        r_rxswap_en,     // RX swapping enable
input [4:0]  r_rx_mkbit,      // Selection of Rx word mark bit
input        r_rx_dbi_en      // Enable for Rx data bus inversion
   );

// Wires
wire [79:0]  dbi_dout;             // Output of data bus inversion
wire [79:0]  rx_fifo_data_out_sel; // Swapped data or input data to FIFO
wire [319:0] rx_fifo_data_out;     // Output from FIFO registered

// FIFO data output
assign rx_adapt_dout =  {rx_fifo_data_out[319:80], rx_fifo_data_out_sel};

// Data output after DBI logic
assign data_out   =  dbi_dout;

// Data after swapping logic.
// Swapping is used only for FIFO 2x with generation 1
assign rx_fifo_data_out_sel[79:0] =
  ((r_rx_fifo_mode==2'b01) & r_rxswap_en & ~m_gen2_mode) ?
    {rx_fifo_data_out[79],
     rx_fifo_data_out[38:0],
     rx_fifo_data_out[39],
     rx_fifo_data_out[78:40]} :
     rx_fifo_data_out[79:0];

// DBI logic
aib_rx_dbi rx_dbi (
 // Inputs
 .rst_n(rxwr_rstn),    // Async reset
 .clk(rxfifo_wrclk),   // FIFO write clock
 .data_in(din),        // Data input
 .dbi_en(r_rx_dbi_en), // Data bus inversion
 // Outputs
 .data_out(dbi_dout)   // Data bus inversion output
);

// RX FIFO data path logic
aib_adapt_rx_fifo aib_adapt_rx_fifo(
// Outputs
.fifo_dout         (rx_fifo_data_out), // FIFO data output registered
.align_done        (align_done),       // Word mark alignment done
// Inputs
.wr_rst_n          (rxwr_fifo_rstn), // Rx FIFO write reset   
.wr_clk            (rxfifo_wrclk),   // Rx FIFO write clock
.fifo_din          (dbi_dout),       // FIFO input
.rd_rst_n          (rxrd_fifo_rstn), // Rx FIFO read reset
.rd_clk            (rxfifo_rd_clk),   // FIFO Read clock
.scan_en           (atpg_mode),      // Scan enable
.m_gen2_mode       (m_gen2_mode),    // Generation mode
.r_fifo_mode       (r_rx_fifo_mode[1:0]),  // RX FIFO mode configuration
.rx_align_threshold (rx_align_threshold[4:0]), // RX FIFO WAM threshold
.r_phcomp_rd_delay (r_rx_phcomp_rd_delay[3:0]), // RX FIFO phase compensation
.r_mkbit           (r_rx_mkbit[4:0]),      // RX Mark bits
.rx_wa_mode_sync   (rx_wa_mode_sync),      // Word alignment mode bit
.r_wa_en           (r_rx_wa_en)            // Word alignment enable
);

endmodule // aib_adapter_rxchnl
