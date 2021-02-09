// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_dcc_ff, View - schematic
// LAST TIME SAVED: May 18 17:39:15 2015
// NETLIST TIME: Jun  3 08:29:48 2015
// `timescale 1ns / 1ns 

module aibcr3_svt16_scdffsdn_cust ( Q, scQ, CK, 
     D, SDN, SE, SI );

output  Q, scQ;

input  SDN, CK, D, SE, SI;

wire Q, net023, se_n, SI, D;
reg  scQ;

assign se_n = !SE;
assign Q = scQ;
assign net023 = se_n ? D : SI;

always@(posedge CK or negedge SDN) begin
        if (!SDN) begin
                scQ <= 1'b1;
        end
        else begin
                scQ <= net023;
        end
end

endmodule

