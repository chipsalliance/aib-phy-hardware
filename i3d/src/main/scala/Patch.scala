package aib3d

import chisel3._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.jtag._

import aib3d.adapter._
import aib3d.deskew._
import aib3d.io._
import aib3d.redundancy._

class BumpsBundle(implicit p: Parameters) extends Record {
	val elements = p(AIB3DKey).padsIoMap
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new BumpsBundle).asInstanceOf[this.type]
}

class MacBundle(implicit p: Parameters) extends Bundle {
	// MAC-facing IOs
  val dual_mode_select = Input(Bool())  // HI = leader, LO = follower

	// Data
	val data_in = Input(UInt(p(AIB3DKey).numTxIOs.W))
	val data_out = Output(UInt(p(AIB3DKey).numRxIOs.W))

	// Handshake
	val ns_transfer_en = Input(Bool())  // Near-side ready for data transfer
	val fs_transfer_en = Output(Bool()) // Far-side ready to transmit data (TODO = fs_transfer_en?)

	// TODO signals for de-assertion of transfer ready

	// TODO signals for reset and recalibration
}

class ScanBundle(implicit p: Parameters) extends Bundle {
	val scan_clk = Input(Clock())

}

class Patch(implicit p: Parameters) extends Module {
  // Clocks separately
	val m_ns_fwd_clk = IO(Input(Clock()))   // Near-side input for transmitting to far-side
	val m_fs_fwd_clk = IO(Output(Clock()))  // Near-side output received from far-side (deskewed)

	val bumpio = IO(new BumpsBundle)
	val macio = IO(new MacBundle)
	val appio = IO(new AppBundle)
  val cfgio = IO(new RedundancyConfigBundle)  // TODO: these should be CSRs

  // Adapter
  val adapter = Module(new Adapter)
  adapter.app <> appio  // pass-thru
  adapter.mac <> macio  // pass-thru

  // DLL: implicit clock is received clock, reset is sync'd to its ref clk
  val dll = withClockAndReset(adapter.fs_fwd_clk, adapter.deskewReset)(Module(new DLL))
  // deskew <> adapter
  dll.ctrl <> adapter.deskewCtrl
  dll.clk_loop := dll.clk_out  // thru clock tree
  adapter.m_ns_fwd_clk := m_ns_fwd_clk
  adapter.m_fs_fwd_clk := dll.clk_out
  m_fs_fwd_clk := dll.clk_out

  // Redundancy
  val redundancy = Module(new RedundancyTop)
  adapter.redundancy <> redundancy.adapter  // bundle connect
  redundancy.cfg <> cfgio

  // IO cells
  val iocells = (0 until p(AIB3DKey).patchSize).map{ i =>
    if (p(AIB3DKey).blackBoxModels) { Module(new IOCellModel(i)).io }
    else { Module(new IOCellBB(i)).io }
  }
  // redundancy <> iocells <> bumps (all signals)
  iocells.foreach{ c =>
    c.tx_clk := m_ns_fwd_clk
    c.rx_clk := dll.clk_out
  }
  (iocells zip redundancy.to_pad).foreach{ case(c, r) => c.attachTx(r) }
  (iocells zip redundancy.from_pad).foreach{ case(c, r) => c.attachRx(r) }
  (iocells zip bumpio.elements).foreach{ case(c, (_, b)) => c.pad <> b }  

	// TODO: connect everything else
}