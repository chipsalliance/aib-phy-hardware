// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.


module phase_adjust_fsm(input ref_clk, //2GHz clock freeval_cntuency
			input rst_n,
			input phase_adjust_ovrd_sel,
			input phase_locked_ovrd,
			input [3:0]phase_sel_code_ovrd,
			input sample_clk, //2GHz Clock freeval_cntuency
			input sys_clk, //System clock(250MHz)
 			input start_phase_lock,
			input [1:0]sel_avg,
			input enable,
 			output wire phase_locked,
			output wire [3:0]phase_sel_code
		       );
reg        [6:0] div_sel;
reg        [6:0] avg_cnt;
reg        [15:0][3:0] samp_data;
reg        [15:0][3:0] samp_data_diff;
reg        [7:0] samp_data_avg;
reg        [1:0] phase_adjust_curst;
reg        [1:0] phase_adjust_nxst;
wire             phase_detect;
wire             phase_detect_sync;
wire             start_phase_sync;
reg        [3:0] max_val;
reg        [3:0] eval_cnt; 
wire             max_value;
wire             phase_value;
wire             eval_value;
wire       [6:0] div_sel_dec;
reg              phase_locked_intr;
reg        [3:0] phase_sel_code_intr;
reg        [3:0] samp_data_in;
reg              phase_detect_ff;

integer i;

parameter START    = 2'b00,
          RUN      = 2'b01,
          EVALUATE = 2'b10,
	  STOP     = 2'b11;

localparam [1:0] AVG_0 = 2'd0;
localparam [1:0] AVG_1 = 2'd1;
localparam [1:0] AVG_2 = 2'd2;
localparam [1:0] AVG_3 = 2'd3;

// Start Phase synchronizer
aib_bit_sync bitsync_start_phase
(
.clk      (sys_clk),       // Clock of destination domain
.rst_n    (rst_n),         // Reset of destination domain
.data_in  (start_phase_lock),    // Input to be synchronized
.data_out (start_phase_sync)   // Synchronized output
);

//Data Muxing b/w Register Data and internal logic data
assign phase_locked   = phase_adjust_ovrd_sel ? phase_locked_ovrd   : phase_locked_intr;
assign phase_sel_code = phase_adjust_ovrd_sel ? phase_sel_code_ovrd : phase_sel_code_intr;

//getting final count values
assign div_sel_dec[6:0] = div_sel[6:0]-7'h01;
assign max_value   = (avg_cnt[6:0] == div_sel_dec[6:0]);
assign phase_value = (phase_sel_code_intr == 4'b1111);
assign eval_value  = (eval_cnt == 4'b1111);

always@(*)
  begin
    case(sel_avg)
     2'b00 : div_sel = 7'b000_1000; //8
     2'b01 : div_sel = 7'b001_0000; //16
     2'b10 : div_sel = 7'b010_0000; //32
     2'b11 : div_sel = 7'b100_0000; //64
    endcase
  end

always @ (posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   phase_adjust_curst[1:0] <= 2'b00;
  else
   phase_adjust_curst[1:0] <= phase_adjust_nxst[1:0];
 end


always @(*)
  begin
    case(sel_avg[1:0])
      AVG_0: samp_data_in[3:0] = samp_data_avg[3:0];
      AVG_1: samp_data_in[3:0] = samp_data_avg[4:1];
      AVG_2: samp_data_in[3:0] = samp_data_avg[5:2];
      AVG_3: samp_data_in[3:0] = samp_data_avg[6:3];
    endcase
  end

always@(posedge sys_clk or negedge rst_n)
  if(!rst_n)
   begin
    avg_cnt             <= 7'b000_0000;
    samp_data_avg       <= 8'b0000_0000;
    phase_sel_code_intr <= 4'b0000;
    phase_locked_intr   <= 1'b0;
    max_val             <= 4'b0000;
    eval_cnt            <= 4'b0000;
    for(i=0; i<16; i=i+1)
      begin
        samp_data[i]      <= 4'b0000;
        samp_data_diff[i] <= 4'b0000;
      end
   end
  else
   begin
    case(phase_adjust_curst)
      START : begin
               avg_cnt 	      <= 7'b000_0000;
               phase_sel_code_intr <= 4'b0000;
               samp_data_avg  <= 8'b0000_0000;
               for(i=0; i<16; i=i+1) 
    		begin
                 samp_data[i]      <= 4'b0000;
                 samp_data_diff[i] <= 4'b0000;
		end
	      end
      RUN   : begin
	      if(max_value)
    	       begin
    		samp_data[phase_sel_code_intr] <= samp_data_in[3:0];
		samp_data_avg        <= 8'b0000_0000;
		avg_cnt              <= 7'b000_0000;
     	        phase_sel_code_intr       <= phase_sel_code_intr+1'b1;
	       end
	      else if(enable)
	       begin
     	 	avg_cnt <= avg_cnt + 1'b1;
	       if(phase_detect)
     		samp_data_avg <= samp_data_avg+1'b1;
	       else
     	 	samp_data_avg <= samp_data_avg;
		end
	      else
	       begin
     	 	avg_cnt       <= avg_cnt;
     	 	samp_data_avg <= samp_data_avg;
	       end
             end
      EVALUATE : begin
                  
                  if(samp_data[0] >=  samp_data[15])
                    begin
                      samp_data_diff[0] <= samp_data[0] - samp_data[15];
                    end
                  else
                    begin
                      samp_data_diff[0] <= 4'b0000;
                    end
                  
                  for(i=1; i<16; i=i+1)
                    begin: diff_calculation_register
                      if(samp_data[i] >=  samp_data[i-1])
                        begin
                          samp_data_diff[i] <= samp_data[i]  - samp_data[i-1];
                        end
                      else
                        begin
                          samp_data_diff[i] <= 4'b0000;
                        end
                    end // block diff_calculation_register
                 
                   if(eval_cnt == 0)
                     begin
                       max_val <= samp_data_diff[0];
                     end
		   else if(samp_data_diff[eval_cnt] > max_val)
		    begin
		     max_val        <= samp_data_diff[eval_cnt];
		     phase_sel_code_intr <= eval_cnt;
		    end
		   else
		    begin
		     max_val        <= max_val;
		     phase_sel_code_intr <= phase_sel_code_intr;
		    end
		   eval_cnt <= eval_cnt+1'b1;
	          end
      STOP     : begin
		  phase_locked_intr   <= 1'b1;
		  phase_sel_code_intr <= phase_sel_code_intr;
		 end
   endcase
 end

always@(*)
 begin
  phase_adjust_nxst = 2'b00;
  case(phase_adjust_curst)
   START    : begin
	       if(start_phase_sync)
		phase_adjust_nxst = RUN;
	       else
		phase_adjust_nxst = START;
	      end
   RUN      : begin
	       if(phase_value && max_value)
		phase_adjust_nxst = EVALUATE;
	       else 
		phase_adjust_nxst = RUN;
	      end
   EVALUATE : begin
               if(eval_value)
	        phase_adjust_nxst = STOP;
	       else
		phase_adjust_nxst = EVALUATE;
	      end
   STOP     : begin
	       if(!start_phase_sync)
		phase_adjust_nxst = START;
    	       else
		phase_adjust_nxst = STOP;
	      end
  endcase
 end

// Register to sample adjusted clock wirh respect of reference clock
always@(posedge ref_clk)
  begin: phase_detect_register
    phase_detect_ff <= sample_clk;
  end // block: phase_detect_register

// Phase detect synchronizer
aib_bit_sync bitsync_phase_detect
(
.clk      (sys_clk),           // Clock of destination domain
.rst_n    (1'b1),              // Reset of destination domain
.data_in  (phase_detect_ff),   // Input to be synchronized
.data_out (phase_detect_sync)  // Synchronized output
);

assign phase_detect = (phase_adjust_curst == RUN) & phase_detect_sync;

endmodule
