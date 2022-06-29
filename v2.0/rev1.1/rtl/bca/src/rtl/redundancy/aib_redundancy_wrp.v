// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_redundancy_wrp (
        input       [101:0] pad_shift,

        input       [101:0] pad_even_data_in,
        input       [101:0] pad_odd_data_in,
        input       [101:0] pad_async_in,

        output wire [101:0] pad_async_out,
        output wire [101:0] pad_even_data_out,
        output wire [101:0] pad_odd_data_out,

        input       [101:0] pad_tx_en,
        input       [101:0] pad_rx_en,
        input       [101:0] pad_async_tx_en,
        input       [101:0] pad_async_rx_en,
        input       [101:0] pad_sdr_mode_en,
        input       [101:0] wkpu_en_in,
        input       [101:0] wkpd_en_in,

        output wire [101:0] pad_tx_en_out,
        output wire [101:0] pad_rx_en_out,
        output wire [101:0] pad_async_tx_en_out,
        output wire [101:0] pad_async_rx_en_out,
        output wire [101:0] pad_sdr_mode_en_out,
        output wire [101:0] wkpu_en_out,
        output wire [101:0] wkpd_en_out

);

//===========================================
// Microbumps that conect to only one signal
//===========================================
assign pad_even_data_out[0]   = pad_even_data_in[0];
assign pad_odd_data_out[0]    = pad_odd_data_in[0];
assign pad_even_data_out[1]   = pad_even_data_in[1];
assign pad_odd_data_out[1]    = pad_odd_data_in[1];

assign pad_even_data_out[100] = (pad_shift[100] == 1'b1) ? pad_even_data_in[98] : pad_even_data_in[100];
assign pad_odd_data_out[100]  = (pad_shift[100] == 1'b1) ? pad_odd_data_in[98]  : pad_odd_data_in[100];
assign pad_even_data_out[101] = (pad_shift[101] == 1'b1) ? pad_even_data_in[99] : pad_even_data_in[101];
assign pad_odd_data_out[101]  = (pad_shift[101] == 1'b1) ? pad_odd_data_in[99]  : pad_odd_data_in[101];

assign pad_async_out[0]   = pad_async_in[0];
assign pad_async_out[1]   = pad_async_in[1];
assign pad_async_out[100] = (pad_shift[100] == 1'b1) ? pad_async_in[98] : pad_async_in[100];
assign pad_async_out[101] = (pad_shift[101] == 1'b1) ? pad_async_in[99] : pad_async_in[101];

assign pad_tx_en_out[0]   = pad_tx_en[0];
assign pad_tx_en_out[1]   = pad_tx_en[1];
assign pad_tx_en_out[100] = pad_tx_en[100];
assign pad_tx_en_out[101] = pad_tx_en[101];

assign pad_rx_en_out[0]   = pad_rx_en[0];
assign pad_rx_en_out[1]   = pad_rx_en[1];
assign pad_rx_en_out[100] = pad_rx_en[100];
assign pad_rx_en_out[101] = pad_rx_en[101];

assign pad_async_tx_en_out[0]   = pad_async_tx_en[0];
assign pad_async_tx_en_out[1]   = pad_async_tx_en[1];
assign pad_async_tx_en_out[100] = pad_async_tx_en[100];
assign pad_async_tx_en_out[101] = pad_async_tx_en[101];

assign pad_async_rx_en_out[0]   = pad_async_rx_en[0];
assign pad_async_rx_en_out[1]   = pad_async_rx_en[1];
assign pad_async_rx_en_out[100] = pad_async_rx_en[100];
assign pad_async_rx_en_out[101] = pad_async_rx_en[101];

assign pad_sdr_mode_en_out[0]   = pad_sdr_mode_en[0];
assign pad_sdr_mode_en_out[1]   = pad_sdr_mode_en[1];
assign pad_sdr_mode_en_out[100] = pad_sdr_mode_en[100];
assign pad_sdr_mode_en_out[101] = pad_sdr_mode_en[101];

assign wkpu_en_out[0]   = wkpu_en_in[0];
assign wkpu_en_out[1]   = wkpu_en_in[1];
assign wkpu_en_out[100] = wkpu_en_in[100];
assign wkpu_en_out[101] = wkpu_en_in[101];

assign wkpd_en_out[0]   = wkpd_en_in[0];
assign wkpd_en_out[1]   = wkpd_en_in[1];
assign wkpd_en_out[100] = wkpd_en_in[100];
assign wkpd_en_out[101] = wkpd_en_in[101];


//=======================================================
// Microbumps connect to three signals(aib[50] & aib[51])
//=======================================================
assign pad_even_data_out[50] = (pad_shift[48] == 1'b1) ? pad_even_data_in[48] : pad_even_data_in[50];
assign pad_odd_data_out[50]  = (pad_shift[48] == 1'b1) ? pad_odd_data_in[48]  : pad_odd_data_in[50];

assign pad_even_data_out[51] = (pad_shift[49] == 1'b1) ? pad_even_data_in[49] : pad_even_data_in[51];
assign pad_odd_data_out[51]  = (pad_shift[49] == 1'b1) ? pad_odd_data_in[49]  : pad_even_data_in[51];

assign pad_async_out[50]     = (pad_shift[48] == 1'b1) ? pad_async_in[48] : pad_async_in[50];
assign pad_async_out[51]     = (pad_shift[49] == 1'b1) ? pad_async_in[49] : pad_async_in[51];

//Muxing Enable signals
assign pad_tx_en_out[50]     = (pad_shift[48] == 1'b1) ? pad_tx_en[48] : (pad_shift[52] == 1'b1) ? pad_tx_en[52] : pad_tx_en[50];
assign pad_tx_en_out[51]     = (pad_shift[49] == 1'b1) ? pad_tx_en[49] : (pad_shift[53] == 1'b1) ? pad_tx_en[53] : pad_tx_en[51];

assign pad_rx_en_out[50]     = (pad_shift[48] == 1'b1) ? pad_rx_en[48] : (pad_shift[52] == 1'b1) ? pad_rx_en[52] : pad_rx_en[50];
assign pad_rx_en_out[51]     = (pad_shift[49] == 1'b1) ? pad_rx_en[49] : (pad_shift[53] == 1'b1) ? pad_rx_en[53] : pad_rx_en[51];

assign pad_async_tx_en_out[50] = (pad_shift[48] == 1'b1) ? pad_async_tx_en[48] : (pad_shift[52] == 1'b1) ? pad_async_tx_en[52] : pad_async_tx_en[50];
assign pad_async_tx_en_out[51] = (pad_shift[49] == 1'b1) ? pad_async_tx_en[49] : (pad_shift[53] == 1'b1) ? pad_async_tx_en[53] : pad_async_tx_en[51];

assign pad_async_rx_en_out[50] = (pad_shift[48] == 1'b1) ? pad_async_rx_en[48] : (pad_shift[52] == 1'b1) ? pad_async_rx_en[52] : pad_async_rx_en[50];
assign pad_async_rx_en_out[51] = (pad_shift[49] == 1'b1) ? pad_async_rx_en[49] : (pad_shift[53] == 1'b1) ? pad_async_rx_en[53] : pad_async_rx_en[51];

assign pad_sdr_mode_en_out[50] = (pad_shift[48] == 1'b1) ? pad_sdr_mode_en[48] : (pad_shift[52] == 1'b1) ? pad_sdr_mode_en[52] : pad_sdr_mode_en[50];
assign pad_sdr_mode_en_out[51] = (pad_shift[49] == 1'b1) ? pad_sdr_mode_en[49] : (pad_shift[53] == 1'b1) ? pad_sdr_mode_en[53] : pad_sdr_mode_en[51];

assign wkpu_en_out[50] = (pad_shift[48] == 1'b1) ? wkpu_en_in[48] :
                         (pad_shift[52] == 1'b1) ? wkpu_en_in[52] : wkpu_en_in[50];
assign wkpu_en_out[51] = (pad_shift[49] == 1'b1) ? wkpu_en_in[49] :
                         (pad_shift[53] == 1'b1) ? wkpu_en_in[53] : wkpu_en_in[51];

assign wkpd_en_out[50] = (pad_shift[48] == 1'b1) ? wkpd_en_in[48] :
                         (pad_shift[52] == 1'b1) ? wkpd_en_in[52] : wkpd_en_in[50];
assign wkpd_en_out[51] = (pad_shift[49] == 1'b1) ? wkpd_en_in[49] :
                         (pad_shift[53] == 1'b1) ? wkpd_en_in[53] : wkpd_en_in[51];


genvar i;

//===================================================
// Shift up from Lower numbered Microbumps [0 to 49]
//===================================================
generate
  for(i=2; i<50; i=i+1)
   begin: iopads_0_49
    aib_redundancy_logic
        i_aib_redundancy (
                .idata_in0_even(pad_even_data_in[i]),
                .idata_in1_even(pad_even_data_in[i-2]),
                .data_out_even (pad_even_data_out[i]),

                .idata_in0_odd(pad_odd_data_in[i]),
                .idata_in1_odd(pad_odd_data_in[i-2]),
                .data_out_odd (pad_odd_data_out[i]),
                //Async Signals
                .async_in0(pad_async_in[i]),
                .async_in1(pad_async_in[i-2]),
                .async_out(pad_async_out[i]),

                .tx_en0(pad_tx_en[i]),
                .tx_en1(pad_tx_en[i-2]),
                .tx_en_out(pad_tx_en_out[i]),

                .rx_en0(pad_rx_en[i]),
                .rx_en1(pad_rx_en[i-2]),
                .rx_en_out(pad_rx_en_out[i]),

                .async_tx_en0(pad_async_tx_en[i]),
                .async_tx_en1(pad_async_tx_en[i-2]),
                .async_tx_en_out(pad_async_tx_en_out[i]),

                .async_rx_en0(pad_async_rx_en[i]),
                .async_rx_en1(pad_async_rx_en[i-2]),
                .async_rx_en_out(pad_async_rx_en_out[i]),

                .sdr_mode_en0(pad_sdr_mode_en[i]),
                .sdr_mode_en1(pad_sdr_mode_en[i-2]),
                .sdr_mode_en_out(pad_sdr_mode_en_out[i]),
                
                .wkpu_en_in0 (wkpu_en_in[i]),
                .wkpu_en_in1 (wkpu_en_in[i-2]),
                .wkpu_en_out (wkpu_en_out[i]),

                .wkpd_en_in0 (wkpd_en_in[i]),
                .wkpd_en_in1 (wkpd_en_in[i-2]),
                .wkpd_en_out (wkpd_en_out[i]),
                
                .shift_en(pad_shift[i])
        );
  end
endgenerate

//=====================================================
// Shift down from Higher numbered Microbump[99 to 52]
//=====================================================
generate
  for(i=99; i>51; i=i-1)
   begin: iopads_52_99
    aib_redundancy_logic
        i_aib_redundancy (
                .idata_in0_even(pad_even_data_in[i]),
                .idata_in1_even(pad_even_data_in[i-2]),
                .data_out_even (pad_even_data_out[i]),

                .idata_in0_odd(pad_odd_data_in[i]),
                .idata_in1_odd(pad_odd_data_in[i-2]),
                .data_out_odd (pad_odd_data_out[i]),
                //Async Signals
                .async_in0(pad_async_in[i]),
                .async_in1(pad_async_in[i-2]),
                .async_out(pad_async_out[i]),

                .tx_en0(pad_tx_en[i]),
                .tx_en1(pad_tx_en[i+2]),
                .tx_en_out(pad_tx_en_out[i]),

                .rx_en0(pad_rx_en[i]),
                .rx_en1(pad_rx_en[i+2]),
                .rx_en_out(pad_rx_en_out[i]),

                .async_tx_en0(pad_async_tx_en[i]),
                .async_tx_en1(pad_async_tx_en[i+2]),
                .async_tx_en_out(pad_async_tx_en_out[i]),

                .async_rx_en0(pad_async_rx_en[i]),
                .async_rx_en1(pad_async_rx_en[i+2]),
                .async_rx_en_out(pad_async_rx_en_out[i]),

                .sdr_mode_en0(pad_sdr_mode_en[i]),
                .sdr_mode_en1(pad_sdr_mode_en[i+2]),
                .sdr_mode_en_out(pad_sdr_mode_en_out[i]),

                .wkpu_en_in0 (wkpu_en_in[i]),
                .wkpu_en_in1 (wkpu_en_in[i+2]),
                .wkpu_en_out (wkpu_en_out[i]),

                .wkpd_en_in0 (wkpd_en_in[i]),
                .wkpd_en_in1 (wkpd_en_in[i+2]),
                .wkpd_en_out (wkpd_en_out[i]),

                .shift_en(pad_shift[i])
       );
   end
endgenerate

endmodule
