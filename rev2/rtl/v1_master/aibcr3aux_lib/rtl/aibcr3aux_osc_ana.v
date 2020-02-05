// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

///////////////////////////////////////////////////////////////////////////
// Ring Oscillator : Analog portion                                
// date: 18 Dec 2016                                                     
// version: 1.0 
//
// 1. Remove atb observability
//                                                                       
///////////////////////////////////////////////////////////////////////////
 `timescale 1ps / 1ps

module aibcr3aux_osc_ana (
                                         ////////////////////////////////
                                         // inputs and output pins
                                         ////////////////////////////////

    input [3:0] iosc_atbmuxsel,
    input [4:0] iosc_cr_vccdreg_vsel,  // controls supply to osc, not implemented
    input [2:0] iosc_cr_vreg_rdy,      // comparator reference, not implemented
    input iosc_ic50u,                      // 50uA supply, not implemented
    input iosc_it50u,                      // 50uA supply, not implemented
    input [9:0] iosc_fuse_trim,     
    input [8:0] iosc_cr_trim,          // trim osc freq, not implemented
                                           // except iosc_cr_trim[7] (chicken bit)
    input iosc_cr_pdb,                     // 0: turn off oscillator

    inout vss_aibcr3aux,
    inout vcc_aibcr3aux,
    inout vcca_aibcr3aux,

    output osc_out,                         // oscillator output
    output osc_atb0,
    output osc_atb1,
    output chicken_bit,
    output comp_out,                         // deprecate
    // output [2:1] ib50u,
    output ib50u_1,
    output ib50u_2, 
    // output [2:1] ib100u,
    output ib100u_2,
    output ib100u_1,   
    inout  osc_extrref
);

                                         ////////////////////////////////
                                         // constants
                                         ////////////////////////////////

    parameter PERIOD = 500;               // oscillator period
    parameter CYCLE  = 100000000;        // number of cycles


                                         ////////////////////////////////
                                         // local variables
                                         ////////////////////////////////
    reg osc_clk;
    reg q;
                                         ////////////////////////////////
                                         // generate oscillator clock
                                         ////////////////////////////////
    initial begin
        osc_clk = 1'b0;
    end
    always begin
        #250 osc_clk = ~osc_clk;         // 250ps is the half period of clock
    end


                                         ////////////////////////////////
                                         // osc power up/down condition
                                         ////////////////////////////////
    // need to add case statement to allow oscillator to spin, only if the
    // osc_extrref is weakly pulled down at the chip level. update pending   
 
    and (osc_out, osc_clk, iosc_cr_pdb);
    assign chicken_bit = iosc_fuse_trim[9] ? iosc_fuse_trim[7] : iosc_cr_trim[7];
    assign {osc_atb0,osc_atb1} = 2'bzz;

endmodule

