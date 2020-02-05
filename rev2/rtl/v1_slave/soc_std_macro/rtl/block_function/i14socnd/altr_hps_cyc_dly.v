// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//---------------------------------------------------------------------------------------
// Description: delay the de-assertion edge of reset by parameterized delay. 
//              there is no delay for the assertion edge of reset. 
//              When reset is de-asserted, an internal counter counts up. When it counts
//              to parameter value, dly_rst_n is de-asserted.
//             
//---------------------------------------------------------------------------------------

module altr_hps_cyc_dly
  (
    input wire 				     clk,
    input wire 				     i_rst_n,          
    output reg 				     dly_rst_n			     
   );
   
   parameter DLY  = 'd8;
   // counter size:
   // counter counts from 0 to DLY-1, then saturates. minimum size should cover DLY-1.
   // To be safe, counter size can cover DLY in case there is one run-over. 
   // e.g.: DLY = 2, counter size = 2 (instead of 1). DLY = 3, size = 3 (instead of 2) ; 
   // DLY =3~6, size =3. DLY=7~14, size=4... 
   //    
   parameter CNT_WIDTH = DLY > 'd1022 ? 'd11 :
			 DLY > 'd510 ?  'd10 :
			 DLY > 'd254 ?  'd9 :
			 DLY > 'd126 ? 'd8 :
			 DLY > 'd62 ? 'd7 :
			 DLY > 'd30 ? 'd6 :
			 DLY > 'd14 ? 'd5 :
			 DLY > 'd6 ? 'd4 :
			 DLY > 'd2 ? 'd3 :
			 DLY > 'd1 ? 'd2 :
			 'd1;

`ifdef ALTR_HPS_SIMULATION
initial // check parameters
 begin

  if( DLY > 'd2046)
   begin
    $display("ERROR : %m : DELAY parameter is too big , MAX Value is 2046.");
    $finish;
   end
 
 if( DLY == 'd0)
   begin
    $display("ERROR : %m : DELAY parameter is 0, no need to instantiate this cell.");
    $finish;
   end

 end
`endif

   reg [CNT_WIDTH-1:0]  dly_cntr;
   wire 		cntr_reached = (dly_cntr >= (DLY-'d1));
   
   
   always @(posedge clk or negedge i_rst_n)
     if (!i_rst_n) begin
	/*AUTORESET*/
	// Beginning of autoreset for uninitialized flops
	dly_cntr <= {(1+(CNT_WIDTH-1)){1'b0}};
	dly_rst_n <= 1'h0;
	// End of automatics
     end
     else begin
	dly_cntr <= cntr_reached ? 
		    dly_cntr :
		    dly_cntr + { {CNT_WIDTH-1{1'b0}}, 1'b1 };
	dly_rst_n <= cntr_reached;	
     end

endmodule
