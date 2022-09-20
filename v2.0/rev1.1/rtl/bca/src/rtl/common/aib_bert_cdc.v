// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
 
module aib_bert_cdc #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(
//------------------------------------------------------------------------------
//                    Interface with RX BERT
//------------------------------------------------------------------------------
output     [  3:0] rx_start_pulse,
output     [  3:0] rx_rst_pulse,
output     [  3:0] seed_in_en,
output reg [  5:0] chk3_lane_sel_ff,
output reg [  5:0] chk2_lane_sel_ff,
output reg [  5:0] chk1_lane_sel_ff,
output reg [  5:0] chk0_lane_sel_ff,
output reg [  2:0] chk3_ptrn_sel_ff,
output reg [  2:0] chk2_ptrn_sel_ff,
output reg [  2:0] chk1_ptrn_sel_ff,
output reg [  2:0] chk0_ptrn_sel_ff,
input      [ 48:0] rxbert_bit_cnt,
input      [ 15:0] biterr_cnt_chk3,
input      [ 15:0] biterr_cnt_chk2,
input      [ 15:0] biterr_cnt_chk1,
input      [ 15:0] biterr_cnt_chk0,
input      [127:0] rx_bert3_data,
input      [127:0] rx_bert2_data,
input      [127:0] rx_bert1_data,
input      [127:0] rx_bert0_data,
input      [  3:0] rx_bertgen_en,
//------------------------------------------------------------------------------
//                    Interface with TX BERT
//------------------------------------------------------------------------------
output reg  [ 1:0] lane39_gen_sel_ff,
output reg  [ 1:0] lane38_gen_sel_ff,
output reg  [ 1:0] lane37_gen_sel_ff,
output reg  [ 1:0] lane36_gen_sel_ff,
output reg  [ 1:0] lane35_gen_sel_ff,
output reg  [ 1:0] lane34_gen_sel_ff,
output reg  [ 1:0] lane33_gen_sel_ff,
output reg  [ 1:0] lane32_gen_sel_ff,
output reg  [ 1:0] lane31_gen_sel_ff,
output reg  [ 1:0] lane30_gen_sel_ff,
output reg  [ 1:0] lane29_gen_sel_ff,
output reg  [ 1:0] lane28_gen_sel_ff,
output reg  [ 1:0] lane27_gen_sel_ff,
output reg  [ 1:0] lane26_gen_sel_ff,
output reg  [ 1:0] lane25_gen_sel_ff,
output reg  [ 1:0] lane24_gen_sel_ff,
output reg  [ 1:0] lane23_gen_sel_ff,
output reg  [ 1:0] lane22_gen_sel_ff,
output reg  [ 1:0] lane21_gen_sel_ff,
output reg  [ 1:0] lane20_gen_sel_ff,
output reg  [ 1:0] lane19_gen_sel_ff,
output reg  [ 1:0] lane18_gen_sel_ff,
output reg  [ 1:0] lane17_gen_sel_ff,
output reg  [ 1:0] lane16_gen_sel_ff,
output reg  [ 1:0] lane15_gen_sel_ff,
output reg  [ 1:0] lane14_gen_sel_ff,
output reg  [ 1:0] lane13_gen_sel_ff,
output reg  [ 1:0] lane12_gen_sel_ff,
output reg  [ 1:0] lane11_gen_sel_ff,
output reg  [ 1:0] lane10_gen_sel_ff,
output reg  [ 1:0] lane9_gen_sel_ff,
output reg  [ 1:0] lane8_gen_sel_ff,
output reg  [ 1:0] lane7_gen_sel_ff,
output reg  [ 1:0] lane6_gen_sel_ff,
output reg  [ 1:0] lane5_gen_sel_ff,
output reg  [ 1:0] lane4_gen_sel_ff,
output reg  [ 1:0] lane3_gen_sel_ff,
output reg  [ 1:0] lane2_gen_sel_ff,
output reg  [ 1:0] lane1_gen_sel_ff,
output reg  [ 1:0] lane0_gen_sel_ff,
output reg  [ 2:0] gen3_ptrn_sel_ff,
output reg  [ 2:0] gen2_ptrn_sel_ff,
output reg  [ 2:0] gen1_ptrn_sel_ff,
output reg  [ 2:0] gen0_ptrn_sel_ff,
output      [ 3:0] tx_start_pulse,
output      [ 3:0] tx_rst_pulse,
output      [15:0] seed_ld_0,
output      [15:0] seed_ld_1,
output      [15:0] seed_ld_2,
output      [15:0] seed_ld_3,
output reg  [31:0] txwdata_sync_ff,
input       [ 3:0] tx_seed_good,
input       [ 3:0] tx_bertgen_en,

//------------------------------------------------------------------------------
//                    BERT access interface
//------------------------------------------------------------------------------
input      [ 5:0] bert_acc_addr,    // BERT access address
input             bert_acc_req,     // BERT access request
input             bert_acc_rdwr,    // BERT access read/write control
input      [31:0] bert_wdata_ff,    // BERT data to be written
output reg [31:0] rx_bert_rdata_ff, // Read data from RX BERT interface
output reg [31:0] tx_bert_rdata_ff, // Read data from TX BERT interface
output            bert_acc_rq_pend, // BERT configuration load is pending
//------------------------------------------------------------------------------
//                        TX BERT control interface
//------------------------------------------------------------------------------
input [3:0] tx_bert_start, // Starts transmitting TX BERT bit sequence
input [3:0] tx_bert_rst,   // Resets TX BERT registers
//------------------------------------------------------------------------------
//                        TX BERT status interface
//------------------------------------------------------------------------------
output reg       bert_seed_good, // Indicates all BPRS seeds are not zero.
output reg [3:0] txbert_run_ff,  // Indicates  TX BERT is running

//------------------------------------------------------------------------------
//                        RX BERT control interface
//------------------------------------------------------------------------------
input [3:0] rxbert_start,   // Starts checking input of RX BERT bit sequence
input [3:0] rxbert_rst,     // Resets RX BERT registers
input [3:0] rxbert_seed_in, // Enables the self-seeding in RX BERT

//------------------------------------------------------------------------------
//                        RX BERT status interface
//------------------------------------------------------------------------------
output reg [ 3:0] rxbert_run_ff,    // Indicates RX BERT is running
output reg [ 3:0] rxbert_biterr_ff, // Error detected in RX BERT checker

// clocks and resets
input i_cfg_avmm_clk,
input i_cfg_avmm_rst_n,
input txfifo_wr_clk,
input txwr_rstn,
input rxfifo_rd_clk,
input rxrd_rstn
);

// RW fields
localparam [5:0] SEEDP0_0     = 6'h0;  
localparam [5:0] SEEDP1_0     = 6'h1;  
localparam [5:0] SEEDP2_0     = 6'h2;  
localparam [5:0] SEEDP3_0     = 6'h3;  
localparam [5:0] SEEDP0_1     = 6'h4;  
localparam [5:0] SEEDP1_1     = 6'h5;  
localparam [5:0] SEEDP2_1     = 6'h6;  
localparam [5:0] SEEDP3_1     = 6'h7;  
localparam [5:0] SEEDP0_2     = 6'h8;  
localparam [5:0] SEEDP1_2     = 6'h9;  
localparam [5:0] SEEDP2_2     = 6'ha;  
localparam [5:0] SEEDP3_2     = 6'hb;  
localparam [5:0] SEEDP0_3     = 6'hc;  
localparam [5:0] SEEDP1_3     = 6'hd;  
localparam [5:0] SEEDP2_3     = 6'he;  
localparam [5:0] SEEDP3_3     = 6'hf;  
localparam [5:0] GEN_SEL0     = 6'h10; 
localparam [5:0] GEN_SEL1     = 6'h11; 
localparam [5:0] GEN_SEL2     = 6'h12; 
localparam [5:0] GEN_PTRN_SEL = 6'h13;
localparam [5:0] RX_LANE_SEL  = 6'h14;
localparam [5:0] CHK_PTRN_SEL = 6'h15;
// Read only field
localparam [5:0] RXBERT_BITCNT_LO = 6'h16;
localparam [5:0] RXBERT_BITCNT_HI = 6'h17;
localparam [5:0] ERRCNT_CHK0      = 6'h18;
localparam [5:0] ERRCNT_CHK1      = 6'h19;
localparam [5:0] ERRCNT_CHK2      = 6'h1a;
localparam [5:0] ERRCNT_CHK3      = 6'h1b;
localparam [5:0] RXBERT0_DATA0    = 6'h1c;
localparam [5:0] RXBERT0_DATA1    = 6'h1d;
localparam [5:0] RXBERT0_DATA2    = 6'h1e;
localparam [5:0] RXBERT0_DATA3    = 6'h1f;
localparam [5:0] RXBERT1_DATA0    = 6'h20;
localparam [5:0] RXBERT1_DATA1    = 6'h21;
localparam [5:0] RXBERT1_DATA2    = 6'h22;
localparam [5:0] RXBERT1_DATA3    = 6'h23;
localparam [5:0] RXBERT2_DATA0    = 6'h24;
localparam [5:0] RXBERT2_DATA1    = 6'h25;
localparam [5:0] RXBERT2_DATA2    = 6'h26;
localparam [5:0] RXBERT2_DATA3    = 6'h27;
localparam [5:0] RXBERT3_DATA0    = 6'h28;
localparam [5:0] RXBERT3_DATA1    = 6'h29;
localparam [5:0] RXBERT3_DATA2    = 6'h2a;
localparam [5:0] RXBERT3_DATA3    = 6'h2b;

reg        txbert_cmd_req; 
reg        rxbert_cmd_req; 
reg [ 5:0] acc_addr_ff;
reg        acc_rdwr_ff;
reg [31:0] wdata_ff; 
reg        tx_cmd_req_ff;
reg        rx_cmd_req_ff;

reg rx_cmd_ack_sync_ff;
reg tx_cmd_ack_sync_ff;
reg rx_rdata_sample_ff;
reg tx_rdata_sample_ff;

wire tx_cmd_busy;
wire rx_cmd_busy;
wire cmd_busy;
wire tx_cmd_ack_sync;
wire rx_cmd_ack_sync;
wire rx_rdata_sample;
wire tx_rdata_sample;


reg       txbert_status_req_ff;
reg [3:0] tx_bertgen_en_ff;
reg       txbert_status_ack_ff;
reg [3:0] tx_seed_good_ff;
reg [3:0] txst_seed_good_ff;
wire      txbert_st_update;
wire      txbert_status_req_sync;
wire      txbert_status_ack_sync;
wire      txbert_status_sample;

reg        rxbert_status_req_ff;
reg        rxbert_status_ack_ff;
reg  [3:0] rx_bertgen_en_ff;
reg  [3:0] rx_berterr_ff;
reg  [3:0] rx_biterr_ff;
wire [3:0] rx_biterr;
wire       rxbert_st_update;
wire       rxbert_status_req_sync;
wire       rxbert_status_ack_sync;
wire       rxbert_status_sample;


//------------------------------------------------------------------------------
//                   TX BERT clock domain (txfifo_wr_clk) logic
//------------------------------------------------------------------------------
wire        tx_cmd_req_sync;
wire        tx_cmd_sample;
wire [31:0] txcmc_read_data;

wire        seedp0_0_acc;
wire        seedp0_0_rd;
wire        seedp0_0_wr;
wire [ 3:0] seedp0_0_be;
wire [31:0] seedp0_0_rdata;

wire        seedp1_0_acc;
wire        seedp1_0_rd;
wire        seedp1_0_wr;
wire [ 3:0] seedp1_0_be;
wire [31:0] seedp1_0_rdata;

wire        seedp2_0_acc;
wire        seedp2_0_rd;
wire        seedp2_0_wr;
wire [ 3:0] seedp2_0_be;
wire [31:0] seedp2_0_rdata;

wire        seedp3_0_acc;
wire        seedp3_0_rd;
wire        seedp3_0_wr;
wire [ 3:0] seedp3_0_be;
wire [31:0] seedp3_0_rdata;

wire        seedp0_1_acc;
wire        seedp0_1_rd;
wire        seedp0_1_wr;
wire [ 3:0] seedp0_1_be;
wire [31:0] seedp0_1_rdata;

wire        seedp1_1_acc;
wire        seedp1_1_rd;
wire        seedp1_1_wr;
wire [ 3:0] seedp1_1_be;
wire [31:0] seedp1_1_rdata;

wire        seedp2_1_acc;
wire        seedp2_1_rd;
wire        seedp2_1_wr;
wire [ 3:0] seedp2_1_be;
wire [31:0] seedp2_1_rdata;

wire        seedp3_1_acc;
wire        seedp3_1_rd;
wire        seedp3_1_wr;
wire [ 3:0] seedp3_1_be;
wire [31:0] seedp3_1_rdata;

wire        seedp0_2_acc;
wire        seedp0_2_rd;
wire        seedp0_2_wr;
wire [ 3:0] seedp0_2_be;
wire [31:0] seedp0_2_rdata;

wire        seedp1_2_acc;
wire        seedp1_2_rd;
wire        seedp1_2_wr;
wire [ 3:0] seedp1_2_be;
wire [31:0] seedp1_2_rdata;

wire        seedp2_2_acc;
wire        seedp2_2_rd;
wire        seedp2_2_wr;
wire [ 3:0] seedp2_2_be;
wire [31:0] seedp2_2_rdata;

wire        seedp3_2_acc;
wire        seedp3_2_rd;
wire        seedp3_2_wr;
wire [ 3:0] seedp3_2_be;
wire [31:0] seedp3_2_rdata;

wire        seedp0_3_acc;
wire        seedp0_3_rd;
wire        seedp0_3_wr;
wire [ 3:0] seedp0_3_be;
wire [31:0] seedp0_3_rdata;

wire        seedp1_3_acc;
wire        seedp1_3_rd;
wire        seedp1_3_wr;
wire [ 3:0] seedp1_3_be;
wire [31:0] seedp1_3_rdata;

wire        seedp2_3_acc;
wire        seedp2_3_rd;
wire        seedp2_3_wr;
wire [ 3:0] seedp2_3_be;
wire [31:0] seedp2_3_rdata;

wire        seedp3_3_acc;
wire        seedp3_3_rd;
wire        seedp3_3_wr;
wire [ 3:0] seedp3_3_be;
wire [31:0] seedp3_3_rdata;

wire        gen_sel0_acc;
wire        gen_sel0_rd;
wire        gen_sel0_wr;
wire [ 3:0] gen_sel0_be;
wire [31:0] gen_sel0_rdata;

wire        gen_sel1_acc;
wire        gen_sel1_rd;
wire        gen_sel1_wr;
wire [ 3:0] gen_sel1_be;
wire [31:0] gen_sel1_rdata;

wire        gen_sel2_acc;
wire        gen_sel2_rd;
wire        gen_sel2_wr;
wire [ 1:0] gen_sel2_be;
wire [31:0] gen_sel2_rdata;

wire        gen_ptrn_sel_acc;
wire        gen_ptrn_sel_rd;
wire        gen_ptrn_sel_wr;
wire [ 3:0] gen_ptrn_sel_be;
wire [31:0] gen_ptrn_sel_rdata;

reg         tx_cmd_ack_ff;
reg         tx_cmd_sample_ff;
reg  [ 5:0] txacc_addr_sync_ff;
reg         txacc_rdwr_sync_ff;
reg  [31:0] txcmd_rdata_ff;

//------------------------------------------------------------------------------
//                        TX BERT Ccntrol interface
//------------------------------------------------------------------------------

wire tx_bert_start_req;
wire tx_bert_rst_req;
wire tx_bert_ctrl_req;
wire tx_bert_ctrl_ack_sync;
wire tx_bert_ctrl_req_sync;
wire tx_bert_ctrl_busy;

reg       tx_bert_ctrl_req_ff;
reg [3:0] tx_bert_start_ff;
reg [3:0] tx_bert_rst_ff;
reg       tx_bert_ctrl_ack_ff;
reg       tx_bert_ctrl_sample;
reg [3:0] tx_bert_start_sync_ff;
reg [3:0] tx_bert_rst_sync_ff;
reg       tx_bert_ctrl_sample_ff;

//------------------------------------------------------------------------------
//                        RX BERT Ccntrol interface
//------------------------------------------------------------------------------

wire rx_bert_start_req;
wire rx_bert_rst_req;
wire rx_bert_seedin_req;
wire rx_bert_ctrl_req;
wire rx_bert_ctrl_ack_sync;
wire rx_bert_ctrl_req_sync;
wire rx_bert_ctrl_busy;

reg       rx_bert_ctrl_req_ff;
reg [3:0] rx_bert_start_ff;
reg [3:0] rx_bert_rst_ff;
reg [3:0] rxbert_seed_in_ff;
reg       rx_bert_ctrl_ack_ff;
reg       rx_bert_ctrl_sample;
reg [3:0] rx_bert_start_sync_ff;
reg [3:0] rx_bert_rst_sync_ff;
reg [3:0] rxbert_seed_in_sync_ff;
reg       rx_bert_ctrl_sample_ff;

//------------------------------------------------------------------------------
//                   RX BERT clock domain (rxfifo_rd_clk) logic
//------------------------------------------------------------------------------
wire        rx_cmd_req_sync;
wire        rx_cmd_sample;
wire [31:0] rxcmc_read_data;

wire        rx_lane_sel_acc;
wire        rx_lane_sel_rd;
wire        rx_lane_sel_wr;
wire [ 3:0] rx_lane_sel_be;
wire [31:0] rx_lane_sel_rdata;

wire        chk_ptrn_sel_acc;
wire        chk_ptrn_sel_rd;
wire        chk_ptrn_sel_wr;
wire [ 3:0] chk_ptrn_sel_be;
wire [31:0] chk_ptrn_sel_rdata;

wire        rxbert_bitcnt_lo_acc;
wire        rxbert_bitcnt_lo_rd;
wire        rxbert_bitcnt_hi_acc;
wire        rxbert_bitcnt_hi_rd;
wire        errcnt_chk0_acc;
wire        errcnt_chk0_rd;
wire        errcnt_chk1_acc;
wire        errcnt_chk1_rd;
wire        errcnt_chk2_acc;
wire        errcnt_chk2_rd;
wire        errcnt_chk3_acc;
wire        errcnt_chk3_rd;

wire [31:0] biterr_cnt_chk0_rdata;
wire [31:0] biterr_cnt_chk1_rdata;
wire [31:0] biterr_cnt_chk2_rdata;
wire [31:0] biterr_cnt_chk3_rdata;

wire        rxbert0_data0_acc;
wire        rxbert0_data0_rd;
wire        rxbert0_data1_acc;
wire        rxbert0_data1_rd;
wire        rxbert0_data2_acc;
wire        rxbert0_data2_rd;
wire        rxbert0_data3_acc;
wire        rxbert0_data3_rd;
wire        rxbert1_data0_acc;
wire        rxbert1_data0_rd;
wire        rxbert1_data1_acc;
wire        rxbert1_data1_rd;
wire        rxbert1_data2_acc;
wire        rxbert1_data2_rd;
wire        rxbert1_data3_acc;
wire        rxbert1_data3_rd;
wire        rxbert2_data0_acc;
wire        rxbert2_data0_rd;
wire        rxbert2_data1_acc;
wire        rxbert2_data1_rd;
wire        rxbert2_data2_acc;
wire        rxbert2_data2_rd;
wire        rxbert2_data3_acc;
wire        rxbert2_data3_rd;
wire        rxbert3_data0_acc;
wire        rxbert3_data0_rd;
wire        rxbert3_data1_acc;
wire        rxbert3_data1_rd;
wire        rxbert3_data2_acc;
wire        rxbert3_data2_rd;
wire        rxbert3_data3_acc;
wire        rxbert3_data3_rd;
wire [95:0] rxbert_aux_rbuf_data;
wire        rx_bert_aux_buf_ld;
reg  [95:0] rxbert_aux_rbuf_ff;

reg        rx_cmd_ack_ff;
reg        rx_cmd_sample_ff;
reg [ 5:0] rxacc_addr_sync_ff;
reg        rxacc_rdwr_sync_ff;
reg [31:0] rxwdata_sync_ff;
reg [31:0] rxcmd_rdata_ff;

//------------------------------------------------------------------------------
//                        Avalon clock domain logic
//------------------------------------------------------------------------------

// TX BERT and RX BERT registers commands
always @(*)
  begin: tx_bert_rx_bert_reg_cmd_logic
    txbert_cmd_req = 1'b0;
    rxbert_cmd_req = 1'b0;
    case(bert_acc_addr[5:0])
      // Theses register should be transfered to TX BERT clock domain
      // (txfifo_wr_clk). Read and write access are allowed.
      SEEDP0_0,SEEDP1_0,SEEDP2_0,SEEDP3_0,
      SEEDP0_1,SEEDP1_1,SEEDP2_1,SEEDP3_1,
      SEEDP0_2,SEEDP1_2,SEEDP2_2,SEEDP3_2,
      SEEDP0_3,SEEDP1_3,SEEDP2_3,SEEDP3_3,
      GEN_SEL0,GEN_SEL1,GEN_SEL2,GEN_PTRN_SEL:
        begin
          if(bert_acc_req)
            begin
              txbert_cmd_req = 1'b1;
            end
        end
      // Theses register should be transfered to RX BERT clock domain
      // (rxfifo_rd_clk). Read and write access are allowed.
      RX_LANE_SEL,CHK_PTRN_SEL:
        begin
          if(bert_acc_req)
            begin
              rxbert_cmd_req = 1'b1;
            end
        end
      // Theses register should be transfered to RX BERT clock domain
      // (rxfifo_rd_clk). Read access are allowed only.
      RXBERT_BITCNT_LO,RXBERT_BITCNT_HI,
      ERRCNT_CHK0,ERRCNT_CHK1,ERRCNT_CHK2,ERRCNT_CHK3,
      RXBERT0_DATA0,RXBERT0_DATA1,RXBERT0_DATA2,RXBERT0_DATA3,
      RXBERT1_DATA0,RXBERT1_DATA1,RXBERT1_DATA2,RXBERT1_DATA3,
      RXBERT2_DATA0,RXBERT2_DATA1,RXBERT2_DATA2,RXBERT2_DATA3,
      RXBERT3_DATA0,RXBERT3_DATA1,RXBERT3_DATA2,RXBERT3_DATA3:
        begin
          rxbert_cmd_req = 1'b1;
        end
      default: // default
        begin
          txbert_cmd_req = 1'b0;
        end
    endcase
  end // block: tx_bert_rx_bert_reg_cmd_logic


aib_bit_sync tx_cmd_ack_sync_i(
.clk      (i_cfg_avmm_clk),   // clock
.rst_n    (i_cfg_avmm_rst_n), // async reset
.data_in  (tx_cmd_ack_ff),    // data in
.data_out (tx_cmd_ack_sync)   // data out
);

aib_bit_sync rx_cmd_ack_sync_i(
.clk      (i_cfg_avmm_clk),   // clock
.rst_n    (i_cfg_avmm_rst_n), // async reset
.data_in  (rx_cmd_ack_ff),    // data in
.data_out (rx_cmd_ack_sync)   // data out
);


assign tx_cmd_busy = tx_cmd_req_ff ^ tx_cmd_ack_sync;
assign rx_cmd_busy = rx_cmd_req_ff ^ rx_cmd_ack_sync;

assign cmd_busy = tx_cmd_busy | rx_cmd_busy;

assign bert_acc_rq_pend = cmd_busy           |
                          rx_rdata_sample_ff |
                          tx_rdata_sample_ff |
                          rx_rdata_sample    |
                          tx_rdata_sample;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        tx_cmd_req_ff <= 1'b0;
      end
    else if(!cmd_busy && txbert_cmd_req) // Command request
      begin
        tx_cmd_req_ff <= ~tx_cmd_req_ff;
      end
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        rx_cmd_req_ff <= 1'b0;
      end
    else if(!cmd_busy && rxbert_cmd_req) // Command request
      begin
        rx_cmd_req_ff <= ~rx_cmd_req_ff;
      end
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        acc_addr_ff[5:0] <= 6'h0;
        acc_rdwr_ff      <= 1'h0;
        wdata_ff[31:0]   <= 32'h0;
      end
    else if(!cmd_busy && (txbert_cmd_req || rxbert_cmd_req) )
      begin
        acc_addr_ff[5:0] <= bert_acc_addr[5:0];
        acc_rdwr_ff      <= bert_acc_rdwr;
        wdata_ff[31:0]   <= bert_wdata_ff[31:0];
      end
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      rx_cmd_ack_sync_ff <= 1'b0;
    else
      rx_cmd_ack_sync_ff <= rx_cmd_ack_sync;
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      tx_cmd_ack_sync_ff <= 1'b0;
    else
      tx_cmd_ack_sync_ff <= tx_cmd_ack_sync;
  end

assign rx_rdata_sample = rx_cmd_ack_sync ^ rx_cmd_ack_sync_ff;
assign tx_rdata_sample = tx_cmd_ack_sync ^ tx_cmd_ack_sync_ff;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      rx_rdata_sample_ff <= 1'b0;
    else
      rx_rdata_sample_ff <= rx_rdata_sample;
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      tx_rdata_sample_ff <= 1'b0;
    else
      tx_rdata_sample_ff <= tx_rdata_sample;
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      rx_bert_rdata_ff[31:0] <= 32'b0;
    else if(rx_rdata_sample_ff && acc_rdwr_ff)
      rx_bert_rdata_ff[31:0] <= rxcmd_rdata_ff[31:0];
  end

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      tx_bert_rdata_ff[31:0] <= 32'b0;
    else if(tx_rdata_sample_ff && acc_rdwr_ff)
      tx_bert_rdata_ff[31:0] <= txcmd_rdata_ff[31:0];
  end

//------------------------------------------------------------------------------
//                   TX BERT clock domain (txfifo_wr_clk) logic
//------------------------------------------------------------------------------

aib_bit_sync tx_cmd_req_sync_i(
.clk      (txfifo_wr_clk),       // clock
.rst_n    (txwr_rstn),      // async reset
.data_in  (tx_cmd_req_ff),  // data in
.data_out (tx_cmd_req_sync) // data out
);

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      tx_cmd_ack_ff <= 1'b0;
    else if(tx_cmd_sample_ff)
      tx_cmd_ack_ff <= tx_cmd_req_sync;
  end

assign tx_cmd_sample = tx_cmd_req_sync ^ tx_cmd_ack_ff;

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      tx_cmd_sample_ff <= 1'b0;
    else
      tx_cmd_sample_ff <= tx_cmd_sample;
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        txacc_addr_sync_ff[5:0] <= 6'b0;
        txacc_rdwr_sync_ff      <= 1'b0;
        txwdata_sync_ff[31:0]   <= 31'b0;
      end  
    else if(tx_cmd_sample)
      begin
        txacc_addr_sync_ff[5:0] <= acc_addr_ff[5:0];
        txacc_rdwr_sync_ff      <= acc_rdwr_ff;
        txwdata_sync_ff[31:0]   <= wdata_ff[31:0];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      txcmd_rdata_ff[31:0] <= 32'h0;
    else if(tx_cmd_sample_ff && txacc_rdwr_sync_ff)
      txcmd_rdata_ff[31:0] <= txcmc_read_data[31:0];
  end

//------------ SEEDP0_0 register implementation ------------------------------

assign seedp0_0_acc = (txacc_addr_sync_ff[5:0] == SEEDP0_0[5:0]) &
                         tx_cmd_sample_ff;

assign seedp0_0_rd = seedp0_0_acc   &  txacc_rdwr_sync_ff;
assign seedp0_0_wr = seedp0_0_acc   & ~txacc_rdwr_sync_ff;

assign seedp0_0_be[3:0] = {4{seedp0_0_wr & BERT_BUF_MODE_EN}};

assign seedp0_0_rdata[31:0] = 32'h0;

//------------ SEEDP1_0 register implementation ------------------------------

assign seedp1_0_acc = (txacc_addr_sync_ff[5:0] == SEEDP1_0[5:0]) &
                         tx_cmd_sample_ff;

assign seedp1_0_rd = seedp1_0_acc   &  txacc_rdwr_sync_ff;
assign seedp1_0_wr = seedp1_0_acc   & ~txacc_rdwr_sync_ff;

assign seedp1_0_be[3:0] = {4{seedp1_0_wr & BERT_BUF_MODE_EN}};

assign seedp1_0_rdata[31:0] = 32'h0;

//------------ SEEDP2_0 register implementation ------------------------------

assign seedp2_0_acc = (txacc_addr_sync_ff[5:0] == SEEDP2_0[5:0]) &
                         tx_cmd_sample_ff;

assign seedp2_0_rd = seedp2_0_acc   &  txacc_rdwr_sync_ff;
assign seedp2_0_wr = seedp2_0_acc   & ~txacc_rdwr_sync_ff;

assign seedp2_0_be[3:0] = {4{seedp2_0_wr & BERT_BUF_MODE_EN}};

assign seedp2_0_rdata[31:0] = 32'h0;

//------------ SEEDP3_0 register implementation ------------------------------

assign seedp3_0_acc = (txacc_addr_sync_ff[5:0] == SEEDP3_0[5:0]) &
                         tx_cmd_sample_ff;

assign seedp3_0_rd = seedp3_0_acc   &  txacc_rdwr_sync_ff;
assign seedp3_0_wr = seedp3_0_acc   & ~txacc_rdwr_sync_ff;

assign seedp3_0_be[3:0] = {4{seedp3_0_wr}};

assign seedp3_0_rdata[31:0] = 32'h0;

//------------ SEEDP0_1 register implementation ------------------------------

assign seedp0_1_acc = (txacc_addr_sync_ff[5:0] == SEEDP0_1[5:0]) &
                         tx_cmd_sample_ff;

assign seedp0_1_rd = seedp0_1_acc   &  txacc_rdwr_sync_ff;
assign seedp0_1_wr = seedp0_1_acc   & ~txacc_rdwr_sync_ff;

assign seedp0_1_be[3:0] = {4{seedp0_1_wr & BERT_BUF_MODE_EN}};

assign seedp0_1_rdata[31:0] = 32'h0;

//------------ SEEDP1_1 register implementation ------------------------------

assign seedp1_1_acc = (txacc_addr_sync_ff[5:0] == SEEDP1_1[5:0]) &
                         tx_cmd_sample_ff;

assign seedp1_1_rd = seedp1_1_acc   &  txacc_rdwr_sync_ff;
assign seedp1_1_wr = seedp1_1_acc   & ~txacc_rdwr_sync_ff;

assign seedp1_1_be[3:0] = {4{seedp1_1_wr & BERT_BUF_MODE_EN}};

assign seedp1_1_rdata[31:0] = 32'h0;

//------------ SEEDP2_1 register implementation ------------------------------

assign seedp2_1_acc = (txacc_addr_sync_ff[5:0] == SEEDP2_1[5:0]) &
                         tx_cmd_sample_ff;

assign seedp2_1_rd = seedp2_1_acc   &  txacc_rdwr_sync_ff;
assign seedp2_1_wr = seedp2_1_acc   & ~txacc_rdwr_sync_ff;

assign seedp2_1_be[3:0] = {4{seedp2_1_wr & BERT_BUF_MODE_EN}};

assign seedp2_1_rdata[31:0] = 32'h0;

//------------ SEEDP3_1 register implementation ------------------------------

assign seedp3_1_acc = (txacc_addr_sync_ff[5:0] == SEEDP3_1[5:0]) &
                         tx_cmd_sample_ff;

assign seedp3_1_rd = seedp3_1_acc   &  txacc_rdwr_sync_ff;
assign seedp3_1_wr = seedp3_1_acc   & ~txacc_rdwr_sync_ff;

assign seedp3_1_be[3:0] = {4{seedp3_1_wr}};

assign seedp3_1_rdata[31:0] = 32'h0;

//------------ SEEDP0_2 register implementation ------------------------------

assign seedp0_2_acc = (txacc_addr_sync_ff[5:0] == SEEDP0_2[5:0]) &
                         tx_cmd_sample_ff;

assign seedp0_2_rd = seedp0_2_acc   &  txacc_rdwr_sync_ff;
assign seedp0_2_wr = seedp0_2_acc   & ~txacc_rdwr_sync_ff;

assign seedp0_2_be[3:0] = {4{seedp0_2_wr & BERT_BUF_MODE_EN}};

assign seedp0_2_rdata[31:0] = 32'h0;

//------------ SEEDP1_2 register implementation ------------------------------

assign seedp1_2_acc = (txacc_addr_sync_ff[5:0] == SEEDP1_2[5:0]) &
                         tx_cmd_sample_ff;

assign seedp1_2_rd = seedp1_2_acc   &  txacc_rdwr_sync_ff;
assign seedp1_2_wr = seedp1_2_acc   & ~txacc_rdwr_sync_ff;

assign seedp1_2_be[3:0] = {4{seedp1_2_wr & BERT_BUF_MODE_EN}};

assign seedp1_2_rdata[31:0] = 32'h0;

//------------ SEEDP2_2 register implementation ------------------------------

assign seedp2_2_acc = (txacc_addr_sync_ff[5:0] == SEEDP2_2[5:0]) &
                         tx_cmd_sample_ff;

assign seedp2_2_rd = seedp2_2_acc   &  txacc_rdwr_sync_ff;
assign seedp2_2_wr = seedp2_2_acc   & ~txacc_rdwr_sync_ff;

assign seedp2_2_be[3:0] = {4{seedp2_2_wr & BERT_BUF_MODE_EN}};

assign seedp2_2_rdata[31:0] = 32'h0;

//------------ SEEDP3_2 register implementation ------------------------------

assign seedp3_2_acc = (txacc_addr_sync_ff[5:0] == SEEDP3_2[5:0]) &
                         tx_cmd_sample_ff;

assign seedp3_2_rd = seedp3_2_acc   &  txacc_rdwr_sync_ff;
assign seedp3_2_wr = seedp3_2_acc   & ~txacc_rdwr_sync_ff;

assign seedp3_2_be[3:0] = {4{seedp3_2_wr}};

assign seedp3_2_rdata[31:0] = 32'h0;


//------------ SEEDP0_3 register implementation ------------------------------

assign seedp0_3_acc = (txacc_addr_sync_ff[5:0] == SEEDP0_3[5:0]) &
                         tx_cmd_sample_ff;

assign seedp0_3_rd = seedp0_3_acc   &  txacc_rdwr_sync_ff;
assign seedp0_3_wr = seedp0_3_acc   & ~txacc_rdwr_sync_ff;

assign seedp0_3_be[3:0] = {4{seedp0_3_wr & BERT_BUF_MODE_EN}};

assign seedp0_3_rdata[31:0] = 32'h0;

//------------ SEEDP1_3 register implementation ------------------------------

assign seedp1_3_acc = (txacc_addr_sync_ff[5:0] == SEEDP1_3[5:0]) &
                         tx_cmd_sample_ff;

assign seedp1_3_rd = seedp1_3_acc   &  txacc_rdwr_sync_ff;
assign seedp1_3_wr = seedp1_3_acc   & ~txacc_rdwr_sync_ff;

assign seedp1_3_be[3:0] = {4{seedp1_3_wr & BERT_BUF_MODE_EN}};

assign seedp1_3_rdata[31:0] = 32'h0;

//------------ SEEDP2_3 register implementation ------------------------------

assign seedp2_3_acc = (txacc_addr_sync_ff[5:0] == SEEDP2_3[5:0]) &
                         tx_cmd_sample_ff;

assign seedp2_3_rd = seedp2_3_acc   &  txacc_rdwr_sync_ff;
assign seedp2_3_wr = seedp2_3_acc   & ~txacc_rdwr_sync_ff;

assign seedp2_3_be[3:0] = {4{seedp2_3_wr & BERT_BUF_MODE_EN}};

assign seedp2_3_rdata[31:0] = 32'h0;

//------------ SEEDP3_3 register implementation ------------------------------

assign seedp3_3_acc = (txacc_addr_sync_ff[5:0] == SEEDP3_3[5:0]) &
                         tx_cmd_sample_ff;

assign seedp3_3_rd = seedp3_3_acc   &  txacc_rdwr_sync_ff;
assign seedp3_3_wr = seedp3_3_acc   & ~txacc_rdwr_sync_ff;

assign seedp3_3_be[3:0] = {4{seedp3_3_wr}};

assign seedp3_3_rdata[31:0] = 32'h0;


//------------ GEN_SEL0   register implementation -----------------------------

assign gen_sel0_acc = (txacc_addr_sync_ff[5:0] == GEN_SEL0[5:0]) &
                        tx_cmd_sample_ff;

assign gen_sel0_rd = gen_sel0_acc   &  txacc_rdwr_sync_ff;
assign gen_sel0_wr = gen_sel0_acc   & ~txacc_rdwr_sync_ff;

assign gen_sel0_be[3:0] = {4{gen_sel0_wr}};

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane0_gen_sel_ff[1:0] <= 2'b00;
        lane1_gen_sel_ff[1:0] <= 2'b00;
        lane2_gen_sel_ff[1:0] <= 2'b00;
        lane3_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel0_be[0])
      begin
        lane0_gen_sel_ff[1:0] <= txwdata_sync_ff[1:0];
        lane1_gen_sel_ff[1:0] <= txwdata_sync_ff[3:2];
        lane2_gen_sel_ff[1:0] <= txwdata_sync_ff[5:4];
        lane3_gen_sel_ff[1:0] <= txwdata_sync_ff[7:6];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane4_gen_sel_ff[1:0] <= 2'b00;
        lane5_gen_sel_ff[1:0] <= 2'b00;
        lane6_gen_sel_ff[1:0] <= 2'b00;
        lane7_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel0_be[1])
      begin
        lane4_gen_sel_ff[1:0] <= txwdata_sync_ff[9:8];
        lane5_gen_sel_ff[1:0] <= txwdata_sync_ff[11:10];
        lane6_gen_sel_ff[1:0] <= txwdata_sync_ff[13:12];
        lane7_gen_sel_ff[1:0] <= txwdata_sync_ff[15:14];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane8_gen_sel_ff[1:0]  <= 2'b00;
        lane9_gen_sel_ff[1:0]  <= 2'b00;
        lane10_gen_sel_ff[1:0] <= 2'b00;
        lane11_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel0_be[2])
      begin
        lane8_gen_sel_ff[1:0]  <= txwdata_sync_ff[17:16];
        lane9_gen_sel_ff[1:0]  <= txwdata_sync_ff[19:18];
        lane10_gen_sel_ff[1:0] <= txwdata_sync_ff[21:20];
        lane11_gen_sel_ff[1:0] <= txwdata_sync_ff[23:22];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane12_gen_sel_ff[1:0] <= 2'b00;
        lane13_gen_sel_ff[1:0] <= 2'b00;
        lane14_gen_sel_ff[1:0] <= 2'b00;
        lane15_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel0_be[3])
      begin
        lane12_gen_sel_ff[1:0] <= txwdata_sync_ff[25:24];
        lane13_gen_sel_ff[1:0] <= txwdata_sync_ff[27:26];
        lane14_gen_sel_ff[1:0] <= txwdata_sync_ff[29:28];
        lane15_gen_sel_ff[1:0] <= txwdata_sync_ff[31:30];
      end
  end

assign gen_sel0_rdata[31:0] = { lane15_gen_sel_ff[1:0],
                                lane14_gen_sel_ff[1:0],
                                lane13_gen_sel_ff[1:0],
                                lane12_gen_sel_ff[1:0],
                                lane11_gen_sel_ff[1:0],
                                lane10_gen_sel_ff[1:0],
                                lane9_gen_sel_ff[1:0],
                                lane8_gen_sel_ff[1:0],
                                lane7_gen_sel_ff[1:0],
                                lane6_gen_sel_ff[1:0],
                                lane5_gen_sel_ff[1:0],
                                lane4_gen_sel_ff[1:0],
                                lane3_gen_sel_ff[1:0],
                                lane2_gen_sel_ff[1:0],
                                lane1_gen_sel_ff[1:0],
                                lane0_gen_sel_ff[1:0]  };

//------------ GEN_SEL1   register implementation -----------------------------

assign gen_sel1_acc = (txacc_addr_sync_ff[5:0] == GEN_SEL1[5:0]) &
                        tx_cmd_sample_ff;

assign gen_sel1_rd = gen_sel1_acc   &  txacc_rdwr_sync_ff;
assign gen_sel1_wr = gen_sel1_acc   & ~txacc_rdwr_sync_ff;

assign gen_sel1_be[3:0] = {4{gen_sel1_wr}};

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane16_gen_sel_ff[1:0] <= 2'b00;
        lane17_gen_sel_ff[1:0] <= 2'b00;
        lane18_gen_sel_ff[1:0] <= 2'b00;
        lane19_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel1_be[0])
      begin
        lane16_gen_sel_ff[1:0] <= txwdata_sync_ff[1:0];
        lane17_gen_sel_ff[1:0] <= txwdata_sync_ff[3:2];
        lane18_gen_sel_ff[1:0] <= txwdata_sync_ff[5:4];
        lane19_gen_sel_ff[1:0] <= txwdata_sync_ff[7:6];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane20_gen_sel_ff[1:0] <= 2'b00;
        lane21_gen_sel_ff[1:0] <= 2'b00;
        lane22_gen_sel_ff[1:0] <= 2'b00;
        lane23_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel1_be[1])
      begin
        lane20_gen_sel_ff[1:0] <= txwdata_sync_ff[9:8];
        lane21_gen_sel_ff[1:0] <= txwdata_sync_ff[11:10];
        lane22_gen_sel_ff[1:0] <= txwdata_sync_ff[13:12];
        lane23_gen_sel_ff[1:0] <= txwdata_sync_ff[15:14];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane24_gen_sel_ff[1:0] <= 2'b00;
        lane25_gen_sel_ff[1:0] <= 2'b00;
        lane26_gen_sel_ff[1:0] <= 2'b00;
        lane27_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel1_be[2])
      begin
        lane24_gen_sel_ff[1:0] <= txwdata_sync_ff[17:16];
        lane25_gen_sel_ff[1:0] <= txwdata_sync_ff[19:18];
        lane26_gen_sel_ff[1:0] <= txwdata_sync_ff[21:20];
        lane27_gen_sel_ff[1:0] <= txwdata_sync_ff[23:22];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane28_gen_sel_ff[1:0]  <= 2'b00;
        lane29_gen_sel_ff[1:0]  <= 2'b00;
        lane30_gen_sel_ff[1:0]  <= 2'b00;
        lane31_gen_sel_ff[1:0]  <= 2'b00;
      end
    else if(gen_sel1_be[3])
      begin
        lane28_gen_sel_ff[1:0]  <= txwdata_sync_ff[25:24];
        lane29_gen_sel_ff[1:0]  <= txwdata_sync_ff[27:26];
        lane30_gen_sel_ff[1:0]  <= txwdata_sync_ff[29:28];
        lane31_gen_sel_ff[1:0]  <= txwdata_sync_ff[31:30];
      end
  end

assign gen_sel1_rdata[31:0] = { lane31_gen_sel_ff[1:0],
                                lane30_gen_sel_ff[1:0],
                                lane29_gen_sel_ff[1:0],
                                lane28_gen_sel_ff[1:0],
                                lane27_gen_sel_ff[1:0],
                                lane26_gen_sel_ff[1:0],
                                lane25_gen_sel_ff[1:0],
                                lane24_gen_sel_ff[1:0],
                                lane23_gen_sel_ff[1:0],
                                lane22_gen_sel_ff[1:0],
                                lane21_gen_sel_ff[1:0],
                                lane20_gen_sel_ff[1:0],
                                lane19_gen_sel_ff[1:0],
                                lane18_gen_sel_ff[1:0],
                                lane17_gen_sel_ff[1:0],
                                lane16_gen_sel_ff[1:0]  };

//------------ GEN_SEL2   register implementation -----------------------------

assign gen_sel2_acc = (txacc_addr_sync_ff[5:0] == GEN_SEL2[5:0]) &
                        tx_cmd_sample_ff;

assign gen_sel2_rd = gen_sel2_acc   &  txacc_rdwr_sync_ff;
assign gen_sel2_wr = gen_sel2_acc   & ~txacc_rdwr_sync_ff;

assign gen_sel2_be[1:0] = {2{gen_sel2_wr}};

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane32_gen_sel_ff[1:0] <= 2'b00;
        lane33_gen_sel_ff[1:0] <= 2'b00;
        lane34_gen_sel_ff[1:0] <= 2'b00;
        lane35_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel2_be[0])
      begin
        lane32_gen_sel_ff[1:0] <= txwdata_sync_ff[1:0];
        lane33_gen_sel_ff[1:0] <= txwdata_sync_ff[3:2];
        lane34_gen_sel_ff[1:0] <= txwdata_sync_ff[5:4];
        lane35_gen_sel_ff[1:0] <= txwdata_sync_ff[7:6];
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        lane36_gen_sel_ff[1:0] <= 2'b00;
        lane37_gen_sel_ff[1:0] <= 2'b00;
        lane38_gen_sel_ff[1:0] <= 2'b00;
        lane39_gen_sel_ff[1:0] <= 2'b00;
      end
    else if(gen_sel2_be[1])
      begin
        lane36_gen_sel_ff[1:0] <= txwdata_sync_ff[9:8];
        lane37_gen_sel_ff[1:0] <= txwdata_sync_ff[11:10];
        lane38_gen_sel_ff[1:0] <= txwdata_sync_ff[13:12];
        lane39_gen_sel_ff[1:0] <= txwdata_sync_ff[15:14];
      end
  end

assign gen_sel2_rdata[31:0] = { 16'h0,
                                lane39_gen_sel_ff[1:0],
                                lane38_gen_sel_ff[1:0],
                                lane37_gen_sel_ff[1:0],
                                lane36_gen_sel_ff[1:0],
                                lane35_gen_sel_ff[1:0],
                                lane34_gen_sel_ff[1:0],
                                lane33_gen_sel_ff[1:0],
                                lane32_gen_sel_ff[1:0]  };

//------------ GEN_PTRN_SEL   register implementation --------------------------

assign gen_ptrn_sel_acc = (txacc_addr_sync_ff[5:0] == GEN_PTRN_SEL[5:0]) &
                           tx_cmd_sample_ff;

assign gen_ptrn_sel_rd = gen_ptrn_sel_acc  &  txacc_rdwr_sync_ff;
assign gen_ptrn_sel_wr = gen_ptrn_sel_acc  & ~txacc_rdwr_sync_ff;

assign gen_ptrn_sel_be[3:0] = {4{gen_ptrn_sel_wr}};

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        gen0_ptrn_sel_ff[2:0] <= 3'b000;
      end
    else if(gen_ptrn_sel_be[0])
      begin
        gen0_ptrn_sel_ff[2:0]  <= txwdata_sync_ff[2:0] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        gen1_ptrn_sel_ff[2:0] <= 3'b000;
      end
    else if(gen_ptrn_sel_be[1])
      begin
        gen1_ptrn_sel_ff[2:0]  <= txwdata_sync_ff[10:8] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        gen2_ptrn_sel_ff[2:0] <= 3'b000;
      end
    else if(gen_ptrn_sel_be[2])
      begin
        gen2_ptrn_sel_ff[2:0]  <= txwdata_sync_ff[18:16] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        gen3_ptrn_sel_ff[2:0] <= 3'b000;
      end
    else if(gen_ptrn_sel_be[3])
      begin
        gen3_ptrn_sel_ff[2:0]  <= txwdata_sync_ff[26:24] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

assign gen_ptrn_sel_rdata[31:0] = { 5'h0,
                                    gen3_ptrn_sel_ff[2:0],
                                    5'h0,
                                    gen2_ptrn_sel_ff[2:0],
                                    5'h0,
                                    gen1_ptrn_sel_ff[2:0],
                                    5'h0,
                                    gen0_ptrn_sel_ff[2:0] };



//------------       TX BERT read data logic       -----------------------------

assign txcmc_read_data[31:0] = 
             (seedp0_0_rd     ? seedp0_0_rdata[31:0]     : 32'h0) |
             (seedp1_0_rd     ? seedp1_0_rdata[31:0]     : 32'h0) |
             (seedp2_0_rd     ? seedp2_0_rdata[31:0]     : 32'h0) |
             (seedp3_0_rd     ? seedp3_0_rdata[31:0]     : 32'h0) |
             (seedp0_1_rd     ? seedp0_1_rdata[31:0]     : 32'h0) |
             (seedp1_1_rd     ? seedp1_1_rdata[31:0]     : 32'h0) |
             (seedp2_1_rd     ? seedp2_1_rdata[31:0]     : 32'h0) |
             (seedp3_1_rd     ? seedp3_1_rdata[31:0]     : 32'h0) |
             (seedp0_2_rd     ? seedp0_2_rdata[31:0]     : 32'h0) |
             (seedp1_2_rd     ? seedp1_2_rdata[31:0]     : 32'h0) |
             (seedp2_2_rd     ? seedp2_2_rdata[31:0]     : 32'h0) |
             (seedp3_2_rd     ? seedp3_2_rdata[31:0]     : 32'h0) |
             (seedp0_3_rd     ? seedp0_3_rdata[31:0]     : 32'h0) |
             (seedp1_3_rd     ? seedp1_3_rdata[31:0]     : 32'h0) |
             (seedp2_3_rd     ? seedp2_3_rdata[31:0]     : 32'h0) |
             (seedp3_3_rd     ? seedp3_3_rdata[31:0]     : 32'h0) |
             (gen_sel0_rd     ? gen_sel0_rdata[31:0]     : 32'h0) |
             (gen_sel1_rd     ? gen_sel1_rdata[31:0]     : 32'h0) |
             (gen_sel2_rd     ? gen_sel2_rdata[31:0]     : 32'h0) |
             (gen_ptrn_sel_rd ? gen_ptrn_sel_rdata[31:0] : 32'h0); 

//-------------------  TX BERT load logic --------------------------------------


assign seed_ld_0[15:0] = { seedp3_0_be[3:0],
                           seedp2_0_be[3:0],
                           seedp1_0_be[3:0],
                           seedp0_0_be[3:0] };

assign seed_ld_1[15:0] = { seedp3_1_be[3:0],
                           seedp2_1_be[3:0],
                           seedp1_1_be[3:0],
                           seedp0_1_be[3:0] };

assign seed_ld_2[15:0] = { seedp3_2_be[3:0],
                           seedp2_2_be[3:0],
                           seedp1_2_be[3:0],
                           seedp0_2_be[3:0] };

assign seed_ld_3[15:0] = { seedp3_3_be[3:0],
                           seedp2_3_be[3:0],
                           seedp1_3_be[3:0],
                           seedp0_3_be[3:0] };

//------------------------------------------------------------------------------
//                   RX BERT clock domain (rxfifo_rd_clk) logic
//------------------------------------------------------------------------------

aib_bit_sync rx_cmd_req_sync_i(
.clk      (rxfifo_rd_clk),       // clock
.rst_n    (rxrd_rstn),      // async reset
.data_in  (rx_cmd_req_ff),  // data in
.data_out (rx_cmd_req_sync) // data out
);

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      rx_cmd_ack_ff <= 1'b0;
    else if(rx_cmd_sample_ff)
      rx_cmd_ack_ff <= rx_cmd_req_sync;
  end

assign rx_cmd_sample = rx_cmd_req_sync ^ rx_cmd_ack_ff;

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      rx_cmd_sample_ff <= 1'b0;
    else
      rx_cmd_sample_ff <= rx_cmd_sample;
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        rxacc_addr_sync_ff[5:0] <= 6'b0;
        rxacc_rdwr_sync_ff      <= 1'b0;
        rxwdata_sync_ff[31:0]   <= 32'h0;
      end  
    else if(rx_cmd_sample)
      begin
        rxacc_addr_sync_ff[5:0] <= acc_addr_ff[5:0];
        rxacc_rdwr_sync_ff      <= acc_rdwr_ff;
        rxwdata_sync_ff[31:0]   <= wdata_ff[31:0];
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      rxcmd_rdata_ff[31:0] <= 32'h0;
    else if(rx_cmd_sample_ff && rxacc_rdwr_sync_ff)
      rxcmd_rdata_ff[31:0] <= rxcmc_read_data[31:0];
  end

// RX BERT configuration registers

// RX_LANE_SEL register -----------------------------------------------------------

assign rx_lane_sel_acc = (rxacc_addr_sync_ff[5:0] == RX_LANE_SEL[5:0]) &
                          rx_cmd_sample_ff;

assign rx_lane_sel_rd  = rx_lane_sel_acc  &  rxacc_rdwr_sync_ff;
assign rx_lane_sel_wr  = rx_lane_sel_acc  & ~rxacc_rdwr_sync_ff;

assign rx_lane_sel_be[3:0] = {4{rx_lane_sel_wr}};

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk0_lane_sel_ff[5:0] <= 6'h00;
      end
    else if(rx_lane_sel_be[0])
      begin
        chk0_lane_sel_ff[5:0] <= rxwdata_sync_ff[5:0];
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk1_lane_sel_ff[5:0] <= 6'h00;
      end
    else if(rx_lane_sel_be[1])
      begin
        chk1_lane_sel_ff[5:0] <= rxwdata_sync_ff[13:8];
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk2_lane_sel_ff[5:0] <= 6'h00;
      end
    else if(rx_lane_sel_be[2])
      begin
        chk2_lane_sel_ff[5:0] <= rxwdata_sync_ff[21:16];
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk3_lane_sel_ff[5:0] <= 6'h00;
      end
    else if(rx_lane_sel_be[3])
      begin
        chk3_lane_sel_ff[5:0] <= rxwdata_sync_ff[29:24];
      end
  end

assign rx_lane_sel_rdata[31:0] = { 2'h0,
                                   chk3_lane_sel_ff[5:0],
                                   2'h0,
                                   chk2_lane_sel_ff[5:0],
                                   2'h0,
                                   chk1_lane_sel_ff[5:0],
                                   2'h0,
                                   chk0_lane_sel_ff[5:0] };

// CHK_PTRN_SEL register -----------------------------------------------------------

assign chk_ptrn_sel_acc = (rxacc_addr_sync_ff[5:0] == CHK_PTRN_SEL[5:0]) &
                          rx_cmd_sample_ff;

assign chk_ptrn_sel_rd  = chk_ptrn_sel_acc  &  rxacc_rdwr_sync_ff;
assign chk_ptrn_sel_wr  = chk_ptrn_sel_acc  & ~rxacc_rdwr_sync_ff;

assign chk_ptrn_sel_be[3:0] = {4{chk_ptrn_sel_wr}};

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk0_ptrn_sel_ff[2:0] <= 3'h0;
      end
    else if(chk_ptrn_sel_be[0])
      begin
        chk0_ptrn_sel_ff[2:0] <= rxwdata_sync_ff[2:0] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk1_ptrn_sel_ff[2:0] <= 3'h0;
      end
    else if(chk_ptrn_sel_be[1])
      begin
        chk1_ptrn_sel_ff[2:0] <= rxwdata_sync_ff[10:8] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk2_ptrn_sel_ff[2:0] <= 3'h0;
      end
    else if(chk_ptrn_sel_be[2])
      begin
        chk2_ptrn_sel_ff[2:0] <= rxwdata_sync_ff[18:16] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        chk3_ptrn_sel_ff[2:0] <= 3'h0;
      end
    else if(chk_ptrn_sel_be[3])
      begin
        chk3_ptrn_sel_ff[2:0] <= rxwdata_sync_ff[26:24] & {BERT_BUF_MODE_EN,2'b11};
      end
  end

assign chk_ptrn_sel_rdata[31:0] = { 5'h0,
                                    chk3_ptrn_sel_ff[2:0],
                                    5'h0,
                                    chk2_ptrn_sel_ff[2:0],
                                    5'h0,
                                    chk1_ptrn_sel_ff[2:0],
                                    5'h0,
                                    chk0_ptrn_sel_ff[2:0] };

// RXBERT_BITCNT_LO register -------------------------------------------------------

assign rxbert_bitcnt_lo_acc = (rxacc_addr_sync_ff[5:0] == RXBERT_BITCNT_LO[5:0]) &
                              rx_cmd_sample_ff;

assign rxbert_bitcnt_lo_rd  =  rxbert_bitcnt_lo_acc & rxacc_rdwr_sync_ff;

// RXBERT_BITCNT_HI register -------------------------------------------------------

assign rxbert_bitcnt_hi_acc = (rxacc_addr_sync_ff[5:0] == RXBERT_BITCNT_HI[5:0]) &
                              rx_cmd_sample_ff;

assign rxbert_bitcnt_hi_rd  =  rxbert_bitcnt_hi_acc & rxacc_rdwr_sync_ff;

// ERRCNT_CHK0 register -------------------------------------------------------

assign errcnt_chk0_acc = (rxacc_addr_sync_ff[5:0] == ERRCNT_CHK0[5:0]) &
                           rx_cmd_sample_ff;

assign errcnt_chk0_rd  =  errcnt_chk0_acc & rxacc_rdwr_sync_ff;

assign biterr_cnt_chk0_rdata[31:0] = {16'h0,biterr_cnt_chk0[15:0]};

// ERRCNT_CHK1 register ------------------------------------------------------

assign errcnt_chk1_acc = (rxacc_addr_sync_ff[5:0] == ERRCNT_CHK1[5:0]) &
                           rx_cmd_sample_ff;

assign errcnt_chk1_rd  =  errcnt_chk1_acc & rxacc_rdwr_sync_ff;

assign biterr_cnt_chk1_rdata[31:0] = {16'h0,biterr_cnt_chk1[15:0]};

// ERRCNT_CHK2 register ------------------------------------------------------

assign errcnt_chk2_acc = (rxacc_addr_sync_ff[5:0] == ERRCNT_CHK2[5:0]) &
                           rx_cmd_sample_ff;

assign errcnt_chk2_rd  =  errcnt_chk2_acc & rxacc_rdwr_sync_ff;

assign biterr_cnt_chk2_rdata[31:0] = {16'h0,biterr_cnt_chk2[15:0]};

// ERRCNT_CHK3 register --------------------------------------------------------

assign errcnt_chk3_acc = (rxacc_addr_sync_ff[5:0] == ERRCNT_CHK3[5:0]) &
                           rx_cmd_sample_ff;

assign errcnt_chk3_rd  =  errcnt_chk3_acc & rxacc_rdwr_sync_ff;

assign biterr_cnt_chk3_rdata[31:0] = {16'h0,biterr_cnt_chk3[15:0]};

// RXBERT0_DATA0 register -----------------------------------------------------
assign rxbert0_data0_acc = (rxacc_addr_sync_ff[5:0] == RXBERT0_DATA0[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert0_data0_rd  =  rxbert0_data0_acc & rxacc_rdwr_sync_ff;

// RXBERT0_DATA1 register -----------------------------------------------------
assign rxbert0_data1_acc = (rxacc_addr_sync_ff[5:0] == RXBERT0_DATA1[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert0_data1_rd  =  rxbert0_data1_acc & rxacc_rdwr_sync_ff;

// RXBERT0_DATA2 register -----------------------------------------------------
assign rxbert0_data2_acc = (rxacc_addr_sync_ff[5:0] == RXBERT0_DATA2[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert0_data2_rd  =  rxbert0_data2_acc & rxacc_rdwr_sync_ff;

// RXBERT0_DATA3 register -----------------------------------------------------
assign rxbert0_data3_acc = (rxacc_addr_sync_ff[5:0] == RXBERT0_DATA3[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert0_data3_rd  =  rxbert0_data3_acc & rxacc_rdwr_sync_ff;

// RXBERT1_DATA0 register -----------------------------------------------------
assign rxbert1_data0_acc = (rxacc_addr_sync_ff[5:0] == RXBERT1_DATA0[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert1_data0_rd  =  rxbert1_data0_acc & rxacc_rdwr_sync_ff;

// RXBERT1_DATA1 register -----------------------------------------------------
assign rxbert1_data1_acc = (rxacc_addr_sync_ff[5:0] == RXBERT1_DATA1[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert1_data1_rd  =  rxbert1_data1_acc & rxacc_rdwr_sync_ff;

// RXBERT1_DATA2 register -----------------------------------------------------
assign rxbert1_data2_acc = (rxacc_addr_sync_ff[5:0] == RXBERT1_DATA2[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert1_data2_rd  =  rxbert1_data2_acc & rxacc_rdwr_sync_ff;

// RXBERT1_DATA3 register -----------------------------------------------------
assign rxbert1_data3_acc = (rxacc_addr_sync_ff[5:0] == RXBERT1_DATA3[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert1_data3_rd  =  rxbert1_data3_acc & rxacc_rdwr_sync_ff;

// RXBERT2_DATA0 register -----------------------------------------------------
assign rxbert2_data0_acc = (rxacc_addr_sync_ff[5:0] == RXBERT2_DATA0[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert2_data0_rd  =  rxbert2_data0_acc & rxacc_rdwr_sync_ff;

// RXBERT2_DATA1 register -----------------------------------------------------
assign rxbert2_data1_acc = (rxacc_addr_sync_ff[5:0] == RXBERT2_DATA1[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert2_data1_rd  =  rxbert2_data1_acc & rxacc_rdwr_sync_ff;

// RXBERT2_DATA2 register -----------------------------------------------------
assign rxbert2_data2_acc = (rxacc_addr_sync_ff[5:0] == RXBERT2_DATA2[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert2_data2_rd  =  rxbert2_data2_acc & rxacc_rdwr_sync_ff;

// RXBERT2_DATA3 register -----------------------------------------------------
assign rxbert2_data3_acc = (rxacc_addr_sync_ff[5:0] == RXBERT2_DATA3[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert2_data3_rd  =  rxbert2_data3_acc & rxacc_rdwr_sync_ff;


// RXBERT3_DATA0 register -----------------------------------------------------
assign rxbert3_data0_acc = (rxacc_addr_sync_ff[5:0] == RXBERT3_DATA0[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert3_data0_rd  =  rxbert3_data0_acc & rxacc_rdwr_sync_ff;

// RXBERT3_DATA1 register -----------------------------------------------------
assign rxbert3_data1_acc = (rxacc_addr_sync_ff[5:0] == RXBERT3_DATA1[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert3_data1_rd  =  rxbert3_data1_acc & rxacc_rdwr_sync_ff;

// RXBERT3_DATA2 register -----------------------------------------------------
assign rxbert3_data2_acc = (rxacc_addr_sync_ff[5:0] == RXBERT3_DATA2[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert3_data2_rd  =  rxbert3_data2_acc & rxacc_rdwr_sync_ff;

// RXBERT3_DATA3 register -----------------------------------------------------
assign rxbert3_data3_acc = (rxacc_addr_sync_ff[5:0] == RXBERT3_DATA3[5:0]) &
                            rx_cmd_sample_ff;

assign rxbert3_data3_rd  =  rxbert3_data3_acc & rxacc_rdwr_sync_ff;


//------------------------------------------------------------------------------
//           Snapshot buffer for bit counter and Rx BERT data
//------------------------------------------------------------------------------

// Load data in auxiliary buffer to be read in the following avalon accesses 
assign rx_bert_aux_buf_ld = rxbert_bitcnt_lo_rd |
                            rxbert0_data0_rd    |
                            rxbert1_data0_rd    |
                            rxbert2_data0_rd    |
                            rxbert3_data0_rd;

// data input of RX bert auxiliary buffer
assign rxbert_aux_rbuf_data[95:0] = (rxbert_bitcnt_lo_rd ? {79'h0,rxbert_bit_cnt[48:32]} : 96'h0) |
                                    (rxbert0_data0_rd    ?  rx_bert0_data[127:32]        : 96'h0) |
                                    (rxbert1_data0_rd    ?  rx_bert1_data[127:32]        : 96'h0) |
                                    (rxbert2_data0_rd    ?  rx_bert2_data[127:32]        : 96'h0) |
                                    (rxbert3_data0_rd    ?  rx_bert3_data[127:32]        : 96'h0);

// RX BERT buffer to store temporary data
always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin: rxbert_aux_rbuf_register
    if(!rxrd_rstn)
      rxbert_aux_rbuf_ff[95:0] <= {96{1'b0}};
    else if(rx_bert_aux_buf_ld)
      rxbert_aux_rbuf_ff[95:0] <= rxbert_aux_rbuf_data[95:0];
  end // block: rxbert_aux_rbuf_register


// Read data logic -------------------------------------------------------------

assign rxcmc_read_data[31:0] = 
          (rx_lane_sel_rd      ? rx_lane_sel_rdata[31:0]      : 32'h0) |
          (chk_ptrn_sel_rd     ? chk_ptrn_sel_rdata[31:0]     : 32'h0) |
          (rxbert_bitcnt_lo_rd ? rxbert_bit_cnt[31:0]         : 32'h0) |
          (rxbert_bitcnt_hi_rd ? rxbert_aux_rbuf_ff[31:0]     : 32'h0) |
          (errcnt_chk0_rd      ? biterr_cnt_chk0_rdata[31:0]  : 32'h0) |
          (errcnt_chk1_rd      ? biterr_cnt_chk1_rdata[31:0]  : 32'h0) |
          (errcnt_chk2_rd      ? biterr_cnt_chk2_rdata[31:0]  : 32'h0) |
          (errcnt_chk3_rd      ? biterr_cnt_chk3_rdata[31:0]  : 32'h0) |
          (rxbert0_data0_rd    ? rx_bert0_data[31:0]          : 32'h0) |
          (rxbert0_data1_rd    ? rxbert_aux_rbuf_ff[31:0]     : 32'h0) |
          (rxbert0_data2_rd    ? rxbert_aux_rbuf_ff[63:32]    : 32'h0) |
          (rxbert0_data3_rd    ? rxbert_aux_rbuf_ff[95:64]    : 32'h0) |
          (rxbert1_data0_rd    ? rx_bert1_data[31:0]          : 32'h0) |
          (rxbert1_data1_rd    ? rxbert_aux_rbuf_ff[31:0]     : 32'h0) |
          (rxbert1_data2_rd    ? rxbert_aux_rbuf_ff[63:32]    : 32'h0) |
          (rxbert1_data3_rd    ? rxbert_aux_rbuf_ff[95:64]    : 32'h0) |
          (rxbert2_data0_rd    ? rx_bert2_data[31:0]          : 32'h0) |
          (rxbert2_data1_rd    ? rxbert_aux_rbuf_ff[31:0]     : 32'h0) |
          (rxbert2_data2_rd    ? rxbert_aux_rbuf_ff[63:32]    : 32'h0) |
          (rxbert2_data3_rd    ? rxbert_aux_rbuf_ff[95:64]    : 32'h0) |
          (rxbert3_data0_rd    ? rx_bert3_data[31:0]          : 32'h0) |
          (rxbert3_data1_rd    ? rxbert_aux_rbuf_ff[31:0]     : 32'h0) |
          (rxbert3_data2_rd    ? rxbert_aux_rbuf_ff[63:32]    : 32'h0) |
          (rxbert3_data3_rd    ? rxbert_aux_rbuf_ff[95:64]    : 32'h0);

//------------------------------------------------------------------------------
//                        TX BERT control interface
//------------------------------------------------------------------------------

assign tx_bert_start_req = |tx_bert_start[3:0];
assign tx_bert_rst_req   = |tx_bert_rst[3:0];
assign tx_bert_ctrl_req  = (tx_bert_start_req | tx_bert_rst_req) &
                           (~tx_bert_ctrl_busy);

aib_bit_sync tx_ctrl_ack_sync_i(
.clk      (i_cfg_avmm_clk),   // clock
.rst_n    (i_cfg_avmm_rst_n), // async reset
.data_in  (tx_bert_ctrl_ack_ff),    // data in
.data_out (tx_bert_ctrl_ack_sync)   // data out
);

assign tx_bert_ctrl_busy = tx_bert_ctrl_req_ff ^ tx_bert_ctrl_ack_sync;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        tx_bert_ctrl_req_ff   <= 1'b0;
        tx_bert_start_ff[3:0] <= 4'b0;
        tx_bert_rst_ff[3:0]   <= 4'b0;
      end
    else if(tx_bert_ctrl_req) 
      begin
        tx_bert_ctrl_req_ff   <= ~tx_bert_ctrl_req_ff;
        tx_bert_start_ff[3:0] <=  tx_bert_start[3:0];
        tx_bert_rst_ff[3:0]   <=  tx_bert_rst[3:0];
      end
  end


aib_bit_sync tx_ctrl_req_sync(
.clk      (txfifo_wr_clk),   // clock
.rst_n    (txwr_rstn), // async reset
.data_in  (tx_bert_ctrl_req_ff),    // data in
.data_out (tx_bert_ctrl_req_sync)   // data out
);

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      tx_bert_ctrl_ack_ff <= 1'b0;
    else
      tx_bert_ctrl_ack_ff <= tx_bert_ctrl_req_sync;
  end

assign tx_bert_ctrl_sample = tx_bert_ctrl_req_sync ^ tx_bert_ctrl_ack_ff;

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        tx_bert_start_sync_ff[3:0] <= 4'b0;
        tx_bert_rst_sync_ff[3:0]   <= 4'b0;
      end
    else if(tx_bert_ctrl_sample)
      begin
        tx_bert_start_sync_ff[3:0] <= tx_bert_start_ff[3:0];
        tx_bert_rst_sync_ff[3:0]   <= tx_bert_rst_ff[3:0]; 
      end 
  end

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      tx_bert_ctrl_sample_ff <= 1'b0;
    else
      tx_bert_ctrl_sample_ff <= tx_bert_ctrl_sample;
  end

assign tx_start_pulse[3:0] = {4{tx_bert_ctrl_sample_ff}} &
                              tx_bert_start_sync_ff[3:0];

assign tx_rst_pulse[3:0]   = {4{tx_bert_ctrl_sample_ff}} & 
                              tx_bert_rst_sync_ff[3:0];


//------------------------------------------------------------------------------
//                        TX BERT status interface
//------------------------------------------------------------------------------

assign txbert_st_update = ~(txbert_status_req_ff ^ txbert_status_ack_sync);

always @(posedge txfifo_wr_clk or negedge txwr_rstn)
  begin
    if(!txwr_rstn)
      begin
        txbert_status_req_ff  <= 1'b0;
        tx_seed_good_ff[3:0]  <= 4'hf;
        tx_bertgen_en_ff[3:0] <= 4'b0;
      end
    else if(txbert_st_update)
      begin
        txbert_status_req_ff  <= ~txbert_status_req_ff;
        tx_seed_good_ff[3:0]  <= tx_seed_good[3:0];
        tx_bertgen_en_ff[3:0] <= tx_bertgen_en[3:0];
      end
  end

aib_bit_sync txbert_status_ack_sync_i(
.clk      (txfifo_wr_clk),        // clock
.rst_n    (txwr_rstn),      // async reset
.data_in  (txbert_status_ack_ff),     // data in
.data_out (txbert_status_ack_sync) // data out
);

aib_bit_sync txbert_status_req_sync_i(
.clk      (i_cfg_avmm_clk),        // clock
.rst_n    (i_cfg_avmm_rst_n),      // async reset
.data_in  (txbert_status_req_ff),     // data in
.data_out (txbert_status_req_sync) // data out
);

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      txbert_status_ack_ff <= 1'b0;
    else
      txbert_status_ack_ff <= txbert_status_req_sync;
  end

assign txbert_status_sample = txbert_status_req_sync ^ txbert_status_ack_ff;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        txst_seed_good_ff[3:0] <= 4'hf;
        txbert_run_ff[3:0]     <= 4'b0;
      end
    else if(txbert_status_sample)
      begin
        txst_seed_good_ff[3:0] <= tx_seed_good_ff[3:0];
        txbert_run_ff[3:0]     <= tx_bertgen_en_ff[3:0];
      end
  end

assign bert_seed_good = |txst_seed_good_ff[3:0];

//------------------------------------------------------------------------------
//                        RX BERT control interface
//------------------------------------------------------------------------------

assign rx_bert_start_req  = |rxbert_start[3:0];
assign rx_bert_rst_req    = |rxbert_rst[3:0];
assign rx_bert_seedin_req = |rxbert_seed_in[3:0];
assign rx_bert_ctrl_req   = ( rx_bert_start_req | 
                              rx_bert_rst_req   |
                              rx_bert_seedin_req ) &
                            (~rx_bert_ctrl_busy  );

aib_bit_sync rx_ctrl_req_sync_i(
.clk      (i_cfg_avmm_clk),   // clock
.rst_n    (i_cfg_avmm_rst_n), // async reset
.data_in  (rx_bert_ctrl_ack_ff),    // data in
.data_out (rx_bert_ctrl_ack_sync)   // data out
);

assign rx_bert_ctrl_busy = rx_bert_ctrl_req_ff ^ rx_bert_ctrl_ack_sync;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        rx_bert_ctrl_req_ff    <= 1'b0;
        rx_bert_start_ff[3:0]  <= 4'b0;
        rx_bert_rst_ff[3:0]    <= 4'b0;
        rxbert_seed_in_ff[3:0] <= 4'b0; 
      end
    else if(rx_bert_ctrl_req) 
      begin
        rx_bert_ctrl_req_ff    <= ~rx_bert_ctrl_req_ff;
        rx_bert_start_ff[3:0]  <=  (~rxbert_rst[3:0]) & rxbert_start[3:0];
        rx_bert_rst_ff[3:0]    <=  rxbert_rst[3:0];
        rxbert_seed_in_ff[3:0] <=  (~rxbert_rst[3:0]) & rxbert_seed_in[3:0];
      end
  end


aib_bit_sync rx_ctrl_req_sync(
.clk      (rxfifo_rd_clk),   // clock
.rst_n    (rxrd_rstn), // async reset
.data_in  (rx_bert_ctrl_req_ff),    // data in
.data_out (rx_bert_ctrl_req_sync)   // data out
);

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      rx_bert_ctrl_ack_ff <= 1'b0;
    else
      rx_bert_ctrl_ack_ff <= rx_bert_ctrl_req_sync;
  end

assign rx_bert_ctrl_sample = rx_bert_ctrl_req_sync ^ rx_bert_ctrl_ack_ff;

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        rx_bert_start_sync_ff[3:0]  <= 4'b0;
        rx_bert_rst_sync_ff[3:0]    <= 4'b0;
        rxbert_seed_in_sync_ff[3:0] <= 4'b0;
      end
    else if(rx_bert_ctrl_sample)
      begin
        rx_bert_start_sync_ff[3:0]  <= rx_bert_start_ff[3:0];
        rx_bert_rst_sync_ff[3:0]    <= rx_bert_rst_ff[3:0]; 
        rxbert_seed_in_sync_ff[3:0] <= rxbert_seed_in_ff[3:0];
      end 
  end

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      rx_bert_ctrl_sample_ff <= 1'b0;
    else
      rx_bert_ctrl_sample_ff <= rx_bert_ctrl_sample;
  end

assign rx_start_pulse[3:0] = {4{rx_bert_ctrl_sample_ff}} &
                              rx_bert_start_sync_ff[3:0];

assign rx_rst_pulse[3:0]   = {4{rx_bert_ctrl_sample_ff}} & 
                              rx_bert_rst_sync_ff[3:0];

assign seed_in_en[3:0] = rxbert_seed_in_sync_ff[3:0];

//------------------------------------------------------------------------------
//                        RX BERT status interface
//------------------------------------------------------------------------------

assign rx_biterr[0] = |biterr_cnt_chk0[15:0];
assign rx_biterr[1] = |biterr_cnt_chk1[15:0];
assign rx_biterr[2] = |biterr_cnt_chk2[15:0];
assign rx_biterr[3] = |biterr_cnt_chk3[15:0];

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        rx_biterr_ff[3:0] <= 4'h0;
      end
    else
      begin
        rx_biterr_ff[0] <= ~rx_rst_pulse[0] & rx_biterr[0];
        rx_biterr_ff[1] <= ~rx_rst_pulse[1] & rx_biterr[1];
        rx_biterr_ff[2] <= ~rx_rst_pulse[2] & rx_biterr[2];
        rx_biterr_ff[3] <= ~rx_rst_pulse[3] & rx_biterr[3];
      end
  end

assign rxbert_st_update = ~(rxbert_status_req_ff ^ rxbert_status_ack_sync);

always @(posedge rxfifo_rd_clk or negedge rxrd_rstn)
  begin
    if(!rxrd_rstn)
      begin
        rxbert_status_req_ff  <= 1'b0;
        rx_bertgen_en_ff[3:0] <= 4'b0;
        rx_berterr_ff[3:0]    <= 4'b0;
      end
    else if(rxbert_st_update)
      begin
        rxbert_status_req_ff  <= ~rxbert_status_req_ff;
        rx_bertgen_en_ff[3:0] <=  rx_bertgen_en[3:0];
        rx_berterr_ff[3:0]    <=  rx_biterr_ff[3:0];
      end
  end

aib_bit_sync rxbert_status_ack_sync_i(
.clk      (rxfifo_rd_clk),        // clock
.rst_n    (rxrd_rstn),      // async reset
.data_in  (rxbert_status_ack_ff),     // data in
.data_out (rxbert_status_ack_sync) // data out
);

aib_bit_sync rxbert_status_req_sync_i(
.clk      (i_cfg_avmm_clk),        // clock
.rst_n    (i_cfg_avmm_rst_n),      // async reset
.data_in  (rxbert_status_req_ff),     // data in
.data_out (rxbert_status_req_sync) // data out
);

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      rxbert_status_ack_ff <= 1'b0;
    else
      rxbert_status_ack_ff <= rxbert_status_req_sync;
  end

assign rxbert_status_sample = rxbert_status_req_sync ^ rxbert_status_ack_ff;

always @(posedge i_cfg_avmm_clk or negedge i_cfg_avmm_rst_n)
  begin
    if(!i_cfg_avmm_rst_n)
      begin
        rxbert_run_ff[3:0]    <= 4'b0;
        rxbert_biterr_ff[3:0] <= 4'b0;
      end
    else if(rxbert_status_sample)
      begin
        rxbert_run_ff[3:0]    <= rx_bertgen_en_ff[3:0];
        rxbert_biterr_ff[3:0] <= rx_berterr_ff[3:0];
      end
  end


endmodule // aib_bert_cdc
