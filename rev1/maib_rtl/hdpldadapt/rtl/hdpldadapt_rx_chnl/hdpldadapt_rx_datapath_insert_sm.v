// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        $RCSfile: hdpcschnlrx_pldif_rx_fifo_insert_sm.v.rca $
// Revision:    $Revision: #4 $
// Date:        $Date: 2014/11/25 $
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_rx_datapath_insert_sm
   #(
      parameter PCSDWIDTH      = 'd64,    // PCS data width
      parameter PCSCWIDTH      = 'd10    // PCS control width
    )
    (
      input  wire                 rd_rst_n,        // rdite Domain Active low Reset
      input  wire                 rd_srst_n,        // rdite Domain Active low Reset
      input  wire                 rd_clk,          // rdite Domain Clock
      
      input  wire [PCSDWIDTH+PCSCWIDTH-1:0] baser_fifo_data,    	// FIFO read data     
      input  wire [PCSDWIDTH+PCSCWIDTH-1:0] baser_fifo_data2,    	// FIFO read data next     
      
      input  wire                 rd_pempty,         // Read partially empty 
      input  wire                 rd_empty,          // Read empty

      input  wire		  baser_data_valid,
      
      input  wire		  r_truebac2bac,

      output wire [19:0]	  insertion_sm_testbus,
      output wire [PCSCWIDTH-1:0] insert_sm_control_out,        // Frame information 
      output wire [PCSDWIDTH-1:0] insert_sm_data_out,        // Read Data Out
      output wire		  fifo_insert,
      output wire		  insert_sm_rd_en,       // To FIFO read enable logic		
      output wire		  insert_sm_rd_en_lt        // To FIFO output register   
    );

//********************************************************************
// Define Parameters 
//********************************************************************
//`include "hd_pcs10g_params.v"
// 10G, 40G & 100G  Ethernet Parameters
   // Spec Definitions
   // MII Control Characters - Unencoded
   localparam               XGMII_IDLE  = 8'h07;
   localparam               XGMII_START = 8'hfb;
   localparam               XGMII_TERM  = 8'hfd;
   localparam               XGMII_ERROR = 8'hfe;
   localparam               XGMII_SEQOS = 8'h9c;
   localparam               XGMII_RES0  = 8'h1c;
   localparam               XGMII_RES1  = 8'h3c;
   localparam               XGMII_RES2  = 8'h7c;
   localparam               XGMII_RES3  = 8'hbc;
   localparam               XGMII_RES4  = 8'hdc;
   localparam               XGMII_RES5  = 8'hf7;
   localparam               XGMII_SIGOS = 8'h5c;

   // Local Fault OS and Error Block - Unencoded 
   localparam               EBLOCK_R            = {8{XGMII_ERROR}};
   localparam               LBLOCK_R_10G        = {8'h1,8'h0,8'h0,XGMII_SEQOS,8'h1,8'h0,8'h0,XGMII_SEQOS};

// Shared Parameters
   // Control Bits 
   localparam               CTL_DATA         = 'd0;
   localparam               CTL_CTRL         = 'd1;
   localparam               CTL_ERR          = 'd8;
   localparam               CTL_BFL          = 'd9;   

   localparam                       RD_IDLE         =2'd0;
   localparam                       RD_ENABLE       =2'd1;
   localparam                       RD_INSERT       =2'd2;
   
   localparam                       XGMII_IDLE_WORD = {4{XGMII_IDLE}};
   
   localparam                       FIFO_DATA_DEFAULT = LBLOCK_R_10G;
   localparam                       FIFO_CTRL_DEFAULT = 10'h11;
   localparam   		    FIFO_DEFAULT = {FIFO_CTRL_DEFAULT, FIFO_DATA_DEFAULT};  
   
   localparam                       FDWIDTH = PCSDWIDTH+PCSCWIDTH;

      
   
   reg [FDWIDTH-1:0]                d_out_comb;
   
   wire                             rd_lw_idle;
   wire                             rd_uw_idle;
   
   wire                             rd_lw_os;
   wire                             rd_uw_os;
   
   wire [1:0]                       ch_insert; 
   
   wire                             wr_en_int;
   wire [FDWIDTH-1:0]               wr_data_in_int;
   
   reg                              first_read;
   
   reg                              insert_after;
   reg                              insert_between;
   
   
//   wire                             rd_en_int;
   wire                             rd_full;
   reg                              keep_insert;
   reg  [1:0]                       rd_add_sm;
   reg  [1:0]                       rd_add_sm_reg;   
   reg                              fifo_insert_pre;
   reg                              rd_en_lt;
   reg		  		    rd_en_10g;       // To FIFO read enable logic		
   wire		                    rd_en_lt0;       // To FIFO output register   
      

   wire [PCSDWIDTH+PCSCWIDTH-1:0]   fifo_out =  baser_fifo_data;    
   wire [PCSDWIDTH+PCSCWIDTH-1:0]   fifo_out_next = baser_fifo_data2;      

   //********************************************************************
   // READ CLOCK DOMAIN: STOP reading when PEMPTY,
   // This logic stops the read data from the fifo if the FIFO becomes partial
   // empty, the FIFO read is stopped when the read data has a 
   // IDLE/TERM/SEQ_IDLE/IDLE_SEQ
   //********************************************************************
   // IDLE/OS detection on read side
   
   assign rd_lw_idle = (fifo_out_next[31:0] == {4{XGMII_IDLE}} && fifo_out_next[67:64] == 4'hF) ? 1'b1: 1'b0;
   assign rd_uw_idle = (fifo_out_next[63:32] == {4{XGMII_IDLE}} && fifo_out_next[71:68] == 4'hF) ? 1'b1: 1'b0;
   
   // OS detection
   // Only delete 2nd OS of consecutive identical OS's
   assign rd_lw_os = (fifo_out_next[7:0] == XGMII_SEQOS && fifo_out_next[67:64] == 4'h1) ? 1'b1: 1'b0;
   assign rd_uw_os = (fifo_out_next[39:32] == XGMII_SEQOS && fifo_out_next[71:68] == 4'h1) ? 1'b1: 1'b0;
   
   assign ch_insert = {rd_uw_idle||rd_uw_os, rd_lw_idle||rd_lw_os}; 
   
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         first_read         <= 1'b1;
      end
      else if (rd_srst_n == 1'b0) begin
         first_read         <= 1'b1;
      end
      else if (~rd_pempty && first_read) begin
         first_read         <= 1'b0;
      end
   end
   
   assign first_read_int = first_read ? rd_pempty : 1'b0;

   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_add_sm          <= RD_IDLE;
         rd_en_10g              <= 1'b0;
         insert_after	<= 1'b0;
         insert_between	<= 1'b0;
         keep_insert		<= 1'b0;
      end
      else if (rd_srst_n == 1'b0) begin
         rd_add_sm          <= RD_IDLE;
         rd_en_10g              <= 1'b0;
         insert_after	<= 1'b0;
         insert_between	<= 1'b0;
         keep_insert		<= 1'b0;
      end      
      else begin
        if (baser_data_valid) begin
//        if (data_valid_in_fb) begin
            case(rd_add_sm)
              RD_IDLE: begin
//                 if (~rd_pempty && ~first_read) begin
                 if (~first_read_int) begin
                    rd_add_sm      <= RD_ENABLE;
                    rd_en_10g          <= 1'b1;
                 end  
                 else begin
                    rd_add_sm      <= RD_IDLE;
                    rd_en_10g          <= 1'b0;
                 end      
              end
              RD_ENABLE: begin
                 insert_after	<= 1'b0;
                 insert_between	<= 1'b0;
                 keep_insert		<= 1'b0;
                 
	             if(|ch_insert && rd_pempty) 
	               begin
                      rd_add_sm        <= RD_INSERT; 
                      rd_en_10g            <= 1'b0;
                      
                      // Data insertion logic
	                  casez(ch_insert)
                        2'b1?: begin
		                   // When UW is Idle/OS
		           insert_after	<= 1'b1;
                        end
		                // When LW is Idle/OS	
                        2'b01: begin
                           insert_between	<= 1'b1;
                        end
                        default: begin
                   	  insert_after	<= 1'b0;
                 	  insert_between	<= 1'b0;
			end
			 
                      endcase
                      
                   end
                 
                 else 
                   begin
		              rd_add_sm        <= RD_ENABLE; 
		              rd_en_10g            <= 1'b1;
                   end
              end 
              
              
              RD_INSERT: begin

                 keep_insert		<= 1'b0;

                 if (rd_pempty && r_truebac2bac) begin
                    rd_add_sm        <= RD_INSERT;
                    rd_en_10g            <= 1'b0;
                    keep_insert		<= 1'b1;
                   
                 end
                 else if (insert_after) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
                 end   
                 else if (insert_between) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
                 end   
                                       
              end
              default: begin
                 rd_add_sm      <= RD_IDLE;
                 rd_en_10g          <= 1'b1;
              end
            endcase
            
         end   
         
         else begin
            rd_en_10g              <= 1'b0;
         end
         
      end         
   end



always @ *
  begin
      if (rd_add_sm_reg==RD_IDLE) begin
        if (~first_read_int)
          d_out_comb	  	= fifo_out;
        else         
          d_out_comb	  	= FIFO_DEFAULT;
      end  
      
      else if (rd_add_sm_reg==RD_ENABLE) begin
// Insert after when UW is Idle/OS
        if (insert_after)
          d_out_comb         	= fifo_out;
// Insert after when LW is Idle/OS and UW is not
        else if (insert_between)
	  d_out_comb	  	= 	{fifo_out[FDWIDTH-1:72] ,4'hF, fifo_out[67:64], XGMII_IDLE_WORD, fifo_out[31:0]};
	else
	  d_out_comb         	= fifo_out;
      end          
         
//      else if (rd_add_sm_reg==RD_INSERT) begin
      else begin
        if (keep_insert)
          d_out_comb			= {2'b10,8'hFF,{2{XGMII_IDLE_WORD}}};
        else if (insert_after)
          d_out_comb         	= {2'b10,8'hFF,{2{XGMII_IDLE_WORD}}};
        else if (insert_between)
          d_out_comb         	= {fifo_out[FDWIDTH-1:68], 4'hF, fifo_out[63:32], XGMII_IDLE_WORD};
        else
          d_out_comb         	= fifo_out;
      end  
      
   end

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      rd_add_sm_reg	 <= RD_IDLE;
   end
   else begin
      rd_add_sm_reg	 <= rd_add_sm;
   end
end   


// 10G BaseR insertion flag
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         fifo_insert_pre	<= 1'b0;      
      end
      else begin
         fifo_insert_pre	<= (insert_after && (rd_add_sm_reg==RD_INSERT)) || insert_between ;      
      end
   end 

assign fifo_insert		= fifo_insert_pre;      
   
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_en_lt	<= 1'b0;      
      end
      else if (rd_srst_n == 1'b0) begin
         rd_en_lt	<= 1'b0;      
      end
      else begin
         rd_en_lt	<= rd_en_10g || rd_en_lt;      
      end
   end 

assign rd_en_lt0 = rd_en_10g || rd_en_lt;


assign {insert_sm_control_out, insert_sm_data_out} = d_out_comb;

assign insert_sm_rd_en_lt	=  rd_en_lt0;
assign insert_sm_rd_en		=  rd_en_10g;

assign insertion_sm_testbus = {14'd0, rd_add_sm, insert_sm_rd_en, insert_after, insert_between, keep_insert};

endmodule
