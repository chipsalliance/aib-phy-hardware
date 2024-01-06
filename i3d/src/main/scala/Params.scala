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
  * Only used for signal shift redundancy.
  * @param hasDBI denotes if data bus inversion is implemented with coding redundancy
  * @param deskewArch is the de-skew architecture
  * @param modSize is the max number of data bits (Tx/Rx, each) in a module
  * @param pinSide is the side where pins are to be assigned, pre-mirroring/rotation.
  * One of "N", "S", "E", "W".
  * @param dataBundle is the data bundle of the leader die
  * @param dataStatistic is the average statistics of the buses in the data bundle.
  * One of "random", "correlated", "one-hot", or "normal".
  * Used for pin-to-bump assignment in all redundancy modes and low-power coding in coding redundancy mode.
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
  modSize: Int = 64,
  pinSide: String = "N",
  dataBundle: Bundle,
  dataStatistic: String = "random") {

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
  require(Set("random", "sequential", "one-hot", "normal").contains(dataStatistic),
    "dataStatistic must be one of 'random', 'sequential', 'one-hot', or 'normal'")

  // TODO: modSize depends on pitch, additional signals, redundancy
  // require(modSize >= pow(maxParticleSize, 2).toInt,
  //   "modSize too small, must be at least maxParticleSize^2")
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
  * @param bumpCellName is the bump cell used by the technology.
  * May be required by the collateral generator.
  * @param ioCellName is the name of the IO cell macro used by the technology.
  * May be required by the collateral generator.
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
  blackBoxModels: Boolean = false,
  bumpCellName: Option[String] = None,
  ioCellName: Option[String] = None) {

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

  /** Step 1: Extract and flatten the Tx and Rx IOs */
  private val data = if (ip.isLeader) gp.dataBundle else Flipped(gp.dataBundle)
  private val flatTx = Utils.flattenIOs(data, SpecifiedDirection.Output)
  private val flatRx = Utils.flattenIOs(data, SpecifiedDirection.Input)
  // TODO: support unbalanced Tx/Rx IO count
  require(flatTx.length == flatRx.length, "Only balanced Tx/Rx IO count supported at this time.")
  // For sorting
  val flatTxOrder = flatTx.map(_.fullName)
  val flatRxOrder = flatRx.map(_.fullName)

  /** Step 2: Calculate public constants */

  // Determine number of modules (Tx/Rx individually) and signals per module
  val numMods = (flatTx.length / gp.modSize.toDouble).ceil.toInt
  require(flatTx.length % numMods == 0,
    s"Number of IOs (${flatTx.length}) not evenly divisible by derived number of modules (${numMods})")
  val sigsPerMod = flatTx.length / numMods
  // TODO: allow for more/less than 2 redundant modules, don't require even number
  val redMods = if (gp.redundArch == 2) numMods / gp.redundRatio else 0
  if (redMods > 0) require(numMods % redMods == 0,
    s"Number of signal mods (${numMods}) must be evenly divisible by number of redundant mods (${redMods})")
  val numModsWR = numMods + redMods

  // Resolve aspect ratio and pin side
  val isWide = Set("N", "S").contains(gp.pinSide)
  val pinSide = if (ip.pinSide.isDefined) {
    val compat = Set("N", "S").contains(ip.pinSide.get) == isWide
    require(compat, "Instance pinSide parameter incompatible with global pinSide parameter.")
    if (compat) ip.pinSide.get else gp.pinSide
  } else gp.pinSide

  // Rows and columns of modules (total, not Tx/Rx individually)
  // If no redundancy, want to find the most "square" arrangement from the factor pairs of numMods
  // Else, shorter dimension is determined by the number of redundant modules
  val (modRows, modCols) =
    if (gp.redundArch == 2)  // signal shift
      if (isWide) (redMods, numMods / redMods * 2)
      else (numMods / redMods * 2, redMods)
    else {
      // Find factor pairs, and return the most "square" one
      // This still works if numMods is a square number
      val bestFactor = (1 to sqrt(numMods * 2).toInt).filter((numMods * 2) % _ == 0).last
      if (isWide) (bestFactor, numMods * 2 / bestFactor)  // wide
      else (numMods * 2 / bestFactor, bestFactor)  // tall
    }
  val (modRowsWR, modColsWR) =
    if (gp.redundArch == 2)  // signal shift
      if (isWide) (redMods, modCols + 2) else (modRows + 2, redMods)
    else (modRows, modCols)

  // Calculate coding cluster properties
  val (clusterDiam, numClusters, clusterPattern, sigsPerCluster) =
    if (gp.redundArch == 1)  // coding
      Utils.gridPacking(gp, sigsPerMod)
    else (0.0, 0, Seq.empty, 0)

  /** Step 3: Create the bump map.
    * It is different depending on the redundancy scheme.
    */

  val (bumpMap: Array[Array[AIB3DBump]], flatBumpMap: Seq[AIB3DBump]) =
    if (gp.redundArch != 1) {  // none or signal shift
      // Rows/cols of signal/PG bumps and extras
      val (rowsSig, colsSig, extras) = Utils.calcRowsCols(sigsPerMod, isWide)
      val rowsP = ((rowsSig.toDouble / gp.sigsPerPG._2) - 1).ceil.toInt + 1
      val colsG = ((colsSig.toDouble / gp.sigsPerPG._1) - 1).ceil.toInt + 1
      val rowsPerMod = rowsSig + rowsP
      val colsPerMod = colsSig + colsG

      // Row/column indices of the power/ground
      val pRows = Utils.pgIdxGen(rowsSig, rowsP, gp.sigsPerPG._2)
      val gCols = Utils.pgIdxGen(colsSig, colsG, gp.sigsPerPG._1)
      // Permute indices into coordinates based on row/cols per mod
      val pCoords = pRows.flatMap(r => (0 until colsPerMod).map(c => (c, r)))
      val gCoords = gCols.flatMap(c => (0 until rowsPerMod).map(r => (c, r)))

      // P/G intersection of the clock signal
      // It should be as close to the middle as possible and biased towards pin edge
      val biasLL = if (Set("S", "W").contains(pinSide)) 1 else 0
      val clkCoord: (Int, Int) =
        (gCols(colsG / 2 - (if (colsG % 2 == 0) biasLL else 0)),
         pRows(rowsP / 2 - (if (rowsP % 2 == 0) biasLL else 0)))

      // Calculate positions of the extra signals
      val extraCoords = Utils.extraCoordGen(extras, pinSide, pRows, gCols,
                                            rowsPerMod, colsPerMod)

      // Calculate (ordered) positions of the data signals
      // Permute row and column indices and filter out the above coordinates
      // TODO: use data statistics
      val sigCoords = (0 until rowsPerMod).flatMap(r =>
        (0 until colsPerMod).map(c => (c, r)))
        .filterNot((pCoords ++ gCoords ++ extraCoords :+ clkCoord) contains _)

      // Map to bump map
      val (txBumpMap, rxBumpMap) = Utils.bumpMapGen(tx = flatTx,
                                                    rx = flatRx,
                                                    mods = numMods,
                                                    redMods = redMods,
                                                    numSigs = sigCoords.length,
                                                    sCoords = sigCoords,
                                                    cCoords = Seq(clkCoord),
                                                    pCoords = pCoords,
                                                    gCoords = gCoords,
                                                    eCoords = extraCoords)

      // Concatenate bump maps then generate the correct ordering of module origins
      // Depending on pin side, the rows/cols of modules are different
      // Note modules in the longer dimension is doubled since Tx and Rx are separate
      val concatenated = Array(txBumpMap, rxBumpMap).flatten
      // Ordering of modules
      // TODO: support more/less than 2 rows/cols of modules
      val modOrigins = {
        if (isWide)  // Tx left of Rx
          ((0 until modColsWR by 2) ++ (1 until modColsWR by 2)).flatMap(c =>
            (0 until modRowsWR).map(r =>
              (r * rowsPerMod, c * colsPerMod)))
        else  // Tx under Rx
          ((0 until modRowsWR by 2) ++ (1 until modRowsWR by 2)).flatMap(r =>
            (0 until modColsWR).map(c =>
              (r * rowsPerMod, c * colsPerMod)))
      }
      require(modOrigins.length == concatenated.length,
        "Error in Tx/Rx module to full module mapping.")

      // Flatten modules into final map
      // Module index tag is added to each bump for module redundancy mapping
      val finalMap = Array.ofDim[AIB3DBump](modRowsWR * rowsPerMod, modColsWR * colsPerMod)
      modOrigins.zipWithIndex.foreach { case ((r, c), s) =>
        for (sr <- 0 until rowsPerMod; sc <- 0 until colsPerMod) {
          finalMap(r + sr)(c + sc) = concatenated(s)(sr)(sc)
          finalMap(r + sr)(c + sc).modIdx =
            Some(AIB3DCoordinates[Int](
              x = c / colsPerMod,
              y = r / rowsPerMod))
        }
      }
      // Return
      (finalMap, finalMap.flatten.toSeq)
    }
    else {  // coding
      val (sCoords, cCoords, pCoords, gCoords) =
        Utils.calcCoding(gp = gp,
                         diam = clusterDiam,
                         circles = numClusters,
                         pattern = clusterPattern,
                         sigsPerCircle = sigsPerCluster,
                         sigsPerMod = sigsPerMod,
                         isWide = isWide)
      // Now need to re-map Tx/Rx IO order based on data statistics for coding
      /*
      val txWithRed = flatTx.grouped(sigsPerMod).zipWithIndex.flatMap { case (mod, mi) =>
        mod ++ (0 until sigsPerCircle).map(si => AIB3DCore(
          name = s"TXRED${mi * sigsPerMod + si}",
          bitIdx = None,

        ))
      }.toSeq
      */
      val (txBumpMap, rxBumpMap) = Utils.bumpMapGen(tx = flatTx,
                                                    rx = flatRx,
                                                    mods = numMods,
                                                    redMods = 0,
                                                    numSigs = sigsPerMod,
                                                    sCoords = sCoords,
                                                    cCoords = cCoords,
                                                    pCoords = pCoords,
                                                    gCoords = gCoords,
                                                    eCoords = Seq.empty)
      val rowsPerMod = txBumpMap(0).length
      val colsPerMod = txBumpMap(0)(0).length

      // Interleave bump maps then generate the correct ordering of module origins
      // Depending on pin side, the rows/cols of modules are different
      // Note modules in the longer dimension is doubled since Tx and Rx are separate
      val interleaved = Array(txBumpMap, rxBumpMap).transpose.flatten
      // Ordering of modules
      // TODO: support more/less than 2 rows/cols of modules
      val modOrigins = {
        if (isWide)  // row-by-row
          (0 until modRows).flatMap(r =>
            (0 until modCols).map(c =>
              (r * rowsPerMod, c * colsPerMod)))
        else  // col-by-col
          (0 until modCols).flatMap(c =>
            (0 until modRows).map(r =>
              (r * rowsPerMod, c * colsPerMod)))
      }
      require(modOrigins.length == interleaved.length,
        "Error in Tx/Rx module to full module mapping.")

      // Flatten modules into final map
      // Module index tag is added to each bump for module redundancy mapping
      val finalMap = Array.ofDim[AIB3DBump](modRows * rowsPerMod, modCols * colsPerMod)
      modOrigins.zipWithIndex.foreach { case ((r, c), m) =>
        for (mr <- 0 until rowsPerMod; mc <- 0 until colsPerMod) {
          finalMap(r + mr)(c + mc) = interleaved(m)(mr)(mc)
          finalMap(r + mr)(c + mc).modIdx =
            Some(AIB3DCoordinates[Int](
              x = c / colsPerMod,
              y = r / rowsPerMod))
        }
      }

      // For the flat bump map, the ordering needs to go cluster-by-cluster
      // to aid in the coding redundancy module IO assignment.
      // Use the coordinates derived above for signal bumps
      val flatMap: ArrayBuffer[AIB3DBump] = ArrayBuffer.empty
      for ((r, c) <- modOrigins) {
        // Get signal bumps first, then clock, power, ground
        val order = Seq(sCoords, cCoords, pCoords, gCoords)
        for (coords <- order) {
          for ((x, y) <- coords) flatMap += finalMap(r + y)(c + x)
        }
      }

      // Return
      (finalMap, flatMap.toSeq)
    }

  // Check
  require(!flatBumpMap.contains(null), "Error in final bump map creation!")

  // Calculate locations
  Utils.calcLocations(bumpMap, pinSide, gp, ip)
}