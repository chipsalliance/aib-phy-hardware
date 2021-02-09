// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_datapath_fifo_pointers
  #(
    parameter AWIDTH = 'd4,              // Address width
    parameter PS_AWIDTH = 'd3,		 // PS Address width
    parameter DEPTH  = 'd16,             // FIFO Depth
    parameter PS_DEPTH = 'd8
    )
(
    input  wire              wr_clk,     // Write Domain Clock
    input  wire		     wr_rst_n,   // Write Domain Reset 
    input  wire              wr_srst_n,   // Write Domain Active low Reset Synchronous
    input  wire              rd_clk,     // Read Domain Clock
    input  wire		     rd_rst_n,   // Read Domain Reset 
    input  wire              rd_srst_n,   // Read Domain Active low Reset Synchronous
    input  wire              wr_en,      // Write Data Enable
    input  wire              rd_en,      // Read Data Enable
    input  wire		     rd_empty,
    input  wire		     wr_full,
    input  wire		     r_stop_read,  // Disable/enable reading when FIFO is empty
    input  wire		     r_stop_write, // Disable/enable writing when FIFO is full
    input  wire		     r_double_read, 	// FIFO double read mode
    input  wire	[2:0]	     r_fifo_power_mode, 	// FIFO double write mode
    

    output wire [DEPTH-1:0]  wr_ptr_one_hot,     // Write Pointer
    output wire [DEPTH-1:0]  rd_ptr_one_hot,     // Read Pointer
    output wire [AWIDTH-1:0] wr_ptr_bin,     // Write Pointer
    output wire [AWIDTH-1:0] rd_ptr_bin,     // Read Pointer

    output wire              wr_addr_msb, 	// Write address MSB
    output wire              rd_addr_msb, 	// Read address MSB
    output wire              ps_wr_addr_msb, 	// PS Write address MSB
    output wire              ps_rd_addr_msb, 	// PS Read address MSB
    output wire              ps_dw_wr_addr_msb, 	// PS Write address MSB
    output wire              ps_dw_rd_addr_msb, 	// PS Read address MSB

    
    output wire [AWIDTH-1:0] wr_numdata,
    output wire [AWIDTH-1:0] rd_numdata

);
   //********************************************************************
   // Define Parameters 
   //********************************************************************
   
   //********************************************************************
   // Define variables 
   //********************************************************************
   reg [AWIDTH:0]            wr_addr_bin;
   reg [AWIDTH:0]            rd_addr_bin;
   
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
   wire [AWIDTH:0]           rd_addr_gry_nxt_dw;


   // Convert pointer to onehot
//   assign rd_ptr_one_hot = ~r_fifo_power_mode[1] ? {{DEPTH-PS_DEPTH{1'b0}}, bin_to_onehot_ps(rd_addr_mem[PS_AWIDTH-1:0])} : bin_to_onehot(rd_addr_mem);
//   assign wr_ptr_one_hot = ~r_fifo_power_mode[1] ? {{DEPTH-PS_DEPTH{1'b0}}, bin_to_onehot_ps(wr_addr_mem[PS_AWIDTH-1:0])} : bin_to_onehot(wr_addr_mem);

   assign rd_ptr_one_hot = ~r_fifo_power_mode[1] ? {{DEPTH-PS_DEPTH{1'b0}}, bin_to_onehot_ps(rd_addr_mem[PS_AWIDTH-1:0])} : 
                           ~r_fifo_power_mode[2] ? {{DEPTH-2*PS_DEPTH{1'b0}}, bin_to_onehot_2ps(rd_addr_mem[PS_AWIDTH:0])} :                      
                                                  bin_to_onehot(rd_addr_mem);
   assign wr_ptr_one_hot = ~r_fifo_power_mode[1] ? {{DEPTH-PS_DEPTH{1'b0}}, bin_to_onehot_ps(wr_addr_mem[PS_AWIDTH-1:0])} : 
                           ~r_fifo_power_mode[2] ? {{DEPTH-2*PS_DEPTH{1'b0}}, bin_to_onehot_2ps(wr_addr_mem[PS_AWIDTH:0])} :                      
                                                  bin_to_onehot(wr_addr_mem);
   
   assign wr_addr_msb = wr_addr_bin[AWIDTH];
   assign rd_addr_msb = rd_addr_bin[AWIDTH];

   assign ps_wr_addr_msb = wr_addr_bin[PS_AWIDTH];
   assign ps_rd_addr_msb = rd_addr_bin[PS_AWIDTH];

   assign ps_dw_wr_addr_msb = wr_addr_bin[PS_AWIDTH+1];
   assign ps_dw_rd_addr_msb = rd_addr_bin[PS_AWIDTH+1];

   assign rd_ptr_bin = rd_addr_bin[AWIDTH-1:0];
   assign wr_ptr_bin = wr_addr_bin[AWIDTH-1:0];

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
   assign wr_addr_bin_nxt = wr_addr_bin + (r_stop_write ? (wr_en & ~wr_full) : wr_en);
   
   // Grey Next Write Address 
   assign wr_addr_gry_nxt = ((wr_addr_bin_nxt>>1'b1) ^ wr_addr_bin_nxt);
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Synchronize Read Address to Write Clock 
   //********************************************************************
   cdclib_bitsync2 
     #(
       .DWIDTH      (AWIDTH+1),    // Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (1),
       .VID (1)
       )
       cdclib_bitsync2_wr
         (
          .clk      (wr_clk),
          .rst_n     (wr_rst_n),
          .data_in  (rd_addr_gry),
          .data_out (rd_addr_gry_sync)
          );
   

   assign rd_addr_bin_sync = !r_double_read ? greytobin(rd_addr_gry_sync) : greytobin_dw(rd_addr_gry_sync); 
   assign wr_numdata       = (wr_addr_bin_nxt - rd_addr_bin_sync);
   
   //********************************************************************
   // READ CLOCK DOMAIN: Generate READ Address & READ Address GREY
   //********************************************************************
   // Memory read-address pointer 
   assign rd_addr_mem = rd_addr_bin[AWIDTH-1:0];

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
         rd_addr_gry <= !r_double_read ? rd_addr_gry_nxt : rd_addr_gry_nxt_dw;
      end
   end
   // Binary Next Read Address 

   assign rd_addr_bin_nxt = rd_addr_bin + (!r_double_read ?  (r_stop_read ? (rd_en & ~rd_empty) : rd_en) : 
   							     (r_stop_read ? 2*(rd_en & ~rd_empty) : 2*rd_en));
   
   // Grey Next Read Address 
   assign rd_addr_gry_nxt = ((rd_addr_bin_nxt>>1'b1) ^ rd_addr_bin_nxt);
   assign rd_addr_gry_nxt_dw = {((rd_addr_bin_nxt[AWIDTH:1]>>1'b1) ^ rd_addr_bin_nxt[AWIDTH:1]),1'b0};
    
   //********************************************************************
   // READ CLOCK DOMAIN: Synchronize Write Address to Read Clock 
   //********************************************************************
   cdclib_bitsync2
     #(
       .DWIDTH      (AWIDTH+1),    // Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (1),
       .VID (1)
       )
       cdclib_bitsync2_rd
         (
          .clk      (rd_clk),
          .rst_n     (rd_rst_n),
          .data_in  (wr_addr_gry),
          .data_out (wr_addr_gry_sync)
          );
   
   assign wr_addr_bin_sync = greytobin(wr_addr_gry_sync); 
   assign rd_numdata       = (wr_addr_bin_sync - rd_addr_bin_nxt);

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

   function [AWIDTH:0] greytobin_dw;
      input [AWIDTH:0] data_in;			// Gray pointers
      integer          i;
      begin
         greytobin_dw[0] = 1'b0;
         for (i='d1; i<=AWIDTH; i=i+1'b1) begin
            greytobin_dw[i] = ^(data_in>> i); 
         end
      end
   endfunction

   function [(1<<AWIDTH)-1:0] bin_to_onehot;
   input [AWIDTH-1:0] bin_to_onehot_num;
   integer i;
   begin
     for (i=0; i<=(1<<AWIDTH)-1; i=i+1) begin
       if (bin_to_onehot_num == i) 
         bin_to_onehot[i] = 1'b1;
       else
         bin_to_onehot[i] = 1'b0;
     end
   end
   endfunction

   function [PS_DEPTH-1:0] bin_to_onehot_ps;
   input [PS_AWIDTH-1:0] bin_to_onehot_num;
   integer i;
   begin
     for (i=0; i<=PS_DEPTH-1; i=i+1) begin
       if (bin_to_onehot_num == i) 
         bin_to_onehot_ps[i] = 1'b1;
       else
         bin_to_onehot_ps[i] = 1'b0;
     end
   end
   endfunction

   function [2*PS_DEPTH-1:0] bin_to_onehot_2ps;
   input [PS_AWIDTH:0] bin_to_onehot_num;
   integer i;
   begin
     for (i=0; i<=2*PS_DEPTH-1; i=i+1) begin
       if (bin_to_onehot_num == i) 
         bin_to_onehot_2ps[i] = 1'b1;
       else
         bin_to_onehot_2ps[i] = 1'b0;
     end
   end
   endfunction


endmodule
