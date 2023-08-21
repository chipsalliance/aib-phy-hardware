package aib3d.stage

import scala.collection.immutable.ListMap
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}
import doodle.image._
import doodle.core._
import doodle.core.format._
import doodle.image.syntax.all._
import doodle.java2d._
import cats.effect.unsafe.implicits.global

import chisel3._

import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations._

import aib3d.io._

/** Record a bump assignment */
case class BumpMapAnnotation(target: Named, mapping: Array[Array[AIB3DBump]]) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)
}

/** Generate bump map collateral */
object GenBumpMapAnno {
  def anno(
    rawModule: RawModule,
    mapping: Array[Array[AIB3DBump]]
  ): Array[Array[AIB3DBump]] = {

    // Annotate module with the bump map
    annotate(new ChiselAnnotation {
      def toFirrtl = BumpMapAnnotation(rawModule.toNamed, mapping)
    })

    mapping
  }

  /** Generates a JSON file with the IO cell instance name and location,
    * core pin name and location, and other physical design constraints.
    */
  def toJSON(
    mapping: Array[Array[AIB3DBump]]
  ): String = {
    val flatMap = mapping.flatten.toSeq
    s"""{\n  "bump_map": [\n""" +
    flatMap.map { case b =>
      s"""    "${b.bumpName}":"${b.location.get.x}, ${b.location.get.y}""""
    }.mkString(",\n") +
    "\n  ]\n}"
  }

  /** Generates a CSV file that can be imported into a spreadsheet
    * Each cell corresponds to a bump. If the bump has a corresponding core signal,
    * it is printed in the cell as well.
    */
  def toCSV(
    mapping: Array[Array[AIB3DBump]]
  ): String = {
    "Signal <-> Bump\n"+
    // Reverse rows to account for spreadsheet vs. layout
    mapping.reverse.map { case r => r.map { case b =>
      val coreSig = if (b.coreSig.isDefined) {
        b.coreSig.get.name + (if (b.coreSig.get.bitIdx.isDefined)
          "[" + b.coreSig.get.bitIdx.get.toString() + "]" else "") + " <-> "
      } else ""
      s"${coreSig}${b.bumpName}"
    }.mkString(", ")}.mkString("\n")
  }

  /** Generates a PNG + PDF file that can be used to visualize the bump map.
    * This uses the scala doodle package and also opens a window for live visualization.
    */
  def toImg(
    mapping: Array[Array[AIB3DBump]]
  ): Unit = {
    // test chessboard
    val blackSquare = Image.rectangle(30, 30).fillColor(Color.black)
    val redSquare = Image.rectangle(30, 30).fillColor(Color.red)

    // A chessboard, broken into steps showing the recursive construction
    val twoByTwo =
      (redSquare.beside(blackSquare))
        .above(blackSquare.beside(redSquare))

    val fourByFour =
      (twoByTwo.beside(twoByTwo))
        .above(twoByTwo.beside(twoByTwo))

    val chessboard =
      (fourByFour.beside(fourByFour))
        .above(fourByFour.beside(fourByFour))

    chessboard.write[Png]("chessboard.png")
    chessboard.write[Pdf]("chessboard.pdf")
    chessboard.draw()
  }
}