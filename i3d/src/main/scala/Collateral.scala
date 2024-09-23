package i3d

import scala.math.{min, max, sqrt, pow}
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}
import doodle.core._
import doodle.core.format._
import doodle.syntax.all._
import doodle.java2d._
import cats.effect.unsafe.implicits.global

import chisel3._

import chisel3.experimental.{BaseModule, DataMirror}
import freechips.rocketchip.util.ElaborationArtefacts

import i3d.io._
import i3d.redundancy.RedundancyArch

/** Generate bump map collateral */
class GenCollateral(iocells: Seq[BaseModule with IOCellConnects])(implicit p: I3DParams) {
  /** Calls all generation functions below */
  def genAll(): Unit = {
    // TODO: serialize param case classes. Requires upickle or circe.
    ElaborationArtefacts.add("bumpmap.json", toJSON())
    ElaborationArtefacts.add("bumpmap.csv", toCSV())
    ElaborationArtefacts.add("hammer.json", toHammerJSON())
    if (p.redArch == RedundancyArch.Shifting) {
      // Produce 2 SDC files for each mode
      ElaborationArtefacts.add("default.sdc", toSDC())
      ElaborationArtefacts.add("shifted.sdc", toSDC(shiftCase = true))
    } else {
      ElaborationArtefacts.add("sdc", toSDC())
    }
    //toImg()
  }

  /** Generates a JSON file with the IO cell instance name and location,
    * core pin name and location, and other physical design constraints.
    */
  def toJSON(): String = {
    pretty(render(("bump map" -> p.flatBumpMap.map{ b =>
      val io = iocells.find(_.forBump == b)
      ("bump_name" -> b.bumpName) ~
      ("core_sig" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.fullName) else None)) ~
      ("iocell_path" -> (if (io.isDefined) Some(io.get.pathName) else None)) ~
      ("bump_x" -> b.location.x) ~
      ("bump_y" -> b.location.y) ~
      ("pin_x" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.pinLocation.x) else None)) ~
      ("pin_y" -> (if (b.coreSig.isDefined) Some(b.coreSig.get.pinLocation.y) else None)) ~
      ("mod_idx" -> b.modCoord.linearIdx)
    })))
  }

  /** Generates a CSV file that can be imported into a spreadsheet
    * Each cell corresponds to a bump. If the bump has a corresponding core signal,
    * it is printed in the cell as well.
    */
  def toCSV(): String = {
    "Signal <-> Bump\n"+
    // Reverse rows to account for spreadsheet vs. layout
    p.bumpMap.reverse.map{ case r => r.map{ case b =>
      val coreSig = if (b.coreSig.isDefined) b.coreSig.get.fullName + " <-> " else ""
      s"${coreSig}${b.bumpName}"
    }.mkString(", ")}.mkString("\n")
  }

  /** Generates a JSON file consumable by the Hammer VLSI flow tool.
    * This is a different from the JSON file generated by toJSON.
    */
  def toHammerJSON(): String = {
    // TODO: support mismatched pitchH/pitchV (not yet supported by Hammer) - need gcd of them
    // TODO: TSV constraints
    // Floating point precision
    def roundToNm(x: Double): Double = (x * 1000).round / 1000.0
    // Redundancy
    val codeRed = p.gp.redundArch == 1
    val shiftRed = p.gp.redundArch == 2
    val redModName = if (codeRed) "coding" else if (shiftRed) "shifting" else ""

    // Bumps
    val bumps =
      ("vlsi.inputs.bumps_mode" -> "manual") ~
      ("vlsi.inputs.bumps" ->
        ("x" -> p.bumpMap(0).length) ~
        ("y" -> p.bumpMap.length) ~
        ("pitch" -> p.gp.pitch) ~
        ("global_x_offset" -> (
          if (p.pinSide == "W") p.ip.bumpOffset else 0.0)) ~
        ("global_y_offset" -> (
          if (p.pinSide == "S") p.ip.bumpOffset else 0.0)) ~
        ("cell" -> p.ip.bumpCellName) ~
        ("assignments" -> p.flatBumpMap.map( b =>
          ("name" -> b.bumpName) ~
          // location is integer multiple of pitch, 1-indexed
          ("x" -> roundToNm(b.location.x / p.gp.pitch + 0.5).toInt) ~
          ("y" -> roundToNm(b.location.y / p.gp.pitch + 0.5).toInt)
        ))
      )

    // Pins
    val coreSigs = iocells.withFilter(_.forBump.coreSig.isDefined).map(_.forBump.coreSig.get)
    val sideMap = Map("N" -> "top", "S" -> "bottom", "E" -> "right", "W" -> "left")
    val pins =
      ("vlsi.inputs.pin_mode" -> "generated") ~
      ("vlsi.inputs.pin" ->
        ("generate_mode" -> "semi_auto") ~
        ("assignments" -> (coreSigs.map( c =>
          ("pins" -> ((if (c.name.contains("CKP")) "clocks_" else "") + c.fullName)) ~
          ("side" -> sideMap(p.pinSide)) ~
          ("layers" -> Seq(c.pinLayer)) ~
          ("location" -> Seq(roundToNm(c.pinLocation.x),
                             roundToNm(c.pinLocation.y)))
        ) ++ Seq(  // TODO: constrain within the edge
          ("pins" -> "{clock reset auto* ioCtrl *Faulty}") ~
          ("side" -> sideMap(p.pinSide)) ~
          ("layers" -> p.ip.layerPitch.keys)
        )))
      )

    // Placements
    val topWidth = p.bumpMap(0).length * p.gp.pitchH +
      (if (!p.isWide) p.ip.bumpOffset else 0.0)
    val topHeight = p.bumpMap.length * p.gp.pitchV +
      (if (p.isWide) p.ip.bumpOffset else 0.0)
    val placeKOZ = max(p.ip.bprKOZRatio.getOrElse(0.0), p.ip.tsvKOZRatio.getOrElse(0.0))
    val places =
      ("vlsi.inputs.placement_constraints" -> (Seq(
        ("path" -> "Patch") ~
        ("type" -> "toplevel") ~
        ("x" -> 0) ~
        ("y" -> 0) ~
        ("width" -> roundToNm(topWidth)) ~
        ("height" -> roundToNm(topHeight)) ~
        ("margins" ->
          ("left" -> 0) ~
          ("right" -> 0) ~
          ("top" -> 0) ~
          ("bottom" -> 0))
      ) ++ iocells.filterNot(_.forBump.bumpName.contains("CK")).map( i =>  // Constrain flip-flop placement
        // Replace Target delimiters with / for P&R
        // Fields depend on whether we are using blackboxes or models
        // TODO: breaks if IO cell beneath top hierarchy
        ("path" -> i.pathName.replace(".","/")) ~
        ("type" -> (if (p.ip.blackBoxModels) "hard_placement" else "hardmacro")) ~
        ("x" -> roundToNm(i.forBump.location.x - (
          if (p.ip.blackBoxModels) p.gp.pitchH / 2 else 0.0))) ~
        ("y" -> roundToNm(i.forBump.location.y - (
          if (p.ip.blackBoxModels) p.gp.pitchV / 2 else 0.0))) ~
        ("width" -> (if (p.ip.blackBoxModels) Some(p.gp.pitchH)
                     else None)) ~
        ("height" -> (if (p.ip.blackBoxModels) Some(p.gp.pitchV)
                      else None)) ~
        ("master" -> (if (p.ip.blackBoxModels) None
                      else Some(i.desiredName)))
        // TODO: top layer for halos
      ) ++ p.flatBumpMap.map( b =>  // Routing KOZ
        ("path" -> s"Patch/${b.bumpName}_route_koz") ~
        ("type" -> "obstruction") ~
        ("obs_types" -> Seq("route", "power")) ~
        ("x" -> roundToNm(b.location.x - p.ip.viaKOZRatio * p.gp.pitchH / 2)) ~
        ("y" -> roundToNm(b.location.y - p.ip.viaKOZRatio * p.gp.pitchV / 2)) ~
        ("width" -> roundToNm(p.ip.viaKOZRatio * p.gp.pitchH)) ~
        ("height" -> roundToNm(p.ip.viaKOZRatio * p.gp.pitchV))
      ) ++ (if (placeKOZ > 0) p.flatBumpMap.map( b =>  // Place KOZ
        ("path" -> s"Patch/${b.bumpName}_place_koz") ~
        ("type" -> "obstruction") ~
        ("obs_types" -> Seq("place")) ~
        ("x" -> roundToNm(b.location.x - placeKOZ * p.gp.pitchH / 2)) ~
        ("y" -> roundToNm(b.location.y - placeKOZ * p.gp.pitchV / 2)) ~
        ("width" -> roundToNm(placeKOZ * p.gp.pitchH)) ~
        ("height" -> roundToNm(placeKOZ * p.gp.pitchV))
      ) else Seq.empty))) ~
      ("vlsi.inputs.placement_constraints_meta" -> "append")

    // SDC: clocks, delays, loads
    val sdc =
      ("vlsi.inputs.custom_sdc_files" -> Seq("Patch.sdc")) ~
      ("vlsi.inputs.custom_sdc_files_meta" -> "prependlocal")

    // Power intent
    val power =
      ("vlsi.inputs.power_spec_mode" -> "auto") ~
      ("vlsi.inputs.power_spec_type" -> "upf") ~
      ("vlsi.inputs.supplies.power" -> Seq(("name" -> "VDDI") ~ ("pins" -> Seq("VDDI")))) ~
      ("vlsi.inputs.supplies.ground" -> Seq(("name" -> "VSS") ~ ("pins" -> Seq("VSS"))))

    pretty(render(bumps merge pins merge places merge sdc merge power))
  }

  def toSDC(shiftCase: Boolean = false): String = {
    // Extract bump objects
    val bumps = iocells.map(_.forBump)

    // TODO: power is bump pitch related.
    val globalSDC = f"""# Global constraints
      |# All timing units assumed in ns
      |# Loads/transitions (config pins, internal)
      |set_load 0.005 [all_outputs]
      |set_max_transition 0.05 [current_design]
      |# Power. Not supported by all tools.
      |set_max_dynamic_power ${0.05 * p.numMods * p.sigsPerMod / p.tPeriod}%.1f mW [current_design]
      |# False paths from config pins
      |set_false_path -from *ioCtrl*
      |set_false_path -from *faulty*
      |""".stripMargin +
      (if (p.redArch == RedundancyArch.Coding) "set_false_path -from *dbi*" else "")

    // Module clocks
    val caseAnalysis = if (p.redArch == RedundancyArch.Shifting)
      "# Case analysis for shifting redundancy\n" +
      s"set_case_analysis ${if (shiftCase) 1 else 0} [get_pins shifting/*Muxes*/shift]"
      else ""
    val txClks = bumps.collect{case b: TxClk => b}
    val txClkSDC = txClks.map(_.sdcConstraints(shiftCase)).mkString("\n")
    // Rx clocks must be reversed for shifted case
    val rxClks = if (shiftCase) bumps.collect{case b: RxClk => b}.reverse
                 else bumps.collect{case b: RxClk => b}
    val rxClkSDC = rxClks.map(_.sdcConstraints(shiftCase)).mkString("\n")

    // Global clock constraints
    // TODO config clock doesn't exist in RawPatch
    // Clock groups vary depending on redundancy architecture
    val clkGrps = p.redArch match {
      case RedundancyArch.Shifting =>
        if (shiftCase) {
          txClks.drop(p.redMods).map{ tx =>  // shifted
            val tsrc = tx.bumpName.replace(tx.modCoord.linearIdx.toString,
              (tx.modCoord.linearIdx - p.redMods).toString)
            s"$tsrc io_${tx.bumpName} out_${tx.bumpName}"
          } ++
          txClks.take(p.redMods).map{ tx =>  // dangling
            s"io_${tx.bumpName} out_${tx.bumpName}"
          } ++
          rxClks.drop(p.redMods).map{ rx =>  // shifted
            val rsrc = rx.bumpName.replace(rx.modCoord.linearIdx.toString,
              (rx.modCoord.linearIdx + p.redMods).toString)
            s"$rsrc io_${rx.bumpName} out_${rx.bumpName}"
          } ++
          rxClks.take(p.redMods).map{ rx =>  // dangling redundant
            s"io_${rx.bumpName}"
          } ++
          rxClks.takeRight(p.redMods).map{ rx =>  // dangling direct
            s"${rx.bumpName}"
          }
        } else {
          txClks.dropRight(p.redMods).map{ tx =>  // direct
            s"${tx.bumpName} io_${tx.bumpName} out_${tx.bumpName}"
          } ++
          txClks.takeRight(p.redMods).map{ tx =>  // redundant
            s"io_${tx.bumpName} out_${tx.bumpName}"
          } ++
          rxClks.drop(p.redMods).map{ rx =>  // direct
            s"${rx.bumpName} io_${rx.bumpName} out_${rx.bumpName}"
          } ++
          rxClks.take(p.redMods).map{ rx =>  // dangling redundant
            s"${rx.bumpName} io_${rx.bumpName}"
          }
        }
      case RedundancyArch.Coding =>
        txClks.filter(_.coreSig.isDefined).map{ tx =>
          val tp = tx.bumpName
          val tr = tp.replace("TXCKP", "TXCKR")
          s"$tp io_$tp out_$tp out_$tr"
        } ++
        rxClks.filter(_.coreSig.isDefined).map{ rx =>
          val rp = rx.bumpName
          val rr = rp.replace("RXCKP", "RXCKR")
          s"$rp io_$rp out_$rp $rr"
        }
      case _ =>  // No redundancy
        txClks.map{ tx =>
          s"${tx.bumpName} io_${tx.bumpName} out_${tx.bumpName}"
        } ++
        rxClks.map{ rx =>
          s"${rx.bumpName} io_${rx.bumpName} out_${rx.bumpName}"
        }
    }
    val globalClkSDC = Seq(
      "# Config clock",
      "create_clock clock -name clock -period 1.0",
      "set_clock_uncertainty 0.02 [get_clocks clock]",
      "# Clock groups",
      "set_clock_groups -asynchronous -group {clock} -group { " + (
        clkGrps.mkString(" } -group { ")
      ) + " }",
      "# Propagate clocks in P&R",
      "set_propagated_clock [all_clocks]"
    ).mkString("\n")

    // Data constraints
    val txSigGrouped = bumps.collect{case b: TxSig => b}.groupBy(_.relatedClk.get)
    val rxSigGrouped = bumps.collect{case b: RxSig => b}.groupBy(_.relatedClk.get)
    val sigSDC = (txSigGrouped ++ rxSigGrouped).map{ case(clk, ports) =>
      s"""# Bumps and core signals in clock domain $clk
        |set bumps { ${ports.map(_.bumpName).mkString(" ")} }
        |set core { ${ports.collect{case p if p.coreSig.isDefined => p.coreSig.get.fullName}.mkString(" ")} }
        |${ports(0).sdcConstraints()}
        |""".stripMargin
    }.mkString("\n")

    // Return (order matters!)
    Seq(
      globalSDC,
      caseAnalysis,
      txClkSDC,
      rxClkSDC,
      globalClkSDC,
      sigSDC
    ).mkString("\n\n")
  }

  /** Generates a PNG + PDF file that can be used to visualize the bump map.
    * This uses the scala doodle package and also opens a window for live visualization.
    */
  def toImg(): Unit = {
    require(p.gp.pattern == "square",
      "Only square bump patterns are supported for visualization")
    // Floating point precision
    def roundToNm(x: Double): String = ((x * 1000).round / 1000.0).toString

    // Iterate row-wise (not in reverse order) and column-wise (in reverse order)
    // Scale by factor of 10 for legibility
    val scale = 10.0
    val unitWidth = scale * p.gp.pitchH
    val unitHeight = scale * p.gp.pitchV
    val bumps =  // 2D recursion
      p.bumpMap.foldLeft(Picture.empty)((below, row) =>
        row.reverse.foldLeft(Picture.empty){(right, b) =>
          val bumpText = Picture.text(b.bumpName).scale(scale / 16, scale / 16)
            .above(
              if (b.coreSig.isDefined)
                Picture.text(b.coreSig.get.fullName).scale(scale / 20, scale / 20)
              else Picture.empty
            )
          // An invisible square with a circle inside
          val bumpCircle = Picture.circle(scale * p.gp.pitch / 2)
          val bumpCell = bumpText.on(bumpCircle.fillColor(b match {
            case _: Pwr => Color.red
            case _: Gnd => Color.gray
            case _: TxSig => Color.lightGreen
            case _: RxSig => Color.lightBlue
            case _ => Color.white
          })).on(Picture.rectangle(unitWidth, unitHeight).noFill.noStroke)
          bumpCell.beside(right)
        }.above(below)
      )

    // Overlay a dotted grid for modules
    // Unfortunately, can't get bounding box or size of patch because it's a bug in doodle 0.19.0
    // Fixed for 0.20.0 but that is only available for Scala 3
    // So we have to do it manually - get dimensions of bump map and draw grid
    // (Accounts for default strokeWidth = 1)
    val (bumpsH, bumpsV) = (p.bumpMap(0).length, p.bumpMap.length)
    val bumpsWidth = bumpsH * unitWidth
    val bumpsHeight = bumpsV * unitHeight
    val grid =  // 2D recursion
      (0 until p.modRowsWR).foldLeft(Picture.empty)((below, y) =>
        (0 until p.modColsWR).foldLeft(Picture.empty)((right, x) =>
          Picture.rectangle(bumpsWidth / p.modColsWR - 1,
                            bumpsHeight / p.modRowsWR - 1)
          .strokeColor(Color.gray).strokeDash(Array(scale / 2, scale / 5))
          .beside(right)
        ).above(below)
      )
    // Title
    val titleText = s"""Bump Map: ${bumpsH} x ${bumpsV} bumps at
                        | ${p.gp.pitchH}um x ${p.gp.pitchV}um pitch"""
                        .stripMargin
    val titleBlock = Picture.text(titleText).scale(scale / 5, scale / 5).on(
      Picture.rectangle(bumpsWidth, unitHeight / 2).noFill.noStroke)
    // Rulers
    val leftRulerOffset = if (p.pinSide == "S") p.ip.bumpOffset else 0.0
    val leftRuler =
      (0 until bumpsV).foldLeft(Picture.empty)((below, y) =>
        Picture.text(roundToNm((y + 0.5) * p.gp.pitchV + leftRulerOffset))
        .on(Picture.rectangle(unitWidth, unitHeight).noFill.noStroke)
        .above(below))
      Picture.rectangle(unitWidth / 2, bumpsHeight).noFill.noStroke
    val bottomRulerOffset = if (p.pinSide == "W") p.ip.bumpOffset else 0.0
    val bottomRuler =
      Picture.text("Rulers (um)")
      .on(Picture.rectangle(unitWidth, unitHeight).noFill.noStroke)
      .beside((0 until bumpsH).reverse.foldLeft(Picture.empty)((right, x) =>
        Picture.text(roundToNm((x + 0.5) * p.gp.pitchH + bottomRulerOffset))
        .on(Picture.rectangle(unitWidth, unitHeight).noFill.noStroke)
        .beside(right))
      )
    // Pin placement
    // location is relative to center of bump array
    val pinOffsetX = (p.pinSide match {
      case "W" => -p.ip.bumpOffset * scale
      case "E" => p.ip.bumpOffset * scale
      case _ => 0.0
    }) + unitWidth / 2 - bumpsWidth / 2
    val pinOffsetY = (p.pinSide match {
      case "S" => -p.ip.bumpOffset * scale
      case "N" => p.ip.bumpOffset * scale
      case _ => 0.0
    }) + unitHeight / 2 - bumpsHeight / 2
    val textOffset = scale
    val rotation = p.pinSide match {
      case "N" | "S" => 90.degrees
      case _ => 0.degrees
    }
    val pins = p.flatBumpMap.filter(_.coreSig.isDefined)
      .foldLeft(Picture.empty){ case (on, b) =>
        val coreSig = b.coreSig.get
        val pinSize = p.ip.layerPitch(coreSig.pinLayer) / 1000 * scale
        val locX = coreSig.pinLocation.x * scale + pinOffsetX
        val locY = coreSig.pinLocation.y * scale + pinOffsetY
        val pinText = Picture.text(s"${coreSig.fullName} (${coreSig.pinLayer})")
          .scale(scale / 100, scale / 100).rotate(rotation)
        val pinRect = Picture.rectangle(pinSize, pinSize).at(locX, locY)
          .strokeColor(Color.black).strokeWidth(scale / 200)
        (p.pinSide match {
          case "N" => pinText.at(locX, locY + textOffset)
          case "S" => pinText.at(locX, locY - textOffset)
          case "E" => pinText.at(locX + textOffset, locY)
          case "W" => pinText.at(locX - textOffset, locY)
        }).on(pinRect).on(on)
      }

    // Final pic
    val bumpMapPic = titleBlock
                     .above(pins
                       .on(leftRuler
                         .beside(bumps.on(grid))
                       .above(bottomRuler)
                       )
                     )

    // Vector
    bumpMapPic.write[Pdf]("bumpmap.pdf")
    // Scalar
    bumpMapPic.write[Png]("bumpmap.png")
    // Live window (2x2 pixels = 1um^2)
    bumpMapPic.scale(2 / scale, 2 / scale).draw()
  }
}