// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


module aibnd_fine_dly_inv ( a, o1, vcc_io, vss_io );

  input a;
  output o1;
  input vss_io;
  input vcc_io;


  assign o1 = ~a ;

endmodule


