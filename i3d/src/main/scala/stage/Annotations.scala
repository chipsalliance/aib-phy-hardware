package aib3d.stage

import chisel3._

import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations._
import scala.collection.immutable.ListMap
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}

import aib3d.io._

/** Record a bump assignment */
case class BumpMapAnnotation(target: Named, mapping: Seq[AIB3DBump]) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)
}

/** Generate bump map collateral */
object GenBumpMapAnno {
  def anno(
    rawModule: RawModule,
    mapping: Seq[AIB3DBump]
  ): Seq[AIB3DBump] = {

    // Annotate module with the bump map
    annotate(new ChiselAnnotation {
      def toFirrtl = BumpMapAnnotation(rawModule.toNamed, mapping)
    })

    mapping
  }

  def toJSON(
    mapping: Seq[AIB3DBump]
  ): String = {
    s"""{\n  "bump_map": [\n""" +
    mapping.map { case b =>
      s"""    "${b.bumpName}":"${b.location.get.x}, ${b.location.get.y}""""
    }.mkString(",\n") +
    "\n  ]\n}"
  }

  def toCSV(
    mapping: Seq[AIB3DBump]
  ): String = {
    "Bump,Signal\n"+
    mapping.map { case b =>
      s"${b.bumpName},${b.location.get.x},${b.location.get.y}"
    }.mkString("\n")
  }
}