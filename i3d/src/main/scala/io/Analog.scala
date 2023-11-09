package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, attach, IntParam}
import chisel3.util.HasBlackBoxResource

class AnalogToUInt(w: Int = 1) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource {
  val io = IO(new Bundle {
    val in = Analog(w.W)
    val out = Output(UInt(w.W))
  })
  addResource("/Analog.v")
}

object AnalogToUInt {
  def apply(in: Analog, out: UInt): Unit = {
    val in2out = Module(new AnalogToUInt(w = in.getWidth))
    attach(in, in2out.io.in)
    out := in2out.io.out
  }
}

class UIntToAnalog(w: Int = 1) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource {
  val io = IO(new Bundle {
    val in = Input(UInt(w.W))
    val out = Analog(w.W)
    val en = Input(Bool())
  })
  addResource("/Analog.v")
}

object UIntToAnalog {
  def apply(in: UInt, out: Analog, en: Bool): Unit = {
    val in2out = Module(new UIntToAnalog(w = in.getWidth))
    attach(out, in2out.io.out)
    in2out.io.in := in
    in2out.io.en := en
  }
}

// Workaround for libraries that have no tristate cells
class AnalogUIntBidir(w: Int = 1) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource {
  val io = IO(new Bundle {
    val ana = Analog(1.W)
    val in = Input(UInt(w.W))
    val out = Output(UInt(w.W))
    val in_en = Input(Bool())
    val out_en = Input(Bool())
  })
  addResource("/Analog.v")
}

object AnalogUIntBidir {
  def apply(ana: Analog, in: UInt, out: UInt, in_en: Bool, out_en: Bool): Unit = {
    val bidir = Module(new AnalogUIntBidir(w = in.getWidth))
    attach(ana, bidir.io.ana)
    bidir.io.in := in
    out := bidir.io.out
    bidir.io.in_en := in_en
    bidir.io.out_en := out_en
  }
}