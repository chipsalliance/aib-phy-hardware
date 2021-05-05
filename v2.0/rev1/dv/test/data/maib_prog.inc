///////////////////////////////////////////////////////////////////////////////////////////
//This file is to program FPGA 24 channel MAIB
//24 channel configuration
//CH[23:0]: 2xFIFO, 78 datain/out, DCC/DLL enabled
///////////////////////////////////////////////////////////////////////////////////////////

`define Concat(a,b) a``b
`define MAIB_DUT dut_slave1.u_maib_
`define MAIB_SUB ndut.hdpldadapt.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping
`define maib_fifo2x_ch(lane)\
//initial\
//begin\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.aib_csr_ctrl[463:0]  = 464'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1200_7d1a_0000_0000_0004_0002_45d3_3b07_b000_0040_0002_0000_2699_0000_0000_0000_0000_0000_0000;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.aib_dprio_ctrl[39:0]      = 40'h18000000;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm1_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm1_dprio_ctrl[7:0]     = 8'h0;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm2_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm2_dprio_ctrl[7:0]     = 8'h0;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm_csr_ctrl[55:0]       = 56'h00_0018_0000_0300;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm_res_csr_ctrl[7:0]    = 8'h0;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.rx_chnl_dprio_ctrl[167:0] = 168'hc8_17c8_c105_6c42_0040_4040_4c00_0303_0018_ca82_4f01;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.sr_dprio_ctrl[23:0]       = 24'h0;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e086_11c5_00ce_2308_008b_0300_6a22_ee00;\
     force `Concat(`MAIB_DUT,lane).ndut.hdpldadapt.hdpldadapt_avmm.r_rx_async_pld_pma_ltd_b_rst_val = 1'b0;\
     force `Concat(`MAIB_DUT,lane).`MAIB_SUB.avmm_csr_ctrl[18] = 1'b1;\
//end

`maib_fifo2x_ch( 0)
`maib_fifo2x_ch( 1)
`maib_fifo2x_ch( 2)
`maib_fifo2x_ch( 3)
`maib_fifo2x_ch( 4)
`maib_fifo2x_ch( 5)
`maib_fifo2x_ch( 6)
`maib_fifo2x_ch( 7)
`maib_fifo2x_ch( 8)
`maib_fifo2x_ch( 9)
`maib_fifo2x_ch(10)
`maib_fifo2x_ch(11)
`maib_fifo2x_ch(12)
`maib_fifo2x_ch(13)
`maib_fifo2x_ch(14)
`maib_fifo2x_ch(15)
`maib_fifo2x_ch(16)
`maib_fifo2x_ch(17)
`maib_fifo2x_ch(18)
`maib_fifo2x_ch(19)
`maib_fifo2x_ch(20)
`maib_fifo2x_ch(21)
`maib_fifo2x_ch(22)
`maib_fifo2x_ch(23)
