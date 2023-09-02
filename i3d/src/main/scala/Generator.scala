package aib3d

import chisel3._

import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental.hierarchy.{Definition, Instance}
import org.chipsalliance.cde.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem.WithoutTLMonitors
import freechips.rocketchip.tilelink._
import freechips.rocketchip.amba.axi4._

import aib3d._
import aib3d.stage._

/** Connect dummy ClientNode (SourceNode) for diplomacy */
trait AIB3DDummyNode {
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

/** AIB3D Main - do "runMain aib3d.AIB3DGenerator" in sbt */
object AIB3DGenerator extends App with AIB3DDummyNode {
  // Select Config here
  implicit val p = new Config(new AIB3DBaseConfig ++ new WithoutTLMonitors)

  // Uncomment for TL version
  val patch = LazyModule(new TLPatch)
  connectTL(patch.node)

  // Uncomment for AXI4 version
  // val patch = LazyModule(new AXI4Patch)
  // connectAXI4(patch.node)

  // Emit FIRRTL, Verilog, and collateral
  (new AIB3DStage).run(Seq(ChiselGeneratorAnnotation(() => patch.module)))
}

/** For generating raw AIB3D module */
object AIB3DRawGenerator extends App {
  implicit val p = new Config(new AIB3DBaseConfig)

  (new AIB3DStage).run(Seq(ChiselGeneratorAnnotation(() => new RawPatch)))
}