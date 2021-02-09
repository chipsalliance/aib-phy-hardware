// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_fsr_in 
 #(
    parameter NUM_OF_PCS_CHAIN   = 16, 
    parameter NUM_OF_HIP_CHAIN   = 16,
    parameter NUM_OF_PARITY_BIT_FSRIN = 1 
  )
(
input wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0] sr_parallel_in,
//input wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0] r_sr_bit,
input wire                    sr_load,
input wire                    clk,
input wire                    rst_n,
input wire                    r_sr_hip_en,
input wire                    r_sr_parity_en,
output wire                   sr_serial_out
);

wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0]  sr_datain_int;
wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1):0]  sr_dataout_int;

assign sr_datain_int[0] = sr_dataout_int[0];

generate
  genvar i;
  for (i=0; i < (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN) ; i=i+1) begin: c3adapt_sr_in_bit
       c3aibadapt_sr_in_bit
       #(
           .RESET_VAL (0)
        ) c3adapt_sr_in_bit
         (
           // input
           .sr_load_in   (sr_parallel_in[i]),
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
  begin: fsr_in_chain_connection
    assign sr_datain_int[j] = sr_dataout_int[j-1];
  end
endgenerate

assign sr_serial_out = r_sr_hip_en ? sr_dataout_int[NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1] : 
                                     !r_sr_parity_en ? sr_dataout_int[NUM_OF_PCS_CHAIN - 1] : sr_dataout_int[NUM_OF_PCS_CHAIN+NUM_OF_PARITY_BIT_FSRIN-1];

endmodule
