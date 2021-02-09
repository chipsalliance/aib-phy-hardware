// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_interpolator :   Output Frequency = phy_clk_phs frequency
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_interpolator (
input          reset_n,          // Active low reset
input          pdn,          	 // power down active low 
input          nfrzdrv,          // for power domain crossing protection
input    [7:0] phy_clk_phs,      // 8 phase 1.6GHz local clock
input    [1:0] rb_filter_code,   // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
input    [2:0] mux_sel_a,        // The gray code to control (even) of the 8 to 1 phase multiplexer
input    [2:0] mux_sel_b,        // The gray code to control (odd ) of the 8 to 1 phase multiplexer
input    [3:0] interp_sel_a,     // The gray code output to control the interpolator (even)
input    [3:0] interp_sel_b,     // The gray code output to control the interpolator (odd )
input    [1:0] dirty_clk,        // The divided clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
input          enable,           // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
input          test_enable,      // Active high test enable    1: avoid tristate on output of interp_mux during testing
input          rb_couple_enable, // Active high cross couple enable
output         int_clk,          // Clock for the counter
output   [1:0] clk_out,          // Complimentary Clock output sent to the dqs_lgc_pnr/ioereg_pnr
output   [1:0] interpolator_clk  // Complimentary Clock output sent to the ioereg
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  FF_DELAY       = 80;  // 50ps
parameter  MUX_DELAY      = 50;  // 50ps

wire [2:0] mux_sel_x_a;
wire [2:0] mux_sel_y_a;
wire [2:0] mux_sel_z_a;
wire [2:0] mux_sel_x_b;
wire [2:0] mux_sel_y_b;
wire [2:0] mux_sel_z_b;
wire [2:0] clk_p_buf;
wire [2:0] clk_n_buf;
wire [2:0] clk_p;
wire [2:0] clk_n;

wire [7:0] phy_clk_phs_gated;
wire [7:0] slow_clk_ph_p;
wire [7:0] slow_clk_ph_n;
wire       test_enable_n;
wire       test_enable_buf;
wire       test_enable_frz;
wire       dft_mux_sel_p;
wire       dft_mux_sel_n;
wire       pon;
wire       non;

wire [7:0] sp;
wire [7:0] sn;
wire [6:0] selp;          // code for 2 phase interpolator (including decode for test)
wire [6:0] seln;          // complimentary code for 2 phase interpolator (including decode for test)
wire [3:1] scp;
wire [3:1] scn;

wire [1:0] interp_clk_x;
wire [1:0] int_clk_out;

io_interp_pdn xphs_gated (
.pdn               ( pdn	            	), // power down active low
.phy_clk_phs       ( phy_clk_phs[7:0]           ), // 8 phase 1.6GHz local clock
.phy_clk_phs_gated ( phy_clk_phs_gated[7:0]     )  // gated 8 phase 1.6GHz local clock
);

// `define FAST_SIM
`ifdef FAST_SIM

reg  [3:0] ph_counter;
reg        time_measured_event;
time       a_time, b_time;
reg  [2:0] mux_sel_t_a;
reg  [2:0] mux_sel_t_b;
reg  [3:0] interp_sel_t_a;
reg  [3:0] interp_sel_t_b;
reg        int_clk_local;
wire       intrinsic_clk;
time       calc_delay_a;
time       del_2x_a;
time       rem_2x_a;
time       del_1x_a;
time       del_0x_a;
time       calc_delay_b;
time       del_2x_b;
time       rem_2x_b;
time       del_1x_b;
time       del_0x_b;
wire [4:0] c_sig;
reg        pmx_2, pmx_1, pmx_0;
reg  [1:0] dirty_clk_reg;
reg        div_clk;

initial ph_counter[3:0] = 4'h0;
initial time_measured_event = 1'b1;

always @(posedge phy_clk_phs_gated[0])
 begin
  ph_counter[3:0] <= #FF_DELAY ph_counter[3:0] + 1'b1;
  if (ph_counter[3:0] == 4'h1)
    begin
      a_time = $time;
      @(posedge phy_clk_phs_gated[1])  b_time = (($time - a_time) + 8) / 16;
      time_measured_event <= #FF_DELAY ~time_measured_event;
    end
 end

always @(negedge int_clk_local or negedge reset_n)
   if (~reset_n) mux_sel_t_a[2:0] <= #FF_DELAY 3'h0;
   else          mux_sel_t_a[2:0] <= #FF_DELAY mux_sel_a[2:0];

always @(posedge int_clk_local or negedge reset_n)
   if (~reset_n) mux_sel_t_b[2:0] <= #FF_DELAY 3'h0;
   else          mux_sel_t_b[2:0] <= #FF_DELAY mux_sel_b[2:0];

always @(negedge int_clk_local or negedge reset_n)
   if (~reset_n) interp_sel_t_a[3:0] <= #FF_DELAY 4'h0;
   else          interp_sel_t_a[3:0] <= #FF_DELAY interp_sel_a[3:0];

always @(posedge int_clk_local or negedge reset_n)
   if (~reset_n) interp_sel_t_b[3:0] <= #FF_DELAY 4'h0;
   else          interp_sel_t_b[3:0] <= #FF_DELAY interp_sel_b[3:0];

always @(posedge phy_clk_phs_gated[0]) if (mux_sel_t_a[2:0] == 3'b000) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[1]) if (mux_sel_t_a[2:0] == 3'b001) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[2]) if (mux_sel_t_a[2:0] == 3'b011) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[3]) if (mux_sel_t_a[2:0] == 3'b010) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[4]) if (mux_sel_t_a[2:0] == 3'b110) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[5]) if (mux_sel_t_a[2:0] == 3'b111) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[6]) if (mux_sel_t_a[2:0] == 3'b101) int_clk_local <= 1'b1;
always @(posedge phy_clk_phs_gated[7]) if (mux_sel_t_a[2:0] == 3'b100) int_clk_local <= 1'b1;

always @(negedge phy_clk_phs_gated[0]) if (mux_sel_t_b[2:0] == 3'b000) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[1]) if (mux_sel_t_b[2:0] == 3'b001) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[2]) if (mux_sel_t_b[2:0] == 3'b011) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[3]) if (mux_sel_t_b[2:0] == 3'b010) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[4]) if (mux_sel_t_b[2:0] == 3'b110) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[5]) if (mux_sel_t_b[2:0] == 3'b111) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[6]) if (mux_sel_t_b[2:0] == 3'b101) int_clk_local <= 1'b0;
always @(negedge phy_clk_phs_gated[7]) if (mux_sel_t_b[2:0] == 3'b100) int_clk_local <= 1'b0;

assign #116 int_clk       = int_clk_local;
assign #150 intrinsic_clk = int_clk;

always @(interp_sel_t_a or time_measured_event)
 begin
   case (interp_sel_t_a[3:0])
     4'b0000 : calc_delay_a = 0 * b_time;
     4'b0001 : calc_delay_a = 1 * b_time;
     4'b0011 : calc_delay_a = 2 * b_time;
     4'b0010 : calc_delay_a = 3 * b_time;
     4'b0110 : calc_delay_a = 4 * b_time;
     4'b0111 : calc_delay_a = 5 * b_time;
     4'b0101 : calc_delay_a = 6 * b_time;
     4'b0100 : calc_delay_a = 7 * b_time;
     4'b1100 : calc_delay_a = 8 * b_time;
     4'b1101 : calc_delay_a = 9 * b_time;
     4'b1111 : calc_delay_a = 10 * b_time;
     4'b1110 : calc_delay_a = 11 * b_time;
     4'b1010 : calc_delay_a = 12 * b_time;
     4'b1011 : calc_delay_a = 13 * b_time;
     4'b1001 : calc_delay_a = 14 * b_time;
     4'b1000 : calc_delay_a = 15 * b_time;
     default : calc_delay_a = 8 * b_time;
   endcase

   del_2x_a = calc_delay_a / 100;          // 100 ps
   rem_2x_a = calc_delay_a - (del_2x_a * 100);
   del_1x_a = rem_2x_a / 10;               // 10 ps
   del_0x_a = rem_2x_a - (del_1x_a * 10);    // 1 ps

 end

always @(interp_sel_t_b or time_measured_event)
 begin
   case (interp_sel_t_b[3:0])
     4'b0000 : calc_delay_b = 0 * b_time;
     4'b0001 : calc_delay_b = 1 * b_time;
     4'b0011 : calc_delay_b = 2 * b_time;
     4'b0010 : calc_delay_b = 3 * b_time;
     4'b0110 : calc_delay_b = 4 * b_time;
     4'b0111 : calc_delay_b = 5 * b_time;
     4'b0101 : calc_delay_b = 6 * b_time;
     4'b0100 : calc_delay_b = 7 * b_time;
     4'b1100 : calc_delay_b = 8 * b_time;
     4'b1101 : calc_delay_b = 9 * b_time;
     4'b1111 : calc_delay_b = 10 * b_time;
     4'b1110 : calc_delay_b = 11 * b_time;
     4'b1010 : calc_delay_b = 12 * b_time;
     4'b1011 : calc_delay_b = 13 * b_time;
     4'b1001 : calc_delay_b = 14 * b_time;
     4'b1000 : calc_delay_b = 15 * b_time;
     default : calc_delay_b = 8 * b_time;
   endcase

   del_2x_b = calc_delay_b / 100;          // 100 ps
   rem_2x_b = calc_delay_b - (del_2x_b * 100);
   del_1x_b = rem_2x_b / 10;               // 10 ps
   del_0x_b = rem_2x_b - (del_1x_b * 10);    // 1 ps

 end

assign #10  c_sig[0]  = intrinsic_clk;
assign #100 c_sig[1]  = c_sig[0];
assign #100 c_sig[2]  = c_sig[1];
assign #100 c_sig[3]  = c_sig[2];
assign #100 c_sig[4]  = c_sig[3];

always @(posedge c_sig[0]) if (del_2x_a == 0) pmx_2 <= 1'b1;
always @(posedge c_sig[1]) if (del_2x_a == 1) pmx_2 <= 1'b1;
always @(posedge c_sig[2]) if (del_2x_a == 2) pmx_2 <= 1'b1;
always @(posedge c_sig[3]) if (del_2x_a == 3) pmx_2 <= 1'b1;
always @(posedge c_sig[4]) if (del_2x_a >= 4) pmx_2 <= 1'b1;

always @(posedge pmx_2)
  case (del_1x_a)
    0 : pmx_1 <= #0  pmx_2;
    1 : pmx_1 <= #10 pmx_2;
    2 : pmx_1 <= #20 pmx_2;
    3 : pmx_1 <= #30 pmx_2;
    4 : pmx_1 <= #40 pmx_2;
    5 : pmx_1 <= #50 pmx_2;
    6 : pmx_1 <= #60 pmx_2;
    7 : pmx_1 <= #70 pmx_2;
    8 : pmx_1 <= #80 pmx_2;
    9 : pmx_1 <= #90 pmx_2;
    default : pmx_1 <= #90 pmx_2;
  endcase

always @(posedge pmx_1)
  case (del_0x_a)
    0 : pmx_0 <= #0 pmx_1;
    1 : pmx_0 <= #1 pmx_1;
    2 : pmx_0 <= #2 pmx_1;
    3 : pmx_0 <= #3 pmx_1;
    4 : pmx_0 <= #4 pmx_1;
    5 : pmx_0 <= #5 pmx_1;
    6 : pmx_0 <= #6 pmx_1;
    7 : pmx_0 <= #7 pmx_1;
    8 : pmx_0 <= #8 pmx_1;
    9 : pmx_0 <= #9 pmx_1;
    default : pmx_0 <= #9 pmx_1;
  endcase

always @(negedge c_sig[0]) if (del_2x_b == 0) pmx_2 <= 1'b0;
always @(negedge c_sig[1]) if (del_2x_b == 1) pmx_2 <= 1'b0;
always @(negedge c_sig[2]) if (del_2x_b == 2) pmx_2 <= 1'b0;
always @(negedge c_sig[3]) if (del_2x_b == 3) pmx_2 <= 1'b0;
always @(negedge c_sig[4]) if (del_2x_b >= 4) pmx_2 <= 1'b0;

always @(negedge pmx_2)
  case (del_1x_b)
    0 : pmx_1 <= #0  pmx_2;
    1 : pmx_1 <= #10 pmx_2;
    2 : pmx_1 <= #20 pmx_2;
    3 : pmx_1 <= #30 pmx_2;
    4 : pmx_1 <= #40 pmx_2;
    5 : pmx_1 <= #50 pmx_2;
    6 : pmx_1 <= #60 pmx_2;
    7 : pmx_1 <= #70 pmx_2;
    8 : pmx_1 <= #80 pmx_2;
    9 : pmx_1 <= #90 pmx_2;
    default : pmx_1 <= #90 pmx_2;
  endcase

always @(negedge pmx_1)
  case (del_0x_b)
    0 : pmx_0 <= #0 pmx_1;
    1 : pmx_0 <= #1 pmx_1;
    2 : pmx_0 <= #2 pmx_1;
    3 : pmx_0 <= #3 pmx_1;
    4 : pmx_0 <= #4 pmx_1;
    5 : pmx_0 <= #5 pmx_1;
    6 : pmx_0 <= #6 pmx_1;
    7 : pmx_0 <= #7 pmx_1;
    8 : pmx_0 <= #8 pmx_1;
    9 : pmx_0 <= #9 pmx_1;
    default : pmx_0 <= #9 pmx_1;
  endcase

always @(posedge int_clk_local or negedge reset_n)
   if (~reset_n) dirty_clk_reg[0] <= #FF_DELAY 1'b1;
   else          dirty_clk_reg[0] <= #FF_DELAY dirty_clk[0];

always @(negedge int_clk_local or negedge reset_n)
   if (~reset_n) dirty_clk_reg[1] <= #FF_DELAY 1'b0;
   else          dirty_clk_reg[1] <= #FF_DELAY dirty_clk[1];

always @(posedge pmx_0 or negedge enable)
  if (~enable) div_clk <= #100 1'b0;
  else         div_clk <= #100 dirty_clk_reg[0];
always @(negedge pmx_0 or negedge enable)
  if (~enable) div_clk <= #100 1'b0;
  else         div_clk <= #100 dirty_clk_reg[1];

assign #150 clk_out[1:0]          = {~div_clk,div_clk};
assign #150 interpolator_clk[1:0] = {~div_clk,div_clk};

`else

//====================================================================================================================================
// io_interp_misc
//====================================================================================================================================

io_interp_misc xinterp_misc (
.reset_n		(reset_n			),             // Active low reset
.test_enable		(test_enable			),             // Active high test enable    1: avoid tristate on output of interp_mux during testing
.nfrzdrv		(nfrzdrv			),             // for power domain crossing protection
.couple_enable		(rb_couple_enable		),             // cross coupling enable
.filter_code		(rb_filter_code[0]		),             // borrowed from filter_code[0] for test
.clk_p_buf0		(clk_p_buf[0]			),             // Clock for pnr int_clk
.int_clk_out		(int_clk_out[1:0]		),             // interpolator clock for pnr/dpa
.phy_clk_phs		(phy_clk_phs_gated[7:0]		),             // 8 phase 1.6GHz local clock
.slow_clk_ph_p		(slow_clk_ph_p[7:0]		),             // 8 phase 1.6GHz local clock
.slow_clk_ph_n		(slow_clk_ph_n[7:0]		),             // 8 phase 1.6GHz local clock
.test_enable_buf	(test_enable_buf		),             // Active high test enable    1: avoid tristate on output of interp_mux during testing
.test_enable_frz	(test_enable_frz		),             // Active high test enable    1: avoid tristate on output of interp_mux during testing
.test_enable_n		(test_enable_n			),             // Active low test enable    0: avoid tristate on output of interp_mux during testing
.l_reset_n		(l_reset_n			),             // Active low reset
.clk_out		(clk_out[1:0]			),             // interpolator clock for pnr/dpa
.dft_mux_sel_n		(dft_mux_sel_n			),             // for test
.dft_mux_sel_p		(dft_mux_sel_p			),             // for test
.pon			(pon				),             // cross couple control for p fingers
.non			(non				),	       // cross couple control for n fingers
.int_clk		(int_clk			)              // Clock for the counter
);

//====================================================================================================================================
// io_interpolator_mux selects 3 of the 8 input clock phases (A complimentary set) 
//====================================================================================================================================


io_interp_mux_pair xim0(
.phy_clk_phs_gated	(phy_clk_phs_gated[7:0]		),       // 8 phase 1.6GHz local clock
.l_reset_n		(l_reset_n			),       // Active low reset
.mux_sel_a		(mux_sel_a[2:0]			),       // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b		(mux_sel_b[2:0]			),       // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.slow_clk_ph_p		(slow_clk_ph_p[7:0]		),
.slow_clk_ph_n		(slow_clk_ph_n[7:0]		),
.test_enable_n		(test_enable_n			),
.test_enable_frz	(test_enable_frz		),
.dft_mux_sel_p		(dft_mux_sel_p			),
.dft_mux_sel_n		(dft_mux_sel_n			),
.mux_sel_x_a		(mux_sel_x_a[2:0]		),       // The latched gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_x_b		(mux_sel_x_b[2:0]		),       // The latched gray code to control (odd ) of the 8 to 1 phase multiplexer
.c_out_n		(clk_n[0]			),	
.c_out_n_buf		(clk_n_buf[0]			),	
.c_out_p		(clk_p[0]			),
.c_out_p_buf		(clk_p_buf[0]			)
);

io_interp_mux_pair xim1(
.phy_clk_phs_gated      ({phy_clk_phs_gated[0],phy_clk_phs_gated[7:1]}	),       // 8 phase 1.6GHz local clock
.l_reset_n              (l_reset_n                      ),       // Active low reset
.mux_sel_a              (mux_sel_x_a[2:0]               ),       // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b              (mux_sel_x_b[2:0]               ),       // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.slow_clk_ph_p          ({slow_clk_ph_p[0],slow_clk_ph_p[7:1]}          ),
.slow_clk_ph_n          ({slow_clk_ph_n[0],slow_clk_ph_n[7:1]}          ),
.test_enable_n          (test_enable_n                  ),
.test_enable_frz        (test_enable_frz                ),
.dft_mux_sel_p          (dft_mux_sel_p                  ),
.dft_mux_sel_n          (dft_mux_sel_n                  ),
.mux_sel_x_a            (mux_sel_y_a[2:0]           	),       // The latched gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_x_b            (mux_sel_y_b[2:0]           	),       // The latched gray code to control (odd ) of the 8 to 1 phase multiplexer
.c_out_n                (clk_n[1]                       ),
.c_out_n_buf            (clk_n_buf[1]                   ),
.c_out_p                (clk_p[1]                       ),
.c_out_p_buf            (clk_p_buf[1]                   )
);

io_interp_mux_pair xim2(
.phy_clk_phs_gated      ({phy_clk_phs_gated[1:0],phy_clk_phs_gated[7:2]}  ),       // 8 phase 1.6GHz local clock
.l_reset_n              (l_reset_n                      ),       // Active low reset
.mux_sel_a              (mux_sel_x_a[2:0]               ),       // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b              (mux_sel_x_b[2:0]               ),       // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.slow_clk_ph_p          ({slow_clk_ph_p[1:0],slow_clk_ph_p[7:2]}          ),
.slow_clk_ph_n          ({slow_clk_ph_n[1:0],slow_clk_ph_n[7:2]}          ),
.test_enable_n          (test_enable_n                  ),
.test_enable_frz        (test_enable_frz                ),
.dft_mux_sel_p          (dft_mux_sel_p                  ),
.dft_mux_sel_n          (dft_mux_sel_n                  ),
.mux_sel_x_a            (mux_sel_z_a[2:0]           	),       // The latched gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_x_b            (mux_sel_z_b[2:0]           	),       // The latched gray code to control (odd ) of the 8 to 1 phase multiplexer
.c_out_n                (clk_n[2]                       ),
.c_out_n_buf            (clk_n_buf[2]                   ),
.c_out_p                (clk_p[2]                       ),
.c_out_p_buf            (clk_p_buf[2]                   )
);

//====================================================================================================================================
// io_cmos_16ph_decode decode interp_sel[3:0] for ip16phs
//====================================================================================================================================

io_cmos_16ph_decode xdec (
 .gray_sel_a  		( interp_sel_a[3:0]    ),
 .gray_sel_b  		( interp_sel_b[3:0]    ),
 .clk_p_0     		( clk_p_buf[0]         ),
 .clk_p_2     		( clk_p_buf[2]         ),
 .clk_n_0     		( clk_n_buf[0]         ),
 .clk_n_2     		( clk_n_buf[2]         ),
 .filter_code 		( rb_filter_code[1:0]  ),
 .enable      		( l_reset_n            ),
 .test_enable_buf      	( test_enable_buf      ),
 .test_enable_n      	( test_enable_n        ),
 .dft_mux_sel_p      	( dft_mux_sel_p        ),
 .dft_mux_sel_n      	( dft_mux_sel_n        ),
 .sp          		( sp[7:0]      	       ),
 .sn         		( sn[7:0]      	       ),
 .selp       		( selp[6:0]            ),
 .seln      		( seln[6:0]            ),
 .scp        		( scp[3:1]             ),
 .scn        		( scn[3:1]             )
);

//=========================================================================================================================================================================
//  io_ip16phs is the 16 phase interpolator
//=========================================================================================================================================================================

io_ip16phs xip16p (
 .c_in        ( clk_p[2:0]           ),
 .sp          ( sp[7:0]              ),
 .sn          ( sn[7:0]              ),
 .selp        ( {selp[6],1'b1,selp[4:3],1'b1,selp[1:0]} ),
 .seln        ( {seln[6],1'b0,seln[4:3],1'b0,seln[1:0]} ),
 .scp         ( scp[3:1]             ),
 .scn         ( scn[3:1]             ),
 .c_out       ( interp_clk_x[0]	     )
);

io_ip16phs xip16n (
 .c_in        ( clk_n[2:0]           ),
 .sp          ( sp[7:0]              ),
 .sn          ( sn[7:0]              ),
 .selp        ( {selp[6],1'b1,selp[4:3],1'b1,selp[1:0]} ),
 .seln        ( {seln[6],1'b0,seln[4:3],1'b0,seln[1:0]} ),
 .scp         ( scp[3:1]             ),
 .scn         ( scn[3:1]             ),
 .c_out       ( interp_clk_x[1]	     )
);

//=========================================================================================================================================================================
// output merge, clock divider & interpolator
//=========================================================================================================================================================================

io_interp_output xinterp_output (
.clk_n_buf0		(clk_n_buf[0]		),
.clk_n_buf2		(clk_n_buf[2]		),
.clk_p_buf0		(clk_p_buf[0]		),
.clk_p_buf2		(clk_p_buf[2]		),
.dirty_clk		(dirty_clk[1:0]		),      // The divided clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
.enable			(enable			),      // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.interp_clk_x		(interp_clk_x[1:0]	),      // interpolator clk after ip16phs
.reset_n		(l_reset_n		),      // Active low reset
.test_enable_n		(test_enable_n		),    	// Active low test enable
.pon			(pon			),      // cross coupling enable p finger
.non			(non			),      // cross coupling enable n finger
.int_clk_out		(int_clk_out[1:0]	),      // Complimentary Clock output sent to the dqs_lgc_pnr/ioereg_pnr
.interpolator_clk	(interpolator_clk[1:0]	)  	// Complimentary Clock output sent to the ioereg
);

//=========================================================================================================================================================================
// Waveforms
//=========================================================================================================================================================================
//
//                   _               ______________________________               _________________________               ______________________________               ____
//  mux_sel_x_a[2:0] _XXXXXXXXXXXXXXX_____________________0________XXXXXXXXXXXXXXX________________0________XXXXXXXXXXXXXXX_____________________1________XXXXXXXXXXXXXXX____
//                   _____________________               ______________________________               ______________________________               ________________________
//  mux_sel_x_b[2:0] ____________7________XXXXXXXXXXXXXXX_____________________0________XXXXXXXXXXXXXXX_____________________1________XXXXXXXXXXXXXXX__________________1_____
//                _ ___________________ ________________________ ___________________ ___________________ ________________________ ___________________ ___________________
//  imp0.amx[7:0] _X_________7_________X_____________0__________X__________0________X__________0________X_____________1__________X__________1________X__________1________X_
//       
//                      ___________________                     ___________________                     ___________________                     ___________________
//  clk_ph[0]  ________/                   \___________________/                   \___________________/                   \___________________/                   \_______
//                           ___________________               :     ___________________                     ___________________                     ___________________
//  clk_ph[1]  _____________/                   \______________:____/                   \___________________/                   \___________________/                   \__
//                                ___________________          :          ___________________                     ______________:____                     _________________
//  clk_ph[2]  __________________/                   \_________:_________/                   \___________________/              :    \___________________/
//             ___                     ___________________     :               ___________________                     _________:_________                     ____________
//  clk_ph[3]     \___________________/                   \____:______________/                   \___________________/         :         \___________________/
//             ________                     ___________________:                    ___________________                     ____:______________                     _______
//  clk_ph[4]          \___________________/                   :___________________/                   \___________________/    :              \___________________/
//             _____________                     ______________:____                     ___________________                    :___________________                     __
//  clk_ph[5]               \___________________/              :    \___________________/                   \___________________:                   \___________________/
//             __________________                     _________:_________                     ___________________               :     ___________________
//  clk_ph[6]                    \___________________/         :         \___________________/                   \______________:____/                   \_________________
//                 ___________________                     ____:______________                     ___________________          :          ___________________
//  clk_ph[7]  ___/                   \___________________/    :              \___________________/                   \_________:_________/                   \____________
//                :                   :                        :                                                                :
//                :___________________:                        :___________________                     ________________________:                    ___________________
//  clk_p[0]   ___/                   \________________________/                   \___________________/                        \___________________/                   \__
//                      ___________________                          ___________________                     ________________________                     _________________
//  clk_p[1]   ________/                   \________________________/                   \___________________/                        \___________________/
//                           ___________________                          ___________________                     ________________________                     ____________
//  clk_p[2]   _____________/                   \________________________/                   \___________________/                        \___________________/  
//
//                     ________               ______________________________               _________________________               ______________________________            
//  out_interp_az[3:0] ________XXXXXXXXXXXXXXX_____________________2________XXXXXXXXXXXXXXX________________C________XXXXXXXXXXXXXXX_____________________6________XXXXXXXXXXXX
//                     ____________________________               ______________________________               ______________________________               _________________
//  out_interp_bz[3:0] ___________________D________XXXXXXXXXXXXXXX_____________________7________XXXXXXXXXXXXXXX_____________________1________XXXXXXXXXXXXXXX_______________B_
//                 __________ ___________________ ________________________ ___________________ ___________________ ________________________ ___________________ _____________
//  therm_sel[7:0] __________X_________D_________X_____________2__________X__________7________X__________C________X_____________1__________X__________6________X__________B__
//       
//  interp_clk          ____________________                       _____________________                      _____________________                      ____________________
//  ideal         _____/                    \_____________________/                     \____________________/                     \____________________/
//                                      ____________________                       _____________________                      _____________________                      ____
//  interp_clk[0] \____________________/                    \_____________________/                     \____________________/                     \____________________/
//                 ____________________                      _____________________                       ____________________                       ____________________
//  interp_clk[1] /                    \____________________/                     \_____________________/                    \_____________________/                    \____
//
//===========================================================================================================================================================================
//===================================================================== divide 1 ============================================================================================
//
//                  _________________________________________________________________________________________________________________________________________________________
//  dbl_edge.lat[0]                1                                         1                                           1                                          1
//      
//  dbl_edge.lat[1] _______________0_________________________________________0___________________________________________0___________________________________________________
//
//                                       _____________________                       _____________________                      _____________________                      __
//  clk_out[0]      ________lat[1]______/        lat[0]       \_______lat[1]________/        lat[0]       \________lat[1]______/        lat[0]       \________lat[1]______/
//       
//
//===========================================================================================================================================================================
//===================================================================== divide 2 ============================================================================================
//
//                        _________________________                                                            ______________________________               
//  dirty_clk_out[0] XXXXX            1            XXXXXXXXXXXXXXX______________0_______________XXXXXXXXXXXXXXX               1              XXXXXXXXXXXXXXX____________0____
//                                  ___________________________                                                           ____________________________               
//  dbl_edge.lat[0] _XXXXXXXXXXXXXXX              1            XXXXXXXXXXXXXXX______________0______________XXXXXXXXXXXXXXX              1             XXXXXXXXXXXXXXX________
//
//                                            ______________________________                                                       ______________________________ 
//  dirty_clk_out[1] ___0______XXXXXXXXXXXXXXX              1               XXXXXXXXXXXXXXX____________0____________XXXXXXXXXXXXXXX              1               XXXXXXXXXXXX
//                                                       ____________________________                                                          ____________________________
//  dbl_edge.lat[1] ________0_____________XXXXXXXXXXXXXXX             1              XXXXXXXXXXXXXXX______________0_____________XXXXXXXXXXXXXXX              1             XX
//
//                                       _____________________ _____________________                                            _____________________ ____________________
//  clk_out[0]      ________lat[1]______/        lat[0]       |       lat[1]        \________lat[0]_______|________lat[1]______/        lat[0]       -        lat[1]      \__
//       
//
//===========================================================================================================================================================================
//===================================================================== divide 4 ============================================================================================
//
//                        _________________________               ______________________________
//  dirty_clk_out[0] XXXXX            1            ---------------               1              XXXXXXXXXXXXXXX________________0_____________---------------______________0__
//                                  ___________________________               _____________________________
//  dbl_edge.lat[0] _XXXXXXXXXXXXXXX              1            ---------------              1              XXXXXXXXXXXXXXX______________0_____________---------------________
//
//                                            ______________________________               _________________________
//  dirty_clk_out[1] __0_______XXXXXXXXXXXXXXX              1               ---------------           1             XXXXXXXXXXXXXXX_______________0______________------------
//                                                       ____________________________               ____________________________
//  dbl_edge.lat[1] __________0___________XXXXXXXXXXXXXXX              1             ---------------              1             XXXXXXXXXXXXXXX_______________0____________--
//                                       _____________________ _____________________ _____________________ ____________________                                            __
//  clk_out[0]      ________lat[1]______/        lat[0]       -       lat[1]        -        lat[0]       -        lat[1]      \________lat[0]_______-________lat[1]______/
//       
//
//===========================================================================================================================================================================

`endif

endmodule


