// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog for library verilog/final_custom created by Liberate 13.1.3 on Thu Nov 20 18:25:10 MST 2014 for SDF version 3.0
//
`celldefine

module an_io_double_edge_ff (clk_in, reset_n, test_enable_n, data_in, data_out `ifndef INTCNOPWR ,vcc ,vss `endif);
input  [1:0] clk_in;            // clk_in[0] is p, clk_in[1] is n
input        reset_n;           // Reset active low
input        test_enable_n;     // Reset active low
input  [1:0] data_in;
output [1:0] data_out;          // Complimentary output
reg notifier;

`ifndef INTCNOPWR
input vcc, vss;
`endif
wire [1:0] clk_buf_n;

assign clk_buf_n[1] = ~(test_enable_n & clk_in[1]);
assign clk_buf_n[0] = ~(test_enable_n & clk_in[0]);
wire  delayed_clk_in_1;
wire  delayed_clk_in_0;
wire  delayed_data_in_1;
wire  delayed_data_in_0;

reg  [1:0] lat;
always @(reset_n or clk_buf_n[0] or data_in[0])
  if (~reset_n)          lat[0] <= 1'b0;
  else if (clk_buf_n[0]) lat[0] <= data_in[0];

always @(reset_n or clk_buf_n[1] or data_in[1])
  if (~reset_n)          lat[1] <= 1'b0;
  else if (clk_buf_n[1]) lat[1] <= data_in[1];

assign data_out[0] = (clk_in[0] &  lat[0]) | (clk_in[1] &  lat[1]) | ( lat[0] &  lat[1]);
assign data_out[1] = (clk_in[0] & ~lat[0]) | (clk_in[1] & ~lat[1]) | (~lat[0] & ~lat[1]);
	specify
                if (~test_enable_n) 
	       			(data_in[0] => data_out[1]) = 0;
                if (~test_enable_n) 
                		(data_in[1] => data_out[1]) = 0;
		if (~test_enable_n)
                		(clk_in[0] => data_out[1]) = 0;
		if (test_enable_n)
                		(posedge clk_in[0] => (data_out[1]:data_in[0])) = (0,0);
		if (test_enable_n)
                		(posedge clk_in[1] => (data_out[1]:data_in[1])) = (0,0);
		if (~test_enable_n)
                		(posedge clk_in[1] => (data_out[1]:data_in[1])) = (0,0);
		if (~test_enable_n)
                		(data_in[0] => data_out[0]) = 0;
		if (~test_enable_n)
                		(data_in[1] => data_out[0]) = 0;
		if (~test_enable_n)
                		(clk_in[0] => data_out[0]) = 0;
		if (test_enable_n)
		                (posedge clk_in[0] => (data_out[0]:data_in[0])) = (0,0);
		if (test_enable_n)
                		(posedge clk_in[1] => (data_out[0]:data_in[1])) = (0,0);
		if (~test_enable_n)
                		(posedge clk_in[1] => (data_out[0]:data_in[1])) = (0,0);
		$setuphold (posedge clk_in[1], posedge data_in[1], 0, 0, notifier,,, delayed_clk_in_1, delayed_data_in_1);
		$setuphold (posedge clk_in[1], negedge data_in[1], 0, 0, notifier,,, delayed_clk_in_1, delayed_data_in_1);
		$setuphold (posedge clk_in[0], posedge data_in[0], 0, 0, notifier,,, delayed_clk_in_0, delayed_data_in_0);
		$setuphold (posedge clk_in[0], negedge data_in[0], 0, 0, notifier,,, delayed_clk_in_0, delayed_data_in_0);
		$width (posedge clk_in[1], 0, 0, notifier);
		$width (posedge clk_in[0], 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`celldefine
module an_io_phdet_ff_ln (q, dn, dp, rst_n, clk_p `ifndef INTCNOPWR ,vcc ,vss `endif);
        output q;
        input dn, dp, rst_n, clk_p;
        reg notifier;
        wire delayed_dn, delayed_dp, delayed_clk_p;
`ifndef INTCNOPWR
input vcc, vss;
`endif

        // Function
        wire int_fwire_Iq, int_fwire_r, xcr_0;

        not (int_fwire_r, rst_n);
        altos_dff_r_err (xcr_0, delayed_clk_p, delayed_dp, int_fwire_r);
        altos_dff_r (int_fwire_Iq, notifier, delayed_clk_p, delayed_dp, int_fwire_r, xcr_0);
        buf (q, int_fwire_Iq);

        // Timing
        specify
                (posedge clk_p => (q+:dp)) = 0;
                $setuphold (posedge clk_p, posedge dn, 0, 0, notifier,,, delayed_clk_p, delayed_dn);
                $setuphold (posedge clk_p, negedge dn, 0, 0, notifier,,, delayed_clk_p, delayed_dn);
                $setuphold (posedge clk_p, posedge dp, 0, 0, notifier,,, delayed_clk_p, delayed_dp);
                $setuphold (posedge clk_p, negedge dp, 0, 0, notifier,,, delayed_clk_p, delayed_dp);
                $width (posedge clk_p, 0, 0, notifier);
        endspecify
endmodule
`endcelldefine

// type:  
primitive altos_dff_r_err (q, clk, d, r);
        output q;
        reg q;
        input clk, d, r;

        table
                 ?   0 (0x) : ? : -;
                 ?   0 (x0) : ? : -;
                (0x) ?  0   : ? : 0;
                (0x) 0  x   : ? : 0;
                (1x) ?  0   : ? : 1;
                (1x) 0  x   : ? : 1;
        endtable
endprimitive

primitive altos_dff_r (q, v, clk, d, r, xcr);
        output q;
        reg q;
        input v, clk, d, r, xcr;

        table
                *  ?   ?  ?   ? : ? : x;
                ?  ?   ?  1   ? : ? : 0;
                ?  b   ? (1?) ? : 0 : -;
                ?  x   0 (1?) ? : 0 : -;
                ?  ?   ? (10) ? : ? : -;
                ?  ?   ? (x0) ? : ? : -;
                ?  ?   ? (0x) ? : 0 : -;
                ? (x1) 0  ?   0 : ? : 0;
                ? (x1) 1  0   0 : ? : 1;
                ? (x1) 0  ?   1 : 0 : 0;
                ? (x1) 1  0   1 : 1 : 1;
                ? (x1) ?  ?   x : ? : -;
                ? (bx) 0  ?   ? : 0 : -;
                ? (bx) 1  0   ? : 1 : -;
                ? (x0) 0  ?   ? : ? : -;
                ? (x0) 1  0   ? : ? : -;
                ? (x0) ?  0   x : ? : -;
                ? (01) 0  ?   ? : ? : 0;
                ? (01) 1  0   ? : ? : 1;
                ? (10) ?  ?   ? : ? : -;
                ?  b   *  ?   ? : ? : -;
                ?  ?   ?  ?   * : ? : -;
        endtable
endprimitive

primitive altos_dff_err (q, clk, d);
        output q;
        reg q;
        input clk, d;

        table
                (0x) ? : ? : 0;
                (1x) ? : ? : 1;
        endtable
endprimitive
