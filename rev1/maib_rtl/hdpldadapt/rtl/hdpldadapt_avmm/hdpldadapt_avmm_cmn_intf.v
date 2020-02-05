// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm_cmn_intf 
(
input wire        avmm_rst_n,
input wire        scan_rst_n,
input wire        scan_mode_n,
input wire        scan_shift_n,
input wire        scan_shift_clk,
input wire        csr_clk,
input wire        csr_bit_last,
input wire        avmm_clk,
input wire        avmm_write,
input wire        avmm_read,
input wire        avmm_request,
input wire [9:0]  avmm_reg_addr,
input wire [7:0]  avmm_writedata,
input wire [8:0]  avmm_reserved_in,
input wire        block_select_master,
input wire [7:0]  master_pld_avmm_readdata,
input wire [7:0]  remote_pld_avmm_readdata,
//input wire [2:0]  remote_pld_avmm_reserved_out,
input wire        interface_sel,
input wire [9:0]  r_avmm_nfhssi_base_addr,
input wire        r_avmm_nfhssi_calibration_en,
input wire [9:0]  r_avmm_adapt_base_addr,
input wire        r_avmm_rd_block_enable,
input wire        r_avmm_uc_block_enable,
input wire        remote_pld_avmm_busy,
input wire        remote_pld_avmm_readdatavalid,
input wire        sr_hssi_avmm1_busy,
input wire        int_pld_avmm_cmdfifo_wr_pfull,

output wire [7:0] master_pld_avmm_writedata,
output wire [7:0] master_pld_avmm_reg_addr,
output wire       master_pld_avmm_write,
output wire       master_pld_avmm_read,

output wire [7:0] remote_pld_avmm_writedata,
output wire [8:0] remote_pld_avmm_reserved_in,
output wire [9:0] remote_pld_avmm_reg_addr,
output wire       remote_pld_avmm_write,
output wire       remote_pld_avmm_read,
output wire       remote_pld_avmm_request,

output wire [7:0]  avmm_readdata,
output reg         avmm_readdatavalid,
//output reg  [2:0]  avmm_reserved_out,
output wire        avmm_pld_avmm_busy,
output wire [10:0] avmm1_cmn_intf_testbus,
output wire        pld_avmm1_cmdfifo_wr_pfull_dly,
output wire        csr_out
);

localparam DATA_WIDTH         =  8;  // Data width
localparam ADDR_WIDTH         =  9;  // Address width
localparam NUM_CHNL           =  2;  // Number of DPRIO modules
localparam CSR_OUT_NEG_FF_EN  =  1;  // Enable negative FF on csr_out

wire        nc_0;
wire        nc_1;
wire        nc_2;
wire        nc_3;
wire        nc_4;
wire        nc_5;
wire        nc_6;
wire        nc_7;
wire        nc_8;
wire        nc_9;
wire        nc_10;
wire        nc_11;
reg [DATA_WIDTH-1:0]  writedata_int;
reg [8:0]  avmm_reserved_in_int;
reg [ADDR_WIDTH:0]  reg_addr_int;
reg        write_int;
reg        read_int;
reg        avmm_request_int;
reg        master_pld_avmm_read_dly1;
reg        master_pld_avmm_read_dly2;
wire       avmm_readdatavalid_dly2;
   
wire        msb_avmm_reg_addr;
wire [NUM_CHNL-1:0]            block_select;
wire [DATA_WIDTH*NUM_CHNL-1:0] readdata_chnl;
wire        hssi_uc_ctrl;
reg         uc_blocked_int;
wire        uc_blocked;
reg         avmm_rd_blocked_int;
wire        avmm_rd_blocked;
reg         msb_avmm_reg_addr_reg;
reg         avmm_request_reg;
reg [8:0]   avmm_reserved_in_reg;
wire [DATA_WIDTH-1:0]          writedata_chnl;
wire [ADDR_WIDTH-1:0]          reg_addr_chnl;
wire                           write_chnl;
wire                           read_chnl;

reg         remote_pld_avmm_busy_dly;
wire        deassertion_pld_avmm_busy;
wire        nd_reg_addr;
wire        remote_pld_avmm_busy_selout;
wire        sr_hssi_avmm1_busy_sync;
reg         remote_pld_avmm_busy_sel;
reg  [2:0]  avmm_reserved_out;

assign avmm1_cmn_intf_testbus = {remote_pld_avmm_write, remote_pld_avmm_read, master_pld_avmm_write, master_pld_avmm_read, avmm_rd_blocked, uc_blocked, nd_reg_addr, hssi_uc_ctrl, master_pld_avmm_read_dly2, remote_pld_avmm_readdatavalid, remote_pld_avmm_busy_selout};

assign block_select      = {~master_pld_avmm_read_dly2,master_pld_avmm_read_dly2};
assign readdata_chnl     = {remote_pld_avmm_readdata,master_pld_avmm_readdata};
assign msb_avmm_reg_addr = avmm_reg_addr[9];

cfg_dprio_ctrl_stat_interface_top
#(
   .DATA_WIDTH(DATA_WIDTH),              // Data width
   .ADDR_WIDTH(ADDR_WIDTH),              // Address width
   .NUM_CHNL(NUM_CHNL),                  // Number of DPRIO modules
   .CSR_OUT_NEG_FF_EN(CSR_OUT_NEG_FF_EN) // Enable negative FF on csr_out
 )
cfg_dprio_ctrl_stat_interface_top (
        // input
        .npor                  (avmm_rst_n           ), // NPOR from CB. 
        .plniotri              (1'b1                 ), // PLNIOTRI from CB
        .entest                (1'b0                 ), // ENTEST from CB
        .scan_mode_n           (1'b1                 ), // active low scan mode enable. 
        .scan_shift_n          (scan_shift_n         ), // active low scan shift
        .refclk_dig            (scan_shift_clk       ), // scan clock. 
        .csr_rst_n             (1'b1                 ), // CSR reset
        .csr_clk               (csr_clk              ), // CSR clock
        .csr_in                (1'b0                 ), // Serial CSR input
        .csr_en                (1'b1                 ), // CSR enable. 
        .csr_out_chnl          (csr_bit_last         ), // CSR output from top channel
        .csr_cbdin             (1'b0                 ), // CSR configuration mode data input
        .csr_tcsrin            (1'b0                 ), // CSR test/scan mode data input
        .csr_din               (1'b0                 ), // Previous CSR bit data output
        .csr_seg               (1'b0                 ), // VSS for Seg0(), VCC for seg[31:1]
        .csr_entest            (1'b0                 ), // enable test control input: ECO fix to tie off the csr_entest
        .csr_enscan            (1'b0                 ), // enable scan control input
        .csr_tverify           (1'b0                 ), // test verify control input
        .csr_load_csr          (1'b0                 ), // JTAG scan mode control input
        .csr_pipe_in           (1'b0                 ), // Input to the Pipeline register to suport 200MHz
        .interface_sel         (1'b0                 ), // Interface selection inputs. 
        .avmm_rst_n            (scan_rst_n           ), // Avalon-MM reset. 
        .avmm_clk              (avmm_clk             ), // Avalon-MM clock.
        .avmm_write            (avmm_write           ), // Avalon-MM write enable input
        .avmm_read             (avmm_read            ), // Avalon-MM read enable input
        .avmm_byte_en          (1'b1                 ), // Avalon-MM Byte enable
        .avmm_reg_addr         (avmm_reg_addr[8:0]   ), // Avalon-MM address input
        .avmm_writedata        (avmm_writedata       ), // Avalon-MM write data input
        .block_select          (block_select         ), // Signal to tell the central interface to select its readdata
        .readdata_chnl         (readdata_chnl        ), // Read data from channels
        // output
        .dprio_rst_n           (nc_10                ), // Active low reset to channel: 
        .dprio_clk             (nc_11                ), // Clock to channel. 
        .writedata_chnl        (writedata_chnl       ), // Write data to channel
        .reg_addr_chnl         (reg_addr_chnl        ), // Address to channel
        .write_chnl            (write_chnl           ), // Write enable to channel
        .read_chnl             (read_chnl            ), // Read enable to channel
        .avmm_readdata         (avmm_readdata        ), // Avalon-MM read data output
        .csr_out               (csr_out              ), // Serial CSR output
        .scan_mode_n_chnl      (nc_0                 ), // active low scan mode enable for top channel
        .scan_shift_n_chnl     (nc_1                 ), // active low scan mode enable for top channel
        .csr_en_chnl           (nc_2                 ), // CSR enable to channels
        .csr_clk_chnl          (nc_3                 ), // CSR clock to channels
        .csr_in_chnl           (nc_4                 ), // CSR input to top channel
        .csr_dout              (nc_5                 ), // CSR input MUX Data output
        .csr_pipe_out          (nc_6                 ), // Pipelined register data output
        .csr_test_mode         (nc_7                 ), // CSR test mode
        .mdio_dis_chnl         (nc_8                 ), // 1'b1=CRAM is from CSR
        .byte_en_chnl          (nc_9                 )
);

// Flop the MSB of avmm_reg_addr
always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      msb_avmm_reg_addr_reg  <= 1'b0;
      avmm_request_reg       <= 1'b0;
      avmm_reserved_in_reg   <= 9'd0;
    end
  else
    begin
      msb_avmm_reg_addr_reg  <= msb_avmm_reg_addr;
      avmm_request_reg       <= avmm_request; 
      avmm_reserved_in_reg   <= avmm_reserved_in;
    end

// AVMM Interface signals during iocsr_rdy assertion and deassertion 
always @(*)
  begin
    case (interface_sel)
      1'b0:  // Avalon-MM interface
            begin
              writedata_int = writedata_chnl;
              reg_addr_int  = {msb_avmm_reg_addr_reg,reg_addr_chnl};
              write_int     = write_chnl;
              read_int      = read_chnl;
              avmm_request_int   = avmm_request_reg;
              avmm_reserved_in_int   = avmm_reserved_in_reg;
            end
      1'b1: // CSR interface
            begin
              writedata_int = {DATA_WIDTH{1'b0}};
              reg_addr_int  = {1'b0,{ADDR_WIDTH{1'b0}}};
              write_int     = 1'b0;
              read_int      = 1'b0;
              avmm_request_int   = 1'b0; 
              avmm_reserved_in_int   = 9'd0;
            end
      default: // CSR
            begin
              writedata_int = {DATA_WIDTH{1'b0}};
              reg_addr_int  = {1'b0,{ADDR_WIDTH{1'b0}}};
              write_int     = 1'b0;
              read_int      = 1'b0;
              avmm_request_int   = 1'b0; 
              avmm_reserved_in_int   = 9'd0;
            end
    endcase
  end

// Select busy bit from SR right after reset until de-assertion of busy bit. After that, always select busy bit from AVMM transfer
cdclib_bitsync2
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (1),       // Reset value
        .CLK_FREQ_MHZ(200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync2_sr_hssi_avmm1_busy
    (
      .clk      (avmm_clk),
      .rst_n    (avmm_rst_n),
      .data_in  (sr_hssi_avmm1_busy),
      .data_out (sr_hssi_avmm1_busy_sync)
    );

always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      remote_pld_avmm_busy_sel <= 1'b1;
    end
  else
    begin
      remote_pld_avmm_busy_sel <= deassertion_pld_avmm_busy ? 1'b0 : remote_pld_avmm_busy_sel;
  end

assign remote_pld_avmm_busy_selout = remote_pld_avmm_busy_sel ? sr_hssi_avmm1_busy_sync : remote_pld_avmm_busy; 

// gate read and write in main adapter after AVMM switch control from PLD to uC in NF HSSI 
assign hssi_uc_ctrl = write_int & (reg_addr_int[9:0] == r_avmm_nfhssi_base_addr[9:0]) & writedata_int[0] & r_avmm_nfhssi_calibration_en;  

always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      remote_pld_avmm_busy_dly <= 1'b1;
    end
  else
    begin
      remote_pld_avmm_busy_dly <= remote_pld_avmm_busy_selout;
  end

//assign avmm_pld_avmm_busy = remote_pld_avmm_busy_dly;
assign avmm_pld_avmm_busy = remote_pld_avmm_busy_selout;
assign deassertion_pld_avmm_busy = (remote_pld_avmm_busy_selout == 1'b0) & (remote_pld_avmm_busy_dly == 1'b1);

assign uc_blocked = uc_blocked_int & r_avmm_uc_block_enable; 
always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      uc_blocked_int <= 1'b0;
    end
  else
    begin
      if (!uc_blocked_int && ( hssi_uc_ctrl || remote_pld_avmm_busy_selout) && !avmm_rd_blocked) begin
          uc_blocked_int <= 1'b1;
      end
      else if (deassertion_pld_avmm_busy) begin
          uc_blocked_int <= 1'b0;
      end
      else begin
          uc_blocked_int <= uc_blocked_int;
      end
    end  

// blocked read command before return of readdatavalid
assign avmm_rd_blocked = avmm_rd_blocked_int & r_avmm_rd_block_enable;
always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      avmm_rd_blocked_int <= 1'b0;
    end
  else
    begin
      //if (!avmm_rd_blocked_int && read_int && !nd_reg_addr && !uc_blocked) begin
      if (!avmm_rd_blocked_int && read_int && !uc_blocked) begin
          avmm_rd_blocked_int <= 1'b1;
      end
      //else if (remote_pld_avmm_readdatavalid || master_pld_avmm_read_dly2) begin
      else if (avmm_readdatavalid_dly2) begin
          avmm_rd_blocked_int <= 1'b0;
      end
      else begin
          avmm_rd_blocked_int <= avmm_rd_blocked_int;
      end
    end

assign nd_reg_addr = (reg_addr_int[9:8] == r_avmm_adapt_base_addr[9:8]) ? 1'b1 : 1'b0;

// distribute AVMM commands to master and slave
assign remote_pld_avmm_writedata = writedata_int; 
assign remote_pld_avmm_reserved_in = avmm_reserved_in_int; 
assign remote_pld_avmm_reg_addr  = reg_addr_int[9:0];
assign remote_pld_avmm_write     = (nd_reg_addr || avmm_rd_blocked || uc_blocked)  ? 1'b0 : write_int; // add uc_blocked component
assign remote_pld_avmm_read      = (nd_reg_addr || avmm_rd_blocked || uc_blocked)  ? 1'b0 : read_int;  // add uc_blocked component
assign remote_pld_avmm_request   = avmm_request_int; 
//assign remote_pld_avmm_read      = (nd_reg_addr || avmm_rd_blocked)  ? 1'b0 : read_int;  // add uc_blocked component

assign master_pld_avmm_writedata = writedata_int;
assign master_pld_avmm_reg_addr  = reg_addr_int[7:0];
assign master_pld_avmm_write     = (!nd_reg_addr || avmm_rd_blocked || uc_blocked) ? 1'b0 : write_int; 
assign master_pld_avmm_read      = (!nd_reg_addr || avmm_rd_blocked || uc_blocked) ? 1'b0 : read_int; 

// Additional 2 flops
always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      master_pld_avmm_read_dly1 <= 1'b0;
      master_pld_avmm_read_dly2 <= 1'b0;
    end
  else
    begin
      master_pld_avmm_read_dly1 <= master_pld_avmm_read;
      master_pld_avmm_read_dly2 <= master_pld_avmm_read_dly1; 
    end


// MUX readdataoutvalid from either master or slave
always @(negedge avmm_rst_n or posedge avmm_clk)
  if (avmm_rst_n == 1'b0)
    begin
      avmm_readdatavalid <= 1'b0;
      avmm_reserved_out  <= 3'd0;
    end
  else
    begin
      avmm_readdatavalid <= master_pld_avmm_read_dly2 ? 1'b1 : remote_pld_avmm_readdatavalid; 
      //avmm_reserved_out  <= remote_pld_avmm_reserved_out; 
      avmm_reserved_out[0]  <= avmm_readdatavalid; 
      avmm_reserved_out[1]  <= avmm_reserved_out[0]; 
      avmm_reserved_out[2]  <= int_pld_avmm_cmdfifo_wr_pfull; 
    end

assign avmm_readdatavalid_dly2 = avmm_reserved_out[1];
assign pld_avmm1_cmdfifo_wr_pfull_dly = avmm_reserved_out[2];
 
endmodule
