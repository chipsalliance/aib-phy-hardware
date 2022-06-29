// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_redundancy_logic(
        input  idata_in0_even,        
        input  idata_in1_even,        
        output wire data_out_even,    

        input  idata_in0_odd,         
        input  idata_in1_odd,         
        output wire data_out_odd,     

        input async_in0,              
        input async_in1,              
        output wire async_out,        

        input tx_en0,                 
        input tx_en1,                 
        output wire tx_en_out,        

        input rx_en0,                 
        input rx_en1,                 
        output wire rx_en_out,        

        input async_tx_en0,           
        input async_tx_en1,           
        output wire async_tx_en_out,  

        input async_rx_en0,
        input async_rx_en1,
        output wire async_rx_en_out,

        input sdr_mode_en0,
        input sdr_mode_en1,
        output wire sdr_mode_en_out,

        input  wkpu_en_in0,
        input  wkpu_en_in1,
        output wkpu_en_out,

        input  wkpd_en_in0,
        input  wkpd_en_in1,
        output wkpd_en_out,

        input shift_en
        );

assign data_out_even = shift_en ? idata_in1_even  : idata_in0_even;
assign data_out_odd  = shift_en ? idata_in1_odd   : idata_in0_odd ;

assign async_out     = shift_en ? async_in1       : async_in0 ;

assign tx_en_out     = shift_en ? tx_en1 : tx_en0 ;
assign rx_en_out     = shift_en ? rx_en1 : rx_en0 ;

assign async_tx_en_out     = shift_en ? async_tx_en1 : async_tx_en0 ;
assign async_rx_en_out     = shift_en ? async_rx_en1 : async_rx_en0 ;

assign sdr_mode_en_out     = shift_en ? sdr_mode_en1 : sdr_mode_en0 ;

assign wkpu_en_out = shift_en ? wkpu_en_in1 : wkpu_en_in0;
assign wkpd_en_out = shift_en ? wkpd_en_in1 : wkpd_en_in0;

endmodule
