// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (C) 2009 Altera Corporation. .
//
//------------------------------------------------------------------------
//------------------------------------------------------------------------
// Description:
//
//------------------------------------------------------------------------

module c3aibadapt_txclk_ctl (
  input  wire                      scan_mode_n,
  input  wire [6:0]                t0_tst_tcm_ctrl,
  input  wire                      t0_test_clk,
  input  wire                      t0_scan_clk,
  input  wire [6:0]                t1_tst_tcm_ctrl,
  input  wire                      t1_test_clk,
  input  wire                      t1_scan_clk,
  input  wire [6:0]                t2_tst_tcm_ctrl,
  input  wire                      t2_test_clk,
  input  wire                      t2_scan_clk,
  input	 wire		           pld_pma_div66_clk,
  input	 wire [3:0] 	           pcs_fpll_shared_direct_async_in,
  input  wire                      tx_ehip_clk,
  input  wire                      tx_rsfec_clk,
  input  wire                      tx_elane_clk,
  input	 wire		           tx_pma_clk,
  input  wire       	           aib_hssi_fpll_shared_direct_async_in,
  input	 wire		           aib_hssi_tx_transfer_clk,
  input	 wire		           aib_hssi_rx_sr_clk_in,
  input	 wire		           aib_hssi_pld_sclk,
  input	 wire		           sr_clock_tx_osc_clk_or_clkdiv,
  input	 wire [1:0]	           r_tx_fifo_rd_clk_sel,
  input	 wire                      r_tx_fifo_wr_clk_scg_en,
  input	 wire                      r_tx_fifo_rd_clk_scg_en,
  input	 wire		           r_tx_osc_clk_scg_en,
  input	 wire		           r_tx_hrdrst_rx_osc_clk_scg_en,
  input	 wire		           r_tx_hip_osc_clk_scg_en,
  input  wire                      r_tx_clkdiv2_dist_bypass_pipeln,
  input	 wire [1:0]	           r_tx_fifo_power_mode,
  input	 wire		           tx_reset_pma_aib_tx_clk_rst_n,
  input  wire                      tx_reset_tx_transfer_clk_rst_n,
  input	 wire		           tx_reset_pma_aib_tx_clkdiv2_rst_n,
  output wire                      tx_ehip_early_clk,
  output wire                      tx_rsfec_early_clk,
  output wire                      tx_elane_early_clk,
  output wire       	           pcs_fpll_shared_direct_async_out,
  output wire		           tx_clock_tx_transfer_clk,
  output wire                      tx_clock_tx_transfer_div2_clk,
  // output wire		           aib_hssi_pld_pcs_tx_clk_out,
  output wire                      tx_clock_fifo_rd_prect_clk,
  output wire		           aib_pma_aib_tx_clk,
  output wire                      aib_pma_aib_tx_div2_clk,
  output wire		           aib_tx_pma_div66_clk,
  output wire [3:0] 	           aib_hssi_fpll_shared_direct_async_out,
  output wire                      tx_clock_reset_hrdrst_rx_osc_clk,
  output wire                      tx_clock_reset_fifo_wr_clk,
  output wire                      tx_clock_reset_fifo_rd_clk,
  output wire		           tx_clock_fifo_sclk,
  output wire                      tx_clock_reset_async_rx_osc_clk,
  output wire                      tx_clock_reset_async_tx_osc_clk,
  output wire                      tx_clock_pma_aib_tx_clk,
  output wire 		           tx_clock_pma_aib_tx_div2_clk,
  output wire		           tx_clock_fifo_wr_clk,		// Static clock gated
  output wire                      q1_tx_clock_fifo_wr_clk,             // Static clock gated
  output wire                      q2_tx_clock_fifo_wr_clk,             // Static clock gated
  output wire                      q3_tx_clock_fifo_wr_clk,             // Static clock gated
  output wire                      q4_tx_clock_fifo_wr_clk,             // Static clock gated
  output wire		           tx_clock_fifo_rd_clk,		// Static clock gated
  output wire		           tx_clock_hrdrst_rx_osc_clk,	        // Static clock gated
  output wire		           tx_clock_async_rx_osc_clk,	        // Static clock gated
  output wire		           tx_clock_async_tx_osc_clk,	        // Static clock gated
  output wire		           tx_clock_hip_async_rx_osc_clk,	// Static clock gated
  output wire		           tx_clock_hip_async_tx_osc_clk        // Static clock gated
);

wire		tx_clock_dft_clk_sel_n;

wire		tx_clock_fifo_rd_clk_mux1;
wire		tx_clock_fifo_rd_clk_mux2;
wire		tx_clock_fifo_rd_clk_mux3;
wire		tx_fifo_rd_clk_en;
wire [1:0]      tx_fifo_rd_clk_sel;

wire		q1_tx_fifo_wr_clk_en;
wire		q2_tx_fifo_wr_clk_en;
wire		q3_tx_fifo_wr_clk_en;
wire		q4_tx_fifo_wr_clk_en;

wire		tx_hrdrst_rx_osc_clk_en;
wire		tx_hip_osc_clk_en;
wire		tx_osc_clk_en; 

wire		tx_clock_pma_aib_tx_clkdiv2_mux1;
wire		tx_clock_pma_aib_tx_clk_mux1;

wire		bond_tx_clock_us_in_div2_int;
wire		bond_tx_clock_ds_in_div2_int;


wire            pma_aib_tx_clk_en;
wire            pma_aib_tx_clkdiv2_en;
wire            sync_pma_aib_tx_clk_en;

// Feedthrough from PCS to AIB
assign aib_tx_pma_div66_clk = pld_pma_div66_clk;
assign aib_hssi_fpll_shared_direct_async_out[3:0] = pcs_fpll_shared_direct_async_in[3:0];

c3lib_ckbuf_ctn ckbuf_tx_ehip_early_clk (
  .out (tx_ehip_early_clk),
  .in  (tx_ehip_clk));

c3lib_ckbuf_ctn ckbuf_tx_elane_early_clk (
  .out (tx_elane_early_clk),
  .in  (tx_elane_clk));

c3lib_ckbuf_ctn ckbuf_tx_rsfec_early_clk (
  .out (tx_rsfec_early_clk),
  .in  (tx_rsfec_clk));

// Feedthrough from AIB to PCS
c3lib_ckbuf_ctn ckbuf_fpll_shared_direct_async (
  .out (pcs_fpll_shared_direct_async_out),
  .in  (aib_hssi_fpll_shared_direct_async_in));

// AIB Transfer clock div 2

c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (2),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (500),        // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_ckdiv2_tx_transfer (
  .i_func_clk     (aib_hssi_tx_transfer_clk),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (tx_reset_tx_transfer_clk_rst_n),
  .i_test_clk     (t0_test_clk),                      
  .i_scan_clk     (t0_scan_clk),                      
  .i_tst_tcm_ctrl (t0_tst_tcm_ctrl),                  
  .o_clk          (tx_clock_tx_transfer_div2_clk));

//////////////////
// Clock muxing //
//////////////////

////////// FIFO Read Clock //////////

assign tx_clock_fifo_rd_prect_clk  = tx_clock_fifo_rd_clk_mux1;	        // Send this to internal1_clk
// assign aib_hssi_pld_pcs_tx_clk_out = tx_clock_pma_aib_tx_clkdiv2_mux1;  // o_aib_tx_pma_div2_clk
assign tx_clock_reset_fifo_rd_clk  = tx_clock_fifo_rd_clk_mux1;

assign tx_fifo_rd_clk_en = (~scan_mode_n) | (~r_tx_fifo_rd_clk_scg_en);

// c3adapt_cmn_clkand2 cmn_clkand2_tx_fifo_rd_clk_scg
c3lib_ckand2_ctn cmn_clkand2_tx_fifo_rd_clk_scg
  (
    .clk_out  (tx_clock_fifo_rd_clk),
    .clk_in0  (tx_clock_fifo_rd_clk_mux1),
    .clk_in1  (tx_fifo_rd_clk_en)
  );

assign tx_fifo_rd_clk_sel = {2{scan_mode_n}} & r_tx_fifo_rd_clk_sel;

// MUXed clock. scan_mode_n selects dominant (most flops) or fastest clock
c3lib_mux4_ctn cmn_clkmux4_txfifo_rd_clk (
  .ck_out      (tx_clock_fifo_rd_clk_mux1),
  .ck0         (tx_ehip_clk),
  .ck1         (tx_elane_clk),
  .ck2         (tx_rsfec_clk),
  .ck3         (tx_clock_tx_transfer_div2_clk),
  .s0          (tx_fifo_rd_clk_sel[0]),
  .s1          (tx_fifo_rd_clk_sel[1])
);

////////// FIFO Write Clock //////////
	
assign tx_clock_fifo_wr_clk       = q1_tx_clock_fifo_wr_clk;
assign tx_clock_reset_fifo_wr_clk = tx_clock_tx_transfer_clk;

assign q1_tx_fifo_wr_clk_en = (~scan_mode_n) |  (~r_tx_fifo_wr_clk_scg_en);
assign q2_tx_fifo_wr_clk_en = (~scan_mode_n) | ((~r_tx_fifo_wr_clk_scg_en) & r_tx_fifo_power_mode[0]);
assign q3_tx_fifo_wr_clk_en = (~scan_mode_n) | ((~r_tx_fifo_wr_clk_scg_en) & r_tx_fifo_power_mode[1]);
assign q4_tx_fifo_wr_clk_en = (~scan_mode_n) | ((~r_tx_fifo_wr_clk_scg_en) & r_tx_fifo_power_mode[1] & r_tx_fifo_power_mode[0]);

// c3adapt_cmn_clkand2 cmn_clkand2_q1_tx_fifo_wr_clk_scg
c3lib_ckand2_ctn cmn_clkand2_q1_tx_fifo_wr_clk_scg (
  .clk_out   (q1_tx_clock_fifo_wr_clk),
  .clk_in0   (tx_clock_tx_transfer_clk),
  .clk_in1   (q1_tx_fifo_wr_clk_en)
);

// c3adapt_cmn_clkand2 cmn_clkand2_q2_tx_fifo_wr_clk_scg
c3lib_ckand2_ctn cmn_clkand2_q2_tx_fifo_wr_clk_scg (
  .clk_out   (q2_tx_clock_fifo_wr_clk),
  .clk_in0   (tx_clock_tx_transfer_clk),
  .clk_in1   (q2_tx_fifo_wr_clk_en)
);

// c3adapt_cmn_clkand2 cmn_clkand2_q3_tx_fifo_wr_clk_scg
c3lib_ckand2_ctn cmn_clkand2_q3_tx_fifo_wr_clk_scg (
  .clk_out   (q3_tx_clock_fifo_wr_clk),
  .clk_in0   (tx_clock_tx_transfer_clk),
  .clk_in1   (q3_tx_fifo_wr_clk_en)
);

// c3adapt_cmn_clkand2 cmn_clkand2_q4_tx_fifo_wr_clk_scg
c3lib_ckand2_ctn cmn_clkand2_q4_tx_fifo_wr_clk_scg (
  .clk_out   (q4_tx_clock_fifo_wr_clk),
  .clk_in0   (tx_clock_tx_transfer_clk),
  .clk_in1   (q4_tx_fifo_wr_clk_en)
);

// Send full-rate clock along with data to EHIP/RSFEC
c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (1000),       // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_clkmux2_tx_fifo_wr_clk_mux1 (
  .i_func_clk     (aib_hssi_tx_transfer_clk),
  .i_func_clken   (1'b1),                    
  .i_rst_n        (1'b1),                    
  .i_test_clk     (t1_test_clk),                
  .i_scan_clk     (t1_scan_clk),                
  .i_tst_tcm_ctrl (t1_tst_tcm_ctrl),            
  .o_clk          (tx_clock_tx_transfer_clk)
);

////////// AIB TX Clock //////////
	
assign aib_pma_aib_tx_clk      = tx_clock_pma_aib_tx_clk;
assign aib_pma_aib_tx_div2_clk = tx_clock_pma_aib_tx_clkdiv2_mux1;

////////// Sample Clock //////////

assign tx_clock_fifo_sclk = aib_hssi_pld_sclk;

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (300),        // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_clkmux2_tx_fifo_sclk_mux1 (
//   .i_func_clk     (aib_hssi_pld_sclk),
//   .i_func_clken   (1'b1),                    
//   .i_rst_n        (1'b1),                    
//   .i_test_clk     (test_clk),                
//   .i_scan_clk     (scan_clk),                
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),            
//   .o_clk          (tx_clock_fifo_sclk_mux1)
// );

////////// Rx Oscillator Clock //////////

  // Note: aib_hssi_rx_sr_clk_in comes from TCM module residing in srclk_ctl module
assign tx_clock_reset_hrdrst_rx_osc_clk = aib_hssi_rx_sr_clk_in;
assign tx_clock_reset_async_rx_osc_clk  = aib_hssi_rx_sr_clk_in;

assign tx_hrdrst_rx_osc_clk_en = (~scan_mode_n) | ~r_tx_hrdrst_rx_osc_clk_scg_en;
assign tx_hip_osc_clk_en       = (~scan_mode_n) | ~r_tx_hip_osc_clk_scg_en;
assign tx_osc_clk_en           = (~scan_mode_n) | ~r_tx_osc_clk_scg_en;

// c3adapt_cmn_clkand2 cmn_clkand2_tx_hrdrst_rx_osc_clk_scg
c3lib_ckand2_ctn cmn_clkand2_tx_hrdrst_rx_osc_clk_scg (
  .clk_out  (tx_clock_hrdrst_rx_osc_clk),
  .clk_in0  (aib_hssi_rx_sr_clk_in),
  .clk_in1  (tx_hrdrst_rx_osc_clk_en)
);

// c3adapt_cmn_clkand2 cmn_clkand2_tx_hip_async_rx_osc_clk_scg
c3lib_ckand2_ctn cmn_clkand2_tx_hip_async_rx_osc_clk_scg (
  .clk_out   (tx_clock_hip_async_rx_osc_clk),
  .clk_in0   (aib_hssi_rx_sr_clk_in),
  .clk_in1   (tx_hip_osc_clk_en)
);

// c3adapt_cmn_clkand2 cmn_clkand2_tx_async_rx_osc_clk_scg
c3lib_ckand2_ctn cmn_clkand2_tx_async_rx_osc_clk_scg (
  .clk_out   (tx_clock_async_rx_osc_clk),
  .clk_in0   (aib_hssi_rx_sr_clk_in),
  .clk_in1   (tx_osc_clk_en)
);

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (1000),       // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_clkmux2_rx_osc_clk_mux1 (
//   .i_func_clk     (aib_hssi_rx_sr_clk_in),
//   .i_func_clken   (1'b1),                    
//   .i_rst_n        (1'b1),                    
//   .i_test_clk     (test_clk),                
//   .i_scan_clk     (scan_clk),                
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),            
//   .o_clk          (tx_clock_rx_osc_clk_mux1)
// );

////////// Tx Oscillator Clock //////////

assign tx_clock_reset_async_tx_osc_clk = sr_clock_tx_osc_clk_or_clkdiv;

c3lib_ckand2_ctn cmn_clkand2_tx_hip_async_tx_osc_clk_scg (
  .clk_out    (tx_clock_hip_async_tx_osc_clk),
  .clk_in0    (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1    (tx_hip_osc_clk_en)
);

c3lib_ckand2_ctn cmn_clkand2_tx_async_tx_osc_clk_scg (
  .clk_out   (tx_clock_async_tx_osc_clk),
  .clk_in0   (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1   (tx_osc_clk_en)
);

////////// PMA AIB Clock //////////

assign tx_clock_pma_aib_tx_div2_clk = tx_clock_pma_aib_tx_clkdiv2_mux1;

// Non-Divided Clock
c3lib_ckbuf_ctn ckbuf_pma_aib_tx_clk (
  .out (tx_clock_pma_aib_tx_clk),
  .in  (tx_pma_clk)
);

// Divided Clock
c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (2),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (1000),       // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_ckdiv2_tx_pma (
  .i_func_clk     (tx_clock_pma_aib_tx_clk),
  .i_func_clken   (1'b1),                    
  .i_rst_n        (tx_reset_pma_aib_tx_clk_rst_n),                    
  .i_test_clk     (t2_test_clk),                
  .i_scan_clk     (t2_scan_clk),                
  .i_tst_tcm_ctrl (t2_tst_tcm_ctrl),            
  .o_clk          (tx_clock_pma_aib_tx_clkdiv2_mux1)
);

endmodule // c3adapt_txclk_ctl
	
