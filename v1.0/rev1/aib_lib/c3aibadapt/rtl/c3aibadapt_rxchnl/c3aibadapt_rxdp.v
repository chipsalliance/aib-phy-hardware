// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: c3aibadapt_rxdp.v.rca $
// Revision:    $Revision: #11 $
// Date:        $Date: 2017/03/29 $
//------------------------------------------------------------------------
// Description: Integration using emacs verilog then manual edit 
//
//------------------------------------------------------------------------

module c3aibadapt_rxdp (

/*AUTOinput  wire*/
input  wire                     rx_ehip_clk,
input  wire                     rx_elane_clk,
input  wire                     rx_rsfec_clk,
input  wire                     rx_pma_clk,
input  wire                     rx_ehip_rst_n,
input  wire                     rx_elane_rst_n,
input  wire                     rx_rsfec_rst_n,
input  wire                     rx_pma_rst_n,
input  wire			rx_hrdrst_asn_data_transfer_en,// To c3adapt_rxdp_asn of c3adapt_rxdp_asn.v
input  wire			rx_hrdrst_rx_fifo_srst,
input  wire [77:0]		rx_ehip_data,	// To c3adapt_rxdp_map  of c3adapt_rxdp_map.v
input  wire [77:0]		rx_elane_data,	// To c3adapt_rxdp_map  of c3adapt_rxdp_map.v
input  wire [77:0]		rx_rsfec_data,	// To c3adapt_rxdp_map  of c3adapt_rxdp_map.v
input  wire [39:0]              rx_pma_data,
input  wire [39:0]              tx_pma_data_lpbk,
input  wire                     tx_aib_transfer_clk,
input  wire                     tx_aib_transfer_clk_rst_n,
input  wire			txeq_invalid_req,       // To c3adapt_rxdp_txeq of c3adapt_rxdp_txeq.v
input  wire                     rx_clock_txeq_clk,
input  wire                     rx_reset_txeq_clk_rst_n,
input  wire [1:0]		pld_pma_pcie_sw_done,	// To c3adapt_rxdp_asn of c3adapt_rxdp_asn.v
input  wire			pld_pma_rx_found,	// To c3adapt_rxdp_map of c3adapt_rxdp_map.v
input  wire			pld_pmaif_mask_tx_pll,	// To c3adapt_rxdp_asn of c3adapt_rxdp_asn.v
input  wire			sr_pld_latency_pulse_sel,
input  wire			r_rx_align_del,		// To c3adapt_rxdp_intlkn_write_ctrl of c3adapt_rxdp_intlkn_write_ctrl.v
input  wire			r_rx_bonding_dft_in_en,	// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire			r_rx_bonding_dft_in_value,	// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire [8-1:0]	        r_rx_comp_cnt,		// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire [1:0]		r_rx_compin_sel,		// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire			r_rx_double_write,		// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire			r_rx_ds_bypass_pipeln,	// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire			r_rx_ds_master,		// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire [5-1:0]	        r_rx_fifo_empty,		// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire [1:0]		r_rx_fifo_mode,		// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire			r_rx_force_align,		// To c3adapt_rxdp_intlkn_write_ctrl of c3adapt_rxdp_intlkn_write_ctrl.v
input  wire [5-1:0]	        r_rx_fifo_full,			// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire			r_rx_indv,			// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire [3:0]		r_rx_mask_del,		// To c3adapt_rxdp_intlkn_write_ctrl of c3adapt_rxdp_intlkn_write_ctrl.v
input  wire [5-1:0]	        r_rx_fifo_pempty,		// To c3adapt_rxddp c3adapt_rxdp_fifo.v
input  wire [5-1:0]	        r_rx_fifo_pfull,		// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire [2:0]		r_rx_phcomp_rd_delay,	// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire	            	r_rx_asn_en,
input  wire	            	r_rx_slv_asn_en,
input  wire	            	r_rx_asn_bypass_clock_gate,
input  wire	            	r_rx_asn_bypass_pma_pcie_sw_done,
input  wire [6:0]      		r_rx_asn_wait_for_fifo_flush_cnt,
input  wire [6:0]      		r_rx_asn_wait_for_dll_reset_cnt,
input  wire [6:0]      		r_rx_asn_wait_for_clock_gate_cnt,
input  wire [6:0]      		r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
input  wire			r_rx_hrdrst_user_ctl_en,
input  wire [2:0]               r_rx_chnl_datapath_map_mode,
input  wire                     rx_direct_transfer_testbus,
input  wire                     r_rx_usertest_sel,
input  wire                     r_tx_latency_src_xcvrif,
input  wire                     r_rx_txeq_en,
input  wire                     r_rx_rxeq_en,
input  wire                     r_rx_pre_cursor_en,
input  wire                     r_rx_post_cursor_en,
input  wire                     r_rx_invalid_no_change,
input  wire                     r_rx_adp_go_b4txeq_en,
input  wire                     r_rx_use_rxvalid_for_rxeq,
input  wire                     r_rx_pma_rstn_en,

input  wire                     r_rx_pma_rstn_cycles,
input  wire [7:0]               r_rx_txeq_time,        // unit is 1us for 8'h100 cycles
input  wire [1:0]               r_rx_eq_iteration,     //


input  wire			r_rx_stop_read,		// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire			r_rx_stop_write,	// To c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
input  wire			r_rx_us_bypass_pipeln,	// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire			r_rx_us_master,		// To c3adapt_rxdp_cp_bond of c3adapt_rxdp_cp_bond.v
input  wire			r_rx_wm_en,		// To c3adapt_rxdp_word_mark of c3adapt_rxdp_word_mark.v
input wire [1:0]	        r_rx_fifo_power_mode,
input wire [2:0]	        r_rx_stretch_num_stages, 
input wire 		        r_rx_wr_adj_en, 
input wire                      r_rx_rd_adj_en,
input wire                      r_rx_msb_rdptr_pipe_byp,
input wire                      r_rx_aib_lpbk_en,
input wire [1:0]                r_rx_adapter_lpbk_mode,
input wire			r_rx_ds_last_chnl,
input wire			r_rx_us_last_chnl,
input wire                      pld_8g_rxelecidle, 
input wire                      pld_rx_prbs_done,
input wire                      pld_rx_prbs_err,
input  wire			rx_clock_asn_pma_hclk,	// To c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
input  wire			rx_clock_fifo_wr_clk,	// To c3adapt_rx_datapath_txeq of c3adapt_rx_datapath_txeq.v
input wire 			q1_rx_clock_fifo_wr_clk,
input wire 			q2_rx_clock_fifo_wr_clk,
input wire 			q3_rx_clock_fifo_wr_clk,
input wire 			q4_rx_clock_fifo_wr_clk,
input  wire [1:0]		rx_pld_rate,		// To c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
input  wire			rx_reset_asn_pma_hclk_rst_n,
input  wire			rx_reset_fifo_wr_rst_n,	// To c3adapt_rx_datapath_txeq of c3adapt_rx_datapath_txeq.v
input  wire			txeq_rxeqeval,		// To c3adapt_rx_datapath_txeq of c3adapt_rx_datapath_txeq.v
input  wire			txeq_rxeqinprogress,    // To c3adapt_rx_datapath_txeq of c3adapt_rx_datapath_txeq.v
input  wire                     txeq_txdetectrx,
input  wire   [1:0]             txeq_rate,
input  wire   [1:0]             txeq_powerdown,
input  wire			wr_align_clr,		// To c3adapt_rxdp_intlkn_wrctrl of c3adapt_rxdp_intlkn_wrctrl.v
// End of automatics
input wire 			rx_clock_fifo_rd_clk,   // from rx_clk module
input wire			rx_clock_fifo_sclk,
input wire 			rx_reset_fifo_rd_rst_n,
input wire 			rx_reset_fifo_sclk_rst_n,

input wire            		bond_rx_asn_ds_in_fifo_hold,
input wire            		bond_rx_asn_ds_in_clk_en,
input wire            		bond_rx_asn_ds_in_gen3_sel,
input wire            		bond_rx_asn_us_in_fifo_hold,
input wire 			bond_rx_asn_us_in_clk_en,
input wire	            	bond_rx_asn_us_in_gen3_sel,

input wire 			bond_rx_fifo_ds_in_rden,
input wire 			bond_rx_fifo_ds_in_wren,

input wire 			bond_rx_fifo_us_in_rden,
input wire 			bond_rx_fifo_us_in_wren,


input wire			rx_fifo_latency_adj_en,
input wire                      xcvrif_rx_latency_pls,
input wire [79:0]	        tx_fifo_data_lpbk,

input wire [4:1]                pld_pma_reserved_in,
input wire                      dft_adpt_rst,

/*AUTOoutput wire*/
// Beginning of automatic output wires (from unused autoinst output wires)
output wire [40-1:0]		aib_hssi_rx_data_out,	 // From c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
output wire			fifo_empty,		 // From c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
output wire			fifo_full,		 // From c3adapt_rxdp_fifo of c3adapt_rxdp_fifo.v
output wire [6:0]               aib_hip_txeq_in,
output wire			rx_asn_fifo_hold,	// From c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
output wire			rx_asn_rate_change_in_progress,
output wire			rx_asn_dll_lock_en,	// From c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
output wire			rx_asn_clk_en,		// From c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
output wire			rx_asn_gen3_sel,	// From c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
output wire [1:0]		rx_asn_rate,		// From c3adapt_rx_datapath_asn of c3adapt_rx_datapath_asn.v
// End of automatics

output wire [2:0]		pld_g3_current_rxpreset,
output wire			pma_adapt_rstn,

output wire			aib_hssi_rx_fifo_latency_pls,

output wire			rx_fifo_ready,

output wire [19:0]		rx_fifo_testbus1,
output wire [19:0]		rx_fifo_testbus2,
output wire [19:0]		rx_cp_bond_testbus,
output wire [19:0]		rx_asn_testbus1,
output wire [19:0]		rx_asn_testbus2,
output wire [19:0]		txeq_testbus1,
output wire [19:0]		txeq_testbus2

);

localparam		DWIDTH = 40;
localparam		CNTWIDTH = 8;
localparam		AWIDTH = 5;
localparam		PCSCWIDTH = 10;
localparam		PCSDWIDTH = 64;

wire 			asn_fifo_srst;
wire 			asn_gen3_sel;

wire 			comp_out_rden_en;
wire 			comp_out_wren_en;

wire 			comp_rden_en;
wire 			comp_wren_en;

wire [PCSCWIDTH-1:0]	control_in;
wire [PCSDWIDTH-1:0]	data_in;	

wire			double_write;
wire			double_write_int;

wire 			dv_en;
wire 			phcomp_rden;
wire 			phcomp_wren;

wire 			master_in_dv;
wire 			master_in_rden;
wire 			master_in_wren;

wire 			ds_in_dv;
wire 			ds_in_rden;
wire 			ds_in_wren;
wire 			us_in_dv;
wire 			us_in_rden;
wire 			us_in_wren;

wire 			ds_out_dv;
wire 			us_out_dv;

wire 			rd_clk;
wire 			rd_rst_n;	
wire 			rd_srst_n	= 1'b1;		// Tie sync reset to 1 for now	
wire 			s_clk;	
wire 			wr_clk;
wire			q1_wr_clk;
wire			q2_wr_clk;
wire			q3_wr_clk;
wire			q4_wr_clk;
wire 			wr_rst_n;
wire 			wr_srst_n	= 1'b1;		// Tie sync reset to 1 for now

wire 			rx_rdfifo_clk;		
wire 			rx_rdfifo_clk_rst_n;	
wire 			rx_wrfifo_clk;
wire 			rx_wrfifo_clk_rst_n;	
wire 			fifo_srst_n_rd_clk;
wire 			fifo_srst_n_wr_clk;

wire			latency_pulse;

//wire [1:0]		rx_pld_rate = 2'b00;		// Tie off for now

wire [79:0]		wm_data;
wire [79:0]		fifo_data_in;


wire [77:0]		word_marker_data;

//wire [19:0]		rx_cp_bond_testbus;		// To be connected to TB
wire [19:0]		rx_txeq_testbus;		// To be connected to TB


wire			fifo_pempty;			// To be connected to TB
wire			fifo_pfull;			// To be connected to TB

wire			pcs_phystatus	= 1'b0;		// Tie off for now. To be connected to RX mapping
wire			phystatus;			// Dangling ouput. To be connected to RX mapping
wire [2:0]		rxpresethint	= 'd0;		// Tie off for now. To be connected to RX mapping

wire			s_rst_n;
wire 		        fifo_empty_int;
wire                    fifo_full_int;
wire			compin_sel_rden;
wire			compin_sel_wren;
wire [DWIDTH-1:0]       pma_direct_data;
   
// Add _rx to DPRIO bit name
wire			r_align_del =			r_rx_align_del;		
wire			r_bonding_dft_in_en =		r_rx_bonding_dft_in_en;	
wire			r_bonding_dft_in_value =	r_rx_bonding_dft_in_value;
wire [8-1:0]	        r_comp_cnt =			r_rx_comp_cnt;		
wire [1:0]		r_compin_sel =			r_rx_compin_sel;		
wire			r_double_write =		r_rx_double_write;		
wire			r_ds_bypass_pipeln =		r_rx_ds_bypass_pipeln;	
wire			r_ds_master =			r_rx_ds_master;		
wire [5-1:0]	        r_empty =			r_rx_fifo_empty;		
wire [1:0]		r_fifo_mode =			r_rx_fifo_mode;		
wire			r_force_align =			r_rx_force_align;		
wire [5-1:0]	        r_full =			r_rx_fifo_full;			
wire			r_indv =			r_rx_indv;			
wire [3:0]		r_mask_del =			r_rx_mask_del;		
wire [5-1:0]	        r_pempty =			r_rx_fifo_pempty;		
wire [5-1:0]	        r_pfull =			r_rx_fifo_pfull;		
wire [2:0]		r_phcomp_rd_delay =		r_rx_phcomp_rd_delay;	
//wire [3:0]		r_rx_txeq_cnt =			r_rx_rx_txeq_cnt;		
//wire [7:0]		r_rx_txeq_time =		r_rx_rx_txeq_time;		
wire			r_stop_read =			r_rx_stop_read;		
wire			r_stop_write =			r_rx_stop_write;		
wire			r_us_bypass_pipeln =		r_rx_us_bypass_pipeln;	
wire			r_us_master =			r_rx_us_master;		
wire			r_wm_en =			r_rx_wm_en;		
//wire			r_write_ctrl =			r_rx_write_ctrl;
wire [1:0]		r_fifo_power_mode =		r_rx_fifo_power_mode;
wire			r_wr_adj_en 	  =	     	r_rx_wr_adj_en;
wire			r_rd_adj_en       =		r_rx_rd_adj_en;     
wire                    r_msb_rdptr_pipe_byp =          r_rx_msb_rdptr_pipe_byp;

wire                    rx_asn_data_transfer_en;
wire                    latency_pulse_mux1;
wire                    xcvrif_latency_sel;

//assign asn_fifo_srst	= rx_asn_fifo_srst;
assign asn_fifo_srst = rx_hrdrst_rx_fifo_srst;
assign asn_gen3_sel  = rx_asn_gen3_sel;

assign comp_rden_en  = comp_out_rden_en;
assign comp_wren_en  = comp_out_wren_en;

assign double_write  = double_write_int;

assign master_in_rden   = phcomp_rden;
assign master_in_wren   = phcomp_wren;

assign ds_in_rden	= r_rx_ds_last_chnl ? 1'b0 : bond_rx_fifo_ds_in_rden;
assign ds_in_wren	= r_rx_ds_last_chnl ? 1'b0 : bond_rx_fifo_ds_in_wren;

assign us_in_rden	= r_rx_us_last_chnl ? 1'b0 : bond_rx_fifo_us_in_rden;
assign us_in_wren	= r_rx_us_last_chnl ? 1'b0 : bond_rx_fifo_us_in_wren;

assign rd_clk		= rx_clock_fifo_rd_clk;
assign rx_rdfifo_clk	= rx_clock_fifo_rd_clk;

assign wr_clk		= rx_clock_fifo_wr_clk;
assign q1_wr_clk	= q1_rx_clock_fifo_wr_clk;
assign q2_wr_clk	= q2_rx_clock_fifo_wr_clk;
assign q3_wr_clk	= q3_rx_clock_fifo_wr_clk;
assign q4_wr_clk	= q4_rx_clock_fifo_wr_clk;
assign rx_wrfifo_clk	= rx_clock_fifo_wr_clk;

assign s_clk		= rx_clock_fifo_sclk;

assign rd_rst_n		= rx_reset_fifo_rd_rst_n;
assign wr_rst_n		= rx_reset_fifo_wr_rst_n;
assign rx_rdfifo_clk_rst_n = rx_reset_fifo_rd_rst_n;
assign rx_wrfifo_clk_rst_n = rx_reset_fifo_wr_rst_n;

assign s_rst_n		= rx_reset_fifo_sclk_rst_n;

// repurposed sr_pld_hssi_rx_asn_data_transfer_en to select between latency
// pulse from XCVRIF and Adapter
// assign sr_pld_latency_pulse_sel = sr_pld_hssi_rx_asn_data_transfer_en;
assign rx_asn_data_transfer_en  = 1'b0;

// assign aib_hssi_rx_fifo_latency_pls = r_rx_usertest_sel ? (sr_pld_latency_pulse_sel ? xcvrif_rx_latency_pls : latency_pulse) 
//                                                         : rx_direct_transfer_testbus;
assign xcvrif_latency_sel = r_tx_latency_src_xcvrif | sr_pld_latency_pulse_sel;

c3lib_mux2_svt_2x c3lib_latency_pulse_mux0 ( 

  .in0  (rx_direct_transfer_testbus),
  .in1  (latency_pulse_mux1),
  .sel  (r_rx_usertest_sel),
  .out  (aib_hssi_rx_fifo_latency_pls)); 

c3lib_mux2_svt_2x c3lib_latency_pulse_mux1 ( 

  .in0  (latency_pulse),
  .in1  (xcvrif_rx_latency_pls),
  .sel  (xcvrif_latency_sel),
  .out  (latency_pulse_mux1)); 

// Output of work-mark --> input of FIFO
assign fifo_data_in = r_wm_en ? {1'b1, wm_data[78:40], 1'b0, wm_data[38:0]} : wm_data;

assign wm_data	    = (r_rx_aib_lpbk_en & (r_rx_adapter_lpbk_mode == 2'b10)) ? tx_fifo_data_lpbk : {1'b0,word_marker_data[77:39],1'b0,word_marker_data[38:0]};

// temp arthur 0919
wire rx_pcs_phystatus;
wire rx_asn_phystatus;

wire        txeq_phystatus;
wire	    mark_bit_location;


assign txeq_testbus2	= 20'd0;

c3aibadapt_rxdp_map rxdp_map (/*AUTOINST*/
  // Outputs
  .rx_pcs_phystatus	      (rx_pcs_phystatus),
  .word_marker_data	      (word_marker_data[77:0]),
  .pma_direct_data	      (pma_direct_data[DWIDTH-1:0]),
  .mark_bit_location	      (mark_bit_location),
  // Inputs
  .r_wm_en                    (r_wm_en),
  .rx_ehip_clk                (rx_ehip_clk),
  .rx_elane_clk               (rx_elane_clk),
  .rx_rsfec_clk               (rx_rsfec_clk),
  .rx_pma_clk                 (rx_pma_clk),
  .rx_ehip_rst_n              (rx_ehip_rst_n),
  .rx_elane_rst_n             (rx_elane_rst_n),
  .rx_rsfec_rst_n             (rx_rsfec_rst_n),
  .rx_pma_rst_n               (rx_pma_rst_n),

  .rx_clock_fifo_wr_clk       (rx_clock_fifo_wr_clk),
  .rx_reset_fifo_wr_rst_n     (rx_reset_fifo_wr_rst_n),
  .r_dp_map_mode              (r_rx_chnl_datapath_map_mode[2:0]),
  .dft_adpt_rst               (dft_adpt_rst),
  .rx_asn_phystatus	      (rx_asn_phystatus),
  .pld_pma_rx_found	      (pld_pma_rx_found),
  .pld_8g_rxelecidle          (pld_8g_rxelecidle),
  .pld_rx_prbs_err            (pld_rx_prbs_err),
  .pld_rx_prbs_done           (pld_rx_prbs_done),
  .r_rx_aib_lpbk_en           (r_rx_aib_lpbk_en),
  .r_rx_adapter_lpbk_mode     (r_rx_adapter_lpbk_mode),
  .tx_aib_transfer_clk        (tx_aib_transfer_clk),          //For 1x loopback
  .tx_aib_transfer_clk_rst_n  (tx_aib_transfer_clk_rst_n),
  .tx_pma_data_lpbk           (tx_pma_data_lpbk),
  .rx_pma_data                (rx_pma_data),
  .rx_rsfec_data              (rx_rsfec_data),
  .rx_elane_data              (rx_elane_data),
  .rx_ehip_data               (rx_ehip_data));

c3aibadapt_rxdp_fifo rxdp_fifo(/*AUTOINST*/
  // Outputs
  .aib_hssi_rx_data_out     (aib_hssi_rx_data_out[DWIDTH-1:0]),
  .fifo_empty		    (fifo_empty_int),
  .fifo_pempty	            (fifo_pempty),
  .fifo_pfull               (fifo_pfull),
  .fifo_full                (fifo_full_int),
  .phcomp_wren	            (phcomp_wren),
  .phcomp_rden	            (phcomp_rden),
  .latency_pulse	    (latency_pulse),
  .double_write_int	    (double_write_int),
  .fifo_srst_n_wr_clk       (fifo_srst_n_wr_clk),
  .fifo_srst_n_rd_clk       (fifo_srst_n_rd_clk),
  .fifo_ready		    (rx_fifo_ready),
  .rx_fifo_testbus1	    (rx_fifo_testbus1),
  .rx_fifo_testbus2	    (rx_fifo_testbus2),

  // Inputs
  .wr_rst_n                 (wr_rst_n),
  .wr_srst_n                (wr_srst_n),
  .wr_clk                   (wr_clk),
  .q1_wr_clk                (q1_wr_clk),
  .q2_wr_clk                (q2_wr_clk),
  .q3_wr_clk                (q3_wr_clk),
  .q4_wr_clk                (q4_wr_clk),							
  .pma_direct_data          (pma_direct_data[DWIDTH-1:0]),
  .data_in                  (fifo_data_in[2*DWIDTH-1:0]),
  .rd_rst_n                 (rd_rst_n),
  .rd_srst_n                (rd_srst_n),
  .rd_clk                   (rd_clk),
  .s_clk                    (s_clk),
  .s_rst_n                  (s_rst_n),
  .r_pempty                 (r_pempty[AWIDTH-1:0]),
  .r_pfull                  (r_pfull[AWIDTH-1:0]),
  .r_empty                  (r_empty[AWIDTH-1:0]),
  .r_full                   (r_full[AWIDTH-1:0]),
  .r_stop_read	            (r_stop_read),
  .r_stop_write	            (r_stop_write),
  .r_double_write           (r_double_write),
  .r_fifo_mode	            (r_fifo_mode[1:0]),
  .r_phcomp_rd_delay        (r_phcomp_rd_delay[2:0]),
  .r_indv                   (r_indv),
  .r_fifo_power_mode        (r_fifo_power_mode),
  .r_wr_adj_en              (r_wr_adj_en),
  .r_rd_adj_en              (r_rd_adj_en),
  .r_msb_rdptr_pipe_byp     (r_msb_rdptr_pipe_byp),
  .fifo_latency_adj         (rx_fifo_latency_adj_en),
  .comp_wren_en	            (comp_wren_en),
  .comp_rden_en	            (comp_rden_en),
  .compin_sel_wren          (compin_sel_wren),
  .compin_sel_rden          (compin_sel_rden),
  .asn_fifo_srst            (asn_fifo_srst),
  .asn_fifo_hold            (rx_asn_fifo_hold),
  .asn_gen3_sel	            (asn_gen3_sel));   

c3aibadapt_rxdp_cp_bond rxdp_cp_bond(/*AUTOINST*/
  // Outputs
  .us_out_wren		(),
  .ds_out_wren		(),
  .us_out_rden		(),
  .ds_out_rden		(),
  .comp_out_wren_en	(comp_out_wren_en),
  .comp_out_rden_en	(comp_out_rden_en),
  .compin_sel_wren	(compin_sel_wren),
  .compin_sel_rden	(compin_sel_rden),
  .rx_cp_bond_testbus	(rx_cp_bond_testbus[19:0]),
  // Inputs
  .rx_wrfifo_clk	(rx_wrfifo_clk),
  .rx_rdfifo_clk	(rx_rdfifo_clk),
  .rx_rdfifo_clk_rst_n	(rx_rdfifo_clk_rst_n),
  .rx_wrfifo_clk_rst_n	(rx_wrfifo_clk_rst_n),
  .wr_srst_n		(fifo_srst_n_wr_clk),
  .rd_srst_n		(fifo_srst_n_rd_clk),
  .double_write		(double_write),
  .r_us_master		(r_us_master),
  .r_ds_master		(r_ds_master),
  .r_us_bypass_pipeln	(r_us_bypass_pipeln),
  .r_ds_bypass_pipeln	(r_ds_bypass_pipeln),
  .r_compin_sel		(r_compin_sel[1:0]),
  .r_comp_cnt		(r_comp_cnt[CNTWIDTH-1:0]),
  .r_bonding_dft_in_en	(r_bonding_dft_in_en),
  .r_bonding_dft_in_value(r_bonding_dft_in_value),
  .master_in_wren	(master_in_wren),
  .us_in_wren		(us_in_wren),
  .ds_in_wren		(ds_in_wren),
  .master_in_rden	(master_in_rden),
  .us_in_rden		(us_in_rden),
  .ds_in_rden		(ds_in_rden));

c3aibadapt_rxdp_asn rxdp_asn (/*AUTOINST*/
  // Outputs
  .bond_rx_asn_ds_out_fifo_hold           (),
  .bond_rx_asn_ds_out_clk_en              (),
  .bond_rx_asn_ds_out_gen3_sel            (),
  .bond_rx_asn_us_out_fifo_hold           (),
  .bond_rx_asn_us_out_clk_en              (),
  .bond_rx_asn_us_out_gen3_sel            (),
  .rx_asn_rate	                          (rx_asn_rate[1:0]),
  .rx_asn_fifo_hold	                  (rx_asn_fifo_hold),
  .rx_asn_rate_change_in_progress         (rx_asn_rate_change_in_progress),
  .rx_asn_dll_lock_en                     (rx_asn_dll_lock_en),
  .rx_asn_clk_en                          (rx_asn_clk_en),
  .rx_asn_gen3_sel	                  (rx_asn_gen3_sel),
  .rx_asn_phystatus                       (rx_asn_phystatus),
  .rx_asn_testbus1                        (rx_asn_testbus1),
  .rx_asn_testbus2                        (rx_asn_testbus2),
  // Inputs
  .rx_clock_asn_pma_hclk                  (rx_clock_asn_pma_hclk),
  .rx_clock_fifo_wr_clk                   (rx_clock_fifo_wr_clk),
  .rx_reset_asn_pma_hclk_rst_n            (rx_reset_asn_pma_hclk_rst_n),
  .rx_reset_fifo_wr_rst_n                 (rx_reset_fifo_wr_rst_n),
  .rx_pld_rate	                          (rx_pld_rate[1:0]),
  .pld_pmaif_mask_tx_pll                  (pld_pmaif_mask_tx_pll),
  .pld_pma_pcie_sw_done                   (pld_pma_pcie_sw_done[1:0]),
  .sr_pld_hssi_rx_asn_data_transfer_en    (rx_asn_data_transfer_en),
  .rx_hrdrst_asn_data_transfer_en         (rx_hrdrst_asn_data_transfer_en),
  .rx_pcs_phystatus                       (rx_pcs_phystatus),
  .bond_rx_asn_ds_in_fifo_hold            (bond_rx_asn_ds_in_fifo_hold),
  .bond_rx_asn_ds_in_clk_en               (bond_rx_asn_ds_in_clk_en),
  .bond_rx_asn_ds_in_gen3_sel             (bond_rx_asn_ds_in_gen3_sel),
  .bond_rx_asn_us_in_fifo_hold            (bond_rx_asn_us_in_fifo_hold),
  .bond_rx_asn_us_in_clk_en               (bond_rx_asn_us_in_clk_en),
  .bond_rx_asn_us_in_gen3_sel             (bond_rx_asn_us_in_gen3_sel),
  .r_rx_asn_en                            (r_rx_asn_en),
  .r_rx_slv_asn_en                        (r_rx_slv_asn_en),
  .r_rx_asn_bypass_clock_gate             (r_rx_asn_bypass_clock_gate),
  .r_rx_asn_bypass_pma_pcie_sw_done       (r_rx_asn_bypass_pma_pcie_sw_done),
  .r_rx_asn_wait_for_fifo_flush_cnt       (r_rx_asn_wait_for_fifo_flush_cnt[6:0]),
  .r_rx_asn_wait_for_dll_reset_cnt        (r_rx_asn_wait_for_dll_reset_cnt[6:0]),
  .r_rx_asn_wait_for_clock_gate_cnt       (r_rx_asn_wait_for_clock_gate_cnt[6:0]),
  .r_rx_asn_wait_for_pma_pcie_sw_done_cnt (r_rx_asn_wait_for_pma_pcie_sw_done_cnt[6:0]),
  .r_rx_master_sel                        (r_rx_compin_sel[1:0]),
  .r_rx_dist_master_sel                   (r_rx_ds_master),
  .r_rx_bonding_dft_in_en                 (r_rx_bonding_dft_in_en),
  .r_rx_bonding_dft_in_value              (r_rx_bonding_dft_in_value),
  .r_rx_hrdrst_user_ctl_en                (r_rx_hrdrst_user_ctl_en));

c3aibadapt_rxdp_txeq	rxdp_txeq (/*AUTOINST*/
  // Outputs
  .pld_g3_current_rxpreset    (pld_g3_current_rxpreset[2:0]),
  .txeq_dirfeedback	      (),
  .txeq_phystatus	      (txeq_phystatus),
  .aib_hip_txeq_in            (aib_hip_txeq_in),
  .pma_adapt_rstn             (pma_adapt_rstn),
  .rx_txeq_testbus            (txeq_testbus1),
  // Inputs
  .rx_clock_txeq_clk          (rx_clock_txeq_clk),
  .rx_reset_txeq_clk_rst_n    (rx_reset_txeq_clk_rst_n),
  
  .r_rx_txeq_en               (1'b0),                                  // r_rx_txeq_en .. TXEQ not supported in CR3
  .r_rx_rxeq_en               (1'b0),                                  // r_rx_rxeq_en .. TXEQ not supported in CR3
  .r_rx_pre_cursor_en         (1'b0),                            // r_rx_pre_cursor_en.. TXEQ not supported in CR3
  .r_rx_post_cursor_en        (1'b0),                           // r_rx_post_cursor_en.. TXEQ not supported in CR3
  .r_rx_invalid_no_change     (1'b0),                        // r_rx_invalid_no_change.. TXEQ not supported in CR3
  .r_rx_adp_go_b4txeq_en      (1'b0),                         // r_rx_adp_go_b4txeq_en .. TXEQ not supported in CR3
  .r_rx_use_rxvalid_for_rxeq  (1'b0),                     // r_rx_use_rxvalid_for_rxeq.. TXEQ not supported in CR3
  .r_rx_pma_rstn_en           (r_rx_pma_rstn_en),
  .r_rx_pma_rstn_cycles       (r_rx_pma_rstn_cycles),
  
  .r_rx_txeq_time	      (8'h00),                            // r_rx_txeq_time[7:0] .. TXEQ not supported in CR3
  .r_rx_eq_iteration	      (r_rx_eq_iteration[1:0]),
  
  .txeq_rxeqinprogress	      (txeq_rxeqinprogress),
  .txeq_rxeqeval	      (txeq_rxeqeval),
  .txeq_invalid_req           (txeq_invalid_req),
  .txeq_txdetectrx            (txeq_txdetectrx),
  .txeq_rate                  (txeq_rate),
  .txeq_powerdown             (txeq_powerdown),
  .txeq_rxvalid               (1'b0),
  .txeq_rxelecidle            (1'b0),
  .pld_pma_reserved_in        (pld_pma_reserved_in[4:1]));

// Pulse-stretch signals before being capture by osc_clk
// Flag pulse-stretch
   c3aibadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) cmn_pulse_stretch_fifo_full
     (
      .clk           (wr_clk),
      .rst_n         (wr_rst_n),             
      .num_stages    (r_rx_stretch_num_stages),
      .data_in       (fifo_full_int),
      .data_out      (fifo_full)                      
      );

   c3aibadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (1)    	// Reset Value 
       ) cmn_pulse_stretch_fifo_empty
     (
      .clk           (rd_clk),
      .rst_n         (rd_rst_n),             
      .num_stages    (r_rx_stretch_num_stages),
      .data_in       (fifo_empty_int),
      .data_out      (fifo_empty)                      
      );

endmodule
