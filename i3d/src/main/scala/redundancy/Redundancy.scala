package aib3d.redundancy

import chisel3._

import chisel3.experimental.noPrefix
import freechips.rocketchip.config.Parameters

import aib3d._

/** Wraps a redundancy unit for one direction */
class RedundancyWrapper(implicit p: Parameters) extends Module {
  val shift = IO(Input(UInt(p(AIB3DKey).patchSize.W)))
	val in = IO(Vec(p(AIB3DKey).patchSize, new RedundancyMuxBundle))
	val out = IO(Vec(p(AIB3DKey).patchSize, Flipped(new RedundancyMuxBundle)))

	// Microbumps that connect to only one signal (first 2)
  out(0) <> in(0)
  out(1) <> in(1)

	// Micro bumps that connect to three signals (spares)
	for (i <- p(AIB3DKey).sparesIdx) {
		val spare = noPrefix { Module(new RedundancySpareLogic).suggestName(s"redundancy_$i") }
		spare.shift(0) := shift(i-2)
		spare.shift(1) := shift(i+2)
		spare.in(0) <> in(i-2)
		spare.in(1) <> in(i)
		spare.in(2) <> in(i+2)
		out(i) <> spare.out
	}

	// Shift up from lower numbered microbumps (Tx)
	for (i <- 2 until p(AIB3DKey).sparesIdx.head) {
		val up = noPrefix { Module(new RedundancyUpLogic).suggestName(s"redundancy_$i") }
		up.shift := shift(i)
		up.in(0) <> in(i)
		up.in(1) <> in(i-2)
		out(i) <> up.out
	}

	// Shift down from higher numbered microbumps (Rx)
	for (i <- p(AIB3DKey).sparesIdx.end until p(AIB3DKey).patchSize - 2) {
		val down = noPrefix { Module(new RedundancyDownLogic).suggestName(s"redundancy_$i") }
		down.shift := shift(i)
		down.in(0) <> in(i-2)
    down.in(1) <> in(i)
    down.in(2) <> in(i+2)
		out(i) <> down.out
	}

  // Last 2 is a special case
  for (i <- List(p(AIB3DKey).patchSize-1, p(AIB3DKey).patchSize-2)) {
    val end = noPrefix { Module(new RedundancyEndLogic).suggestName(s"redundancy_$i") }
    end.shift := shift(i)
    end.in(0) := in(i)
    end.in(1) := in(i-2)
    out(i) <> end.out
  }
}

/** 
  * Top-level redundancy unit, sits between adapter and pads 
  * TODO: optionally support loopback
  */
class RedundancyTop(implicit p: Parameters) extends Module {
	val from_pad = IO(Vec(p(AIB3DKey).patchSize, new RedundancyMuxDataBundle))
	val to_pad = IO(Vec(p(AIB3DKey).patchSize, Flipped(new RedundancyMuxBundle)))
	val adapter = IO(Flipped(new AdapterToRedundancyBundle))
	val csrs = IO(new RedundancyConfigBundle)

	// 1 wrapper for each direction
	val adapter_to_pad, pad_to_adapter = Module(new RedundancyWrapper)

	// Generate shifts
	val shifter = Module(new RedundancyShiftLogic)
	shifter.faulty := csrs.faulty
	adapter_to_pad.shift := shifter.shift
	pad_to_adapter.shift := shifter.shift

  // Generate adapter_to_pad control based on type
  (p(AIB3DKey).padsIoTypes zip adapter_to_pad.in).foreach {
    case(io, a2p) => io._2 match {
      case _:TxSeq =>
        a2p.tx_en := csrs.pad_en & csrs.pad_rstb
        a2p.rx_en := false.B
        a2p.async_tx_en := false.B
        a2p.async_rx_en := false.B
        a2p.wkpu_en := csrs.tx_wkpu
        a2p.wkpd_en := csrs.tx_wkpd | (!csrs.pad_rstb)
      case _:TxAsync => 
        a2p.tx_en := false.B
        a2p.rx_en := false.B
        a2p.async_tx_en := csrs.pad_en & csrs.pad_rstb
        a2p.async_rx_en := false.B
        a2p.wkpu_en := csrs.tx_wkpu
        a2p.wkpd_en := csrs.tx_wkpd | (!csrs.pad_rstb)
      case _:RxSeq =>
        a2p.tx_en := false.B
        a2p.rx_en := csrs.pad_en & csrs.pad_rstb
        a2p.async_tx_en := false.B
        a2p.async_rx_en := false.B
        a2p.wkpu_en := csrs.rx_wkpu
        a2p.wkpd_en := csrs.rx_wkpu | (!csrs.pad_rstb)
      case _:RxAsync =>
        a2p.tx_en := false.B
        a2p.rx_en := false.B
        a2p.async_tx_en := false.B
        a2p.async_rx_en := csrs.pad_en & csrs.pad_rstb
        a2p.wkpu_en := csrs.rx_wkpu
        a2p.wkpd_en := csrs.rx_wkpu | (!csrs.pad_rstb)
      case _:PoR =>
        a2p.tx_en := false.B
        a2p.rx_en := false.B
        if (io._1 == "patch_reset") {
          a2p.async_tx_en := !csrs.leader
          a2p.async_rx_en := csrs.leader
        } else {
          a2p.async_tx_en := csrs.leader
          a2p.async_rx_en := !csrs.leader
        }
        a2p.wkpu_en := false.B
        a2p.wkpd_en := true.B
      case _:Spare =>
        a2p.tx_en := false.B
        a2p.rx_en := false.B
        a2p.async_tx_en := false.B
        a2p.async_rx_en := false.B
        a2p.wkpu_en := false.B
        a2p.wkpd_en := true.B
      case _ =>  // TODO: bidirectional - needs additional CSRs
    }
  }

  // Generate adapter <> wrapper data/async connections based on bump number + type
  (adapter_to_pad.in zip pad_to_adapter.out).zipWithIndex.foreach {
    case((a2p, p2a), i) =>
      val signals = p(AIB3DKey).adapterIoTypes.filter{ case(_, t) => t.bumpNum == i }
      // Flags to prevent re-assignments for bidirectional signals
      var a2p_d_uninit, a2p_a_uninit, p2a_d_uninit, p2a_a_uninit = true
      signals.foreach{ case(name, t) => t match {     
        case _:TxSeq =>
          if (!a2p_d_uninit) throw new RebindingException(s"Can't have 2 TxSeq-type signals for bump $i!")
          a2p_d_uninit = false; a2p.data := adapter(name)
          if (a2p_a_uninit)     a2p.async := 0.U
          if (p2a_d_uninit)     p2a.data := DontCare
          if (p2a_a_uninit)     p2a.async := DontCare
        case _:TxAsync =>
          if (!a2p_a_uninit) throw new RebindingException(s"Can't have 2 TxAsync-type signals for bump $i!")         
          if (a2p_d_uninit)     a2p.data := 0.U
          a2p_a_uninit = false; a2p.async := adapter(name)
          if (p2a_d_uninit)     p2a.data := DontCare
          if (p2a_a_uninit)     p2a.async := DontCare
        case _:RxSeq =>
          if (!p2a_d_uninit) throw new RebindingException(s"Can't have 2 RxSeq-type signals for bump $i!")         
          if (a2p_d_uninit)     a2p.data := 0.U
          if (a2p_a_uninit)     a2p.async := 0.U
          p2a_d_uninit = false; adapter(name) := p2a.data
          if (p2a_a_uninit)     p2a.async := DontCare
        case _:RxAsync =>
          if (!p2a_a_uninit) throw new RebindingException(s"Can't have 2 RxAsync-type signals for bump $i!")         
          if (a2p_d_uninit)     a2p.data := 0.U
          if (a2p_a_uninit)     a2p.async := 0.U
          if (p2a_d_uninit)     p2a.data := DontCare
          p2a_a_uninit = false; adapter(name) := p2a.async
        case _ =>  // not valid
      }}
  }

  // Tie off spares' data/async
  val spares = p(AIB3DKey).padsIoTypes.filter{ case(n, _) => n contains "spare" }
  spares.foreach{ case(_, t) => 
    adapter_to_pad.in(t.bumpNum).data := 0.U
    adapter_to_pad.in(t.bumpNum).async := 0.U
    pad_to_adapter.out(t.bumpNum).data := DontCare
    pad_to_adapter.out(t.bumpNum).async := DontCare
  }
	
	// Wrappers <> pads
  adapter_to_pad.out <> to_pad  // double flipping not recognized
  (pad_to_adapter.in zip from_pad).foreach { case(p2a, fp) => 
	  p2a.data := fp.data
	  p2a.async := fp.async
  }
	// these don't exist in reverse direction - tie & optimize out
  pad_to_adapter.in.foreach{i =>
    List(i.tx_en, i.rx_en, i.async_tx_en, i.async_rx_en, i.wkpu_en, i.wkpd_en).foreach(_ := false.B)
  }
	pad_to_adapter.out.foreach{o => 
		List(o.tx_en, o.rx_en, o.async_tx_en, o.async_rx_en, o.wkpu_en, o.wkpd_en).foreach(_ := DontCare)
	}
}