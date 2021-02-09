// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibnd_bsr_red_wrap schematic"


// Library - aibnd_lib(// Library - aibnd_lib), Cell - aibnd_bsr_red_wrap, View - schematic
// LAST TIME SAVED: Oct 24 09:56:41 2014
// NETLIST TIME: Oct 29 15:26:36 2014

module aibnd_bsr_red_wrap ( anlg_rstb_aib, async_data_aib,
     dig_rstb_aib, iclkin_dist_out, idat0_aib, idat1_aib,
     idataselb_out, iddren_out, ilaunch_clk_out, ilpbk_dat_out,
     ilpbk_en_out, indrv_out, ipdrv_out, irxen_out, istrbclk_out,
     itxen_aib, jtag_clkdr_out, jtag_rx_scan_out, jtag_tx_scan_out,
     last_bs_out, oclk_out, oclkb_out, odat0_out, odat1_out,
     odat_async_out, pd_data_out, anlg_rstb_adap,			//removed VCCL & VSS port
     async_dat_in0, async_dat_in1, dig_rstb_adap, iclkin_dist_in0,
     iclkin_dist_in1, idata0_in0, idata0_in1, idata1_in0, idata1_in1,
     idataselb_in0, idataselb_in1, iddren_in0, iddren_in1,
     ilaunch_clk_in0, ilaunch_clk_in1, ilpbk_dat_in0, ilpbk_dat_in1,
     ilpbk_en_in0, ilpbk_en_in1, indrv_in0, indrv_in1, ipdrv_in0,
     ipdrv_in1, irxen_in0, irxen_in1, istrbclk_in0, istrbclk_in1,
     itxen_in0, itxen_in1, jtag_clkdr_in, jtag_loopbacken_in,
     jtag_mode_in, jtag_rst_en, jtag_rstb, jtag_rx_scan_in,
     jtag_rx_scanen_in, jtag_tx_scan_in, jtag_tx_scanen_in, last_bs_in,
     oclk_aib, oclk_in0, oclk_in1, oclkb_in0, oclkb_in1, odat0_aib,
     odat0_in0, odat0_in1, odat1_aib, odat1_in0, odat1_in1,
     odat_asyn_aib, odat_async_in0, odat_async_in1, pd_data_in0,
     pd_data_in1, shift_en );

output  anlg_rstb_aib, async_data_aib, dig_rstb_aib, iclkin_dist_out,
     idat0_aib, idat1_aib, idataselb_out, iddren_out, ilaunch_clk_out,
     ilpbk_dat_out, ilpbk_en_out, istrbclk_out, itxen_aib,
     jtag_clkdr_out, jtag_rx_scan_out, jtag_tx_scan_out, last_bs_out,
     oclk_out, oclkb_out, odat0_out, odat1_out, odat_async_out,
     pd_data_out;

//input  vccl, vssl;

input  anlg_rstb_adap, async_dat_in0, async_dat_in1, dig_rstb_adap,
     iclkin_dist_in0, iclkin_dist_in1, idata0_in0, idata0_in1,
     idata1_in0, idata1_in1, idataselb_in0, idataselb_in1, iddren_in0,
     iddren_in1, ilaunch_clk_in0, ilaunch_clk_in1, ilpbk_dat_in0,
     ilpbk_dat_in1, ilpbk_en_in0, ilpbk_en_in1, istrbclk_in0,
     istrbclk_in1, itxen_in0, itxen_in1, jtag_clkdr_in,
     jtag_loopbacken_in, jtag_mode_in, jtag_rst_en, jtag_rstb,
     jtag_rx_scan_in, jtag_rx_scanen_in, jtag_tx_scan_in,
     jtag_tx_scanen_in, last_bs_in, oclk_aib, oclk_in0, oclk_in1,
     oclkb_in0, oclkb_in1, odat0_aib, odat0_in0, odat0_in1, odat1_aib,
     odat1_in0, odat1_in1, odat_asyn_aib, odat_async_in0,
     odat_async_in1, pd_data_in0, pd_data_in1, shift_en;

output [2:0]  irxen_out;
output [1:0]  ipdrv_out;
output [1:0]  indrv_out;

input [1:0]  indrv_in1;
input [2:0]  irxen_in0;
input [1:0]  ipdrv_in1;
input [2:0]  irxen_in1;
input [1:0]  ipdrv_in0;
input [1:0]  indrv_in0;


aibnd_redundancy xredundancy ( //input of input mux
pd_data_in1, pd_data_in0, iclkin_dist_in1, iclkin_dist_in0, idata0_in1, idata0_in0, idata1_in1, idata1_in0,
idataselb_in1, idataselb_in0, iddren_in1, iddren_in0, ilaunch_clk_in1, ilaunch_clk_in0, ilpbk_dat_in1, ilpbk_dat_in0, ilpbk_en_in1, ilpbk_en_in0,
irxen_in1, irxen_in0, istrbclk_in1, istrbclk_in0, itxen_in1, itxen_in0, indrv_in1, indrv_in0, ipdrv_in1, ipdrv_in0, async_dat_in1, async_dat_in0,
//Output of input mux
iclkin_dist_out, idata0_out, idata1_out, idataselb_out, iddren_out,  ilaunch_clk_out, ilpbk_dat_out, ilpbk_en_out,
irxen_out, istrbclk_out, itxen_out, indrv_out, ipdrv_out, async_dat_out,

//input of output mux
oclkb_in1, oclkb_in0, oclk_in1, oclk_in0, odat0_in1, odat0_in0, odat1_in1, odat1_in0, odat_async_in1, odat_async_in0,

//Output of output mux
pd_data_out, oclkb_out, oclk_out, odat0_out, odat1_out, odat_async_out,

//Mux selection signal
shift_en );	//removed VCCL & VSS port



aibnd_jtag_bscan xjtag(
.odat0_aib(odat0_aib),           //sync data0 RX from AIB
.odat1_aib(odat1_aib),           //sync data1 RX from AIB
.odat_asyn_aib(odat_asyn_aib),       //async data RX from AIB
.oclk_aib(oclk_aib),            //diff clk RX from AIB
.itxen_adap(itxen_out),           //OE TX from HSSI Adapter
.idat0_adap(idata0_out),           //SDR dat0 TX from HSSI Adapter
.idat1_adap(idata1_out),           //SDR dat1 TX from HSSI Adapter
.async_data_adap(async_dat_out),      //async data TX from HSSI Adapter
.jtag_tx_scanen_in(jtag_tx_scanen_in),   //JTAG shift DR, active high
.jtag_rx_scanen_in(jtag_rx_scanen_in),   //JTAG shift DR, active high
.jtag_clkdr_in(jtag_clkdr_in),       //JTAG boundary scan clock
.jtag_tx_scan_in(jtag_tx_scan_in),     //JTAG TX data scan in
.jtag_rx_scan_in(jtag_rx_scan_in),     //JTAG TX data scan in
.jtag_mode_in(jtag_mode_in),                //JTAG mode select


//.jtag_loopbacken_in(jtag_loopbacken_in),          //HIJACK_DFT  TW: need to remove from top level schematic
.last_bs_in(last_bs_in),          //scan-out loopback feedthru back to SSM
.anlg_rstb_adap(anlg_rstb_adap),           //IRSTB from Adaptor
.dig_rstb_adap(dig_rstb_adap),           //IRSTB from Adaptor
.jtag_rstb_en(jtag_rst_en),         //reset_en from TAP
.jtag_rstb(jtag_rstb),           //reset signal from TAP

.jtag_clkdr_out(jtag_clkdr_out),     //CLKDR to remaining BSR
.jtag_tx_scan_out(jtag_tx_scan_out),   //JTAG TX scan chain output
.jtag_rx_scan_out(jtag_rx_scan_out),   //JTAG TX scan chain output
.odat0_adap(),          //sync data0 RX to HSSI Adapter
.odat1_adap(),          //sync data1 RX to HSSI Adapter
.oclk_adap(),           //sync data1 RX to HSSI Adapter
.odat_asyn_adap(),      //async data RX to HSSI Adapter
.itxen_aib(itxen_aib),          //OE TX to AIB
.idat0_aib(idat0_aib),          //SDR dat0 TX to AIB
.idat1_aib(idat1_aib),          //SDR dat1 TX to AIB
.async_data_aib(async_data_aib),     //async data TX to AIB
.anlg_rstb_aib(anlg_rstb_aib),          //irstb to AIB
.dig_rstb_aib(dig_rstb_aib),          //irstb to AIB
.last_bs_out(last_bs_out)         //scan-out loopback feedthru back to SSM

);


endmodule


// End HDL models


