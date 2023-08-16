package aib3d

import chisel3._

import chisel3.experimental.DataMirror
import chisel3.experimental.BundleLiterals._
import freechips.rocketchip.config.Parameters
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
import aib3d.stage._
import freechips.rocketchip.tilelink.TLMessages

abstract class Patch(implicit p: Parameters) extends RegisterRouter(
  RegisterRouterParams(
    name = "aib3d-patch",
    compat = Seq("ucbbar,rocketchip"),
    base = p(AIB3DInstKey).baseAddress,
    beatBytes = 8)  // TODO: AVMM is 32-bit
) with HasInterruptSources {

  def nInterrupts = 0

  lazy val module = new LazyModuleImp(this) {
    // Module name should always be Patch regardless of protocol
    override def desiredName = "Patch"

    // IO
    val coreio = IO(new CoreBundle)
    val bumpio = IO(new BumpsBundle(atBumps = true))

    // Generate IO cells and connect to bumps
    val iocells = (0 until bumpio.elements.size).map { i =>
      if (p(AIB3DInstKey).blackBoxModels) Module(new IOCellModel(i)).io
      else Module(new IOCellBB(i)).io
    }
    iocells zip bumpio.elements foreach { case (c, (_, b)) => c.pad <> b }
    // Reset to pull down
    val ioCtrl = RegInit((new IOControlBundle).Lit(
      _.loopback -> false.B,
      _.tx_wkpu -> false.B,
      _.tx_wkpd -> true.B,
      _.rx_wkpu -> false.B,
      _.rx_wkpd -> true.B
    ))

    // Regmap up to this point
    var patchSCRs = Seq(
      // TODO: why does making this writeable cause this error:
      // [error] firrtl.passes.CheckFlows$WrongFlow:  @[RegField.scala 74:92]: [module Patch]
      // Expression _T_1 is used as a SinkFlow but can only be used as a SourceFlow.
      Seq(RegField.r(ioCtrl.asUInt.getWidth, ioCtrl.asUInt,
        RegFieldDesc("ioCtrl", "{loopback, tx_wkpu, tx_wkpd, rx_wkpu, rx_wkpd} - pulls-down when reset.")))
    )

    // Redundancy affects how IO cells are connected
    if (p(AIB3DGlblKey).redundArch == 2) {
      val redundancy = Module(new RedundancyMuxTop)

      // Connect core side of muxes to coreio
      coreio.elements zip redundancy.core.elements foreach { case ((_, c), (_, r)) => c <> r }

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
      // Connect coreio to iocells
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

    // Documentation/collateral + annotations
    val thisMod = Module.currentModule.get.asInstanceOf[RawModule]
    // Bump map
    val flatBumpMap = p(AIB3DKey).flatBumpMap
    ElaborationArtefacts.add(s"bumpmap.json", GenBumpMapAnno.toJSON(flatBumpMap))
    ElaborationArtefacts.add(s"bumpmap.csv", GenBumpMapAnno.toCSV(flatBumpMap))
    GenBumpMapAnno.anno(thisMod, flatBumpMap)
    // TODO: constraints
  }
}

/** Patch with TileLink interconnect to CSRs */
class TLPatch(implicit p: Parameters) extends Patch with HasTLControlRegMap
/** Patch with AXI4 interconnect to CSRs */
class AXI4Patch(implicit p: Parameters) extends Patch with HasAXI4ControlRegMap