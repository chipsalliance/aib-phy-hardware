// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapt_txchnl(
   // Outputs
   output wire [79:0] dout,    
// output wire        ns_fwd_clk,
   // Inputs
   input              atpg_mode, 
   input              adapt_rstn, 
   input              m_wr_clk,
   input              m_ns_fwd_clk,  
   input [319:0]      data_in_f,   //FIFO mode 
   input [79:0]       data_in,     //register mode
   input              r_tx_dbi_en,
   input [1:0]        r_tx_fifo_mode, 
   input [3:0]        r_tx_phcomp_rd_delay,
   input              r_tx_wm_en 
   );

wire         fifo_empty, fifo_full;
wire [79:0]  fifo_dout, merge_dout;
wire         txrd_rstn, txfifo_wrclk, txwr_rstn;

//Mux for bypass mode data and fifo data
assign merge_dout[79:0]= (r_tx_fifo_mode == 2'b11) ?  data_in[79:0] : fifo_dout[79:0];

//DBI mux
aib_adapttxdbi_txdp txdbi 
  (
    .rst_n(txrd_rstn),
    .clk(m_ns_fwd_clk),
    .dbi_en(r_tx_dbi_en),
    .data_in(merge_dout),
    .data_out(dout)

  );
    

aib_adapttxdp_fifo txdp_fifo (
  // Outputs
  .fifo_dout	                          (fifo_dout[79:0]),
  .fifo_empty		                  (fifo_empty),
  .fifo_full		                  (fifo_full),
  .fifo_pfull                             (),
  .fifo_pempty                            (),
  // Inputs
  .data_in                                (data_in_f[319:0]),
  .r_empty	                          (5'b0),
  .r_fifo_mode	                          (r_tx_fifo_mode[1:0]),
  .r_full	                          (5'b11111),
  .r_pempty	                          (5'b0),
  .r_pfull	                          (5'b11111),
  .r_phcomp_rd_delay	                  (r_tx_phcomp_rd_delay),

  .r_wm_en		                  (r_tx_wm_en),
  .wr_clk	                          (m_wr_clk),
  .wr_rst_n                               (txwr_rstn),
  .rd_clk	                          (m_ns_fwd_clk),
  .rd_rst_n                               (txrd_rstn)
);


aib_rstnsync txwr_rstnsync
  (
    .clk(m_wr_clk),               // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(txwr_rstn)            // Synchronized reset output

   );

aib_rstnsync txrd_rstnsync
  (
    .clk(m_ns_fwd_clk),                   // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(txrd_rstn)            // Synchronized reset output

   );

endmodule
