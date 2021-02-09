// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------


module aib_adaptrxdp_rxdp (

input wire  [40-1:0]	        din,	
input wire  [5-1:0]	        r_rx_fifo_empty,		
input wire  [1:0]		r_rx_fifo_mode,		        
input wire  [5-1:0]	        r_rx_fifo_full,		        
input wire  [5-1:0]	        r_rx_fifo_pempty,		
input wire  [5-1:0]	        r_rx_fifo_pfull,		
input wire  [2:0]		r_rx_phcomp_rd_delay,	        
input wire 			r_rx_wa_en,		                     

input wire 			rx_clock_fifo_rd_clk,	
input wire 			rx_reset_fifo_rd_rst_n,	
input wire 			rx_clock_fifo_wr_clk,
input wire			rx_reset_fifo_wr_rst_n,

output wire 			wa_error,		
output wire  [3:0]		wa_error_cnt,		
output wire  [79:0] 		rx_fifo_data_out,
output wire			align_done


);


localparam		DWIDTH = 40;
localparam		CNTWIDTH = 8;
localparam		AWIDTH = 5;


wire 			phcomp_rden;
wire 			phcomp_wren;

wire 			rd_clk;
wire 			rd_rst_n;	
wire 			wr_clk;
wire 			wr_rst_n;

wire 			rx_rdfifo_clk;		
wire 			rx_wrfifo_clk;
wire 			fifo_srst_n_rd_clk;
wire 			fifo_srst_n_wr_clk;


wire 			fifo_pempty;
wire 			fifo_pfull;

wire 			rd_en_reg;

wire 		        fifo_empty_int;
wire                    fifo_full_int;

wire  [5-1:0]	        r_empty =			r_rx_fifo_empty;		
wire  [1:0]		r_fifo_mode =			r_rx_fifo_mode;		
wire  [5-1:0]	        r_full =			r_rx_fifo_full;			
wire  [5-1:0]	        r_pempty =			r_rx_fifo_pempty;		
wire  [5-1:0]	        r_pfull =			r_rx_fifo_pfull;		
wire  [2:0]		r_phcomp_rd_delay =		r_rx_phcomp_rd_delay;	
wire 			r_wa_en =			r_rx_wa_en;		




assign rd_clk		= rx_clock_fifo_rd_clk;
assign rx_rdfifo_clk	= rx_clock_fifo_rd_clk;

assign wr_clk		= rx_clock_fifo_wr_clk;
assign rx_wrfifo_clk	= rx_clock_fifo_wr_clk;

assign rd_rst_n		= rx_reset_fifo_rd_rst_n;
assign wr_rst_n		= rx_reset_fifo_wr_rst_n;


assign align_done	= rd_en_reg;

   
aib_adaptrxdp_fifo rxdp_fifo(
    // Outputs
    .rx_fifo_data_out	  (rx_fifo_data_out[2*DWIDTH-1:0]),
    .rd_en_reg		  (rd_en_reg),
    .fifo_empty		  (fifo_empty_int),
    .fifo_pempty	  (fifo_pempty),
    .fifo_pfull		  (fifo_pfull),
    .fifo_full		  (fifo_full_int),
    .wa_error		  (wa_error),
    .wa_error_cnt	  (wa_error_cnt[3:0]),

    // Inputs
    .wr_rst_n		  (wr_rst_n),
    .wr_clk		  (wr_clk),
    .aib_hssi_rx_data_in  (din[DWIDTH-1:0]),
    .rd_rst_n		  (rd_rst_n),
    .rd_clk		  (rd_clk),
    .r_pempty		  (r_pempty[AWIDTH-1:0]),
    .r_pfull		  (r_pfull[AWIDTH-1:0]),
    .r_empty		  (r_empty[AWIDTH-1:0]),
    .r_full		  (r_full[AWIDTH-1:0]),
    .r_stop_read	  (r_stop_read),
    .r_stop_write	  (r_stop_write),
    .r_double_read	  (r_double_read),
    .r_fifo_mode	  (r_fifo_mode[1:0]),
    .r_phcomp_rd_delay	  (r_phcomp_rd_delay[2:0]),
    .r_wa_en		  (r_wa_en));


endmodule
