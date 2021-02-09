// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #3 $
// Date:        $DateTime: 2015/05/27 18:53:02 $
//------------------------------------------------------------------------
// Description: 16 phase interpolator gray code decode
//
//------------------------------------------------------------------------

module io_cmos_16ph_decode (
input             enable,           // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
input             test_enable_buf,  // Active high test enable
input             test_enable_n,    // Active low test enable
input             dft_mux_sel_p,    // mux selection during test
input             dft_mux_sel_n,    // complimentary mux selection during test
input             clk_p_0,          // clock for sync gray code - 1st latch
input             clk_n_0,          // clock for sync gray code - 1st latch
input             clk_p_2,          // clock for sync gray code - 2nd latch
input             clk_n_2,          // clock for sync gray code - 2nd latch
input       [3:0] gray_sel_a,       // The gray code output to control the interpolator (even)
input       [3:0] gray_sel_b,       // The gray code output to control the interpolator (odd )
input       [1:0] filter_code,      // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
output      [7:0] sp,          	 // thermal code for 8 phase interpolator
output      [7:0] sn,          	 // complimentary thermal code for 8 phase interpolator
output      [6:0] selp,          // code for 2 phase interpolator (including decode for test)
output      [6:0] seln,          // complimentary code for 2 phase interpolator (including decode for test)
output      [3:1] scp,              // filter capacitance selection
output reg  [3:1] scn               // complimentary filter capacitance selection
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  MUX_DELAY      = 50;  // 50ps

reg  [3:0] gray_sel_ax;
reg  [3:0] gray_sel_bx;
reg  [3:0] out_gray_az;
reg  [3:0] out_gray_bz;
reg  [7:0] sp_a;
reg  [7:0] sp_b;
wire [7:0] sn_a;
wire [7:0] sn_b;
reg  [6:0] seln_a;
reg  [6:0] seln_b;
wire [6:0] selp_a;
wire [6:0] selp_b;
wire	   clk_p_0_buf;
wire	   clk_n_0_buf;
wire	   clk_p_2_buf;
wire	   clk_n_2_buf;

assign #BUF_DELAY clk_p_0_buf = clk_p_0;
assign #BUF_DELAY clk_n_0_buf = clk_n_0;
assign #BUF_DELAY clk_p_2_buf = clk_p_2;
assign #BUF_DELAY clk_n_2_buf = clk_n_2;

//filter code decode
always @(*)
  case (filter_code[1:0])
    2'b00 :  scn[3:1] = 3'b000;
    2'b01 :  scn[3:1] = 3'b001;
    2'b10 :  scn[3:1] = 3'b011;
    2'b11 :  scn[3:1] = 3'b111;
  endcase
assign #INV_DELAY scp[3:1] = ~scn[3:1];

//gray code sync
always @(*)
  if (~enable)          gray_sel_ax[3:0] <= #LATCH_DELAY 4'h0;
  else if (clk_p_0_buf) gray_sel_ax[3:0] <= #LATCH_DELAY gray_sel_a[3:0];

always @(*)
  if (~enable)          gray_sel_bx[3:0] <= #LATCH_DELAY 4'h0;
  else if (clk_n_0_buf) gray_sel_bx[3:0] <= #LATCH_DELAY gray_sel_b[3:0];

always @(*)
  if (~enable)          out_gray_az[3:0] <= #LATCH_DELAY 4'h0;
  else if (clk_p_2_buf) out_gray_az[3:0] <= #LATCH_DELAY gray_sel_ax[3:0];

always @(*)
  if (~enable)          out_gray_bz[3:0] <= #LATCH_DELAY 4'h0;
  else if (clk_n_2_buf) out_gray_bz[3:0] <= #LATCH_DELAY gray_sel_bx[3:0];

//gray code decode
always @(*)
  case (out_gray_az[3:0])
    4'b0000 :  sp_a[7:0] = 8'b0000_0000;
    4'b0001 :  sp_a[7:0] = 8'b0000_0001;
    4'b0011 :  sp_a[7:0] = 8'b0000_0011;
    4'b0010 :  sp_a[7:0] = 8'b0000_0111;
    4'b0110 :  sp_a[7:0] = 8'b0000_1111;
    4'b0111 :  sp_a[7:0] = 8'b0001_1111;
    4'b0101 :  sp_a[7:0] = 8'b0011_1111;
    4'b0100 :  sp_a[7:0] = 8'b0111_1111;
    4'b1100 :  sp_a[7:0] = 8'b1111_1111;
    4'b1101 :  sp_a[7:0] = 8'b0111_1111;
    4'b1111 :  sp_a[7:0] = 8'b0011_1111;
    4'b1110 :  sp_a[7:0] = 8'b0001_1111;
    4'b1010 :  sp_a[7:0] = 8'b0000_1111;
    4'b1011 :  sp_a[7:0] = 8'b0000_0111;
    4'b1001 :  sp_a[7:0] = 8'b0000_0011;
    4'b1000 :  sp_a[7:0] = 8'b0000_0001;
  endcase

always @(*)
  case (out_gray_bz[3:0])
    4'b0000 :  sp_b[7:0] = 8'b0000_0000;
    4'b0001 :  sp_b[7:0] = 8'b0000_0001;
    4'b0011 :  sp_b[7:0] = 8'b0000_0011;
    4'b0010 :  sp_b[7:0] = 8'b0000_0111;
    4'b0110 :  sp_b[7:0] = 8'b0000_1111;
    4'b0111 :  sp_b[7:0] = 8'b0001_1111;
    4'b0101 :  sp_b[7:0] = 8'b0011_1111;
    4'b0100 :  sp_b[7:0] = 8'b0111_1111;
    4'b1100 :  sp_b[7:0] = 8'b1111_1111;
    4'b1101 :  sp_b[7:0] = 8'b0111_1111;
    4'b1111 :  sp_b[7:0] = 8'b0011_1111;
    4'b1110 :  sp_b[7:0] = 8'b0001_1111;
    4'b1010 :  sp_b[7:0] = 8'b0000_1111;
    4'b1011 :  sp_b[7:0] = 8'b0000_0111;
    4'b1001 :  sp_b[7:0] = 8'b0000_0011;
    4'b1000 :  sp_b[7:0] = 8'b0000_0001;
  endcase

//assign sp_a[7] = out_gray_az[3];
//assign sp_b[7] = out_gray_bz[3];
assign sn_a[7:0] = ~sp_a[7:0];
assign sn_b[7:0] = ~sp_b[7:0];

//gray code decode for 2 phase interpolator including special decoding during test
//for int_a			clk_in_a	clk_in_c	clk_in_b
//greay3	gray2	test	s0_n	s1_n	s2_n	s3_n	s4_n	s4_n
//	0	*	0	1	1	0	0	1	1		interpolate clk_in_a and clk_in_b	
//	1	*	0	0	1	0	1	1	1		clk_in_b
//	0	0	1	1	1	0	0	0	0		clk_in_a
//	1	1	1	0	0	0	0	1	1		clk_in_b
//	0	1	1	0	0	0	0	1	1		clk_in_b
//	1	0	1	0	0	1	1	0	0		clk_in_c
//for int_c			clk_in_a	clk_in_c	clk_in_b
//greay3	gray2	test	s0_n	s5_n	s6_n	s3_n	s4_n	s4_n		(s5_n connects to s1_n of xip2c; s6_n connects to s2_n of xip2c)
//	0	*	0	1	0	1	0	1	1		clk_in_b
//	1	*	0	0	0	1	1	1	1		interpolate clk_in_b and clk_in_c
//	0	0	1	1	1	0	0	0	0		clk_in_a
//	1	1	1	0	0	0	0	1	1		clk_in_b
//	0	1	1	0	0	0	0	1	1		clk_in_b
//	1	0	1	0	0	1	1	0	0		clk_in_c

always @(*)
  casez ({out_gray_az[3:2],test_enable_buf})
    3'b0?0 :  seln_a[6:0] = 7'b101_0011;	//int_a=(clk_in_a+clk_in_b)/2; int_c=clk_in_b;
    3'b1?0 :  seln_a[6:0] = 7'b101_1010;	//int_c=clk_in_b; int_a=(clk_in_b+clk_in_c)/2;
    3'b001 :  seln_a[6:0] = 7'b000_0011;	//int_a=int_c=clk_in_a;
    3'b111 :  seln_a[6:0] = 7'b001_0000;	//int_a=int_c=clk_in_b;
    3'b011 :  seln_a[6:0] = 7'b001_0000;	//int_a=int_c=clk_in_b;
    3'b101 :  seln_a[6:0] = 7'b100_1000;	//int_a=int_c=clk_in_c;
  endcase

always @(*)
  casez ({out_gray_bz[3:2],test_enable_buf})
    3'b0?0 :  seln_b[6:0] = 7'b101_0011;	//int_a=(clk_in_a+clk_in_b)/2; int_c=clk_in_b;
    3'b1?0 :  seln_b[6:0] = 7'b101_1010;	//int_a=clk_in_b; int_c=(clk_in_b+clk_in_c)/2;
    3'b001 :  seln_b[6:0] = 7'b000_0011;	//int_a=int_c=clk_in_a;
    3'b111 :  seln_b[6:0] = 7'b001_0000;	//int_a=int_c=clk_in_b;
    3'b011 :  seln_b[6:0] = 7'b001_0000;	//int_a=int_c=clk_in_b;
    3'b101 :  seln_b[6:0] = 7'b100_1000;	//int_a=int_c=clk_in_c;
  endcase

assign selp_a[6:0] = ~seln_a[6:0];
assign selp_b[6:0] = ~seln_b[6:0];

//gray code mux
//assign #MUX_DELAY sp[7:0] = ({8{clk_n_2}} & {out_gray_az[3],sp_a[6:0]}) | ({8{clk_p_2}} & {out_gray_bz[3],sp_b[6:0]});
//assign #INV_DELAY sn[7:0] = ~sp[7:0];
assign clk_p_2_buf2 = ~(dft_mux_sel_p & ~(clk_p_2 & test_enable_n ));
assign clk_n_2_buf2 = ~(dft_mux_sel_n & ~(clk_n_2 & test_enable_n ));
assign #MUX_DELAY sp[7:0] 	= clk_p_2_buf2? sp_b[7:0]   : sp_a[7:0];
assign #MUX_DELAY sn[7:0] 	= clk_n_2_buf2? sn_a[7:0]   : sn_b[7:0];
assign #MUX_DELAY selp[6:0] 	= clk_p_2_buf2? selp_b[6:0] : selp_a[6:0];
assign #MUX_DELAY seln[6:0] 	= clk_n_2_buf2? seln_a[6:0] : seln_b[6:0];

//=========================================================================================================================================================================
// Waveforms
//=========================================================================================================================================================================
//
//                 ___________________                          ___________________                     ________________________:                    ___________________
//  clk_p_0    ___/                   \________________________/                   \___________________/                        \___________________/                   \__
//                      ___________________                          ___________________                     ________________________                     _________________
//  clk_p_1    ________/                   \________________________/                   \___________________/                        \___________________/
//                           ___________________                          ___________________                     ________________________                     ____________
//  clk_p_2   _____________/                   \________________________/                   \___________________/                        \___________________/  
//
//                     ________               ______________________________               _________________________               ______________________________            
//  out_gray_az[3:0]   ________XXXXXXXXXXXXXXX_____________________2________XXXXXXXXXXXXXXX________________C________XXXXXXXXXXXXXXX_____________________6________XXXXXXXXXXXX
//                     ____________________________               ______________________________               ______________________________               _________________
//  out_gray_bz[3:0]   ___________________D________XXXXXXXXXXXXXXX_____________________7________XXXXXXXXXXXXXXX_____________________1________XXXXXXXXXXXXXXX_______________B_
//                 __________ ___________________ ________________________ ___________________ ___________________ ________________________ ___________________ _____________
//  sn[7:0]        __________X_________D_________X_____________2__________X__________7________X__________C________X_____________1__________X__________6________X__________B__
//
//===========================================================================================================================================================================

endmodule


