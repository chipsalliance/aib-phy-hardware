// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: c3aibadapt_txdp.v.rca $
// Revision:    $Revision: #6 $
// Date:        $Date: 2017/03/29 $
//------------------------------------------------------------------------
// Description: Integration using emacs verilog 
//
//------------------------------------------------------------------------


module c3aibadapt_txdp (

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input wire  [40-1:0]	        aib_hssi_tx_data_in,	// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v, ...
input wire			aib_hssi_pld_tx_fifo_latency_adj_en,
input wire 			tx_direct_transfer_testbus,	// To c3adapt_txdp_map of c3adapt_txdp_map.v
input wire  [39:0]		aib_hssi_rx_data_out,                                 
input wire                      r_tx_rev_lpbk,                              
input wire 			r_tx_bonding_dft_in_en,	        // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire 			r_tx_bonding_dft_in_value,	// To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire  [8-1:0]	        r_tx_comp_cnt,		        // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire  [1:0]		r_tx_compin_sel,		// To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire 			r_tx_double_read,		// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire 			r_tx_ds_bypass_pipeln,	        // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire 			r_tx_ds_master,		        // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire  [5-1:0]	        r_tx_fifo_empty,		// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire  [1:0]		r_tx_fifo_mode,		        // To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire  [5-1:0]	        r_tx_fifo_full,		        // To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire 			r_tx_indv,			// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire  [5-1:0]	        r_tx_fifo_pempty,		// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire  [5-1:0]	        r_tx_fifo_pfull,		// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire  [2:0]		r_tx_phcomp_rd_delay,	        // To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire 			r_tx_stop_read,		        // To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire 			r_tx_stop_write,		// To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v
input wire [2:0] 	        r_tx_chnl_datapath_map_mode,// To c3adapt_txdp_map of c3adapt_txdp_map.v
input wire 			r_tx_us_bypass_pipeln,	                     // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire 			r_tx_us_master,		                     // To c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
input wire 			r_tx_wa_en,		                     // To c3adapt_txdp_fifo of c3adapt_txdp_fifo.v, ...
input wire [1:0]	        r_tx_fifo_power_mode,
input wire [4:0]                r_tx_wren_fastbond,                                 
input wire [2:0]	        r_tx_stretch_num_stages, 
input wire [2:0]	        r_tx_datapath_tb_sel, 
input wire 		        r_tx_wr_adj_en, 
input wire                      r_tx_rd_adj_en,
input wire		        r_tx_dv_gating_en,
input wire			r_tx_ds_last_chnl,
input wire			r_tx_us_last_chnl,
input wire			r_tx_presethint_bypass,
input wire			r_tx_usertest_sel,
input wire                      r_tx_latency_src_xcvrif,

input wire                      tx_ehip_clk,      
input wire                      tx_elane_clk,      
input wire                      tx_rsfec_clk,      
input wire                      tx_aib_transfer_clk,
input wire                      tx_ehip_rst_n,
input wire                      tx_elane_rst_n,
input wire                      tx_rsfec_rst_n,
input wire                      tx_aib_transfer_rst_n,

input wire 			tx_clock_fifo_rd_clk,	// To c3adapt_txdp_map of c3adapt_txdp_map.v
input wire 			tx_reset_fifo_rd_rst_n,	// To c3adapt_txdp_map of c3adapt_txdp_map.v
input wire 			tx_clock_fifo_sclk,
input wire 			tx_clock_fifo_wr_clk,
input  wire			q1_tx_clock_fifo_wr_clk,
input  wire			q2_tx_clock_fifo_wr_clk,
input  wire			q3_tx_clock_fifo_wr_clk,
input  wire			q4_tx_clock_fifo_wr_clk,
input wire			tx_reset_fifo_wr_rst_n,
input wire			tx_reset_fifo_sclk_rst_n,

input wire 			bond_tx_fifo_ds_in_dv,
input wire 			bond_tx_fifo_ds_in_rden,
input wire 			bond_tx_fifo_ds_in_wren,

input wire 			bond_tx_fifo_us_in_dv,
input wire 			bond_tx_fifo_us_in_rden,
input wire 			bond_tx_fifo_us_in_wren,

input wire 			tx_asn_fifo_hold,
input wire 			tx_asn_fifo_srst,
input wire		        pipe_mode,

input wire [2:0] 		pld_g3_current_rxpreset,
input wire  		        dft_adpt_rst,
input wire                      pld_pma_tx_qpi_pulldn_sr,
input wire                      pld_pma_tx_qpi_pullup_sr,
input wire                      pld_pma_rx_qpi_pullup_sr,
input wire                      xcvrif_tx_latency_pls,
input wire                      r_tx_qpi_sr_enable,
input wire                      sr_pld_latency_pulse_sel,

// Beginning of automatic output wire s (from unused autoinst output wire s)
//output wire 			asn_fifo_srst_n_rd_clk,	// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			asn_fifo_srst_n_wr_clk,	// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			comp_out_dv_en,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			comp_out_rden_en,	// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			comp_out_wren_en,	// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			double_read_int,	// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			ds_out_dv,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			ds_out_rden,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			ds_out_wren,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			dv_en,			// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire 			fifo_empty,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire 			fifo_full,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			fifo_pempty,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			fifo_pfull,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire  [77:0]		tx_ehip_data,	        // From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire  [77:0]             tx_elane_data,
output wire  [77:0]             tx_rsfec_data,
output wire  [39:0]             tx_pma_data,
//output wire  [63:0]		hip_tx_data,		// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			txeq_invalid_req,       // From c3adapt_txdp_map     of c3adapt_txdp_map.v
//output wire 			latency_pulse,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			phcomp_rden,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			phcomp_wren,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire 			pld_10g_tx_burst_en,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_10g_tx_data_valid,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire  [1:0]		pld_10g_tx_diag_status,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_10g_tx_wordslip,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_8g_rddisable_tx,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_8g_wrenable_tx,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_pma_rx_qpi_pullup,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_pma_tx_qpi_pulldn,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire 			pld_pma_tx_qpi_pullup,	// From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire [1:0]  		rx_pld_rate,
//output wire 			rd_en_reg,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire 			txeq_rxeqeval,		// From c3adapt_txdp_map     of c3adapt_txdp_ma.v
output wire 			txeq_rxeqinprogress,    // From c3adapt_txdp_map     of c3adapt_txdp_map.v
output wire                     txeq_txdetectrx, 
output wire  [1:0]              txeq_rate,  
output wire  [1:0]              txeq_powerdown,
output wire  [19:0]		tx_cp_bond_testbus,	// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire  [2*40-1:0]	tx_fifo_data_out,	// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
//output wire 			us_out_dv,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			us_out_rden,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
//output wire 			us_out_wren,		// From c3adapt_txdp_cp_bond of c3adapt_txdp_cp_bond.v
output wire 			wa_error,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire  [3:0]		wa_error_cnt,		// From c3adapt_txdp_fifo    of c3adapt_txdp_fifo.v
output wire  [79:0]		tx_fifo_data_lpbk,


// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
output wire			aib_hssi_tx_fifo_latency_pls,
output wire 			bond_tx_fifo_ds_out_dv,
output wire 			bond_tx_fifo_ds_out_rden,
output wire 			bond_tx_fifo_ds_out_wren,
output wire 			bond_tx_fifo_us_out_dv,
output wire 			bond_tx_fifo_us_out_rden,
output wire 			bond_tx_fifo_us_out_wren,
output wire			tx_fifo_ready,

output wire [19:0]              tx_fifo_testbus1, // RX FIFO
output wire [19:0]              tx_fifo_testbus2, // RX FIFO
output wire [19:0]              word_align_testbus,

output wire			align_done


);


localparam		DWIDTH = 40;
localparam		CNTWIDTH = 8;
localparam		AWIDTH = 5;

wire			wa_lock;		// From c3adapt_txdp_word_align of c3adapt_txdp_word_align.v
// End of automatics

wire 			comp_out_dv_en;
wire 			comp_out_rden_en;
wire 			comp_out_wren_en;

wire 			comp_dv_en;
wire 			comp_rden_en;
wire 			comp_wren_en;

wire 			data_valid_in_raw = 1'b1;	// To be removed
wire 			double_read;		

wire 			double_read_int;

wire 			dv_en;
wire 			phcomp_rden;
wire 			phcomp_wren;

wire 			master_in_dv;
wire 			master_in_rden;
wire 			master_in_wren;

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

wire 			tx_rdfifo_clk;		
wire 			tx_rdfifo_clk_rst_n;	
wire 			tx_wrfifo_clk;
wire 			tx_wrfifo_clk_rst_n;	
wire 			fifo_srst_n_rd_clk;
wire 			fifo_srst_n_wr_clk;

wire 			latency_pulse;
//wire  [19:0]		tx_cp_bond_testbus;		// To be connected to testbus
wire  [79:0] 		tx_fifo_data_out;
wire  [79:0]		word_align_datain;
wire 			word_align_cmd;

wire 			ds_in_dv;
wire 			ds_in_rden;
wire 			ds_in_wren;
wire 			us_in_dv;
wire 			us_in_rden;
wire 			us_in_wren;

wire 			ds_out_dv;
wire 			ds_out_rden;
wire 			ds_out_wren;
wire 			us_out_dv;
wire 			us_out_rden;
wire 			us_out_wren;

wire 			wr_en = 1'b0;			// To be removed

wire 			fifo_pempty;
wire 			fifo_pfull;

wire 			rd_en_reg;

wire 			asn_fifo_hold;
wire 			asn_fifo_srst;
wire 			asn_gen3_sel;

// wire 			wa_error;			// To be connected to TB/status
// wire  [3:0]		wa_error_cnt;			// To be connected to TB/status
wire			s_rst_n;
wire 		        fifo_empty_int;
wire                    fifo_full_int;

//assign  		tx_fifo_testbus1 = 20'd0;	// To be connected to TB
//assign  		tx_fifo_testbus2 = 20'd0;  	// To be connected to TB
//assign  		word_align_testbus = 20'd0;     // To be connected to TB

wire			mark_bit_location;
wire			compin_sel_rden;
wire			compin_sel_wren;
wire                    xcvrif_latency_sel;
wire                    latency_pulse_mux1;

// Add _tx to DPRIO bit name
wire 			r_bonding_dft_in_en =		r_tx_bonding_dft_in_en;	
wire 			r_bonding_dft_in_value =	r_tx_bonding_dft_in_value;	
wire  [8-1:0]	        r_comp_cnt =			r_tx_comp_cnt;		
wire  [1:0]		r_compin_sel =			r_tx_compin_sel;		
wire 			r_double_read =			r_tx_double_read;		
wire 			r_ds_bypass_pipeln =		r_tx_ds_bypass_pipeln;	
wire 			r_ds_master =			r_tx_ds_master;		
wire  [5-1:0]	        r_empty =			r_tx_fifo_empty;		
wire  [1:0]		r_fifo_mode =			r_tx_fifo_mode;		
wire  [5-1:0]	        r_full =			r_tx_fifo_full;			
wire 			r_indv =			r_tx_indv;			
wire  [5-1:0]	        r_pempty =			r_tx_fifo_pempty;		
wire  [5-1:0]	        r_pfull =			r_tx_fifo_pfull;		
wire  [2:0]		r_phcomp_rd_delay =		r_tx_phcomp_rd_delay;	
wire 			r_stop_read =			r_tx_stop_read;		
wire 			r_stop_write =			r_tx_stop_write;		
wire 			r_us_bypass_pipeln =		r_tx_us_bypass_pipeln;
wire 			r_us_master =			r_tx_us_master;		
wire 			r_wa_en =			r_tx_wa_en;		
wire [1:0]		r_fifo_power_mode =		r_tx_fifo_power_mode;
wire			r_wr_adj_en 	  =	     	r_tx_wr_adj_en;
wire			r_rd_adj_en       =		r_tx_rd_adj_en;

assign tx_fifo_data_lpbk = tx_fifo_data_out;

assign comp_dv_en 	=	comp_out_dv_en;
assign comp_rden_en	= 	comp_out_rden_en;
assign comp_wren_en	= 	comp_out_wren_en;

assign double_read	= 	double_read_int;

assign master_in_dv	= dv_en;
assign master_in_rden   = phcomp_rden;
assign master_in_wren   = phcomp_wren;

assign rd_clk		= tx_clock_fifo_rd_clk;
assign tx_rdfifo_clk	= tx_clock_fifo_rd_clk;

assign wr_clk		= tx_clock_fifo_wr_clk;
assign q1_wr_clk	= q1_tx_clock_fifo_wr_clk;
assign q2_wr_clk	= q2_tx_clock_fifo_wr_clk;
assign q3_wr_clk	= q3_tx_clock_fifo_wr_clk;
assign q4_wr_clk	= q4_tx_clock_fifo_wr_clk;
assign tx_wrfifo_clk	= tx_clock_fifo_wr_clk;

assign s_clk		= tx_clock_fifo_sclk;

assign rd_rst_n		= tx_reset_fifo_rd_rst_n;
assign wr_rst_n		= tx_reset_fifo_wr_rst_n;
assign tx_rdfifo_clk_rst_n	= 	tx_reset_fifo_rd_rst_n;
assign tx_wrfifo_clk_rst_n	= 	tx_reset_fifo_wr_rst_n;

assign s_rst_n		= tx_reset_fifo_sclk_rst_n;

// assign aib_hssi_tx_fifo_latency_pls = r_tx_usertest_sel ? (xcvrif_latency_sel  ? xcvrif_tx_latency_pls : latency_pulse) 
//                                                         : tx_direct_transfer_testbus;

assign xcvrif_latency_sel = r_tx_latency_src_xcvrif | sr_pld_latency_pulse_sel;

c3lib_mux2_svt_2x c3lib_latency_pulse_mux0 ( 

  .in0  (tx_direct_transfer_testbus),
  .in1  (latency_pulse_mux1),
  .sel  (r_tx_usertest_sel),
  .out  (aib_hssi_tx_fifo_latency_pls)); 

c3lib_mux2_svt_2x c3lib_latency_pulse_mux1 ( 

  .in0  (latency_pulse),
  .in1  (xcvrif_tx_latency_pls),
  .sel  (xcvrif_latency_sel),
  .out  (latency_pulse_mux1)); 

// assign word_align_datain	= tx_fifo_data_out;  // add muxing for reverse loopback
assign word_align_datain	= r_tx_rev_lpbk ? {40'd0, aib_hssi_rx_data_out} : tx_fifo_data_out;
assign word_align_cmd		= rd_en_reg;

// late change right before final SYN (so not an ECO like on ND)   
//assign ds_in_wren	= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_wren;
//assign ds_in_wren	= (!r_tx_ds_last_chnl && r_tx_wren_fastbond[4]) ? bond_tx_fifo_ds_in_wren : (!r_tx_ds_last_chnl && !r_tx_wren_fastbond[3]) ? bond_tx_fifo_ds_in_wren : 1'b0;
assign ds_in_wren	= (!r_tx_ds_last_chnl && r_tx_wren_fastbond[3]) ? bond_tx_fifo_ds_in_wren : (!r_tx_ds_last_chnl && r_tx_wren_fastbond[2]) ? bond_tx_fifo_ds_in_wren : !r_tx_ds_last_chnl ? bond_tx_fifo_ds_in_wren : 1'b0;
//assign us_in_wren	= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_wren;
//assign us_in_wren	= (!r_tx_us_last_chnl && r_tx_wren_fastbond[2]) ? bond_tx_fifo_us_in_wren : (!r_tx_us_last_chnl && !r_tx_wren_fastbond[1]) ? bond_tx_fifo_us_in_wren : 1'b0;
assign us_in_wren	= (!r_tx_us_last_chnl && r_tx_wren_fastbond[1]) ? bond_tx_fifo_us_in_wren : (!r_tx_us_last_chnl && r_tx_wren_fastbond[0]) ? bond_tx_fifo_us_in_wren : !r_tx_us_last_chnl ? bond_tx_fifo_us_in_wren : 1'b0;
   
assign ds_in_dv		= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_dv;
assign ds_in_rden	= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_rden;

assign us_in_dv		= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_dv;
assign us_in_rden	= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_rden;

assign bond_tx_fifo_ds_out_dv	= ds_out_dv;
assign bond_tx_fifo_ds_out_rden	= ds_out_rden;
assign bond_tx_fifo_ds_out_wren	= ds_out_wren;

assign bond_tx_fifo_us_out_dv	= us_out_dv;
assign bond_tx_fifo_us_out_rden	= us_out_rden;
assign bond_tx_fifo_us_out_wren	= us_out_wren;

assign asn_fifo_hold	= tx_asn_fifo_hold;
assign asn_fifo_srst	= tx_asn_fifo_srst;
assign asn_gen3_sel	= 1'b0;

assign align_done	= rd_en_reg;

c3aibadapt_txdp_map  txdp_map   (
    // Outputs
    .rx_pld_rate                    (rx_pld_rate),
    .pld_10g_tx_data_valid          (pld_10g_tx_data_valid),
    .pld_pma_rx_qpi_pullup          (pld_pma_rx_qpi_pullup),
    .pld_pma_tx_qpi_pulldn          (pld_pma_tx_qpi_pulldn),
    .pld_pma_tx_qpi_pullup          (pld_pma_tx_qpi_pullup),
    .pld_10g_tx_burst_en	    (pld_10g_tx_burst_en),
    .pld_10g_tx_wordslip	    (pld_10g_tx_wordslip),
    .pld_10g_tx_diag_status         (pld_10g_tx_diag_status),
    .pld_8g_rddisable_tx	    (pld_8g_rddisable_tx),
    .pld_8g_wrenable_tx	            (pld_8g_wrenable_tx),
    .txeq_rxeqeval                  (txeq_rxeqeval),
    .txeq_rxeqinprogress	    (txeq_rxeqinprogress),
    .txeq_invalid_req	            (txeq_invalid_req),
    .txeq_txdetectrx                (txeq_txdetectrx),
    .txeq_rate                      (txeq_rate),
    .txeq_powerdown                 (txeq_powerdown),
    .tx_ehip_data	            (tx_ehip_data[77:0]),
    .tx_elane_data                  (tx_elane_data[77:0]),
    .tx_rsfec_data                  (tx_rsfec_data[77:0]),
    .tx_pma_data                    (tx_pma_data[39:0]),
    .mark_bit_location	            (mark_bit_location),

    // Inputs
    .r_tx_presethint_bypass         (r_tx_presethint_bypass),
    .r_tx_chnl_datapath_map_mode    (r_tx_chnl_datapath_map_mode),
    .r_tx_qpi_sr_enable             (r_tx_qpi_sr_enable),
    .r_tx_wa_en                     (r_wa_en),		
    .aib_hssi_tx_data_in            (aib_hssi_tx_data_in),
    .pld_pma_tx_qpi_pulldn_sr       (pld_pma_tx_qpi_pulldn_sr),
    .pld_pma_tx_qpi_pullup_sr       (pld_pma_tx_qpi_pullup_sr),
    .pld_pma_rx_qpi_pullup_sr       (pld_pma_rx_qpi_pullup_sr),
    .dft_adpt_rst                   (dft_adpt_rst),
    .pld_g3_current_rxpreset        (pld_g3_current_rxpreset),
    //.hip_hssi_tx_data	          (hip_hssi_tx_data[75:0]),
    .word_align_cmd	            (word_align_cmd),
    .word_align_datain	            (word_align_datain[79:0]),
     // TX Synch path
    .tx_ehip_clk                    (tx_ehip_clk),
    .tx_elane_clk                   (tx_elane_clk),
    .tx_rsfec_clk                   (tx_rsfec_clk),
    .tx_aib_transfer_clk            (tx_aib_transfer_clk),
    .tx_ehip_rst_n                  (tx_ehip_rst_n),
    .tx_elane_rst_n                 (tx_elane_rst_n),
    .tx_rsfec_rst_n                 (tx_rsfec_rst_n),
    .tx_aib_transfer_rst_n          (tx_aib_transfer_rst_n),

    .tx_clock_fifo_rd_clk	    (tx_clock_fifo_rd_clk),
    .tx_reset_fifo_rd_rst_n         (tx_reset_fifo_rd_rst_n));

   
c3aibadapt_txdp_fifo txdp_fifo(/*AUTOINST*/
    // Outputs
    .tx_fifo_data_out	  (tx_fifo_data_out[2*DWIDTH-1:0]),
    .rd_en_reg		  (rd_en_reg),
    .fifo_empty		  (fifo_empty_int),
    .fifo_pempty	  (fifo_pempty),
    .fifo_pfull		  (fifo_pfull),
    .fifo_full		  (fifo_full_int),
    .phcomp_wren	  (phcomp_wren),
    .phcomp_rden	  (phcomp_rden),
    .dv_en		  (dv_en),
    .latency_pulse	  (latency_pulse),
    .wa_error		  (wa_error),
    .wa_error_cnt	  (wa_error_cnt[3:0]),
    .double_read_int	  (double_read_int),
    .fifo_srst_n_wr_clk   (fifo_srst_n_wr_clk),
    .fifo_srst_n_rd_clk   (fifo_srst_n_rd_clk),
    .fifo_ready		  (tx_fifo_ready),
    .tx_fifo_testbus1	  (tx_fifo_testbus1),
    .tx_fifo_testbus2	  (tx_fifo_testbus2),

    // Inputs
    .wr_rst_n		  (wr_rst_n),
    .wr_srst_n		  (wr_srst_n),
    .wr_clk		  (wr_clk),
    .q1_wr_clk		  (q1_wr_clk),
    .q2_wr_clk		  (q2_wr_clk),
    .q3_wr_clk		  (q3_wr_clk),
    .q4_wr_clk		  (q4_wr_clk),
    .wr_en		  (wr_en),
    .aib_hssi_tx_data_in  (aib_hssi_tx_data_in[DWIDTH-1:0]),
    .rd_rst_n		  (rd_rst_n),
    .rd_srst_n		  (rd_srst_n),
    .rd_clk		  (rd_clk),
    .s_clk		  (s_clk),
    .s_rst_n		  (s_rst_n),
    .r_pempty		  (r_pempty[AWIDTH-1:0]),
    .r_pfull		  (r_pfull[AWIDTH-1:0]),
    .r_empty		  (r_empty[AWIDTH-1:0]),
    .r_full		  (r_full[AWIDTH-1:0]),
    .r_stop_read	  (r_stop_read),
    .r_stop_write	  (r_stop_write),
    .r_double_read	  (r_double_read),
    .r_fifo_mode	  (r_fifo_mode[1:0]),
    .r_phcomp_rd_delay	  (r_phcomp_rd_delay[2:0]),
    .r_indv		  (r_indv),
    .r_wa_en		  (r_wa_en),
    .r_fifo_power_mode    (r_fifo_power_mode),
    .r_wr_adj_en          (r_wr_adj_en),
    .r_rd_adj_en          (r_rd_adj_en),
    .r_dv_gating_en	  (r_tx_dv_gating_en),
    .r_us_bypass_pipeln	  (r_us_bypass_pipeln),
    .pipe_mode		  (pipe_mode),
    .fifo_latency_adj	  (aib_hssi_pld_tx_fifo_latency_adj_en),
    .comp_dv_en		  (comp_dv_en),
    .comp_wren_en	  (comp_wren_en),
    .comp_rden_en	  (comp_rden_en),
    .compin_sel_wren	  (compin_sel_wren),
    .compin_sel_rden	  (compin_sel_rden),
    .asn_fifo_hold	  (asn_fifo_hold),
    .asn_fifo_srst	  (asn_fifo_srst),
    .asn_gen3_sel	  (asn_gen3_sel),
    .wa_lock		  (wa_lock));   

c3aibadapt_txdp_word_align txdp_word_align(/*AUTOINST*/
    // Outputs
    .wa_lock	        (wa_lock),
    .word_align_testbus	(word_align_testbus),
    // Inputs
    .wr_clk		(wr_clk),
    .wr_rst_n	        (wr_rst_n),
    .wr_srst_n          (fifo_srst_n_wr_clk),
    .r_wa_en	        (r_wa_en),
    .mark_bit_location 	(mark_bit_location),
    .aib_hssi_tx_data_in(aib_hssi_tx_data_in[DWIDTH-1:0]));

c3aibadapt_txdp_cp_bond txdp_cp_bond(/*AUTOINST*/
								  // Outputs
								  .us_out_dv		(us_out_dv),
								  .ds_out_dv		(ds_out_dv),
								  .us_out_wren		(us_out_wren),
								  .ds_out_wren		(ds_out_wren),
								  .us_out_rden		(us_out_rden),
								  .ds_out_rden		(ds_out_rden),
								  .comp_out_dv_en	(comp_out_dv_en),
								  .comp_out_wren_en	(comp_out_wren_en),
								  .comp_out_rden_en	(comp_out_rden_en),
							          .compin_sel_wren	(compin_sel_wren),
							          .compin_sel_rden	(compin_sel_rden),
								  .tx_cp_bond_testbus	(tx_cp_bond_testbus[19:0]),
								  // Inputs
								  .tx_wrfifo_clk	(tx_wrfifo_clk),
								  .tx_rdfifo_clk	(tx_rdfifo_clk),
								  .tx_rdfifo_clk_rst_n	(tx_rdfifo_clk_rst_n),
								  .tx_wrfifo_clk_rst_n	(tx_wrfifo_clk_rst_n),
								  .wr_srst_n		(fifo_srst_n_wr_clk),
								  .rd_srst_n		(fifo_srst_n_rd_clk),
								  .data_valid_in_raw	(data_valid_in_raw),
								  .r_us_master		(r_us_master),
								  .r_ds_master		(r_ds_master),
								  .r_us_bypass_pipeln	(r_us_bypass_pipeln),
								  .r_ds_bypass_pipeln	(r_ds_bypass_pipeln),
								  .r_compin_sel		(r_compin_sel[1:0]),
								  .r_comp_cnt		(r_comp_cnt[CNTWIDTH-1:0]),
								  .r_bonding_dft_in_en	(r_bonding_dft_in_en),
								  .r_bonding_dft_in_value(r_bonding_dft_in_value),
								  .double_read		(double_read),
								  .master_in_dv		(master_in_dv),
								  .us_in_dv		(us_in_dv),
								  .ds_in_dv		(ds_in_dv),
								  .master_in_wren	(master_in_wren),
								  .us_in_wren		(us_in_wren),
								  .ds_in_wren		(ds_in_wren),
								  .master_in_rden	(master_in_rden),
								  .us_in_rden		(us_in_rden),
								  .ds_in_rden		(ds_in_rden));
   

   
// Pulse-stretch signals before being capture by osc_clk

// Flag pulse-stretch
   c3aibadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (0)    	// Reset Value 
       ) pulse_stretch_fifo_full
     (
      .clk           (wr_clk),
      .rst_n         (wr_rst_n),             
      .num_stages    (r_tx_stretch_num_stages),
      .data_in       (fifo_full_int),
      .data_out      (fifo_full)                      
      );

   c3aibadapt_cmn_pulse_stretch 
     #(
       .RESET_VAL   (1)    	// Reset Value 
       ) pulse_stretch_fifo_empty
     (
      .clk           (rd_clk),
      .rst_n         (rd_rst_n),             
      .num_stages    (r_tx_stretch_num_stages),
      .data_in       (fifo_empty_int),
      .data_out      (fifo_empty)                      
      );
   
endmodule
