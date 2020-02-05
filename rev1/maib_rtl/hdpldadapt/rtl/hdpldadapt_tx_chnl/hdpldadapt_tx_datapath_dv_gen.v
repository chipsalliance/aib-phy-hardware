// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpldadapt_tx_datapath_dv_gen.v.rca $
// Revision:    $Revision: #8 $
// Date:        $Date: 2015/04/15 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------
module hdpldadapt_tx_datapath_dv_gen
   #(
      parameter ISWIDTH        = 'd7       // Gearbox Selector width
    )
    (
      input  wire                 rst_n,           // Active low Reset
      input  wire                 clk,             // Clock

      input  wire		  r_double_write,  // FIFO double write option
      input  wire                 r_dv_indv,       // Data valid Individual Mode
      input  wire [2:0]           r_gb_idwidth,   // Gearbox Input Width
      input  wire [1:0]           r_gb_odwidth,   // Gearbox Output Width
      input  wire [2:0]           r_fifo_mode,     // FIFO Mode: Phase-comp, Interlaken, Elastic, Register Mode
      input  wire                 r_gb_dv_en,     // DV gen bypass
      
      input  wire		  rd_pempty,
//      input  wire	          data_valid_in,
      input  wire	          phcomp_rden,
      input  wire	          comp_dv_en_reg,
      
      output  wire [19:0]	  dv_gen_testbus,
      output wire  		  start_dv,
      output  wire	          data_valid_2x,       // Toggling DV from DV gen   
      output wire                 data_valid_out    	 // Data Valid Enable to CP Bonding
    );

//********************************************************************
// Define Parameters 
//********************************************************************

//********************************************************************
// Define variables 
//********************************************************************
reg [ISWIDTH-1:0]    sel_cnt;
reg [2:0]          gap_cnt;
wire               rd_val;
wire [ISWIDTH:0]   m_selcnt;
reg		   first_read;
reg		   dv_2x;

// FIFO mode decode
wire intl_generic_mode = (r_fifo_mode == 3'b001);
wire basic_generic_mode = (r_fifo_mode == 3'b101);
wire register_mode = (r_fifo_mode[1:0] == 2'b11);
wire phcomp_mode = (r_fifo_mode[1:0] == 2'b00);


wire [6:0]         gb_idwidth;
wire [6:0]         gb_odwidth;

wire [6:0]         threshold;

reg  [6:0]	   dv_seq_cnt;

wire	           gap_cnt_en;

//wire		   start_dv;

assign gb_idwidth = (r_gb_idwidth == 'd5) ? 'd64 : (r_gb_idwidth == 'd4) ? 'd32 : (r_gb_idwidth == 'd3) ? 'd40 :  (r_gb_idwidth == 'd2) ? 'd50 : (r_gb_idwidth == 'd1) ? 'd67 : 'd66;
assign gb_odwidth = (r_gb_odwidth == 'd2) ? 'd64 : (r_gb_odwidth == 'd1) ? 'd40 : 'd32;

assign threshold  = (gb_idwidth == 'd50) ? 'd24 : (gb_idwidth == 'd67) ? 'd66 : (gb_idwidth == 'd64) ? 'd31 : 'd32; 

wire [6:0] diff_gb_iodwidth = gb_idwidth - gb_odwidth;
assign data_valid_2x = dv_2x;

//********************************************************************
// Instantiated modules
//********************************************************************

always @(negedge rst_n or posedge clk) begin
   if (rst_n == 1'b0) begin
      dv_2x         <= 1'b0;
   end
   else if (gap_cnt_en) begin
//      dv_2x         <= r_double_write ? ~dv_2x : 1'b1;
      dv_2x         <= r_gb_dv_en ? ~dv_2x : 1'b1;
   end
end


always @(negedge rst_n or posedge clk) begin
   if (rst_n == 1'b0) begin
      dv_seq_cnt   	<= 'd0;
   end
   else if (gap_cnt_en && dv_2x) begin
     if (dv_seq_cnt < threshold)
       dv_seq_cnt       <= dv_seq_cnt + 1'b1;
     else
       dv_seq_cnt	<= 'd0;
   end
end

assign start_dv = (dv_seq_cnt == 'd0) && gap_cnt_en;

always @(negedge rst_n or posedge clk) begin
   if (rst_n == 1'b0) begin
      first_read         <= 1'b1;
   end
   else if (~rd_pempty && first_read) begin
      first_read         <= 1'b0;
   end
end


assign gap_cnt_en = phcomp_rden && phcomp_mode && r_dv_indv ||                 // Non bonding phase-comp
                    ~first_read && r_dv_indv && ~phcomp_mode || // Non bonding not phase-comp
                    (comp_dv_en_reg && ~r_dv_indv);		// DV bonding	 
                    
assign rd_val =  	~gap_cnt_en ? 1'b0 : (gap_cnt == 'd0) ? 1'b1 : 1'b0;

assign  m_selcnt = (gb_idwidth+sel_cnt);
                 	
always @(negedge rst_n or posedge clk) begin
   if (rst_n == 1'b0) begin
      sel_cnt   <= 'd0;
      gap_cnt   <= 'd0;
   end
   else begin  
// rd_val Generation
// Phase Comp non-bonding: wait until first_read deasserts
// Phase Comp bonding: doesn't wait for first_read (Need data_valid to be available before write/read enable) 
// Interlaken Generic: doesn't wait for first_read (Interlaken needs data_valid for Frame Generator)
// Basic Generic: wait until first_read deasserts 
      
      if (gap_cnt_en && dv_2x) begin
        if (gap_cnt == 'd0) begin    
           // calculate next MUX selection
           if (m_selcnt >= gb_odwidth * 'd5) begin
              sel_cnt <= (m_selcnt-gb_odwidth * 'd5);
              gap_cnt <= 'd4;
           end
           else if (m_selcnt >= gb_odwidth * 'd4) begin
             sel_cnt <= (m_selcnt-gb_odwidth * 'd4);
             gap_cnt <= 'd3;
           end
           else if (m_selcnt >= gb_odwidth * 'd3) begin
             sel_cnt <= (m_selcnt-gb_odwidth * 'd3);
             gap_cnt <= 'd2;
           end
           else if (m_selcnt >= gb_odwidth * 'd2) begin
             sel_cnt <= (m_selcnt-gb_odwidth * 'd2);
             gap_cnt <= 'd1;
           end
           else begin 
             sel_cnt <= (m_selcnt-gb_odwidth);
             gap_cnt <= 'd0;
           end
        end
        else begin
           gap_cnt <= gap_cnt-1'b1;
        end
      
      end

   end
end


//assign data_valid_out = r_gb_dv_en ? data_valid_in : rd_val;
assign data_valid_out = rd_val;

assign dv_gen_testbus = {6'd0, gap_cnt, sel_cnt, start_dv, gap_cnt_en, dv_2x, data_valid_out};

endmodule
