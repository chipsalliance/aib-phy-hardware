// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
//  2011 Altera Corporation. .
//
//****************************************************************************************

module altr_hps_t2_register
    (
    input  wire              clk,      // clock
    input  wire              rst_n,    // async reset
    input  wire              scan_en,   // scan enable
    input  wire              data_in,   // data in
    input  wire              scan_in,   // scan in
    output wire              data_out   // data out
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF

   reg   dff1;
   
   always @(posedge clk or negedge rst_n)
   begin
      if (!rst_n)
         dff1     <= 1'b0;
      else
         dff1 <= scan_en ? scan_in : data_in;
   end
   assign data_out = dff1;

`else
 
 
 

`endif

endmodule // altr_interface_register

