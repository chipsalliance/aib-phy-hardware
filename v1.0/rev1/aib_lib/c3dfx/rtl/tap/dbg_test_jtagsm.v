// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//
`include "dbg_test_defines.v"
module dbg_test_jtagsm(
  tck,
  tms,
  tdi,
  tdo,
  reset_n,
  update_ir,
  update_dr,
  capture_dr,
  shift_ir,
  shift_dr,
  test_logic_reset,
  instruction,
  state_shift_dr_p
);

parameter TOTAL_IR_SIZE = 15;
parameter EFF_IR_SIZE = 7;

input tck;
input tms;
input reset_n;
input tdi;
output tdo;
output update_ir;
output update_dr;
output capture_dr;
output shift_ir;
output shift_dr;
output test_logic_reset;
output [EFF_IR_SIZE-1:0] instruction;
output state_shift_dr_p;

reg [3:0] current_state;
reg [3:0] next_state;
reg [TOTAL_IR_SIZE-1:0] ir;
reg [EFF_IR_SIZE-1:0] instruction;

reg update_ir;
reg update_dr;
reg capture_dr;
reg shift_ir;
reg shift_dr;
reg test_logic_reset;

// TAP state machine
always @(posedge tck or negedge reset_n)
begin
  if(reset_n == 1'b0)
    current_state <= `CNT_DBG_TEST__TEST_LOGIC_RESET;
  else
    current_state <= next_state;
end

always @(tms or current_state)
begin
  case(current_state)
    `CNT_DBG_TEST__TEST_LOGIC_RESET:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__TEST_LOGIC_RESET;
      else
        next_state = `CNT_DBG_TEST__RUN_TEST_IDLE;
    end

    `CNT_DBG_TEST__RUN_TEST_IDLE:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__SELECT_DR_SCAN;
      else
        next_state = `CNT_DBG_TEST__RUN_TEST_IDLE;
    end

    `CNT_DBG_TEST__SELECT_DR_SCAN:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__SELECT_IR_SCAN;
      else
        next_state = `CNT_DBG_TEST__CAPTURE_DR;
    end

    `CNT_DBG_TEST__CAPTURE_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT1_DR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_DR;
    end

    `CNT_DBG_TEST__SHIFT_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT1_DR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_DR;
    end

    `CNT_DBG_TEST__EXIT1_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__UPDATE_DR;
      else
        next_state = `CNT_DBG_TEST__PAUSE_DR;
    end

    `CNT_DBG_TEST__PAUSE_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT2_DR;
      else
        next_state = `CNT_DBG_TEST__PAUSE_DR;
    end

    `CNT_DBG_TEST__EXIT2_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__UPDATE_DR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_DR;
    end

    `CNT_DBG_TEST__UPDATE_DR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__SELECT_DR_SCAN;
      else
        next_state = `CNT_DBG_TEST__RUN_TEST_IDLE;
    end

    `CNT_DBG_TEST__SELECT_IR_SCAN:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__TEST_LOGIC_RESET;
      else
        next_state = `CNT_DBG_TEST__CAPTURE_IR;
    end

    `CNT_DBG_TEST__CAPTURE_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT1_IR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_IR;
    end

    `CNT_DBG_TEST__SHIFT_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT1_IR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_IR;
    end

    `CNT_DBG_TEST__EXIT1_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__UPDATE_IR;
      else
        next_state = `CNT_DBG_TEST__PAUSE_IR;
    end

    `CNT_DBG_TEST__PAUSE_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__EXIT2_IR;
      else
        next_state = `CNT_DBG_TEST__PAUSE_IR;
    end

    `CNT_DBG_TEST__EXIT2_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__UPDATE_IR;
      else
        next_state = `CNT_DBG_TEST__SHIFT_IR;
    end

    `CNT_DBG_TEST__UPDATE_IR:
    begin
      if(tms)
        next_state = `CNT_DBG_TEST__SELECT_DR_SCAN;
      else
        next_state = `CNT_DBG_TEST__RUN_TEST_IDLE;
    end

    default:
      next_state = `CNT_DBG_TEST__TEST_LOGIC_RESET;

  endcase
end

always @(current_state)
begin
  shift_ir = 1'b0;
  shift_dr = 1'b0;
  capture_dr = 1'b0;
  update_ir = 1'b0;
  update_dr = 1'b0;
  test_logic_reset = 1'b0;

  case(current_state)
    `CNT_DBG_TEST__SHIFT_IR:
      shift_ir = 1'b1;

    `CNT_DBG_TEST__SHIFT_DR:
      shift_dr = 1'b1;

    `CNT_DBG_TEST__CAPTURE_DR:
      capture_dr = 1'b1;

    `CNT_DBG_TEST__UPDATE_IR:
      update_ir = 1'b1;

    `CNT_DBG_TEST__UPDATE_DR:
      update_dr = 1'b1;

    `CNT_DBG_TEST__TEST_LOGIC_RESET:
      test_logic_reset = 1'b1;

  endcase
end

// TAP IR
// SHIFT-IR operation
always @(posedge tck or negedge reset_n)
begin
  if(reset_n == 1'b0)
    ir <= {TOTAL_IR_SIZE{1'b0}};
  else if(test_logic_reset == 1'b1)
    ir <= {TOTAL_IR_SIZE{1'b0}};
  else if(shift_ir)
    ir <= {tdi,ir[TOTAL_IR_SIZE-1:1]};
end 

assign tdo = ir[0];

// UPDATE-IR operation
always @(negedge tck or negedge reset_n)
begin
  if(reset_n == 1'b0)
    instruction <= {EFF_IR_SIZE{1'b0}};
  else if(update_ir == 1'b1)
    instruction <= ir[EFF_IR_SIZE-1:0];
end

assign state_shift_dr_p = (next_state == `CNT_DBG_TEST__SHIFT_DR) ? 1'b1: 1'b0;

endmodule
