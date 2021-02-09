// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmmclk_dcg
(
        input   wire            clk,
	input	wire		rst_n,
        input   wire            ungate,
        input   wire            gate,
	input	wire		r_dcg_en,
	input	wire 		r_dcg_cnt_bypass,
	input	wire [3:0]	r_dcg_wait_cnt,
	input	wire		te,
        output  wire            gclk,
	output	wire [7:0]	dcg_testbus
);

//********************************************************************
// Define Parameters
//********************************************************************
        localparam  UNGATED = 1'b0;
        localparam  GATED   = 1'b1;

//********************************************************************
// Define variables
//********************************************************************
	reg [3:0]	dcg_cnt;
	wire		dcg_cnt_timeout;

	reg		dcg_sm_cs;
	reg		dcg_sm_ns;
	wire		UNGATED_s;
	wire		GATED_s;

        wire    	dcg_clken;
        wire    	gated_clk;

assign dcg_testbus[7:0] = {dcg_clken,dcg_sm_cs,dcg_cnt[3:0],gate,ungate};

//********************************************************************
// Dynamic Clock Gating Counter
//********************************************************************
always @(negedge rst_n or posedge clk)
begin
        if (~rst_n)
        begin
                dcg_cnt[3:0] <= 4'b0000;
        end
        else
        begin
		if (r_dcg_en && ~ungate && gate && UNGATED_s)
		begin
			dcg_cnt[3:0] <= dcg_cnt[3:0] + 4'b0001;
		end
		else
		begin
			dcg_cnt[3:0] <= 4'b0000;
		end
        end
end

assign dcg_cnt_timeout = (dcg_cnt[3:0] == r_dcg_wait_cnt[3:0]);
 
//********************************************************************
// Dynamic Clock Gating State Machine
//********************************************************************
always @(negedge rst_n or posedge clk)
begin
        if (~rst_n)
        begin
                dcg_sm_cs <= UNGATED;
        end
        else
        begin
                dcg_sm_cs <= dcg_sm_ns;
        end
end

always @ (*)
begin
        case(dcg_sm_cs)
        UNGATED:
        begin
                if(r_dcg_en && ~ungate && gate && (r_dcg_cnt_bypass | dcg_cnt_timeout))
                begin
                        dcg_sm_ns  = GATED;
                end
		else
                begin
                        dcg_sm_ns  = UNGATED;
                end
        end

        GATED:
        begin
                if (~r_dcg_en || ungate)
                begin
                        dcg_sm_ns = UNGATED;
                end
		else
                begin
                        dcg_sm_ns  = GATED;
                end
        end

        default:
        begin
                dcg_sm_ns = UNGATED;
        end
      endcase
  end

assign UNGATED_s = (dcg_sm_cs == UNGATED); 
assign GATED_s = (dcg_sm_cs == GATED); 

//********************************************************************
// Dynamic Clock Gating Enable
//********************************************************************
assign dcg_clken = UNGATED_s | (GATED_s & (~r_dcg_en || ungate));

// c3adapt_cmn_clkgate_high c3adapt_cmn_clkgate_high_avmm_dcg
//     (
//         .cpn(clk),
//         .e(dcg_clken),
//         .te(te),
//         .q(gclk)
//     );

c3lib_ckg_negedge_ctn clkgate_high_avmm_dcg (
  .clk         (clk),
  .tst_en      (te),
  .clk_en      (dcg_clken),
  .gated_clk   (gated_clk)
);


// te is tied to scan_mode
// clk is from static-gated clock which is already bypassed in scan_mode
c3lib_mux2_ctn dcg_clk_byp (
  .ck_out      (gclk),
  .ck0         (gated_clk),
  .ck1         (clk),
  .s0          (te)
);

endmodule // c3aibadapt_avmmclk_dcg
