// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`timescale 1ps/1ps
interface avalon_mm_if (
    input bit clk
    );

    logic                        rst_n;
    logic [16:0]                 address;
    logic                        read;
    logic                        write;
    logic [31:0]                 writedata;
    logic [ 3:0]                 byteenable;
    logic [31:0]                 readdata;
    logic                        readdatavalid;
    logic                        waitrequest;


    task cfg_write (
       input [16:0] addr,
       input [ 3:0] be,
       input [31:0] wdata);

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
       input  [ 3:0] be,
       output [31:0] rdata);

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
