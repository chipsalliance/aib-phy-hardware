package aib3d

import chisel3._

import chisel3.util.log2Ceil
import freechips.rocketchip.config.Parameters

/** Top-level and adapter bundles */
class BumpsBundle(implicit p: Parameters) extends Record {
	val elements = p(AIB3DKey).padsIoMap
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new BumpsBundle).asInstanceOf[this.type]
}

class MacBundle(implicit p: Parameters) extends Bundle {
	// MAC-facing IOs
  val ns_adapter_rstn = Input(Bool())

	// Data
	val data_in = if(p(AIB3DKey).numTxIOs > 0) Some(Input(UInt(p(AIB3DKey).numTxIOs.W))) else None
	val data_out = if(p(AIB3DKey).numRxIOs > 0) Some(Output(UInt(p(AIB3DKey).numRxIOs.W))) else None

	// Status
	val ns_mac_rdy = Input(Bool())  // Near-side MAC ready for data transfer
  val conf_done = Output(Bool())  // Near-side finished config (equiv. to ns_transfer_en)
	val fs_mac_rdy = Output(Bool()) // Far-side MAC ready for data transfer (equiv. to fs_transfer_en)
}

class AppBundle(implicit p: Parameters) extends Bundle {
	// Application interface IOs - used for initialization
  val dual_mode_select = Input(Bool())  // HI = leader, LO = follower
	val power_on_reset = Input(Bool())  // Controls ns_patch_por and disables transfers. Must be stable @ power up.
  val m_patch_reset = Output(Bool())  // If far side is follower, denotes if reset is commanded (active HI)
	val m_patch_detect = Output(Bool())  // If far side is leader, denotes patch present (active HI)
}

class ScanBundle(implicit p: Parameters) extends Bundle {
	val scan_clk = Input(Clock())
  // TODO
}

/** Redundancy bundles */
/** Unit bundles for redundancy mux cells */
class RedundancyMuxDataBundle extends Bundle {
  val data, async = Input(Bits(1.W))
}
class RedundancyMuxBundle extends RedundancyMuxDataBundle {
  val tx_en, rx_en, async_tx_en, async_rx_en, wkpu_en, wkpd_en = Input(Bool())
}

/** Config signals for RedundancyTop */
class RedundancyConfigBundle(implicit p: Parameters) extends Bundle {
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

/** This generates the adapter to redundancy data connection */
class AdapterToRedundancyBundle(implicit p: Parameters) extends Record {
  val elements = p(AIB3DKey).adapterIoMap
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new AdapterToRedundancyBundle).asInstanceOf[this.type]
}

// DLL control
class DeskewCtrlBundle extends Bundle {
  val start = Input(Bool())
  val locked = Output(Bool())
}