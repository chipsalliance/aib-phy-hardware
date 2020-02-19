// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        aibcr3pnr_dll_core.v
// Revision:    Revision: #1 
// Date:        2016/07/04
//------------------------------------------------------------------------
// Description: dll core logic
// 1. added in new csr bits : rb_clkdiv[1:0],rb_selflock,rb_half_code,rb_dly_pst
// 2. changed dll_lock port to lock (to cater for self-timed lock signal
// 3. instanciated aibcrpnr_self_lock_assertion and aibcrpnr_half_cycle_code_gen
// 4. added output port pvt_ref_half_gry[9:0]
// 5. added synchronizers for t_up and t_down
// 6. separated coarse and fine delay codes in gray-code generation
// 7. move synchronizers to aibcrpnr_dll_pnr level
// 8. bring out [6:0] gate_shf
// 9. added synchronizers for core_up and core_dn
// 10. added prelock to partition >1 step jump and <=1 step jump
// 11. increase bus width of rb_clkdiv to 3 bit
// 12. removed up[4:1] and down[4:1] from tcalc_up and tcalc_down calculations
// 13. added scan_mode_n for self_lock_assertion scan chain
// 14. removed pvt_ref_half_gray_pst by directly reset pvt_ref_half_gry bits to 0
//------------------------------------------------------------------------
// To be changed :
//------------------------------------------------------------------------
`timescale 1ps/1ps

module aibcr3pnr_dll_core
#(
//-----------------------------------------------------------------------------------------------------------------------
//  Configuration parameters
//-----------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
//  Local calculated parameters
//-----------------------------------------------------------------------------------------------------------------------
parameter FF_DELAY     = 200
)
(
   input  wire         clk,
   input  wire         reset_n,
   input  wire         rb_ctlsel,               // static setting selection
   input  wire [10:0]  rb_ctl_static,           // dll static setting from csr; change - from [9:0] to [10:0]
   input  wire         rb_core_updnen,          // core updown control enable
   input  wire [10:0]  rb_dly_pst,              // counter preset value;  change - from [9:0] to [10:0]
   output wire         up_core,                 // updown signal to core 
   output wire         dn_core,                 // updown signal to core 
   input  wire         core_up,                 // up signal from core
   input  wire         core_dn,                 // down signal from core
   input  wire         t_up,                    // output of phase detector
   input  wire         t_down,                  // output of phase detector
   input  wire   [2:0] rb_clkdiv,               //select division factor for clock
   input  wire         rb_selflock,             //select between lock signal from self-timed logics or FSM lock monitor
   input  wire         rb_half_code,            //select between original or half-cycle codes
   input  wire         scan_mode_n,
   output wire         launch,                  // Decode from gate_shf, Used as the input to the delay line
   output wire         measure,                 // Decode from gate_shf, Used as the clock for the phase detector
   output wire [7:0]   f_gray,                  // gray code for nand delay chain;  change - from [6:0] to [7:0]
   output wire [2:0]   i_gray,                  // gray code for phase interpolator
   output wire         lock,                // "1" when lock found. Output lock to core
   output wire [10:0]  pvt_ref_binary,          // output binary pvt value for delay chain; change - from [9:0] to [10:0]
   output reg  [10:0]  internal_pvt_binary,     // registered binary pvt value for dll internal delay chain; change - from [9:0] to [10:0]
   output reg          search_overflow,
   output reg  [3:0]   gate_state,              // State Machine used to implement the fast binary search
   output reg  [6:0]   gate_shf,               // Used with gate_cnt to process the UP/DOWN sampling
   output reg  [10:0]   pvt_ref_gry,             // output gray code for dll delay setting;  change - from [9:0] to [10:0] 
   output reg  [10:0]   pvt_ref_half_gry         // divided-by-4 output gray code for dll delay setting;  change - from [9:0] to [10:0] 
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

//-----------------------------------------------------------------------------------------------------------------------
//  reg and wire
//-----------------------------------------------------------------------------------------------------------------------

wire           core_up_sync;
wire           core_dn_sync;
wire     [10:0] int_pvt_value;      // binary pvt value for delay chain;  change - from [9:0] to [10:0] 
reg      [13:0] pvt_value;          // binary pvt value for delay chain;  change - from [12:0] to [13:0] 
wire     [10:0] pvt_ref_gray;       // output gray pvt value for delay chain nand;  change - from [9:0] to [10:0] 
wire     [10:0] pvt_ref_half_gray;  // divided-by-2 output gray pvt value for delay chain nand;  change - from [9:0] to [10:0] 
wire     [10:0] pvt_ref_half_binary;//divided-by-2 output binary pvt value for delay chain nand;  change - from [9:0] to [10:0] 
reg      [3:0] gate_cnt;           // Counter used to time the UP/DOWN sampling
//reg      [6:0] gate_shf;           // Used with gate_cnt to process the UP/DOWN sampling
wire           core_capture;       // Decode from gate_shf, Used to time when to capture core_up and core_dn
wire           up_down_capture;    // Decode from gate_shf, Used to time when to use the t_up,t_down outputs of the phase detector
wire           tog_state;          // Decode from gate_shf, Used to time when to change the value of the state machine 
wire           pgm_write;          // Decode from gate_shf, Used to time when to change the value of the delay chain, ???
wire           load_en;            // Decode from gate_shf, Used to time when to change the value of the delay chain, ???
wire           filter_load;        // Decode from gate_shf, Used to time when to update the UP/DOWN counter, {pvt_value[12:0],o_filter[7:0]}
wire     [4:0] state_adder;        // The offset from the internal_value used for the fast binary search
wire    [14:0] search_value;       // The internal_value + offset used to set the delay of the delay line;  change - from [13:0] to [14:0] 
wire           phase_clk;
reg      [4:0] up, down;
reg            core_up_reg;
reg            core_dn_reg;
wire           t_up_in;
wire           t_down_in;
wire           new_t_up;
wire           new_t_down;
wire           any_up;
wire           any_down;
wire           large_up;
wire           large_down;
reg            mem_up, mem_down;
reg      [5:0] accel_up;
reg      [5:0] accel_down;
reg      [3:0] lock_cnt;
wire           dll_lock_det;
wire    [16:0] tcalc_up;           // change - from [15:0] to [16:0] 
wire    [16:0] tcalc_down;         // change - from [15:0] to [16:0] 
reg     [13:0] internal_value;     // The internal UP/DOWN value,  the unfiltered version of pvt_value[12:0]; change - from [12:0] to [13:0] 
reg      [1:0] i_filter;           // The tiny filter 2-bits used with internal_value[13:0]
reg      [7:0] o_filter;           // The larger filter 8-bits use with pvt_value[13:0]
wire           dll_lock;           // lock signal from FSM (lock monitor)
wire    [10:0]  pvt_ref_bin;        // pre-divided-by-2 delay setting ;  change - from [9:0] to [10:0] 
wire    [10:0]  pvt_ref_half_binary_pst; //divided-by-2 preset binary setting;  change - from [9:0] to [10:0]  
wire    [10:0]  pvt_ref_half_gray_pst; // divided-by-2 preset gray setting;  change - from [9:0] to [10:0] 
wire          prelock;
//-----------------------------------------------------------------------------------------------------------------------
//  Divide the clock by 16
//                      ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
//  gate_cnt           |__1_|__2_|__3_|__4_|__5_|__6_|__7_|__8_|__9_|_10_|_11_|
//                      _________                                                                       _________
//  gate_shf[0]  ______/         \_____________________________________________________________________/         \_______
//                           _________                                                                       _________   
//  gate_shf[1]  ___________/         \_____________________________________________________________________/         \__
//                                _________                                                                       _______
//  gate_shf[2]  ________________/         \_____________________________________________________________________/      
//                                     _________                                                                       __
//  gate_shf[3]  _____________________/         \_____________________________________________________________________/  
//                                          _________                                                                    
//  gate_shf[4]  __________________________/         \___________________________________________________________________
//                                               _________                                                                    
//  gate_shf[5]  _______________________________/         \______________________________________________________________
//                                                    _________                                                                
//  gate_shf[6]  ____________________________________/         \_________________________________________________________
//                      _________                                                                       _________
//  launch       ______/         \_____________________________________________________________________/         \_______
//                           _________                                                                       _________
//  measure      ___________/         \_____________________________________________________________________/         \__
//                                     ____                                                                            __
//  core_capture _____________________/    \__________________________________________________________________________/  
//                                          ____                                  
//  up_down_capture _______________________/    \________________________________________________________________________
//                                               ____                                                                             
//  up--down     _______________________________/    \___________________________________________________________________
//                 __________________________________ ___________________________________________________________________
//  internal_value ______________15223_______________X__________________15224____________________________________________
//                                               ____                                                                   
//  tog_state    _______________________________/    \___________________________________________________________________
//               ____________________________________ ___________________________________________________________________
//  gate_state   _________________State 1____________X________________State 2____________________________________________
//                                                    ____                                                           
//  pgm_write    ____________________________________/    \______________________________________________________________
//                                                         ____                                                       
//  load_en      _________________________________________/    \_________________________________________________________
//                                                         ____                                                    
//  filter_load  _________________________________________/    \_________________________________________________________
//
//-----------------------------------------------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n)
  if (~reset_n) gate_cnt[3:0] <= #FF_DELAY 4'b0000;
  else          gate_cnt[3:0] <= #FF_DELAY gate_cnt[3:0] + 1'b1;

always @(posedge clk or negedge reset_n)
  if (~reset_n) gate_shf[6:0] <= 7'b000_0000;
  else          gate_shf[6:0] <= {gate_shf[5:0],(gate_cnt[3:1] == 3'b000)};

assign  launch          = gate_shf[0];
assign  measure         = gate_shf[1];
assign  core_capture    = (gate_shf[3:2] == 2'b11);
assign  up_down_capture = (gate_shf[5:4] == 2'b01);
assign  tog_state       = (gate_shf[5:4] == 2'b11);
assign  pgm_write       = (gate_shf[5:4] == 2'b10);
assign  load_en         = (gate_shf[6:5] == 2'b10);
assign  filter_load     = (gate_shf[6:5] == 2'b10);

//core_up and core_dn synchronization
//hd_dpcmn_bitsync2 ucoreup  ( .rst_n(reset_n), .clk(clk), .data_in(core_up),  .data_out(core_up_sync) );
//hd_dpcmn_bitsync2 ucoredn  ( .rst_n(reset_n), .clk(clk), .data_in(core_dn),  .data_out(core_dn_sync) );
c3lib_sync2_ulvt_bitsync ucoreup  ( .rst_n(reset_n), .clk(clk), .data_in(core_up),  .data_out(core_up_sync) );
c3lib_sync2_ulvt_bitsync ucoredn  ( .rst_n(reset_n), .clk(clk), .data_in(core_dn),  .data_out(core_dn_sync) );

always @(posedge clk or negedge reset_n)
  if (~reset_n)             core_up_reg <= #FF_DELAY 1'b0;
  else if (core_capture)    core_up_reg <= #FF_DELAY core_up_sync;
  else                      core_up_reg <= #FF_DELAY core_up_reg;

always @(posedge clk or negedge reset_n)
  if (~reset_n)             core_dn_reg <= #FF_DELAY 1'b0;
  else if (core_capture)    core_dn_reg <= #FF_DELAY core_dn_sync;
  else                      core_dn_reg <= #FF_DELAY core_dn_reg;

assign  up_core         = t_up;
assign  dn_core         = t_down;
assign  t_up_in         = rb_core_updnen? core_up_reg: t_up;
assign  t_down_in       = rb_core_updnen? core_dn_reg: t_down;
assign  new_t_up        = ~t_down_in & t_up_in;
assign  new_t_down      = ~t_up_in & t_down_in;


//sync core_up and core_dn and combine with t_up and t_down using rb_core_updnen
//end will update

//-----------------------------------------------------------------------------------------------------------------------
//  16 state machine used for a binary search
//-----------------------------------------------------------------------------------------------------------------------

parameter  UP_STATE_0  = 4'b0_000;
parameter  UP_STATE_1  = 4'b0_100;
parameter  UP_STATE_2  = 4'b0_101;
parameter  UP_STATE_3  = 4'b0_110;
parameter  UP_STATE_4  = 4'b0_111;
parameter  DN_STATE_0  = 4'b1_000;
parameter  DN_STATE_1  = 4'b1_100;
parameter  DN_STATE_2  = 4'b1_101;
parameter  DN_STATE_3  = 4'b1_110;
parameter  DN_STATE_4  = 4'b1_111;

reg [4:0] gate_counter;

always @(posedge clk or negedge reset_n)
  if (~reset_n)                       gate_counter[4:0] <= #FF_DELAY 5'h0;
  else if (~tog_state)                gate_counter[4:0] <= #FF_DELAY gate_counter[4:0];
  else casez ({gate_state[3],mem_down,mem_up})
         3'b000 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0];
         3'b001 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0] + 1'b1;
         3'b010 : gate_counter[4:0] <= #FF_DELAY 5'h00;
         3'b011 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0];
         3'b100 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0];
         3'b101 : gate_counter[4:0] <= #FF_DELAY 5'h00;
         3'b110 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0] + 1'b1;
         3'b111 : gate_counter[4:0] <= #FF_DELAY gate_counter[4:0];
       endcase

always @(posedge clk or negedge reset_n)
  if (~reset_n)            gate_state <= #FF_DELAY UP_STATE_0;
  else if (~tog_state)     gate_state <= #FF_DELAY gate_state;
  else if (rb_core_updnen) gate_state <= #FF_DELAY mem_up        ? UP_STATE_1 :
                                                   mem_down      ? DN_STATE_1 :                                                   
                                                   gate_state[3] ? DN_STATE_0 :
                                                                   UP_STATE_0 ;
  else if ( (internal_value[13:5] == 9'h000) &  gate_state[3] ) gate_state <= #FF_DELAY UP_STATE_0;  //  change - from [12:5] to [13:5] 
  else if ( (internal_value[13:5] == 9'h1FF) & ~gate_state[3] ) gate_state <= #FF_DELAY DN_STATE_0;  //  change - from [12:5] to [13:5] 
  else if (~prelock) case (gate_state)
   UP_STATE_0   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[4:0] == 5'h1F)) ? UP_STATE_1  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_0  :
                                                                                      DN_STATE_0  ;
   UP_STATE_1   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[3:0] == 4'hF))  ? UP_STATE_2  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_1  :
                                                                                      UP_STATE_0  ;
   UP_STATE_2   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[2:0] == 3'h7))  ? UP_STATE_3  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_2  :
                                                                                      UP_STATE_1  ;
   UP_STATE_3   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[1:0] == 2'h3))  ? UP_STATE_4  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_3  :
                                                                                      UP_STATE_2  ;
   UP_STATE_4   : gate_state <= #FF_DELAY (mem_up   & ~mem_down)                    ? UP_STATE_4  :
                                                                                      UP_STATE_3  ;
   DN_STATE_0   : gate_state <= #FF_DELAY (mem_down & (gate_counter[4:0] == 5'h1F)) ? DN_STATE_1  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_0  :
                                                                                      UP_STATE_0  ;
   DN_STATE_1   : gate_state <= #FF_DELAY (mem_down & (gate_counter[3:0] == 4'hF))  ? DN_STATE_2  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_1  :
                                                                                      DN_STATE_0  ;
   DN_STATE_2   : gate_state <= #FF_DELAY (mem_down & (gate_counter[2:0] == 3'h7))  ? DN_STATE_3  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_2  :
                                                                                      DN_STATE_1  ;
   DN_STATE_3   : gate_state <= #FF_DELAY (mem_down & (gate_counter[1:0] == 2'h3))  ? DN_STATE_4  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_3  :
                                                                                      DN_STATE_2  ;
   DN_STATE_4   : gate_state <= #FF_DELAY (mem_down & ~mem_up)                      ? DN_STATE_4  :
                                                                                      DN_STATE_3  ;
   default      : gate_state <= #FF_DELAY UP_STATE_0;
  endcase  
  else case (gate_state)
   UP_STATE_0   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[4:0] == 5'h1F)) ? UP_STATE_0  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_0  :
                                                                                      DN_STATE_0  ;
   UP_STATE_1   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[3:0] == 4'hF))  ? UP_STATE_0  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_0  :
                                                                                      UP_STATE_0  ;
   UP_STATE_2   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[2:0] == 3'h7))  ? UP_STATE_3  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_2  :
                                                                                      UP_STATE_1  ;
   UP_STATE_3   : gate_state <= #FF_DELAY (mem_up   & (gate_counter[1:0] == 2'h3))  ? UP_STATE_4  :
                                          (mem_up   & ~mem_down)                    ? UP_STATE_3  :
                                                                                      UP_STATE_2  ;
   UP_STATE_4   : gate_state <= #FF_DELAY (mem_up   & ~mem_down)                    ? UP_STATE_4  :
                                                                                      UP_STATE_3  ;
   DN_STATE_0   : gate_state <= #FF_DELAY (mem_down & (gate_counter[4:0] == 5'h1F)) ? DN_STATE_0  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_0  :
                                                                                      UP_STATE_0  ;
   DN_STATE_1   : gate_state <= #FF_DELAY (mem_down & (gate_counter[3:0] == 4'hF))  ? DN_STATE_0  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_0  :
                                                                                      DN_STATE_0  ;
   DN_STATE_2   : gate_state <= #FF_DELAY (mem_down & (gate_counter[2:0] == 3'h7))  ? DN_STATE_3  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_2  :
                                                                                      DN_STATE_1  ;
   DN_STATE_3   : gate_state <= #FF_DELAY (mem_down & (gate_counter[1:0] == 2'h3))  ? DN_STATE_4  :
                                          (mem_down & ~mem_up)                      ? DN_STATE_3  :
                                                                                      DN_STATE_2  ;
   DN_STATE_4   : gate_state <= #FF_DELAY (mem_down & ~mem_up)                      ? DN_STATE_4  :
                                                                                      DN_STATE_3  ;
   default      : gate_state <= #FF_DELAY UP_STATE_0;
  endcase

//-----------------------------------------------------------------------------------------------------------------------
//  coarse_delay : Delay the clk by (128 * COARSE_DELAY) + INTRINSIC_DELAY
//  stg_b        : Fine Delay - Multiply, Round, Truncate, Out Pipe (Integer overflow will never happen, clip not needed)
//-----------------------------------------------------------------------------------------------------------------------

assign state_adder[4] =  gate_state[3] & gate_state[2] ;
assign state_adder[3] = (gate_state[3:0] == UP_STATE_4) | (gate_state[3:0] == DN_STATE_1) | (gate_state[3:0] == DN_STATE_2) | (gate_state[3:0] == DN_STATE_3) | (gate_state[3:0] == DN_STATE_4);
assign state_adder[2] = (gate_state[3:0] == UP_STATE_3) | (gate_state[3:0] == DN_STATE_1) | (gate_state[3:0] == DN_STATE_2) | (gate_state[3:0] == DN_STATE_3);
assign state_adder[1] = (gate_state[3:0] == UP_STATE_2) | (gate_state[3:0] == DN_STATE_1) | (gate_state[3:0] == DN_STATE_2);
assign state_adder[0] = (gate_state[3:0] == UP_STATE_1) | (gate_state[3:0] == DN_STATE_1);

//assign search_value[14:0] = internal_value[13:0] + {{7{state_adder[4]}},state_adder[3:0],4'b0000} ;  // Check for max,min - borrow or carry out ?????
assign search_value[14:0] = prelock ? {1'b0,internal_value[13:0]} : (internal_value[13:0] + {{7{state_adder[4]}},state_adder[3:0],4'b0000});    //  change - increase the bus width by 1 bit

assign int_pvt_value[10:0] = search_value[14] ? internal_value[13:3] : search_value[13:3];                                                      // change - increase the bus width by 1 bit. ECO - ms3.0 condition changed to search_value[14], was [13] in ms1.0

always @(posedge clk or negedge reset_n)                                                                                                        // change - increase the bus width by 1 bit
  if (~reset_n)        internal_pvt_binary[10:0] <= #FF_DELAY 11'b0;            // change, was preset using rb_dly_pst[10:0];
  else if (rb_ctlsel)  internal_pvt_binary[10:0] <= #FF_DELAY rb_ctl_static[10:0];
  else if (pgm_write)  internal_pvt_binary[10:0] <= #FF_DELAY int_pvt_value[10:0];
  else                 internal_pvt_binary[10:0] <= #FF_DELAY internal_pvt_binary[10:0];

assign f_gray[7:0] = { internal_pvt_binary[10],
                       internal_pvt_binary[10] ^ internal_pvt_binary[9],
                       internal_pvt_binary[9] ^ internal_pvt_binary[8],
                       internal_pvt_binary[8] ^ internal_pvt_binary[7],
                       internal_pvt_binary[7] ^ internal_pvt_binary[6],
                       internal_pvt_binary[6] ^ internal_pvt_binary[5],
                       internal_pvt_binary[5] ^ internal_pvt_binary[4],
                       internal_pvt_binary[4] ^ internal_pvt_binary[3] };

assign i_gray[2:0] = { internal_pvt_binary[2],
                       internal_pvt_binary[2] ^ internal_pvt_binary[1],
                       internal_pvt_binary[1] ^ internal_pvt_binary[0] };

always @(posedge clk or negedge reset_n)
  if (~reset_n)       search_overflow <= #FF_DELAY 1'b0;
  else if (pgm_write) search_overflow <= #FF_DELAY search_value[14];                            // change - change from bit [13] to [14]
  else                search_overflow <= #FF_DELAY search_overflow;

always @(posedge clk or negedge reset_n)
  if (~reset_n)              {up[4:0],down[4:0]} <= #FF_DELAY 10'b00000_00000;
  else if (~up_down_capture) {up[4:0],down[4:0]} <= #FF_DELAY 10'b00000_00000;
  else if (search_overflow)  {up[4:0],down[4:0]} <= #FF_DELAY 10'b10000_00000;
  else if (rb_core_updnen)   {up[4:0],down[4:0]} <= #FF_DELAY {3'b000,new_t_up,4'b0000,new_t_down,1'b0};
  else if (~prelock) case (gate_state)
   UP_STATE_0  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   UP_STATE_1  : {up[4:0],down[4:0]} <= #FF_DELAY {3'b000,new_t_up,6'b00_0000};
   UP_STATE_2  : {up[4:0],down[4:0]} <= #FF_DELAY {2'b00,new_t_up,7'b000_0000};
   UP_STATE_3  : {up[4:0],down[4:0]} <= #FF_DELAY {1'b0,new_t_up,8'b0000_0000};
   UP_STATE_4  : {up[4:0],down[4:0]} <= #FF_DELAY {new_t_up,9'b00000_0000};
   DN_STATE_0  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_1  : {up[4:0],down[4:0]} <= #FF_DELAY {8'b0000_0000,new_t_down,1'b0};
   DN_STATE_2  : {up[4:0],down[4:0]} <= #FF_DELAY {7'b000_0000,new_t_down,2'b00};
   DN_STATE_3  : {up[4:0],down[4:0]} <= #FF_DELAY {6'b00_0000,new_t_down,3'b000};
   DN_STATE_4  : {up[4:0],down[4:0]} <= #FF_DELAY {5'b0_0000,new_t_down,4'b0000};
   default     : {up[4:0],down[4:0]} <= #FF_DELAY 10'b00000_00000;
  endcase
  else case (gate_state)
   UP_STATE_0  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   UP_STATE_1  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   UP_STATE_2  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   UP_STATE_3  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   UP_STATE_4  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_0  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_1  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_2  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_3  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   DN_STATE_4  : {up[4:0],down[4:0]} <= #FF_DELAY {4'b0000,new_t_up,4'b0000,new_t_down};
   default     : {up[4:0],down[4:0]} <= #FF_DELAY 10'b00000_00000;
  endcase

assign any_up     = |up[4:0];
assign any_down   = |down[4:0];
assign large_up   = |up[4:1];
assign large_down = |down[4:1];

always @(posedge clk or negedge reset_n)
  if (~reset_n)             {mem_up,mem_down} <= #FF_DELAY 2'b00;
  else if (search_overflow) {mem_up,mem_down} <= #FF_DELAY 2'b00;
  else if (up_down_capture) {mem_up,mem_down} <= #FF_DELAY {new_t_up,new_t_down};
  else                      {mem_up,mem_down} <= #FF_DELAY {mem_up,mem_down};

//-----------------------------------------------------------------------------------------------------------------------
//  UP/DOWN Acceleration
//-----------------------------------------------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n)
  if (~reset_n)                               accel_up[5:0] <= #FF_DELAY 6'h00;
  else if (down[0])                           accel_up[5:0] <= #FF_DELAY 6'h00;
  else if (rb_core_updnen)                    accel_up[5:0] <= #FF_DELAY 6'h00;
  else if (up[0] & (accel_up[5:3] != 3'b111)) accel_up[5:0] <= #FF_DELAY accel_up[5:0] + 1'b1;
  else                                        accel_up[5:0] <= #FF_DELAY accel_up[5:0];

always @(posedge clk or negedge reset_n)
  if (~reset_n)                                   accel_down[5:0] <= #FF_DELAY 6'h00;
  else if (up[0])                                 accel_down[5:0] <= #FF_DELAY 6'h00;
  else if (rb_core_updnen)                        accel_down[5:0] <= #FF_DELAY 6'h00;
  else if (down[0] & (accel_down[5:3] != 3'b111)) accel_down[5:0] <= #FF_DELAY accel_down[5:0] + 1'b1;
  else                                            accel_down[5:0] <= #FF_DELAY accel_down[5:0];

//-----------------------------------------------------------------------------------------------------------------------
//  Lock detect
//-----------------------------------------------------------------------------------------------------------------------

wire [13:0] difference_value;                  // change - from [12:0] to [13:0]

assign  difference_value[13:0] = internal_value[13:0] - pvt_value[13:0];                  // change - from [12:0] to [13:0]

assign dll_lock_det = filter_load & (difference_value[13:2] == 12'h000);                  // change - from [12:2] to [13:2]

always @(posedge clk or negedge reset_n)
  if (~reset_n)                               lock_cnt[3:0] <= #FF_DELAY 4'h0;
  else if (gate_state[2])                     lock_cnt[3:0] <= #FF_DELAY 4'h0;
  else if (search_overflow)                   lock_cnt[3:0] <= #FF_DELAY 4'h0;
  else if (lock_cnt[3])                       lock_cnt[3:0] <= #FF_DELAY 4'h8;
  else                                        lock_cnt[3:0] <= #FF_DELAY lock_cnt[3:0] + dll_lock_det;

assign dll_lock = lock_cnt[3];

//-----------------------------------------------------------------------------------------------------------------------
//  internal_value : UP/DOWN Counter
//-----------------------------------------------------------------------------------------------------------------------

/*
assign tcalc_up[15:0] = {internal_value[12:0],i_filter[1:0]} + {up[4:1],5'b00000,up[0]} + ({6{up[0]}} & accel_up[5:0]);
assign tcalc_down[15:0] = {internal_value[12:0],i_filter[1:0]} - {down[4:1],5'b00000,down[0]} - ({6{down[0]}} & accel_down[5:0]);
*/

/*
assign tcalc_up[15:0] = {internal_value[12:0],i_filter[1:0]} + {up[4:1],5'b00000,up[0]};
assign tcalc_down[15:0] = {internal_value[12:0],i_filter[1:0]} - {down[4:1],5'b00000,down[0]};
*/

//assign int_pvt_value[9:0] = search_value[13] ? internal_value[12:3] : search_value[12:3];
// change - increase tcalc_up/down to [16:0] from [15:0] and update the
// new bus width for internal_value
assign tcalc_up[16:0] = prelock ? ({internal_value[13:0],i_filter[1:0]} + up[0]) : ({internal_value[13:0],i_filter[1:0]} + {up[4:1],5'b00000,up[0]} + ({6{up[0]}} & accel_up[5:0]));
assign tcalc_down[16:0] = prelock ? ({internal_value[13:0],i_filter[1:0]} - down[0]): ({internal_value[13:0],i_filter[1:0]} - {down[4:1],5'b00000,down[0]} - ({6{down[0]}} & accel_down[5:0]));

always @(posedge clk or negedge reset_n)
  if (~reset_n)          {internal_value[13:0],i_filter[1:0]} <= #FF_DELAY 16'b0;       // change - was tied to {rb_dly_pst,5'h00};
  else if (any_up)       {internal_value[13:0],i_filter[1:0]} <= #FF_DELAY tcalc_up[16]   ? 16'hFFFF : tcalc_up[15:0];
  else if (any_down)     {internal_value[13:0],i_filter[1:0]} <= #FF_DELAY tcalc_down[16] ? 16'h0000 : tcalc_down[15:0];
  else                   {internal_value[13:0],i_filter[1:0]} <= #FF_DELAY {internal_value[13:0],i_filter[1:0]};

//-----------------------------------------------------------------------------------------------------------------------
//  pvt_value : Output filter + hysteresis
//-----------------------------------------------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n)
  if (~reset_n)                                                      {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY 22'b0;    // change - was {rb_dly_pst,11'h000};
  else if (rb_ctlsel)                                                {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {rb_ctl_static[10:0],11'h000};
  else if (large_up)                                                 {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY tcalc_up[16]   ? 22'h3FFF80 : {tcalc_up[15:2],8'b1000_0000};
  else if (large_down)                                               {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY tcalc_down[16] ? 22'h000000 : {tcalc_down[15:2],8'b1000_0000};
  else if (~filter_load)                                             {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {pvt_value[13:0],o_filter[7:0]};
  else if ((internal_value[13:0] == pvt_value[13:0]) & ~o_filter[7]) {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {pvt_value[13:0],o_filter[7:0]} + {~dll_lock,3'h4};
  else if ((internal_value[13:0] == pvt_value[13:0]) &  o_filter[7]) {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {pvt_value[13:0],o_filter[7:0]} - {~dll_lock,3'h4};
  else if (dll_lock)                                                 {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {pvt_value[13:0],o_filter[7:0]} + internal_value[13:0] - pvt_value[13:0];
  else                                                               {pvt_value[13:0],o_filter[7:0]} <= #FF_DELAY {pvt_value[13:0],o_filter[7:0]} + {internal_value[13:0],6'h0} - {pvt_value[13:0],6'h0};

// self-timed based lock assertion
aibcr3pnr_self_lock_assertion xaibcr3pnr_self_lock_assertion (
.clk                    ( clk            ),
.reset_n                ( reset_n        ),
.rb_clkdiv              ( rb_clkdiv[2:0]),
.rb_selflock            ( rb_selflock    ),
.scan_mode_n            ( scan_mode_n    ),
.fsm_lock               ( dll_lock       ),
.prelock 		( prelock	 ),
.lock                   ( lock           )
);

//send out dll setting

assign pvt_ref_binary[10:0] = pvt_value[13:3];                                 // change - from 10 bits to 11 bits

assign pvt_ref_gray[10:0] = { pvt_ref_binary[10],                              // change - from 10 bits to 11 bits
	                      pvt_ref_binary[10] ^ pvt_ref_binary[9],
                              pvt_ref_binary[9] ^ pvt_ref_binary[8],
                              pvt_ref_binary[8] ^ pvt_ref_binary[7],
                              pvt_ref_binary[7] ^ pvt_ref_binary[6],
                              pvt_ref_binary[6] ^ pvt_ref_binary[5],
                              pvt_ref_binary[5] ^ pvt_ref_binary[4],
                              pvt_ref_binary[4] ^ pvt_ref_binary[3],
                              pvt_ref_binary[2],
                              pvt_ref_binary[2] ^ pvt_ref_binary[1],
                              pvt_ref_binary[1] ^ pvt_ref_binary[0] };

// wire [10:0] pvt_ref_gray_pst;                                                 // change - from 10 bits to 11 bits
/* assign pvt_ref_gray_pst[10:0] = {rb_dly_pst[10],                              // change - from 10 bits to 11 bits
	                      rb_dly_pst[10] ^ rb_dly_pst[9],
                              rb_dly_pst[9] ^ rb_dly_pst[8],
                              rb_dly_pst[8] ^ rb_dly_pst[7],
                              rb_dly_pst[7] ^ rb_dly_pst[6],
                              rb_dly_pst[6] ^ rb_dly_pst[5],
                              rb_dly_pst[5] ^ rb_dly_pst[4],
                              rb_dly_pst[4] ^ rb_dly_pst[3],
                              rb_dly_pst[2],
                              rb_dly_pst[2] ^ rb_dly_pst[1],
                              rb_dly_pst[1] ^ rb_dly_pst[0] };
*/

always @(posedge clk or negedge reset_n)
  if (~reset_n)       pvt_ref_gry[10:0] <= 11'b0;            // change - from 10 bits to 11 bits; was assigned to pvt_ref_gray_pst
  else                pvt_ref_gry[10:0] <= pvt_ref_gray[10:0];               // change - from 10 bits to 11 bits

//half-cycle code generation (bypass or divide by 2)

aibcr3pnr_half_cycle_code_gen xaibcr3pnr_half_cycle_code_gen (
.clk                    ( clk                ),
.reset_n                ( reset_n            ),
.pvt_ref_binary         ( internal_pvt_binary[10:0]),
.rb_half_code           ( rb_half_code       ),
.pvt_ref_half_binary    ( pvt_ref_half_binary[10:0])
);

assign pvt_ref_half_gray[10:0] = {  pvt_ref_half_binary[10],                              // change - from 10 bits to 11 bits   
	                           pvt_ref_half_binary[10] ^ pvt_ref_half_binary[9],
                              	   pvt_ref_half_binary[9] ^ pvt_ref_half_binary[8],
                                   pvt_ref_half_binary[8] ^ pvt_ref_half_binary[7],
                                   pvt_ref_half_binary[7] ^ pvt_ref_half_binary[6],
                                   pvt_ref_half_binary[6] ^ pvt_ref_half_binary[5],
                                   pvt_ref_half_binary[5] ^ pvt_ref_half_binary[4],
                                   pvt_ref_half_binary[4] ^ pvt_ref_half_binary[3],
                                   pvt_ref_half_binary[2],
                                   pvt_ref_half_binary[2] ^ pvt_ref_half_binary[1],
                                   pvt_ref_half_binary[1] ^ pvt_ref_half_binary[0] };

always @(posedge clk or negedge reset_n)
  if (~reset_n)       pvt_ref_half_gry[10:0] <= 11'b000_0000_0000;
  else                pvt_ref_half_gry[10:0] <= pvt_ref_half_gray[10:0];

endmodule // aibcr3pnr_dll_core

