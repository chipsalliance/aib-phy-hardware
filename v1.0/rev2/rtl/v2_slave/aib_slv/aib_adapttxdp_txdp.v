// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------

module aib_adapttxdp_txdp (

//input  wire                     tx_elane_clk,
//input  wire                     tx_elane_rst_n,
input  wire [77:0]		data_in,	
input  wire			r_tx_double_write,		
input  wire [5-1:0]	        r_tx_fifo_empty,		
input  wire [1:0]		r_tx_fifo_mode,		
input  wire [5-1:0]	        r_tx_fifo_full,			
input  wire [5-1:0]	        r_tx_fifo_pempty,		
input  wire [5-1:0]	        r_tx_fifo_pfull,		
input  wire [2:0]		r_tx_phcomp_rd_delay,	

input  wire			r_tx_stop_read,		
input  wire			r_tx_stop_write,	
input  wire			r_tx_wm_en,		
input wire [2:0]	        r_tx_stretch_num_stages, 
input wire 		        r_tx_wr_adj_en, 
input wire                      r_tx_rd_adj_en,
input wire			tx_fifo_latency_adj_en,
input  wire			tx_clock_fifo_wr_clk,	
input wire 			q1_tx_clock_fifo_wr_clk,
input  wire			tx_reset_fifo_wr_rst_n,	
input wire 			tx_clock_fifo_rd_clk,   
input wire 			tx_reset_fifo_rd_rst_n,

input wire                      rx_aib_lpbk_en,    //loopback path from rxfifo output enable
input wire [79:0]               rx_fifo_lpbk_data, //loopback data from rxfifo output

output wire [40-1:0]		fifo_dout,	 

output wire			fifo_empty,		 
output wire			fifo_full,		 

output wire			tx_fifo_ready,

output wire [19:0]		tx_fifo_testbus1,
output wire [19:0]		tx_fifo_testbus2

);

localparam		DWIDTH = 40;
localparam		CNTWIDTH = 8;
localparam		AWIDTH = 5;

wire			double_write;
wire			double_write_int;

wire 			phcomp_rden;
wire 			phcomp_wren;

wire 			rd_clk;
wire 			rd_rst_n;	
wire 			wr_clk;
wire			q1_wr_clk;
wire 			wr_rst_n;

wire 			fifo_srst_n_rd_clk;
wire 			fifo_srst_n_wr_clk;

wire [79:0]		wm_data;
wire [79:0]		fifo_data_in;

wire [77:0]		word_marker_data;

wire			fifo_pempty;			// To be connected to TB
wire			fifo_pfull;			// To be connected to TB

wire 		        fifo_empty_int;
wire                    fifo_full_int;
wire			compin_sel_rden;
wire			compin_sel_wren;
   
// Add _tx to DPRIO bit name
wire			r_double_write =		r_tx_double_write;		
wire [5-1:0]	        r_empty =			r_tx_fifo_empty;		
wire [1:0]		r_fifo_mode =			r_tx_fifo_mode;		
wire [5-1:0]	        r_full =			r_tx_fifo_full;			
wire [5-1:0]	        r_pempty =			r_tx_fifo_pempty;		
wire [5-1:0]	        r_pfull =			r_tx_fifo_pfull;		
wire [2:0]		r_phcomp_rd_delay =		r_tx_phcomp_rd_delay;	
wire			r_stop_read =			r_tx_stop_read;		
wire			r_stop_write =			r_tx_stop_write;		
wire			r_wm_en =			r_tx_wm_en;		
wire			r_wr_adj_en 	  =	     	r_tx_wr_adj_en;
wire			r_rd_adj_en       =		r_tx_rd_adj_en;     

//wire                    latency_pulse_mux1;
//wire                    xcvrif_latency_sel;

assign double_write  = double_write_int;

assign rd_clk		= tx_clock_fifo_rd_clk;

assign wr_clk		= tx_clock_fifo_wr_clk;
assign q1_wr_clk	= q1_tx_clock_fifo_wr_clk;


assign rd_rst_n		= tx_reset_fifo_rd_rst_n;
assign wr_rst_n		= tx_reset_fifo_wr_rst_n;




// Output of work-mark --> input of FIFO
assign fifo_data_in = (rx_aib_lpbk_en ) ? rx_fifo_lpbk_data[79:0] :
                      r_wm_en ? {1'b1, data_in[77:39], 1'b0, data_in[38:0]} : {2'b0,data_in[77:0]};

//assign wm_data	    = (rx_aib_lpbk_en ) ? rx_fifo_lpbk_data[79:0] : {1'b0,data_in[77:39],1'b0,data_in[38:0]};


aib_adapttxdp_fifo txdp_fifo(
  // Outputs
  .aib_hssi_tx_data_out     (fifo_dout[DWIDTH-1:0]),
  .fifo_empty		    (fifo_empty_int),
  .fifo_pempty	            (fifo_pempty),
  .fifo_pfull               (fifo_pfull),
  .fifo_full                (fifo_full_int),
  .phcomp_wren	            (phcomp_wren),
  .phcomp_rden	            (phcomp_rden),
  .double_write_int	    (double_write_int),
  .fifo_ready		    (tx_fifo_ready),
  .tx_fifo_testbus1	    (tx_fifo_testbus1),
  .tx_fifo_testbus2	    (tx_fifo_testbus2),

  // Inputs
  .wr_rst_n                 (wr_rst_n),
  .wr_clk                   (wr_clk),
  .q1_wr_clk                (q1_wr_clk),
  .direct_data              (data_in[DWIDTH-1:0]),
  .data_in                  (fifo_data_in[2*DWIDTH-1:0]),
  .rd_rst_n                 (rd_rst_n),
  .rd_clk                   (rd_clk),
  .r_pempty                 (r_pempty[AWIDTH-1:0]),
  .r_pfull                  (r_pfull[AWIDTH-1:0]),
  .r_empty                  (r_empty[AWIDTH-1:0]),
  .r_full                   (r_full[AWIDTH-1:0]),
  .r_double_write           (r_double_write),
  .r_fifo_mode	            (r_fifo_mode[1:0]),
  .r_phcomp_rd_delay        (r_phcomp_rd_delay[2:0]),
  .r_wr_adj_en              (r_wr_adj_en),
  .r_rd_adj_en              (r_rd_adj_en),
  .fifo_latency_adj         (tx_fifo_latency_adj_en));


// Pulse-stretch signals before being capture by osc_clk
// Flag pulse-stretch
   aib_adapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) cmn_pulse_stretch_fifo_full
     (
      .clk           (wr_clk),
      .rst_n         (wr_rst_n),             
      .num_stages    (r_tx_stretch_num_stages),
      .data_in       (fifo_full_int),
      .data_out      (fifo_full)                      
      );

   aib_adapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (1)    	// Reset Value 
       ) cmn_pulse_stretch_fifo_empty
     (
      .clk           (rd_clk),
      .rst_n         (rd_rst_n),             
      .num_stages    (r_tx_stretch_num_stages),
      .data_in       (fifo_empty_int),
      .data_out      (fifo_empty)                      
      );

endmodule
