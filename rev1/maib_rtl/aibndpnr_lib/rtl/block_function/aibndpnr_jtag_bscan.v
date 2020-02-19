// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


module aibndpnr_jtag_bscan (
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
//   input   jtag_rx_scanen_in,	//JTAG shift DR, active high
   input   jtag_clkdr_in,	//JTAG boundary scan clock
   input   jtag_tx_scan_in,	//JTAG TX data scan in
//   input   jtag_rx_scan_in,	//JTAG TX data scan in
   input   jtag_mode_in,		//JTAG mode select
//   input   last_bs_in,    	//scan-out loopback feedthru back to SSM
   input   anlg_rstb_adap,		//IRSTB from Adaptor
   input   dig_rstb_adap,		//IRSTB from Adaptor
   input   jtag_rstb_en,	//reset_en from TAP
   input   jtag_rstb,		//reset signal from TAP
   input   jtag_intest,		//intest from TAP
   input   [2:0] irxen_adap,		//RXEN from adapter
//   input   idataselb_adap,	//idataselb tie-off for functional
//   input   iddren_adap,	//iddren tie-off for functional

   output   jtag_clkdr_out,	//CLKDR to remaining BSR
//   output   jtag_tx_scan_out,	//JTAG TX scan chain output
   output   jtag_rx_scan_out,	//JTAG TX scan chain output
   output   odat0_adap,		//sync data0 RX to HSSI Adapter
   output   odat1_adap,		//sync data1 RX to HSSI Adapter
//   output   oclkp_adap,		//diff OCLKP RX to HSSI Adapter
//   output   oclkn_adap,		//diff OCLKN RX to HSSI Adapter
   output   odat_asyn_adap,	//async data RX to HSSI Adapter
   output   itxen_aib,		//OE TX to AIB
   output   idat0_aib,		//SDR dat0 TX to AIB
   output   idat1_aib,		//SDR dat1 TX to AIB
   output   async_data_aib,	//async data TX to AIB
   output   anlg_rstb_aib,		//irstb to AIB
   output   dig_rstb_aib,		//irstb to AIB
   output   [2:0] irxen_aib,	//RXEN to AIB
   output   jtag_clkdr_outn	//inverted clkdr for sync DDR TX
//   output   idataselb_aib,	//idataselb 
//   output   iddren_aib,	//iddren
//   output   last_bs_out		//scan-out loopback feedthru back to SSM
//   output   weakpu,		//Weak Pull-up control for leakage test to AIB
//   output   weakpdn		//Weak Pull-down control for leakage test to AIB
//   output   jtag_bsdout	//Replaced with separate TX and RX Scan out

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

altr_hps_ckmux21 async_data_aib_ckmux (
					.clk_0(async_data_adap),
					.clk_1(tx_reg[4]),
					.clk_sel(jtag_mode_in),
					.clk_o(async_data_aib)
                                );

assign itxen_aib = (jtag_mode_in)? tx_reg[3] : itxen_adap;
assign irxen_aib[2] = (jtag_mode_in)? tx_reg[2] : irxen_adap[2];
assign irxen_aib[1] = (jtag_mode_in)? tx_reg[1] : irxen_adap[1];
assign irxen_aib[0] = (jtag_mode_in)? tx_reg[0] : irxen_adap[0];

assign odat0_adap = (jtag_intest)? rx_reg[4] : odat0_aib;
assign odat1_adap = (jtag_intest)? rx_reg[3] : odat1_aib;

//Change this to CKMUX
//assign odat_asyn_adap = (jtag_intest)? rx_reg[0] : odat_asyn_aib;

altr_hps_ckmux21 odat_asyn_adap_ckmux (
					.clk_0(odat_asyn_aib),
					.clk_1(rx_reg[0]),
					.clk_sel(jtag_intest),
					.clk_o(odat_asyn_adap)
				);

assign anlg_rstb_aib = (jtag_rstb_en)? jtag_rstb : anlg_rstb_adap;
assign dig_rstb_aib = (jtag_rstb_en)? jtag_rstb : dig_rstb_adap;
 
assign jtag_clkdr_out = jtag_clkdr_in;
//Change to ckinv
//assign jtag_clkdr_outn = ~jtag_clkdr_in;

altr_hps_ckinv jtag_clkdr_ckinv (
				.clk(jtag_clkdr_in),
				.clk_inv(jtag_clkdr_outn)
				);

//assign tx_shift = (jtag_tx_scanen_in) ? tx_intst : tx_reg[6:0];
// Change async_data_adap mux to CKMUX
//assign tx_shift = (jtag_tx_scanen_in) ? {jtag_tx_scan_in,tx_reg[6:1]} : tx_intst;
assign tx_shift[6:5] = (jtag_tx_scanen_in) ? {jtag_tx_scan_in,tx_reg[6]} : tx_intst[6:5];
assign tx_shift[3:0] = (jtag_tx_scanen_in) ? {tx_reg[4:1]} : tx_intst[3:0];

altr_hps_ckmux21 tx_shift_4_ckmux (
                                        .clk_0(tx_intst[4]),
                                        .clk_1(tx_reg[5]),
                                        .clk_sel(jtag_tx_scanen_in),
                                        .clk_o(tx_shift[4])
                                );

//assign tx_intst = (jtag_intest) ? {idat0_adap,idat1_adap,async_data_adap,itxen_adap,irxen_adap[2],irxen_adap[1],irxen_adap[0]} : {jtag_tx_scan_in,tx_reg[6:1]};
// Change async_data_adap mux to CKMUX
//assign tx_intst = (jtag_intest) ? {idat0_adap,idat1_adap,async_data_adap,itxen_adap,irxen_adap[2],irxen_adap[1],irxen_adap[0]} : tx_reg[6:0];
assign tx_intst[6:5] = (jtag_intest) ? {idat0_adap,idat1_adap} : tx_reg[6:5];
assign tx_intst[3:0] = (jtag_intest) ? {itxen_adap,irxen_adap[2],irxen_adap[1],irxen_adap[0]} : tx_reg[3:0];

altr_hps_ckmux21 tx_intst_4_ckmux (
                                        .clk_0(tx_reg[4]),
                                        .clk_1(async_data_adap),
                                        .clk_sel(jtag_intest),
                                        .clk_o(tx_intst[4])
                                );



always @( posedge jtag_clkdr_in )
begin
	tx_reg <= tx_shift;
end

//assign rx_shift = (jtag_tx_scanen_in) ? {tx_reg[0],rx_reg[4:1]} : {odat0_aib,odat1_aib,oclkn_aib,oclkp_aib,odat_asyn_aib}; 
//Change oclkn_aib, oclkp_aib and odat_asyn_adap to ckmux
//assign rx_shift = (jtag_tx_scanen_in) ? {tx_reg[0],rx_reg[4:1]} : {odat0_adap,odat1_adap,oclkn_aib,oclkp_aib,odat_asyn_adap};
assign rx_shift[4:3] = (jtag_tx_scanen_in) ? {tx_reg[0],rx_reg[4]} : {odat0_adap,odat1_adap};

altr_hps_ckmux21 rx_shift_2_ckmux (
                                        .clk_0(oclkn_aib),
                                        .clk_1(rx_reg[3]),
                                        .clk_sel(jtag_tx_scanen_in),
                                        .clk_o(rx_shift[2])
                                );

altr_hps_ckmux21 rx_shift_1_ckmux (
                                        .clk_0(oclkp_aib),
                                        .clk_1(rx_reg[2]),
                                        .clk_sel(jtag_tx_scanen_in),
                                        .clk_o(rx_shift[1])
                                );

altr_hps_ckmux21 rx_shift_0_ckmux (
                                        .clk_0(odat_asyn_adap),
                                        .clk_1(rx_reg[1]),
                                        .clk_sel(jtag_tx_scanen_in),
                                        .clk_o(rx_shift[0])
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
