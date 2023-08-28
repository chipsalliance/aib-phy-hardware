package aib3d

import org.json4s._
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}
import doodle.core._
import doodle.core.format._
import doodle.syntax.all._
import doodle.java2d._
import cats.effect.unsafe.implicits.global

import chisel3._

import chisel3.experimental.BaseModule
import org.chipsalliance.cde.config.Parameters

import aib3d.io._

/** Generate bump map collateral */
object GenCollateral {
  /** Generates a JSON file with the IO cell instance name and location,
    * core pin name and location, and other physical design constraints.
    */
  def toJSON(iocells: Seq[BaseModule with IOCellBundle])
    (implicit params: AIB3DParams): String = {
    implicit val formats = DefaultFormats
    val jsonMap = params.flatBumpMap.map { case b =>
      val iocell = iocells.find(_.forBump == b)
      ("bump_name" -> b.bumpName) ~
      ("core_sig" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.fullName) else None)) ~
      ("iocell_path" -> (if (iocell.isDefined) Some(iocell.get.toTarget.toString) else None)) ~
      ("bump_x" -> b.location.get.x) ~
      ("bump_y" -> b.location.get.y) ~
      ("pin_x" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.pinLocation.get.x) else None)) ~
      ("pin_y" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.pinLocation.get.y) else None)) ~
      ("submod_idx" -> (if (b.submodIdx.isDefined) Some(b.submodIdx.get.linearIdx) else None))
    }.toSeq
    pretty(render(("bump_map" -> jsonMap)))
  }

  /** Generates a CSV file that can be imported into a spreadsheet
    * Each cell corresponds to a bump. If the bump has a corresponding core signal,
    * it is printed in the cell as well.
    */
  def toCSV(implicit params: AIB3DParams): String = {
    "Signal <-> Bump\n"+
    // Reverse rows to account for spreadsheet vs. layout
    params.bumpMap.reverse.map { case r => r.map { case b =>
      val coreSig = if (b.coreSig.isDefined) b.coreSig.get.fullName + " <-> " else ""
      s"${coreSig}${b.bumpName}"
    }.mkString(", ")}.mkString("\n")
  }

  /** Generates a PNG + PDF file that can be used to visualize the bump map.
    * This uses the scala doodle package and also opens a window for live visualization.
    */
  def toImg(implicit params: AIB3DParams): Unit = {
    // Iterate row-wise (not in reverse order) and column-wise (in reverse order) using recursion
    // Scale by factor of 10 for legibility
    val scale = 10
    def constructCols(right: Picture[Unit], ba: Array[AIB3DBump]): Picture[Unit] = {
      if (ba.isEmpty) right
      else {
        val b = ba.head
        val coreSig = if (b.coreSig.isDefined) {
          b.coreSig.get.name + (if (b.coreSig.get.bitIdx.isDefined)
            "[" + b.coreSig.get.bitIdx.get.toString() + "]" else "")
        } else ""
        val bumpText = Picture.text(b.bumpName)
          .scale(scale / 2 /8.0, scale / 2 /8.0)
          .above(
            if (b.coreSig.isDefined)
              Picture.text(coreSig).scale(scale * 0.05, scale * 0.05)
            else Picture.empty
          )
        // An invisible square with a circle inside
        val bumpCircle = Picture.circle(scale * params.gp.pitch / 2)
        val bumpCell = bumpText.on(
          if (b.isInstanceOf[Pwr]) bumpCircle.fillColor(Color.red)
          else if (b.isInstanceOf[Gnd]) bumpCircle.fillColor(Color.gray)
          else bumpCircle.noFill).on(
            Picture.rectangle(scale * params.gp.pitchH, scale * params.gp.pitchV).noFill.noStroke)
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
    // So we have to do it manually - get dimensions of bump map and draw grid
    // (Accounts for default strokeWidth = 1)
    val (bumpsH, bumpsV) = (params.bumpMap(0).length, params.bumpMap.length)
    val bumpsWidth = bumpsH * scale * params.gp.pitchH
    val bumpsHeight = bumpsV * scale * params.gp.pitchV
    val gridWidth = (bumpsH + 1) * scale * params.gp.pitchH / params.submodColsWR - 1
    val gridHeight = (bumpsV + 1) * scale * params.gp.pitchV / params.submodRowsWR - 1
    val titleText = s"""Bump Map: ${bumpsH} x ${bumpsV} bumps at
                        |${params.gp.pitchH}um x ${params.gp.pitchV}um pitch"""
                        .stripMargin
    val titleBlock = Picture.text(titleText).scale(scale / 5, scale / 5).on(
      Picture.rectangle(bumpsWidth, scale / 2 * params.gp.pitchV).noFill.noStroke)
    // TODO: add ruler. Also vertical edge
    val bottomBlock =
      Picture.rectangle(bumpsWidth, scale / 2 * params.gp.pitchV).noFill.noStroke
    // TODO: show pin placement
    def gridCols(right: Picture[Unit], x: Int): Picture[Unit] = {
      if (x == params.submodColsWR) right
      else {
        val gridRect = Picture.rectangle(gridWidth, gridHeight)
          .strokeColor(Color.gray).strokeDash(Array(scale / 2.0, scale / 5.0))
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
    // Live window (2x2 pixels = 1um^2)
    // bumpMapPic.scale(2.0 / scale, 2.0 / scale).draw()
  }
}