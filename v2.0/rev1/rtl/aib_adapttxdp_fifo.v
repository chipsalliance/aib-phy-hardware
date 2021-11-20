// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module aib_adapttxdp_fifo
  #(
    parameter DWIDTH = 'd80,             // FIFO Input data width 
    parameter AWIDTH = 'd5             // FIFO Depth (address width) 
    )
    (
    input  wire                wr_rst_n,    // Write Domain Active low Reset
    input  wire                wr_clk,     // Write Domain Clock
    input  wire                m_gen2_mode,
    input  wire [4*DWIDTH-1:0] data_in,    // Write Data In
    input  wire                rd_rst_n,    // Read Domain Active low Reset
    input  wire                rd_clk,     // Read Domain Clock
    input  wire [AWIDTH-1:0]   r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0]   r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0]   r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0]   r_full,     // FIFO full threshold
    input  wire                r_wm_en,    // mark enable
    input  wire [4:0]          r_mkbit,    // Configurable marker bit
    input  wire [1:0]          r_fifo_mode,     // FIFO Mode: 4:1 2:1 1:1 Reg mode 
    input  wire [3:0]          r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode
    
    output wire [DWIDTH-1:0]   fifo_dout,    // Read Data Out 

    output wire                fifo_empty,        // FIFO empty
    output wire                fifo_pempty,       // FIFO partial empty
    output wire                fifo_pfull,        // FIFO partial full 
    output wire                fifo_full        // FIFO full
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************
localparam   FIFO_DATA_DEFAULT = 320'd0;
localparam   ASYNC_FIFO_AWIDTH = 4;		
localparam   FIFO_1X   = 2'b00;       //Full rate
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate
localparam   REG_MOD   = 2'b11;       //REG mode

   
   //********************************************************************
   // Define variables 
   //********************************************************************
wire 			register_mode;
wire 			phcomp_mode;
wire			phcomp_rden_int;

wire                    phcomp_wren;
reg			phcomp_wren_d0;
wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;

wire [DWIDTH-1:0]	fifo_out;
reg  [DWIDTH-1:0]       data_out_int;
reg  [DWIDTH*4-1:0]     wr_data;
//wire			phcomp_mode1x;
wire 			wr_en_int;
wire 			rd_en_int;
wire			wr_empty;
wire			wr_pempty;
wire			wr_full;
wire			wr_pfull;
wire			rd_empty;
wire			rd_pempty;
wire			rd_full;
wire			rd_pfull;

wire			wr_addr_msb;
wire			rd_addr_msb;

wire			phcomp_wren_sync;



reg			phcomp_wren_d1;
reg			phcomp_wren_d2;


// FIFO mode decode
assign register_mode = (r_fifo_mode == REG_MOD);

assign phcomp_mode =  ~ register_mode; 

always @ * begin
   if (r_wm_en) begin
      if (r_fifo_mode == FIFO_4X)
        if (r_mkbit[4]) 
          wr_data ={{              1'b1, data_in[318:240]}, 
                    {              1'b0, data_in[238:160]}, 
                    {              1'b0, data_in[158:80]}, 
                    {              1'b0, data_in[78:0]}};               //bit 79
        else if (r_mkbit[3])
          wr_data ={{data_in[319], 1'b1, data_in[317:240]}, 
                    {data_in[239], 1'b0, data_in[237:160]}, 
                    {data_in[159], 1'b0, data_in[157:80]}, 
                    {data_in[79],  1'b0, data_in[77:0]}};               //bit 78
        else if (r_mkbit[2])
          wr_data ={{data_in[319:318], 1'b1, data_in[316:240]}, 
                    {data_in[239:238], 1'b0, data_in[236:160]}, 
                    {data_in[159:158], 1'b0, data_in[156:80]}, 
                    {data_in[79:78],   1'b0, data_in[76:0]}};            //bit 77
        else if (r_mkbit[1])          
          wr_data ={{data_in[319:317], 1'b1, data_in[315:240]}, 
                    {data_in[239:237], 1'b0, data_in[235:160]}, 
                    {data_in[159:157], 1'b0, data_in[155:80]}, 
                    {data_in[79:77],   1'b0, data_in[75:0]}};            //bit 76
        else wr_data = data_in;
      else if (r_fifo_mode == FIFO_2X)
        if (r_mkbit[4]) 
          wr_data ={ 160'h0,
                    {              1'b1, data_in[158:80]},
                    {              1'b0, data_in[78:0]}}; 
        else if (r_mkbit[3])
          wr_data ={ 160'h0,
                    {data_in[159], 1'b1, data_in[157:80]},
                    {data_in[79],  1'b0, data_in[77:0]}};
        else if (r_mkbit[2])
          wr_data ={ 160'h0,
                    {data_in[159:158], 1'b1, data_in[156:80]},
                    {data_in[79:78],   1'b0, data_in[76:0]}};
        else if (r_mkbit[1])
          wr_data ={ 160'h0,
                    {data_in[159:157], 1'b1, data_in[155:80]},
                    {data_in[79:77],   1'b0, data_in[75:0]}};
        else if (r_mkbit[0] & ~m_gen2_mode)
          wr_data ={ 160'h0,
                    {40'h0, 1'b1, data_in[78:40]},
                    {40'h0, 1'b0, data_in[38:0]}};
        else 
          wr_data = data_in;
      else
          wr_data = data_in;
   end else begin
   if ((r_fifo_mode == FIFO_2X) & ~m_gen2_mode)
      wr_data ={ 160'h0,
               {40'h0, data_in[79:40]},
               {40'h0, data_in[39:0]}};
   else
      wr_data = data_in;
   end
end



//********************************************************************
// Instantiate the Async FIFO 
//********************************************************************
aib_adapttxdp_async_fifo
  #(
  .DWIDTH        (DWIDTH),       // FIFO Input data width 
  .AWIDTH        (ASYNC_FIFO_AWIDTH)       
  )
  adapt_txdp_async_fifo (
  .wr_rst_n          (wr_rst_n),    // Write Domain Active low Reset
  .wr_clk            (wr_clk),     // Write Domain Clock
  .wr_en             (wr_en_int),      // Write Data Enable
  .wr_data           (wr_data), // Write Data In
  .rd_rst_n          (rd_rst_n),    // Read Domain Active low Reset
  .rd_clk            (rd_clk),     // Read Domain Clock
  .rd_en             (rd_en_int),      // Read Data Enable
  .rd_data           (fifo_out),   // Read Data Out 
  .r_pempty	     (r_pempty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially empty threshold   
  .r_pfull	     (r_pfull[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially full threshold   
  .r_empty	     (r_empty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO empty threshold   
  .r_full	     (r_full[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO full threshold   
  .r_fifo_mode       (r_fifo_mode),
  .wr_empty          (wr_empty),              // FIFO Empty
  .wr_pempty         (wr_pempty),            // FIFO Partial Empty
  .wr_full           (wr_full),                // FIFO Full
  .wr_pfull          (wr_pfull),              // FIFO Parial Full
  .rd_empty          (rd_empty),              // FIFO Empty
  .rd_pempty         (rd_pempty),            // FIFO Partial Empty
  .rd_full           (rd_full),                // FIFO Full 
  .rd_pfull          (rd_pfull)              // FIFO Partial Full 
  );




//********************************************************************
// Read Write logic 
//********************************************************************
  

assign wr_en_int = phcomp_mode &  phcomp_wren;	// Phase Comp Indiviual mode

assign rd_en_int = phcomp_mode &  phcomp_rden_int;	// Phase Comp Indiviual mode

// Output Register and Bypass Logic
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out_int           <= FIFO_DATA_DEFAULT;
   end
   else if (phcomp_mode && ~rd_en_int) begin
      data_out_int           <= FIFO_DATA_DEFAULT;
   end
   else begin
      data_out_int           <= rd_en_int ? fifo_out: data_out_int;
   end
end

assign fifo_dout = data_out_int;

//********************************************************************
// FIFO bonding logic 
//********************************************************************

// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
     phcomp_wren_d2 <= 1'b0;

   end
   else begin
     phcomp_wren_d0 <= 1'b1;	// Indv: 1, Bonding: goes high and stays high
     phcomp_wren_d1 <= phcomp_wren_d0;
     phcomp_wren_d2 <= phcomp_wren_d1;

   end
end

assign phcomp_wren = phcomp_wren_d2;

// phcomp_wren Synchronizer
       aib_bitsync bitsync2_phcomp_wren
         (
          .clk      (rd_clk),
          .rst_n    (rd_rst_n),
          .data_in  (phcomp_wren),
          .data_out (phcomp_wren_sync2)
          );


always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      phcomp_wren_sync3	 	<= 	1'b0;
      phcomp_wren_sync4	 	<= 	1'b0;
      phcomp_wren_sync5	 	<= 	1'b0;
      phcomp_wren_sync6	 	<= 	1'b0;
   end
   else begin
      phcomp_wren_sync3	 	<= 	phcomp_wren_sync2;
      phcomp_wren_sync4	 	<= 	phcomp_wren_sync3;
      phcomp_wren_sync5	 	<= 	phcomp_wren_sync4;
      phcomp_wren_sync6	 	<= 	phcomp_wren_sync5;
   end
end   

// Read Enable
assign phcomp_wren_sync = (r_phcomp_rd_delay == 4'b0110) ? phcomp_wren_sync6 : 
                          (r_phcomp_rd_delay == 4'b0101) ? phcomp_wren_sync5 : 
                          (r_phcomp_rd_delay == 4'b0100) ? phcomp_wren_sync4 : 
                          (r_phcomp_rd_delay == 4'b0011) ? phcomp_wren_sync3 : phcomp_wren_sync2;
assign phcomp_rden = phcomp_wren_sync;

assign phcomp_rden_int = phcomp_rden;



// Sync to write/read clock domain



assign fifo_full = wr_full;
assign fifo_pfull = wr_pfull;
assign fifo_empty = rd_empty;
assign fifo_pempty = rd_pempty;

endmodule 
