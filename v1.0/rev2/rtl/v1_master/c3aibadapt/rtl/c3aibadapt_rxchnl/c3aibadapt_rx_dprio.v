// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rx_dprio(
// rx_datapath
        output   wire    [15:0]  avmm_rx_datapath_user_datain,
        output   wire            r_10g_mode    ,
        output   wire            r_bonding_dft_in_en,
        output   wire            r_bonding_dft_in_value,
        output   wire    [7:0]   r_comp_cnt,
        output   wire    [1:0]   r_compin_sel,
        output   wire            r_double_write,
        output   wire            r_ds_bypass_pipeln,
        output   wire            r_ds_master,
        output   wire    [3:0]   r_empty,
        output   wire            r_empty_type  ,
        output   wire    [2:0]   r_fifo_mode,
        output   wire    [3:0]   r_full,
        output   wire            r_full_type   ,
        output   wire            r_indv,
        output   wire    [3:0]   r_pempty,
        output   wire            r_pempty_type ,
        output   wire    [3:0]   r_pfull,
        output   wire            r_pfull_type  ,
        output   wire    [2:0]   r_phcomp_rd_delay,
        output   wire            r_stop_read   ,
        output   wire            r_stop_write  ,
        output   wire            r_us_bypass_pipeln,
        output   wire            r_us_master,
        output   wire            r_write_ctrl,
// rx_async
        output   wire    [23:0]  avmm_rx_async_user_datain,
// rxclk_ctrl
        output   wire    [15:0]  rx_user_clk_config
// rxrst_ctrl
);




endmodule
