// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_bsr_red_wrap
// Description    : Behavioral model of JTAG and redundancy wrapper for IO
// Revision       : 1.0
// ============================================================================
module aib_bsr_red_wrap ( async_data_out,
     dig_rstb_aib, idata0_out, idata1_out,
     idataselb_out, iddren_out,
     irxen_out,
     itxen_out, jtag_clkdr_out, jtag_rx_scan_out, 
     odat0_out, odat1_out,
     odat_async_out, 
     async_dat_in0, async_dat_in1, dig_rstb_adap,
     idata0_in0, idata0_in1, idata1_in0, idata1_in1,
     idataselb_in0, idataselb_in1, iddren_in0, iddren_in1,
     irxen_in0, irxen_in1,
     itxen_in0, itxen_in1, jtag_clkdr_in, 
     jtag_mode_in, jtag_rstb_en, jtag_rstb,
     jtag_tx_scan_in, jtag_tx_scanen_in,
     oclk_in, oclkb_in,
     odat0_in0, odat0_in1, odat1_in0, odat1_in1,
     odat_async_in0, odat_async_in1,
     shift_en, jtag_intest, jtag_clkdr_outn, idata0_red, idata1_red, async_dat_red 
     );

output  async_data_out, dig_rstb_aib,
     idata0_out, idata1_out, idataselb_out, iddren_out,
     itxen_out,
     jtag_clkdr_out, jtag_clkdr_outn, jtag_rx_scan_out, 
     odat0_out, odat1_out, odat_async_out;


input  async_dat_in0, async_dat_in1, dig_rstb_adap,
     idata0_in0, idata0_in1,
     idata1_in0, idata1_in1, idataselb_in0, idataselb_in1, iddren_in0,
     iddren_in1,
     itxen_in0, itxen_in1, jtag_clkdr_in,
     jtag_mode_in, jtag_rstb_en, jtag_rstb,
     jtag_tx_scan_in,
     jtag_tx_scanen_in,
     oclk_in, oclkb_in,
     odat0_in0, odat0_in1,
     odat1_in0, odat1_in1, odat_async_in0,
     odat_async_in1, shift_en;

output [2:0]  irxen_out;
output idata0_red;
output idata1_red;
output async_dat_red;

input [2:0]  irxen_in0;
input [2:0]  irxen_in1;
input jtag_intest;

wire [2:0] irxen_red;
wire odat0_red;
wire odat1_red;
wire odat_async_red;
wire itxen_red;

aib_redundancy xredundancy ( 
//input of input mux
.idata0_in1(idata0_in1), 
.idata0_in0(idata0_red), 
.idata1_in1(idata1_in1), 
.idata1_in0(idata1_red),
.idataselb_in1(idataselb_in1), 
.idataselb_in0(idataselb_in0), 
.iddren_in1(iddren_in1), 
.iddren_in0(iddren_in0), 
.irxen_in1(irxen_in1), 
.irxen_in0(irxen_red), 
.itxen_in1(itxen_in1), 
.itxen_in0(itxen_red), 
.async_dat_in1(async_dat_in1), 
.async_dat_in0(async_dat_red),
//Output of input mux
.idata0_out(idata0_out), 
.idata1_out(idata1_out), 
.idataselb_out(idataselb_out), 
.iddren_out(iddren_out),  
.irxen_out(irxen_out), 
.itxen_out(itxen_out), 
.async_dat_out(async_data_out),

//input of output mux
.odat0_in1(odat0_in1), 
.odat0_in0(odat0_in0), 
.odat1_in1(odat1_in1), 
.odat1_in0(odat1_in0), 
.odat_async_in1(odat_async_in1), 
.odat_async_in0(odat_async_in0),

//Output of output mux
.odat0_out(odat0_red), 
.odat1_out(odat1_red), 
.odat_async_out(odat_async_red),

//Mux selection signal
.shift_en(shift_en)
 );	


aib_jtag_bscan xjtag(
.odat0_aib(odat0_red),           //sync data0 RX from AIB
.odat1_aib(odat1_red),           //sync data1 RX from AIB
.odat_asyn_aib(odat_async_red),       //async data RX from AIB
.oclkp_aib(oclk_in),            //diff clk RX from AIB
.oclkn_aib(oclkb_in),            //diff clk RX from AIB
.itxen_adap(itxen_in0),           //OE TX from HSSI Adapter
.idat0_adap(idata0_in0),           //SDR dat0 TX from HSSI Adapter
.idat1_adap(idata1_in0),           //SDR dat1 TX from HSSI Adapter
.async_data_adap(async_dat_in0),      //async data TX from HSSI Adapter
.jtag_tx_scanen_in(jtag_tx_scanen_in),   //JTAG shift DR, active high
.jtag_clkdr_in(jtag_clkdr_in),       //JTAG boundary scan clock
.jtag_tx_scan_in(jtag_tx_scan_in),     //JTAG TX data scan in
.jtag_mode_in(jtag_mode_in),                //JTAG mode select


.dig_rstb_adap(dig_rstb_adap),           //IRSTB from Adaptor
.jtag_rstb_en(jtag_rstb_en),         //reset_en from TAP
.jtag_rstb(jtag_rstb),           //reset signal from TAP
.jtag_intest(jtag_intest),
.irxen_adap(irxen_in0),

.jtag_clkdr_out(jtag_clkdr_out),     //CLKDR to remaining BSR
.jtag_rx_scan_out(jtag_rx_scan_out),   //JTAG TX scan chain output
.odat0_adap(odat0_out),          //sync data0 RX to HSSI Adapter
.odat1_adap(odat1_out),          //sync data1 RX to HSSI Adapter
.odat_asyn_adap(odat_async_out),      //async data RX to HSSI Adapter
.itxen_aib(itxen_red),          //OE TX to AIB
.idat0_aib(idata0_red),          //SDR dat0 TX to AIB
.idat1_aib(idata1_red),          //SDR dat1 TX to AIB
.async_data_aib(async_dat_red),     //async data TX to AIB
.dig_rstb_aib(dig_rstb_aib),          //irstb to AIB
.irxen_aib(irxen_red),
.jtag_clkdr_outn(jtag_clkdr_outn)
);


endmodule


// End HDL models

