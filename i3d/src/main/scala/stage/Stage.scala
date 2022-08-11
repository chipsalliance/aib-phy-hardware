package aib3d.stage

import chisel3.stage.ChiselStage
import firrtl.options.Dependency
import firrtl.options.PhaseManager.PhaseDependency

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