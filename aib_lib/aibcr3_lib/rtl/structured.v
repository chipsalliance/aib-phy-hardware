// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module sa_invg0_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg1_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg2_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg2_hs_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg4_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg4_hs_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg8_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg0_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg1_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg2_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg2_hs_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg4_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg4_hs_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_invg8_elvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = ~in ;
  
endmodule

module sa_buf00_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = in ;
  
endmodule

module sa_buf01_ulvt ( in, out, vccesa, vssesa );

  input in;
  output out;
  input vssesa;
  input vccesa;
  
  assign out = in ;
  
endmodule

module sa_nd2g1_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb) ;
  
endmodule

module sa_nd3g1_ulvt( out, ina, inb, inc , vccesa, vssesa );

  output out;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb && inc ) ;
  
endmodule

module sa_nd4g1_ulvt( out, ina, inb, inc , ind,  vccesa, vssesa );

  output out;
  input ind;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb && inc && ind ) ;
  
endmodule

module sa_nd2g1_elvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb) ;
  
endmodule

module sa_nd3g1_elvt( out, ina, inb, inc , vccesa, vssesa );

  output out;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb && inc ) ;
  
endmodule

module sa_nd4g1_elvt( out, ina, inb, inc , ind,  vccesa, vssesa );

  output out;
  input ind;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb && inc && ind ) ;
  
endmodule

module sa_nr2g1_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb) ;
  
endmodule

module sa_nr3g1_ulvt( out, ina, inb, inc , vccesa, vssesa );

  output out;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb || inc ) ;
  
endmodule

module sa_nr4g1_ulvt( out, ina, inb, inc , ind,  vccesa, vssesa );

  output out;
  input ind;
  input inc;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb || inc || ind ) ;
  
endmodule

module sa_nr2g1_elvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb) ;
  
endmodule

module sa_nd2_hs_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb) ;
  
endmodule

module sa_nr2_hs_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb) ;
  
endmodule

module sa_nd2_cl_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina && inb) ;
  
endmodule

module sa_nr2_cl_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ~(ina || inb) ;
  
endmodule

module sa_xnr2_hs_ulvt( out, ina, inb, vccesa, vssesa );

  output out;
  input inb;
  input vssesa;
  input ina;
  input vccesa;
  
  assign out = ina ~^ inb ;
  
endmodule

module sa_xor2_hs_ulvt( out, outb, ina_p, ina_n, inb_p, inb_n, vccesa, vssesa );

  output out;
  output outb;
  input inb_p;
  input inb_n;
  input vssesa;
  input ina_p;
  input ina_n;
  input vccesa;
  
//  assign out = ((ina_p ~^ ~ina_n) && (inb_p ~^ ~inb_n )) ? ina_p ^ inb_p : 1'bx  ;
//  assign outb = ((ina_p ~^ ~ina_n) && (inb_p ~^ ~inb_n )) ? ~out : 1'bx ;
  assign out = ina_p ^ inb_p ;
  assign outb = ~out ;

endmodule



//==========================================================================================
module sa_frncnp_elvt ( q, qn, clk, d, nclr, npre, vccesa, vssesa );

  output qn;
  output q;
  input nclr;
  input npre;
  input d;
  input clk;
  inout vssesa;
  inout vccesa;

  reg q;

  always @ (posedge clk or negedge nclr or negedge npre) begin
     if (~nclr)
        q <= 1'b0;
     else if (~npre)
        q <= 1'b1;
     else
        q <= d;
  end
  assign qn = ~q;

endmodule


//==========================================================================================
module sa_frncnp_ulvt ( q, qn, clk, d, nclr, npre, vccesa, vssesa );

  output qn;
  output q;
  input nclr;
  input npre;
  input d;
  input clk;
  inout vssesa;
  inout vccesa;

  reg q;

  always @ (posedge clk or negedge nclr or negedge npre) begin
    if (~nclr)
       q <= 1'b0;
    else if (~npre)
       q <= 1'b1;
    else
       q <= d;
  end
  assign qn = ~q;

endmodule


//==========================================================================================
module sa_frnc_ulvt ( q, clk, d, nclr, vccesa, vssesa );

  output q;
  input nclr;
  input d;
  input clk;
  inout vssesa;
  inout vccesa;

  reg q;

  always @ (posedge clk or negedge nclr) begin
    if (~nclr)
       q <= 1'b0;
    else
       q <= d;
  end

endmodule


//==========================================================================================
module sa_frnc_ulvt_hp ( q, clk, d, nclr, vccesa, vssesa );

  output q;
  input nclr;
  input d;
  input clk;
  inout vssesa;
  inout vccesa;

  reg q;

  always @ (posedge clk or negedge nclr) begin
    if (~nclr)
       q <= 1'b0;
    else
       q <= d;
  end

endmodule


//==========================================================================================
module sa_sdff_1x ( out, outb, clk, d, vccesa, vssesa );

  inout out;
  inout outb;
  input d;
  input clk;
  inout vssesa;
  inout vccesa;

  reg tmp;

  always @ (posedge clk) begin
     tmp <= d;
  end
  assign out  = (clk)? tmp:1'bz;
  assign outb = (clk)?~tmp:1'bz;

endmodule


//==========================================================================================
module sa_sdffrr_1x ( out, outb, clk, d, db, rst_n, vccesa, vssesa );

  input rst_n;
  output out;
  output outb;
  input d;
  input clk;
  inout vssesa;
  input db;
  inout vccesa;
  
  reg out;

  always @ (posedge clk or negedge rst_n) begin
     out <= (!rst_n)?1'b0:((db!=d)?d:1'bx);
  end
  assign outb = ~out;

endmodule


//==========================================================================================
module sa_sdffrr_1x_tx ( out, outb, clk, d, db, rst_n, vccesa, vssesa );

  input rst_n;
  output out;
  output outb;
  input d;
  input clk;
  inout vssesa;
  input db;
  inout vccesa;

  reg out;

  always @ (posedge clk or negedge rst_n) begin
     out <= (!rst_n)?1'b0:((db!=d)?d:1'bx);
  end
  assign outb = ~out;

endmodule


//==========================================================================================
module sa_sdffrr ( out, outb, clk, d, db, rst_n, vccesa, vssesa );

  input rst_n;
  output out;
  output outb;
  input d;
  input clk;
  inout vssesa;
  input db;
  inout vccesa;

  reg out;

  always @ (posedge clk or negedge rst_n) begin
     out <= (!rst_n)?1'b0:((db!=d)?d:1'bx);
  end
  assign outb = ~out;

endmodule


//==========================================================================================
module sa_sdl_en_2x ( out, outb, clk, d, db, en, vccesa, vssesa );

  inout out;
  inout outb;
  input d;
  input en;
  input clk;
  inout vssesa;
  input db;
  inout vccesa;

  reg tmp;
  wire ck;

  assign ck = clk&en;
  always @ (posedge ck) begin
     tmp <= (db!=d)?d:1'bx;
  end
  assign out  = (ck)? tmp:1'bz;
  assign outb = (ck)?~tmp:1'bz;

endmodule


//==========================================================================================






module sa_triinv1_ulvt ( en, in, out, vccesa, vssesa );

  output out;
  input in;
  input en;
  inout vssesa;
  inout vccesa;

  wire out;
  
  assign out = (en) ? ~in : 1'bz;
  
endmodule


module sa_triinv2_ulvt ( en, in, out, vccesa, vssesa );

  output out;
  input in;
  input en;
  inout vssesa;
  inout vccesa;

  wire out;
  
  assign out = (en) ? ~in : 1'bz;
  
endmodule


module sa_triinv2_elvt ( en, in, out, vccesa, vssesa );

  output out;
  input in;
  input en;
  inout vssesa;
  inout vccesa;
  
  wire out;

  assign out = (en) ? ~in : 1'bz;
  
endmodule


module sa_muxnd21_ulvt ( in0, in1, en0, en1, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input en0;
  input en1;
  inout vssesa;
  inout vccesa;
  
  reg out;

  always @ (en0, en1, in0, in1)
  case ({en1, en0})
  2'b00 : out = 1'b0;
  2'b01 : out = in0;
  2'b10 : out = in1;
  2'b11 : out = ~(~in1 && ~in0);
  endcase
  
endmodule


module sa_muxnd41_ulvt ( in0, in1, in2, in3, en0, en1, en2, en3, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input in3;
  input en0;
  input en1;
  input en2;
  input en3;
  inout vssesa;
  inout vccesa;
  
  wire out;

  wire in0_temp , in1_temp , in2_temp , in3_temp;

     assign in0_temp = (en0) ? ~in0 : 1'b1;
     assign in1_temp = (en1) ? ~in1 : 1'b1;
     assign in2_temp = (en2) ? ~in2 : 1'b1;
     assign in3_temp = (en3) ? ~in3 : 1'b1;

     assign out = ~(in0_temp && in1_temp && in2_temp && in3_temp);

endmodule


module sa_muxnd21_buf_ulvt ( in0, in1, en0, en1, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input en0;
  input en1;
  inout vssesa;
  inout vccesa;
  
  reg out;

  always @ (en0, en1, in0, in1)
  case ({en1, en0})
  2'b00 : out = 1'b0;
  2'b01 : out = in0;
  2'b10 : out = in1;
  2'b11 : out = ~(~in1 && ~in0);
  endcase
  
endmodule


module sa_muxnd41_buf_ulvt ( in0, in1, in2, in3, en0, en1, en2, en3, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input in3;
  input en0;
  input en1;
  input en2;
  input en3;
  inout vssesa;
  inout vccesa;
  
  wire out;

  wire in0_temp , in1_temp , in2_temp , in3_temp;

     assign in0_temp = (en0) ? ~in0 : 1'b1;
     assign in1_temp = (en1) ? ~in1 : 1'b1;
     assign in2_temp = (en2) ? ~in2 : 1'b1;
     assign in3_temp = (en3) ? ~in3 : 1'b1;

     assign out = ~(in0_temp && in1_temp && in2_temp && in3_temp);

endmodule


module sa_muxpas21_ulvt ( in0, in1, en0, en1, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input en0;
  input en1;
  inout vssesa;
  inout vccesa;
  
  reg out;

  always @ (en0, en1, in0, in1)
  case ({en1, en0})
  2'b00 : out = 1'bz;
  2'b01 : out = in0;
  2'b10 : out = in1;
  default : out = 1'bx;
  endcase
  
endmodule


module sa_muxpas41_ulvt ( in0, in1, in2, in3, en0, en1, en2, en3, out, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input in3;
  input en0;
  input en1;
  input en2;
  input en3;
  inout vssesa;
  inout vccesa;
  
  reg out;

  always @ (en0, en1, en2, en3, in0, in1, in2, in3)
  case ({en3, en2, en1, en0})
  4'b0000 : out = 1'bz;
  4'b0001 : out = in0;
  4'b0010 : out = in1;
  4'b0100 : out = in2;
  4'b1000 : out = in3;
  default : out = 1'bx;
  endcase

endmodule


module sa_muxtri21_ulvt ( in0, in1, en0, en1, out, pd, pdb, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input en0;
  input en1;
  input pd;
  input pdb;
  inout vssesa;
  inout vccesa;
  
  wire out;
  reg outb;

  always @ (en0, en1, in0, in1, pd, pdb)
  case ({pdb, pd})
  2'b00 : outb = 1'b1;
  2'b01 : outb = 1'bx;
  2'b10 :
	case ({en1, en0})
	2'b00 : outb = 1'bz;
	2'b01 : outb = ~in0;
	2'b10 : outb = ~in1;
	2'b11 : outb = 1'bx;
	endcase
  2'b11 : outb = 1'b0;
  endcase

  assign out = ~outb;

endmodule


module sa_muxtri31_ulvt ( in0, in1, in2, en0, en1, en2, out, pd, pdb, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input en0;
  input en1;
  input en2;
  input pd;
  input pdb;
  inout vssesa;
  inout vccesa;
  
  wire out;
  reg outb;

  always @ (en0, en1, en2, in0, in1, in2, pd, pdb)
  case ({pdb, pd})
  2'b00 : outb = 1'b1;
  2'b01 : outb = 1'bx;
  2'b10 :
	case ({en2, en1, en0})
	3'b000 : outb = 1'bz;
	3'b001 : outb = ~in0;
	3'b010 : outb = ~in1;
	3'b100 : outb = ~in2;
	default : outb = 1'bx;
  	endcase
  2'b11 : outb = 1'b0;
  endcase

  assign out = ~outb;
  
endmodule


module sa_muxtri41_ulvt ( in0, in1, in2, in3, en0, en1, en2, en3, out, pd, pdb, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input in3;
  input en0;
  input en1;
  input en2;
  input en3;
  input pd;
  input pdb;
  inout vssesa;
  inout vccesa;
  
  wire out;
  reg outb;

  always @ (en0, en1, en2, en3, in0, in1, in2, in3, pd, pdb)
  case ({pdb, pd})
  2'b00 : outb = 1'b1;
  2'b01 : outb = 1'bx;
  2'b10 :
	case ({en3, en2, en1, en0})
	4'b0000 : outb = 1'bz;
	4'b0001 : outb = ~in0;
	4'b0010 : outb = ~in1;
	4'b0100 : outb = ~in2;
	4'b1000 : outb = ~in3;
	default : outb = 1'bx;
	endcase
  2'b11 : outb = 1'b0;
  endcase

  assign out = ~outb;
  
endmodule


module sa_muxtri81_ulvt ( in0, in1, in2, in3,in4, in5, in6, in7, en0, en1, en2, en3, en4, en5, en6, en7, out, pd, pdb, vccesa, vssesa );

  output out;
  input in0;
  input in1;
  input in2;
  input in3;
  input in4;
  input in5;
  input in6;
  input in7;
  input en0;
  input en1;
  input en2;
  input en3;
  input en4;
  input en5;
  input en6;
  input en7;
  input pd;
  input pdb;
  inout vssesa;
  inout vccesa;
  
  wire out;
  reg outb;

  always @ (en0, en1, en2, en3, en4, en5, en6, en7, in0, in1, in2, in3, in4, in5, in6, in7, pd, pdb)
  case ({pdb, pd})
  2'b00 : outb = 1'b1;
  2'b01 : outb = 1'bx;
  2'b10 :
	case ({en7, en6, en5, en4, en3, en2, en1, en0})
	8'b00000000 : outb = 1'bz;
	8'b00000001 : outb = ~in0;
	8'b00000010 : outb = ~in1;
	8'b00000100 : outb = ~in2;
	8'b00001000 : outb = ~in3;
	8'b00010000 : outb = ~in4;
	8'b00100000 : outb = ~in5;
	8'b01000000 : outb = ~in6;
	8'b10000000 : outb = ~in7;
	default : outb = 1'bx;
	endcase
  2'b11 : outb = 1'b0;
  endcase

  assign out = ~outb;
  
endmodule


module sa_txgate_ulvt ( en, in, out, vccesa, vssesa );

  output out;
  input in;
  input en;
  inout vssesa;
  inout vccesa;

  wire out;

  assign out = (en) ? in : 1'bz;
  
endmodule


module sa_txgate_elvt ( en, in, out, vccesa, vssesa );

  output out;
  input in;
  input en;
  inout vssesa;
  inout vccesa;

  wire out;

  assign out = (en) ? in : 1'bz;
  
endmodule



module sa_lvshift_ulvt ( i, ib, o, ob, vccesa, vssesa );

  output o;
  output ob;
  input i;
  input ib;
  inout vssesa;
  inout vccesa;
  
  wire o;

  assign o = (i > ib) ? 1'b1 : 1'b0;
  assign ob = ~o;
  
endmodule

module sa_decap4_ulvt ( vccesa , vssesa );

  inout vccesa;
  inout vssesa;

endmodule

module sa_decap8_ulvt ( vccesa , vssesa );

  inout vccesa;
  inout vssesa;

endmodule
