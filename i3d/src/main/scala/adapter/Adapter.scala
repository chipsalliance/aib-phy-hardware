package aib3d.adapter

import chisel3._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.util.SynchronizerShiftReg

import aib3d._

/**
 * Adapter module contains FSMs and additional blocks like BERT.
 */
class Adapter(implicit p: Parameters) extends Module {
  // Implicit clock is m_ns_fwd_clk
  // Implicit reset is !ns_adapter_rstn
	val m_fs_fwd_clk = IO(Input(Clock()))  // Near-side input received from far-side (deskewed)
  // MAC interface (data, status)
  val mac = IO(new MacBundle)
  // To/from deskew block
  val deskewCtrl = IO(Flipped(new DeskewCtrlBundle))
  // To/from redundancy block
  val redundancy = IO(new AdapterToRedundancyBundle)
  val redundancy_cfg = IO(Flipped(new RedundancyConfigBundle))
  // Application interface
  val app = IO(new AppBundle)
  // From CSRs
  val io_ctrl = IO(Input(UInt(4.W)))
  val redund = IO(Input(UInt(redundancy_cfg.faulty.getWidth.W)))

  // Power-on reset logic
  redundancy("ns_patch_por") := app.dual_mode_select || app.power_on_reset
  app.m_patch_reset := app.dual_mode_select && redundancy("fs_patch_por").asTypeOf(Bool())
  app.m_patch_detect := app.dual_mode_select || redundancy("fs_patch_por").asTypeOf(Bool())

  // Data transfer ready logic
  deskewCtrl.start := !reset.asBool
  val ns_transfer_en = Wire(Bool())
  ns_transfer_en := !reset.asBool && deskewCtrl.locked && mac.ns_mac_rdy
  redundancy("ns_transfer_en") := ns_transfer_en
  mac.conf_done := ns_transfer_en
  mac.fs_mac_rdy := redundancy("fs_transfer_en")

  // Redundancy config logic
  redundancy_cfg.pad_rstb := !reset.asBool
  redundancy_cfg.pad_en := ns_transfer_en
  redundancy_cfg.leader := app.dual_mode_select
  redundancy_cfg.tx_wkpu := io_ctrl(3)
  redundancy_cfg.tx_wkpd := io_ctrl(2)
  redundancy_cfg.rx_wkpu := io_ctrl(1)
  redundancy_cfg.rx_wkpd := io_ctrl(0)
  redundancy_cfg.faulty := redund

  // TODO: synchronizers for particular logic

  // Data pass thru
  // TODO: add optional BERT, loopback
  for (i <- 0 until p(AIB3DKey).numTxIOs) {
    redundancy(s"tx_$i") := mac.data_in.get(i)
  }
  if (p(AIB3DKey).numRxIOs > 0) {
    mac.data_out.get := VecInit.tabulate(p(AIB3DKey).numRxIOs)(i => redundancy(s"rx_$i")).asUInt
  }

  // Clock pass thru
  redundancy("ns_fwd_clk") := clock.asUInt
  redundancy("ns_fwd_clkb") := !(clock.asBool)
}

