// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_avalon_if #(
      parameter AVMM_ADDR_WIDTH=8, // Input Address bus width
      parameter RDL_ADDR_WIDTH =8  // Output Address bus width
   ) (
// Inputs
input   logic        avmm_clk,                   // Avalon interface clock
input   logic        avmm_rst_n,                 // Avalon interface reset
input   logic        i_avmm_write,               // Write control
input   logic        i_avmm_read,                // Read control
input   logic [AVMM_ADDR_WIDTH-1:0] i_avmm_addr, // Address bus input
input   logic [31:0] i_avmm_wdata,               // Write data bus
input   logic [3:0]  i_avmm_byte_en,             // Byte enable
input   logic [31:0] readdata,                   // Read bus from registers
                                                 // register access logic
// Outputs
output  logic [31:0] o_avmm_rdata,         // Read data buus
output  logic        o_avmm_rdatavalid,    // Read data valid indication
output  logic        o_avmm_waitrequest,   // Wait request to master
output  logic        clk,                  // Feedthrough of avmm_clk clock
output  logic        reset,                // avmm_rst_n inverted
output  logic [31:0] writedata,            // Write data for register logic
output  logic        read,                 // read control for register logic
output  logic        write,                // Write control for register logic
output  logic [3:0]  byteenable,           // Byte enable for register logic
output  logic [RDL_ADDR_WIDTH-1:0] address // Address bus for register logic
);

// Access machine states
localparam [255:0] ZEROS          = 256'h0;
localparam SM_IDLE                = 3'h0;
localparam SM_WRITE               = 3'h1;
localparam SM_READ                = 3'h2;
localparam SM_CPL                 = 3'h3;
localparam RDATA_OUT_OF_RANGE_ADDR= 32'h0;

logic [2:0] sm_base;
logic addr_out_of_range;
logic addr_out_of_range_r;

assign o_avmm_waitrequest = ((sm_base==SM_WRITE)||(sm_base==SM_READ))?1'b0:1'b1;
assign o_avmm_rdatavalid  = (sm_base==SM_CPL)?1'b1:1'b0;

// Avalon accesss machine
always @(posedge avmm_clk or negedge avmm_rst_n) 
  begin: p_avmm_register
    if (avmm_rst_n==1'b0) 
      begin
        sm_base             <= SM_IDLE;
        addr_out_of_range_r <= 1'b0;
      end
    else
      begin
        if (o_avmm_waitrequest==1'b0)
          begin
            addr_out_of_range_r <= addr_out_of_range;
          end
        case(sm_base)
          SM_IDLE : sm_base <= (i_avmm_write==1'b1)  ? SM_WRITE:
                               (i_avmm_read == 1'b1) ? SM_READ :
                                                       SM_IDLE;
          SM_WRITE : sm_base <= SM_IDLE;
          SM_READ  : sm_base <= SM_CPL ;
          SM_CPL   : sm_base <= SM_IDLE;
          default  : sm_base <= SM_IDLE;
        endcase
      end
  end // block: p_avmm_register

// Logic to detect out of range access
generate
  if (RDL_ADDR_WIDTH<AVMM_ADDR_WIDTH)
    begin: g_addr
      assign addr_out_of_range = 
           ( i_avmm_addr[AVMM_ADDR_WIDTH-1:RDL_ADDR_WIDTH]==
             ZEROS[AVMM_ADDR_WIDTH-1:RDL_ADDR_WIDTH]         ) ? 1'b0 : 1'b1;
    end
  else
    begin
      assign addr_out_of_range = 1'b0;
    end
endgenerate

assign o_avmm_rdata = (addr_out_of_range_r==1'b0) ?
                       readdata[31:0]             :
                       RDATA_OUT_OF_RANGE_ADDR;

assign write = (addr_out_of_range==1'b0)?i_avmm_write  :1'b0;

assign writedata                   = i_avmm_wdata[31:0];
assign byteenable                  = i_avmm_byte_en[3:0];
assign address[RDL_ADDR_WIDTH-1:0] = i_avmm_addr[RDL_ADDR_WIDTH-1:0];
assign read                        = i_avmm_read;
assign clk                         = avmm_clk;
assign reset                       = ~avmm_rst_n;

endmodule  // aib_avalon_if
