// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module aib_adaptrxdp_word_align 
  #(
    parameter DWIDTH = 'd40             // FIFO Input data width 
    )
    (
    input  wire               wr_clk,      	  // clock
    input  wire               wr_rst_n,       	  // async reset
    input  wire               r_wa_en,            // Word-align enable  
    input  wire [DWIDTH-1:0]  aib_hssi_rx_data_in,    // Write Data In
    output wire		      wa_lock,		  // Go to FIFO, status reg
    output wire [19:0]	      word_align_testbus
    );
    

reg		        wm_bit;
reg		        wm_bit_d1;
reg		        wm_bit_d2;
reg		        wm_bit_d3;
reg		        wm_bit_d4;
reg		        wm_bit_d5;
reg			wa_lock_lt;
wire			wa_lock_int;
//********************************************************************
// Main logic 
//********************************************************************



//Word-align
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     wm_bit 	 <= 1'b0;
     wm_bit_d1 <= 1'b0;
     wm_bit_d2 <= 1'b0;
     wm_bit_d3 <= 1'b0;
     wm_bit_d4 <= 1'b0;
     wm_bit_d5 <= 1'b0;
   end
   else begin
     wm_bit 	 <= aib_hssi_rx_data_in[39];
     wm_bit_d1 <= wm_bit;
     wm_bit_d2 <= wm_bit_d1;
     wm_bit_d3 <= wm_bit_d2;
     wm_bit_d4 <= wm_bit_d3;
     wm_bit_d5 <= wm_bit_d4;
   end
end

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     wa_lock_lt 	 <= 1'b0;
   end
   else begin
     wa_lock_lt 	 <= wa_lock_int || wa_lock_lt;
   end
end

assign wa_lock_int = wm_bit && ~wm_bit_d1 && wm_bit_d2 && ~wm_bit_d3 && wm_bit_d4 && ~wm_bit_d5 || ~r_wa_en;

assign wa_lock = wa_lock_int || wa_lock_lt;



assign word_align_testbus = {13'd0, wa_lock, wm_bit, wm_bit_d1, wm_bit_d2, wm_bit_d3, wm_bit_d4, wm_bit_d5};
  
endmodule
