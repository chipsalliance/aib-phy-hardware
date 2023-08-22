package aib3d.redundancy

import chisel3._

import chisel3.experimental.{noPrefix, DataMirror}
import org.chipsalliance.cde.config.Parameters
import testchipip.ClockMux2

import aib3d._
import aib3d.io._

/** Redundancy muxes per submodule*/
class RedundancyMuxSubmod(
  submodIdxA: AIB3DCoordinates[Int],
  submodIdxB: AIB3DCoordinates[Int],
  isTx: Boolean = true)(implicit p: Parameters) extends RawModule {

  // Note difference in submod indices for Tx vs. Rx
  val (a, b, o) = (
    IO(new SubmodBundle(submodIdxA, coreFacing = isTx)),
    IO(new SubmodBundle(submodIdxB, coreFacing = isTx)),
    IO(new SubmodBundle(submodIdxA, coreFacing = !isTx)))

  // TODO: Output false path annotation for shift input
  val shift = IO(Input(Bool()))

  a.elements.values zip b.elements.values zip o.elements.values foreach {
    case ((av, bv), ov) =>
      require(DataMirror.directionOf(av) == ActualDirection.Input &&
        DataMirror.directionOf(bv) == ActualDirection.Input &&
        DataMirror.directionOf(ov) == ActualDirection.Output,
        "Improper directions of a, b, o in redundancy mux")
      // This clock mux is NOT glitchless (fine, because shift is static)
      if (DataMirror.checkTypeEquivalence(ov, Clock())) {
        val clkMux = Module(new ClockMux2)
        clkMux.io.sel := shift
        clkMux.io.clocksIn(0) := av
        clkMux.io.clocksIn(1) := bv
        ov := clkMux.io.clockOut
      }
      else ov := Mux(shift, bv, av)
  }
}

/** Top-level shift redundancy add-on module */
class RedundancyMuxTop(implicit p: Parameters) extends RawModule {
  val params = p(AIB3DKey)

  val bumps = IO(new BumpsBundle(atBumps = false))  // internal
  val core = IO(new CoreBundle)

  // One hot encoding
  val txFaulty, rxFaulty = IO(Input(UInt(params.numSubmods.W)))

  // Shift in the longer dimension
  // Order is (tx.a, tx.b, rx.a, rx.b)
  val submodIdxs = if (params.isWide) {
    for {
      j <- 0 until params.submodRowsWR
      i <- 0 until params.submodColsWR - 2 by 2
    } yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](i+k, j))
  } else {
    for {
      i <- 0 until params.submodColsWR
      j <- 0 until params.submodRowsWR - 2 by 2
    } yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](i, j+k))
  }
  // Use these indices to generate the shift signal for each mux
  // Essentially, count the bit positions (by 2) to the right of the current one
  // that contains a 1 in the one-hot encoding of txFaulty and rxFaulty
  val (txShift, rxShift) = submodIdxs.indices.map { idx =>
    val tx, rx = Wire(Bool())
    val dependsOn = (idx % 2 to idx by 2)
    tx := dependsOn.map(i => txFaulty(i)).reduce(_ | _)
    rx := dependsOn.map(i => rxFaulty(i)).reduce(_ | _)
    (tx, rx)
  }.unzip

  // Generate redundancy muxes
  val (txMuxes, rxMuxes) = submodIdxs.map { idx =>
    val txMux = Module(new RedundancyMuxSubmod(idx(1), idx(0), isTx = true))
    core.connectToMux(txMux.a)
    core.connectToMux(txMux.b)
    bumps.connectToMux(txMux.o)
    txMux.shift := txShift(idx(0).linearIdx).asBool

    val rxMux = Module(new RedundancyMuxSubmod(idx(2), idx(3), isTx = false))
    bumps.connectToMux(rxMux.a)
    bumps.connectToMux(rxMux.b)
    core.connectToMux(rxMux.o)
    rxMux.shift := rxShift(idx(0).linearIdx).asBool

    (txMux, rxMux)
  }.unzip

  // First set of Tx bumps must have inputs directly from core
  // 0's as primary input to Tx mux for redundant submods are handled in connectToMux function
  val noMuxTxSubmods = Seq(AIB3DCoordinates[Int](0, 0)) :+ (
    if (params.isWide) AIB3DCoordinates[Int](0, 1)
    else AIB3DCoordinates[Int](1, 0))
  noMuxTxSubmods foreach { idx =>
    // TODO: make a pass-thru connector instead going through a set of wires
    val fromCore = Wire(new SubmodBundle(idx, coreFacing = true))
    val toBumps = Wire(new SubmodBundle(idx, coreFacing = false))
    core.connectToMux(fromCore)
    fromCore.elements.values zip toBumps.elements.values foreach {
      case (c, b) => b := c
    }
    bumps.connectToMux(toBumps)
  }
}

// TODO: logic for coding?