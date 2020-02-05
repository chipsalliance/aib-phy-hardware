// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_tx_datapath_pulse_stretch.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2014/09/23 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_tx_datapath_pulse_stretch
    (
    input  wire         clk,                   // clock
    input  wire         rst_n,                 // async reset
    input  wire         tx_frame_raw,          // input to stretch
    input  wire         burst_en_exe_raw,   //  input to stretch
    input  wire         wordslip_exe_raw,   //  input to stretch
    input  wire         rd_empty_raw,        //  input to stretch
    input  wire         rd_pempty_raw,       //  input to stretch

    input  wire [2:0]   r_stretch_num_stages,  // # stages sel
    output  wire        tx_frame,              // stretched output
    output  wire        tx_burst_en_exe,       //  stretched output
    output  wire        tx_wordslip_exe,       //  stretched output
    output  wire        rd_empty_stretch,      //  stretched output
    output  wire        rd_pempty_stretch      //  stretched output

    );

   wire [2:0]           num_stages;
   
   assign num_stages = r_stretch_num_stages;

   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_tx_wordslip_exe
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (wordslip_exe_raw),
      .data_out      (tx_wordslip_exe)                      
      ); 

   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_tx_burst_en_exe
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (burst_en_exe_raw),
      .data_out      (tx_burst_en_exe)                      
      ); 
   
   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_tx_frame_raw
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (tx_frame_raw),
      .data_out      (tx_frame)                      
      ); 

// Flag pulse-stretch
   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (1)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_rd_empty
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (rd_empty_raw),
      .data_out      (rd_empty_stretch)                      
      );

   hdpldadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (1)    	// Reset Value 
       ) hdpldadapt_cmn_pulse_stretch_rd_pempty
     (
      .clk           (clk),
      .rst_n         (rst_n),             
      .num_stages    (num_stages),
      .data_in       (rd_pempty_raw),
      .data_out      (rd_pempty_stretch)                      
      );
      
endmodule      
