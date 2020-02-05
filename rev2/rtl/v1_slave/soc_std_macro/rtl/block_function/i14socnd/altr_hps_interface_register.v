// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: 28-nm standard cell harden FF synchronizer
//
// Note on RESET_VAL:
// if a "set" or "reset" type synchronizer should be used. If RESET_VAL evaluates
// to zero, a reset type synchronizer is chosen. All other values of RESET_VAL
// will lead to a set type synchronizer
//
// when multi-bit crossing is required (note: async handshake macros are also available and is
// usually recommended for multi-bit CDC - ensure your use case is fine with double-synchronizers
// if you choose this macro)
//
// However, choosing this method excludes 1 use case: There's is no mechanism to choose individual
// reset value for each bit of a multi-bit signal through this macro. e.g: RESET_VAL == 3'b101 is
// not supported. It is assumed that this use case is not required for users of this macro
//
//------------------------------------------------------------------------

module altr_hps_interface_register
    (
    input  wire              clk,       // clock
    input  wire              rst_n,     // async reset
    input  wire              test_ctrl, // test control
    input  wire              scanen,    // scan enable
    input  wire              data_in,   // data in
    input  wire              scan_in,   // scan in
    output wire              data_out   // data out
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF

    reg   dff1;
    wire  muxsel;

   assign  muxsel = scanen | test_ctrl;

   
   always @(posedge clk or negedge rst_n)
   begin
      if (!rst_n)
         dff1     <= 1'b0;
      else
         dff1 <= muxsel ? scan_in : data_in;
   end
  assign data_out = dff1;

`else


`endif

endmodule // altr_hps_interface_register

