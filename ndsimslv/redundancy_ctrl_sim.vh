// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//Redundancy control inputs signals
//All the inputs tied to "0" are for no repaire
                                                  //example of repairing setting for tx[16] in master
                                                  //master                      //slave
    .shift_en_tx({(DATAWIDTH/4){4'h0}}),          //20'h0ffff                   //{(DATAWIDTH/4){4'h0}}
    .shift_en_rx({(DATAWIDTH/4){4'h0}}),          //{(DATAWIDTH/4){4'h0}}       //20'h0ffff
    .shift_en_txclkb(1'b0),                       //1'b1                        //1'b0
    .shift_en_txfckb(1'b0),                       //1'b1                        //1'b0
    .shift_en_stckb(1'b0),                        //1'b1                        //1'b0
    .shift_en_stl(1'b0),                          //1'b1                        //1'b0
    .shift_en_arstno(1'b0),                       //1'b1                        //1'b0
    .shift_en_txclk(1'b0),                        //1'b1                        //1'b0
    .shift_en_std(1'b0),                          //1'b1                        //1'b0
    .shift_en_stck(1'b0),                         //1'b1                        //1'b0
    .shift_en_txfck(1'b0),                        //1'b1                        //1'b0
    .shift_en_rstno(1'b0),                        //1'b1                        //1'b0
    .shift_en_rxclkb(1'b0),                       //1'b0                        //1'b1
    .shift_en_rxfckb(1'b0),                       //1'b0                        //1'b1
    .shift_en_srckb(1'b0),                        //1'b0                        //1'b1
    .shift_en_srl(1'b0),                          //1'b0                        //1'b1
    .shift_en_arstni(1'b0),                       //1'b0                        //1'b1
    .shift_en_rxclk(1'b0),                        //1'b0                        //1'b1
    .shift_en_rxfck(1'b0),                        //1'b0                        //1'b1
    .shift_en_srck(1'b0),                         //1'b0                        //1'b1
    .shift_en_srd(1'b0),                          //1'b0                        //1'b1
    .shift_en_rstni(1'b0),                        //1'b0                        //1'b1

