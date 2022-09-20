// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_rx_bert #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(
// Inputs
input         clk,              // Rx BERT clock
input         rstn,             // Active low asynchronous reset 
input [  3:0] rx_rst_pulse,     // Resets synchronously RX BERT logic
input [  3:0] rx_start_pulse,   // Starts data comparison
input [  3:0] seed_in_en,       // Seed input mode enable
input [  5:0] chk3_lane_sel_ff, // Lane selection to checker3
input [  5:0] chk2_lane_sel_ff, // Lane selection to checker2
input [  5:0] chk1_lane_sel_ff, // Lane selection to checker1
input [  5:0] chk0_lane_sel_ff, // Lane selection to checker0
input [  2:0] chk3_ptrn_sel_ff, // Pattern selection to checker 3
input [  2:0] chk2_ptrn_sel_ff, // Pattern selection to checker 2
input [  2:0] chk1_ptrn_sel_ff, // Pattern selection to checker 1
input [  2:0] chk0_ptrn_sel_ff, // Pattern selection to checker 0
input [319:0] rx_bert_data_i,   // Data bits from RX FIFO
input         sdr_mode,         // Single data rate mode
input   [1:0] r_fifo_mode,      // RX FIFO mode
input         m_gen2_mode,      // GEN2 mode selector
// Outputs
output reg [ 48:0] rbert_bit_cnt_ff, // Bit counter
output     [ 15:0] biterr_cnt_chk3,  // Bit error counter from checker3
output     [ 15:0] biterr_cnt_chk2,  // Bit error counter from checker2
output     [ 15:0] biterr_cnt_chk1,  // Bit error counter from checker1
output     [ 15:0] biterr_cnt_chk0,  // Bit error counter from checker0
output     [127:0] rx_bert3_data,    // Receive data in RX BERT3
output     [127:0] rx_bert2_data,    // Receive data in RX BERT2
output     [127:0] rx_bert1_data,    // Receive data in RX BERT1
output     [127:0] rx_bert0_data,    // Receive data in RX BERT0
output     [  3:0] rbert_running_ff  // Indicates RX BERT checker is running
);

//------------------------------------------------------------------------------
// Local Parameters 
//------------------------------------------------------------------------------
localparam   FIFO_1X   = 2'b00;       //Full rate
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate

// Defines the number of bits to be considered in RX data:
localparam [1:0] NBIT1 = 2'b00; // 1 bit per clock
localparam [1:0] NBIT2 = 2'b01; // 2 bit per clock
localparam [1:0] NBIT4 = 2'b10; // 4 bit per clock
localparam [1:0] NBIT8 = 2'b11; // 8 bit per clock

integer i; // Integer to attribute bits for each lane

reg [39:0][7:0] rx_bert_lanes;   // Bits received in each lane
reg [ 1:0] rx_sft_nb;            // Selects the number of valid bits in RX BERT
                                 // checker
reg [ 7:0] rx_bert_data_chk0_ff;  // Bits of lane selected to Checker0
reg [ 7:0] rx_bert_data_chk1_ff;  // Bits of lane selected to Checker1
reg [ 7:0] rx_bert_data_chk2_ff;  // Bits of lane selected to Checker2
reg [ 7:0] rx_bert_data_chk3_ff;  // Bits of lane selected to Checker3
reg [48:0] rbert_bit_cnt_in;
reg        co1_nc;

wire [7:0] rx_bert_data_chk0;   // Bits of lane selected to Checker0
wire [7:0] rx_bert_data_chk1;   // Bits of lane selected to Checker1
wire [7:0] rx_bert_data_chk2;   // Bits of lane selected to Checker2
wire [7:0] rx_bert_data_chk3;   // Bits of lane selected to Checker3

//Logic to select the number of bits per clock
always @(*)
  begin: rx_sft_nb_logic
    case(r_fifo_mode)
      FIFO_1X: // FIFO 1:1 rate
        begin
          if(sdr_mode)
            rx_sft_nb[1:0] = 2'b00; // 1 bits per clock
          else
            rx_sft_nb[1:0] = 2'b01; // 2 bits per clock
        end
      FIFO_2X: // FIFO 1:2 rate
        begin
          if(sdr_mode)
            rx_sft_nb[1:0] = 2'b01; // 2 bits per clock
          else
            rx_sft_nb[1:0] = 2'b10; // 4 bits per clock
        end
      FIFO_4X: // FIFO 1:4 rate
        begin
          if(sdr_mode)
            rx_sft_nb[1:0] = 2'b10; // 4 bits per clock
          else
            rx_sft_nb[1:0] = 2'b11; // 8 bits per clock
        end
      default: // register mode - BERT does not support
        begin
          if(sdr_mode)
            rx_sft_nb[1:0] = 2'b00; // 1 bits per clock
          else
            rx_sft_nb[1:0] = 2'b01; // 2 bits per clock
        end
    endcase
  end // block: rx_sft_nb_logic

// Grouped 8-bit sequence per each lane
always @(*)
  begin: rx_bert_lanes_logic
    if(m_gen2_mode) // GEN 2 mode
      begin: rx_bert_lanes_gen2
        for(i=0;i<40;i=i+1)
          begin
            rx_bert_lanes[i] = { rx_bert_data_i[(2*i)+241],
                                 rx_bert_data_i[(2*i)+240],
                                 rx_bert_data_i[(2*i)+161],
                                 rx_bert_data_i[(2*i)+160],
                                 rx_bert_data_i[(2*i)+81],
                                 rx_bert_data_i[(2*i)+80],
                                 rx_bert_data_i[(2*i)+1],
                                 rx_bert_data_i[2*i] };
          end
      end // GEN 2 mode
    else // GEN1 mode
      begin: rx_bert_lanes_gen1
        for(i=0;i<20;i=i+1)
          begin
            if(sdr_mode) // SDR mode in GEN1 mode
              begin
                rx_bert_lanes[i] = { rx_bert_data_i[(2*i)+241], // Unused
                                     rx_bert_data_i[(2*i)+240], // Unused
                                     rx_bert_data_i[(2*i)+161], // Unused
                                     rx_bert_data_i[(2*i)+160], // Unused
                                     rx_bert_data_i[(2*i)+81],  // Unused
                                     rx_bert_data_i[(2*i)+80],  // Unused
                                     rx_bert_data_i[(2*i)+40],
                                     rx_bert_data_i[2*i] };
              end // SDR mode
            else // DDR mode in GEN1 mode
              begin
                rx_bert_lanes[i] = { rx_bert_data_i[(2*i)+241], // Unused
                                     rx_bert_data_i[(2*i)+240], // Unused
                                     rx_bert_data_i[(2*i)+161], // Unused
                                     rx_bert_data_i[(2*i)+160], // Unused
                                     rx_bert_data_i[(2*i)+41],
                                     rx_bert_data_i[(2*i)+40],
                                     rx_bert_data_i[(2*i)+1],
                                     rx_bert_data_i[2*i] };
              end // DDR mode in GEN1 mode
          end
        for(i=20;i<40;i=i+1)
          begin
            rx_bert_lanes[i] = { rx_bert_data_i[(2*i)+241], // Unused in GEN1
                                 rx_bert_data_i[(2*i)+240], // Unused in GEN1
                                 rx_bert_data_i[(2*i)+161], // Unused in GEN1
                                 rx_bert_data_i[(2*i)+160], // Unused in GEN1
                                 rx_bert_data_i[(2*i)+81],  // Unused in GEN1
                                 rx_bert_data_i[(2*i)+80],  // Unused in GEN1
                                 rx_bert_data_i[(2*i)+1],   // Unused in GEN1
                                 rx_bert_data_i[2*i] };     // Unused in GEN1
          end
      end // // GEN1 mode
  end // block: rx_bert_lanes_logic

// Bit selection for each checker
assign rx_bert_data_chk0[7:0] = (chk0_lane_sel_ff[5:0] < 6'd40)      ?
                                 rx_bert_lanes[chk0_lane_sel_ff[5:0] ] :
                                 8'h00;

assign rx_bert_data_chk1[7:0] = (chk1_lane_sel_ff[5:0] < 6'd40)      ?
                                 rx_bert_lanes[chk1_lane_sel_ff[5:0]] :
                                 8'h00;

assign rx_bert_data_chk2[7:0] = (chk2_lane_sel_ff[5:0] < 6'd40)      ?
                                 rx_bert_lanes[chk2_lane_sel_ff[5:0]] :
                                 8'h00;


assign rx_bert_data_chk3[7:0] = (chk3_lane_sel_ff[5:0] < 6'd40)      ?
                                 rx_bert_lanes[chk3_lane_sel_ff[5:0]] :
                                 8'h00;

//Input data to LFSRs is registered to meet synthesis timing
always @(posedge clk or negedge rstn)
  begin: rx_bert_data_register
    if(!rstn)
      begin
        rx_bert_data_chk0_ff[7:0] <= 8'h0;
        rx_bert_data_chk1_ff[7:0] <= 8'h0;
        rx_bert_data_chk2_ff[7:0] <= 8'h0;
        rx_bert_data_chk3_ff[7:0] <= 8'h0;
      end
    else
      begin
        rx_bert_data_chk0_ff[7:0] <= rx_bert_data_chk0[7:0];
        rx_bert_data_chk1_ff[7:0] <= rx_bert_data_chk1[7:0];
        rx_bert_data_chk2_ff[7:0] <= rx_bert_data_chk2[7:0];
        rx_bert_data_chk3_ff[7:0] <= rx_bert_data_chk3[7:0];
      end
  end // block: rx_bert_data_register

//------------------------------------------------------------------------------
//                       Rx BERT bit counter implementation
//------------------------------------------------------------------------------

// Logic to increment BERT bit counter
always @(*)
  begin: rbert_bit_cnt_in_logic
    case(rx_sft_nb[1:0])
      NBIT1: // Receives 1 bit per clock
        begin
          {co1_nc,rbert_bit_cnt_in[48:0]} = rbert_bit_cnt_ff[48:0] + 49'd1;
        end
      NBIT2: // Receives 2 bit per clock
        begin
          {co1_nc,rbert_bit_cnt_in[48:0]} = rbert_bit_cnt_ff[48:0] + 49'd2;
        end
      NBIT4: // Receives 4 bit per clock
        begin
          {co1_nc,rbert_bit_cnt_in[48:0]} = rbert_bit_cnt_ff[48:0] + 49'd4;
        end
      NBIT8: // Receives 8 bit per clock
        begin
          {co1_nc,rbert_bit_cnt_in[48:0]} = rbert_bit_cnt_ff[48:0] + 49'd8;
        end
    endcase
  end // block: rbert_bit_cnt_in_logic

// Linear feedback shift register
always @(posedge clk or negedge rstn)
  begin: rbert_bit_cnt_register
    if(!rstn) // Async reset
      begin
        rbert_bit_cnt_ff[48:0] <= {49{1'b0}};
      end
    else if(rx_rst_pulse[3:0] != 4'h0)
      begin
        rbert_bit_cnt_ff[48:0] <= {49{1'b0}};
      end
    else if(rbert_running_ff[3:0] != 4'h0)
      begin
        rbert_bit_cnt_ff[48:0] <= rbert_bit_cnt_in[48:0];
      end
  end // block: rbert_bit_cnt_register


//------------------------------------------------------------------------------
//                   Checker Instances
//------------------------------------------------------------------------------

// Checker 0
aib_bert_chk #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_chk0(
// Inputs
.clk             (clk),            
.rstn            (rstn),           
.rx_rst_pulse    (rx_rst_pulse[0]),   
.rx_start_pulse  (rx_start_pulse[0]), 
.seed_in_en      (seed_in_en[0]),     
.rx_sft_nb       (rx_sft_nb[1:0]), 
.rx_bert_data_in (rx_bert_data_chk0_ff[7:0]),  
.rx_ptrn_sel     (chk0_ptrn_sel_ff[2:0]),      
// Outputs
.rx_bert_data_ff     (rx_bert0_data[127:0]), 
.rbert_running_ff    (rbert_running_ff[0]),     
.rbert_biterr_cnt_ff (biterr_cnt_chk0[15:0])
);

// Checker 1
aib_bert_chk #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_chk1(
// Inputs
.clk             (clk),            
.rstn            (rstn),           
.rx_rst_pulse    (rx_rst_pulse[1]),   
.rx_start_pulse  (rx_start_pulse[1]), 
.seed_in_en      (seed_in_en[1]),     
.rx_sft_nb       (rx_sft_nb[1:0]), 
.rx_bert_data_in (rx_bert_data_chk1_ff[7:0]),  
.rx_ptrn_sel     (chk1_ptrn_sel_ff[2:0]),      
// Outputs
.rx_bert_data_ff     (rx_bert1_data[127:0]), 
.rbert_running_ff    (rbert_running_ff[1]),     
.rbert_biterr_cnt_ff (biterr_cnt_chk1[15:0])
);

aib_bert_chk #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_chk2(
// Inputs
.clk             (clk),            
.rstn            (rstn),           
.rx_rst_pulse    (rx_rst_pulse[2]),   
.rx_start_pulse  (rx_start_pulse[2]), 
.seed_in_en      (seed_in_en[2]),     
.rx_sft_nb       (rx_sft_nb[1:0]), 
.rx_bert_data_in (rx_bert_data_chk2_ff[7:0]),  
.rx_ptrn_sel     (chk2_ptrn_sel_ff[2:0]),      
// Outputs
.rx_bert_data_ff     (rx_bert2_data[127:0]), 
.rbert_running_ff    (rbert_running_ff[2]),     
.rbert_biterr_cnt_ff (biterr_cnt_chk2[15:0])
);

// Checker 3
aib_bert_chk #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_chk3(
// Inputs
.clk             (clk),            
.rstn            (rstn),           
.rx_rst_pulse    (rx_rst_pulse[3]),   
.rx_start_pulse  (rx_start_pulse[3]), 
.seed_in_en      (seed_in_en[3]),     
.rx_sft_nb       (rx_sft_nb[1:0]), 
.rx_bert_data_in (rx_bert_data_chk3_ff[7:0]),  
.rx_ptrn_sel     (chk3_ptrn_sel_ff[2:0]),      
// Outputs
.rx_bert_data_ff     (rx_bert3_data[127:0]), 
.rbert_running_ff    (rbert_running_ff[3]),     
.rbert_biterr_cnt_ff (biterr_cnt_chk3[15:0])
);

endmodule // aib_rx_bert
