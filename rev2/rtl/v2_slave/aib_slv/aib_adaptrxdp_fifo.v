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


module aib_adaptrxdp_fifo
  #(
    parameter DWIDTH = 'd40,             // FIFO Input data width 
    parameter AWIDTH = 'd5             // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_clk,     // Write Domain Clock
    input  wire              q1_wr_clk,     // Write Domain Clock
    input  wire [DWIDTH-1:0] aib_hssi_rx_data_in,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_clk,     // Read Domain Clock
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    input  wire		     r_stop_read,  // Disable/enable reading when FIFO is empty
    input  wire		     r_stop_write, // Disable/enable writing when FIFO is full
    input  wire		     r_double_read, 	// FIFO double write mode
    input  wire [1:0]        r_fifo_mode,     // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
    input  wire [2:0]        r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode
    input  wire		     r_wa_en,		 // Word-align enable
    input  wire              r_wr_adj_en, 
    input  wire              r_rd_adj_en,
    input  wire		     fifo_latency_adj,
    
    input  wire		     wa_lock,
    
    output wire [2*DWIDTH-1:0] rx_fifo_data_out,    // Read Data Out
    output reg               rd_en_reg,		// Read data valid
    output wire [19:0]	     rx_fifo_testbus1,
    output wire [19:0]	     rx_fifo_testbus2,

    output wire              fifo_empty,        // FIFO empty
    output wire              fifo_pempty,       // FIFO partial empty
    output wire              fifo_pfull,        // FIFO partial full 
    output wire              fifo_full,         // FIFO full
    output reg 		     wa_error,          // To SR, status reg
    output reg  [3:0]	     wa_error_cnt	// Go to status reg
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************
localparam   FIFO_DATA_DEFAULT = {1'b1, 39'd0,1'b0, 39'd0};
localparam   G3_DATA_OUT_HOLD  = {1'b1, 39'd0,1'b0, 39'd0};	// To be updated

localparam  ASYNC_FIFO_AWIDTH = 4;		
   
   //********************************************************************
   // Define variables 
   //********************************************************************
wire 			phcomp_mode;
wire			phcomp_rden_int;

reg			phcomp_wren_d0;
wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;

wire [DWIDTH-1:0]	fifo_out;
wire [DWIDTH-1:0]	fifo_out_next;
wire [DWIDTH-1:0]	data_in;
reg [2*DWIDTH-1:0]      data_out;

wire                    wa_error_int;
wire			double_read_int;
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

wire			phcomp_wren, phcomp_wren_sync;

reg			fifo_latency_adj_wr_sync_d0;
reg			fifo_latency_adj_wr_sync_d1;
wire			fifo_latency_adj_wr_sync;
wire			fifo_latency_adj_wr_pulse;
reg			fifo_latency_adj_rd_sync_d0;
wire			fifo_latency_adj_rd_sync;
wire			fifo_latency_adj_rd_pulse;
wire 			wr_en_int2;
wire 			rd_en_int2;
reg  			rd_en_int2_d0;

wire			ps_rd_addr_msb;
wire			ps_wr_addr_msb;

reg			phcomp_wren_d1;
reg			phcomp_wren_d2;
wire                    phcomp_rden;

// FIFO mode decode
assign phcomp_mode   = (r_fifo_mode == 2'b01) | (r_fifo_mode == 2'b00);

assign data_in = aib_hssi_rx_data_in;


//********************************************************************
// Instantiate the Async FIFO 
//********************************************************************
aib_adaptrxdp_async_fifo
  #(
  .DWIDTH        (DWIDTH),       // FIFO Input data width 
  .AWIDTH        (ASYNC_FIFO_AWIDTH)       // Reduce depth from 32 to 16 to save power 
  )
  rx_datapath_async_fifo
   (
   .wr_rst_n          (wr_rst_n),    // Write Domain Active low Reset
   .wr_clk            (wr_clk),     // Write Domain Clock
   .q1_wr_clk         (q1_wr_clk),     // Write Domain Clock
   .wr_en             (wr_en_int2),      // Write Data Enable
   .wr_data           (data_in), // Write Data In
   .rd_rst_n          (rd_rst_n),    // Read Domain Active low Reset
   .rd_clk            (rd_clk),     // Read Domain Clock
   .rd_en             (rd_en_int2),      // Read Data Enable
   .rd_data           (fifo_out),   // Read Data Out 
   .rd_data_next      (fifo_out_next),// Read Data Out 
   .r_pempty	      (r_pempty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially empty threshold   
   .r_pfull	      (r_pfull[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially full threshold   
   .r_empty	      (r_empty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO empty threshold   
   .r_full	      (r_full[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO full threshold   
   .r_stop_write      (r_stop_write),    // FIFO write option
   .r_stop_read       (r_stop_read),    // FIFO read option
   .r_double_read     (double_read_int), 	// FIFO read option
   .r_fifo_power_mode (2'b11),
   .wr_empty          (wr_empty),              // FIFO Empty
   .wr_pempty         (wr_pempty),            // FIFO Partial Empty
   .wr_full           (wr_full),                // FIFO Full
   .wr_pfull          (wr_pfull),              // FIFO Parial Full
   .rd_empty          (rd_empty),              // FIFO Empty
   .rd_pempty         (rd_pempty),            // FIFO Partial Empty
   .rd_full           (rd_full),                // FIFO Full 
   .rd_pfull          (rd_pfull),              // FIFO Partial Full 
   .wr_addr_msb       (wr_addr_msb),	   // Write address MSB for latency measure
   .rd_addr_msb	      (rd_addr_msb),	   // Read address MSB for latency measure
   .ps_wr_addr_msb    (ps_wr_addr_msb),	   // Write address MSB for latency measure
   .ps_rd_addr_msb    (ps_rd_addr_msb)	   // Read address MSB for latency measure
   );


//********************************************************************
// Read Write logic 
//********************************************************************
  

assign wr_en_int = phcomp_mode & phcomp_wren;	

assign rd_en_int = phcomp_mode & phcomp_rden_int;	

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out           <= FIFO_DATA_DEFAULT;
   end
   else if (phcomp_mode && ~rd_en_int2) begin
      data_out               <= FIFO_DATA_DEFAULT;
   end
   else begin
      data_out            <= rd_en_int2 ? {fifo_out_next, fifo_out}: data_out;
   end
end

// Pipeline comb output to send to test bus
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     rd_en_int2_d0 <= 1'b0;
   end
   else begin
     rd_en_int2_d0 <= rd_en_int2;
   end
end


always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      rd_en_reg	 <= 1'b0;
   end
   else begin
      rd_en_reg	 <= rd_en_int2;
   end
end

//Word-align error detect

assign wa_error_int = (data_out[39] || ~data_out[79]) && r_wa_en && rd_en_reg && (r_fifo_mode == 2'b01);


// Sample and hold wa_error
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) 
     wa_error <= 1'b0;
   else 
     wa_error <= wa_error | wa_error_int;
end   

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     wa_error_cnt <= 4'b0000;
   end
   else if (wa_error_cnt < 4'b1111 && wa_error_int) begin
     wa_error_cnt 	<= wa_error_cnt + 1'b1;
   end
end   

// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
     phcomp_wren_d2 <= 1'b0;

   end
   else begin
     phcomp_wren_d0 <= (~r_wa_en || wa_lock) || phcomp_wren_d0;	
     phcomp_wren_d1 <= phcomp_wren_d0;
     phcomp_wren_d2 <= phcomp_wren_d1;

   end
end

assign phcomp_wren = phcomp_wren_d1;

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
assign phcomp_wren_sync = (r_phcomp_rd_delay == 3'b110) ? phcomp_wren_sync6 : 
                          (r_phcomp_rd_delay == 3'b101) ? phcomp_wren_sync5 : 
                          (r_phcomp_rd_delay == 3'b100) ? phcomp_wren_sync4 : 
                          (r_phcomp_rd_delay == 3'b011) ? phcomp_wren_sync3 : phcomp_wren_sync2;

assign phcomp_rden = phcomp_wren_sync;

// Phase comp mode, FIFO read enable signal asserts when rd_val is high
assign phcomp_rden_int = phcomp_rden;


assign fifo_empty = rd_empty;
assign fifo_pempty = rd_pempty;
assign fifo_full = wr_full;
assign fifo_pfull = wr_pfull;



assign double_read_int = r_double_read;

// Latency adjust
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
        .rst_n    (wr_rst_n),
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
        .rst_n    (rd_rst_n),
        .data_in  (fifo_latency_adj),
        .data_out (fifo_latency_adj_rd_sync)
        );

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     fifo_latency_adj_wr_sync_d0 <= 1'b0;
     fifo_latency_adj_wr_sync_d1 <= 1'b0;
   end
   else begin
     fifo_latency_adj_wr_sync_d0 <= fifo_latency_adj_wr_sync; 
     fifo_latency_adj_wr_sync_d1 <= fifo_latency_adj_wr_sync_d0;
   end
end
 
assign fifo_latency_adj_wr_pulse = r_wr_adj_en && (r_double_read ? fifo_latency_adj_wr_sync && (~fifo_latency_adj_wr_sync_d0 || ~fifo_latency_adj_wr_sync_d1) : fifo_latency_adj_wr_sync && ~fifo_latency_adj_wr_sync_d0); 

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     fifo_latency_adj_rd_sync_d0 <= 1'b0;
   end
   else begin
     fifo_latency_adj_rd_sync_d0 <= fifo_latency_adj_rd_sync; 
   end
end

assign fifo_latency_adj_rd_pulse = r_rd_adj_en && (fifo_latency_adj_rd_sync && ~fifo_latency_adj_rd_sync_d0);

assign wr_en_int2 = wr_en_int && ~ fifo_latency_adj_wr_pulse;
assign rd_en_int2 = rd_en_int && ~ fifo_latency_adj_rd_pulse;

assign rx_fifo_data_out[79:0] = data_out[79:0];


// Testbus
assign rx_fifo_testbus1 =	{13'd0, wa_error, wr_en_int, wr_en_int2, 1'b0, phcomp_wren, fifo_full, fifo_pfull};
assign rx_fifo_testbus2 =	{7'd0, rd_en_int, rd_en_int2_d0, 1'b0, rd_en_reg, wa_error, wa_error_cnt[3:0], 1'b0, 1'b0, fifo_empty, fifo_pempty};



endmodule 
