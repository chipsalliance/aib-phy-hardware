// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module DIFF_CLK_RCVR_inv_2__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module DIFF_CLK_RCVR_inv_3__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module DIFF_CLK_RCVR_inv_chain_1__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire outb;

DIFF_CLK_RCVR_inv_2__w_sup XINV0 (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

DIFF_CLK_RCVR_inv_3__w_sup XINV1 (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module DIFF_CLK_RCVR_diffamp_self_biased_1__w_sup(
    input  wire v_inn,
    input  wire v_inp,
    output wire v_out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic temp;

always_comb begin
    casez ({v_inp, v_inn, VDD, VSS})
        4'b1010: temp = 1'b1;
        4'b0110: temp = 1'b0;
        4'b??00: temp = 1'b0;
        default: temp = 1'bx;
    endcase
end

assign #DELAY v_out = temp;

endmodule


module DIFF_CLK_RCVR_diffamp_self_biased_buffer_1__w_sup(
    input  wire v_inn,
    input  wire v_inp,
    output wire v_out,
    inout  wire VDD,
    inout  wire VSS
);

wire v_mid;

DIFF_CLK_RCVR_inv_chain_1__w_sup XBUF (
    .in( v_mid ),
    .out( v_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

DIFF_CLK_RCVR_diffamp_self_biased_1__w_sup XDIFF (
    .v_inn( v_inn ),
    .v_inp( v_inp ),
    .v_out( v_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module DIFF_CLK_RCVR_esd_diode_ndio_1__w_sup(
    inout  wire MINUS,
    inout  wire PLUS
);

always @(PLUS) begin
    if(PLUS===1'bz) $display("ESD ndio error: PLUS port is 1'bz");
end

endmodule


module DIFF_CLK_RCVR_esd_diode_pdio_1__w_sup(
    inout  wire MINUS,
    inout  wire PLUS
);

always @(MINUS) begin
    if(MINUS===1'bz) $display("ESD pdio error: MINUS port is 1'bz");
end

endmodule


module DIFF_CLK_RCVR__w_sup(
    input  wire CLK_N,
    input  wire CLK_P,
    output wire clk_in,
    inout  wire VDD,
    inout  wire VDDGPIO,
    inout  wire VSS
);

DIFF_CLK_RCVR_diffamp_self_biased_buffer_1__w_sup XDIFF_BUF (
    .v_inn( CLK_N ),
    .v_inp( CLK_P ),
    .v_out( clk_in ),
    .VDD( VDD ),
    .VSS( VSS )
);

DIFF_CLK_RCVR_esd_diode_ndio_1__w_sup XESD_N_BOT (
    .MINUS( CLK_N ),
    .PLUS( VSS )
);

DIFF_CLK_RCVR_esd_diode_pdio_1__w_sup XESD_N_TOP (
    .MINUS( VDDGPIO ),
    .PLUS( CLK_N )
);

DIFF_CLK_RCVR_esd_diode_ndio_1__w_sup XESD_P_BOT (
    .MINUS( CLK_P ),
    .PLUS( VSS )
);

DIFF_CLK_RCVR_esd_diode_pdio_1__w_sup XESD_P_TOP (
    .MINUS( VDDGPIO ),
    .PLUS( CLK_P )
);

endmodule


module DIFF_CLK_RCVR(
    input  wire CLK_N,
    input  wire CLK_P,
    output wire clk_in
);

wire VDD_val;
wire VDDGPIO_val;
wire VSS_val;

wire clk_in_int;

assign VDD_val = 1'b1;
assign VDDGPIO_val = 1'b1;
assign VSS_val = 1'b0;

DIFF_CLK_RCVR__w_sup XDUT (
    .CLK_N( CLK_N ),
    .CLK_P( CLK_P ),
    .clk_in( clk_in_int ),
    .VDD( VDD_val ),
    .VDDGPIO( VDDGPIO_val ),
    .VSS( VSS_val )
);

// from tttt_25_0p850_0p970
assign #(50, 50) clk_in = clk_in_int;

endmodule
