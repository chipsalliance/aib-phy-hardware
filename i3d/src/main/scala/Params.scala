package aib3d

import util.control.Breaks._
import scala.collection.mutable.{ArrayBuffer, LinkedHashMap}
import scala.collection.immutable.ListMap
import scala.math.{pow, sqrt, min, max}

import chisel3._

import chisel3.experimental.{Analog, DataMirror}
import freechips.rocketchip.config._

import aib3d.io._

/** Global AIB3D Parameters
  * These dictate the bump map and spec discretization
  * Following are technology parameters
  * @param pitch is the minimum bond pitch in um
  * @param pitchOvrdH overrides the bond pitch in the horizontal dimension
  * @param pitchOvrdV overrides the bond pitch in the vertical dimension
  * @param maxNode is the largest/oldest tech node (in nm) in the 3D stack (or expected to be compatible with)
  * @param ubOrHb is microbump or hybrid bond
  * @param maxParticleSize is the maximum particle size to be repaired, measured in span (diameter) of bond pitches
  * @param patternOvrd is the bump pattern override for the bump technology
  * @param sigsPerPGOvrdH overrides the max number of signals between P/G bumps in the horizontal (width) dimension
  * @param sigsPerPGOvrdV overrides the max number of signals between P/G bumps in the vertical (height) dimension
  * Following are design parameters
  * @param redundArch is the active data redundancy architecture.
  * 0 = none, 1 = coding, 2 = signal shift
  * @param hasDBI denotes if data bus inversion is implemented with coding redundancy
  * @param deskewArch is the de-skew architecture
  * @param submodSize is the max number of data bits (Tx/Rx, each) in a sub-module
  * @param dataBundle is the data bundle of the leader die
  */
case class AIB3DGlblParams(
  pitch: Double = 10.0,
  pitchOvrdH: Option[Double] = None,
  pitchOvrdV: Option[Double] = None,
  maxNode: Double = 28.0,
  maxParticleSize: Int = 5,
  patternOvrd: Option[String] = None,
  sigsPerPGOvrdH: Option[Int] = None,
  sigsPerPGOvrdV: Option[Int] = None,
  redundArch: Int = 2,
  hasDBI: Boolean = false,
  deskewArch: Int = 0,
  submodSize: Int = 64,
  dataBundle: Bundle) {

  // Checks
  require(pitch >= 1.0 && pitch <= 25.0, "Pitch must be within [1, 25] um")
  if (pitchOvrdH.isDefined) require(pitchOvrdH.get >= pitch && pitchOvrdH.get <= 25.0, "Bad pitchOvrdH")
  if (pitchOvrdV.isDefined) require(pitchOvrdV.get >= pitch && pitchOvrdV.get <= 25.0, "Bad pitchOvrdV")
  require(maxNode <= 28.0, "Max supported tech node is 28nm")
  require(maxParticleSize >= 0, "Can't have negative particle size")
  if (patternOvrd.isDefined) require(patternOvrd.get == "square" || patternOvrd.get == "hex", "Only 'square' or 'hex' for patternOvrd supported")
  if (sigsPerPGOvrdH.isDefined) require(sigsPerPGOvrdH.get >= 1, "Unsupported number of signals between P/G bumps.")
  if (sigsPerPGOvrdV.isDefined) require(sigsPerPGOvrdV.get >= 1, "Unsupported number of signals between P/G bumps.")

  // Process pitch
  val pitchH = pitchOvrdH.getOrElse(pitch)
  val pitchV = pitchOvrdV.getOrElse(pitch)

  // Process array pattern param
  val pattern = patternOvrd.getOrElse(if (pitch <= 9.0) "square" else "hex")

  // Number of continuous signal bumps between power/ground bumps in each dimension
  // TODO: discretize based on pitch
  private val sigsPerPGDefault = 4
  val sigsPerPG = (sigsPerPGOvrdH.getOrElse(sigsPerPGDefault), sigsPerPGOvrdV.getOrElse(sigsPerPGDefault))

  // Checks
  require(redundArch >= 0 && redundArch <= 2, "Only 0, 1, 2 supported for redundArch")
  require(hasDBI ^ !(redundArch == 1), "DBI only supported with coding redundancy")
  require(deskewArch >= 0 && deskewArch <= 2, "Only 0, 1, 2 supported for deskewArch")

  // TODO: submodSize depends on pitch, additional signals, redundancy
  // require(submodSize >= pow(maxParticleSize, 2).toInt, "submodSize too small, must be at least maxParticleSize^2")
}

/** Instance AIB3D Parameters
  * Following are technology parameters
  * @param node is the tech node (in nm) of the instance
  * @param layerPitch is the layer name to pitch (in nm) mapping corresponding to the track pitch on a set of layers for routing.
  * Should be ordered from lowest to highest layer.
  * @param viaKOZRatio is the ratio of the KOZ around S/P/G via stacks to the bond pitch
  * @param bprKOZRatio is the ratio of the backsize power TSV landing KOZ to the bond pitch
  * @param tsvKOZRatio is the ratio of the TSV KOZ to the bond pitch
  * @param faceToStack denotes if the FEOL is facing the rest of the stack (dependent on isLeader)
  * @param powerF is true if power/ground are supplied from/thru the frontside
  * @param powerB is true if power/ground are supplied from/thru the backside
  * Following are design parameters
  * @param isLeader denotes if this instance is the leader in the stack
  * @param orientation is the orientation of the instance, exported as a floorplan constraint.
  * Only "MX" or "MY" supported.
  * @param pinSide is the side of the blocks where pins are to be assigned, pre-mirroring/rotation.
  * One of "N", "S", "E", "W".
  * //TODO: this should probably be specified by the leader?
  * @param baseAddress is the memory-mapped CSR base address
  * @param testProtocol denotes which test protocol is implemented
  * @param blackBoxModels true denotes using behavioral models of all blackboxes
  */
case class AIB3DInstParams (
  node: Double = 10.0,
  layerPitch: Map[String, Double] = Map("M3" -> 100.0),
  viaKOZRatio: Double = 0.15,
  bprKOZRatio: Option[Double] = None,
  tsvKOZRatio: Option[Double] = None,
  faceToStack: Boolean = true,
  powerF: Boolean = true,
  powerB: Boolean = true,
  isLeader: Boolean,
  orientation: Option[String] = None,
  pinSide: String = "N",
  baseAddress: Int = 0x2000,
  testProtocol: String = "IEEE1838",
  blackBoxModels: Boolean = false) {

  // Checks
  require(node <= 28.0, "Max supported tech node is 28nm")
  require(!layerPitch.isEmpty, "layerPitch Map cannot be empty")
  require(viaKOZRatio > 0.0 && viaKOZRatio < 1.0, "viaKOZRatio must be within (0.0, 1.0)")
  if (bprKOZRatio.isDefined) require(bprKOZRatio.get > 0.0 && bprKOZRatio.get < 1.0, "bprKOZRatio must be within (0.0, 1.0)")
  if (tsvKOZRatio.isDefined) require(tsvKOZRatio.get > 0.0 && tsvKOZRatio.get < 1.0, "tsvKOZRatio must be within (0.0, 1.0)")

  require(powerF || powerB, "At least one of powerF or powerB must be true")
  require(faceToStack && powerF, "If faceToStack is true, powerF must be true")
  require(faceToStack || powerB, "If faceToStack is false, powerB must be true")

  if (orientation.isDefined) require(orientation.get == "MX" || orientation.get == "MY", "Only 'MX' or 'MY' supported for orientation")
  require(Set("N","S","E","W").contains(pinSide), "pinSides Set can only be 'N', 'S', 'E', or 'W'")
  require(baseAddress > 0, "baseAddress must be non-negative")
  // TODO: check testProtocol
}

case class AIB3DParams(
  gp: AIB3DGlblParams,
  ip: AIB3DInstParams) {

  // Extract the Tx and Rx IOs
  private val data = if (ip.isLeader) gp.dataBundle else Flipped(gp.dataBundle)
  private val txIOs = data.elements.filter(elt => DataMirror.specifiedDirectionOf(elt._2) == SpecifiedDirection.Output)
  private val rxIOs = data.elements.filter(elt => DataMirror.specifiedDirectionOf(elt._2) == SpecifiedDirection.Input)
  private val numTxIOs = txIOs.map(_._2.getWidth).sum
  private val numRxIOs = rxIOs.map(_._2.getWidth).sum
  // TODO: support unbalanced Tx/Rx IO count
  require(numTxIOs == numRxIOs, "Only balanced Tx/Rx IO count supported at this time.")

  // IO flattening
  private def flattenIOs(orig: ListMap[String, Data]) : Seq[AIB3DCore] = {
    def cloneDirection(d: Data) = DataMirror.specifiedDirectionOf(d) match {
      case SpecifiedDirection.Input => Input(UInt(1.W))
      case SpecifiedDirection.Output => Output(UInt(1.W))
      case _ => throw new Exception("Only Input/Output supported")
    }
    val flat = ArrayBuffer.empty[AIB3DCore]
    for (((sig, data), width) <- (orig zip orig.map(_._2.getWidth))) {
      // Add single bit IOs as-is, otherwise break into individual bits
      if (width > 1) {
        for (i <- (0 until width).reverse) {  // MSB to LSB
          // TODO: support scrambling of bus bits for switching activity distribution
          // Bit indexing can't be done unless it is actually hardware.
          // Thus, we need to copy the direction and make it a 1-bit Data.
          flat += AIB3DCore(sig, Some(i), cloneDirection(data), None)
        }
      } else {
        flat += AIB3DCore(sig, None, data, None)
      }
    }
    flat.toSeq
  }
  private val flatTx = flattenIOs(txIOs)
  private val flatRx = flattenIOs(rxIOs)

  // Some public constants
  // TODO: for coding, need to take the ratio into account...
  val numSubmods = (numTxIOs / gp.submodSize.toDouble).ceil.toInt
  require(numTxIOs % numSubmods == 0, s"Number of IOs (${numTxIOs}) not evenly divisible by derived number of submodules (${numSubmods})")
  val sigsPerSubmod = numTxIOs / numSubmods
  // TODO: allow for more/less than 2 redundant submods, don't require even number
  val redSubmods = if (gp.redundArch == 2) 2 else 0
  require(numSubmods % redSubmods == 0, "Number of submods must be even")
  val isWide = Set("N", "S").contains(ip.pinSide)
  val numSubmodsWR = numSubmods + redSubmods
  // These are total, not Tx/Rx individually
  val (submodRows, submodCols) = if (isWide) (2, numSubmods) else (numSubmods, 2)
  val (submodRowsWR, submodColsWR) = if (isWide) (2, numSubmodsWR) else (numSubmodsWR, 2)

  /** Following is the process of creating the bump map.
    * It is different depending on the redundancy scheme.
    */

  val bumpMap: Array[Array[AIB3DBump]] = if (gp.redundArch != 1) {  // none or signal shift
    /* Submodule calculations */

    // TODO: support non-square submodules?
    // Prioritize least number of bumps
    val rowsSigCandidates = Seq(sqrt(sigsPerSubmod.toDouble).floor.toInt, sqrt(sigsPerSubmod.toDouble).ceil.toInt)
    val colsSigCandidates = rowsSigCandidates.map(r => (sigsPerSubmod / r.toDouble).ceil.toInt)
    val (rowsSig, colsSig) = {
      if (rowsSigCandidates(0) * colsSigCandidates(0) < rowsSigCandidates(1) * colsSigCandidates(1)) {
        (rowsSigCandidates(0), colsSigCandidates(0))
      } else {
        (rowsSigCandidates(1), colsSigCandidates(1))
      }
    }
    val extras = rowsSig * colsSig - sigsPerSubmod

    // There must be an intersection for clock
    // TODO: 1 row or 1 column? Make this 1 if no valid
    val rowsP = min(1, ((rowsSig.toDouble / gp.sigsPerPG._2) - 1).ceil.toInt)
    val colsG = min(1, ((colsSig.toDouble / gp.sigsPerPG._1) - 1).ceil.toInt)
    val rowsPerSubmod = rowsSig + rowsP
    val colsPerSubmod = colsSig + colsG

    // Evenly distribute rowsSig and colsSig between power rows and ground columns
    // To do this, need to make a Seq filled with the quotient, and obtain the remainder
    // Then split the quotient Seq at the remainder position, and add 1 to the first half
    // Then perform binary recursion to evenly diffuse the smaller Seq into the larger
    def spgPatternGen(sigs: Int, pg: Int): Seq[Int] = {
      val splitQuotient = Seq.fill(pg + 1)(sigs / (pg + 1)).splitAt(sigs % (pg + 1))
      def diffuse(l: Seq[Int], s: Seq[Int]): Seq[Int] = {
        val splitL = l.splitAt(l.length / 2)
        if (s.length == 0) l
        else if (s.length == 1) splitL._1 ++ s ++ splitL._2
        else {
          val splitS = s.tail.splitAt(s.tail.length / 2)
          diffuse(splitL._1 ++ s.take(1), splitS._1) ++ diffuse(splitL._2, splitS._2)
        }
      }
      if (splitQuotient._1.length >= splitQuotient._2.length) {
        diffuse(splitQuotient._1.map(_ + 1), splitQuotient._2)
      } else {
        diffuse(splitQuotient._2, splitQuotient._1.map(_ + 1))
      }
    }
    // Get the pattern and the row/column indices of the power/ground
    val spgPatternV = spgPatternGen(rowsSig, rowsP)
    val pRows = spgPatternV.scanLeft(0)(_ + _ + 1).map(_ - 1).tail
    val spgPatternH = spgPatternGen(colsSig, colsG)
    val gCols = spgPatternH.scanLeft(0)(_ + _ + 1).map(_ - 1).tail

    // Calculate which P/G intersections the clock signal will be located
    // It should be as close to the middle as possible and biased towards pin edge
    val biasUL = if (Set("N", "W").contains(ip.pinSide)) 1 else 0
    val clkCoord: (Int, Int) = (colsG % 2 == 0, rowsP % 2 == 0) match {
      case (true, true) => (gCols(colsG / 2 - biasUL), pRows(rowsP / 2 - biasUL))
      case (true, false) => (gCols(colsG / 2 - biasUL), pRows(rowsP / 2))
      case (false, true) => (gCols(colsG / 2), pRows(rowsP / 2 - biasUL))
      case (false, false) => (gCols(colsG / 2), pRows(rowsP / 2))
    }

    // Calculate which positions the extra signals will be located
    // In a circle around the submod, get the cornermost bumps, starting at (0, 0)
    // This method reduces the radius of the clock tree in each submodule
    // Col pattern is 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, etc. and row is reverse (count down)
    // Use recursion to generate this pattern and only take as many entries as necessary
    def extraCoordGen(coords: Seq[(Int, Int)], maxIdx: Int): Seq[(Int, Int)] = {
      if (coords.length >= extras) coords
      else {
        val range = Range(0, maxIdx)
        val nextCoords = (range zip range.reverse).map{ case(c, r) =>
          Seq((c, r), (colsPerSubmod - c, r), (colsPerSubmod - c, rowsPerSubmod - r), (c, rowsPerSubmod - r))
        }.flatten
        extraCoordGen(coords ++ nextCoords, maxIdx + 1)
      }
    }
    val extraCoords = extraCoordGen(Seq.empty, 0).take(extras)

    // Map to bump map
    val txBumpMap, rxBumpMap = Array.ofDim[AIB3DBump](numSubmodsWR, rowsPerSubmod, colsPerSubmod)
    var bitCnt = 0
    for (s <- 0 until numSubmodsWR) {
      for (r <- 0 until rowsPerSubmod; c <- 0 until colsPerSubmod) {
        breakable {
          // Clock
          if (clkCoord == (c, r)) {
            txBumpMap(s)(r)(c) = TxClk(s)
            rxBumpMap(s)(r)(c) = RxClk(s)
            break
          }

          // Grounds. Extra gets set to ground too
          if (gCols.contains(c) || extraCoords.contains((c, r))) {
            txBumpMap(s)(r)(c) = Gnd()
            rxBumpMap(s)(r)(c) = Gnd()
            break
          }

          // Power
          if (pRows.contains(r)) {
            txBumpMap(s)(r)(c) = Pwr()
            rxBumpMap(s)(r)(c) = Pwr()
            break
          }

          // Signal
          txBumpMap(s)(r)(c) = TxSig(bitCnt,
            if (s < numSubmods) Some(flatTx(bitCnt).copy(relatedClk = Some(s"TXCKP$s"))) else None )
          rxBumpMap(s)(r)(c) = RxSig(bitCnt,
            if (s < numSubmods) Some(flatRx(bitCnt).copy(relatedClk = Some(s"RXCKP$s"))) else None )
          bitCnt += 1
        }
      }
      if (s == numSubmods - 1) bitCnt = 0  // reset bit count for redundant submods
    }

    // Concatenate bump maps then generate the correct ordering of submodule origins
    // Depending on pin side, the rows/cols of submods are different
    // Note the number of modules in the longer dimension is doubled since Tx and Rx are separate for now
    val concatenated = Array(txBumpMap, rxBumpMap).flatten
    // Ordering of submodules
    // TODO: support more/less than 2 rows/cols of submods
    val submodOrigins = {
      if (isWide) {  // Tx left of Rx
        ((0 until submodColsWR by 2) ++ (1 until submodColsWR by 2)).flatMap(c => (0 until submodRowsWR).map(r =>
          (r*(rowsPerSubmod+1), c*(colsPerSubmod+1))))
      } else {  // Tx under Rx
        ((0 until submodRowsWR by 2) ++ (1 until submodRowsWR by 2)).flatMap(r => (0 until submodColsWR).map(c =>
          (r*(rowsPerSubmod+1), c*(colsPerSubmod+1))))
      }
    }
    require(submodOrigins.length == concatenated.length, "Error in Tx/Rx submodule to full module mapping.")

    // Flatten submodules into final map
    // Dimensions of final map account for extra rows/cols of ground between each Tx/Rx submodule
    // Submodule index tag is added to each bump for submodule redundancy mapping
    val (finalRows, finalCols) = (submodRowsWR * (rowsPerSubmod + 1) - 1, submodColsWR * (colsPerSubmod + 1) - 1)
    val finalMap = Array.ofDim[AIB3DBump](finalRows, finalCols)
    submodOrigins.zipWithIndex.foreach { case ((r, c), s) =>
      for (sr <- 0 until rowsPerSubmod; sc <- 0 until colsPerSubmod) {
        finalMap(r + sr)(c + sc) = concatenated(s)(sr)(sc)
        finalMap(r + sr)(c + sc).submodIdx = Some(AIB3DCoordinates[Int](x = c / (colsPerSubmod + 1), y = r / (rowsPerSubmod + 1)))
      }
    }
    // Add rows/cols of ground
    // Permute the submodRowsWR and submodColsWR together
    (1 until submodRowsWR).flatMap(r => (0 until finalCols).map(c => (r * (rowsPerSubmod + 1) - 1, c))) ++
    (1 until submodColsWR).flatMap(c => (0 until finalRows).map(r => (r, c * (colsPerSubmod + 1) - 1))) foreach {
      case(r, c) => finalMap(r)(c) = Gnd()
    }

    // Calculate location
    // TODO: should we just ignore tech grids and let the tools snap coordinates or use BigDecimal?
    for (r <- 0 until finalRows; c <- 0 until finalCols) {
      // Update coordinates using calculated pitch. Assume 0.5 * pitch to each edge. Can offset later.
      finalMap(r)(c).location = Some(AIB3DCoordinates[Double](x = (c + 0.5) * gp.pitchH, y = (r + 0.5) * gp.pitchV))
    }

    // Calculate pin locations
    // TODO: calculate how many layers + min pitch or not for each
    // TODO: should we just assume that the tools have intelligent pin spreading?

    // Return
    finalMap

  } else {  // coding
    Array.ofDim[AIB3DBump](1, 1)
  }

  val flatBumpMap : Seq[AIB3DBump] = bumpMap.flatten.toSeq
  // Check
  require(!flatBumpMap.contains(null), "Error in final bump map creation!")

}