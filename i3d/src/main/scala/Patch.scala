package aib3d

import chisel3._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy.LazyModuleImp
import freechips.rocketchip.interrupts.HasInterruptSources
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink.HasTLControlRegMap
import freechips.rocketchip.amba.axi4.HasAXI4ControlRegMap
import freechips.rocketchip.util.{ResetCatchAndSync, ElaborationArtefacts}
import freechips.rocketchip.jtag._

import aib3d.adapter._
import aib3d.deskew._
import aib3d.io._
import aib3d.redundancy._
import aib3d.stage._

abstract class Patch(implicit p: Parameters) extends RegisterRouter(
  RegisterRouterParams(
    name = "aib3d-patch",
    compat = Seq("ucbbar,rocketchip"),
    base = p(AIB3DKey).baseAddress,
    beatBytes = 8)  // TODO: AVMM is 32-bit
) with HasInterruptSources {

  def nInterrupts = 0

  lazy val module = new LazyModuleImp(this) {
    // Module name should always be Patch regardless of protocol
    override def desiredName = "Patch"

    // Clocks and reset (implicit ones for CSRs)
    val m_ns_fwd_clk = IO(Input(Clock()))   // Near-side input for transmitting to far-side
    val m_fs_fwd_clk = IO(Output(Clock()))  // Near-side output received from far-side (deskewed)
    val ns_adapter_rstn = IO(Input(Bool())) // Near-side adapter reset (must be on m_ns_fwd_clk domain)

    val bumpio = IO(new BumpsBundle)
    val macio = IO(new MacBundle)
    val appio = IO(new AppBundle)

    // Adapter + CSRs
    val adapter = withClockAndReset(m_ns_fwd_clk, !ns_adapter_rstn)(Module(new Adapter))
    adapter.app <> appio  // pass-thru
    adapter.mac <> macio  // pass-thru
    val io_ctrl = RegInit(5.U(4.W))
    adapter.io_ctrl := io_ctrl
    val redund = RegInit(p(AIB3DKey).sparesIdx.head.U(adapter.redund.getWidth.W))
    adapter.redund := redund

    // Redundancy
    val redundancy = Module(new RedundancyTop)
    adapter.redundancy <> redundancy.adapter  // I/Os
    adapter.redundancy_cfg <> redundancy.cfg  // config
    val fs_fwd_clk = redundancy.adapter("fs_fwd_clkb").asTypeOf(Clock())  // 180 deg. sampling
    
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

    // IO cells
    val iocells = (0 until p(AIB3DKey).patchSize).map{ i =>
      if (p(AIB3DKey).blackBoxModels) { Module(new IOCellModel(i)).io }
      else { Module(new IOCellBB(i)).io }
    }
    iocells.foreach{ c =>
      c.tx_clk := m_ns_fwd_clk
      c.rx_clk := dll.clk_out
    }
    // redundancy <> iocells <> bumps (all signals)
    (iocells zip redundancy.to_pad).foreach{ case(c, r) => c.attachTx(r) }
    (iocells zip redundancy.from_pad).foreach{ case(c, r) => c.attachRx(r) }
    (iocells zip bumpio.elements).foreach{ case(c, (_, b)) => c.pad <> b }

    // CSR memory mapping
    regmap(
      0x00 -> Seq(RegField(io_ctrl.getWidth, io_ctrl,
        RegFieldDesc("io_ctrl", "{tx_wkpu, tx_wkpd, rx_wkpu, rx_wkpd} - pulls-down when reset."))),
      0x08 -> Seq(RegField(redund.getWidth, redund,
        RegFieldDesc("redund", "Denotes which ubump is faulty (0-indexed). Set to 1st spare for no shift when reset.")))
    )

    // Documentation/collateral + annotations
    val thisMod = Module.currentModule.get.asInstanceOf[RawModule]
    // Bump map
    ElaborationArtefacts.add(s"bumpmap.json", GenBumpMapAnno.toJSON(p(AIB3DKey).padsIoTypes))
    ElaborationArtefacts.add(s"bumpmap.csv", GenBumpMapAnno.toCSV(p(AIB3DKey).padsIoTypes))
    GenBumpMapAnno.anno(thisMod, p(AIB3DKey).padsIoTypes)
    // TODO: constraints
  }
}

/** Patch with TileLink interconnect to CSRs */
class TLPatch(implicit p: Parameters) extends Patch with HasTLControlRegMap 
/** Patch with AXI4 interconnect to CSRs */
class AXI4Patch(implicit p: Parameters) extends Patch with HasAXI4ControlRegMap