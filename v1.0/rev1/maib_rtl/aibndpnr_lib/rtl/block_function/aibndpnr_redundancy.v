// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibndpnr_redundancy ( //input of input mux
idata0_in1, idata0_in0, idata1_in1, idata1_in0, 
idataselb_in1, idataselb_in0, iddren_in1, iddren_in0,
irxen_in1, irxen_in0, itxen_in1, itxen_in0, indrv_in1, indrv_in0, ipdrv_in1, ipdrv_in0, async_dat_in1, async_dat_in0, 
//Output of input mux
idata0_out, idata1_out, idataselb_out, iddren_out,
irxen_out, itxen_out, indrv_out, ipdrv_out, async_dat_out,

//input of output mux
odat0_in1, odat0_in0, odat1_in1, odat1_in0, odat_async_in1, odat_async_in0,

//Output of output mux
odat0_out, odat1_out, odat_async_out,

//Mux selection signal
shift_en	//Removed VCCL & VSS port

);

//Power Supply
//input  vccl, vssl;

//Mux selection signal
input shift_en;

//input of input mux
input idata0_in1, idata0_in0; 
input idata1_in1, idata1_in0;
input idataselb_in1, idataselb_in0;
input iddren_in1, iddren_in0;
input [2:0] irxen_in1, irxen_in0;
input itxen_in1, itxen_in0; 
input [1:0] indrv_in1, indrv_in0; 
input [1:0] ipdrv_in1, ipdrv_in0;
input async_dat_in1, async_dat_in0;

//output of input mux
output idata0_out; 
output idata1_out;
output idataselb_out;
output iddren_out;
output [2:0] irxen_out;
output itxen_out; 
output [1:0] indrv_out; 
output [1:0] ipdrv_out;
output async_dat_out;


//input of output mux
input odat0_in1, odat0_in0; 
input odat1_in1, odat1_in0;
input odat_async_in1, odat_async_in0;

//output of output mux
output odat0_out; 
output odat1_out;
output odat_async_out;

// Buses in the design


//input mux
assign idata0_out = shift_en? idata0_in1 : idata0_in0;
assign idata1_out = shift_en? idata1_in1 : idata1_in0;
assign idataselb_out = shift_en? idataselb_in1 : idataselb_in0 ;
assign iddren_out = shift_en? iddren_in1 : iddren_in0;
assign irxen_out[2] = shift_en? irxen_in1[2] : irxen_in0[2];
assign irxen_out[1] = shift_en? irxen_in1[1] : irxen_in0[1];
assign irxen_out[0] = shift_en? irxen_in1[0] : irxen_in0[0];
assign itxen_out = shift_en? itxen_in1 : itxen_in0;
assign indrv_out[1] = shift_en? indrv_in1[1] : indrv_in0[1];
assign indrv_out[0] = shift_en? indrv_in1[0] : indrv_in0[0];
assign ipdrv_out[1] = shift_en? ipdrv_in1[1] : ipdrv_in0[1];
assign ipdrv_out[0] = shift_en? ipdrv_in1[0] : ipdrv_in0[0];

//Change to CKMUX
//assign async_dat_out = shift_en? async_dat_in1 : async_dat_in0;

altr_hps_ckmux21 async_dat_out_ckmux (
                                        .clk_0(async_dat_in0),
                                        .clk_1(async_dat_in1),
                                        .clk_sel(shift_en),
                                        .clk_o(async_dat_out)
                                );


//output mux
assign odat0_out = shift_en? odat0_in1 : odat0_in0;
assign odat1_out = shift_en? odat1_in1 : odat1_in0;

//Change to CKMUX
//assign odat_async_out = shift_en? odat_async_in1 : odat_async_in0;

altr_hps_ckmux21 odat_async_out_ckmux (
                                        .clk_0(odat_async_in0),
                                        .clk_1(odat_async_in1),
                                        .clk_sel(shift_en),
                                        .clk_o(odat_async_out)
                                );

endmodule

