package aib3d

import chisel3._

import chisel3.experimental.{DataMirror, AutoCloneType, FlatIO}
import chisel3.experimental.BundleLiterals._
import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.diplomacy.LazyModuleImp
import freechips.rocketchip.interrupts.HasInterruptSources
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink.HasTLControlRegMap
import freechips.rocketchip.amba.axi4.HasAXI4ControlRegMap
import freechips.rocketchip.util.{ResetCatchAndSync, ElaborationArtefacts}
import freechips.rocketchip.jtag._

// import aib3d.deskew._
import aib3d.io._
import aib3d.redundancy._

trait BasePatch {
  implicit val p: Parameters
  // Calculate these params only once for speed, pass around implicitly
  implicit val params: AIB3DParams = p(AIB3DKey)
  implicit val glblParams: AIB3DGlblParams = p(AIB3DGlblKey)
  implicit val instParams: AIB3DInstParams = p(AIB3DInstKey)

  // IO
  val coreio = Wire(new CoreBundle)
  val dataio = FlatIO(Flipped(glblParams.dataBundle.cloneType))  // no prefix
  val clocks = IO(coreio.clksRecord)  // prefix, since these are manually connected
  val bumpio = FlatIO(new BumpsBundle(atBumps = true))  // no prefix

  // Connect coreio wires to dataio and clocks
  // TODO: With Chisel 3.6+, should be able to use :<>= and waiveAll
  clocks.elements.foreach{ case (n, d) => d <> coreio.elements(n) }
  coreio.connectDataBundle(dataio)

  // Generate IO cells and connect to bumps
  val iocells =
    (bumpio.sigBumps lazyZip bumpio.getElements).map{ (b: AIB3DBump, d: Data) =>
      val iocell = Module(
        if (instParams.blackBoxModels) new IOCellModel(b)
        else new IOCellBB(b))
      iocell.io.pad <> d
      iocell
    }.toSeq
  val ioCtrlWire = Wire(new IOControlBundle)

  // Redundancy affects how IO cells are connected
  val red = glblParams.redundArch == 2
  val redundancy = if (red) Some(Module(new RedundancyMuxTop)) else None
  val txFaultyWire = if (red) Some(Wire(UInt(redundancy.get.txFaulty.getWidth.W))) else None
  val rxFaultyWire = if (red) Some(Wire(UInt(redundancy.get.rxFaulty.getWidth.W))) else None
  if (red) {
    // Connect core side of muxes to coreio
    coreio <> redundancy.get.core
    // Connect bumps side of muxes to iocells
    (iocells zip redundancy.get.bumps.elements) foreach { case (i, (bs, bd)) =>
      // Get related clock (all submodules should have a clock)
      val relatedClk = redundancy.get.bumps.getRelatedClk(bs)
      i.connectInternal(bd, relatedClk, ioCtrlWire)
    }
    redundancy.get.txFaulty := txFaultyWire.get
    redundancy.get.rxFaulty := rxFaultyWire.get
  } else {
    // Connect coreio to iocells directly
    coreio.elements zip iocells foreach { case ((cs, cd), i) =>
      // Get related clock (all submodules should have a clock)
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
  ElaborationArtefacts.add(s"bumpmap.json", GenCollateral.toJSON(iocells))
  ElaborationArtefacts.add(s"hammer.json", GenCollateral.toHammerJSON(iocells))
  ElaborationArtefacts.add(s"bumpmap.csv", GenCollateral.toCSV)
  GenCollateral.toImg
}

class RawPatch(implicit val p: Parameters) extends RawModule with BasePatch {
  override def desiredName = "Patch"

  val ioCtrl = FlatIO(Input(new IOControlBundle))
  ioCtrlWire := ioCtrl

  if (red) {
    val txFaulty = IO(Input(redundancy.get.txFaulty.cloneType))
    val rxFaulty = IO(Input(redundancy.get.rxFaulty.cloneType))
    txFaultyWire.get := txFaulty
    rxFaultyWire.get := rxFaulty
  }
}

abstract class RegsPatch(implicit p: Parameters) extends RegisterRouter(
  RegisterRouterParams(
    name = "aib3d-patch",
    compat = Seq("ucbbar,rocketchip"),
    base = p(AIB3DInstKey).baseAddress,
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

    // Redundancy affects how IO cells are connected
    if (red) {
      // Faulty control registers
      val txFaulty = RegInit(0.U(txFaultyWire.get.getWidth.W))
      val rxFaulty = RegInit(0.U(rxFaultyWire.get.getWidth.W))
      txFaultyWire.get := txFaulty
      rxFaultyWire.get := rxFaulty
      patchSCRs = patchSCRs ++ Seq(
        Seq(RegField(txFaulty.getWidth, txFaulty,
          RegFieldDesc("txFaulty", "One-hot encoding of faulty submodules (Tx)."))),
        Seq(RegField(rxFaulty.getWidth, rxFaulty,
          RegFieldDesc("rxFaulty", "One-hot encoding of faulty submodules (Rx).")))
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