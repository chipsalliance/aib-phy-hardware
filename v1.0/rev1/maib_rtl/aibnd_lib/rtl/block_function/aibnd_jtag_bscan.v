// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


module aibnd_jtag_bscan (
   input   odat0_aib,		//sync data0 RX from AIB 
   input   odat1_aib,		//sync data1 RX from AIB 
   input   odat_asyn_aib,	//async data RX from AIB 
   input   oclk_aib,		//diff clk RX from AIB
   input   itxen_adap,		//OE TX from HSSI Adapter
   input   idat0_adap,		//SDR dat0 TX from HSSI Adapter
   input   idat1_adap,		//SDR dat1 TX from HSSI Adapter
   input   async_data_adap,	//async data TX from HSSI Adapter
   input   jtag_tx_scanen_in,	//JTAG shift DR, active high
   input   jtag_rx_scanen_in,	//JTAG shift DR, active high
   input   jtag_clkdr_in,	//JTAG boundary scan clock
   input   jtag_tx_scan_in,	//JTAG TX data scan in
   input   jtag_rx_scan_in,	//JTAG TX data scan in
   input   jtag_mode_in,		//JTAG mode select
   input   last_bs_in,    	//scan-out loopback feedthru back to SSM
   input   anlg_rstb_adap,		//IRSTB from Adaptor
   input   dig_rstb_adap,		//IRSTB from Adaptor
   input   jtag_rstb_en,	//reset_en from TAP
   input   jtag_rstb,		//reset signal from TAP

   output   jtag_clkdr_out,	//CLKDR to remaining BSR
   output   jtag_tx_scan_out,	//JTAG TX scan chain output
   output   jtag_rx_scan_out,	//JTAG TX scan chain output
//   output   jtag_tx_scanen_out, 
//   output   jtag_rx_scanen_out, 
   output   odat0_adap,		//sync data0 RX to HSSI Adapter
   output   odat1_adap,		//sync data1 RX to HSSI Adapter
   output   oclk_adap,		//sync data1 RX to HSSI Adapter
   output   odat_asyn_adap,	//async data RX to HSSI Adapter
   output   itxen_aib,		//OE TX to AIB
   output   idat0_aib,		//SDR dat0 TX to AIB
   output   idat1_aib,		//SDR dat1 TX to AIB
   output   async_data_aib,	//async data TX to AIB
   output   anlg_rstb_aib,		//irstb to AIB
   output   dig_rstb_aib,		//irstb to AIB
//   output   tx_clk,
//   output   rx_clk,
   output   last_bs_out		//scan-out loopback feedthru back to SSM
//   output   weakpu,		//Weak Pull-up control for leakage test to AIB
//   output   weakpdn		//Weak Pull-down control for leakage test to AIB
//   output   jtag_bsdout	//Replaced with separate TX and RX Scan out

);

reg [3:0]   tx_reg;
reg [3:0]   rx_reg;
reg tx_nreg;
reg rx_nreg;
//wire   tx_clk;  
//wire   tx_clk;  
wire [3:0]   tx_shift;  
wire [3:0]   rx_shift;  

assign jtag_rx_scan_out = rx_nreg;
assign jtag_tx_scan_out = tx_nreg;
assign idat0_aib = (jtag_mode_in)? tx_reg[3] : idat0_adap;
assign idat1_aib = (jtag_mode_in)? tx_reg[2] : idat1_adap;
assign async_data_aib = (jtag_mode_in)? tx_reg[1] : async_data_adap;
assign itxen_aib = (jtag_mode_in)? tx_reg[0] : itxen_adap;
assign odat0_adap = odat0_aib;
assign odat1_adap = odat1_aib;
assign oclk_adap = oclk_aib;
assign odat_asyn_adap = odat_asyn_aib;
assign last_bs_out = last_bs_in;
//assign jtag_tx_scanen_out = jtag_tx_scanen_in;
//assign jtag_rx_scanen_out = jtag_rx_scanen_in;
assign anlg_rstb_aib = (jtag_rstb_en)? jtag_rstb : anlg_rstb_adap;
assign dig_rstb_aib = (jtag_rstb_en)? jtag_rstb : dig_rstb_adap;
//assign jtag_loopbacken_out = jtag_loopbacken_in;
//assign jtag_mode_out = jtag_mode_in;

assign jtag_clkdr_out = jtag_clkdr_in;

//assign tx_clk = ( burst_en )? pma_ref_clk : jtag_clkdr_in;	//Need to force tools to use CKMUX for this CLK Muxing to prevent glitch
//assign rx_clk = ( jtag_loopbacken_in )? tx_clk : istrbclk_aib;	//Need to force tools to use CKMUX for this CLK Muxing to prevent glitch
//assign ilaunch_clk_aib = ( jtag_mode_in )? tx_clk : ilaunch_clk_adap;	//Need to force tools to use CKMUX for this CLK Muxing to prevent glitch

assign tx_shift = (jtag_tx_scanen_in) ? {jtag_tx_scan_in,tx_reg[3:1]} : tx_reg; 

//always @( posedge tx_clk )
always @( posedge jtag_clkdr_in )
begin
	tx_reg <= #1 tx_shift;
end

//always @( negedge tx_clk )
always @( negedge jtag_clkdr_in )
begin
	tx_nreg <= tx_reg[0];
end

assign rx_shift = (jtag_rx_scanen_in) ? {jtag_rx_scan_in,rx_reg[3:1]} : {odat0_aib,odat1_aib,oclk_aib,odat_asyn_aib}; 

//always @( posedge rx_clk )
always @( posedge jtag_clkdr_in )
begin
	rx_reg <= rx_shift;
end

//always @ ( negedge rx_clk )
always @ ( negedge jtag_clkdr_in )
begin 
   rx_nreg <= rx_reg[0];
end

endmodule	

