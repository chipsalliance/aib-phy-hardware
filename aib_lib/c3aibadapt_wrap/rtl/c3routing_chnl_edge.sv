// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module c3routing_chnl_edge(
// right edge
  output [31:0]o_rdata,
  output       o_rdatavalid,
  output       o_waitreq,
  output [12:0]o_aibdftdll2adjch,
  output       o_red_idataselb_chain1,
  output       o_red_idataselb_chain2,
  output       o_txen_chain1,
  output       o_txen_chain2,
  output       o_red_shift_en_out_chain1,
  output       o_red_shift_en_out_chain2,
  input        i_jtag_last_bs_chain_in,
  output       o_jtag_last_bs_chain_out,        
  output       o_directout_data_chain1_out,     
  output       o_directout_data_chain2_out,     
  input        i_jtag_bs_scanen_in,
  input        i_jtag_clkdr_in,                 
  input        i_jtag_clksel_in,                
  input        i_jtag_intest_in,                
  input        i_jtag_mode_in,                  
  input        i_jtag_rstb_en_in,               
  input        i_jtag_rstb_in,                  
  input        i_jtag_weakpdn_in,               
  input        i_jtag_weakpu_in
// left edge
);
`ifndef CRETE3_STUB
//Static tie cells to terminate the AVMM chain
  assign o_rdata      = 32'd0;
  assign o_rdatavalid = 1'b0;
  assign o_waitreq    = 1'b1;
  assign o_aibdftdll2adjch = 13'd0;
  assign o_red_idataselb_chain1 = 1'b0;
  assign o_red_idataselb_chain2 = 1'b0;
  assign o_txen_chain1 = 1'b1;
  assign o_txen_chain2 = 1'b1;
  assign o_red_shift_en_out_chain1 = 1'b0;
  assign o_red_shift_en_out_chain2 = 1'b0;

  assign o_jtag_last_bs_chain_out = i_jtag_last_bs_chain_in;
  assign o_directout_data_chain1_out = '0;
  assign o_directout_data_chain2_out = '0;

`endif

endmodule
