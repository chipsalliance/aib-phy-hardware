// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019  Ayar Labs, Inc.
// Copyright (C) 2019 Intel Corporation. 

// Ayar changes: this is a wrapper to the original aibcr3_dcc_phasedet
// to use only the rising edge of the clock instead of both edges (single phase
// design). This will improve the deadzone of the phasedet block if there are
// duty cycle variations introduced by the DCC delay lines. Note that this
// simply instantiates the original aibcr3_dcc_phasedet but, instead of
// using the t_down output, it just generates it by inverting t_up

`default_nettype none
module aibcr3_dcc_phasedet_single (
        output wire     t_down, 
        output wire     t_up, 
        input wire      CLKA, 
        input wire      CLKB,
        input wire      RSTb
    );


    aibcr3_dcc_phasedet phasedet (
        .t_down (),
        .t_up   (t_up),
        .CLKA   (CLKA),
        .CLKB   (CLKB),
        .RSTb   (RSTb)
    );

    assign t_down = !t_up;

endmodule
`default_nettype wire


