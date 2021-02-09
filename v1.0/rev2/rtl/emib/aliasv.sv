//------------------------------------------
//------------------------------------------
// CELL: aliasv
//
//  Description: Bidirectional alias device
//
//------------------------------------------
 module aliasv ( .PLUS(w), .MINUS(w) );

   inout   w;
   wire    w;

 endmodule

 module aliasv_16 ( .PLUS(w), .MINUS(w) );

   inout [15:0]  w;
   wire  [15:0]  w;

 endmodule

