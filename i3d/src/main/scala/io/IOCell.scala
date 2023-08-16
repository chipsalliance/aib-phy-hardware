package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

class IOControlBundle extends Bundle {
  val loopback, tx_wkpu, tx_wkpd, rx_wkpu, rx_wkpd = Bool()
}

class IOCellBundle extends Bundle {
  // TODO: these must match IO cell generator. Use DataView?
  val tx_clk, rx_clk = Input(Clock())
  val tx_data = Input(Bits(1.W))
  val rx_data = Output(Bits(1.W))
  val async, tx_en, rx_en, wkpu_en, wkpd_en = Input(Bool())
  val pad = Analog(1.W)

  def connectInternal(d: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    if (DataMirror.directionOf(d) == ActualDirection.Input) connectRx(d, clk, ioCtrl.loopback)
    else connectTx(d, clk, ioCtrl.loopback)
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

class IOCellModel(idx: Int) extends RawModule {
  val io = IO(new IOCellBundle)

  // Analog to directional
  val to_pad = Wire(Bits(1.W))
  UIntToAnalog(to_pad, io.pad, io.wkpu_en || io.wkpd_en || io.tx_en)
  val from_pad = Wire(Bits(1.W))
  AnalogToUInt(io.pad, from_pad)

  // TODO: detect clock cells

  // Tx logic
  val tx_retimed = withClockAndReset(io.tx_clk, !io.tx_en)(RegNext(io.tx_data, 0.U))
  when (io.wkpu_en) {
    to_pad := 1.U
  } .elsewhen (io.wkpd_en) {
    to_pad := 0.U
  } .elsewhen (io.async) {
    to_pad := io.tx_data & io.tx_en
  } .otherwise {
    to_pad := tx_retimed
  }

  // Rx logic
  val rx_retimed = withClockAndReset(io.rx_clk, !io.rx_en)(RegNext(from_pad, 0.U))
  when (io.async) {
    io.rx_data := from_pad & io.rx_en
  } .otherwise {
    io.rx_data := rx_retimed
  }

  override def desiredName = s"aibio_$idx"
}

class IOCellBB(idx: Int) extends BlackBox {
  val io = IO(new IOCellBundle)

  override def desiredName = s"aibio_$idx"
}