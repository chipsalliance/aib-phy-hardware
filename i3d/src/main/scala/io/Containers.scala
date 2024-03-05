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
    def fullName: String = {
      val inBus = bitIdx.isDefined && !DataMirror.checkTypeEquivalence(ioType, Clock())
      name + (if (inBus) s"[${bitIdx.get}]" else "")
    }
    // This returns muxed clock name
    def muxedClk(offset: Int): String = {
      require(DataMirror.checkTypeEquivalence(ioType, Clock()), "muxedClk only works for clocks")
      val clkIdx = name.filter(_.isDigit).toInt + offset
      name.filterNot(_.isDigit) + clkIdx.toString()
    }

    // Core-facing SDC constraints
    def sdcConstraints(implicit p: AIB3DParams): Seq[String] = {
      val dir = DataMirror.directionOf(ioType)
      val isClk = DataMirror.checkTypeEquivalence(ioType, Clock())
      (dir, isClk) match {
        case (ActualDirection.Input, true) =>  // Tx clock
          val base = Seq(
            // Create clocks for forwarding
            f"create_clock -name $name -period ${p.tPeriod}%.4f [get_ports clocks_$name]",
            f"set_clock_uncertainty ${p.tj}%.4f [get_clocks $name]",
            s"create_generated_clock -name io_$name -source [get_ports clocks_$name] -divide_by 1 [get_pins */clksToTx_$bitIdx]",
            f"set_clock_uncertainty ${p.tj}%.4f [get_clocks io_$name]",
            s"create_generated_clock -name out_$name -source [get_pins */bumps_$name] -divide_by 1 [get_ports $name]",
            f"set_clock_uncertainty ${p.tj}%.4f [get_clocks out_$name]",
            // Model ideal clock tree delay in synthesis
            f"set_clock_latency -min ${p.dtxMin * 2/3}%.4f [get_clocks io_$name]",
            f"set_clock_latency -max ${p.dtxMax * 2/3}%.4f [get_clocks io_$name]",
          )
          val coded = {
            val redName = name.replace("CKP", "CKR")
            Seq(
              s"create_generated_clock -name out_$redName -source [get_pins */bumps_$redName] -divide_by 1 [get_ports $redName]",
              s"set_clock_uncertainty ${p.tj}%.4f [get_clocks out_$redName]"
            )
          }
          val muxed = Seq.empty  // TODO
          base ++ (p.gp.redundArch match {
            case 0 => Seq.empty
            case 1 => coded
            case 2 => muxed
            case _ => throw new Exception("Invalid redundancy architecture")
          })

        case (ActualDirection.Output, true) =>  // Rx clock
          Seq(
            s"set_max_capacitance 0.01 [get_ports clocks_$name]"
          )

        case (ActualDirection.Input, false) =>  // Tx data
          Seq(
            s"set_input_delay -clock [get_clocks ${relatedClk.get}] -max ${p.dtxMax}%.4f [get_ports $name]",
            s"set_input_delay -clock [get_clocks ${relatedClk.get}] -min ${p.dtxMin}%.4f [get_ports $name]",
            s"set_output_delay -clock [get_clocks ${relatedClk.get}] -max ${p.dtxMax}%.4f [get_ports $name]",
            s"set_output_delay -clock [get_clocks ${relatedClk.get}] -min ${p.dtxMin}%.4f [get_ports $name]"
          )

        case (ActualDirection.Output, false) =>  // Rx data
          Seq(
            s"set_max_capacitance 0.01 [get_ports $name]"
          )
      }
    }
  }

/** AIB3D bump containers */
sealed trait AIB3DBump {
  val bumpName: String  // bump net name
  val relatedClk: Option[String] = None  // bump clock domain
  val coreSig: Option[AIB3DCore] = None
  val sdcConstraints: Seq[String]
  var location: Option[AIB3DCoordinates[Double]] = None
  var modIdx: Option[AIB3DCoordinates[Int]] = None
}
// Power/Ground
case class Pwr() extends AIB3DBump {
  val bumpName = "VDDAIB"
  val sdcConstraints = Seq.empty
}
case class Gnd() extends AIB3DBump {
  val bumpName = "VSS"
  val sdcConstraints = Seq.empty
}
// Data
case class TxSig(bumpNum: Int, clkIdx: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"TXDATA${bumpNum}" else s"TXRED${bumpNum}"
  override val relatedClk = Some(s"TXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
  val sdcConstraints = Seq.empty
}
case class RxSig(bumpNum: Int, clkIdx: Int, sig: Option[AIB3DCore]) extends AIB3DBump {
  val bumpName = if (sig.isDefined) s"RXDATA${bumpNum}" else s"RXRED${bumpNum}"
  override val relatedClk = Some(s"RXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
  val sdcConstraints = Seq.empty
}
// Clock
case class TxClk(modNum: Int, codeRed: Boolean, muxRed: Boolean) extends AIB3DBump {
  val bumpName = if (codeRed) s"TXCKR${modNum}" else s"TXCKP${modNum}"
  override val coreSig = if (codeRed || muxRed) None
    else Some(AIB3DCore(s"TXCKP${modNum}", Some(modNum), Output(Clock()), None))
  val sdcConstraints = Seq.empty
}
case class RxClk(modNum: Int, codeRed: Boolean, muxRed: Boolean) extends AIB3DBump {
  val bumpName = if (codeRed) s"RXCKR${modNum}" else s"RXCKP${modNum}"
  override val coreSig = if (codeRed || muxRed) None
    else Some(AIB3DCore(s"RXCKP${modNum}", Some(modNum), Input(Clock()), None))
  val sdcConstraints = Seq.empty
}