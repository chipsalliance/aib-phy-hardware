package aib3d

import chisel3._

import chisel3.experimental.Analog
import freechips.rocketchip.config._
import scala.collection.mutable.LinkedHashMap
import scala.collection.immutable.ListMap

/** AIB3D I/O Types */
sealed trait AIB3DIO {
  val bumpNum: Int  // bump assignment
  val ioType: Data  // Input, Output, Analog
}
// Data
case class TxSeq(bumpNum: Int) extends AIB3DIO { val ioType: Data = Output(Bits(1.W)) }
case class RxSeq(bumpNum: Int) extends AIB3DIO { val ioType: Data = Input(Bits(1.W)) }
case class TxAsync(bumpNum: Int) extends AIB3DIO { val ioType: Data = Output(Bits(1.W)) }
case class RxAsync(bumpNum: Int) extends AIB3DIO { val ioType: Data = Input(Bits(1.W)) }
case class BidirSeq(bumpNum: Int) extends AIB3DIO { val ioType: Data = Analog(1.W) }
case class BidirAsync(bumpNum: Int) extends AIB3DIO { val ioType: Data = Analog(1.W) }
// Power-on Reset
case class TxPoR(bumpNum: Int) extends AIB3DIO { val ioType: Data = Output(Bits(1.W)) }
case class RxPoR(bumpNum: Int) extends AIB3DIO { val ioType: Data = Input(Bits(1.W)) }
case class Spare(bumpNum: Int) extends AIB3DIO { val ioType: Data = Analog(1.W) }

/** Global AIB3D Parameters 
  * This generates the global signal <-> ubump assignments
  * @param numTxIOs is the number of Tx ubumps
  * @param numRxIOs is the number of Rx ubumps
  * @param baseAddress is the memory-mapped CSR base address
  * @param blackBoxModels true denotes using behavioral models of all blackboxes
  */
case class AIB3DParams(
  numTxIOs: Int = 256,
  numRxIOs: Int = 256,
  baseAddress: Int = 0x2000,  // CSR address
  blackBoxModels: Boolean = false) {

  // Checks
  require(numTxIOs % 16 == 0, "Tx IO count must be a multiple of 16")
  require(numRxIOs % 16 == 0, "Rx IO count must be a multiple of 16")
  // TODO: this doesn't work properly for unbalanced configs
  require(numTxIOs == numRxIOs, "Only balanced Tx/Rx IO count supported at this time.")

  private val clockOffset = 8  // where clocks are placed
  
  // Construct ordered IOs
  private var ios = LinkedHashMap.empty[String, AIB3DIO]
  // clockOffset Tx IOs come first, then Tx clocks, then rest of Tx IOs
  if (numTxIOs > 0) {
    for (i <- 0 until clockOffset) { ios += s"tx_$i" -> TxSeq(ios.size) }
    ios += "ns_fwd_clk" -> TxAsync(ios.size)
    ios += "ns_fwd_clkb" -> TxAsync(ios.size)
    for (i <- clockOffset until numTxIOs) { ios += s"tx_$i" -> TxSeq(ios.size) }
  }
  // Near-side data transfer ready
  private val firstTxCtrl = ios.size
  ios += "ns_transfer_en" -> TxAsync(ios.size)
  // Patch detection output
  ios += "ns_patch_por" -> TxPoR(ios.size)
  // Spares
  private val firstSpare = ios.size
  ios += "spare_0" -> Spare(ios.size)
  ios += "spare_1" -> Spare(ios.size)
  // Patch detection input
  private val firstRxCtrl = ios.size
  ios += "fs_patch_por" -> RxPoR(ios.size)
  // Far-side data transfer ready
  ios += "fs_transfer_en" -> RxAsync(ios.size)
  // Rx is reverse of Tx
  if (numRxIOs > 0) {
    for (i <- (clockOffset until numRxIOs).reverse) { ios += s"rx_$i" -> RxSeq(ios.size) }
    ios += "fs_fwd_clkb" -> RxAsync(ios.size)
    ios += "fs_fwd_clk" -> RxAsync(ios.size)
    for (i <- (0 until clockOffset).reverse) { ios += s"rx_$i" -> RxSeq(ios.size) }
  }

  // Following are globally-accessible

  // Constants
  val patchSize = ios.size
  val numTxCtrlClk = if (numTxIOs > 0) 4 else 2
  val numRxCtrlClk = if (numRxIOs > 0) 4 else 2

  // Convenience Ranges
  val txClkIdx = Range(clockOffset, clockOffset+2)  // doesn't account for no Tx IOs
  val rxClkIdx = Range(this.patchSize-clockOffset, this.patchSize-clockOffset+2)  // doesn't account for no Rx IOs
  val txCtrlIdx = Range(firstTxCtrl, firstTxCtrl+2)
  val rxCtrlIdx = Range(firstRxCtrl, firstRxCtrl+2)
  val sparesIdx = Range(firstSpare, firstSpare+2)

  // Mapped IO types and data
  val padsIoTypes: ListMap[String, AIB3DIO] = ListMap(ios.toSeq:_*)
  val padsIoMap: ListMap[String, Data] = ListMap(ios.mapValues(_ => Analog(1.W)).toSeq:_*)  // for connection to pad cells

  // no spares, bidir signals turn into in and out
  // TODO: bidir signals not implemented properly
  val adapterIoTypes: ListMap[String, AIB3DIO] = ListMap(ios.flatMap {
    case(n, t) => t match {
      case _:Spare => List.empty  // no spares
      case io:BidirSeq => List(s"${n}_out" -> TxSeq(io.bumpNum), s"${n}_in" -> RxSeq(io.bumpNum))
      case io:BidirAsync => List(s"${n}_out" -> TxAsync(io.bumpNum), s"${n}_in" -> RxAsync(io.bumpNum))
      case _ => List(n -> t)  // keep as-is
    }}.toSeq:_*)
  val adapterIoMap: ListMap[String, Data] = ListMap(adapterIoTypes.mapValues(io => io.ioType).toSeq:_*)
}

case object AIB3DKey extends Field[AIB3DParams]

/** 
  * Global AIB3D Configs
  * When running the Generator, select one of these configs for the implicit params.
  */

class AIB3DBaseConfig extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams()
})

class AIB3DHalfConfig extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams(128, 128)
})

class AIB3DBalancedConfig(val numIOs: Int) extends Config ((site, here, up) => { 
  case AIB3DKey => AIB3DParams(numIOs, numIOs)
})

// TODO: below configs are not yet supported.
class AIB3DUnbalancedConfig(val numTx: Int, val numRx: Int) extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams(numTx, numRx)
})

class AIB3DAllTxConfig(val numTx: Int) extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams(numTx, 0)
})

class AIB3DAllRxConfig(val numRx: Int) extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams(0, numRx)
})

class AIB3DBiDirConfig(val numIOs: Int) extends Config ((site, here, up) => {  // TODO: to be implemented properly
  case AIB3DKey => AIB3DParams(numIOs, numIOs)
})