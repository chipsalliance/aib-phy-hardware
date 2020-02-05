// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_rx_datapath_cp_bond.v.rca $
// Revision:    $Revision: #6 $
// Date:        $Date: 2015/06/19 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module hdpldadapt_rx_datapath_cp_bond 
  #(
    parameter CNTWIDTH         = 'd8
    )
    (
    input  wire                     rx_wrfifo_clk,          // TX PCS clock clock
    input  wire                     rx_rdfifo_clk,          // TX RD clock clock
    input  wire                     rx_rdfifo_clk_rst_n,    // TX PCS rst output
    input  wire                     rx_wrfifo_clk_rst_n,    // TX RD rst output
    input  wire                     wr_srst_n,    		// Write sync rst_n
    input  wire                     rd_srst_n,    		// Read sync rst_n
//    input  wire		  	    double_read,  		// FIFO double write option
   
    input  wire                     r_us_master,        	// CP up master sel
    input  wire                     r_ds_master,       		// CP dwn master sel
    input  wire                     r_us_bypass_pipeln, 	// CP up comb or seq sel
    input  wire                     r_ds_bypass_pipeln,		// CP dwn comb or seq sel
    input  wire [1:0]               r_compin_sel,           	// Comp input sel
    input  wire [CNTWIDTH-1:0]      r_comp_cnt,             	// Comp timeout value
    input  wire			    r_bonding_dft_in_en,   	// Gate bonding signal during scan
    input  wire			    r_bonding_dft_in_value,   	// Gate bonding signal during scan
    input  wire		  	    r_double_read,  		// FIFO double write option

    input  wire                     master_in_wren,      	// PC wren master in
    input  wire                     us_in_wren,      		// PC wren up in
    input  wire                     ds_in_wren,      		// PC wren dwn in
    input  wire                     master_in_rden,      	// PC rden master in
    input  wire                     us_in_rden,      		// PC rden up in
    input  wire                     ds_in_rden,      		// PC rden dwn in

    output  wire                    us_out_wren,      		// PC wren up out
    output  wire                    ds_out_wren,      		// PC wren dwn out
    output  wire                    us_out_rden,      		// PC rden up out
    output  wire                    ds_out_rden,      		// PC rden dwn out
//    output  wire                    comp_out_dv_en,      	// data valid comp out
    output  wire                    comp_out_wren_en,      	// PC wren comp out
    output  wire                    comp_out_rden_en,      	// PC rden comp out
    output  wire                    compin_sel_rden,
    output  wire                    compin_sel_wren,    
    output  wire [19:0]             rx_cp_bond_testbus      	// testbus
   );


   wire                             ds_tap_wren;
   wire                             us_tap_wren;
   wire                             ds_tap_rden;
   wire                             us_tap_rden;

   wire                             ds_in_wren_int;
   wire                             us_in_wren_int;
   wire                             ds_in_rden_int;
   wire                             us_in_rden_int;

   wire [CNTWIDTH-1:0]      comp_cnt_int;
//   wire 			    double_write_int;

   
   assign ds_in_wren_int = r_bonding_dft_in_en ? r_bonding_dft_in_value : ds_in_wren;
   assign us_in_wren_int = r_bonding_dft_in_en ? r_bonding_dft_in_value : us_in_wren;
   assign ds_in_rden_int = r_bonding_dft_in_en ? r_bonding_dft_in_value : ds_in_rden;
   assign us_in_rden_int = r_bonding_dft_in_en ? r_bonding_dft_in_value : us_in_rden;

   hdpldadapt_cmn_cp_dist_pair_dw
     #(
       .ASYNC_RESET_VAL (0),
       .WIDTH         (1)   // Control width
       )
       hdpldadapt_cmn_cp_dist_pair_dw_wren
         (
          .clk                      (rx_wrfifo_clk),
          .rst_n                    (rx_wrfifo_clk_rst_n),
          .srst_n                   (wr_srst_n),
          .data_enable              (1'b1),
          .master_in                (master_in_wren),
          .us_in                (us_in_wren_int),
          .ds_in               (ds_in_wren_int),
          .r_us_master          (r_us_master),
          .r_ds_master         (r_ds_master),
          .r_us_bypass_pipeln   (1'b0),
          .r_ds_bypass_pipeln  (1'b0),
          .r_double_en		    (r_double_read),
          .us_out               (us_out_wren),
          .ds_out              (ds_out_wren),
          .ds_tap              (ds_tap_wren),
          .us_tap               (us_tap_wren)
          );

   hdpldadapt_cmn_cp_comp_cntr
     #(
       .CNTWIDTH         (8)
       )
       hdpldadapt_cmn_cp_comp_cntr_wren
         (
          .clk            (rx_wrfifo_clk),
          .rst_n          (rx_wrfifo_clk_rst_n),  
          .srst_n                   (wr_srst_n),
          .data_enable    (1'b1),
          .master_in_en   (master_in_wren),
          .us_tap_en  (us_tap_wren),
          .ds_tap_en (ds_tap_wren),
          .r_compin_sel   (r_compin_sel),
          .r_comp_cnt     (comp_cnt_int),
          .comp_cnt_match (comp_out_wren_en),
          .compin_sel	  (compin_sel_wren)
          );

   hdpldadapt_cmn_cp_dist_pair
     #(
       .ASYNC_RESET_VAL (0),
       .WIDTH         (1)   // Control width
       )
       hdpldadapt_cmn_cp_dist_pair_dw_rden
         (
          .clk                      (rx_rdfifo_clk),
          .rst_n                    (rx_rdfifo_clk_rst_n),
          .srst_n                   (rd_srst_n),
          .data_enable              (1'b1),
          .master_in                (master_in_rden),
          .us_in                (us_in_rden_int),
          .ds_in               (ds_in_rden_int),
          .r_us_master          (r_us_master),
          .r_ds_master         (r_ds_master),
          .r_us_bypass_pipeln   (1'b0),
          .r_ds_bypass_pipeln  (1'b0),
//          .r_double_en		    (r_double_read),
          .us_out               (us_out_rden),
          .ds_out              (ds_out_rden),
          .ds_tap              (ds_tap_rden),
          .us_tap               (us_tap_rden)
          );

   hdpldadapt_cmn_cp_comp_cntr
     #(
       .CNTWIDTH         (8)
       )
       hdpldadapt_cmn_cp_comp_cntr_rden
         (
          .clk            (rx_rdfifo_clk),
          .rst_n          (rx_rdfifo_clk_rst_n),  
          .srst_n                   (rd_srst_n),
          .data_enable    (1'b1),
          .master_in_en   (master_in_rden),
          .us_tap_en  (us_tap_rden),
          .ds_tap_en (ds_tap_rden),
          .r_compin_sel   (r_compin_sel),
          .r_comp_cnt     (r_comp_cnt),
          .comp_cnt_match (comp_out_rden_en),
          .compin_sel	  (compin_sel_rden)
          );

   assign rx_cp_bond_testbus = {8'h00,
                                master_in_wren,
                                us_in_wren,
                                ds_in_wren,
                                ds_tap_wren,
                                us_tap_wren,
                                comp_out_wren_en,
                                master_in_rden,
                                us_in_rden,
                                ds_in_rden,
                                ds_tap_rden,
                                us_tap_rden,
                                comp_out_rden_en
                                };

assign	comp_cnt_int = r_double_read ? r_comp_cnt << 1 : r_comp_cnt;

endmodule
