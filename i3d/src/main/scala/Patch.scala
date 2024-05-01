package i3d

import chisel3._

import chisel3.experimental.{DataMirror, AutoCloneType, FlatIO}
import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.diplomacy.LazyModuleImp
import freechips.rocketchip.interrupts.HasInterruptSources
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink.HasTLControlRegMap
import freechips.rocketchip.amba.axi4.HasAXI4ControlRegMap
import freechips.rocketchip.util.{ResetCatchAndSync, ElaborationArtefacts}

// import i3d.deskew._
import i3d.io._
import i3d.redundancy._
import chisel3.util.log2Ceil

trait BasePatch {
  implicit val p: Parameters
  // Calculate these params only once for speed, pass around implicitly
  implicit val params: I3DParams = p(I3DKey)
  implicit val glblParams: I3DGlblParams = p(I3DGlblKey)
  implicit val instParams: I3DInstParams = p(I3DInstKey)

  // IO
  val coreio = Wire(new CoreBundle)
  val dataio = FlatIO(Flipped(glblParams.dataBundle.cloneType))  // no prefix
  val clocks = IO(coreio.clksRecord)  // prefix, since these are manually connected
  val bumpio = FlatIO(new BumpsBundle)  // no prefix

  // Connect coreio wires to dataio and clocks
  // TODO: With Chisel 3.6+, should be able to use :<>= and waiveAll
  clocks.elements.foreach{ case (n, d) => d <> coreio.elements(n) }
  coreio.connectDataBundle(dataio)

  // Generate IO cells and connect to bumps
  val iocells =
    (bumpio.sigBumps lazyZip bumpio.getElements).map{ (b: I3DBump, d: Data) =>
      val iocell = Module(
        if (instParams.blackBoxModels) { b match {
          case _:TxClk => new TxClkIOCellModel(b)
          case _:TxSig => new TxSigIOCellModel(b)
          case _:RxClk => new RxClkIOCellModel(b)
          case _:RxSig => new RxSigIOCellModel(b)
          case _ => throw new Exception("Should not get here")
        }}
        else new IOCellBB(b))
      iocell.connectExternal(d)
      iocell
    }.toSeq
  val ioCtrlWire = Wire(new IOControlBundle)

  // Coding redundancy option
  val codeRed = params.redArch == RedundancyArch.Coding
  val coding = if (codeRed) Some(Module(new CodingRedundancyTop)) else None
  val faultyWire = if (codeRed) Some(Wire(chiselTypeOf(coding.get.faulty))) else None
  val faultyClkWire = if (codeRed) Some(Wire(UInt(coding.get.faultyClk.getWidth.W))) else None
  val dbiWire = if (codeRed && glblParams.hasDBI) Some(Wire(Bool())) else None

  // Shift (mux) redundancy option
  val shiftRed = params.redArch == RedundancyArch.Shifting
  val shifting = if (shiftRed) Some(Module(new ShiftingRedundancyTop)) else None
  val faultyTxWire =
    if (shiftRed) Some(Wire(UInt(shifting.get.faultyTx.getWidth.W))) else None
  val faultyRxWire =
    if (shiftRed) Some(Wire(UInt(shifting.get.faultyRx.getWidth.W))) else None

  // Redundancy affects how IO cells are connected
  if (codeRed) {
    // Connect coreio to coding
    coreio <> coding.get.core
    // Connect iocells to coding
    (iocells zip coding.get.bumps.sigBumps zip coding.get.bumps.getElements) foreach {
      case ((i, sb), bd) =>
        // Get related clock (all modules should have a clock)
        val relatedTxClk = coding.get.clksToTx(sb.modCoord.linearIdx)
        val relatedRxClk = coding.get.clksToRx(sb.modCoord.linearIdx)
        if (DataMirror.directionOf(bd) == ActualDirection.Output)  // Tx
          i.connectInternal(bd, relatedTxClk, ioCtrlWire)
        else  // Rx
          i.connectInternal(bd, relatedRxClk, ioCtrlWire)
    }
    //(iocells zip coding.get.bumps.elements) foreach { case (i, (bs, bd)) =>
    //  // Get related clock (all modules should have a clock)
    //  val relatedClk = coding.get.bumps.getRelatedClk(bs)
    //  i.connectInternal(bd, relatedClk, ioCtrlWire)
    //}
    // Connect redundancy control signals
    coding.get.faulty := faultyWire.get
    coding.get.faultyClk := faultyClkWire.get
    coding.get.dbi := dbiWire.getOrElse(false.B)
  } else if (shiftRed) {
    // Connect core side of muxes to coreio
    coreio <> shifting.get.core
    // Connect iocells to shifting
    (iocells zip shifting.get.bumps.sigBumps zip shifting.get.bumps.getElements) foreach {
      case ((i, sb), bd) =>
        // Get related clock (all modules should have a clock)
        val relatedTxClk = shifting.get.clksToTx(sb.modCoord.linearIdx)
        val relatedRxClk = shifting.get.clksToRx(sb.modCoord.linearIdx)
        if (DataMirror.directionOf(bd) == ActualDirection.Output)  // Tx
          i.connectInternal(bd, relatedTxClk, ioCtrlWire)
        else  // Rx
          i.connectInternal(bd, relatedRxClk, ioCtrlWire)
    }
    // Connect bumps side of muxes to iocells
    //(iocells zip shifting.get.bumps.elements) foreach { case (i, (bs, bd)) =>
    //  // Get related clock (all modules should have a clock)
    //  val relatedClk = shifting.get.bumps.getRelatedClk(bs)
    //  i.connectInternal(bd, relatedClk, ioCtrlWire)
    //}
    // Connect redundancy control signals
    shifting.get.faultyTx := faultyTxWire.get
    shifting.get.faultyRx := faultyRxWire.get
  } else {
    // Connect coreio to iocells directly
    coreio.elements zip iocells foreach { case ((cs, cd), i) =>
      // Get related clock (all modules should have a clock)
      val relatedClk = coreio.getRelatedClk(cs)
      i.connectInternal(cd, relatedClk, ioCtrlWire)
    }
  }

  /*
  // DLL
  // implicit clock is received clock
  // implicit reset is sync'd to its ref clk (?)
  val deskewRst = ResetCatchAndSync(fs_fwd_clk, !ns_adapter_rstn, 2)
  val dll = withClockAndReset(fs_fwd_clk, deskewRst)(Module(new DLL))
  dll.clk_loop := dll.clk_out  // thru clock tree
  adapter.m_fs_fwd_clk := dll.clk_out
  m_fs_fwd_clk := dll.clk_out
  // deskew <> adapter
  dll.ctrl <> adapter.deskewCtrl
  */

  // Documentation/collateral
  val collat = new GenCollateral(iocells)
  collat.genAll()
}

class RawPatch(implicit val p: Parameters) extends RawModule with BasePatch {
  override def desiredName = "Patch"

  val ioCtrl = IO(Input(new IOControlBundle))
  ioCtrlWire := ioCtrl

  if (codeRed) {
    val faulty = IO(Input(chiselTypeOf(coding.get.faulty)))
    val faultyClk = IO(Input(chiselTypeOf(coding.get.faultyClk)))
    faultyWire.get := faulty
    faultyClkWire.get := faultyClk
    if (glblParams.hasDBI) {
      val dbi = IO(Input(chiselTypeOf(coding.get.dbi)))
      dbiWire.get := dbi
    }
  }
  if (shiftRed) {
    val faultyTx = IO(Input(chiselTypeOf(shifting.get.faultyTx)))
    val faultyRx = IO(Input(chiselTypeOf(shifting.get.faultyRx)))
    faultyTxWire.get := faultyTx
    faultyRxWire.get := faultyRx
  }
}

abstract class RegsPatch(implicit p: Parameters) extends RegisterRouter(
  RegisterRouterParams(
    name = "i3d-patch",
    compat = Seq("ucbbar,rocketchip"),
    base = p(I3DInstKey).baseAddress,
    beatBytes = 8)  // TODO: AVMM is 32-bit
) with HasInterruptSources {

  def nInterrupts = 0

  lazy val module = new LazyModuleImp(this) with BasePatch {
    // Module name should always be Patch regardless of protocol
    override def desiredName = "Patch"

    // Reset to pull down
    val ioCtrl = RegInit(ioCtrlWire.init)
    ioCtrlWire := ioCtrl.asTypeOf(ioCtrlWire)

    // Regmap up to this point
    var patchSCRs = Seq(
      Seq(RegField(ioCtrl.getWidth, ioCtrl,
        RegFieldDesc("ioCtrl", "{loopback, txWkpu, txWkpd, rxWkpu, rxWkpd} - pulls-down when reset.")))
    )

    if (codeRed) {
      // TODO: figure out how to init these to 0
      val faulty = Reg(chiselTypeOf(faultyWire.get))
      val faultyClk = Reg(chiselTypeOf(faultyClkWire.get))
      faultyWire.get := faulty
      faultyClkWire.get := faultyClk
      patchSCRs = patchSCRs ++
        faulty.zipWithIndex.flatMap{ case (fm, mi) =>
          fm.zipWithIndex.map{ case (fc, ci) =>
            Seq(RegField(fc.getWidth, fc,
              RegFieldDesc(s"faulty_${mi}_${ci}", s"Faulty bits for module $mi, cluster $ci.")))
          }
        }.toSeq :+
          Seq(RegField(faultyClk.getWidth, faultyClk,
            RegFieldDesc("faultyClk", "Faulty Tx clock (one-hot module encoded).")))
      if (glblParams.hasDBI) {
        val dbi = RegInit(false.B)
        dbiWire.get := dbi
        patchSCRs = patchSCRs :+
          Seq(RegField(1, dbi,
            RegFieldDesc("dbi", "DBI enable.")))
      }
    }
    if (shiftRed) {
      // Faulty control registers
      val faultyTx = RegInit(0.U(faultyTxWire.get.getWidth.W))
      val faultyRx = RegInit(0.U(faultyRxWire.get.getWidth.W))
      faultyTxWire.get := faultyTx
      faultyRxWire.get := faultyRx
      patchSCRs = patchSCRs ++ Seq(
        Seq(RegField(faultyTx.getWidth, faultyTx,
          RegFieldDesc("faultyTx", "One-hot encoding of faulty submodules (Tx)."))),
        Seq(RegField(faultyRx.getWidth, faultyRx,
          RegFieldDesc("faultyRx", "One-hot encoding of faulty submodules (Rx).")))
      )
    }

    // CSR memory mapping
    regmap(((0 until patchSCRs.size).map(_ * beatBytes) zip patchSCRs):_*)
  }
}

/** Patch with TileLink interconnect to CSRs */
class TLPatch(implicit p: Parameters) extends RegsPatch with HasTLControlRegMap
/** Patch with AXI4 interconnect to CSRs */
class AXI4Patch(implicit p: Parameters) extends RegsPatch with HasAXI4ControlRegMap