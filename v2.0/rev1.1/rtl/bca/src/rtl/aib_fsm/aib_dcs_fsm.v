// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_dcs_fsm (
	   input sys_clk,
           input rst_n,
   	   input scan_mode,  // Scan mode
   	   input clk_div_ld, // Clock divider enable from avalon interface
   	   input clk_div_1_onehot,  // Onehot enable for clock divided by 1
   	   input clk_div_2_onehot,  // Onehot enable for clock divided by 2
   	   input clk_div_4_onehot,  // Onehot enable for clock divided by 4
   	   input clk_div_8_onehot,  // Onehot enable for clock divided by 8
   	   input clk_div_16_onehot, // Onehot enable for clock divided by 16
   	   input clk_div_32_onehot, // Onehot enable for clock divided by 32
   	   input clk_div_64_onehot, // Onehot enable for clock divided by 64
   	   input clk_div_128_onehot, // Onehot enable for clock divided by 128
   	   input clk_div_256_onehot, // Onehot enable for clock divided by 256
           input duty_gt_50,
           input dcs_en,
           input dcs_ovrd_sel,
           input dcs_ovrd_lock,
           input dcs_ovrd_chopen,
           input [4:0] dcs_ovrd_p_pdsel,
           input [4:0] dcs_ovrd_p_pusel,
           input [4:0] dcs_ovrd_n_pdsel,
           input [4:0] dcs_ovrd_n_pusel,
           output wire [4:0] dcc_p_pdsel,
           output wire [4:0] dcc_p_pusel,
           output wire [4:0] dcc_n_pdsel,
           output wire [4:0] dcc_n_pusel,
           output wire chopen, 
           output wire dcs_lock,
   	   output wire clk_div_ld_ack_ff // Clock divider load acknowledge
	   );

reg [1:0] dcs_curst, dcs_nxst;
reg [6:0] dcs_code;
reg [4:0] duty_gt_50_cnt;
reg dcs_lock_int;
reg [1:0]dcs_comp;
reg chopen_intr;
reg [4:0] dcs_lock_cnt;
wire p_pd_chng;
wire n_pu_chng;
wire n_pd_chng;
wire [4:0] dcc_p_pdsel_intr;
wire [4:0] dcc_p_pusel_intr;
wire [4:0] dcc_n_pdsel_intr;
wire [4:0] dcc_n_pusel_intr;
wire sys_div_clk;
wire duty_gt_50_sync;

parameter START = 2'b00,
	  RUN   = 2'b01;

// DCS counter threshold
`ifdef CAL_CODE_CNT
   localparam [4:0] DCS_CNT_VAL = `DCS_CNT_VAL;
`else
   localparam [4:0] DCS_CNT_VAL = 5'b1_1111;// Calibration count
`endif

//Should keep divider block Div-32,64,128,256 and need to add DCS lock signal
aib_clk_div_dcs aib_clk_div_dcs(
.rst_n(rst_n),
.clk(sys_clk),
.scan_mode(scan_mode),
.clk_div_ld(clk_div_ld),
.clk_div_1_onehot(clk_div_1_onehot),
.clk_div_2_onehot(clk_div_2_onehot),
.clk_div_4_onehot(clk_div_4_onehot),
.clk_div_8_onehot(clk_div_8_onehot),
.clk_div_16_onehot(clk_div_16_onehot),
.clk_div_32_onehot(clk_div_32_onehot),
.clk_div_64_onehot(clk_div_64_onehot), //Default value is 64
.clk_div_128_onehot(clk_div_128_onehot),
.clk_div_256_onehot(clk_div_256_onehot),
.clk_out(sys_div_clk),
.clk_div_ld_ack_ff(clk_div_ld_ack_ff)
);

// Start Phase synchronizer
aib_bit_sync bitsync_duty_gt_50
(
.clk      (sys_clk),       // Clock of destination domain
.rst_n    (rst_n),         // Reset of destination domain
.data_in  (duty_gt_50),    // Input to be synchronized
.data_out (duty_gt_50_sync)   // Synchronized output
);

//as output and keep override signal
assign p_pd_chng  = ~(dcs_code[1] & dcs_code[0]);
assign n_pu_chng  = (dcs_code[1:0] == 2'b00 || dcs_code[1:0] == 2'b01);
assign n_pd_chng  = ~(dcs_code[1] | dcs_code[0]);

assign dcc_p_pusel_intr = ~dcs_code[6:2];
assign dcc_p_pdsel_intr = p_pd_chng ? ~dcs_code[6:2] : (~dcs_code[6:2] - 1'b1);
assign dcc_n_pusel_intr = n_pu_chng ?  dcs_code[6:2] : (dcs_code[6:2] + 1'b1);
assign dcc_n_pdsel_intr = n_pd_chng ?  dcs_code[6:2] : (dcs_code[6:2] + 1'b1);

//Data Muxing b/w Register Data and internal logic data
assign dcc_p_pusel = dcs_ovrd_sel ? dcs_ovrd_p_pusel : dcc_p_pusel_intr;
assign dcc_p_pdsel = dcs_ovrd_sel ? dcs_ovrd_p_pdsel : dcc_p_pdsel_intr;
assign dcc_n_pusel = dcs_ovrd_sel ? dcs_ovrd_n_pusel : dcc_n_pusel_intr;
assign dcc_n_pdsel = dcs_ovrd_sel ? dcs_ovrd_n_pdsel : dcc_n_pdsel_intr;
assign dcs_lock    = dcs_ovrd_sel ? dcs_ovrd_lock    : dcs_lock_int;
assign chopen      = dcs_ovrd_sel ? dcs_ovrd_chopen  : chopen_intr;

always@(posedge sys_div_clk or negedge rst_n)
 begin
  if(!rst_n)
   dcs_curst[1:0] <= 2'b00;
  else
   dcs_curst[1:0] <= dcs_nxst[1:0];
 end
 
always@(posedge sys_div_clk or negedge rst_n)
 if(!rst_n)
  begin
   dcs_code       <= 7'b011_1111;
   duty_gt_50_cnt <= 5'b0_0000;
   chopen_intr    <= 1'b0;
   dcs_comp       <= 2'b00;
   dcs_lock_cnt   <= 5'b0_0000;
   dcs_lock_int   <= 1'b0;
  end
 else
  begin
   case(dcs_curst)
    START : begin
   	     dcs_code       <= 7'b011_1111;
             duty_gt_50_cnt <= 5'b0_0000;
   	     chopen_intr    <= 1'b0;
             dcs_comp       <= 2'b00;
   	     dcs_lock_cnt   <= 5'b0_0000;
   	     dcs_lock_int   <= 1'b0;
	    end
    RUN   : begin
	     if(duty_gt_50_cnt == 5'b1_0000)
	      begin
	       duty_gt_50_cnt <= 5'b0_0000;
               dcs_comp       <= 2'b00;
	      end
	     else
	      begin
	       duty_gt_50_cnt <= duty_gt_50_cnt + 1'b1;
	       if(duty_gt_50_cnt == 5'b0_0110 || duty_gt_50_cnt == 5'b0_1110)
		dcs_comp[duty_gt_50_cnt[3]] <= chopen_intr^duty_gt_50_sync;
	       else
		dcs_comp <= dcs_comp;
	       if(duty_gt_50_cnt == 5'b0_1000 || duty_gt_50_cnt == 5'b0_0000)
	        chopen_intr <= ~chopen_intr;
               else 
	        chopen_intr <= chopen_intr;

	       if(duty_gt_50_cnt == 5'b0_1111)
	        begin
	         if(dcs_comp == 2'b11)
	          begin
	           if(dcs_code == 7'd0)
	            dcs_code <= dcs_code;
	           else
	             dcs_code <= dcs_code - 1'b1;
	          end
	         else if(dcs_comp == 2'b00)
	          begin
	           if(dcs_code == 7'd123)
	            dcs_code <= dcs_code;
	           else
	             dcs_code       <= dcs_code + 1'b1;
	          end
	         else  
	          dcs_code <= dcs_code;
 		   if(dcs_lock_cnt == DCS_CNT_VAL)
    		    dcs_lock_int   <= 1'b1;
                   else
	            begin
   		     dcs_lock_cnt   <= dcs_lock_cnt + 1'b1;
   	             dcs_lock_int   <= dcs_lock_int;
	            end
	        end
	      end
	    end
  default : begin
   	     dcs_code       <= 7'b011_1111;
   	     duty_gt_50_cnt <= 7'b000_0000;
   	     chopen_intr    <= 1'b0;
             dcs_comp       <= 2'b00;
   	     dcs_lock_cnt   <= 5'b0_0000;
   	     dcs_lock_int   <= 1'b0;
	    end
   endcase
  end

 always@(*)
  begin
   dcs_nxst = 2'b00;
    case(dcs_curst)
     START   : begin
		if(dcs_en)
		 dcs_nxst = RUN;
		else
		 dcs_nxst = START;
	       end
     RUN     : begin
		if(!dcs_en)
		 dcs_nxst = START;
		else
		 dcs_nxst = RUN;
	       end
     default   : begin
		if(dcs_en)
		 dcs_nxst = RUN;
		else
		 dcs_nxst = START;
	       end
   endcase
  end

endmodule
