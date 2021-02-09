// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_rx_datapath.v.rca $
// Revision:    $Revision: #53 $
// Date:        $Date: 2015/09/09 $
//------------------------------------------------------------------------
// Description: Integration using emacs verilog then manual edit 
//
//------------------------------------------------------------------------
module hdpldadapt_rx_datapath (

/*AUTOINPUT*/

// new inputs for ECO8
    input  wire [1:0]  r_rx_wren_fastbond,
    input  wire [1:0]  r_rx_rden_fastbond,
                               
// Beginning of automatic input  wires (from unused autoinst input  wires)
input  wire [39:0]	aib_fabric_rx_data_in,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ..., Couldn't Merge
//input  wire			avmm_hrdrst_data_transfer_en,// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input	wire			pld_fabric_rx_asn_data_transfer_en,
input	wire			rx_hrdrst_asn_data_transfer_en,
input	wire			rx_hrdrst_rx_fifo_srst,
//input  wire			comp_rden_en,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			comp_wren_en,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			ds_in_rden,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			ds_in_wren,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			master_in_rden,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			master_in_wren,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_bonding_dft_in_en,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_bonding_dft_in_value,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire [7:0]	        r_rx_comp_cnt,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire [1:0]		r_rx_compin_sel,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_double_read,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
input  wire			r_rx_ds_bypass_pipeln,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_ds_master,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire [5:0]	        r_rx_fifo_empty,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			r_rx_empty_type,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire [2:0]		r_rx_fifo_mode,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire [5:0]	        r_rx_fifo_full,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			r_rx_full_type,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire			r_rx_indv,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire [5:0]	        r_rx_fifo_pempty,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			r_rx_pempty_type,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire [5:0]	        r_rx_fifo_pfull,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			r_rx_pfull_type,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire [2:0]		r_rx_phcomp_rd_delay,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input   wire            r_rx_asn_en,
input   wire            r_rx_asn_bypass_pma_pcie_sw_done,
input   wire [7:0]      r_rx_asn_wait_for_fifo_flush_cnt,
input   wire [7:0]      r_rx_asn_wait_for_dll_reset_cnt,
input   wire [7:0]      r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
input	wire		r_rx_hrdrst_user_ctl_en,
//input   wire [1:0]      r_rx_master_sel,
//input   wire            r_rx_dist_master_sel,
input  wire			r_rx_ds_last_chnl,
input  wire			r_rx_us_last_chnl,
//input   wire            r_rx_bonding_dft_in_en,
//input   wire            r_rx_bonding_dft_in_value,
/*
input  wire [7:0]		r_rx_chnl_datapath_asn_1,// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire [7:0]		r_rx_chnl_datapath_asn_2,// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire [7:0]		r_rx_chnl_datapath_asn_3,// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire [7:0]		r_rx_chnl_datapath_asn_4,// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
*/
input  wire			r_rx_stop_read,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire			r_rx_usertest_sel,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire			r_rx_stop_write,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire			r_rx_truebac2bac,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
input  wire			r_rx_us_bypass_pipeln,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_us_master,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire			r_rx_gb_dv_en,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
input  wire			r_rx_wa_en,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
//input  wire			rd_clk,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
//input  wire			rd_en,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			rd_rst_n,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
//input  wire			rd_srst_n,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
input  wire			rx_clock_asn_pma_hclk,	// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire			rx_reset_asn_pma_hclk_rst_n,	// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire			rx_fsr_mask_tx_pll,	// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
input  wire [1:0]		rx_pld_rate,		// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//input  wire			rx_rdfifo_clk,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			rx_rdfifo_clk_rst_n,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
input  wire [1:0]		rx_ssr_pcie_sw_done,	// To hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//input  wire			rx_wrfifo_clk,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			rx_wrfifo_clk_rst_n,	// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			s_clk,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			s_rst_n,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			us_in_rden,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			us_in_wren,		// To hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//input  wire			wr_clk,			// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
//input  wire			wr_empty_stretch,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			wr_full_stretch,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			wr_pempty_stretch,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			wr_pfull_stretch,	// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//input  wire			wr_rst_n,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
//input  wire			wr_srst_n,		// To hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v, ...
// End of automatics

input wire 			rx_clock_fifo_rd_clk,
input wire 			rx_clock_fifo_wr_clk,
input wire 			q1_rx_clock_fifo_wr_clk,
input wire 			q2_rx_clock_fifo_wr_clk,
input wire 			q3_rx_clock_fifo_wr_clk,
input wire 			q4_rx_clock_fifo_wr_clk,
input wire 			q5_rx_clock_fifo_wr_clk,
input wire 			q6_rx_clock_fifo_wr_clk,
input wire			rx_reset_fifo_wr_rst_n,
input wire			rx_reset_fifo_sclk_rst_n,
input  wire			rx_reset_fifo_rd_rst_n,
input  wire			rx_clock_fifo_sclk,
input wire			rx_clock_fifo_rd_clk_ins_sm,
input wire			rx_clock_fifo_wr_clk_del_sm,


input   wire            bond_rx_asn_ds_in_fifo_hold,
//input   wire            bond_rx_asn_ds_in_gen3_sel,
input   wire            bond_rx_asn_us_in_fifo_hold,
//input   wire            bond_rx_asn_us_in_gen3_sel,

input wire 			bond_rx_fifo_ds_in_rden,
input wire 			bond_rx_fifo_ds_in_wren,

input wire 			bond_rx_fifo_us_in_rden,
input wire 			bond_rx_fifo_us_in_wren,

input wire			pld_rx_fabric_fifo_rd_en,
input wire			pld_rx_fabric_fifo_align_clr,	// To be connected to RX FIFO

input wire			r_rx_write_ctrl,
input wire [2:0]	        r_rx_fifo_power_mode,
input wire [2:0]	        r_rx_stretch_num_stages, 
//input wire [2:0]	        r_rx_datapath_tb_sel, 
input wire 		        r_rx_wr_adj_en, 
input wire                      r_rx_rd_adj_en,
input wire			r_rx_pipe_en,

input   wire                    nfrzdrv_in,
input   wire                    pr_channel_freeze_n,
input	wire		        aib_fabric_pld_rx_hssi_fifo_latency_pulse,
input   wire                    pld_rx_fifo_latency_adj_en,


/*AUTOoutput wire wire*/
// Beginning of automatic output wire wires (from unused autoinst output wire wires)
//output wire			comp_out_dv_en,		// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			comp_out_rden_en,	// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			comp_out_wren_en,	// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			ds_out_rden,		// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			ds_out_wren,		// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			fifo_empty,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			fifo_full,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			fifo_insert,		// From hdpldadapt_rx_datapath_ of hdpldadapt_rx_datapath_insert_sm.v
//output wire			fifo_pempty,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			fifo_pfull,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			latency_pulse,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			phcomp_rden,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			phcomp_wren,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
output wire [79:0]	        pld_rx_fabric_data_out,	// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			rd_full,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			rd_pfull,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
output wire			pld_fabric_asn_dll_lock_en,
output wire			rx_fabric_align_done_raw,
output wire			rx_asn_rate_change_in_progress,
output wire			rx_asn_dll_lock_en,// From hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
output wire			rx_asn_fifo_hold,	// From hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//output wire			rx_asn_fifo_srst,	// From hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//output wire			rx_asn_gen3_sel,	// From hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//output wire [1:0]		rx_asn_rate,		// From hdpldadapt_rx_datapath_asn of hdpldadapt_rx_datapath_asn.v
//output wire [19:0]		rx_cp_bond_testbus,	// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire [19:0]		testbus1,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire [19:0]		testbus2,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			us_out_rden,		// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			us_out_wren,		// From hdpldadapt_rx_datapath_cp_bond of hdpldadapt_rx_datapath_cp_bond.v
//output wire			wr_full_comb,		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
//output wire			wr_pfull_comb		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
// End of automatics
output wire			pld_rx_fabric_fifo_full,
output wire			pld_rx_fabric_fifo_empty,
output wire			pld_rx_fabric_fifo_pfull,
output wire			pld_rx_fabric_fifo_pempty,
output wire			pld_rx_fabric_fifo_latency_pulse,
output wire			pld_rx_fabric_fifo_insert,
output wire			pld_rx_fabric_fifo_del,
output wire			pld_rx_fabric_align_done,
output wire		        wa_error,          // To status reg
output wire  [3:0]	        wa_error_cnt,	// Go to status reg


output	wire			pld_rx_hssi_fifo_latency_pulse,

output  wire            bond_rx_asn_ds_out_fifo_hold,
output  wire            bond_rx_asn_us_out_fifo_hold,

output wire 			bond_rx_fifo_ds_out_rden,
output wire 			bond_rx_fifo_ds_out_wren,

output wire 			bond_rx_fifo_us_out_rden,
output wire 			bond_rx_fifo_us_out_wren,

output   wire			rx_fifo_ready,
output   wire			pld_rx_fifo_ready,
output wire			rd_align_clr_reg,

output   wire [19:0]           rx_fifo_testbus1, 		// RX FIFO
output   wire [19:0]           rx_fifo_testbus2, 		// RX FIFO
output   wire [19:0]           rx_cp_bond_testbus,
output   wire [19:0]           rx_asn_testbus,
output   wire [19:0]           deletion_sm_testbus,
output   wire [19:0]           insertion_sm_testbus,
output   wire [19:0]           word_align_testbus

);


localparam		DWIDTH = 40;
localparam		CNTWIDTH = 8;
localparam		AWIDTH = 6;
localparam		PCSCWIDTH = 10;
localparam		PCSDWIDTH = 64;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			baser_data_valid;	// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
wire [73:0]		baser_fifo_data;	// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
wire [73:0]		baser_fifo_data2;	// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
wire [PCSCWIDTH-1:0]	insert_sm_control_out;	// From hdpldadapt_rx_datapath_ of hdpldadapt_rx_datapath_insert_sm.v
wire [PCSDWIDTH-1:0]	insert_sm_data_out;	// From hdpldadapt_rx_datapath_ of hdpldadapt_rx_datapath_insert_sm.v
wire			insert_sm_rd_en;	// From hdpldadapt_rx_datapath_ of hdpldadapt_rx_datapath_insert_sm.v
wire			insert_sm_rd_en_lt;	// From hdpldadapt_rx_datapath_ of hdpldadapt_rx_datapath_insert_sm.v
wire			rd_empty;		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
wire			rd_pempty;		// From hdpldadapt_rx_datapath_fifo of hdpldadapt_rx_datapath_fifo.v
wire			wa_lock;		// From hdpldadapt_rx_datapath_word_align of hdpldadapt_rx_datapath_word_align.v
// End of automatics

wire 			asn_fifo_srst;
//wire 			asn_gen3_sel;
wire			rx_asn_phystatus;

wire 			comp_out_rden_en;
wire 			comp_out_wren_en;

wire 			comp_rden_en;
wire 			comp_wren_en;

//wire [PCSCWIDTH-1:0]	control_in;
//wire [PCSDWIDTH-1:0]	data_in;	
//wire			data_valid_in;

wire			double_read;
wire			double_read_int;

wire 			phcomp_rden;
wire 			phcomp_wren;

wire 			master_in_rden;
wire 			master_in_wren;

wire 			ds_in_rden;
wire 			ds_in_wren;
wire 			us_in_rden;
wire 			us_in_wren;

wire 			ds_out_rden;
wire 			ds_out_wren;
wire 			us_out_rden;
wire 			us_out_wren;

wire			rd_clk;
wire			rd_rst_n;
wire 			rd_srst_n	= 1'b1;		// Tie sync reset to 1 for now	
wire			rx_rdfifo_clk;
wire			rx_rdfifo_clk_rst_n;
wire			rx_wrfifo_clk;
wire			rx_wrfifo_clk_rst_n;
wire			s_clk;
wire			s_rst_n;
wire			wr_clk;
wire			q1_wr_clk;
wire			q2_wr_clk;
wire			q3_wr_clk;
wire			q4_wr_clk;
wire			q5_wr_clk;
wire			q6_wr_clk;
wire 			wr_srst_n	= 1'b1;		// Tie sync reset to 1 for now	
wire			wr_rst_n;


wire			rd_en;
//wire [1:0]		rx_pld_rate	= 2'b00;	// Tie off for now. To be connected to mapping

wire			wr_empty_stretch = 1'b0;	// Tie off: since r_empty_type =0
//wire			wr_full_stretch  = 1'b0;
wire			wr_pempty_stretch = 1'b0;	// Tie off: since r_pempty_type =0
//wire			wr_pfull_stretch  = 1'b0;

wire			fifo_empty;
wire			fifo_full;	
wire			fifo_insert;	
wire			fifo_pempty;	
wire			fifo_pfull;	
wire			align_done;	
wire			latency_pulse;

//wire [19:0]		rx_cp_bond_testbus;
//wire [19:0]		rx_fifo_testbus1;	
//wire [19:0]		rx_fifo_testbus2;

wire			r_empty_type = 1'b0;
wire			r_pempty_type = 1'b0;
wire			r_full_type = 1'b1;
wire			r_pfull_type = 1'b1;

wire			r_bonding_dft_in_en =		r_rx_bonding_dft_in_en;	
wire			r_bonding_dft_in_value =	r_rx_bonding_dft_in_value;	
wire [8-1:0]	        r_comp_cnt =			r_rx_comp_cnt;		
wire [1:0]		r_compin_sel =			r_rx_compin_sel;		
wire			r_double_read =			r_rx_double_read;		
wire			r_ds_bypass_pipeln =		r_rx_ds_bypass_pipeln;	
wire			r_ds_master =			r_rx_ds_master;		
wire [6-1:0]	        r_empty =			r_rx_fifo_empty;		
wire [2:0]		r_fifo_mode =			r_rx_fifo_mode;		
wire [6-1:0]	        r_full =			r_rx_fifo_full;			
wire			r_indv =			r_rx_indv;			
wire [6-1:0]	        r_pempty =			r_rx_fifo_pempty;		
wire [6-1:0]	        r_pfull =			r_rx_fifo_pfull;		
wire [2:0]		r_phcomp_rd_delay =		r_rx_phcomp_rd_delay;	
wire			r_stop_read =			r_rx_stop_read;		
wire			r_stop_write =			r_rx_stop_write;		
wire			r_truebac2bac =			r_rx_truebac2bac;		
wire			r_us_bypass_pipeln =		r_rx_us_bypass_pipeln;	
wire			r_us_master =			r_rx_us_master;		
wire			r_gb_dv_en =			r_rx_gb_dv_en;		
wire			r_wa_en =			r_rx_wa_en;		
	
wire [39:0]		del_sm_data_out;
wire			wr_full_raw;
wire			wr_pfull_raw;

wire			rx_fifo_del_raw;
wire			rx_fifo_del;

wire            nfrz_output_2one;

wire [79:0]		pld_rx_fabric_data_out_int;
wire			pld_rx_fabric_fifo_empty_int; 
wire			pld_rx_fabric_fifo_full_int;
wire			pld_rx_fabric_fifo_insert_int;
wire			pld_rx_fabric_fifo_pempty_int;
wire			pld_rx_fabric_fifo_pfull_int; 
wire			pld_rx_fabric_fifo_latency_pulse_int;
wire			pld_rx_fabric_align_done_int;
reg			pld_rx_hssi_fifo_latency_pulse_int;
wire			pld_rx_fabric_fifo_del_int;

wire			rd_align_clr = pld_rx_fabric_fifo_align_clr;

wire			block_lock;
wire			block_lock_lt;
wire			fifo_srst_n_wr_clk;
wire			fifo_srst_n_rd_clk;
wire			del_sm_wr_en;
wire			compin_sel_wren;
wire			compin_sel_rden;
wire			wa_srst_n_wr_clk;

assign asn_fifo_srst	= rx_hrdrst_rx_fifo_srst;
//assign asn_gen3_sel	= rx_asn_gen3_sel;
assign asn_fifo_hold	= rx_asn_fifo_hold;

assign comp_rden_en	= 	comp_out_rden_en;
assign comp_wren_en	= 	comp_out_wren_en;

assign double_read	= double_read_int;

assign master_in_rden   = phcomp_rden;
assign master_in_wren   = phcomp_wren;


// ECO8   
assign ds_in_rden	= (!r_rx_ds_last_chnl && r_rx_rden_fastbond[0]) ? bond_rx_fifo_ds_in_rden : (!r_rx_ds_last_chnl && !r_rx_rden_fastbond[0]) ? bond_rx_fifo_ds_in_rden : 1'b0;
assign ds_in_wren	= (!r_rx_ds_last_chnl && r_rx_wren_fastbond[0]) ? bond_rx_fifo_ds_in_wren : (!r_rx_ds_last_chnl && !r_rx_wren_fastbond[0]) ? bond_rx_fifo_ds_in_wren : 1'b0;

assign us_in_rden	= (!r_rx_us_last_chnl && r_rx_rden_fastbond[1]) ? bond_rx_fifo_us_in_rden : (!r_rx_us_last_chnl && !r_rx_rden_fastbond[1]) ? bond_rx_fifo_us_in_rden : 1'b0;
assign us_in_wren	= (!r_rx_us_last_chnl && r_rx_wren_fastbond[1]) ? bond_rx_fifo_us_in_wren : (!r_rx_us_last_chnl && !r_rx_wren_fastbond[1]) ? bond_rx_fifo_us_in_wren : 1'b0;

/* ECO8  
assign ds_in_rden	= r_rx_ds_last_chnl ? 1'b0 : bond_rx_fifo_ds_in_rden;
assign ds_in_wren	= r_rx_ds_last_chnl ? 1'b0 : bond_rx_fifo_ds_in_wren;

assign us_in_rden	= r_rx_us_last_chnl ? 1'b0 : bond_rx_fifo_us_in_rden;
assign us_in_wren	= r_rx_us_last_chnl ? 1'b0 : bond_rx_fifo_us_in_wren;
*/
   
assign bond_rx_fifo_ds_out_rden	= ds_out_rden;
assign bond_rx_fifo_ds_out_wren	= ds_out_wren;

assign bond_rx_fifo_us_out_rden	= us_out_rden;
assign bond_rx_fifo_us_out_wren	= us_out_wren;


assign rd_clk		= rx_clock_fifo_rd_clk;
assign rx_rdfifo_clk	= rx_clock_fifo_rd_clk;

assign wr_clk		= rx_clock_fifo_wr_clk;
assign q1_wr_clk		= q1_rx_clock_fifo_wr_clk;
assign q2_wr_clk		= q2_rx_clock_fifo_wr_clk;
assign q3_wr_clk		= q3_rx_clock_fifo_wr_clk;
assign q4_wr_clk		= q4_rx_clock_fifo_wr_clk;
assign q5_wr_clk		= q5_rx_clock_fifo_wr_clk;
assign q6_wr_clk		= q6_rx_clock_fifo_wr_clk;
assign rx_wrfifo_clk	= rx_clock_fifo_wr_clk;

assign s_clk		= rx_clock_fifo_sclk;

assign rd_rst_n		= rx_reset_fifo_rd_rst_n;
assign wr_rst_n		= rx_reset_fifo_wr_rst_n;
assign rx_rdfifo_clk_rst_n	= 	rx_reset_fifo_rd_rst_n;
assign rx_wrfifo_clk_rst_n	= 	rx_reset_fifo_wr_rst_n;

assign s_rst_n		= rx_reset_fifo_sclk_rst_n;

assign rd_en		= pld_rx_fabric_fifo_rd_en;

assign pld_rx_fabric_fifo_empty_int 	= fifo_empty;
assign pld_rx_fabric_fifo_full_int	= fifo_full;	
assign pld_rx_fabric_fifo_insert_int 	= fifo_insert;	
assign pld_rx_fabric_fifo_pempty_int 	= fifo_pempty;	
assign pld_rx_fabric_fifo_pfull_int	= fifo_pfull;	
assign pld_rx_fabric_fifo_latency_pulse_int = latency_pulse;
assign rx_fabric_align_done_raw		= align_done;
assign pld_rx_fabric_align_done_int	= align_done;
assign pld_rx_fabric_fifo_del_int 	= rx_fifo_del;	


assign rx_asn_phystatus = pld_rx_fabric_data_out_int[32];


// BaseR deletion SM
hdpldadapt_rx_datapath_del_sm hdpldadapt_rx_datapath_del_sm (
.wr_rst_n           	(wr_rst_n),         	
.wr_clk             	(rx_clock_fifo_wr_clk_del_sm),           
.r_write_ctrl	  	(r_rx_write_ctrl),
.aib_fabric_rx_data_in		(aib_fabric_rx_data_in),
.wr_pfull		(wr_pfull_raw),
.wr_full		(wr_full_raw),
.wa_lock		(wa_lock),
.base_r_clkcomp_mode		(base_r_clkcomp_mode),
.data_out   		(del_sm_data_out), 
.fifo_del   		(rx_fifo_del_raw),
.block_lock		(block_lock),
.block_lock_lt		(block_lock_lt),
.del_sm_wr_en		(del_sm_wr_en),
.deletion_sm_testbus	(deletion_sm_testbus)
    );


hdpldadapt_rx_datapath_fifo hdpldadapt_rx_datapath_fifo(/*AUTOINST*/
							// Outputs
							.phcomp_wren	(phcomp_wren),
							.phcomp_rden	(phcomp_rden),
							.baser_fifo_data(baser_fifo_data[73:0]),
							.baser_fifo_data2(baser_fifo_data2[73:0]),
							.baser_data_valid(baser_data_valid),
							.pld_rx_fabric_data_out(pld_rx_fabric_data_out_int[79:0]),
							.rd_pfull	(rd_pfull),
							.rd_empty	(rd_empty),
							.rd_pempty	(rd_pempty),
							.rd_full	(rd_full),
							.wr_full_comb	(wr_full_comb),
							.wr_pfull_comb	(wr_pfull_comb),
							.wr_full	(wr_full_raw),
							.wr_pfull	(wr_pfull_raw),
							.fifo_empty	(fifo_empty),
							.fifo_pempty	(fifo_pempty),
							.fifo_pfull	(fifo_pfull),
							.fifo_full	(fifo_full),
							.latency_pulse	(latency_pulse),
							.testbus1	(rx_fifo_testbus1[19:0]),
							.testbus2	(rx_fifo_testbus2[19:0]),
							.double_read_int	(double_read_int),
							.fifo_srst_n_wr_clk(fifo_srst_n_wr_clk),
							.fifo_srst_n_rd_clk(fifo_srst_n_rd_clk),
							.wa_srst_n_wr_clk (wa_srst_n_wr_clk),
							.align_done	(align_done),
							.base_r_clkcomp_mode		(base_r_clkcomp_mode),
							.wa_error		(wa_error),
							.wa_error_cnt	(wa_error_cnt[3:0]),

							// Inputs
							.wr_rst_n	(wr_rst_n),
							.rd_rst_n	(rd_rst_n),
//							.wr_srst_n	(wr_srst_n),
//							.rd_srst_n	(rd_srst_n),
							.wr_clk		(wr_clk),
							.q1_wr_clk		(q1_wr_clk),
							.q2_wr_clk		(q2_wr_clk),
							.q3_wr_clk		(q3_wr_clk),
							.q4_wr_clk		(q4_wr_clk),							
							.q5_wr_clk		(q5_wr_clk),							
							.q6_wr_clk		(q6_wr_clk),							
							.rd_clk		(rd_clk),
							.s_clk		(s_clk),
							.s_rst_n	(s_rst_n),
							.r_fifo_mode	(r_fifo_mode[2:0]),
							.r_pempty	(r_pempty),
							.r_pfull	(r_pfull),
							.r_empty	(r_empty),
							.r_full		(r_full),
							.r_indv		(r_indv),
							.r_phcomp_rd_delay(r_phcomp_rd_delay[2:0]),
							.r_pempty_type	(r_pempty_type),
							.r_pfull_type	(r_pfull_type),
							.r_empty_type	(r_empty_type),
							.r_full_type	(r_full_type),
							.r_stop_read	(r_stop_read),
							.r_stop_write	(r_stop_write),
							.r_double_read	(r_double_read),
							.r_gb_dv_en	(r_gb_dv_en),
							.r_truebac2bac	(r_truebac2bac),
							.r_wa_en	(r_wa_en),
							.r_fifo_power_mode (r_rx_fifo_power_mode),
							.r_wr_adj_en (r_rx_wr_adj_en),
							.r_rd_adj_en (r_rx_rd_adj_en),
							.r_pipe_en (r_rx_pipe_en),
							.r_write_ctrl	  	(r_rx_write_ctrl),
							.fifo_latency_adj	(pld_rx_fifo_latency_adj_en),
							.aib_fabric_rx_data_in(del_sm_data_out),
							.rd_en		(rd_en),
							.rd_align_clr	(rd_align_clr),
							.rd_align_clr_reg 	(rd_align_clr_reg),
							.comp_wren_en	(comp_wren_en),
							.comp_rden_en	(comp_rden_en),
							.compin_sel_wren	(compin_sel_wren),
							.compin_sel_rden	(compin_sel_rden),
							.wr_pfull_stretch(wr_pfull_stretch),
							.wr_empty_stretch(wr_empty_stretch),
							.wr_pempty_stretch(wr_pempty_stretch),
							.wr_full_stretch(wr_full_stretch),
							.wa_lock	(wa_lock),
							.block_lock		(block_lock),
							.block_lock_lt		(block_lock_lt),
							.del_sm_wr_en		(del_sm_wr_en),
							.asn_fifo_hold	(asn_fifo_hold),
							.asn_fifo_srst	(asn_fifo_srst),
							.asn_gen3_sel	(1'b0),
							.fifo_ready	(rx_fifo_ready),
							.insert_sm_control_out(insert_sm_control_out[9:0]),
							.insert_sm_data_out(insert_sm_data_out[63:0]),
							.insert_sm_rd_en(insert_sm_rd_en),
							.insert_sm_rd_en_lt(insert_sm_rd_en_lt));   
hdpldadapt_rx_datapath_word_align hdpldadapt_rx_datapath_word_align(/*AUTOINST*/
								    // Outputs
								    .wa_lock		(wa_lock),
								    .word_align_testbus (word_align_testbus),
								    // Inputs
								    .wr_clk		(wr_clk),
								    .wr_rst_n		(wr_rst_n),
								    .wr_srst_n		(wa_srst_n_wr_clk),
								    .r_wa_en		(r_wa_en),
								    .aib_fabric_rx_data_in(aib_fabric_rx_data_in));
hdpldadapt_rx_datapath_cp_bond hdpldadapt_rx_datapath_cp_bond(/*AUTOINST*/
							      // Outputs
							      .us_out_wren	(us_out_wren),
							      .ds_out_wren	(ds_out_wren),
							      .us_out_rden	(us_out_rden),
							      .ds_out_rden	(ds_out_rden),
//							      .comp_out_dv_en	(comp_out_dv_en),
							      .comp_out_wren_en	(comp_out_wren_en),
							      .comp_out_rden_en	(comp_out_rden_en),
							      .compin_sel_wren	(compin_sel_wren),
							      .compin_sel_rden	(compin_sel_rden),
							      .rx_cp_bond_testbus(rx_cp_bond_testbus[19:0]),
							      // Inputs
							      .rx_wrfifo_clk	(rx_wrfifo_clk),
							      .rx_rdfifo_clk	(rx_rdfifo_clk),
							      .rx_rdfifo_clk_rst_n(rx_rdfifo_clk_rst_n),
							      .rx_wrfifo_clk_rst_n(rx_wrfifo_clk_rst_n),
							      .wr_srst_n	(fifo_srst_n_wr_clk),
							      .rd_srst_n	(fifo_srst_n_rd_clk),
							      .r_us_master	(r_us_master),
							      .r_ds_master	(r_ds_master),
							      .r_us_bypass_pipeln(r_us_bypass_pipeln),
							      .r_ds_bypass_pipeln(r_ds_bypass_pipeln),
							      .r_compin_sel	(r_compin_sel[1:0]),
							      .r_comp_cnt	(r_comp_cnt),
							      .r_bonding_dft_in_en(r_bonding_dft_in_en),
							      .r_bonding_dft_in_value(r_bonding_dft_in_value),
							      .r_double_read	(double_read),
							      .master_in_wren	(master_in_wren),
							      .us_in_wren	(us_in_wren),
							      .ds_in_wren	(ds_in_wren),
							      .master_in_rden	(master_in_rden),
							      .us_in_rden	(us_in_rden),
							      .ds_in_rden	(ds_in_rden));
hdpldadapt_rx_datapath_insert_sm hdpldadapt_rx_datapath_insert_sm(/*AUTOINST*/
							 // Outputs
							 .insert_sm_control_out	(insert_sm_control_out),
							 .insert_sm_data_out	(insert_sm_data_out),
							 .fifo_insert		(fifo_insert),
							 .insert_sm_rd_en	(insert_sm_rd_en),
							 .insert_sm_rd_en_lt	(insert_sm_rd_en_lt),
							 .insertion_sm_testbus	(insertion_sm_testbus),
							 // Inputs
							 .rd_rst_n		(rd_rst_n),
							 .rd_srst_n		(rd_srst_n),
							 .rd_clk		(rx_clock_fifo_rd_clk_ins_sm),
							 .baser_fifo_data	(baser_fifo_data[73:0]),
							 .baser_fifo_data2	(baser_fifo_data2[73:0]),
							 .rd_pempty		(rd_pempty),
							 .rd_empty		(rd_empty),
							 .baser_data_valid	(baser_data_valid),
							 .r_truebac2bac		(r_truebac2bac));
hdpldadapt_rx_datapath_asn hdpldadapt_rx_datapath_asn(/*AUTOINST*/
						      		// Outputs
						      		.pld_fabric_asn_dll_lock_en(pld_fabric_asn_dll_lock_en),
						      		.rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
						      		.rx_asn_dll_lock_en(rx_asn_dll_lock_en),
						      		.rx_asn_fifo_hold	(rx_asn_fifo_hold),
                                                                .bond_rx_asn_ds_out_fifo_hold(bond_rx_asn_ds_out_fifo_hold),
                                                                .bond_rx_asn_us_out_fifo_hold(bond_rx_asn_us_out_fifo_hold),
                                                             	.rx_asn_testbus (rx_asn_testbus),
						      		// Inputs
						      		.rx_clock_asn_pma_hclk(rx_clock_asn_pma_hclk),
						      		.rx_clock_fifo_rd_clk(rx_clock_fifo_rd_clk),
						      		.rx_reset_asn_pma_hclk_rst_n(rx_reset_asn_pma_hclk_rst_n),
						      		.rx_reset_fifo_rd_rst_n(rx_reset_fifo_rd_rst_n),
						      		.rx_pld_rate	(rx_pld_rate[1:0]),
						      		.rx_fsr_mask_tx_pll(rx_fsr_mask_tx_pll),
						      		.rx_ssr_pcie_sw_done(rx_ssr_pcie_sw_done[1:0]),
						      		.rx_hrdrst_asn_data_transfer_en(rx_hrdrst_asn_data_transfer_en),
						      		.rx_asn_phystatus(rx_asn_phystatus),
						      		.nfrzdrv_in(nfrzdrv_in),
						      		.pr_channel_freeze_n(pr_channel_freeze_n),
						      		.pld_fabric_rx_asn_data_transfer_en(pld_fabric_rx_asn_data_transfer_en),
                                                                .bond_rx_asn_ds_in_fifo_hold(bond_rx_asn_ds_in_fifo_hold),
                                                                .bond_rx_asn_us_in_fifo_hold(bond_rx_asn_us_in_fifo_hold),
                                                                .r_rx_asn_en(r_rx_asn_en),
                                                                .r_rx_asn_bypass_pma_pcie_sw_done(r_rx_asn_bypass_pma_pcie_sw_done),
                                                                .r_rx_asn_wait_for_fifo_flush_cnt(r_rx_asn_wait_for_fifo_flush_cnt),
                                                                .r_rx_asn_wait_for_dll_reset_cnt(r_rx_asn_wait_for_dll_reset_cnt),
                                                                .r_rx_asn_wait_for_pma_pcie_sw_done_cnt(r_rx_asn_wait_for_pma_pcie_sw_done_cnt),
                                                                .r_rx_master_sel(r_rx_compin_sel),
                                                                .r_rx_dist_master_sel(r_rx_ds_master),
                                                                .r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
                                                                .r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
                                                                .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en));

hdpldadapt_rx_datapath_pulse_stretch hdpldadapt_rx_datapath_pulse_stretch (
								    .clk		(wr_clk),
								    .rst_n		(wr_rst_n),
								    .wr_pfull_raw	(wr_pfull_raw),
								    .wr_full_raw	(wr_full_raw),
								    .rx_fifo_del_raw	(rx_fifo_del_raw),
								    .r_stretch_num_stages (r_rx_stretch_num_stages),
								    .wr_pfull_stretch 	(wr_pfull_stretch),
								    .wr_full_stretch 	(wr_full_stretch),
								    .rx_fifo_del	(rx_fifo_del));
								    

// Pipeline hssi_latency_pulse
always @(negedge rx_reset_fifo_sclk_rst_n or posedge rx_clock_fifo_sclk) begin
   if (rx_reset_fifo_sclk_rst_n == 1'b0) begin
     pld_rx_hssi_fifo_latency_pulse_int <= 1'b0;
   end
   else begin
     pld_rx_hssi_fifo_latency_pulse_int <= aib_fabric_pld_rx_hssi_fifo_latency_pulse;
   end
end

// Freeze outputs to PLD
assign nfrz_output_2one  = nfrzdrv_in & pr_channel_freeze_n;

assign pld_rx_fabric_data_out           = nfrz_output_2one ?  	pld_rx_fabric_data_out_int                 : {80{1'b1}};
assign pld_rx_fabric_fifo_empty 	= nfrz_output_2one ?  	pld_rx_fabric_fifo_empty_int : 1'b1; 		
assign pld_rx_fabric_fifo_full		= nfrz_output_2one ?  	pld_rx_fabric_fifo_full_int : 1'b1;	
assign pld_rx_fabric_fifo_insert 	= nfrz_output_2one ?  	pld_rx_fabric_fifo_insert_int : 1'b1; 	
assign pld_rx_fabric_fifo_pempty 	= nfrz_output_2one ?  	pld_rx_fabric_fifo_pempty_int : 1'b1; 	
assign pld_rx_fabric_fifo_pfull		= nfrz_output_2one ?  	pld_rx_fabric_fifo_pfull_int : 1'b1;	
assign pld_rx_fabric_fifo_latency_pulse = nfrz_output_2one ?  	pld_rx_fabric_fifo_latency_pulse_int : 1'b1; 
assign pld_rx_fabric_align_done		= nfrz_output_2one ?  	pld_rx_fabric_align_done_int : 1'b1;
assign pld_rx_hssi_fifo_latency_pulse   = nfrz_output_2one ?  	(r_rx_usertest_sel ? pld_rx_hssi_fifo_latency_pulse_int : aib_fabric_pld_rx_hssi_fifo_latency_pulse ) : 1'b1;
assign pld_rx_fabric_fifo_del		= nfrz_output_2one ?  	pld_rx_fabric_fifo_del_int : 1'b1;
assign pld_rx_fifo_ready		= nfrz_output_2one ?    rx_fifo_ready : 1'b1;





endmodule
