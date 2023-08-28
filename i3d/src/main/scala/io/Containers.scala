package aib3d.io

import org.json4s.jackson.Serialization
import org.json4s.jackson.Serialization.write

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import aib3d._

/** Useful case classes */

/** Useful for any coordinates (submodule, pin, bump) */
case class AIB3DCoordinates[T: Numeric](x: T, y: T) {
  import Numeric.Implicits._
  // Following methods are to be used for submodule indices only
  // Divide by 2 since submods are created in pairs
  def linearIdx(implicit params: AIB3DParams): Int = {
    if (params.isWide) x.toInt / 2 * params.submodRowsWR + y.toInt
    else y.toInt / 2 * params.submodColsWR + x.toInt
  }
  def isRedundant(implicit params: AIB3DParams): Boolean = {
    if (params.isWide) x.toInt >= params.submodCols
    else y.toInt >= params.submodRows
  }
}

/** AIB3D core facing signal container */
case class AIB3DCore(
  name: String,  // Signal name (from data bundle)
  bitIdx: Option[Int],  // For buses
  ioType: Data,  // Input, Output, Analog
  relatedClk: Option[String]) {  // Name of clock domain
    //var pinLocation: Option[AIB3DCoordinates[Double]] = None
    var pinLocation: Option[AIB3DCoordinates[Double]] =
      Some(AIB3DCoordinates[Double](0.0, 0.0))
    // TODO: this uses a DataMirror internal API, subject to change/removal
    def cloneIoType: Data = DataMirror.internal.chiselTypeClone(ioType)
    def fullName: String =
      name + (if (bitIdx.isDefined) "[" + bitIdx.get.toString() + "]" else "")
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
case class TxClk(submodNum: Int, isRedundant: Boolean) extends AIB3DBump {
  val bumpName = s"TXCKP${submodNum}"
  val coreSig = if (isRedundant) None
    else Some(AIB3DCore(s"TXCKP${submodNum}", None, Output(Clock()), None))
}
case class RxClk(submodNum: Int, isRedundant: Boolean) extends AIB3DBump {
  val bumpName = s"RXCKP${submodNum}"
  val coreSig = if (isRedundant) None
    else Some(AIB3DCore(s"RXCKP${submodNum}", None, Input(Clock()), None))
}