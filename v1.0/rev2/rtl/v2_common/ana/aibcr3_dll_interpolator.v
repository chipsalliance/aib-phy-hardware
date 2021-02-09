// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dll_interpolator_nand_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dll_interpolator_nand_4__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dll_interpolator_aib_dlycell_core_1__w_sup(
    input  wire bk1,
    input  wire ci_p,
    input  wire in_p,
    output wire co_p,
    output wire out_p,
    inout  wire VDD,
    inout  wire VSS
);

wire sr0_o;
wire sr1_o;

aib_dll_interpolator_nand_3__w_sup XNAND_SR0 (
    .in( {sr1_o,bk1} ),
    .out( sr0_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_nand_3__w_sup XNAND_SR1 (
    .in( {sr0_o,in_p} ),
    .out( sr1_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_nand_4__w_sup XNAND_in (
    .in( {bk1,in_p} ),
    .out( co_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_nand_4__w_sup XNAND_out (
    .in( {sr1_o,ci_p} ),
    .out( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dll_interpolator_phase_interp_1__w_sup(
    input  wire [7:0] a_en,
    input  wire [7:0] a_enb,
    input  wire a_in,
    input  wire [7:0] b_en,
    input  wire [7:0] b_enb,
    input  wire b_in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);
    // The phase interpolator behavioral model behaves as follows:
    //
    // Normal (expected) operation:
    //     1. Wait for a_in or b_in to toggle. Register the one that toggled as early
    //     2. Wait for the other signal to toggle. Register this one as late.
    //        Under normal operations, it'll be the same direction as the early (e.g., a rise b rise).
    //     3. Measure the delay between the two inputs.
    //     4. Based on the en/enb settings for the two signals and the relative delay steps,
    //        calculate the relative delay (i.e., as a proportion to the delay between the two inputs).
    //     5. Calculate the absolute delay, accounting for the intrinsic delay as well.
    //     6. Propagate the inputs to the output with the absolute delay.
    //
    // This step-by-step operation is enabled by the FSM, which has the following states:
    //     IDLE        : Waiting for an early edge.
    //     A_EARLY_RISE: Waiting for late edge given that early edge was rising a_in.
    //                   Under normal operation, late edge then should be rising b_in.
    //     A_EARLY_FALL: Waiting for late edge given that early edge was falling a_in.
    //                   Under normal operation, late edge then should be falling b_in.
    //     B_EARLY_RISE: Waiting for late edge given that early edge was rising b_in.
    //                   Under normal operation, late edge then should be rising a_in.
    //     B_EARLY_FALL: Waiting for late edge given that early edge was falling b_in.
    //                   Under normal operation, late edge then should be falling a_in.
    //
    // The delay calculation and delayed assignment to output happens when the late signal is registered,
    // which happens at the state transition from A/B_EARLY_RISE/FALL to IDLE.
    //
    // Edge cases:
    //     If any of the inputs and enable signals is x, then output is x immediately.
    //
    //     If a_en and a_enb are not complementary, then error. Same for b_en and b_enb. Same for a_en and b_en.
    //
    //     If the intrinsic delay less than the calculated delay (which is a linear function of the
    //      delay between the 2 inputs) such that the delay from the late input to the output is negative,
    //      then error and don't update the output.
    //      Note: this isn't an actual "problem" in the actual circuit, but the model works by
    //      applying a delay relative to the late edge. Hence it won't work in this case.
    //
    //     If the early edge is rising and the late edge is falling (or vice versa), then error.
    //      However, treat the late falling edge as the early falling edge and update the state correspondingly.
    //      In other words, assume the early edge was invalid (or that it was actually a late edge and the
    //      previous rising edge was not captured).
    //
    //     If one input toggles (and is detected as the early edge) and the same input toggles again
    //      without the other input toggling, then error. However, treat the latter toggle as the early
    //      edge, update the state correspondingly, and proceed. In other words, assume the former edge was invalid.
    //
    //     When an input is x, output x immediately as described above. In addition, do not update the state.
    //      Note that this means that the FSM can see two consecutive (defined) toggles from the same input
    //      in the same direction. For example, a_in can be 0 -> 1 -> x -> 1. In this case, as was with
    //      the above cases, error but treat the latter rising edge (x -> 1) as the early rising edge.
    //      In other words, assume that the former rising edge (0 -> 1) was invalid.
    //
    //     If both inputs change simultaneously, the model interprets them given the current state:
    //      IDLE        : If both signals rise or fall, then arbitrarily assign one as early and the other as late.
    //                      Proceed to delay calculation. Keep state at IDLE.
    //                    If one rises and the other falls, error and keep state at IDLE.
    //                    If one rises or falls and the other becomes x, ignore the latter and register the
    //                      former as the early edge.
    //                    If both become x, error, ignore both, and keep the state at IDLE.
    //      A_EARLY_RISE: If a_in falls and b_in rises, associate rising b_in with the previously detected
    //                      a_in and register it as the late edge. Proceed to delay calculation accordingly.
    //                      Register the falling a_in as the early edge for the next pair of edges and thus
    //                      advance to A_EARLY_FALL.
    //                    If both rise, ignore the previously detected early edge and use the recent rising edges.
    //                      Arbitrarily assign one as early and the other as late. Proceed to delay calculation.
    //                      Advance to IDLE. Note that this only happens when a_in was 1 -> x before and
    //                      both a_in and b_in transition to 1.
    //                    If both fall, error because rising b_in was expected. Ignore the previously detected
    //                      early edge and use the recent falling edges. Arbitrarily assign one as early
    //                      and the other as late. Proceed to delay calculation. Advance to IDLE.
    //                    If a_in rises and b_in falls, error and advance to IDLE. Note that this only
    //                      happens when a_in was 1 -> x before. and a_in transitions to 1, while b_in falls.
    //                    If either a_in or b_in becomes x, ignore the x and treat it as a single edge toggling.
    //                    If both become x, error and keep state at A_EARLY_RISE.
    //     All the other states are mirrored cases of A_EARLY_RISE.

    time intrinsic = 41;  // intrinsic delay of circuit
    parameter ASSERTION_DELAY = 0; // Delay for assertion checkers

    logic late_in;
    logic [7:0] late_en;
    time early_time, late_time, late_early_delta;

    real delay_scalar;                // relative delay from late edge to output in
                                      // proportion to delay between early and late edge
    time calc_delay, neg_calc_delay;  // neg_calc_delay is used as a sanity check to
                                      // ensure that the intrinsic delay is large enough
                                      // for the model to work properly

    logic temp;

    // FSM states
    typedef enum {IDLE, A_EARLY_RISE, A_EARLY_FALL, B_EARLY_RISE, B_EARLY_FALL} state_t;
    state_t curr_state;

    logic prev_a_in, prev_b_in;
    logic a_stable, a_new_x, a_rise, a_fall;
    logic b_stable, b_new_x, b_rise, b_fall;
    time next_early_time;  // only used when early_time must be used to calculate
                           // the delay but the next early edge is already detected

    wire has_inputs_x;
    assign has_inputs_x = $isunknown({a_en, a_enb, b_en, b_enb, a_in, b_in});

    always @(posedge a_in or posedge b_in or negedge a_in or negedge b_in) begin
        a_stable = a_in === prev_a_in;
        b_stable = b_in === prev_b_in;
        a_new_x = $isunknown(a_in) && !$isunknown(prev_a_in);
        b_new_x = $isunknown(b_in) && !$isunknown(prev_b_in);
        a_rise = (!$isunknown(a_in) && a_in)  && ($isunknown(prev_a_in) || !prev_a_in) && !a_stable;
        a_fall = (!$isunknown(a_in) && !a_in) && ($isunknown(prev_a_in) || prev_a_in)  && !a_stable;
        b_rise = (!$isunknown(b_in) && b_in)  && ($isunknown(prev_b_in) || !prev_b_in) && !b_stable;
        b_fall = (!$isunknown(b_in) && !b_in) && ($isunknown(prev_b_in) || prev_b_in)  && !b_stable;

        if ((a_new_x && $isunknown(b_in)) || ($isunknown(a_in) && b_new_x)) begin
            `ifdef PI_ERROR
                $error("Invalid transition because a_in = b_in = x. Not updating curr_state");
            `else
                $info("Invalid transition because a_in = b_in = x. Not updating curr_state");
            `endif
        end
        else begin
            case (curr_state)
                IDLE: begin
                    early_time = $time;
                    casez({a_rise, a_fall, b_rise, b_fall})
                        4'b10_10, 4'b01_01: begin
                            curr_state <= IDLE;
                            late_time = $time;
                            // Doesn't matter which is early and late if both arrive simultaneously
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_01, 4'b01_10: begin
                            `ifdef PI_ERROR
                                $error("a_in and b_in changed simultaneously but in reverse polarity");
                            `else
                                $info("a_in and b_in changed simultaneously but in reverse polarity");
                            `endif
                            curr_state <= IDLE;
                        end
                        4'b10_00, 4'b01_00: begin
                            curr_state <= a_rise ? A_EARLY_RISE : A_EARLY_FALL;
                        end
                        4'b00_10, 4'b00_01: begin
                            curr_state <= b_rise ? B_EARLY_RISE : B_EARLY_FALL;
                        end
                        4'b00_00: begin
                            if (a_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because a_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because a_in = x. Not updating curr_state");
                                `endif
                            else if (b_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because b_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because b_in = x. Not updating curr_state");
                                `endif
                        end
                    endcase
                end
                A_EARLY_RISE: begin
                    casez({a_rise, a_fall, b_rise, b_fall})
                        4'b01_10: begin
                            curr_state <= A_EARLY_FALL;
                            late_time = $time;
                            next_early_time = $time;
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_10, 4'b01_01: begin
                            if (a_rise)
                                `ifdef PI_ERROR
                                    $error("Expected negedge, received posedge instead");
                                `else
                                    $info("Expected negedge, received posedge instead");
                                `endif
                            else
                                `ifdef PI_ERROR
                                    $error("Expected posedge, received negedge instead");
                                `else
                                    $info("Expected posedge, received negedge instead");
                                `endif
                            curr_state <= IDLE;
                            early_time = $time;
                            late_time = $time;
                            // Doesn't matter which is early and late if both arrive simultaneously
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_01: begin
                            `ifdef PI_ERROR
                                $error("a_in and b_in changed simultaneously but in reverse polarity");
                            `else
                                $info("a_in and b_in changed simultaneously but in reverse polarity");
                            `endif
                            curr_state <= IDLE;
                        end
                        4'b10_00, 4'b01_00: begin
                            `ifdef PI_ERROR
                                $error("Expected b_in to change, not a_in");
                            `else
                                $info("Expected b_in to change, not a_in");
                            `endif
                            curr_state <= a_rise ? A_EARLY_RISE : A_EARLY_FALL;
                            early_time = $time;
                        end
                        4'b00_01: begin
                            `ifdef PI_ERROR
                                $error("Expected posedge, received negedge instead");
                            `else
                                $info("Expected posedge, received negedge instead");
                            `endif
                            curr_state <= B_EARLY_FALL;
                            early_time = $time;
                        end
                        4'b00_10: begin
                            curr_state <= IDLE;
                            late_time = $time;
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        default: begin
                            if (a_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because a_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because a_in = x. Not updating curr_state");
                                `endif
                            else if (b_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because b_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because b_in = x. Not updating curr_state");
                                `endif
                        end
                    endcase
                end
                A_EARLY_FALL: begin
                    casez({a_fall, a_rise, b_fall, b_rise})
                        4'b01_10: begin
                            curr_state <= A_EARLY_RISE;
                            late_time = $time;
                            next_early_time = $time;
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_10, 4'b01_01: begin
                            if (a_fall)
                                `ifdef PI_ERROR
                                    $error("Expected negedge, received posedge instead");
                                `else
                                    $info("Expected negedge, received posedge instead");
                                `endif
                            else
                                `ifdef PI_ERROR
                                    $error("Expected posedge, received negedge instead");
                                `else
                                    $info("Expected posedge, received negedge instead");
                                `endif
                            curr_state <= IDLE;
                            early_time = $time;
                            late_time = $time;
                            // Doesn't matter which is early and late if both arrive simultaneously
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_01: begin
                            `ifdef PI_ERROR
                                $error("a_in and b_in changed simultaneously but in reverse polarity");
                            `else
                                $info("a_in and b_in changed simultaneously but in reverse polarity");
                            `endif
                            curr_state <= IDLE;
                        end
                        4'b10_00, 4'b01_00: begin
                            `ifdef PI_ERROR
                                $error("Expected b_in to change, not a_in");
                            `else
                                $info("Expected b_in to change, not a_in");
                            `endif
                            curr_state <= a_fall ? A_EARLY_FALL : A_EARLY_RISE;
                            early_time = $time;
                        end
                        4'b00_01: begin
                            `ifdef PI_ERROR
                                $error("Expected posedge, received negedge instead");
                            `else
                                $info("Expected posedge, received negedge instead");
                            `endif
                            curr_state <= B_EARLY_RISE;
                            early_time = $time;
                        end
                        4'b00_10: begin
                            curr_state <= IDLE;
                            late_time = $time;
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        default: begin
                            if (a_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because a_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because a_in = x. Not updating curr_state");
                                `endif
                            else if (b_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because b_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because b_in = x. Not updating curr_state");
                                `endif
                        end
                    endcase
                end
                B_EARLY_RISE: begin
                    casez({b_rise, b_fall, a_rise, a_fall})
                        4'b01_10: begin
                            curr_state <= B_EARLY_FALL;
                            late_time = $time;
                            next_early_time = $time;
                            late_in <= a_in;
                            late_en <= a_en;
                        end
                        4'b10_10, 4'b01_01: begin
                            if (b_rise)
                                `ifdef PI_ERROR
                                    $error("Expected negedge, received posedge instead");
                                `else
                                    $info("Expected negedge, received posedge instead");
                                `endif
                            else
                                `ifdef PI_ERROR
                                    $error("Expected posedge, received negedge instead");
                                `else
                                    $info("Expected posedge, received negedge instead");
                                `endif
                            curr_state <= IDLE;
                            early_time = $time;
                            late_time = $time;
                            // Doesn't matter which is early and late if both arrive simultaneously
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_01: begin
                            `ifdef PI_ERROR
                                $error("a_in and b_in changed simultaneously but in reverse polarity");
                            `else
                                $info("a_in and b_in changed simultaneously but in reverse polarity");
                            `endif
                            curr_state <= IDLE;
                        end
                        4'b10_00, 4'b01_00: begin
                            `ifdef PI_ERROR
                                $error("Expected a_in to change, not b_in");
                            `else
                                $info("Expected a_in to change, not b_in");
                            `endif
                            curr_state <= b_rise ? B_EARLY_RISE : B_EARLY_FALL;
                            early_time = $time;
                        end
                        4'b00_01: begin
                            `ifdef PI_ERROR
                                $error("Expected posedge, received negedge instead");
                            `else
                                $info("Expected posedge, received negedge instead");
                            `endif
                            curr_state <= A_EARLY_FALL;
                            early_time = $time;
                        end
                        4'b00_10: begin
                            curr_state <= IDLE;
                            late_time = $time;
                            late_in <= a_in;
                            late_en <= a_en;
                        end
                        default: begin
                            if (a_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because a_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because a_in = x. Not updating curr_state");
                                `endif
                            else if (b_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because b_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because b_in = x. Not updating curr_state");
                                `endif
                        end
                    endcase
                end
                B_EARLY_FALL: begin
                    casez({b_fall, b_rise, a_fall, a_rise})
                        4'b01_10: begin
                            curr_state <= B_EARLY_RISE;
                            late_time = $time;
                            next_early_time = $time;
                            late_in <= a_in;
                            late_en <= a_en;
                        end
                        4'b10_10, 4'b01_01: begin
                            if (b_fall)
                                `ifdef PI_ERROR
                                    $error("Expected negedge, received posedge instead");
                                `else
                                    $info("Expected negedge, received posedge instead");
                                `endif
                            else
                                `ifdef PI_ERROR
                                    $error("Expected posedge, received negedge instead");
                                `else
                                    $info("Expected posedge, received negedge instead");
                                `endif
                            curr_state <= IDLE;
                            early_time = $time;
                            late_time = $time;
                            // Doesn't matter which is early and late if both arrive simultaneously
                            late_in <= b_in;
                            late_en <= b_en;
                        end
                        4'b10_01: begin
                            `ifdef PI_ERROR
                                $error("a_in and b_in changed simultaneously but in reverse polarity");
                            `else
                                $info("a_in and b_in changed simultaneously but in reverse polarity");
                            `endif
                            curr_state <= IDLE;
                        end
                        4'b10_00, 4'b01_00: begin
                            `ifdef PI_ERROR
                                $error("Expected a_in to change, not b_in");
                            `else
                                $info("Expected a_in to change, not b_in");
                            `endif
                            curr_state <= b_fall ? B_EARLY_FALL : B_EARLY_RISE;
                            early_time = $time;
                        end
                        4'b00_01: begin
                            `ifdef PI_ERROR
                                $error("Expected posedge, received negedge instead");
                            `else
                                $info("Expected posedge, received negedge instead");
                            `endif
                            curr_state <= A_EARLY_RISE;
                            early_time = $time;
                        end
                        4'b00_10: begin
                            curr_state <= IDLE;
                            late_time = $time;
                            late_in <= a_in;
                            late_en <= a_en;
                        end
                        default: begin
                            if (a_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because a_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because a_in = x. Not updating curr_state");
                                `endif
                            else if (b_new_x)
                                `ifdef PI_ERROR
                                    $error("Invalid transition because b_in = x. Not updating curr_state");
                                `else
                                    $info("Invalid transition because b_in = x. Not updating curr_state");
                                `endif
                        end
                    endcase
                end
            endcase
        end

        prev_a_in <= a_in;
        prev_b_in <= b_in;
    end

    always @(late_in) begin
        // Calculate delay_scalar for each thermometer code
        case ($countones(late_en))
            0: delay_scalar = 0;
            1: delay_scalar = 0.143;
            2: delay_scalar = 0.286;
            3: delay_scalar = 0.429;
            4: delay_scalar = 0.571;
            5: delay_scalar = 0.714;
            6: delay_scalar = 0.857;
            7: delay_scalar = 1;
        endcase

        late_early_delta = late_time - early_time;
        calc_delay = intrinsic - (1 - delay_scalar) * late_early_delta;
        neg_calc_delay = (1 - delay_scalar) * late_early_delta - intrinsic;

        if (intrinsic > (1 - delay_scalar) * late_early_delta)
            temp = #(calc_delay) late_in;
        else
            `ifdef PI_ERROR
                $error("intrinsic delay (%0t) is too small, resulting in negative calc_delay (-%0t)", intrinsic, neg_calc_delay);
            `else
                $info("intrinsic delay (%0t) is too small, resulting in negative calc_delay (-%0t)", intrinsic, neg_calc_delay);
            `endif

        early_time <= next_early_time;
    end

    // enable complement assertion checker
    // With real delays, no two signals will change at the same time. Thus, only check for complementary signals
    // after ASSERTION_DELAY, which is expected to be enough time for all relevant signals to change
    always @(*) begin
        if (!$isunknown({ a_en, a_enb })) begin
            #(ASSERTION_DELAY);
            assert (a_en == ~a_enb) else
                `ifdef PI_ERROR
                    $error("a_en (%b) and a_enb (%b) must be complementary", a_en, a_enb);
                `else
                    $info("a_en (%b) and a_enb (%b) must be complementary", a_en, a_enb);
                `endif
        end
    end
    always @(*) begin
        if (!$isunknown({ b_en, b_enb })) begin
            #(ASSERTION_DELAY);
            assert (b_en == ~b_enb) else
                `ifdef PI_ERROR
                    $error("b_en (%b) and b_enb (%b) must be complementary", b_en, b_enb);
                `else
                    $info("b_en (%b) and b_enb (%b) must be complementary", b_en, b_enb);
                `endif
        end
    end
    always @(*) begin
        if (!$isunknown({ a_en, b_en })) begin
            #(ASSERTION_DELAY);
            assert (a_en == ~b_en) else
                `ifdef PI_ERROR
                    $error("a_en (%b) and b_en (%b) must be complementary", a_en, b_en);
                `else
                    $info("a_en (%b) and b_en (%b) must be complementary", a_en, b_en);
                `endif
        end
    end

    // enable x assertion checker
    always_comb begin
        assert (!$isunknown(a_en)) else
            `ifdef PI_ERROR
                $error("a_en (%b) contains x's", a_en);
            `else
                $info("a_en (%b) contains x's", a_en);
            `endif
    end
    always_comb begin
        assert (!$isunknown(a_enb)) else
            `ifdef PI_ERROR
                $error("a_enb (%b) contains x's", a_enb);
            `else
                $info("a_enb (%b) contains x's", a_enb);
            `endif
    end
    always_comb begin
        assert (!$isunknown(b_en)) else
            `ifdef PI_ERROR
                $error("b_en (%b) contains x's", b_en);
            `else
                $info("b_en (%b) contains x's", b_en);
            `endif
    end
    always_comb begin
        assert (!$isunknown(b_enb)) else
            `ifdef PI_ERROR
                $error("b_enb (%b) contains x's", b_enb);
            `else
                $info("b_enb (%b) contains x's", b_enb);
            `endif
    end

    assign out = has_inputs_x ? 1'bx : temp;

endmodule


module aib_dll_interpolator_inv_2__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_interpolator_inv_3__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_interpolator_nand_5__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aibcr3_dll_interpolator__w_sup(
    input  wire a_in,
    input  wire [6:0] sn,
    input  wire [6:0] sp,
    output wire intout,
    inout  wire VDD,
    inout  wire VSS
);

wire a_in_buf;
wire a_inb;
wire b_in;
wire mid;

aib_dll_interpolator_aib_dlycell_core_1__w_sup XDC (
    .bk1( VDD ),
    .ci_p( mid ),
    .in_p( a_in_buf ),
    .co_p( mid ),
    .out_p( b_in ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_phase_interp_1__w_sup XINT (
    .a_en( {VDD,sn[6:0]} ),
    .a_enb( {VSS,sp[6:0]} ),
    .a_in( a_in_buf ),
    .b_en( {VSS,sp[6:0]} ),
    .b_enb( {VDD,sn[6:0]} ),
    .b_in( b_in ),
    .out( intout ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_inv_2__w_sup XINVH (
    .in( a_in ),
    .out( a_inb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_inv_3__w_sup XINVL (
    .in( a_in ),
    .out( a_inb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_nand_5__w_sup XNANDH (
    .in( {a_inb,VDD} ),
    .out( a_in_buf ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_interpolator_nand_4__w_sup XNANDL (
    .in( {a_inb,VDD} ),
    .out( a_in_buf ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dll_interpolator(
    input  wire a_in,
    input  wire [6:0] sn,
    input  wire [6:0] sp,
    output wire intout
);

wire VDD_val;
wire VSS_val;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_dll_interpolator__w_sup XDUT (
    .a_in( a_in ),
    .sn( sn ),
    .sp( sp ),
    .intout( intout ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

endmodule
