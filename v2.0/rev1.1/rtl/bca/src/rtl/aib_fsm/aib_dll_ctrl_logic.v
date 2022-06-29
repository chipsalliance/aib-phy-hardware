// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_dll_ctrl_logic(
		    	  input      [2:0] freq_range_sel,
		    	  output reg [2:0] trim_ctrl_bits
		         );

always@(*)
 begin
  case(freq_range_sel)
   3'b000 : trim_ctrl_bits = 3'b100;
   3'b001 : trim_ctrl_bits = 3'b101;
   3'b010 : trim_ctrl_bits = 3'b110;
   3'b011 : trim_ctrl_bits = 3'b111;
   3'b100 : trim_ctrl_bits = 3'b000;
   3'b101 : trim_ctrl_bits = 3'b001;
   3'b110 : trim_ctrl_bits = 3'b010;
   3'b111 : trim_ctrl_bits = 3'b011;
  endcase
 end

//========================Frequency LUT======================================
//Freq_range_sel(GHz)  Min    Max        Trim bits(Current trim and cap trim)
//	3'b000         3.2     2.6        3'b100
//	3'b001         2.6     2.1        3'b101
//	3'b010         2.1     1.7        3'b110
//	3'b011         1.7     1.4        3'b111
//	3'b100         1.4     1.1        3'b000
//	3'b101         1.1     0.85       3'b001
//	3'b110         0.85    0.65       3'b010
//	3'b111         0.65    0.50       3'b011
//========================Frequency LUT======================================


endmodule
