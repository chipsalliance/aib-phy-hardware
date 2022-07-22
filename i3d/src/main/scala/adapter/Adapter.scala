package aib3d.adapter

import chisel3._

import freechips.rocketchip.config.Parameters

import aib3d._
import aib3d.redundancy.AdapterToRedundancyBundle

class Adapter(implicit p: Parameters) extends Module {
  // Data
	val data_in = Input(UInt(p(AIB3DKey).numTxIOs.W))
	val data_out = Output(UInt(p(AIB3DKey).numRxIOs.W))

	// Clocks
	val m_ns_fwd_clk = Input(Clock())   // Near-side input for transmitting to far-side
	val m_fs_fwd_clk = Output(Clock())  // Near-side output received from far-side

  val redundancy = IO(new AdapterToRedundancyBundle)


  // Retimers
  // val tx
}

