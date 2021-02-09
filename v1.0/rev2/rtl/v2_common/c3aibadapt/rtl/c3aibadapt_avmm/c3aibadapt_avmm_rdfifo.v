// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hd_pcs10g_async_fifo.v.rca $
// Revision:    $Revision: #4 $
// Date:        $Date: 2016/10/04 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module c3aibadapt_avmm_rdfifo
  #(
    parameter DWIDTH = 'd4,             // FIFO Input data width 
    parameter AWIDTH = 'd6              // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_srst_n,   // Write Domain Active low Reset Synchronous
    input  wire              wr_clk,     // Write Domain Clock
    input  wire              wr_en,      // Write Data Enable
    input  wire [DWIDTH-1:0] wr_data,    // Write Data In
    input  wire [DWIDTH-1:0] wr_data1,    // Write Data In1
    input  wire [DWIDTH-1:0] wr_data2,    // Write Data In2
    input  wire [DWIDTH-1:0] wr_data3,    // Write Data In3
    input  wire [DWIDTH-1:0] wr_data4,    // Write Data In4
    input  wire [DWIDTH-1:0] wr_data5,    // Write Data In5
    input  wire [DWIDTH-1:0] wr_data6,    // Write Data In6
    input  wire [DWIDTH-1:0] wr_data7,    // Write Data In7
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_srst_n,   // Read Domain Active low Reset Synchronous
    input  wire              rd_clk,     // Read Domain Clock
    input  wire              rd_en,      // Read Data Enable
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
//    input  wire		     r_oct_write, 	// FIFO double write mode
    
    input  wire		     r_stop_read,  // Disable/enable reading when FIFO is empty
    input  wire		     r_stop_write, // Disable/enable writing when FIFO is full
    
    output wire [DWIDTH-1:0] rd_data,    // Read Data Out 
//    output wire [DWIDTH-1:0] rd_data_next,    // Read Data Out Next
//    output wire [AWIDTH-1:0] rd_numdata, // Number of Data available in Read clock
//    output wire [AWIDTH-1:0] wr_numdata, // Number of Data available in Write clock
//    output wire              wr_addr_msb, 	// Write address MSB
//    output wire              rd_addr_msb, 	// Write address MSB
        
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
//`include "hd_pcs10g_params.v"
   
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
   
   wire [AWIDTH:0]           wr_addr_bin_nxt;
   wire [AWIDTH:0]           rd_addr_bin_nxt;
   wire [AWIDTH:0]           wr_addr_gry_nxt;
   wire [AWIDTH:0]           rd_addr_gry_nxt;
   wire [AWIDTH:0]           wr_addr_bin_sync;

   wire [AWIDTH:0]           rd_addr_bin_sync;
   wire [AWIDTH:0]           wr_addr_gry_sync;
   wire [AWIDTH:0]           rd_addr_gry_sync;
   
   wire [AWIDTH-1:0]         rd_numdata;
   wire [AWIDTH-1:0]         wr_numdata;
   
   // For debug. Will be removed
   wire r_num_type = 0;


   //********************************************************************
   // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
   //********************************************************************
   
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
            fifo_mem[m] <= 'd0;	
         end
      end
      else if (wr_srst_n == 1'b0) begin
         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
            fifo_mem[m] <= 'd0;	
         end
      end
   // Add option to allow write when full
//      else if (wr_en && ~wr_full) begin
      else if (wr_en && (~wr_full||~r_stop_write)) begin
         fifo_mem[wr_addr_mem] <= wr_data;
         fifo_mem[wr_addr_mem+1] <= wr_data1;
         fifo_mem[wr_addr_mem+2] <= wr_data2;
         fifo_mem[wr_addr_mem+3] <= wr_data3;
         fifo_mem[wr_addr_mem+4] <= wr_data4;
         fifo_mem[wr_addr_mem+5] <= wr_data5;
         fifo_mem[wr_addr_mem+6] <= wr_data6;
         fifo_mem[wr_addr_mem+7] <= wr_data7;
      end
   end

   
   assign rd_data = fifo_mem[rd_addr_mem];
//   assign rd_data_next = fifo_mem[rd_addr_mem_next];
   
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate WRITE Address & WRITE Address GREY
   //********************************************************************
   // Memory write-address pointer 
   assign wr_addr_mem = wr_addr_bin[AWIDTH-1:0];

   always @(negedge wr_rst_n or posedge wr_clk) begin
     if (wr_rst_n == 1'b0) begin
        wr_addr_bin <= 'd0;
        wr_addr_gry <= 'd0;
     end
     else if (wr_srst_n == 1'b0) begin
        wr_addr_bin <= 'd0;
        wr_addr_gry <= 'd0;
     end
     else begin
        wr_addr_bin <= wr_addr_bin_nxt;
        wr_addr_gry <= wr_addr_gry_nxt;
     end
   end

   // Binary Next Write Address 

   assign wr_addr_bin_nxt = 7'(wr_addr_bin + (r_stop_write ? 'd8*(wr_en & ~wr_full) : 'd8*wr_en));
   
   // Grey Next Write Address 

//   cdclib_bintogray_inc8 
//   #(
//      .WIDTH (AWIDTH+1)
//    ) wr_addr_nxt_bintogray
//    (
//      .data_in (wr_addr_bin_nxt),
//      .data_out (wr_addr_gry_nxt)
//    );  

   assign wr_addr_gry_nxt = {((wr_addr_bin_nxt[AWIDTH:3]>>1'b1) ^ wr_addr_bin_nxt[AWIDTH:3]), 3'b000};

   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Synchronize Read Address to Write Clock 
   //********************************************************************
   // hd_dpcmn_bitsync2 
   c3lib_bitsync 
     #(
       .SRC_DATA_FREQ_MHZ (200),        // Source data freq 
       .DST_CLK_FREQ_MHZ  (900),        // Destination clock freq
       .DWIDTH            (AWIDTH+1),   // Sync Data input 
       .RESET_VAL         (0)    	// Reset Value 
       )
       bitsync2_wr
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (rd_addr_gry),
          .data_out (rd_addr_gry_sync)
          );
   
//   cdclib_graytobin 
//   #(
//      .WIDTH (AWIDTH+1)
//    ) rd_addr_graytobin
//    (
//      .data_in (rd_addr_gry_sync),
//      .data_out (rd_addr_bin_sync)
//    );  
   
   assign rd_addr_bin_sync = greytobin(rd_addr_gry_sync);
   assign wr_numdata       = ~r_num_type ? (wr_addr_bin_nxt - rd_addr_bin_sync) : (wr_addr_bin - rd_addr_bin_sync);
   
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
      else if (wr_srst_n == 1'b0) begin
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
//   assign rd_addr_mem_next = rd_addr_bin_next_item[AWIDTH-1:0];
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_addr_bin <= 'd0;
         rd_addr_gry <= 'd0;
      end
      else if (rd_srst_n == 1'b0) begin
         rd_addr_bin <= 'd0;
         rd_addr_gry <= 'd0;
      end
      else begin
         rd_addr_bin <= rd_addr_bin_nxt;
         rd_addr_gry <= rd_addr_gry_nxt;
      end
   end

   // Binary Next Read Address 
   assign rd_addr_bin_nxt = 7'(rd_addr_bin + (r_stop_read ? (rd_en & ~rd_empty) : rd_en));
   
   // Grey Next Read Address 
//   cdclib_bintogray 
//   #(
//      .WIDTH (AWIDTH+1)
//    ) rd_addr_nxt_bintogray
//    (
//      .data_in (rd_addr_bin_nxt),
//      .data_out (rd_addr_gry_nxt)
//    );  

   // Grey Next Read Address 
   assign rd_addr_gry_nxt = ((rd_addr_bin_nxt>>1'b1) ^ rd_addr_bin_nxt);

   
   //********************************************************************
   // READ CLOCK DOMAIN: Synchronize Write Address to Read Clock 
   //********************************************************************
   // hd_dpcmn_bitsync2
   c3lib_bitsync 
     #(
       .SRC_DATA_FREQ_MHZ (200),        // Source data freq 
       .DST_CLK_FREQ_MHZ  (900),        // Destination clock freq
       .DWIDTH            (AWIDTH+1),   // Sync Data input 
       .RESET_VAL         (0)    	// Reset Value 
       )
       bitsync2_rd
         (
          .clk      (rd_clk),
          .rst_n    (rd_rst_n),
          .data_in  (wr_addr_gry),
          .data_out (wr_addr_gry_sync)
          );
   
//   cdclib_graytobin_inc8 
//   #(
//      .WIDTH (AWIDTH+1)
//    ) wr_addr_graytobin
//    (
//      .data_in (wr_addr_gry_sync),
//      .data_out (wr_addr_bin_sync)
//    );  
    

   assign wr_addr_bin_sync = greytobin_ow(wr_addr_gry_sync);    
   assign rd_numdata       = ~r_num_type ? (wr_addr_bin_sync - rd_addr_bin_nxt) : (wr_addr_bin_sync - rd_addr_bin);
   
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
      else if (rd_srst_n == 1'b0) begin
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
// Function to convert Grey to Binary 
//********************************************************************
function [AWIDTH:0] greytobin;
   input [AWIDTH:0] data_in;			// Gray pointers
   integer          i;
   begin
      for (i='d0; i<=AWIDTH; i=i+1'b1) begin
         greytobin[i] = ^(data_in>> i); 
      end
   end
endfunction

function [AWIDTH:0] greytobin_ow;
   input [AWIDTH:0] data_in;			// Gray pointers
   integer          i;
   begin
      greytobin_ow[2:0] = 3'b000;
      for (i='d3; i<=AWIDTH; i=i+1'b1) begin
         greytobin_ow[i] = ^(data_in>> i); 
      end
   end
endfunction


endmodule
