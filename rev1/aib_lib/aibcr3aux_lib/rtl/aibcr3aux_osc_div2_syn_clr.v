// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_div2_syn_clr, View -
//schematic
// LAST TIME SAVED: Apr 30 15:12:23 2015
// NETLIST TIME: Jun  3 17:00:05 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_div2_syn_clr ( clkout, scan_out, syncrstb,
     vcc_aibcraux, vss_aibcraux, clkin, irstb, scan_clk, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n );

//  `timescale 1ps / 1ps

output  clkout, scan_out, syncrstb;

inout  vcc_aibcraux, vss_aibcraux;

input  clkin, irstb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

wire dff_rstb, scan_modn, scan_rstn, irstb, dff_clk, scnclk, clkin, scanshftn, scanshft, net0141, net0136, net0137, scan_shift_n, net033, net0150, d1, net0144, vcc_aibcraux, scan_clk, syncrstb, scan_rst_n, scan_mode_n, clkout;

reg ss;

/*initial
   begin
      #0 ss=1'b0;
      #1 ss=1'b1;
   end */
// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_div2_syn_clr";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign ss = irstb;
assign dff_rstb = scan_modn ? irstb : scan_rstn;
assign dff_clk = scan_modn ? clkin : scnclk;
aibcr3_ulvt16_2xarstsyncdff1_b2  xsync0 (      .SE(scanshft), .D(1'b1),  .Q(d1),     .CK(net033),  .SI(scan_in), .CLR_N(dff_rstb));
assign scanshftn = ~scanshft;
assign net0141 = ~net0136;
assign net0136 = ~net0137;
assign scanshft = ~scan_shift_n;
assign net033 = scan_modn ? net0141 : scnclk;
assign net0150 = scan_modn ? d1 : scan_rstn;
`ifdef LEC
	assign net0144 = scan_modn ? vcc_aibcraux : scan_rstn;
`else
	assign net0144 = scan_modn ? ss : scan_rstn;
`endif
assign scnclk = scan_clk;
assign syncrstb = net0150;
assign scan_rstn = scan_rst_n;
assign scan_modn = scan_mode_n;
aibcr3aux_osc_ff x5 ( .cdn(net0144), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(net0137), .so(scan_out), .cp(dff_clk), .d(net0136),
     .se_n(scanshftn), .si(d1));
assign clkout = net0137;

endmodule

