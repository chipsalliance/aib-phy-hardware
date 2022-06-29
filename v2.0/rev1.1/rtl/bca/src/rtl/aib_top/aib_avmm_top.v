// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_avmm_top(
// Avalon interface Inputs
input        i_cfg_avmm_clk,
input        i_cfg_avmm_rst_n,
input [16:0] i_cfg_avmm_addr,
input [ 3:0] i_cfg_avmm_byte_en,
input        i_cfg_avmm_read,
input        i_cfg_avmm_write,
input [31:0] i_cfg_avmm_wdata,
// Scan mode input
input        i_scan_mode,
// ADC0 signals
output [1:0] clkdiv_adc0,
output [2:0] adc0_muxsel,
output       adc0_en,
output       adc0_start,
output       adc0_chopen,
output       adc0_dfx_en,
input  [9:0] adc0_out,
input        adc0_done,
// ADC1 signals
output [1:0] clkdiv_adc1,
output [2:0] adc1_muxsel,
output       adc1_en,
output       adc1_start,
output       adc1_chopen,
output       adc1_dfx_en,
input  [9:0] adc1_out,
input        adc1_done,
// ADC2 signals
output [1:0] clkdiv_adc2,
output [2:0] adc2_muxsel,
output       adc2_en,
output       adc2_start,
output       adc2_chopen,
output       adc2_dfx_en,
input  [9:0] adc2_out,
input        adc2_done,
// ADC3 signals
output [1:0] clkdiv_adc3,
output [2:0] adc3_muxsel,
output       adc3_en,
output       adc3_start,
output       adc3_chopen,
output       adc3_dfx_en,
input  [9:0] adc3_out,
input        adc3_done,
// ADC4 signals
output [1:0] clkdiv_adc4,
output [2:0] adc4_muxsel,
output       adc4_en,
output       adc4_start,
output       adc4_chopen,
output       adc4_dfx_en,
input  [9:0] adc4_out,
input        adc4_done,
// AIBIO PVTMONA CBB
output        pvtmona_en,
output        pvtmona_dfx_en,
output [ 2:0] pvtmona_digview_sel,
output [ 2:0] pvtmona_ref_clkdiv,
output [ 2:0] pvtmona_osc_clkdiv,
output [ 2:0] pvtmona_osc_sel,
output        pvtmona_count_start,
input  [ 9:0] pvtmona_osc_clk_count,
input         pvtmona_count_done,
// AIBIO PVTMONB CBB
output        pvtmonb_en,
output        pvtmonb_dfx_en,
output [ 2:0] pvtmonb_digview_sel,
output [ 2:0] pvtmonb_ref_clkdiv,
output [ 2:0] pvtmonb_osc_clkdiv,
output [ 2:0] pvtmonb_osc_sel,
output        pvtmonb_count_start,
input  [ 9:0] pvtmonb_osc_clk_count,
input         pvtmonb_count_done,
// AIBIO PVTMONC CBB
output        pvtmonc_en,
output        pvtmonc_dfx_en,
output [ 2:0] pvtmonc_digview_sel,
output [ 2:0] pvtmonc_ref_clkdiv,
output [ 2:0] pvtmonc_osc_clkdiv,
output [ 2:0] pvtmonc_osc_sel,
output        pvtmonc_count_start,
input  [ 9:0] pvtmonc_osc_clk_count,
input         pvtmonc_count_done,
// AIBIO PVTMOND CBB
output        pvtmond_en,
output        pvtmond_dfx_en,
output [ 2:0] pvtmond_digview_sel,
output [ 2:0] pvtmond_ref_clkdiv,
output [ 2:0] pvtmond_osc_clkdiv,
output [ 2:0] pvtmond_osc_sel,
output        pvtmond_count_start,
input  [ 9:0] pvtmond_osc_clk_count,
input         pvtmond_count_done,
// AIBIO PVTMONA CBB
output        pvtmone_en,
output        pvtmone_dfx_en,
output [ 2:0] pvtmone_digview_sel,
output [ 2:0] pvtmone_ref_clkdiv,
output [ 2:0] pvtmone_osc_clkdiv,
output [ 2:0] pvtmone_osc_sel,
output        pvtmone_count_start,
input  [ 9:0] pvtmone_osc_clk_count,
input         pvtmone_count_done,
// Auxiliary Channel signals
output [2:0] auxch_rxbuf,
// Avalon outputs
output reg        avmm_rdatavld_top,
output reg [31:0] avmm_rdata_top, 
output reg        avmm_waitreq_top
);

// Address offsets
localparam [7:0] ADC0_ADDR_OFF  = 'h0;  
localparam [7:0] ADC1_ADDR_OFF  = 'h4;  
localparam [7:0] ADC2_ADDR_OFF  = 'h8;  
localparam [7:0] ADC3_ADDR_OFF  = 'hc;  
localparam [7:0] ADC4_ADDR_OFF  = 'h10; 
localparam [7:0] AUXCH_ADDR_OFF = 'h18;

// PVTMON offsets
localparam [7:0] PVTMONA3_ADDR_OFF   = 8'h24;
localparam [7:0] PVTMONA4_ADDR_OFF   = 8'h28;
localparam [7:0] PVTMONB3_ADDR_OFF   = 8'h34;
localparam [7:0] PVTMONB4_ADDR_OFF   = 8'h38;
localparam [7:0] PVTMONC3_ADDR_OFF   = 8'h44;
localparam [7:0] PVTMONC4_ADDR_OFF   = 8'h48;
localparam [7:0] PVTMOND3_ADDR_OFF   = 8'h54;
localparam [7:0] PVTMOND4_ADDR_OFF   = 8'h58;
localparam [7:0] PVTMONE3_ADDR_OFF   = 8'h64;
localparam [7:0] PVTMONE4_ADDR_OFF   = 8'h68;

// Base addresses
localparam [16:0] AIB_BASE_LWR = 17'hc000;
localparam [16:0] AIB_BASE_UPR = 17'hc800;

// Access FSM states
localparam [1:0] AVMM_IDLE  = 2'd0;
localparam [1:0] AVMM_WRITE = 2'd1;
localparam [1:0] AVMM_READ  = 2'd2;
localparam [1:0] AVMM_VLRD  = 2'd3;

wire [31:0] rdata_comb;
wire        top_addr_match;
wire        top_only_write;
wire        top_only_read;
reg  [ 1:0] avmm_fsm_ns;
reg  [ 1:0] avmm_fsm_ff;

//--------------------------
// ADC0 register
//--------------------------
wire        adc0_sel;
wire        adc0_read;
wire        adc0_wbyte_23_16;
wire        adc0_wbyte_31_24;
wire [31:0] adc0_data;
reg         adc0_done_ff;
reg  [ 9:0] adc0_value_ff;
reg  [ 1:0] clkdiv_adc0_ff;
reg  [ 2:0] adc0_muxsel_ff;
reg         adc0_en_ff;
reg         adc0_start_ff;
reg         adc0_chopen_ff;
reg         adc0_dfx_en_ff;

//--------------------------
// ADC1 register
//--------------------------
wire        adc1_sel;
wire        adc1_read;
wire        adc1_wbyte_23_16;
wire        adc1_wbyte_31_24;
wire [31:0] adc1_data;
reg         adc1_done_ff;
reg  [ 9:0] adc1_value_ff;
reg  [ 1:0] clkdiv_adc1_ff;
reg  [ 2:0] adc1_muxsel_ff;
reg         adc1_en_ff;
reg         adc1_start_ff;
reg         adc1_chopen_ff;
reg         adc1_dfx_en_ff;

//--------------------------
// ADC2 register
//--------------------------
wire        adc2_sel;
wire        adc2_read;
wire        adc2_wbyte_23_16;
wire        adc2_wbyte_31_24;
wire [31:0] adc2_data;
reg         adc2_done_ff;
reg  [ 9:0] adc2_value_ff;
reg  [ 1:0] clkdiv_adc2_ff;
reg  [ 2:0] adc2_muxsel_ff;
reg         adc2_en_ff;
reg         adc2_start_ff;
reg         adc2_chopen_ff;
reg         adc2_dfx_en_ff;

//--------------------------
// ADC3 register
//--------------------------
wire        adc3_sel;
wire        adc3_read;
wire        adc3_wbyte_23_16;
wire        adc3_wbyte_31_24;
wire [31:0] adc3_data;
reg         adc3_done_ff;
reg  [ 9:0] adc3_value_ff;
reg  [ 1:0] clkdiv_adc3_ff;
reg  [ 2:0] adc3_muxsel_ff;
reg         adc3_en_ff;
reg         adc3_start_ff;
reg         adc3_chopen_ff;
reg         adc3_dfx_en_ff;

//--------------------------
// ADC4 register
//--------------------------
wire        adc4_sel;
wire        adc4_read;
wire        adc4_wbyte_23_16;
wire        adc4_wbyte_31_24;
wire [31:0] adc4_data;
reg         adc4_done_ff;
reg  [ 9:0] adc4_value_ff;
reg  [ 1:0] clkdiv_adc4_ff;
reg  [ 2:0] adc4_muxsel_ff;
reg         adc4_en_ff;
reg         adc4_start_ff;
reg         adc4_chopen_ff;
reg         adc4_dfx_en_ff;

//--------------------------
// AUXCH register
//--------------------------
wire        auxch_sel;
wire        auxch_read;
wire        auxch_wbyte_7_0;
wire [31:0] auxch_data;
reg  [ 2:0] auxch_rxbuf_cfg_code_ff;

//--------------------------
// PVTMONA3 register
//--------------------------
wire        pvtmona3_sel;
wire        pvtmona3_read;
wire        pvtmona3_wbyte_23_16;
wire        pvtmona3_wbyte_31_24;
wire [31:0] pvtmona3_data;
reg         pvtmona3_en_ff;
reg         pvtmona3_dfx_en_ff;
reg  [ 2:0] pvtmona3_digview_sel_ff;
reg  [ 2:0] pvtmona3_ref_clkdiv_ff;
reg  [ 2:0] pvtmona3_osc_clkdiv_ff;
reg  [ 2:0] pvtmona3_osc_sel_ff;

//--------------------------
// PVTMONA4 register
//--------------------------
wire        pvtmona4_sel;
wire        pvtmona4_read;
wire        pvtmona4_wbyte_23_16;
wire [31:0] pvtmona4_data;
reg         pvtmona4_count_done_ff;
reg         pvtmona4_count_start_ff;
reg  [ 9:0] pvtmona4_osc_clk_count_ff;

//--------------------------
// PVTMONB3 register
//--------------------------
wire        pvtmonb3_sel;
wire        pvtmonb3_read;
wire        pvtmonb3_wbyte_23_16;
wire        pvtmonb3_wbyte_31_24;
wire [31:0] pvtmonb3_data;
reg         pvtmonb3_en_ff;
reg         pvtmonb3_dfx_en_ff;
reg  [ 2:0] pvtmonb3_digview_sel_ff;
reg  [ 2:0] pvtmonb3_ref_clkdiv_ff;
reg  [ 2:0] pvtmonb3_osc_clkdiv_ff;
reg  [ 2:0] pvtmonb3_osc_sel_ff;

//--------------------------
// PVTMONB4 register
//--------------------------
wire        pvtmonb4_sel;
wire        pvtmonb4_read;
wire        pvtmonb4_wbyte_23_16;
wire [31:0] pvtmonb4_data;
reg         pvtmonb4_count_done_ff;
reg         pvtmonb4_count_start_ff;
reg  [ 9:0] pvtmonb4_osc_clk_count_ff;

//--------------------------
// PVTMONC3 register
//--------------------------
wire        pvtmonc3_sel;
wire        pvtmonc3_read;
wire        pvtmonc3_wbyte_23_16;
wire        pvtmonc3_wbyte_31_24;
wire [31:0] pvtmonc3_data;
reg         pvtmonc3_en_ff;
reg         pvtmonc3_dfx_en_ff;
reg  [ 2:0] pvtmonc3_digview_sel_ff;
reg  [ 2:0] pvtmonc3_ref_clkdiv_ff;
reg  [ 2:0] pvtmonc3_osc_clkdiv_ff;
reg  [ 2:0] pvtmonc3_osc_sel_ff;

//--------------------------
// PVTMONC4 register
//--------------------------
wire        pvtmonc4_sel;
wire        pvtmonc4_read;
wire        pvtmonc4_wbyte_23_16;
wire [31:0] pvtmonc4_data;
reg         pvtmonc4_count_done_ff;
reg         pvtmonc4_count_start_ff;
reg  [ 9:0] pvtmonc4_osc_clk_count_ff;

//--------------------------
// PVTMOND3 register
//--------------------------
wire        pvtmond3_sel;
wire        pvtmond3_read;
wire        pvtmond3_wbyte_23_16;
wire        pvtmond3_wbyte_31_24;
wire [31:0] pvtmond3_data;
reg         pvtmond3_en_ff;
reg         pvtmond3_dfx_en_ff;
reg  [ 2:0] pvtmond3_digview_sel_ff;
reg  [ 2:0] pvtmond3_ref_clkdiv_ff;
reg  [ 2:0] pvtmond3_osc_clkdiv_ff;
reg  [ 2:0] pvtmond3_osc_sel_ff;

//--------------------------
// PVTMOND4 register
//--------------------------
wire        pvtmond4_sel;
wire        pvtmond4_read;
wire        pvtmond4_wbyte_23_16;
wire [31:0] pvtmond4_data;
reg         pvtmond4_count_done_ff;
reg         pvtmond4_count_start_ff;
reg  [ 9:0] pvtmond4_osc_clk_count_ff;

//--------------------------
// PVTMONE3 register
//--------------------------
wire        pvtmone3_sel;
wire        pvtmone3_read;
wire        pvtmone3_wbyte_23_16;
wire        pvtmone3_wbyte_31_24;
wire [31:0] pvtmone3_data;
reg         pvtmone3_en_ff;
reg         pvtmone3_dfx_en_ff;
reg  [ 2:0] pvtmone3_digview_sel_ff;
reg  [ 2:0] pvtmone3_ref_clkdiv_ff;
reg  [ 2:0] pvtmone3_osc_clkdiv_ff;
reg  [ 2:0] pvtmone3_osc_sel_ff;

//--------------------------
// PVTMONE4 register
//--------------------------
wire        pvtmone4_sel;
wire        pvtmone4_read;
wire        pvtmone4_wbyte_23_16;
wire [31:0] pvtmone4_data;
reg         pvtmone4_count_done_ff;
reg         pvtmone4_count_start_ff;
reg  [ 9:0] pvtmone4_osc_clk_count_ff;

//------------------------------------------------------------------------------
//                          Address decodification
//------------------------------------------------------------------------------

assign top_addr_match  = (i_cfg_avmm_addr[16:11] >= AIB_BASE_LWR[16:11])& 
                         (i_cfg_avmm_addr[16:11] <  AIB_BASE_UPR[16:11]);

assign top_only_write = top_addr_match & i_cfg_avmm_write;
assign top_only_read  = top_addr_match & i_cfg_avmm_read;

//------------------------------------------------------------------------------
//                          Access FSM
//------------------------------------------------------------------------------

// Access FSM next state and output logic
always @(*)
  begin: avmm_fsm_ns_output_logic
    case(avmm_fsm_ff[1:0])
      AVMM_IDLE:
        begin
          avmm_waitreq_top  = 1'b1;
          avmm_rdatavld_top = 1'b0;
          if(top_only_write)
            begin
              avmm_fsm_ns[1:0] = AVMM_WRITE;
            end
          else if(top_only_read)
            begin
              avmm_fsm_ns[1:0] = AVMM_READ;
            end
          else
            begin
              avmm_fsm_ns[1:0] = AVMM_IDLE;
            end
        end
      AVMM_WRITE:
        begin
          avmm_waitreq_top  = 1'b0;
          avmm_rdatavld_top = 1'b0;
          avmm_fsm_ns[1:0]  = AVMM_IDLE;
        end
      AVMM_READ:
        begin
          avmm_waitreq_top  = 1'b0;
          avmm_rdatavld_top = 1'b0;
          avmm_fsm_ns[1:0]  = AVMM_VLRD;
        end
      AVMM_VLRD:
        begin
          avmm_waitreq_top  = 1'b1;
          avmm_rdatavld_top = 1'b1;
          avmm_fsm_ns[1:0]  = AVMM_IDLE;
        end
    endcase
  end // block: avmm_fsm_ns_output_logic

// AVMM access FSM register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: avmm_fsm_register
    if(!i_cfg_avmm_rst_n)
      avmm_fsm_ff[1:0] <= AVMM_IDLE;
    else
      avmm_fsm_ff[1:0] <= avmm_fsm_ns[1:0];
  end // block: avmm_fsm_register


//------------------------------------------------------------------------------
//                                ADC0 register
//------------------------------------------------------------------------------
assign adc0_sel  = (i_cfg_avmm_addr[7:2] == ADC0_ADDR_OFF[7:2]);
assign adc0_read = adc0_sel & top_only_read;

assign adc0_wbyte_23_16 = top_only_write & adc0_sel & i_cfg_avmm_byte_en[2];
assign adc0_wbyte_31_24 = top_only_write & adc0_sel & i_cfg_avmm_byte_en[3];

// ADC0 conversion data register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc0_value_register
    if(!i_cfg_avmm_rst_n)
      adc0_value_ff[9:0] <= 10'h0;
    else if(adc0_done) // Samples ADC conversion value
      adc0_value_ff[9:0] <= adc0_out[9:0];
  end // block: adc0_value_register

// ADC0 conversion done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc0_done_register
    if(!i_cfg_avmm_rst_n)
      adc0_done_ff <= 1'h0;
    else if(adc0_done) // ADC conversion done
      adc0_done_ff <= 1'h1;
    else if(adc0_start_ff) // ADC done is cleared when ADC conversion starts
      adc0_done_ff <= 1'h0;
  end // block: adc0_done_register

// ADC start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc0_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc0_start_ff <= 1'h0;
      end
    else if(adc0_done)
      begin
        adc0_start_ff  <= 1'h0;
      end
    else if(adc0_wbyte_31_24)
      begin
        adc0_start_ff  <= i_cfg_avmm_wdata[31];
      end
  end // block: adc0_start_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc0_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc0_chopen_ff      <= 1'h0;
        adc0_en_ff          <= 1'h0;
        clkdiv_adc0_ff[1:0] <= 2'h0;
        adc0_muxsel_ff[2:0] <= 3'h0;
        adc0_dfx_en_ff      <= 1'h0;
      end
    else if(adc0_wbyte_23_16)
      begin
        adc0_chopen_ff      <= i_cfg_avmm_wdata[16];
        adc0_en_ff          <= i_cfg_avmm_wdata[17];
        clkdiv_adc0_ff[1:0] <= i_cfg_avmm_wdata[19:18];
        adc0_muxsel_ff[2:0] <= i_cfg_avmm_wdata[22:20];
        adc0_dfx_en_ff      <= i_cfg_avmm_wdata[23];
      end
  end // block: adc0_byte_23_16_register

assign adc0_data[31:0] = { adc0_start_ff,
                           7'h0,
                           adc0_dfx_en_ff,
                           adc0_muxsel_ff[2:0],
                           clkdiv_adc0_ff[1:0],
                           adc0_en_ff,
                           adc0_chopen_ff,
                           adc0_done_ff,
                           5'h0,
                           adc0_value_ff[9:0] };

assign adc0_start       = adc0_start_ff       & ~i_scan_mode;
assign adc0_dfx_en      = adc0_dfx_en_ff      & ~i_scan_mode;
assign adc0_muxsel[2:0] = adc0_muxsel_ff[2:0] & {3{(~i_scan_mode)}};
assign clkdiv_adc0[1:0] = clkdiv_adc0_ff[1:0] & {2{(~i_scan_mode)}};
assign adc0_en          = adc0_en_ff          & ~i_scan_mode;
assign adc0_chopen      = adc0_chopen_ff      & ~i_scan_mode;

//------------------------------------------------------------------------------
//                                ADC1 register
//------------------------------------------------------------------------------
assign adc1_sel  = (i_cfg_avmm_addr[7:2] == ADC1_ADDR_OFF[7:2]);
assign adc1_read = adc1_sel & top_only_read;

assign adc1_wbyte_23_16 = top_only_write & adc1_sel & i_cfg_avmm_byte_en[2];
assign adc1_wbyte_31_24 = top_only_write & adc1_sel & i_cfg_avmm_byte_en[3];

// ADC1 conversion data register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc1_value_register
    if(!i_cfg_avmm_rst_n)
      adc1_value_ff[9:0] <= 10'h0;
    else if(adc1_done) // Samples ADC conversion value
      adc1_value_ff[9:0] <= adc1_out[9:0];
  end // block: adc1_value_register

// ADC1 conversion done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc1_done_register
    if(!i_cfg_avmm_rst_n)
      adc1_done_ff <= 1'h0;
    else if(adc1_done) // ADC conversion done
      adc1_done_ff <= 1'h1;
    else if(adc1_start_ff) // ADC done is cleared when ADC conversion starts
      adc1_done_ff <= 1'h0;
  end // block: adc1_done_register

// ADC start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc1_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc1_start_ff <= 1'h0;
      end
    else if(adc1_done)
      begin
        adc1_start_ff  <= 1'h0;
      end
    else if(adc1_wbyte_31_24)
      begin
        adc1_start_ff  <=  i_cfg_avmm_wdata[31];
      end
  end // block: adc1_start_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc1_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc1_chopen_ff      <= 1'h0;
        adc1_en_ff          <= 1'h0;
        clkdiv_adc1_ff[1:0] <= 2'h0;
        adc1_muxsel_ff[2:0] <= 3'h0;
        adc1_dfx_en_ff      <= 1'h0;
      end
    else if(adc1_wbyte_23_16)
      begin
        adc1_chopen_ff      <= i_cfg_avmm_wdata[16];
        adc1_en_ff          <= i_cfg_avmm_wdata[17];
        clkdiv_adc1_ff[1:0] <= i_cfg_avmm_wdata[19:18];
        adc1_muxsel_ff[2:0] <= i_cfg_avmm_wdata[22:20];
        adc1_dfx_en_ff      <= i_cfg_avmm_wdata[23];
      end
  end // block: adc1_byte_23_16_register

assign adc1_data[31:0] = { adc1_start_ff,
                           7'h0,
                           adc1_dfx_en_ff,
                           adc1_muxsel_ff[2:0],
                           clkdiv_adc1_ff[1:0],
                           adc1_en_ff,
                           adc1_chopen_ff,
                           adc1_done_ff,
                           5'h0,
                           adc1_value_ff[9:0] };

assign adc1_start       = adc1_start_ff       & ~i_scan_mode;
assign adc1_dfx_en      = adc1_dfx_en_ff      & ~i_scan_mode;
assign adc1_muxsel[2:0] = adc1_muxsel_ff[2:0] & {3{(~i_scan_mode)}};
assign clkdiv_adc1[1:0] = clkdiv_adc1_ff[1:0] & {2{(~i_scan_mode)}};
assign adc1_en          = adc1_en_ff          & ~i_scan_mode;
assign adc1_chopen      = adc1_chopen_ff      & ~i_scan_mode;

//------------------------------------------------------------------------------
//                                ADC2 register
//------------------------------------------------------------------------------
assign adc2_sel  = (i_cfg_avmm_addr[7:2] == ADC2_ADDR_OFF[7:2]);
assign adc2_read = adc2_sel & top_only_read;

assign adc2_wbyte_23_16 = top_only_write & adc2_sel & i_cfg_avmm_byte_en[2];
assign adc2_wbyte_31_24 = top_only_write & adc2_sel & i_cfg_avmm_byte_en[3];

// ADC2 conversion data register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc2_value_register
    if(!i_cfg_avmm_rst_n)
      adc2_value_ff[9:0] <= 10'h0;
    else if(adc2_done) // Samples ADC conversion value
      adc2_value_ff[9:0] <= adc2_out[9:0];
  end // block: adc2_value_register

// ADC2 conversion done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc2_done_register
    if(!i_cfg_avmm_rst_n)
      adc2_done_ff <= 1'h0;
    else if(adc2_done) // ADC conversion done
      adc2_done_ff <= 1'h1;
    else if(adc2_start_ff) // ADC done is cleared when ADC conversion starts
      adc2_done_ff <= 1'h0;
  end // block: adc2_done_register

// ADC start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc2_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc2_start_ff <= 1'h0;
      end
    else if(adc2_done)
      begin
        adc2_start_ff  <= 1'h0;
      end
    else if(adc2_wbyte_31_24)
      begin
        adc2_start_ff  <= i_cfg_avmm_wdata[31];
      end
  end // block: adc2_start_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc2_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc2_chopen_ff      <= 1'h0;
        adc2_en_ff          <= 1'h0;
        clkdiv_adc2_ff[1:0] <= 2'h0;
        adc2_muxsel_ff[2:0] <= 3'h0;
        adc2_dfx_en_ff      <= 1'h0;
      end
    else if(adc2_wbyte_23_16)
      begin
        adc2_chopen_ff      <= i_cfg_avmm_wdata[16];
        adc2_en_ff          <= i_cfg_avmm_wdata[17];
        clkdiv_adc2_ff[1:0] <= i_cfg_avmm_wdata[19:18];
        adc2_muxsel_ff[2:0] <= i_cfg_avmm_wdata[22:20];
        adc2_dfx_en_ff      <= i_cfg_avmm_wdata[23];
      end
  end // block: adc2_byte_23_16_register

assign adc2_data[31:0] = { adc2_start_ff,
                           7'h0,
                           adc2_dfx_en_ff,
                           adc2_muxsel_ff[2:0],
                           clkdiv_adc2_ff[1:0],
                           adc2_en_ff,
                           adc2_chopen_ff,
                           adc2_done_ff,
                           5'h0,
                           adc2_value_ff[9:0] };

assign adc2_start       = adc2_start_ff       & ~i_scan_mode;
assign adc2_dfx_en      = adc2_dfx_en_ff      & ~i_scan_mode;
assign adc2_muxsel[2:0] = adc2_muxsel_ff[2:0] & {3{(~i_scan_mode)}};
assign clkdiv_adc2[1:0] = clkdiv_adc2_ff[1:0] & {2{(~i_scan_mode)}};
assign adc2_en          = adc2_en_ff          & ~i_scan_mode;
assign adc2_chopen      = adc2_chopen_ff      & ~i_scan_mode;

//------------------------------------------------------------------------------
//                                ADC3 register
//------------------------------------------------------------------------------
assign adc3_sel  = (i_cfg_avmm_addr[7:2] == ADC3_ADDR_OFF[7:2]);
assign adc3_read = adc3_sel & top_only_read;

assign adc3_wbyte_23_16 = top_only_write & adc3_sel & i_cfg_avmm_byte_en[2];
assign adc3_wbyte_31_24 = top_only_write & adc3_sel & i_cfg_avmm_byte_en[3];

// ADC3 conversion data register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc3_value_register
    if(!i_cfg_avmm_rst_n)
      adc3_value_ff[9:0] <= 10'h0;
    else if(adc3_done) // Samples ADC conversion value
      adc3_value_ff[9:0] <= adc3_out[9:0];
  end // block: adc3_value_register

// ADC3 conversion done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc3_done_register
    if(!i_cfg_avmm_rst_n)
      adc3_done_ff <= 1'h0;
    else if(adc3_done) // ADC conversion done
      adc3_done_ff <= 1'h1;
    else if(adc3_start_ff) // ADC done is cleared when ADC conversion starts
      adc3_done_ff <= 1'h0;
  end // block: adc3_done_register

// ADC start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc3_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc3_start_ff <= 1'h0;
      end
    else if(adc3_done)
      begin
        adc3_start_ff  <= 1'h0;
      end
    else if(adc3_wbyte_31_24)
      begin
        adc3_start_ff  <= i_cfg_avmm_wdata[31];
      end
  end // block: adc3_start_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc3_chopen_ff      <= 1'h0;
        adc3_en_ff          <= 1'h0;
        clkdiv_adc3_ff[1:0] <= 2'h0;
        adc3_muxsel_ff[2:0] <= 3'h0;
        adc3_dfx_en_ff      <= 1'h0;
      end
    else if(adc3_wbyte_23_16)
      begin
        adc3_chopen_ff      <= i_cfg_avmm_wdata[16];
        adc3_en_ff          <= i_cfg_avmm_wdata[17];
        clkdiv_adc3_ff[1:0] <= i_cfg_avmm_wdata[19:18];
        adc3_muxsel_ff[2:0] <= i_cfg_avmm_wdata[22:20];
        adc3_dfx_en_ff      <= i_cfg_avmm_wdata[23];
      end
  end // block: adc3_byte_23_16_register

assign adc3_data[31:0] = { adc3_start_ff,
                           7'h0,
                           adc3_dfx_en_ff,
                           adc3_muxsel_ff[2:0],
                           clkdiv_adc3_ff[1:0],
                           adc3_en_ff,
                           adc3_chopen_ff,
                           adc3_done_ff,
                           5'h0,
                           adc3_value_ff[9:0] };


assign adc3_start       = adc3_start_ff       & ~i_scan_mode;
assign adc3_dfx_en      = adc3_dfx_en_ff      & ~i_scan_mode;
assign adc3_muxsel[2:0] = adc3_muxsel_ff[2:0] & {3{(~i_scan_mode)}};
assign clkdiv_adc3[1:0] = clkdiv_adc3_ff[1:0] & {2{(~i_scan_mode)}};
assign adc3_en          = adc3_en_ff          & ~i_scan_mode;
assign adc3_chopen      = adc3_chopen_ff      & ~i_scan_mode;

//------------------------------------------------------------------------------
//                                ADC4 register
//------------------------------------------------------------------------------
assign adc4_sel  = (i_cfg_avmm_addr[7:2] == ADC4_ADDR_OFF[7:2]);
assign adc4_read = adc4_sel & top_only_read;

assign adc4_wbyte_23_16 = top_only_write & adc4_sel & i_cfg_avmm_byte_en[2];
assign adc4_wbyte_31_24 = top_only_write & adc4_sel & i_cfg_avmm_byte_en[3];

// ADC4 conversion data register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc4_value_register
    if(!i_cfg_avmm_rst_n)
      adc4_value_ff[9:0] <= 10'h0;
    else if(adc4_done) // Samples ADC conversion value
      adc4_value_ff[9:0] <= adc4_out[9:0];
  end // block: adc4_value_register

// ADC4 conversion done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc4_done_register
    if(!i_cfg_avmm_rst_n)
      adc4_done_ff <= 1'h0;
    else if(adc4_done) // ADC conversion done
      adc4_done_ff <= 1'h1;
    else if(adc4_start_ff) // ADC done is cleared when ADC conversion starts
      adc4_done_ff <= 1'h0;
  end // block: adc4_done_register

// ADC start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc4_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc4_start_ff <= 1'h0;
      end
    else if(adc4_done)
      begin
        adc4_start_ff  <= 1'h0;
      end
    else if(adc4_wbyte_31_24)
      begin
        adc4_start_ff  <= i_cfg_avmm_wdata[31];
      end
  end // block: adc4_start_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: adc4_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        adc4_chopen_ff      <= 1'h0;
        adc4_en_ff          <= 1'h0;
        clkdiv_adc4_ff[1:0] <= 2'h0;
        adc4_muxsel_ff[2:0] <= 3'h0;
        adc4_dfx_en_ff      <= 1'h0;
      end
    else if(adc4_wbyte_23_16)
      begin
        adc4_chopen_ff      <= i_cfg_avmm_wdata[16];
        adc4_en_ff          <= i_cfg_avmm_wdata[17];
        clkdiv_adc4_ff[1:0] <= i_cfg_avmm_wdata[19:18];
        adc4_muxsel_ff[2:0] <= i_cfg_avmm_wdata[22:20];
        adc4_dfx_en_ff      <= i_cfg_avmm_wdata[23];
      end
  end // block: adc4_byte_23_16_register

assign adc4_data[31:0] = { adc4_start_ff,
                           7'h0,
                           adc4_dfx_en_ff,
                           adc4_muxsel_ff[2:0],
                           clkdiv_adc4_ff[1:0],
                           adc4_en_ff,
                           adc4_chopen_ff,
                           adc4_done_ff,
                           5'h0,
                           adc4_value_ff[9:0] };

assign adc4_start       = adc4_start_ff       & ~i_scan_mode;
assign adc4_dfx_en      = adc4_dfx_en_ff      & ~i_scan_mode;
assign adc4_muxsel[2:0] = adc4_muxsel_ff[2:0] & {3{(~i_scan_mode)}};
assign clkdiv_adc4[1:0] = clkdiv_adc4_ff[1:0] & {2{(~i_scan_mode)}};
assign adc4_en          = adc4_en_ff          & ~i_scan_mode;
assign adc4_chopen      = adc4_chopen_ff      & ~i_scan_mode;

//------------------------------------------------------------------------------
//                             AUXCH register
//------------------------------------------------------------------------------
assign auxch_sel  = (i_cfg_avmm_addr[7:2] == AUXCH_ADDR_OFF[7:2]);
assign auxch_read = auxch_sel & top_only_read;

assign auxch_wbyte_7_0   = top_only_write & auxch_sel & i_cfg_avmm_byte_en[0];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: auxch_byte_7_0_register
    if(!i_cfg_avmm_rst_n)
      begin
        auxch_rxbuf_cfg_code_ff[2:0] <= 3'h0;
      end
    else if(auxch_wbyte_7_0)
      begin
        auxch_rxbuf_cfg_code_ff[2:0] <= i_cfg_avmm_wdata[2:0];
      end
  end // block: auxch_byte_7_0_register

assign auxch_data[31:0] = {29'h0, auxch_rxbuf_cfg_code_ff[2:0]};

assign auxch_rxbuf[2:0] = auxch_rxbuf_cfg_code_ff[2:0] & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONA3 register
//------------------------------------------------------------------------------

assign pvtmona3_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONA3_ADDR_OFF[7:2]);
assign pvtmona3_read = pvtmona3_sel & top_only_read;

assign pvtmona3_wbyte_23_16 = top_only_write & pvtmona3_sel & i_cfg_avmm_byte_en[2];
assign pvtmona3_wbyte_31_24 = top_only_write & pvtmona3_sel & i_cfg_avmm_byte_en[3];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmona3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmona3_osc_sel_ff[2:0]    <= 2'h0;
        pvtmona3_osc_clkdiv_ff[2:0] <= 3'h0;
      end
    else if(pvtmona3_wbyte_23_16)
      begin
        pvtmona3_osc_sel_ff[2:0]    <= i_cfg_avmm_wdata[18:16];
        pvtmona3_osc_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[22:20];
      end
  end // block: pvtmona3_byte_23_16_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmona3_byte_31_24_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmona3_ref_clkdiv_ff[2:0]  <= 3'h0;
        pvtmona3_digview_sel_ff[2:0] <= 3'h0;
        pvtmona3_dfx_en_ff           <= 1'b0;
        pvtmona3_en_ff               <= 1'h0;
      end
    else if(pvtmona3_wbyte_31_24)
      begin
        pvtmona3_ref_clkdiv_ff[2:0]  <= i_cfg_avmm_wdata[26:24];
        pvtmona3_digview_sel_ff[2:0] <= i_cfg_avmm_wdata[29:27];
        pvtmona3_dfx_en_ff           <= i_cfg_avmm_wdata[30];
        pvtmona3_en_ff               <= i_cfg_avmm_wdata[31];
      end
  end // block: pvtmona3_byte_31_24_register

assign pvtmona3_data[31:0] = { pvtmona3_en_ff,
                               pvtmona3_dfx_en_ff,
                               pvtmona3_digview_sel_ff[2:0],
                               pvtmona3_ref_clkdiv_ff[2:0],
                               1'h0,
                               pvtmona3_osc_clkdiv_ff[2:0],
                               1'h0,
                               pvtmona3_osc_sel_ff[2:0],
                               16'h0 };

// Logic to avoid that analog control signals change during scan
assign pvtmona_en          = pvtmona3_en_ff               & {(~i_scan_mode)};
assign pvtmona_dfx_en      = pvtmona3_dfx_en_ff           & {(~i_scan_mode)};
assign pvtmona_ref_clkdiv  = pvtmona3_ref_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmona_digview_sel = pvtmona3_digview_sel_ff[2:0] & {3{(~i_scan_mode)}};
assign pvtmona_osc_clkdiv  = pvtmona3_osc_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmona_osc_sel     = pvtmona3_osc_sel_ff[2:0]     & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONA4 register
//------------------------------------------------------------------------------

assign pvtmona4_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONA4_ADDR_OFF[7:2]);
assign pvtmona4_read = pvtmona4_sel & top_only_read;

assign pvtmona4_wbyte_23_16 = top_only_write & pvtmona4_sel & i_cfg_avmm_byte_en[2];

// Oscillator clock counter done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmona4_osc_count_done_register
    if(!i_cfg_avmm_rst_n)
      pvtmona4_count_done_ff <= 1'h0;
    else if(pvtmona_count_done)
      pvtmona4_count_done_ff <= 1'h1;
    else if(pvtmona4_count_start_ff)
      pvtmona4_count_done_ff <= 1'h0;
  end // block: pvtmona4_osc_count_done_register

// Oscillator clock counter register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmona4_osc_clk_count_register
    if(!i_cfg_avmm_rst_n)
      pvtmona4_osc_clk_count_ff[9:0] <= 10'h0;
    else if(pvtmona_count_done)
      pvtmona4_osc_clk_count_ff[9:0] <= pvtmona_osc_clk_count[9:0];
  end // block: pvtmona4_osc_clk_count_register

// PVT monitor counter start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmona4_count_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmona4_count_start_ff <= 1'h0;
      end
    else if(pvtmona_count_done)
      begin
        pvtmona4_count_start_ff <= 1'h0;
      end
    else if(pvtmona4_wbyte_23_16)
      begin
        pvtmona4_count_start_ff <= i_cfg_avmm_wdata[16];
      end
  end // block: pvtmona4_byte_23_16_register

assign pvtmona4_data[31:0] = { pvtmona4_count_done_ff,
                               14'h0,
                               pvtmona4_count_start_ff,
                               6'h0,
                               pvtmona4_osc_clk_count_ff[9:0] };

// Logic to avoid that analog control signals change during scan
assign pvtmona_count_start = pvtmona4_count_start_ff & {(~i_scan_mode)};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONB3 register
//------------------------------------------------------------------------------

assign pvtmonb3_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONB3_ADDR_OFF[7:2]);
assign pvtmonb3_read = pvtmonb3_sel & top_only_read;

assign pvtmonb3_wbyte_23_16 = top_only_write & pvtmonb3_sel & i_cfg_avmm_byte_en[2];
assign pvtmonb3_wbyte_31_24 = top_only_write & pvtmonb3_sel & i_cfg_avmm_byte_en[3];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonb3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonb3_osc_sel_ff[2:0]    <= 3'h0;
        pvtmonb3_osc_clkdiv_ff[2:0] <= 3'h0;
      end
    else if(pvtmonb3_wbyte_23_16)
      begin
        pvtmonb3_osc_sel_ff[2:0]    <= i_cfg_avmm_wdata[18:16];
        pvtmonb3_osc_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[22:20];
      end
  end // block: pvtmonb3_byte_23_16_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonb3_byte_31_24_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonb3_ref_clkdiv_ff[2:0]  <= 3'h0;
        pvtmonb3_digview_sel_ff[2:0] <= 3'h0;
        pvtmonb3_dfx_en_ff           <= 1'b0;
        pvtmonb3_en_ff               <= 1'h0;
      end
    else if(pvtmonb3_wbyte_31_24)
      begin
        pvtmonb3_ref_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[26:24];
        pvtmonb3_digview_sel_ff[2:0] <= i_cfg_avmm_wdata[29:27];
        pvtmonb3_dfx_en_ff          <= i_cfg_avmm_wdata[30];
        pvtmonb3_en_ff              <= i_cfg_avmm_wdata[31];
      end
  end // block: pvtmonb3_byte_31_24_register

assign pvtmonb3_data[31:0] = { pvtmonb3_en_ff,
                               pvtmonb3_dfx_en_ff,
                               pvtmonb3_digview_sel_ff[2:0],
                               pvtmonb3_ref_clkdiv_ff[2:0],
                               1'h0,
                               pvtmonb3_osc_clkdiv_ff[2:0],
                               1'h0,
                               pvtmonb3_osc_sel_ff[2:0],
                               16'h0 };

// Logic to avoid that analog control signals change during scan
assign pvtmonb_en          = pvtmonb3_en_ff               & {(~i_scan_mode)};
assign pvtmonb_dfx_en      = pvtmonb3_dfx_en_ff           & {(~i_scan_mode)};
assign pvtmonb_digview_sel = pvtmonb3_digview_sel_ff[2:0] & {3{(~i_scan_mode)}};
assign pvtmonb_ref_clkdiv  = pvtmonb3_ref_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmonb_osc_clkdiv  = pvtmonb3_osc_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmonb_osc_sel     = pvtmonb3_osc_sel_ff[2:0]     & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONB4 register
//------------------------------------------------------------------------------

assign pvtmonb4_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONB4_ADDR_OFF[7:2]);
assign pvtmonb4_read = pvtmonb4_sel & top_only_read;

assign pvtmonb4_wbyte_23_16 = top_only_write & pvtmonb4_sel & i_cfg_avmm_byte_en[2];

// Oscillator clock counter done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonb4_osc_count_done_register
    if(!i_cfg_avmm_rst_n)
      pvtmonb4_count_done_ff <= 1'h0;
    else if(pvtmonb_count_done)
      pvtmonb4_count_done_ff <= 1'h1;
    else if(pvtmonb4_count_start_ff)
      pvtmonb4_count_done_ff <= 1'h0;
  end // block: pvtmonb4_osc_count_done_register

// Oscillator clock counter register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonb4_osc_clk_count_register
    if(!i_cfg_avmm_rst_n)
      pvtmonb4_osc_clk_count_ff[9:0] <= 10'h0;
    else if(pvtmonb_count_done)
      pvtmonb4_osc_clk_count_ff[9:0] <= pvtmonb_osc_clk_count[9:0];
  end // block: pvtmonb4_osc_clk_count_register

// PVT monitor counter start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonb4_count_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonb4_count_start_ff <= 1'h0;
      end
    else if(pvtmonb_count_done)
      begin
        pvtmonb4_count_start_ff <= 1'h0;
      end
    else if(pvtmonb4_wbyte_23_16)
      begin
        pvtmonb4_count_start_ff <= i_cfg_avmm_wdata[16];
      end
  end // block: pvtmonb4_byte_23_16_register

assign pvtmonb4_data[31:0] = { pvtmonb4_count_done_ff,
                               14'h0,
                               pvtmonb4_count_start_ff,
                               6'h0,
                               pvtmonb4_osc_clk_count_ff[9:0] };

// Logic to avoid that analog control signals change during scan
assign pvtmonb_count_start = pvtmonb4_count_start_ff & {(~i_scan_mode)};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONC3 register
//------------------------------------------------------------------------------

assign pvtmonc3_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONC3_ADDR_OFF[7:2]);
assign pvtmonc3_read = pvtmonc3_sel & top_only_read;

assign pvtmonc3_wbyte_23_16 = top_only_write & pvtmonc3_sel & i_cfg_avmm_byte_en[2];
assign pvtmonc3_wbyte_31_24 = top_only_write & pvtmonc3_sel & i_cfg_avmm_byte_en[3];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonc3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonc3_osc_sel_ff[2:0]    <= 3'h0;
        pvtmonc3_osc_clkdiv_ff[2:0] <= 3'h0;
      end
    else if(pvtmonc3_wbyte_23_16)
      begin
        pvtmonc3_osc_sel_ff[2:0]    <= i_cfg_avmm_wdata[18:16];
        pvtmonc3_osc_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[22:20];
      end
  end // block: pvtmonc3_byte_23_16_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonc3_byte_31_24_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonc3_ref_clkdiv_ff[2:0]  <= 3'h0;
        pvtmonc3_digview_sel_ff[2:0] <= 3'h0;
        pvtmonc3_dfx_en_ff           <= 1'b0;
        pvtmonc3_en_ff               <= 1'h0;
      end
    else if(pvtmonc3_wbyte_31_24)
      begin
        pvtmonc3_ref_clkdiv_ff[2:0]  <= i_cfg_avmm_wdata[26:24];
        pvtmonc3_digview_sel_ff[2:0] <= i_cfg_avmm_wdata[29:27];
        pvtmonc3_dfx_en_ff           <= i_cfg_avmm_wdata[30];
        pvtmonc3_en_ff               <= i_cfg_avmm_wdata[31];
      end
  end // block: pvtmonc3_byte_31_24_register

assign pvtmonc3_data[31:0] = { pvtmonc3_en_ff,
                               pvtmonc3_dfx_en_ff,
                               pvtmonc3_digview_sel_ff[2:0],
                               pvtmonc3_ref_clkdiv_ff[2:0],
                               1'h0,
                               pvtmonc3_osc_clkdiv_ff[2:0],
                               1'h0,
                               pvtmonc3_osc_sel_ff[2:0],
                               16'h0 };

// Logic to avoid that analog control signals change during scan
assign pvtmonc_en          = pvtmonc3_en_ff               & {(~i_scan_mode)};
assign pvtmonc_dfx_en      = pvtmonc3_dfx_en_ff           & {(~i_scan_mode)};
assign pvtmonc_digview_sel = pvtmonc3_digview_sel_ff[2:0] & {3{(~i_scan_mode)}};
assign pvtmonc_ref_clkdiv  = pvtmonc3_ref_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmonc_osc_clkdiv  = pvtmonc3_osc_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmonc_osc_sel     = pvtmonc3_osc_sel_ff[2:0]     & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONC4 register
//------------------------------------------------------------------------------

assign pvtmonc4_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONC4_ADDR_OFF[7:2]);
assign pvtmonc4_read = pvtmonc4_sel & top_only_read;

assign pvtmonc4_wbyte_23_16 = top_only_write & pvtmonc4_sel & i_cfg_avmm_byte_en[2];

// Oscillator clock counter done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonc4_osc_count_done_register
    if(!i_cfg_avmm_rst_n)
      pvtmonc4_count_done_ff <= 1'h0;
    else if(pvtmonc_count_done)
      pvtmonc4_count_done_ff <= 1'h1;
    else if(pvtmonc4_count_start_ff)
      pvtmonc4_count_done_ff <= 1'h0;
  end // block: pvtmonc4_osc_count_done_register

// Oscillator clock counter register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonc4_osc_clk_count_register
    if(!i_cfg_avmm_rst_n)
      pvtmonc4_osc_clk_count_ff[9:0] <= 10'h0;
    else if(pvtmonc_count_done)
      pvtmonc4_osc_clk_count_ff[9:0] <= pvtmonc_osc_clk_count[9:0];
  end // block: pvtmonc4_osc_clk_count_register

// PVT monitor counter start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmonc4_count_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmonc4_count_start_ff <= 1'h0;
      end
    else if(pvtmonc_count_done)
      begin
        pvtmonc4_count_start_ff <= 1'h0;
      end
    else if(pvtmonc4_wbyte_23_16)
      begin
        pvtmonc4_count_start_ff <= i_cfg_avmm_wdata[16];
      end
  end // block: pvtmonc4_byte_23_16_register

assign pvtmonc4_data[31:0] = { pvtmonc4_count_done_ff,
                               14'h0,
                               pvtmonc4_count_start_ff,
                               6'h0,
                               pvtmonc4_osc_clk_count_ff[9:0] };

// Logic to avoid that analog control signals change during scan
assign pvtmonc_count_start = pvtmonc4_count_start_ff & {(~i_scan_mode)};

//------------------------------------------------------------------------------
//                             AIBIO PVTMOND3 register
//------------------------------------------------------------------------------

assign pvtmond3_sel  = (i_cfg_avmm_addr[7:2]  == PVTMOND3_ADDR_OFF[7:2]);
assign pvtmond3_read = pvtmond3_sel & top_only_read;

assign pvtmond3_wbyte_23_16 = top_only_write & pvtmond3_sel & i_cfg_avmm_byte_en[2];
assign pvtmond3_wbyte_31_24 = top_only_write & pvtmond3_sel & i_cfg_avmm_byte_en[3];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmond3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmond3_osc_sel_ff[2:0]    <= 3'h0;
        pvtmond3_osc_clkdiv_ff[2:0] <= 3'h0;
      end
    else if(pvtmond3_wbyte_23_16)
      begin
        pvtmond3_osc_sel_ff[2:0]    <= i_cfg_avmm_wdata[18:16];
        pvtmond3_osc_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[22:20];
      end
  end // block: pvtmond3_byte_23_16_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmond3_byte_31_24_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmond3_ref_clkdiv_ff[2:0]  <= 3'h0;
        pvtmond3_digview_sel_ff[2:0] <= 3'h0;
        pvtmond3_dfx_en_ff           <= 1'b0;
        pvtmond3_en_ff               <= 1'h0;
      end
    else if(pvtmond3_wbyte_31_24)
      begin
        pvtmond3_ref_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[26:24];
        pvtmond3_digview_sel_ff[2:0] <= i_cfg_avmm_wdata[29:27];
        pvtmond3_dfx_en_ff          <= i_cfg_avmm_wdata[30];
        pvtmond3_en_ff              <= i_cfg_avmm_wdata[31];
      end
  end // block: pvtmond3_byte_31_24_register

assign pvtmond3_data[31:0] = { pvtmond3_en_ff,
                               pvtmond3_dfx_en_ff,
                               pvtmond3_digview_sel_ff[2:0],
                               pvtmond3_ref_clkdiv_ff[2:0],
                               1'h0,
                               pvtmond3_osc_clkdiv_ff[2:0],
                               1'h0,
                               pvtmond3_osc_sel_ff[2:0],
                               16'h0 };

// Logic to avoid that analog control signals change during scan
assign pvtmond_en          = pvtmond3_en_ff               & {(~i_scan_mode)};
assign pvtmond_dfx_en      = pvtmond3_dfx_en_ff           & {(~i_scan_mode)};
assign pvtmond_digview_sel = pvtmond3_digview_sel_ff[2:0] & {3{(~i_scan_mode)}};
assign pvtmond_ref_clkdiv  = pvtmond3_ref_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmond_osc_clkdiv  = pvtmond3_osc_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmond_osc_sel     = pvtmond3_osc_sel_ff[2:0]     & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMOND4 register
//------------------------------------------------------------------------------

assign pvtmond4_sel  = (i_cfg_avmm_addr[7:2]  == PVTMOND4_ADDR_OFF[7:2]);
assign pvtmond4_read = pvtmond4_sel & top_only_read;

assign pvtmond4_wbyte_23_16 = top_only_write & pvtmond4_sel & i_cfg_avmm_byte_en[2];

// Oscillator clock counter done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmond4_osc_count_done_register
    if(!i_cfg_avmm_rst_n)
      pvtmond4_count_done_ff <= 1'h0;
    else if(pvtmond_count_done)
      pvtmond4_count_done_ff <= 1'h1;
    else if(pvtmond4_count_start_ff)
      pvtmond4_count_done_ff <= 1'h0;
  end // block: pvtmond4_osc_count_done_register

// Oscillator clock counter register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmond4_osc_clk_count_register
    if(!i_cfg_avmm_rst_n)
      pvtmond4_osc_clk_count_ff[9:0] <= 10'h0;
    else if(pvtmond_count_done)
      pvtmond4_osc_clk_count_ff[9:0] <= pvtmond_osc_clk_count[9:0];
  end // block: pvtmond4_osc_clk_count_register

// PVT monitor counter start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmond4_count_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmond4_count_start_ff <= 1'h0;
      end
    else if(pvtmond_count_done)
      begin
        pvtmond4_count_start_ff <= 1'h0;
      end
    else if(pvtmond4_wbyte_23_16)
      begin
        pvtmond4_count_start_ff <= i_cfg_avmm_wdata[16];
      end
  end // block: pvtmond4_byte_23_16_register

assign pvtmond4_data[31:0] = { pvtmond4_count_done_ff,
                               14'h0,
                               pvtmond4_count_start_ff,
                               6'h0,
                               pvtmond4_osc_clk_count_ff[9:0] };

// Logic to avoid that analog control signals change during scan
assign pvtmond_count_start = pvtmond4_count_start_ff & {(~i_scan_mode)};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONE3 register
//------------------------------------------------------------------------------

assign pvtmone3_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONE3_ADDR_OFF[7:2]);
assign pvtmone3_read = pvtmone3_sel & top_only_read;

assign pvtmone3_wbyte_23_16 = top_only_write & pvtmone3_sel & i_cfg_avmm_byte_en[2];
assign pvtmone3_wbyte_31_24 = top_only_write & pvtmone3_sel & i_cfg_avmm_byte_en[3];

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmone3_byte_23_16_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmone3_osc_sel_ff[2:0]    <= 3'h0;
        pvtmone3_osc_clkdiv_ff[2:0] <= 3'h0;
      end
    else if(pvtmone3_wbyte_23_16)
      begin
        pvtmone3_osc_sel_ff[2:0]    <= i_cfg_avmm_wdata[18:16];
        pvtmone3_osc_clkdiv_ff[2:0] <= i_cfg_avmm_wdata[22:20];
      end
  end // block: pvtmone3_byte_23_16_register

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmone3_byte_31_24_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmone3_ref_clkdiv_ff[2:0]  <= 3'h0;
        pvtmone3_digview_sel_ff[2:0] <= 3'h0;
        pvtmone3_dfx_en_ff           <= 1'b0;
        pvtmone3_en_ff               <= 1'h0;
      end
    else if(pvtmone3_wbyte_31_24)
      begin
        pvtmone3_ref_clkdiv_ff[2:0]  <= i_cfg_avmm_wdata[26:24];
        pvtmone3_digview_sel_ff[2:0] <= i_cfg_avmm_wdata[29:27];
        pvtmone3_dfx_en_ff           <= i_cfg_avmm_wdata[30];
        pvtmone3_en_ff               <= i_cfg_avmm_wdata[31];
      end
  end // block: pvtmone3_byte_31_24_register

assign pvtmone3_data[31:0] = { pvtmone3_en_ff,
                               pvtmone3_dfx_en_ff,
                               pvtmone3_digview_sel_ff[2:0],
                               pvtmone3_ref_clkdiv_ff[2:0],
                               1'h0,
                               pvtmone3_osc_clkdiv_ff[2:0],
                               1'h0,
                               pvtmone3_osc_sel_ff[2:0],
                               16'h0 };

// Logic to avoid that analog control signals change during scan
assign pvtmone_en           = pvtmone3_en_ff               & {(~i_scan_mode)};
assign pvtmone_dfx_en       = pvtmone3_dfx_en_ff           & {(~i_scan_mode)};
assign pvtmone_digview_sel  = pvtmone3_digview_sel_ff[2:0] & {3{(~i_scan_mode)}};
assign pvtmone_ref_clkdiv   = pvtmone3_ref_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmone_osc_clkdiv   = pvtmone3_osc_clkdiv_ff[2:0]  & {3{(~i_scan_mode)}};
assign pvtmone_osc_sel      = pvtmone3_osc_sel_ff[2:0]     & {3{(~i_scan_mode)}};

//------------------------------------------------------------------------------
//                             AIBIO PVTMONE4 register
//------------------------------------------------------------------------------

assign pvtmone4_sel  = (i_cfg_avmm_addr[7:2]  == PVTMONE4_ADDR_OFF[7:2]);
assign pvtmone4_read = pvtmone4_sel & top_only_read;

assign pvtmone4_wbyte_23_16 = top_only_write & pvtmone4_sel & i_cfg_avmm_byte_en[2];

// Oscillator clock counter done register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmone4_osc_count_done_register
    if(!i_cfg_avmm_rst_n)
      pvtmone4_count_done_ff <= 1'h0;
    else if(pvtmone_count_done)
      pvtmone4_count_done_ff <= 1'h1;
    else if(pvtmone4_count_start_ff)
      pvtmone4_count_done_ff <= 1'h0;
  end // block: pvtmone4_osc_count_done_register

// Oscillator clock counter register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmone4_osc_clk_count_register
    if(!i_cfg_avmm_rst_n)
      pvtmone4_osc_clk_count_ff[9:0] <= 10'h0;
    else if(pvtmone_count_done)
      pvtmone4_osc_clk_count_ff[9:0] <= pvtmone_osc_clk_count[9:0];
  end // block: pvtmone4_osc_clk_count_register

// PVT monitor counter start register
always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: pvtmone4_count_start_register
    if(!i_cfg_avmm_rst_n)
      begin
        pvtmone4_count_start_ff <= 1'h0;
      end
    else if(pvtmone_count_done)
      begin
        pvtmone4_count_start_ff <= 1'h0;
      end
    else if(pvtmone4_wbyte_23_16)
      begin
        pvtmone4_count_start_ff <= i_cfg_avmm_wdata[16];
      end
  end // block: pvtmone4_byte_23_16_register

assign pvtmone4_data[31:0] = { pvtmone4_count_done_ff,
                               14'h0,
                               pvtmone4_count_start_ff,
                               6'h0,
                               pvtmone4_osc_clk_count_ff[9:0] };

// Logic to avoid that analog control signals change during scan
assign pvtmone_count_start = pvtmone4_count_start_ff & {(~i_scan_mode)};

//------------------------------------------------------------------------------
//                             Read data logic
//------------------------------------------------------------------------------

assign rdata_comb[31:0] = (adc0_read       ? adc0_data[31:0]       : 32'h0) |
                          (adc1_read       ? adc1_data[31:0]       : 32'h0) |
                          (adc2_read       ? adc2_data[31:0]       : 32'h0) |
                          (adc3_read       ? adc3_data[31:0]       : 32'h0) |
                          (adc4_read       ? adc4_data[31:0]       : 32'h0) |
                          (pvtmona3_read   ? pvtmona3_data[31:0]   : 32'h0) |
                          (pvtmona4_read   ? pvtmona4_data[31:0]   : 32'h0) |
                          (pvtmonb3_read   ? pvtmonb3_data[31:0]   : 32'h0) |
                          (pvtmonb4_read   ? pvtmonb4_data[31:0]   : 32'h0) |
                          (pvtmonc3_read   ? pvtmonc3_data[31:0]   : 32'h0) |
                          (pvtmonc4_read   ? pvtmonc4_data[31:0]   : 32'h0) |
                          (pvtmond3_read   ? pvtmond3_data[31:0]   : 32'h0) |
                          (pvtmond4_read   ? pvtmond4_data[31:0]   : 32'h0) |
                          (pvtmone3_read   ? pvtmone3_data[31:0]   : 32'h0) |
                          (pvtmone4_read   ? pvtmone4_data[31:0]   : 32'h0) |
                          (auxch_read      ? auxch_data[31:0]      : 32'h0);

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin: avmm_rdata_top_register
    if(!i_cfg_avmm_rst_n)
      avmm_rdata_top[31:0] <= 32'h0;
    else
      avmm_rdata_top[31:0] <= rdata_comb[31:0];
  end // block: avmm_rdata_top_register

endmodule // aib_avmm_top
