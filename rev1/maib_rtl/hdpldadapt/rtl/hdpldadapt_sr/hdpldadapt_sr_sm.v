// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_sr_sm 
 #(
    parameter NUM_OF_PCS_CHAIN   = 7'd16,
    parameter NUM_OF_HIP_CHAIN   = 7'd16,
    parameter NUM_OF_RESERVED_CHAIN_SSRIN = 7'd5, 
    parameter NUM_OF_PARITY_IN = 7'd1
  )
(
input wire  clk,
input wire  rst_n,
input wire  r_sr_hip_en,
input wire  r_sr_parity_en,
input wire  r_sr_reserbits_in_en, 
input wire  avmm_hrdrst_fabric_osc_transfer_en_sync,

output wire [11:0] sr_sm_testbus,
output reg  sr_loadout
);


localparam SR_LOAD  = 1'b1;
localparam SR_SHIFT = 1'b0; 

reg sr_ns;
reg sr_cs;
reg sr_loadout_comb;

reg sr_counter_expired;
reg sr_count_start_comb;
reg  [6:0] sr_counter;
wire [6:0] sr_counter_target;

assign sr_counter_target = (!r_sr_reserbits_in_en) ? (r_sr_hip_en ? (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN - 1) : !r_sr_parity_en ? (NUM_OF_PCS_CHAIN - 1) : (NUM_OF_PARITY_IN + NUM_OF_PCS_CHAIN - 1) ) :
                                                     (r_sr_hip_en ? (NUM_OF_PCS_CHAIN + NUM_OF_HIP_CHAIN + NUM_OF_RESERVED_CHAIN_SSRIN - 1) : 
                                                     !r_sr_parity_en ? (NUM_OF_PCS_CHAIN + NUM_OF_RESERVED_CHAIN_SSRIN - 1) : (NUM_OF_PARITY_IN + NUM_OF_PCS_CHAIN + NUM_OF_RESERVED_CHAIN_SSRIN - 1));

assign sr_sm_testbus = {1'b0, avmm_hrdrst_fabric_osc_transfer_en_sync, sr_cs, sr_counter_expired, sr_count_start_comb, sr_counter[6:0]};

 
always @(*) begin
  sr_ns = sr_cs;
  sr_loadout_comb = 1'b0;
  sr_count_start_comb = 1'b0;
 
  case (sr_cs)
    SR_LOAD: 
      begin
         sr_loadout_comb      = 1'b1;
         sr_count_start_comb  = 1'b0;
         sr_ns                = SR_SHIFT;
      end
    SR_SHIFT:
      begin
         sr_loadout_comb      = 1'b0;
         sr_count_start_comb  = 1'b1;
         if (sr_counter_expired == 1'b1) 
         begin 
             sr_ns      = SR_LOAD;
         end
      end
    default: 
      begin
         sr_loadout_comb     = 1'b1;
         sr_count_start_comb = 1'b0;
         sr_ns               = SR_LOAD;
      end
  endcase
end


always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
       sr_loadout <= 1'b1;
       sr_cs      <= SR_LOAD;
    end
  else if (avmm_hrdrst_fabric_osc_transfer_en_sync == 1'b0)
    begin
       sr_loadout <= 1'b1;
       sr_cs      <= SR_LOAD;
    end
  else
    begin
       sr_loadout <= sr_loadout_comb;
       sr_cs      <= sr_ns;
    end
    
always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      sr_counter <= 7'b000_0000;
      sr_counter_expired <= 1'b0; 
    end
  else
    begin
       if (sr_count_start_comb == 1'b1) begin
           sr_counter <= sr_counter + 7'b000_0001;
           sr_counter_expired <= (sr_counter[6:0] == (sr_counter_target[6:0]-1))? 1'b1: 1'b0;
       end
       else begin
           sr_counter <= 7'b000_0000;
           sr_counter_expired <= 1'b0;
       end
    end

endmodule
