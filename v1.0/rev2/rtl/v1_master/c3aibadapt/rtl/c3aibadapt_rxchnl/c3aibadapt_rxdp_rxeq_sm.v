// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxdp_rxeq_sm(/*AUTOARG*/
   // Outputs
   pma_adapt_rstn, pma_adp_rx_adp_go, rxeqinprogress_f, pma_tx_adapt_en,
   rq_st,
   // Inputs
   clk, rstn, rxvalid, rxelecidle, rate_1, powerdown_1, txdetectrx,
   rxeqinprogress, r_rx_rxeq_en, r_rx_adp_go_b4txeq_en,
   r_rx_pma_rstn_en, r_rx_pma_rstn_cycles, r_rx_use_rxvalid_for_rxeq
   );


input clk;
input rstn;


// PIPE
input rxvalid;
input rxelecidle;

input rate_1;
input powerdown_1;
input txdetectrx;
input rxeqinprogress;

output pma_adapt_rstn;
output pma_adp_rx_adp_go;

output rxeqinprogress_f;
output pma_tx_adapt_en;

// CARM
input r_rx_rxeq_en;
input r_rx_adp_go_b4txeq_en;
input r_rx_pma_rstn_en;
input r_rx_pma_rstn_cycles;
input r_rx_use_rxvalid_for_rxeq;

output [2:0] rq_st;

// 
reg pma_adapt_rstn;
reg pma_adp_rx_adp_go;

// internal 
reg [1:0] st1_cnt;
reg [2:0] st2_cnt;
reg rxeqinprogress_d;
reg [2:0] rq_st, rq_nt;
reg pma_adapt_rstn_n, pma_adp_rx_adp_go_n;

always @(posedge clk or negedge rstn)
   if (~rstn) rxeqinprogress_d <= 1'b0;
   else rxeqinprogress_d <= rxeqinprogress;

assign pma_tx_adapt_en = rxeqinprogress_d;
//
// rxeq_needed generation
parameter RQ_UP 	= 3'd0;
parameter RQ_PMA_INIT 	= 3'd1;
parameter RQ_PMA_WAIT 	= 3'd2;
parameter RQ_PMA_GO 	= 3'd3;
parameter RQ_WAIT_TX 	= 3'd4;
parameter RQ_DN 	= 3'd5;

// 

wire rxeqinprogress_f = !rxeqinprogress & rxeqinprogress_d;	// falling edge of rxeqinprogress
wire wait_rstn_done = r_rx_pma_rstn_cycles ? st2_cnt == 3'h7 : st2_cnt == 3'h3;
wire mac_det_st = ~rate_1 & powerdown_1 & txdetectrx;		// MAC in detect state

// cnt
always @(posedge clk or negedge rstn)
   if (~rstn) st1_cnt <= 2'b0;
   else if (rq_st == RQ_PMA_WAIT) st1_cnt <= st1_cnt + 1;
   else st1_cnt <= 2'b0;

always @(posedge clk or negedge rstn)
   if (~rstn) st2_cnt <= 3'd0;
   else if ((rq_st == RQ_PMA_INIT) || (rq_st == RQ_PMA_GO))  st2_cnt <= st2_cnt + 1;
   else st2_cnt <= 3'd0;

// wire exit_elecidle = r_rx_use_rxvalid_for_rxeq ? rxvalid : ~rxelecidle;
wire exit_elecidle = r_rx_use_rxvalid_for_rxeq ? ~rxelecidle : rxvalid;
always @(posedge clk or negedge rstn)
   if (~rstn) rq_st <= RQ_UP;
   else rq_st <= rq_nt;

always @*
begin
	rq_nt = rq_st;
       	pma_adapt_rstn_n = 1'b1; 
	pma_adp_rx_adp_go_n = 1'b0;
   case(rq_st)
   RQ_UP: begin
	   if (rate_1 & exit_elecidle & r_rx_rxeq_en) begin
		rq_nt = RQ_PMA_INIT;
		pma_adapt_rstn_n = 1'b0;
	   end
   end
   RQ_PMA_INIT: begin
			pma_adapt_rstn_n = 1'b0;
	   if (wait_rstn_done) begin
		rq_nt = RQ_PMA_WAIT;
		pma_adapt_rstn_n = 1'b1;
	   end
   end
   RQ_PMA_WAIT: begin
	   if (st1_cnt == 2'd3) begin
		if (r_rx_adp_go_b4txeq_en) begin
			rq_nt = RQ_PMA_GO;
			pma_adp_rx_adp_go_n = 1'b1;
		end
		else rq_nt = RQ_WAIT_TX;	// !r_rx_adp_go_after_txeq_en
	   end
   end
   RQ_PMA_GO: begin
			pma_adp_rx_adp_go_n = 1'b1;
	   if (st2_cnt == 3'd3) begin
		rq_nt = RQ_DN;
		pma_adp_rx_adp_go_n = 1'b0;
	   end
   end		
   RQ_DN: begin
	   if (mac_det_st) rq_nt = RQ_UP;
   end
   RQ_WAIT_TX: begin
	   if (rxeqinprogress_f) begin
		rq_nt = RQ_PMA_GO;
		pma_adp_rx_adp_go_n = 1'b1;
	   end
	   else if (mac_det_st) rq_nt = RQ_UP;
   end
   default: rq_nt = RQ_UP;
   endcase
end

always @(posedge clk or negedge rstn)
   if (~rstn) begin
	pma_adapt_rstn <= 1'b1;
	pma_adp_rx_adp_go <= 1'b0;
   end
   else begin
	pma_adapt_rstn <= pma_adapt_rstn_n & r_rx_pma_rstn_en;
	pma_adp_rx_adp_go <= pma_adp_rx_adp_go_n;
   end
	

endmodule
	

