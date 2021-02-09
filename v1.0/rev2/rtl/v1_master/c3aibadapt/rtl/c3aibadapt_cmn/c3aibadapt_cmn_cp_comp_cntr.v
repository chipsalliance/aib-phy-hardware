// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// File:        $RCSfile: c3aibadapt_cmn_cp_comp_cntr.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2016/07/18 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module c3aibadapt_cmn_cp_comp_cntr
  #(
    parameter CNTWIDTH         = 'd8
    )
    (
    input  wire                clk,             // clock
    input  wire                rst_n,           // async reset
    input  wire                srst_n,          // async reset
    input  wire                data_enable,     // data enable / data valid
    input  wire                master_in_en,    
    input  wire                us_tap_en,   
    input  wire                ds_tap_en,  
    input  wire [1:0]          r_compin_sel,    // CRAM input select
    input  wire [CNTWIDTH-1:0] r_comp_cnt,      // CRAM timeout value
    output  reg                comp_cnt_match,   // output signal for match
    output wire		       compin_sel	 
     );

   localparam                  MASTER	         = 2'd0;
   localparam                  SLAVE_ABOVE		 = 2'd1;
   localparam                  SLAVE_BELOW		 = 2'd2;
   
   reg [CNTWIDTH-1:0] cnt, cnt_ns;
   reg                cnt_co;
   reg                cnt_enable;
//   reg		      cnt_enable_reg;
//   wire		      cnt_enable_neg_edge;

   always @*
     begin
        cnt_enable = master_in_en;
        cnt_ns = cnt;
        cnt_co = 1'b0;
        comp_cnt_match = 1'b0;
                        
        case (r_compin_sel)
          MASTER: begin
             cnt_enable = master_in_en;
          end
          SLAVE_ABOVE: begin
             cnt_enable = us_tap_en;
          end
          SLAVE_BELOW: begin
             cnt_enable = ds_tap_en;
          end
          default: begin
             cnt_enable = master_in_en;
          end
        endcase // case(r_compin_sel)

        
        if (cnt == r_comp_cnt && cnt_enable)
          begin
             comp_cnt_match = 1'b1;
          end
        else if (data_enable && cnt_enable && cnt != r_comp_cnt)
          begin
             {cnt_co,cnt_ns} = cnt + 1'b1;
          end
        
     end // always @ *

assign compin_sel = cnt_enable;

//   always @(negedge rst_n or posedge clk)
//     begin
//        if (~rst_n)
//          begin
//             cnt_enable_reg <= 1'b0;
//          end
//        else if (~srst_n)
//          begin
//             cnt_enable_reg <= 1'b0;
//          end
//        else 
//          begin
//             cnt_enable_reg <= cnt_enable;
//          end
//     end // always @ (negedge rst_n or posedge clk)               
// 
//   assign cnt_enable_neg_edge = ~cnt_enable && cnt_enable_reg;

   always @(negedge rst_n or posedge clk)
     begin
        if (~rst_n)
          begin
             cnt <= {CNTWIDTH{1'b0}};
          end
//        else if (~srst_n || cnt_enable_neg_edge)
        else if (~srst_n)
          begin
             cnt <= {CNTWIDTH{1'b0}};
          end
        else 
          begin
             cnt <= cnt_ns;
          end
     end // always @ (negedge rst_n or posedge clk)               
   
endmodule // c3aibadapt_cmn_cp_comp_cntr
