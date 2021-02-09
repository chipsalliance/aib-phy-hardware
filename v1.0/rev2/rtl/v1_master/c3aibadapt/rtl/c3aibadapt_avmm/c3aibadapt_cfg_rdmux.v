// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cfg_rdmux (
  // Output
  output reg  [31:0]  cfg_avmm_rdata,
  output reg          cfg_avmm_rdatavld,
  output reg          cfg_avmm_waitreq,
  output reg          cfg_avmm_slave_read,
  output reg          cfg_avmm_slave_write,

  // Input
  input  wire         cfg_write,
  input  wire         cfg_read,
  input  wire         cfg_rst_n,
  input  wire         r_ifctl_usr_active,
  input  wire [31:0]  chnl_cfg_rdata,
  input  wire         chnl_cfg_rdatavld,
  input  wire         chnl_cfg_waitreq,
  input  wire [31:0]  cfg_only_rdata,
  input  wire         cfg_only_rdatavld,
  input  wire         cfg_only_waitreq,
  input  wire [31:0]  ehip_cfg_rdata,
  input  wire         ehip_cfg_rdatavld,
  input  wire         ehip_cfg_waitreq,
  input  wire [31:0]  adpt_cfg_rdata,
  input  wire         adpt_cfg_rdatavld,
  input  wire         adpt_cfg_waitreq
);

// In config mode (r_ifctl_usr_active = 0), CRSSM can 
// r_ifctl_usr_active is asserted when User has control of AVMM interface.
// r_ifctl_usr_active affects channel-related signals. CRSSM can only access
// config-only space when r_ifctl_usr_active is asserted.
// In this case, CRSSM can only access Config-only space
always @(*) begin
  cfg_avmm_waitreq  = adpt_cfg_waitreq  & ehip_cfg_waitreq  & (r_ifctl_usr_active ? cfg_only_waitreq  : (cfg_only_waitreq  & chnl_cfg_waitreq));
  cfg_avmm_rdatavld = adpt_cfg_rdatavld | ehip_cfg_rdatavld | (r_ifctl_usr_active ? cfg_only_rdatavld : (cfg_only_rdatavld | chnl_cfg_rdatavld));
  cfg_avmm_rdata    = adpt_cfg_rdata    | ehip_cfg_rdata    | (r_ifctl_usr_active ? cfg_only_rdata    : (cfg_only_rdata    | chnl_cfg_rdata));
end

// Scenario1: 
// Assert: one_hot(chnl_cfg_rdatavld, ehip_cfg_rdatavld, adpt_cfg_rdatavld);

// Scenario2:
// helper1 = (chnl_cfg_rdatavld!='0); helper2 =  (chnl_cfg_rdatavld!='0); helper3 =  (adpt_cfg_rdatavld != '0)
// Assert: one_hot (helper1, helper2, helper3);

always @(*) begin
  cfg_avmm_slave_write = cfg_write;
  cfg_avmm_slave_read  = cfg_read;
end

endmodule
