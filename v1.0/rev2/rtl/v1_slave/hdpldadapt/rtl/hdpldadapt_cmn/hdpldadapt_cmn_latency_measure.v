// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_latency_measure 
   (
   // Inputs
   input  wire              s_clk,      	  // clock
   input  wire              s_rst_n,       // async reset
   input  wire [2:0]	    r_fifo_power_mode,
   input  wire              wr_addr_msb, 	// Write address MSB
   input  wire              rd_addr_msb, 	// Read address MSB
   input  wire              ps_wr_addr_msb, 	// Write address MSB
   input  wire              ps_rd_addr_msb, 	// Read address MSB
   input  wire              ps_dw_wr_addr_msb, 	// Write address MSB
   input  wire              ps_dw_rd_addr_msb, 	// Read address MSB

   // Outputs
   output reg  		    latency_pulse       // Latency pulse
   );


wire			    rd_addr_msb_sync;
wire			    wr_addr_msb_sync;

wire			    ps_rd_addr_msb_sync;
wire			    ps_wr_addr_msb_sync;

wire			    ps_dw_rd_addr_msb_sync;
wire			    ps_dw_wr_addr_msb_sync;

cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)   	// Reset Value
    )
    cdclib_bitsync2_wr
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (wr_addr_msb),
       .data_out (wr_addr_msb_sync)
       );

cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)    	// Reset Value 
    )
    cdclib_bitsync2_rd
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (rd_addr_msb),
       .data_out (rd_addr_msb_sync)
       );

   
cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)    	// Reset Value 
    )
    hd_dpcmn_bitsync2_ps_wr_msb
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (ps_wr_addr_msb),
       .data_out (ps_wr_addr_msb_sync)
       );

cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)    	// Reset Value 
    )
    hd_dpcmn_bitsync2_ps_rd_msb
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (ps_rd_addr_msb),
       .data_out (ps_rd_addr_msb_sync)
       );

cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)    	// Reset Value 
    )
    hd_dpcmn_bitsync2_ps_dw_wr_msb
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (ps_dw_wr_addr_msb),
       .data_out (ps_dw_wr_addr_msb_sync)
       );

cdclib_bitsync2 
  #(
    .DWIDTH      (1),    // Sync Data input 
    .CLK_FREQ_MHZ(500),
    .TOGGLE_TYPE (2), 
    .RESET_VAL   (0)    	// Reset Value 
    )
    hd_dpcmn_bitsync2_ps_dw_rd_msb
      (
       .clk       (s_clk),
       .rst_n     (s_rst_n),
       .data_in  (ps_dw_rd_addr_msb),
       .data_out (ps_dw_rd_addr_msb_sync)
       );
   
always @(negedge s_rst_n or posedge s_clk) begin
   if (~s_rst_n) begin
      latency_pulse      <= 1'b0;
   end
   else begin
      latency_pulse      <= r_fifo_power_mode[2] ? wr_addr_msb_sync ^ rd_addr_msb_sync : r_fifo_power_mode[1] ? ps_dw_wr_addr_msb_sync ^ ps_dw_rd_addr_msb_sync : ps_wr_addr_msb_sync ^ ps_rd_addr_msb_sync ;
   end
end

endmodule
