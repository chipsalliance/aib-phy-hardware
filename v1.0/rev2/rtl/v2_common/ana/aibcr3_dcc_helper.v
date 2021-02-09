// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dcc_inv_5__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_inv_6__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_inv_chain_1__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire outb;

aib_dcc_inv_5__w_sup XINV0 (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_6__w_sup XINV1 (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_strongarm_frontend_2__w_sup(
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


module aib_dcc_sr_latch_symmetric_core_2__w_sup(
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


module aib_dcc_inv_7__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_sr_latch_symmetric_2__w_sup(
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

aib_dcc_sr_latch_symmetric_core_2__w_sup XCORE (
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

aib_dcc_inv_7__w_sup XIBUF_1 (
    .in( sb ),
    .out( s ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_7__w_sup XIBUF_0 (
    .in( rb ),
    .out( r ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_7__w_sup XOBUF_1 (
    .in( midp ),
    .out( qb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_7__w_sup XOBUF_0 (
    .in( midn ),
    .out( q ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_flop_strongarm_2__w_sup(
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

aib_dcc_strongarm_frontend_2__w_sup XSA (
    .clk( clk ),
    .inn( inn ),
    .inp( inp ),
    .rstb( rstlb ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_sr_latch_symmetric_2__w_sup XSR (
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


module aib_dcc_inv_8__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_inv_tristate_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire in,
    output trireg out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic temp;

always_comb begin
    casez ({en, enb, VDD, VSS})
        4'b1010: temp = ~in;
        4'b0110: temp = 1'bz;
        4'b1110: temp = in ? 1'b0 : 1'bz;
        4'b0010: temp = in ? 1'bz : 1'b1;
        4'b??00: temp = 1'b0;
        default : temp = 1'bx;
    endcase
end

assign #DELAY out = temp;

endmodule


module aib_dcc_current_summer_1__w_sup(
    input  wire [1:0] in,
    output wire out
);

    tran tr0(in[0], out);
    tran tr1(in[1], out);

endmodule


module aib_dcc_mux2to1_matched_1__w_sup(
    input  wire [1:0] in,
    input  wire sel,
    input  wire selb,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire outb;
wire [1:0] outb_s;

aib_dcc_inv_8__w_sup XBUF (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_tristate_1__w_sup XPASS_1 (
    .en( sel ),
    .enb( selb ),
    .in( in[1] ),
    .out( outb_s[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_tristate_1__w_sup XPASS_0 (
    .en( selb ),
    .enb( sel ),
    .in( in[0] ),
    .out( outb_s[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_current_summer_1__w_sup XSUM (
    .in( outb_s[1:0] ),
    .out( outb )
);

endmodule


module aib_dcc_aib_dcc_helper_core_1__w_sup(
    input  wire clk_dcd,
    input  wire dcc_byp,
    input  wire launch,
    input  wire measure,
    input  wire rstlb,
    output wire clk_out,
    inout  wire VDD,
    inout  wire VSS
);

wire clk_dbl;
wire clkn;
wire clkp;
wire dcc_byp_bar;
wire dcc_byp_buf;

aib_dcc_flop_strongarm_2__w_sup XDIV (
    .clk( clk_dbl ),
    .inn( clkp ),
    .inp( clkn ),
    .rstlb( rstlb ),
    .outn( clkn ),
    .outp( clkp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_8__w_sup XINV0 (
    .in( dcc_byp ),
    .out( dcc_byp_bar ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_8__w_sup XINV1 (
    .in( dcc_byp_bar ),
    .out( dcc_byp_buf ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_mux2to1_matched_1__w_sup XMUXI (
    .in( {measure,launch} ),
    .sel( clkp ),
    .selb( clkn ),
    .out( clk_dbl ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_mux2to1_matched_1__w_sup XMUXO (
    .in( {clk_dcd,clkp} ),
    .sel( dcc_byp_buf ),
    .selb( dcc_byp_bar ),
    .out( clk_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_strongarm_frontend_3__w_sup(
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


module aib_dcc_sr_latch_symmetric_core_3__w_sup(
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


module aib_dcc_inv_9__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_sr_latch_symmetric_3__w_sup(
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

aib_dcc_sr_latch_symmetric_core_3__w_sup XCORE (
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

aib_dcc_inv_9__w_sup XIBUF_1 (
    .in( sb ),
    .out( s ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_9__w_sup XIBUF_0 (
    .in( rb ),
    .out( r ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_9__w_sup XOBUF_1 (
    .in( midp ),
    .out( qb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_9__w_sup XOBUF_0 (
    .in( midn ),
    .out( q ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_flop_strongarm_3__w_sup(
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

aib_dcc_strongarm_frontend_3__w_sup XSA (
    .clk( clk ),
    .inn( inn ),
    .inp( inp ),
    .rstb( rstlb ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_sr_latch_symmetric_3__w_sup XSR (
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


module aibcr3_dcc_helper__w_sup(
    input  wire clk_dcd,
    input  wire dcc_byp,
    input  wire launch,
    input  wire measure,
    input  wire rstb,
    output wire ckout,
    inout  wire VDD,
    inout  wire VSS
);

wire [3:0] dumn;
wire [3:0] dump;
wire launch_buf;
wire [3:0] rstlb_n;
wire [3:0] rstlb_p;
wire unused;

aib_dcc_inv_chain_1__w_sup XCKBUF (
    .in( launch ),
    .out( launch_buf ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_aib_dcc_helper_core_1__w_sup XCORE (
    .clk_dcd( clk_dcd ),
    .dcc_byp( dcc_byp ),
    .launch( launch ),
    .measure( measure ),
    .rstlb( rstlb_p[3] ),
    .clk_out( ckout ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_inv_chain_1__w_sup XDUMBUF (
    .in( measure ),
    .out( unused ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XDUMSYNC_3 (
    .clk( VSS ),
    .inn( dumn[2] ),
    .inp( dump[2] ),
    .rstlb( VSS ),
    .outn( dumn[3] ),
    .outp( dump[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XDUMSYNC_2 (
    .clk( VSS ),
    .inn( dumn[1] ),
    .inp( dump[1] ),
    .rstlb( VSS ),
    .outn( dumn[2] ),
    .outp( dump[2] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XDUMSYNC_1 (
    .clk( VSS ),
    .inn( dumn[0] ),
    .inp( dump[0] ),
    .rstlb( VSS ),
    .outn( dumn[1] ),
    .outp( dump[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XDUMSYNC_0 (
    .clk( VSS ),
    .inn( VSS ),
    .inp( VDD ),
    .rstlb( VSS ),
    .outn( dumn[0] ),
    .outp( dump[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XSYNC_3 (
    .clk( launch_buf ),
    .inn( rstlb_n[2] ),
    .inp( rstlb_p[2] ),
    .rstlb( rstb ),
    .outn( rstlb_n[3] ),
    .outp( rstlb_p[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XSYNC_2 (
    .clk( launch_buf ),
    .inn( rstlb_n[1] ),
    .inp( rstlb_p[1] ),
    .rstlb( rstb ),
    .outn( rstlb_n[2] ),
    .outp( rstlb_p[2] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XSYNC_1 (
    .clk( launch_buf ),
    .inn( rstlb_n[0] ),
    .inp( rstlb_p[0] ),
    .rstlb( rstb ),
    .outn( rstlb_n[1] ),
    .outp( rstlb_p[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_flop_strongarm_3__w_sup XSYNC_0 (
    .clk( launch_buf ),
    .inn( VSS ),
    .inp( VDD ),
    .rstlb( rstb ),
    .outn( rstlb_n[0] ),
    .outp( rstlb_p[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dcc_helper(
    input  wire clk_dcd,
    input  wire dcc_byp,
    input  wire launch,
    input  wire measure,
    input  wire rstb,
    output wire ckout
);

wire VDD_val;
wire VSS_val;

wire launch_int;
wire measure_int;
wire clk_dcd_int;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

// from tttt_25_0p850_0p970
assign #(105) launch_int = launch;
assign #(105) measure_int = measure;
assign #(25, 26) clk_dcd_int = clk_dcd;

aibcr3_dcc_helper__w_sup XDUT (
    .clk_dcd( clk_dcd_int ),
    .dcc_byp( dcc_byp ),
    .launch( launch_int ),
    .measure( measure_int ),
    .rstb( rstb ),
    .ckout( ckout ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

endmodule
