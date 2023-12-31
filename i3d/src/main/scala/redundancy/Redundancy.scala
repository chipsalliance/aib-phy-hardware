package aib3d.redundancy

import chisel3._

import chisel3.experimental.DataMirror
import testchipip.ClockMux2

import aib3d._
import aib3d.io._

/** Redundancy muxes per module*/
class RedundancyMuxMod(
  modIdxA: AIB3DCoordinates[Int],
  modIdxB: AIB3DCoordinates[Int],
  isTx: Boolean = true)(implicit params: AIB3DParams) extends RawModule {

  // Note difference in module indices for Tx vs. Rx
  val (a, b, o) = (
    IO(new ModuleBundle(modIdxA, coreFacing = isTx)),
    IO(new ModuleBundle(modIdxB, coreFacing = isTx)),
    IO(new ModuleBundle(modIdxA, coreFacing = !isTx)))

  // TODO: Output false path annotation for shift input
  val shift = IO(Input(Bool()))

  (a.getElements zip b.getElements zip o.getElements).foreach {
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
class RedundancyMuxTop(implicit params: AIB3DParams) extends RawModule {
  val core = IO(new CoreBundle)
  val bumps = IO(new BumpsBundle(atBumps = false))  // internal

  // One hot encoding
  val txFaulty, rxFaulty = IO(Input(UInt(params.numMods.W)))

  // Shift in the longer dimension
  // Order is (tx.a, tx.b, rx.a, rx.b)
  val modIdxs = if (params.isWide) {
    for {
      j <- 0 until params.modRowsWR
      i <- 0 until params.modColsWR - 2 by 2
    } yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](i+k, j))
  } else {
    for {
      i <- 0 until params.modColsWR
      j <- 0 until params.modRowsWR - 2 by 2
    } yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](i, j+k))
  }

  // Use these indices to generate the shift signal for each mux
  // Essentially, count the bit positions (by 2) to the right of the current one
  // that contains a 1 in the one-hot encoding of txFaulty and rxFaulty
  val (txShift, rxShift) = modIdxs.indices.map { idx =>
    val tx, rx = Wire(Bool())
    val dependsOn = (idx % 2 to idx by 2)
    tx := dependsOn.map(i => txFaulty(i)).reduce(_ | _)
    rx := dependsOn.map(i => rxFaulty(i)).reduce(_ | _)
    (tx, rx)
  }.unzip

  // Generate redundancy muxes and set inputs/outputs based on indices
  val (txMuxes, rxMuxes) = modIdxs.map { idx =>
    val txMux = Module(new RedundancyMuxMod(idx(1), idx(0), isTx = true))
    core.connectToMux(txMux.a)
    core.connectToMux(txMux.b)
    bumps.connectToMux(txMux.o)
    txMux.shift := txShift(idx(0).linearIdx).asBool

    val rxMux = Module(new RedundancyMuxMod(idx(2), idx(3), isTx = false))
    bumps.connectToMux(rxMux.a)
    bumps.connectToMux(rxMux.b)
    core.connectToMux(rxMux.o)
    rxMux.shift := rxShift(idx(0).linearIdx).asBool

    (txMux, rxMux)
  }.unzip

  // First set of Tx bumps must have inputs directly from core
  // 0's as primary input to Tx mux for redundant modules are handled in connectToMux function
  val noMuxTxMods =
    if (params.isWide) (0 until params.modRowsWR).map(i =>
      AIB3DCoordinates[Int](0, i))
    else (0 until params.modColsWR).map(i =>
      AIB3DCoordinates[Int](i, 0))
  noMuxTxMods.foreach { idx =>
    // TODO: make a pass-thru connector instead going through a set of wires
    val fromCore = Wire(new ModuleBundle(idx, coreFacing = true))
    val toBumps = Wire(new ModuleBundle(idx, coreFacing = false))
    core.connectToMux(fromCore)
    (fromCore.getElements zip toBumps.getElements).foreach {
      case (c, b) => b := c
    }
    bumps.connectToMux(toBumps)
  }
}

// TODO: logic for coding?
/** Unit encoding module */
/*
class Encoder(implicit params: AIB3DParams) extends RawModule {
  val in = IO(Input(UInt((params.numClusters - 1).W)))
  val out = IO(Output(UInt(params.numClusters.W)))
}

class Decoder(implicit params: AIB3DParams) extends RawModule {
  val in = IO(Input(UInt(params.numClusters.W)))
  val out = IO(Output(UInt((params.numClusters - 1).W)))
}
*/
