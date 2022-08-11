package aib3d.stage

import firrtl.AnnotationSeq
import firrtl.options.{Phase, Dependency}
import freechips.rocketchip.util.{ElaborationArtefacts, HasRocketChipStageUtils}

/** Adapted from rocket-chip's GenerateArtefacts Phase w/o targetDir annotation requirement */
class GenerateArtefacts extends Phase with HasRocketChipStageUtils {

  override val prerequisites = Seq(Dependency[chisel3.stage.phases.Elaborate])  // LazyModuleImp must be resolved

  override def transform(annotations: AnnotationSeq): AnnotationSeq = {
    val targetDir = "."

    ElaborationArtefacts.files.foreach { case (extension, contents) =>
      writeOutputFile(targetDir, s"Patch.${extension}", contents ())
    }

    annotations
  }

}