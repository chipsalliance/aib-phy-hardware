// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_pa_phs_buf :   buffer for phy_clk_phs
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_pa_phs_buf (
input          reset_n,          	// Active low reset
input          nfrzdrv,          	// Active low reset
input    [7:0] phy_clk_phs,      	// 8 phase 1.6GHz local clock
input          test_enable,      	// Active high test enable    1: avoid tristate on output of interp_mux during testing
input    [2:0] phx_sel_master_0,        // The gray code to control the first of the 8 to 1 phase multiplexer
input    [2:0] phx_sel_master_1,        // The gray code to control the first of the 8 to 1 phase multiplexer
input    [1:0] periphery_clk_x,         // periphery_clk from io_interpolator
input    [1:0] core_clk_x,              // core_clk from io_interpolator
output   [1:0] periphery_clk_out,       // Clock feedback to the periphery
output   [1:0] core_clk_out,            // Clock feedback to the core
output   [2:0] phx_master_0_buf,        // buffered gray code for interp_mux
output   [2:0] phx_master_1_buf,        // buffered gray code for interp_mux
output   [2:0] phx_master_0_inv,        // Inverted gray code for interp_mux
output   [2:0] phx_master_1_inv,        // Inverted gray code for interp_mux
output   [7:0] slow_clk_ph_p,           // buffered 8 phase 1.6GHz local clock
output   [7:0] slow_clk_ph_n,           // buffered 8 phase 1.6GHz local clock
output         test_enable_n,           // active low test enable
output         dft_mux_sel              // mux control during test
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps

wire           test_rst_p;              // reset control for io_interp_mux
wire           test_rst_n;              // reset control for io_interp_mux
wire           test_enable_buf;         // active high test enable

assign test_enable_n        	= ~test_enable;
assign test_enable_buf      	= ~test_enable_n;
assign dft_mux_sel          	= ~(~phx_master_0_inv[0] & test_enable_buf);
assign test_rst_n           	= test_enable_n & reset_n;
assign test_rst_p           	= ~test_rst_n;
assign #(3 * INV_DELAY) slow_clk_ph_p[7:0] = phy_clk_phs[7:0] | {8{test_rst_p}};
assign #(3 * INV_DELAY) slow_clk_ph_n[7:0] = phy_clk_phs[7:0] & {8{test_rst_n}};
assign phx_master_0_buf   	= phx_sel_master_0[2:0];
assign phx_master_1_buf   	= phx_sel_master_1[2:0];
assign phx_master_0_inv   	= ~phx_sel_master_0[2:0];
assign phx_master_1_inv   	= ~phx_sel_master_1[2:0];
assign core_clk_out[1:0]        = {2{nfrzdrv}} & core_clk_x[1:0];
assign periphery_clk_out[1:0]   = {2{nfrzdrv}} & periphery_clk_x[1:0];

endmodule


