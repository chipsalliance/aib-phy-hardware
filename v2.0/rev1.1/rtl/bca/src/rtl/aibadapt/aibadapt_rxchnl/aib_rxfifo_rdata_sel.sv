// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_rxfifo_rdata_sel #(
parameter DWIDTH  = 320,  // FIFO Input data width
parameter DEPTH   = 4,    // FIFO Depth
parameter DEPTH4  = DEPTH * 4  // FIFO Depth
)
(
// Output
output reg [DWIDTH-1:0]  fifo_rdata, 
// Input
input [1:0]              r_fifo_mode,
input                    m_gen2_mode,
input [DEPTH4-1:0][79:0] fifo_out_sel
);

localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate

reg  [ 79:0] fifo_rdata_1x_int;
wire [319:0] fifo_rdata_1x;
reg  [159:0] fifo_rdata_2x_int;
wire [319:0] fifo_rdata_2x;
reg  [319:0] fifo_rdata_4x;
reg  [ 79:0] ff_rdata_2x_gen1_int;
wire [319:0] ff_rdata_2x_gen1;

integer i;

always @(*)
  begin
    fifo_rdata_1x_int[79:0] = 80'h0;
    for(i=0; i<DEPTH4; i=i+1)
      begin
        fifo_rdata_1x_int[79:0] = fifo_rdata_1x_int[79:0] |
                                  fifo_out_sel[i];
      end
  end

assign fifo_rdata_1x[319:0] = {240'h0,fifo_rdata_1x_int[79:0]};

always @(*)
  begin
    fifo_rdata_2x_int[159:0] = 160'h0;
    for(i=0; i<(DEPTH4/2); i=i+1)
      begin
        fifo_rdata_2x_int[159:0] = fifo_rdata_2x_int[159:0]                    |
                                   {fifo_out_sel[(2*i)+1], fifo_out_sel[2*i]};
      end
  end

assign fifo_rdata_2x[319:0] = {160'h0,fifo_rdata_2x_int[159:0]};

always @(*)
  begin
    ff_rdata_2x_gen1_int[79:0] = 80'h0;
    for(i=0; i<(DEPTH4/2); i=i+1)
      begin
        ff_rdata_2x_gen1_int[79:0] =
                    ff_rdata_2x_gen1_int[79:0]                            |
                   {fifo_out_sel[(2*i)+1][39:0], fifo_out_sel[2*i][39:0]};
      end
  end

assign ff_rdata_2x_gen1[319:0] = {240'h0,ff_rdata_2x_gen1_int[79:0]};

always @(*)
  begin
    fifo_rdata_4x[319:0] = 320'h0;
    for(i=0; i<(DEPTH4/4); i=i+1)
      begin
        fifo_rdata_4x[319:0] =
                  fifo_rdata_4x[319:0]        |
                  { fifo_out_sel[(4*i)+3] ,
                    fifo_out_sel[(4*i)+2] ,
                    fifo_out_sel[(4*i)+1] ,
                    fifo_out_sel[4*i]      };
      end
  end

always @(*)
  begin
    case(r_fifo_mode[1:0])
      FIFO_4X: fifo_rdata[DWIDTH-1:0] = fifo_rdata_4x[319:0];
      FIFO_2X:
        begin
          if(m_gen2_mode)
            fifo_rdata[DWIDTH-1:0] = fifo_rdata_2x[319:0];
          else
            fifo_rdata[DWIDTH-1:0] = ff_rdata_2x_gen1[319:0];
        end
      default: fifo_rdata[DWIDTH-1:0] = fifo_rdata_1x[319:0];
    endcase
  end

endmodule // aib_rxfifo_rdata_sel
