// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #8 $
// Date:        $DateTime: 2015/12/02 22:11:55 $
//------------------------------------------------------------------------
// Description: self-timed lock assertion logics
//------------------------------------------------------------------------

module aibndpnr_self_lock_assertion 
#(
parameter FF_DELAY     = 200
)
(
   input  wire         clk,                     //reference clock from pll
   input  wire         reset_n,                 //output for dll reset
   input  wire	 [2:0] rb_clkdiv,               //select division factor for clock      
   input  wire         rb_selflock,             //select between lock signal from self-timed logics or FSM lock monitor
   input  wire         fsm_lock,   		//lock signal from FSM lock monitor 
   input  wire         scan_mode_n,
   output wire         prelock, 		//prelock signal for fast binary search
   output wire 	       lock 			//lock signal to core
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

wire  	   clkdiv_2, clkdiv_4, clkdiv_8, clkdiv_16, clkdiv_32, clkdiv_64;
wire        clkdiv_128, clkdiv_256, clkdiv_512, clkdiv_1024;
reg [7:0]  cntr256;
reg        pre_lock;
reg 	   self_lock;
wire        divclk;
reg [9:0]   count1024;

        always @(posedge clk or negedge reset_n)
                begin
                        if(~reset_n) begin
                                count1024 <= #FF_DELAY 10'b0;
                        end
			else
				count1024 <= #FF_DELAY (count1024 == 10'b11111_11111)? 0 : count1024+1;
		end

         assign clkdiv_2 = count1024[0];
         assign clkdiv_4 = count1024[1];
         assign clkdiv_8 = count1024[2];
         assign clkdiv_16 = count1024[3];
         assign clkdiv_32 = count1024[4];
         assign clkdiv_64 = count1024[5];
         assign clkdiv_128 = count1024[6];
         assign clkdiv_256 = count1024[7];
         assign clkdiv_512 = count1024[8];
         assign clkdiv_1024 = count1024[9];
/*
	always @(posedge clk or negedge reset_n)
  		if (~reset_n) divclk <= #FF_DELAY 1'b0;
  		else case (rb_clkdiv)
     			3'b000 : divclk <= #FF_DELAY clkdiv_8;        //div8 when rb_clkdiv=000
                	3'b001 : divclk <= #FF_DELAY clkdiv_16;       //div16 when rb_clkdiv=001
                	3'b010 : divclk <= #FF_DELAY clkdiv_32;       //div32 when rb_clkdiv=010
                	3'b011 : divclk <= #FF_DELAY clkdiv_64;       //div64 when rb_clkdiv=011 
                        3'b100 : divclk <= #FF_DELAY clkdiv_128;      //div128 when rb_clkdiv=100
                        3'b101 : divclk <= #FF_DELAY clkdiv_256;      //div256 when rb_clkdiv=101
                        3'b110 : divclk <= #FF_DELAY clkdiv_512;      //div512 when rb_clkdiv=110
                        3'b111 : divclk <= #FF_DELAY clkdiv_1024;     //div1024 when rb_clkdiv=111
     			default : divclk <= #FF_DELAY clkdiv_8;
  		endcase
*/

wire clk8_16,clk32_64,clk128_256,clk512_1024,clk8_16_32_64,clk128_256_512_1024;

aibndpnr_dll_atech_clkmux clkmux_clk8_16
(
    .clk1   (clkdiv_16),
    .clk2   (clkdiv_8),
    .s      (rb_clkdiv[0]),
    .clkout (clk8_16)
);

aibndpnr_dll_atech_clkmux clkmux_clk32_64
(
    .clk1   (clkdiv_64),
    .clk2   (clkdiv_32),
    .s      (rb_clkdiv[0]),
    .clkout (clk32_64)
);

aibndpnr_dll_atech_clkmux clkmux_clk128_256
(
    .clk1   (clkdiv_256),
    .clk2   (clkdiv_128),
    .s      (rb_clkdiv[0]),
    .clkout (clk128_256)
);

aibndpnr_dll_atech_clkmux clkmux_clk512_1024
(
    .clk1   (clkdiv_1024),
    .clk2   (clkdiv_512),
    .s      (rb_clkdiv[0]),
    .clkout (clk512_1024)
);

aibndpnr_dll_atech_clkmux clkmux_clk8_16_32_64
(
    .clk1   (clk32_64),
    .clk2   (clk8_16),
    .s      (rb_clkdiv[1]),
    .clkout (clk8_16_32_64)
);

aibndpnr_dll_atech_clkmux clkmux_clk128_256_512_1024
(
    .clk1   (clk512_1024),
    .clk2   (clk128_256),
    .s      (rb_clkdiv[1]),
    .clkout (clk128_256_512_1024)
);

aibndpnr_dll_atech_clkmux clkmux_divclk
(
    .clk1   (clk128_256_512_1024),
    .clk2   (clk8_16_32_64),
    .s      (rb_clkdiv[2]),
    .clkout (divclk)
);

         always @(posedge divclk or negedge reset_n) begin
                if (~reset_n) begin
                        cntr256 <= #FF_DELAY 8'b0000_0000;
                        pre_lock <= #FF_DELAY 1'b0;
                        self_lock <= #FF_DELAY 1'b0;
                end
                else if ((cntr256 >= 8'd0) & (cntr256 < 8'd150)) begin
                        cntr256 <= #FF_DELAY cntr256 + 8'b0000_0001;
                end
                else if ((cntr256 >= 8'd150) & (cntr256 < 8'd255)) begin
                        pre_lock <= #FF_DELAY 1'b1;
                        cntr256 <= #FF_DELAY cntr256 + 8'b0000_0001;
                end
                else begin
                        self_lock <= #FF_DELAY 1'b1;
                end
        end

wire lock_presync;
       assign lock_presync = rb_selflock ? self_lock : fsm_lock;

//lock synchronization
//cdclib_bitsync2 #(.CLK_FREQ_MHZ(1000)) prelock_sync  ( .rst_n(reset_n), .clk(clk), .data_in(pre_lock),  .data_out(prelock) );
//cdclib_bitsync2 #(.CLK_FREQ_MHZ(1000)) lock_sync  ( .rst_n(reset_n), .clk(clk), .data_in(lock_presync),  .data_out(lock) );
cdclib_bitsync2 #(
   .DWIDTH(1),
   .RESET_VAL(0),
   .CLK_FREQ_MHZ(1000),
   .TOGGLE_TYPE(1),
   .VID(1)
) prelock_sync  ( .rst_n(reset_n), .clk(clk), .data_in(pre_lock),  .data_out(prelock) );

cdclib_bitsync2 #(
   .DWIDTH(1),
   .RESET_VAL(0),
   .CLK_FREQ_MHZ(1000),
   .TOGGLE_TYPE(1),
   .VID(1)
) lock_sync  ( .rst_n(reset_n), .clk(clk), .data_in(lock_presync),  .data_out(lock) );

endmodule // aibndpnr_self_lock_assertion
