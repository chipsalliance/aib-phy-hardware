// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_cdr_fsm(
	input phase_detect, //RxDLL output
	input sys_clk,         //System CLock,
	input rst_n,
	input scan_mode,
	input rx_en,
	input cdr_ovrd_sel,
	input cdr_lock_ovrd,
	input picode_update_ovrd,
	input [6:0]picode_even_ovrd,
	input [6:0]picode_odd_ovrd,
	input [1:0]clk_sel,//Config Register to decide averaging(2-bits)
	output wire picode_update,
	output wire cdr_lock, //To indicate the picodes have been locked 
	output wire  [6:0] picode_even, //picode even[6:0] and picode odd[6:0]
	output wire [6:0] picode_odd   //picode even[6:0] and picode odd[6:0]
	);

parameter START    = 2'b00,
          RUN      = 2'b01;

reg [1:0] cdr_lock_curst, cdr_lock_nxst;
reg [6:0] div_sel;
reg [6:0] avg_cnt;
reg [6:0] phase_detect_cnt;
reg [5:0] picode_refp;
reg [4:0] picode_refn;
reg [4:0] lock_count;
reg [31:0][6:0] picode_avg_data;
reg [12:0] picode_average;
reg [4:0] picode_avg_index;
wire max_value;
wire [6:0] picode_avg_divide_value;
wire [6:0] picode_cond_check_0;
wire [6:0] picode_cond_check_p1;
wire [6:0] picode_cond_check_m1;
wire [6:0] picode_cond_check_p2;
wire [6:0] picode_cond_check_m2;
wire [6:0] picode_cond_check;
wire [6:0] div_sel_dec;
reg picode_update_int;
reg  [6:0] picode_even_intr;
wire [6:0] picode_odd_intr;   
reg picode_update_intr;
reg  cdr_lock_intr; 
integer i;
wire sync_rst_n;
wire phase_detect_sync;

//Reset Synchronizer
aib_rst_sync cdr_rst_sync
(
.clk         (sys_clk),         // Destination clock of reset to be synced
.i_rst_n     (rst_n),   // Asynchronous reset input
.scan_mode   (scan_mode), // Scan enable
.sync_rst_n  (sync_rst_n)       // Synchronized reset output
);

// Phase detect synchronizer
aib_bit_sync bitsync_phase_detect
(
.clk      (sys_clk),       // Clock of destination domain
.rst_n    (sync_rst_n),         // Reset of destination domain
.data_in  (phase_detect),    // Input to be synchronized
.data_out (phase_detect_sync)   // Synchronized output
);

//Data Muxing b/w Register Data and internal logic data
assign picode_even   = cdr_ovrd_sel ? picode_even_ovrd : picode_even_intr;
assign picode_odd    = cdr_ovrd_sel ? picode_odd_ovrd  : picode_odd_intr ;
assign picode_update = cdr_ovrd_sel ? picode_update_ovrd : picode_update_intr;
assign cdr_lock      = cdr_ovrd_sel ? cdr_lock_ovrd : cdr_lock_intr;

assign picode_avg_divide_value[6:0] = picode_average[11:5];
assign div_sel_dec[6:0] = (div_sel[6:0]-7'h01);
assign max_value = (avg_cnt[6:0] == div_sel_dec[6:0]);

assign picode_cond_check_0  =  picode_avg_divide_value ^ picode_even_intr;
assign picode_cond_check_p1 = (picode_avg_divide_value+1) ^ picode_even_intr;
assign picode_cond_check_m1 = (picode_avg_divide_value-1) ^ picode_even_intr;
assign picode_cond_check_p2 = (picode_avg_divide_value+2) ^ picode_even_intr;
assign picode_cond_check_m2 = (picode_avg_divide_value-2) ^ picode_even_intr;
assign picode_cond_check    = picode_cond_check_0 & picode_cond_check_p1 & picode_cond_check_m1 & picode_cond_check_p2 & picode_cond_check_m2;


//Need to update
always@(*)
 begin
   case(clk_sel)
    2'b00 : div_sel = 7'b000_1000; //8
    2'b01 : div_sel = 7'b001_0000; //16
    2'b10 : div_sel = 7'b010_0000; //32
    2'b11 : div_sel = 7'b100_0000; //64
   endcase
 end

always @ (posedge sys_clk or negedge sync_rst_n)
 begin
  if(!sync_rst_n)
   cdr_lock_curst[1:0] <= 2'b00;
  else
   cdr_lock_curst[1:0] <= cdr_lock_nxst[1:0];
 end

 always@(posedge sys_clk or negedge sync_rst_n)
  if(!sync_rst_n)
   begin
    picode_refp      <= 6'b00_0000;
    picode_refn      <= 5'b0_0000;
    picode_even_intr      <= 7'b000_0000;
    cdr_lock_intr         <= 1'b0;
    picode_update_intr    <= 1'b0;
    picode_update_int <= 1'b0;
    lock_count       <= 5'b0_0000;
    phase_detect_cnt <= 7'b000_0000;
    avg_cnt 	     <= 7'b000_0000;
    for(i=0; i<32; i=i+1)
      begin
        picode_avg_data[i] <= 7'b000_0000; 
        picode_average     <= {13{1'b0}}; 
        picode_avg_index   <= {5{1'b0}};
      end 
   end
  else
   begin
    case(cdr_lock_nxst)
      START : begin
               avg_cnt 	        <= 7'b000_0000;
               phase_detect_cnt <= 7'b000_0000;
    	       picode_update_intr    <= 1'b0;
    	       picode_update_int <= 1'b0;
    	       for(i=0; i<32; i=i+1)
     		picode_avg_data[i]     <= 7'b000_0000; 
      		picode_average  <= {13{1'b0}}; 
      		picode_avg_index  <= {5{1'b0}}; 
	      end
      RUN  : begin
	      if(max_value)
    	       begin
    		phase_detect_cnt <= 7'b000_0000;
     		avg_cnt          <= 7'b000_0000;
      		picode_average  <= (picode_even_intr - picode_avg_data[picode_avg_index]) + picode_average;
		picode_avg_data[picode_avg_index] <= picode_even_intr;
		picode_avg_index <= picode_avg_index + 1'b1;
     		if(phase_detect_cnt < {1'b0,picode_refp})  
		 begin
     		  picode_even_intr       <= picode_even_intr - 1'b1;
    		  picode_update_int <= 1'b1;
		 end
     		else if(phase_detect_cnt > {2'b00,picode_refn})
		 begin
      		  picode_even_intr       <= picode_even_intr + 1'b1;
    		  picode_update_int <= 1'b1;
		 end
		else
		 begin
      		  picode_even_intr       <= picode_even_intr ;
    		  picode_update_int <= 1'b0;
		 end
		if(cdr_lock_intr == 1'b0) 
		 begin
		  if(picode_cond_check!=7'b000_0000) 
		   lock_count   <= 5'b0_0000;
		  else
		   lock_count   <= lock_count + 1'b1;
		  if(lock_count > 5'b1_0000)
		   cdr_lock_intr     <= 1'b1;
		  else
		   cdr_lock_intr     <= cdr_lock_intr; 
		 end
	       end
	      else if(rx_en)
	       begin
     	 	avg_cnt 	 <= avg_cnt + 1'b1;
	       if(phase_detect_sync)
    		phase_detect_cnt <= phase_detect_cnt + 1'b1;
	       else
     	 	phase_detect_cnt <= phase_detect_cnt;
	       end
	      else
	       begin
     	 	avg_cnt          <= avg_cnt;
     	 	phase_detect_cnt <= phase_detect_cnt;
	       end
	       if(avg_cnt == 7'b000_0000)
    	        picode_update_intr    <= picode_update_int;
	       else if(avg_cnt == 7'b000_0001) 
    	        picode_update_intr    <= 1'b0;
	       else
    	        picode_update_intr <= picode_update_intr;
     	        picode_refp        <= 3 * (div_sel>>2); 
    	        picode_refn        <= div_sel>>2; 
              end
    default : begin
               avg_cnt 	         <= 7'b000_0000;
               phase_detect_cnt  <= 7'b000_0000;
    	       picode_update_intr <= 1'b0;
    	       picode_update_int <= 1'b0;
    	       for(i=0; i<32; i=i+1)
     		picode_avg_data[i] <= 7'b000_0000; 
      		picode_average     <= {13{1'b0}}; 
      		picode_avg_index  <= {5{1'b0}}; 
	      end
   endcase
 end

always@(*)
 begin
  cdr_lock_nxst = 2'b00;
  case(cdr_lock_curst)
   START    : begin
	       if(rx_en)
		cdr_lock_nxst = RUN;
	       else
		cdr_lock_nxst = START;
	      end
   RUN      : begin
	       if(!rx_en)
		cdr_lock_nxst = START;
    	       else
		cdr_lock_nxst = RUN;
	      end
   default  : begin
	       if(rx_en)
		cdr_lock_nxst = RUN;
	       else
		cdr_lock_nxst = START;
	      end
  endcase
 end
assign picode_odd_intr = picode_even_intr + 7'd64;

endmodule
