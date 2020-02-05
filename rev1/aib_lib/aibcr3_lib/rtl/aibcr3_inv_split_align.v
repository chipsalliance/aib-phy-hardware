// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//Verilog HDL for "aibcr_lib", "aibcr_inv_split_align" "verilog"


module aibcr3_inv_split_align ( din, dout, vccl, vssl );

  input din;
  output dout;
  input vssl;
  input vccl;


  assign dout = ~din ;

endmodule


