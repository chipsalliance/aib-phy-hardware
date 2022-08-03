package aib3d.deskew

import chisel3._

class DeskewCtrlBundle extends Bundle {
  val start = Input(Bool())
  val locked = Output(Bool())
}
/**
  * This fully-synthesizable DLL uses a folded delay line topology, originally designed by Uneeb Rathore.
  * This DLL is to be used for phase alignment for receive data sampling.
  */
class DLL extends Module {
  // implicit clock is reference clock
  val clk_loop = IO(Input(Clock()))
  val clk_out = IO(Output(Clock()))
  val ctrl = IO(new DeskewCtrlBundle())

  clk_out := false.B.asClock
  ctrl.locked := false.B

  // val GL
}