package aib3d.io

import chisel3._

import chisel3.experimental.Analog
import freechips.rocketchip.config.Parameters

import aib3d._

/** Useful case classes */
// Useful for any coordinates (submodule, pin, bump)
case class AIB3DCoordinates[T: Numeric](x: T, y: T) {
  import Numeric.Implicits._
  // Following methods are to be used for submodule indices only
  // Divide by 2 since submods are created in pairs
  def linearIdx(implicit p: Parameters): Int = {
    val params = p(AIB3DKey)
    if (params.isWide)
      x.toInt() / 2 * params.submodRowsWR + y.toInt()
    else
      y.toInt() / 2 * params.submodColsWR + x.toInt()
  }
  def isRedundant(implicit p: Parameters): Boolean = {
    val params = p(AIB3DKey)
    if (params.isWide) x.toInt() >= params.submodCols
    else y.toInt() >= params.submodRows
  }
}

/** AIB3D core facing signal container */
case class AIB3DCore(
  name: String,  // Signal name (from data bundle)
  bitIdx: Option[Int],  // For buses
  ioType: Data,  // Input, Output, Analog
  relatedClk: Option[String]) {  // Name of clock domain
    var pinLocation: Option[AIB3DCoordinates[Double]] = None
  }

/** AIB3D bump containers */
sealed trait AIB3DBump {
  val bumpName: String  // bump net name
  val coreSig: Option[AIB3DCore]
  var location: Option[AIB3DCoordinates[Double]] = None
  var submodIdx: Option[AIB3DCoordinates[Int]] = None
}
// Power/Ground
case class Pwr() extends AIB3DBump {
  val bumpName = "VDDAIB"
  val coreSig = None
}
case class Gnd() extends AIB3DBump {
  val bumpName = "VSS"
  val coreSig = None
}
// Data
case class TxSig(bumpNum: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"TXDATA${bumpNum}" else s"TXRED${bumpNum}"
  val coreSig = if (sig.isDefined) sig else None
}
case class RxSig(bumpNum: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"RXDATA${bumpNum}" else s"RXRED${bumpNum}"
  val coreSig = if (sig.isDefined) sig else None
}
// Clock
// TODO: redundant block should not have coreSig?
case class TxClk(submodNum: Int) extends AIB3DBump {
  val bumpName = s"TXCKP${submodNum}"
  val coreSig = Some(AIB3DCore(s"TXCKP${submodNum}", None, Output(Clock()), None))
}
case class RxClk(submodNum: Int) extends AIB3DBump {
  val bumpName = s"RXCKP${submodNum}"
  val coreSig = Some(AIB3DCore(s"RXCKP${submodNum}", None, Input(Clock()), None))
}