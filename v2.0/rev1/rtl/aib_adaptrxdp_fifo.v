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
    parameter DWIDTH = 'd80,             // FIFO Input data width 
    parameter AWIDTH = 'd5             // FIFO Depth (address width) 
    )
    (
    input  wire              wr_rst_n,    // Write Domain Active low Reset
    input  wire              wr_clk,     // Write Domain Clock
    input  wire [DWIDTH-1:0] fifo_din,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_clk,     // Read Domain Clock
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    input  wire              m_gen2_mode,
    input  wire [1:0]        r_fifo_mode,     // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
    input  wire [3:0]        r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode
    input  wire		     r_wa_en,		 // Word-align enable
    input  wire [4:0]        r_mkbit,            // Configurable marker bit
    
    
    output wire [4*DWIDTH-1:0] fifo_dout,    // Read Data Out

    output wire              fifo_empty,        // FIFO empty
    output wire              fifo_pempty,       // FIFO partial empty
    output wire              fifo_pfull,        // FIFO partial full 
    output wire              fifo_full,         // FIFO full
    output wire              align_done
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************

localparam   ASYNC_FIFO_AWIDTH = 4;		
localparam   FIFO_1X   = 2'b00;       //Full rate
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate
localparam   REG_MOD   = 2'b11;       //REG mode

   
   //********************************************************************
   // Define variables 
   //********************************************************************
wire 			phcomp_mode;
wire			phcomp_rden_int;

reg			phcomp_wren_d0;
wire			phcomp_wren_sync2;
wire                    defult_wren_sync;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;
reg			phcomp_wren_sync7;
reg			phcomp_wren_sync8;

wire [4*DWIDTH-1:0]	fifo_out;
wire [4*DWIDTH-1:0]	data_in;
reg  [4*DWIDTH-1:0]     data_out;

wire 			rd_en_int;
wire			wr_empty;
wire			wr_pempty;
wire			wr_full;
wire			wr_pfull;
wire			rd_empty;
wire			rd_pempty;
wire			rd_full;
wire			rd_pfull;
wire                    wa_lock;


wire			phcomp_wren, phcomp_wren_sync;



reg			phcomp_wren_d1;
reg			phcomp_wren_d2;
wire                    phcomp_rden;
reg                     rd_en_reg;

// FIFO mode decode
assign phcomp_mode   = (r_fifo_mode != REG_MOD);  //2'b11 is reg_mod


assign align_done = rd_en_reg;
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
   .wr_en             (wr_en_int),      // Write Data Enable
   .wr_data           (fifo_din), // Write Data In
   .rd_rst_n          (rd_rst_n),    // Read Domain Active low Reset
   .rd_clk            (rd_clk),     // Read Domain Clock
   .rd_en             (rd_en_int),      // Read Data Enable
   .rd_data           (fifo_out),   // Read Data Out 
   .r_wa_en           (r_wa_en),
   .wa_lock           (wa_lock),
   .r_pempty	      (r_pempty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially empty threshold   
   .r_pfull	      (r_pfull[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO partially full threshold   
   .r_empty	      (r_empty[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO empty threshold   
   .r_full	      (r_full[ASYNC_FIFO_AWIDTH-1:0]),	     // FIFO full threshold   
   .r_fifo_mode       (r_fifo_mode),
   .m_gen2_mode       (m_gen2_mode),
   .r_mkbit           (r_mkbit),
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
  

assign wr_en_int = phcomp_mode & phcomp_wren;	

assign rd_en_int = phcomp_mode & phcomp_rden_int;	

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out           <= 320'h0;
   end
   else if (phcomp_mode && ~rd_en_int) begin
      data_out               <= 320'h0;
   end
   else begin
      data_out            <= rd_en_int ? fifo_out : data_out;
   end
end


always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      rd_en_reg	 <= 1'b0;
   end
   else begin
      rd_en_reg	 <= rd_en_int;
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
      phcomp_wren_sync7	 	<= 	1'b0;
      phcomp_wren_sync8	 	<= 	1'b0;
   end
   else begin
      phcomp_wren_sync3	 	<= 	phcomp_wren_sync2;
      phcomp_wren_sync4	 	<= 	phcomp_wren_sync3;
      phcomp_wren_sync5	 	<= 	phcomp_wren_sync4;
      phcomp_wren_sync6	 	<= 	phcomp_wren_sync5;
      phcomp_wren_sync7	 	<= 	phcomp_wren_sync6;
      phcomp_wren_sync8	 	<= 	phcomp_wren_sync7;
   end
end   

// Read Enable
// Add safe guard for FIFO_4X mode in case user put wrong configuration value.
wire [3:0] r_phcomp_dly_mod;
assign r_phcomp_dly_mod = ((r_fifo_mode == FIFO_4X) && (r_phcomp_rd_delay < 4'b0110)) ? 4'b0110: r_phcomp_rd_delay;
assign phcomp_wren_sync = (r_phcomp_dly_mod == 4'b0111) ? phcomp_wren_sync7 : 
                          (r_phcomp_dly_mod == 4'b0110) ? phcomp_wren_sync6 : 
                          (r_phcomp_dly_mod == 4'b0101) ? phcomp_wren_sync5 : 
                          (r_phcomp_dly_mod == 4'b0100) ? phcomp_wren_sync4 : 
                          (r_phcomp_dly_mod == 4'b0011) ? phcomp_wren_sync3 : phcomp_wren_sync2;

assign phcomp_rden = phcomp_wren_sync;

// Phase comp mode, FIFO read enable signal asserts when rd_val is high
assign phcomp_rden_int = phcomp_rden;


assign fifo_empty = rd_empty;
assign fifo_pempty = rd_pempty;
assign fifo_full = wr_full;
assign fifo_pfull = wr_pfull;





assign fifo_dout[319:0] = data_out[319:0];

wire [79:0] f3, f2, f1, f0;
assign {f3, f2, f1, f0}  = data_out;

endmodule 
