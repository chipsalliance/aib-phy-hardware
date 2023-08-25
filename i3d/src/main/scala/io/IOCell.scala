package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

class IOControlBundle extends Bundle {
  val loopback, tx_wkpu, tx_wkpd, rx_wkpu, rx_wkpd = Bool()
}

trait IOCellBundle {
  val location: AIB3DCoordinates[Double]

  // TODO: these must match IO cell generator. Use DataView?
  val tx_clk, rx_clk = IO(Input(Clock()))
  val tx_data = IO(Input(Bits(1.W)))
  val rx_data = IO(Output(Bits(1.W)))
  val async, tx_en, rx_en, wkpu_en, wkpd_en = IO(Input(Bool()))
  val pad = IO(Analog(1.W))

  def connectInternal(d: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    DataMirror.directionOf(d) match {
      case ActualDirection.Input => connectRx(d, clk, ioCtrl.loopback)
      case ActualDirection.Output => connectTx(d, clk, ioCtrl.loopback)
      case _ => throw new Exception("Data to be connected must have a direction")
    }
    async := DataMirror.checkTypeEquivalence(d, clk).B  // is clock
    wkpu_en := ioCtrl.tx_wkpu
    wkpd_en := ioCtrl.tx_wkpd
  }

  private def connectTx(tx: Data, clk: Clock, loopback: Bool): Unit = {
    tx_data := tx.asTypeOf(tx_data)
    rx_data := DontCare
    tx_clk := clk
    // TODO: use testchipip.ClockSignalNor2 if clock gating not inferred properly
    rx_clk := (loopback && clk.asBool).asClock
    tx_en := true.B
    rx_en := loopback
  }

  private def connectRx(rx: Data, clk: Clock, loopback: Bool): Unit = {
    tx_data := 0.U
    rx := rx_data.asTypeOf(rx)
    tx_clk := (loopback && clk.asBool).asClock
    rx_clk := clk
    tx_en := loopback
    rx_en := true.B
  }
}

class IOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellBundle {
  val location = forBump.location.get

  // Analog to directional
  val to_pad = Wire(Bits(1.W))
  UIntToAnalog(to_pad, pad, tx_en)
  val from_pad = Wire(Bits(1.W))
  AnalogToUInt(pad, from_pad)

  // TODO: detect clock cells and don't have retimers

  // Tx logic
  val tx_retimed = withClockAndReset(tx_clk, !tx_en)(RegNext(tx_data, 0.U))
  val tx = Mux(async, tx_data, tx_retimed)
  val txp = Mux(wkpu_en ^ wkpd_en, wkpu_en & ~wkpd_en, tx)
  to_pad := Mux(tx_en, tx, txp)

  // Rx logic
  val rx_retimed = withClockAndReset(rx_clk, !rx_en)(RegNext(from_pad, 0.U))
  rx_data := Mux(async, from_pad & rx_en, rx_retimed)
}

class IOCellBB(val forBump: AIB3DBump) extends BlackBox with IOCellBundle {
  val location = forBump.location.get
}