// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: c3aibadapt_tx_dp_async_fifo.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2016/10/04 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module c3aibadapt_txdp_async_fifo
  #(
    parameter DWIDTH = 'd40,             // FIFO Input data width 
    parameter AWIDTH = 'd4             // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_srst_n,   // Write Domain Active low Reset Synchronous
    input  wire              wr_clk,     // Write Domain Clock
    input  wire              q1_wr_clk,     // Write Domain Clock
    input  wire              q2_wr_clk,     // Write Domain Clock
    input  wire              q3_wr_clk,     // Write Domain Clock
    input  wire              q4_wr_clk,     // Write Domain Clock
    input  wire              wr_en,      // Write Data Enable
    input  wire [DWIDTH-1:0] wr_data,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_srst_n,   // Read Domain Active low Reset Synchronous
    input  wire              rd_clk,     // Read Domain Clock
    input  wire              rd_en,      // Read Data Enable
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    input  wire		     r_double_read, 	// FIFO double write mode
    input  wire	[1:0]	     r_fifo_power_mode, 	// FIFO double write mode
    
//    input  wire 	     r_pempty_type,   // FIFO partially empty flag type
//    input  wire 	     r_pfull_type,    // FIFO partially full flag type
//    input  wire 	     r_empty_type,    // FIFO empty flag type
//    input  wire 	     r_full_type,     // FIFO full flag type
    input  wire		     r_stop_read,  // Disable/enable reading when FIFO is empty
    input  wire		     r_stop_write, // Disable/enable writing when FIFO is full
    
    output wire [DWIDTH-1:0] rd_data,    // Read Data Out 
    output wire [DWIDTH-1:0] rd_data_next,    // Read Data Out Next
//    output wire [AWIDTH-1:0] rd_numdata, // Number of Data available in Read clock
//    output wire [AWIDTH-1:0] wr_numdata, // Number of Data available in Write clock 
    output wire              wr_addr_msb, 	// Write address MSB
    output wire              rd_addr_msb, 	// Write address MSB
    output wire              ps_wr_addr_msb, 	// Power-saving Write address MSB
    output wire              ps_rd_addr_msb, 	// Power-saving Write address MSB
    
    
    output reg               wr_empty,   // FIFO Empty
    output reg               wr_pempty,  // FIFO Partial Empty
    output reg               wr_full,    // FIFO Full
    output reg               wr_pfull,   // FIFO Parial Full
//    output wire              wr_full_comb,    // FIFO Full
//    output wire              wr_pfull_comb,   // FIFO Parial Full
    output reg               rd_empty,   // FIFO Empty
    output reg               rd_pempty,  // FIFO Partial Empty
    output reg               rd_full,    // FIFO Full 
    output reg               rd_pfull    // FIFO Partial Full 
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************

   localparam	DEPTH	  = (1<<AWIDTH);
   localparam	PS_DEPTH  = 8;
   localparam	PS_AWIDTH = 3;
   localparam	PS_DWIDTH = 20;
   localparam	NPS_DEPTH  = 8;
   localparam	NPS_AWIDTH = 3;
   localparam	NPS_DWIDTH = 20;
   
   
   //********************************************************************
   // Define variables 
   //********************************************************************

   wire [AWIDTH-1:0] 	     rd_numdata; // Number of Data available in Read clock
   wire [AWIDTH-1:0] 	     wr_numdata; // Number of Data available in Write clock 
   wire                      wr_full_comb;    // FIFO Full
   wire                      wr_pfull_comb;   // FIFO Parial Full

//   wire			   	q1_wr_clk;
   wire			     	q1_wr_en;
   wire	[PS_DEPTH-1:0]		q1_wr_ptr;
   wire	[PS_DEPTH-1:0]		q1_rd_ptr;
   wire [PS_DWIDTH-1:0]		q1_wr_data;
   wire [PS_DWIDTH-1:0]		q1_rd_data;
   wire [PS_DWIDTH-1:0]		q1_rd_data2;


//   wire			   	q2_wr_clk;
   wire			     	q2_wr_en;
   wire	[PS_DEPTH-1:0]		q2_wr_ptr;
   wire	[PS_DEPTH-1:0]		q2_rd_ptr;
   wire [PS_DWIDTH-1:0]		q2_wr_data;
   wire [PS_DWIDTH-1:0]		q2_rd_data;
   wire [PS_DWIDTH-1:0]		q2_rd_data2;

//   wire			   	q3_wr_clk;
   wire			     	q3_wr_en;
   wire	[NPS_DEPTH-1:0]	        q3_wr_ptr;
   wire	[NPS_DEPTH-1:0]	        q3_rd_ptr;
   wire [NPS_DWIDTH-1:0]	q3_wr_data;
   wire [NPS_DWIDTH-1:0]	q3_rd_data;
   wire [NPS_DWIDTH-1:0]	q3_rd_data2;

//   wire			   	q4_wr_clk;
   wire			     	q4_wr_en;
   wire	[NPS_DEPTH-1:0]	        q4_wr_ptr;
   wire	[NPS_DEPTH-1:0]	        q4_rd_ptr;
   wire [NPS_DWIDTH-1:0]	q4_wr_data;
   wire [NPS_DWIDTH-1:0]	q4_rd_data;
   wire [NPS_DWIDTH-1:0]	q4_rd_data2;


//   wire			   	top_wr_clk;     
//   wire			   	top_rd_clk;     
   wire			   	top_wr_en;      
   wire			   	top_rd_en;      
   wire			   	top_rd_empty;
   wire			   	top_wr_full;
   wire	[PS_DEPTH-1:0]		top_wr_ptr_one_hot;
   wire	[PS_DEPTH-1:0]		top_rd_ptr_one_hot;
   wire			   	top_wr_addr_msb;
   wire			   	top_rd_addr_msb;
   wire	[PS_AWIDTH-1:0]		top_wr_numdata;
   wire	[PS_AWIDTH-1:0]		top_rd_numdata;
   wire	[PS_AWIDTH-1:0]		top_rd_ptr_bin;
   wire	[PS_AWIDTH-1:0]		top_wr_ptr_bin;
   



//   wire			   	full_wr_clk;     
//   wire			   	full_rd_clk;     
   wire			   	full_wr_en;      
   wire			   	full_rd_en;      
   wire			   	full_rd_empty;
   wire			   	full_wr_full;
   wire	[DEPTH-1:0]		full_wr_ptr_one_hot;
   wire	[DEPTH-1:0]		full_rd_ptr_one_hot;
   wire			   	full_wr_addr_msb;
   wire			   	full_rd_addr_msb;
   wire	[AWIDTH-1:0]		full_wr_numdata;
   wire	[AWIDTH-1:0]		full_rd_numdata;
   wire	[AWIDTH-1:0]		full_rd_ptr_bin;
   wire	[AWIDTH-1:0]		full_wr_ptr_bin;
   
   wire [DWIDTH-1:0]		full_rd_data;
   wire [DWIDTH-1:0]		full_rd_data2;

   wire	[AWIDTH-1:0]		full_rd_ptr2_bin;
   wire [DWIDTH-1:0]		top_rd_data;
   wire [DWIDTH-1:0]		top_rd_data2;
   wire [DWIDTH-1:0]		bot_rd_data;
   wire [DWIDTH-1:0]		bot_rd_data2;
   

//   assign wr_addr_msb = wr_addr_bin[AWIDTH-1];
//   assign rd_addr_msb = rd_addr_bin[AWIDTH-1];
   
//   wire	[1:0]                   r_fifo_power_mode = 2'b01; 	// FIFO double write mode
   
   reg [DWIDTH-1:0]      mem_comb [DEPTH-1:0];
   reg [DWIDTH-1:0]      mem2_comb [DEPTH-1:0];

   
//   assign q1_wr_clk	=	wr_clk;
//   assign q2_wr_clk	=	wr_clk;
//   assign q3_wr_clk	=	wr_clk;
//   assign q4_wr_clk	=	wr_clk;

//   wire q1_rd_clk	=	rd_clk;
//   wire q2_rd_clk	=	rd_clk;
//   wire q3_rd_clk	=	rd_clk;
//   wire q4_rd_clk	=	rd_clk;
   
   //********************************************************************
   // FIFO RAM 
   //********************************************************************

c3aibadapt_txdp_fifo_ram 
  # ( 
  .DWIDTH		(PS_DWIDTH),
  .DEPTH		(PS_DEPTH))
  q1_ram (
     .r_double_read			(r_double_read),
     .r_stop_write			(r_stop_write),
     .wr_clk    			(q1_wr_clk),
     .wr_rst_n  			(wr_rst_n),
     .wr_en     			(q1_wr_en),
     .wr_full		        (wr_full),
     .wr_ptr    			(q1_wr_ptr),
     .wr_data   			(q1_wr_data),
     .rd_ptr    			(q1_rd_ptr),
     .rd_data   			(q1_rd_data),
     .rd_data2   			(q1_rd_data2)
     );

c3aibadapt_txdp_fifo_ram 
  # ( 
  .DWIDTH		(NPS_DWIDTH),
  .DEPTH		(PS_DEPTH))
  q2_ram (
     .r_double_read			(r_double_read),
     .r_stop_write			(r_stop_write),
     .wr_clk    			(q2_wr_clk),
     .wr_rst_n  			(wr_rst_n),
     .wr_en     			(q2_wr_en),
     .wr_full		        (wr_full),
     .wr_ptr    			(q2_wr_ptr),
     .wr_data   			(q2_wr_data),
     .rd_ptr    			(q2_rd_ptr),
     .rd_data   			(q2_rd_data),
     .rd_data2   			(q2_rd_data2)
     );

c3aibadapt_txdp_fifo_ram 
  # ( 
  .DWIDTH		(PS_DWIDTH),
  .DEPTH		(NPS_DEPTH))
  q3_ram (
     .r_double_read			(r_double_read),
     .r_stop_write			(r_stop_write),
     .wr_clk    			(q3_wr_clk),
     .wr_rst_n  			(wr_rst_n),
     .wr_en     			(q3_wr_en),
     .wr_full		        (wr_full),
     .wr_ptr    			(q3_wr_ptr),
     .wr_data   			(q3_wr_data),
     .rd_ptr    			(q3_rd_ptr),
     .rd_data   			(q3_rd_data),
     .rd_data2   			(q3_rd_data2)
     );

c3aibadapt_txdp_fifo_ram 
  # ( 
  .DWIDTH      (NPS_DWIDTH),
  .DEPTH       (NPS_DEPTH))
  q4_ram (
     .r_double_read			(r_double_read),
     .r_stop_write			(r_stop_write),
     .wr_clk    			(q4_wr_clk),
     .wr_rst_n  			(wr_rst_n),
     .wr_en     			(q4_wr_en),
     .wr_full		        (wr_full),
     .wr_ptr    			(q4_wr_ptr),
     .wr_data   			(q4_wr_data),
     .rd_ptr    			(q4_rd_ptr),
     .rd_data   			(q4_rd_data),
     .rd_data2   			(q4_rd_data2)
     );



   //********************************************************************
   // FIFO pointers 
   //********************************************************************
c3aibadapt_txdp_fifo_ptr 
  # ( 
  .AWIDTH        (AWIDTH),
  .PS_AWIDTH     (PS_AWIDTH),
  .DEPTH         (DEPTH),
  .PS_DEPTH      (PS_DEPTH))
  full_pointers (
     .wr_clk     			(wr_clk),     
     .wr_rst_n   			(wr_rst_n),   
     .wr_srst_n   			(wr_srst_n),   
     .rd_clk     			(rd_clk),     
     .rd_rst_n   			(rd_rst_n),   
     .rd_srst_n   			(rd_srst_n),   
     .wr_en      			(full_wr_en),      
     .rd_en      			(full_rd_en),      
     .rd_empty			(full_rd_empty),
     .wr_full			(full_wr_full),
     .r_stop_read			(r_stop_read),
     .r_stop_write			(r_stop_write),
     .r_double_read			(r_double_read),
     .r_fifo_power_mode			(r_fifo_power_mode),
     .wr_ptr_one_hot			(full_wr_ptr_one_hot),
     .rd_ptr_one_hot			(full_rd_ptr_one_hot),
     .rd_ptr_bin			(full_rd_ptr_bin),
     .wr_ptr_bin			(full_wr_ptr_bin),
     .wr_addr_msb			(full_wr_addr_msb),
     .rd_addr_msb			(full_rd_addr_msb),
     .ps_wr_addr_msb			(ps_wr_addr_msb),
     .ps_rd_addr_msb			(ps_rd_addr_msb),
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
//         wr_full   <= (wr_numdata >= r_full) ? 1'b1 : 1'b0; 
         wr_full   <= wr_full_comb; 
         // Generate FIFO Almost Full
//         wr_pfull  <= (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;
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
   // FIFO Mapping
   //********************************************************************
//   assign q1_wr_en	= r_fifo_power_mode[1] ? wr_en 	       : wr_en && |full_wr_ptr_one_hot[PS_DEPTH-1:0];
   assign q1_wr_en	= wr_en;
//   assign q1_wr_ptr	= r_fifo_power_mode[1] ? top_wr_ptr_one_hot : full_wr_ptr_one_hot[PS_DEPTH-1:0];
//   assign q1_rd_ptr	= r_fifo_power_mode[1] ? top_rd_ptr_one_hot : full_rd_ptr_one_hot[PS_DEPTH-1:0];
   assign q1_wr_ptr	= full_wr_ptr_one_hot[PS_DEPTH-1:0];
   assign q1_rd_ptr	= full_rd_ptr_one_hot[PS_DEPTH-1:0];
   assign q1_wr_data 	= wr_data[PS_DWIDTH-1:0];

   assign q2_wr_en	= q1_wr_en;
   assign q2_wr_ptr	= q1_wr_ptr;
   assign q2_rd_ptr	= q1_rd_ptr;
   assign q2_wr_data 	= wr_data[DWIDTH-1:PS_DWIDTH];
   
//   assign q3_wr_en	=  wr_en && |full_wr_ptr_one_hot[DEPTH-1:PS_DEPTH];
   assign q3_wr_en	=  wr_en;
   assign q3_wr_ptr	=  full_wr_ptr_one_hot[DEPTH-1:PS_DEPTH];
   assign q3_rd_ptr	=  full_rd_ptr_one_hot[DEPTH-1:PS_DEPTH];
   assign q3_wr_data 	=  wr_data[PS_DWIDTH-1:0];
   
   assign q4_wr_en	=  q3_wr_en;
   assign q4_wr_ptr	=  q3_wr_ptr;
   assign q4_rd_ptr	=  q3_rd_ptr;
   assign q4_wr_data 	=  wr_data[DWIDTH-1:PS_DWIDTH];


//   assign top_wr_clk = q1_wr_clk;
//   assign top_rd_clk = q1_rd_clk;
   assign top_wr_en  = wr_en;
   assign top_rd_en  = rd_en;
   assign top_rd_empty = rd_empty;
   assign top_wr_full = wr_full;

//   assign full_wr_clk = q1_wr_clk;
//   assign full_rd_clk = q1_rd_clk;
   assign full_wr_en  = wr_en;
   assign full_rd_en  = rd_en;
   assign full_rd_empty = rd_empty;
   assign full_wr_full = wr_full;


   assign wr_numdata = ~r_fifo_power_mode[1] ? {{AWIDTH-PS_AWIDTH{1'b0}},full_wr_numdata[PS_AWIDTH-1:0]} : full_wr_numdata;    
   assign rd_numdata = ~r_fifo_power_mode[1] ? {{AWIDTH-PS_AWIDTH{1'b0}},full_rd_numdata[PS_AWIDTH-1:0]} : full_rd_numdata;
   
   assign wr_addr_msb = full_wr_addr_msb;
   assign rd_addr_msb = full_rd_addr_msb;
   
   assign top_rd_data = {q2_rd_data, q1_rd_data}; 
   assign bot_rd_data = {q4_rd_data, q3_rd_data};
   assign top_rd_data2 = {q2_rd_data2, q1_rd_data2}; 
   assign bot_rd_data2 = {q4_rd_data2, q3_rd_data2};


assign full_rd_ptr2_bin = full_rd_ptr_bin + 1'b1;  
   
// Read data: concatenate data from multiple FIFOs

integer		i, j;

always @ * begin
  for (i='d0; i<= DEPTH-1; i=i+1'b1) begin
    if (i<=PS_DEPTH-1)
      mem_comb[i] = {q2_rd_data, q1_rd_data};
    else
      mem_comb[i] = {q4_rd_data, q3_rd_data};
  end
end

always @ * begin
  for (i='d0; i<= DEPTH-1; i=i+1'b1) begin
    if (i<=PS_DEPTH-1)
      mem2_comb[i] = {q2_rd_data2, q1_rd_data2};
    else
      mem2_comb[i] = {q4_rd_data2, q3_rd_data2};
  end
end

assign full_rd_data = mem_comb[full_rd_ptr_bin];
assign full_rd_data2 = mem2_comb[full_rd_ptr2_bin];


assign rd_data = ~r_fifo_power_mode[1] ? top_rd_data : full_rd_data;
assign rd_data_next = ~r_fifo_power_mode[1] ? top_rd_data2 : full_rd_data2;   

endmodule // c3aibadapt_tx_chnl_async_fifo
