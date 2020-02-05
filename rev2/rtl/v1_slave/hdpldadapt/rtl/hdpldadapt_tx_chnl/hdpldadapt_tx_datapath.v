// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_tx_datapath.v.rca $
// Revision:    $Revision: #31 $
// Date:        $Date: 2015/09/09 $
//------------------------------------------------------------------------
// Description: Integration using emacs verilog then manual edit 
//
//------------------------------------------------------------------------
module hdpldadapt_tx_datapath (

/*AUTOINPUT*/

// new inputs for ECO8
    input  wire [1:0]  r_tx_wren_fastbond,
    input  wire [1:0]  r_tx_rden_fastbond,                                
                               
// Beginning of automatic inputs (from unused autoinst inputs)
//input  wire			asn_fifo_srst,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			asn_gen3_sel,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			burst_en,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//input  wire			clk,			// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v, ...
//input  wire			comp_dv_en,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			comp_rden_en,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			comp_wren_en,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire [79:0]		data_in,		// To hdpldadapt_tx_datapath_word_mark of hdpldadapt_tx_datapath_word_mark.v
//input  wire			data_valid_in,		// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v
//input  wire			data_valid_in_raw,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v, ...
//input  wire			data_valid_raw,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire [1:0]		diag_status,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//input  wire			ds_in_dv,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			ds_in_rden,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			ds_in_wren,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			frm_gen_rd_en,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			master_in_dv,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			master_in_rden,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			master_in_wren,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire [80-1:0]	        pld_tx_fabric_data_in,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire			r_tx_bonding_dft_in_en,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_bonding_dft_in_value,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_burst_en,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire			r_tx_bypass_frmgen,	// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire [8-1:0]	        r_tx_comp_cnt,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire [1:0]		r_tx_compin_sel,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_double_write,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
input  wire			r_tx_ds_bypass_pipeln,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_ds_master,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_dv_indv,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
input  wire [4:0]		r_tx_fifo_empty,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			r_tx_empty_type,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire [2:0]		r_tx_fifo_mode,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
input  wire [4:0]		r_tx_fifo_full,			// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			r_tx_full_type,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire			r_tx_gb_dv_en,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
input  wire [2:0]		r_tx_gb_idwidth,		// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v
input  wire [1:0]		r_tx_gb_odwidth,		// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v
input  wire			r_tx_indv,			// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
input  wire [15:0]		r_tx_mfrm_length,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire [4:0]		r_tx_fifo_pempty,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			r_tx_pempty_type,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire [4:0]		r_tx_fifo_pfull,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			r_tx_pfull_type,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire [2:0]		r_tx_phcomp_rd_delay,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire			r_tx_pipeln_frmgen,	// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire			r_tx_pyld_ins,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire			r_tx_sh_err,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
input  wire			r_tx_stop_read,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire			r_tx_stop_write,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
input  wire			r_tx_us_bypass_pipeln,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_us_master,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
input  wire			r_tx_wm_en,		// To hdpldadapt_tx_datapath_word_mark of hdpldadapt_tx_datapath_word_mark.v
input  wire			r_tx_wordslip,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//input  wire			rd_clk,			// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			rd_empty_stretch,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			rd_full_stretch,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//  wire			rd_pempty,		// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v
//input  wire			rd_pempty_stretch,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			rd_pfull_stretch,	// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			rd_rst_n,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			rd_srst_n,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
//input  wire			rst_n,			// To hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v, ...
//input  wire			s_clk,			// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			s_rst_n,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire [39:0]		tx_fifo_data,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//input  wire			tx_rdfifo_clk,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			tx_rdfifo_clk_rst_n,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			tx_wrfifo_clk,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			tx_wrfifo_clk_rst_n,	// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			us_in_dv,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			us_in_rden,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			us_in_wren,		// To hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//input  wire			wordslip,		// To hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//input  wire			wr_clk,			// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			wr_rst_n,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//input  wire			wr_srst_n,		// To hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
// End of automatics
input  wire			pld_10g_tx_burst_en,
input  wire			tx_reset_fifo_wr_rst_n,
input  wire			tx_reset_fifo_rd_rst_n,
input  wire			tx_reset_fifo_sclk_rst_n,
input  wire			tx_clock_fifo_wr_clk,
input  wire			q1_tx_clock_fifo_wr_clk,
input  wire			q2_tx_clock_fifo_wr_clk,
input  wire			q3_tx_clock_fifo_wr_clk,
input  wire			q4_tx_clock_fifo_wr_clk,
input  wire			q5_tx_clock_fifo_wr_clk,
input  wire			q6_tx_clock_fifo_wr_clk,
input  wire			tx_clock_fifo_rd_clk,
input  wire			tx_clock_fifo_sclk,

input wire 			bond_tx_fifo_ds_in_dv,
input wire 			bond_tx_fifo_ds_in_rden,
input wire 			bond_tx_fifo_ds_in_wren,

input wire 			bond_tx_fifo_us_in_dv,
input wire 			bond_tx_fifo_us_in_rden,
input wire 			bond_tx_fifo_us_in_wren,

input wire [1:0]		pld_10g_tx_diag_status,
input wire			pld_10g_tx_wordslip,

input wire			tx_asn_fifo_srst,
input wire 			tx_asn_gen3_sel,
input wire 			tx_asn_fifo_hold,

input wire [2:0]	        r_tx_fifo_power_mode,
input wire [2:0]	        r_tx_stretch_num_stages, 
input wire [2:0]	        r_tx_datapath_tb_sel, 
input wire 		        r_tx_wr_adj_en, 
input wire                      r_tx_rd_adj_en,
input wire			r_tx_ds_last_chnl,
input wire			r_tx_us_last_chnl,
input wire			r_tx_usertest_sel,

input   wire                    nfrzdrv_in,
input   wire                    pr_channel_freeze_n,
input	wire		        aib_fabric_pld_tx_hssi_fifo_latency_pulse,
input	wire	                pld_tx_fifo_latency_adj_en,
input   wire			tx_clock_fifo_rd_clk_frm_gen,


/*AUTOoutput wire*/
// Beginning of automatic output wires (from unused autoinst output wires)
output wire [40-1:0]	aib_fabric_tx_data_out,	// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ..., Couldn't Merge
//output wire			asn_fifo_srst_n_rd_clk,	// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			asn_fifo_srst_n_wr_clk,	// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			burst_en_exe,		// From hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//output wire			comp_out_dv_en,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			comp_out_rden_en,	// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			comp_out_wren_en,	// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire [79:0]		data_out,		// From hdpldadapt_tx_datapath_word_mark of hdpldadapt_tx_datapath_word_mark.v
//output wire			data_valid_out,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v, ...
//output wire			ds_out_dv,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			ds_out_rden,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			ds_out_wren,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			dv_en,			// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			fifo_empty,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			fifo_full,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			fifo_pempty,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			fifo_pfull,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire [19:0]		frame_gen_testbus1,	// From hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//output wire [19:0]		frame_gen_testbus2,	// From hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//output wire			latency_pulse,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			phcomp_wren,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			rd_empty_comb,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			rd_en,			// From hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//output wire			rd_full,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire			rd_pempty_comb,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire [19:0]		testbus1,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire [19:0]		testbus2,		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//output wire [19:0]		tx_cp_bond_testbus,	// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			tx_frame,		// From hdpldadapt_tx_datapath_frame_gen of hdpldadapt_tx_datapath_frame_gen.v
//output wire			us_out_dv,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			us_out_rden,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
//output wire			us_out_wren,		// From hdpldadapt_tx_datapath_cp_bond of hdpldadapt_tx_datapath_cp_bond.v
// End of automatics

output   wire [19:0]            tx_fifo_testbus1, 		// RX FIFO
output   wire [19:0]            tx_fifo_testbus2, 		// RX FIFO
output   wire [19:0]            frame_gen_testbus1,
output   wire [19:0]            frame_gen_testbus2,
output   wire [19:0]		dv_gen_testbus,    
output   wire [19:0]            tx_cp_bond_testbus,
output   wire			tx_fifo_ready,
output	wire			pld_tx_fifo_ready,

output wire 			bond_tx_fifo_ds_out_dv,
output wire 			bond_tx_fifo_ds_out_rden,
output wire 			bond_tx_fifo_ds_out_wren,
output wire 			bond_tx_fifo_us_out_dv,
output wire 			bond_tx_fifo_us_out_rden,
output wire 			bond_tx_fifo_us_out_wren,
output wire			pld_10g_tx_burst_en_exe,
output wire			pld_10g_tx_wordslip_exe,
output wire			pld_tx_fabric_fifo_full,
output wire			pld_tx_fabric_fifo_empty,
output wire			pld_tx_fabric_fifo_pfull,
output wire			pld_tx_fabric_fifo_pempty,
output wire			pld_tx_fabric_fifo_latency_pulse,
output wire  			pld_tx_hssi_fifo_latency_pulse,
output wire			pld_10g_krfec_tx_frame
);

localparam		FDWIDTH = 40;
localparam		CNTWIDTH = 8;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			comp_dv_en_reg;		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
//wire			data_valid_2x;		// From hdpldadapt_tx_datapath_dv_gen of hdpldadapt_tx_datapath_dv_gen.v
wire			double_write_int;	// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
wire [FDWIDTH-1:0]	fifo_out_comb;		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
wire			phcomp_rden;		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
wire			rd_pfull;		// From hdpldadapt_tx_datapath_fifo of hdpldadapt_tx_datapath_fifo.v
// End of automatics

wire 			asn_fifo_srst;
wire 			asn_gen3_sel;

wire			burst_en;
wire			clk;

wire			rd_rst_n;
wire			rd_srst_n;
wire			rst_n;
wire			s_clk;
wire			s_rst_n;
wire			tx_rdfifo_clk;
wire			tx_rdfifo_clk_rst_n;
wire			tx_wrfifo_clk;
wire			tx_wrfifo_clk_rst_n;
wire			rd_clk;
wire			wr_clk;
wire			q1_wr_clk;
wire			q2_wr_clk;
wire			q3_wr_clk;
wire			q4_wr_clk;
wire			q5_wr_clk;
wire			q6_wr_clk;
wire			wr_rst_n;
wire 			wr_srst_n;

wire 			comp_out_dv_en;
wire 			comp_out_rden_en;
wire 			comp_out_wren_en;

wire 			comp_dv_en;
wire 			comp_rden_en;
wire 			comp_wren_en;

wire 			dv_en;
//wire 			phcomp_rden;
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
wire 			ds_out_rden;
wire 			ds_out_wren;
wire 			us_out_dv;
wire 			us_out_rden;
wire 			us_out_wren;

//wire [79:0]		wm_data_in;
//wire [79:0]		wm_data_out;

wire 			data_valid_in_raw;
wire			dv_gen_data_valid_out;
wire			dv_gen_data_valid_2x;

wire [1:0]		diag_status;
wire			frm_gen_rd_en;

//wire			rd_empty_stretch = 1'b0;	// Tie off for now. To be connected to pulse-stretch
wire			rd_full_stretch  = 1'b0;
//wire			rd_pempty_stretch = 1'b0;
wire			rd_pfull_stretch = 1'b0;

wire			rd_pempty;

wire [39:0]		tx_data_out;

wire			wordslip;
//wire			wordslip_exe;

wire 			fifo_srst_n_rd_clk;
wire 			fifo_srst_n_wr_clk;

wire [79:0]		wm_data_in;
wire [79:0]		wm_data_out;
wire [79:0]		fifo_data_in;

wire			fifo_empty;
wire			fifo_full;
wire			fifo_pempty;
wire			fifo_pfull;

//wire [19:0]		frame_gen_testbus1;		// To be connected to TB
//wire [19:0]		frame_gen_testbus2;

wire			latency_pulse;

wire			rd_empty_comb;			// To be connected to pulse-stretch
wire			rd_en;		
wire			rd_full;			// To be removed
wire			rd_pempty_comb;			// To be connected to pulse-stretch

//wire [19:0]		tx_fifo_testbus1;		// To be connected to TB
//wire [19:0]		tx_fifo_testbus2;	
//wire [19:0]		tx_cp_bond_testbus;

wire			tx_frame;

wire			r_empty_type = 1'b0;
wire			r_pempty_type = 1'b0;
wire			r_full_type = 1'b1;
wire			r_pfull_type = 1'b1;

wire			rd_pempty_raw;
wire			rd_empty_raw;
wire			burst_en_exe_raw;
wire			wordslip_exe_raw;
wire			tx_frame_raw;

wire			tx_wordslip_exe;
wire			tx_burst_en_exe;

wire                    nfrz_output_2one;
reg			pld_tx_hssi_fifo_latency_pulse_int;


wire			pld_tx_fabric_fifo_empty_int; 
wire			pld_tx_fabric_fifo_full_int;
wire			pld_tx_fabric_fifo_pempty_int;
wire			pld_tx_fabric_fifo_pfull_int; 
wire			pld_tx_fabric_fifo_latency_pulse_int;
wire			pld_10g_tx_burst_en_exe_int;
wire			pld_10g_tx_wordslip_exe_int;
wire			pld_10g_krfec_tx_frame_int;

wire 			start_dv;
wire			fifo_wr_en;
wire			compin_sel_wren;
wire			compin_sel_rden;

//wire [2:0]		r_stretch_num_stages =		3'd4;	// Tie off for now. To be connected to DPRIO	

// Add _tx to DPRIO bit name
wire			r_bonding_dft_in_en = r_tx_bonding_dft_in_en;
wire			r_bonding_dft_in_value =	r_tx_bonding_dft_in_value;	
wire			r_burst_en =			r_tx_burst_en;		
wire			r_bypass_frmgen =		r_tx_bypass_frmgen;	
wire [8-1:0]	        r_comp_cnt =			r_tx_comp_cnt;		
wire [1:0]		r_compin_sel =			r_tx_compin_sel;		
wire			r_double_write =		r_tx_double_write;		
wire			r_ds_bypass_pipeln =		r_tx_ds_bypass_pipeln;	
wire			r_ds_master =			r_tx_ds_master;		
wire			r_dv_indv =			r_tx_dv_indv;		
wire [4:0]		r_empty =			r_tx_fifo_empty;		
wire [2:0]		r_fifo_mode =			r_tx_fifo_mode;		
wire [4:0]		r_full =			r_tx_fifo_full;			
wire			r_gb_dv_en =			r_tx_gb_dv_en;		
wire [2:0]		r_gb_idwidth =			r_tx_gb_idwidth;		
wire [1:0]		r_gb_odwidth =			r_tx_gb_odwidth;		
wire			r_indv =			r_tx_indv;			
wire [15:0]		r_mfrm_length =			r_tx_mfrm_length;		
wire [4:0]		r_pempty =			r_tx_fifo_pempty;		
wire [4:0]		r_pfull =			r_tx_fifo_pfull;		
wire [2:0]		r_phcomp_rd_delay =		r_tx_phcomp_rd_delay;	
wire			r_pipeln_frmgen =		r_tx_pipeln_frmgen;	
wire			r_pyld_ins =			r_tx_pyld_ins;		
wire			r_sh_err =			r_tx_sh_err;		
wire			r_stop_read =			r_tx_stop_read;		
wire			r_stop_write =			r_tx_stop_write;		
wire			r_us_bypass_pipeln =		r_tx_us_bypass_pipeln;	
wire			r_us_master =			r_tx_us_master;		
wire			r_wm_en =			r_tx_wm_en;		
wire			r_wordslip =			r_tx_wordslip;		

assign asn_fifo_srst	= tx_asn_fifo_srst;
assign asn_gen3_sel	= tx_asn_gen3_sel;
assign burst_en		= pld_10g_tx_burst_en;

assign clk		= tx_clock_fifo_rd_clk;
assign rst_n		= tx_reset_fifo_rd_rst_n;

assign rd_rst_n		= tx_reset_fifo_rd_rst_n;
assign rd_srst_n	= 1'b1;				// Tie off sync reset for now
assign s_clk		= tx_clock_fifo_sclk;
assign s_rst_n		= tx_reset_fifo_sclk_rst_n;
assign tx_rdfifo_clk  	= tx_clock_fifo_rd_clk;
assign tx_wrfifo_clk  	= tx_clock_fifo_wr_clk;
assign tx_rdfifo_clk_rst_n	= tx_reset_fifo_rd_rst_n;
assign tx_wrfifo_clk_rst_n	= tx_reset_fifo_wr_rst_n;
assign rd_clk		= tx_clock_fifo_rd_clk;
assign wr_clk		= tx_clock_fifo_wr_clk;
assign q1_wr_clk	= q1_tx_clock_fifo_wr_clk;
assign q2_wr_clk	= q2_tx_clock_fifo_wr_clk;
assign q3_wr_clk	= q3_tx_clock_fifo_wr_clk;
assign q4_wr_clk	= q4_tx_clock_fifo_wr_clk;
assign q5_wr_clk	= q5_tx_clock_fifo_wr_clk;
assign q6_wr_clk	= q6_tx_clock_fifo_wr_clk;

assign wr_rst_n		= tx_reset_fifo_wr_rst_n;
assign wr_srst_n	= 1'b1;				// Tie off sync reset for now


assign comp_dv_en 	=	comp_out_dv_en;
assign comp_rden_en	= 	comp_out_rden_en;
assign comp_wren_en	= 	comp_out_wren_en;

assign master_in_dv	= dv_en;
assign master_in_rden   = phcomp_rden;
assign master_in_wren   = phcomp_wren;

// Tie-off bonding if it's last us/ds channel

// ECO8
assign ds_in_rden	= (!r_tx_ds_last_chnl && r_tx_rden_fastbond[0]) ? bond_tx_fifo_ds_in_rden : (!r_tx_ds_last_chnl && !r_tx_rden_fastbond[0]) ? bond_tx_fifo_ds_in_rden : 1'b0;
assign ds_in_wren	= (!r_tx_ds_last_chnl && r_tx_wren_fastbond[0]) ? bond_tx_fifo_ds_in_wren : (!r_tx_ds_last_chnl && !r_tx_wren_fastbond[0]) ? bond_tx_fifo_ds_in_wren : 1'b0;

assign us_in_rden	= (!r_tx_us_last_chnl && r_tx_rden_fastbond[1]) ? bond_tx_fifo_us_in_rden : (!r_tx_us_last_chnl && !r_tx_rden_fastbond[1]) ? bond_tx_fifo_us_in_rden : 1'b0;
assign us_in_wren	= (!r_tx_us_last_chnl && r_tx_wren_fastbond[1]) ? bond_tx_fifo_us_in_wren : (!r_tx_us_last_chnl && !r_tx_wren_fastbond[1]) ? bond_tx_fifo_us_in_wren : 1'b0;

// ECO8 DV not used in HIP mode.   
assign ds_in_dv		= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_dv;
assign us_in_dv		= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_dv;
   
/* ECO8
assign ds_in_dv		= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_dv;
assign ds_in_rden	= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_rden;
assign ds_in_wren	= r_tx_ds_last_chnl ? 1'b0 : bond_tx_fifo_ds_in_wren;

assign us_in_dv		= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_dv;
assign us_in_rden	= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_rden;
assign us_in_wren	= r_tx_us_last_chnl ? 1'b0 : bond_tx_fifo_us_in_wren;
*/ 

assign bond_tx_fifo_ds_out_dv	= ds_out_dv;
assign bond_tx_fifo_ds_out_rden	= ds_out_rden;
assign bond_tx_fifo_ds_out_wren	= ds_out_wren;

assign bond_tx_fifo_us_out_dv	= us_out_dv;
assign bond_tx_fifo_us_out_rden	= us_out_rden;
assign bond_tx_fifo_us_out_wren	= us_out_wren;

assign data_valid_in_raw	= dv_gen_data_valid_out;
assign data_valid_raw		= dv_gen_data_valid_out;

assign diag_status	= pld_10g_tx_diag_status;

//assign rd_pempty	= fifo_empty;			// To be changed to rd_pempty
assign rd_pempty	= rd_pempty_raw;

assign wordslip		= pld_10g_tx_wordslip;

// Output of work-mark --> input of FIFO
assign fifo_data_in	= wm_data_out;
assign wm_data_in	= pld_tx_fabric_data_in;
assign fifo_wr_en	= pld_tx_fabric_data_in[79];

assign pld_tx_fabric_fifo_full_int		= fifo_full;		
assign pld_tx_fabric_fifo_empty_int		= fifo_empty;
assign pld_tx_fabric_fifo_pfull_int		= fifo_pfull;
assign pld_tx_fabric_fifo_pempty_int	= fifo_pempty;

assign pld_tx_fabric_fifo_latency_pulse_int	= latency_pulse;

assign pld_10g_krfec_tx_frame_int = tx_frame;			// Mux with krfec_frame???

assign pld_10g_tx_burst_en_exe_int = tx_burst_en_exe;
assign pld_10g_tx_wordslip_exe_int = tx_wordslip_exe;

hdpldadapt_tx_datapath_fifo hdpldadapt_tx_datapath_fifo(/*AUTOINST*/
							// Outputs
							.aib_fabric_tx_data_out(tx_data_out),	// Rename port
							.fifo_out_comb	(fifo_out_comb),
							.data_valid_out	(data_valid_out),
							.rd_pfull	(rd_pfull),
							.rd_full	(rd_full),
							.rd_empty_comb	(rd_empty_raw),
							.rd_pempty_comb	(rd_pempty_raw),
							.fifo_empty	(fifo_empty),
							.fifo_pempty	(fifo_pempty),
							.fifo_pfull	(fifo_pfull),
							.fifo_full	(fifo_full),
							.phcomp_wren	(phcomp_wren),
							.phcomp_rden	(phcomp_rden),
							.dv_en		(dv_en),
							.comp_dv_en_reg	(comp_dv_en_reg),
							.latency_pulse	(latency_pulse),
							.double_write_int(double_write_int),
							.fifo_srst_n_wr_clk(fifo_srst_n_wr_clk),
							.fifo_srst_n_rd_clk(fifo_srst_n_rd_clk),
							.fifo_ready	(tx_fifo_ready),
							.testbus1	(tx_fifo_testbus1[19:0]),
							.testbus2	(tx_fifo_testbus2[19:0]),
							// Inputs
							.wr_rst_n	(wr_rst_n),
							.rd_rst_n	(rd_rst_n),
							.wr_srst_n	(wr_srst_n),
							.rd_srst_n	(rd_srst_n),
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
							.r_pempty	(r_pempty[4:0]),
							.r_pfull	(r_pfull[4:0]),
							.r_empty	(r_empty[4:0]),
							.r_full		(r_full[4:0]),
							.r_indv		(r_indv),
							.r_phcomp_rd_delay(r_phcomp_rd_delay[2:0]),
							.r_pempty_type	(r_pempty_type),
							.r_pfull_type	(r_pfull_type),
							.r_empty_type	(r_empty_type),
							.r_full_type	(r_full_type),
							.r_stop_read	(r_stop_read),
							.r_stop_write	(r_stop_write),
							.r_double_write	(r_double_write),
							.r_dv_indv	(r_dv_indv),
							.r_gb_dv_en	(r_gb_dv_en),
							.r_fifo_power_mode (r_tx_fifo_power_mode),
							.r_wr_adj_en (r_tx_wr_adj_en),
							.r_rd_adj_en (r_tx_rd_adj_en),														
							.fifo_latency_adj	(pld_tx_fifo_latency_adj_en),
							.start_dv		(start_dv),
							.fifo_wr_en		(fifo_wr_en),
							.pld_tx_fabric_data_in(fifo_data_in),		// Rename port							
							.frm_gen_rd_en	(frm_gen_rd_en),
							.data_valid_raw	(data_valid_raw),
							.data_valid_2x	(dv_gen_data_valid_2x),
							.comp_dv_en	(comp_dv_en),
							.comp_wren_en	(comp_wren_en),
							.comp_rden_en	(comp_rden_en),
							.compin_sel_wren	(compin_sel_wren),
							.compin_sel_rden	(compin_sel_rden),
							.asn_fifo_srst	(asn_fifo_srst),
							.asn_gen3_sel	(asn_gen3_sel),
							.asn_fifo_hold (tx_asn_fifo_hold),
							.rd_pfull_stretch(rd_pfull_stretch),
							.rd_empty_stretch(rd_empty_stretch),
							.rd_pempty_stretch(rd_pempty_stretch),
							.rd_full_stretch(rd_full_stretch));   
hdpldadapt_tx_datapath_word_mark hdpldadapt_tx_datapath_word_mark(/*AUTOINST*/
								  // Outputs
								  .data_out		(wm_data_out[79:0]),
								  // Inputs
								  .data_in		(wm_data_in[79:0]),
								  .r_wm_en		(r_wm_en));
hdpldadapt_tx_datapath_cp_bond hdpldadapt_tx_datapath_cp_bond(/*AUTOINST*/
							      // Outputs
							      .us_out_dv	(us_out_dv),
							      .ds_out_dv	(ds_out_dv),
							      .us_out_wren	(us_out_wren),
							      .ds_out_wren	(ds_out_wren),
							      .us_out_rden	(us_out_rden),
							      .ds_out_rden	(ds_out_rden),
							      .comp_out_dv_en	(comp_out_dv_en),
							      .comp_out_wren_en	(comp_out_wren_en),
							      .comp_out_rden_en	(comp_out_rden_en),
							      .compin_sel_wren	(compin_sel_wren),
							      .compin_sel_rden	(compin_sel_rden),
							      .tx_cp_bond_testbus(tx_cp_bond_testbus[19:0]),
							      // Inputs
							      .tx_wrfifo_clk	(tx_wrfifo_clk),
							      .tx_rdfifo_clk	(tx_rdfifo_clk),
							      .tx_rdfifo_clk_rst_n(tx_rdfifo_clk_rst_n),
							      .tx_wrfifo_clk_rst_n(tx_wrfifo_clk_rst_n),
							      .wr_srst_n	(fifo_srst_n_wr_clk),
							      .rd_srst_n	(fifo_srst_n_rd_clk),
							      .data_valid_in_raw(data_valid_in_raw),
							      .r_us_master	(r_us_master),
							      .r_ds_master	(r_ds_master),
							      .r_us_bypass_pipeln(r_us_bypass_pipeln),
							      .r_ds_bypass_pipeln(r_ds_bypass_pipeln),
							      .r_compin_sel	(r_compin_sel[1:0]),
							      .r_comp_cnt	(r_comp_cnt),
							      .r_bonding_dft_in_en(r_bonding_dft_in_en),
							      .r_bonding_dft_in_value(r_bonding_dft_in_value),
							      .double_write_int	(double_write_int),
							      .master_in_dv	(master_in_dv),
							      .us_in_dv		(us_in_dv),
							      .ds_in_dv		(ds_in_dv),
							      .master_in_wren	(master_in_wren),
							      .us_in_wren	(us_in_wren),
							      .ds_in_wren	(ds_in_wren),
							      .master_in_rden	(master_in_rden),
							      .us_in_rden	(us_in_rden),
							      .ds_in_rden	(ds_in_rden));
hdpldadapt_tx_datapath_dv_gen hdpldadapt_tx_datapath_dv_gen(/*AUTOINST*/
							    // Outputs
							    .data_valid_2x	(dv_gen_data_valid_2x),
							    .data_valid_out	(dv_gen_data_valid_out),
							    .start_dv		(start_dv),
							    .dv_gen_testbus	(dv_gen_testbus),
							    // Inputs
							    .rst_n		(rst_n),
							    .clk		(clk),
							    .r_double_write	(r_double_write),
							    .r_dv_indv		(r_dv_indv),
							    .r_gb_idwidth	(r_gb_idwidth[2:0]),
							    .r_gb_odwidth	(r_gb_odwidth[1:0]),
							    .r_fifo_mode	(r_fifo_mode[2:0]),
							    .r_gb_dv_en		(r_gb_dv_en),
							    .rd_pempty		(rd_pempty),
//							    .data_valid_in	(data_valid_in),
							    .phcomp_rden	(phcomp_rden),
							    .comp_dv_en_reg	(comp_dv_en_reg));
hdpldadapt_tx_datapath_frame_gen hdpldadapt_tx_datapath_frame_gen(/*AUTOINST*/
								  // Outputs
								  .aib_fabric_tx_data_out(aib_fabric_tx_data_out[39:0]),
								  .rd_en		(frm_gen_rd_en),
								  .tx_frame		(tx_frame_raw),
								  .burst_en_exe		(burst_en_exe_raw),
								  .wordslip_exe		(wordslip_exe_raw),
								  .frame_gen_testbus1	(frame_gen_testbus1[19:0]),
								  .frame_gen_testbus2	(frame_gen_testbus2[19:0]),
								  // Inputs
								  .clk			(tx_clock_fifo_rd_clk_frm_gen),
								  .rst_n		(rst_n),
								  .r_bypass_frmgen	(r_bypass_frmgen),
								  .r_pipeln_frmgen	(r_pipeln_frmgen),
								  .r_mfrm_length	(r_mfrm_length[15:0]),
								  .r_pyld_ins		(r_pyld_ins),
								  .r_sh_err		(r_sh_err),
								  .r_burst_en		(r_burst_en),
								  .r_wordslip		(r_wordslip),
								  .r_indv		(r_indv),
								  .data_valid_in_raw	(data_valid_in_raw),
								  .data_valid_2x	(dv_gen_data_valid_2x),
							          .start_dv		(start_dv),
								  .diag_status		(diag_status[1:0]),
								  .burst_en		(burst_en),
								  .wordslip		(wordslip),
								  .rd_pfull		(rd_pfull),
								  .tx_fifo_data		(tx_data_out[39:0]),
								  .fifo_out_comb	(fifo_out_comb[39:0]));

hdpldadapt_tx_datapath_pulse_stretch hdpldadapt_tx_datapath_pulse_stretch (
								    .clk		(rd_clk),
								    .rst_n		(rd_rst_n),
								    .rd_pempty_raw	(rd_pempty_raw),
								    .rd_empty_raw	(rd_empty_raw),
								    .burst_en_exe_raw	(burst_en_exe_raw),
								    .wordslip_exe_raw	(wordslip_exe_raw),
								    .tx_frame_raw	(tx_frame_raw),
								    
								    .r_stretch_num_stages (r_tx_stretch_num_stages),
								    .rd_pempty_stretch 	(rd_pempty_stretch),
								    .rd_empty_stretch 	(rd_empty_stretch),
								    .tx_burst_en_exe	(tx_burst_en_exe),
								    .tx_wordslip_exe	(tx_wordslip_exe),
								    .tx_frame		(tx_frame));


// Pipeline hssi_latency_pulse
always @(negedge tx_reset_fifo_sclk_rst_n or posedge tx_clock_fifo_sclk) begin
   if (tx_reset_fifo_sclk_rst_n == 1'b0) begin
     pld_tx_hssi_fifo_latency_pulse_int <= 1'b0;
   end
   else begin
     pld_tx_hssi_fifo_latency_pulse_int <= aib_fabric_pld_tx_hssi_fifo_latency_pulse;
   end
end

// Freeze outputs to PLD
assign nfrz_output_2one  = nfrzdrv_in & pr_channel_freeze_n;

assign pld_tx_fabric_fifo_empty 	= nfrz_output_2one ?  	pld_tx_fabric_fifo_empty_int : 1'b1; 
assign pld_tx_fabric_fifo_full		= nfrz_output_2one ?  	pld_tx_fabric_fifo_full_int : 1'b1;
assign pld_tx_fabric_fifo_pempty	= nfrz_output_2one ?  	pld_tx_fabric_fifo_pempty_int : 1'b1;
assign pld_tx_fabric_fifo_pfull 	= nfrz_output_2one ?  	pld_tx_fabric_fifo_pfull_int : 1'b1; 
assign pld_tx_fabric_fifo_latency_pulse	= nfrz_output_2one ?  	pld_tx_fabric_fifo_latency_pulse_int : 1'b1;
assign pld_10g_tx_burst_en_exe		= nfrz_output_2one ?  	pld_10g_tx_burst_en_exe_int : 1'b1;
assign pld_10g_tx_wordslip_exe		= nfrz_output_2one ?  	pld_10g_tx_wordslip_exe_int : 1'b1;
assign pld_10g_krfec_tx_frame		= nfrz_output_2one ?  	pld_10g_krfec_tx_frame_int : 1'b1;
assign pld_tx_hssi_fifo_latency_pulse   = nfrz_output_2one ?  	(r_tx_usertest_sel ? pld_tx_hssi_fifo_latency_pulse_int : aib_fabric_pld_tx_hssi_fifo_latency_pulse ): 1'b1;
assign pld_tx_fifo_ready		= nfrz_output_2one ? 	tx_fifo_ready : 1'b1;


endmodule
