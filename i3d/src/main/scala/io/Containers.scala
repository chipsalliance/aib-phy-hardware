package aib3d.io

import org.json4s.jackson.Serialization
import org.json4s.jackson.Serialization.write

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

/** Useful case classes */

/** Useful for any coordinates (module, pin, bump) */
case class AIB3DCoordinates[T: Numeric](x: T, y: T) {
  import Numeric.Implicits._
  // Following methods are to be used for module indices only
  // Get the linear index of the module (Tx/Rx are separate)
  // Divide by 2 since modules are created in pairs
  def linearIdx(implicit params: AIB3DParams): Int = {
    if (params.isWide) x.toInt / 2 * params.modRowsWR + y.toInt
    else y.toInt / 2 * params.modColsWR + x.toInt
  }
  // Determine if the module is redundant
  def isRedundant(implicit params: AIB3DParams): Boolean = {
    if (params.isWide) x.toInt >= 2 * params.modCols
    else y.toInt >= 2 * params.modRows
  }
}

/** AIB3D core facing signal container */
case class AIB3DCore(
  name: String,  // Signal name (from data bundle)
  bitIdx: Option[Int],  // For buses
  ioType: Data,  // Input, Output, Analog
  relatedClk: Option[String]) {  // Name of clock domain
    var pinLocation: Option[AIB3DCoordinates[Double]] = None
    var pinLayer: Option[String] = None
    // TODO: this uses a DataMirror internal API, subject to change/removal
    def cloneIoType: Data = DataMirror.internal.chiselTypeClone(ioType)
    def fullName: String =
      name + (if (bitIdx.isDefined) "[" + bitIdx.get.toString() + "]" else "")
    // This returns muxed clock name
    def muxedClk(offset: Int): String = {
      require(DataMirror.checkTypeEquivalence(ioType, Clock()), "muxedClk only works for clocks")
      val clkIdx = name.filter(_.isDigit).toInt + offset
      name.filterNot(_.isDigit) + clkIdx.toString()
    }
  }

/** AIB3D bump containers */
sealed trait AIB3DBump {
  val bumpName: String  // bump net name
  val relatedClk: Option[String] = None  // bump clock domain
  val coreSig: Option[AIB3DCore] = None
  var location: Option[AIB3DCoordinates[Double]] = None
  var modIdx: Option[AIB3DCoordinates[Int]] = None
}
// Power/Ground
case class Pwr() extends AIB3DBump {
  val bumpName = "VDDAIB"
}
case class Gnd() extends AIB3DBump {
  val bumpName = "VSS"
}
// Data
case class TxSig(bumpNum: Int, clkIdx: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"TXDATA${bumpNum}" else s"TXRED${bumpNum}"
  override val relatedClk = Some(s"TXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
}
case class RxSig(bumpNum: Int, clkIdx: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"RXDATA${bumpNum}" else s"RXRED${bumpNum}"
  override val relatedClk = Some(s"RXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
}
// Clock
case class TxClk(modNum: Int, codeRed: Boolean, muxRed: Boolean) extends AIB3DBump {
  val bumpName = if (codeRed) s"TXCKR${modNum}" else s"TXCKP${modNum}"
  override val coreSig = if (codeRed || muxRed) None
    else Some(AIB3DCore(s"TXCKP${modNum}", None, Output(Clock()), None))
}
case class RxClk(modNum: Int, codeRed: Boolean, muxRed: Boolean) extends AIB3DBump {
  val bumpName = if (codeRed) s"RXCKR${modNum}" else s"RXCKP${modNum}"
  override val coreSig = if (codeRed || muxRed) None
    else Some(AIB3DCore(s"RXCKP${modNum}", None, Input(Clock()), None))
}