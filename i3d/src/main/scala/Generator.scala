package aib3d

import chisel3._

import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}
import firrtl.{AnnotationSeq, EmittedVerilogCircuitAnnotation, EmittedVerilogModuleAnnotation, VerilogEmitter}
import firrtl.options.{Phase, PhaseManager, Dependency, Shell, Stage, StageOptions}
import firrtl.options.PhaseManager.PhaseDependency
import firrtl.stage.RunFirrtlTransformAnnotation
import freechips.rocketchip.util.{ElaborationArtefacts, HasRocketChipStageUtils}
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.amba.axi4._

/** Adapted from rocket-chip's GenerateArtefacts Phase w/o targetDir annotation requirement */
class GenerateArtefacts extends Phase with HasRocketChipStageUtils {

  override val prerequisites = Seq(Dependency[chisel3.stage.phases.Elaborate])  // LazyModuleImp must be resolved

  override def transform(annotations: AnnotationSeq): AnnotationSeq = {
    val targetDir = "."

    ElaborationArtefacts.files.foreach { case (extension, contents) =>
      writeOutputFile(targetDir, s"TLPatch.${extension}", contents ())
    }

    annotations
  }

}

/** Custom Stage with extra Phases */
class AIB3DStage extends ChiselStage {
  override val targets: Seq[PhaseDependency] = Seq(
    Dependency[chisel3.stage.phases.Checks],
    Dependency[chisel3.stage.phases.Elaborate],
    Dependency[chisel3.stage.phases.AddImplicitOutputFile],
    Dependency[chisel3.stage.phases.AddImplicitOutputAnnotationFile],
    Dependency[chisel3.stage.phases.MaybeAspectPhase],
    Dependency[chisel3.stage.phases.Emitter],
    Dependency[chisel3.stage.phases.Convert],
    Dependency[chisel3.stage.phases.MaybeFirrtlStage],
    Dependency[firrtl.stage.phases.Compiler],
    Dependency[GenerateArtefacts]
  )
}

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
  implicit val p = new AIB3DBaseConfig

  // Uncomment for TL version
  val patch = LazyModule(new TLPatch)
  connectTL(patch.node)

  // Uncomment for AXI4 version
  // val patch = LazyModule(new AXI4Patch)
  // connectAXI4(patch.node)

  // Emit FIRRTL, Verilog, and collateral
  (new AIB3DStage).run(Seq(ChiselGeneratorAnnotation(() => patch.module)))
}