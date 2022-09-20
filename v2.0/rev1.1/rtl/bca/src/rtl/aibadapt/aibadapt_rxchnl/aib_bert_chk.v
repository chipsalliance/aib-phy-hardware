// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_bert_chk #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(
input            clk,                  // Rx BERT clock
input            rstn,                 // Active low asynchronous reset 
input            rx_rst_pulse,         // Resets synchronously RX BERT logic
input            rx_start_pulse,       // Starts data comparison process
input            seed_in_en,           // Seed input mode enable
input      [1:0] rx_sft_nb,            // Selects the number  of valid data bits
                                       // per clock
input      [7:0]   rx_bert_data_in,    // Data bits from RX FIFO
input      [2:0]   rx_ptrn_sel,        // Pattern selection
output reg [127:0] rx_bert_data_ff,    // Last 128 received bits
output reg         rbert_running_ff,   // Rx BERT checker is running
output reg [15:0]  rbert_biterr_cnt_ff // Rx bit error counter
);

// Defines the number of bits to be considered in RX data:
localparam [1:0] NBIT1 = 2'b00; // 1 bit per clock
localparam [1:0] NBIT2 = 2'b01; // 2 bit per clock
localparam [1:0] NBIT4 = 2'b10; // 4 bit per clock
localparam [1:0] NBIT8 = 2'b11; // 8 bit per clock

// Defines pattern check
localparam [2:0] PRBS7   = 3'b000; // PRBS7 selected
localparam [2:0] PRBS15  = 3'b001; // PRBS15 selected
localparam [2:0] PRBS23  = 3'b010; // PRBS23 selected
localparam [2:0] PRBS31  = 3'b011; // PRBS31 selected
localparam [2:0] PTRN127 = 3'b100; // 127-bit pattern selected
localparam [2:0] PTRN128 = 3'b101; // 127-bit pattern selected

integer i; // Integer used on error increment calculation

// Internal Regs
reg  [127:0] lfsr_buf_ff;      // Linear feedback shift register (LFSR)
reg  [127:0] seed_data_in;     // Seed data input for self seeding process
reg  [127:0] lfsr_buf_next;    // Indicate the next value of LFSR
reg  [  7:0] bit_err;          // Indicates all the bit error per clock
reg  [  3:0] rxbert_inc_val;   // Indicates the increment value of error counter
reg          co2_nc;           // Unconnected carryout

// Internal wires
wire [15:0] rbert_biterr_cnt_in; // Error counter input
wire [15:0] rbert_biterr_nxt;    // Next Error counter value
wire        co1_cnt;             // Error counter carryout

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
//     RX BERT checker enable: received data is compared with expected data
//------------------------------------------------------------------------------

// This register enables data comparison
always @(posedge clk or negedge rstn)
  begin: rbert_running_register
    if(!rstn) // Async reset
      begin
        rbert_running_ff <= 1'h0;
      end
    else if(rx_rst_pulse)
      begin
        rbert_running_ff <= 1'h0;
      end
    else if(rx_start_pulse)
      begin
        rbert_running_ff <= 1'b1;
      end
  end // block: rbert_running_register

//------------------------------------------------------------------------------
//        Seeding value selection according to CRR configuration
//------------------------------------------------------------------------------

// Seeding logic
always @(*)
  begin: seed_data_in_logic
    case(rx_sft_nb[1:0])
      NBIT1: // Receives 1 bit per clock
        begin
          seed_data_in[127:0] = {rx_bert_data_in[0],
                                 lfsr_buf_ff[127:1]};
        end
      NBIT2: // Receives 2 bit per clock
        begin
          seed_data_in[127:0] = {rx_bert_data_in[1:0],
                                 lfsr_buf_ff[127:2]};
        end
      NBIT4: // Receives 4 bit per clock
        begin
          seed_data_in[127:0] = {rx_bert_data_in[3:0],
                                 lfsr_buf_ff[127:4]};
        end
      NBIT8: // Receives 8 bit per clock
        begin
          seed_data_in[127:0] = {rx_bert_data_in[7:0],
                                 lfsr_buf_ff[127:8]};
        end
    endcase
  end // block: seed_data_in_logic

//------------------------------------------------------------------------------
//      Next value of LFSR7 register when operating in check mode 
//------------------------------------------------------------------------------
// Polynomial
// x7  + x6  + 1

// One for each configuration: 1bit/clk, 2bit/clk, 4bit/clk and 8bit/clk
assign lfsr7_sft1[7:0] = {(lfsr_buf_ff[121] ^ lfsr_buf_ff[122]),
                           lfsr_buf_ff[127:121]};

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
assign lfsr15_sft1[14:0] = {(lfsr_buf_ff[113] ^ lfsr_buf_ff[114]),
                             lfsr_buf_ff[127:114]};

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
assign lfsr23_sft1[22:0] = {(lfsr_buf_ff[105] ^ lfsr_buf_ff[110]),
                             lfsr_buf_ff[127:106]};

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
assign lfsr31_sft1[30:0] = {(lfsr_buf_ff[97] ^ lfsr_buf_ff[100]),
                             lfsr_buf_ff[127:98]};

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
  begin: lfsr_buf_next_logic
    lfsr_buf_next[127:0] = lfsr_buf_ff[127:0];
    case(rx_ptrn_sel[2:0])
      PRBS7: // PRBS7 selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:120] = lfsr7_sft1[7:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:120] = lfsr7_sft2[7:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:120] = lfsr7_sft4[7:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:120] = lfsr7_sft8[7:0];
              end
          endcase
        end
      PRBS15: // PRBS15 selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:113] = lfsr15_sft1[14:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:113] = lfsr15_sft2[14:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:113] = lfsr15_sft4[14:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:113] = lfsr15_sft8[14:0];
              end
          endcase
        end
      PRBS23: // PRBS23 selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:105] = lfsr23_sft1[22:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:105] = lfsr23_sft2[22:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:105] = lfsr23_sft4[22:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:105] = lfsr23_sft8[22:0];
              end
          endcase
        end 
      PRBS31:  // PRBS31 selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:97] = lfsr31_sft1[30:0];
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:97] = lfsr31_sft2[30:0];
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:97] = lfsr31_sft4[30:0];
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:97] = lfsr31_sft8[30:0];
              end
          endcase
        end
      PTRN127: // 127-bit pattern selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:1] = { lfsr_buf_ff[1],
                                         lfsr_buf_ff[127:2]  };
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:1] = { lfsr_buf_ff[2:1],
                                         lfsr_buf_ff[127:3] };
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:1] = { lfsr_buf_ff[4:1],
                                         lfsr_buf_ff[127:5] };
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:1] = { lfsr_buf_ff[8:1],
                                         lfsr_buf_ff[127:9] };
              end
          endcase
        end
      PTRN128: // 128-bit pattern selected
        begin
          case(rx_sft_nb[1:0])
            NBIT1: // Receives 1 bit per clock
              begin
                lfsr_buf_next[127:0] = { lfsr_buf_ff[0],
                                         lfsr_buf_ff[127:1]  };
              end
            NBIT2: // Receives 2 bit per clock
              begin
                lfsr_buf_next[127:0] = { lfsr_buf_ff[1:0],
                                         lfsr_buf_ff[127:2] };
              end
            NBIT4: // Receives 4 bit per clock
              begin
                lfsr_buf_next[127:0] = { lfsr_buf_ff[3:0],
                                         lfsr_buf_ff[127:4] };
              end
            NBIT8: // Receives 8 bit per clock
              begin
                lfsr_buf_next[127:0] = { lfsr_buf_ff[7:0],
                                         lfsr_buf_ff[127:8] };
              end
          endcase
        end
      default: //Reserved selections keep the register value
        begin
          lfsr_buf_next[127:0] = lfsr_buf_ff[127:0];
        end
    endcase
  end // block: lfsr_buf_next_logic

//------------------------------------------------------------------------------
//                    Linear feedback shift register
//------------------------------------------------------------------------------

// Linear feedback shift register
always @(posedge clk or negedge rstn)
  begin: lfsr_buf_register
    if(!rstn) // Async reset
      begin
        lfsr_buf_ff[127:0] <= 128'h0000_0000_0000_0000_0000_0000_0000_0000;
      end
    else if(rx_rst_pulse)
      begin
        lfsr_buf_ff[127:0] <= 128'h0000_0000_0000_0000_0000_0000_0000_0000;
      end
    else if(rbert_running_ff  | rx_start_pulse)
      begin
        lfsr_buf_ff[127:0] <= lfsr_buf_next[127:0] &
                              {31'h7fff_ffff,{97{BERT_BUF_MODE_EN}}};
      end
    else if(seed_in_en)
      begin
        lfsr_buf_ff[127:0] <= seed_data_in[127:0] &
                              {31'h7fff_ffff,{97{BERT_BUF_MODE_EN}}};
      end
  end // block: lfsr_buf_register

//------------------------------------------------------------------------------
//                RX data buffer - stores the last 128 receive bits
//------------------------------------------------------------------------------

// Linear feedback shift register
always @(posedge clk or negedge rstn)
  begin: rx_bert_data_register
    if(!rstn) // Async reset
      begin
        rx_bert_data_ff[127:0] <= 128'h0000_0000_0000_0000_0000_0000_0000_0000;
      end
    else if(rx_rst_pulse)
      begin
        rx_bert_data_ff[127:0] <= 128'h0000_0000_0000_0000_0000_0000_0000_0000;
      end
    else if(rbert_running_ff  | rx_start_pulse)
      begin
        rx_bert_data_ff[127:0] <= seed_data_in[127:0];
      end
  end // block: rx_bert_data_register

//------------------------------------------------------------------------------
//                           Bit error detection
//------------------------------------------------------------------------------

// Detects bit error according to operation mode
always @(*)
  begin: bit_err_logic
    bit_err[7:0]     = 8'b00;
    case(rx_sft_nb[1:0])
      NBIT1: // Receives 1 bit per clock
        begin
          if(rbert_running_ff)
            bit_err[0] = lfsr_buf_ff[127] ^ rx_bert_data_ff[127];
        end
      NBIT2: // Receives 2 bit per clock
        begin
          if(rbert_running_ff)
            bit_err[1:0] = lfsr_buf_ff[127:126] ^ rx_bert_data_ff[127:126];
        end
      NBIT4: // Receives 4 bit per clock
        begin
          if(rbert_running_ff)
            bit_err[3:0] = lfsr_buf_ff[127:124] ^ rx_bert_data_ff[127:124];
        end
      NBIT8: // Receives 8 bit per clock
        begin
          if(rbert_running_ff)
            bit_err[7:0] = lfsr_buf_ff[127:120] ^ rx_bert_data_ff[127:120];
        end
    endcase
  end // block: bit_err_logic

//------------------------------------------------------------------------------
//                       Rx BERT Error counter implementation
//------------------------------------------------------------------------------

// Error counter increment logic
// Calculates the error counter increment based on the total number of bit
// errors in 8-bit word
always @(*)
  begin: rxbert_inc_val_logic
    rxbert_inc_val[3:0] = 4'h0;
    for(i=0;i<8;i=i+1)
      begin
        rxbert_inc_val[3:0] = rxbert_inc_val[3:0] + {3'h0,bit_err[i]};
      end
  end // block: rxbert_inc_val_logic


assign {co1_cnt,rbert_biterr_nxt[15:0]}  = rbert_biterr_cnt_ff[15:0] +
                                          {12'h0,rxbert_inc_val[3:0]};

// Check saturation of error counter
assign rbert_biterr_cnt_in[15:0] = co1_cnt ? 16'hffff : rbert_biterr_nxt[15:0];

// Linear feedback shift register
always @(posedge clk or negedge rstn)
  begin: rbert_biterr_cnt_register
    if(!rstn) // Async reset
      begin
        rbert_biterr_cnt_ff[15:0] <= {16{1'b0}};
      end
    else if(rx_rst_pulse)
      begin
        rbert_biterr_cnt_ff[15:0] <= {16{1'b0}};
      end
    else if(rbert_running_ff)
      begin
        rbert_biterr_cnt_ff[15:0] <= rbert_biterr_cnt_in[15:0];
      end
  end // block: rbert_biterr_cnt_register


endmodule // aib_bert_chk
