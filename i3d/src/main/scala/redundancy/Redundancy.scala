package aib3d.redundancy

import chisel3._

import chisel3.experimental.DataMirror
import testchipip.{ClockMux2, ClockOr2}

import aib3d._
import aib3d.io._
import chisel3.util.{log2Ceil, Cat, Fill}
import chisel3.util.MuxLookup

/** Redundancy muxes per module*/
class RedundancyMux(
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
  val bumps = IO(new BumpsBundle)  // internal

  // One hot encoding
  val faultyTx, faultyRx = IO(Input(UInt(params.numMods.W)))

  // Shift in the longer dimension
  // Order is (tx.a, tx.b, rx.a, rx.b)
  val modIdxs = if (params.isWide) {
    for (j <- 0 until params.modRows; i <- 0 until params.modCols)
      yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](2*i+k, j))
  } else {
    for (i <- 0 until params.modCols; j <- 0 until params.modRows)
      yield Seq(0, 2, 1, 3).map(k => AIB3DCoordinates[Int](i, 2*j+k))
  }

  // Use these indices to generate the shift signal for each mux
  // Essentially, count the bit positions (by 2) to the right of the current one
  // that contains a 1 in the one-hot encoding of faultyTx and faultyRx
  val (txShift, rxShift) = modIdxs.indices.map { idx =>
    val tx, rx = Wire(Bool())
    val dependsOn = (idx % 2 to idx by 2)
    tx := dependsOn.map(i => faultyTx(i)).reduce(_ | _)
    rx := dependsOn.map(i => faultyRx(i)).reduce(_ | _)
    (tx, rx)
  }.unzip

  // Generate redundancy muxes and set inputs/outputs based on indices
  val (txMuxes, rxMuxes) = modIdxs.map { idx =>
    val txMux = Module(new RedundancyMux(idx(1), idx(0), isTx = true))
    core.connectToModuleBundle(txMux.a)
    core.connectToModuleBundle(txMux.b)
    bumps.connectToModuleBundle(txMux.o)
    txMux.shift := txShift(idx(0).linearIdx).asBool

    val rxMux = Module(new RedundancyMux(idx(2), idx(3), isTx = false))
    bumps.connectToModuleBundle(rxMux.a)
    bumps.connectToModuleBundle(rxMux.b)
    core.connectToModuleBundle(rxMux.o)
    rxMux.shift := rxShift(idx(0).linearIdx).asBool

    (txMux, rxMux)
  }.unzip

  // First set of Tx bumps must have inputs directly from core
  // 0's as primary input to Tx mux for redundant modules are handled in connectToModuleBundle function
  val noMuxTxMods =
    if (params.isWide) (0 until params.modRowsWR).map(i =>
      AIB3DCoordinates[Int](0, i))
    else (0 until params.modColsWR).map(i =>
      AIB3DCoordinates[Int](i, 0))
  noMuxTxMods.foreach { idx =>
    // TODO: make a pass-thru connector instead going through a set of wires
    val fromCore = Wire(new ModuleBundle(idx, coreFacing = true))
    val toBumps = Wire(new ModuleBundle(idx, coreFacing = false))
    core.connectToModuleBundle(fromCore)
    (fromCore.getElements zip toBumps.getElements).foreach {
      case (c, b) => b := c
    }
    bumps.connectToModuleBundle(toBumps)
  }
}

/** Module-level encoder */
class Encoder(val modIdx: AIB3DCoordinates[Int])(implicit params: AIB3DParams) extends RawModule {
  val core = IO(new ModuleBundle(modIdx, coreFacing = true))
  val bumps = IO(new ModuleBundle(modIdx, coreFacing = false))
  val clkOut = IO(Output(Clock()))
  val faulty = IO(Input(Vec(params.sigsPerCluster, UInt(log2Ceil(params.numClusters - 1).W))))
  val faultyClk = IO(Input(Bool()))
  val dbi = IO(Input(Bool()))

  // Process bits into coding groups
  // Need to deal with the last cluster not necessarily having the same number of bits
  val cBits = core.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .map(d => Some(d.asUInt))  // convert to Option
                .padTo(params.numClusters * params.sigsPerCluster, None)  // deal w/ last cluster
                .grouped(params.sigsPerCluster).toSeq  // group by cluster
                .transpose  // to get bits for each encoder
  val bsBits = bumps.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .dropRight(params.sigsPerCluster)  // drop redundant bits
                .map(d => Some(d.asUInt))
                .padTo(params.numClusters * params.sigsPerCluster, None)
                .grouped(params.sigsPerCluster).toSeq
                .transpose
  val brBits = bumps.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .takeRight(params.sigsPerCluster)

  // Signals
  (cBits zip bsBits).zipWithIndex.foreach { case ((cGrp, bGrp), i) =>
    // Invert is a n-input mux controlled by faulty
    // TODO: implement DBI
    val inv = MuxLookup(faulty(i), 0.U,
      (0 until params.numClusters - 1).map(j =>
        j.U -> cGrp(j).getOrElse(0.U(1.W))
    ))
    // XOR bits with inv
    (bGrp zip cGrp).foreach { case (b, c) =>
      if (b.isDefined) b.get := c.get ^ inv
    }
    // Redundant bit is invert
    brBits(i) := inv
  }

  // Clocks
  val cClk = core.getElements.find(
    DataMirror.checkTypeEquivalence(_, Clock())
  ).get.asUInt()(0).asClock
  val bClks = bumps.getElements.filter(
    DataMirror.checkTypeEquivalence(_, Clock())
  )
  clkOut := cClk
  // Implement as clock gate
  // bClks.head := EICG_wrapper(cClk, ~faultyClk)
  // bClks.last := EICG_wrapper(cClk, faultyClk)
  // Simple AND
  bClks.head := (cClk.asBool & ~faultyClk).asClock
  bClks.last := (cClk.asBool & faultyClk).asClock
  /*
  val pClkMux = Module(new ClockMux2)
  pClkMux.io.sel := faultyClk
  pClkMux.io.clocksIn(0) := cClk
  pClkMux.io.clocksIn(1) := false.B.asClock
  bClks.head := pClkMux.io.clockOut
  val rClkMux = Module(new ClockMux2)
  rClkMux.io.sel := faultyClk
  rClkMux.io.clocksIn(0) := false.B.asClock
  rClkMux.io.clocksIn(1) := cClk
  bClks.last := rClkMux.io.clockOut
  */
}

/** Module-level decoder */
class Decoder(val modIdx: AIB3DCoordinates[Int])(implicit params: AIB3DParams) extends RawModule {
  val core = IO(new ModuleBundle(modIdx, coreFacing = true))
  val bumps = IO(new ModuleBundle(modIdx, coreFacing = false))
  val clkOut = IO(Output(Clock()))

  // Process bits into coding groups
  // Need to deal with the last cluster not necessarily having the same number of bits
  val cBits = core.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .map(d => Some(d.asUInt))  // convert to Option
                .padTo(params.numClusters * params.sigsPerCluster, None)  // deal w/ last cluster
                .grouped(params.sigsPerCluster).toSeq  // group by cluster
                .transpose  // to get bits for each encoder
  val bsBits = bumps.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .map(d => Some(d.asUInt))  // convert to Option
                .dropRight(params.sigsPerCluster)  // drop redundant bits
                .padTo(params.numClusters * params.sigsPerCluster, None)
                .grouped(params.sigsPerCluster).toSeq
                .transpose
  val brBits = bumps.getElements
                .filterNot(DataMirror.checkTypeEquivalence(_, Clock()))  // drop clocks
                .takeRight(params.sigsPerCluster)

  // Signals
  (cBits zip bsBits).zipWithIndex.foreach { case ((cGrp, bGrp), i) =>
    // XOR bits with inv
    (bGrp zip cGrp).foreach { case (b, c) =>
      if (b.isDefined) c.get := b.get ^ brBits(i).asUInt
    }
  }

  // Clocks
  val cClk = core.getElements.find(
    DataMirror.checkTypeEquivalence(_, Clock())
  ).get
  val bClks = bumps.getElements.filter(
    DataMirror.checkTypeEquivalence(_, Clock())
  ).map(_.asUInt()(0).asClock)

  // Decoding clock depends on if SA1 faults are to be detected
  val decodedClk = Wire(Clock())

  // Circuit for just SA0 faults:
  val clkOr = Module(new ClockOr2)
  clkOr.io.clocksIn(0) := bClks.head
  clkOr.io.clocksIn(1) := bClks.last
  decodedClk := clkOr.io.clockOut

  // Circuit for SA0 and SA1 faults:
  // TODO: need reset, ClockOr2, ClockAnd2
  // val clkOr = Wire(Clock())
  // val clkAnd = Wire(Clock())
  // clkOr := bClks.head | bClks.last
  // clkAnd := bClks.head & bClks.last
  // val switchReg = withClock(clkAnd)(RegNext(true.B, false.B))
  // val clkMux = Module(new ClockMux2)
  // clkMux.io.sel := switchReg
  // clkMux.io.clocksIn(0) := clkOr
  // clkMux.io.clocksIn(1) := clkAnd
  // decodedClk := clkMux.io.clockOut

  cClk := decodedClk.asTypeOf(cClk)
  clkOut := decodedClk
}

/** Top-level coding redundancy add-on module */
class CodingRedundancyTop(implicit params: AIB3DParams) extends RawModule {
  val core = IO(new CoreBundle)
  val bumps = IO(new BumpsBundle)  // internal
  val clksToTx = IO(Output(Vec(params.numMods, Clock())))
  val clksToRx = IO(Output(Vec(params.numMods, Clock())))
  val faulty = IO(Input(Vec(params.numMods,  // Tx only
    Vec(params.sigsPerCluster, UInt(log2Ceil(params.numClusters - 1).W)))))  // binary-coded
  val faultyClk = IO(Input(UInt(params.numMods.W)))  // Tx only, one-hot
  val dbi = IO(Input(Bool()))

  // Instantiate encoders and decoders
  // Assumes Tx/Rx interleaved
  val modCoords = if (params.isWide)  // col-by-col
    for (c <- 0 until params.modCols; r <- 0 until params.modRows)
      yield (AIB3DCoordinates[Int](2*c, r), AIB3DCoordinates[Int](2*c+1, r))
  else  // row-by-row
    for (r <- 0 until params.modRows; c <- 0 until params.modCols)
      yield (AIB3DCoordinates[Int](c, 2*r), AIB3DCoordinates[Int](c, 2*r+1))
  val encoders = modCoords.map(c => Module(new Encoder(c._1)))
  val decoders = modCoords.map(c => Module(new Decoder(c._2)))

  // Connect encoder inputs
  encoders.zipWithIndex.foreach { case (enc, i) =>
    core.connectToModuleBundle(enc.core)
    bumps.connectToModuleBundle(enc.bumps)
    clksToTx(i) := enc.clkOut
    enc.faulty := faulty(i)
    enc.faultyClk := faultyClk(i)
    enc.dbi := dbi
  }
  // Connect decoder inputs
  decoders.zipWithIndex.foreach { case (dec, i) =>
    core.connectToModuleBundle(dec.core)
    bumps.connectToModuleBundle(dec.bumps)
    clksToRx(i) := dec.clkOut
  }
}