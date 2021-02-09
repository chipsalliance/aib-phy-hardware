// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dll_phasedet_inv_6__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_strongarm_frontend_1__w_sup(
    input  wire clk,
    input  wire inn,
    input  wire inp,
    input  wire rstb,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

logic woutp;
logic woutn;

always @(clk or rstb) begin
    if (~rstb || ~clk) {woutp, woutn} <= 2'b11;
    else begin
        case ({inp, inn})
            2'b10: {woutp, woutn} <= 2'b10;
            2'b01: {woutp, woutn} <= 2'b01;
            2'b00: {woutp, woutn} <= 2'b11;
            2'b11: {woutp, woutn} <= 2'b10; // Added a bias to ensure that don't fall into
                                            // default case that produces x's simply because
                                            // of arbitrary event ordering resolution.
            default: {woutp, woutn} <= 2'bxx;
        endcase
    end
end

assign outp = VSS ? 1'bx : (~VDD ? 1'b0 : woutp);
assign outn = VSS ? 1'bx : (~VDD ? 1'b0 : woutn);

endmodule


module aib_dll_phasedet_sr_latch_symmetric_core_1__w_sup(
    input  wire r,
    input  wire rb,
    input  wire rsthb,
    input  wire rstlb,
    input  wire s,
    input  wire sb,
    output wire q,
    output wire qb,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic temp_q, temp_qb;

always_comb begin
    casez ({rsthb, r, sb, VDD, VSS})
        5'b00?10: temp_q = 1'b1;
        5'b01?10: temp_q = 1'bx;
        5'b10010: temp_q = 1'b1;
        5'b10110: temp_q = ~temp_qb;
        5'b11010: temp_q = 1'bx;
        5'b11110: temp_q = 1'b0;
        5'b???00: temp_q = 1'b0;
        default : temp_q = 1'bx;
    endcase
end

always_comb begin
    casez ({rstlb, s, rb, VDD, VSS})
        5'b00?10: temp_qb = 1'b1;
        5'b01?10: temp_qb = 1'bx;
        5'b10010: temp_qb = 1'b1;
        5'b10110: temp_qb = ~temp_q;
        5'b11010: temp_qb = 1'bx;
        5'b11110: temp_qb = 1'b0;
        5'b???00: temp_qb = 1'b0;
        default: temp_qb = 1'bx;
    endcase
end

assign #DELAY q = temp_q;
assign #DELAY qb = temp_qb;

endmodule


module aib_dll_phasedet_inv_7__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_sr_latch_symmetric_1__w_sup(
    input  wire rb,
    input  wire rsthb,
    input  wire rstlb,
    input  wire sb,
    output wire q,
    output wire qb,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;
wire r;
wire s;

aib_dll_phasedet_sr_latch_symmetric_core_1__w_sup XCORE (
    .r( r ),
    .rb( rb ),
    .rsthb( rsthb ),
    .rstlb( rstlb ),
    .s( s ),
    .sb( sb ),
    .q( midp ),
    .qb( midn ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_7__w_sup XIBUF_1 (
    .in( sb ),
    .out( s ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_7__w_sup XIBUF_0 (
    .in( rb ),
    .out( r ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_7__w_sup XOBUF_1 (
    .in( midp ),
    .out( qb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_7__w_sup XOBUF_0 (
    .in( midn ),
    .out( q ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dll_phasedet_flop_strongarm_1__w_sup(
    input  wire clk,
    input  wire inn,
    input  wire inp,
    input  wire rstlb,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_dll_phasedet_strongarm_frontend_1__w_sup XSA (
    .clk( clk ),
    .inn( inn ),
    .inp( inp ),
    .rstb( rstlb ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_sr_latch_symmetric_1__w_sup XSR (
    .rb( midp ),
    .rsthb( VDD ),
    .rstlb( rstlb ),
    .sb( midn ),
    .q( outp ),
    .qb( outn ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dll_phasedet_inv_8__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_inv_9__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_inv_10__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_inv_11__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_phasedet_passgate_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire s,
    output trireg d,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
wire tmp;

assign #DELAY tmp = VSS ? 1'bx : (~VDD ? 1'b0 : s);

tranif1 XTRN1 (d, tmp, en );
tranif0 XTRN0 (d, tmp, enb);

endmodule


module aib_dll_phasedet_se_to_diff_1__w_sup(
    input  wire in,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

wire midn_inv;
wire midn_pass0;
wire midn_pass1;
wire midp;

aib_dll_phasedet_inv_8__w_sup XINVN0 (
    .in( in ),
    .out( midn_inv ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_9__w_sup XINVN1 (
    .in( midn_inv ),
    .out( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_10__w_sup XINVN2 (
    .in( midp ),
    .out( outn ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_11__w_sup XINVP0 (
    .in( in ),
    .out( midn_pass0 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_10__w_sup XINVP1 (
    .in( midn_pass1 ),
    .out( outp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_passgate_1__w_sup XPASS (
    .en( VDD ),
    .enb( VSS ),
    .s( midn_pass0 ),
    .d( midn_pass1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dll_phasedet__w_sup(
    input  wire CLKA,
    input  wire CLKB,
    input  wire RSTb,
    output wire t_down,
    output wire t_up,
    inout  wire VDD,
    inout  wire VSS
);

wire i_del_n;
wire i_del_p;
wire phase_clk;
wire phase_clkb;
wire [3:0] unused;

aib_dll_phasedet_inv_6__w_sup XDUMD (
    .in( phase_clkb ),
    .out( unused[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_inv_6__w_sup XDUMU (
    .in( i_del_p ),
    .out( unused[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_flop_strongarm_1__w_sup XFLOPD (
    .clk( i_del_n ),
    .inn( phase_clk ),
    .inp( phase_clkb ),
    .rstlb( RSTb ),
    .outn( unused[2] ),
    .outp( t_down ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_flop_strongarm_1__w_sup XFLOPU (
    .clk( phase_clk ),
    .inn( i_del_n ),
    .inp( i_del_p ),
    .rstlb( RSTb ),
    .outn( unused[1] ),
    .outp( t_up ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_se_to_diff_1__w_sup XSED (
    .in( CLKB ),
    .outn( phase_clkb ),
    .outp( phase_clk ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_phasedet_se_to_diff_1__w_sup XSEU (
    .in( CLKA ),
    .outn( i_del_n ),
    .outp( i_del_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dll_phasedet(
    input  wire CLKA,
    input  wire CLKB,
    input  wire RSTb,
    output wire t_down,
    output wire t_up
);

wire VDD_val;
wire VSS_val;

wire t_up_int;
wire t_down_int;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_dll_phasedet__w_sup XDUT (
    .CLKA( CLKA ),
    .CLKB( CLKB ),
    .RSTb( RSTb ),
    .t_down( t_down_int ),
    .t_up( t_up_int ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

// from tttt_25_0p850_0p970
assign #(64, 62) t_up = t_up_int;
assign #(69, 67) t_down = t_down_int;

endmodule
