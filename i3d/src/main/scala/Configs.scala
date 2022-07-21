package aib3d

import chisel3._

import chisel3.experimental.Analog
import freechips.rocketchip.config._
import scala.collection.mutable.LinkedHashMap
import scala.collection.immutable.ListMap

case object AIB3DKey extends Field[AIB3DParams]

/** 
  * Global AIB3D Parameters 
  * This generates the global signal <-> ubump assignments
  * @param numTxIOs is the number of Tx ubumps
  * @param numRxIOs is the number of Rx ubumps
  * @param blackBoxModels true denotes using behavioral models of all blackboxes
  */
case class AIB3DParams(
  numTxIOs: Int = 256,
  numRxIOs: Int = 256,
  blackBoxModels: Boolean = false)
{
  require(numTxIOs % 16 == 0, "Tx IO count must be a multiple of 16")
  require(numRxIOs % 16 == 0, "Rx IO count must be a multiple of 16")
  val clockOffset = 8  // where clocks are placed

  // Ordered mapping of <name> -> <Output(Bits(1.W)) = output, Input(Bits(1.W)) = input, Analog(1.W) = inout>
  private var mapping = LinkedHashMap.empty[String, Data]
  // 8 Tx pads come first, then Tx clocks, then rest of Tx IOs
  if (numTxIOs > 0) {
    for (i <- 0 until clockOffset) { mapping += s"tx_$i" -> Output(Bits(1.W)) }
    mapping += "ns_fwd_clk" -> Output(Bits(1.W))
    mapping += "ns_fwd_clkb" -> Output(Bits(1.W))
    for (i <- 8 until numTxIOs) { mapping += s"tx_$i" -> Output(Bits(1.W)) }
  }
  // Near-side handshake
  mapping += "ns_transfer_reset" -> Output(Bits(1.W))
  mapping += "ns_transfer_en" -> Output(Bits(1.W))
  // Patch detection (power-on reset) on Tx side of spares
  val firstPoR = mapping.size
  mapping += "patch_reset" -> Analog(1.W)
  mapping += "patch_detect" -> Analog(1.W)
  // Spares
  val firstSpare = mapping.size
  mapping += "spare0" -> Analog(1.W)
  mapping += "spare1" -> Analog(1.W)
  // Far-side handshake
  mapping += "fs_transfer_en" -> Input(Bits(1.W))
  mapping += "fs_transfer_reset" -> Input(Bits(1.W))
  // Rx is reverse of Tx
  if (numRxIOs > 0) {
    for (i <- (clockOffset until numRxIOs).reverse) { mapping += s"rx_$i" -> Input(Bits(1.W)) }
    mapping += "fs_fwd_clkb" -> Input(Bits(1.W))
    mapping += "fs_fwd_clk" -> Input(Bits(1.W))
    for (i <- (0 until clockOffset).reverse) { mapping += s"rx_$i" -> Input(Bits(1.W)) }
  }

  def patchSize: Int = mapping.size

  def numTxCtrlClk: Int = if (numTxIOs > 0) 4 else 2  // excludes patch_detect/reset

  def txClkIdx: Range = Range(clockOffset, clockOffset+2)  // doesn't account for no Tx IOs

  def numRxCtrlClk: Int = if (numRxIOs > 0) 4 else 2

  def rxClkIdx: Range = Range(this.patchSize-clockOffset, this.patchSize-clockOffset+2)  // doesn't account for no Rx IOs

  def porIdx: Range = Range(firstPoR, firstPoR+2)

  def sparesIdx: Range = Range(firstSpare, firstSpare+2)

  def padsIoMap: ListMap[String, Data] = {
    ListMap(mapping.mapValues(_ => Analog(1.W)).toSeq:_*)
  } 

  def adapterIoMap: ListMap[String, Data] = {
    // no spares, PoR signals have in and out
    var adapter_mapping = mapping.take(numTxIOs + this.numTxCtrlClk)
    adapter_mapping ++= List("patch_reset_out" -> Output(Bits(1.W)), "patch_detect_out" -> Output(Bits(1.W)))
    adapter_mapping ++= List("patch_reset_in" -> Input(Bits(1.W)), "patch_detect_in" -> Input(Bits(1.W)))
    adapter_mapping ++= mapping.takeRight(numRxIOs + this.numRxCtrlClk)
    ListMap(adapter_mapping.toSeq:_*)
  }
}

/** 
  * Global AIB3D Configs
  * When running the Generator, 
  */

class AIB3DBaseConfig extends Config ((site, here, up) => {
  case AIB3DKey => AIB3DParams()
})

class AIB3DBalancedConfig(val numIOs: Int) extends Config ((site, here, up) => { 
  case AIB3DKey => AIB3DParams(numIOs, numIOs)
})

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