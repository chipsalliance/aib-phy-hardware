// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3routing_chnl_aib(
// right edge
  input        i_clk,
  input        i_rst_n,
  input [16:0] i_addr,
  input [3:0]  i_byte_en,
  input        i_read,
  input        i_write,
  input [31:0] i_wdata,
  output [31:0]o_rdata,
  output       o_rdatavalid,
  output       o_waitreq,
  input        i_adpt_hard_rst_n,
  input        i_red_idataselb_chain1,
  input        i_red_idataselb_chain2,
  input        i_red_shift_en_chain1,
  input        i_red_shift_en_chain2,
  input        i_txen_chain1,
  input        i_txen_chain2,
  input        i_osc_clk,
  input [12:0] i_aibdftdll2adjch,
  input        i_vccl,
  input        i_vcchssi,

// left edge
  output       o_clk,
  output       o_rst_n,
  output [16:0]o_addr,
  output [3:0] o_byte_en,
  output       o_read,
  output       o_write,
  output [31:0]o_wdata,
  input [31:0] i_rdata,
  input        i_rdatavalid,
  input        i_waitreq,
  output       o_adpt_hard_rst_n,
  output       o_red_idataselb_chain1,
  output       o_red_idataselb_chain2,
  output       o_red_shift_en_chain1,
  output       o_red_shift_en_chain2,
  output       o_txen_chain1,
  output       o_txen_chain2,
  output       o_osc_clk,
  output [12:0]o_aibdftdll2adjch,
  output       o_vccl,
  output       o_vcchssi,
  input        i_jtag_last_bs_chain_in,
  output       o_jtag_last_bs_chain_out,
  input        i_directout_data_chain1_in,
  output       o_directout_data_chain1_out,
  input        i_directout_data_chain2_in,
  output       o_directout_data_chain2_out,
  input        i_jtag_bs_chain_in,
  output       o_jtag_bs_chain_out,
  input        i_jtag_bs_scanen_in,
  output       o_jtag_bs_scanen_out,
  input        i_jtag_clkdr_in,
  output       o_jtag_clkdr_out,
  input        i_jtag_clksel_in,
  output       o_jtag_clksel_out,
  input        i_jtag_intest_in,
  output       o_jtag_intest_out,
  input        i_jtag_mode_in,
  output       o_jtag_mode_out,
  input        i_jtag_rstb_en_in,
  output       o_jtag_rstb_en_out,
  input        i_jtag_rstb_in,
  output       o_jtag_rstb_out,
  input        i_jtag_weakpdn_in,
  output       o_jtag_weakpdn_out,
  input        i_jtag_weakpu_in,
  output       o_jtag_weakpu_out
);
`ifndef CRETE3_STUB


  assign o_clk        = i_clk;
  assign o_rst_n      = i_rst_n;
  assign o_addr       = i_addr;
  assign o_byte_en    = i_byte_en;
  assign o_read       = i_read;
  assign o_write      = i_write;
  assign o_wdata      = i_wdata;
  assign o_rdata      = i_rdata;
  assign o_rdatavalid = i_rdatavalid;
  assign o_waitreq    = i_waitreq;
  assign o_adpt_hard_rst_n = i_adpt_hard_rst_n;

  assign o_red_idataselb_chain1 = i_red_idataselb_chain1;
  assign o_red_idataselb_chain2 = i_red_idataselb_chain2;
  assign o_txen_chain1 = i_txen_chain1;
  assign o_txen_chain2 = i_txen_chain2;
  assign o_osc_clk = i_osc_clk;
  assign o_aibdftdll2adjch = i_aibdftdll2adjch;
  assign o_red_shift_en_chain1 = i_red_shift_en_chain1;
  assign o_red_shift_en_chain2 = i_red_shift_en_chain2;
  assign o_vccl = i_vccl;
  assign o_vcchssi = i_vcchssi; 

  assign o_jtag_last_bs_chain_out = i_jtag_last_bs_chain_in;
  assign o_directout_data_chain1_out = i_directout_data_chain1_in;
  assign o_directout_data_chain2_out = i_directout_data_chain2_in;
  assign o_jtag_bs_chain_out = i_jtag_bs_chain_in;
  assign o_jtag_bs_scanen_out = i_jtag_bs_scanen_in;
  assign o_jtag_clkdr_out = i_jtag_clkdr_in;
  assign o_jtag_clksel_out = i_jtag_clksel_in;
  assign o_jtag_intest_out = i_jtag_intest_in;
  assign o_jtag_mode_out = i_jtag_mode_in;
  assign o_jtag_rstb_en_out = i_jtag_rstb_en_in;
  assign o_jtag_rstb_out = i_jtag_rstb_in;
  assign o_jtag_weakpdn_out = i_jtag_weakpdn_in;
  assign o_jtag_weakpu_out = i_jtag_weakpu_in;

`endif
endmodule
