// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// time scale
`timescale 1ns/1ps

// no undeclared nets
`default_nettype none

// Synchronizes the falling edge of the rst_in signal to the clock
module data_sync_for_aib(
        //---------------------------------------------------------------------------
        //  Input Signals
        //---------------------------------------------------------------------------
        clk,
        rst_in,
        data_in,
        //---------------------------------------------------------------------------
    
        //---------------------------------------------------------------------------
        //  Output Signals
        //---------------------------------------------------------------------------
        data_out
        //---------------------------------------------------------------------------    
    );
    
    //-----------------------------------------------------------------------------------
    //  Parameters
    //-----------------------------------------------------------------------------------
    parameter ActiveLow =           0;      // active low reset
    parameter ResetVal =            1'b0;
    parameter SyncRegWidth =        2;
    //-----------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------    
    //  I/O
    //---------------------------------------------------------------------------    
    input wire                      clk;
    input wire                      data_in;
    input wire                      rst_in;
    output wire                     data_out;
    //---------------------------------------------------------------------------    

`ifdef BEHAVIORAL

    //-----------------------------------------------------------------------------------
    //  Signals
    //-----------------------------------------------------------------------------------
    reg     [SyncRegWidth-1:0]      sync_reg;
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //  Assigns
    //-----------------------------------------------------------------------------------
    assign data_out =               sync_reg[0];
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //  Reset Sync
    //-----------------------------------------------------------------------------------

    generate if (ActiveLow) begin:  active_hilo
        always @(posedge clk or negedge rst_in) begin
            if (~rst_in) sync_reg <= {SyncRegWidth{ResetVal}};
            else sync_reg <= {data_in, sync_reg[SyncRegWidth-1:1]};
        end
    end else begin
        always @(posedge clk or posedge rst_in) begin
            if (rst_in) sync_reg <= {SyncRegWidth{ResetVal}};
            else sync_reg <= {data_in, sync_reg[SyncRegWidth-1:1]};
        end        
    end endgenerate
    //-----------------------------------------------------------------------------------    
    
`else

generate
  if (SyncRegWidth == 2)
    if (!ResetVal)
      if (ActiveLow)
        // Width=2, Rst->Clr, Rst when 0
         //replace this section with user technology cell
         //for the purpose of cell hardening, synthesis don't touch
           $display("ERROR : %m : replace this section with user technology cell");
           $finish;
      else
        // Width=2, Rst->Clr, Rst when 1
        //replace this section with user technology cell
        //for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish;
    else
      if (ActiveLow)
        // Width=2, Rst->Set, Rst when 0
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
          $display("ERROR : %m : replace this section with user technology cell");
          $finish;
 
      else
        // Width=2, Rst->Set, Rst when 1
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish;
  else if (SyncRegWidth == 3)
    if (!ResetVal)
      if (ActiveLow)
        // Width=3, Rst->Clr, Rst when 0
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish;
      else
        // Width=3, Rst->Clr, Rst when 1
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish;
    else
      if (ActiveLow)
        // Width=3, Rst->Set, Rst when 0
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish; 
      else
        // Width=3, Rst->Set, Rst when 1
        // replace this section with user technology cell
        // for the purpose of cell hardening, synthesis don't touch
        $display("ERROR : %m : replace this section with user technology cell");
        $finish;        
endgenerate

`endif

endmodule    

// revert back to the default
`default_nettype wire

