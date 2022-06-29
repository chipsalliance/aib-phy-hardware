// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_rx_fifo_wam #(
parameter IDWIDTH = 'd80         // FIFO Input data width
)
(
// Inputs
input                wr_rst_n,    // Write Domain Active low Reset
input                wr_clk,      // Write Domain Clock
input  [IDWIDTH-1:0] wr_data,     // Write Data In
input                rd_rst_n,    // Read Domain Active low Reset
input                rd_clk,      // Read Domain Clock
input  [1:0]         r_fifo_mode, // FIFO double write mode
input                rx_wa_mode_sync, // Rx word alignment mode bit
input  [4:0]         r_mkbit,     // Configurable marker bit (79:76 plus 39)
input  [4:0]         rx_align_threshold, // Rx FIFO word alignment threshold
input                r_wa_en,     // Rx word alignment enable
// Outputs
output               wam_alig_sync,   // Word aligned indication synchronized
output               wam_fifo_wren    // Write in FIFO is enabled
);

//------------------------------------------------------------------------------
//                              Local Parameters 
//------------------------------------------------------------------------------
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate

// States of Word alignment mark extraction FSM
localparam [1:0] WAM_RESET  = 2'd0; // Reset condition
localparam [1:0] FIND_WAM   = 2'd1; // Find alignment condition
localparam [1:0] ALIGNED    = 2'd2; // Word mark is aligned
localparam [1:0] ALING_LOST = 2'd3; // Word alignment lost

//------------------------------------------------------------------------------
//                              Wires and regs 
//------------------------------------------------------------------------------
reg                wm_bit;        // Selects the bit mark according to 
                                  // configuration
reg [4:0] wam_cnt_ff;             // Counts number of valid mark bits 
reg [1:0] wam_extrac_fsm_ff;      // Machine to detect the word mark alignment
reg [1:0] wam_extrac_fsm_ns;      // Next state of WAM extraction machine
reg       wam_cnt_rst;            // Resets WAM counter
reg       wam_cnt_inc;            // Increments WAM counter
reg       wam_aligned;            // Indicates alignment condiction was detected
reg       bit_mark_aligned;       // Indicates the current mark is aligned
reg       bit_mark_misalign;      // Indicates the current mark is not aligned
reg       wam_bit_cnt_clr;        // Resets WAM bit counter
reg [1:0] wam_bit_cnt_ff;         // Index of bit sequence for word alignment 
reg       wam_aligned_ff;         // Word aligned information registered

// Rx mark bit selection logic
always @(*)
  begin:_word_mark_bit_logic
    case (r_mkbit[4:0])
      5'b10000: wm_bit = (wr_data[79] & r_wa_en);
      5'b01000: wm_bit = (wr_data[78] & r_wa_en);
      5'b00100: wm_bit = (wr_data[77] & r_wa_en);
      5'b00010: wm_bit = (wr_data[76] & r_wa_en);
      5'b00001: wm_bit = (wr_data[39] & r_wa_en);
      default:  wm_bit = 1'b0; 
    endcase
  end // block: _word_mark_bit_logic

// Logic to clear WAM bit counter
always @(*)
  begin: wam_bit_cnt_clr_logic
    case(r_fifo_mode[1:0]) // operation mode
      FIFO_4X: wam_bit_cnt_clr = (wam_bit_cnt_ff[1:0] == 3'd3) | wm_bit;
      FIFO_2X: wam_bit_cnt_clr = (wam_bit_cnt_ff[1:0] == 3'd1) | wm_bit;
      default: wam_bit_cnt_clr = 1'b1; // FIFO 1x or REG mode
    endcase // operation mode
  end // block: wam_bit_cnt_clr_logic

// This counter detects if bit mark is aligned
always @(posedge wr_clk or negedge wr_rst_n)
  begin: wam_bit_cnt_register
    if(!wr_rst_n)
      wam_bit_cnt_ff[1:0] <= 2'h0;
    else if(wam_bit_cnt_clr) // Clear condition
      wam_bit_cnt_ff[1:0] <= 2'h0;
    else if(!wm_bit) // Waiting for mark bit
      wam_bit_cnt_ff[1:0] <= wam_bit_cnt_ff[1:0] + 2'd1;
  end // block: wam_bit_cnt_register

// Word alignment mark count
always @(posedge wr_clk or negedge wr_rst_n)
  begin: wam_cnt_register
    if(!wr_rst_n)
      wam_cnt_ff[4:0] <= 5'h0;
    else if(wam_cnt_rst) // Word mark counter reset
      wam_cnt_ff[4:0] <= 5'h0;
    else if(wam_cnt_inc) // Word mark counter increment
      wam_cnt_ff[4:0] <= wam_cnt_ff[4:0] + 5'd1;
  end // block: wam_cnt_register

// Logic to detect the bit mark is aligned
always @(*)
  begin: bit_mark_aligned_logic
    case(r_fifo_mode[1:0]) // mode
      FIFO_4X: bit_mark_aligned = (wam_bit_cnt_ff[1:0] == 3'd3) & wm_bit;
      FIFO_2X: bit_mark_aligned = (wam_bit_cnt_ff[1:0] == 3'd1) & wm_bit;
      default: bit_mark_aligned = 1'b0; // FIFO 1x or REG mode
    endcase
  end // block: bit_mark_aligned_logic

// Logic to detect the bit mark is not aligned
always @(*)
  begin: bit_mark_misalign_logic
    case(r_fifo_mode[1:0]) // mode
      FIFO_4X: bit_mark_misalign = ((wam_bit_cnt_ff[1:0] == 3'd3) & ~wm_bit) |
                                   ((wam_bit_cnt_ff[1:0] != 3'd3) &  wm_bit);
      FIFO_2X: bit_mark_misalign = ((wam_bit_cnt_ff[1:0] == 3'd1) & ~wm_bit) |
                                   ((wam_bit_cnt_ff[1:0] == 3'd0) &  wm_bit);
      default: bit_mark_misalign = 1'b0; // FIFO 1x or REG mode
    endcase
  end // block: bit_mark_misalign_logic

// Word alignment mark extraction FSM - next state/output logic
always @(*)
  begin: wam_ext_fsm_nxt_out_logic
    case(wam_extrac_fsm_ff[1:0])
      
      WAM_RESET: // Reset condition
        begin
          wam_aligned            = 1'b0;
          wam_cnt_rst            = 1'b1;
          wam_cnt_inc            = 1'b0;
          wam_extrac_fsm_ns[1:0] = FIND_WAM;
        end // WAM_RESET
      
      FIND_WAM: // Find alignment condition
        begin
          case(r_fifo_mode[1:0]) // mode
            FIFO_4X,FIFO_2X: // FIFO 4x or FIFO 2x
              begin
                if( ( (wam_cnt_ff == rx_align_threshold) &&
                       bit_mark_aligned )                || // Threshold met
                      (!r_wa_en)             )   // Alignment disabled
                  begin
                    wam_cnt_inc   = ~r_wa_en & bit_mark_misalign;
                    wam_cnt_rst   = 1'b0;
                    wam_aligned   = 1'b0;
                    if(r_wa_en)
                      begin
                        wam_extrac_fsm_ns[1:0] = ALIGNED;
                      end
                    else if(wam_cnt_ff[4:0] == 5'd2) // Delay to wait reset 
                      begin                      // propagation to read domain
                        wam_extrac_fsm_ns[1:0] = ALIGNED;
                      end
                    else // Waiting for word alignment or minimum delay
                      begin
                        wam_extrac_fsm_ns[1:0] = FIND_WAM;
                      end
                  end // Threshold met
                else if(bit_mark_misalign) // Mark is not aligned
                  begin
                    wam_cnt_inc   = 1'b0;
                    wam_cnt_rst   = 1'b1;
                    wam_aligned   = 1'b0;
                    wam_extrac_fsm_ns[1:0] = FIND_WAM;
                  end // Mark is not aligned
                else // Still detecting mark threshold
                  begin
                    wam_cnt_inc   = bit_mark_aligned;
                    wam_cnt_rst   = 1'b0;
                    wam_aligned   = 1'b0;
                    wam_extrac_fsm_ns[1:0] = FIND_WAM;
                  end // Still detecting mark threshold
              end // FIFO_4X,FIFO_2X
            default:// FIFO 1X
              begin
                wam_cnt_inc   = 1'b0; 
                wam_cnt_rst   = 1'b0; 
                wam_aligned   = 1'b0; 
                wam_extrac_fsm_ns[1:0] = ALIGNED;
              end // default
          endcase // mode
        end // FIND_WAM
      
      ALIGNED: // Word mark is aligned
        begin
          wam_cnt_inc   = 1'b0;
          wam_aligned   = 1'b1;
          case(r_fifo_mode[1:0]) // Operation mode
            FIFO_4X,FIFO_2X:
              begin
                if( bit_mark_misalign &&  // Mark is misssing
                   !rx_wa_mode_sync     ) // Word alignment mode
                  begin
                    wam_extrac_fsm_ns[1:0] = ALING_LOST;
                    wam_cnt_rst            = 1'b1;
                  end
                else // Mark is in the corrent position
                  begin
                    wam_extrac_fsm_ns[1:0] = ALIGNED;
                    wam_cnt_rst            = 1'b0;
                  end
              end // FIFO_4X or FIFO 2X
            default: // FIFO 1x or REG mode
              begin
                wam_extrac_fsm_ns[1:0] = ALIGNED;
                wam_cnt_rst            = 1'b0;
              end // FIFO 1x or REG mode
          endcase // Operation mode
        end // ALIGNED
        
      ALING_LOST: // Word alignment lost
        begin
          if(   rx_wa_mode_sync                     ||   // Word alignment mode
               ( (wam_cnt_ff == rx_align_threshold) &&
                bit_mark_aligned )                     ) // Threshold met
            begin
              wam_cnt_inc = 1'b0;
              wam_cnt_rst = 1'b0;
              wam_aligned = 1'b0;
              wam_extrac_fsm_ns[1:0] = ALIGNED;
            end // Threshold met
          else if(bit_mark_misalign) // Mark is not aligned
            begin
              wam_cnt_inc = 1'b0;
              wam_cnt_rst = 1'b1;
              wam_aligned = 1'b0;
              wam_extrac_fsm_ns[1:0] = ALING_LOST;
            end // Mark is not aligned
          else // Still detecting mark threshold
            begin
              wam_cnt_inc = bit_mark_aligned;
              wam_cnt_rst = 1'b0;
              wam_aligned = 1'b0;
              wam_extrac_fsm_ns[1:0] = ALING_LOST;
            end // Still detecting mark threshold
        end // ALING_LOST
        
    endcase // current state check
  end // block: wam_ext_fsm_nxt_out_logic

// Word alignment mark extraction FSM - current state
always @(posedge wr_clk or negedge wr_rst_n)
  begin: wam_extrac_fsm_register
    if(!wr_rst_n)
      wam_extrac_fsm_ff[1:0] <= WAM_RESET;
    else
      wam_extrac_fsm_ff[1:0] <= wam_extrac_fsm_ns;
  end // block: wam_extrac_fsm_register

// Register to indicate RX adapter is aligned
// WAM aligned output needs to be register to avoid
// Glitch in read clock synchronizer 
always @(posedge wr_clk or negedge wr_rst_n)
  begin: wam_aligned_register
    if(!wr_rst_n)
      wam_aligned_ff <= 1'b0;
    else
      wam_aligned_ff <= wam_aligned;
  end // block: wam_aligned_register

// Output needs to be register to avoid
// Glitch in read clock synchronizer
// When stats is ALINGNED (10) or ALING_LOST (11),
// FIFO write is enable: state = 1x
assign wam_fifo_wren = wam_extrac_fsm_ff[1];

// wam_aligned synchronized in read clock domain
aib_bit_sync bitsync2_phcomp_wren
(
.clk      (rd_clk),        // Clock of destination domain
.rst_n    (rd_rst_n),      // Reset of destination domain
.data_in  (wam_aligned_ff),   // Input to be synchronized
.data_out (wam_alig_sync)  // Synchronized output
);

endmodule // aib_rx_fifo_wam
