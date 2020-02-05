// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_fsr_out 
 #(
    parameter NUM_OF_PCS_CHAIN   = 16, 
    parameter NUM_OF_HIP_CHAIN   = 16,
    parameter NUM_OF_PARITY_BIT_FSROUT = 1 
  )
(
input wire                    sr_serial_in,
input wire                    sr_load,
input wire                    clk,
input wire                    rst_n,
input wire                    r_sr_hip_en,
input wire                    r_sr_parity_en,
//input wire  [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0] r_sr_bit,
output wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0] sr_parallel_out
);

localparam NUM_OF_UNUSED_HIP_CHAIN = NUM_OF_HIP_CHAIN - NUM_OF_PARITY_BIT_FSROUT;

wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0]  sr_datain_int;
wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0]  sr_dataout_int;

assign sr_datain_int[0] = sr_serial_in;

generate
  genvar i;
  for (i=0; i < (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN); i=i+1) begin: c3adapt_sr_out_bit
       c3aibadapt_sr_out_bit
       #(
           .RESET_VAL (0)
        ) c3adapt_sr_out_bit
         (
           // input
           .sr_shift_in  (sr_datain_int[i]),
           .sr_load      (sr_load),
           .clk          (clk),
           .rst_n        (rst_n),
           // output
           .sr_dataout   (sr_dataout_int[i])
         );
  end
endgenerate

generate
  genvar j;
  for (j=1; j < (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN); j=j+1)
  begin: fsr_out_chain_connection
    assign sr_datain_int[j] = sr_dataout_int[j-1];
  end
endgenerate


assign sr_parallel_out = r_sr_hip_en ? sr_dataout_int : !r_sr_parity_en ? {{NUM_OF_HIP_CHAIN{1'b0}},sr_dataout_int[NUM_OF_PCS_CHAIN-1:0]} : {{NUM_OF_UNUSED_HIP_CHAIN{1'b0}}, sr_dataout_int[NUM_OF_PARITY_BIT_FSROUT+NUM_OF_PCS_CHAIN-1:0]};  

endmodule
