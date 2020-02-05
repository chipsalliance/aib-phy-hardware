// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module io_phs_pair_couple_x48 (
input            c_in_p,
input            c_in_n,
input            phy_clk_phs_ctrl,
input            snc,
input            spc,
input      [5:0] r_gray,
input      [5:0] f_gray,
output           c_out_p,
output           c_out_n 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter STEP_DELAY = 40;

reg c_in_del;

wire         c_in_p_gated;
wire         c_in_n_gated;
wire  [48:0] c_in_p_f;
wire  [48:0] c_in_p_r;

assign  {c_in_n_gated,c_in_p_gated} = phy_clk_phs_ctrl? {c_in_n,c_in_p}: 2'b10;

assign #54  c_in_p_f[0] = c_in_p_gated;
assign #57  c_in_p_f[1] = c_in_p_gated;
assign #60  c_in_p_f[2] = c_in_p_gated;
assign #63  c_in_p_f[3] = c_in_p_gated;
assign #66  c_in_p_f[4] = c_in_p_gated;
assign #69  c_in_p_f[5] = c_in_p_gated;
assign #72  c_in_p_f[6] = c_in_p_gated;
assign #75  c_in_p_f[7] = c_in_p_gated;
assign #78  c_in_p_f[8] = c_in_p_gated;
assign #81  c_in_p_f[9] = c_in_p_gated;
assign #84  c_in_p_f[10] = c_in_p_gated;
assign #87  c_in_p_f[11] = c_in_p_gated;
assign #90  c_in_p_f[12] = c_in_p_gated;
assign #93  c_in_p_f[13] = c_in_p_gated;
assign #96  c_in_p_f[14] = c_in_p_gated;
assign #99  c_in_p_f[15] = c_in_p_gated;
assign #102  c_in_p_f[16] = c_in_p_gated;
assign #105  c_in_p_f[17] = c_in_p_gated;
assign #108  c_in_p_f[18] = c_in_p_gated;
assign #111  c_in_p_f[19] = c_in_p_gated;
assign #114  c_in_p_f[20] = c_in_p_gated;
assign #117  c_in_p_f[21] = c_in_p_gated;
assign #120  c_in_p_f[22] = c_in_p_gated;
assign #123  c_in_p_f[23] = c_in_p_gated;
assign #126  c_in_p_f[24] = c_in_p_gated;
assign #129  c_in_p_f[25] = c_in_p_gated;
assign #132  c_in_p_f[26] = c_in_p_gated;
assign #135  c_in_p_f[27] = c_in_p_gated;
assign #138  c_in_p_f[28] = c_in_p_gated;
assign #141  c_in_p_f[29] = c_in_p_gated;
assign #144  c_in_p_f[30] = c_in_p_gated;
assign #147  c_in_p_f[31] = c_in_p_gated;
assign #150  c_in_p_f[32] = c_in_p_gated;
assign #153  c_in_p_f[33] = c_in_p_gated;
assign #156  c_in_p_f[34] = c_in_p_gated;
assign #159  c_in_p_f[35] = c_in_p_gated;
assign #162  c_in_p_f[36] = c_in_p_gated;
assign #165  c_in_p_f[37] = c_in_p_gated;
assign #168  c_in_p_f[38] = c_in_p_gated;
assign #171  c_in_p_f[39] = c_in_p_gated;
assign #174  c_in_p_f[40] = c_in_p_gated;
assign #177  c_in_p_f[41] = c_in_p_gated;
assign #180  c_in_p_f[42] = c_in_p_gated;
assign #183  c_in_p_f[43] = c_in_p_gated;
assign #186  c_in_p_f[44] = c_in_p_gated;
assign #189  c_in_p_f[45] = c_in_p_gated;
assign #192  c_in_p_f[46] = c_in_p_gated;
assign #195  c_in_p_f[47] = c_in_p_gated;
assign #198  c_in_p_f[48] = c_in_p_gated;

assign #54  c_in_p_r[0] = c_in_p_gated;
assign #57  c_in_p_r[1] = c_in_p_gated;
assign #60  c_in_p_r[2] = c_in_p_gated;
assign #63  c_in_p_r[3] = c_in_p_gated;
assign #66  c_in_p_r[4] = c_in_p_gated;
assign #69  c_in_p_r[5] = c_in_p_gated;
assign #72  c_in_p_r[6] = c_in_p_gated;
assign #75  c_in_p_r[7] = c_in_p_gated;
assign #78  c_in_p_r[8] = c_in_p_gated;
assign #81  c_in_p_r[9] = c_in_p_gated;
assign #84  c_in_p_r[10] = c_in_p_gated;
assign #87  c_in_p_r[11] = c_in_p_gated;
assign #90  c_in_p_r[12] = c_in_p_gated;
assign #93  c_in_p_r[13] = c_in_p_gated;
assign #96  c_in_p_r[14] = c_in_p_gated;
assign #99  c_in_p_r[15] = c_in_p_gated;
assign #102  c_in_p_r[16] = c_in_p_gated;
assign #105  c_in_p_r[17] = c_in_p_gated;
assign #108  c_in_p_r[18] = c_in_p_gated;
assign #111  c_in_p_r[19] = c_in_p_gated;
assign #114  c_in_p_r[20] = c_in_p_gated;
assign #117  c_in_p_r[21] = c_in_p_gated;
assign #120  c_in_p_r[22] = c_in_p_gated;
assign #123  c_in_p_r[23] = c_in_p_gated;
assign #126  c_in_p_r[24] = c_in_p_gated;
assign #129  c_in_p_r[25] = c_in_p_gated;
assign #132  c_in_p_r[26] = c_in_p_gated;
assign #135  c_in_p_r[27] = c_in_p_gated;
assign #138  c_in_p_r[28] = c_in_p_gated;
assign #141  c_in_p_r[29] = c_in_p_gated;
assign #144  c_in_p_r[30] = c_in_p_gated;
assign #147  c_in_p_r[31] = c_in_p_gated;
assign #150  c_in_p_r[32] = c_in_p_gated;
assign #153  c_in_p_r[33] = c_in_p_gated;
assign #156  c_in_p_r[34] = c_in_p_gated;
assign #159  c_in_p_r[35] = c_in_p_gated;
assign #162  c_in_p_r[36] = c_in_p_gated;
assign #165  c_in_p_r[37] = c_in_p_gated;
assign #168  c_in_p_r[38] = c_in_p_gated;
assign #171  c_in_p_r[39] = c_in_p_gated;
assign #174  c_in_p_r[40] = c_in_p_gated;
assign #177  c_in_p_r[41] = c_in_p_gated;
assign #180  c_in_p_r[42] = c_in_p_gated;
assign #183  c_in_p_r[43] = c_in_p_gated;
assign #186  c_in_p_r[44] = c_in_p_gated;
assign #189  c_in_p_r[45] = c_in_p_gated;
assign #192  c_in_p_r[46] = c_in_p_gated;
assign #195  c_in_p_r[47] = c_in_p_gated;
assign #198  c_in_p_r[48] = c_in_p_gated;

always @(*)
  if (c_in_p == 1'b0)
    begin
      case (f_gray[5:0])
       6'h00 : c_in_del =  c_in_p_f[0];
       6'h01 : c_in_del =  c_in_p_f[1];
       6'h03 : c_in_del =  c_in_p_f[2];
       6'h02 : c_in_del =  c_in_p_f[3];
       6'h06 : c_in_del =  c_in_p_f[4];
       6'h07 : c_in_del =  c_in_p_f[5];
       6'h05 : c_in_del =  c_in_p_f[6];
       6'h04 : c_in_del =  c_in_p_f[7];
       6'h0C : c_in_del =  c_in_p_f[8];
       6'h0D : c_in_del =  c_in_p_f[9];
       6'h0F : c_in_del =  c_in_p_f[10];
       6'h0E : c_in_del =  c_in_p_f[11];
       6'h0A : c_in_del =  c_in_p_f[12];
       6'h0B : c_in_del =  c_in_p_f[13];
       6'h09 : c_in_del =  c_in_p_f[14];
       6'h08 : c_in_del =  c_in_p_f[15];
       6'h18 : c_in_del =  c_in_p_f[16];
       6'h19 : c_in_del =  c_in_p_f[17];
       6'h1B : c_in_del =  c_in_p_f[18];
       6'h1A : c_in_del =  c_in_p_f[19];
       6'h1E : c_in_del =  c_in_p_f[20];
       6'h1F : c_in_del =  c_in_p_f[21];
       6'h1D : c_in_del =  c_in_p_f[22];
       6'h1C : c_in_del =  c_in_p_f[23];
       6'h14 : c_in_del = c_in_p_f[24];
       6'h15 : c_in_del = c_in_p_f[25];
       6'h17 : c_in_del = c_in_p_f[26];
       6'h16 : c_in_del = c_in_p_f[27];
       6'h12 : c_in_del = c_in_p_f[28];
       6'h13 : c_in_del = c_in_p_f[29];
       6'h11 : c_in_del = c_in_p_f[30];
       6'h10 : c_in_del = c_in_p_f[31];
       6'h30 : c_in_del = c_in_p_f[32];
       6'h31 : c_in_del = c_in_p_f[33];
       6'h33 : c_in_del = c_in_p_f[34];
       6'h32 : c_in_del = c_in_p_f[35];
       6'h36 : c_in_del = c_in_p_f[36];
       6'h37 : c_in_del = c_in_p_f[37];
       6'h35 : c_in_del = c_in_p_f[38];
       6'h34 : c_in_del = c_in_p_f[39];
       6'h3C : c_in_del = c_in_p_f[40];
       6'h3D : c_in_del = c_in_p_f[41];
       6'h3F : c_in_del = c_in_p_f[42];
       6'h3E : c_in_del = c_in_p_f[43];
       6'h3A : c_in_del = c_in_p_f[44];
       6'h3B : c_in_del = c_in_p_f[45];
       6'h39 : c_in_del = c_in_p_f[46];
       6'h38 : c_in_del = c_in_p_f[47];
       default : c_in_del = c_in_p_f[48];
       endcase
    end
  else if (c_in_p == 1'b1)
    begin
      case (r_gray[5:0])
       6'h00 : c_in_del =   c_in_p_r[0];
       6'h01 : c_in_del =   c_in_p_r[1];
       6'h03 : c_in_del =   c_in_p_r[2];
       6'h02 : c_in_del =   c_in_p_r[3];
       6'h06 : c_in_del =   c_in_p_r[4];
       6'h07 : c_in_del =   c_in_p_r[5];
       6'h05 : c_in_del =   c_in_p_r[6];
       6'h04 : c_in_del =   c_in_p_r[7];
       6'h0C : c_in_del =   c_in_p_r[8];
       6'h0D : c_in_del =   c_in_p_r[9];
       6'h0F : c_in_del =   c_in_p_r[10];
       6'h0E : c_in_del =   c_in_p_r[11];
       6'h0A : c_in_del =   c_in_p_r[12];
       6'h0B : c_in_del =   c_in_p_r[13];
       6'h09 : c_in_del =   c_in_p_r[14];
       6'h08 : c_in_del =   c_in_p_r[15];
       6'h18 : c_in_del =   c_in_p_r[16];
       6'h19 : c_in_del =   c_in_p_r[17];
       6'h1B : c_in_del =   c_in_p_r[18];
       6'h1A : c_in_del =   c_in_p_r[19];
       6'h1E : c_in_del =   c_in_p_r[20];
       6'h1F : c_in_del =   c_in_p_r[21];
       6'h1D : c_in_del =   c_in_p_r[22];
       6'h1C : c_in_del =   c_in_p_r[23];
       6'h14 : c_in_del =   c_in_p_r[24];
       6'h15 : c_in_del =   c_in_p_r[25];
       6'h17 : c_in_del =   c_in_p_r[26];
       6'h16 : c_in_del =   c_in_p_r[27];
       6'h12 : c_in_del =   c_in_p_r[28];
       6'h13 : c_in_del =   c_in_p_r[29];
       6'h11 : c_in_del =   c_in_p_r[30];
       6'h10 : c_in_del =   c_in_p_r[31];
       6'h30 : c_in_del =   c_in_p_r[32];
       6'h31 : c_in_del =   c_in_p_r[33];
       6'h33 : c_in_del =   c_in_p_r[34];
       6'h32 : c_in_del =   c_in_p_r[35];
       6'h36 : c_in_del =   c_in_p_r[36];
       6'h37 : c_in_del =   c_in_p_r[37];
       6'h35 : c_in_del =   c_in_p_r[38];
       6'h34 : c_in_del =   c_in_p_r[39];
       6'h3C : c_in_del =   c_in_p_r[40];
       6'h3D : c_in_del =   c_in_p_r[41];
       6'h3F : c_in_del =   c_in_p_r[42];
       6'h3E : c_in_del =   c_in_p_r[43];
       6'h3A : c_in_del =   c_in_p_r[44];
       6'h3B : c_in_del =   c_in_p_r[45];
       6'h39 : c_in_del =   c_in_p_r[46];
       6'h38 : c_in_del =   c_in_p_r[47];
       default : c_in_del = c_in_p_r[48];
       endcase
    end

assign c_out_p =  c_in_del;
assign c_out_n = ~c_in_del;

endmodule

//======================================================================
// 
//     r_delay(f_gray=5'b0)                       f_delay(r_gray=5'b0)
//   x48_delay_wc x48_delay_tt x48_delay_bc   x48_delay_wc x48_delay_tt x48_delay_bc
// 1    2.047E-10   1.544E-10   1.108E-10   1    2.042E-10   1.544E-10   1.109E-10
// 2    2.063E-10   1.561E-10   1.126E-10   2    2.053E-10   1.556E-10   1.123E-10
// 3    2.074E-10   1.573E-10   1.141E-10   3    2.071E-10   1.575E-10   1.143E-10
// 4    2.089E-10   1.591E-10   1.162E-10   4    2.083E-10   1.589E-10   1.160E-10
// 5    2.100E-10   1.604E-10   1.177E-10   5    2.101E-10   1.608E-10   1.181E-10
// 6    2.115E-10   1.621E-10   1.197E-10   6    2.113E-10   1.621E-10   1.197E-10
// 7    2.127E-10   1.634E-10   1.213E-10   7    2.128E-10   1.639E-10   1.216E-10
// 8    2.143E-10   1.650E-10   1.232E-10   8    2.143E-10   1.655E-10   1.236E-10
// 9    2.158E-10   1.667E-10   1.254E-10   9    2.161E-10   1.674E-10   1.259E-10
// 10   2.174E-10   1.686E-10   1.277E-10   10   2.176E-10   1.691E-10   1.280E-10
// 11   2.189E-10   1.703E-10   1.298E-10   11   2.194E-10   1.711E-10   1.304E-10
// 12   2.208E-10   1.723E-10   1.323E-10   12   2.209E-10   1.727E-10   1.325E-10
// 13   2.221E-10   1.737E-10   1.341E-10   13   2.227E-10   1.747E-10   1.348E-10
// 14   2.237E-10   1.756E-10   1.365E-10   14   2.244E-10   1.766E-10   1.373E-10
// 15   2.256E-10   1.777E-10   1.393E-10   15   2.263E-10   1.787E-10   1.401E-10
// 16   2.274E-10   1.798E-10   1.422E-10   16   2.281E-10   1.808E-10   1.429E-10
// 17   2.292E-10   1.818E-10   1.450E-10   17   2.300E-10   1.829E-10   1.458E-10
// 18   2.312E-10   1.841E-10   1.480E-10   18   2.317E-10   1.849E-10   1.485E-10
// 19   2.326E-10   1.858E-10   1.503E-10   19   2.337E-10   1.871E-10   1.513E-10
// 20   2.346E-10   1.879E-10   1.534E-10   20   2.356E-10   1.893E-10   1.544E-10
// 21   2.366E-10   1.904E-10   1.570E-10   21   2.376E-10   1.917E-10   1.581E-10
// 22   2.387E-10   1.929E-10   1.606E-10   22   2.397E-10   1.942E-10   1.617E-10
// 23   2.407E-10   1.954E-10   1.642E-10   23   2.418E-10   1.967E-10   1.653E-10
// 24   2.429E-10   1.979E-10   1.679E-10   24   2.438E-10   1.991E-10   1.688E-10
// 25   2.445E-10   1.999E-10   1.708E-10   25   2.459E-10   2.016E-10   1.722E-10
// 26   2.466E-10   2.024E-10   1.750E-10   26   2.480E-10   2.040E-10   1.763E-10
// 27   2.490E-10   2.053E-10   1.798E-10   27   2.504E-10   2.069E-10   1.812E-10
// 28   2.514E-10   2.082E-10   1.846E-10   28   2.526E-10   2.097E-10   1.860E-10
// 29   2.536E-10   2.110E-10   1.895E-10   29   2.550E-10   2.126E-10   1.909E-10
// 30   2.560E-10   2.139E-10   1.944E-10   30   2.573E-10   2.154E-10   1.958E-10
// 31   2.579E-10   2.163E-10   1.986E-10   31   2.597E-10   2.183E-10   2.002E-10
// 32   2.603E-10   2.193E-10   2.047E-10   32   2.621E-10   2.212E-10   2.064E-10
// 33   2.628E-10   2.228E-10   2.119E-10   33   2.646E-10   2.247E-10   2.134E-10
// 34   2.655E-10   2.261E-10   2.188E-10   34   2.674E-10   2.281E-10   2.204E-10
// 35   2.682E-10   2.297E-10   2.259E-10   35   2.700E-10   2.316E-10   2.276E-10
// 36   2.708E-10   2.331E-10   2.329E-10   36   2.725E-10   2.350E-10   2.345E-10
// 37   2.733E-10   2.362E-10   2.393E-10   37   2.752E-10   2.383E-10   2.410E-10
// 38   2.758E-10   2.399E-10   2.505E-10   38   2.780E-10   2.419E-10   2.523E-10
// 39   2.789E-10   2.441E-10   2.631E-10   39   2.808E-10   2.463E-10   2.647E-10
// 40   2.818E-10   2.484E-10   2.754E-10   40   2.840E-10   2.505E-10   2.772E-10
// 41   2.849E-10   2.527E-10   2.878E-10   41   2.870E-10   2.549E-10   2.896E-10
// 42   2.879E-10   2.570E-10   3.002E-10   42   2.902E-10   2.591E-10   3.021E-10
// 43   2.908E-10   2.609E-10   3.123E-10   43   2.932E-10   2.632E-10   3.137E-10
// 44   2.937E-10   2.657E-10   3.496E-10   44   2.961E-10   2.681E-10   3.511E-10
// 45   2.971E-10   2.712E-10   3.917E-10   45   2.995E-10   2.735E-10   3.932E-10
// 46   3.006E-10   2.769E-10   4.335E-10   46   3.031E-10   2.791E-10   4.354E-10
// 47   3.040E-10   2.825E-10   failed      47   3.064E-10   2.848E-10   failed
// 48   3.106E-10   2.931E-10   failed      48   3.133E-10   2.957E-10   failed
// 
//======================================================================
// 
