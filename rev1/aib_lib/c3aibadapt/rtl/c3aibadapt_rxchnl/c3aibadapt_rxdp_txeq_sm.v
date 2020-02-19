// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxdp_txeq_sm(/*AUTOARG*/
   // Outputs
   phystatus, dirfeedback, pma_tx_accum, tx_st, timeout,
   // Inputs
   clk, rstn, rxeqinprogress, rxeqeval, invalid_req, rxeqinprogress_f,
   pre_up, pre_dn, post_up, post_dn, r_rx_txeq_en, r_rx_pre_cursor_en,
   r_rx_post_cursor_en, r_rx_invalid_no_change, r_rx_eq_iteration,
   r_rx_txeq_time
   );


input clk;
input rstn;


// PIPE
input rxeqinprogress;
input rxeqeval;
input invalid_req;
input rxeqinprogress_f;

output phystatus;
output [5:0] dirfeedback;

// PMA
input pre_up;
input pre_dn;
input post_up;
input post_dn;

output pma_tx_accum;

// CARM
input r_rx_txeq_en;
input r_rx_pre_cursor_en;
input r_rx_post_cursor_en;
input r_rx_invalid_no_change;
input [1:0] r_rx_eq_iteration;
input [7:0] r_rx_txeq_time;

output [1:0] tx_st;
output timeout;

reg pma_tx_accum, phystatus;
// internal 
parameter TX_EQ 	= 2'd0;
parameter TX_EVAL 	= 2'd1;
parameter TX_WAIT_FB 	= 2'd2;
parameter TX_FB 	= 2'd3;

reg [1:0] st_cnt;
reg [1:0] tx_st, tx_nt;
reg pma_tx_accum_n, phystatus_n;
reg [7:0] eq_done_cnt;
//reg [15:0] timeout_cnt; 
reg [17:0] timeout_cnt; // add 2bits, (2^18 * 4ns = 1024 us max) 
reg timeout;

reg rxeqeval_d0, rxeqeval_d1, rxeqeval_d2;
reg invalid_req_d;

// delay rxeqeval in case rxeqinprogress comes early
always @(posedge clk or negedge rstn)
   if (~rstn) begin
	rxeqeval_d0 <= 1'b0;
	rxeqeval_d1 <= 1'b0;
	rxeqeval_d2 <= 1'b0;
   end
   else begin
	rxeqeval_d0 <= rxeqeval;
	rxeqeval_d1 <= rxeqeval_d0;
	rxeqeval_d2 <= rxeqeval_d1;
   end

wire rxeqeval_r = rxeqeval_d1 & !rxeqeval_d2;
//
// latch invalid_req  
// invalid_req 
always @(posedge clk or negedge rstn)
   if (~rstn) invalid_req_d <= 1'b0;
   else if (invalid_req) invalid_req_d <= 1'b1;
   else if (phystatus_n) invalid_req_d <= 1'b0;		

// eq_done
reg eq_done_cnt_lt_eq_limit;
always @(posedge clk or negedge rstn)
   if (~rstn) eq_done_cnt <= 8'd0;
   else if (phystatus_n) eq_done_cnt <= eq_done_cnt + 1;
   else if (rxeqinprogress_f) eq_done_cnt <= 8'd0;
   

always @*
begin
   case(r_rx_eq_iteration)
   2'd0: eq_done_cnt_lt_eq_limit = 1'b1;
   2'd1: eq_done_cnt_lt_eq_limit = (eq_done_cnt[7:5] == 3'd0);
   2'd2: eq_done_cnt_lt_eq_limit = (eq_done_cnt[7:6] == 2'd0);
   2'd3: eq_done_cnt_lt_eq_limit = !eq_done_cnt[7];
   endcase
end

// timeout counter
always @(posedge clk or negedge rstn)
   if (~rstn) timeout_cnt <= 18'd0;
   else if (tx_st == TX_EVAL) timeout_cnt <= timeout_cnt + 1;
   else if (tx_st == TX_FB) timeout_cnt <= 18'd0;

always @(posedge clk or negedge rstn)
   if (~rstn) timeout <= 1'b0;
   else if ((tx_st == TX_EVAL) && (timeout_cnt[17:10] == r_rx_txeq_time)) timeout <= 1'b1;
   else if (tx_st == TX_FB) timeout <= 1'b0; 

// 
// get PMA results
// wait for rising edge  
// pma will latch pre_up/dn post_up/dn and reset with next pma_tx_accum
reg pre_up_d, pre_dn_d, post_up_d, post_dn_d;
wire pre_done = !r_rx_pre_cursor_en || ((pre_up & !pre_up_d) || (pre_dn & !pre_dn_d)); 
wire post_done = !r_rx_post_cursor_en || ((post_up & !post_up_d) || (post_dn & !post_dn_d));
reg [1:0] pma_pre_fb, pma_post_fb;

always @(posedge clk or negedge rstn)
   if (~rstn) begin
	pre_up_d <= 1'b0;
	pre_dn_d <= 1'b0;
	post_up_d <= 1'b0;
	post_dn_d <= 1'b0;
   end
   else begin
	pre_up_d <= pre_up;
        pre_dn_d <= pre_dn;
        post_up_d <= post_up;
        post_dn_d <= post_dn;
   end


always @(posedge clk or negedge rstn)
   if (~rstn) pma_pre_fb <= 2'd0;
   else if (!r_rx_pre_cursor_en) pma_pre_fb <= 2'd0;
   else if (tx_st == TX_WAIT_FB && st_cnt == 2'd3) begin
	if (invalid_req_d & !r_rx_invalid_no_change) pma_pre_fb <= 2'd0;
    // last minute change to filter UP & DN, which is illegal per the PIPE spec  
    // else pma_pre_fb <= {pre_dn,pre_up};
    else pma_pre_fb <= ({pre_dn,pre_up} == 2'b11) ? 2'b00 : {pre_dn,pre_up};
   end

always @(posedge clk or negedge rstn)
   if (~rstn) pma_post_fb <= 2'd0;
   else if (!r_rx_post_cursor_en) pma_post_fb <= 2'd0;
   else if (tx_st == TX_WAIT_FB && st_cnt == 2'd3) begin
	if (invalid_req_d & !r_rx_invalid_no_change) pma_post_fb <= 2'd0;
    // last minute change to filter UP & DN, which is illegal per the PIPE spec        
	// else pma_post_fb <= {post_dn,post_up};
    else pma_post_fb <= ({post_dn,post_up} == 2'b11) ? 2'b00 : {post_dn,post_up};
   end

assign dirfeedback = {pma_post_fb,2'b00,pma_pre_fb};

// cnt
always @(posedge clk or negedge rstn)
   if (~rstn) st_cnt <= 2'b0;
   else if (tx_st == TX_WAIT_FB) st_cnt <= st_cnt + 1;
   else st_cnt <= 2'b0;

always @(posedge clk or negedge rstn)
   if (~rstn) tx_st <= TX_EQ;
   else tx_st <= tx_nt;

always @*
begin
	tx_nt = tx_st;
	pma_tx_accum_n = 1'b0;
	phystatus_n = 1'b0;
   case(tx_st)
   TX_EQ: begin
	   if (r_rx_txeq_en & rxeqinprogress & rxeqeval_r) begin
			if (eq_done_cnt_lt_eq_limit) begin
				tx_nt = TX_EVAL;
				pma_tx_accum_n = 1'b1;
			end
			else tx_nt = TX_WAIT_FB;
	   end
   end
   TX_EVAL: begin
		pma_tx_accum_n = 1'b1;
	   if ((pre_done & post_done) || timeout)begin
		tx_nt = TX_WAIT_FB;
		pma_tx_accum_n = 1'b0;
	   end
   end
   TX_WAIT_FB: begin
	   if (st_cnt == 2'd3) tx_nt = TX_FB;
   end
   TX_FB: begin
		phystatus_n = 1'b1;
		tx_nt = TX_EQ;
   end
   endcase
end

always @(posedge clk or negedge rstn)
   if (~rstn) begin
	pma_tx_accum <= 1'b0;
	phystatus <= 1'b0;
   end
   else begin
	pma_tx_accum <= pma_tx_accum_n;
	phystatus <= phystatus_n;
   end
	

endmodule
	

