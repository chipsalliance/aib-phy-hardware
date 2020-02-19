// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// © 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: altr_hps_gltchfltr_vec:
//
//       This is a vector version of altr_hps_gltchfltr
//       Notable differences are:
//       Parameterized width: DWIDTH
//       Parameterized counter value: COUNT
//       Parameterized behavior: RELOAD
//
//       Some notable behavioral differences with altr_hps_gltchfltr:
//       RESET_VAL is evaluated and used the same way as altr_hps_bitsync
//          This doesn't matter to altr_hps_gltchfltr since it's 1 bit
//          but it matters to this due to the multiple bit requirement
//
//       How often a new dout_clean is registered can be changed
//       using the RELOAD parameter:
//          RELOAD == 0 : Load a new dout_clean once the deglitching count reaches
//                        COUNT. Always recirculate old value otherwise.
//          RELOAD == 1 : Load a new dout_clean every COUNT clocks - regardless
//                        of the fact that din never changed
//                        This matches altr_hps_gltchfltr behavior
//
//       The following comment come from altr_hps_gltchfltr
//       Simple low cost in terms of gate single bit glitch filter.
//       This macro is created for FPGA Manager as CB inputs could glitch.
//
//       This macro assumes the input bits make transitions infrequently,
//       such that the sampling window is large.   It is best used for
//       bits sampled in software or used as static configuration that
//       changes every once in awhile.
//
//       The design has 1 syncflop and 2 extra flops.  There is a 3 bit
//       counter which enables the output flop (4th flop) to be loaded
//       every 8 clock cycles.   The counter is reset if a transition
//       occurs.  So the din synchronized value must be stable for
//       8 clocks for the value to be propigated to the output.
//
//------------------------------------------------------------------------

module altr_hps_gltchfltr_vec 
          #(parameter RESET_VAL = 'd0,   // Reset value
            parameter DWIDTH = 'd2,
            parameter COUNT = 'd8,
            parameter RELOAD = 'd1 )  (  

   // src_clk domain signals.
   input                      clk,
   input                      rst_n,

   input wire [DWIDTH-1:0]  din,           // Async. input
   output reg [DWIDTH-1:0]  dout_clean     // Synchronous output to clk.
                                          // Glitch free output signal.
   );

function integer clog2;
   input [31:0] value;  // Input variable
   for (clog2=0; value>0; clog2=clog2+1)
   value = value>>'d1;
endfunction

localparam FULL   = COUNT - 'd1;
localparam CWIDTH = clog2(FULL);

// The reset methodology will follow altr_hps_bitsync
localparam RESET_VAL_1B = (RESET_VAL == 'd0) ? 1'b0 : 1'b1;

// signals
wire [DWIDTH-1:0] din_sync;
reg  [DWIDTH-1:0] din_sync_r;
wire              detect_transition;
wire              dout_enable;
wire              deglitching;
reg  [CWIDTH-1:0] cntr;


altr_hps_bitsync #(.DWIDTH(DWIDTH), .RESET_VAL(RESET_VAL)) gltchfltr_sync (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(din),
    .data_out(din_sync)
);

// 2 extra flops per bit
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin

    din_sync_r <= {DWIDTH{RESET_VAL_1B}};
    dout_clean <= {DWIDTH{RESET_VAL_1B}};

  end else begin

    din_sync_r <= din_sync;

    if (dout_enable) begin
      dout_clean <= din_sync_r;
    end

  end
end

// Transition when bits are not equal (xor)
assign detect_transition = |(din_sync ^ din_sync_r);

// RELOAD == 1 causes it's behavior to match with altr_hps_gltchfltr
assign deglitching = (RELOAD == 'd1 ) ? 1'b1 : ( |(din_sync ^ dout_clean) );

// Enable output flop only when count is equal to 3'b111 and not transition.
assign dout_enable = (cntr == FULL) & ~detect_transition;

// 3 bit counter for 8 stable clocks without a transition.
always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin

      cntr <= {CWIDTH{1'b0}};

   end else begin

      // Some seriously long cascaded muxes
      cntr <= deglitching ? ( detect_transition ? {CWIDTH{1'b0}} : (cntr == FULL) ? {CWIDTH{1'b0}} : cntr + {{CWIDTH-1{1'b0}}, 1'b1} ) : {CWIDTH{1'b0}};

      // Here's what it means
      // if (deglitching)  -- it means a new input is sampled and is different from current output
      //    if (detect_transition)  -- 1 pulse signal indicating a change in the synchronized input
      //                            -- detect_transition pulses when a new input is sampled and will also pulse if the input changes again while deglitching
      //       reset counter to zero
      //    else if (counter == FULL)  -- has the counter his FULL count yet? 
      //       reset counter to zero
      //    else
      //       increment the counter
      // else                          -- this "else" matches with "if (deglitching)" 
      //                               -- when deglitching is no longer required - reset the counter to zero
      //    reset counter to zero
            
   end

end

endmodule 
