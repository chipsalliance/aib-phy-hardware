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
	
	// Slice adapter <> wrapper bundles into Tx, Rx, PoR, spares
	val lastTx = p(AIB3DKey).numTxIOs + p(AIB3DKey).numTxCtrlClk
	val lastRx = p(AIB3DKey).patchSize - p(AIB3DKey).numRxIOs - p(AIB3DKey).numRxCtrlClk
	val (a2pTx, a2pNotTx) = adapter_to_pad.in.splitAt(lastTx)
	val (p2aTx, p2aNotTx) = pad_to_adapter.out.splitAt(lastTx)
	val (a2pNotRx, a2pRx) = adapter_to_pad.in.splitAt(lastRx)
	val (p2aNotRx, p2aRx) = pad_to_adapter.out.splitAt(lastRx)
	val a2pPoR = adapter_to_pad.in.slice(p(AIB3DKey).porIdx.start, p(AIB3DKey).porIdx.end)
	val p2aPoR = pad_to_adapter.out.slice(p(AIB3DKey).porIdx.start, p(AIB3DKey).porIdx.end)
	val a2pSpares = adapter_to_pad.in.slice(p(AIB3DKey).sparesIdx.start, p(AIB3DKey).sparesIdx.end)
	val p2aSpares = pad_to_adapter.out.slice(p(AIB3DKey).sparesIdx.start, p(AIB3DKey).sparesIdx.end)

	// Weak pull-up/down logic
	a2pTx.foreach(_.wkpu_en := csrs.tx_wkpu)
	a2pTx.foreach(_.wkpd_en := csrs.tx_wkpd | (!csrs.pad_rstb))
	a2pRx.foreach(_.wkpu_en := csrs.rx_wkpu)
	a2pRx.foreach(_.wkpd_en := csrs.rx_wkpd | (!csrs.pad_rstb))
	a2pPoR.foreach(_.wkpu_en := false.B)
	a2pPoR.foreach(_.wkpd_en := true.B)
	a2pSpares.foreach(_.wkpu_en := false.B)
	a2pSpares.foreach(_.wkpd_en := true.B)

	// Tx enable logic
	a2pTx.foreach(_.tx_en := csrs.pad_en & csrs.pad_rstb)
	a2pNotTx.foreach(_.tx_en := false.B)

	// Rx enable logic
	a2pRx.foreach(_.rx_en := csrs.pad_en & csrs.pad_rstb)
	a2pNotRx.foreach(_.rx_en := false.B)

	// Async enable logic
	a2pTx.foreach(_.async_tx_en := false.B)
	a2pTx.foreach(_.async_rx_en := false.B)
	a2pRx.foreach(_.async_tx_en := false.B)
	a2pRx.foreach(_.async_rx_en := false.B)
	a2pSpares.foreach(_.async_tx_en := false.B)
	a2pSpares.foreach(_.async_rx_en := false.B)
	// patch_reset - leader is input
	a2pPoR(0).async_tx_en := !csrs.leader
	a2pPoR(0).async_rx_en := csrs.leader
	// patch_detect - leader is output
	a2pPoR(1).async_tx_en := csrs.leader
	a2pPoR(1).async_rx_en := !csrs.leader

	// Adapter <> wrapper data
  val adapterTx = p(AIB3DKey).adapterIoMap.keys.toList.take(p(AIB3DKey).numTxIOs + p(AIB3DKey).numTxCtrlClk)
	(a2pTx zip adapterTx).foreach { case(w, a) => w.data := adapter(a) }
	a2pNotTx.foreach(_.data := 0.U)
  val adapterRx = p(AIB3DKey).adapterIoMap.keys.toList.takeRight(p(AIB3DKey).numRxIOs + p(AIB3DKey).numRxCtrlClk)
	(p2aRx zip adapterRx).foreach { case(w, a) => adapter(a) := w.data }
	p2aNotRx.foreach(_.data := DontCare)

	// Adapter <> wrapper async
	a2pPoR(0).async := adapter("patch_reset_out")
	a2pPoR(1).async := adapter("patch_detect_out")
	adapter("patch_reset_in") := p2aPoR(0).async
	adapter("patch_detect_in") := p2aPoR(1).async
	a2pTx.foreach(_.async := 0.U)
	p2aTx.foreach(_.async := DontCare)
	a2pRx.foreach(_.async := 0.U)
	p2aRx.foreach(_.async := DontCare)
	a2pSpares.foreach(_.async := 0.U)
	p2aSpares.foreach(_.async := DontCare)

	// Wrappers <> pads
  adapter_to_pad.out <> to_pad  // double flipping not recognized
  (pad_to_adapter.in zip from_pad).foreach { case(lhs, rhs) => 
	  lhs.data := rhs.data
	  lhs.async := rhs.async
  }
	// these don't exist in reverse direction - tie & optimize out
  pad_to_adapter.in.foreach{i =>
    List(i.tx_en, i.rx_en, i.async_tx_en, i.async_rx_en, i.wkpu_en, i.wkpd_en).foreach(_ := false.B)
  }
	pad_to_adapter.out.foreach{o => 
		List(o.tx_en, o.rx_en, o.async_tx_en, o.async_rx_en, o.wkpu_en, o.wkpd_en).foreach(_ := DontCare)
	}
}