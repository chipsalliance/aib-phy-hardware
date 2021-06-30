// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1ps
interface avalon_mm_if #(parameter AVMM_WIDTH = 32, BYTE_WIDTH = 4) (
    input bit clk
    );

    logic                        rst_n;
    logic [16:0]                 address;
    logic                        read;
    logic                        write;
    logic [AVMM_WIDTH-1:0]       writedata;
    logic [BYTE_WIDTH-1:0]       byteenable;
    logic [AVMM_WIDTH-1:0]       readdata;
    logic                        readdatavalid;
    logic                        waitrequest;


    task cfg_write (
       input [16:0] addr,
       input [BYTE_WIDTH-1:0] be,
       input [AVMM_WIDTH-1:0] wdata);

       begin
           @(posedge clk);
           write       <= 1'b1;
           read        <= 1'b0;
           address     <= addr;
           byteenable  <= be;
           writedata   <= wdata;

           repeat (3) @(posedge clk);
           write       <= 1'b0;
       end

   endtask


   task cfg_read (
       input  [16:0] addr,
       input  [BYTE_WIDTH-1:0] be,
       output [AVMM_WIDTH-1:0] rdata);

       begin
           @(posedge clk);
           write       <= 1'b0;
           read        <= 1'b1;
           address     <= addr;
           byteenable  <= be;
 
           repeat (3) @(posedge clk);
           @(posedge readdatavalid);
           rdata = readdata;
           $display("READ_MM: address %x =  %x", addr, rdata);
           read        <= 1'b0;

       end
 
   endtask


endinterface : avalon_mm_if
