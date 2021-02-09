// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxdp_txeq(

// 

input wire rx_clock_txeq_clk,		// from c3adapt_rxclk_ctl
input wire rx_reset_txeq_clk_rst_n,	// from c3adapt_rxrst_ctl

/*
pma_adp_rstn

pma_adp_rx_adp_go

pma_tx_adapt_en

pma_tx_accum

pma_tx_pre_up_tap1

pma_tx_pre_dn_tap1

pma_tx_post_up_tap1

pma_tx_post_dn_tap1

*/


output wire [6:0] aib_hip_txeq_in,

//DPRIO
input wire r_rx_txeq_en,
input wire r_rx_rxeq_en,
input wire r_rx_pre_cursor_en,
input wire r_rx_post_cursor_en,
input wire r_rx_invalid_no_change,
input wire r_rx_adp_go_b4txeq_en,
input wire r_rx_use_rxvalid_for_rxeq,
input wire r_rx_pma_rstn_en,

input wire r_rx_pma_rstn_cycles,
input wire [7:0] r_rx_txeq_time,	// unit is 1us for 8'h100 cycles 250MHz (update to unit = 4us for 'h400 cycles 20150506)
input wire [1:0] r_rx_eq_iteration,	// 

output wire [19:0] rx_txeq_testbus,
//output wire [19:0] txeq_testbus_1;



// c3adapt_txdp_map
input wire txeq_rxeqinprogress,
input wire txeq_rxeqeval,
input wire txeq_invalid_req,
input wire txeq_txdetectrx,
input wire [1:0] txeq_rate,	
input wire [1:0] txeq_powerdown,

output [2:0] pld_g3_current_rxpreset,

// c3aibadapt_rxdp_map
input wire txeq_rxvalid,		
input wire txeq_rxelecidle,		

output wire [5:0] txeq_dirfeedback,
output wire txeq_phystatus,
//
// PMA
input wire [4:1] pld_pma_reserved_in,	// from PMA
output wire pma_adapt_rstn		// connected to pld_pma_reserved_out[4] ?
);

wire [1:0] tx_st;
wire [2:0] rq_st;
wire timeout;

wire pre_up, pre_dn, post_up, post_dn;
wire rate_1, powerdown_1, txdetectrx, rxeqinprogress, rxeqeval, invalid_req;

assign rx_txeq_testbus[1:0] = tx_st[1:0];
assign rx_txeq_testbus[4:2] = rq_st[2:0];
assign rx_txeq_testbus[7:5] = pld_g3_current_rxpreset[2:0];
assign rx_txeq_testbus[8]   = txeq_rxeqinprogress;
assign rx_txeq_testbus[9]   = txeq_rxeqeval;
assign rx_txeq_testbus[10]  = txeq_phystatus;
assign rx_txeq_testbus[14:11]  = pld_pma_reserved_in;
assign rx_txeq_testbus[15]  = timeout;
assign rx_txeq_testbus[17:16]  = txeq_dirfeedback[1:0];
assign rx_txeq_testbus[19:18]  = txeq_dirfeedback[5:4];


assign aib_hip_txeq_in = {txeq_phystatus,txeq_dirfeedback[5:0]};
//assign pld_g3_current_rxpreset = 3'd0;
//assign txeq_dirfeedback = 6'd0;
//assign txeq_phystatus = 1'b0;
//assign pma_adapt_rstn = 1'b0;


/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			rxeqinprogress_f;	// From c3adapt_rx_datapath_rxeq_sm of hd_hssiadapt_rx_datapath_rxeq_sm.v
// End of automatics

/* c3adapt_rx_datapath_rxeq_sm AUTO_TEMPLATE (
.clk (rx_clock_txeq_clk),
.rstn (rx_reset_txeq_clk_rst_n),
.rxvalid (txeq_rxvalid),
.rxelecidle (txeq_rxelecidle),
.pma_adp_rx_adp_go (pld_g3_current_rxpreset[0]),
.pma_tx_adapt_en (pld_g3_current_rxpreset[2]),
);
*/

/*c3adapt_rx_datapath_txeq_sm AUTO_TEMPLATE (
.clk (rx_clock_txeq_clk),
.rstn (rx_reset_txeq_clk_rst_n),
.rxeqinprogress (txeq_rxeqinprogress),
.phystatus (txeq_phystatus),
.pma_tx_accum (pld_g3_current_rxpreset[1]),
.dirfeedback (txeq_dirfeedback),
);
*/

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_pld_pma_pre_up (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (pld_pma_reserved_in[1]),
    .data_out (pre_up)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_pld_pma_pre_dn
  (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (pld_pma_reserved_in[2]),
    .data_out (pre_dn)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_pld_pma_post_up (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (pld_pma_reserved_in[3]),
    .data_out (post_up)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_pld_pma_post_dn (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (pld_pma_reserved_in[4]),
    .data_out (post_dn)
  );

//
// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
   bitsync2_rate_1 (
     .clk      (rx_clock_txeq_clk),
     .rst_n    (rx_reset_txeq_clk_rst_n),
     .data_in  (txeq_rate[1]),
     .data_out (rate_1)
   );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_powerdown (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (txeq_powerdown[1]),
    .data_out (powerdown_1)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_txdetectrx (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (txeq_txdetectrx),
    .data_out (txdetectrx)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_rxeqinprogress (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (txeq_rxeqinprogress),
    .data_out (rxeqinprogress)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_rxeqeval (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (txeq_rxeqeval),
    .data_out (rxeqeval)
  );

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),      // Sync Data input
  .RESET_VAL            (0)  // Reset value
  )
  bitsync2_invalid_req (
    .clk      (rx_clock_txeq_clk),
    .rst_n    (rx_reset_txeq_clk_rst_n),
    .data_in  (txeq_invalid_req),
    .data_out (invalid_req)
  );



c3aibadapt_rxdp_rxeq_sm adapt_rxdp_rxeq_sm(/*AUTOINST*/
								  // Outputs
								  .pma_adapt_rstn	(pma_adapt_rstn),
								  .pma_adp_rx_adp_go	(pld_g3_current_rxpreset[0]), // Templated
								  .rxeqinprogress_f	(rxeqinprogress_f),
								  .pma_tx_adapt_en	(pld_g3_current_rxpreset[2]), // Templated
								  .rq_st		(rq_st[2:0]), 
								  // Inputs
								  .clk			(rx_clock_txeq_clk), // Templated
								  .rstn			(rx_reset_txeq_clk_rst_n), // Templated
								  .rxvalid		(txeq_rxvalid),	 // Templated
								  .rxelecidle		(txeq_rxelecidle), // Templated
								  .rate_1		(rate_1),
								  .powerdown_1		(powerdown_1),
								  .txdetectrx		(txdetectrx),
								  .rxeqinprogress	(rxeqinprogress),
								  .r_rx_rxeq_en		(r_rx_rxeq_en),
								  .r_rx_adp_go_b4txeq_en(r_rx_adp_go_b4txeq_en),
								  .r_rx_pma_rstn_en	(r_rx_pma_rstn_en),
								  .r_rx_pma_rstn_cycles	(r_rx_pma_rstn_cycles),
								  .r_rx_use_rxvalid_for_rxeq(r_rx_use_rxvalid_for_rxeq));

c3aibadapt_rxdp_txeq_sm adapt_rxdp_txeq_sm(/*AUTOINST*/
								  // Outputs
								  .phystatus		(txeq_phystatus), // Templated
								  .dirfeedback		(txeq_dirfeedback), // Templated
								  .pma_tx_accum		(pld_g3_current_rxpreset[1]), // Templated
								  .tx_st		(tx_st[1:0]), 
								  .timeout		(timeout), 
								  // Inputs
								  .clk			(rx_clock_txeq_clk), // Templated
								  .rstn			(rx_reset_txeq_clk_rst_n), // Templated
								  .rxeqinprogress	(txeq_rxeqinprogress), // Templated
								  .rxeqeval		(rxeqeval),
								  .invalid_req		(invalid_req),
								  .rxeqinprogress_f	(rxeqinprogress_f),
								  .pre_up		(pre_up),
								  .pre_dn		(pre_dn),
								  .post_up		(post_up),
								  .post_dn		(post_dn),
								  .r_rx_txeq_en		(r_rx_txeq_en),
								  .r_rx_pre_cursor_en	(r_rx_pre_cursor_en),
								  .r_rx_post_cursor_en	(r_rx_post_cursor_en),
								  .r_rx_invalid_no_change(r_rx_invalid_no_change),
								  .r_rx_eq_iteration	(r_rx_eq_iteration[1:0]),
								  .r_rx_txeq_time	(r_rx_txeq_time[7:0]));


endmodule

