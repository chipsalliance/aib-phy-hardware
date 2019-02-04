// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib_aux_channel
// Description    : Behavioral model of aux channel
// Revision       : 1.0
// ============================================================================
//
//
module aib_aux_channel 
   (
    // AIB IO Bidirectional 
    inout wire          iopad_dev_dect,
    inout wire          iopad_dev_dectrdcy,
    inout wire          iopad_dev_por,
    inout wire          iopad_dev_porrdcy,

    input               device_detect_ms,
    output wire         por_ms,
    input               por_sl,
    output wire         osc_clk,
    input               ms_nsl, //"1", this is a Master. "0", this is a Slave
    input               irstb // Output buffer tri-state enable
    );


   wire device_detect_oe, device_detect_oerdcy;
   wire device_detect_ie, device_detect_ierdcy;
   
   wire por_oe, por_oerdcy;
   wire por_ie, por_ierdcy;

   wire device_detect_sl_main, device_detect_sl_rdcy;

   wire por_ms_main, por_ms_rdcy;

   assign por_ms = por_ms_main & por_ms_rdcy;
   
   assign device_detect_oe = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign device_detect_oerdcy = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign device_detect_ie = !device_detect_oe;
   assign device_detect_ierdcy = !device_detect_oerdcy;

   assign por_oe = (ms_nsl == 1'b1) ? 1'b0 : 1'b1;
   assign por_oerdcy = (ms_nsl == 1'b1) ? 1'b0 : 1'b1;
   assign por_ie = !por_oe;
   assign por_ierdcy = !por_oerdcy;

	   aib_io_buffer u_device_detect 
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (irstb),
	      .idat0       (device_detect_ms),
	      .idat1       (device_detect_ms),
	      .async_data  (device_detect_ms),
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
	      .weaken      (1'b0),
	      .weakdir     (1'b0)
	      );

	   aib_io_buffer u_device_detectrdcy  //redundancy pin
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (irstb),
	      .idat0       (device_detect_ms),
	      .idat1       (device_detect_ms),
	      .async_data  (device_detect_ms),
	      .oclkn       (),

	      // Rx Path
	      .iclkn       (1'b0),
	      .inclk       (1'b0),
	      .inclk_dist  (1'b0),
	      .oclk        (),
	      .oclk_b      (),
	      .odat0       (),
	      .odat1       (),
	      .odat_async  (device_detect_sl_rdcy),

	      // Bidirectional Data 
	      .io_pad      (iopad_dev_dectrdcy),

	      // I/O configuration
	      .async       (1'b1),
	      .ddren       (1'b0),
	      .txen        (device_detect_oerdcy),
	      .rxen        (device_detect_ierdcy),
	      .weaken      (1'b0),
	      .weakdir     (1'b0)
	      );

	   aib_io_buffer u_device_por 
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (irstb),
	      .idat0       (por_sl),
	      .idat1       (por_sl),
	      .async_data  (por_sl),
	      .oclkn       (),

	      // Rx Path
	      .iclkn       (1'b0),
	      .inclk       (1'b0),
	      .inclk_dist  (1'b0),
	      .oclk        (),
	      .oclk_b      (),
	      .odat0       (),
	      .odat1       (),
	      .odat_async  (por_ms_main),

	      // Bidirectional Data 
	      .io_pad      (iopad_dev_por),

	      // I/O configuration
	      .async       (1'b1),
	      .ddren       (1'b0),
	      .txen        (por_oe),
	      .rxen        (por_ie),
	      .weaken      (1'b0),
	      .weakdir     (1'b0)
	      );

	   aib_io_buffer u_device_porrdcy  //redundancy pin
	     (
	      // Tx Path
	      .ilaunch_clk (1'b0),
	      .irstb       (irstb),
	      .idat0       (por_sl),
	      .idat1       (por_sl),
	      .async_data  (por_sl),
	      .oclkn       (),

	      // Rx Path
	      .iclkn       (1'b0),
	      .inclk       (1'b0),
	      .inclk_dist  (1'b0),
	      .oclk        (),
	      .oclk_b      (),
	      .odat0       (),
	      .odat1       (),
	      .odat_async  (por_ms_rdcy),

	      // Bidirectional Data 
	      .io_pad      (iopad_dev_porrdcy),

	      // I/O configuration
	      .async       (1'b1),
	      .ddren       (1'b0),
	      .txen        (por_oerdcy),
	      .rxen        (por_ierdcy),
	      .weaken      (1'b0),
	      .weakdir     (1'b0)
	      );

aib_osc_clk  aib_osc_clk
    (.osc_clk(osc_clk)
    );

endmodule // aib_aux_channel
