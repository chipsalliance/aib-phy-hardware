// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapt_txchnl(
   // Outputs
   output wire [39:0] dout, 
   output wire        ns_fwd_clk,
   // Inputs
   input              atpg_mode, 
   input              txswap_en, 
   input              adapt_rstn, 
   input              m_wr_clk,
   input              m_ns_fwd_clk,
   input [77:0]       data_in, 
   input [79:0]       rx_fifo_data_out, //loopback data from rx fifo mode
   input [39:0]       rx_reg_dout,      //loopback data from rx reg mode
   input [39:0]       din,              //loopback data from rx aib io 
   input              m_rd_clk,         //loopback clock for rx fifo mode
   input              fs_fwd_clk,       //loopback clock for rx reg mode loopback
   input              rxfifo_wrclk,     //loopback2 clock 
   input              r_tx_double_write,
   input [1:0]        r_tx_fifo_mode, 
   input [1:0]        r_tx_adapter_lpbk_mode, //tx loopback mode:00 no lpbk. 01 lpbk 2, 10 lpbk 3 reg, 11 lpbk 3 fifo 
   input [2:0]        r_tx_phcomp_rd_delay,
   input              r_tx_wm_en, 
   input              r_tx_wr_adj_en,
   input              r_tx_rd_adj_en,
   input              r_tx_fifo_latency_adj_en
   );

wire			fifo_empty;
wire			fifo_full;

wire [39:0]   reg_din, reg_dout, fifo_dout;
wire          loopback2, loopback3_reg, loopback3_fifo;
wire          txrd_rstn, tx_fifo_ready, txfifo_wrclk, txwr_rstn;
wire          loopbk2_3reg;
wire          reg_clk, regmd_rstn;
wire [77:0]   data_in_sel; 

assign loopback2 = (r_tx_adapter_lpbk_mode[1:0] == 2'b01);
assign loopback3_reg = (r_tx_adapter_lpbk_mode[1:0] == 2'b10);
assign loopback3_fifo = (r_tx_adapter_lpbk_mode[1:0] == 2'b11);
assign loopbk2_3reg = loopback2 | loopback3_reg;

assign dout[39:0]= loopback2 ? din[39:0] :
                   (r_tx_fifo_mode == 2'b11) ? reg_dout[39:0] : fifo_dout[39:0];

assign reg_din[39:0]= loopback3_reg ? rx_reg_dout[39:0] : data_in[39:0];

assign data_in_sel[77:0] = ((r_tx_fifo_mode == 2'b01) & txswap_en) ? {data_in[38:0], data_in[77:39]} : data_in[77:0];

c3lib_mux2_ctn reg_clk_mux (
    .ck_out      (reg_clk),
    .ck0         (m_ns_fwd_clk),
    .ck1         (fs_fwd_clk),
    .s0          (loopback3_reg)
                                );

aib_rstnsync regmd_rstnsync
  (
    .clk(reg_clk),                   // Destination clock of reset to be synced
    .i_rst_n(adapt_rstn),             // Asynchronous reset input
    .scan_mode(atpg_mode),            // Scan bypass for reset
    .sync_rst_n(regmd_rstn)            // Synchronized reset output

   );

aib_adapttxdp_reg txdp_reg (
  // Outputs
  .reg_dout	      (reg_dout[39:0]),
  // Inputs
  .tx_clock_fifo_rd_clk               (reg_clk),
  .tx_reset_fifo_rd_rst_n             (regmd_rstn),
  .r_tx_fifo_mode                     (r_tx_fifo_mode),
  .data_in                            (reg_din[39:0])
);

aib_adapttxdp_txdp tx_datapath (
  // Outputs
  .fifo_dout	                          (fifo_dout[39:0]),
  .fifo_empty		                  (fifo_empty),
  .fifo_full		                  (fifo_full),
  .tx_fifo_ready	                  (tx_fifo_ready),
  .tx_fifo_testbus1	                  (),
  .tx_fifo_testbus2 	                  (), 
  // Inputs
  .data_in                                (data_in_sel[77:0]),
  .r_tx_double_write	                  (r_tx_double_write),
  .r_tx_fifo_empty	                  (5'b0),
  .r_tx_fifo_mode	                  (r_tx_fifo_mode[1:0]),
  .r_tx_fifo_full	                  (5'b11111),
  .r_tx_fifo_pempty	                  (5'b0),
  .r_tx_fifo_pfull	                  (5'b11111),
  .r_tx_phcomp_rd_delay	                  (r_tx_phcomp_rd_delay[2:0]),

  .r_tx_stop_read	                  (1'b1),
  .r_tx_stop_write	                  (1'b1),
  .r_tx_wm_en		                  (r_tx_wm_en),
  .r_tx_stretch_num_stages		  (3'b001), 	
  .r_tx_wr_adj_en 			  (r_tx_wr_adj_en), 
  .r_tx_rd_adj_en			  (r_tx_rd_adj_en),
  .tx_fifo_latency_adj_en                 (r_tx_fifo_latency_adj_en),
  .rx_aib_lpbk_en                         (loopback3_fifo),
  .rx_fifo_lpbk_data			  (rx_fifo_data_out),
  .tx_clock_fifo_wr_clk	                  (txfifo_wrclk),
  .q1_tx_clock_fifo_wr_clk                (txfifo_wrclk),
  .tx_reset_fifo_wr_rst_n                 (txwr_rstn),
  .tx_clock_fifo_rd_clk	                  (m_ns_fwd_clk),
  .tx_reset_fifo_rd_rst_n                 (txrd_rstn)
);

c3lib_mux2_ctn txfifo_wrclk_mux (
    .ck_out      (txfifo_wrclk),
    .ck0         (m_wr_clk),
    .ck1         (m_rd_clk),
    .s0          (loopback3_fifo)
                                );
c3lib_mux2_ctn ns_fwd_clk_mux (
    .ck_out      (ns_fwd_clk),
    .ck0         (m_ns_fwd_clk),
    .ck1         (rxfifo_wrclk),
    .s0          (loopbk2_3reg)
                                );


aib_rstnsync txwr_rstnsync
  (
    .clk(txfifo_wrclk),               // Destination clock of reset to be synced
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
