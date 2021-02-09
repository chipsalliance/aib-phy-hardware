// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

module cfg_dprio_readdata_mux 
#(
   parameter DATA_WIDTH      = 16,  // Data width
   parameter NUM_INPUT       = 4    // Number of n-bit input
 )
( 
input  wire                             clk,
input  wire                             rst_n,
input  wire                             read,
input  wire [NUM_INPUT-1:0]             sel,      // 1-hot selection input
input  wire [DATA_WIDTH*NUM_INPUT-1:0]  data_in,  // data input

output reg  [DATA_WIDTH-1:0]            data_out  // data output
);


wire  [DATA_WIDTH-1:0] data_out_int[0:NUM_INPUT-1];
//wire  [DATA_WIDTH-1:0] input_array[0:NUM_INPUT-1];
wire  [DATA_WIDTH-1:0] data_out_d;
wire  [NUM_INPUT-1:0] data_out_bit[0:DATA_WIDTH-1];

generate
genvar i;
  for (i=0; i<NUM_INPUT; i=i+1)
    begin: array_assignment
//      assign input_array[i] = data_in[(DATA_WIDTH*(i+1))-1:DATA_WIDTH*i];
      // 2:1 mux for each data_in[DATA_WIDTH-1:0]
      assign data_out_int[i] = (sel[i]) ? data_in[(DATA_WIDTH*(i+1))-1:DATA_WIDTH*i] : {DATA_WIDTH{1'b0}};
    end
endgenerate

generate
genvar k,l;
  for (k=0; k<DATA_WIDTH; k=k+1)
  begin: bit_sel
    for (l=0; l<NUM_INPUT; l=l+1)
      begin: bit_sel_or
        // Create array of bit[0], bit[1],.... for muxed data
        assign data_out_bit[k][l] = data_out_int[l][k];
      end
  // bitwise ORED each array element
  assign data_out_d[k] = |data_out_bit[k];
  end
endgenerate


// Registering output
always @ (negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      data_out <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (read == 1'b1)
        begin
          data_out <= data_out_d;
        end
    end


/*
wire [DATA_WIDTH*(NUM_INPUT+1)-1:0] out_int;

// 1-hot muxing
generate
genvar i;
 for (i=0; i<NUM_INPUT; i=i+1)
   begin: modular_mux
   hd_dpcmn_dprio_readdata_mux_mod 
   #(
     .DATA_WIDTH(DATA_WIDTH)  // Data width
    ) hd_dpcmn_dprio_readdata_mux_mod
    ( 
     .sel      (sel[i]),                                        // 1-hot selection input
     .data_in1 (data_in[DATA_WIDTH*(i+1)-1:DATA_WIDTH*(i+0)]),  // data input
     .data_in0 (out_int[DATA_WIDTH*(i+1)-1:DATA_WIDTH*(i+0)]),  // data input
     .data_out (out_int[DATA_WIDTH*(i+2)-1:DATA_WIDTH*(i+1)])   // data output
    );
   end
endgenerate

assign out_int[DATA_WIDTH-1:0] = {DATA_WIDTH{1'b0}};

// Registering output
always @ (negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      data_out <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (read == 1'b1)
        begin
          data_out <= out_int[DATA_WIDTH*(NUM_INPUT+1)-1:DATA_WIDTH*NUM_INPUT];
        end
    end
*/    
endmodule
