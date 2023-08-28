package aib3d

import chisel3._

import chisel3.experimental.{DataMirror}
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

abstract class Patch(implicit p: Parameters) extends RegisterRouter(
  RegisterRouterParams(
    name = "aib3d-patch",
    compat = Seq("ucbbar,rocketchip"),
    base = p(AIB3DInstKey).baseAddress,
    beatBytes = 8)  // TODO: AVMM is 32-bit
) with HasInterruptSources {

  def nInterrupts = 0

  // Calculate these params only once for speed, pass around implicitly
  implicit val params: AIB3DParams = p(AIB3DKey)
  implicit val glblParams: AIB3DGlblParams = p(AIB3DGlblKey)
  implicit val instParams: AIB3DInstParams = p(AIB3DInstKey)

  lazy val module = new LazyModuleImp(this) {
    // Module name should always be Patch regardless of protocol
    override def desiredName = "Patch"

    // IO
    val coreio = IO(new CoreBundle)
    val bumpio = IO(new BumpsBundle(atBumps = true))

    // Generate IO cells and connect to bumps
    val iocells = (bumpio.sigBumps lazyZip bumpio.elements.values).map {
      (b: AIB3DBump, d: Data) =>
        val iocell = Module(
          if (instParams.blackBoxModels) new IOCellModel(b)
          else new IOCellBB(b))
        iocell.pad <> d
        iocell
    }.toSeq

    // Reset to pull down
    val ioCtrl = RegInit((new IOControlBundle).Lit(
      _.loopback -> false.B,
      _.txWkpu -> false.B,
      _.txWkpd -> true.B,
      _.rxWkpu -> false.B,
      _.rxWkpd -> true.B
    ))

    // Regmap up to this point
    var patchSCRs = Seq(
      // TODO: why does making this writeable cause this error:
      // [error] firrtl.passes.CheckFlows$WrongFlow:  @[RegField.scala 74:92]: [module Patch]
      // Expression _T_1 is used as a SinkFlow but can only be used as a SourceFlow.
      Seq(RegField.r(ioCtrl.asUInt.getWidth, ioCtrl.asUInt,
        RegFieldDesc("ioCtrl", "{loopback, txWkpu, txWkpd, rxWkpu, rxWkpd} - pulls-down when reset.")))
    )

    // Redundancy affects how IO cells are connected
    if (glblParams.redundArch == 2) {
      val redundancy = Module(new RedundancyMuxTop)

      // Connect core side of muxes to coreio
      coreio <> redundancy.core

      // Connect bumps side of muxes to iocells
      (iocells zip redundancy.bumps.elements) foreach { case (i, (bs, bd)) =>
        // Get related clock (all submodules should have a clock)
        val relatedClk = redundancy.bumps.getRelatedClk(bs)
        i.connectInternal(bd, relatedClk, ioCtrl)
      }

      // Faulty control registers
      // TODO: why does .asTypeOf fail to get the width?
      val txFaulty = RegInit(0.U(redundancy.txFaulty.getWidth.W))
      val rxFaulty = RegInit(0.U(redundancy.rxFaulty.getWidth.W))
      redundancy.txFaulty := txFaulty
      redundancy.rxFaulty := rxFaulty
      patchSCRs = patchSCRs ++ Seq(
        Seq(RegField(txFaulty.getWidth, txFaulty,
          RegFieldDesc("txFaulty", "One-hot encoding of faulty submodules (Tx)."))),
        Seq(RegField(rxFaulty.getWidth, rxFaulty,
          RegFieldDesc("rxFaulty", "One-hot encoding of faulty submodules (Rx).")))
      )
    } else {
      // Connect coreio to iocells directly
      coreio.elements zip iocells foreach { case ((cs, cd), i) =>
        // Get related clock (all submodules should have a clock)
        val relatedClk = coreio.getRelatedClk(cs)
        i.connectInternal(cd, relatedClk, ioCtrl)
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

    // CSR memory mapping
    regmap(((0 until patchSCRs.size).map(_ * beatBytes) zip patchSCRs):_*)

    // Documentation/collateral
    ElaborationArtefacts.add(s"bumpmap.json", GenCollateral.toJSON(iocells))
    ElaborationArtefacts.add(s"hammer.json", GenCollateral.toHammerJSON(iocells))
    ElaborationArtefacts.add(s"bumpmap.csv", GenCollateral.toCSV)
    GenCollateral.toImg
  }
}

/** Patch with TileLink interconnect to CSRs */
class TLPatch(implicit p: Parameters) extends Patch with HasTLControlRegMap
/** Patch with AXI4 interconnect to CSRs */
class AXI4Patch(implicit p: Parameters) extends Patch with HasAXI4ControlRegMap