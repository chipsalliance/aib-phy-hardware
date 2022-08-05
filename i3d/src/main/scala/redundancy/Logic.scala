package aib3d.redundancy

import chisel3._

import chisel3.util.{log2Ceil, Cat, Fill}
import freechips.rocketchip.config.Parameters

import aib3d._

/** Unit 2-input mux for shifting up */
class RedundancyUpLogic extends RawModule {
	val shift = IO(Input(Bool()))
	val in = IO(Vec(2, new RedundancyMuxBundle))  // (idx, idx+2)
	val out = IO(Flipped(new RedundancyMuxBundle))
  out <> in(shift.asUInt)
}

/** Unit 3-input mux for shifting down */
class RedundancyDownLogic extends RawModule {
	val shift = IO(Input(Bool()))
	val in = IO(Vec(3, new RedundancyMuxBundle))  // (idx-2, idx, idx+2)
	val out = IO(Flipped(new RedundancyMuxBundle))
	when (shift) { 
    out.data := in(0).data
    out.async := in(0).async
    out.tx_en := in(2).tx_en
    out.rx_en := in(2).rx_en
    out.async_tx_en := in(2).async_tx_en
    out.async_rx_en := in(2).async_rx_en
    out.wkpu_en := in(2).wkpu_en
    out.wkpd_en := in(2).wkpd_en
  }	.otherwise { 
    out <> in(1)
  } 
}

/** Unit 2-input mux for last 2 shift downs */
class RedundancyEndLogic extends RawModule {
  val shift = IO(Input(Bool()))
  val in = IO(Vec(2, new RedundancyMuxBundle))  // (idx, idx-2)
  val out = IO(Flipped(new RedundancyMuxBundle))
  out.data := in(shift.asUInt).data
  out.async := in(shift.asUInt).async
  out.tx_en := in(0).tx_en
  out.rx_en := in(0).rx_en
  out.async_tx_en := in(0).async_tx_en
  out.async_rx_en := in(0).async_tx_en
  out.wkpu_en := in(0).wkpu_en
  out.wkpd_en := in(0).wkpu_en
}

/** Unit 3-input mux for spares */
class RedundancySpareLogic extends RawModule {
	val shift = IO(Input(Vec(2, Bool())))  // (idx-2, idx+2)
	val in = IO(Vec(3, new RedundancyMuxBundle))  // (idx-2, idx, idx+2)
	val out = IO(Flipped(new RedundancyMuxBundle))

	when (shift(0)) {
		out <> in(0)
	} .elsewhen (shift(1)) {
		out.data := in(1).data
		out.async := in(1).async
		out.tx_en := in(2).tx_en
		out.rx_en := in(2).rx_en
		out.async_tx_en := in(2).async_tx_en
		out.async_rx_en := in(2).async_rx_en
		out.wkpu_en := in(2).wkpu_en
		out.wkpd_en := in(2).wkpd_en
	} .otherwise {
		out <> in(1)
	}
}

/** 
  * Decodes faulty bump number to shift enable signals
  * If faulty = index of either spare or > patch size, no redundancy
  */
trait RedundancyShiftLogicIO { this: RawModule =>
  implicit val p: Parameters  
  val faulty = IO(Input(UInt(log2Ceil(p(AIB3DKey).patchSize).W)))
	val shift = IO(Output(UInt(p(AIB3DKey).patchSize.W)))
}
class RedundancyShiftLogic(implicit val p: Parameters) extends RawModule with RedundancyShiftLogicIO {
  val lastUp = p(AIB3DKey).sparesIdx.head - 1
  val firstDown = p(AIB3DKey).sparesIdx.last + 1

  val upOnes = Fill(p(AIB3DKey).sparesIdx.head, 1.U)
  val downOnes = Fill(p(AIB3DKey).patchSize - p(AIB3DKey).sparesIdx.end, 1.U)

	when (faulty < p(AIB3DKey).sparesIdx.head.U) {
		shift := (upOnes << faulty)(p(AIB3DKey).sparesIdx.head-1, 0)  // zero-extended
	} .elsewhen (faulty > p(AIB3DKey).sparesIdx.last.U) {
		shift := Cat(~(downOnes << faulty - p(AIB3DKey).sparesIdx.last.U), 0.U(p(AIB3DKey).sparesIdx.end.W))
	} .otherwise {  // spares
		shift := 0.U
	}
}