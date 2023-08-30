package aib3d

import util.control.Breaks._
import scala.collection.mutable.ArrayBuffer
import scala.collection.immutable.SeqMap
import scala.math.{pow, sqrt, min, max}

import chisel3._

import chisel3.experimental.DataMirror

import aib3d.io._

/** Global AIB3D Parameters
  * These dictate the bump map and spec discretization
  * Following are technology parameters
  * @param pitch is the minimum bond pitch in um
  * @param pitchOvrdH overrides the bond pitch in the horizontal dimension
  * @param pitchOvrdV overrides the bond pitch in the vertical dimension
  * @param maxNode is the largest/oldest tech node (in nm) in the 3D stack
  * (or expected to be compatible with)
  * @param ubOrHb is microbump or hybrid bond
  * @param maxParticleSize is the maximum particle size to be repaired,
  * measured in span (diameter) of bond pitches
  * @param patternOvrd is the bump pattern override for the bump technology
  * @param sigsPerPGOvrdH overrides the max number of signals between P/G bumps
  * in the horizontal (width) dimension
  * @param sigsPerPGOvrdV overrides the max number of signals between P/G bumps
  * in the vertical (height) dimension
  * Following are design parameters
  * @param redundArch is the active data redundancy architecture.
  * 0 = none, 1 = coding, 2 = signal shift
  * @param redundRatio is the redundancy ratio (default: 4).
  * Denotes the number of signal bumps per redundant bump.
  * @param hasDBI denotes if data bus inversion is implemented with coding redundancy
  * @param deskewArch is the de-skew architecture
  * @param submodSize is the max number of data bits (Tx/Rx, each) in a sub-module
  * @param pinSide is the side where pins are to be assigned, pre-mirroring/rotation.
  * One of "N", "S", "E", "W".
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
  redundRatio: Int = 4,
  hasDBI: Boolean = false,
  deskewArch: Int = 0,
  submodSize: Int = 64,
  pinSide: String = "N",
  dataBundle: Bundle) {

  // Checks
  require(pitch >= 1.0 && pitch <= 25.0, "Pitch must be within [1, 25] um")
  if (pitchOvrdH.isDefined)
    require(pitchOvrdH.get > pitch && pitchOvrdH.get <= 25.0,
    "Bad pitchOvrdH: must be greater than pitch if specified")
  if (pitchOvrdV.isDefined)
    require(pitchOvrdV.get > pitch && pitchOvrdV.get <= 25.0,
    "Bad pitchOvrdV: must be greater than pitch if specified")
  require(maxNode <= 28.0, "Max supported tech node is 28nm")
  require(maxParticleSize >= 0, "Can't have negative particle size")
  if (patternOvrd.isDefined)
    require(Set("square", "hex").contains(patternOvrd.get),
    "Only 'square' or 'hex' for patternOvrd supported")
  if (sigsPerPGOvrdH.isDefined)
    require(sigsPerPGOvrdH.get >= 1,
    "Unsupported number of signals between P/G bumps.")
  if (sigsPerPGOvrdV.isDefined)
    require(sigsPerPGOvrdV.get >= 1,
    "Unsupported number of signals between P/G bumps.")

  // Process pitch
  val pitchH = pitchOvrdH.getOrElse(pitch)
  val pitchV = pitchOvrdV.getOrElse(pitch)

  // Process array pattern param
  val pattern = patternOvrd.getOrElse(if (pitch <= 10.0) "square" else "hex")

  // Number of continuous signal bumps between power/ground bumps in each dimension
  // TODO: discretize based on pitch
  private val sigsPerPGDefault = 4
  val sigsPerPG = (sigsPerPGOvrdH.getOrElse(sigsPerPGDefault),
                   sigsPerPGOvrdV.getOrElse(sigsPerPGDefault))

  // Checks
  require(redundArch >= 0 && redundArch <= 2, "Only 0, 1, 2 supported for redundArch")
  require(redundRatio >= 1, "Redundancy ratio must be a positive integer")
  require(hasDBI ^ !(redundArch == 1), "DBI only supported with coding redundancy")
  require(deskewArch >= 0 && deskewArch <= 2, "Only 0, 1, 2 supported for deskewArch")
  require(Set("N","S","E","W").contains(pinSide),
    "pinSides Set can only be 'N', 'S', 'E', or 'W'")

  // TODO: submodSize depends on pitch, additional signals, redundancy
  // require(submodSize >= pow(maxParticleSize, 2).toInt,
  //   "submodSize too small, must be at least maxParticleSize^2")
}

/** Instance AIB3D Parameters
  * Following are technology parameters
  * @param node is the tech node (in nm) of the instance
  * @param layerPitch is the layer name to pitch (in nm) mapping corresponding
  * to the track pitch on a set of layers for routing.
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
  * @param bumpOffset is the offset of the bump array from the pin edge
  * @param baseAddress is the memory-mapped CSR base address
  * @param testProtocol denotes which test protocol is implemented
  * @param blackBoxModels true denotes using behavioral models of all blackboxes
  */
case class AIB3DInstParams (
  node: Double = 10.0,
  layerPitch: Map[String, Double] = Map("M3" -> 100.0, "M5" -> 200.0),
  viaKOZRatio: Double = 0.15,
  bprKOZRatio: Option[Double] = None,
  tsvKOZRatio: Option[Double] = None,
  faceToStack: Boolean = true,
  powerF: Boolean = true,
  powerB: Boolean = true,
  isLeader: Boolean,
  orientation: Option[String] = None,
  pinSide: Option[String] = None,
  bumpOffset: Double = 0.0,
  baseAddress: Int = 0x2000,
  testProtocol: String = "IEEE1838",
  blackBoxModels: Boolean = false) {

  // Checks
  require(node <= 28.0, "Max supported tech node is 28nm")
  require(!layerPitch.isEmpty, "layerPitch Map cannot be empty")
  require(viaKOZRatio > 0.0 && viaKOZRatio < 1.0, "viaKOZRatio must be within (0.0, 1.0)")
  if (bprKOZRatio.isDefined)
    require(bprKOZRatio.get > 0.0 && bprKOZRatio.get < 1.0,
    "bprKOZRatio must be within (0.0, 1.0)")
  if (tsvKOZRatio.isDefined)
    require(tsvKOZRatio.get > 0.0 && tsvKOZRatio.get < 1.0,
    "tsvKOZRatio must be within (0.0, 1.0)")

  require(powerF || powerB, "At least one of powerF or powerB must be true")
  require(faceToStack && powerF, "If faceToStack is true, powerF must be true")
  require(faceToStack || powerB, "If faceToStack is false, powerB must be true")

  if (orientation.isDefined)
    require(orientation.get == "MX" || orientation.get == "MY",
    "Only 'MX' or 'MY' supported for orientation")
  if (pinSide.isDefined)
    require(Set("N","S","E","W").contains(pinSide.get),
    "pinSides Set can only be 'N', 'S', 'E', or 'W'")
  require(baseAddress > 0, "baseAddress must be non-negative")
  // TODO: check testProtocol
}

case class AIB3DParams(
  gp: AIB3DGlblParams,
  ip: AIB3DInstParams) {

  // Extract the Tx and Rx IOs
  private val data = if (ip.isLeader) gp.dataBundle else Flipped(gp.dataBundle)
  private val txIOs = data.elements.filter(elt =>
    DataMirror.specifiedDirectionOf(elt._2) == SpecifiedDirection.Output)
  private val rxIOs = data.elements.filter(elt =>
    DataMirror.specifiedDirectionOf(elt._2) == SpecifiedDirection.Input)
  private val numTxIOs = txIOs.map(_._2.getWidth).sum
  private val numRxIOs = rxIOs.map(_._2.getWidth).sum
  // TODO: support unbalanced Tx/Rx IO count
  require(numTxIOs == numRxIOs, "Only balanced Tx/Rx IO count supported at this time.")

  // IO flattening
  private def flattenIOs(orig: SeqMap[String, Data]) : Seq[AIB3DCore] = {
    def cloneDirection(d: Data) = DataMirror.specifiedDirectionOf(d) match {
      case SpecifiedDirection.Input => Input(UInt(1.W))
      case SpecifiedDirection.Output => Output(UInt(1.W))
      case _ => throw new Exception("Only Input/Output supported")
    }
    val flat = ArrayBuffer.empty[AIB3DCore]
    for (((sig, data), width) <- (orig zip orig.map(_._2.getWidth))) {
      // Add single bit IOs as-is, otherwise break into individual bits
      if (width > 1)
        for (i <- (0 until width).reverse) {  // MSB to LSB
          // TODO: support scrambling of bus bits for switching activity distribution
          // Bit indexing can't be done unless it is actually hardware.
          // Thus, we need to copy the direction and make it a 1-bit Data.
          flat += AIB3DCore(sig, Some(i), cloneDirection(data), None)
        }
      else
        flat += AIB3DCore(sig, None, data, None)
    }
    flat.toSeq
  }
  private val flatTx = flattenIOs(txIOs)
  private val flatRx = flattenIOs(rxIOs)

  // Some public constants
  // TODO: for coding, need to take the ratio into account...
  val numSubmods = (numTxIOs / gp.submodSize.toDouble).ceil.toInt
  require(numTxIOs % numSubmods == 0,
    s"Number of IOs (${numTxIOs}) not evenly divisible by derived number of submodules (${numSubmods})")
  val sigsPerSubmod = numTxIOs / numSubmods
  // TODO: allow for more/less than 2 redundant submods, don't require even number
  val redSubmods = if (gp.redundArch == 2) numSubmods / gp.redundRatio else 0
  if (redSubmods > 0) require(numSubmods % redSubmods == 0,
    s"Number of signal submods (${numSubmods}) must be evenly divisible by number of redundant submods (${redSubmods})")
  // TODO: fix this: determined globally
  val isWide = Set("N", "S").contains(gp.pinSide)
  val pinSide = if (ip.pinSide.isDefined) ip.pinSide.get else gp.pinSide
  val numSubmodsWR = numSubmods + redSubmods
  // These are total, not Tx/Rx individually
  // If no redundancy, want to find the most "square" arrangement from the factor pairs of numSubmods
  // Else, shorter dimension is determined by the number of redundant submods
  val (submodRows, submodCols) =
    if (gp.redundArch == 2)
      if (isWide) (redSubmods, numSubmods / redSubmods * 2)
      else (numSubmods / redSubmods * 2, redSubmods)
    else {
      // Find factor pairs, and return the most "square" one
      // This still works if numSubmods is a square number
      val bestFactor = (1 to sqrt(numSubmods).toInt).filter(numSubmods % _ == 0).last
      if (isWide) (bestFactor, numSubmods / bestFactor)  // wide
      else (numSubmods / bestFactor, bestFactor)  // tall
    }
  val (submodRowsWR, submodColsWR) =
    if (gp.redundArch == 2)
      if (isWide) (redSubmods, submodCols + 2) else (submodRows + 2, redSubmods)
    else (submodRows, submodCols)

  /** Following is the process of creating the bump map.
    * It is different depending on the redundancy scheme.
    */

  val bumpMap: Array[Array[AIB3DBump]] = if (gp.redundArch != 1) {  // none or signal shift
    /* Submodule calculations */

    // Prioritize least number of bumps
    // Choose the ordering with fewer bumps facing pin edge
    // TODO: is this the right decision?
    val rowsSigOpts = Seq(sqrt(sigsPerSubmod.toDouble).floor.toInt,
                                sqrt(sigsPerSubmod.toDouble).ceil.toInt)
    val colsSigOpts = rowsSigOpts.map(r =>
      (sigsPerSubmod / r.toDouble).ceil.toInt)
    val (rowsSig, colsSig) = {
      if (rowsSigOpts(0) * colsSigOpts(0) < rowsSigOpts(1) * colsSigOpts(1))
        if (isWide) (colsSigOpts(0), rowsSigOpts(0))
        else (rowsSigOpts(0), colsSigOpts(0))
      else
        if (isWide) (rowsSigOpts(1), colsSigOpts(1))
        else (colsSigOpts(1), rowsSigOpts(1))
    }
    val extras = rowsSig * colsSig - sigsPerSubmod

    // There must be an intersection for clock
    val rowsP = ((rowsSig.toDouble / gp.sigsPerPG._2) - 1).ceil.toInt + 1
    val colsG = ((colsSig.toDouble / gp.sigsPerPG._1) - 1).ceil.toInt + 1
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
      if (splitQuotient._1.length >= splitQuotient._2.length)
        diffuse(splitQuotient._1.map(_ + 1), splitQuotient._2)
      else
        diffuse(splitQuotient._2, splitQuotient._1.map(_ + 1))
    }
    // Get the pattern and the row/column indices of the power/ground
    // At the edges, the signals virtually spill over into adjacent submods
    // So we must add sigsPerPG to the pattern gen then subtract half when we
    // calculate the indicies of pRows and gCols
    val spgPatternV = spgPatternGen(rowsSig + gp.sigsPerPG._2, rowsP)
    val pRows = spgPatternV.scanLeft(0)(_ + _ + 1)
                .map(_ - 1 - gp.sigsPerPG._2/2)
                .drop(1).dropRight(1)
    val spgPatternH = spgPatternGen(colsSig + gp.sigsPerPG._1, colsG)
    val gCols = spgPatternH.scanLeft(0)(_ + _ + 1)
                .map(_ - 1 - gp.sigsPerPG._1/2)
                .drop(1).dropRight(1)

    // Calculate which P/G intersections the clock signal will be located
    // It should be as close to the middle as possible and biased towards pin edge
    // TODO: should really be on the center-most power/ground row/col, which
    // is not necessarily an intersection
    val biasLL = if (Set("S", "W").contains(gp.pinSide)) 1 else 0
    val clkCoord: (Int, Int) = (colsG % 2 == 0, rowsP % 2 == 0) match {
      case (true, true) => (gCols(colsG / 2 - biasLL), pRows(rowsP / 2 - biasLL))
      case (true, false) => (gCols(colsG / 2 - biasLL), pRows(rowsP / 2))
      case (false, true) => (gCols(colsG / 2), pRows(rowsP / 2 - biasLL))
      case (false, false) => (gCols(colsG / 2), pRows(rowsP / 2))
    }

    // Calculate which positions the extra signals will be located.
    // In a counter-clockwise circle, get the cornermost bumps, starting at (0, 0)
    // Then reorder based on which side the pin is on (prioritize farther ones).
    // This method reduces the radius of the clock tree in each submodule
    // while decreasing the total length of routing to all IO cells.
    // For ranges: col pattern is (0), (0, 1), (0, 1, 2), (0, 1, 2, 3), etc.
    // and row is reverse (count down within each of those groups in col pattern).
    // We must also adjust for any rows/cols of power/ground.
    // Use recursion to generate this pattern and take as many entries as necessary.
    val sideDropTake = gp.pinSide match{
      case "N" => 0
      case "W" => 1
      case "S" => 2
      case "E" => 3
    }
    val extraCoords = (1 to (extras / 4.0).ceil.toInt)  // recursion
      .foldLeft(Seq.empty[(Int, Int)]){ case (coords, e) =>
        val range = Range(0, e)
        val nextCoords = (range zip range.reverse).map{ case(c, r) =>
          val cAdjUp = gCols.indexWhere(c >= _) + 1
          val cAdjDown = gCols.reverse.indexWhere(colsPerSubmod - c - 1 <= _) + 2
          val rAdjUp = pRows.indexWhere(r >= _) + 1
          val rAdjDown = pRows.reverse.indexWhere(rowsPerSubmod - r - 1 <= _) + 2
          val ord = Seq((c + cAdjUp, r + rAdjUp),
                        (colsPerSubmod - c - cAdjDown, r + rAdjUp),
                        (colsPerSubmod - c - cAdjDown, rowsPerSubmod - r - rAdjDown),
                        (c + cAdjUp, rowsPerSubmod - r - rAdjDown))
          ord.drop(sideDropTake) ++ ord.take(sideDropTake)
        }.flatten
        coords ++ nextCoords
      }.take(extras)

    // Map to bump map
    val txBumpMap, rxBumpMap = Array.ofDim[AIB3DBump](numSubmodsWR, rowsPerSubmod, colsPerSubmod)
    var bitCnt = 0
    for (s <- 0 until numSubmodsWR) {
      for (r <- 0 until rowsPerSubmod; c <- 0 until colsPerSubmod) {
        breakable {
          // Clock
          if (clkCoord == (c, r)) {
            txBumpMap(s)(r)(c) = TxClk(s, s >= numSubmods)
            rxBumpMap(s)(r)(c) = RxClk(s, s >= numSubmods)
            break()
          }

          // Grounds. Extra gets set to ground too
          if (gCols.contains(c) || extraCoords.contains((c, r))) {
            txBumpMap(s)(r)(c) = Gnd()
            rxBumpMap(s)(r)(c) = Gnd()
            break()
          }

          // Power
          if (pRows.contains(r)) {
            txBumpMap(s)(r)(c) = Pwr()
            rxBumpMap(s)(r)(c) = Pwr()
            break()
          }

          // Signal
          txBumpMap(s)(r)(c) = TxSig(bitCnt, if (s < numSubmods)
            Some(flatTx(bitCnt).copy(relatedClk = Some(s"TXCKP$s"))) else None)
          rxBumpMap(s)(r)(c) = RxSig(bitCnt, if (s < numSubmods)
            Some(flatRx(bitCnt).copy(relatedClk = Some(s"RXCKP$s"))) else None)
          bitCnt += 1
        }
      }
      if (s == numSubmods - 1) bitCnt = 0  // reset bit count for redundant submods
    }

    // Concatenate bump maps then generate the correct ordering of submodule origins
    // Depending on pin side, the rows/cols of submods are different
    // Note modules in the longer dimension is doubled since Tx and Rx are separate
    val concatenated = Array(txBumpMap, rxBumpMap).flatten
    // Ordering of submodules
    // TODO: support more/less than 2 rows/cols of submods
    val submodOrigins = {
      if (isWide)  // Tx left of Rx
        ((0 until submodColsWR by 2) ++ (1 until submodColsWR by 2)).flatMap(c =>
          (0 until submodRowsWR).map(r =>
            (r * rowsPerSubmod, c * colsPerSubmod)))
      else  // Tx under Rx
        ((0 until submodRowsWR by 2) ++ (1 until submodRowsWR by 2)).flatMap(r =>
          (0 until submodColsWR).map(c =>
            (r * rowsPerSubmod, c * colsPerSubmod)))
    }
    require(submodOrigins.length == concatenated.length,
      "Error in Tx/Rx submodule to full module mapping.")

    // Flatten submodules into final map
    // Submodule index tag is added to each bump for submodule redundancy mapping
    val finalRows = submodRowsWR * rowsPerSubmod
    val finalCols = submodColsWR * colsPerSubmod
    val finalMap = Array.ofDim[AIB3DBump](finalRows, finalCols)
    submodOrigins.zipWithIndex.foreach { case ((r, c), s) =>
      for (sr <- 0 until rowsPerSubmod; sc <- 0 until colsPerSubmod) {
        finalMap(r + sr)(c + sc) = concatenated(s)(sr)(sc)
        finalMap(r + sr)(c + sc).submodIdx =
          Some(AIB3DCoordinates[Int](
            x = c / colsPerSubmod,
            y = r / rowsPerSubmod))
      }
    }

    // Calculate bump/iocell location
    // TODO: ignore tech grids and let the tools snap or use BigDecimal?
    for (r <- 0 until finalRows; c <- 0 until finalCols) {
      // Update coordinates using calculated pitch.
      // Assume 0.5 * pitch to each edge. Can offset later.
      finalMap(r)(c).location =
        Some(AIB3DCoordinates[Double](
          x = (c + 0.5) * gp.pitchH,
          y = (r + 0.5) * gp.pitchV))
    }

    // Calculate pin locations
    // Check for available routing resources
    // Assume 20% power assumption + 50% shielding/space penalty
    val routingTracks = ip.layerPitch.map{ case(layer, pitch) =>
      layer -> (gp.pitch / pitch * 1000).floor.toInt}
    val sumTracks = routingTracks.map(_._2).sum
    val reqdSigs =
      if (Set("E", "W").contains(pinSide)) colsSig * submodCols
      else rowsSig * submodRows
    require(sumTracks * 0.4 >= reqdSigs,
      s"""Not enough routing tracks on pin side (${pinSide}).
      ${reqdSigs} tracks requested but only ${sumTracks} available.""")
    // Query bumps with core signals in each row/col depending on pinSide
    val coreSigs = (if (isWide) finalMap.transpose else finalMap).map{
      _.filter(_.coreSig.isDefined).map(_.coreSig.get)}
    // Spread signals out evenly across all layers,
    // starting from the lowest layer in the middle of the row/column
    // Assume that tools will snap to track
    val pinOffsetsPos = routingTracks.map{ case(layer, tracks) =>
      (0 until tracks / 2).map( t => (t * ip.layerPitch(layer) / 1000, layer))
      }.flatten.grouped(sumTracks / reqdSigs).map(_.head).toSeq
    val pinOffsetsNeg = pinOffsetsPos.map{ case(os, lay) => (-os, lay)}.toSeq
    val pinOffsets: Seq[(Double, String)] = pinSide match {
      case "N" | "E" =>  // reverse (farthest I/O appears first)
        Seq(pinOffsetsPos.reverse, pinOffsetsNeg.reverse).transpose.flatten
      case _ => Seq(pinOffsetsPos, pinOffsetsNeg).transpose.flatten.tail
    }
    coreSigs.zipWithIndex.foreach{ case (grp, i) =>
      (grp zip pinOffsets.take(grp.length)).foreach{ case (sig, (os, lay)) =>
        sig.pinLayer = Some(lay)
        sig.pinLocation = pinSide match {
          case "W" => Some(AIB3DCoordinates[Double](
                        x = 0,
                        y = (i + 0.5) * gp.pitchV + os))
          case "E" => Some(AIB3DCoordinates[Double](
                        x = finalCols * gp.pitchH + ip.bumpOffset,
                        y = (i + 0.5) * gp.pitchV + os))
          case "S" => Some(AIB3DCoordinates[Double](
                        x = (i + 0.5) * gp.pitchH + os,
                        y = 0))
          case "N" => Some(AIB3DCoordinates[Double](
                        x = (i + 0.5) * gp.pitchH + os,
                        y = finalRows * gp.pitchV + ip.bumpOffset))
        }
      }
    }

    // Return
    finalMap

  } else {  // coding
    Array.ofDim[AIB3DBump](1, 1)
  }

  val flatBumpMap : Seq[AIB3DBump] = bumpMap.flatten.toSeq
  // Check
  require(!flatBumpMap.contains(null), "Error in final bump map creation!")

}