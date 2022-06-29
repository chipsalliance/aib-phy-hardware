// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_deskew_logic(
	input       deskew_en,       //Coming from AVMM register
	input       deskew_ovrd,     //Coming from AVMM register
	input       deskew_step,     //Coming from AVMM register
	input       [3:0]deskew_data,     //Coming from AVMM register
	output wire [101:0][3:0]deskew_out 
	);
reg [3:0] deskew_val0;
reg [3:0] deskew_val1;
reg [3:0] deskew_val2;
reg [3:0] deskew_val3;
reg [101:0][3:0] deskew_distr;
integer i;

genvar m;

generate
  for(m=0;m<102;m++)
    begin: deskew_out_gen
      assign deskew_out[m] = deskew_ovrd ? deskew_data : deskew_distr[m];
    end // block: deskew_out_gen
endgenerate

function [6:0]deskew_map0;
  input [6:0]index;
    case(index[6:0])
      7'd0:    deskew_map0 = 23;
      7'd1:    deskew_map0 = 22;
      7'd2:    deskew_map0 = 21;
      7'd3:    deskew_map0 = 20;
      7'd4:    deskew_map0 = 19;
      7'd5:    deskew_map0 = 18;
      7'd6:    deskew_map0 = 78;
      7'd7:    deskew_map0 = 80;
      7'd8:    deskew_map0 = 82;
      7'd9:    deskew_map0 = 79;
      7'd10:   deskew_map0 = 81;
      7'd11:   deskew_map0 = 83;
      default: deskew_map0 = 83;
    endcase
endfunction

function [6:0]deskew_map1;
 input [6:0]index;
  case(index[6:0])
   7'd0:    deskew_map1 = 13;
   7'd1:    deskew_map1 = 12;
   7'd2:    deskew_map1 = 15;
   7'd3:    deskew_map1 = 14;
   7'd4:    deskew_map1 = 17;
   7'd5:    deskew_map1 = 16;
   7'd6:    deskew_map1 = 25;
   7'd7:    deskew_map1 = 24;
   7'd8:    deskew_map1 = 27;
   7'd9:    deskew_map1 = 26;
   7'd10:   deskew_map1 = 29;
   7'd11:   deskew_map1 = 28;
   7'd12:   deskew_map1 = 87;
   7'd13:   deskew_map1 = 84;
   7'd14:   deskew_map1 = 85;
   7'd15:   deskew_map1 = 88;
   7'd16:   deskew_map1 = 89;
   7'd17:   deskew_map1 = 86;
   7'd18:   deskew_map1 = 76;
   7'd19:   deskew_map1 = 77;
   7'd20:   deskew_map1 = 74;
   7'd21:   deskew_map1 = 75;
   7'd22:   deskew_map1 = 72;
   7'd23:   deskew_map1 = 73;
   default: deskew_map1 = 73;
  endcase
endfunction

function [6:0]deskew_map2;
 input [6:0]index;
  case(index[6:0])
   7'd0:    deskew_map2 = 8;
   7'd1:    deskew_map2 = 7;
   7'd2:    deskew_map2 = 6;
   7'd3:    deskew_map2 = 9;
   7'd4:    deskew_map2 = 10;
   7'd5:    deskew_map2 = 11;
   7'd6:    deskew_map2 = 30;
   7'd7:    deskew_map2 = 31;
   7'd8:    deskew_map2 = 32;
   7'd9:    deskew_map2 = 33;
   7'd10:   deskew_map2 = 34;
   7'd11:   deskew_map2 = 35;
   7'd12:   deskew_map2 = 68;
   7'd13:   deskew_map2 = 67;
   7'd14:   deskew_map2 = 66;
   7'd15:   deskew_map2 = 69;
   7'd16:   deskew_map2 = 70;
   7'd17:   deskew_map2 = 71;
   7'd18:   deskew_map2 = 95; 
   7'd19:   deskew_map2 = 94;
   7'd20:   deskew_map2 = 93;
   7'd21:   deskew_map2 = 92; 
   7'd22:   deskew_map2 = 91;
   7'd23:   deskew_map2 = 90;
   default: deskew_map2 = 90;
  endcase
endfunction
//TBD
function [6:0]deskew_map3;
 input [6:0]index;
  case(index[6:0])
   7'd0:    deskew_map3 = 2;
   7'd1:    deskew_map3 = 5;
   7'd2:    deskew_map3 = 4;
   7'd3:    deskew_map3 = 3;
   7'd4:    deskew_map3 = 0;
   7'd5:    deskew_map3 = 1;
   7'd6:    deskew_map3 = 38;
   7'd7:    deskew_map3 = 41;
   7'd8:    deskew_map3 = 40;
   7'd9:    deskew_map3 = 39;
   7'd10:   deskew_map3 = 36;
   7'd11:   deskew_map3 = 37;
   7'd12:   deskew_map3 = 42;
   7'd13:   deskew_map3 = 43;
   7'd14:   deskew_map3 = 63;
   7'd15:   deskew_map3 = 60;
   7'd16:   deskew_map3 = 61;
   7'd17:   deskew_map3 = 62;
   7'd18:   deskew_map3 = 65;
   7'd19:   deskew_map3 = 64;
   7'd20:   deskew_map3 = 59;
   7'd21:   deskew_map3 = 58;
   7'd22:   deskew_map3 = 98;
   7'd23:   deskew_map3 = 101;
   7'd24:   deskew_map3 = 100;
   7'd25:   deskew_map3 = 99;
   7'd26:   deskew_map3 = 96;
   7'd27:   deskew_map3 = 97;
   7'd28:   deskew_map3 = 44;
   7'd29:   deskew_map3 = 45;
   7'd30:   deskew_map3 = 46;
   7'd31:   deskew_map3 = 47;
   7'd32:   deskew_map3 = 48;
   7'd33:   deskew_map3 = 49;
   7'd34:   deskew_map3 = 50;
   7'd35:   deskew_map3 = 51;
   7'd36:   deskew_map3 = 52;
   7'd37:   deskew_map3 = 53;
   7'd38:   deskew_map3 = 54;
   7'd39:   deskew_map3 = 55;
   7'd40:   deskew_map3 = 56;
   7'd41:   deskew_map3 = 57;
   default: deskew_map3 = 57;
  endcase
endfunction

always @(*)
 begin
  case({deskew_step,deskew_en})
   2'b00   : begin 
	      deskew_val0 = 4'b0000;
	      deskew_val1 = 4'b0000;
	      deskew_val2 = 4'b0000;
	      deskew_val3 = 4'b0000;
 	      for(i=0; i<12; i=i+1)
  	       deskew_distr[deskew_map0(i)]  = deskew_val0;
 	      for(i=0; i<24; i=i+1)
	       begin
  	        deskew_distr[deskew_map1(i)] = deskew_val1;
  	        deskew_distr[deskew_map2(i)] = deskew_val2;
	       end
 	      for(i=0; i<42; i=i+1)
  	       deskew_distr[deskew_map3(i)]  = deskew_val3;
	     end
   2'b01   : begin 
	      deskew_val0 = 4'b0000;
	      deskew_val1 = 4'b0001;
	      deskew_val2 = 4'b0010;
	      deskew_val3 = 4'b0011;
 	      for(i=0; i<12; i=i+1)
  	       deskew_distr[deskew_map0(i)]  = deskew_val0;
 	      for(i=0; i<24; i=i+1)
	       begin
  	        deskew_distr[deskew_map1(i)] = deskew_val1;
  	        deskew_distr[deskew_map2(i)] = deskew_val2;
	       end
 	      for(i=0; i<42; i=i+1)
  	       deskew_distr[deskew_map3(i)]  = deskew_val3;
	     end

   2'b11   : begin 
	      deskew_val0 = 4'b0000;
	      deskew_val1 = 4'b0010;
	      deskew_val2 = 4'b0100;
	      deskew_val3 = 4'b0110;
 	      for(i=0; i<12; i=i+1)
  	       deskew_distr[deskew_map0(i)]  = deskew_val0;
 	      for(i=0; i<24; i=i+1)
	       begin
  	        deskew_distr[deskew_map1(i)] = deskew_val1;
  	        deskew_distr[deskew_map2(i)] = deskew_val2;
	       end
 	      for(i=0; i<42; i=i+1)
  	       deskew_distr[deskew_map3(i)]  = deskew_val3;
	     end
 default   : begin 
	      deskew_val0 = 4'b0000;
	      deskew_val1 = 4'b0000;
	      deskew_val2 = 4'b0000;
	      deskew_val3 = 4'b0000;
 	      for(i=0; i<12; i=i+1)
  	       deskew_distr[deskew_map0(i)]  = deskew_val0;
 	      for(i=0; i<24; i=i+1)
	       begin
  	        deskew_distr[deskew_map1(i)] = deskew_val1;
  	        deskew_distr[deskew_map2(i)] = deskew_val2;
	       end
 	      for(i=0; i<42; i=i+1)
  	       deskew_distr[deskew_map3(i)]  = deskew_val3;
	     end
  endcase
 end
endmodule
