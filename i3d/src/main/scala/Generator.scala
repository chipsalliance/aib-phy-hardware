package i3d

import chisel3._

import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental.hierarchy.{Definition, Instance}
import org.chipsalliance.cde.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem.WithoutTLMonitors
import freechips.rocketchip.tilelink._
import freechips.rocketchip.amba.axi4._

import i3d._
import i3d.stage._

/** Connect dummy ClientNode (SourceNode) for diplomacy */
trait I3DDummyNode {
  implicit val p: Parameters
  val dummyNode = TLClientNode(Seq(TLMasterPortParameters.v2(Seq(TLMasterParameters.v2(name = "dummy")))))
  def connectTL(node: TLInwardNode) =
    node := dummyNode
  def connectAXI4(node: AXI4InwardNode) =
    node :=
    AXI4UserYanker() :=
    AXI4Deinterleaver(64) :=
    TLToAXI4() :=
    dummyNode
}

/** I3D Main - do "runMain i3d.I3DGenerator" in sbt */
object I3DGenerator extends App with I3DDummyNode {
  // Select Config here
  implicit val p = new Config(new I3DCoding5Config ++ new WithoutTLMonitors)

  // Uncomment for TL version
  val patch = LazyModule(new TLPatch)
  connectTL(patch.node)

  // Uncomment for AXI4 version
  // val patch = LazyModule(new AXI4Patch)
  // connectAXI4(patch.node)

  // Emit FIRRTL, Verilog, and collateral
  (new I3DStage).run(Seq(ChiselGeneratorAnnotation(() => patch.module)))
}

/** For generating raw I3D module */
object I3DRawGenerator extends App {
  implicit val p = new Config(new I3DBaseConfig)

  (new I3DStage).run(Seq(ChiselGeneratorAnnotation(() => new RawPatch)))
}