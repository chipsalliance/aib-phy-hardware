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
           $display("%0t: WRITE_MM: address %x wdata =  %x", $time, addr, wdata);
           @(negedge waitrequest);
           @(posedge clk);
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
           @(negedge waitrequest);
           @(posedge clk);
           read        <= 1'b0;
           @(posedge readdatavalid);
           @(negedge clk);
           rdata <= readdata;
           @(posedge clk);
           $display("%0t: READ_MM: address %x rdata =  %x", $time, addr, rdata);

       end
 
   endtask


endinterface : avalon_mm_if
