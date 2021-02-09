// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_datapath_del_sm
    (
      input  wire                 wr_rst_n,        // Write Domain Active low Reset
      input  wire                 wr_clk,          // Write Domain Clock

      input  wire [39:0]   aib_fabric_rx_data_in,         // Write Data In 
      
//      input  wire [PCSCWIDTH-1:0] control_in,         // Frame information 
//      input  wire [PCSDWIDTH-1:0] data_in,         // Write Data In (Contains CTRL+DATA)
//      input  wire                 data_valid_in,   // Write Data In Valid 
//      input  wire [77:0]	  data_in;

      input  wire		  r_write_ctrl,
      
      input  wire                 wr_pfull,         // Write partial full 
      input  wire                 wr_full,         // Write full 

      input  wire	          wa_lock,	   // Word-align lock
      input  wire		  base_r_clkcomp_mode,
      
      output wire [19:0]	  deletion_sm_testbus,
      output wire [39:0]	  data_out,
      output wire		  block_lock,
      output reg		  block_lock_lt,
      output reg		  del_sm_wr_en,
      output reg		  fifo_del	  // FIFO deletion
    );

//********************************************************************
// Define Parameters 
//********************************************************************
//`include "hd_pcs10g_params.v"

   localparam PCSDWIDTH      = 'd64;    // PCS data width
   localparam PCSCWIDTH      = 'd10;     // PCS control width


// 10G, 40G & 100G  Ethernet Parameters
   // Spec Definitions
   // MII Control Characters - Unencoded
   localparam               XGMII_IDLE  = 8'h07;
   localparam               XGMII_START = 8'hfb;
   localparam               XGMII_TERM  = 8'hfd;
   localparam               XGMII_ERROR = 8'hfe;
   localparam               XGMII_SEQOS = 8'h9c;
   localparam               XGMII_RES0  = 8'h1c;
   localparam               XGMII_RES1  = 8'h3c;
   localparam               XGMII_RES2  = 8'h7c;
   localparam               XGMII_RES3  = 8'hbc;
   localparam               XGMII_RES4  = 8'hdc;
   localparam               XGMII_RES5  = 8'hf7;
   localparam               XGMII_SIGOS = 8'h5c;

   // Local Fault OS and Error Block - Unencoded 
   localparam               EBLOCK_R            = {8{XGMII_ERROR}};
   localparam               LBLOCK_R_10G        = {8'h1,8'h0,8'h0,XGMII_SEQOS,8'h1,8'h0,8'h0,XGMII_SEQOS};

// Shared Parameters
   // Control Bits 
   localparam               CTL_DATA         = 'd0;
   localparam               CTL_CTRL         = 'd1;
   localparam               CTL_ERR          = 'd8;
   localparam               CTL_BFL          = 'd9;


//   localparam 			    PCSDWIDTH      = 'd64,    // PCS data width
//   localparam 			    PCSCWIDTH      = 'd10     // PCS control width

   localparam                       WR_IDLE         = 3'd0; 
   localparam                       WR_ADD_NXT_DAT  = 3'd1; 
   localparam                       WR_ADD_STOR_DAT = 3'd2; 
   localparam                       WR_ADD_NULL_DAT = 3'd3; 
   localparam 			    WR_ADD_NO_DEL   = 3'd4;
   
   
   localparam                       XGMII_IDLE_WORD = {4{XGMII_IDLE}};
   
   localparam                       FIFO_DATA_DEFAULT = LBLOCK_R_10G;
   localparam                       FIFO_CTRL_DEFAULT = 10'h11;
   localparam   		    FIFO_DEFAULT = {FIFO_CTRL_DEFAULT, FIFO_DATA_DEFAULT};  
   
   localparam                       FDWIDTH = PCSDWIDTH+PCSCWIDTH;

//********************************************************************
// Define variables 
//********************************************************************


   wire [FDWIDTH-1:0]               wr_data_in;

   // Define variables 
   // Regs
   reg [FDWIDTH-1:0]                nx1_data_in;
   reg [FDWIDTH-1:0]                nx0_data_in;
   reg [FDWIDTH-1:0]                cur_data_in;
   reg                              nx1_data_valid_in;
   reg                              nx0_data_valid_in;
   reg                              cur_data_valid_in;
   reg                              nx1_lsoctet_os;
   reg                              nx1_lsoctet_idle;
   reg                              nx1_lsoctet_term;
   reg                              nx1_msoctet_os; 
   reg                              nx1_msoctet_idle;
   reg                              nx1_msoctet_term;
   reg                              nx0_lsoctet_os;
   reg                              nx0_lsoctet_idle;
   reg                              nx0_lsoctet_term;
   reg                              nx0_msoctet_os; 
   reg                              nx0_msoctet_idle;
   reg                              nx0_msoctet_term;
   reg                              cur_lsoctet_os;
   reg                              cur_lsoctet_idle;
   reg                              cur_lsoctet_term;
   reg                              cur_msoctet_os;
   reg                              cur_msoctet_idle;
   reg                              cur_msoctet_term;
   reg                              cur_msoctet_del;
   reg                              cur_lsoctet_del;
   reg                              nx0_msoctet_del;
   reg                              nx0_lsoctet_del;
//   reg                              wr_en;
   reg [FDWIDTH-3:0]                wr_data;
   reg [2:0]                        wr_del_sm;
   reg [31:0]                       store_lsd;
   reg [3:0]                        store_lsc;
   
   // Wires
   wire [31:0]                      cur_data_in_lsd;
   wire [31:0]                      cur_data_in_msd;
   wire [3:0]                       cur_data_in_lsc;
   wire [3:0]                       cur_data_in_msc;
   wire [31:0]                      nx0_data_in_lsd;
   wire [31:0]                      nx0_data_in_msd;
   wire [3:0]                       nx0_data_in_lsc;
   wire [3:0]                       nx0_data_in_msc;

   wire				    data_valid_in;
   wire	[63:0]			    data_in;
   wire [9:0]			    control_in;
//   wire				    block_lock;
   wire				    block_lock_sync;
//   reg			            block_lock_lt;
   wire			            block_lock_int;
   wire                 	    wr_srst_n;
   reg			            keep_store;
   reg				    wr_en;
   
// Extract data, control, DV bits
//assign control_in 	= data_in[9:0];
//assign data_valid_in 	= data_in[10];
//assign data_in_int 	= data_in[77:14];

   
   wire	[39:0]	aib_in = aib_fabric_rx_data_in;
   
   reg	[39:0]	aib_in_reg;
   reg  [79:0]			    fifo_in_2x;
   reg				    dv_2x_reg;
   wire				    dv_2x;

   wire	[79:0]			data_out_del_sm_aib_2x;
   reg	[39:0]			data_out_del_sm_aib;

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      aib_in_reg         <= 'd0;
   end
   else begin
      aib_in_reg         <= aib_in;
   end
end

   
   always@(posedge wr_clk or negedge wr_rst_n) begin 
      if (!wr_rst_n) begin
        fifo_in_2x 		<= 'd0;
      end
      else if (~dv_2x && wa_lock) begin
        fifo_in_2x		<= {aib_in, aib_in_reg};
      end
   end

//assign fifo_in_2x = {aib_in, aib_in_reg};

assign {data_valid_in, control_in, data_in} = aib_2_teng_map(fifo_in_2x);

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      dv_2x_reg         <= 1'b0;
   end
   else begin
      dv_2x_reg         <= dv_2x;
   end
end

assign dv_2x = ~wa_lock ? 1'b0: ~dv_2x_reg;



assign wr_data_in = {control_in, data_in};

//   always @(negedge wr_rst_n or posedge wr_clk) begin
//      if (wr_rst_n == 1'b0) begin
//         nx1_data_valid_in  <= 'd0; 
//         nx0_data_valid_in  <= 'd0; 
//         cur_data_valid_in  <= 'd0; 
//      end
//      else if (dv_2x) begin
//         nx1_data_valid_in  <= data_valid_in;
//         nx0_data_valid_in  <= nx1_data_valid_in;
//         cur_data_valid_in  <= nx0_data_valid_in;
//      end
//   end

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         nx1_data_valid_in  <= 'd0; 
         nx0_data_valid_in  <= 'd0; 
         cur_data_valid_in  <= 'd0; 
         nx1_data_in      <= 'd0; 
         nx0_data_in      <= 'd0; 
         cur_data_in      <= 'd0; 
      end
      else if (dv_2x_reg) begin
         nx1_data_valid_in  <= data_valid_in;
         nx0_data_valid_in  <= nx1_data_valid_in;
         cur_data_valid_in  <= nx0_data_valid_in;
         nx1_data_in      <= (data_valid_in)     ? wr_data_in     : nx1_data_in;
         nx0_data_in      <= (nx1_data_valid_in) ? nx1_data_in : nx0_data_in;
         cur_data_in      <= (nx0_data_valid_in) ? nx0_data_in : cur_data_in;

      end
   end

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
//         nx1_data_in      <= 'd0; 
//         nx0_data_in      <= 'd0; 
//         cur_data_in      <= 'd0; 
         
         nx1_lsoctet_os   <= 'd0; 
         nx1_lsoctet_idle <= 'd0; 
         nx1_lsoctet_term <= 'd0; 
         nx1_msoctet_os   <= 'd0; 
         nx1_msoctet_idle <= 'd0; 
         nx1_msoctet_term <= 'd0; 
         
         nx0_lsoctet_os   <= 'd0; 
         nx0_lsoctet_idle <= 'd0; 
         nx0_lsoctet_term <= 'd0; 
         nx0_msoctet_os   <= 'd0; 
         nx0_msoctet_idle <= 'd0; 
         nx0_msoctet_term <= 'd0; 
         
         cur_lsoctet_os   <= 'd0; 
         cur_lsoctet_idle <= 'd0; 
         cur_lsoctet_term <= 'd0; 
         cur_msoctet_os   <= 'd0; 
         cur_msoctet_idle <= 'd0; 
         cur_msoctet_term <= 'd0; 
         
      end
      else if (dv_2x_reg) begin  
//      else begin  
//         nx1_data_in      <= (data_valid_in)     ? wr_data_in     : nx1_data_in;
//         nx0_data_in      <= (nx1_data_valid_in) ? nx1_data_in : nx0_data_in;
//         cur_data_in      <= (nx0_data_valid_in) ? nx0_data_in : cur_data_in;
         
         nx0_lsoctet_os   <= (nx1_data_valid_in) ? nx1_lsoctet_os   : nx0_lsoctet_os;     
         nx0_lsoctet_idle <= (nx1_data_valid_in) ? nx1_lsoctet_idle : nx0_lsoctet_idle; 
         nx0_lsoctet_term <= (nx1_data_valid_in) ? nx1_lsoctet_term : nx0_lsoctet_term; 
         nx0_msoctet_os   <= (nx1_data_valid_in) ? nx1_msoctet_os   : nx0_msoctet_os;  
         nx0_msoctet_idle <= (nx1_data_valid_in) ? nx1_msoctet_idle : nx0_msoctet_idle; 
         nx0_msoctet_term <= (nx1_data_valid_in) ? nx1_msoctet_term : nx0_msoctet_term;  
         
         cur_lsoctet_os   <= (nx0_data_valid_in) ? nx0_lsoctet_os   : cur_lsoctet_os;     
         cur_lsoctet_idle <= (nx0_data_valid_in) ? nx0_lsoctet_idle : cur_lsoctet_idle; 
         cur_lsoctet_term <= (nx0_data_valid_in) ? nx0_lsoctet_term : cur_lsoctet_term; 
         cur_msoctet_os   <= (nx0_data_valid_in) ? nx0_msoctet_os   : cur_msoctet_os;  
         cur_msoctet_idle <= (nx0_data_valid_in) ? nx0_msoctet_idle : cur_msoctet_idle; 
         cur_msoctet_term <= (nx0_data_valid_in) ? nx0_msoctet_term : cur_msoctet_term;  
         
         
         // Reset these before decoding
         nx1_lsoctet_os   <= 'd0; 
         nx1_lsoctet_idle <= 'd0; 
         nx1_lsoctet_term <= 'd0; 
         nx1_msoctet_os   <= 'd0; 
         nx1_msoctet_idle <= 'd0; 
         nx1_msoctet_term <= 'd0; 

         // Decode Next1 data
         case(wr_data_in[71:64])
           8'b1111_1111: begin 
              // 2nd row of Figure 49-7, BLOCK_TYPE_FIELD=8'h1e
              // Check if all bits are control, then if true, convert from XGMII to 10GBASE-R
              // C7,C6,C5,C4/C3,C2,C1,C0
              if (wr_data_in[63:32] == {4{XGMII_IDLE}}) begin
                 nx1_msoctet_idle <= 1'b1; 
              end
              else begin
                 nx1_msoctet_idle <= 1'b0; 
              end
              if (wr_data_in[31:0] == {4{XGMII_IDLE}}) begin
                 nx1_lsoctet_idle  <= 1'b1;
              end
              else begin
                 nx1_lsoctet_idle  <= 1'b0;
              end
              // 10th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h87
              // C7,C6,C5,C4/C3,C2,C1,T0
              if (wr_data_in[7:0] == XGMII_TERM) begin
                 nx1_lsoctet_term <= 1'b1;
              end
              else begin
                 nx1_lsoctet_term <= 1'b0;
              end
           end
           8'b0001_1111: begin 
              // 3rd row of Figure 49-7, BLOCK_TYPE_FIELD=8'h2d
              // Check if HIGH ORDERED SET and 1st_XGMII_transfer = all_control. 
              // D7,D6,D5,O4/C3,C2,C1,C0
              if (wr_data_in[39:32] == XGMII_SEQOS) begin
                 nx1_msoctet_os <= 1'b1;
              end
              else begin
                 nx1_msoctet_os <= 1'b0;
              end
              if (wr_data_in[31:0] == {4{XGMII_IDLE}}) begin
                 nx1_lsoctet_idle <= 1'b1;
              end
              else begin
                 nx1_lsoctet_idle <= 1'b0;
              end
           end
           8'b0001_0001: begin 
              // 6th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h66
              // D7,D6,D5,O4/D3,D2,D1,O0
              if (wr_data_in[39:32] == XGMII_SEQOS) begin
                 nx1_msoctet_os <= 1'b1;
              end
              else begin
                 nx1_msoctet_os <= 1'b0;
              end
              if (wr_data_in[7:0] == XGMII_SEQOS) begin
                 nx1_lsoctet_os <= 1'b1;
              end
              else begin
                 nx1_lsoctet_os <= 1'b0;
              end
           end
           8'b1111_0001: begin 
              // 8th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h4b
              // C7,C6,C5,C4/D3,D2,D1,O0
              if (wr_data_in[63:32] == {4{XGMII_IDLE}}) begin
                 nx1_msoctet_idle <= 1'b1;
              end
              else begin
                 nx1_msoctet_idle <= 1'b0;
              end
              if (wr_data_in[7:0] == XGMII_SEQOS) begin
                 nx1_lsoctet_os <= 1'b1;
              end
              else begin
                 nx1_lsoctet_os <= 1'b0;
              end
           end
           8'b1111_1110: begin 
              // 10th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h99
              // C7,C6,C5,C4/C3,C2,T1,D0
              if (wr_data_in[15:8] == XGMII_TERM) begin
                 nx1_lsoctet_term <= 1'b1;
              end
              else begin
                 nx1_lsoctet_term <= 1'b0;
              end
           end
           8'b1111_1100: begin 
              // 11th row of Figure 49-7, BLOCK_TYPE_FIELD=8'haa
              // C7,C6,C5,C4/C3,T2,D1,D0
              if (wr_data_in[23:16] == XGMII_TERM) begin
                 nx1_lsoctet_term <= 1'b1;
              end
              else begin
                 nx1_lsoctet_term <= 1'b0;
              end
           end
           8'b1111_1000: begin 
              // 12th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hb4
              // C7,C6,C5,C4/T3,D2,D1,D0
              if (wr_data_in[31:24] == XGMII_TERM) begin
                 nx1_lsoctet_term <= 1'b1;
              end
              else begin
                 nx1_lsoctet_term <= 1'b0;
              end
           end
           8'b1111_0000: begin 
              // 13th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hcc
              // C7,C6,C5,T4/D3,D2,D1,D0
              if (wr_data_in[39:32] == XGMII_TERM) begin
                 nx1_msoctet_term <= 1'b1;
              end
              else begin
                 nx1_msoctet_term <= 1'b0;
              end
           end
           8'b1110_0000: begin     
              // 14th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hd2
              // C7,C6,T5,D4/D3,D2,D1,D0
              if (wr_data_in[47:40] == XGMII_TERM) begin
                 nx1_msoctet_term <= 1'b1;
              end
              else begin
                 nx1_msoctet_term <= 1'b0;
              end
           end
           8'b1100_0000: begin  
              // 15th row of Figure 49-7, BLOCK_TYPE_FIELD=8'he1
              // C7,T6,D5,D4/D3,D2,D1,D0
              if (wr_data_in[55:48] == XGMII_TERM) begin
                 nx1_msoctet_term <= 1'b1;
              end
              else begin
                 nx1_msoctet_term <= 1'b0;
              end
           end
           8'b1000_0000: begin  
              // 16th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hff
              // T7,D6,D5,D4/D3,D2,D1,D0
              if (wr_data_in[63:56] == XGMII_TERM) begin
                 nx1_msoctet_term <= 1'b1;
              end
              else begin
                 nx1_msoctet_term <= 1'b0;
              end
           end
           default: begin
              nx1_lsoctet_os   <= 'd0; 
              nx1_lsoctet_idle <= 'd0; 
              nx1_lsoctet_term <= 'd0; 
              nx1_msoctet_os   <= 'd0; 
              nx1_msoctet_idle <= 'd0; 
              nx1_msoctet_term <= 'd0; 
           end
         endcase
      end
   end
   
   //********************************************************************
   // Delete the Current/Next0 LS OCTET if 
   //	1) Previous LS OCTET has T and Current LS OCTET is IDLE 
   //	--> this will make sure that there is miminum of 5 IPG
   //	2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
   //	and is same as the current LS OCTET which is an OS 
   //	2) Previous MS OCTET is not T & the current LS octet is IDLE  
   //	
   // Delete the Current/Next0 MS OCTET if 
   //	1) Previous MS OCTET has T and Current MS OCTET is IDLE
   //	--> this will make sure that there is a minimum 5 IPG
   //	2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
   //	and is same as the current LS OCTET which is an OS 
   //	2) Previous LS OCTET is not T & the current LS octet is IDLE  
   //********************************************************************
   // Current OS is delete-able if previous word is an OS and it's not delete-able

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         nx0_lsoctet_del <= 1'b0;
         nx0_msoctet_del <= 1'b0;
      end
      else begin
      if (nx1_data_valid_in && dv_2x_reg) begin
         // Decode for NEXT0 Data Decodes
         if ((((nx0_msoctet_os & nx1_lsoctet_os & !nx0_msoctet_del) & (nx0_data_in[63:32] == nx1_data_in[31:0]))) |
             (nx0_msoctet_term == 1'b0 & nx1_lsoctet_idle)) begin
            nx0_lsoctet_del <= 1'b1;
         end
         else begin
            nx0_lsoctet_del <= 1'b0;
         end
         
         if ((((nx1_lsoctet_os & nx1_msoctet_os & !((nx0_msoctet_os & nx1_lsoctet_os & !nx0_msoctet_del) & (nx0_data_in[63:32] == nx1_data_in[31:0]))) & (nx1_data_in[31:0] == nx1_data_in[63:32]))) |
             (nx1_lsoctet_term == 1'b0 & nx1_msoctet_idle)) begin
            nx0_msoctet_del <= 1'b1;
         end
         else begin
            nx0_msoctet_del <= 1'b0;
         end
      end            
      end
   end

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         cur_lsoctet_del <= 1'b0;
         cur_msoctet_del <= 1'b0;
      end
      else begin
      if (nx0_data_valid_in && dv_2x_reg) begin
         // Decode for Current Data Decodes
         if ((((cur_msoctet_os & nx0_lsoctet_os & !cur_msoctet_del) & (cur_data_in[63:32] == nx0_data_in[31:0]))) |
             (cur_msoctet_term == 1'b0 & nx0_lsoctet_idle)) begin
            cur_lsoctet_del <= 1'b1;
         end
         else begin
            cur_lsoctet_del <= 1'b0;
         end
         
         if ((((nx0_lsoctet_os & nx0_msoctet_os & !((cur_msoctet_os & nx0_lsoctet_os & !cur_msoctet_del) & (cur_data_in[63:32] == nx0_data_in[31:0]))) & (nx0_data_in[31:0] == nx0_data_in[63:32]))) | 
             (nx0_lsoctet_term == 1'b0 & nx0_msoctet_idle)) begin
            cur_msoctet_del <= 1'b1;
         end
         else begin
            cur_msoctet_del <= 1'b0;
         end       
      end         
      end
   end
   
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Delete 1 OCTET when PFULL. 
   // In order to stop the writing to the FOFO the following conditions has to be
   // true
   // 1) Check in the current received data if any octet can be deleted
   //    if it can be deleted, form a 64 it data by borrowing octet from next
   //    data  
   // 2) Before borrowing an octet from nex data, make sure the octet being
   //    borrowed is valid and not a ocetet that is to be deleted.
   // 3) If no valid octet are present in the next data, store the current octet
   //    until a valid data is received to form a 64 bit data.  
   //
   // The logic implemented below looks at the current 2 octet (MSB,LSB) and the next
   // 2 octet (MSB,LSB).
   // 
   // WR_IDLE: This is the default state. In this state are the 4 octets are looked
   // at to decide how to form the 64 bit data.
   // WR_ADD_NXT_DAT : In this state one VALID next data MSB/LSB octet is
   // combined with the current data MSB/LSB octet.
   // WR_ADD_STOR_DAT : In thei state the current data MSB/LSB is stored if the
   // next data does not have a vaid data (MSB/LSB octet of next data to be
   // deleted) 
   // WR_ADD_NULL_DAT: In this state, no data is formed and the fifo write enable
   // is pulled low for a clock cycle.
   //********************************************************************
   assign cur_data_in_lsd = cur_data_in[31:0];
   assign cur_data_in_msd = cur_data_in[63:32];
   assign cur_data_in_lsc = cur_data_in[67:64];
   assign cur_data_in_msc = cur_data_in[71:68];
   
   assign nx0_data_in_lsd = nx0_data_in[31:0];
   assign nx0_data_in_msd = nx0_data_in[63:32];
   assign nx0_data_in_lsc = nx0_data_in[67:64];
   assign nx0_data_in_msc = nx0_data_in[71:68];

//   assign block_lock 	= 	cur_data_in[PCSDWIDTH + CTL_BFL];	// Frame lock or Block lock status
//   assign block_lock 	= 	((phcomp_mode || basic_generic_mode) && wr_data_in[PCSDWIDTH + CTL_BFL] && (~r_bypass_blksync || r_fec_en)) || (base_r_clkcomp_mode && cur_data_in[PCSDWIDTH + CTL_BFL]);	// Frame lock or Block lock status
   assign block_lock 	= 	cur_data_in[PCSDWIDTH + CTL_BFL];

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         block_lock_lt            <= 1'b0;
      end
      else begin
         block_lock_lt            <= block_lock || (block_lock_lt && r_write_ctrl);
      end   
   end
   
   assign block_lock_int = r_write_ctrl ? (block_lock_lt ||block_lock) : block_lock;
   
   // Sequintial Part of SM
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_en            <= 1'b0;
         wr_del_sm        <= WR_IDLE;
         wr_data	  <= FIFO_DEFAULT[FDWIDTH-3: 0];
         store_lsd        <= 'd0; 
         store_lsc        <= 'd0; 
	 keep_store  	  <= 1'b0;
      end
      else if (!block_lock_int) begin
         wr_en            <= 1'b0;
         wr_del_sm        <= WR_IDLE;
         wr_data	  <= FIFO_DEFAULT[FDWIDTH-3: 0];
         store_lsd        <= 'd0; 
         store_lsc        <= 'd0; 
	 keep_store  	  <= 1'b0;
      end   

      else if (nx0_data_valid_in  && dv_2x_reg) begin
	 keep_store  	  <= 'd0;
         
         case(wr_del_sm)
           WR_IDLE: begin
              casez({wr_pfull,  nx0_msoctet_del,nx0_lsoctet_del,  cur_msoctet_del,cur_lsoctet_del})
                5'b1_?0_01: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
                end
                5'b1_?0_10: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_lsc};    // Control Bits
                end
                5'b1_01_01: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
                end
                5'b1_01_10: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_lsc};    // Control Bits
                end
                5'b1_11_01: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT; 
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_msd; // Data Bits
                   store_lsc        <= cur_data_in_msc; // Data Bits
	 	   keep_store  	    <= 'd1;
                end
                5'b1_11_10: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT; 
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_lsd; // Data Bits
                   store_lsc        <= cur_data_in_lsc; // Control Bits 
	 	   keep_store  	    <= 'd1;
                end
                5'b1_??_11: begin
                   wr_del_sm        <= WR_IDLE;
                   wr_en            <= 1'b0;
                end
                default: begin
                   wr_del_sm        <= WR_IDLE;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
                end
              endcase
           end
           WR_ADD_NXT_DAT: begin 
              casez({wr_pfull,nx0_msoctet_del,nx0_lsoctet_del,cur_msoctet_del})
                4'b1_?_01: begin
                   wr_del_sm        <= WR_IDLE; 
                   wr_en            <= 1'b0;
                end
                4'b1_0_10: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
                end
                4'b1_1_10: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT; 
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_msd; // Data Bits
                   store_lsc        <= cur_data_in_msc; // Control Bits
                   keep_store	    <= 1'b1;
                end
	        4'b1_0_11: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT; 
                   wr_en            <= 1'b0;
                   store_lsd        <= nx0_data_in_msd; // HN
                   store_lsc        <= nx0_data_in_msc; // HN
	           keep_store  	    <= 1'b1;
                end
                4'b1_1_11: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b0;
                end
                default: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
                end
              endcase
           end
           WR_ADD_STOR_DAT: begin
              casez({wr_pfull,cur_msoctet_del,cur_lsoctet_del})
                3'b1_01: begin
                   if (!keep_store) begin  
                      wr_del_sm        <= WR_IDLE; 
                      wr_en            <= 1'b1;
                      wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd , store_lsd}; // Data Bits
                      wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_msc , store_lsc}; // Control Bits
                   end
                   else begin
                      wr_del_sm        <= WR_ADD_STOR_DAT;
                      wr_en            <= 1'b0;
                   end
                end
                3'b1_10: begin
                   wr_del_sm        <= WR_IDLE; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                end
                3'b1_00: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   store_lsd        <= cur_data_in_msd;               // Data Bits
                   store_lsc        <= cur_data_in_msc;               // Control Bits
                end
                3'b1_11: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                end
                default: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   store_lsd        <= cur_data_in_msd;               // Data Bits
                   store_lsc        <= cur_data_in_msc;               // Control Bits
                end



                3'b0_??: begin
                   if (keep_store) begin  
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                   end
                   else begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   store_lsd        <= cur_data_in_msd;               // Data Bits
                   store_lsc        <= cur_data_in_msc;               // Control Bits
                   end
                end



                
              endcase
           end
           WR_ADD_NULL_DAT: begin 
              wr_del_sm        <= WR_IDLE; 
              wr_en            <= 1'b0;
           end
           
           default: begin
              wr_del_sm        <= WR_IDLE;
              wr_en            <= 1'b1;
              wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
              wr_data[FDWIDTH-3: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
           end
           
         endcase
      end
      else if (dv_2x_reg) begin
         wr_en            <= 1'b0;
      end
   end



// 10G BaseR Deletion Flag
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         fifo_del  	<= 1'b0;
      end
//      else if (wr_en != cur_data_valid_in) begin
//         fifo_del  	<= 1'b1;
//      end
//      else if (cur_data_valid_in) begin
//         fifo_del  	<= 1'b0;
//      end
//   end     
// Bug fix: de-assert fifo_del after it's has been written to FIFO on next word
//      else if (block_lock_lt) begin
//         fifo_del  	<= (wr_en != cur_data_valid_in);
//      end
//   end
      else if (block_lock_lt && dv_2x_reg) begin 
        if (fifo_del && !wr_en) begin
	      fifo_del <= 1'b1;
	   end
        else if (wr_en != cur_data_valid_in || (wr_en & wr_full) ) begin
            fifo_del  	<= 1'b1; 
        end
        else begin 
            fifo_del  	<= 1'b0;      
        end
     end
   end   

   // Attach block lock and deletion flag to write data  
//   assign {control_out, data_out} = {block_lock_lt, fifo_del, wr_data[FDWIDTH-3:0]};

   assign     wr_srst_n    = (block_lock || r_write_ctrl); 
   

//   assign data_out = {wr_data[PCSDWIDTH-1:0], 2'b00, wr_srst_n, wr_en, block_lock_lt, fifo_del, wr_data[FDWIDTH-3: FDWIDTH-10]};  

assign data_out_del_sm_aib_2x = teng_2_aib_map({wr_en, block_lock_lt, fifo_del, wr_data[71:64], wr_data[63:0]});  

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      data_out_del_sm_aib            <= 40'd0;
      del_sm_wr_en		     <= 1'b0;
   end
   else begin
      data_out_del_sm_aib            <= dv_2x ? data_out_del_sm_aib_2x[39:0] : data_out_del_sm_aib_2x[79:40];
      del_sm_wr_en		     <= wr_en;
   end   
end


assign data_out = ~base_r_clkcomp_mode ? aib_fabric_rx_data_in : data_out_del_sm_aib;  

function [79:0] teng_2_aib_map;
   input [74:0] teng_in;
   begin
// MB, rsvd, 38-b data, MB, 2 rsvd, 10-b control dv, 26-b data  --> New map: MB, 1b rsvd, ctrl[9:4], data[63:32], MB, 2-b rsvd, dv, ctrl[3:0], data[31:0] 
//     teng_2_aib_map = {1'b1, 1'b0, teng_in[63:26], 1'b0, 2'b00,teng_in[73:64], teng_in[74],teng_in[25:0]};
     teng_2_aib_map = {1'b1, 1'b0, teng_in[73:68], teng_in[63:32], 1'b0, 2'b00,teng_in[74], teng_in[67:64],teng_in[31:0]};
   end
endfunction


function [74:0] aib_2_teng_map;
   input [79:0] aib_data;
   begin
//     aib_2_teng_map = {aib_data[26], aib_data[36:27], aib_data[77:40], aib_data[25:0]};
     aib_2_teng_map = {aib_data[36], aib_data[77:72], aib_data[35:32], aib_data[71:40], aib_data[31:0]};
   end
endfunction

assign deletion_sm_testbus =	{9'd0, cur_msoctet_term, cur_lsoctet_term, cur_msoctet_os, cur_lsoctet_os, cur_msoctet_del, cur_lsoctet_del, wr_full, wr_pfull , wr_del_sm[1:0], wr_en, fifo_del};


endmodule
