// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_jtag_bscan
// Description    : Behavioral model of JTAG boundry scan for IO buffer
// Revision       : 1.0
// ============================================================================
module aib_jtag_bscan (
   input   odat0_aib,		//sync data0 RX from AIB 
   input   odat1_aib,		//sync data1 RX from AIB 
   input   odat_asyn_aib,	//async data RX from AIB 
   input   oclkp_aib,		//diff clk RX from AIB
   input   oclkn_aib,		//diff clk RX from AIB
   input   itxen_adap,		//OE TX from HSSI Adapter
   input   idat0_adap,		//SDR dat0 TX from HSSI Adapter
   input   idat1_adap,		//SDR dat1 TX from HSSI Adapter
   input   async_data_adap,	//async data TX from HSSI Adapter
   input   jtag_tx_scanen_in,	//JTAG shift DR, active high
   input   jtag_clkdr_in,	//JTAG boundary scan clock
   input   jtag_tx_scan_in,	//JTAG TX data scan in
   input   jtag_mode_in,		//JTAG mode select
   input   dig_rstb_adap,		//IRSTB from Adaptor
   input   jtag_rstb_en,	//reset_en from TAP
   input   jtag_rstb,		//reset signal from TAP
   input   jtag_intest,		//intest from TAP
   input   [2:0] irxen_adap,		//RXEN from adapter

   output   jtag_clkdr_out,	//CLKDR to remaining BSR
   output   jtag_rx_scan_out,	//JTAG TX scan chain output
   output   odat0_adap,		//sync data0 RX to HSSI Adapter
   output   odat1_adap,		//sync data1 RX to HSSI Adapter
   output   odat_asyn_adap,	//async data RX to HSSI Adapter
   output   itxen_aib,		//OE TX to AIB
   output   idat0_aib,		//SDR dat0 TX to AIB
   output   idat1_aib,		//SDR dat1 TX to AIB
   output   async_data_aib,	//async data TX to AIB
   output   dig_rstb_aib,		//irstb to AIB
   output   [2:0] irxen_aib,	//RXEN to AIB
   output   jtag_clkdr_outn	//inverted clkdr for sync DDR TX

);

reg [6:0]   tx_reg;
reg [4:0]   rx_reg;
reg rx_nreg;
wire [6:0]   tx_shift;  
wire [6:0]   tx_intst;  
wire [4:0]   rx_shift; 

assign jtag_rx_scan_out = rx_nreg;
assign idat0_aib = (jtag_mode_in)? tx_reg[6] : idat0_adap;
assign idat1_aib = (jtag_mode_in)? tx_reg[5] : idat1_adap;

//Change this to CKMUX
//assign async_data_aib = (jtag_mode_in)? tx_reg[4] : async_data_adap;

aib_mux21 async_data_aib_ckmux           (
						.mux_in0(async_data_adap),
						.mux_in1(tx_reg[4]),
						.mux_sel(jtag_mode_in),
						.mux_out(async_data_aib)
					); 

assign itxen_aib = (jtag_mode_in)? tx_reg[3] : itxen_adap;
assign irxen_aib[2] = (jtag_mode_in)? tx_reg[2] : irxen_adap[2];
assign irxen_aib[1] = (jtag_mode_in)? tx_reg[1] : irxen_adap[1];
assign irxen_aib[0] = (jtag_mode_in)? tx_reg[0] : irxen_adap[0];

assign odat0_adap = (jtag_intest)? rx_reg[4] : odat0_aib;
assign odat1_adap = (jtag_intest)? rx_reg[3] : odat1_aib;

//Change this to CKMUX
//assign odat_asyn_adap = (jtag_intest)? rx_reg[0] : odat_asyn_aib;

aib_mux21 odat_asyn_adap_ckmux           (
						.mux_in0(odat_asyn_aib),
						.mux_in1(rx_reg[0]),
						.mux_sel(jtag_intest),
						.mux_out(odat_asyn_adap)
					);


assign dig_rstb_aib = (jtag_rstb_en)? jtag_rstb : dig_rstb_adap;
 
assign jtag_clkdr_out = jtag_clkdr_in;
assign jtag_clkdr_outn = ~jtag_clkdr_in;

//May need to change to ckinv
/**
c3lib_ckinv_ctn jtag_clkdr_ckinv (

					.in(jtag_clkdr_in),
                                	.out(jtag_clkdr_outn)
				);
**/

// Change async_data_adap mux to CKMUX
//assign tx_shift = (jtag_tx_scanen_in) ? {jtag_tx_scan_in,tx_reg[6:1]} : tx_intst;
assign tx_shift[6:5] = (jtag_tx_scanen_in) ? {jtag_tx_scan_in,tx_reg[6]} : tx_intst[6:5];
assign tx_shift[3:0] = (jtag_tx_scanen_in) ? {tx_reg[4:1]} : tx_intst[3:0];

aib_mux21 tx_shift_4_ckmux (

						.mux_in0(tx_intst[4]),
						.mux_in1(tx_reg[5]),
						.mux_sel(jtag_tx_scanen_in),
						.mux_out(tx_shift[4])
					);

// Change async_data_adap mux to CKMUX
assign tx_intst[6:5] = (jtag_intest) ? {idat0_adap,idat1_adap} : tx_reg[6:5];
assign tx_intst[3:0] = (jtag_intest) ? {itxen_adap,irxen_adap[2],irxen_adap[1],irxen_adap[0]} : tx_reg[3:0];

aib_mux21 tx_intst_4_ckmux          (

						.mux_in0(tx_reg[4]),
						.mux_in1(async_data_adap),
						.mux_sel(jtag_intest),
						.mux_out(tx_intst[4])
					);


always @( posedge jtag_clkdr_in )
begin
          tx_reg <= tx_shift;
end

//Change oclkn_aib, oclkp_aib and odat_asyn_adap to ckmux
assign rx_shift[4:3] = (jtag_tx_scanen_in) ? {tx_reg[0],rx_reg[4]} : {odat0_adap,odat1_adap};

aib_mux21 rx_shift_2_ckmux          (

						.mux_in0(oclkn_aib),
						.mux_in1(rx_reg[3]),
						.mux_sel(jtag_tx_scanen_in),
						.mux_out(rx_shift[2])
					);

aib_mux21 rx_shift_1_ckmux          (
						.mux_in0(oclkp_aib),
						.mux_in1(rx_reg[2]),
						.mux_sel(jtag_tx_scanen_in),
						.mux_out(rx_shift[1])
					);

aib_mux21 rx_shift_0_ckmux          (

						.mux_in0(odat_asyn_adap),
						.mux_in1(rx_reg[1]),
						.mux_sel(jtag_tx_scanen_in),
						.mux_out(rx_shift[0])
					);

always @( posedge jtag_clkdr_in )
begin
	  rx_reg <= rx_shift;
end

always @ ( negedge jtag_clkdr_in )
begin
          rx_nreg <= rx_reg[0];
end

endmodule	
