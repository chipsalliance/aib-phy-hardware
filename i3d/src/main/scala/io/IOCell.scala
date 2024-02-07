package aib3d.io

import chisel3._

import chisel3.experimental.{Analog, DataMirror}
import testchipip.{ClockMux2, ClockInverter}

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
  val txEn, rxEn, wkpuEn, wkpdEn = Input(Bool())
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
    io.wkpuEn := ioCtrl.txWkpu
    io.wkpdEn := ioCtrl.txWkpd
  }

  private def connectTx(tx: Data, clk: Clock, loopback: Bool): Unit = {
    val isClk = DataMirror.checkTypeEquivalence(tx, clk)
    io.txData := tx.asTypeOf(io.txData)
    io.rxData := DontCare
    io.txClk := (if (isClk) false.B.asClock else clk)
    // TODO: use testchipip.ClockSignalNor2 if clock gating not inferred properly
    io.rxClk := (if (isClk) false.B else loopback && clk.asBool).asClock
    io.txEn := true.B
    io.rxEn := loopback
  }

  private def connectRx(rx: Data, clk: Clock, loopback: Bool): Unit = {
    val isClk = DataMirror.checkTypeEquivalence(rx, clk)
    io.txData := 0.U
    rx := io.rxData.asTypeOf(rx)
    io.txClk := (if (isClk) false.B else loopback && clk.asBool).asClock
    io.rxClk := (if (isClk) false.B.asClock else clk)
    io.txEn := loopback
    io.rxEn := true.B
  }
}

class IOCellModel(val forBump: AIB3DBump) extends RawModule with IOCellConnects {
  // Different logic for clocks
  val isClk = forBump match {
    case _: TxClk | _: RxClk => true
    case _ => false
  }

  // Uncomment if tristates supported in technology
  /*
  // Analog to directional
  val toPad = Wire(Bits(1.W))
  val fromPad = Wire(Bits(1.W))
  UIntToAnalogInvert(toPad, io.pad, io.txEn)
  AnalogToUInt(io.pad, fromPad)
  // Tx logic
  if (isClk) {
    // Direct output
    toPad := ~io.txData
  } else {
    val txRetimed = withClock(io.txClk)(RegNext(~io.txData)) // invert, no reset
    toPad := Mux(io.wkpuEn ^ io.wkpdEn, io.wkpuEn & ~io.wkpdEn, txRetimed)
  }

  // Rx logic
  if (isClk)
    // Direct output via clock inverter
    io.rxData := ClockInverter(fromPad.asBool.asClock).asUInt
  else
    io.rxData := withClock(io.rxClk)(RegNext(fromPad))
  */

  // Else uncomment this
  forBump match {
    case _: TxClk =>
      UIntToAnalogNoTristate(io.txData, io.pad)
      io.rxData := DontCare
    case _: RxClk =>
      val fromPad = Wire(Bits(1.W))
      AnalogToUInt(io.pad, fromPad)
      // Invert received clock
      io.rxData := ClockInverter(fromPad.asBool.asClock).asUInt
    case _: TxSig =>
      val toPad = Wire(Bits(1.W))
      UIntToAnalogNoTristate(toPad, io.pad)
      val txRetimed = withClock(io.txClk)(RegNext(io.txData)) // no reset
      toPad := Mux(io.wkpuEn ^ io.wkpdEn, io.wkpuEn & ~io.wkpdEn, txRetimed)
      io.rxData := withClock(io.rxClk)(RegNext(toPad))
    case _: RxSig =>
      val fromPad = Wire(Bits(1.W))
      AnalogToUInt(io.pad, fromPad)
      val txRetimed = withClock(io.txClk)(RegNext(io.txData)) // no reset
      val muxedRx = Mux(io.txEn, txRetimed, fromPad)
      io.rxData := withClock(io.rxClk)(RegNext(muxedRx))
  }
}

class IOCellBB(val forBump: AIB3DBump)(implicit params: AIB3DInstParams)
  extends BlackBox with IOCellConnects {
  override def desiredName =
    if (params.ioCellName.isDefined) params.ioCellName.get
    else "IOCellBB"
}