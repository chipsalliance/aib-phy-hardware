// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_ssr_out 
 #(
    parameter NUM_OF_PCS_CHAIN   = 16, 
    parameter NUM_OF_HIP_CHAIN   = 16, 
    parameter NUM_OF_RESERVED_CHAIN_SSROUT  = 5,
    parameter NUM_OF_PARITY_BIT_SSROUT = 5
  )
(
input wire                    sr_serial_in,
input wire                    sr_load,
input wire                    clk,
input wire                    rst_n,
input wire                    r_sr_hip_en,
input wire                    r_sr_parity_en,
input wire                    r_sr_reserbits_out_en,
output wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT - 1):0] sr_parallel_out
);


localparam NUM_OF_UNUSED_HIP_CHAIN = NUM_OF_HIP_CHAIN - NUM_OF_PARITY_BIT_SSROUT;

wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT - 1):0]  sr_datain_int;
wire [(NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT - 1):0]  sr_dataout_int;

assign sr_datain_int[0] = sr_serial_in;

generate
  genvar i; 
  for (i=0; i < (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT); i=i+1) begin: hdpldadapt_sr_out_bit 
       hdpldadapt_sr_out_bit
       #(
           .RESET_VAL (0)
        ) hdpldadapt_sr_out_bit
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
  for (j=1; j < (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT); j=j+1)
  begin: ssr_out_chain_connection
    if (j == (NUM_OF_PCS_CHAIN + NUM_OF_RESERVED_CHAIN_SSROUT)) begin
         assign sr_datain_int[j] = r_sr_reserbits_out_en ? sr_dataout_int[j-1] : sr_dataout_int[NUM_OF_PCS_CHAIN-1];
    end
    else begin 
         assign sr_datain_int[j] = sr_dataout_int[j-1];
    end
  end
endgenerate

assign sr_parallel_out = (!r_sr_reserbits_out_en) ? 
                             (r_sr_hip_en ? {sr_dataout_int[(NUM_OF_RESERVED_CHAIN_SSROUT+NUM_OF_PCS_CHAIN+NUM_OF_HIP_CHAIN-1):(NUM_OF_RESERVED_CHAIN_SSROUT+NUM_OF_PCS_CHAIN)], 
                                             {NUM_OF_RESERVED_CHAIN_SSROUT{1'b0}}, sr_dataout_int[NUM_OF_PCS_CHAIN-1:0]} :
                                            (!r_sr_parity_en ? {{NUM_OF_HIP_CHAIN{1'b0}}, {NUM_OF_RESERVED_CHAIN_SSROUT{1'b0}}, sr_dataout_int[NUM_OF_PCS_CHAIN-1:0]} :
                                                               {{NUM_OF_UNUSED_HIP_CHAIN{1'b0}}, sr_dataout_int[(NUM_OF_PARITY_BIT_SSROUT + NUM_OF_RESERVED_CHAIN_SSROUT + NUM_OF_PCS_CHAIN - 1): (NUM_OF_RESERVED_CHAIN_SSROUT+ NUM_OF_PCS_CHAIN)], {NUM_OF_RESERVED_CHAIN_SSROUT{1'b0}}, sr_dataout_int[NUM_OF_PCS_CHAIN-1:0]}  )): 
                             (r_sr_hip_en ? sr_dataout_int : 
                                            !r_sr_parity_en ? ({{NUM_OF_HIP_CHAIN{1'b0}}, sr_dataout_int[NUM_OF_RESERVED_CHAIN_SSROUT+NUM_OF_PCS_CHAIN-1:0]}) : 
                                                              {{NUM_OF_UNUSED_HIP_CHAIN{1'b0}}, sr_dataout_int[NUM_OF_PARITY_BIT_SSROUT+NUM_OF_RESERVED_CHAIN_SSROUT+NUM_OF_PCS_CHAIN-1:0]}) ;
                                                  
endmodule
