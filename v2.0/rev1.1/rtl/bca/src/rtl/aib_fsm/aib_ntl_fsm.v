// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_ntl_fsm(
	       input              sys_clk,
	       input              rst_n,
	       input              ntl_en,
	       input              ntl_ovrd_en,
	       input      [15:0]  ntl_count_ovrd,
	       input      [101:0] ntl_tx_en_ovrd,
	       input      [101:0] ntl_rx_en_ovrd,
	       input      [101:0] ntl_async_tx_en_ovrd,
	       input      [101:0] ntl_async_rx_en_ovrd,
	       input      [101:0] ntl_tx_data_even_ovrd,
	       input      [101:0] ntl_tx_data_odd_ovrd,
	       input              ntl_done_ovrd,
	       input      [101:0] tx_en,
	       input      [101:0] rx_en,
	       input      [101:0] tx_async_en,
	       input      [101:0] rx_async_en,
	       input      [6:0]   pad_num, //Avmm
	       input      [101:0] tx_data_even,
	       input      [101:0] tx_data_odd,
	       input      [101:0] rx_data_even,
	       input      [101:0] rx_data_odd,
	       output wire [15:0]  ntl_count_value,
	       output wire [101:0] pad_tx_en,
	       output wire [101:0] pad_rx_en,
	       output wire [101:0] pad_async_tx_en,
	       output wire [101:0] pad_async_rx_en,
	       output wire [101:0] pad_tx_data_even,
	       output wire [101:0] pad_tx_data_odd,
	       output wire 	   ntl_done
	      );

 reg [3:0] test_count;
 reg [1:0] ntl_curst, ntl_nxst;
 reg  ntl_tx_en;
 reg  ntl_rx_en;
 wire pad_cond;
 wire pad_cond_sync;
 reg [15:0] ntl_count_value_intr;
 reg 	   ntl_done_intr;

 parameter START = 2'b00,
	   INIT  = 2'b01,
           RUN   = 2'b10,
           STOP  = 2'b11;

assign pad_cond = ~(rx_data_even[pad_num] & rx_data_odd[pad_num]);

// PAD condition synchronized
aib_bit_sync pad_cond_sync_i
(
.clk      (sys_clk),      // Clock of destination domain
.rst_n    (1'b1),         // Reset of destination domain
.data_in  (pad_cond),     // Input to be synchronized
.data_out (pad_cond_sync) // Synchronized output
);

//pad0, pad101, pad50 and pad60
//Data Muxing b/w Register Data and internal logic data
assign pad_tx_en        = ntl_ovrd_en ? ntl_tx_en_ovrd        : (ntl_en ? {102{ntl_tx_en}} : tx_en);
assign pad_rx_en        = ntl_ovrd_en ? ntl_rx_en_ovrd        : (ntl_en ? {102{ntl_rx_en}} : rx_en);
assign pad_tx_data_even = ntl_ovrd_en ? ntl_tx_data_even_ovrd : (ntl_en ? {102{1'b1}} : tx_data_even);
assign pad_tx_data_odd  = ntl_ovrd_en ? ntl_tx_data_odd_ovrd  : (ntl_en ? {102{1'b1}} : tx_data_odd);
assign ntl_count_value  = ntl_ovrd_en ? ntl_count_ovrd        : ntl_count_value_intr;
assign ntl_done         = ntl_ovrd_en ? ntl_done_ovrd         : ntl_done_intr;
assign pad_async_tx_en  = ntl_ovrd_en ? ntl_async_tx_en_ovrd  : (ntl_en ? {{52{1'b0}},{8{ntl_tx_en}},{42{1'b0}}} : tx_async_en);
assign pad_async_rx_en  = ntl_ovrd_en ? ntl_async_rx_en_ovrd  : (ntl_en ? {{42{1'b0}},{8{ntl_rx_en}},{52{1'b0}}} : rx_async_en);

always @ (posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   ntl_curst[1:0] <= 2'b00;
  else
   ntl_curst[1:0] <= ntl_nxst[1:0];
 end

always@(posedge sys_clk or negedge rst_n)
  if(!rst_n)
   begin
    ntl_count_value_intr  <= {16{1'b0}}; 
    test_count       <= {4{1'b0}}; 
    ntl_tx_en        <= 1'b0; 
    ntl_rx_en        <= 1'b0; 
    ntl_done_intr    <= 1'b0; 
   end
  else
   begin
    case(ntl_nxst)
      START : begin
               ntl_count_value_intr  <= {16{1'b0}}; 
               test_count       <= {4{1'b0}}; 
               ntl_tx_en        <= 1'b1; 
               ntl_rx_en        <= 1'b1; 
               ntl_done_intr    <= 1'b0; 
	      end
      INIT  : begin
	       test_count        <= test_count + 1'b1;
  	       if(test_count == 4'b1110)
		begin
		 ntl_tx_en         <= 1'b0;
		end
              end
       RUN  : begin
	       if(pad_cond_sync == 1'b1) 
	        ntl_count_value_intr <= ntl_count_value_intr;
	       else
	        ntl_count_value_intr <= ntl_count_value_intr + 1'b1;
              end
      STOP  : begin
               ntl_count_value_intr  <= ntl_count_value_intr;  
               ntl_done_intr         <= 1'b1;  
	      end
   endcase
 end

always@(*)
 begin
  ntl_nxst = 2'b00;
  case(ntl_curst)
   START    : begin
	       if(ntl_en)
		ntl_nxst = INIT;
	       else
		ntl_nxst = START;
	      end
   INIT     : begin
	       if(test_count == 4'b1111)
		ntl_nxst = RUN;
    	       else
		ntl_nxst = INIT;
	      end
   RUN      : begin
	       if(pad_cond_sync == 1'b1)
		ntl_nxst = STOP;
    	       else
		ntl_nxst = RUN;
	       end
   STOP     : begin
	       if(!ntl_en)
		ntl_nxst = START;
    	       else
		ntl_nxst = STOP;
	      end
  endcase
 end
endmodule : aib_ntl_fsm
