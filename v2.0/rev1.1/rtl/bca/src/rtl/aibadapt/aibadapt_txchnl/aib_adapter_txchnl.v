// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapter_txchnl(
   // Outputs
   output wire [79:0] dout, // AIB Data output
   // Inputs
   input              atpg_mode,      // Scan enable
   input              txwr_fifo_rstn, // Tx write fifo reset
   input              txrd_rstn,      // Tx read reset
   input              txrd_fifo_rstn, // Tx read fifo reset
   input              m_gen2_mode,    // AIB Generation 2.0 indication
   input              txfifo_wr_clk,  // Write clock
   input              tx_clk_adapter, // TX DLL clock to adapter
   input [319:0]      tx_adapt_din,   // FIFO mode data input
   input [79:0]       data_in,        // Register mode data input
   input              r_tx_dbi_en,    // Enable for tx data bus inversion
   input [1:0]        r_tx_fifo_mode, // TX FIFO mode register
   input [3:0]        r_tx_phcomp_rd_delay, // TX phase compensation register
   input              r_txswap_en,    // TX swapping enable
   input              r_tx_wm_en,     // Tx word mark enable
   input  [4:0]       r_tx_mkbit      // Selection of word mark bit
   );

wire [79:0]  fifo_dout;      // Output data from FIFO
wire [79:0]  merge_dout;     // Output slection based on operation mode
wire [79:0]  data_in_f_sel;  // Swapped data or input data to FIFO 

//Mux for bypass mode data and fifo data
assign merge_dout[79:0]= (r_tx_fifo_mode == 2'b11) ?
                          data_in[79:0] :
                          fifo_dout[79:0];

//Data bus inversion logic (DBI)
aib_tx_dbi txdbi 
  (
    .rst_n(txrd_rstn),     // Async, reset
    .clk(tx_clk_adapter),    // Near side forwarded clock
    .dbi_en(r_tx_dbi_en),  // DBI enable
    .data_in(merge_dout),  // Data to be inverted by DBI logic
    .data_out(dout)        // Data after DBI logic

  );
 
// Swapping logic used only in Gen 1 mode and 2xFIFO    
assign data_in_f_sel[79:0] =
     ((r_tx_fifo_mode == 2'b01) & r_txswap_en & ~m_gen2_mode)  ? 
       {tx_adapt_din[79],
        tx_adapt_din[38:0],
        tx_adapt_din[39],
        tx_adapt_din[78:40]} :
        tx_adapt_din[79:0];

// TX FIFO data path logic
aib_adapt_tx_fifo aib_adapt_tx_fifo (
  // Outputs
  .fifo_dout   (fifo_dout[79:0]), // FIFO data output
  // Inputs
  .data_in  ({tx_adapt_din[319:80], data_in_f_sel[79:0]}), // FIFO data input
  .r_fifo_mode        (r_tx_fifo_mode[1:0]),  // FIFO mode register
  .r_phcomp_rd_delay  (r_tx_phcomp_rd_delay[3:0]), // Tx phase compensation 
  .m_gen2_mode        (m_gen2_mode),          // Generation 2.0 mode
  .r_wm_en            (r_tx_wm_en),           // Tx swapping 
  .r_mkbit            (r_tx_mkbit[4:0]),      // Tx Mark bits
  .scan_en            (atpg_mode),            // Scan enable
  .wr_clk             (txfifo_wr_clk),        // Tx write clock
  .wr_rst_n           (txwr_fifo_rstn),       // Tx FIFO write reset
  .rd_clk             (tx_clk_adapter),       // TX DLL clock to adapter
  .rd_rst_n           (txrd_fifo_rstn)        // Tx FIFO read reset
);

endmodule // aib_adapter_txchnl
