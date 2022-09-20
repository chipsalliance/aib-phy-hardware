// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_bert_gen #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(
// Inputs
input            clk,                 // Tx BERT clock
input            rstn,                // Active low asynchronous reset
input            tx_start_pulse,      // Starts bit sequence transmission
input            tx_rst_pulse,        // Resets synchronously TX BERT logic
input    [  1:0] tx_sft_nb,           // Selects the number  of valid data bits per clock
input    [  2:0] tx_ptrn_sel,         // Selects the sequence type
input    [31:0]  tx_seed,             // Seed to initialize transmit buffer
input    [15:0]  tx_seed_ld,          // Loads seed into transmit buffer
// Outputs
output reg       tx_seed_good,      // Seed is different from zero
output reg       tx_bert_run_ff,    // LFSR is running
output reg [7:0] tx_bert_data       // Data bits from TX FIFO
);

// Defines the number of bits to be considered in TX data:
localparam [1:0] NBIT1 = 2'b00; // 1 bit per clock
localparam [1:0] NBIT2 = 2'b01; // 2 bit per clock
localparam [1:0] NBIT4 = 2'b10; // 4 bit per clock
localparam [1:0] NBIT8 = 2'b11; // 8 bit per clock

localparam [2:0] PRBS7   = 3'b000; // PRBS7 selected
localparam [2:0] PRBS15  = 3'b001; // PRBS15 selected
localparam [2:0] PRBS23  = 3'b010; // PRBS23 selected
localparam [2:0] PRBS31  = 3'b011; // PRBS31 selected
localparam [2:0] PTRN127 = 3'b100; // 127-bit pattern selected
localparam [2:0] PTRN128 = 3'b101; // 127-bit pattern selected

// Reset value of Linear feedback shift register
localparam [127:0] LFSR_RST = 
                     BERT_BUF_MODE_EN                             ?
                     128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff :
                     128'hffff_fffe_0000_0000_0000_0000_0000_0000;

// Internal Regs
reg  [127:0] lfsr_buffer_ff;    // Linear feedback shift register (LFSR)
reg  [127:0] lfsr_buffer_next;  // Indicate the next value of LFSR
wire  [127:0] tx_seed_in;        // Load data input for seeding generator

// Internal wires

wire [7:0] lfsr7_sft1; // LSFR7 calculation shifted by 1 bit on the right
wire [7:0] lfsr7_sft2; // LSFR7 calculation shifted by 2 bit on the right
wire [7:0] lfsr7_sft3; // LSFR7 calculation shifted by 3 bit on the right
wire [7:0] lfsr7_sft4; // LSFR7 calculation shifted by 4 bit on the right
wire [7:0] lfsr7_sft5; // LSFR7 calculation shifted by 5 bit on the right
wire [7:0] lfsr7_sft6; // LSFR7 calculation shifted by 6 bit on the right
wire [7:0] lfsr7_sft7; // LSFR7 calculation shifted by 7 bit on the right
wire [7:0] lfsr7_sft8; // LSFR7 calculation shifted by 8 bit on the right

wire [14:0] lfsr15_sft1; // LSFR15 calculation shifted by 1 bit on the right
wire [14:0] lfsr15_sft2; // LSFR15 calculation shifted by 2 bit on the right
wire [14:0] lfsr15_sft3; // LSFR15 calculation shifted by 3 bit on the right
wire [14:0] lfsr15_sft4; // LSFR15 calculation shifted by 4 bit on the right
wire [14:0] lfsr15_sft5; // LSFR15 calculation shifted by 5 bit on the right
wire [14:0] lfsr15_sft6; // LSFR15 calculation shifted by 6 bit on the right
wire [14:0] lfsr15_sft7; // LSFR15 calculation shifted by 7 bit on the right
wire [14:0] lfsr15_sft8; // LSFR15 calculation shifted by 8 bit on the right

wire [22:0] lfsr23_sft1; // LSFR23 calculation shifted by 1 bit on the right
wire [22:0] lfsr23_sft2; // LSFR23 calculation shifted by 2 bit on the right
wire [22:0] lfsr23_sft3; // LSFR23 calculation shifted by 3 bit on the right
wire [22:0] lfsr23_sft4; // LSFR23 calculation shifted by 4 bit on the right
wire [22:0] lfsr23_sft5; // LSFR23 calculation shifted by 5 bit on the right
wire [22:0] lfsr23_sft6; // LSFR23 calculation shifted by 6 bit on the right
wire [22:0] lfsr23_sft7; // LSFR23 calculation shifted by 7 bit on the right
wire [22:0] lfsr23_sft8; // LSFR23 calculation shifted by 8 bit on the right

wire [30:0] lfsr31_sft1; // LSFR31 calculation shifted by 1 bit on the right
wire [30:0] lfsr31_sft2; // LSFR31 calculation shifted by 2 bit on the right
wire [30:0] lfsr31_sft3; // LSFR31 calculation shifted by 3 bit on the right
wire [30:0] lfsr31_sft4; // LSFR31 calculation shifted by 4 bit on the right
wire [30:0] lfsr31_sft5; // LSFR31 calculation shifted by 5 bit on the right
wire [30:0] lfsr31_sft6; // LSFR31 calculation shifted by 6 bit on the right
wire [30:0] lfsr31_sft7; // LSFR31 calculation shifted by 7 bit on the right
wire [30:0] lfsr31_sft8; // LSFR31 calculation shifted by 8 bit on the right

//------------------------------------------------------------------------------
//      Next value of LFSR7 register when operating in check mode 
//------------------------------------------------------------------------------
// Polynomial
// x7  + x6  + 1

// One for each configuration: 1bit/clk, 2bit/clk, 4bit/clk and 8bit/clk
assign lfsr7_sft1[7:0] = {(lfsr_buffer_ff[121] ^ lfsr_buffer_ff[122]),
                           lfsr_buffer_ff[127:121]};

assign lfsr7_sft2[7:0] = {(lfsr7_sft1[1] ^ lfsr7_sft1[2]),lfsr7_sft1[7:1]};
assign lfsr7_sft3[7:0] = {(lfsr7_sft2[1] ^ lfsr7_sft2[2]),lfsr7_sft2[7:1]};
assign lfsr7_sft4[7:0] = {(lfsr7_sft3[1] ^ lfsr7_sft3[2]),lfsr7_sft3[7:1]};
assign lfsr7_sft5[7:0] = {(lfsr7_sft4[1] ^ lfsr7_sft4[2]),lfsr7_sft4[7:1]};
assign lfsr7_sft6[7:0] = {(lfsr7_sft5[1] ^ lfsr7_sft5[2]),lfsr7_sft5[7:1]};
assign lfsr7_sft7[7:0] = {(lfsr7_sft6[1] ^ lfsr7_sft6[2]),lfsr7_sft6[7:1]};
assign lfsr7_sft8[7:0] = {(lfsr7_sft7[1] ^ lfsr7_sft7[2]),lfsr7_sft7[7:1]};

//------------------------------------------------------------------------------
//      Next value of LFSR15 register when operating in check mode 
//------------------------------------------------------------------------------
// Polynomial
// x15 + x14 + 1

// One for each configuration: 1bit/clk, 2bit/clk, 4bit/clk and 8bit/clk
assign lfsr15_sft1[14:0] = {(lfsr_buffer_ff[113] ^ lfsr_buffer_ff[114]),
                             lfsr_buffer_ff[127:114]};

assign lfsr15_sft2[14:0] = {(lfsr15_sft1[0] ^ lfsr15_sft1[1]),lfsr15_sft1[14:1]};
assign lfsr15_sft3[14:0] = {(lfsr15_sft2[0] ^ lfsr15_sft2[1]),lfsr15_sft2[14:1]};
assign lfsr15_sft4[14:0] = {(lfsr15_sft3[0] ^ lfsr15_sft3[1]),lfsr15_sft3[14:1]};
assign lfsr15_sft5[14:0] = {(lfsr15_sft4[0] ^ lfsr15_sft4[1]),lfsr15_sft4[14:1]};
assign lfsr15_sft6[14:0] = {(lfsr15_sft5[0] ^ lfsr15_sft5[1]),lfsr15_sft5[14:1]};
assign lfsr15_sft7[14:0] = {(lfsr15_sft6[0] ^ lfsr15_sft6[1]),lfsr15_sft6[14:1]};
assign lfsr15_sft8[14:0] = {(lfsr15_sft7[0] ^ lfsr15_sft7[1]),lfsr15_sft7[14:1]};

//------------------------------------------------------------------------------
//      Next value of LFSR23 register when operating in check mode 
//------------------------------------------------------------------------------
// Polynomial
// x23 + x18 + 1

// One for each configuration: 1bit/clk, 2bit/clk, 4bit/clk and 8bit/clk
assign lfsr23_sft1[22:0] = {(lfsr_buffer_ff[105] ^ lfsr_buffer_ff[110]),
                             lfsr_buffer_ff[127:106]};

assign lfsr23_sft2[22:0] = {(lfsr23_sft1[0] ^ lfsr23_sft1[5]),lfsr23_sft1[22:1]};
assign lfsr23_sft3[22:0] = {(lfsr23_sft2[0] ^ lfsr23_sft2[5]),lfsr23_sft2[22:1]};
assign lfsr23_sft4[22:0] = {(lfsr23_sft3[0] ^ lfsr23_sft3[5]),lfsr23_sft3[22:1]};
assign lfsr23_sft5[22:0] = {(lfsr23_sft4[0] ^ lfsr23_sft4[5]),lfsr23_sft4[22:1]};
assign lfsr23_sft6[22:0] = {(lfsr23_sft5[0] ^ lfsr23_sft5[5]),lfsr23_sft5[22:1]};
assign lfsr23_sft7[22:0] = {(lfsr23_sft6[0] ^ lfsr23_sft6[5]),lfsr23_sft6[22:1]};
assign lfsr23_sft8[22:0] = {(lfsr23_sft7[0] ^ lfsr23_sft7[5]),lfsr23_sft7[22:1]};

//------------------------------------------------------------------------------
//      Next value of LFSR31 register when operating in check mode 
//------------------------------------------------------------------------------
// Polynomial
// x31 + x28 + 1

// One for each configuration: 1bit/clk, 2bit/clk, 4bit/clk and 8bit/clk
assign lfsr31_sft1[30:0] = {(lfsr_buffer_ff[97] ^ lfsr_buffer_ff[100]),
                             lfsr_buffer_ff[127:98]};

assign lfsr31_sft2[30:0] = {(lfsr31_sft1[0] ^ lfsr31_sft1[3]),lfsr31_sft1[30:1]};
assign lfsr31_sft3[30:0] = {(lfsr31_sft2[0] ^ lfsr31_sft2[3]),lfsr31_sft2[30:1]};
assign lfsr31_sft4[30:0] = {(lfsr31_sft3[0] ^ lfsr31_sft3[3]),lfsr31_sft3[30:1]};
assign lfsr31_sft5[30:0] = {(lfsr31_sft4[0] ^ lfsr31_sft4[3]),lfsr31_sft4[30:1]};
assign lfsr31_sft6[30:0] = {(lfsr31_sft5[0] ^ lfsr31_sft5[3]),lfsr31_sft5[30:1]};
assign lfsr31_sft7[30:0] = {(lfsr31_sft6[0] ^ lfsr31_sft6[3]),lfsr31_sft6[30:1]};
assign lfsr31_sft8[30:0] = {(lfsr31_sft7[0] ^ lfsr31_sft7[3]),lfsr31_sft7[30:1]};

//------------------------------------------------------------------------------
//         Logic to calculate next values of bit sequence
//------------------------------------------------------------------------------

// LFSR next value value logic
always @(*)
  begin: lfsr_buffer_next_logic
    lfsr_buffer_next[127:0] = lfsr_buffer_ff[127:0];
    case(tx_ptrn_sel[2:0])
      PRBS7: // PRBS7 selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:120] = lfsr7_sft1[7:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:120] = lfsr7_sft2[7:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:120] = lfsr7_sft4[7:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:120] = lfsr7_sft8[7:0];
              end
          endcase
        end
      PRBS15: // PRBS15 selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:113] = lfsr15_sft1[14:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:113] = lfsr15_sft2[14:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:113] = lfsr15_sft4[14:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:113] = lfsr15_sft8[14:0];
              end
          endcase
        end
      PRBS23: // PRBS23 selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:105] = lfsr23_sft1[22:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:105] = lfsr23_sft2[22:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:105] = lfsr23_sft4[22:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:105] = lfsr23_sft8[22:0];
              end
          endcase
        end 
      PRBS31:  // PRBS31 selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:97] = lfsr31_sft1[30:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:97] = lfsr31_sft2[30:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:97] = lfsr31_sft4[30:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:97] = lfsr31_sft8[30:0];
              end
          endcase
        end
      PTRN127: // 127-bit pattern selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:1] = { lfsr_buffer_ff[126:1],
                                            lfsr_buffer_ff[127]  };
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:1] = { lfsr_buffer_ff[125:1],
                                            lfsr_buffer_ff[127:126] };
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:1] = { lfsr_buffer_ff[123:1],
                                            lfsr_buffer_ff[127:124] };
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:1] = { lfsr_buffer_ff[119:1],
                                            lfsr_buffer_ff[127:120] };
              end
          endcase
        end
      PTRN128: // 128-bit pattern selected
        begin
          case(tx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buffer_next[127:0] = { lfsr_buffer_ff[126:0],
                                            lfsr_buffer_ff[127]  };
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buffer_next[127:0] = { lfsr_buffer_ff[125:0],
                                            lfsr_buffer_ff[127:126] };
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buffer_next[127:0] = { lfsr_buffer_ff[123:0],
                                            lfsr_buffer_ff[127:124] };
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buffer_next[127:0] = { lfsr_buffer_ff[119:0],
                                            lfsr_buffer_ff[127:120] };
              end
          endcase
        end
      default: //Reserved selections keep the register value
        begin
          lfsr_buffer_next[127:0] = lfsr_buffer_ff[127:0];
        end
    endcase
  end // block: lfsr_buffer_next_logic

//------------------------------------------------------------------------------
//                    Enable shift register
//------------------------------------------------------------------------------

// Indicates data is being generated by TX BERT block
always @ (posedge clk or negedge rstn)
  begin: tx_bert_run_register
    if (!rstn) // Async reset
      begin
        tx_bert_run_ff <= 1'b0;
      end
    else if (tx_rst_pulse) // TX BERT reset
      begin
        tx_bert_run_ff <= 1'b0;
      end
    else if (tx_start_pulse) // TX BERT start request
      begin
        tx_bert_run_ff <= 1'b1;
      end
  end // block: tx_bert_run_register

//------------------------------------------------------------------------------
//                    Linear feedback shift register
//------------------------------------------------------------------------------

genvar i;
generate
  for(i=0;i<4;i=i+1)
      begin: tx_seed_in_gen_7_0
        assign tx_seed_in[(32*i+7):(32*i)] = 
                           tx_seed_ld[i*4] ?
                           tx_seed[7:0]    :
                           lfsr_buffer_ff[((32*i)+7):(32*i)];
      end
endgenerate


generate
  for(i=0;i<4;i=i+1)
      begin: tx_seed_in_gen_15_8
        assign tx_seed_in[((32*i)+15):((32*i)+8)] = 
                           tx_seed_ld[(i*4)+1] ?
                           tx_seed[15:8]       :
                           lfsr_buffer_ff[((32*i)+15):((32*i)+8)];
      end
endgenerate


generate
  for(i=0;i<4;i=i+1)
      begin: tx_seed_in_gen_23_16
        assign tx_seed_in[((32*i)+23):((32*i)+16)] = 
                           tx_seed_ld[(i*4)+2] ?
                           tx_seed[23:16]      :
                           lfsr_buffer_ff[((32*i)+23):((32*i)+16)];
      end
endgenerate


generate
  for(i=0;i<4;i=i+1)
      begin: tx_seed_in_gen_31_24
        assign tx_seed_in[((32*i)+31):((32*i)+24)] =
                           tx_seed_ld[(i*4)+3] ?
                           tx_seed[31:24]      :
                           lfsr_buffer_ff[((32*i)+31):((32*i)+24)];
      end
endgenerate


// Linear feedback shift register
always @(posedge clk or negedge rstn)
  begin
    if(!rstn) // Async reset
      begin
        lfsr_buffer_ff[127:0] <= LFSR_RST[127:0];
      end
    else if(tx_rst_pulse) // TX BERT reset
      begin
        lfsr_buffer_ff[127:0] <= LFSR_RST[127:0];
      end
    else if(tx_bert_run_ff) // Generation is enabled
      begin
        lfsr_buffer_ff[127:0] <= lfsr_buffer_next[127:0] &
                                 {31'h7fff_ffff,{97{BERT_BUF_MODE_EN}}};
      end
    else // Generation is disabled 
      begin
        lfsr_buffer_ff[127:0] <= tx_seed_in[127:0] &
                                 {31'h7fff_ffff,{97{BERT_BUF_MODE_EN}}};
      end
   end

// Seed should be different from 0.
always @(*)
  begin: tx_seed_good_logic
    case(tx_ptrn_sel[2:0])
      PRBS7:   tx_seed_good = (lfsr_buffer_ff[127:121] != { 7{1'b0}});
      PRBS15:  tx_seed_good = (lfsr_buffer_ff[127:113] != {15{1'b0}});
      PRBS23:  tx_seed_good = (lfsr_buffer_ff[127:105] != {23{1'b0}});
      PRBS31:  tx_seed_good = (lfsr_buffer_ff[127:97]  != {31{1'b0}});
      default: tx_seed_good = 1'b1;
    endcase
  end // block: tx_seed_good_logic

// TX BERT data output logic
always @(*)
  begin: tx_bert_out_logic
    if(tx_bert_run_ff) // TX BERT generator is running
      begin
        case(tx_sft_nb[1:0])
          NBIT1: // Transmits 1 bit per clock
            begin
              tx_bert_data[7:0] = {lfsr_buffer_ff[127],7'h00};
            end
          NBIT2: // Transmits 2 bit per clock
            begin
              case(tx_ptrn_sel[2:0])
                PTRN127,PTRN128:
                  begin
                    tx_bert_data[7:0] = {lfsr_buffer_ff[127:126],6'h00};
                  end
                default: // PRBS
                  begin
                    tx_bert_data[7:0] = {lfsr_buffer_ff[126],
                                         lfsr_buffer_ff[127],
                                         6'h00};
                  end
              endcase
            end
          NBIT4: // Transmits 4 bit per clock
            begin
              case(tx_ptrn_sel[2:0])
                PTRN127,PTRN128:
                  begin
                    tx_bert_data[7:0] = {lfsr_buffer_ff[127:124],4'h0};
                  end
                default: // PRBS
                  begin
                    tx_bert_data[7:0] = {lfsr_buffer_ff[124],
                                         lfsr_buffer_ff[125],
                                         lfsr_buffer_ff[126],
                                         lfsr_buffer_ff[127],
                                         4'h0};
                  end
              endcase
            end
          NBIT8: // Transmits 8 bit per clock
            begin
              case(tx_ptrn_sel[2:0])
                PTRN127,PTRN128:
                  begin
                    tx_bert_data[7:0] = lfsr_buffer_ff[127:120];
                  end
                default: // PRBS
                  begin
                    tx_bert_data[7:0] = {lfsr_buffer_ff[120],
                                         lfsr_buffer_ff[121],
                                         lfsr_buffer_ff[122],
                                         lfsr_buffer_ff[123],
                                         lfsr_buffer_ff[124],
                                         lfsr_buffer_ff[125],
                                         lfsr_buffer_ff[126],
                                         lfsr_buffer_ff[127] };
                  end
              endcase
            end
        endcase
      end
    else // TX BERT generator is idle
      begin
        tx_bert_data[7:0] = 8'hff;
      end
  end // block: tx_bert_out_logic




endmodule // block: aib_bert_gen
