// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_dfx_mon(
  input              en_digmon,
  input      [ 15:0] digmon_sel_code,
  //Analog signals
  input              en_anamon,
  input      [ 2:0] anamon_sel_code,
  output reg [103:0] txrx_dfx_en,
  output wire        tx_dll_dfx_en,
  output wire        rx_dll_dfx_en,
  output wire        dcs_dfx_en,
  output reg [  4:0] txrx_digviewsel,
  output reg [  2:0] txrx_anaviewsel,
  output reg [  4:0] onehot_anaviewsel
);

wire [2:0] anamon_sel_code_int;
wire [15:0] digmon_sel_code_int;
reg txrx_dfx_en_int;
reg tx_dll_dfx_en_int;
reg rx_dll_dfx_en_int;
reg dcs_dfx_en_int;
wire txrx_dfx_en_block;

//We should enable either en_digmon or en_anamon
assign digmon_sel_code_int = en_digmon ? digmon_sel_code : {16{1'b0}};
assign anamon_sel_code_int = en_anamon ? anamon_sel_code : {3{1'b0}};

assign tx_dll_dfx_en       = en_anamon | tx_dll_dfx_en_int;
assign rx_dll_dfx_en       = en_anamon | rx_dll_dfx_en_int;
assign dcs_dfx_en          = en_anamon | dcs_dfx_en_int;
assign txrx_dfx_en_block   = en_anamon | txrx_dfx_en_int;
//========================================
//6-bits([15:10]), for the block selection
//========================================
always@(*)
 begin
  case(digmon_sel_code_int[15:10])
   6'b00_0001 : begin
                 txrx_dfx_en_int     = 1'b1; 
                 tx_dll_dfx_en_int   = 1'b0;
                 rx_dll_dfx_en_int   = 1'b0;
                 dcs_dfx_en_int      = 1'b0;
                end
   6'b00_0010 : begin
                 txrx_dfx_en_int    = 1'b0;
                 tx_dll_dfx_en_int  = 1'b1;
                 rx_dll_dfx_en_int  = 1'b0;
                 dcs_dfx_en_int     = 1'b0;
                end
   6'b00_0011 : begin
                 txrx_dfx_en_int   = 1'b0;
                 tx_dll_dfx_en_int = 1'b0;
                 rx_dll_dfx_en_int = 1'b1;
                 dcs_dfx_en_int    = 1'b0;
                end
   6'b00_0100 : begin
                 txrx_dfx_en_int   = 1'b0;
                 tx_dll_dfx_en_int = 1'b0;
                 rx_dll_dfx_en_int = 1'b0;
                 dcs_dfx_en_int    = 1'b1;
                end
   default    : begin
                 txrx_dfx_en_int   = 1'b0;
                 tx_dll_dfx_en_int = 1'b0;
                 rx_dll_dfx_en_int = 1'b0;
                 dcs_dfx_en_int    = 1'b0;
                end
  endcase
 end

//========================================
//7-bits([9:3]), for the IO selection
//========================================
always @(*)
  begin
    txrx_dfx_en[103:0] = {104{1'b0}};
    if(digmon_sel_code_int[9:3] < 7'd104)
      begin
        txrx_dfx_en[digmon_sel_code_int[9:3]] = txrx_dfx_en_block;
      end
  end

//========================================
//3-bits([2:0]), for the Pin selection
//========================================
always@(*)
 begin
    case(digmon_sel_code_int[2:0])
      3'b000 : begin 
                txrx_digviewsel[0] = 1'b1;
                txrx_digviewsel[1] = 1'b0;
                txrx_digviewsel[2] = 1'b0;
                txrx_digviewsel[3] = 1'b0;
                txrx_digviewsel[4] = 1'b0;
               end
      3'b001 : begin
                txrx_digviewsel[0] = 1'b0;
                txrx_digviewsel[1] = 1'b1;
                txrx_digviewsel[2] = 1'b0;
                txrx_digviewsel[3] = 1'b0;
                txrx_digviewsel[4] = 1'b0;
               end
      3'b010 : begin
                txrx_digviewsel[0] = 1'b0;
                txrx_digviewsel[1] = 1'b0;
                txrx_digviewsel[2] = 1'b1;
                txrx_digviewsel[3] = 1'b0;
                txrx_digviewsel[4] = 1'b0;
               end
      3'b011 : begin
                txrx_digviewsel[0] = 1'b0;
                txrx_digviewsel[1] = 1'b0;
                txrx_digviewsel[2] = 1'b0;
                txrx_digviewsel[3] = 1'b1;
                txrx_digviewsel[4] = 1'b0;
               end
      3'b100 : begin 
                txrx_digviewsel[0] = 1'b0;
                txrx_digviewsel[1] = 1'b0;
                txrx_digviewsel[2] = 1'b0;
                txrx_digviewsel[3] = 1'b0;
                txrx_digviewsel[4] = 1'b1;
               end
      default :                      
        begin                        
          txrx_digviewsel[0] = 1'b0; 
          txrx_digviewsel[1] = 1'b0; 
          txrx_digviewsel[2] = 1'b0; 
          txrx_digviewsel[3] = 1'b0; 
          txrx_digviewsel[4] = 1'b0; 
        end                          
    endcase
 end

assign txrx_anaviewsel[2:0] = anamon_sel_code_int[2:0];

always@(*)
 begin
  case(anamon_sel_code_int[2:0])
   3'b000 : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b0;
            end
   3'b001 : begin 
             onehot_anaviewsel[0] = 1'b1;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b0;
            end
   3'b010 : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b1;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b0;
            end
   3'b011 : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b1;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b0;
            end
   3'b100 : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b1;
             onehot_anaviewsel[4] = 1'b0;
            end
   3'b101 : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b1;
            end
  default : begin 
             onehot_anaviewsel[0] = 1'b0;
             onehot_anaviewsel[1] = 1'b0;
             onehot_anaviewsel[2] = 1'b0;
             onehot_anaviewsel[3] = 1'b0;
             onehot_anaviewsel[4] = 1'b0;
            end
  endcase
 end
endmodule
