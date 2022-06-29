// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapt_fifo_ptr
  #(
    parameter AWIDTH    = 'd4,    // Address width
    parameter DEPTH     = 'd16    // FIFO Depth
    )
(
// Inputs
input  wire              wr_clk,     // Write Domain Clock
input  wire              wr_rst_n,   // Write Domain Reset 
input  wire              rd_clk,     // Read Domain Clock
input  wire              rd_rst_n,   // Read Domain Reset 
input  wire              wr_en,      // Write Data Enable
input  wire              rd_en,      // Read Data Enable
// Outputs
output wire [DEPTH-1:0]  wr_ptr_one_hot, // One hot Write Pointer
output wire [DEPTH-1:0]  rd_ptr_one_hot, // One hot Read Pointer
output wire [AWIDTH-1:0] wr_ptr_bin,     // Binary write Pointer
output wire [AWIDTH-1:0] rd_ptr_bin,     // Binary read Pointer
output wire [AWIDTH-1:0] wr_numdata,     // Num. of stored words in write domain
output wire [AWIDTH-1:0] rd_numdata      // Num. of stored words in read domain
);

// Registers
reg [AWIDTH:0]    wr_addr_bin_ff; // Binary write address register
reg [AWIDTH:0]    rd_addr_bin_ff; // Binary read address register
reg [AWIDTH:0]    wr_addr_gry_ff; // Grey-code write address register
reg [AWIDTH:0]    rd_addr_gry_ff; // Grey-code read address register

// Wires
wire [AWIDTH-1:0] wr_addr_mem;      // Write address
wire [AWIDTH-1:0] rd_addr_mem;      // Read address
wire [AWIDTH:0]   wr_addr_bin_nxt;  // Next value of binary write address
wire [AWIDTH:0]   rd_addr_bin_nxt;  // Next value of binary read address
wire [AWIDTH:0]   wr_addr_gry_nxt;  // Next value of grey write address
wire [AWIDTH:0]   rd_addr_gry_nxt;  // Next value of grey read address
wire [AWIDTH:0]   wr_addr_bin_sync; // Synchronized write pointer
wire [AWIDTH:0]   rd_addr_bin_sync; // Synchronized read pointer
wire [AWIDTH:0]   wr_addr_gry_sync; // Synchronized write pointer in grey code
wire [AWIDTH:0]   rd_addr_gry_sync; // Synchronized read pointer in grey code


// Convert pointer to onehot
assign rd_ptr_one_hot = bin_to_onehot(rd_addr_mem);
assign wr_ptr_one_hot = bin_to_onehot(wr_addr_mem);

// Pointer outputs
assign rd_ptr_bin = rd_addr_bin_ff[AWIDTH-1:0];
assign wr_ptr_bin = wr_addr_bin_ff[AWIDTH-1:0];

//********************************************************************
// WRITE CLOCK DOMAIN: Generate WRITE Address & WRITE Address GREY
//********************************************************************
// Memory write-address pointer 
assign wr_addr_mem = wr_addr_bin_ff[AWIDTH-1:0];

// Write pointer registers
always @(posedge wr_clk or negedge wr_rst_n)
  begin: wr_addr_pointer_register
    if (wr_rst_n == 1'b0)
      begin
        wr_addr_bin_ff <= 'd0;
        wr_addr_gry_ff <= 'd0;
      end // reset
    else
      begin
        wr_addr_bin_ff <= wr_addr_bin_nxt;
        wr_addr_gry_ff <= wr_addr_gry_nxt;
      end // else
  end // block: wr_addr_pointer_register

// Binary Next Write Address 
// Add option to allow write when full
assign wr_addr_bin_nxt = (AWIDTH+1)'(wr_addr_bin_ff + wr_en); 

// Grey Next Write Address 
assign wr_addr_gry_nxt = ((wr_addr_bin_nxt>>1'b1) ^ wr_addr_bin_nxt);

//********************************************************************
// WRITE CLOCK DOMAIN: Synchronize Read Address to Write Clock 
//********************************************************************
aib_bit_sync  #(.DWIDTH (AWIDTH+1))
bitsync2_wr
(
 .clk      (wr_clk),          // Write domain clock
 .rst_n    (wr_rst_n),        // Write domain reset
 .data_in  (rd_addr_gry_ff),  // Read pointer in grey
 .data_out (rd_addr_gry_sync) // Read pointer in grey synchronized
 );
   
// Read pointer converted to binary at write domain
assign rd_addr_bin_sync = greytobin(rd_addr_gry_sync); 

// Number  of words stored in FIFO at write domain
assign wr_numdata       = (wr_addr_bin_nxt - rd_addr_bin_sync);

//********************************************************************
// READ CLOCK DOMAIN: Generate READ Address & READ Address GREY
//********************************************************************
// Memory read-address pointer 
assign rd_addr_mem = rd_addr_bin_ff[AWIDTH-1:0];

// Read pointer registers
always @(posedge rd_clk or negedge rd_rst_n)
  begin: read_addr_pointer_register
    if (rd_rst_n == 1'b0)
      begin
        rd_addr_bin_ff <= 'd0;
        rd_addr_gry_ff <= 'd0;
      end // reset
    else
      begin
        rd_addr_bin_ff <= rd_addr_bin_nxt;
        rd_addr_gry_ff <= rd_addr_gry_nxt;
      end // else
  end // Block: read_addr_pointer_register

// Binary Next Read Address 
// Add option to allow read when empty
assign rd_addr_bin_nxt = (AWIDTH+1)'(rd_addr_bin_ff +  rd_en);

// Grey Next Read Address 
assign rd_addr_gry_nxt = ((rd_addr_bin_nxt>>1'b1) ^ rd_addr_bin_nxt);

//********************************************************************
// READ CLOCK DOMAIN: Synchronize Write Address to Read Clock 
//********************************************************************
aib_bit_sync #(.DWIDTH (AWIDTH+1))
bitsync2_rd
(
 .clk      (rd_clk),          // Read domain clock
 .rst_n    (rd_rst_n),        // Read domain reset
 .data_in  (wr_addr_gry_ff),  // Write address in grey 
 .data_out (wr_addr_gry_sync) // Write address in grey synchronized 
 );

// Write pointer converted to binary at read domain   
assign wr_addr_bin_sync = greytobin(wr_addr_gry_sync);

// Number  of words stored in FIFO at read domain
assign rd_numdata       = (wr_addr_bin_sync - rd_addr_bin_nxt);

//********************************************************************
// Function to convert Grey to Binary 
//********************************************************************
function [AWIDTH:0] greytobin;
  input [AWIDTH:0] data_in;  // Data in grey
  integer i; // index
  begin
    for (i='d0; i<=AWIDTH; i=i+1'b1)  
      begin                           
        greytobin[i] = ^(data_in>> i); // Binary value
      end                             
  end
endfunction // End of greytobin function

//********************************************************************
// Function to convert binary to onehot 
//********************************************************************
function [(1<<AWIDTH)-1:0] bin_to_onehot;
  input [AWIDTH-1:0] bin_to_onehot_num;
  integer i;// index
  begin  
    for (i=0; i<=(1<<AWIDTH)-1; i=i+1)
      begin 
        if (bin_to_onehot_num == i) // bit conversion
          bin_to_onehot[i] = 1'b1; 
        else                       
          bin_to_onehot[i] = 1'b0; 
      end                        
  end                            
endfunction // End of bin_to_onehot function

endmodule // aib_adapt_fifo_ptr
