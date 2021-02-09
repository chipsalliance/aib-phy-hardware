// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm1_config
(
input   wire            avmm_clock_dprio_clk,            
input   wire            avmm_reset_avmm_rst_n,        

// ATPG Scan
input   wire            adapter_scan_shift_n,
input   wire            adapter_scan_mode_n,
input   wire            adapter_scan_shift_clk,
input   wire            adapter_scan_rst_n,
input   wire  [3:0]     adapter_config_scan_in,  

// CSR
input   wire            avmm_clock_csr_clk,
input   wire            avmm_clock_csr_clk_n,
input   wire    [2:0]   csr_config,
input   wire    [2:0]   csr_in,                
input   wire            csr_rdy_in,
input   wire    [2:0]   csr_pipe_in,

// From PLD
input   wire            pld_avmm1_read,
input   wire    [9:0]   pld_avmm1_reg_addr,	
input   wire            pld_avmm1_request,
input   wire            pld_avmm1_write,
input   wire    [7:0]   pld_avmm1_writedata,	
input   wire    [8:0]   pld_avmm1_reserved_in,	

// From AVMM transfer
input   wire            remote_pld_avmm_busy,	
input   wire    [7:0]   remote_pld_avmm_readdata,
input   wire            remote_pld_avmm_readdatavalid,
input   wire    [2:0]   remote_pld_avmm_reserved_out,
input   wire            int_pld_avmm_cmdfifo_wr_pfull,

// Status Register
input   wire    [7:0]   rx_chnl_dprio_status, 
input   wire            rx_chnl_dprio_status_write_en_ack,
input   wire    [7:0]   tx_chnl_dprio_status,            
input   wire            tx_chnl_dprio_status_write_en_ack,

// SSM
input   wire            nfrzdrv_in,
input   wire            usermode_in,

// uC AVMM

// From SR
input   wire            sr_hssi_avmm1_busy,

// ATPG Scan
output  wire   [3:0]    adapter_config_scan_out, 

// IOCSR
output  wire    [2:0]   csr_out,         
output  wire    [2:0]   csr_pipe_out,

// To PLD
output  wire            pld_avmm1_busy,
output  wire    [7:0]   pld_avmm1_readdata,	
output  wire            pld_avmm1_readdatavalid,
output  wire    [2:0]   pld_avmm1_reserved_out,	

// To Remote
output  wire            remote_pld_avmm_read,	
output  wire    [9:0]   remote_pld_avmm_reg_addr,	
output  wire            remote_pld_avmm_request,
output  wire            remote_pld_avmm_write,
output  wire    [7:0]   remote_pld_avmm_writedata,
output  wire    [8:0]   remote_pld_avmm_reserved_in,

// To uC AVMM

// Status Register
output  wire            rx_chnl_dprio_status_write_en,
output  wire            tx_chnl_dprio_status_write_en,

// testbus
output  wire   [10:0]   avmm1_cmn_intf_testbus,

// DPRIO & IOCSR
 
// new ouputs for ECO8
    output  wire [1:0]  r_tx_wren_fastbond,
    output  wire [1:0]  r_tx_rden_fastbond,                                
    output  wire [1:0]  r_rx_wren_fastbond,
    output  wire [1:0]  r_rx_rden_fastbond, 
 
output  wire    [3:0]   r_tx_hip_aib_ssr_in_polling_bypass,
output  wire            r_tx_pld_8g_tx_boundary_sel_polling_bypass,
output  wire            r_tx_pld_10g_tx_bitslip_polling_bypass,
output  wire            r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
output  wire            r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,
output  wire [4:0]      r_tx_fifo_empty,
output  wire [2:0]      r_tx_fifo_mode,
output  wire [4:0]      r_tx_fifo_full,
output  wire [2:0]      r_tx_phcomp_rd_delay,
output  wire [4:0]      r_tx_fifo_pempty,
output  wire            r_tx_indv,
output  wire            r_tx_stop_read,
output  wire            r_tx_stop_write,
output  wire [4:0]      r_tx_fifo_pfull,
output  wire            r_tx_double_write,
output  wire [7:0]      r_tx_comp_cnt,
output  wire            r_tx_us_master,
output  wire            r_tx_ds_master,
output  wire            r_tx_us_bypass_pipeln,
output  wire            r_tx_ds_bypass_pipeln,
output  wire [1:0]      r_tx_compin_sel,
output  wire            r_tx_bonding_dft_in_en,
output  wire            r_tx_bonding_dft_in_value,
output  wire            r_tx_dv_indv,
output  wire [2:0]      r_tx_gb_idwidth,
output  wire [1:0]      r_tx_gb_odwidth,
output  wire            r_tx_gb_dv_en,
output  wire [15:0]     r_tx_mfrm_length,
output  wire            r_tx_bypass_frmgen,
output  wire            r_tx_pipeln_frmgen,
output  wire            r_tx_pyld_ins,
output  wire            r_tx_sh_err,
output  wire            r_tx_burst_en,
output  wire            r_tx_wm_en,
output  wire            r_tx_wordslip,
output  wire [2:0]	r_tx_fifo_power_mode,
output  wire [2:0]	r_tx_stretch_num_stages, 
output  wire [2:0]	r_tx_datapath_tb_sel, 
output  wire		r_tx_wr_adj_en, 
output  wire            r_tx_rd_adj_en,
output  wire            r_tx_async_pld_txelecidle_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit0_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit1_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit2_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit3_rst_val,
output  wire            r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit0_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit1_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit2_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit3_rst_val,
output  wire            r_tx_fpll_shared_direct_async_in_sel,
output  wire [1:0]      r_tx_aib_clk1_sel,
output  wire [1:0]      r_tx_aib_clk2_sel,
output  wire [1:0]      r_tx_fifo_rd_clk_sel,
output  wire            r_tx_pld_clk1_sel,
output	wire		r_tx_pld_clk1_delay_en,
output	wire [3:0]	r_tx_pld_clk1_delay_sel,
output	wire		r_tx_pld_clk1_inv_en,
output  wire            r_tx_pld_clk2_sel,
output	wire		r_tx_fifo_rd_clk_frm_gen_scg_en,
output  wire            r_tx_fifo_rd_clk_scg_en,
output  wire            r_tx_fifo_wr_clk_scg_en,
output  wire            r_tx_osc_clk_scg_en,
output  wire            r_tx_hrdrst_rst_sm_dis,
output  wire            r_tx_hrdrst_dcd_cal_done_bypass,
output	wire		r_tx_hrdrst_user_ctl_en,
output  wire            r_tx_ds_last_chnl,
output  wire            r_tx_us_last_chnl,
output  wire            r_tx_hrdrst_rx_osc_clk_scg_en,
output	wire		r_tx_hip_osc_clk_scg_en,
output	wire		r_tx_usertest_sel,
output	wire		r_rx_usertest_sel,
output  wire [5:0]      r_rx_fifo_empty,
output  wire [5:0]      r_rx_fifo_full,
output  wire            r_rx_double_read,
output  wire            r_rx_gb_dv_en,
output  wire [5:0]      r_rx_fifo_pempty,
output  wire            r_rx_stop_read,
output  wire            r_rx_stop_write,
output  wire [5:0]      r_rx_fifo_pfull,
output  wire            r_rx_indv,
output  wire            r_rx_truebac2bac,
output  wire [2:0]      r_rx_fifo_mode,
output  wire [2:0]      r_rx_phcomp_rd_delay,
output  wire [7:0]      r_rx_comp_cnt,
output  wire            r_rx_us_master,
output  wire            r_rx_ds_master,
output  wire            r_rx_us_bypass_pipeln,
output  wire            r_rx_ds_bypass_pipeln,
output  wire [1:0]      r_rx_compin_sel,
output  wire            r_rx_bonding_dft_in_en,
output  wire            r_rx_bonding_dft_in_value,
output  wire            r_rx_wa_en,
output  wire     	r_rx_write_ctrl,
output  wire [2:0]	r_rx_fifo_power_mode,
output  wire [2:0]	r_rx_stretch_num_stages, 
output  wire [3:0]	r_rx_datapath_tb_sel, 
output  wire		r_rx_wr_adj_en, 
output  wire            r_rx_rd_adj_en, 
output  wire            r_rx_pipe_en,
output  wire            r_rx_lpbk_en,
output                  r_rx_asn_en,
output                  r_rx_asn_bypass_pma_pcie_sw_done,
output [7:0]            r_rx_asn_wait_for_fifo_flush_cnt,
output [7:0]            r_rx_asn_wait_for_dll_reset_cnt,
output [7:0]            r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
output	wire		r_rx_free_run_div_clk,
output  wire            r_rx_hrdrst_rst_sm_dis,
output  wire            r_rx_hrdrst_dll_lock_bypass,
output  wire            r_rx_hrdrst_align_bypass,
output	wire		r_rx_hrdrst_user_ctl_en,
output  wire            r_rx_ds_last_chnl,
output  wire            r_rx_us_last_chnl,
output  wire            r_rx_async_pld_ltr_rst_val,
output  wire            r_rx_async_pld_pma_ltd_b_rst_val,
output  wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
output  wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,
output  wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,
output  wire            r_rx_async_prbs_flags_sr_enable,
output  wire            r_rx_pld_8g_eidleinfersel_polling_bypass,
output  wire            r_rx_pld_pma_eye_monitor_polling_bypass,
output  wire            r_rx_pld_pma_pcie_switch_polling_bypass,
output  wire            r_rx_pld_pma_reser_out_polling_bypass,
output  wire [1:0]      r_rx_aib_clk1_sel,
output  wire [1:0]      r_rx_aib_clk2_sel,
output  wire 		r_rx_fifo_wr_clk_sel,
output  wire [1:0]      r_rx_fifo_rd_clk_sel,
output  wire            r_rx_pld_clk1_sel,
output	wire		r_rx_pld_clk1_delay_en,
output	wire [3:0]	r_rx_pld_clk1_delay_sel,
output	wire		r_rx_pld_clk1_inv_en,
output  wire            r_rx_sclk_sel,
output  wire            r_rx_fifo_wr_clk_scg_en,
output  wire            r_rx_fifo_rd_clk_scg_en,
output  wire            r_rx_pma_hclk_scg_en,
output  wire            r_rx_osc_clk_scg_en,
output	wire		r_rx_fifo_wr_clk_del_sm_scg_en,
output	wire		r_rx_fifo_rd_clk_ins_sm_scg_en,
output  wire            r_rx_hrdrst_rx_osc_clk_scg_en,
output   wire            r_rx_internal_clk1_sel1,
output   wire            r_rx_internal_clk1_sel2,
output   wire            r_rx_txfiford_post_ct_sel,
output   wire            r_rx_txfifowr_post_ct_sel,
output   wire            r_rx_internal_clk2_sel1,
output   wire            r_rx_internal_clk2_sel2,
output   wire            r_rx_rxfifowr_post_ct_sel,
output   wire            r_rx_rxfiford_post_ct_sel,
output  wire            r_sr_hip_en,
output  wire            r_sr_reserbits_in_en,
output  wire            r_sr_reserbits_out_en,
output  wire            r_sr_testbus_sel,
output  wire            r_sr_parity_en,
output  wire            r_sr_osc_clk_scg_en,
output  wire [7:0]      r_aib_dprio_ctrl_0,
output  wire [7:0]      r_aib_dprio_ctrl_1,
output  wire [7:0]      r_aib_dprio_ctrl_2,
output  wire [7:0]      r_aib_dprio_ctrl_3,
output  wire [7:0]      r_aib_dprio_ctrl_4,
output  wire            r_avmm_hrdrst_osc_clk_scg_en,
output  wire [1:0]      r_avmm_testbus_sel,
output  wire            r_avmm1_osc_clk_scg_en,
output  wire            r_avmm1_avmm_clk_scg_en,
output  wire [5:0]      r_avmm1_cmdfifo_full,
output  wire            r_avmm1_cmdfifo_stop_read,
output  wire            r_avmm1_cmdfifo_stop_write,
output  wire [5:0]      r_avmm1_cmdfifo_empty,
output  wire [5:0]      r_avmm1_cmdfifo_pfull,
output  wire [5:0]      r_avmm1_rdfifo_full,
output  wire            r_avmm1_rdfifo_stop_read,
output  wire            r_avmm1_rdfifo_stop_write,
output  wire [5:0]      r_avmm1_rdfifo_empty,
output  wire            r_avmm2_osc_clk_scg_en,
output  wire            r_avmm2_avmm_clk_scg_en,
output  wire [5:0]      r_avmm2_cmdfifo_full,
output  wire            r_avmm2_cmdfifo_stop_read,
output  wire            r_avmm2_cmdfifo_stop_write,
output  wire [5:0]      r_avmm2_cmdfifo_empty,
output  wire [5:0]      r_avmm2_cmdfifo_pfull,
output  wire [5:0]      r_avmm2_rdfifo_full,
output  wire            r_avmm2_rdfifo_stop_read,
output  wire            r_avmm2_rdfifo_stop_write,
output  wire [5:0]      r_avmm2_rdfifo_empty,
output  wire            r_avmm2_hip_sel,
output  wire            r_avmm2_gate_dis,
output  wire [7:0]      r_aib_csr_ctrl_0,
output  wire [7:0]      r_aib_csr_ctrl_1,
output  wire [7:0]      r_aib_csr_ctrl_2,
output  wire [7:0]      r_aib_csr_ctrl_3,
output  wire [7:0]      r_aib_csr_ctrl_4,
output  wire [7:0]      r_aib_csr_ctrl_5,
output  wire [7:0]      r_aib_csr_ctrl_6,
output  wire [7:0]      r_aib_csr_ctrl_7,
output  wire [7:0]      r_aib_csr_ctrl_8,
output  wire [7:0]      r_aib_csr_ctrl_9,
output  wire [7:0]      r_aib_csr_ctrl_10,
output  wire [7:0]      r_aib_csr_ctrl_11,
output  wire [7:0]      r_aib_csr_ctrl_12,
output  wire [7:0]      r_aib_csr_ctrl_13,
output  wire [7:0]      r_aib_csr_ctrl_14,
output  wire [7:0]      r_aib_csr_ctrl_15,
output  wire [7:0]      r_aib_csr_ctrl_16,
output  wire [7:0]      r_aib_csr_ctrl_17,
output  wire [7:0]      r_aib_csr_ctrl_18,
output  wire [7:0]      r_aib_csr_ctrl_19,
output  wire [7:0]      r_aib_csr_ctrl_20,
output  wire [7:0]      r_aib_csr_ctrl_21,
output  wire [7:0]      r_aib_csr_ctrl_22,
output  wire [7:0]      r_aib_csr_ctrl_23,
output  wire [7:0]      r_aib_csr_ctrl_24,
output  wire [7:0]      r_aib_csr_ctrl_25,
output  wire [7:0]      r_aib_csr_ctrl_26,
output  wire [7:0]      r_aib_csr_ctrl_27,
output  wire [7:0]      r_aib_csr_ctrl_28,
output  wire [7:0]      r_aib_csr_ctrl_29,
output  wire [7:0]      r_aib_csr_ctrl_30,
output  wire [7:0]      r_aib_csr_ctrl_31,
output  wire [7:0]      r_aib_csr_ctrl_32,
output  wire [7:0]      r_aib_csr_ctrl_33,
output  wire [7:0]      r_aib_csr_ctrl_34,
output  wire [7:0]      r_aib_csr_ctrl_35,
output  wire [7:0]      r_aib_csr_ctrl_36,
output  wire [7:0]      r_aib_csr_ctrl_37,
output  wire [7:0]      r_aib_csr_ctrl_38,
output  wire [7:0]      r_aib_csr_ctrl_39,
output  wire [7:0]      r_aib_csr_ctrl_40,
output  wire [7:0]      r_aib_csr_ctrl_41,
output  wire [7:0]      r_aib_csr_ctrl_42,
output  wire [7:0]      r_aib_csr_ctrl_43,
output  wire [7:0]      r_aib_csr_ctrl_44,
output  wire [7:0]      r_aib_csr_ctrl_45,
output  wire [7:0]      r_aib_csr_ctrl_46,
output  wire [7:0]      r_aib_csr_ctrl_47,
output  wire [7:0]      r_aib_csr_ctrl_48,
output  wire [7:0]      r_aib_csr_ctrl_49,
output  wire [7:0]      r_aib_csr_ctrl_50,
output  wire [7:0]      r_aib_csr_ctrl_51,
output  wire [7:0]      r_aib_csr_ctrl_52,
output  wire [7:0]      r_aib_csr_ctrl_53,
output  wire [7:0]      r_aib_csr_ctrl_54,
output  wire [7:0]      r_aib_csr_ctrl_55,
output  wire [7:0]      r_aib_csr_ctrl_56,
output  wire [7:0]      r_aib_csr_ctrl_57

);

wire         csr_out_int;
wire [7:0]   master_pld_avmm_writedata;
wire [7:0]   master_pld_avmm_reg_addr;
wire         master_pld_avmm_write;
wire         master_pld_avmm_read;
wire         block_select;
wire [7:0]   readdata;
wire [639:0] extra_csr_out;  
wire [383:0] user_dataout;  
wire         interface_sel;
wire         csr_test_mode;
reg  [2:0]   csr_pipe_temp;
reg  [2:0]   csr_pipe_temp_n;
wire [1:0]   dprio_status_write_en;
wire [1:0]   dprio_status_write_en_ack;
wire [15:0]  dprio_status;

wire    [55:0]  avmm_csr_ctrl;
wire    [55:0]  avmm1_csr_ctrl;
wire    [55:0]  avmm2_csr_ctrl;
wire    [135:0] tx_chnl_dprio_ctrl;
wire    [167:0] rx_chnl_dprio_ctrl;
wire    [23:0]  sr_dprio_ctrl;
wire    [7:0]   avmm1_dprio_ctrl;
wire    [7:0]   avmm2_dprio_ctrl;
wire    [463:0] aib_csr_ctrl;
wire    [39:0]  aib_dprio_ctrl;
wire    [7:0]   avmm_res_csr_ctrl;

//wire [7:0]      r_avmm1_arbiter_ctrl_0;
//wire [7:0]      r_avmm2_arbiter_ctrl_0;
wire [9:0]      r_avmm_adapt_base_addr;
wire            r_avmm_rd_block_enable;
wire            r_avmm_uc_block_enable;
wire            r_avmm_nfhssi_calibration_en;
wire            r_avmm_force_inter_sel_csr_ctrl;
wire            r_avmm_dprio_broadcast_en_csr_ctrl;
wire [9:0]      r_avmm_nfhssi_base_addr;
wire            r_avmm1_gate_dis;

wire            pld_avmm1_busy_int;
wire    [7:0]   pld_avmm1_readdata_int;
wire            pld_avmm1_readdatavalid_int;
wire    [2:0]   pld_avmm1_reserved_out_int;

wire            pld_avmm1_read_int;
wire            pld_avmm1_request_int;
wire            pld_avmm1_write_int;

wire            csr_in_chnl;
wire            csr_out_chnl_n;

reg   [2:0]     csr_temp;
reg   [2:0]     csr_temp_n;

wire            usermode_in_sync;
wire            pld_avmm1_cmdfifo_wr_pfull_dly;

// uC Feedthrough


// From PLD
   cdclib_bitsync2
     #(
       .DWIDTH      (1),    // Sync Data input
       .RESET_VAL   (0),        // Reset Value
       .CLK_FREQ_MHZ(200),
       .TOGGLE_TYPE (4),
       .VID         (1)
       )
       cdclib_bitsync2_usermode_in
         (
          .clk      (avmm_clock_dprio_clk),
          .rst_n    (avmm_reset_avmm_rst_n),
          .data_in  (usermode_in),
          .data_out (usermode_in_sync)
          );


//assign remote_pld_avmm_request = (~r_avmm1_gate_dis && ~usermode_in_sync) ? 1'b0 : pld_avmm1_request;
assign pld_avmm1_request_int   = ( (~r_avmm1_gate_dis && ~usermode_in_sync) || pld_avmm1_cmdfifo_wr_pfull_dly) ? remote_pld_avmm_request : pld_avmm1_request;
assign pld_avmm1_read_int      = ( (~r_avmm1_gate_dis && ~usermode_in_sync) || pld_avmm1_cmdfifo_wr_pfull_dly) ? 1'b0 : pld_avmm1_read;
assign pld_avmm1_write_int     = ( (~r_avmm1_gate_dis && ~usermode_in_sync) || pld_avmm1_cmdfifo_wr_pfull_dly) ? 1'b0 : pld_avmm1_write;

// To PLD
assign pld_avmm1_busy          = nfrzdrv_in ? pld_avmm1_busy_int : 1'b1;
assign pld_avmm1_readdata      = nfrzdrv_in ? pld_avmm1_readdata_int : 8'hFF;
assign pld_avmm1_readdatavalid = nfrzdrv_in ? pld_avmm1_readdatavalid_int : 1'b1;
//assign pld_avmm1_reserved_out  = nfrzdrv_in ? pld_avmm1_reserved_out_int  : 3'b111;
assign pld_avmm1_reserved_out  = nfrzdrv_in ? remote_pld_avmm_reserved_out: 3'b111;

// Extra CSR out distribution
assign avmm_csr_ctrl        = extra_csr_out[55:0]; 
assign avmm1_csr_ctrl       = extra_csr_out[111:56]; 
assign avmm2_csr_ctrl       = extra_csr_out[167:112]; 
assign aib_csr_ctrl         = extra_csr_out[631:168];
assign avmm_res_csr_ctrl    = extra_csr_out[639:632];

// DPPRI distribution
assign tx_chnl_dprio_ctrl   = user_dataout[135:0];  
assign rx_chnl_dprio_ctrl   = user_dataout[303:136]; 
assign sr_dprio_ctrl        = user_dataout[327:304];
assign avmm1_dprio_ctrl     = user_dataout[335:328];
assign avmm2_dprio_ctrl     = user_dataout[343:336];
assign aib_dprio_ctrl       = user_dataout[383:344]; 

// ATPG 
//assign  interface_sel  = adapter_scan_shift_n ? (!csr_rdy_in) : pld_avmm1_read_int;  // AR: to be confirm
assign  interface_sel  = !csr_rdy_in;
assign  csr_test_mode  = !adapter_scan_shift_n;

// CSR Selection
assign  csr_in_chnl = csr_config[2] ? csr_in[2] :
                      csr_config[1] ? csr_in[1] :
                      csr_config[0] ? csr_in[0] : 1'b0;

// CSR In and OUT
always @(posedge avmm_clock_csr_clk) begin
    begin
      csr_pipe_temp <= csr_pipe_in;
      csr_temp      <= csr_in;
    end
end

always @(posedge avmm_clock_csr_clk_n) begin
    begin
      csr_pipe_temp_n <= csr_pipe_temp;
      csr_temp_n      <= csr_temp;
    end
end

assign csr_pipe_out = csr_pipe_temp_n;

assign csr_out[0] = csr_config[0] ? csr_out_chnl_n  : csr_temp_n[0];
assign csr_out[1] = csr_config[1] ? csr_out_chnl_n  : csr_temp_n[1];
assign csr_out[2] = csr_config[2] ? csr_out_chnl_n  : csr_temp_n[2];

// Status Registers
assign {rx_chnl_dprio_status_write_en,tx_chnl_dprio_status_write_en} = dprio_status_write_en;
assign dprio_status_write_en_ack = {rx_chnl_dprio_status_write_en_ack,tx_chnl_dprio_status_write_en_ack};
assign dprio_status              = {rx_chnl_dprio_status[7:0],tx_chnl_dprio_status[7:0]};

hdpldadapt_avmm_cmn_intf hdpldadapt_avmm_cmn_intf (
     // input
     .avmm_rst_n                 (avmm_reset_avmm_rst_n),
     .scan_shift_n               (adapter_scan_shift_n),
     .scan_mode_n                (adapter_scan_mode_n),
     .scan_shift_clk             (adapter_scan_shift_clk),
     .scan_rst_n                 (adapter_scan_rst_n),
     .csr_clk                    (avmm_clock_csr_clk),
     .csr_bit_last               (csr_out_int),
     .avmm_clk                   (avmm_clock_dprio_clk),
     .avmm_write                 (pld_avmm1_write_int),
     .avmm_read                  (pld_avmm1_read_int),
     .avmm_request               (pld_avmm1_request_int),
     .avmm_reg_addr              (pld_avmm1_reg_addr),
     .avmm_writedata             (pld_avmm1_writedata),
     .avmm_reserved_in           (pld_avmm1_reserved_in),
     .block_select_master        (block_select),
     .master_pld_avmm_readdata   (readdata),
     .remote_pld_avmm_readdata   (remote_pld_avmm_readdata),
     //.remote_pld_avmm_reserved_out(remote_pld_avmm_reserved_out),
     .interface_sel              (interface_sel),
     .r_avmm_nfhssi_base_addr    (r_avmm_nfhssi_base_addr),
     .r_avmm_adapt_base_addr     (r_avmm_adapt_base_addr),
     .r_avmm_nfhssi_calibration_en    (r_avmm_nfhssi_calibration_en),
     .r_avmm_rd_block_enable     (r_avmm_rd_block_enable),
     .r_avmm_uc_block_enable     (r_avmm_uc_block_enable),
     .remote_pld_avmm_busy       (remote_pld_avmm_busy),
     .remote_pld_avmm_readdatavalid   (remote_pld_avmm_readdatavalid),
     .sr_hssi_avmm1_busy          (sr_hssi_avmm1_busy),
     .int_pld_avmm_cmdfifo_wr_pfull  (int_pld_avmm_cmdfifo_wr_pfull),
     //output
     .pld_avmm1_cmdfifo_wr_pfull_dly (pld_avmm1_cmdfifo_wr_pfull_dly),
     .master_pld_avmm_writedata  (master_pld_avmm_writedata),
     .master_pld_avmm_reg_addr   (master_pld_avmm_reg_addr),
     .master_pld_avmm_write      (master_pld_avmm_write),
     .master_pld_avmm_read       (master_pld_avmm_read),
     .remote_pld_avmm_reserved_in(remote_pld_avmm_reserved_in),
     .remote_pld_avmm_writedata  (remote_pld_avmm_writedata),
     .remote_pld_avmm_reg_addr   (remote_pld_avmm_reg_addr),
     .remote_pld_avmm_write      (remote_pld_avmm_write),
     .remote_pld_avmm_read       (remote_pld_avmm_read),
     .remote_pld_avmm_request    (remote_pld_avmm_request),
     .avmm_readdata              (pld_avmm1_readdata_int),
     .avmm_readdatavalid         (pld_avmm1_readdatavalid_int),
     //.avmm_reserved_out        (pld_avmm1_reserved_out_int),
     .avmm_pld_avmm_busy         (pld_avmm1_busy_int),
     .avmm1_cmn_intf_testbus     (avmm1_cmn_intf_testbus),
     .csr_out                    (csr_out_chnl_n)
);


hdpldadapt_avmm_dprio_reg hdpldadapt_avmm_dprio_reg (
     // input
     .csr_clk                (avmm_clock_csr_clk),   
     .avmm_clk               (avmm_clock_dprio_clk),  
     .scan_mode_n            (adapter_scan_mode_n),
     .scan_shift_n           (adapter_scan_shift_n),
     .csr_in_ds              (csr_in_chnl),
     .scan_in                (adapter_config_scan_in), 
     .csr_en                 (csr_rdy_in),
     .avmm_rst_n             (avmm_reset_avmm_rst_n),
     .write                  (master_pld_avmm_write),
     .read                   (master_pld_avmm_read),
     .reg_addr               (master_pld_avmm_reg_addr),
     .writedata              (master_pld_avmm_writedata),
     .csr_test_mode          (csr_test_mode),
     .mdio_dis               (interface_sel),
     .user_datain            (dprio_status),
     .write_en_ack           (dprio_status_write_en_ack),
     // Output
     .csr_out                (csr_out_int),
     .scan_out               (adapter_config_scan_out),
     .readdata               (readdata),
     .block_select           (block_select),
     .user_dataout           (user_dataout),
     .write_en               (dprio_status_write_en),
     .extra_csr_out          (extra_csr_out)
);

hdpldadapt_avmm1_dprio_mapping hdpldadapt_avmm1_dprio_mapping (
      // input
      .avmm_csr_ctrl     (avmm_csr_ctrl),
      .avmm1_csr_ctrl    (avmm1_csr_ctrl),
      .avmm2_csr_ctrl    (avmm2_csr_ctrl),
      .aib_csr_ctrl      (aib_csr_ctrl),
      .avmm_res_csr_ctrl (avmm_res_csr_ctrl),
      .tx_chnl_dprio_ctrl(tx_chnl_dprio_ctrl),
      .rx_chnl_dprio_ctrl(rx_chnl_dprio_ctrl),
      .sr_dprio_ctrl     (sr_dprio_ctrl),
      .avmm1_dprio_ctrl  (avmm1_dprio_ctrl),
      .avmm2_dprio_ctrl  (avmm2_dprio_ctrl),
      .aib_dprio_ctrl    (aib_dprio_ctrl),
                                                               
      // new ouputs for ECO8
      .r_tx_wren_fastbond (r_tx_wren_fastbond),
      .r_tx_rden_fastbond (r_tx_rden_fastbond),                                
      .r_rx_wren_fastbond (r_rx_wren_fastbond),
      .r_rx_rden_fastbond (r_rx_rden_fastbond),
                                                               
      // output
      .r_tx_fifo_empty                                   (r_tx_fifo_empty),
      .r_tx_fifo_mode                                    (r_tx_fifo_mode),
      .r_tx_fifo_full                                    (r_tx_fifo_full),
      .r_tx_phcomp_rd_delay                              (r_tx_phcomp_rd_delay),
      .r_tx_fifo_pempty                                  (r_tx_fifo_pempty),
      .r_tx_indv                                         (r_tx_indv),
      .r_tx_stop_read                                    (r_tx_stop_read),
      .r_tx_stop_write                                   (r_tx_stop_write),
      .r_tx_fifo_pfull                                   (r_tx_fifo_pfull),
      .r_tx_double_write                                 (r_tx_double_write),
      //.r_tx_chnl_datapath_fifo_3_res_6_2                 (r_tx_chnl_datapath_fifo_3_res_6_2),
      .r_tx_comp_cnt                                     (r_tx_comp_cnt),
      .r_tx_us_master                                    (r_tx_us_master),
      .r_tx_ds_master                                    (r_tx_ds_master),
      .r_tx_us_bypass_pipeln                             (r_tx_us_bypass_pipeln),
      .r_tx_ds_bypass_pipeln                             (r_tx_ds_bypass_pipeln),
      .r_tx_compin_sel                                   (r_tx_compin_sel),
      .r_tx_bonding_dft_in_en                            (r_tx_bonding_dft_in_en),
      .r_tx_bonding_dft_in_value                         (r_tx_bonding_dft_in_value),
      .r_tx_dv_indv                                      (r_tx_dv_indv),
      .r_tx_gb_idwidth                                   (r_tx_gb_idwidth),
      .r_tx_gb_odwidth                                   (r_tx_gb_odwidth),
      .r_tx_gb_dv_en                                     (r_tx_gb_dv_en),
      //.r_tx_chnl_datapath_dv_en_0_res_7_1                (r_tx_chnl_datapath_dv_en_0_res_7_1),
      .r_tx_mfrm_length                                  (r_tx_mfrm_length),
      .r_tx_bypass_frmgen                                (r_tx_bypass_frmgen),
      .r_tx_pipeln_frmgen                                (r_tx_pipeln_frmgen),
      .r_tx_pyld_ins                                     (r_tx_pyld_ins),
      .r_tx_sh_err                                       (r_tx_sh_err),
      .r_tx_burst_en                                     (r_tx_burst_en),
      .r_tx_wm_en                                        (r_tx_wm_en),
      .r_tx_wordslip                                     (r_tx_wordslip),
      .r_tx_fifo_power_mode				 (r_tx_fifo_power_mode),
      .r_tx_stretch_num_stages				 (r_tx_stretch_num_stages), 	
      .r_tx_datapath_tb_sel 				 (r_tx_datapath_tb_sel), 
      .r_tx_wr_adj_en 					 (r_tx_wr_adj_en), 
      .r_tx_rd_adj_en					 (r_tx_rd_adj_en),
      .r_tx_hip_aib_ssr_in_polling_bypass                (r_tx_hip_aib_ssr_in_polling_bypass),
      .r_tx_pld_8g_tx_boundary_sel_polling_bypass        (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
      .r_tx_pld_10g_tx_bitslip_polling_bypass            (r_tx_pld_10g_tx_bitslip_polling_bypass),
      .r_tx_pld_pma_fpll_cnt_sel_polling_bypass          (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
      .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
      //.r_tx_chnl_datapath_frm_gen_async_res_7_1          (r_tx_chnl_datapath_frm_gen_async_res_7_1),
      .r_tx_async_pld_txelecidle_rst_val                 (r_tx_async_pld_txelecidle_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit0_rst_val            (r_tx_async_hip_aib_fsr_in_bit0_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit1_rst_val            (r_tx_async_hip_aib_fsr_in_bit1_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit2_rst_val            (r_tx_async_hip_aib_fsr_in_bit2_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit3_rst_val            (r_tx_async_hip_aib_fsr_in_bit3_rst_val),
      .r_tx_async_pld_pmaif_mask_tx_pll_rst_val          (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit0_rst_val           (r_tx_async_hip_aib_fsr_out_bit0_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit1_rst_val           (r_tx_async_hip_aib_fsr_out_bit1_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit2_rst_val           (r_tx_async_hip_aib_fsr_out_bit2_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit3_rst_val           (r_tx_async_hip_aib_fsr_out_bit3_rst_val),
      //.r_tx_chnl_datapath_async_reserved_11_2            (r_tx_chnl_datapath_async_reserved_11_2),
      //.r_tx_chnl_datapath_async_3_clk0                   (r_tx_chnl_datapath_async_3_clk0),
      .r_tx_fpll_shared_direct_async_in_sel              (r_tx_fpll_shared_direct_async_in_sel),
      .r_tx_aib_clk1_sel                                 (r_tx_aib_clk1_sel),
      .r_tx_aib_clk2_sel                                 (r_tx_aib_clk2_sel),
      .r_tx_fifo_rd_clk_sel                              (r_tx_fifo_rd_clk_sel),
      //.r_tx_fifo_wr_clk_sel                              (r_tx_fifo_wr_clk_sel),
      .r_tx_pld_clk1_sel                                 (r_tx_pld_clk1_sel),
      .r_tx_pld_clk1_delay_en                            (r_tx_pld_clk1_delay_en),
      .r_tx_pld_clk1_delay_sel                           (r_tx_pld_clk1_delay_sel[3:0]),
      .r_tx_pld_clk1_inv_en                            (r_tx_pld_clk1_inv_en),
      .r_tx_pld_clk2_sel                                 (r_tx_pld_clk2_sel),
      .r_tx_fifo_rd_clk_frm_gen_scg_en                   (r_tx_fifo_rd_clk_frm_gen_scg_en),
      .r_tx_fifo_rd_clk_scg_en                           (r_tx_fifo_rd_clk_scg_en),
      .r_tx_fifo_wr_clk_scg_en                           (r_tx_fifo_wr_clk_scg_en),
      .r_tx_osc_clk_scg_en                            (r_tx_osc_clk_scg_en),		
      .r_tx_hrdrst_rx_osc_clk_scg_en                     (r_tx_hrdrst_rx_osc_clk_scg_en),
      .r_tx_hip_osc_clk_scg_en                     (r_tx_hip_osc_clk_scg_en),
      .r_tx_hrdrst_rst_sm_dis                            (r_tx_hrdrst_rst_sm_dis),
      .r_tx_hrdrst_dcd_cal_done_bypass                   (r_tx_hrdrst_dcd_cal_done_bypass),
      .r_tx_hrdrst_user_ctl_en                           (r_tx_hrdrst_user_ctl_en),
      //.r_tx_chnl_datapath_clk_1_res_7                    (r_tx_chnl_datapath_clk_1_res_7),
      //.r_tx_chnl_datapath_res_1                          (r_tx_chnl_datapath_res_1),
      //.r_tx_chnl_datapath_res_2                          (r_tx_chnl_datapath_res_2),
      .r_rx_fifo_empty                                   (r_rx_fifo_empty),
      .r_rx_pld_8g_eidleinfersel_polling_bypass (r_rx_pld_8g_eidleinfersel_polling_bypass),
      .r_rx_pld_pma_eye_monitor_polling_bypass  (r_rx_pld_pma_eye_monitor_polling_bypass),
      .r_rx_pld_pma_pcie_switch_polling_bypass  (r_rx_pld_pma_pcie_switch_polling_bypass),
      .r_rx_pld_pma_reser_out_polling_bypass (r_rx_pld_pma_reser_out_polling_bypass),
      //.r_rx_chnl_datapath_fifo_0_res_6_2                 (r_rx_chnl_datapath_fifo_0_res_6_2),
      .r_rx_fifo_full                                    (r_rx_fifo_full),
      .r_rx_double_read                                  (r_rx_double_read),
      .r_rx_gb_dv_en                                     (r_rx_gb_dv_en),
      .r_rx_fifo_pempty                                  (r_rx_fifo_pempty),
      .r_rx_stop_read                                    (r_rx_stop_read),
      .r_rx_stop_write                                   (r_rx_stop_write),
      .r_rx_fifo_pfull                                   (r_rx_fifo_pfull),
      .r_rx_indv                                         (r_rx_indv),
      .r_rx_truebac2bac                                  (r_rx_truebac2bac),
      .r_rx_fifo_mode                                    (r_rx_fifo_mode),
      .r_rx_phcomp_rd_delay                              (r_rx_phcomp_rd_delay),
      //.r_rx_chnl_datapath_fifo_4_res_6_2                 (r_rx_chnl_datapath_fifo_4_res_6_2),
      .r_rx_comp_cnt                                     (r_rx_comp_cnt),
      .r_rx_us_master                                    (r_rx_us_master),
      .r_rx_ds_master                                    (r_rx_ds_master),
      .r_rx_us_bypass_pipeln                             (r_rx_us_bypass_pipeln),
      .r_rx_ds_bypass_pipeln                             (r_rx_ds_bypass_pipeln),
      .r_rx_compin_sel                                   (r_rx_compin_sel),
      .r_rx_bonding_dft_in_en                            (r_rx_bonding_dft_in_en),
      .r_rx_bonding_dft_in_value                         (r_rx_bonding_dft_in_value),
      .r_rx_wa_en                                        (r_rx_wa_en),
      .r_rx_write_ctrl                                   (r_rx_write_ctrl),
      .r_rx_fifo_power_mode				 (r_rx_fifo_power_mode),
      .r_rx_stretch_num_stages				 (r_rx_stretch_num_stages), 	
      .r_rx_datapath_tb_sel 				 (r_rx_datapath_tb_sel), 
      .r_rx_wr_adj_en 					 (r_rx_wr_adj_en), 
      .r_rx_rd_adj_en					 (r_rx_rd_adj_en),
      .r_rx_pipe_en					 (r_rx_pipe_en),
      .r_rx_lpbk_en					 (r_rx_lpbk_en),
      //.r_rx_chnl_datapath_wa_0_res_1_7                   (r_rx_chnl_datapath_wa_0_res_1_7),
      //.r_rx_chnl_datapath_wa_1_ins_0_asn_0               (r_rx_chnl_datapath_wa_1_ins_0_asn_0),
      .r_rx_asn_en                                       (r_rx_asn_en),
      .r_rx_asn_bypass_pma_pcie_sw_done                  (r_rx_asn_bypass_pma_pcie_sw_done),
//      .r_tx_hrdrst_master_sel                            (r_tx_hrdrst_master_sel),
//      .r_tx_hrdrst_dist_master_sel                       (r_tx_hrdrst_dist_master_sel),
      .r_tx_ds_last_chnl                          (r_tx_ds_last_chnl),
      .r_tx_us_last_chnl                          (r_tx_us_last_chnl),
      .r_tx_usertest_sel                          (r_tx_usertest_sel),
      .r_rx_usertest_sel                          (r_rx_usertest_sel),
      .r_rx_asn_wait_for_fifo_flush_cnt                  (r_rx_asn_wait_for_fifo_flush_cnt),
      .r_rx_asn_wait_for_dll_reset_cnt                   (r_rx_asn_wait_for_dll_reset_cnt),
      .r_rx_asn_wait_for_pma_pcie_sw_done_cnt            (r_rx_asn_wait_for_pma_pcie_sw_done_cnt),

//      .r_rx_asn_master_sel                               (r_rx_asn_master_sel),
//      .r_rx_asn_dist_master_sel                          (r_rx_asn_dist_master_sel),
      //.r_rx_asn_bonding_dft_in_en                        (r_rx_asn_bonding_dft_in_en),
      //.r_rx_asn_bonding_dft_in_value                     (r_rx_asn_bonding_dft_in_value),
      //.r_rx_chnl_datapath_asn_5_async_0                  (r_rx_chnl_datapath_asn_5_async_0),
      .r_rx_async_pld_ltr_rst_val                        (r_rx_async_pld_ltr_rst_val),
      .r_rx_async_pld_pma_ltd_b_rst_val                  (r_rx_async_pld_pma_ltd_b_rst_val),
      .r_rx_async_pld_8g_signal_detect_out_rst_val       (r_rx_async_pld_8g_signal_detect_out_rst_val),
      .r_rx_async_pld_10g_rx_crc32_err_rst_val           (r_rx_async_pld_10g_rx_crc32_err_rst_val),
      .r_rx_async_pld_rx_fifo_align_clr_rst_val          (r_rx_async_pld_rx_fifo_align_clr_rst_val),
      .r_rx_async_prbs_flags_sr_enable                   (r_rx_async_prbs_flags_sr_enable),
      .r_rx_hrdrst_rx_osc_clk_scg_en                     (r_rx_hrdrst_rx_osc_clk_scg_en),
      .r_rx_free_run_div_clk                             (r_rx_free_run_div_clk),
      .r_rx_hrdrst_rst_sm_dis                            (r_rx_hrdrst_rst_sm_dis),
      .r_rx_hrdrst_dll_lock_bypass                       (r_rx_hrdrst_dll_lock_bypass),
      .r_rx_hrdrst_align_bypass                          (r_rx_hrdrst_align_bypass),
      .r_rx_hrdrst_user_ctl_en                           (r_rx_hrdrst_user_ctl_en),
//      .r_rx_hrdrst_master_sel                            (r_rx_hrdrst_master_sel[1:0]),
//      .r_rx_hrdrst_dist_master_sel			 (r_rx_hrdrst_dist_master_sel),
      .r_rx_ds_last_chnl                          (r_rx_ds_last_chnl),
      .r_rx_us_last_chnl                          (r_rx_us_last_chnl),
      //.r_rx_chnl_datapath_async_reserved_2_4             (r_rx_chnl_datapath_async_reserved_2_4),
      //.r_rx_chnl_datapath_async_2                        (r_rx_chnl_datapath_async_2),
      //.r_rx_chnl_datapath_async_3_clk_0                  (r_rx_chnl_datapath_async_3_clk_0),
      .r_rx_aib_clk1_sel                                 (r_rx_aib_clk1_sel),
      .r_rx_aib_clk2_sel                                 (r_rx_aib_clk2_sel),
      .r_rx_fifo_wr_clk_sel                              (r_rx_fifo_wr_clk_sel),
      .r_rx_fifo_rd_clk_sel                              (r_rx_fifo_rd_clk_sel),
      .r_rx_pld_clk1_sel                                 (r_rx_pld_clk1_sel),
      .r_rx_pld_clk1_delay_en                            (r_rx_pld_clk1_delay_en),
      .r_rx_pld_clk1_delay_sel                           (r_rx_pld_clk1_delay_sel[3:0]),
      .r_rx_pld_clk1_inv_en                              (r_rx_pld_clk1_inv_en),
      //.r_rx_pld_clk2_sel                                 (r_rx_pld_clk2_sel),
      .r_rx_sclk_sel                                     (r_rx_sclk_sel),
      .r_rx_fifo_wr_clk_scg_en                           (r_rx_fifo_wr_clk_scg_en),
      .r_rx_fifo_rd_clk_scg_en                           (r_rx_fifo_rd_clk_scg_en),
      .r_rx_pma_hclk_scg_en                              (r_rx_pma_hclk_scg_en),
      .r_rx_osc_clk_scg_en                            (r_rx_osc_clk_scg_en),	
      .r_rx_fifo_wr_clk_del_sm_scg_en(r_rx_fifo_wr_clk_del_sm_scg_en),
      .r_rx_fifo_rd_clk_ins_sm_scg_en(r_rx_fifo_rd_clk_ins_sm_scg_en),
      //.r_rx_coreclkin_sel                                (r_rx_coreclkin_sel),
	.r_rx_internal_clk1_sel1(r_rx_internal_clk1_sel1),
	.r_rx_internal_clk1_sel2(r_rx_internal_clk1_sel2),
	.r_rx_txfiford_post_ct_sel(r_rx_txfiford_post_ct_sel),
	.r_rx_txfifowr_post_ct_sel(r_rx_txfifowr_post_ct_sel),
	.r_rx_internal_clk2_sel1(r_rx_internal_clk2_sel1),
	.r_rx_internal_clk2_sel2(r_rx_internal_clk2_sel2),
	.r_rx_rxfifowr_post_ct_sel(r_rx_rxfifowr_post_ct_sel),
	.r_rx_rxfiford_post_ct_sel(r_rx_rxfiford_post_ct_sel),
      //.r_rx_chnl_datapath_clk_2_res_1_7                  (r_rx_chnl_datapath_clk_2_res_1_7),
      //.r_rx_chnl_datapath_res_1                          (r_rx_chnl_datapath_res_1),
      .r_sr_hip_en                                       (r_sr_hip_en),
      //.r_sr_pld_txelecidle_rst_val                       (r_sr_pld_txelecidle_rst_val),
      //.r_sr_pld_ltr_rst_val                              (r_sr_pld_ltr_rst_val),
      //.r_sr_pld_pma_ltd_b_rst_val                        (r_sr_pld_pma_ltd_b_rst_val),
      //.r_sr_hip_fsr_in_bit0_rst_val                      (r_sr_hip_fsr_in_bit0_rst_val),
      //.r_sr_hip_fsr_in_bit1_rst_val                      (r_sr_hip_fsr_in_bit1_rst_val),
      //.r_sr_hip_fsr_in_bit2_rst_val                      (r_sr_hip_fsr_in_bit2_rst_val),
      //.r_sr_hip_fsr_in_bit3_rst_val                      (r_sr_hip_fsr_in_bit3_rst_val),
      //.r_sr_pld_pmaif_mask_tx_pll_rst_val                (r_sr_pld_pmaif_mask_tx_pll_rst_val),
      //.r_sr_pld_8g_signal_detect_out_rst_val             (r_sr_pld_8g_signal_detect_out_rst_val),
      //.r_sr_pld_10g_rx_crc32_err_rst_val                 (r_sr_pld_10g_rx_crc32_err_rst_val),
      //.r_sr_hip_fsr_out_bit0_rst_val                     (r_sr_hip_fsr_out_bit0_rst_val),
      //.r_sr_hip_fsr_out_bit1_rst_val                     (r_sr_hip_fsr_out_bit1_rst_val),
      //.r_sr_hip_fsr_out_bit2_rst_val                     (r_sr_hip_fsr_out_bit2_rst_val),
      //.r_sr_hip_fsr_out_bit3_rst_val                     (r_sr_hip_fsr_out_bit3_rst_val),
      //.r_sr_pld_rx_fifo_align_clr_rst_val                (r_sr_pld_rx_fifo_align_clr_rst_val),
      .r_sr_osc_clk_scg_en                               (r_sr_osc_clk_scg_en),		
      .r_sr_reserbits_in_en                               (r_sr_reserbits_in_en),
      .r_sr_reserbits_out_en                              (r_sr_reserbits_out_en),
      .r_sr_testbus_sel                                  (r_sr_testbus_sel),
      .r_sr_parity_en                                    (r_sr_parity_en),
      //.r_sr_clk_0_res_2_7                                (r_sr_clk_0_res_2_7),
//      .r_avmm1_arbiter_ctrl_0                            (r_avmm1_arbiter_ctrl_0),
//      .r_avmm2_arbiter_ctrl_0                            (r_avmm2_arbiter_ctrl_0),
      .r_aib_dprio_ctrl_0                                (r_aib_dprio_ctrl_0),
      .r_aib_dprio_ctrl_1                                (r_aib_dprio_ctrl_1),
      .r_aib_dprio_ctrl_2                                (r_aib_dprio_ctrl_2),
      .r_aib_dprio_ctrl_3                                (r_aib_dprio_ctrl_3),
      .r_aib_dprio_ctrl_4                                (r_aib_dprio_ctrl_4),
      .r_avmm_hrdrst_osc_clk_scg_en                      (r_avmm_hrdrst_osc_clk_scg_en),
      .r_avmm_adapt_base_addr                            (r_avmm_adapt_base_addr),
      .r_avmm_rd_block_enable                            (r_avmm_rd_block_enable),
      .r_avmm_uc_block_enable                            (r_avmm_uc_block_enable),
      .r_avmm_testbus_sel                                (r_avmm_testbus_sel),
      //.r_avmm_general_reserved_1_2                       (r_avmm_general_reserved_1_2),
      .r_avmm_nfhssi_calibration_en                      (r_avmm_nfhssi_calibration_en),
      //.r_avmm_general_reserved_1_4                       (r_avmm_general_reserved_1_4),
      .r_avmm_force_inter_sel_csr_ctrl                   (r_avmm_force_inter_sel_csr_ctrl),
      .r_avmm_dprio_broadcast_en_csr_ctrl                (r_avmm_dprio_broadcast_en_csr_ctrl),
      //.r_avmm_general_reserved_1_7                       (r_avmm_general_reserved_1_7),
      .r_avmm_nfhssi_base_addr                           (r_avmm_nfhssi_base_addr),
      //.r_avmm_general_reserved_4_1                       (r_avmm_general_reserved_4_1),
      //.r_avmm_reset_0                                    (r_avmm_reset_0),
      //.r_avmm1_avmm_clk_sel                              (r_avmm1_avmm_clk_sel),
      .r_avmm1_osc_clk_scg_en                         (r_avmm1_osc_clk_scg_en),	
      .r_avmm1_avmm_clk_scg_en                           (r_avmm1_avmm_clk_scg_en),
      //.r_avmm1_clk_reserved_4_7                          (r_avmm1_clk_reserved_4_7),
      .r_avmm1_cmdfifo_full                              (r_avmm1_cmdfifo_full),
      .r_avmm1_cmdfifo_stop_read                         (r_avmm1_cmdfifo_stop_read),
      .r_avmm1_cmdfifo_stop_write                        (r_avmm1_cmdfifo_stop_write),
      .r_avmm1_cmdfifo_empty                             (r_avmm1_cmdfifo_empty),
      //.r_avmm1_cmdfifo_1_res_6_7                         (r_avmm1_cmdfifo_1_res_6_7),
      .r_avmm1_cmdfifo_pfull                             (r_avmm1_cmdfifo_pfull),
      //.r_avmm1_cmdfifo_2_res_6_7                         (r_avmm1_cmdfifo_2_res_6_7),
      //.r_avmm1_cmdfifo_3_res_0_7                         (r_avmm1_cmdfifo_3_res_0_7),
      .r_avmm1_rdfifo_full                               (r_avmm1_rdfifo_full),
      .r_avmm1_rdfifo_stop_read                          (r_avmm1_rdfifo_stop_read),
      .r_avmm1_rdfifo_stop_write                         (r_avmm1_rdfifo_stop_write),
      .r_avmm1_rdfifo_empty                              (r_avmm1_rdfifo_empty),
      .r_avmm1_gate_dis                                  (r_avmm1_gate_dis),
      //.r_avmm1_rdfifo_1_res_6_7                          (r_avmm1_rdfifo_1_res_6_7),
      //.r_avmm2_avmm_clk_sel                              (r_avmm2_avmm_clk_sel),
      .r_avmm2_osc_clk_scg_en                         (r_avmm2_osc_clk_scg_en),	
      .r_avmm2_avmm_clk_scg_en                           (r_avmm2_avmm_clk_scg_en),
      //.r_avmm2_clk_reserved_4_7                          (r_avmm2_clk_reserved_4_7),
      .r_avmm2_cmdfifo_full                              (r_avmm2_cmdfifo_full),
      .r_avmm2_cmdfifo_stop_read                         (r_avmm2_cmdfifo_stop_read),
      .r_avmm2_cmdfifo_stop_write                        (r_avmm2_cmdfifo_stop_write),
      .r_avmm2_cmdfifo_empty                             (r_avmm2_cmdfifo_empty),
      //.r_avmm2_cmdfifo_1_res_6_7                         (r_avmm2_cmdfifo_1_res_6_7),
      .r_avmm2_cmdfifo_pfull                             (r_avmm2_cmdfifo_pfull),
      //.r_avmm2_cmdfifo_2_res_6_7                         (r_avmm2_cmdfifo_2_res_6_7),
      //.r_avmm2_cmdfifo_3_res_0_7                         (r_avmm2_cmdfifo_3_res_0_7),
      .r_avmm2_rdfifo_full                               (r_avmm2_rdfifo_full),
      .r_avmm2_rdfifo_stop_read                          (r_avmm2_rdfifo_stop_read),
      .r_avmm2_rdfifo_stop_write                         (r_avmm2_rdfifo_stop_write),
      .r_avmm2_rdfifo_empty                              (r_avmm2_rdfifo_empty),
      .r_avmm2_hip_sel                                   (r_avmm2_hip_sel),
      .r_avmm2_gate_dis                                  (r_avmm2_gate_dis),
      //.r_avmm2_rdfifo_1_res_6_7                          (r_avmm2_rdfifo_1_res_6_7),
      .r_aib_csr_ctrl_0                                  (r_aib_csr_ctrl_0),
      .r_aib_csr_ctrl_1                                  (r_aib_csr_ctrl_1),
      .r_aib_csr_ctrl_2                                  (r_aib_csr_ctrl_2),
      .r_aib_csr_ctrl_3                                  (r_aib_csr_ctrl_3),
      .r_aib_csr_ctrl_4                                  (r_aib_csr_ctrl_4),
      .r_aib_csr_ctrl_5                                  (r_aib_csr_ctrl_5),
      .r_aib_csr_ctrl_6                                  (r_aib_csr_ctrl_6),
      .r_aib_csr_ctrl_7                                  (r_aib_csr_ctrl_7),
      .r_aib_csr_ctrl_8                                  (r_aib_csr_ctrl_8),
      .r_aib_csr_ctrl_9                                  (r_aib_csr_ctrl_9),
      .r_aib_csr_ctrl_10                                 (r_aib_csr_ctrl_10),
      .r_aib_csr_ctrl_11                                 (r_aib_csr_ctrl_11),
      .r_aib_csr_ctrl_12                                 (r_aib_csr_ctrl_12),
      .r_aib_csr_ctrl_13                                 (r_aib_csr_ctrl_13),
      .r_aib_csr_ctrl_14                                 (r_aib_csr_ctrl_14),
      .r_aib_csr_ctrl_15                                 (r_aib_csr_ctrl_15),
      .r_aib_csr_ctrl_16                                 (r_aib_csr_ctrl_16),
      .r_aib_csr_ctrl_17                                 (r_aib_csr_ctrl_17),
      .r_aib_csr_ctrl_18                                 (r_aib_csr_ctrl_18),
      .r_aib_csr_ctrl_19                                 (r_aib_csr_ctrl_19),
      .r_aib_csr_ctrl_20                                 (r_aib_csr_ctrl_20),
      .r_aib_csr_ctrl_21                                 (r_aib_csr_ctrl_21),
      .r_aib_csr_ctrl_22                                 (r_aib_csr_ctrl_22),
      .r_aib_csr_ctrl_23                                 (r_aib_csr_ctrl_23),
      .r_aib_csr_ctrl_24                                 (r_aib_csr_ctrl_24),
      .r_aib_csr_ctrl_25                                 (r_aib_csr_ctrl_25),
      .r_aib_csr_ctrl_26                                 (r_aib_csr_ctrl_26),
      .r_aib_csr_ctrl_27                                 (r_aib_csr_ctrl_27),
      .r_aib_csr_ctrl_28                                 (r_aib_csr_ctrl_28),
      .r_aib_csr_ctrl_29                                 (r_aib_csr_ctrl_29),
      .r_aib_csr_ctrl_30                                 (r_aib_csr_ctrl_30),
      .r_aib_csr_ctrl_31                                 (r_aib_csr_ctrl_31),
      .r_aib_csr_ctrl_32                                 (r_aib_csr_ctrl_32),
      .r_aib_csr_ctrl_33                                 (r_aib_csr_ctrl_33),
      .r_aib_csr_ctrl_34                                 (r_aib_csr_ctrl_34),
      .r_aib_csr_ctrl_35                                 (r_aib_csr_ctrl_35),
      .r_aib_csr_ctrl_36                                 (r_aib_csr_ctrl_36),
      .r_aib_csr_ctrl_37                                 (r_aib_csr_ctrl_37),
      .r_aib_csr_ctrl_38                                 (r_aib_csr_ctrl_38),
      .r_aib_csr_ctrl_39                                 (r_aib_csr_ctrl_39),
      .r_aib_csr_ctrl_40                                 (r_aib_csr_ctrl_40),
      .r_aib_csr_ctrl_41                                 (r_aib_csr_ctrl_41),
      .r_aib_csr_ctrl_42                                 (r_aib_csr_ctrl_42),
      .r_aib_csr_ctrl_43                                 (r_aib_csr_ctrl_43),
      .r_aib_csr_ctrl_44                                 (r_aib_csr_ctrl_44),
      .r_aib_csr_ctrl_45                                 (r_aib_csr_ctrl_45),
      .r_aib_csr_ctrl_46                                 (r_aib_csr_ctrl_46),
      .r_aib_csr_ctrl_47                                 (r_aib_csr_ctrl_47),
      .r_aib_csr_ctrl_48                                 (r_aib_csr_ctrl_48),
      .r_aib_csr_ctrl_49                                 (r_aib_csr_ctrl_49),
      .r_aib_csr_ctrl_50                                 (r_aib_csr_ctrl_50),
      .r_aib_csr_ctrl_51                                 (r_aib_csr_ctrl_51),
      .r_aib_csr_ctrl_52                                 (r_aib_csr_ctrl_52),
      .r_aib_csr_ctrl_53                                 (r_aib_csr_ctrl_53),
      .r_aib_csr_ctrl_54                                 (r_aib_csr_ctrl_54),
      .r_aib_csr_ctrl_55                                 (r_aib_csr_ctrl_55),
      .r_aib_csr_ctrl_56                                 (r_aib_csr_ctrl_56),
      .r_aib_csr_ctrl_57                                 (r_aib_csr_ctrl_57)
);
endmodule
