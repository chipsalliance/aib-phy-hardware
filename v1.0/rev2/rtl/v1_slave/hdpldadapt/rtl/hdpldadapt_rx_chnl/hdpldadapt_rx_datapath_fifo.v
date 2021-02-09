// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_datapath_fifo
   #(
      parameter FDWIDTH      = 'd40,      // FIFO width
      parameter FAWIDTH = 'd6             // FIFO Depth (address width) 
    )
    (
      input  wire                 wr_rst_n,        // Write Domain Active low Reset
      input  wire                 rd_rst_n,        // Read Domain Active low Reset
//      input  wire                 wr_srst_n,        // Write Domain Active low Reset
//      input  wire                 rd_srst_n,        // Read Domain Active low Reset
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
      input  wire [FAWIDTH-1:0]	          r_pempty,        // FIFO partially empty threshold
      input  wire [FAWIDTH-1:0]	          r_pfull,         // FIFO partially full threshold
      input  wire [FAWIDTH-1:0]	          r_empty,        // FIFO empty threshold
      input  wire [FAWIDTH-1:0]	          r_full,         // FIFO full threshold
      input  wire                 r_indv,     	  // Individual Mode
      input  wire [2:0]		  r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp mode

      input  wire 	     	  r_pempty_type,   // FIFO partially empty flag type
      input  wire 	          r_pfull_type,    // FIFO partially full flag type
      input  wire 	          r_empty_type,    // FIFO empty flag type
      input  wire 	          r_full_type,     // FIFO full flag type
      input  wire		  r_stop_read,     // Disable/enable reading when FIFO is empty
      input  wire		  r_stop_write,    // Disable/enable writing when FIFO is full
      input  wire		  r_double_read,  // FIFO double write option
      input  wire                 r_gb_dv_en,      // GB data valid enable
      input  wire                 r_truebac2bac,
      input  wire		  r_wa_en,
      input  wire [2:0]		  r_fifo_power_mode,
      input  wire 		  r_wr_adj_en, 
      input  wire                 r_rd_adj_en, 
      input  wire		  r_pipe_en,
      input  wire		  r_write_ctrl,
      input  wire		  fifo_latency_adj,
      
      input  wire [FDWIDTH-1:0]   aib_fabric_rx_data_in,         // Write Data In 
//      input  wire                 data_valid_in,   // Write Data In Valid 
      input  wire		  rd_en,	     // Core read enable
      input  wire		  rd_align_clr,
      
      input  wire                 comp_wren_en,    // CP Bonding Write Enable
      input  wire                 comp_rden_en,    // CP Bonding Read Enable
      input  wire		  compin_sel_wren,
      input  wire		  compin_sel_rden,
      output wire                 phcomp_wren,	  // Wr Enable to CP Bonding
      output wire                 phcomp_rden,      // Rd Enable to CP Bonding

      input  wire                 wr_pfull_stretch,         // Write partial full stretch 
      input  wire                 wr_empty_stretch,         // Write empty stretch
      input  wire                 wr_pempty_stretch,        // Write partial empty stretch
      input  wire                 wr_full_stretch,          // Write full stretch
      input  wire		  wa_lock,		    // From word-align
      
      input  wire [9:0]		  insert_sm_control_out,
      input  wire [63:0]          insert_sm_data_out,
      input  wire		  insert_sm_rd_en,
      input  wire		  insert_sm_rd_en_lt,
      
      input  wire		  block_lock,
      input  wire		  block_lock_lt,
      input  wire		  del_sm_wr_en,
      
      input  wire		     asn_fifo_hold,	// ASN hold value on FIFO output reg
      input  wire		     asn_fifo_srst,	// sync reset
      input  wire		     asn_gen3_sel,	// Switch between single/double mode
      
      output wire [73:0]          baser_fifo_data,
      output wire [73:0]          baser_fifo_data2,
      output wire		  baser_data_valid,
      
//      output reg [FDWIDTH-1:0]    control_out,        // Frame information 
      output wire [2*FDWIDTH-1:0] pld_rx_fabric_data_out,        // Read Data Out
//      output reg                  data_valid_out,  // Read Data Out Valid 
      output wire                 rd_pfull,         // Read partial full 
      output wire                 rd_empty,         // Read empty
      output wire                 rd_pempty,        // Read partial empty
      output wire                 rd_full,          // Read full 
      output wire                 wr_full_comb,         // Write full
      output wire                 wr_pfull_comb,        // Write partial full
      output wire                 wr_full,         // Write full
      output wire                 wr_pfull,        // Write partial full
      output wire                 fifo_empty,        // FIFO empty
      output wire                 fifo_pempty,       // FIFO partial empty
      output wire                 fifo_pfull,        // FIFO partial full 
      output wire                 fifo_full,         // FIFO full

//      output wire                 wr_addr_msb, 	// Write address MSB
//      output wire                 rd_addr_msb, 	// Read address MSB
      output wire		  latency_pulse,
      output wire		  align_done,
      output wire		  wa_error,          // To status reg
      output reg  [3:0]	          wa_error_cnt,	// Go to status reg
      

      output wire		  double_read_int,   // Go to CP bonding
      output wire		  fifo_srst_n_wr_clk,	// Go to CP bonding
      output wire		  fifo_srst_n_rd_clk, 	// Go to CP bonding
      output wire		  wa_srst_n_wr_clk,	// Go to WA      
      
      output wire		  base_r_clkcomp_mode,		// Go to del_sm
      output reg		  rd_align_clr_reg,
      output reg		  fifo_ready,
      
      output wire[19:0]		  testbus1,	     // Test Bus 1
      output wire[19:0]		  testbus2	     // Test Bus 2

    );

//********************************************************************
// Define Parameters 
//********************************************************************
//`include "hd_pcs10g_params.v"


localparam   FIFO_DATA_DEFAULT = {80{1'h0}};

//********************************************************************
// Define variables 
//********************************************************************

wire [FAWIDTH-1:0] rd_numdata;
wire [FAWIDTH-1:0] wr_numdata;

wire                    wr_en_int;
wire [FDWIDTH-1:0]      wr_data_in_int;

//reg			first_read;

wire [FDWIDTH-1:0]	data_in;
wire [FDWIDTH-1:0]	wr_data_in;
wire [FDWIDTH-1:0]	wr_data_in2;
wire [FDWIDTH-1:0]	fifo_out;
wire [FDWIDTH-1:0]	fifo_out_next;
wire [FDWIDTH-1:0]	fifo_out2;
wire [FDWIDTH-1:0]	fifo_out2_next;

wire			rd_en_int;


wire 			phcomp_rden_int;
wire 			comp_rden_en_int;




reg			phcomp_wren_d0;
reg			phcomp_wren_d1;


wire 			comp_dv_en_sync;
wire			phcomp_wren_sync;

reg      		dv_en_d0;
reg      		dv_en_d1;
reg      		dv_en_d2;
reg      		dv_en_d3;
reg      		dv_en_d4;

wire                	wr_empty;
wire                	wr_pempty;
//wire                	wr_pfull;
//wire                	wr_full;

wire			phcomp_wren_sync2;
reg			phcomp_wren_sync3;
reg			phcomp_wren_sync4;
reg			phcomp_wren_sync5;
reg			phcomp_wren_sync6;

wire			wr_fifo_en;

reg [79:0]		data_out;
//wire [73:0]		baser_fifo_data;
//wire [73:0]		baser_fifo2_data;
wire			data_valid_in;
reg			data_valid_out;
wire [79:0]		baser_insert_sm_data;


// FIFO mode decode
wire intl_generic_mode = (r_fifo_mode == 3'b001);
wire basic_generic_mode = (r_fifo_mode == 3'b101);
wire register_mode = (r_fifo_mode[1:0] == 2'b11);
wire phcomp_mode = (r_fifo_mode[1:0] == 2'b00);
//wire base_r_clkcomp_mode = (r_fifo_mode == 3'b010);
assign base_r_clkcomp_mode = (r_fifo_mode == 3'b010);

wire generic_mode = intl_generic_mode || basic_generic_mode;

//reg		        wm_bit;
//reg		        wm_bit_d1;
//reg		        wm_bit_d2;
//reg		        wm_bit_d3;
//reg		        wm_bit_d4;
//reg		        wm_bit_d5;
//wire		        wm_found;
//reg			wm_found_lt;

reg			rd_en_lt;

//wire [63:0]		insert_sm_data_out;
//wire [9:0]		insert_sm_control_out;
//wire			insert_sm_rd_en;
//wire			rd_en_lt0;
wire			phcomp_wren_int;

//assign rx_fifo_rd_en = rd_en_int;

wire 			asn_gen3_sel_sync;
wire			asn_fifo_hold_sync;

wire			dv_bit;
reg			dv_bit_reg;

reg			fifo_latency_adj_wr_sync_d0;
reg			fifo_latency_adj_wr_sync_d1;
wire			fifo_latency_adj_wr_sync;
wire			fifo_latency_adj_wr_pulse;
reg			fifo_latency_adj_rd_sync_d0;
wire			fifo_latency_adj_rd_sync;
wire			fifo_latency_adj_rd_pulse;
wire 			wr_en_int2;
wire 			rd_en_int2;

wire			ps_rd_addr_msb;
wire			ps_wr_addr_msb;

reg			phystatus_fall;
reg			phystatus_delay;
wire			phystatus;

wire			ps_dw_wr_addr_msb;
wire			ps_dw_rd_addr_msb;

reg			phcomp_wren_d2;
wire			asn_fifo_srst_n_rd_clk;
wire			asn_fifo_srst_n_wr_clk;

wire			wr_srst_n_int;
wire			rd_srst_n_int;

wire			block_lock_sync;
wire			wr_align_clr;
wire			comp_wren_en_int;
wire		        fifo_ready_int;

reg		        compin_sel_wren_reg;
reg		        compin_sel_wren_reg2;
wire			compin_sel_wren_neg_edge;

reg		        compin_sel_rden_reg;
reg		        compin_sel_rden_reg2;
wire			compin_sel_rden_neg_edge;
reg                     rd_addr_msb_reg;
reg                     ps_rd_addr_msb_reg;
reg                     ps_dw_rd_addr_msb_reg;

// Bit mapping
// phcomp mode or elastic: data valid
// clock comp: 10G baseR wr_en
//assign dv_or_wren  = data_in[38];
//assign frame_lock  = data_in[37];
//assign control_bit  = data_in[29];

assign data_in = aib_fabric_rx_data_in;

//assign pld_rx_fabric_data_out = data_out;

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0)
      rd_align_clr_reg     <= 1'b0;
   else 
      rd_align_clr_reg	   <= rd_align_clr;
end


//********************************************************************
// Instantiate the Async FIFO 
// (parameter FDWIDTH,parameter FAWIDTH,parameter FIFO_ALMFULL,parameter FIFO_ALMEMPTY)
//********************************************************************
hdpldadapt_rx_datapath_async_fifo
#(
.DWIDTH        (FDWIDTH),       // FIFO Input data width 
.AWIDTH        (FAWIDTH)       // FIFO Depth (address width) 
)
hdpldadapt_rx_datapath_async_fifo
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
.rd_rst_n      (rd_rst_n),    // Read Domain Active low Reset
.rd_srst_n     (fifo_srst_n_rd_clk),       // Read Domain Active low Reset Synchronous
.rd_clk       (rd_clk),     // Read Domain Clock
.rd_en        (rd_en_int2),      // Read Data Enable
.rd_data      (fifo_out),   // Read Data Out 
.rd_data_next (fifo_out_next),// Read Data Out 
.rd_data2      (fifo_out2),   // Read Data Out 
.rd_data2_next (fifo_out2_next),// Read Data Out 
.rd_numdata   (rd_numdata), // Number of Data available in Read clock
.wr_numdata   (wr_numdata), // Number of Data available in Write clock 
.r_pempty	(r_pempty),	     // FIFO partially empty threshold   
.r_pfull	(r_pfull),	     // FIFO partially full threshold   
.r_empty	(r_empty),	     // FIFO empty threshold   
.r_full	        (r_full),	     // FIFO full threshold   
.r_stop_write   (r_stop_write),    // FIFO write option
.r_stop_read    (r_stop_read),    // FIFO read option
.r_double_read    (r_double_read), 	// FIFO read option
.r_fifo_power_mode (r_fifo_power_mode),
.wr_empty (wr_empty),              // FIFO Empty
.wr_pempty (wr_pempty),            // FIFO Partial Empty
.wr_full (wr_full),                // FIFO Full
.wr_pfull (wr_pfull),              // FIFO Parial Full
.wr_full_comb (wr_full_comb),                // FIFO Full
.wr_pfull_comb (wr_pfull_comb),              // FIFO Parial Full
.rd_empty (rd_empty),              // FIFO Empty
.rd_pempty (rd_pempty),            // FIFO Partial Empty
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
.ps_dw_wr_addr_msb (ps_dw_wr_addr_msb),	   // Write address MSB for latency measure
.ps_dw_rd_addr_msb (ps_dw_rd_addr_msb_reg),	   // Read address MSB for latency measure
.ps_wr_addr_msb (ps_wr_addr_msb),	   // Write address MSB for latency measure
.ps_rd_addr_msb	(ps_rd_addr_msb_reg),	   // Read address MSB for latency measure
.latency_pulse	(latency_pulse)
);

//assign del_sm_wr_data   = {del_sm_control_out, del_sm__out};

// Insert data valid to control bit[7]
// assign  wr_data_in_phcomp = same_clk_phcomp_mode ? {wr_data_in[FDWIDTH-1: FDWIDTH-2], data_valid_in_pre, wr_data_in[FDWIDTH-4: 0]} : wr_data_in;  

// Data & Write/Read selection for different modes
//assign wr_data_in_int = generic_mode ? wr_data_in :             // Generic
//                        phcomp_mode ?  wr_data_in :      	// Phase Comp mode 
//                        del_sm_wr_data;				// BaseR Clock Comp

assign wr_data_in 	= data_in;  


assign wr_en_int = (phcomp_mode && r_indv) ? phcomp_wren_int:	// Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_wren_en_int:	// Phase Comp Bonding mode
                   (base_r_clkcomp_mode) ?    del_sm_wr_en:     // BaseR mode	
                                              data_valid_in;       // Interlaken mode or generic mode


assign rd_en_int = (phcomp_mode && r_indv) ? phcomp_rden :	// Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_rden_en_int:	// Phase Comp Bonding mode
                   generic_mode ?	      rd_en :	        // Interlaken or Generic mode
					      insert_sm_rd_en;	// BaseR 
					      
// FIFO sync reset
// Interlaken Generic: reset with rd_align_clr
// Clock comp: reset by block lock or not (depends on r_write_ctrl)
// Phase-comp: reset by rd_align_clr (depends on r_write_ctrl)
assign     wr_srst_n_int    = intl_generic_mode  ? ~wr_align_clr : base_r_clkcomp_mode ? (block_lock || r_write_ctrl) : r_write_ctrl || ~wr_align_clr ; 
assign     rd_srst_n_int    = intl_generic_mode  ? ~rd_align_clr_reg : base_r_clkcomp_mode ? (block_lock_sync || r_write_ctrl) : r_write_ctrl || ~rd_align_clr_reg ; 
					      
//********************************************************************
// READ CLOCK DOMAIN: STOP reading when PEMPTY,
// empty, the FIFO read is stopped when the read data has a 
// IDLE/TERM/SEQ_IDLE/IDLE_SEQ
//********************************************************************


// Output Register and Bypass Logic
//always @(negedge rd_rst_n or posedge rd_clk) begin
//   if (rd_rst_n == 1'b0) begin
//      data_valid_out     <= 1'b0;
//      data_out           <= FIFO_DATA_DEFAULT;
//   end
//   else if (fifo_srst_n_rd_clk == 1'b0) begin
//      data_valid_out     <= 1'b0;
//      data_out           <= FIFO_DATA_DEFAULT;
//   end
//// PCI-e hold during switching   
//   else if (~asn_fifo_hold_sync) begin
//    // PC mode: before reading from FIFO
//     if (phcomp_mode && ~rd_en_int) begin
//        data_valid_out     <= 1'b0;
//        data_out               <= FIFO_DATA_DEFAULT;
//     end
//    // Non PC mode, when empty   
//     else if (rd_empty && ~phcomp_mode) begin
//        data_valid_out     <= 1'b0;
//        data_out               <= FIFO_DATA_DEFAULT;
//     end
//     else if (base_r_clkcomp_mode) begin
//        data_valid_out     <= 1'b1;
//        data_out               <= insert_sm_rd_en_lt? baser_insert_sm_data : data_out;
//     end
//    // Interlaken mode and Phase Comp mode
//    // Use rd_en to gate data_out and generate data_valid_out
//     else begin
//        data_valid_out     <= rd_en_int ? 1'b1: 1'b0;
//        data_out        <= rd_en_int ? {fifo_out_next, fifo_out}: data_out;
//     end
//   end
//
//end

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
   end
// PCI-e hold during switching   
   else if (asn_fifo_hold_sync) begin
      data_valid_out     <= data_valid_out;
      data_out           <= data_out;
   end     
   else if (fifo_srst_n_rd_clk == 1'b0) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
   end
    // Register mode
   else if (register_mode) begin
      data_valid_out     <= 1'b1;
      data_out               <= {{FDWIDTH{1'b0}},data_in};
   end
    // PC mode: before reading from FIFO
   else if (phcomp_mode && ~rd_en_int2) begin
      data_valid_out     <= 1'b0;
      data_out               <= FIFO_DATA_DEFAULT;
   end
   // Non PC mode, when empty   
   else if (rd_empty && ~phcomp_mode) begin
      data_valid_out     <= 1'b0;
      data_out               <= FIFO_DATA_DEFAULT;
   end
   else if (base_r_clkcomp_mode) begin
      data_valid_out     <= 1'b1;
      data_out               <= insert_sm_rd_en_lt? baser_insert_sm_data : data_out;
   end
   // Interlaken mode and Phase Comp mode
   // Use rd_en to gate data_out and generate data_valid_out
   else begin
      data_valid_out     <= rd_en_int2 ? 1'b1: 1'b0;
      data_out        <= rd_en_int2 ? {fifo_out_next, fifo_out}: data_out;
   end

end


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
   else if (fifo_srst_n_wr_clk == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
     phcomp_wren_d2 <= 1'b0;
   end   
   else begin
//     phcomp_wren_d0 <= phcomp_wren_d0 || wa_lock && (data_valid_in || ~r_gb_dv_en);
     phcomp_wren_d0 <= phcomp_wren_d0 || data_valid_in;
     phcomp_wren_d1 <= phcomp_wren_d0;
     phcomp_wren_d2 <= phcomp_wren_d1;
   end
end

assign phcomp_wren = phcomp_wren_d1;

//assign phcomp_wren_int = phcomp_wren && (data_valid_in || ~r_gb_dv_en);
assign phcomp_wren_int = phcomp_wren && data_valid_in;

//assign comp_wren_en_int = comp_wren_en && (data_valid_in || ~r_gb_dv_en);
assign comp_wren_en_int = comp_wren_en && data_valid_in;

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
assign phcomp_wren_sync = (r_phcomp_rd_delay == 3'b110) ? phcomp_wren_sync6 : (r_phcomp_rd_delay == 3'b101) ? phcomp_wren_sync5 : (r_phcomp_rd_delay == 3'b100) ? phcomp_wren_sync4 : (r_phcomp_rd_delay == 3'b011) ? phcomp_wren_sync3 : phcomp_wren_sync2;
assign phcomp_rden = phcomp_wren_sync;


assign comp_rden_en_int = comp_rden_en;




// Testbus
assign testbus1 =	{5'd0, fifo_srst_n_wr_clk, ps_dw_wr_addr_msb, ps_wr_addr_msb, wr_addr_msb, wr_pempty, wr_empty, phcomp_wren, comp_wren_en, wr_numdata[5:0], wr_en_int2};
assign testbus2 =	{2'd0, fifo_srst_n_rd_clk, fifo_ready, ps_dw_rd_addr_msb, ps_rd_addr_msb, rd_addr_msb, rd_empty, rd_pempty, data_valid_in, rd_numdata[5:0], rd_en_int2, comp_rden_en, phcomp_rden, data_valid_out};


// Output flag
assign fifo_pempty 	= r_pempty_type ? wr_pempty_stretch : 	rd_pempty;
assign fifo_pfull 	= r_pfull_type  ? wr_pfull_stretch  :	rd_pfull; 
assign fifo_empty 	= r_empty_type  ? wr_empty_stretch  :   rd_empty;
assign fifo_full  	= r_full_type 	? wr_full_stretch   :   rd_full;


// Need to extract wr_en/DV bit from LW bit 26, bit[38] is Interlaken write_en
// Mapping update: wr_en/DV bit = bit 36, bit[38] is Interlaken write_en
//assign dv_bit = wa_lock && (intl_generic_mode ? data_in[38] && ~data_in[39] && data_in[26] : ~data_in[39] && data_in[26]);
//assign dv_bit = wa_lock && (intl_generic_mode ? data_in[38] && data_in[36] : data_in[36]);
//assign dv_bit = wa_lock && ~data_in[39] && (intl_generic_mode ? data_in[38] && data_in[36] : data_in[36]);
   assign dv_kill = data_in[36] & r_gb_dv_en;
   assign dv_bit = wa_lock && ~data_in[39] && (intl_generic_mode ? data_in[38] && dv_kill : dv_kill );

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     dv_bit_reg <= 1'b0;
   end
// Only logic used in PIPE/PCI-e mode uses sync reset
//   else if (fifo_srst_n_wr_clk == 1'b0) begin
//     dv_bit_reg <= 1'b0;
//   end
   else begin
     dv_bit_reg <= dv_bit;
   end
end

//assign data_valid_in = dv_bit || dv_bit_reg || ~r_gb_dv_en;
assign data_valid_in = r_gb_dv_en ? (dv_bit || dv_bit_reg) : wa_lock;


//Word-align
//always @(negedge wr_rst_n or posedge wr_clk) begin
//   if (wr_rst_n == 1'b0) begin
//     wm_bit 	 <= 1'b0;
//     wm_bit_d1 <= 1'b0;
//     wm_bit_d2 <= 1'b0;
//     wm_bit_d3 <= 1'b0;
//     wm_bit_d4 <= 1'b0;
//     wm_bit_d5 <= 1'b0;
//     wa_lock_lt <= 1'b0;
//   end
//   else begin
//     wm_bit 	 <= data_in[39];
//     wm_bit_d1 <= wm_bit;
//     wm_bit_d2 <= wm_bit_d1;
//     wm_bit_d3 <= wm_bit_d2;
//     wm_bit_d4 <= wm_bit_d3;
//     wm_bit_d5 <= wm_bit_d4;
//     wm_found_lt <= wm_found_lt || wm_found;
//   end
//end
//
//assign wm_found = wm_bit && ~wm_bit_d1 && wm_bit_d2 && ~wm_bit_d3 && wm_bit_d4 && ~wm_bit_d5 || ~r_wa_en;

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      rd_en_lt			<= 1'b0;
   end
   else if (~fifo_srst_n_rd_clk)
      rd_en_lt			<= 1'b0;   
   else begin
      rd_en_lt			<= rd_en_int2 || rd_en_lt;
   end
end   


assign align_done = r_wa_en && rd_en_lt;
 
   
//********************************************************************
// 10G BaseR deletion/insertion logic 
//********************************************************************
//hdpldadapt_rx_datapath_del_sm
//   #(
//      .PCSDWIDTH      	(PCSDWIDTH),   // PCS data width
//      .PCSCWIDTH      	(PCSCWIDTH,    // PCS control width
//      .FAWIDTH          (FAWIDTH),     // FIFO Depth (address width) 
//    ) hdpldadapt_rx_datapath_del_sm
//    (
//.wr_rst_n			(wr_rst_n),
//.wr_srst_n   			(wr_srst_n),   
//.wr_clk      			(wr_clk),      
//.control_in  			(control_in),  
//.data_in     			(data_in),     
//.data_valid_in			(data_valid_in),
//.block_lock			(block_lock),
//.r_write_ctrl			(r_write_ctrl),
//.wr_pfull    			(wr_pfull),    
//.wr_full     			(wr_full),     
//.control_out 			(del_sm_control_out), 
//.data_out    			(del_sm_data_out),    
//.fifo_del 			(fifo_del), 
//.wr_en				(del_sm_wr_en)
//    );

//hdpldadapt_rx_datapath_insert_sm
//   #(
//      .PCSDWIDTH      	(64),   // PCS data width
//      .PCSCWIDTH      	(10)    // PCS control width
//    ) hdpldadapt_rx_datapath_insert_sm
//    (				
//.rd_rst_n 			(rd_rst_n), 
//.rd_srst_n			(rd_srst_n),
//.rd_clk				(rd_clk),
//.fifo_out    			(baseR_fifo_data),
//.fifo_out_next			(baseR_fifo_data2),
//.rd_pempty			(rd_pempty),
//.rd_empty			(rd_empty),
//.data_valid_out			(data_valid_out),
//.r_truebac2bac			(r_truebac2bac),
//.control_out			(insert_sm_control_out),
//.data_out   			(insert_sm_data_out),
//.rd_en_10g			(insert_sm_rd_en),
//.rd_en_lt0			(rd_en_lt0)
//    );

// Remap
// assign baser_fifo_data		= {fifo_out[36:27], fifo_out_next[37:0], fifo_out[25:0]};
// assign baser_fifo_data2		= {fifo_out2[36:27], fifo_out2_next[37:0], fifo_out2[25:0]};
assign baser_fifo_data		= {fifo_out_next[37:32], fifo_out[35:32], fifo_out_next[31:0], fifo_out[31:0]};
assign baser_fifo_data2		= {fifo_out2_next[37:32], fifo_out2[35:32], fifo_out2_next[31:0], fifo_out2[31:0]};


// Map data from insert SM to 80-bit
// Remap: assign baser_insert_sm_data	= {1'b1, 1'b0, insert_sm_data_out[63:26], 1'b0, 2'b00,insert_sm_control_out, data_valid_out,insert_sm_data_out[25:0]};
assign baser_insert_sm_data	= {1'b1, 1'b0, insert_sm_control_out[9:4], insert_sm_data_out[63:32], 1'b0, 2'b00, data_valid_out,insert_sm_control_out[3:0], insert_sm_data_out[31:0]};

assign baser_data_valid 	= data_valid_out;

//Word-align error detect

assign wa_error = (data_out[39] || ~data_out[79]) && r_wa_en && data_valid_out;

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     wa_error_cnt <= 4'b0000;
   end
   else if (fifo_srst_n_rd_clk == 1'b0) begin
     wa_error_cnt <= 4'b0000;
   end
   else if (wa_error_cnt < 4'b1111 && wa_error) begin
     wa_error_cnt 	<= wa_error_cnt + 1'b1;
   end
end   

// G3 switching/reset logic

// Sync to write/read clock domain
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),   	// Reset Value 
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

//   cdclib_bitsync2 
//     #(
//       .DWIDTH      (1),    	// Sync Data input 
//       .RESET_VAL   (0)    	// Reset Value 
//       )
//       cdclib_bitsync2_asn_gen3_sel
//         (
//          .clk      (rd_clk),
//          .rst_n    (rd_rst_n),
//          .data_in  (asn_gen3_sel),
//          .data_out (asn_gen3_sel_sync)
//          );

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

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_align_clr
         (
          .clk      (wr_clk),
          .rst_n    (wr_rst_n),
          .data_in  (rd_align_clr_reg),
          .data_out (wr_align_clr)
          );

   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    	// Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (4),
       .VID (1)
       ) 
       hd_dpcmn_bitsync2_block_lock
         (
          .clk      (rd_clk),
          .rst_n    (rd_rst_n),
          .data_in  (block_lock_lt),
          .data_out (block_lock_sync)
          );

assign asn_fifo_srst_n = ~asn_fifo_srst;  

// Combine with legacy 10G sync reset
// Combine with bond signal neg edge detect
assign fifo_srst_n_rd_clk = asn_fifo_srst_n_rd_clk && rd_srst_n_int && ~compin_sel_rden_neg_edge;
assign fifo_srst_n_wr_clk = asn_fifo_srst_n_wr_clk && wr_srst_n_int && ~compin_sel_wren_neg_edge;
// HN func ECO assign wa_srst_n_wr_clk = asn_fifo_srst_n_wr_clk && ~compin_sel_wren_neg_edge;
assign wa_srst_n_wr_clk = asn_fifo_srst_n_wr_clk && ~compin_sel_wren_neg_edge && ~wr_align_clr;
//assign double_read_int = asn_gen3_sel_sync || r_double_read ? 1'b1: 1'b0;
assign double_read_int = r_double_read;

// Latency adjust
   cdclib_bitsync2 
     #(
       .DWIDTH      (1),    // Sync Data input 
       .RESET_VAL   (0),    	// Reset Value 
       .CLK_FREQ_MHZ(1000),
       .TOGGLE_TYPE (4),
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
       .TOGGLE_TYPE (4),
       .VID (1)
       )
       cdclib_bitsync2_rd_adj
         (
          .clk      (rd_clk),
          .rst_n     (rd_rst_n),
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

// Gate phystatus to 1 during reset
assign phystatus = data_out[32];

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n) begin
    phystatus_fall 	<= 1'b0;
    phystatus_delay 	<= 1'b0;
  end  
//  else if (~fifo_srst_n_rd_clk) begin
//    phystatus_fall 	<= 1'b0;
//    phystatus_delay 	<= 1'b0;
//  end  
  else begin
    phystatus_fall 	<= phystatus_fall || (~phystatus && phystatus_delay);
    phystatus_delay 	<= phystatus;
  end  
end

// In PIPE mode, after reset release and before seeing phystatus first rising edge, gate phystatus to 1;
assign pld_rx_fabric_data_out[32] = (r_pipe_en && ~phystatus_fall) ? 1'b1 : data_out[32];
//assign pld_rx_fabric_data_out[31:0] = data_out[31:0];
//assign pld_rx_fabric_data_out[25:0] = data_out[25:0];
//assign pld_rx_fabric_data_out[31:27] = data_out[31:27];
assign pld_rx_fabric_data_out[31:0] = data_out[31:0];
//assign pld_rx_fabric_data_out[79:33] = data_out[79:33];
assign pld_rx_fabric_data_out[35:33] = data_out[35:33];
assign pld_rx_fabric_data_out[36] = data_out[36];
assign pld_rx_fabric_data_out[78:37] = data_out[78:37];


// When GB data valid is enabled, map pld_rx_fabric_data_out[26] to FIFO data valid out
// Remap: assign pld_rx_fabric_data_out[26] = r_gb_dv_en ? data_valid_out: data_out[26];
// assign data_valid_out to bit 79. This bit is needed for Interlaken, Elastic and regsiter mode with GB. Optional for PC and CC mode
//assign pld_rx_fabric_data_out[36] = r_gb_dv_en ? data_valid_out: data_out[36];
assign pld_rx_fabric_data_out[79] = data_valid_out;

assign fifo_ready_int = comp_rden_en_int || r_indv || ~phcomp_mode;

always @ (posedge rd_clk or negedge rd_rst_n) begin
  if (~rd_rst_n) begin
    fifo_ready 	<= 1'b0;
  end  
  else begin
    fifo_ready 	<= fifo_ready_int; 
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
          ps_dw_rd_addr_msb_reg  <= 1'b0;
       end
     else
       begin
          rd_addr_msb_reg <= rd_addr_msb;
          ps_rd_addr_msb_reg  <= ps_rd_addr_msb;
          ps_dw_rd_addr_msb_reg  <= ps_dw_rd_addr_msb;
       end
     end // always @ (negedge rst_n or posedge clk)
     
endmodule
