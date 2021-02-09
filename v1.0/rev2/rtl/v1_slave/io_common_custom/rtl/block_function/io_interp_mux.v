// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #2 $
// Date:        $DateTime: 2014/10/18 21:47:06 $
//------------------------------------------------------------------------
// Description: interpolator mux
//
//------------------------------------------------------------------------

module io_interp_mux (

input  [7:0] phy_clk_phs,   // 8 phase 1.6GHz clock
input  [7:0] slow_clk_ph_p, // 8 phase 1.6GHz clock combined with reset
input  [7:0] slow_clk_ph_n, // 8 phase 1.6GHz clock combined with reset
input  [2:0] gray_a_buf,    // Mux select A
input  [2:0] gray_a_inv,    // inverted Mux select A
input  [2:0] gray_b_buf,    // Mux select B
input  [2:0] gray_b_inv,    // inverted Mux select B
input        test_enable_n, // active low test enable
input        dft_mux_sel,   // mux selection during test
output       c_out,         // 1 of the 3 output phases, sent to the interpolator
output       mux_out_b      // 1 of the 3 output phases, sent to other logic
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  NAND_DELAY     = 17;  // 17ps
parameter  NOR_DELAY      = 22;  // 22ps
parameter  INV_DELAY      = 12;  // 10ps
parameter  MUX_DELAY      = 40;  // 35ps
parameter  BUF_DELAY      = 20;  // 16ps
parameter  FINGER_DELAY   = 55;  // 55ps

//wire  [7:0] slow_clk_ph;	//move to io_interpolator
reg   [7:0] dc_a,dc_b;
wire  [7:0] amx;
wire  [7:0] ap;
reg   [7:0] en,ep;
wire  [7:0] xn,sn,xp,sp;
wire        c_out_n;
wire        c_out_int_n;
wire        c_out_p;
wire        c_out_int_p;
wire 	    c_out_n_mux;

//-----------------------------------------------------------------------------------------------------------------------------
//   This circuit is used to mux out 2 of the clock phases and not glitch during the transition to the next clock phase.
//   The circuit must stretch the output and not glitch the output.
//-----------------------------------------------------------------------------------------------------------------------------
//                      ___________________                     ___________________                     ___________________
//  clk_ph[0]  ________/                   \___________________/                   \___________________/                   \___
//                           ___________________                     ___________________                     __________________
//  clk_ph[1]  _____________/                   \___________________/                   \___________________/                 
//                                ___________________                     ___________________                     _____________
//  clk_ph[2]  __________________/                   \___________________/                   \___________________/            
//             ___                     ___________________                     ___________________                     ________
//  clk_ph[3]     \___________________/                   \___________________/                   \___________________/       
//             ________                     ___________________                     ___________________                     ___
//  clk_ph[4]          \___________________/                   \___________________/                   \___________________/  
//             __________                               _____________________________                               ___________
//  clk_out              \_____________________________/                             \_____________________________/           
//             ______________________________
//  en[0]                                    \_________________________________________________________________________________
//                         ____________________________________________________________________________________________________
//  ep[0]      ___________/
//                         _____________________________
//  en[2]      ___________/                             \______________________________________________________________________
//             ___________________                                        _____________________________________________________
//  ep[2]                  *******\______________________________________/
//                                                               _______________________________________ 
//  en[4]      __________________________________________*******/                                       \______________________
//             _________________________________________                               ________________________________________
//  ep[4]                                               \_____________________________/
//
//-----------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
//  clk_ph buffers
//--------------------------------------------------------------------------------------------------

//assign #(2 * INV_DELAY) slow_clk_ph[7:0] = phy_clk_phs[7:0];	//move to io_interpolator

//--------------------------------------------------------------------------------------------------
//  Decoder of the gray_sel input
//--------------------------------------------------------------------------------------------------

always @(*)
  case (gray_a_buf[2:0])
    3'b000 : dc_a[7:0] = 8'b0000_0001;
    3'b001 : dc_a[7:0] = 8'b0000_0010;
    3'b011 : dc_a[7:0] = 8'b0000_0100;
    3'b010 : dc_a[7:0] = 8'b0000_1000;
    3'b110 : dc_a[7:0] = 8'b0001_0000;
    3'b111 : dc_a[7:0] = 8'b0010_0000;
    3'b101 : dc_a[7:0] = 8'b0100_0000;
    3'b100 : dc_a[7:0] = 8'b1000_0000;
  endcase

always @(*)
  case (gray_b_buf[2:0])
    3'b000 : dc_b[7:0] = 8'b0000_0001;
    3'b001 : dc_b[7:0] = 8'b0000_0010;
    3'b011 : dc_b[7:0] = 8'b0000_0100;
    3'b010 : dc_b[7:0] = 8'b0000_1000;
    3'b110 : dc_b[7:0] = 8'b0001_0000;
    3'b111 : dc_b[7:0] = 8'b0010_0000;
    3'b101 : dc_b[7:0] = 8'b0100_0000;
    3'b100 : dc_b[7:0] = 8'b1000_0000;
  endcase

assign #MUX_DELAY amx[7:0] = c_out_int_p ? dc_b[7:0] : dc_a[7:0];

assign #INV_DELAY ap[7:0] = ~amx[7:0];
//assign #BUF_DELAY an[7:0] =  amx[7:0];

//--------------------------------------------------------------------------------------------------
//  Finger enable for out[0]
//--------------------------------------------------------------------------------------------------

assign #NAND_DELAY xn[7:0] = ~({8{c_out_int_n}} & slow_clk_ph_n[7:0]);
assign #NAND_DELAY sn[7:0] = ~(amx[7:0] & xn[7:0]) ;

always @(*)
  if      ( ~sn[0] )            en[0] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[0] ) en[0] <= #NAND_DELAY 1'b0;
  else if ( ~ap[7] )            en[0] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[1] )            en[1] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[1] ) en[1] <= #NAND_DELAY 1'b0;
  else if ( ~ap[0] )            en[1] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[2] )            en[2] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[2] ) en[2] <= #NAND_DELAY 1'b0;
  else if ( ~ap[1] )            en[2] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[3] )            en[3] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[3] ) en[3] <= #NAND_DELAY 1'b0;
  else if ( ~ap[2] )            en[3] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[4] )            en[4] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[4] ) en[4] <= #NAND_DELAY 1'b0;
  else if ( ~ap[3] )            en[4] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[5] )            en[5] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[5] ) en[5] <= #NAND_DELAY 1'b0;
  else if ( ~ap[4] )            en[5] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[6] )            en[6] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[6] ) en[6] <= #NAND_DELAY 1'b0;
  else if ( ~ap[5] )            en[6] <= #NAND_DELAY 1'b0;

always @(*)
  if      ( ~sn[7] )            en[7] <= #NAND_DELAY 1'b1;
  else if ( ~slow_clk_ph_n[7] ) en[7] <= #NAND_DELAY 1'b0;
  else if ( ~ap[6] )            en[7] <= #NAND_DELAY 1'b0;

assign #NOR_DELAY  xp[7:0] = ~({8{c_out_int_n}} | slow_clk_ph_p[7:0]);
assign #NOR_DELAY  sp[7:0] = ~(ap[7:0] | xp[7:0]) ;

always @(*)
  if      ( sp[0] )            ep[0] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[0] ) ep[0] <= #NAND_DELAY 1'b1;
  else if ( amx[7] )           ep[0] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[1] )            ep[1] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[1] ) ep[1] <= #NAND_DELAY 1'b1;
  else if ( amx[0] )           ep[1] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[2] )            ep[2] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[2] ) ep[2] <= #NAND_DELAY 1'b1;
  else if ( amx[1] )           ep[2] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[3] )            ep[3] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[3] ) ep[3] <= #NAND_DELAY 1'b1;
  else if ( amx[2] )           ep[3] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[4] )            ep[4] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[4] ) ep[4] <= #NAND_DELAY 1'b1;
  else if ( amx[3] )           ep[4] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[5] )            ep[5] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[5] ) ep[5] <= #NAND_DELAY 1'b1;
  else if ( amx[4] )           ep[5] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[6] )            ep[6] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[6] ) ep[6] <= #NAND_DELAY 1'b1;
  else if ( amx[5] )           ep[6] <= #NAND_DELAY 1'b1;

always @(*)
  if      ( sp[7] )            ep[7] <= #NAND_DELAY 1'b0;
  else if ( slow_clk_ph_p[7] ) ep[7] <= #NAND_DELAY 1'b1;
  else if ( amx[6] )           ep[7] <= #NAND_DELAY 1'b1;

//--------------------------------------------------------------------------------------------------
//  Finger Mux for out[0]
//--------------------------------------------------------------------------------------------------

assign c_out_n_mux = ({ep[0],phy_clk_phs[0]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[1],phy_clk_phs[1]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[2],phy_clk_phs[2]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[3],phy_clk_phs[3]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[4],phy_clk_phs[4]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[5],phy_clk_phs[5]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[6],phy_clk_phs[6]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({ep[7],phy_clk_phs[7]}==2'b00)? 1'b1 : 1'bz;
assign c_out_n_mux = ({en[0],phy_clk_phs[0]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[1],phy_clk_phs[1]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[2],phy_clk_phs[2]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[3],phy_clk_phs[3]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[4],phy_clk_phs[4]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[5],phy_clk_phs[5]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[6],phy_clk_phs[6]}==2'b11)? 1'b0 : 1'bz;
assign c_out_n_mux = ({en[7],phy_clk_phs[7]}==2'b11)? 1'b0 : 1'bz;

assign #FINGER_DELAY c_out_n = c_out_n_mux;

assign #INV_DELAY c_out = ~c_out_n;
assign #INV_DELAY mux_out_b = ~c_out_n;
assign #INV_DELAY c_out_p = ~c_out_n;
assign #INV_DELAY c_out_int_n = ~c_out_p;

assign #(2 * NAND_DELAY) c_out_int_p  = ~(dft_mux_sel & ~(test_enable_n & c_out_p));

endmodule

