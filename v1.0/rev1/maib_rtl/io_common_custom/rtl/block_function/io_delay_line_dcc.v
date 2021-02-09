// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module io_delay_line_dcc (
input            c_in_p,
input            c_in_n,
input      [3:0] r_gray,
input      [3:0] f_gray,
output           c_out_p,
output           c_out_n 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter STEP_DELAY = 40;

reg c_in_del;

wire  [15:0] c_in_p_f;
wire  [15:0] c_in_p_r;

assign #63  c_in_p_f[0] = c_in_p;
assign #67  c_in_p_f[1] = c_in_p;
assign #71  c_in_p_f[2] = c_in_p;
assign #75  c_in_p_f[3] = c_in_p;
assign #79  c_in_p_f[4] = c_in_p;
assign #83  c_in_p_f[5] = c_in_p;
assign #87  c_in_p_f[6] = c_in_p;
assign #91  c_in_p_f[7] = c_in_p;
assign #95  c_in_p_f[8] = c_in_p;
assign #99  c_in_p_f[9] = c_in_p;
assign #103  c_in_p_f[10] = c_in_p;
assign #107  c_in_p_f[11] = c_in_p;
assign #111  c_in_p_f[12] = c_in_p;
assign #115  c_in_p_f[13] = c_in_p;
assign #119  c_in_p_f[14] = c_in_p;
assign #123  c_in_p_f[15] = c_in_p;

assign #63  c_in_p_r[0] = c_in_p;
assign #67  c_in_p_r[1] = c_in_p;
assign #71  c_in_p_r[2] = c_in_p;
assign #75  c_in_p_r[3] = c_in_p;
assign #79  c_in_p_r[4] = c_in_p;
assign #83  c_in_p_r[5] = c_in_p;
assign #87  c_in_p_r[6] = c_in_p;
assign #91  c_in_p_r[7] = c_in_p;
assign #95  c_in_p_r[8] = c_in_p;
assign #99  c_in_p_r[9] = c_in_p;
assign #103  c_in_p_r[10] = c_in_p;
assign #107  c_in_p_r[11] = c_in_p;
assign #111  c_in_p_r[12] = c_in_p;
assign #115  c_in_p_r[13] = c_in_p;
assign #119  c_in_p_r[14] = c_in_p;
assign #123  c_in_p_r[15] = c_in_p;

always @(*)
  if (c_in_p == 1'b0)
    begin
      case (f_gray[3:0])
       4'b0000 : c_in_del =  c_in_p_f[0];
       4'b0001 : c_in_del =  c_in_p_f[1];
       4'b0011 : c_in_del =  c_in_p_f[2];
       4'b0010 : c_in_del =  c_in_p_f[3];
       4'b0110 : c_in_del =  c_in_p_f[4];
       4'b0111 : c_in_del =  c_in_p_f[5];
       4'b0101 : c_in_del =  c_in_p_f[6];
       4'b0100 : c_in_del =  c_in_p_f[7];
       4'b1100 : c_in_del =  c_in_p_f[8];
       4'b1101 : c_in_del =  c_in_p_f[9];
       4'b1111 : c_in_del =  c_in_p_f[10];
       4'b1110 : c_in_del =  c_in_p_f[11];
       4'b1010 : c_in_del =  c_in_p_f[12];
       4'b1011 : c_in_del =  c_in_p_f[13];
       4'b1001 : c_in_del =  c_in_p_f[14];
       4'b1000 : c_in_del =  c_in_p_f[15];
       default : c_in_del =  c_in_p_f[0];
       endcase
    end
  else if (c_in_p == 1'b1)
    begin
      case (r_gray[3:0])
       4'b0000 : c_in_del =   c_in_p_r[0];
       4'b0001 : c_in_del =   c_in_p_r[1];
       4'b0011 : c_in_del =   c_in_p_r[2];
       4'b0010 : c_in_del =   c_in_p_r[3];
       4'b0110 : c_in_del =   c_in_p_r[4];
       4'b0111 : c_in_del =   c_in_p_r[5];
       4'b0101 : c_in_del =   c_in_p_r[6];
       4'b0100 : c_in_del =   c_in_p_r[7];
       4'b1100 : c_in_del =   c_in_p_r[8];
       4'b1101 : c_in_del =   c_in_p_r[9];
       4'b1111 : c_in_del =   c_in_p_r[10];
       4'b1110 : c_in_del =   c_in_p_r[11];
       4'b1010 : c_in_del =   c_in_p_r[12];
       4'b1011 : c_in_del =   c_in_p_r[13];
       4'b1001 : c_in_del =   c_in_p_r[14];
       4'b1000 : c_in_del =   c_in_p_r[15];
       default : c_in_del =   c_in_p_r[0];
       endcase
    end

assign c_out_p =  c_in_del;
assign c_out_n = ~c_in_del;

endmodule

//======================================================================
//	r_dly(f_gray=4'b0)			f_dly(r_gray=4'b0)		
//	wc		tt		bc		wc		tt		bc
//0	8.95E-11	5.99E-11	4.78E-11	9.34E-11	6.25E-11	5.04E-11
//1	9.17E-11	6.20E-11	5.03E-11	9.55E-11	6.45E-11	5.25E-11
//2	9.60E-11	6.53E-11	5.35E-11	9.75E-11	6.67E-11	5.51E-11
//3	9.86E-11	6.81E-11	5.70E-11	1.00E-10	6.93E-11	5.83E-11
//4	1.03E-10	7.21E-11	6.13E-11	1.03E-10	7.22E-11	6.22E-11
//5	1.06E-10	7.58E-11	6.66E-11	1.06E-10	7.57E-11	6.74E-11
//6	1.11E-10	8.06E-11	7.26E-11	1.09E-10	7.98E-11	7.31E-11
//7	1.15E-10	8.57E-11	8.19E-11	1.13E-10	8.49E-11	8.23E-11
//8	1.20E-10	9.18E-11	9.16E-11	1.18E-10	9.06E-11	9.20E-11
//9	1.23E-10	9.51E-11	9.89E-11	1.20E-10	9.39E-11	9.94E-11
//10	1.25E-10	9.90E-11	1.06E-10	1.22E-10	9.73E-11	1.06E-10
//11	1.28E-10	1.03E-10	1.18E-10	1.25E-10	1.01E-10	1.18E-10
//12	1.31E-10	1.08E-10	1.29E-10	1.28E-10	1.06E-10	1.29E-10
//13	1.34E-10	1.13E-10	1.51E-10	1.31E-10	1.11E-10	1.51E-10
//14	1.37E-10	1.18E-10	1.73E-10	1.34E-10	1.16E-10	1.73E-10
//15	1.41E-10	1.25E-10	2.74E-10	1.37E-10	1.23E-10	2.76E-10
// 
