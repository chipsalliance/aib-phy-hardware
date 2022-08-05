package aib3d

import chisel3._

import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}
import freechips.rocketchip.diplomacy.LazyModule

import freechips.rocketchip.examples._

object AIB3DGenerator extends App {
  (new ChiselStage).emitVerilog(LazyModule(new PatchTL()(new AIB3DBaseConfig)).module)
  // (new ChiselStage).emitVerilog(LazyModule(new TLExampleDevice(ExampleDeviceParams(1, 0))(new AIB3DBaseConfig)).module)
}