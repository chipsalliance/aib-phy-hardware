// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_min_misc :   misc block for interpolator
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_min_misc (
input       [1:0] filter_code,      	// 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
input       [1:0] c_out_x,      		// interpolator clock for pnr/dpa
input             couple_enable,    	// cross coupling enable
input             nfrzdrv,          	// for power domain crossing protection
input             test_enable,      	// Active high test enable    1: avoid tristate on output of interp_mux during testing
output      [1:0] c_out,			// interpolator clock for pnr/dpa
output            pon,        		// cross couple control for p fingers
output            non,        		// cross couple control for n fingers
output      [3:1] scp,              	// filter capacitance selection
output reg  [3:1] scn,              	// filter capacitance selection
output            svcc,        		// for test
output            test_enable_n      	// Active low test enable
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  MUX_DELAY      = 50;  // 50ps

assign svcc = 1'b1;
assign test_enable_n        = ~test_enable;
assign #(2 * INV_DELAY) c_out[1:0] = c_out_x[1:0] & {2{nfrzdrv}};
assign non	    	    = couple_enable & test_enable_n;
assign pon	    	    = ~non;

//filter code decode
always @(*)
  case (filter_code[1:0])
    2'b00 :  scn[3:1] = 3'b000;
    2'b01 :  scn[3:1] = 3'b001;
    2'b10 :  scn[3:1] = 3'b011;
    2'b11 :  scn[3:1] = 3'b111;
  endcase
assign #INV_DELAY scp[3:1] = ~scn[3:1];

endmodule


