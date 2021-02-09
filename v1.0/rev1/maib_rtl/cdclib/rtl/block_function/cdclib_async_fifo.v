// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_async_fifo.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//-----------------------------------------------------------------------------
// Description : Async. FIFO module
//-----------------------------------------------------------------------------
module cdclib_async_fifo
  #(
    parameter DWIDTH = 8,             // FIFO Input data width 
    parameter AWIDTH = 4,             // FIFO Depth (address width)
    parameter WR_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
    parameter RD_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
    parameter VID          = 1     // 1: VID, 0: preVID
    )
    (
    input  wire                   wr_rst_n,     // Write Domain Active low Reset
    input  wire                   wr_clk,       // Write Domain Clock
    input  wire                   wr_en,        // Write Data Enable
    input  wire [DWIDTH-1:0]      wr_data,      // Write Data In
    input  wire                   rd_rst_n,     // Read Domain Active low Reset
    input  wire                   rd_clk,       // Read Domain Clock
    input  wire                   rd_en,        // Read Data Enable
    input  wire [AWIDTH-1:0]      r_pempty,     // FIFO partially empty threshold
    input  wire [AWIDTH-1:0]      r_pfull,      // FIFO partially full threshold
    input  wire [AWIDTH-1:0]      r_empty,      // FIFO empty threshold
    input  wire [AWIDTH-1:0]      r_full,       // FIFO full threshold
    
    output wire [DWIDTH-1:0]      rd_data,      // Read Data Out 
    output wire [AWIDTH-1:0]      rd_numdata,   // Number of Data available in Read clock
    output wire [AWIDTH-1:0]      wr_numdata,   // Number of Data available in Write clock 
     
    output reg                    wr_empty,     // FIFO Empty
    output reg                    wr_pempty,    // FIFO Partial Empty
    output reg                    wr_full,      // FIFO Full
    output reg                    wr_pfull,     // FIFO Parial Full
    output reg                    rd_empty,     // FIFO Empty
    output reg                    rd_pempty,    // FIFO Partial Empty
    output reg                    rd_full,      // FIFO Full 
    output reg                    rd_pfull     // FIFO Partial Full 
     );
      
   //********************************************************************
   // Define variables 
   //********************************************************************
   integer                   m;
   // Regs
   reg [DWIDTH-1:0]          fifo_mem [((1<<AWIDTH)-1):0];
   reg [AWIDTH:0]            wr_addr_bin;
   reg [AWIDTH:0]            rd_addr_bin;
//   reg [AWIDTH:0]            rd_addr_bin_next_item;
   
   reg [AWIDTH:0]            wr_addr_gry;
   reg [AWIDTH:0]            rd_addr_gry;
   
   // Wires
   wire [AWIDTH-1:0]         wr_addr_mem;
   wire [AWIDTH-1:0]         rd_addr_mem;
//   wire [AWIDTH-1:0]         rd_addr_mem_next;
   
   wire [AWIDTH:0]           wr_addr_bin_nxt;
   wire [AWIDTH:0]           rd_addr_bin_nxt;
   wire [AWIDTH:0]           wr_addr_gry_nxt;
   wire [AWIDTH:0]           rd_addr_gry_nxt;
   wire [AWIDTH:0]           wr_addr_bin_sync;
   wire [AWIDTH:0]           rd_addr_bin_sync;
   wire [AWIDTH:0]           wr_addr_gry_sync;
   wire [AWIDTH:0]           rd_addr_gry_sync;

   
   //********************************************************************
   // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
   //********************************************************************
   
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
            fifo_mem[m] <= 'd0;	
         end
      end
//      else if (wr_srst_n == 1'b0) begin
//         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
//            fifo_mem[m] <= 'd0;	
//         end
//      end
   // Add option to allow write when full
      else if (wr_en && ~wr_full) begin
         fifo_mem[wr_addr_mem] <= wr_data;
      end
   end
   
   assign rd_data = fifo_mem[rd_addr_mem];


   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate WRITE Address & WRITE Address GREY
   //********************************************************************
   // Memory write-address pointer 
   assign wr_addr_mem = wr_addr_bin[AWIDTH-1:0];
   always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      wr_addr_bin <= {(AWIDTH+1){1'b0}};
      wr_addr_gry <= {(AWIDTH+1){1'b0}};
   end
   else begin
      wr_addr_bin <= wr_addr_bin_nxt;
      wr_addr_gry <= wr_addr_gry_nxt;
   end
   end
   // Binary Next Write Address 
   assign wr_addr_bin_nxt = wr_addr_bin + (wr_en & ~wr_full);
   
   // Grey Next Write Address 
//   assign wr_addr_gry_nxt = ((wr_addr_bin_nxt>>1) ^ wr_addr_bin_nxt);
   cdclib_bintogray 
   #(
      .WIDTH (AWIDTH+1)
    ) wr_addr_nxt_bintogray
    (
      .data_in (wr_addr_bin_nxt),
      .data_out (wr_addr_gry_nxt)
    );  
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Synchronize Read Address to Write Clock 
   //********************************************************************
   cdclib_bitsync2 
     #(
       .DWIDTH      (AWIDTH+1),    // Sync Data input 
       .RESET_VAL   (0),           // Reset value
       .CLK_FREQ_MHZ(WR_CLK_FREQ_MHZ),
       .TOGGLE_TYPE	(1),
       .VID		(VID)
      )
       wr_bitsync2
         (
          .clk      (wr_clk),
          .rst_n     (wr_rst_n),
          .data_in  (rd_addr_gry),
          .data_out (rd_addr_gry_sync)
          );
//   assign rd_addr_bin_sync = greytobin(rd_addr_gry_sync); 
   cdclib_graytobin 
   #(
      .WIDTH (AWIDTH+1)
    ) rd_addr_graytobin
    (
      .data_in (rd_addr_gry_sync),
      .data_out (rd_addr_bin_sync)
    );  
    
   assign wr_numdata       = (wr_addr_bin_nxt - rd_addr_bin_sync);
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate Fifo Number of Data Present 
   // using Write Address and Synchronized Read Address
   //********************************************************************
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_full  <= 1'b0;
         wr_pfull <= 1'b0;
         wr_empty <= 1'b1;
         wr_pempty<= 1'b1;
      end
      else begin
         
         // Generate FIFO Empty
         wr_empty  <= (wr_numdata == r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty 
         wr_pempty <= (wr_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         wr_full   <= (wr_numdata >= r_full) ? 1'b1 : 1'b0; 
         // Generate FIFO Almost Full
         wr_pfull  <= (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;
         
      end
   end
   
   //********************************************************************
   // READ CLOCK DOMAIN: Generate READ Address & READ Address GREY
   //********************************************************************
   // Memory read-address pointer 
   assign rd_addr_mem = rd_addr_bin[AWIDTH-1:0];

   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_addr_bin <= {(AWIDTH+1){1'b0}};
         rd_addr_gry <= {(AWIDTH+1){1'b0}};
      end
      else begin
         rd_addr_bin <= rd_addr_bin_nxt;
         rd_addr_gry <= rd_addr_gry_nxt;
      end
   end
   // Binary Next Read Address 
   assign rd_addr_bin_nxt = rd_addr_bin + (rd_en & ~rd_empty);
   
   // Grey Next Read Address 
   cdclib_bintogray 
   #(
      .WIDTH (AWIDTH+1)
    ) rd_addr_nxt_bintogray
    (
      .data_in (rd_addr_bin_nxt),
      .data_out (rd_addr_gry_nxt)
    );  

   
   //********************************************************************
   // READ CLOCK DOMAIN: Synchronize Write Address to Read Clock 
   //********************************************************************
   cdclib_bitsync2 
     #(
       .DWIDTH      (AWIDTH+1),    // Sync Data input 
       .RESET_VAL   (0),           // Reset value
       .CLK_FREQ_MHZ(RD_CLK_FREQ_MHZ),
       .TOGGLE_TYPE	(1),
       .VID		(VID)
       )
       rd_bitsync2
         (
          .clk      (rd_clk),
          .rst_n     (rd_rst_n),
          .data_in  (wr_addr_gry),
          .data_out (wr_addr_gry_sync)
          );
   cdclib_graytobin 
   #(
      .WIDTH (AWIDTH+1)
    ) wr_addr_graytobin
    (
      .data_in (wr_addr_gry_sync),
      .data_out (wr_addr_bin_sync)
    );  
   assign rd_numdata       = (wr_addr_bin_sync - rd_addr_bin_nxt);
   
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
         rd_empty    <= (rd_numdata == r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty
         rd_pempty   <= (rd_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         rd_full     <= (rd_numdata >= r_full) ? 1'b1 : 1'b0; 
         // Generate FIFO Almost Full 
         rd_pfull    <= (rd_numdata >= r_pfull) ? 1'b1 : 1'b0;
         
      end
   end
      
endmodule // cdclib_async_fifo


