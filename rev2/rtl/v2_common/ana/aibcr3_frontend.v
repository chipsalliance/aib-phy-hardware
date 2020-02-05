// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_frontend_inv_14__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_15__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_8__w_sup(
    input  wire in,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_15__w_sup XINV (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_4__w_sup(
    input  wire inn,
    input  wire inp,
    input  wire rst_casc,
    input  wire rst_outn,
    input  wire rst_outp,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic outp_temp;
logic outn_temp;

// add first two lines of casez to eliminate any X output.  This is done to debug innovus
always_comb begin
    casez ({rst_outp, rst_outn, rst_casc, inp, inn, VDD, VSS})
        7'b00_1_00_10: {outp_temp, outn_temp} = 2'b00;
        7'b00_1_11_10: {outp_temp, outn_temp} = 2'b11;
        7'b10_0_??_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_0_??_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_10_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_01_10: {outp_temp, outn_temp} = 2'b01;
        7'b10_1_10_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_1_01_10: {outp_temp, outn_temp} = 2'b10;
        7'b??_?_??_00: {outp_temp, outn_temp} = 2'b00;
        default: {outp_temp, outn_temp} = 2'bxx;
    endcase
end

assign #DELAY outp = outp_temp;
assign #DELAY outn = outn_temp;

endmodule


module aib_frontend_lvshift_core_w_drivers_6__w_sup(
    input  wire in,
    input  wire inb,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_8__w_sup XBUFN (
    .in( midn ),
    .outb( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_chain_8__w_sup XBUFP (
    .in( midp ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_4__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .rst_casc( rst_casc ),
    .rst_outn( rst_outb ),
    .rst_outp( rst_out ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_16__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_9__w_sup(
    input  wire in,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_16__w_sup XINV0 (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_16__w_sup XINV1 (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_chain_10__w_sup(
    input  wire in,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_16__w_sup XINV (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_5__w_sup(
    input  wire inn,
    input  wire inp,
    input  wire rst_casc,
    input  wire rst_outn,
    input  wire rst_outp,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic outp_temp;
logic outn_temp;

// add first two lines of casez to eliminate any X output.  This is done to debug innovus
always_comb begin
    casez ({rst_outp, rst_outn, rst_casc, inp, inn, VDD, VSS})
        7'b00_1_00_10: {outp_temp, outn_temp} = 2'b00;
        7'b00_1_11_10: {outp_temp, outn_temp} = 2'b11;
        7'b10_0_??_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_0_??_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_10_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_01_10: {outp_temp, outn_temp} = 2'b01;
        7'b10_1_10_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_1_01_10: {outp_temp, outn_temp} = 2'b10;
        7'b??_?_??_00: {outp_temp, outn_temp} = 2'b00;
        default: {outp_temp, outn_temp} = 2'bxx;
    endcase
end

assign #DELAY outp = outp_temp;
assign #DELAY outn = outn_temp;

endmodule


module aib_frontend_lvshift_core_w_drivers_7__w_sup(
    input  wire in,
    input  wire inb,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_10__w_sup XBUFN (
    .in( midn ),
    .outb( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_chain_10__w_sup XBUFP (
    .in( midp ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_5__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .rst_casc( rst_casc ),
    .rst_outn( rst_outb ),
    .rst_outp( rst_out ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_4__w_sup(
    input  wire in,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VDD_in,
    inout  wire VSS
);

wire in_buf;
wire inb_buf;

aib_frontend_inv_chain_9__w_sup XBUF (
    .in( in ),
    .out( in_buf ),
    .outb( inb_buf ),
    .VDD( VDD_in ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_7__w_sup XLEV (
    .in( in_buf ),
    .inb( inb_buf ),
    .rst_casc( rst_casc ),
    .rst_out( rst_out ),
    .rst_outb( rst_outb ),
    .out( out ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_17__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_11__w_sup(
    input  wire in,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_17__w_sup XINV (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_6__w_sup(
    input  wire inn,
    input  wire inp,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic outp_temp;
logic outn_temp;

// add first two lines of casez to eliminate any X output.  This is done to debug innovus
always_comb begin
    casez ({inp, inn, VDD, VSS})
        4'b00_10: {outp_temp, outn_temp} = 2'b00;
        4'b11_10: {outp_temp, outn_temp} = 2'b11;
        4'b10_10: {outp_temp, outn_temp} = 2'b10;
        4'b01_10: {outp_temp, outn_temp} = 2'b01;
        4'b??_00: {outp_temp, outn_temp} = 2'b00;
        default: {outp_temp, outn_temp} = 2'bxx;
    endcase
end

assign #DELAY outp = outp_temp;
assign #DELAY outn = outn_temp;

endmodule


module aib_frontend_lvshift_core_w_drivers_8__w_sup(
    input  wire in,
    input  wire inb,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_11__w_sup XBUFN (
    .in( midn ),
    .outb( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_chain_11__w_sup XBUFP (
    .in( midp ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_6__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_18__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_19__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_12__w_sup(
    input  wire in,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_18__w_sup XINV0 (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_19__w_sup XINV1 (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_20__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_13__w_sup(
    input  wire in,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

wire [0:0] mid;
wire out;

aib_frontend_inv_16__w_sup XINV0 (
    .in( in ),
    .out( mid[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_20__w_sup XINV1 (
    .in( mid[0] ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_19__w_sup XINV2 (
    .in( out ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_nand_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_frontend_nor_2__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

   assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~|in );
   

endmodule


module aib_frontend_aib_se2diff_match_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire inn,
    input  wire inp,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

wire nand_out;
wire nor_out;

aib_frontend_inv_chain_13__w_sup XBUFN (
    .in( nor_out ),
    .outb( outn ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_chain_13__w_sup XBUFP (
    .in( nand_out ),
    .outb( outp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_nand_3__w_sup XNAND (
    .in( {en,inp} ),
    .out( nand_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_nor_2__w_sup XNOR (
    .in( {enb,inn} ),
    .out( nor_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_21__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_22__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_23__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_24__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_passgate_1__w_sup(
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


module aib_frontend_se_to_diff_1__w_sup(
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

aib_frontend_inv_21__w_sup XINVN0 (
    .in( in ),
    .out( midn_inv ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_22__w_sup XINVN1 (
    .in( midn_inv ),
    .out( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_23__w_sup XINVN2 (
    .in( midp ),
    .out( outn ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_24__w_sup XINVP0 (
    .in( in ),
    .out( midn_pass0 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_23__w_sup XINVP1 (
    .in( midn_pass1 ),
    .out( outp ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_passgate_1__w_sup XPASS (
    .en( VDD ),
    .enb( VSS ),
    .s( midn_pass0 ),
    .d( midn_pass1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_nand_4__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_frontend_aib_se2diff_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire in,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

wire inb;
wire nc;

aib_frontend_se_to_diff_1__w_sup XCORE (
    .in( inb ),
    .outn( outp ),
    .outp( outn ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_nor_2__w_sup XDUM (
    .in( {enb,VDD} ),
    .out( nc ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_nand_4__w_sup XNAND (
    .in( {en,in} ),
    .out( inb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_aib_rxanlg_core_1__w_sup(
    input  wire clk_en,
    input  wire data_en,
    input  wire iclkn,
    input  wire iopad,
    input  wire por,
    output wire oclkn,
    output wire oclkp,
    output wire odat,
    output wire odat_async,
    output wire por_vccl,
    output wire porb_vccl,
    inout  wire VDDCore,
    inout  wire VDDIO,
    inout  wire VSS
);

wire clk_en_vccl;
wire clk_enb_vccl;
wire data_en_vccl;
wire data_enb_vccl;
wire dumn;
wire dump;
wire oclkn_vccl;
wire oclkp_vccl;
wire odatb;
wire odatn_vccl;
wire odatp_vccl;
wire por_buf;
wire porb_buf;
wire [2:0] unused;

aib_frontend_inv_14__w_sup XDUM (
    .in( VSS ),
    .out( unused[0] ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_inv_14__w_sup XINV (
    .in( odatb ),
    .out( odat_async ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_6__w_sup XLV_CLK (
    .in( oclkp_vccl ),
    .inb( oclkn_vccl ),
    .rst_casc( porb_buf ),
    .rst_out( por_buf ),
    .rst_outb( VSS ),
    .out( oclkp ),
    .outb( oclkn ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_4__w_sup XLV_CLK_EN (
    .in( clk_en ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( clk_en_vccl ),
    .outb( clk_enb_vccl ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_6__w_sup XLV_DATA (
    .in( odatp_vccl ),
    .inb( odatn_vccl ),
    .rst_casc( porb_buf ),
    .rst_out( por_buf ),
    .rst_outb( VSS ),
    .out( odat ),
    .outb( odatb ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_4__w_sup XLV_DATA_EN (
    .in( data_en ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( data_en_vccl ),
    .outb( data_enb_vccl ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_8__w_sup XLV_DUM (
    .in( dump ),
    .inb( dumn ),
    .out( unused[1] ),
    .outb( unused[2] ),
    .VDD( VDDIO ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_8__w_sup XLV_POR (
    .in( por_buf ),
    .inb( porb_buf ),
    .out( por_vccl ),
    .outb( porb_vccl ),
    .VDD( VDDIO ),
    .VSS( VSS )
);

aib_frontend_inv_chain_12__w_sup XPOR (
    .in( por ),
    .out( por_buf ),
    .outb( porb_buf ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_inv_chain_12__w_sup XPOR_DUM (
    .in( VSS ),
    .out( dump ),
    .outb( dumn ),
    .VDD( VDDCore ),
    .VSS( VSS )
);

aib_frontend_aib_se2diff_match_1__w_sup XSE_CLK (
    .en( clk_en_vccl ),
    .enb( clk_enb_vccl ),
    .inn( iclkn ),
    .inp( iopad ),
    .outn( oclkn_vccl ),
    .outp( oclkp_vccl ),
    .VDD( VDDIO ),
    .VSS( VSS )
);

aib_frontend_aib_se2diff_1__w_sup XSE_DATA (
    .en( data_en_vccl ),
    .enb( data_enb_vccl ),
    .in( iopad ),
    .outn( odatn_vccl ),
    .outp( odatp_vccl ),
    .VDD( VDDIO ),
    .VSS( VSS )
);

endmodule


module aib_frontend_aib_driver_pu_pd_2__w_sup(
    input  wire pden,
    input  wire puenb,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

    logic out_temp;

    always_comb begin
        // puenb connects to PMOS, pden connects to NMOS
        casez ({VDD, VSS, puenb, pden})
           4'b10_00: out_temp = 1'b1;
           4'b10_01: out_temp = 1'bx;
           4'b10_10: out_temp = 1'bz;
           4'b10_11: out_temp = 1'b0;
           4'b00_??: out_temp = 1'b0;
           default:  out_temp = 1'bx;
        endcase
    end

    assign (weak0, weak1) out = out_temp;

endmodule


module aib_frontend_current_summer_1__w_sup(
    input  wire [6:0] in,
    output wire out
);

    tran tr0(in[0], out);
    tran tr1(in[1], out);
    tran tr2(in[2], out);
    tran tr3(in[3], out);
    tran tr4(in[4], out);
    tran tr5(in[5], out);
    tran tr6(in[6], out);

endmodule


module aib_frontend_nand_5__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_frontend_nor_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

   assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~|in );
   

endmodule


module aib_frontend_aib_driver_pu_pd_3__w_sup(
    input  wire pden,
    input  wire puenb,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

    logic out_temp;

    always_comb begin
        // puenb connects to PMOS, pden connects to NMOS
        casez ({VDD, VSS, puenb, pden})
           4'b10_00: out_temp = 1'b1;
           4'b10_01: out_temp = 1'bx;
           4'b10_10: out_temp = 1'bz;
           4'b10_11: out_temp = 1'b0;
           4'b00_??: out_temp = 1'b0;
           default:  out_temp = 1'bx;
        endcase
    end

    assign out = out_temp;

endmodule


module aib_frontend_aib_driver_output_unit_cell_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire nand_pu;
wire nor_pd;

aib_frontend_nand_5__w_sup XNAND (
    .in( {en,in} ),
    .out( nand_pu ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_nor_3__w_sup XNOR (
    .in( {enb,in} ),
    .out( nor_pd ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_pu_pd_3__w_sup Xpupd (
    .pden( nor_pd ),
    .puenb( nand_pu ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_aib_driver_output_driver_1__w_sup(
    input  wire din,
    input  wire [1:0] n_enb_drv,
    input  wire [1:0] p_en_drv,
    input  wire tristate,
    input  wire tristateb,
    input  wire weak_pden,
    input  wire weak_puenb,
    output wire txpadout,
    inout  wire VDD,
    inout  wire VSS
);

wire [6:0] txpadout_tmp;

aib_frontend_aib_driver_pu_pd_2__w_sup XPUPD (
    .pden( weak_pden ),
    .puenb( weak_puenb ),
    .out( txpadout_tmp[6] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_current_summer_1__w_sup XSUM (
    .in( txpadout_tmp[6:0] ),
    .out( txpadout )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_5 (
    .en( p_en_drv[0] ),
    .enb( n_enb_drv[0] ),
    .in( din ),
    .out( txpadout_tmp[5] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_4 (
    .en( p_en_drv[1] ),
    .enb( n_enb_drv[1] ),
    .in( din ),
    .out( txpadout_tmp[4] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_3 (
    .en( p_en_drv[1] ),
    .enb( n_enb_drv[1] ),
    .in( din ),
    .out( txpadout_tmp[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_2 (
    .en( tristateb ),
    .enb( tristate ),
    .in( din ),
    .out( txpadout_tmp[2] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_1 (
    .en( tristateb ),
    .enb( tristate ),
    .in( din ),
    .out( txpadout_tmp[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_aib_driver_output_unit_cell_1__w_sup XUNIT_0 (
    .en( tristateb ),
    .enb( tristate ),
    .in( din ),
    .out( txpadout_tmp[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_25__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_26__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_14__w_sup(
    input  wire in,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_25__w_sup XINV0 (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_inv_26__w_sup XINV1 (
    .in( outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_inv_27__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_frontend_inv_chain_15__w_sup(
    input  wire in,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

aib_frontend_inv_27__w_sup XINV (
    .in( in ),
    .out( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_7__w_sup(
    input  wire inn,
    input  wire inp,
    input  wire rst_casc,
    input  wire rst_outn,
    input  wire rst_outp,
    output wire outn,
    output wire outp,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic outp_temp;
logic outn_temp;

// add first two lines of casez to eliminate any X output.  This is done to debug innovus
always_comb begin
    casez ({rst_outp, rst_outn, rst_casc, inp, inn, VDD, VSS})
        7'b00_1_00_10: {outp_temp, outn_temp} = 2'b00;
        7'b00_1_11_10: {outp_temp, outn_temp} = 2'b11;
        7'b10_0_??_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_0_??_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_10_10: {outp_temp, outn_temp} = 2'b10;
        7'b00_1_01_10: {outp_temp, outn_temp} = 2'b01;
        7'b10_1_10_10: {outp_temp, outn_temp} = 2'b01;
        7'b01_1_01_10: {outp_temp, outn_temp} = 2'b10;
        7'b??_?_??_00: {outp_temp, outn_temp} = 2'b00;
        default: {outp_temp, outn_temp} = 2'bxx;
    endcase
end

assign #DELAY outp = outp_temp;
assign #DELAY outn = outn_temp;

endmodule


module aib_frontend_lvshift_core_w_drivers_9__w_sup(
    input  wire in,
    input  wire inb,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_15__w_sup XBUFN (
    .in( midn ),
    .outb( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_7__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .rst_casc( rst_casc ),
    .rst_outn( rst_outb ),
    .rst_outp( rst_out ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_5__w_sup(
    input  wire in,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    inout  wire VDD,
    inout  wire VDD_in,
    inout  wire VSS
);

wire in_buf;
wire inb_buf;

aib_frontend_inv_chain_14__w_sup XBUF (
    .in( in ),
    .out( in_buf ),
    .outb( inb_buf ),
    .VDD( VDD_in ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_9__w_sup XLEV (
    .in( in_buf ),
    .inb( inb_buf ),
    .rst_casc( rst_casc ),
    .rst_out( rst_out ),
    .rst_outb( rst_outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_w_drivers_10__w_sup(
    input  wire in,
    input  wire inb,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire outb,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_10__w_sup XBUFP (
    .in( midp ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_5__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .rst_casc( rst_casc ),
    .rst_outn( rst_outb ),
    .rst_outp( rst_out ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_6__w_sup(
    input  wire in,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    output wire outb,
    inout  wire VDD,
    inout  wire VDD_in,
    inout  wire VSS
);

wire in_buf;
wire inb_buf;

aib_frontend_inv_chain_9__w_sup XBUF (
    .in( in ),
    .out( in_buf ),
    .outb( inb_buf ),
    .VDD( VDD_in ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_10__w_sup XLEV (
    .in( in_buf ),
    .inb( inb_buf ),
    .rst_casc( rst_casc ),
    .rst_out( rst_out ),
    .rst_outb( rst_outb ),
    .outb( outb ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_core_w_drivers_11__w_sup(
    input  wire in,
    input  wire inb,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire midn;
wire midp;

aib_frontend_inv_chain_10__w_sup XBUFN (
    .in( midn ),
    .outb( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_5__w_sup XCORE (
    .inn( inb ),
    .inp( in ),
    .rst_casc( rst_casc ),
    .rst_outn( rst_outb ),
    .rst_outp( rst_out ),
    .outn( midn ),
    .outp( midp ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_lvshift_7__w_sup(
    input  wire in,
    input  wire rst_casc,
    input  wire rst_out,
    input  wire rst_outb,
    output wire out,
    inout  wire VDD,
    inout  wire VDD_in,
    inout  wire VSS
);

wire in_buf;
wire inb_buf;

aib_frontend_inv_chain_9__w_sup XBUF (
    .in( in ),
    .out( in_buf ),
    .outb( inb_buf ),
    .VDD( VDD_in ),
    .VSS( VSS )
);

aib_frontend_lvshift_core_w_drivers_11__w_sup XLEV (
    .in( in_buf ),
    .inb( inb_buf ),
    .rst_casc( rst_casc ),
    .rst_out( rst_out ),
    .rst_outb( rst_outb ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_frontend_aib_txanlg_core_1__w_sup(
    input  wire din,
    input  wire [1:0] indrv_buf,
    input  wire [1:0] ipdrv_buf,
    input  wire itx_en_buf,
    input  wire por_vccl,
    input  wire porb_vccl,
    input  wire weak_pulldownen,
    input  wire weak_pullupenb,
    output wire txpadout,
    inout  wire VDDCore,
    inout  wire VDDIO,
    inout  wire VSS
);

wire din_io;
wire [1:0] nen_drv_io;
wire [1:0] nen_drvb_io;
wire pden_io;
wire [1:0] pen_drv_io;
wire puenb_io;
wire tristate_io;
wire tristateb_io;

aib_frontend_aib_driver_output_driver_1__w_sup XDRV (
    .din( din_io ),
    .n_enb_drv( nen_drvb_io[1:0] ),
    .p_en_drv( pen_drv_io[1:0] ),
    .tristate( tristate_io ),
    .tristateb( tristateb_io ),
    .weak_pden( pden_io ),
    .weak_puenb( puenb_io ),
    .txpadout( txpadout ),
    .VDD( VDDIO ),
    .VSS( VSS )
);

aib_frontend_lvshift_5__w_sup XLV_DIN (
    .in( din ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( din_io ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_4__w_sup XLV_ITX_EN (
    .in( itx_en_buf ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( tristateb_io ),
    .outb( tristate_io ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_6__w_sup XLV_NDRV_1 (
    .in( indrv_buf[1] ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( nen_drv_io[1] ),
    .outb( nen_drvb_io[1] ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_6__w_sup XLV_NDRV_0 (
    .in( indrv_buf[0] ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( nen_drv_io[0] ),
    .outb( nen_drvb_io[0] ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_7__w_sup XLV_PD (
    .in( weak_pulldownen ),
    .rst_casc( porb_vccl ),
    .rst_out( VSS ),
    .rst_outb( por_vccl ),
    .out( pden_io ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_7__w_sup XLV_PDRV_1 (
    .in( ipdrv_buf[1] ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( pen_drv_io[1] ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_7__w_sup XLV_PDRV_0 (
    .in( ipdrv_buf[0] ),
    .rst_casc( porb_vccl ),
    .rst_out( por_vccl ),
    .rst_outb( VSS ),
    .out( pen_drv_io[0] ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

aib_frontend_lvshift_7__w_sup XLV_PU (
    .in( weak_pullupenb ),
    .rst_casc( porb_vccl ),
    .rst_out( VSS ),
    .rst_outb( por_vccl ),
    .out( puenb_io ),
    .VDD( VDDIO ),
    .VDD_in( VDDCore ),
    .VSS( VSS )
);

endmodule


module aib_frontend_aib_frontend_core_1__w_sup(
    input  wire clk_en,
    input  wire data_en,
    input  wire din,
    input  wire iclkn,
    input  wire [1:0] indrv_buf,
    input  wire [1:0] ipdrv_buf,
    input  wire itx_en_buf,
    input  wire por,
    input  wire rxpadin,
    input  wire weak_pulldownen,
    input  wire weak_pullupenb,
    output wire oclkn,
    output wire oclkp,
    output wire odat,
    output wire odat_async,
    output wire txpadout,
    inout  wire VDDCore,
    inout  wire VDDIO,
    inout  wire VSS
);

wire por_vccl;
wire porb_vccl;

aib_frontend_aib_rxanlg_core_1__w_sup XRX (
    .clk_en( clk_en ),
    .data_en( data_en ),
    .iclkn( iclkn ),
    .iopad( rxpadin ),
    .por( por ),
    .oclkn( oclkn ),
    .oclkp( oclkp ),
    .odat( odat ),
    .odat_async( odat_async ),
    .por_vccl( por_vccl ),
    .porb_vccl( porb_vccl ),
    .VDDCore( VDDCore ),
    .VDDIO( VDDIO ),
    .VSS( VSS )
);

aib_frontend_aib_txanlg_core_1__w_sup XTX (
    .din( din ),
    .indrv_buf( indrv_buf[1:0] ),
    .ipdrv_buf( ipdrv_buf[1:0] ),
    .itx_en_buf( itx_en_buf ),
    .por_vccl( por_vccl ),
    .porb_vccl( porb_vccl ),
    .weak_pulldownen( weak_pulldownen ),
    .weak_pullupenb( weak_pullupenb ),
    .txpadout( txpadout ),
    .VDDCore( VDDCore ),
    .VDDIO( VDDIO ),
    .VSS( VSS )
);

endmodule


module aib_frontend_metal_short_m6_1__w_sup(
    inout  wire MINUS,
    inout  wire PLUS
);

    tran tr(PLUS, MINUS);

endmodule


module aib_frontend_esd_diode_ndio_1__w_sup(
    inout  wire MINUS,
    inout  wire PLUS
);

always @(PLUS) begin
    if(PLUS===1'bz) $display("ESD ndio error: PLUS port is 1'bz");
end

endmodule


module aib_frontend_esd_diode_pdio_1__w_sup(
    inout  wire MINUS,
    inout  wire PLUS
);

always @(MINUS) begin
    if(MINUS===1'bz) $display("ESD pdio error: MINUS port is 1'bz");
end

endmodule


module aibcr3_frontend__w_sup(
    input  wire clk_en,
    input  wire data_en,
    input  wire din,
    input  wire iclkn,
    input  wire [1:0] indrv_buf,
    input  wire [1:0] ipdrv_buf,
    input  wire itx_en_buf,
    input  wire por,
    input  wire weak_pulldownen,
    input  wire weak_pullupenb,
    output wire iopad_out,
    output wire oclkn,
    output wire oclkp,
    output wire odat,
    output wire odat_async,
    inout  wire VDDCore,
    inout  wire VDDIO,
    inout  wire VSS,
    inout  wire iopad
);

aib_frontend_aib_frontend_core_1__w_sup XFE (
    .clk_en( clk_en ),
    .data_en( data_en ),
    .din( din ),
    .iclkn( iclkn ),
    .indrv_buf( indrv_buf[1:0] ),
    .ipdrv_buf( ipdrv_buf[1:0] ),
    .itx_en_buf( itx_en_buf ),
    .por( por ),
    .rxpadin( iopad_out ),
    .weak_pulldownen( weak_pulldownen ),
    .weak_pullupenb( weak_pullupenb ),
    .oclkn( oclkn ),
    .oclkp( oclkp ),
    .odat( odat ),
    .odat_async( odat_async ),
    .txpadout( iopad ),
    .VDDCore( VDDCore ),
    .VDDIO( VDDIO ),
    .VSS( VSS )
);

aib_frontend_metal_short_m6_1__w_sup XMS (
    .MINUS( iopad_out ),
    .PLUS( iopad )
);

aib_frontend_esd_diode_ndio_1__w_sup XND (
    .MINUS( iopad ),
    .PLUS( VSS )
);

aib_frontend_esd_diode_pdio_1__w_sup XPD (
    .MINUS( VDDIO ),
    .PLUS( iopad )
);

endmodule


module aibcr3_frontend(
    input  wire clk_en,
    input  wire data_en,
    input  wire din,
    input  wire iclkn,
    input  wire [1:0] indrv_buf,
    input  wire [1:0] ipdrv_buf,
    input  wire itx_en_buf,
    input  wire por,
    input  wire weak_pulldownen,
    input  wire weak_pullupenb,
    output wire iopad_out,
    output wire oclkn,
    output wire oclkp,
    output wire odat,
    output wire odat_async,
    inout  wire iopad
);

wire VDDCore_val;
wire VDDIO_val;
wire VSS_val;

wire odat_int;
wire odat_async_int;
wire oclkp_int;
wire oclkn_int;

assign VDDCore_val = 1'b1;
assign VDDIO_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_frontend__w_sup XDUT (
    .clk_en( clk_en ),
    .data_en( data_en ),
    .din( din ),
    .iclkn( iclkn ),
    .indrv_buf( indrv_buf ),
    .ipdrv_buf( ipdrv_buf ),
    .itx_en_buf( itx_en_buf ),
    .por( por ),
    .weak_pulldownen( weak_pulldownen ),
    .weak_pullupenb( weak_pullupenb ),
    .iopad_out( iopad_out ),
    .oclkn( oclkn_int ),
    .oclkp( oclkp_int ),
    .odat( odat_int ),
    .odat_async( odat_async_int ),
    .VDDCore( VDDCore_val ),
    .VDDIO( VDDIO_val ),
    .VSS( VSS_val ),
    .iopad( iopad )
);


// from tttt_25_0p850_0p970
assign #(42, 55) odat = odat_int;
assign #(56, 56) odat_async = odat_async_int;
assign #(40, 55) oclkp = oclkp_int;
assign #(48, 48) oclkn = oclkn_int;

endmodule
