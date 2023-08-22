package aib3d.stage

import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}
import doodle.core._
import doodle.core.format._
import doodle.syntax.all._
import doodle.java2d._
import cats.effect.unsafe.implicits.global

import chisel3._

import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations._
import org.chipsalliance.cde.config.Parameters

import aib3d._
import aib3d.io._

/** Record a bump assignment */
case class BumpMapAnnotation(
  target: Named, mapping: Array[Array[AIB3DBump]]
  ) extends SingleTargetAnnotation[Named] {
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
  def toImg(implicit p: Parameters): Unit = {
    val params = p(AIB3DKey)

    // Iterate row-wise (not in reverse order) and column-wise (in reverse order) using recursion
    // Scale by factor of 10 for legibility
    def constructCols(right: Picture[Unit], ba: Array[AIB3DBump]): Picture[Unit] = {
      if (ba.isEmpty) right
      else {
        val b = ba.head
        val coreSig = if (b.coreSig.isDefined) {
          b.coreSig.get.name + (if (b.coreSig.get.bitIdx.isDefined)
            "[" + b.coreSig.get.bitIdx.get.toString() + "]" else "")
        } else ""
        val bumpText = Picture.text(b.bumpName).scale(5.0/8, 5.0/8).above(
          if (b.coreSig.isDefined) Picture.text(coreSig).scale(1.0/2, 1.0/2)
          else Picture.empty)
        // An invisible square with a circle inside
        val bumpCircle = Picture.circle(10 * params.gp.pitch / 2)
        val bumpCell = bumpText.on(
          if (b.isInstanceOf[Pwr]) bumpCircle.fillColor(Color.red)
          else if (b.isInstanceOf[Gnd]) bumpCircle.fillColor(Color.gray)
          else bumpCircle.noFill).on(
            Picture.rectangle(10 * params.gp.pitchH, 10 * params.gp.pitchV).noFill.noStroke)
        constructCols(bumpCell.beside(right), ba.tail)
      }
    }
    def constructRows(below: Picture[Unit], ba: Array[Array[AIB3DBump]]): Picture[Unit] = {
      if (ba.isEmpty) below
      else {
        val row = constructCols(Picture.empty, ba.head.reverse)
        constructRows(row.above(below), ba.tail)
      }
    }
    val bumpsOnly = constructRows(Picture.empty, params.bumpMap)

    // Overlay a dotted grid for submodules and some helpful text
    // Unfortunately, can't get bounding box or size of patch because it's a bug in doodle 0.19.0
    // Fixed for 0.20.0 but that is only available for Scala 3
    // So we have to do it manually - get dimensions of bump map and draw grid (account for strokeWidth)
    val (bumpsH, bumpsV) = (params.bumpMap(0).length, params.bumpMap.length)
    val gridWidth = (bumpsH + 1) * 10 * params.gp.pitchH / params.submodColsWR - 1.0
    val gridHeight = (bumpsV + 1) * 10 * params.gp.pitchV / params.submodRowsWR - 1.0
    val titleText = s"Bump Map: ${bumpsH} x ${bumpsV} bumps at ${params.gp.pitchH} x ${params.gp.pitchV} pitch"
    val titleBlock = Picture.text(titleText).scale(2.0, 2.0).on(
      Picture.rectangle(bumpsH * 10 * params.gp.pitchH, 5 * params.gp.pitchV).noFill.noStroke)
    // TODO: add ruler. Also vertical edge
    val bottomBlock =
      Picture.rectangle(bumpsH * 10 * params.gp.pitchH, 5 * params.gp.pitchV).noFill.noStroke
    // TODO: show pin placement
    def gridCols(right: Picture[Unit], x: Int): Picture[Unit] = {
      if (x == params.submodColsWR) right
      else {
        val gridRect = Picture.rectangle(gridWidth, gridHeight)
          .strokeColor(Color.gray).strokeDash(Array(5.0, 2.0))
        gridCols(gridRect.beside(right), x + 1)
      }
    }
    def gridRows(below: Picture[Unit], y: Int): Picture[Unit] = {
      if (y == params.submodRowsWR) below
      else {
        val row = gridCols(Picture.empty, 0)
        gridRows(row.above(below), y + 1)
      }
    }
    val submodGrid = gridRows(Picture.empty, 0)
    val bumpMapPic = titleBlock
                      .above(bumpsOnly)
                      .above(bottomBlock)
                      .on(submodGrid)

    // Vector
    bumpMapPic.write[Pdf]("bumpmap.pdf")
    // Scalar
    // bumpMapPic.write[Png]("bumpmap.png")
    // Live window
    // bumpMapPic.draw()
  }
}