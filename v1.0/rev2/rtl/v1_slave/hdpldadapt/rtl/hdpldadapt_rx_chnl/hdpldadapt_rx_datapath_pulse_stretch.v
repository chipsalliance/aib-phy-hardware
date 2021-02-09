// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_rx_datapath_pulse_stretch.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2014/09/23 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_rx_datapath_pulse_stretch
    (
    input  wire         clk,             // clock
    input  wire         rst_n,          // async reset
    input  wire         wr_pfull_raw,        //  input to stretch 
    input  wire         wr_full_raw,         //  input to stretch 
    input  wire         rx_fifo_del_raw,

    input  wire [2:0]   r_stretch_num_stages, // # stages
    
    output  wire        rx_fifo_del,
    output  wire        wr_pfull_stretch,      //  stretched output 
    output  wire        wr_full_stretch        //  stretched output 

     );

   wire [2:0]           num_stages;
   
   assign num_stages = r_stretch_num_stages;
   
   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_fifo_del
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (rx_fifo_del_raw),
      .data_out      (rx_fifo_del)                      
      ); 

// Flag pulse-stretch
   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_wr_full
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (wr_full_raw),
      .data_out      (wr_full_stretch)                      
      );

   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_wr_pfull
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (wr_pfull_raw),
      .data_out      (wr_pfull_stretch)                      
      );
      
endmodule      
