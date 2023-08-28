package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

class IOControlBundle extends Bundle {
  val loopback, txWkpu, txWkpd, rxWkpu, rxWkpd = Bool()
}

trait IOCellBundle {
  val forBump: AIB3DBump

  // TODO: these must match IO cell generator. Use DataView?
  val txClk, rxClk = IO(Input(Clock()))
  val txData = IO(Input(Bits(1.W)))
  val rxData = IO(Output(Bits(1.W)))
  val async, txEn, rxEn, wkpuEn, wkpdEn = IO(Input(Bool()))
  val pad = IO(Analog(1.W))

  def connectInternal(d: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    DataMirror.directionOf(d) match {
      case ActualDirection.Input => connectRx(d, clk, ioCtrl.loopback)
      case ActualDirection.Output => connectTx(d, clk, ioCtrl.loopback)
      case _ => throw new Exception("Data to be connected must have a direction")
    }
    async := DataMirror.checkTypeEquivalence(d, clk).B  // is clock
    wkpuEn := ioCtrl.txWkpu
    wkpdEn := ioCtrl.txWkpd
  }

  private def connectTx(tx: Data, clk: Clock, loopback: Bool): Unit = {
    txData := tx.asTypeOf(txData)
    rxData := DontCare
    txClk := clk
    // TODO: use testchipip.ClockSignalNor2 if clock gating not inferred properly
    rxClk := (loopback && clk.asBool).asClock
    txEn := true.B
    rxEn := loopback
  }

  private def connectRx(rx: Data, clk: Clock, loopback: Bool): Unit = {
    txData := 0.U
    rx := rxData.asTypeOf(rx)
    txClk := (loopback && clk.asBool).asClock
    rxClk := clk
    txEn := loopback
    rxEn := true.B
  }
}

class IOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellBundle {
  // Analog to directional
  val toPad = Wire(Bits(1.W))
  UIntToAnalog(toPad, pad, txEn)
  val fromPad = Wire(Bits(1.W))
  AnalogToUInt(pad, fromPad)

  // TODO: detect clock cells and don't have retimers

  // Tx logic
  val txRetimed = withClockAndReset(txClk, !txEn)(RegNext(txData, 0.U))
  val tx = Mux(async, txData, txRetimed)
  val txp = Mux(wkpuEn ^ wkpdEn, wkpuEn & ~wkpdEn, tx)
  toPad := Mux(txEn, tx, txp)

  // Rx logic
  val rxRetimed = withClockAndReset(rxClk, !rxEn)(RegNext(fromPad, 0.U))
  rxData := Mux(async, fromPad & rxEn, rxRetimed)
}

class IOCellBB(val forBump: AIB3DBump) extends BlackBox with IOCellBundle {
}