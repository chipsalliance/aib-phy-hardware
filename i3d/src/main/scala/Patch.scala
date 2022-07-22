package aib3d

import chisel3._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.jtag._

class BumpsBundle(implicit p: Parameters) extends Record {
	val elements = p(AIB3DKey).padsIoMap
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new BumpsBundle).asInstanceOf[this.type]
}

class MacBundle(implicit p: Parameters) extends Bundle {
	// MAC-facing IOs
	val ns_adapter_rstn = Input(Reset())

	// Data
	val data_in = Input(UInt(p(AIB3DKey).numTxIOs.W))
	val data_out = Output(UInt(p(AIB3DKey).numRxIOs.W))

	// Clocks
	val m_ns_fwd_clk = Input(Clock())   // Near-side input for transmitting to far-side
	val m_fs_fwd_clk = Output(Clock())  // Near-side output received from far-side

	// Handshake
	val ns_mac_rdy = Input(Bool())  // Near-side ready for data transfer
	val fs_mac_rdy = Output(Bool()) // Far-side ready to transmit data (TODO = fs_transfer_en?)

	// TODO signals for de-assertion of transfer ready

	// TODO signals for reset and recalibration

	// TODO user-defined shift-register bits  
}

class ScanBundle(implicit p: Parameters) extends Bundle {
	val scan_clk = Input(Clock())

}

class AppBundle(implicit p: Parameters) extends ScanBundle {
	// Application interface IOs
	// Leader
	val o_m_power_on_reset = Output(Bool()) // power_on_reset from leader, qualified by override from m_por_ovrd
	val m_por_ovrd = Input(Bool())          // Intended for standalone test without an AIB partner
											// LO = leader not in reset
											// HI = leader in reset if power_on_reset = 1 (w/ weak pull-up)

	// Follower
	val i_m_power_on_reset = Input(Bool())  // Controls power_on_reset to leader. Must be stable @ power up.
	val m_device_detect = Output(Bool())    // From leader's device_detect, qualified by m_device_detect_ovrd
	val m_device_detect_ovrd = Input(Bool())    // Intended for standalone test without an AIB partner
												// LO = follower uses device_detect
												// HI = follower outputs m_device_detect = 1

	// Mode select
	val dual_mode_select = Input(Bool())    // LO = follower, HI = leader
}

class Patch(implicit p: Parameters) extends Module {
	val bumpio = IO(new BumpsBundle)
	val macio = IO(new MacBundle)
	val appio = IO(new AppBundle)

	// TODO: use rocket-chip JTAG?
	//val jtagio = IO(new JtagControllerIO)  
	//val jtag = new(JtagTapGenerator)

	// TODO: connect everything
	// mac/appio <> adapter <> redundancy <> io <> bumpio
	// macio <> deskew <> adapter
}