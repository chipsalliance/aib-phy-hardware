// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapt_fifo_mem #(
parameter DWIDTH = 'd320,            // FIFO Input data width 
parameter DEPTH  = 'd16              // FIFO Depth 
)
(
// Inputs
input [DEPTH-1 :0] ff_clk_39_0,    // clocks for bits 39-0 of FIFO
input [DEPTH-1 :0] ff_clk_79_40,   // clocks for bits 79-40 of FIFO
input [DEPTH-1 :0] ff_clk_119_80,  // clocks for bits 119-80 of FIFO
input [DEPTH-1 :0] ff_clk_159_120, // clocks for bits 159-120 of FIFO
input [DEPTH-1 :0] ff_clk_199_160, // clocks for bits 199-160 of FIFO
input [DEPTH-1 :0] ff_clk_239_200, // clocks for bits 239-200 of FIFO
input [DEPTH-1 :0] ff_clk_279_240, // clocks for bits 279-240 of FIFO
input [DEPTH-1 :0] ff_clk_319_280, // clocks for bits 319-280 of FIFO
input              ff_rst_n,       // FIFO array reset
input [DWIDTH-1:0] wr_data,        // FIFO write data bus
// Outputs
output reg  [DEPTH-1 :0][DWIDTH-1:0] fifo_data_ff // FIFO data
);

// Bits 39-0
genvar i;
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_39_0
      always @(posedge ff_clk_39_0[i] or negedge ff_rst_n)
        begin: fifo_data_39_0_register
          if(!ff_rst_n)
            fifo_data_ff[i][39:0] <= {40{1'b0}};
          else
            fifo_data_ff[i][39:0] <= wr_data[39:0];
        end // block: fifo_data_39_0_register
    end // block: fifo_data_39_0
endgenerate 

// Bits 79-40
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_79_40
      always @(posedge ff_clk_79_40[i] or negedge ff_rst_n)
        begin: fifo_data_79_40_register
          if(!ff_rst_n)
            fifo_data_ff[i][79:40] <= {40{1'b0}};
          else
            fifo_data_ff[i][79:40] <= wr_data[79:40];
        end // block: fifo_data_79_40_register
    end // block: fifo_data_79_40
endgenerate 

// Bits 119-80
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_119_80
      always @(posedge ff_clk_119_80[i] or negedge ff_rst_n)
        begin: fifo_data_119_80_register
          if(!ff_rst_n)
            fifo_data_ff[i][119:80] <= {40{1'b0}};
          else
            fifo_data_ff[i][119:80] <= wr_data[119:80];
        end // block: fifo_data_119_80_register
    end // block: fifo_data_119_80
endgenerate

// Bits 159-120
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_159_120
      always @(posedge ff_clk_159_120[i] or negedge ff_rst_n)
        begin: fifo_data_159_120_register
          if(!ff_rst_n)
            fifo_data_ff[i][159:120] <= {40{1'b0}};
          else
            fifo_data_ff[i][159:120] <= wr_data[159:120];
        end // block: fifo_data_159_120_register
    end // block: fifo_data_159_120
endgenerate

// Bits 199-160
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_199_160
      always @(posedge ff_clk_199_160[i] or negedge ff_rst_n)
        begin: fifo_data_199_160_register
          if(!ff_rst_n)
            fifo_data_ff[i][199:160] <= {40{1'b0}};
          else
            fifo_data_ff[i][199:160] <= wr_data[199:160];
        end // block: fifo_data_199_160_register
    end // block: fifo_data_199_160
endgenerate

// Bits 239-200
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_239_200
      always @(posedge ff_clk_239_200[i] or negedge ff_rst_n)
        begin: fifo_data_239_200_register
          if(!ff_rst_n)
            fifo_data_ff[i][239:200] <= {40{1'b0}};
          else
            fifo_data_ff[i][239:200] <= wr_data[239:200];
        end // block: fifo_data_239_200_register
    end // block: fifo_data_239_200
endgenerate

// Bits 279-240
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_279_240
      always @(posedge ff_clk_279_240[i] or negedge ff_rst_n)
        begin: fifo_data_279_240_register
          if(!ff_rst_n)
            fifo_data_ff[i][279:240] <= {40{1'b0}};
          else
            fifo_data_ff[i][279:240] <= wr_data[279:240];
        end // block: fifo_data_279_240_register
    end // block: fifo_data_279_240
endgenerate

// Bits 319-280
generate
  for(i=0;i<DEPTH;i=i+1)
    begin:fifo_data_319_280
      always @(posedge ff_clk_319_280[i] or negedge ff_rst_n)
        begin: fifo_data_319_280_register
          if(!ff_rst_n)
            fifo_data_ff[i][319:280] <= {40{1'b0}};
          else
            fifo_data_ff[i][319:280] <= wr_data[319:280];
        end // block: fifo_data_319_280_register
    end // block: fifo_data_319_280
endgenerate

endmodule // aib_adapt_fifo_mem
