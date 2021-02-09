// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .

// Library - aibndaux_lib, Cell - aibndaux_top, View - schematic
// LAST TIME SAVED: May 29 14:15:42 2015
// NETLIST TIME: Jun  1 14:34:53 2015
//`timescale 1ns / 1ns 

module aibndaux_top_slave (  o_crdet, u_crdet, u_crdet_r, u_dn_por, u_dn_por_r, i_dn_por, i_crdet_ovrd);

output o_crdet;

inout u_crdet, u_crdet_r, u_dn_por, u_dn_por_r;

input  i_dn_por, i_crdet_ovrd;

wire o_crete_detect;
assign vccl_aibndaux = 1'b1;
assign vssl_aibndaux = 1'b0;
assign o_crdet = o_crete_detect | i_crdet_ovrd; 

aibndaux_aliasd aliasd2 ( .PLUS(u_dn_por), .MINUS(u_dn_por_r));
aibndaux_pasred_simple xpasred ( .crete_detect(o_crete_detect),
                                 .iopad_crdet(u_crdet), 
                                 .vssl_aibndaux(vssl_aibndaux),
                                 .vccl_aibndaux(vccl_aibndaux), 
                                 .iopad_dn_por(u_dn_por),
                                 .dn_por(i_dn_por)
     );
endmodule

