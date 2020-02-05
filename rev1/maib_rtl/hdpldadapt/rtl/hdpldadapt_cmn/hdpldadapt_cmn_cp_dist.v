// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_cmn_cp_dist.v.rca $
// Revision:    $Revision: #2 $
// Date:        $Date: 2014/09/05 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module hdpldadapt_cmn_cp_dist
  #(
    parameter ASYNC_RESET_VAL = 'd0,   // Asynchronous reset value
    parameter WIDTH           = 'd1    // Control width
    )
    (
    input  wire                clk,                      // clock
    input  wire                rst_n,                    // async reset
    input  wire                srst_n,                   // sync reset
    input wire                 data_enable,              // data enable / data valid
    input  wire [WIDTH-1:0]    master_in,                // master control signal
    input  wire [WIDTH-1:0]    dist_in,                  // CP distributed signal in 
    input  wire                r_dist_master,            // CRAM to control master or distributed
    input  wire                r_dist_bypass_pipeln,     // CRAM combo or registered
    output  wire [WIDTH-1:0]   dist_out,                 // CP distributed signal out
    output  wire [WIDTH-1:0]   dist_tap                  // CP output for this channel
     );

   reg [WIDTH-1:0]          dist_1;
   reg [WIDTH-1:0]          dist_2;

   reg [WIDTH-1:0]         dist_1_in;
   reg [WIDTH-1:0]          dist_2_in;
   reg [WIDTH-1:0]          dist_1_out;
   reg [WIDTH-1:0]          dist_2_out;


   // module outputs
   assign  dist_tap = dist_1_out;
   assign  dist_out = dist_2_out;
   
   
   always @*
     begin
        // default FF inputs to FF outputs
        dist_1_in = dist_1;
        dist_2_in = dist_2;

        // default stage outputs to FF outputs
        dist_1_out = dist_1;
        dist_2_out = dist_2;

        // set FF inputs
        if (data_enable)
          begin
             dist_1_in = dist_in;
             if (r_dist_master)
               begin
                  dist_2_in = master_in;
               end
             else
               begin
                  dist_2_in = dist_1_out;
               end
          end // if (data_enable)
        
        // set stage outputs
        if (r_dist_bypass_pipeln)
          begin
             dist_1_out = dist_in;
             if (r_dist_master)
               begin
                  dist_2_out = master_in;
               end
             else
               begin
                  dist_2_out = dist_1_out;
               end
          end // if (r_dist_bypass_pipeln)
        else
          begin
             dist_1_out = dist_1;
             dist_2_out = dist_2;
          end

     end // always @ *
      
   
   always @(negedge rst_n or posedge clk)
     begin
        if (~rst_n)
          begin
             dist_1 <= {WIDTH{ASYNC_RESET_VAL}};
             dist_2 <= {WIDTH{ASYNC_RESET_VAL}};
          end
        else if (~srst_n)
          begin
             dist_1 <= {WIDTH{ASYNC_RESET_VAL}};
             dist_2 <= {WIDTH{ASYNC_RESET_VAL}};
          end
        else 
          begin
             dist_1 <= dist_1_in;
             dist_2 <= dist_2_in;
          end
     end // always @ (negedge rst_n or posedge clk)

   
endmodule // hdpldadapt_cmn_cp_dist

   
   
