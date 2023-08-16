package aib3d.deskew

import chisel3._

import aib3d._

/**
  * This fully-synthesizable DLL uses a folded delay line topology, originally designed by Uneeb Rathore.
  * This DLL is to be used for phase alignment for receive data sampling.
  */
/*
class DLL extends Module {
  // implicit clock is reference clock
  val clk_loop = IO(Input(Clock()))
  val clk_out = IO(Output(Clock()))
  val ctrl = IO(new DeskewCtrlBundle())

  clk_out := clock
  ctrl.locked := RegNext(ctrl.start)

  // val GL
}
*/