`timescale 1ps/1fs

module aibio_txrx_cbb
(
	//------Supply pins------//
	input vddc,
	input vddtx,
	input vss,
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
	input txrx_anaview_in,
	//------Output pins------//
	output rx_out_even,
	output rx_out_odd,
	output rx_async,
	output [1:0] txrx_digviewout,
   output txrx_anaviewout,
	//------InOut pins------//
	inout xx_pad,
	//------Spare pins------//
	input [7:0] i_txrx_spare,
	output [7:0] o_txrx_spare
);

//---------Internal Signals------------//
wire d_even_clk;
wire d_odd_clk;
wire d_odd_clk_int;

wire clkeven_int;

reg idata;
wire idatab;
wire data;

wire rx_out_even_int;

wire pu_gen1;
wire pd_gen1;
wire pu_gen2;
wire pd_gen2;
wire wkpd;
wire wkpu;

reg tx_datain_even_latch;
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
assign idatab = !idata;

initial begin
	idata = 1'b0;
end

always@(posedge cktx_even or posedge cktx_odd)
 begin
  if(cktx_even)
   idata <= tx_datain_even;
  else if(cktx_odd)
   idata <= d_odd_clk_int;
  else
   idata <= idata;
 end

//----------------Serialiser Ends---------------------------//

always @(posedge cktx_even)
begin
	tx_datain_even_latch <= tx_datain_even;
end

assign data = tx_async_en ? tx_async   :
				  sdr_mode_en ? tx_datain_even_latch :
					idata;

//--------------Transmitter Enable logic--------------------//

en_logic_xxpad i_en_logic_pad
		(
		.data(data),
		.pwrgoodtx(pwrgood_io_in),
		.pwrgood(pwrgood_in),
		.rst_strap(rst_padlow_strap),
		.wk_pu_en(wkpu_en),
		.wk_pd_en(wkpd_en),
		.compen_n(tx_compen_n),
		.compen_p(tx_compen_p),
		.tx_en(tx_en),
		.sdr_mode_en(sdr_mode_en),
		.tx_async_en(tx_async_en),
		.gen1_en(gen1mode_en),
		.pu_en_gen1(pu_gen1),
		.pd_en_gen1(pd_gen1),
		.pu_en_gen2(pu_gen2),
		.pd_en_gen2(pd_gen2),
		.wkpd_en(wkpd),
		.wkpu_en(wkpu)
		);

//--------------------------------------------------------//


//---------------Routing serialised/even/async data to pad: logic---------------//

pad_out_logic i_pad_out_logic
		(
		.rst(rst_padlow_strap),
		.pu_gen1(pu_gen1),
		.pd_gen1(pd_gen1),
		.pu_gen2(pu_gen2),
		.pd_gen2(pd_gen2),
		.wkpu(wkpu),
		.wkpd(wkpd),
		.data_out(xx_pad)
		);

//---------------------------------------------------------------------//


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

assign rx_async = (rx_async_en) ? xx_pad : 1'b0;

endmodule
