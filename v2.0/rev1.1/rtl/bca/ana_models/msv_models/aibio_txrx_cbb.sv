`timescale 1ps/1fs

module aibio_txrx_cbb
(
	//------Supply pins------//
	input vddc,
	input vddcq,
	input vddtx,
	inout vss,
	//------Supply pins------//
	input ckrx_odd,
	input ckrx_even,
	input rx_calen,
	input rx_vref_cal,
	input rx_en,
	input rx_vrefp_gen1,
	input rx_vrefn_gen1,
	input rx_vrefp_gen2,
	input rx_vrefn_gen2,
	input gen1mode_en,
	input gen2mode_en,
	input [7:0] rx_ofscal_even,
	input [7:0] rx_ofscal_odd,
	input [3:0] rx_deskew,
	input txrx_bscan_data,
	input txrx_bscan_en,
	input txrx_bscan_hiz,
	input txrx_dfx_en,
	input [4:0] txrx_digviewsel,
	input [2:0] txrx_anaviewsel,
	input cktx_odd,
	input cktx_even,
	input tx_en,
	input tx_compen_p,
	input tx_compen_n,
	input tx_datain_odd,
	input tx_datain_even,
	input [7:0] tx_drv_npdsel,
	input [7:0] tx_drv_npusel,
	input [7:0] tx_drv_ppusel,
	input [3:0] tx_deskew,
	input rst_padlow_strap,
	input pwrgood_in,
	input pwrgood_io_in,
	input tx_async,
	input tx_async_en,
	input rx_async_en,
	input sdr_mode_en,
	input wkpu_en,
	input wkpd_en,
	input tx_bypass_serialiser,
	//------Output pins------//
	output rx_out_even,
	output rx_out_odd,
	output rx_async,
	output [1:0] txrx_digviewout,
   output txrx_anaviewout,
	//------InOut pins------//
	inout xx_pad,
	inout xxpad_async,
	//------Spare pins------//
	input [7:0] i_txrx_spare,
	output [7:0] o_txrx_spare
);

//---------Internal Signals------------//
logic d_even_clk;
logic d_odd_clk;

logic clkeven_int;

logic idata;
logic idatab;
logic data;

logic rx_out_even_int;

logic pu_en_gen1;
logic pd_en_gen1;

logic pu_en_gen2;
logic pd_en_gen2;

logic en_wkpd;
logic en_wkpu;
logic d_odd_clk_int;
//----------------Serialiser--------------------//
sampler #(.t_setup(20),.t_hold(20),.t_clk2q(45))
			i_tx_sampler_even
			(
			.data_in(tx_datain_even),
			.clk(cktx_even),
			.rst(tx_en),
			.data_out(d_even_clk)
			);

sampler #(.t_setup(20),.t_hold(20),.t_clk2q(45))
			i_tx_sampler_odd_sync
			(
			.data_in(tx_datain_odd),
			.clk(cktx_even),
			.rst(tx_en),
			.data_out(d_odd_clk_int)
			);

sampler #(.t_setup(20),.t_hold(20),.t_clk2q(45))
			i_tx_sampler_odd
			(
			.data_in(d_odd_clk_int),
			.clk(cktx_odd),
			.rst(tx_en),
			.data_out(d_odd_clk)
			);
assign #45 clkeven_int = cktx_even;
assign idata = (clkeven_int === 1'b1) ? d_even_clk : d_odd_clk;
assign idatab = !idata;

assign data = sdr_mode_en ? d_even_clk : idata;

//----------------Serialiser Ends---------------------------//

en_logic i_en_logic
		(
		.data(data),
		.data_async(tx_async),
		.pwrgoodtx(pwrgood_io_in),
		.pwrgood(pwrgood_in),
		.rst_strap(rst_padlow_strap),
		.wk_pu_en(wkpu_en),
		.wk_pd_en(wkpd_en),
		.compen_n(tx_compen_n),
		.compen_p(tx_compen_n),
		.tx_en(tx_en),
		.sdr_mode_en(sdr_mode_en),
		.tx_async_en(tx_async_en),
		.gen1_en(gen1mode_en),
		.gen2_en(gen2mode_en),
		.bypass_serialiser(tx_bypass_serialiser),
		.pu_en_gen1(pu_en_gen1),
		.pd_en_gen1(pd_en_gen1),
		.pu_en_gen2(pu_en_gen2),
		.pd_en_gen2(pd_en_gen2),
		.wkpd_en(en_wkpd),
		.wkpu_en(en_wkpu),
		.data_out(xx_pad),
		.data_out_async(xxpad_async)
		);


//----------------Transmitter Ends---------------------------//


//----------------Receiver--------------------------//
sampler #(.t_setup(20),.t_hold(20),.t_clk2q(40))
			i_rx_sampler_even
			(
			.data_in(xx_pad),
			.clk(ckrx_even),
			.rst(rx_en),
			.data_out(rx_out_even_int)
			);

sampler #(.t_setup(20),.t_hold(20),.t_clk2q(40))
			i_rx_sampler_odd
			(
			.data_in(xx_pad),
			.clk(ckrx_odd),
			.rst(rx_en),
			.data_out(rx_out_odd)
			);

sampler #(.t_setup(20),.t_hold(20),.t_clk2q(40))
			i_rx_sampler_even_sync
			(
			.data_in(rx_out_even_int),
			.clk(ckrx_odd),
			.rst(rx_en),
			.data_out(rx_out_even)
			);

//-------------------Receiver Ends-------------------------------//

assign rx_async = (rx_async_en) ? xxpad_async : 1'b0;

endmodule



/*********************Sampler Model******************************/

module sampler #(parameter real t_setup=20, parameter real t_hold=20, parameter real t_clk2q=40)
		(
		input data_in,
		input rst,
		input clk,
		output data_out
		);

reg data_1;

reg sample_1,sample_2;
reg q1,q2,q3;
reg q3_prev;

wire clk_1;

assign #(t_setup) data_1 = data_in;
assign #(t_hold) clk_1 = clk;

always @(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		sample_1 = 1'b0;
	end
	else
	begin
		sample_1 = data_in;
	end
end

always @(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		sample_2 = 1'b0;
	end
	else
	begin
		sample_2 = data_1;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q3 = 1'b0;
		q3_prev = 1'b0;
	end
	else
	begin
		q3 <= data_in;
		q3_prev <= q3;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q1 = 1'b0;
	end
	else
	begin
		q1 = sample_1;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q2 = 1'b0;
	end
	else
	begin
		q2 <= sample_2;
	end
end

assign #(t_clk2q - t_hold) data_out = ((q1==q2) && (q2==q3) &&(q1==q3)) ? q3 : q3_prev;

endmodule

module en_logic
		(
		input data,
		input data_async,
		input pwrgoodtx,
		input pwrgood,
		input rst_strap,
		input wk_pu_en,
		input wk_pd_en,
		input compen_n,
		input compen_p,
		input tx_en,
		input sdr_mode_en,
		input tx_async_en,
		input gen1_en,
		input gen2_en,
		input bypass_serialiser,
		output reg pu_en_gen1,
		output reg pd_en_gen1,
		output reg pu_en_gen2,
		output reg pd_en_gen2,
		output reg wkpd_en,
		output reg wkpu_en,
		output reg data_out,
		output reg data_out_async
		);

logic [12:0] en_bus;

assign en_bus = {pwrgoodtx,pwrgood,rst_strap,wk_pu_en,wk_pd_en,compen_n,compen_p,tx_en,sdr_mode_en,tx_async_en,gen1_en,gen2_en,bypass_serialiser};

always @(en_bus,data,data_async)
begin
	casez(en_bus)
		13'b??1?????????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b1;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'b0;		//Strong Pull-down
									data_out_async = 1'b0;
									end
		13'b01??????????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bz;		//High Z
									data_out_async = 1'bz;
									end
		13'b10??????????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bz;		//High Z
									data_out_async = 1'bz;
									end
		13'b110??10???0?? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b1;
									pd_en_gen2 = 1'b1;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bx;		//Both PU & PD is enabled. So X-state
									data_out_async = 1'bz;
									end
		13'b110??01???1?? : begin
									pu_en_gen1 = 1'b1;
									pd_en_gen1 = 1'b1;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bx;		//Both PU & PD is enabled. So X-state
									data_out_async = 1'bz;
									end
		13'b11010000????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b1;
									data_out = 1'b1; 		//Weak pull-up
									data_out_async = 1'bz;
									end
		13'b11001000????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b1;
									wkpu_en = 1'b0;
									data_out = 1'b0;		//Weak pull-down
									data_out_async = 1'bz;
									end
		13'b11011000????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b1;
									wkpu_en = 1'b1;
									data_out = 1'bx;		//Weak pull-down
									data_out_async = 1'bz;
									end
		13'b1100000??11?? : begin
									pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
									pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bz;
									data_out_async = data_async;//ASYNC MODE(in GEN1 Mode by default) - tx_async data driven to xxpad_async
									end
		13'b11000000????? : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = 1'bz;		//High Z
									data_out_async = 1'bz;		//High Z
									end
		13'b11000001?01?1 : begin
									pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
									pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = data_async;			//ASYNC MODE(in GEN1 Mode by default) - tx_async data driven to xxpad
									data_out_async = 1'bz;
									end
		13'b11000001001?0 : begin
									pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
									pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = data;			//GEN1 Mode- Serialised data
									data_out_async = 1'bz;
									end
		13'b11000001000?0 : begin
									pu_en_gen1 = 1'b0;
									pd_en_gen1 = 1'b0;
									pu_en_gen2 = (data == 1'b1) ? 1'b1 : 1'b0;
									pd_en_gen2 = (data == 1'b0) ? 1'b1 : 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = data;			//GEN2 Mode - Serialised data
									data_out_async = 1'bz;
									end
		13'b11000001101?0 : begin
									pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
									pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
									pu_en_gen2 = 1'b0;
									pd_en_gen2 = 1'b0;
									wkpd_en = 1'b0;
									wkpu_en = 1'b0;
									data_out = data;			//SDR MODE(in GEN1 Mode by default) - even data driven to xxpad
									data_out_async = 1'bz;
									end
/*
		13'b1100_0001_100?_0 : begin
									$display("Error : GEN2 MODE is enabled in SDR MODE");
									end

		13'b1100_000?_?10?_? : begin
									$display("Error : GEN2 MODE is enabled in ASYNC MODE");
									end
		13'b1100_0001_?10?_1 : begin
									$display("Error : GEN2 MODE is enabled in ASYNC MODE");
									end
*/
		default : begin $display("OPERATION IS NOT ANY MODE"); end
	endcase
end

endmodule

