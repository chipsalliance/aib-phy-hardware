// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapt_rxchnl(
   // Outputs
 
output wire [319:0]             data_out_f,
output wire [79:0]              data_out,
output wire                     align_done,
output wire                     wa_error,
output wire [3:0]               wa_error_cnt,
   // Inputs
input wire                      atpg_mode,
input wire                      adapt_rstn,
input wire  [79:0]	        din,   //from io buffer
input wire                      m_rd_clk, 
input wire                      rxfifo_wrclk,
input wire  [1:0]		r_rx_fifo_mode,		        
input wire  [3:0]		r_rx_phcomp_rd_delay,	        
input wire 			r_rx_wa_en,		                     
input wire 			r_rx_dbi_en		                     
   );

wire [79:0]  dbi_dout;
wire [319:0] rx_fifo_data_out;
wire         rxwr_rstn, rxrd_rstn;

assign data_out_f =  rx_fifo_data_out;
assign data_out   =  dbi_dout;

aib_adaptrxdbi_rxdp rx_dbi (
    .rst_n(rxwr_rstn),
    .clk(rxfifo_wrclk),
    .data_in(din),
    .dbi_en(r_rx_dbi_en),

    .data_out(dbi_dout)
   );

aib_adaptrxdp_fifo rxdp_fifo(
    // Outputs
    .fifo_dout            (rx_fifo_data_out),
    .fifo_empty           (fifo_empty),
    .fifo_pempty          (fifo_pempty),
    .fifo_pfull           (fifo_pfull),
    .fifo_full            (fifo_full_int),
    .wa_error             (wa_error),
    .wa_error_cnt         (wa_error_cnt[3:0]),
    .align_done           (align_done),

    // Inputs
    .wr_rst_n             (rxwr_rstn),
    .wr_clk               (rxfifo_wrclk),
    .fifo_din             (dbi_dout),
    .rd_rst_n             (rxrd_rstn),
    .rd_clk               (m_rd_clk),
    .r_pempty             (5'b0),
    .r_pfull              (5'b11111),
    .r_empty              (5'b0),
    .r_full               (5'b11111),
    .r_fifo_mode          (r_rx_fifo_mode[1:0]),
    .r_phcomp_rd_delay    (r_rx_phcomp_rd_delay),
    .r_wa_en              (r_rx_wa_en));


aib_rstnsync rxwr_rstnsync
  (
    .clk(rxfifo_wrclk),               // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(rxwr_rstn)            // Synchronized reset output

   );

aib_rstnsync rxrd_rstnsync
  (
    .clk(m_rd_clk),                   // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(rxrd_rstn)            // Synchronized reset output

   );


endmodule
