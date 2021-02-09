// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: altr_hps_gltchfltr:
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

module altr_hps_gltchfltr 
          #(parameter RESET_VAL = 'd0)  (  // Reset value

    // src_clk domain signals.
    input                      clk,
    input                      rst_n,

    input wire                 din,           // Async. input
    output reg                 dout_clean     // Synchronous output to clk.
                                              // Glitch free output signal.
	  );

// signals
wire            din_sync;
reg             din_sync_r;
wire            detect_transition;
wire            dout_enable;
reg     [ 2: 0] cntr;


altr_hps_bitsync #(.DWIDTH(1), .RESET_VAL(RESET_VAL)) gltchfltr_sync (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(din),
    .data_out(din_sync)
);

// 2 extra flops
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin

    din_sync_r <= RESET_VAL;
    dout_clean <= RESET_VAL;

  end else begin

    din_sync_r <= din_sync;

    if (dout_enable) begin
      dout_clean <= din_sync_r;
    end

  end
end

// Transition when bits are not equal (xor)
assign detect_transition = din_sync ^ din_sync_r;

// Enable output flop only when count is equal to 3'b111 and not transition.
assign dout_enable = (cntr == 3'b111) & ~detect_transition;

// 3 bit counter for 8 stable clocks without a transition.
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin

    cntr <= 3'd0;

  end else begin

    cntr <= detect_transition ? 3'd0: cntr + 3'd1;

  end
end


endmodule 



