package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}
import testchipip.{ClockMux2, ClockInverter}

import aib3d._

class IOControlBundle extends Bundle {
  val loopback, txWkpu, txWkpd, rxWkpu, rxWkpd = Bool()

  def init: UInt = "b00101".U(5.W)
}

// TODO: these must match IO cell generator. Use DataView?
class TxClkIOCellBundle extends Bundle {
  // Direct output, no loopback
  val txClk = Input(Clock())
  val pad = Output(Clock())
  val wkpuEn, wkpdEn = Input(Bool())
}

class TxSigIOCellBundle extends Bundle {
  // Retimed output, loopback
  val txClk = Input(Clock())
  val txData = Input(Bits(1.W))
  val pad = Output(Bits(1.W))
  val wkpuEn, wkpdEn, loopback = Input(Bool())
  val lpbkData = Output(Bits(1.W))
}

class RxClkIOCellBundle extends Bundle {
  // Inverted output, no loopback
  val pad = Input(Clock())
  val rxClk = Output(Clock())
}

class RxSigIOCellBundle extends Bundle {
  // Retimed output, loopback
  val pad = Input(Bits(1.W))
  val rxClk = Input(Clock())
  val rxData = Output(Bits(1.W))
  val loopback = Input(Bool())
  val lpbkData = Input(Bits(1.W))
}

trait IOCellConnects {
  val forBump: AIB3DBump

  def connectInternal(d: Data, clk: Clock, ioCtrl: IOControlBundle): Unit

  def connectExternal(d: Data): Unit
}

class TxClkIOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  val io = IO(new TxClkIOCellBundle)

  def connectInternal(tx: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    require(DataMirror.checkTypeEquivalence(tx, clk), "Trying to assign data to Tx clock pad")
    io.txClk := tx.asTypeOf(io.txClk)
    io.wkpuEn := ioCtrl.txWkpu
    io.wkpdEn := ioCtrl.txWkpd
  }

  def connectExternal(d: Data): Unit =
    d := io.pad.asTypeOf(d)

  io.pad := io.txClk
}

class TxSigIOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  val io = IO(new TxSigIOCellBundle)

  def connectInternal(tx: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    require(!DataMirror.checkTypeEquivalence(tx, clk), "Trying to assign clock to Tx data pad")
    io.txData := tx.asTypeOf(io.txData)
    io.txClk := clk
    io.wkpuEn := ioCtrl.txWkpu
    io.wkpdEn := ioCtrl.txWkpd
    io.loopback := ioCtrl.loopback
  }

  def connectExternal(d: Data): Unit =
    d := io.pad.asTypeOf(d)

  val txRetimed = withClock(io.txClk)(RegNext(io.txData)) // no reset
  //io.pad := Mux(io.wkpuEn ^ io.wkpdEn, io.wkpuEn & ~io.wkpdEn, txRetimed)
  io.pad := txRetimed
  io.lpbkData := withClock(io.txClk)(RegNext(io.pad))
}

class RxClkIOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  val io = IO(new RxClkIOCellBundle)

  def connectInternal(rx: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    require(DataMirror.checkTypeEquivalence(rx, clk), "Trying to assign data to Rx clock pad")
    rx := io.rxClk.asTypeOf(rx)
  }

  def connectExternal(d: Data): Unit =
    io.pad := d.asTypeOf(io.pad)

  io.rxClk := ClockInverter(io.pad)
}

class RxSigIOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  val io = IO(new RxSigIOCellBundle)

  def connectInternal(rx: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = {
    require(!DataMirror.checkTypeEquivalence(rx, clk), "Trying to assign clock to Rx data pad")
    rx := io.rxData.asTypeOf(rx)
    io.rxClk := clk
    io.loopback := ioCtrl.loopback
    io.lpbkData := 0.U  // TODO
  }

  def connectExternal(d: Data): Unit =
    io.pad := d.asTypeOf(io.pad)

  val lpbkRetimed = withClock(io.rxClk)(RegNext(io.lpbkData)) // no reset
  val muxedRx = Mux(io.loopback, lpbkRetimed, io.pad)
  io.rxData := withClock(io.rxClk)(RegNext(muxedRx))
}

class IOCellBB(val forBump: AIB3DBump)(implicit params: AIB3DInstParams)
  extends BlackBox with IOCellConnects {
  override def desiredName =
    if (params.ioCellName.isDefined) params.ioCellName.get
    else "IOCellBB"

  def connectInternal(tx: Data, clk: Clock, ioCtrl: IOControlBundle): Unit = ???  // TODO
  def connectExternal(d: Data): Unit = ???  // TODO
}