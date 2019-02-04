// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module aibcr3_aliasv (ra, rb);
 inout rb, ra;
 wire w;
  assign ra = w;
  assign rb = w;
endmodule


