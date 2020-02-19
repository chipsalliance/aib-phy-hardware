// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
input [DATAWIDTH-1:0]   shift_en_tx,        //tx data io redundancy control. "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed.
input [DATAWIDTH-1:0]   shift_en_rx,        //rx data io redundancy control. "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed.
input          shift_en_rxclkb,    //fs_fwd_clkb io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_rxfckb,    //fs_rcv_clkb io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_srckb,     //fs_sr_clkb io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_srl,       //fs_sr_load io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_arstni,    //fs_adapter_rstn io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_rstno,     //ns_mac_rdy io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_std,       //ns_sr_data io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_stck,      //ns_sr_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_txfck,     //ns_rcv_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_txclk,     //ns_fwd_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_rxclk,     //fs_fwd_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_rxfck,     //fs_rcv_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_srck,      //fs_sr_clk io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_srd,       //fs_sr_data io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_rstni,     //fs_mac_rdy io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_arstno,    //ns_adapter_rstn io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_stl,       //ns_sr_load io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_stckb,     //ns_sr_clkb io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_txfckb,    //ns_rcv_clkb io redundancy control, "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
input          shift_en_txclkb,    //ns_fwd_clkb io redundancy control. "1" the io is bad, it is shifted
                                   //to the next io. "0" the io is good, no shifting is needed. 
