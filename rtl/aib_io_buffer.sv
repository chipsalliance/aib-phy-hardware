// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib_io_buffer
// Description    : Behavioral model of AIB io buffer
// Revision       : 1.0
// ============================================================================
`timescale 1ps/1ps
module aib_io_buffer 
  (
   // Tx Path
   input ilaunch_clk,            // Clock for transmit SDR/DDR data
   input irstb,                  // io buffer reset
   input idat0,                  // sync data from MAC to iopad
   input idat1,                  // sync data from MAC to iopad
   input async_data,             // Async data from MAC to iopad
   output wire      oclkn,       // clock output

   // Rx Path
   input       	     inclk,       // Rx clock input
   input       	     inclk_dist,  // Rx clock input
   input       	     iclkn,       // clock input
   output wire       oclk,        // clock output
   output wire       oclk_b,      // clock output
   output wire       odat0,       // Data to MAC
   output wire       odat1,       // Data to MAC
   output wire       odat_async,  // Async data out

   // Bidirectional Data 
   inout wire 	     io_pad,

   // I/O configuration
   input async,                   // 0 = Sample input data with ilaunch_clk
                                  // 1 = Async path from async_data to iopad
   input ddren,                   // 0 = SDR data idat0 delayed 1.0 ilaunch_clk
                                  // 1 = DDR data idat0 delayed 1.5 ilaunch_clk
                                  //              idat1 delayed 2.0 ilaunch_clk
   input txen,                    // 0 = output path disabled
                                  // 1 = output path enabled
   input rxen,                    // 0 = input path disabled
                                  // 1 = input path enabled
   input weaken,                  // 0 = No weak driver on iopad
                                  // 1 = Enable weak driver on iopad
   input weakdir                  // 0 = Pull-down enable when weaken = 1
                                  // 1 = Pull-up enable when weaken = 1
   );
   
   reg 	     idat0_preg;    // idat0 sampled with pos edge of ilaunch_clk
   reg 	     idat1_preg;    // idat1 sampled with pos edge of ilaunch_clk
   reg       idat_nreg;     // Selected data sampled with neg edge of ilaunch_clk
   wire      idatsync_sel;  // Synchronized inputdata
   wire      idat_iopad;    // Data value driven to output iopad
   reg 	     iopad_preg;    // iopad sampled with positive edge of clock
   reg 	     iopad_nreg;    // iopad sampled with negative edge of clock
   reg 	     odat0_i;       // latch Rx data
   reg 	     odat1_i;       // latch Rx data
   reg 	     odat0_r;       // Rx data to MAC
   reg 	     odat1_r;       // Rx data to MAC

   // Output tri-state buffr
   assign io_pad = (~irstb && txen) ? 1'b0 : 
                 (irstb && txen) ? idat_iopad : 1'bz;

   // pull-up
   bufif1 (weak1, weak0) (io_pad, 1'b1, weaken && (weakdir == 1'b1));

   // pull-down
   bufif1 (weak1, weak0) (io_pad, 1'b0, weaken && (weakdir == 1'b0));
   
   //---------------------------------------------------------------------------
   // Receive Data
   //---------------------------------------------------------------------------
   // Rx data sampled on positive edge of clock
   always @(posedge inclk)
    if (rxen)
     begin
	iopad_preg <= io_pad;
     end

   // Latch when clock is low
   always @(irstb or inclk or rxen or iopad_preg)
    if (~irstb)
     begin
        odat1_i = 1'b0;
     end
    else if (~inclk && rxen)
     begin
	odat1_i = iopad_preg;
     end

   // Rx data sampled on negative edge of clock
   always @(negedge inclk)
    if (rxen)
     begin
	iopad_nreg <= io_pad;
     end

   // Latch when clock is high
   always @(irstb or inclk or rxen or iopad_nreg)
    if (~irstb)
     begin
        odat0_i = 1'b0;
     end
    else if (inclk && rxen)
     begin
	odat0_i = iopad_nreg;
     end

wire odat0_i_tmp;
assign #1  odat0_i_tmp = odat0_i;
   // Data to MAC
   always @(posedge inclk_dist)
    if(rxen)
     begin
//	odat0_r <= odat0_i;
  	odat0_r <= odat0_i_tmp;
	odat1_r <= odat1_i;
     end	
   
   //assign odat0 = odat0_r && rxen && irstb;
   assign odat0 = ddren ? odat0_r && rxen && irstb : odat1_r && rxen && irstb;
   assign odat1 = odat1_r && rxen && irstb;

   // Asynchronous Rx data outputs
   assign odat_async = io_pad && rxen;
   
   //---------------------------------------------------------------------------
   // Transmit Data 
   //---------------------------------------------------------------------------
   // Tx data sampled on positive edge of clock
   always @(posedge ilaunch_clk)
    if(txen)
     begin
	idat0_preg <= idat0;
	idat1_preg <= idat1;
     end

   // Latch when clock is low
   always @(ilaunch_clk or txen or ddren or idat1_preg or idat0_preg)
    if(!ilaunch_clk && txen)
     begin
	idat_nreg = ddren ? idat1_preg : idat0_preg;
     end

   // SDR/DDR mux
   //assign idatsync_sel = ((ilaunch_clk == 1'b0) ? idat0_preg : idat_nreg) && txen;
   assign idatsync_sel = (((ilaunch_clk == 1'b1) & !ddren) ? idat0_preg : 
                          ((ilaunch_clk == 1'b0) & ddren) ? idat0_preg : idat_nreg) && txen;
   
   // Async/Sync mux
   assign idat_iopad = async ? async_data && txen : idatsync_sel;
		     
   //---------------------------------------------------------------------------
   // Differential Clock
   //---------------------------------------------------------------------------
   assign oclkn  = io_pad; 
   assign oclk   = io_pad; 
   assign oclk_b = iclkn;
   
endmodule // aib_io_buffer
