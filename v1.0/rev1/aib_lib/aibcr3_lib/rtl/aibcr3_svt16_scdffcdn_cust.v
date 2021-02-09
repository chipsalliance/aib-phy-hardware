// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, View - schematic
// `timescale 1ns / 1ns 

module aibcr3_svt16_scdffcdn_cust ( Q, scQ, 
     CDN, CK, D, SE, SI );

output  Q, scQ;

input  CDN, CK, D, SE, SI;

wire Q, net023, se_n, SI, D;
reg  scQ;

assign se_n = !SE;
assign Q = scQ;
assign net023 = se_n ? D : SI;

always@(posedge CK or negedge CDN) begin
        if (!CDN) begin
                scQ <= 1'b0;
        end
        else begin
                scQ <= net023;
        end
end

endmodule

