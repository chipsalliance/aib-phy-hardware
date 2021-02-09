// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: c3aibadapt_txdp_fifo.v.rca $
// Revision:    $Revision: #5 $
// Date:        $Date: 2017/02/05 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------


module c3aibadapt_txdp_fifo
  #(
    parameter DWIDTH = 'd40,             // FIFO Input data width 
    parameter AWIDTH = 'd5             // FIFO Depth (address width) 
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
    input  wire [DWIDTH-1:0] aib_hssi_tx_data_in,    // Write Data In
    input  wire              rd_rst_n,    // Read Domain Active low Reset
    input  wire              rd_srst_n,   // Read Domain Active low Reset Synchronous
    input  wire              rd_clk,     // Read Domain Clock
    input  wire              s_clk,      // Latency Measure Sample Clock
    input  wire              s_rst_n,    // Latency Measure Sample Reset
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    input  wire		     r_stop_read,  // Disable/enable reading when FIFO is empty
    input  wire		     r_stop_write, // Disable/enable writing when FIFO is full
    input  wire		     r_double_read, 	// FIFO double write mode
    input  wire [1:0]        r_fifo_mode,     // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
    input  wire [2:0]        r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode
    input  wire              r_indv,     	  // Individual Mode
    input  wire		     r_wa_en,		 // Word-align enable
    input  wire [1:0]	     r_fifo_power_mode,
    input  wire              r_wr_adj_en, 
    input  wire              r_rd_adj_en,
    input  wire		     fifo_latency_adj,
    input  wire		     r_dv_gating_en,
    input  wire		     r_us_bypass_pipeln,
    

    input  wire              comp_dv_en,	   // CP Bonding Data Valid Enable
    input  wire              comp_wren_en,    // CP Bonding Write Enable
    input  wire              comp_rden_en,    // CP Bonding Read Enable
    input  wire		     compin_sel_wren,
    input  wire		     compin_sel_rden,
    input  wire		     asn_fifo_hold,	// ASN hold value on FIFO output reg
    input  wire		     asn_fifo_srst,	// sync reset
    input  wire		     asn_gen3_sel,	// Switch between single/double mode
    
    input  wire		     wa_lock,
    input  wire		     pipe_mode,
    
    output wire [2*DWIDTH-1:0] tx_fifo_data_out,    // Read Data Out
    output reg               rd_en_reg,		// Read data valid
    output wire [19:0]	     tx_fifo_testbus1,
    output wire [19:0]	     tx_fifo_testbus2,
    output wire              fifo_ready,

    output wire              fifo_empty,        // FIFO empty
    output wire              fifo_pempty,       // FIFO partial empty
    output wire              fifo_pfull,        // FIFO partial full 
    output wire              fifo_full,         // FIFO full
    output wire              phcomp_wren,	// Wr Enable to CP Bonding
    output wire              phcomp_rden,      	// Rd Enable to CP Bonding
    output wire              dv_en,    	 	// Data Valid Enable to CP Bonding
    output wire		     latency_pulse,
    output reg 		     wa_error,          // To SR, status reg
    output reg  [3:0]	     wa_error_cnt,	// Go to status reg
    output wire		     double_read_int,   // Go to CP bonding
    output wire		     fifo_srst_n_wr_clk,	// Go to CP bonding
    output wire		     fifo_srst_n_rd_clk 	// Go to CP bonding
     );
   
   //********************************************************************
   // Define Parameters 
   //********************************************************************
localparam   FIFO_DATA_DEFAULT = {1'b1, 39'd0,1'b0, 39'd0};
//localparam   FIFO_DATA_DEFAULT = 80'd0;
localparam   G3_DATA_OUT_HOLD  = {1'b1, 39'd0,1'b0, 39'd0};	// To be updated

localparam  ASYNC_FIFO_AWIDTH = 4;		// Reduce depth from 32 to 16 to save power
   
   //********************************************************************
   // Define variables 
   //********************************************************************
// wire 			register_mode;
wire 			phcomp_mode;
wire			phcomp_rden_int;
wire			comp_rden_en_int;
reg      		dv_en_d0;
reg      		dv_en_d1;
reg      		dv_en_d2;
reg      		dv_en_d3;
reg      		dv_en_d4;

reg			phcomp_wren_d0;
reg			comp_dv_en_reg;
wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;

wire [DWIDTH-1:0]	fifo_out;
wire [DWIDTH-1:0]	fifo_out_next;
wire [DWIDTH-1:0]	data_in;
reg [2*DWIDTH-1:0]      data_out;

//reg  [3:0]		wa_error_cnt;
wire                    wa_error_int;
//wire			double_read_int;
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

wire			comp_dv_en_sync;
wire			phcomp_wren_sync;
wire			asn_fifo_srst_n;

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
wire                    register_mode;
wire                    bypass_mode;

wire			powerdown;
wire			txdeemph;
wire			txelecidle;

reg			pipe_gating;

wire			start_dv;
reg			start_dv_lt;
wire			start_dv_lt_int;
wire			asn_fifo_srst_n_rd_clk;
wire			asn_fifo_srst_n_wr_clk;
reg			phcomp_wren_d1;
reg			phcomp_wren_d2;

wire			asn_fifo_hold_sync;
reg 		        fifo_ready_int;

reg		        compin_sel_wren_reg;
reg		        compin_sel_wren_reg2;
wire			compin_sel_wren_neg_edge;

reg		        compin_sel_rden_reg;
reg		        compin_sel_rden_reg2;
wire			compin_sel_rden_neg_edge;
reg			rd_addr_msb_reg;
reg			ps_rd_addr_msb_reg;

// FIFO mode decode
assign bypass_mode   = (r_fifo_mode == 2'b00);
assign phcomp_mode   = (r_fifo_mode == 2'b01);
assign register_mode = (r_fifo_mode == 2'b11);

assign data_in = aib_hssi_tx_data_in;


//********************************************************************
// Instantiate the Async FIFO 
//********************************************************************
c3aibadapt_txdp_async_fifo
  #(
  .DWIDTH        (DWIDTH),       // FIFO Input data width 
  .AWIDTH        (ASYNC_FIFO_AWIDTH)       // Reduce depth from 32 to 16 to save power 
  )
  tx_datapath_async_fifo
   (
   .wr_rst_n          (wr_rst_n),    // Write Domain Active low Reset
   .wr_srst_n         (fifo_srst_n_wr_clk),       // Write Domain Active low Reset Synchronous
   .wr_clk            (wr_clk),     // Write Domain Clock
   .q1_wr_clk         (q1_wr_clk),     // Write Domain Clock
   .q2_wr_clk         (q2_wr_clk),     // Write Domain Clock
   .q3_wr_clk         (q3_wr_clk),     // Write Domain Clock
   .q4_wr_clk         (q4_wr_clk),     // Write Domain Clock
   .wr_en             (wr_en_int2),      // Write Data Enable
   .wr_data           (data_in), // Write Data In
   .rd_rst_n          (rd_rst_n),    // Read Domain Active low Reset
   .rd_srst_n         (fifo_srst_n_rd_clk),       // Read Domain Active low Reset Synchronous
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
   .r_fifo_power_mode (r_fifo_power_mode),
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
// Instantiate latency measuring logic 
//********************************************************************

c3aibadapt_cmn_latency_measure cmn_latency_measure (
   .s_clk		(s_clk),
   .s_rst_n		(s_rst_n),
   .r_fifo_power_mode (r_fifo_power_mode),
   .wr_addr_msb  	(wr_addr_msb),	   // Write address MSB for latency measure
   .rd_addr_msb	(rd_addr_msb_reg),	   // Read address MSB for latency measure
   .ps_wr_addr_msb (ps_wr_addr_msb),	   // Write address MSB for latency measure
   .ps_rd_addr_msb	(ps_rd_addr_msb_reg),	   // Read address MSB for latency measure
   .latency_pulse	(latency_pulse)
);


//********************************************************************
// Read Write logic 
//********************************************************************
  

assign wr_en_int = (phcomp_mode && r_indv) ?     phcomp_wren:	// Phase Comp Indiviual mode
						 comp_wren_en;	// Phase Comp Bonding mode

assign rd_en_int = (phcomp_mode && r_indv) ?    phcomp_rden_int:	// Phase Comp Indiviual mode
                   				comp_rden_en_int;	// Phase Comp Bonding mode

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out           <= FIFO_DATA_DEFAULT;
   end
   else if (asn_fifo_hold_sync) begin
      data_out		<= data_out;
   end   
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      data_out           <= FIFO_DATA_DEFAULT;
   end
   // else if (register_mode == 1'b1) begin
   //    data_out           <= {40'd0, data_in[DWIDTH-1:0]};
   // end
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
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      rd_en_reg	 <= 1'b0;
   end
   else if (register_mode == 1'b1) begin
      rd_en_reg	 <= 1'b1;
   end
   else begin
      rd_en_reg	 <= rd_en_int2;
   end
end


//********************************************************************
// FIFO bonding logic 
//********************************************************************


// Data valid Enable to CP Bonding
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      dv_en_d0	 	<= 	1'b0;
      dv_en_d1	 	<= 	1'b0;
      dv_en_d2	 	<= 	1'b0;
      dv_en_d3	 	<= 	1'b0;
      dv_en_d4	 	<= 	1'b0;
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      dv_en_d0	 	<= 	1'b0;
      dv_en_d1	 	<= 	1'b0;
      dv_en_d2	 	<= 	1'b0;
      dv_en_d3	 	<= 	1'b0;
      dv_en_d4	 	<= 	1'b0;
   end
   else begin
      dv_en_d0	 	<= 	1'b1;
      dv_en_d1	 	<= 	dv_en_d0;
      dv_en_d2	 	<= 	dv_en_d1;
      dv_en_d3	 	<= 	dv_en_d2;
      dv_en_d4	 	<= 	dv_en_d3;
   end
end   

assign dv_en = dv_en_d4;

// Register comp_dv_en before synchronizing because comp_dv_en is not directly from register.
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      comp_dv_en_reg	<= 	1'b0;
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      comp_dv_en_reg	<= 	1'b0;
   end
   else begin
      comp_dv_en_reg	<= 	comp_dv_en;
   end
end   


// comp_dv_en Synchronizer
   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
     .DST_CLK_FREQ_MHZ     (1000),   // Dest clock freq
     .DWIDTH               (1),      // Sync Data input
     .RESET_VAL            (0)  // Reset value
     )
       hd_dpcmn_bitsync2_comp_dv_en
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (comp_dv_en_reg),
          .data_out (comp_dv_en_sync)
          );


//Word-align error detect

assign wa_error_int = (data_out[39] || ~data_out[79]) && r_wa_en && rd_en_reg;


// Sample and hold wa_error
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) 
     wa_error <= 1'b0;
   else if (fifo_srst_n_rd_clk == 1'b0) 
     wa_error <= 1'b0;
   else 
     wa_error <= wa_error | wa_error_int;
end   

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     wa_error_cnt <= 4'b0000;
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
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
   else if (fifo_srst_n_wr_clk == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
     phcomp_wren_d2 <= 1'b0;

   end
   else begin
     phcomp_wren_d0 <= (~r_wa_en || wa_lock) || phcomp_wren_d0;	// Indv: 1, Bonding: goes high and stays high when comp_dv_en goes high 
     phcomp_wren_d1 <= phcomp_wren_d0;
     phcomp_wren_d2 <= phcomp_wren_d1;

   end
end

assign phcomp_wren = phcomp_wren_d1;

// phcomp_wren Synchronizer
   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (500),   // Source data freq
     .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
     .DWIDTH               (1),     // Sync Data input
     .RESET_VAL            (0)  // Reset value
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
   else if (fifo_srst_n_rd_clk == 1'b0) begin
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

assign comp_rden_en_int = comp_rden_en;

assign fifo_empty = rd_empty;
assign fifo_pempty = rd_pempty;
assign fifo_full = wr_full;
assign fifo_pfull = wr_pfull;

// G3 switching/reset logic

// Sync to write/read clock domain
   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (500),   // Source data freq
     .DST_CLK_FREQ_MHZ     (1000),   // Dest clock freq
     .DWIDTH               (1),     // Sync Data input
     .RESET_VAL            (0)  // Reset value
     )
       bitsync2_asn_srst_n_wr_clk
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (asn_fifo_srst_n),
          .data_out (asn_fifo_srst_n_wr_clk)
          );

   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (500),   // Source data freq
     .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
     .DWIDTH               (1),     // Sync Data input
     .RESET_VAL            (0)  // Reset value
     )
     bitsync2_asn_srst_n_rd_clk
       (
        .clk      (rd_clk),
        .rst_n    (rd_rst_n),
        .data_in  (asn_fifo_srst_n),
        .data_out (asn_fifo_srst_n_rd_clk)
        );

   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (500),   // Source data freq
     .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
     .DWIDTH               (1),     // Sync Data input
     .RESET_VAL            (0)  // Reset value
     )
       bitsync2_asn_fifo_hold_rd_clk
         (
          .clk      (rd_clk),
          .rst_n    (rd_rst_n),
          .data_in  (asn_fifo_hold),
          .data_out (asn_fifo_hold_sync)
          );

assign asn_fifo_srst_n = ~asn_fifo_srst;  

// Combine with bond signal neg edge detect
assign fifo_srst_n_rd_clk = asn_fifo_srst_n_rd_clk && ~compin_sel_rden_neg_edge;
assign fifo_srst_n_wr_clk = asn_fifo_srst_n_wr_clk && ~compin_sel_wren_neg_edge;

//assign double_read_int = asn_gen3_sel || r_double_read ? 1'b1: 1'b0;
assign double_read_int = r_double_read;

// Latency adjust
   // hd_dpcmn_bitsync2 
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (200),     // Source data freq
     .DST_CLK_FREQ_MHZ     (10000),   // Dest clock freq
     .DWIDTH               (1),       // Sync Data input
     .RESET_VAL            (0)        // Reset value
     )
     bitsync2_wr_adj
       (
        .clk      (wr_clk),
        .rst_n    (wr_rst_n),
        .data_in  (fifo_latency_adj),
        .data_out (fifo_latency_adj_wr_sync)
        );
   
   // hd_dpcmn_bitsync2
   c3lib_bitsync
     #(
     .SRC_DATA_FREQ_MHZ    (200),   // Source data freq
     .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
     .DWIDTH               (1),     // Sync Data input
     .RESET_VAL            (0)      // Reset value
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
   else if (fifo_srst_n_wr_clk == 1'b0) begin
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
   else if (fifo_srst_n_rd_clk == 1'b0) begin
     fifo_latency_adj_rd_sync_d0 <= 1'b0;
   end
   else begin
     fifo_latency_adj_rd_sync_d0 <= fifo_latency_adj_rd_sync; 
   end
end

assign fifo_latency_adj_rd_pulse = r_rd_adj_en && (fifo_latency_adj_rd_sync && ~fifo_latency_adj_rd_sync_d0);

assign wr_en_int2 = wr_en_int && ~ fifo_latency_adj_wr_pulse;
assign rd_en_int2 = rd_en_int && ~ fifo_latency_adj_rd_pulse;

// Gate powerdown[1], txdeemph, txelecidle to 1 during reset in PIPE mode
assign powerdown = data_out[22];
assign txdeemph = data_out[26];
assign txelecidle = data_out[10];

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n)
    pipe_gating 	<= 1'b1;
  else 
    pipe_gating 	<= 1'b0;
end     
  
assign tx_fifo_data_out[22] = (pipe_mode && pipe_gating) ? 1'b1 : data_out[22];
// DV bit moved from bit 26 to bit 36: assign tx_fifo_data_out[26] = (pipe_mode && pipe_gating) ? 1'b1 : r_dv_gating_en ? start_dv_lt_int&& data_out[26] : data_out[26];
assign tx_fifo_data_out[26] = (pipe_mode && pipe_gating) ? 1'b1 : data_out[26];
assign tx_fifo_data_out[10] = (pipe_mode && pipe_gating) ? 1'b1 : data_out[10];

assign tx_fifo_data_out[9:0] = data_out[9:0];
assign tx_fifo_data_out[21:11] = data_out[21:11];
assign tx_fifo_data_out[25:23] = data_out[25:23];
// DV bit is bit 36. Gate it with start_dv_lt_int for 67:x gearbox
//assign tx_fifo_data_out[79:27] = data_out[79:27];
assign tx_fifo_data_out[35:27] = data_out[35:27];
assign tx_fifo_data_out[36] = r_dv_gating_en ? start_dv_lt_int && data_out[36] : data_out[36];
assign tx_fifo_data_out[79:37] = data_out[79:37];



// Use DV start of sequence bit to gate DV to avoid TX GB overflow when ratio is 67:x: bit 38
// Remap to bit 77
//assign start_dv = data_out[38];
assign start_dv = data_out[77];

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n) begin
    start_dv_lt 	<= 1'b0;
  end  
// Only logic used in PIPE/PCI-e mode uses sync reset
//  else if (~fifo_srst_n_rd_clk) begin
//    start_dv_lt 	<= 1'b0;
//  end  
  else begin
    start_dv_lt 	<= start_dv_lt_int; 
  end  
end

assign start_dv_lt_int	= start_dv_lt || start_dv;

// Testbus
assign tx_fifo_testbus1 =	{13'd0, wa_error, wr_en_int, wr_en_int2, comp_wren_en, phcomp_wren, fifo_full, fifo_pfull};
assign tx_fifo_testbus2 =	{7'd0, rd_en_int, rd_en_int2_d0, comp_rden_en_int, rd_en_reg, wa_error, wa_error_cnt[3:0], start_dv_lt, pipe_gating, fifo_empty, fifo_pempty};

// assign fifo_ready_int = rd_en_int || ~phcomp_mode || r_us_bypass_pipeln;
assign fifo_ready = bypass_mode ? 1'b1 : fifo_ready_int;

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n) begin
    fifo_ready_int <= 1'b0;
  end  
  else begin
    fifo_ready_int <= rd_en_int || ~phcomp_mode || r_us_bypass_pipeln;
  end  
end

// Bonding signal falling edge detect for PIPE/HIP speed change reset

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0)
       begin
          compin_sel_wren_reg <= 1'b0;
          compin_sel_wren_reg2 <= 1'b0;
       end
     else 
       begin
          compin_sel_wren_reg <= compin_sel_wren;
          compin_sel_wren_reg2 <= compin_sel_wren_reg;
       end
     end // always @ (negedge rst_n or posedge clk)  

//assign compin_sel_wren_neg_edge = ~compin_sel_wren && compin_sel_wren_reg;
// Register cause compin_sel is timing-critical
assign compin_sel_wren_neg_edge = ~compin_sel_wren_reg && compin_sel_wren_reg2 && ~r_indv;

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0)
       begin
          compin_sel_rden_reg <= 1'b0;
          compin_sel_rden_reg2 <= 1'b0;
       end
     else 
       begin
          compin_sel_rden_reg <= compin_sel_rden;
          compin_sel_rden_reg2 <= compin_sel_rden_reg;
       end
     end // always @ (negedge rst_n or posedge clk)  

assign compin_sel_rden_neg_edge = ~compin_sel_rden_reg && compin_sel_rden_reg2 && ~r_indv;

// Delay rd_ptr_msb to account for FIFO ouput being registered
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0)
       begin
          rd_addr_msb_reg <= 1'b0;
          ps_rd_addr_msb_reg  <= 1'b0;
       end
     else
       begin
          rd_addr_msb_reg <= rd_addr_msb;
          ps_rd_addr_msb_reg  <= ps_rd_addr_msb;
       end
     end // always @ (negedge rst_n or posedge clk)

endmodule // c3aibadapt_txdp_fifo
