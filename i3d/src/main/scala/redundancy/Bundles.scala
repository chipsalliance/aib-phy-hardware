package aib3d.redundancy

import chisel3._

import chisel3.util.log2Ceil
import freechips.rocketchip.config.Parameters

import aib3d._

class RedundancyMuxDataBundle extends Bundle {
  val data, async = Input(Bits(1.W))
}

/** Unit bundle for mux cells */
class RedundancyMuxBundle extends RedundancyMuxDataBundle {
  val tx_en, rx_en, async_tx_en, async_rx_en, wkpu_en, wkpd_en = Input(Bool())
}

/** Config signals for top wrapper */
class RedundancyConfigBundle(implicit p: Parameters) extends Bundle {
  // from CSRs
  val pad_rstb = Input(Bool())
  val pad_en = Input(Bool())
  val tx_wkpu = Input(Bool())
  val tx_wkpd = Input(Bool())
  val rx_wkpu = Input(Bool())
  val rx_wkpd = Input(Bool())
  val faulty = Input(UInt(log2Ceil(p(AIB3DKey).patchSize).W))  // denotes which bump is faulty
  val leader = Input(Bool())  // denotes if near-side is leader

  // TODO: support loopback
  // val tx_lpbk_mode = Input(Bool())
  // val rx_lpbk_mode = Input(Bool())
}