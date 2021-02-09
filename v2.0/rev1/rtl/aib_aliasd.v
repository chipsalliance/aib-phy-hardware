// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
//  CELL: aib_aliasd
//
//  Description: Directional alias device
//
//------------------------------------------
 module aib_aliasd( sig_in, sig_red );

    output   sig_red;
    input    sig_in;

    assign sig_red = sig_in;

 endmodule
