// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm2_config
(
input   wire            avmm_clock_dprio_clk, 
input   wire            avmm_reset_avmm_rst_n,

// From AVMM Transfer 
input   wire            remote_pld_avmm_read,
input   wire    [8:0]   remote_pld_avmm_reg_addr,	
input   wire            remote_pld_avmm_request,
input   wire            remote_pld_avmm_write,
input   wire    [7:0]   remote_pld_avmm_writedata,	

// From NF HSSI
input   wire            pld_avmm2_busy,	
input   wire    [7:0]   pld_avmm2_readdata,

// To AVMM Transfer
output  wire            remote_pld_avmm_busy,
output  wire    [7:0]   remote_pld_avmm_readdata,	
output  wire            remote_pld_avmm_readdatavalid,

// To NF HSSI
output  wire            pld_avmm2_read,	
output  wire    [8:0]   pld_avmm2_reg_addr,	
output  wire            pld_avmm2_request,
output  wire            pld_avmm2_write,
output  wire    [7:0]   pld_avmm2_writedata
);

reg [3:0] avmm2_readdatavalid_int;

// To/From NF HSSI 
assign pld_avmm2_read     = remote_pld_avmm_read;
assign pld_avmm2_reg_addr = remote_pld_avmm_reg_addr;
assign pld_avmm2_request  = remote_pld_avmm_request;
assign pld_avmm2_write    = remote_pld_avmm_write;
assign pld_avmm2_writedata= remote_pld_avmm_writedata;

assign remote_pld_avmm_busy     = pld_avmm2_busy;

// generate readdatavalid based on received read
always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_dprio_clk)
  if (avmm_reset_avmm_rst_n == 1'b0)
    begin
      avmm2_readdatavalid_int <= 4'b0000;
    end
  else
    begin
      avmm2_readdatavalid_int <= {avmm2_readdatavalid_int[2:0],remote_pld_avmm_read};
    end


assign remote_pld_avmm_readdatavalid = !remote_pld_avmm_busy && avmm2_readdatavalid_int[3];
assign remote_pld_avmm_readdata      = pld_avmm2_readdata;
 
endmodule
