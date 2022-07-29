package aib3d.adapter

import chisel3._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.util.AsyncResetShiftReg

import aib3d._
import aib3d.redundancy.AdapterToRedundancyBundle
import aib3d.deskew.DeskewCtrlBundle

/* Signals used for initialization */
class AppBundle(implicit p: Parameters) extends Bundle {
	// Application interface IOs
	val power_on_reset = Input(Bool())  // Controls patch_reset to leader. Must be stable @ power up.
	val patch_reset_ovrd = Input(Bool())  // Intended for standalone test without an AIB partner
											// LO = leader not in reset
											// HI = leader in reset if patch_reset = 1 (w/ weak pull-up)
  val patch_reset = Output(Bool())  // Denotes if follower in reset 
	val patch_detect = Output(Bool())  // From leader's patch_detect, qualified by patch_detect_ovrd
	val patch_detect_ovrd = Input(Bool())  // Intended for standalone test without an AIB partner
												// LO = follower uses device_detect
												// HI = follower outputs m_device_detect = 1
}

/**
 * Adapter module contains FSMs and additional blocks like BERT.
 */
class Adapter(implicit p: Parameters) extends Module {
  val m_ns_fwd_clk = IO(Input(Clock()))  // Near-side input for transmitting to far-side
	val m_fs_fwd_clk = IO(Input(Clock()))  // Near-side input received from far-side (deskewed)
  val fs_fwd_clk = IO(Output(Clock()))  // Near-side input received from far-side (not yet deskewed)

  // Data, reset
  val mac = IO(new MacBundle)

  // To/from deskew block
  val deskewCtrl = IO(Flipped(new DeskewCtrlBundle))
  val deskewReset = IO(Output(Reset()))

  // To/from redundancy block
  val redundancy = IO(Flipped(new AdapterToRedundancyBundle))

  // App (power-on reset) interface + logic
  val app = IO(new AppBundle)
  redundancy("patch_reset_out") := app.power_on_reset
  app.patch_reset := app.patch_reset_ovrd & redundancy("patch_reset_in").asUInt
  redundancy("patch_detect_out") := true.B
  app.patch_detect := app.patch_detect_ovrd & redundancy("patch_detect_in").asUInt

  // Data transfer ready logic
  // TODO: clarify how this doesn't circularly reset everything
  redundancy("ns_transfer_rstb") := !reset.asBool
  val adapter_rstb = Wire(Bool())
  adapter_rstb := !reset.asBool && redundancy("fs_transfer_rstb").asUInt.asBool && deskewCtrl.locked
  // TODO: sync'd resets for particular logic
  deskewReset := AsyncResetShiftReg(!adapter_rstb, 2)
  redundancy("ns_transfer_en") := !reset.asBool && deskewCtrl.locked
  deskewCtrl.start := redundancy("fs_transfer_en")

  // Data pass thru
  // TODO: add optional BERT, loopback
  for (i <- 0 until p(AIB3DKey).numTxIOs) {
    redundancy(s"tx_$i") := mac.data_in(i)
  }
  for (i <- 0 until p(AIB3DKey).numRxIOs) {
    mac.data_out(i) := redundancy(s"rx_$i")
  }
  // Clock pass thru
  redundancy("ns_fwd_clk") := m_ns_fwd_clk
  redundancy("ns_fwd_clkb") := !(m_ns_fwd_clk.asBool)
  fs_fwd_clk := redundancy("fs_fwd_clk")
  redundancy("fs_fwd_clkb") := DontCare
}