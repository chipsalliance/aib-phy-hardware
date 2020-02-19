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
    parameter DWIDTH = 'd40,             // FIFO Input data width 
    parameter AWIDTH = 'd5             // FIFO Depth (address width) 
    )
    (
    input  wire                wr_rst_n,    // Write Domain Active low Reset
    input  wire                wr_clk,     // Write Domain Clock
    input  wire                q1_wr_clk,     // Write Domain Clock
    input  wire [2*DWIDTH-1:0] data_in,    // Write Data In
    input  wire [DWIDTH-1:0]   direct_data,
    input  wire                rd_rst_n,    // Read Domain Active low Reset
    input  wire                rd_clk,     // Read Domain Clock
    input  wire [AWIDTH-1:0]   r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0]   r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0]   r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0]   r_full,     // FIFO full threshold
    input  wire		       r_double_write, 	// FIFO double write mode
    input  wire [1:0]          r_fifo_mode,     // FIFO Mode: Phase-comp, Register Mode
    input  wire [2:0]          r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode
    input  wire                r_wr_adj_en, 
    input  wire                r_rd_adj_en,
    input  wire		       fifo_latency_adj,
    
    output wire [DWIDTH-1:0]   aib_hssi_tx_data_out,    // Read Data Out 
    output wire [19:0]	       tx_fifo_testbus1,
    output wire [19:0]	       tx_fifo_testbus2,
    output wire                fifo_ready,

    output wire                fifo_empty,        // FIFO empty
    output wire                fifo_pempty,       // FIFO partial empty
    output wire                fifo_pfull,        // FIFO partial full 
    output wire                fifo_full,        // FIFO full
    output wire                phcomp_wren,	// Wr Enable to CP Bonding
    output wire                phcomp_rden,      	// Rd Enable to CP Bonding
    output wire		       double_write_int   // To CP bonding
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************
localparam   FIFO_DATA_DEFAULT = 40'd0;

localparam  ASYNC_FIFO_AWIDTH = 4;		
   
   //********************************************************************
   // Define variables 
   //********************************************************************
wire 			register_mode;
wire 			phcomp_mode;
wire			phcomp_rden_int;

reg			phcomp_wren_d0;
wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;

wire [DWIDTH-1:0]	fifo_out,wr_data;
reg  [DWIDTH-1:0]       data_out_int;
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

reg			fifo_latency_adj_wr_sync_d0;
wire			fifo_latency_adj_wr_sync;
wire			fifo_latency_adj_wr_pulse;
reg			fifo_latency_adj_rd_sync_d0;
reg			fifo_latency_adj_rd_sync_d1;
wire			fifo_latency_adj_rd_sync;
wire			fifo_latency_adj_rd_pulse;
wire 			wr_en_int2;
wire 			rd_en_int2;


reg			phcomp_wren_d1;
reg			phcomp_wren_d2;


// FIFO mode decode
 assign register_mode = (r_fifo_mode == 2'b11);
assign phcomp_mode =   (r_fifo_mode == 2'b01) | (r_fifo_mode == 2'b00); //2'b00:1xphcomp, 2'b01:2xphcomp

assign wr_data[DWIDTH-1:0] = (r_fifo_mode == 2'b00) ? direct_data[DWIDTH-1:0]  : data_in[DWIDTH-1:0];

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
  .q1_wr_clk         (q1_wr_clk),     // Write Domain Clock
  .wr_en             (wr_en_int2),      // Write Data Enable
  .wr_data           (wr_data[DWIDTH-1:0]), // Write Data In
  .wr_data2          (data_in[2*DWIDTH-1:DWIDTH]), // Write Data In
  .rd_rst_n          (rd_rst_n),    // Read Domain Active low Reset
  .rd_clk            (rd_clk),     // Read Domain Clock
  .rd_en             (rd_en_int2),      // Read Data Enable
  .rd_data           (fifo_out),   // Read Data Out 
  .r_pempty	     (r_pempty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially empty threshold   
  .r_pfull	     (r_pfull[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially full threshold   
  .r_empty	     (r_empty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO empty threshold   
  .r_full	     (r_full[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO full threshold   
  .r_stop_write      (1'b0),    // FIFO write option
  .r_stop_read       (1'b0),    // FIFO read option
  .r_double_write    (r_double_write), 	// FIFO read option
  .r_fifo_power_mode (2'b11),
  .wr_empty          (wr_empty),              // FIFO Empty
  .ps_wr_addr_msb    (),
  .ps_rd_addr_msb    (),
  .wr_pempty         (wr_pempty),            // FIFO Partial Empty
  .wr_full           (wr_full),                // FIFO Full
  .wr_pfull          (wr_pfull),              // FIFO Parial Full
  .rd_empty          (rd_empty),              // FIFO Empty
  .rd_pempty         (rd_pempty),            // FIFO Partial Empty
  .rd_full           (rd_full),                // FIFO Full 
  .rd_pfull          (rd_pfull),              // FIFO Partial Full 
  .wr_addr_msb       (wr_addr_msb),	   // Write address MSB for latency measure
  .rd_addr_msb	     (rd_addr_msb)	   // Read address MSB for latency measure
  );

//********************************************************************
// Instantiate latency measuring logic 
//********************************************************************


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
   //else if (register_mode == 1'b1) begin
   //   data_out_int           <= data_in[DWIDTH-1:0];
   //end
   else if (phcomp_mode && ~rd_en_int2) begin
      data_out_int               <= FIFO_DATA_DEFAULT;
   end
   else begin
      data_out_int            <= rd_en_int2 ? fifo_out: data_out_int;
   end
end

assign aib_hssi_tx_data_out = data_out_int;

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
       c3lib_bitsync
       #(
       .SRC_DATA_FREQ_MHZ (200),        
       .DST_CLK_FREQ_MHZ  (1000),        
       .DWIDTH            (1),   
       .RESET_VAL         (0)           
       )
       bitsync2_phcomp_wren
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
assign phcomp_wren_sync = (r_phcomp_rd_delay == 3'b110) ? phcomp_wren_sync6 : (r_phcomp_rd_delay == 3'b101) ? phcomp_wren_sync5 : (r_phcomp_rd_delay == 3'b100) ? phcomp_wren_sync4 : (r_phcomp_rd_delay == 3'b011) ? phcomp_wren_sync3 : phcomp_wren_sync2;
assign phcomp_rden = phcomp_wren_sync;

assign phcomp_rden_int = phcomp_rden;



// Sync to write/read clock domain


assign double_write_int = r_double_write;

assign fifo_full = wr_full;
assign fifo_pfull = wr_pfull;
assign fifo_empty = rd_empty;
assign fifo_pempty = rd_pempty;

       c3lib_bitsync
       #(
       .SRC_DATA_FREQ_MHZ (200),        
       .DST_CLK_FREQ_MHZ  (1000),        
       .DWIDTH            (1),   
       .RESET_VAL         (0)           
       )
       bitsync2_wr_adj
         (
          .clk      (wr_clk),
          .rst_n     (wr_rst_n),
          .data_in  (fifo_latency_adj),
          .data_out (fifo_latency_adj_wr_sync)
          );
   
       c3lib_bitsync
       #(
       .SRC_DATA_FREQ_MHZ (200),        
       .DST_CLK_FREQ_MHZ  (1000),        
       .DWIDTH            (1),   
       .RESET_VAL         (0)           
       )
       bitsync2_rd_adj
         (
          .clk      (rd_clk),
          .rst_n     (rd_rst_n),
          .data_in  (fifo_latency_adj),
          .data_out (fifo_latency_adj_rd_sync)
          );

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     fifo_latency_adj_rd_sync_d0 <= 1'b0;
     fifo_latency_adj_rd_sync_d1 <= 1'b0;
   end
   else begin
     fifo_latency_adj_rd_sync_d0 <= fifo_latency_adj_rd_sync; 
     fifo_latency_adj_rd_sync_d1 <= fifo_latency_adj_rd_sync_d0;
   end
end
 
assign fifo_latency_adj_rd_pulse = r_rd_adj_en && (r_double_write ? fifo_latency_adj_rd_sync && (~fifo_latency_adj_rd_sync_d0 || ~fifo_latency_adj_rd_sync_d1) : fifo_latency_adj_rd_sync && ~fifo_latency_adj_rd_sync_d0); 

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     fifo_latency_adj_wr_sync_d0 <= 1'b0;
   end
   else begin
     fifo_latency_adj_wr_sync_d0 <= fifo_latency_adj_wr_sync; 
   end
end

assign fifo_latency_adj_wr_pulse = r_wr_adj_en && (fifo_latency_adj_wr_sync && ~fifo_latency_adj_wr_sync_d0);

assign wr_en_int2 = wr_en_int && ~ fifo_latency_adj_wr_pulse;
assign rd_en_int2 = rd_en_int && ~ fifo_latency_adj_rd_pulse;

// Testbus
assign tx_fifo_testbus1 =	{16'd0, wr_full, wr_pfull ,  wr_addr_msb, wr_en_int2};
assign tx_fifo_testbus2 =	{16'd0, rd_empty, rd_pempty, rd_addr_msb, rd_en_int2};

assign fifo_ready  = register_mode;




endmodule 
