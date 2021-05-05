// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module aib_adaptrxdp_async_fifo
  #(
    parameter DWIDTH = 'd80,             // FIFO Input data width 
    parameter AWIDTH = 'd4             // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_clk,     // Write Domain Clock
    input  wire              wr_en,      // Write Data Enable
    input  wire [DWIDTH-1:0] wr_data,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_clk,     // Read Domain Clock
    input  wire              rd_en,      // Read Data Enable
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    input  wire	[1:0]	     r_fifo_mode, 	// FIFO double write mode
    input  wire              r_wa_en,    // word alignment enable
    input  wire              m_gen2_mode, //AIB2.0 Gen2 or Gen1 mode
    input  wire [4:0]        r_mkbit,     //Configurable marker bit (79:76 plus 39)
    
    
    output wire [DWIDTH*4-1:0] rd_data,    // Read Data Out 
    
    output reg               wa_lock,    
    output reg               wr_empty,   // FIFO Empty
    output reg               wr_pempty,  // FIFO Partial Empty
    output reg               wr_full,    // FIFO Full
    output reg               wr_pfull,   // FIFO Parial Full
    output reg               rd_empty,   // FIFO Empty
    output reg               rd_pempty,  // FIFO Partial Empty
    output reg               rd_full,    // FIFO Full 
    output reg               rd_pfull    // FIFO Partial Full 
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************

   localparam	DEPTH	  = (1<<AWIDTH);
   localparam   FIFO_1X   = 2'b00;       //Full rate
   localparam   FIFO_2X   = 2'b01;       //Half rate
   localparam   FIFO_4X   = 2'b10;       //Quarter Rate
   localparam   REG_MOD   = 2'b11;       //REG mode
   
   
   //********************************************************************
   // Define variables 
   //********************************************************************

   wire [AWIDTH-1:0] 	     rd_numdata; // Number of Data available in Read clock
   wire [AWIDTH-1:0] 	     wr_numdata; // Number of Data available in Write clock 

   reg  [11:0]               wm_history;


   wire			   	full_rd_en;      
   wire			   	full_rd_empty;
   wire			   	full_wr_full;
   wire	[DEPTH-1:0]		full_wr_ptr_one_hot;
   wire	[DEPTH-1:0]		full_rd_ptr_one_hot;
   wire	[AWIDTH-1:0]		full_wr_numdata;
   wire	[AWIDTH-1:0]		full_rd_numdata;
   wire	[AWIDTH-1:0]		full_rd_ptr_bin;
   wire	[AWIDTH-1:0]		full_wr_ptr_bin;
   
   wire [DWIDTH*4-1:0]          full_wr_data;
   reg  [DWIDTH-1:0]            wd3, wd2, wd1, wd0;
   wire                         wr_full_comb;
   wire                         wr_pfull_comb;


   reg [1:0]                    wr_cnt;
   reg                          full_wr_en;
   reg                          wm_bit;
   wire                         wa_lock_int;
   

   

   
   //********************************************************************
   // FIFO RAM 
   //********************************************************************

aib_adaptrxdp_fifo_ram 
  # ( 
  .DWIDTH		(DWIDTH),
  .DEPTH		(DEPTH))
    ram (
     .wr_clk    			(wr_clk),
     .wr_rst_n  			(wr_rst_n),
     .wr_en     			(full_wr_en),
     .wr_ptr    			(full_wr_ptr_one_hot),
     .wr_data   			(full_wr_data),
     .rd_ptr    			(full_rd_ptr_one_hot),
     .rd_data   			(rd_data)
     );



   //********************************************************************
   // FIFO pointers 
   //********************************************************************
aib_adaptrxdp_fifo_ptr 
  # ( 
  .AWIDTH        (AWIDTH),
  .DEPTH         (DEPTH))
  full_pointers (
     .wr_clk     			(wr_clk),     
     .wr_rst_n   			(wr_rst_n),   
     .rd_clk     			(rd_clk),     
     .rd_rst_n   			(rd_rst_n),   
     .wr_en      			(full_wr_en),      
     .rd_en      			(full_rd_en),      
     .rd_empty			        (full_rd_empty),
     .wr_ptr_one_hot			(full_wr_ptr_one_hot),
     .rd_ptr_one_hot			(full_rd_ptr_one_hot),
     .rd_ptr_bin			(full_rd_ptr_bin),
     .wr_ptr_bin			(full_wr_ptr_bin),
     .wr_numdata			(full_wr_numdata),
     .rd_numdata			(full_rd_numdata)
     );


   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate Fifo Number of Data Present 
   // using Write Address and Synchronized Read Address
   //********************************************************************
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_full   <= 1'b0;
         wr_pfull  <= 1'b0;
         wr_empty  <= 1'b1;
         wr_pempty <= 1'b1;
      end
      else begin
         
         // Generate FIFO Empty
         wr_empty  <= (wr_numdata <= r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty 
         wr_pempty <= (wr_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         wr_full   <= wr_full_comb; 
         // Generate FIFO Almost Full
         wr_pfull  <= wr_pfull_comb;
         
      end
   end

   assign wr_full_comb   = (wr_numdata >= r_full) ? 1'b1 : 1'b0;
   assign wr_pfull_comb  = (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;

   always @* begin
      casez (r_mkbit)
        5'b10000: wm_bit = wr_data[79];
        5'b01000: wm_bit = wr_data[78];
        5'b00100: wm_bit = wr_data[77];
        5'b00010: wm_bit = wr_data[76];
        5'b00001: wm_bit = wr_data[39];
        default: wm_bit = 1'b0; 
      endcase
   end

   assign wa_lock_int = (r_fifo_mode == FIFO_4X) ? ((wm_history==12'h111) ? 1'b1: 1'b0) :
                        (r_fifo_mode == FIFO_2X) ? ((wm_history[5:0]==6'h15)? 1'b1: 1'b0): 
                        1'b1;

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
        wr_cnt      <= 2'b00;
        wm_history  <= 12'h0;
        wa_lock     <= 1'b0;
      end
      else begin
        if (r_wa_en) begin
          wa_lock    <= wa_lock_int | wa_lock;
          wm_history <= {wm_history[10:0], wm_bit};
          if (wr_en) wr_cnt <= wr_cnt + 1'b1;;
        end
      end
   end


   always @(posedge wr_clk)  begin
     case (r_fifo_mode)
       FIFO_1X:  begin 
                   wd0 <= wr_data;
                  {wd1,wd2,wd3} <= 240'h0;
                 end
       REG_MOD:  begin
                   wd0 <= wr_data;
                  {wd1,wd2,wd3} <= 240'h0;
                 end
       FIFO_2X:  case (wr_cnt[0])
                   1'b0: begin 
                           if (m_gen2_mode) wd0 <= wr_data;
                           else wd0[39:0] <= wr_data[39:0];
                         end
                   1'b1: begin 
                           if (m_gen2_mode) wd1 <= wr_data;
                           else wd0[79:40] <= wr_data[39:0]; 
                         end
                 endcase
       FIFO_4X:  case(wr_cnt)
                   2'b00: wd0 <= wr_data;
                   2'b01: wd1 <= wr_data;
                   2'b10: wd2 <= wr_data;
                   2'b11: wd3 <= wr_data;
                 endcase
     endcase
  end

  assign full_wr_data = {wd3, wd2, wd1, wd0}; 

  always @(posedge wr_clk)  begin
      if (r_fifo_mode == FIFO_4X) full_wr_en <= wr_en & (wr_cnt == 2'b11);
      else if (r_fifo_mode == FIFO_2X) full_wr_en <= wr_en & (wr_cnt[0] == 1'b1);
      else                           full_wr_en <= wr_en;
   end
   //********************************************************************
   // READ CLOCK DOMAIN: Generate Fifo Number of Data Present
   // using Read Address and Synchronized Write Address
   //********************************************************************
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_empty    <= 1'b1;
         rd_pempty   <= 1'b1;
         rd_full     <= 1'b0;
         rd_pfull    <= 1'b0;
      end
      else begin
         
         // Generate FIFO Empty
         rd_empty    <= (rd_numdata <= r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty
         rd_pempty   <= (rd_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         rd_full     <= (rd_numdata >= r_full) ? 1'b1 : 1'b0; 
         // Generate FIFO Almost Full 
         rd_pfull    <= (rd_numdata >= r_pfull) ? 1'b1 : 1'b0;
         
      end
   end
   

   //********************************************************************
   // FIFO Mapping
   //********************************************************************

   assign full_rd_en  = rd_en;
   assign full_rd_empty = rd_empty;
   assign full_wr_full = wr_full;


   assign wr_numdata =  full_wr_numdata;    
   assign rd_numdata =  full_rd_numdata;
   


   

endmodule // aib_adaptrxdp_async_fifo


