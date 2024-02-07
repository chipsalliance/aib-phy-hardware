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

// Map to tristate buffer
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

// Map to tristate inverter
class UIntToAnalogInvert(w: Int = 1) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource {
  val io = IO(new Bundle {
    val in = Input(UInt(w.W))
    val out = Analog(w.W)
    val en = Input(Bool())
  })
  addResource("/Analog.v")
}

object UIntToAnalogInvert {
  def apply(in: UInt, out: Analog, en: Bool): Unit = {
    val in2out = Module(new UIntToAnalogInvert(w = in.getWidth))
    attach(out, in2out.io.out)
    in2out.io.in := in
    in2out.io.en := en
  }
}

// Workaround for libraries that have no tristate cells
class UIntToAnalogNoTristate(w: Int = 1) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource {
  val io = IO(new Bundle {
    val in = Input(UInt(w.W))
    val out = Analog(w.W)
  })
  addResource("/Analog.v")
}

object UIntToAnalogNoTristate {
  def apply(in: UInt, out: Analog): Unit = {
    val in2out = Module(new UIntToAnalogNoTristate(w = in.getWidth))
    attach(out, in2out.io.out)
    in2out.io.in := in
  }
}