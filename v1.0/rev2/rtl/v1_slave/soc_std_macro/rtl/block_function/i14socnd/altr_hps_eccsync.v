// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//
// Name    : ECC Hand-shake Synchronizer

module altr_hps_eccsync (
  input  wire rst_n,          // Reset (active low)
  input  wire clk,            // Clock 
  input  wire err,            // Error interrupt (from ECC RAM, serr/derr)
  input  wire err_ack,        // Error interrupt request (from System Manager)
  output reg  err_req         // Error interrupt acknowledge (to GIC)
);

// Declaration
localparam IDLE = 1'b0,
           REQ  = 1'b1;

reg err_d, ack_d;
wire err_p, ack_p;

// Positive edge detection
assign err_p = err & ~err_d;
assign ack_p = err_ack & ~ack_d;

always @(posedge clk, negedge rst_n) begin
  if (~rst_n) begin
    err_d <= 1'b0;
    ack_d <= 1'b0;
    end
  else begin
    err_d <= err;
    ack_d <= err_ack;
    end
  end

// Hand-shake states
always @(posedge clk, negedge rst_n) begin
  if (~rst_n)
    err_req <= 1'b0;
  else
    case (err_req)
      IDLE: err_req <= err_p & ~err_ack;
      REQ : err_req <= ~ack_p;
      default: err_req <= 1'bx;  // simulation purpose
    endcase
end

endmodule
