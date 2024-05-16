package i3d.io

import org.json4s.jackson.Serialization
import org.json4s.jackson.Serialization.write
import scala.collection.mutable.ArrayBuffer

import chisel3._

import chisel3.experimental.{Analog, DataMirror}

import i3d._
import i3d.redundancy.RedundancyArch

/** Useful case classes */

/** Useful for any coordinates (module, pin, bump) */
case class I3DCoordinates[T: Numeric](x: T, y: T) {
  import Numeric.Implicits._
  // Following methods are to be used for module indices only
  // Get the linear index of the module (Tx/Rx are separate)
  // Divide by 2 since modules are created in pairs
  def linearIdx(implicit p: I3DParams): Int = {
    if (p.isWide) x.toInt / 2 * p.modRowsWR + y.toInt
    else y.toInt / 2 * p.modColsWR + x.toInt
  }
  // Determine if the module is shifted-to in shifting redundancy
  def isRedundant(implicit p: I3DParams): Boolean = {
    if (p.isWide) x.toInt >= 2 * p.modCols
    else y.toInt >= 2 * p.modRows
  }
  // Determine if the module is shifted-from in shifting redundancy
  def isDirect(implicit p: I3DParams): Boolean = {
    if (p.isWide) x.toInt == 0
    else y.toInt == 0
  }
}

/** I3D core facing signal container */
case class I3DCore(
  name: String,  // Signal name (from data bundle)
  bitIdx: Option[Int],  // For buses
  ioType: Data,  // Input, Output, Analog
  relatedClk: Option[String]) {  // Name of clock domain
    var pinLocation: I3DCoordinates[Double] = I3DCoordinates(-1.0, -1.0)
    var pinLayer: String = ""
    // TODO: this uses a DataMirror internal API, subject to change/removal
    def cloneIoType: Data = DataMirror.internal.chiselTypeClone(ioType)
    def fullName: String = {
      val inBus = bitIdx.isDefined && !DataMirror.checkTypeEquivalence(ioType, Clock())
      name + (if (inBus) s"[${bitIdx.get}]" else "")
    }
    // This returns shifted clock name
    def shiftedClk(offset: Int): String = {
      require(DataMirror.checkTypeEquivalence(ioType, Clock()), "shiftedClk only works for clocks")
      val clkIdx = name.filter(_.isDigit).toInt + offset
      name.filterNot(_.isDigit) + clkIdx.toString()
    }
  }

/** I3D bump containers */
sealed trait I3DBump {
  val bumpName: String  // bump net name
  val relatedClk: Option[String] = None  // bump clock domain
  val coreSig: Option[I3DCore] = None  // primary core signal
  // These are set dynamically after bump map is created
  var location: I3DCoordinates[Double] = I3DCoordinates(-1.0, -1.0)
  var modCoord: I3DCoordinates[Int] = I3DCoordinates(-1, -1)
  // Generates SDC constraints after construction
  def sdcConstraints(shiftCase: Boolean = false, ioCellPath: String = "")
    (implicit p: I3DParams): String = ""
}
// Power/Ground
case class Pwr() extends I3DBump {
  val bumpName = "VDDI"
}
case class Gnd() extends I3DBump {
  val bumpName = "VSS"
}
/** Transmit data bump
  * @param bumpNum is the signal bump number
  * @param clkIdx is the related clock index
  * @param sig is the core signal (required if not coded or shifted)
  */
case class TxSig(bumpNum: Int, clkIdx: Int, sig: Option[I3DCore]) extends I3DBump {
  val bumpName = if (sig.isDefined) s"TXDATA${bumpNum}" else s"TXRED${bumpNum}"
  override val relatedClk = Some(s"TXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
  override def sdcConstraints(shiftCase: Boolean = false, ioCellPath: String = "")
    (implicit p: I3DParams): String = {
    // This is called once per clock domain ($core and $bumps defined globally)
    val sdc = ArrayBuffer(s"# Tx data constraints in clock domain ${relatedClk.get}")
    // Core input delay. Calculated from clock latency.
    // 1st quarter to half period budget.
    // Omitted if module is redundant.
    if (!modCoord.isRedundant) {
      val lat = p.pinSide match {
        case "N" => (p.modRowsWR - modCoord.y + 0.5) * p.modDelay
        case "S" => (modCoord.y + 1.5) * p.modDelay
        case "E" => (p.modColsWR - modCoord.x + 0.5) * p.modDelay
        case "W" => (modCoord.x + 1.5) * p.modDelay
      }
      sdc += f"set_input_delay ${lat * 1.1 + p.tPeriod / 2}%.4f " +
        s"-clock [get_clocks ${relatedClk.get}] " +
        s"-max [get_ports $$core] -add_delay"  // setup
      sdc += f"set_input_delay ${lat * 0.9 + p.tPeriod / 4}%.4f " +
        s"-clock [get_clocks ${relatedClk.get}] " +
        s"-min [get_ports $$core] -add_delay"  // hold
    }
    // Constrain output delay using data checks so that the clock path can be adjusted instead.
    // Due to duty cycle distortion, need to constrain against falling edge of forwarded clock.
    // Data check is same cycle constraint. Add period fractions instead of set_multicycle_path.
    // TODO: Can't use [get_ports {list}] in -to of set_data_check (Cadence bug?)
    sdc += "foreach b $bumps {"
    sdc += f"  set_data_check ${-p.dtxMax - p.tj - p.tPeriod / 2}%.4f " +
      s"-fall_from [get_ports ${relatedClk.get}] -to [get_ports $$b] -setup"
    sdc += f"  set_data_check ${p.dtxMin - p.tj + p.tPeriod * 1.5}%.4f " +
      s"-fall_from [get_ports ${relatedClk.get}] -to [get_ports $$b] -hold"
    if (p.redArch == RedundancyArch.Coding) {
      sdc += f"  set_data_check ${-p.dtxMax - p.tj - p.tPeriod / 2}%.4f " +
        s"-fall_from [get_ports TXCKR${clkIdx}] -to [get_ports $$b] -setup"
      sdc += f"  set_data_check ${p.dtxMin - p.tj + p.tPeriod * 1.5}%.4f " +
        s"-fall_from [get_ports TXCKR${clkIdx}] -to [get_ports $$b] -hold"
    }
    sdc += "}"
    // Constrain rise vs. fall delay using pulse width check
    sdc += f"set_min_pulse_width ${p.tPeriod + p.tj - p.jpw / 2}%.4f [get_ports $$bumps]"
    // Set output load.
    // TODO: bump tech dependent
    sdc += f"set_load 0.04 [get_ports $$bumps]"
    // Set output transition.
    // TODO: SI dependent
    sdc += f"set_min_transition ${p.tPeriod/10}%.4f [get_ports $$bumps]"
    sdc += f"set_max_transition ${p.tPeriod/6}%.4f [get_ports $$bumps]"
    // Set lane-to-lane skew
    sdc += f"""# Tx lane-to-lane skew for clock domain ${relatedClk.get}
      |foreach p1 $$bumps {
      |  foreach p2 $$bumps {
      |    if {$$p1 ne $$p2} {
      |      set_data_check ${-p.skew - p.tj}%.4f -from [get_ports $$p1] -to [get_ports $$p2]
      |    }
      |  }
      |}""".stripMargin
    // Return
    sdc.mkString("\n")
  }
}
/** Receive data bump
  * @param bumpNum is the signal bump number
  * @param clkIdx is the related clock index
  * @param sig is the core signal (required if not coded or shifted)
  */
case class RxSig(bumpNum: Int, clkIdx: Int, sig: Option[I3DCore]) extends I3DBump {
  val bumpName = if (sig.isDefined) s"RXDATA${bumpNum}" else s"RXRED${bumpNum}"
  override val relatedClk = Some(s"RXCKP${clkIdx}")
  override val coreSig = if (sig.isDefined) sig else None
  override def sdcConstraints(shiftCase: Boolean = false, ioCellPath: String = "")
    (implicit p: I3DParams): String = {
    // This is called once per clock domain ($core and $bumps defined globally)
    val sdc = ArrayBuffer(s"# Rx data constraints in clock domain ${relatedClk.get}")
    // Bump input delay
    sdc += f"set_input_delay ${p.drxMax}%.4f " +
      s"-clock [get_clocks ${relatedClk.get}] " +
      s"-max [get_ports $$bumps] -add_delay"  // setup
    sdc += f"set_input_delay ${p.drxMin}%.4f " +
      s"-clock [get_clocks ${relatedClk.get}] " +
      s"-min [get_ports $$bumps] -add_delay"  // hold
    if (p.redArch == RedundancyArch.Coding) {
      sdc += f"set_input_delay ${p.drxMax}%.4f " +
        s"-clock [get_clocks RXCKR${clkIdx}] " +
        s"-max [get_ports $$bumps] -add_delay"  // setup
      sdc += f"set_input_delay ${p.drxMin}%.4f " +
        s"-clock [get_clocks RXCKR${clkIdx}] " +
        s"-min [get_ports $$bumps] -add_delay"  // hold
    }
    // Input transition. Matches Tx output transition.
    sdc += f"set_input_transition -min ${p.tPeriod/10}%.4f [get_ports $$bumps]"
    sdc += f"set_input_transition -max ${p.tPeriod/6}%.4f [get_ports $$bumps]"
    // Core output delay
    // Omitted if module is redundant.
    if (!modCoord.isRedundant) {
      sdc += f"set_output_delay ${p.tPeriod/2}%.4f " +
        s"-clock [get_clocks out_${relatedClk.get}] " +
        s"-max [get_ports $$core] -add_delay"  // setup
      sdc += f"set_output_delay 0 -clock [get_clocks out_${relatedClk.get}] " +
        s"-min [get_ports $$core] -add_delay"  // hold
      // Core max capacitance
      // TODO: tech dependent
      sdc += f"set_max_capacitance 0.01 [get_ports $$core]"
      // Set lane-to-lane skew
      sdc += f"""# Rx lane-to-lane skew for clock domain ${relatedClk.get}
        |foreach p1 $$core {
        |  foreach p2 $$core {
        |    if {$$p1 ne $$p2} {
        |      set_data_check ${-p.skew - p.tj}%.4f -from [get_ports $$p1] -to [get_ports $$p2]
        |    }
        |  }
        |}""".stripMargin
    }
    // Return
    sdc.mkString("\n")
  }
}
/** Transmit clock bump
  * @param modNum is the linear module index
  * @param coded is true if this clock bump is coded
  * @param shifted is true if this clock bump is in last shifted module
  */
case class TxClk(modNum: Int, coded: Boolean, shifted: Boolean) extends I3DBump {
  val bumpName = if (coded) s"TXCKR${modNum}" else s"TXCKP${modNum}"
  override val coreSig =
    if (coded || shifted) None
    else Some(I3DCore(s"TXCKP${modNum}", Some(modNum), Output(Clock()), None))
  override def sdcConstraints(shiftCase: Boolean, ioCellPath: String = "")
    (implicit p: I3DParams): String = {
    // This is called for each clock
    val sdc = ArrayBuffer(s"# Constraints for clock $bumpName")
    // Create clocks (order matters!)
    val isShiftedClk = (shiftCase && !modCoord.isDirect) || (!shiftCase && modCoord.isRedundant)
    if (!coded) {
      if (!shifted) {  // Redundant modules have no input clocks
        // Core input clock
        sdc += f"create_clock [get_ports clocks_$bumpName] -name $bumpName -period ${p.tPeriod}%.4f"
        sdc += f"set_clock_uncertainty ${p.tj}%.4f [get_clocks $bumpName]"
      }
      // Generated clock source depends on case analysis in shifting redundancy
      // Note redundancy modules' generated clocks don't have a true source (tools will report 0 latency)
      val srcClk = if (isShiftedClk)
        bumpName.replace(modNum.toString, (modNum - p.redMods).toString)
        else bumpName
      sdc ++= Seq(
        // Clock to data IO cells
        s"create_generated_clock -name io_$bumpName -source [get_ports clocks_$srcClk] " +
          s"-divide_by 1 [get_pins */clksToTx_$modNum]",
        f"set_clock_uncertainty ${p.tj}%.4f [get_clocks io_$bumpName]",
        // Direct clock to bump
        s"create_generated_clock -name out_$bumpName -source [get_ports clocks_$srcClk] " +
          s"-divide_by 1 [get_ports $bumpName]",
        f"set_clock_uncertainty ${p.tj}%.4f [get_clocks out_$bumpName]"
      )
    } else {
      // Direct clock to bump (source is non-redundant input clock)
      sdc += s"create_generated_clock -name out_$bumpName -source [get_ports clocks_TXCKP${modNum}] " +
        s"-divide_by 1 [get_ports $bumpName]"
      sdc += f"set_clock_uncertainty ${p.tj}%.4f [get_clocks out_$bumpName]"
    }
    // Set clock latency for synthesis
    // For shift redundancy, depends on case analysis
    // Add 2-module latency for shifted-to modules
    val lat = (p.pinSide match {
      case "N" => (p.modRowsWR - modCoord.y + 0.5) * p.modDelay
      case "S" => (modCoord.y + 1.5) * p.modDelay
      case "E" => (p.modColsWR - modCoord.x + 0.5) * p.modDelay
      case "W" => (modCoord.x + 1.5) * p.modDelay
    }) + (if (isShiftedClk) 2 * p.modDelay else 0.0)
    if (!coded) {
      sdc += f"set_clock_latency -min ${lat * 0.9}%.4f [get_clocks io_$bumpName]"
      sdc += f"set_clock_latency -max ${lat * 1.1}%.4f [get_clocks io_$bumpName]"
    }
    sdc += f"set_clock_latency -min ${lat * 0.9}%.4f [get_clocks out_$bumpName]"
    sdc += f"set_clock_latency -max ${lat * 1.1}%.4f [get_clocks out_$bumpName]"
    // Set clock skew. May not be supported by all tools.
    if (!coded)
      sdc += f"set_clock_skew ${p.skew/2}%.4f [get_clocks io_$bumpName]"
    // Constrain output duty cycle distortion with pulse width constraint
    sdc += f"set_min_pulse_width ${p.tPeriod * 0.48 + p.tj}%.4f [get_ports $bumpName]"
    // Set output load.
    // TODO: bump tech dependent
    sdc += f"set_load 0.04 [get_ports $bumpName]"
    // Set output transition.
    // TODO: SI dependent
    sdc += f"set_min_transition ${p.tPeriod/10}%.4f [get_ports $bumpName]"
    sdc += f"set_max_transition ${p.tPeriod/6}%.4f [get_ports $bumpName]"
    // Return
    sdc.mkString("\n")
  }
}
/** Receive clock bump
  * @param modNum is the linear module index
  * @param coded is true if this clock bump is coded
  * @param shifted is true if this clock bump is in last shifted module
  */
case class RxClk(modNum: Int, coded: Boolean, shifted: Boolean) extends I3DBump {
  val bumpName = if (coded) s"RXCKR${modNum}" else s"RXCKP${modNum}"
  override val coreSig =
    if (coded || shifted) None
    else Some(I3DCore(s"RXCKP${modNum}", Some(modNum), Input(Clock()), None))
  override def sdcConstraints(shiftCase: Boolean = false, ioCellPath: String)
    (implicit p: I3DParams): String = {
    // This is called for each clock
    val sdc = ArrayBuffer(s"# Constraints for clock $bumpName")
    // Create clocks (order matters!)
    val isShiftedClk = shiftCase && !modCoord.isRedundant
    sdc ++= Seq(
      // Bump clock
      f"create_clock [get_ports $bumpName] -name $bumpName -period ${p.tPeriod}%.4f",
      f"set_clock_uncertainty ${p.tj}%.4f [get_clocks $bumpName]",
      // Inverted IO cell output clock
      //s"create_generated_clock -name $bumpName -source [get_ports $bumpName] " +
      //  s"-divide_by 1 -invert [get_pins *$ioCellPath/io_rxClk]",
      //f"set_clock_uncertainty ${p.tj}%.4f [get_clocks $bumpName]"
    )
    if (!coded) {
      // Clock to data IO cells
      sdc += s"create_generated_clock -name io_$bumpName -source [get_ports $bumpName] " +
        s"-divide_by 1 -invert [get_pins */clksToRx_$modNum]"
      sdc += f"set_clock_uncertainty ${p.tj}%.4f [get_clocks io_$bumpName]"
      val srcClk = if (isShiftedClk)
        bumpName.replace(modNum.toString, (modNum + p.redMods).toString)
        else bumpName
      if (!shifted) {
        // Direct clock to core
        sdc += s"create_generated_clock -name out_$bumpName -source [get_ports $srcClk] " +
          s"-divide_by 1 -invert [get_ports clocks_$bumpName]"
        sdc += f"set_clock_uncertainty ${p.tj}%.4f [get_clocks out_$bumpName]"
      }
      // Set clock latency for synthesis
      sdc += f"set_clock_latency -min ${p.modDelay * 0.9}%.4f [get_clocks io_$bumpName]"
      sdc += f"set_clock_latency -max ${p.modDelay * 1.1}%.4f [get_clocks io_$bumpName]"
      // For shift redundancy, depends on case analysis
      // Add 2-module latency for shifted-to modules
      val outLat = (p.pinSide match {
        case "N" => (p.modRowsWR - modCoord.y - 0.5) * p.modDelay
        case "S" => (modCoord.y + 0.5) * p.modDelay
        case "E" => (p.modColsWR - modCoord.x - 0.5) * p.modDelay
        case "W" => (modCoord.x + 0.5) * p.modDelay
      }) + (if (isShiftedClk) 2 * p.modDelay else 0.0)
      if (!shifted) {
        sdc += f"set_clock_latency -min ${outLat * 0.9}%.4f [get_clocks out_$bumpName]"
        sdc += f"set_clock_latency -max ${outLat * 1.1}%.4f [get_clocks out_$bumpName]"
      }
      // Set clock skew. May not be supported by all tools.
      sdc += f"set_clock_skew ${p.skew/2}%.4f [get_clocks io_$bumpName]"
      if (!shifted) {
        // Constrain output duty cycle distortion with pulse width constraint
        sdc += f"set_min_pulse_width ${p.tPeriod * 0.48 + p.tj}%.4f [get_ports clocks_$bumpName]"
        // Max capacitance
        // TODO: tech dependent
        sdc += f"set_max_capacitance 0.01 [get_ports clocks_$bumpName]"
      }
    } else {
      // Clock exclusivity for coded Rx clocks
      // TODO: shifted
      sdc += s"set_false_path -from [get_clocks RXCKP${modNum}] -to [get_clocks RXCKR${modNum}]"
      sdc += s"set_false_path -from [get_clocks RXCKR${modNum}] -to [get_clocks RXCKP${modNum}]"
    }
    // Input transition. Matches Tx output transition.
    sdc += f"set_input_transition -min ${p.tPeriod/10}%.4f [get_ports $bumpName]"
    sdc += f"set_input_transition -max ${p.tPeriod/6}%.4f [get_ports $bumpName]"

    // Return
    sdc.mkString("\n")
  }
}