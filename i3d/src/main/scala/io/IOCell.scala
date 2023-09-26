package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

class IOControlBundle extends Bundle {
  val loopback, txWkpu, txWkpd, rxWkpu, rxWkpd = Bool()

  def init: UInt = "b00101".U(5.W)
}

class IOCellBundle extends Bundle {
  // TODO: these must match IO cell generator. Use DataView?
  val txClk, rxClk = Input(Clock())
  val txData = Input(Bits(1.W))
  val rxData = Output(Bits(1.W))
  val async, txEn, rxEn, wkpuEn, wkpdEn = Input(Bool())
  val pad = Analog(1.W)
}

trait IOCellConnects {
  val forBump: AIB3DBump

  val io = IO(new IOCellBundle)

  def connectInternal(d: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    DataMirror.directionOf(d) match {
      case ActualDirection.Input => connectRx(d, clk, ioCtrl.loopback)
      case ActualDirection.Output => connectTx(d, clk, ioCtrl.loopback)
      case _ => throw new Exception("Data to be connected must have a direction")
    }
    io.async := DataMirror.checkTypeEquivalence(d, clk).B  // is clock
    io.wkpuEn := ioCtrl.txWkpu
    io.wkpdEn := ioCtrl.txWkpd
  }

  private def connectTx(tx: Data, clk: Clock, loopback: Bool): Unit = {
    io.txData := tx.asTypeOf(io.txData)
    io.rxData := DontCare
    io.txClk := clk
    // TODO: use testchipip.ClockSignalNor2 if clock gating not inferred properly
    io.rxClk := (loopback && clk.asBool).asClock
    io.txEn := true.B
    io.rxEn := loopback
  }

  private def connectRx(rx: Data, clk: Clock, loopback: Bool): Unit = {
    io.txData := 0.U
    rx := io.rxData.asTypeOf(rx)
    io.txClk := (loopback && clk.asBool).asClock
    io.rxClk := clk
    io.txEn := loopback
    io.rxEn := true.B
  }
}

class IOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  // Analog to directional
  val toPad = Wire(Bits(1.W))
  UIntToAnalog(toPad, io.pad, io.txEn)
  val fromPad = Wire(Bits(1.W))
  AnalogToUInt(io.pad, fromPad)

  // TODO: detect clock cells and don't have retimers

  // Tx logic
  val txRetimed = withClockAndReset(io.txClk, !io.txEn)(RegNext(io.txData, 0.U))
  val tx = Mux(io.async, io.txData, txRetimed)
  val txp = Mux(io.wkpuEn ^ io.wkpdEn, io.wkpuEn & ~io.wkpdEn, tx)
  toPad := Mux(io.txEn, tx, txp)

  // Rx logic
  val rxClock = Wire(Clock())
  rxClock := (!io.rxClk.asBool).asClock
  val rxRetimed = withClockAndReset(rxClock, !io.rxEn)(RegNext(fromPad, 0.U))
  io.rxData := Mux(io.async, fromPad & io.rxEn, rxRetimed)
}

class IOCellBB(val forBump: AIB3DBump)(implicit params: AIB3DInstParams)
  extends BlackBox with IOCellConnects {
  override def desiredName =
    if (params.ioCellName.isDefined) params.ioCellName.get
    else "IOCellBB"
}