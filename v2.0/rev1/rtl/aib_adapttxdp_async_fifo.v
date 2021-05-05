// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module aib_adapttxdp_async_fifo
  #(
    parameter DWIDTH = 'd80,             // FIFO Input data width 
    parameter AWIDTH = 'd4               // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_clk,      // Write Domain Clock
    input  wire              wr_en,       // Write Data Enable
    input  wire [DWIDTH*4-1:0] wr_data,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_clk,      // Read Domain Clock
    input  wire              rd_en,       // Read Data Enable
    input  wire [AWIDTH-1:0] r_pempty,    // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,     // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,     // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,      // FIFO full threshold
    input  wire	[1:0]	     r_fifo_mode, // FIFO 2'b00 1:1 FIFO mode 
                                          //      2'b01 2:1 FIFO mode
                                          //      2'b10 4:1 FIFO mode. 
                                          //      2'b11 reg mode. 
    output reg  [DWIDTH-1:0] rd_data,   // Read Data Out 
    
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
   wire                      wr_full_comb;    // FIFO Full
   wire                      wr_pfull_comb;   // FIFO Parial Full




   wire			   	full_rd_empty;
   wire			   	full_wr_full;
   wire	[DEPTH-1:0]		full_wr_ptr_one_hot;
   wire	[DEPTH-1:0]		full_rd_ptr_one_hot;
   wire	[AWIDTH-1:0]		full_wr_numdata;
   wire	[AWIDTH-1:0]		full_rd_numdata;
   wire	[AWIDTH-1:0]		full_rd_ptr_bin;
   wire	[AWIDTH-1:0]		full_wr_ptr_bin;
   
   wire [DWIDTH*4-1:0]		full_rd_data;
   wire [DWIDTH-1:0]		rd3, rd2, rd1, rd0;
   wire [DWIDTH-1:0]		wd3, wd2, wd1, wd0;

   

   reg [1:0]                    rd_cnt;   
   reg                          full_rd_en;
   
   //********************************************************************
   // FIFO RAM 
   //********************************************************************

   aib_adapttxdp_fifo_ram 
   # ( 
   .DWIDTH		(DWIDTH),
   .DEPTH		(DEPTH))
   ram (
   .wr_clk    			(wr_clk),
   .wr_rst_n  			(wr_rst_n),
   .wr_en     			(wr_en),
   .wr_ptr    			(full_wr_ptr_one_hot),
   .wr_data   			(wr_data),
   .rd_ptr    			(full_rd_ptr_one_hot),
   .rd_data   			(full_rd_data)
   );

   assign {rd3, rd2, rd1, rd0} = full_rd_data;
   assign {wd3, wd2, wd1, wd0} = wr_data;

   //********************************************************************
   // FIFO pointers 
   //********************************************************************
   aib_adapttxdp_fifo_ptr 
   # ( 
   .AWIDTH		(AWIDTH),
   .DEPTH		(DEPTH))
   full_pointers (
   .wr_clk     			(wr_clk),     
   .wr_rst_n   			(wr_rst_n),   
   .rd_clk     			(rd_clk),     
   .rd_rst_n   			(rd_rst_n),   
   .wr_en      			(wr_en),      
   .rd_en      			(full_rd_en),      
   .rd_empty			(full_rd_empty),
   .wr_ptr_one_hot	        (full_wr_ptr_one_hot),
   .rd_ptr_one_hot	        (full_rd_ptr_one_hot),
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

   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_cnt      <= 2'b0;
      end
      else begin

         // Generate counter that select rd data for full/half/quard data rate 
         if (rd_en == 1'b1)
         rd_cnt     <= rd_cnt + 1'b1;
      end
   end

   always @ * begin
      if (r_fifo_mode == FIFO_4X) full_rd_en = rd_en & (rd_cnt == 2'b11);
      else if (r_fifo_mode == FIFO_2X) full_rd_en = rd_en & (rd_cnt[0] == 1'b1);
      else                           full_rd_en = rd_en;
   end 

   //********************************************************************
   // FIFO Mapping
   //********************************************************************

   assign wr_numdata =  full_wr_numdata;    
   assign rd_numdata =  full_rd_numdata;
   

   
// Read data: concatenate data from multiple FIFOs


  always @ * begin
     case (r_fifo_mode)
       REG_MOD: rd_data = rd0;
       FIFO_1X: rd_data = rd0;
       FIFO_2X: case (rd_cnt[0])
                  1'b0: rd_data = rd0;
                  1'b1: rd_data = rd1;
                endcase
       FIFO_4X: case(rd_cnt) 
                  2'b00: rd_data = rd0;
                  2'b01: rd_data = rd1;
                  2'b10: rd_data = rd2;
                  2'b11: rd_data = rd3;
                endcase
     endcase
  end


endmodule 
