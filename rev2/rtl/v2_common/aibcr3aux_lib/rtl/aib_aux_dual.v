// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_aux_channel
// Description    : Behavioral model of aux channel
// Revision       : 1.0
// ============================================================================
//
//
module aib_aux_dual 
   (
    // AIB IO Bidirectional 
    inout wire          iopad_dev_dect,
    inout wire          iopad_dev_dectrdcy,
    inout wire          iopad_dev_por,
    inout wire          iopad_dev_porrdcy,

    input               m_i_por_ovrd, //Master onlhy input, it overrides the por signal. For slave, it is tied to "0"
    input               m_i_device_detect_ovrd, //Slave only input, it overrides the device_detect signal. For Master, it is tied to "0"
    output wire         m_o_power_on_reset,
    output wire         m_o_device_detect,
    input               m_i_power_on_reset,
    input               ms_nsl //"1", this is a Master. "0", this is a Slave
    );


aib_aliasd aliaspor ( .sig_red(iopad_dev_porrdcy), .sig_in(iopad_dev_por));
aib_aliasd aliasdet ( .sig_red(iopad_dev_dectrdcy), .sig_in(iopad_dev_dect));

   wire device_detect_oe;
   wire device_detect_ie;
   
   wire por_oe;
   wire por_ie;

   wire device_detect_sl_main;

   wire m_o_power_on_reset_main;

   assign m_o_device_detect = device_detect_sl_main | m_i_device_detect_ovrd;

   assign m_o_power_on_reset = m_o_power_on_reset_main & m_i_por_ovrd;
   
   assign device_detect_oe = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign device_detect_ie = !device_detect_oe;

   assign por_oe = (ms_nsl == 1'b1) ? 1'b0 : 1'b1;
   assign por_ie = !por_oe;

	   aib_io_buffer u_device_detect 
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (1'b1),
	      .idat0       (1'b1),
	      .idat1       (1'b1),
	      .async_data  (1'b1),
	      .oclkn       (),

	      // Rx Path
	      .iclkn       (1'b0),
	      .inclk       (1'b0),
	      .inclk_dist  (1'b0),
	      .oclk        (),
	      .oclk_b      (),
	      .odat0       (),
	      .odat1       (),
	      .odat_async  (device_detect_sl_main),

	      // Bidirectional Data 
	      .io_pad      (iopad_dev_dect),

	      // I/O configuration
	      .async       (1'b1),
	      .ddren       (1'b0),
	      .txen        (device_detect_oe),
	      .rxen        (device_detect_ie),
	      .weaken      (device_detect_ie),
	      .weakdir     (1'b0)
	      );

	   aib_io_buffer u_device_por 
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (1'b1),
	      .idat0       (m_i_power_on_reset),
	      .idat1       (m_i_power_on_reset),
	      .async_data  (m_i_power_on_reset),
	      .oclkn       (),

	      // Rx Path
	      .iclkn       (1'b0),
	      .inclk       (1'b0),
	      .inclk_dist  (1'b0),
	      .oclk        (),
	      .oclk_b      (),
	      .odat0       (),
	      .odat1       (),
	      .odat_async  (m_o_power_on_reset_main),

	      // Bidirectional Data 
	      .io_pad      (iopad_dev_por),

	      // I/O configuration
	      .async       (1'b1),
	      .ddren       (1'b0),
	      .txen        (por_oe),
	      .rxen        (por_ie),
	      .weaken      (por_ie),
	      .weakdir     (1'b1)
	      );



endmodule // aib_aux_dual
