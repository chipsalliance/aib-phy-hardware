// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapt_rxchnl(
   // Outputs
 
output wire [77:0]                   data_out,
output wire [79:0]                   rx_fifo_data_out_sel,
output wire [39:0]                   reg_dout, //reg mode output
output wire                          align_done,
output wire                          rxfifo_wrclk,
   // Inputs
input wire                      atpg_mode,
input wire                      rxswap_en,
input wire                      adapt_rstn,
input wire  [39:0]	        din,   //from io buffer
input wire  [39:0]              dout,  //loopback data from tx to io buffer
input wire                      ns_fwd_clk, //loopback clock from tx
input wire                      fs_fwd_clk, 
input wire                      m_rd_clk, 
input wire			rx_fifo_latency_adj_en,
input wire 			r_rx_double_read,		
input wire  [1:0]		r_rx_fifo_mode,		        
input wire                      r_rx_lpbk,
input wire  [2:0]		r_rx_phcomp_rd_delay,	        
input wire 			r_rx_wa_en,		                     
input wire 		        r_rx_wr_adj_en, 
input wire                      r_rx_rd_adj_en
   );

wire loopback1;
wire [39:0] din_sel;
wire [79:0] r_fifo_dout, rx_fifo_data_out;
wire        rxwr_rstn, rxrd_rstn, wa_error;

assign loopback1 = r_rx_lpbk;
assign din_sel[39:0] = loopback1 ? dout[39:0] :din[39:0];

assign data_out[77:0] = (r_rx_fifo_mode==2'b11) ? {38'b0,reg_dout[39:0]} :
                        (r_rx_fifo_mode==2'b00) ? {39'b0, r_fifo_dout[39:0]} :
                        {r_fifo_dout[78:40], r_fifo_dout[38:0]};

assign rx_fifo_data_out_sel[79:0] =((r_rx_fifo_mode==2'b01) & rxswap_en) ? {rx_fifo_data_out[79], rx_fifo_data_out[38:0], rx_fifo_data_out[39], rx_fifo_data_out[78:40]} : rx_fifo_data_out[79:0];

aib_adaptrxdp_map  aib_adaptrxdp_map (

  .din(din_sel[39:0]),
  .rx_fifo_data_out(rx_fifo_data_out_sel[79:0]),      // Data from rx fifo
  .rx_aib_transfer_clk(rxfifo_wrclk),
  .rx_aib_transfer_rst_n(rxwr_rstn),
  .rx_clock_fifo_rd_clk(m_rd_clk),
  .rx_reset_fifo_rd_rst_n(rxrd_rstn),
  .r_fifo_dout(r_fifo_dout[79:0]),
  .reg_dout(reg_dout[39:0])
);



aib_adaptrxdp_rxdp rx_datapath (
    // Outputs
    .rx_fifo_data_out           (rx_fifo_data_out[79:0]),
    .align_done		        (align_done),
    .wa_error		        (wa_error),
    .wa_error_cnt		(),
    .rx_fifo_testbus1	        (),
    .rx_fifo_testbus2 	        (), 
    .word_align_testbus	        (),
    
    // Inputs
    .din	                (din_sel[39:0]),
    .r_rx_double_read	        (r_rx_double_read),
    .r_rx_fifo_empty	        (5'b0),
    .r_rx_fifo_mode	        (r_rx_fifo_mode[1:0]),
    .r_rx_fifo_full	        (5'b11111),
    .r_rx_fifo_pempty	        (5'b0),
    .r_rx_fifo_pfull	        (5'b11111),
    .r_rx_phcomp_rd_delay	(r_rx_phcomp_rd_delay[2:0]),
    .r_rx_stop_read	        (1'b1),
    .r_rx_stop_write	        (1'b1),
    .r_rx_wa_en		        (r_rx_wa_en),
    .r_rx_wr_adj_en             (r_rx_wr_adj_en), 
    .r_rx_rd_adj_en             (r_rx_rd_adj_en),
    .rx_fifo_latency_adj_en     (rx_fifo_latency_adj_en),
    .rx_clock_fifo_rd_clk       (m_rd_clk),
    .rx_reset_fifo_rd_rst_n     (rxrd_rstn),
    .rx_clock_fifo_wr_clk	(rxfifo_wrclk),
    .q1_rx_clock_fifo_wr_clk    (rxfifo_wrclk),
    .rx_reset_fifo_wr_rst_n     (rxwr_rstn));


c3lib_mux2_ctn rxfifo_wrclk_mux (
    .ck_out      (rxfifo_wrclk),
    .ck0         (fs_fwd_clk),
    .ck1         (ns_fwd_clk),
    .s0          (loopback1)
                                );


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
