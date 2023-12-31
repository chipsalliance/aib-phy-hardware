package aib3d

import util.control.Breaks._
import scala.collection.mutable.ArrayBuffer
import scala.collection.immutable.SeqMap
import scala.math.{pow, sqrt, min, max}

import chisel3._

import chisel3.experimental.DataMirror

import aib3d.io._

// Assorted methods needed for bump map generation
object Utils {
  /**
   * IO flattening
   * @param bundle is a data bundle
   * @param dir is the desired data direction
   * @return a sequence of AIB3DCore objects
   */
  def flattenIOs(bundle: Bundle, dir: SpecifiedDirection) : Seq[AIB3DCore] = {
    def cloneDirection(d: Data) = DataMirror.specifiedDirectionOf(d) match {
      case SpecifiedDirection.Input => Input(UInt(1.W))
      case SpecifiedDirection.Output => Output(UInt(1.W))
      case _ => throw new Exception("Only Input/Output supported")
    }
    val flat = ArrayBuffer.empty[AIB3DCore]
    val orig = bundle.elements.filter(elt => DataMirror.specifiedDirectionOf(elt._2) == dir)
    for ((oname, odata) <- orig) {
      // Add single bit IOs as-is, otherwise break into individual bits
      // Need to deal with Vec and Seq types (recursively flatten with naming)
      def flattenVecSeq(name: String, d: Data): Seq[(String, Data)] = d match {
        case v: Vec[_] => v.zipWithIndex.flatMap{ case (elt, i) =>
          flattenVecSeq(s"${name}_${i}", elt)
        }
        case s: Seq[_] => s.zipWithIndex.flatMap{ case (elt, i) =>
          flattenVecSeq(s"${name}_${i}", elt.asInstanceOf[Data])
        }
        case _ => Seq((name, d))
      }
      flattenVecSeq(oname, odata).foreach{ case (name, data) =>
        val width = data.getWidth
        if (width > 1)
          for (i <- (0 until width).reverse) {  // MSB to LSB
            // TODO: support scrambling of bus bits for switching activity distribution
            // Bit indexing can't be done unless it is actually hardware.
            // Thus, we need to copy the direction and make it a 1-bit Data.
            flat += AIB3DCore(name, Some(i), cloneDirection(odata), None)
          }
        else
          flat += AIB3DCore(name, None, cloneDirection(odata), None)
      }
    }
    flat.toSeq
  }

  /**
    * Calculate number of signal rows/columns, prioritizing the least number of bumps
    * and the ordering with fewer bumps facing pin edge
    * @param sigs: number of signal bumps
    * @param isWide: true if wide, false if tall
    * @return A tuple of (number of signal rows, number of signal columns, number of extra bumps)
    */
  def sigRowsCols(sigs: Int, isWide: Boolean): (Int, Int, Int) = {
    val rowsSigOpts = Seq(sqrt(sigs.toDouble).floor.toInt,
                          sqrt(sigs.toDouble).ceil.toInt)
    val colsSigOpts = rowsSigOpts.map(r => (sigs / r.toDouble).ceil.toInt)
    val (rowsSig, colsSig) = {
      if (rowsSigOpts(0) * colsSigOpts(0) < rowsSigOpts(1) * colsSigOpts(1))
        if (isWide) (colsSigOpts(0), rowsSigOpts(0))
        else (rowsSigOpts(0), colsSigOpts(0))
      else
        if (isWide) (rowsSigOpts(1), colsSigOpts(1))
        else (colsSigOpts(1), rowsSigOpts(1))
    }
    (rowsSig, colsSig, rowsSig * colsSig - sigs)
  }

  /**
   * Determine the indices of power/ground bumps in the relevant dimension
   * Step 1: Signal/power/ground pattern generation
   * Evenly distribute rowsSig and colsSig between power rows and ground columns
   * To do this, need to make a Seq filled with the quotient, and obtain the remainder
   * Then split the quotient Seq at the remainder position, and add 1 to the first half
   * Then perform binary recursion to evenly diffuse the smaller Seq into the larger
   * Step 2: Calculate row/column indices of power/ground bumps
   * At the edges, the signals virtually spill over into adjacent modules
   * So we must add sigsPerPG to the pattern gen then subtract half
   * @param sigs: number of signal bumps in this dimension
   * @param pg: number of power and ground bumps in this dimension
   * @param sigsPerPG: number of signal bumps between power/ground bumps in this dimension
   * @return A Seq[Int] with row indices of power bumps or col indices of ground bumps
   */
  def pgIdxGen(sigs: Int, pg: Int, sigsPerPG: Int): Seq[Int] = {
    val splitQuotient = Seq.fill(pg + 1)((sigs + sigsPerPG) / (pg + 1)).splitAt((sigs + sigsPerPG) % (pg + 1))
    def diffuse(l: Seq[Int], s: Seq[Int]): Seq[Int] = {
      val splitL = l.splitAt(l.length / 2)
      if (s.length == 0) l
      else if (s.length == 1) splitL._1 ++ s ++ splitL._2
      else {
        val splitS = s.tail.splitAt(s.tail.length / 2)
        diffuse(splitL._1 ++ s.take(1), splitS._1) ++ diffuse(splitL._2, splitS._2)
      }
    }
    val pattern = {
      if (splitQuotient._1.length >= splitQuotient._2.length)
        diffuse(splitQuotient._1.map(_ + 1), splitQuotient._2)
      else
        diffuse(splitQuotient._2, splitQuotient._1.map(_ + 1))
    }
    pattern.scanLeft(0)(_ + _ + 1)
           .map(_ - 1 - sigsPerPG/2)
           .drop(1).dropRight(1)
  }

  /**
    * Get coordinates of extra signal bumps to assign to ground
    * In a counter-clockwise circle, get the cornermost bumps, starting at (0, 0)
    * Then reorder based on which side the pin is on (prioritize farther ones).
    * This method reduces the radius of the clock tree in each module
    * while decreasing the length of routing to all IO cells.
    * For ranges: col pattern is (0), (0, 1), (0, 1, 2), (0, 1, 2, 3), etc.
    * and row is reverse (count down within each of those groups in col pattern).
    * We must also adjust for any rows/cols of power/ground.
    * Use recursion to generate this pattern and take as many entries as necessary.
    * @param extras: number of extra signal bumps
    * @param pinSide: side of pins
    * @param pRows: indices of power rows
    * @param gCols: indices of ground columns
    * @param rows: number of rows
    * @param cols: number of columns
    * @return A Seq[(Int, Int)] with coordinates of extra signal bumps
    */
  def extraCoordGen(extras: Int, pinSide: String, pRows: Seq[Int], gCols: Seq[Int],
                    rows: Int, cols: Int): Seq[(Int, Int)] = {
    val sideDropTake = pinSide match{
      case "N" => 0
      case "W" => 1
      case "S" => 2
      case "E" => 3
    }
    // Recursion
    (1 to (extras / 4.0).ceil.toInt).foldLeft(Seq.empty[(Int, Int)]){ case (coords, e) =>
      val range = Range(0, e)
      val nextCoords = (range zip range.reverse).map{ case(c, r) =>
        val cAdjUp = gCols.indexWhere(c >= _) + 1
        val cAdjDown = gCols.reverse.indexWhere(cols - c - 1 <= _) + 2
        val rAdjUp = pRows.indexWhere(r >= _) + 1
        val rAdjDown = pRows.reverse.indexWhere(rows - r - 1 <= _) + 2
        val ord = Seq((c + cAdjUp, r + rAdjUp),
                      (cols - c - cAdjDown, r + rAdjUp),
                      (cols - c - cAdjDown, rows - r - rAdjDown),
                      (c + cAdjUp, rows - r - rAdjDown))
        ord.drop(sideDropTake) ++ ord.take(sideDropTake)
      }.flatten
      coords ++ nextCoords
    }.take(extras)
  }

  /**
    * Perform bump map generation
    * @param tx: flattened TX IOs
    * @param rx: flattened RX IOs
    * @param mods: number of modules
    * @param redMods: number of redundant modules
    * @param cCoords: coordinates of clock bumps
    * @param pCoords: coordinates of power bumps
    * @param gCoords: coordinates of ground bumps
    * @param eCoords: coordinates of extra signal bumps
    * @param sCoords: (ordered) coordinates of signal bumps
    * @return Two bump maps: one for TX and one for RX
    */
  def bumpMapGen(tx: Seq[AIB3DCore], rx: Seq[AIB3DCore],
                 mods: Int, redMods: Int, cCoords: Seq[(Int, Int)],
                 pCoords: Seq[(Int, Int)], gCoords: Seq[(Int, Int)],
                 eCoords: Seq[(Int, Int)], sCoords: Seq[(Int, Int)]):
                (Array[Array[Array[AIB3DBump]]], Array[Array[Array[AIB3DBump]]]) = {
    // Determine number of rows and columns from the maximum indices found in the coordinates
    val allCoords = cCoords ++ pCoords ++ gCoords ++ eCoords ++ sCoords
    val rows = allCoords.map(_._2).max + 1
    val cols = allCoords.map(_._1).max + 1
    // Initialize bump maps
    val txBumpMap, rxBumpMap = Array.ofDim[AIB3DBump](mods + redMods, rows, cols)
    // Counters
    var clkCnt = 0
    var bitCnt = 0
    // Loop through modules
    for (m <- 0 until (mods + redMods)) {
      // First, map power bumps
      for ((c, r) <- pCoords) {
        txBumpMap(m)(r)(c) = Pwr()
        rxBumpMap(m)(r)(c) = Pwr()
      }
      // Next, map ground bumps
      for ((c, r) <- (gCoords ++ eCoords)) {
        txBumpMap(m)(r)(c) = Gnd()
        rxBumpMap(m)(r)(c) = Gnd()
      }
      // Next, map clock bumps
      // Redundant if m >= mods (redundant module in signal-shift redundancy)
      // or clkCnt > 0 (clock already mapped in coding redundancy)
      for ((c, r) <- cCoords) {
        txBumpMap(m)(r)(c) = TxClk(m, (m >= mods) || (clkCnt > 0))
        rxBumpMap(m)(r)(c) = RxClk(m, (m >= mods) || (clkCnt > 0))
        clkCnt += 1
      }
      // Finally, map signal bumps
      for ((c, r) <- sCoords) {
        // Note: redundant module clocks mapped to adjacent module
        txBumpMap(m)(r)(c) = TxSig(bitCnt, if (m < mods) m else m - redMods,
          if (m < mods) Some(tx(bitCnt).copy(relatedClk = Some(s"TXCKP$m"))) else None)
        rxBumpMap(m)(r)(c) = RxSig(bitCnt, m,
          if (m < mods) Some(rx(bitCnt).copy(relatedClk = Some(s"RXCKP$m"))) else None)
        bitCnt += 1
      }
      clkCnt = 0  // reset clock count for next module
      if (m == mods - 1) bitCnt = 0  // reset bit count for redundant modules
    }
    // Return
    (txBumpMap, rxBumpMap)
  }

  /**
   * Calculate bump/iocell and pin locations
   * @param bumpMap: an Array containing the bump map
   * @param pinSide: side of pins
   * @param gp: global params
   * @param ip: instance params
   */
  def calcLocations(bumpMap: Array[Array[AIB3DBump]], pinSide: String,
                    gp: AIB3DGlblParams, ip: AIB3DInstParams) : Unit = {
    val rows = bumpMap.length
    val cols = bumpMap(0).length
    val isWide = Set("N", "S").contains(pinSide)

    // Calculate bump/iocell location
    // TODO: ignore tech grids and let the tools snap or use BigDecimal?
    for (r <- 0 until rows; c <- 0 until cols) {
      // Update coordinates using calculated pitch and bumpOffset.
      bumpMap(r)(c).location = Some(AIB3DCoordinates[Double](
        x = (c + 0.5) * gp.pitchH + (if (pinSide == "W") ip.bumpOffset else 0.0),
        y = (r + 0.5) * gp.pitchV + (if (pinSide == "S") ip.bumpOffset else 0.0))
      )
    }

    // Calculate pin locations
    // Check for available routing resources
    // Assume 20% power assumption + 50% shielding/space penalty
    val routingTracks = ip.layerPitch.map{ case(layer, pitch) =>
      layer -> (gp.pitch / pitch * 1000).floor.toInt}
    val sumTracks = routingTracks.map(_._2).sum
    // Traverse row-by-row or column-by-column and get max number of signals
    val reqdSigs =
      if (Set("E", "W").contains(pinSide)) {
        (0 until cols).map{ c =>
          bumpMap.map(_(c)).filter(_.coreSig.isDefined).length}.max
      } else {
        (0 until rows).map{ r =>
          bumpMap(r).filter(_.coreSig.isDefined).length}.max
      }
    require(sumTracks * 0.4 >= reqdSigs,
      s"""Not enough routing tracks on pin side (${pinSide}).
      |${reqdSigs} tracks requested but only ${sumTracks * 0.4} available.
      |""".stripMargin)
    // Query bumps with core signals in each row/col depending on pinSide
    val coreSigs = (if (isWide) bumpMap.transpose else bumpMap).map{
      _.withFilter(_.coreSig.isDefined).map(_.coreSig.get)}
    // Spread signals out evenly across all layers,
    // starting from the lowest layer in the middle of the row/column
    // Assume that tools will snap to track
    val pinOffsetsPos = routingTracks.map{ case(layer, tracks) =>
      (0 until tracks / 2).map( t => (t * ip.layerPitch(layer) / 1000, layer))
      }.flatten.grouped(sumTracks / reqdSigs).map(_.head).toSeq
    val pinOffsetsNeg = pinOffsetsPos.map{ case(os, lay) => (-os, lay)}.toSeq
    val pinOffsets: Seq[(Double, String)] = pinSide match {  // interleaving
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
                        x = cols * gp.pitchH + ip.bumpOffset,
                        y = (i + 0.5) * gp.pitchV + os))
          case "S" => Some(AIB3DCoordinates[Double](
                        x = (i + 0.5) * gp.pitchH + os,
                        y = 0))
          case "N" => Some(AIB3DCoordinates[Double](
                        x = (i + 0.5) * gp.pitchH + os,
                        y = rows * gp.pitchV + ip.bumpOffset))
        }
      }
    }
  }
}