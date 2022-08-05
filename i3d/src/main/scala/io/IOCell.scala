package aib3d.io

import chisel3._

import chisel3.experimental.Analog

import aib3d._

class IOCellBundle extends Bundle {
  // TODO: these must match IO cell generator. Use Record instead?
  val tx_clk, rx_clk = Input(Clock())
  val tx_data, tx_async = Input(Bits(1.W))
  val rx_data, rx_async = Output(Bits(1.W))
  val tx_en, rx_en, async_tx_en, async_rx_en, wkpu_en, wkpd_en = Input(Bool())
  val pad = Analog(1.W)

  def attachTx(that: RedundancyMuxBundle) {
    tx_data := that.data
    tx_async := that.async
    tx_en := that.tx_en
    rx_en := that.rx_en
    async_tx_en := that.async_tx_en
    async_rx_en := that.async_rx_en
    wkpu_en := that.wkpu_en
    wkpd_en := that.wkpd_en
  }

  def attachRx(that: RedundancyMuxDataBundle) {
    that.data := rx_data
    that.async := rx_async
  }
}

class IOCellModel(idx: Int) extends RawModule {
  val io = IO(new IOCellBundle)

  // Analog to directional
  val to_pad = Wire(Bits(1.W))
  UIntToAnalog(to_pad, io.pad, io.wkpu_en || io.wkpd_en || io.async_tx_en || io.tx_en)
  val from_pad = Wire(Bits(1.W))
  AnalogToUInt(io.pad, from_pad)

  // Tx logic
  val tx_retimed = withClockAndReset(io.tx_clk, !io.tx_en)(RegNext(io.tx_data, 0.U))
  when (io.wkpu_en) {
    to_pad := 1.U
  } .elsewhen (io.wkpd_en) {
    to_pad := 0.U
  } .elsewhen (io.async_tx_en) {
    to_pad := io.tx_async
  } .otherwise {
    to_pad := tx_retimed
  }

  // Rx logic
  val rx_retimed = withClockAndReset(io.rx_clk, !io.rx_en)(RegNext(from_pad, 0.U))
  io.rx_data := rx_retimed
  io.rx_async := Mux(io.async_rx_en, from_pad, 0.U)

  override def desiredName = s"aibio_$idx"
}

class IOCellBB(idx: Int) extends BlackBox {
  val io = IO(new IOCellBundle)

  override def desiredName = s"aibio_$idx"
}