// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_tx_datapath_frame_gen.v.rca $
// Revision:    $Revision: #9 $
// Date:        $Date: 2015/03/23 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_tx_datapath_frame_gen
(   
    input  wire                 clk,             // Clock  
    input  wire                 rst_n,           // Active low reset 
    input  wire                 r_bypass_frmgen, // Bypass frame encoder
    input  wire                 r_pipeln_frmgen,// Latency enhanced frame encoder
    input  wire [15:0] 		r_mfrm_length,   // Programmable Meta Frame Length
    input  wire                 r_pyld_ins,      // Payload words to replace skips
    input  wire                 r_sh_err,        // Sync header error insertion
    input  wire                 r_burst_en,      // special burst en feature en
    input  wire                 r_wordslip,       // special wordslip feature en
    input  wire                 r_indv,
    input  wire                 data_valid_in_raw,   // From DV gen
    input  wire			data_valid_2x,       // Toggling DV from DV gen   
    input  wire			start_dv, 
//    input  wire			data_valid_in,       // Toggling DV from DV gen   
    input  wire [1:0]           diag_status,     // Status message of health
    input  wire                 burst_en,        // Burst enable 
    input  wire                 wordslip,        // Word slip 
    input  wire                 rd_pfull,        // FIFO read partially full 
    input  wire [39:0]		tx_fifo_data,
    input  wire [39:0]          fifo_out_comb,        // Read Data Out (Contains CTRL+DATA)
    
    output reg  [39:0]		aib_fabric_tx_data_out,
    
    output reg                  rd_en,           // FIFO read data_validble
    output wire                 tx_frame,         // Transmitted frame signal
    output reg                  burst_en_exe,     // burst en ack
    output reg                  wordslip_exe,     // wordslip en ack
    output wire [19:0]          frame_gen_testbus1,  // testbus
    output wire [19:0]          frame_gen_testbus2   // testbus
   );
   
   // Define Parameters 
//`include "hdpldadapt_params.v"
// Interlaken Parameters
   // Spec Definitions
   // Block Type
   localparam               SYNC_DWRD = 2'b01;
   localparam               SYNC_CWRD = 2'b10;
   localparam               FCTRL = 1'b0;
   localparam               PCTRL = 1'b1;
   localparam               BT_SYNC = 5'b11110;
   localparam               BT_SCRM = 5'b01010;
   localparam               BT_SKIP = 5'b00111;
   localparam               BT_DIAG = 5'b11001;

   // Implementation specific parameters
   // Framing Control Bits 
   localparam               CTL_INVB         = 'd2;
   localparam               CTL_PYLD         = 'd3;
   localparam               CTL_SYNC         = 'd4;
   localparam               CTL_SCRM         = 'd5;
   localparam               CTL_SKIP         = 'd6;
   localparam               CTL_DIAG         = 'd7;


   // Shared Parameters
   // Control Bits 
   localparam               CTL_DATA         = 'd0;
   localparam               CTL_CTRL         = 'd1;
   localparam               CTL_ERR          = 'd8;
   localparam               CTL_BFL          = 'd9;


   localparam			  DWIDTH    = 'd64;
   localparam			  CWIDTH    = 'd9;
   localparam 			  WORD_SIZE = 'd64;       // Word size 
   localparam 			  MFRM_SIZE = 'd16;  
   
   // State Machine Variables
   localparam                     RESET           = 4'd0;
   localparam                     SYNC            = 4'd1;
   localparam                     SCRM            = 4'd2;
   localparam                     SKIP            = 4'd3;
   localparam                     PYLD_DATA       = 4'd4;
   localparam                     PYLD_DATA_SLIP  = 4'd5;
   localparam                     PYLD_SKIP       = 4'd6;
   localparam                     PYLD_SKIP_SLIP  = 4'd7;
   localparam                     DIAG            = 4'd8;
   
   
   reg [3:0]                      frame_gen_sm_ns, frame_gen_sm;
   reg [MFRM_SIZE-1:0]            frame_cnt_ns, frame_cnt;
   reg                            frame_cnt_ns_co;
      
   reg                            rd_en_ctl_comb, rd_en_ctl;
   reg                            lat_burst_en_comb, lat_burst_en;
   reg                            burst_en_exe_comb;
   reg                            wordslip_exe_comb;
   reg                            insert_sync_comb, insert_sync_d1;
   reg                            insert_scrm_comb, insert_scrm_d1;
   reg                            insert_skip_comb, insert_skip_d1;
   reg                            insert_diag_comb, insert_diag_d1;
   reg                            data_valid_raw_d1;
      
   reg                            wordslip_posedge, wordslip_d1;
   reg                            wordslip_req_comb, wordslip_req;
   reg                            burst_en_req_comb, burst_en_req;
   reg                            clr_frame_cnt_comb, clr_frame_cnt;
   reg                            incr_frame_cnt_comb, incr_frame_cnt;
   
   reg                            data_valid_comb, data_valid_d1;          // Valid
   reg [DWIDTH-1:0]               data_comb, data_d1;          // Data
   reg [CWIDTH-1:0]               control_comb, control_d1;
   reg [1:0]                      diag_status_comb, diag_status_reg;

   
   wire [1:0]                     diag_status_int;
   wire                           burst_en_int;
   wire                           wordslip_int;

   wire                           insert_sync_delay;
   wire                           insert_scrm_delay;
   wire                           insert_skip_delay;
   wire                           insert_diag_delay;
   wire                           data_valid_raw_delay;

   reg                  	  data_valid_out; 
   reg [DWIDTH-1:0]               data_out;
   reg [CWIDTH-1:0]               control_out;
   
   wire				  data_valid_in;
   wire [DWIDTH-1:0]              data_in;
   wire [CWIDTH-1:0]              control_in;
   
   reg  [79:0]			  fifo_in_2x;
   wire [79:0]			  aib_tx_data_2x;
//   reg  [39:0]			  tx_fifo_data_delay;
//   reg				  data_valid_2x_delay;   
 
   wire [WORD_SIZE-1:0] 	  r_sync_word;     // Programmable Sync Word Value
   wire [WORD_SIZE-1:0] 	  r_scrm_word;     // Programmable Scrm Word Value
   wire [WORD_SIZE-1:0]           r_skip_word;     // Programmable Skip Word Value
   wire [WORD_SIZE-1:0]           r_diag_word;     // Programmable Diag Word Value

   assign r_sync_word 	= 64'h78F678F678F678F6;
   assign r_scrm_word	= 64'h2800000000000000;
   assign r_diag_word	= 64'h6400000000000000; 
   assign r_skip_word 	= 64'h1E1E1E1E1E1E1E1E;
   
   // Extract 10g data and control from fifo data at 2x clock

//   always@(posedge clk or negedge rst_n) begin 
//      if (!rst_n) begin
//        fifo_in_2x 		<= 	'd0;
//
//      end // if (!rst_n)
//      else begin
//        fifo_in_2x[79:40]	<= tx_fifo_data[39] ? tx_fifo_data: fifo_in_2x[79:40];
//        fifo_in_2x[39:0]	<= ~tx_fifo_data[39] ? tx_fifo_data: fifo_in_2x[39:0];
//      end // else: !if(!rst_n)
//   end // always@ (posedge clk or negedge rst_n)


   always@(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin
        fifo_in_2x 		<= 	'd0;

      end // if (!rst_n)
      else if (data_valid_2x) begin
        fifo_in_2x		<=  {fifo_out_comb, tx_fifo_data};
      end // else: !if(!rst_n)
   end // always@ (posedge clk or negedge rst_n)

//   always@(posedge clk or negedge rst_n) begin 
//      if (!rst_n) begin
//        data_valid_2x_delay 		<= 	'd0;
//        tx_fifo_data_delay		<=	'd0;
//      end // if (!rst_n)
//      else begin
//        data_valid_2x_delay		<= 	data_valid_2x;
//        tx_fifo_data_delay		<=	tx_fifo_data;
//     end // else: !if(!rst_n)
//   end // always@ (posedge clk or negedge rst_n)
        

   assign {data_valid_in, control_in, data_in} = aib_2_teng_map(fifo_in_2x);
   

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (4),
       .VID (1)
       )
    cdclib_bitsync2_wordslip
      (
       .clk      (clk),
       .rst_n    (rst_n),
       .data_in  (wordslip),
       .data_out (wordslip_int)
       );

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (4),
       .VID (1)
       )
    cdclib_bitsync2_burst_en
      (
       .clk      (clk),
       .rst_n    (rst_n),
       .data_in  (burst_en),
       .data_out (burst_en_int)
       );

   cdclib_bitsync2 
     #(
       .DWIDTH      (2),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (3),
       .VID (1)
       )
    cdclib_bitsync2_diag_status
      (
       .clk      (clk),
       .rst_n    (rst_n),
       .data_in  (diag_status),
       .data_out (diag_status_int)
       );
   
   assign tx_frame = insert_sync_d1;
   

   always @* begin

      if (!data_valid_in_raw) begin
         // when !data_valid_in retain previous value
         frame_gen_sm_ns =  frame_gen_sm;
         rd_en_ctl_comb = rd_en_ctl;
         lat_burst_en_comb = lat_burst_en;
         burst_en_exe_comb = burst_en_exe;
         wordslip_exe_comb = wordslip_exe;
         insert_sync_comb = insert_sync_d1;
         insert_scrm_comb = insert_scrm_d1;
         insert_skip_comb = insert_skip_d1;
         insert_diag_comb = insert_diag_d1;
         clr_frame_cnt_comb = clr_frame_cnt;
         incr_frame_cnt_comb = incr_frame_cnt;
         
         // Non-registered SM outputs have no previous value to retain (no FF), so set to 0 by default
         
      end else begin // if (!data_valid_in_raw)
         // when data_valid_in default assignments to CS for SM
         frame_gen_sm_ns =  frame_gen_sm;

         // when data_valid_in default assignments to 0 for all outputs
         rd_en_ctl_comb = 1'b0;
         lat_burst_en_comb = 1'b0;
         burst_en_exe_comb = 1'b0;
         wordslip_exe_comb = 1'b0;
         insert_sync_comb = 1'b0;
         insert_scrm_comb = 1'b0;
         insert_skip_comb = 1'b0;
         insert_diag_comb = 1'b0;
         clr_frame_cnt_comb = 1'b0;
         incr_frame_cnt_comb = 1'b0;

         case (frame_gen_sm)
           RESET: begin
              frame_gen_sm_ns = SYNC;
              clr_frame_cnt_comb = 1'b1;
              insert_sync_comb = 1'b1;
           end
           SYNC: begin
              frame_gen_sm_ns = SCRM;
              incr_frame_cnt_comb = 1'b1;
              lat_burst_en_comb = 1'b1;
              insert_scrm_comb = 1'b1;
           end
           SCRM: begin
//              if ((r_indv ? rd_pfull : comp_rd_pfull) && r_pyld_ins && ((burst_en_req && r_burst_en) || !r_burst_en)) begin
              if (rd_pfull && r_pyld_ins && ((burst_en_req && r_burst_en) || !r_burst_en)) begin
                 frame_gen_sm_ns = PYLD_DATA;
                 rd_en_ctl_comb = 1'b1;
                 incr_frame_cnt_comb = 1'b1;
                 if (burst_en_req && r_burst_en) begin
                    burst_en_exe_comb = 1'b1;
                 end
              end else begin
                 frame_gen_sm_ns = SKIP;
                 incr_frame_cnt_comb = 1'b1;
                 insert_skip_comb = 1'b1;
              end
           end // case: SCRM
           SKIP: begin
              if (frame_cnt == r_mfrm_length-'d2) begin
                 frame_gen_sm_ns = DIAG;
                 incr_frame_cnt_comb = 1'b1;
                 insert_diag_comb = 1'b1;
              end
              else if ((burst_en_req && r_burst_en) || !r_burst_en) begin
                 frame_gen_sm_ns = PYLD_DATA;
                 rd_en_ctl_comb = 1'b1;
                 incr_frame_cnt_comb = 1'b1;
                 if (burst_en_req && r_burst_en) begin
                    burst_en_exe_comb = 1'b1;
                 end
              end else begin
                 frame_gen_sm_ns = PYLD_SKIP;
                 incr_frame_cnt_comb = 1'b1;
                 insert_skip_comb = 1'b1;
              end
           end // case: SKIP
           PYLD_DATA: begin
              if (frame_cnt == r_mfrm_length-'d2) begin
                 frame_gen_sm_ns = DIAG;
                 incr_frame_cnt_comb = 1'b1;
                 insert_diag_comb = 1'b1;
              end
              else if (wordslip_req && r_wordslip) begin
                 frame_gen_sm_ns = PYLD_DATA_SLIP;
                 wordslip_exe_comb = 1'b1;
                 rd_en_ctl_comb = 1'b1;
              end else begin
                 rd_en_ctl_comb = 1'b1;
                 incr_frame_cnt_comb = 1'b1;
              end
           end // case: PYLD_DATA
           PYLD_DATA_SLIP: begin
              frame_gen_sm_ns = PYLD_DATA;
              rd_en_ctl_comb = 1'b1;
              incr_frame_cnt_comb = 1'b1;
           end
           PYLD_SKIP: begin
              if (frame_cnt == r_mfrm_length-'d2) begin
                 frame_gen_sm_ns = DIAG;
                 incr_frame_cnt_comb = 1'b1;
                 insert_diag_comb = 1'b1;
              end
              else if (wordslip_req && r_wordslip) begin
                 frame_gen_sm_ns = PYLD_SKIP_SLIP;
                 wordslip_exe_comb = 1'b1;
                 insert_skip_comb = 1'b1;
              end else begin
                 incr_frame_cnt_comb = 1'b1;
                 insert_skip_comb = 1'b1;
              end
           end // case: PYLD_SKIP
           PYLD_SKIP_SLIP: begin
              frame_gen_sm_ns = PYLD_SKIP;
              incr_frame_cnt_comb = 1'b1;
              insert_skip_comb = 1'b1;
           end
           DIAG: begin
              frame_gen_sm_ns = SYNC;
              clr_frame_cnt_comb = 1'b1;
              insert_sync_comb = 1'b1;
           end
           default: begin
              frame_gen_sm_ns = RESET;
              clr_frame_cnt_comb = 1'b1;
           end
         endcase // case(frame_gen_sm)
      end // else: !if(!data_valid_in_raw)

      
      frame_cnt_ns = frame_cnt;
      frame_cnt_ns_co = 1'b0;     
      if (clr_frame_cnt_comb) begin
         frame_cnt_ns = {MFRM_SIZE{1'b0}};
      end else if (incr_frame_cnt_comb && data_valid_in_raw) begin
         {frame_cnt_ns_co, frame_cnt_ns} = frame_cnt + 1'b1;
      end

      wordslip_req_comb = wordslip_req;
      wordslip_posedge = !wordslip_d1 && wordslip_int;
      if (wordslip_exe_comb) begin
         wordslip_req_comb = 1'b0;
      end else if (wordslip_posedge) begin
         wordslip_req_comb = 1'b1;
      end
      
      burst_en_req_comb = burst_en_req;
      if (lat_burst_en_comb) begin
         burst_en_req_comb = burst_en_int;
      end

      diag_status_comb = diag_status_int;

      rd_en = 1'b0;
      // Read enable to be asserted when block is bypassed
      // FIFO should handle read when empty to reduce latency
      if (r_bypass_frmgen || rd_en_ctl_comb) begin
         rd_en = data_valid_in_raw;
      end

   end // always @ *


// Data control
   always @* begin
      data_valid_comb = data_valid_d1;         
      data_comb = data_d1;
      control_comb = control_d1;
      data_valid_out = 1'b0;
      data_out = {DWIDTH{1'b0}};
      control_out = {CWIDTH{1'b0}};
      
      if (data_valid_raw_delay) begin
         // Set to the input value by default
         // - Particular bus bits will be overwritten
         control_comb = control_in;

         // Create sync header error
         if (r_sh_err && control_in[CTL_ERR]) begin
// Lint fix            control_comb[CTL_CTRL] = ~control_comb[CTL_CTRL];
            control_comb[CTL_CTRL] = ~control_in[CTL_CTRL];
         end

         case ({insert_sync_delay,insert_scrm_delay,insert_skip_delay,insert_diag_delay})
           4'b1000: begin
              // Create Synchronize word
              data_valid_comb = 1'b1;
              // {FCTRL,BT_SYNC,58'h0F6_78F6_78F6_78F6}; 
              data_comb = r_sync_word;
              control_comb[CTL_INVB] = 1'b0;
              control_comb[CTL_CTRL] = 1'b1;
              control_comb[CTL_DATA] = 1'b0;
              // sync framing layer control word
              control_comb[CTL_PYLD] = 1'b0;
              control_comb[CTL_SYNC] = 1'b1;
              control_comb[CTL_SCRM] = 1'b0;
              control_comb[CTL_SKIP] = 1'b0;
              control_comb[CTL_DIAG] = 1'b0;
              control_comb[CTL_ERR]  = 1'b0;	// see FB
           end
           4'b0100: begin
              // Create Scrambler State word
              data_valid_comb = 1'b1;
              // {FCTRL,BT_SCRM,58'h000_0000_0000_0000};
              data_comb = r_scrm_word;
              control_comb[CTL_INVB] = 1'b0;
              control_comb[CTL_CTRL] = 1'b1;
              control_comb[CTL_DATA] = 1'b0;
              // scrm framing layer control word
              control_comb[CTL_PYLD] = 1'b0;
              control_comb[CTL_SYNC] = 1'b0;
              control_comb[CTL_SCRM] = 1'b1;
              control_comb[CTL_SKIP] = 1'b0;
              control_comb[CTL_DIAG] = 1'b0;
              control_comb[CTL_ERR]  = 1'b0;	// see FB
           end
           4'b0010: begin
              // Create Skip word
              data_valid_comb = 1'b1;
              // {FCTRL,BT_SKIP,58'h21E_1E1E_1E1E_1E1E};
              data_comb = r_skip_word;
              control_comb[CTL_INVB] = 1'b0;
              control_comb[CTL_CTRL] = 1'b1;
              control_comb[CTL_DATA] = 1'b0;
              // skip framing layer control word
              control_comb[CTL_PYLD] = 1'b0;
              control_comb[CTL_SYNC] = 1'b0;
              control_comb[CTL_SCRM] = 1'b0;
              control_comb[CTL_SKIP] = 1'b1;
              control_comb[CTL_DIAG] = 1'b0;
              control_comb[CTL_ERR]  = 1'b0;	// see FB
           end
           4'b0001: begin
              // Create Diagnostic word
              data_valid_comb = 1'b1;
              // {FCTRL,BT_DIAG,24'h00_0000,diag_status[1:0],32'h0000_0000};
              data_comb[WORD_SIZE-1:34] = r_diag_word[WORD_SIZE-1:34];
              data_comb[33:32] = diag_status_reg[1:0];
              data_comb[31:0] = r_diag_word[31:0];
              control_comb[CTL_INVB] = 1'b0;
              control_comb[CTL_CTRL] = 1'b1;
              control_comb[CTL_DATA] = 1'b0;
              // diag framing layer control word
              control_comb[CTL_PYLD] = 1'b0;
              control_comb[CTL_SYNC] = 1'b0;
              control_comb[CTL_SCRM] = 1'b0;
              control_comb[CTL_SKIP] = 1'b0;
              control_comb[CTL_DIAG] = 1'b1;
              control_comb[CTL_ERR]  = 1'b0;	// see FB
           end
           4'b0000: begin
              // Create Payload word
              if (data_valid_in) begin
                 data_valid_comb = 1'b1;
                 data_comb = data_in;
                 // control bus passes through, other than framing layer specific flags
                 control_comb[CTL_INVB] = 1'b0;
                 // no framing layer control word
                 control_comb[CTL_PYLD] = 1'b0;
                 control_comb[CTL_SYNC] = 1'b0;
                 control_comb[CTL_SCRM] = 1'b0;
                 control_comb[CTL_SKIP] = 1'b0;
                 control_comb[CTL_DIAG] = 1'b0;
              end else begin
                 // Skip words should be asserted if input data is not valid
                 data_valid_comb = 1'b1;
                 // {FCTRL,BT_SKIP,58'h21E_1E1E_1E1E_1E1E};
                 data_comb = r_skip_word;
                 control_comb[CTL_INVB] = 1'b0;
                 control_comb[CTL_CTRL] = 1'b1;
                 control_comb[CTL_DATA] = 1'b0;
                 // skip framing layer control word
                 control_comb[CTL_PYLD] = 1'b0;
                 control_comb[CTL_SYNC] = 1'b0;
                 control_comb[CTL_SCRM] = 1'b0;
                 control_comb[CTL_SKIP] = 1'b1;
                 control_comb[CTL_DIAG] = 1'b0;
              end
           end
           default: begin
              data_valid_comb = 1'b0;
              // {FCTRL,BT_SKIP,58'h21E_1E1E_1E1E_1E1E};
              data_comb = r_skip_word;
              control_comb[CTL_INVB] = 1'b0;
              control_comb[CTL_CTRL] = 1'b1;
              control_comb[CTL_DATA] = 1'b0;
              // skip framing layer control word
              control_comb[CTL_PYLD] = 1'b0;
              control_comb[CTL_SYNC] = 1'b0;
              control_comb[CTL_SCRM] = 1'b0;
              control_comb[CTL_SKIP] = 1'b1;
              control_comb[CTL_DIAG] = 1'b0;
              control_comb[CTL_ERR]  = 1'b0;	// see FB
           end
         endcase // case({insert_sync_delay,insert_scrm_delay,insert_skip_delay,insert_diag_delay})
                  
      end else begin
         // Gate the output valid with data data_validble
         data_valid_comb = 1'b0; 
      end // else: !if(data_valid_raw_delay)
            

      // Output data bus 
//      if (r_bypass_frmgen) begin
//         data_valid_out = data_valid_in;
//         data_out = data_in;
//         control_out = control_in;
//      end else if (r_pipeln_frmgen) begin
      if (r_pipeln_frmgen) begin
         data_valid_out = data_valid_d1;
         data_out = data_d1;
         control_out = control_d1;
      end else begin
         data_valid_out = data_valid_comb;
         data_out = data_comb;
         control_out = control_comb;
      end

   end // always @ *


   

   
   // SM controls: 1x clock
   always@(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin
         // flop_defaults
         frame_gen_sm <= RESET;
         frame_cnt <= {MFRM_SIZE{1'b0}};
         rd_en_ctl <= 1'b0;
         lat_burst_en <= 1'b0;
         burst_en_exe <= 1'b0;
         wordslip_exe <= 1'b0;
         data_valid_raw_d1 <= 1'b0;
         insert_sync_d1 <= 1'b0; 
         insert_scrm_d1 <= 1'b0; 
         insert_skip_d1 <= 1'b0; 
         insert_diag_d1 <= 1'b0; 
         wordslip_d1 <= 1'b0;
         wordslip_req <= 1'b0;
         burst_en_req <= 1'b0;
         diag_status_reg <= 2'b00;
         clr_frame_cnt <= 1'b0;
         incr_frame_cnt <= 1'b0;
      end // if (!rst_n)
      else if (data_valid_2x) begin
         frame_gen_sm <= frame_gen_sm_ns;
         frame_cnt <= frame_cnt_ns;
         rd_en_ctl <= rd_en_ctl_comb;
         lat_burst_en <= lat_burst_en_comb;
         burst_en_exe <= burst_en_exe_comb;
         wordslip_exe <= wordslip_exe_comb;
         data_valid_raw_d1 <= data_valid_in_raw;
         insert_sync_d1 <= insert_sync_comb; 
         insert_scrm_d1 <= insert_scrm_comb; 
         insert_skip_d1 <= insert_skip_comb; 
         insert_diag_d1 <= insert_diag_comb; 
         wordslip_d1 <= wordslip_int;
         wordslip_req <= wordslip_req_comb;
         burst_en_req <= burst_en_req_comb;
         diag_status_reg <= diag_status_comb;
         clr_frame_cnt <= clr_frame_cnt_comb;
         incr_frame_cnt <= incr_frame_cnt_comb;
      end // else: !if(!rst_n)
   end // always@ (posedge clk or negedge rst_n)




// Data 
   always@(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin
         // flop_defaults
         data_valid_d1 <= 1'b0;
         data_d1 <= {DWIDTH{1'b0}};
         control_d1 <= {CWIDTH{1'b0}};
      end // if (!rst_n)
      else if (data_valid_2x) begin
         data_valid_d1 <= data_valid_comb;
         data_d1 <= data_comb;
         control_d1 <= control_comb;
      end // else: !if(!rst_n)
   end // always@ (posedge clk or negedge rst_n)
   

   assign frame_gen_testbus1 = {
//                                1'b0,
//                                data_valid_in_raw,
//                                rd_en,
                                frame_cnt,	// SV: 13-bit, NF: 16-bit
                                frame_gen_sm};

   assign frame_gen_testbus2 = {10'd0,
                                data_valid_in_raw,
                                rd_en,
                                data_valid_in,
                                data_valid_out,
                                insert_sync_d1,
                                insert_scrm_d1,
                                insert_skip_d1,
                                insert_diag_d1,
                                wordslip_req,
                                burst_en_req};

assign 	insert_sync_delay	= insert_sync_d1;
assign 	insert_scrm_delay	= insert_scrm_d1;
assign 	insert_skip_delay	= insert_skip_d1;
assign 	insert_diag_delay	= insert_diag_d1;
assign 	data_valid_raw_delay	= data_valid_raw_d1;

//                                       [74]     [73]              [72:64]      [63:0]  
assign aib_tx_data_2x = teng_2_aib_map({start_dv, data_valid_out, control_out, data_out});

function [79:0] teng_2_aib_map;
   input [74:0] teng_in;
   begin
// MB, rsvd, 38-b data, MB, 3 rsvd, dv, 26-b data --> MB, 1b rsvd, start_dv, ctrl[8:4], data[63:32], MB, 2-b rsvd, dv, ctrl[3:0], data[31:0]  
//     teng_2_aib_map = {1'b1, 1'b0, teng_in[63:26], 1'b0, teng_in[74], 2'b00,teng_in[72:64], teng_in[73],teng_in[25:0]};
     teng_2_aib_map = {1'b1, 1'b0,  teng_in[74], teng_in[72:68], teng_in[63:32], 1'b0, 2'b00,teng_in[73], teng_in[67:64],teng_in[31:0]};
   end
endfunction


function [73:0] aib_2_teng_map;
   input [79:0] aib_in;
   begin
//     aib_2_teng_map = {aib_in[26], aib_in[35:27], aib_in[77:40], aib_in[25:0]};
     aib_2_teng_map = {aib_in[36], aib_in[76:72], aib_in[35:32], aib_in[71:40], aib_in[31:0]};
   end
endfunction


// Data serializer
//always@(posedge clk or negedge rst_n) begin 
//   if (!rst_n) begin
//     aib_fabric_tx_data_out 		<= 	'd0;
//   end // if (!rst_n)
//   else begin
//     aib_fabric_tx_data_out		<= ~data_valid_2x ? aib_tx_data_2x[39:0] : aib_tx_data_2x[79:40];	 
//   end // else: !if(!rst_n)
//end // always@ (posedge clk or negedge rst_n)

always @* begin
  aib_fabric_tx_data_out		= r_bypass_frmgen? tx_fifo_data : (~data_valid_2x ? aib_tx_data_2x[39:0] : aib_tx_data_2x[79:40]);
end  
   
endmodule // hd_pcs10g_frame_gen


   
  
       
      
      
      
      
         
                 
              


































   

