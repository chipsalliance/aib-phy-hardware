package aib3d.adapter

import chisel3._

import chisel3.experimental.Analog
import freechips.rocketchip.config.Parameters
import scala.collection.immutable.ListMap

import aib3d._

/** This generates the translation from adapter data to redundancy block */
class AdapterToRedundancyBundle(implicit p: Parameters) extends Record {
  val elements = p(AIB3DKey).adapterIoMap
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new AdapterToRedundancyBundle).asInstanceOf[this.type]
}
