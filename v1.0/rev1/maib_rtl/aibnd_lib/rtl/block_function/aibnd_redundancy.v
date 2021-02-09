// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_redundancy ( //input of input mux
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
shift_en	//Removed VCCL & VSS port

);

//Power Supply
//input  vccl, vssl;

//Mux selection signal
input shift_en;

//input of input mux
input iclkin_dist_in1, iclkin_dist_in0;
input idata0_in1, idata0_in0; 
input idata1_in1, idata1_in0;
input idataselb_in1, idataselb_in0;
input iddren_in1, iddren_in0;
input ilaunch_clk_in1, ilaunch_clk_in0;
input ilpbk_dat_in1, ilpbk_dat_in0;
input ilpbk_en_in1, ilpbk_en_in0;
input [2:0] irxen_in1, irxen_in0;
input istrbclk_in1, istrbclk_in0;
input itxen_in1, itxen_in0; 
input [1:0] indrv_in1, indrv_in0; 
input [1:0] ipdrv_in1, ipdrv_in0;
input async_dat_in1, async_dat_in0;

//output of input mux
output iclkin_dist_out;
output idata0_out; 
output idata1_out;
output idataselb_out;
output iddren_out;
output ilaunch_clk_out;
output ilpbk_dat_out;
output ilpbk_en_out;
output [2:0] irxen_out;
output istrbclk_out;
output itxen_out; 
output [1:0] indrv_out; 
output [1:0] ipdrv_out;
output async_dat_out;


//input of output mux
input pd_data_in1, pd_data_in0;
input oclkb_in1, oclkb_in0;
input oclk_in1, oclk_in0; 
input odat0_in1, odat0_in0; 
input odat1_in1, odat1_in0;
input odat_async_in1, odat_async_in0;

//output of output mux
output pd_data_out;
output oclkb_out;
output oclk_out;
output odat0_out; 
output odat1_out;
output odat_async_out;

// Buses in the design


//input mux
assign iclkin_dist_out = shift_en? iclkin_dist_in1 : iclkin_dist_in0 ;
assign idata0_out = shift_en? idata0_in1 : idata0_in0;
assign idata1_out = shift_en? idata1_in1 : idata1_in0;
assign idataselb_out = shift_en? idataselb_in1 : idataselb_in0 ;
assign iddren_out = shift_en? iddren_in1 : iddren_in0;
assign ilaunch_clk_out = shift_en? ilaunch_clk_in1 : ilaunch_clk_in0 ;
assign ilpbk_dat_out = shift_en? ilpbk_dat_in1 : ilpbk_dat_in0 ;
assign ilpbk_en_out = shift_en? ilpbk_en_in1 : ilpbk_en_in0 ;
assign irxen_out[2] = shift_en? irxen_in1[2] : irxen_in0[2];
assign irxen_out[1] = shift_en? irxen_in1[1] : irxen_in0[1];
assign irxen_out[0] = shift_en? irxen_in1[0] : irxen_in0[0];
assign istrbclk_out = shift_en? istrbclk_in1 : istrbclk_in0;
assign itxen_out = shift_en? itxen_in1 : itxen_in0;
assign indrv_out[1] = shift_en? indrv_in1[1] : indrv_in0[1];
assign indrv_out[0] = shift_en? indrv_in1[0] : indrv_in0[0];
assign ipdrv_out[1] = shift_en? ipdrv_in1[1] : ipdrv_in0[1];
assign ipdrv_out[0] = shift_en? ipdrv_in1[0] : ipdrv_in0[0];
assign async_dat_out = shift_en? async_dat_in1 : async_dat_in0;

//output mux
assign pd_data_out = shift_en? pd_data_in1 : pd_data_in0;
assign oclkb_out = shift_en? oclkb_in1 : oclkb_in0;
assign oclk_out = shift_en? oclk_in1 : oclk_in0;
assign odat0_out = shift_en? odat0_in1 : odat0_in0;
assign odat1_out = shift_en? odat1_in1 : odat1_in0;
assign odat_async_out = shift_en? odat_async_in1 : odat_async_in0;

endmodule


