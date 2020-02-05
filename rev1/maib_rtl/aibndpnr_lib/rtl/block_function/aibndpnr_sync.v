// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibndpnr_sync 
#(
//-----------------------------------------------------------------------------------------------------------------------
//  Local calculated parameters
//-----------------------------------------------------------------------------------------------------------------------
parameter FF_DELAY     = 200
)

( q, so, clk, d, rb, ssb, si );

output reg  q, so;

input  clk, d, rb, ssb, si;

`ifdef DLL_SYNOPSYS

d04hgy23nd0c0 xsync0 ( .d(d), .clk(clk), .o(q0),
     .rb(rb), .si(si), .so(so0), .ssb(ssb));
d04hgy23nd0c0 xsync1 ( .d(q0), .clk(clk), .o(q),
     .rb(rb), .si(so0), .so(so), .ssb(ssb));

`else

reg           t_reg0;
reg           t_reg1;

always @(posedge clk or negedge rb)
    if (~rb) begin
        t_reg0 <= #FF_DELAY 1'b0;
        t_reg1 <= #FF_DELAY 1'b0;
        q <= #FF_DELAY 1'b0;
    end
    else begin
        t_reg0 <= #FF_DELAY d;
        t_reg1 <= #FF_DELAY t_reg0;
        q <= #FF_DELAY t_reg1;
    end

`endif

endmodule


