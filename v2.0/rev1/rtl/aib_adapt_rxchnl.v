// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapt_rxchnl(
   // Outputs
 
output wire [319:0]             data_out_f,
output wire [79:0]              data_out,
output wire                     align_done,
   // Inputs
input wire                      atpg_mode,
input wire                      m_gen2_mode,
input wire                      adapt_rstn,
input wire                      rx_fifo_rstn,
input wire  [79:0]	        din,   //from io buffer
input wire                      m_rd_clk, 
input wire                      rxfifo_wrclk,
input wire  [1:0]		r_rx_fifo_mode,		        
input wire  [3:0]		r_rx_phcomp_rd_delay,	        
input wire 			r_rx_wa_en,		                     
input wire                      r_rxswap_en,
input wire  [4:0]               r_rx_mkbit,
input wire 			r_rx_dbi_en		                     
   );

wire [79:0]  dbi_dout, rx_fifo_data_out_sel;
wire [319:0] rx_fifo_data_out;
wire         rxwr_rstn, rxrd_rstn;
wire         rxwr_fifo_rstn, rxrd_fifo_rstn;

assign data_out_f =  {rx_fifo_data_out[319:80], rx_fifo_data_out_sel};
assign data_out   =  dbi_dout;

assign rx_fifo_data_out_sel[79:0] =((r_rx_fifo_mode==2'b01) & r_rxswap_en & ~m_gen2_mode) ? {rx_fifo_data_out[79], rx_fifo_data_out[38:0], rx_fifo_data_out[39], rx_fifo_data_out[78:40]} : rx_fifo_data_out[79:0];

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
    .align_done           (align_done),

    // Inputs
    .wr_rst_n             (rxwr_fifo_rstn),
    .wr_clk               (rxfifo_wrclk),
    .fifo_din             (dbi_dout),
    .rd_rst_n             (rxrd_fifo_rstn),
    .rd_clk               (m_rd_clk),
    .r_pempty             (5'b0),
    .r_pfull              (5'b11111),
    .r_empty              (5'b0),
    .r_full               (5'b11111),
    .m_gen2_mode          (m_gen2_mode),
    .r_fifo_mode          (r_rx_fifo_mode[1:0]),
    .r_phcomp_rd_delay    (r_rx_phcomp_rd_delay),
    .r_mkbit              (r_rx_mkbit),
    .r_wa_en              (r_rx_wa_en));


aib_rstnsync rxwr_rstnsync
  (
    .clk(rxfifo_wrclk),               // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(rxwr_rstn)            // Synchronized reset output

   );

aib_rstnsync rxwr_fifo_rstnsync
  (
    .clk(rxfifo_wrclk),              
    .i_rst_n(rx_fifo_rstn),           
    .scan_mode(atpg_mode),         
    .sync_rst_n(rxwr_fifo_rstn)        

   );

aib_rstnsync rxrd_rstnsync
  (
    .clk(m_rd_clk),                   // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(rxrd_rstn)            // Synchronized reset output

   );

aib_rstnsync rxrd_fifo_rstnsync
  (
    .clk(m_rd_clk),                
    .i_rst_n(rx_fifo_rstn),         
    .scan_mode(atpg_mode),       
    .sync_rst_n(rxrd_fifo_rstn)      

   );

endmodule
