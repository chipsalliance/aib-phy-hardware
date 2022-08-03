package aib3d

import chisel3._

import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}

object AIB3DGenerator extends App {
  (new ChiselStage).emitVerilog(new Patch()(new AIB3DBaseConfig))
}