// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// File:        $RCSfile: c3aibadapt_cmn_cp_dist_pair.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2016/07/18 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module c3aibadapt_cmn_cp_dist_pair
  #(
    parameter ASYNC_RESET_VAL = 'd0,   // Asynchronous reset value
    parameter WIDTH         = 'd1   // Control width
    )
    (
    input  wire                clk,                        // clock 
    input  wire                rst_n,                      // async reset
    input  wire                srst_n,                   // sync reset
    input wire                 data_enable,                // data enable / data valid
    input  wire [WIDTH-1:0]    master_in,                  // master control signal
    input  wire [WIDTH-1:0]    us_in,                  // CP distributed signal in up
    input  wire [WIDTH-1:0]    ds_in,                 // CP distributed signal in dwn
    input  wire                r_us_master,            // CRAM to control master or distributed up
    input  wire                r_ds_master,           // CRAM to control master or distributed dwn
    input  wire                r_us_bypass_pipeln,     // CRAM combo or registered up
    input  wire                r_ds_bypass_pipeln,    // CRAM combo or registered dwn
    output  wire [WIDTH-1:0]   us_out,                 // CP distributed signal out up
    output  wire [WIDTH-1:0]   ds_out,                // CP distributed signal out dwn
    output  wire [WIDTH-1:0]   ds_tap,                // CP output for this channel dwn 
    output  wire [WIDTH-1:0]   us_tap                  // CP output for this channel up
     );

   c3aibadapt_cmn_cp_dist
     #(
       .ASYNC_RESET_VAL (ASYNC_RESET_VAL),
       .WIDTH         (WIDTH)
       )
       adapt_cmn_cp_dist_dwn
         (
          .clk                  (clk),
          .rst_n                (rst_n), 
          .srst_n               (srst_n), 
          .data_enable          (data_enable),
          .master_in            (master_in),
          .dist_in              (us_in),
          .r_dist_master        (r_ds_master),
          .r_dist_bypass_pipeln (r_ds_bypass_pipeln),
          .dist_out             (ds_out),
          .dist_tap             (ds_tap)
          );

   c3aibadapt_cmn_cp_dist
     #(
       .ASYNC_RESET_VAL (ASYNC_RESET_VAL),
       .WIDTH         (WIDTH)
       )
       adapt_cmn_cp_dist_up
         (
          .clk                  (clk),
          .rst_n                (rst_n),
          .srst_n               (srst_n), 
          .data_enable          (data_enable),
          .master_in            (master_in),
          .dist_in              (ds_in),
          .r_dist_master        (r_us_master),
          .r_dist_bypass_pipeln (r_us_bypass_pipeln),
          .dist_out             (us_out),
          .dist_tap             (us_tap)
          );
   
   
endmodule // c3aibadapt_cmn_cp_dist_pair



   
   
