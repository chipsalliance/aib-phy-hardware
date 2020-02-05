// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_tx_datapath_fifo.v.rca $
// Revision:    $Revision: #38 $
// Date:        $Date: 2015/07/24 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_tx_datapath_fifo
   #(
      parameter FDWIDTH        = 'd40,    // FIFO width
      parameter FAWIDTH        = 'd5      // FIFO Depth (address width) 
    )
    (
      input  wire                 wr_rst_n,        // Write Domain Active low Reset
      input  wire                 rd_rst_n,        // Read Domain Active low Reset
      input  wire                 wr_srst_n,        // Write Domain Active low Reset
      input  wire                 rd_srst_n,        // Read Domain Active low Reset
      input  wire                 wr_clk,          // Write Domain Clock
      input  wire                 q1_wr_clk,     // Write Domain Clock
      input  wire                 q2_wr_clk,     // Write Domain Clock
      input  wire                 q3_wr_clk,     // Write Domain Clock
      input  wire                 q4_wr_clk,     // Write Domain Clock
      input  wire                 q5_wr_clk,     // Write Domain Clock
      input  wire                 q6_wr_clk,     // Write Domain Clock
      input  wire                 rd_clk,          // Read Domain Clock
      input  wire                 s_clk,      // Latency Measure Sample Clock
      input  wire                 s_rst_n,    // Latency Measure Sample Reset
      
      input  wire [2:0]           r_fifo_mode,     // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
      input  wire [4:0]	          r_pempty,        // FIFO partially empty threshold
      input  wire [4:0]	          r_pfull,         // FIFO partially full threshold
      input  wire [4:0]	          r_empty,        // FIFO empty threshold
      input  wire [4:0]	          r_full,         // FIFO full threshold
      input  wire                 r_indv,     	  // Individual Mode
      input  wire [2:0]		  r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode

      input  wire 	     	  r_pempty_type,   // FIFO partially empty flag type
      input  wire 	          r_pfull_type,    // FIFO partially full flag type
      input  wire 	          r_empty_type,    // FIFO empty flag type
      input  wire 	          r_full_type,     // FIFO full flag type
      input  wire		  r_stop_read,     // Disable/enable reading when FIFO is empty
      input  wire		  r_stop_write,    // Disable/enable writing when FIFO is full
      input  wire		  r_double_write,  // FIFO double write option
      input  wire                 r_dv_indv,       // Data valid Individual Mode
      input  wire                 r_gb_dv_en,       // Gearbox data valid is enabled
      input  wire [2:0]		  r_fifo_power_mode,
      input  wire 		  r_wr_adj_en, 
      input  wire                 r_rd_adj_en, 
      
      input  wire		  fifo_latency_adj,
      input  wire		  start_dv,
      input  wire [2*FDWIDTH-1:0]    pld_tx_fabric_data_in,         // Write Data In 
      input  wire             	  frm_gen_rd_en,           // Read Enable from 10G Frame Gen 
      input  wire                 data_valid_raw,  // Raw Data Valid from DV gen 
      input  wire		  data_valid_2x,  	// From DV gen
      input  wire		  fifo_wr_en,

      input  wire                 comp_dv_en,	   // CP Bonding Data Valid Enable
      input  wire                 comp_wren_en,    // CP Bonding Write Enable
      input  wire                 comp_rden_en,    // CP Bonding Read Enable
      input  wire		  compin_sel_wren,
      input  wire		  compin_sel_rden,

      input  wire		  asn_fifo_hold,	// ASN hold value on FIFO output reg
      input  wire		  asn_fifo_srst,	// sync reset
      input  wire		  asn_gen3_sel,	// Switch between single/double mode


      input  wire                 rd_pfull_stretch,         // Read partial full stretch 
      input  wire                 rd_empty_stretch,         // Read empty stretch
      input  wire                 rd_pempty_stretch,        // Read partial empty stretch
      input  wire                 rd_full_stretch,          // Read full stretch
      
      output wire [FDWIDTH-1:0]  aib_fabric_tx_data_out,        // Read Data Out (Contains CTRL+DATA)
      output wire [FDWIDTH-1:0]  fifo_out_comb,        // Read Data Out (Contains CTRL+DATA)
      output reg                 data_valid_out,  // Read Data Out Valid to Frame Gen 
      output wire                rd_pfull,         // Read partial full --> to Frame-gen 
      output wire                rd_full,          // Read full 
      output wire                rd_empty_comb,         // Read empty
      output wire                rd_pempty_comb,        // Read partial empty
      output wire                fifo_empty,        // FIFO empty
      output wire                fifo_pempty,       // FIFO partial empty
      output wire                fifo_pfull,        // FIFO partial full 
      output wire                fifo_full,         // FIFO full
      output wire                phcomp_wren,	  // Wr Enable to CP Bonding
      output wire                phcomp_rden,      // Rd Enable to CP Bonding
      output wire                dv_en,    	 // Data Valid Enable to CP Bonding
      output reg		 comp_dv_en_reg, // To DV generator

      output wire		 latency_pulse,
      output wire		 double_write_int,   // To CP bonding
      output wire		 fifo_srst_n_wr_clk,	// Go to CP bonding
      output wire		 fifo_srst_n_rd_clk, 	// Go to CP bonding
      
      output reg		 fifo_ready,
      				 
      output wire[19:0]		 testbus1,	     // Test Bus 1
      output wire[19:0]		 testbus2	     // Test Bus 2

    );

//********************************************************************
// Define Parameters 
//********************************************************************
//`include "hd_pcs10g_params.v"


localparam   FIFO_DATA_DEFAULT = {40{1'b0}};

//********************************************************************
// Define variables 
//********************************************************************

wire [FAWIDTH-1:0] rd_numdata;
wire [FAWIDTH-1:0] wr_numdata;

wire                  wr_en_int;
wire [FDWIDTH-1:0]    wr_data_in_int;

//reg			first_read;

wire [FDWIDTH-1:0]	wr_data_in;
wire [FDWIDTH-1:0]	wr_data_in2;
wire [FDWIDTH-1:0]	fifo_out;
wire [FDWIDTH-1:0]	fifo_out_next;

wire			rd_en_int;
wire			data_valid_in;

// To be removed
//assign phcomp_wren = 1'b0;
//assign phcomp_rden = 1'b0;




wire 			phcomp_rden_int;
wire 			comp_rden_en_int;



wire			rd_en_generic;

reg			phcomp_wren_d0;

wire 			comp_dv_en_sync;
wire			phcomp_wren_sync;

reg      		dv_en_d0;
reg      		dv_en_d1;
reg      		dv_en_d2;
reg      		dv_en_d3;
reg      		dv_en_d4;

wire                	wr_empty;
wire                	wr_pempty;
wire                	wr_pfull;
wire                	wr_full;

//reg			comp_dv_en_reg;
wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;
reg			phcomp_wren_sync7;
reg			phcomp_wren_sync8;
reg			phcomp_wren_sync9;

reg  [FDWIDTH-1:0]  	data_out;
//reg			data_valid_out;
wire [FDWIDTH -1:0]	data_out_int;
wire			wr_addr_msb;
wire			rd_addr_msb;

reg			fifo_latency_adj_wr_sync_d0;
wire			fifo_latency_adj_wr_sync;
wire			fifo_latency_adj_wr_pulse;
reg			fifo_latency_adj_rd_sync_d0;
reg			fifo_latency_adj_rd_sync_d1;
wire			fifo_latency_adj_rd_sync;
wire			fifo_latency_adj_rd_pulse;
wire 			wr_en_int2;
wire 			rd_en_int2;

wire			ps_rd_addr_msb;
wire			ps_wr_addr_msb;
wire			ps_dw_rd_addr_msb;
wire			ps_dw_wr_addr_msb;

reg			phcomp_wren_d1;
reg			phcomp_wren_d2;

wire			asn_fifo_srst_n_rd_clk;
wire			asn_fifo_srst_n_wr_clk;
wire  [FDWIDTH-1:0]  	data_out_wm;
wire 			asn_fifo_hold_sync;

reg		        first_write;
//wire			first_write_uw;
reg			insert_wm;
reg			start_read;


//reg   [3:0]		wait_count;
reg			phcomp_rden_reg;
wire			phcomp_rden_gb_bond;

reg			wm_bit;
reg			wm_bit_d1;
reg			wm_bit_d2;
reg			wm_bit_d3;
reg			wm_bit_d4;
reg			wm_bit_d5;
reg			wm_found_lt;
wire			wm_found_int;
wire			wm_found;
wire			fifo_ready_int;
reg		        compin_sel_wren_reg;
reg		        compin_sel_wren_reg2;
wire			compin_sel_wren_neg_edge;

reg		        compin_sel_rden_reg;
reg		        compin_sel_rden_reg2;
wire			compin_sel_rden_neg_edge;
reg                     rd_addr_msb_reg;
reg                     ps_rd_addr_msb_reg;
reg                     ps_dw_rd_addr_msb_reg;
reg                     ps_dw_rd_addr_msb_reg2;


// FIFO mode decode
wire intl_generic_mode = (r_fifo_mode == 3'b001);
wire basic_generic_mode = (r_fifo_mode == 3'b101);
wire register_mode = (r_fifo_mode[1:0] == 2'b11);
wire phcomp_mode = (r_fifo_mode[1:0] == 2'b00);

wire generic_mode = intl_generic_mode || basic_generic_mode;

assign 	wr_data_in = pld_tx_fabric_data_in[FDWIDTH -1:0];	
assign	wr_data_in2 = pld_tx_fabric_data_in[2*FDWIDTH -1:FDWIDTH];	

assign aib_fabric_tx_data_out = data_out_int;
// Remap: assign data_valid_in 	      = pld_tx_fabric_data_in[26];
//assign data_valid_in 	      = pld_tx_fabric_data_in[36];
// Use pld_tx_fabric_data_in[79] as write enable (NF data_valid_in) in Interlaken, and elastic mode
assign data_valid_in 	      = fifo_wr_en;
//assign tx_fifo_rd_en = rd_en_int;

//********************************************************************
// Instantiate the Async FIFO 
// (parameter FDWIDTH,parameter FAWIDTH,parameter FIFO_ALMFULL,parameter FIFO_ALMEMPTY)
//********************************************************************
hdpldadapt_tx_datapath_async_fifo
#(
.DWIDTH        (FDWIDTH),       // FIFO Input data width 
.AWIDTH        (FAWIDTH)       // FIFO Depth (address width) 
)
hdpldadapt_tx_datapath_async_fifo
(
.wr_rst_n      (wr_rst_n),    // Write Domain Active low Reset
.wr_srst_n     (fifo_srst_n_wr_clk),       // Write Domain Active low Reset Synchronous
.wr_clk       (wr_clk),     // Write Domain Clock
.q1_wr_clk    (q1_wr_clk),     // Write Domain Clock
.q2_wr_clk    (q2_wr_clk),     // Write Domain Clock
.q3_wr_clk    (q3_wr_clk),     // Write Domain Clock
.q4_wr_clk    (q4_wr_clk),     // Write Domain Clock
.q5_wr_clk    (q5_wr_clk),     // Write Domain Clock
.q6_wr_clk    (q6_wr_clk),     // Write Domain Clock
.wr_en        (wr_en_int2),      // Write Data Enable
.wr_data      (wr_data_in), // Write Data In
.wr_data2     (wr_data_in2), // Write Data In
.rd_rst_n      (rd_rst_n),    // Read Domain Active low Reset
.rd_srst_n     (fifo_srst_n_rd_clk),       // Read Domain Active low Reset Synchronous
.rd_clk       (rd_clk),     // Read Domain Clock
.rd_en        (rd_en_int2),      // Read Data Enable
.rd_data      (fifo_out),   // Read Data Out 
//.rd_data_next (fifo_out_next),// Read Data Out 
.rd_numdata   (rd_numdata), // Number of Data available in Read clock
.wr_numdata   (wr_numdata), // Number of Data available in Write clock 
.r_pempty	(r_pempty),	     // FIFO partially empty threshold   
.r_pfull	(r_pfull),	     // FIFO partially full threshold   
.r_empty	(r_empty),	     // FIFO empty threshold   
.r_full	        (r_full),	     // FIFO full threshold   
.r_stop_write   (r_stop_write),    // FIFO write option
.r_stop_read    (r_stop_read),    // FIFO read option
.r_double_write    (double_write_int), 	// FIFO read option
.r_fifo_power_mode (r_fifo_power_mode),
.wr_empty (wr_empty),              // FIFO Empty
.wr_pempty (wr_pempty),            // FIFO Partial Empty
.wr_full (wr_full),                // FIFO Full
.wr_pfull (wr_pfull),              // FIFO Parial Full
.rd_empty (rd_empty),              // FIFO Empty
.rd_pempty (rd_pempty),            // FIFO Partial Empty
.rd_empty_comb (rd_empty_comb),
.rd_pempty_comb (rd_pempty_comb),
.rd_full (rd_full),                // FIFO Full 
.rd_pfull (rd_pfull),              // FIFO Partial Full
.wr_addr_msb 	(wr_addr_msb),
.rd_addr_msb    (rd_addr_msb),
.ps_dw_wr_addr_msb (ps_dw_wr_addr_msb),	   // Write address MSB for latency measure
.ps_dw_rd_addr_msb (ps_dw_rd_addr_msb),	   // Read address MSB for latency measure
.ps_wr_addr_msb (ps_wr_addr_msb),	   // Write address MSB for latency measure
.ps_rd_addr_msb	(ps_rd_addr_msb)	   // Read address MSB for latency measure
);


//********************************************************************
// Instantiate latency measuring logic 
//********************************************************************

hdpldadapt_cmn_latency_measure hdpldadapt_cmn_latency_measure (
.s_clk		(s_clk),
.s_rst_n		(s_rst_n),
.r_fifo_power_mode (r_fifo_power_mode),
.wr_addr_msb  	(wr_addr_msb),	   // Write address MSB for latency measure
.rd_addr_msb	(rd_addr_msb_reg),	   // Read address MSB for latency measure
.ps_wr_addr_msb (ps_wr_addr_msb),	   // Write address MSB for latency measure
.ps_rd_addr_msb	(ps_rd_addr_msb_reg),	   // Read address MSB for latency measure
.ps_dw_wr_addr_msb (ps_dw_wr_addr_msb),	   // Write address MSB for latency measure
.ps_dw_rd_addr_msb (ps_dw_rd_addr_msb_reg2),	   // Read address MSB for latency measure
.latency_pulse	(latency_pulse)
);


// Data & Write/Read selection for different modes

assign rd_en_generic  	= basic_generic_mode ? data_valid_raw : frm_gen_rd_en;


assign wr_data_in_int = wr_data_in;


assign wr_en_int = (phcomp_mode && r_indv) ? phcomp_wren:	// Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_wren_en:	// Phase Comp Bonding mode
                                              data_valid_in;    // Interlaken or Generic mode


assign rd_en_int = (phcomp_mode && r_indv) ? phcomp_rden_int:	// Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_rden_en_int:	// Phase Comp Bonding mode
                   			      rd_en_generic;	// Interlaken or Generic mode



//********************************************************************
//********************************************************************


// Output Register and Bypass Logic
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
   end
//   else if (asn_fifo_hold_sync) begin
//      data_valid_out     <= data_valid_out;
//      data_out           <= data_out;
//   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
   end
// register mode
   else if (register_mode) begin
//      data_valid_out     <= 1'b1;
      data_valid_out     <= data_valid_in;
      data_out               <= wr_data_in;
   end
// PC mode: before reading from FIFO
//   else if (phcomp_mode && ~phcomp_rden) begin
   else if (phcomp_mode && ~((phcomp_rden && r_indv) || (comp_rden_en && ~r_indv))) begin
      data_valid_out     <= 1'b0;
      data_out               <= FIFO_DATA_DEFAULT;
   end
// Non PC mode, when empty   
   else if (rd_empty && ~phcomp_mode) begin
      data_valid_out     <= 1'b0;
      data_out               <= FIFO_DATA_DEFAULT;
   end
// Interlaken mode and Phase Comp mode
// Use rd_en to gate data_out and generate data_valid_out
   else begin
      data_valid_out     <= rd_en_int2 ? 1'b1: 1'b0;
//      data_out        <= rd_en_int ? fifo_out: data_out;
      data_out        <= fifo_out_comb;
   end
end

assign fifo_out_comb = 	rd_en_int2 ? fifo_out: data_out;

// When GB DV is used, attach to data LW, bit 26

// Insert word-marking bits when not reading from FIFO due to data valid
//assign data_out_wm = ~r_gb_dv_en || ~double_write_int || data_valid_out ? data_out : {~data_valid_2x,data_out[38:0]};
//assign data_out_wm = ~r_gb_dv_en || data_valid_out ? data_out : {~data_valid_2x,data_out[38:0]};
assign data_out_wm = ~r_gb_dv_en || data_valid_out ? data_out : {~insert_wm,data_out[38:0]};

//assign data_out_int = ~r_gb_dv_en || ~double_write_int || data_out[39] ? data_out : {data_out[39:27], data_valid_out, data_out[25:0]};
// Insert DV start of sequence bit to avoid TX GB overflow when ratio is 67:x: bit 38
// Remap start dv is bit 77 (was bit 38)
//assign data_out_int = ~r_gb_dv_en || ~double_write_int || data_out_wm[39] ? data_out_wm : {data_out_wm[39], start_dv, data_out_wm[37:27], data_valid_out, data_out_wm[25:0]};
assign data_out_int = r_gb_dv_en && ~data_out_wm[39] ? {data_out_wm[39:37], data_valid_out, data_out_wm[35:0]} :  
	              r_gb_dv_en && data_out_wm[39]  ? {data_out_wm[39:38], start_dv, data_out_wm[36:0]} :
	                                               data_out_wm;


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

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      phcomp_rden_reg   <= 	1'b0; 
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      phcomp_rden_reg   <= 	1'b0; 
   end
   else begin
      phcomp_rden_reg   <= 	phcomp_wren_sync; 
   end
end   

// Delay 1 cycle if phcomp_rden asserts when data_valid_2x = 1 to make sure first word read from FIFO is  LW
assign phcomp_rden_gb_bond = ~data_valid_2x ? phcomp_wren_sync || phcomp_rden_reg : phcomp_rden_reg;  

// comp_dv_en Synchronizer
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value
       .CLK_FREQ_MHZ(1000),       
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_comp_dv_en
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (comp_dv_en_reg),
          .data_out (comp_dv_en_sync)
          );


// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
//     phcomp_wren_d2 <= 1'b0;
   end
   else if (~fifo_srst_n_wr_clk) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
//     phcomp_wren_d2 <= 1'b0;
   end 
   else begin
//     phcomp_wren_d0 <= (r_indv || comp_dv_en_sync || ~r_gb_dv_en) || phcomp_wren_d0;	// Indv: 1, Bonding: goes high and stays high when comp_dv_en goes high 
//     phcomp_wren_d0 <= (~r_gb_dv_en || r_double_write || data_valid_in) && (r_indv || comp_dv_en_sync) || phcomp_wren_d0;	// Indv: 1, Bonding: goes high and stays high when comp_dv_en goes high 
     phcomp_wren_d0 <= (~r_gb_dv_en || r_double_write || wm_found) && (r_indv || comp_dv_en_sync) || phcomp_wren_d0;	// Indv: 1, Bonding: goes high and stays high when comp_dv_en goes high 
     phcomp_wren_d1 <= phcomp_wren_d0;
//     phcomp_wren_d2 <= phcomp_wren_d1;     
   end
end

// In 2x1x with GB mode, use pld_tx_fabric_data_in[79] as kick-start signal on LW
//assign phcomp_wren = phcomp_wren_d2;
//assign phcomp_wren = phcomp_wren_d2 && (~r_gb_dv_en || ~r_double_write || data_valid_in);
assign phcomp_wren = phcomp_wren_d1;

// phcomp_wren Synchronizer
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value
       .CLK_FREQ_MHZ(1000),       
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_phcomp_wren
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
      phcomp_wren_sync9	 	<= 	1'b0;      
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      phcomp_wren_sync3	 	<= 	1'b0;
      phcomp_wren_sync4	 	<= 	1'b0;
      phcomp_wren_sync5	 	<= 	1'b0;
      phcomp_wren_sync6	 	<= 	1'b0;
      phcomp_wren_sync7	 	<= 	1'b0;
      phcomp_wren_sync8	 	<= 	1'b0;      
      phcomp_wren_sync9	 	<= 	1'b0;      
   end
   else begin
      phcomp_wren_sync3	 	<= 	phcomp_wren_sync2;
      phcomp_wren_sync4	 	<= 	phcomp_wren_sync3;
      phcomp_wren_sync5	 	<= 	phcomp_wren_sync4;
      phcomp_wren_sync6	 	<= 	phcomp_wren_sync5;
      phcomp_wren_sync7	 	<= 	phcomp_wren_sync6;
      phcomp_wren_sync8	 	<= 	phcomp_wren_sync7;
      phcomp_wren_sync9	 	<= 	phcomp_wren_sync8;      
   end
end   

// Read Enable
///* Temp hack for simulation debug
assign phcomp_wren_sync = (r_phcomp_rd_delay == 3'b010) ? phcomp_wren_sync2 : 
                          (r_phcomp_rd_delay == 3'b011) ? phcomp_wren_sync3 : 
                          (r_phcomp_rd_delay == 3'b100) ? phcomp_wren_sync4 : 
                          (r_phcomp_rd_delay == 3'b101) ? phcomp_wren_sync5 : 
                          (r_phcomp_rd_delay == 3'b110) ? phcomp_wren_sync6 :
                          (r_phcomp_rd_delay == 3'b111) ? phcomp_wren_sync7 :
                          (r_phcomp_rd_delay == 3'b000) ? phcomp_wren_sync8 : phcomp_wren_sync9;

//assign phcomp_wren_sync = phcomp_wren_sync3;	// To be removed 

// assign phcomp_rden = phcomp_wren_sync;
assign phcomp_rden = (r_gb_dv_en && ~r_indv) ? phcomp_rden_gb_bond : phcomp_wren_sync;

// Phase comp mode, FIFO read enable signal asserts when data_valid_raw is high
assign phcomp_rden_int = phcomp_rden & (data_valid_raw || ~r_gb_dv_en);

assign comp_rden_en_int = comp_rden_en & (data_valid_raw || ~r_gb_dv_en);

//********************************************************************
// READ Valid generation 
//********************************************************************

// Testbus
assign testbus1 =	{9'd0, fifo_srst_n_wr_clk, wr_addr_msb, wr_pempty, wr_empty, phcomp_wren, comp_wren_en, wr_numdata[3:0], wr_en_int2};
assign testbus2 =	{4'd0, fifo_srst_n_rd_clk, fifo_ready, rd_addr_msb, rd_empty, rd_pempty, rd_full, data_valid_raw, rd_numdata[3:0], rd_en_int2, comp_dv_en, comp_rden_en, phcomp_rden, data_valid_out};


// Output flag
assign fifo_pempty 	= r_pempty_type ? wr_pempty : 	rd_pempty_stretch;
assign fifo_pfull 	= r_pfull_type  ? wr_pfull  :	rd_pfull_stretch; 
assign fifo_empty 	= r_empty_type  ? wr_empty  :   rd_empty_stretch;
assign fifo_full  	= r_full_type 	? wr_full   :   rd_full_stretch;

// G3 switching/reset logic

// Sync to write/read clock domain
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value
       .CLK_FREQ_MHZ(1000),       
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_asn_srst_n_wr_clk
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (asn_fifo_srst_n),
          .data_out (asn_fifo_srst_n_wr_clk)
          );

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),       
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_asn_srst_n_rd_clk
         (
          .clk      (rd_clk),
          .rst_n    (rd_rst_n),
          .data_in  (asn_fifo_srst_n),
          .data_out (asn_fifo_srst_n_rd_clk)
          );

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),       
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_asn_fifo_hold
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

//assign double_write_int = asn_gen3_sel || r_double_write ? 1'b1: 1'b0;
assign double_write_int = r_double_write;

// Latency adjust
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    // Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (5),
       .VID (1)
       )
       cdclib_bitsync2_wr_adj
         (
          .clk      (wr_clk),
          .rst_n     (wr_rst_n),
          .data_in  (fifo_latency_adj),
          .data_out (fifo_latency_adj_wr_sync)
          );
   
   cdclib_bitsync2
     #(
       .DWIDTH      (1),    // Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (5),
       .VID (1)
       )
       cdclib_bitsync2_rd_adj
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
   else if (fifo_srst_n_rd_clk == 1'b0) begin
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
   else if (fifo_srst_n_wr_clk == 1'b0) begin
     fifo_latency_adj_wr_sync_d0 <= 1'b0;
   end
   else begin
     fifo_latency_adj_wr_sync_d0 <= fifo_latency_adj_wr_sync; 
   end
end

assign fifo_latency_adj_wr_pulse = r_wr_adj_en && (fifo_latency_adj_wr_sync && ~fifo_latency_adj_wr_sync_d0);

assign wr_en_int2 = wr_en_int && ~ fifo_latency_adj_wr_pulse;
//assign wr_en_int2 = wr_en_int && ~ fifo_latency_adj_wr_pulse && ~first_write_uw;
assign rd_en_int2 = rd_en_int && ~ fifo_latency_adj_rd_pulse;


always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      first_write         <= 1'b1;
   end
   else if (wr_en_int) begin
      first_write         <= 1'b0;
   end
end

// To be removed
//always @(negedge wr_rst_n or posedge wr_clk) begin
//   if (wr_rst_n == 1'b0) begin
//      wait_count         <= 'd0;
//   end
//   else  begin
//      wait_count         <= wait_count + 'd1;
//   end
//end

// Drop first word if it is UW for 2x1x mode
// assign first_write_uw = wr_en_int & first_write & r_gb_dv_en & ~r_double_write & pld_tx_fabric_data_in[39];

// Store last WM bit, so WM can be inseted correctly during DV = 0 for non 1-1 GB mode
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      insert_wm         <= 1'b0;
   end
   else if (~start_read) begin
      insert_wm         <= 1'b0;
   end
   else if (data_valid_out) begin
      insert_wm         <= data_out[39];
   end
   else begin
      insert_wm         <= ~insert_wm;
   end
end

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      start_read         <= 1'b0;
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      start_read         <= 1'b0;
   end   
   else if (rd_en_int) begin
      start_read         <= 1'b1;
   end
end

//assign fifo_ready = (comp_rden_en_int && (~r_gb_dv_en || r_double_write)) || (comp_dv_en_reg && (r_gb_dv_en && ~r_double_write)) || r_indv || ~phcomp_mode;
//assign fifo_ready_int = comp_rden_en_int || r_indv || ~phcomp_mode;
//assign fifo_ready_int = comp_rden_en || r_indv || ~phcomp_mode;
assign fifo_ready_int = start_read || ~phcomp_mode;

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n) begin
    fifo_ready 	<= 1'b0;
  end  
  else begin
    fifo_ready 	<= fifo_ready_int; 
  end  
end

//WM bit detect
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     wm_bit 	 <= 1'b0;
     wm_bit_d1 <= 1'b0;
     wm_bit_d2 <= 1'b0;
     wm_bit_d3 <= 1'b0;
     wm_bit_d4 <= 1'b0;
     wm_bit_d5 <= 1'b0;
   end
   else if (wr_srst_n == 1'b0) begin
     wm_bit 	 <= 1'b0;
     wm_bit_d1 <= 1'b0;
     wm_bit_d2 <= 1'b0;
     wm_bit_d3 <= 1'b0;
     wm_bit_d4 <= 1'b0;
     wm_bit_d5 <= 1'b0;
   end
   else begin
//     wm_bit 	 <= pld_tx_fabric_data_in[39];
// Detect after DV is up and running in bonding mode
//     wm_bit 	 <= pld_tx_fabric_data_in[39] && comp_dv_en_sync;
     wm_bit 	 <= pld_tx_fabric_data_in[39] && (comp_dv_en_sync || r_indv);
     wm_bit_d1 <= wm_bit;
     wm_bit_d2 <= wm_bit_d1;
     wm_bit_d3 <= wm_bit_d2;
     wm_bit_d4 <= wm_bit_d3;
     wm_bit_d5 <= wm_bit_d4;
   end
end

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     wm_found_lt 	 <= 1'b0;
   end
   else if (wr_srst_n == 1'b0) begin
     wm_found_lt 	 <= 1'b0;
   end
   else begin
     wm_found_lt 	 <= wm_found_int || wm_found_lt;
   end
end

assign wm_found_int = wm_bit && ~wm_bit_d1 && wm_bit_d2 && ~wm_bit_d3 && wm_bit_d4 && ~wm_bit_d5;

assign wm_found = wm_found_int || wm_found_lt;

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
assign compin_sel_wren_neg_edge = ~compin_sel_wren_reg && compin_sel_wren_reg2  && ~r_indv;

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

assign compin_sel_rden_neg_edge = ~compin_sel_rden_reg && compin_sel_rden_reg2  && ~r_indv;

// Delay rd_ptr_msb to account for FIFO ouput being registered
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0)
       begin
          rd_addr_msb_reg <= 1'b0;
          ps_rd_addr_msb_reg  <= 1'b0;
          ps_dw_rd_addr_msb_reg  <= 1'b0;
          ps_dw_rd_addr_msb_reg2  <= 1'b0;
       end
     else
       begin
          rd_addr_msb_reg <= rd_addr_msb;
          ps_rd_addr_msb_reg  <= ps_rd_addr_msb;
          ps_dw_rd_addr_msb_reg  <= ps_dw_rd_addr_msb;
          ps_dw_rd_addr_msb_reg2  <= ps_dw_rd_addr_msb_reg;
       end
     end // always @ (negedge rst_n or posedge clk)


endmodule
