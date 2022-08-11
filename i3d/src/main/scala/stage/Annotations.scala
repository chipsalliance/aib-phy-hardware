package aib3d.stage

import chisel3._

import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations._
import scala.collection.immutable.ListMap
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods.{pretty, render}

import aib3d.AIB3DIO

/** Record a bump assignment */
case class BumpMapAnnotation(target: Named, mapping: ListMap[String, AIB3DIO]) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)
}

/** Generate bump map collateral */
object GenBumpMapAnno {
  def anno(
    rawModule: RawModule,
    mapping: ListMap[String, AIB3DIO]
  ): ListMap[String, AIB3DIO] = {

    // Annotate module with the bump map
    annotate(new ChiselAnnotation {
      def toFirrtl = BumpMapAnnotation(rawModule.toNamed, mapping)
    })

    mapping
  }

  def toJSON(
    mapping: ListMap[String, AIB3DIO]
  ): String = { 
    s"""{\n  "bump_map": [\n""" +
    mapping.map { case(n, t) =>
      s"""    "aib_${t.bumpNum}":"${n}""""
    }.mkString(",\n") +
    "\n  ]\n}"
  }

  def toCSV(
    mapping: ListMap[String, AIB3DIO]
  ): String = {
    "Bump,Signal\n"+
    mapping.map { case(n, t) => 
      s"aib_${t.bumpNum},$n"
    }.mkString("\n")
  }
}