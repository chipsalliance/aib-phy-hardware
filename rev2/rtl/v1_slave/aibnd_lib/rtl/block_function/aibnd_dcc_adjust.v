// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_adjust, View - schematic
// LAST TIME SAVED: Oct 29 15:22:27 2014
// NETLIST TIME: Oct 29 17:05:14 2014


module aibnd_dcc_adjust ( ckout, vcc_pl, vss_pl, ckin, init_up,
     rb_dcc_byp, therm_dn, therm_up, thermb_dn, thermb_up );

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

output  ckout;
inout  vcc_pl, vss_pl;
input  ckin, init_up, rb_dcc_byp;

input [30:0]  therm_dn;
input [30:0]  thermb_up;
input [30:0]  thermb_dn;
input [30:0]  therm_up;

time step, a_time,b_time;
integer pulse, total_delay,calc_delay_up, calc_delay_dn, calc_delay;
reg  trig;
wire ckin_dcc;

//--------------------------------------------------------------------------------------------------------------------------------------------
//--- Calculate the delay of the dcc delay line
//--------------------------------------------------------------------------------------------------------------------------------------------

   initial step =  5;  // Supports 5 ps step size

   always @(posedge ckin)
       case (therm_up)
        31'b0_00000_00000_00000_00000_00000_00000 :  calc_delay_up <= (0 * step);
        31'b0_00000_00000_00000_00000_00000_00001 :  calc_delay_up <= (1 * step);
        31'b0_00000_00000_00000_00000_00000_00011 :  calc_delay_up <= (2 * step);
        31'b0_00000_00000_00000_00000_00000_00111 :  calc_delay_up <= (3 * step);
        31'b0_00000_00000_00000_00000_00000_01111 :  calc_delay_up <= (4 * step);
        31'b0_00000_00000_00000_00000_00000_11111 :  calc_delay_up <= (5 * step);
        31'b0_00000_00000_00000_00000_00001_11111 :  calc_delay_up <= (6 * step);
        31'b0_00000_00000_00000_00000_00011_11111 :  calc_delay_up <= (7 * step);
        31'b0_00000_00000_00000_00000_00111_11111 :  calc_delay_up <= (8 * step);
        31'b0_00000_00000_00000_00000_01111_11111 :  calc_delay_up <= (9 * step);
        31'b0_00000_00000_00000_00000_11111_11111 :  calc_delay_up <= (10 * step);
        31'b0_00000_00000_00000_00001_11111_11111 :  calc_delay_up <= (11 * step);
        31'b0_00000_00000_00000_00011_11111_11111 :  calc_delay_up <= (12 * step);
        31'b0_00000_00000_00000_00111_11111_11111 :  calc_delay_up <= (13 * step);
        31'b0_00000_00000_00000_01111_11111_11111 :  calc_delay_up <= (14 * step);
        31'b0_00000_00000_00000_11111_11111_11111 :  calc_delay_up <= (15 * step);
        31'b0_00000_00000_00001_11111_11111_11111 :  calc_delay_up <= (16 * step);
        31'b0_00000_00000_00011_11111_11111_11111 :  calc_delay_up <= (17 * step);
        31'b0_00000_00000_00111_11111_11111_11111 :  calc_delay_up <= (18 * step);
        31'b0_00000_00000_01111_11111_11111_11111 :  calc_delay_up <= (19 * step);
        31'b0_00000_00000_11111_11111_11111_11111 :  calc_delay_up <= (20 * step);
        31'b0_00000_00001_11111_11111_11111_11111 :  calc_delay_up <= (21 * step);
        31'b0_00000_00011_11111_11111_11111_11111 :  calc_delay_up <= (22 * step);
        31'b0_00000_00111_11111_11111_11111_11111 :  calc_delay_up <= (23 * step);
        31'b0_00000_01111_11111_11111_11111_11111 :  calc_delay_up <= (24 * step);
        31'b0_00000_11111_11111_11111_11111_11111 :  calc_delay_up <= (25 * step);
        31'b0_00001_11111_11111_11111_11111_11111 :  calc_delay_up <= (26 * step);
        31'b0_00011_11111_11111_11111_11111_11111 :  calc_delay_up <= (27 * step);
        31'b0_00111_11111_11111_11111_11111_11111 :  calc_delay_up <= (28 * step);
        31'b0_01111_11111_11111_11111_11111_11111 :  calc_delay_up <= (29 * step);
        31'b0_11111_11111_11111_11111_11111_11111 :  calc_delay_up <= (30 * step);
        31'b1_11111_11111_11111_11111_11111_11111 :  calc_delay_up <= (31 * step);
        default     :  calc_delay_up <= (0 * step);
       endcase

   always @(posedge ckin)
        case (therm_dn)
        31'b0_00000_00000_00000_00000_00000_00000 :  calc_delay_dn <= (-31 * step);
        31'b0_00000_00000_00000_00000_00000_00001 :  calc_delay_dn <= (-30 * step);
        31'b0_00000_00000_00000_00000_00000_00011 :  calc_delay_dn <= (-29 * step);
        31'b0_00000_00000_00000_00000_00000_00111 :  calc_delay_dn <= (-28 * step);
        31'b0_00000_00000_00000_00000_00000_01111 :  calc_delay_dn <= (-27 * step);
        31'b0_00000_00000_00000_00000_00000_11111 :  calc_delay_dn <= (-26 * step);
        31'b0_00000_00000_00000_00000_00001_11111 :  calc_delay_dn <= (-25 * step);
        31'b0_00000_00000_00000_00000_00011_11111 :  calc_delay_dn <= (-24 * step);
        31'b0_00000_00000_00000_00000_00111_11111 :  calc_delay_dn <= (-23 * step);
        31'b0_00000_00000_00000_00000_01111_11111 :  calc_delay_dn <= (-22 * step);
        31'b0_00000_00000_00000_00000_11111_11111 :  calc_delay_dn <= (-21 * step);
        31'b0_00000_00000_00000_00001_11111_11111 :  calc_delay_dn <= (-20 * step);
        31'b0_00000_00000_00000_00011_11111_11111 :  calc_delay_dn <= (-19 * step);
        31'b0_00000_00000_00000_00111_11111_11111 :  calc_delay_dn <= (-18 * step);
        31'b0_00000_00000_00000_01111_11111_11111 :  calc_delay_dn <= (-17 * step);
        31'b0_00000_00000_00000_11111_11111_11111 :  calc_delay_dn <= (-16 * step);
        31'b0_00000_00000_00001_11111_11111_11111 :  calc_delay_dn <= (-15 * step);
        31'b0_00000_00000_00011_11111_11111_11111 :  calc_delay_dn <= (-14 * step);
        31'b0_00000_00000_00111_11111_11111_11111 :  calc_delay_dn <= (-13 * step);
        31'b0_00000_00000_01111_11111_11111_11111 :  calc_delay_dn <= (-12 * step);
        31'b0_00000_00000_11111_11111_11111_11111 :  calc_delay_dn <= (-11 * step);
        31'b0_00000_00001_11111_11111_11111_11111 :  calc_delay_dn <= (-10 * step);
        31'b0_00000_00011_11111_11111_11111_11111 :  calc_delay_dn <= (-9 * step);
        31'b0_00000_00111_11111_11111_11111_11111 :  calc_delay_dn <= (-8 * step);
        31'b0_00000_01111_11111_11111_11111_11111 :  calc_delay_dn <= (-7 * step);
        31'b0_00000_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-6 * step);
        31'b0_00001_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-5 * step);
        31'b0_00011_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-4 * step);
        31'b0_00111_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-3 * step);
        31'b0_01111_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-2 * step);
        31'b0_11111_11111_11111_11111_11111_11111 :  calc_delay_dn <= (-1 * step);
        31'b1_11111_11111_11111_11111_11111_11111 :  calc_delay_dn <= (0 * step);
        default     :  calc_delay_dn <= (0 * step);
        endcase

   always @(posedge ckin)  calc_delay <= calc_delay_up + calc_delay_dn;
   always @(posedge ckin)  a_time <= $time;
   always @(negedge ckin)  b_time <= $time;

    always @(posedge ckin) begin
        pulse <= b_time - a_time;
        total_delay <= pulse + calc_delay;
    end

   always @(posedge ckin)
	   if (ckin) begin
                     trig <= 1'b1;
              #total_delay trig <= 1'b0;
	   end

	assign ckin_dcc = trig;	
        assign ckout  = (rb_dcc_byp) ? ckin : ckin_dcc;             

endmodule

