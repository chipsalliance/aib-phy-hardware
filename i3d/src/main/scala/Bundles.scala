package aib3d

import scala.collection.immutable.SeqMap

import chisel3._

import chisel3.experimental.{Analog, DataMirror}
import chisel3.util.log2Ceil
import freechips.rocketchip.config.Parameters

import aib3d.io._

/** Top-level and adapter bundles */
class BumpsBundle(atBumps: Boolean)(implicit p: Parameters) extends Record {
  // Filter out power and ground bumps
  val sigBumps: Seq[AIB3DBump] = p(AIB3DKey).flatBumpMap.filter(b => b match {
    case _:Pwr | _:Gnd => false
    case _ => true
  })
  // elements map is the bump name -> ioType
  val elements: SeqMap[String, Data] = SeqMap(sigBumps.map(b => b.bumpName -> {
    if (atBumps) Analog(1.W)  // Analog type for bump pads
    else if (b.coreSig.isDefined) b.coreSig.get.ioType
    else (b match {
      case _:TxSig => Output(UInt(1.W))
      case _:RxSig => Input(UInt(1.W))
      case _:TxClk => Output(Clock())
      case _:RxClk => Input(Clock())
      case _ => throw new Exception("Should not get here")
  })}):_*)
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new BumpsBundle(atBumps)).asInstanceOf[this.type]

  // Connect the correct bumps in this bundle to the corresponding submodule bundle
  def connectToMux(that: SubmodBundle): Unit = {
    that.elements foreach { elt => elt._2 <> elements(elt._1) }
  }

  // Get related clock for a bump
  def getRelatedClk(bumpName: String): Clock = {
    val bump = sigBumps.find(b => b.bumpName == bumpName).get
    bump match {
      case _:TxClk | _:RxClk => elements(bumpName).asUInt(0).asClock
      case _ =>
        if (bump.coreSig.isDefined) {
          elements(bump.coreSig.get.relatedClk.get).asUInt(0).asClock
        } else {
          val submodNum = bump.submodIdx.get.linearIdx
          bump match {
            case _:TxSig => elements(s"TXCKP${submodNum}").asUInt(0).asClock
            case _:RxSig => elements(s"RXCKP${submodNum}").asUInt(0).asClock
            case _ => throw new Exception("Should not get here")
          }
        }
    }
  }
}

class CoreBundle(implicit p: Parameters) extends Record {
  val params = p(AIB3DKey)

  // Filter out power and ground bumps, and coreSig must be defined
  val coreSigs: Seq[AIB3DBump] = params.flatBumpMap.filter(b => b match {
    case _:Pwr | _:Gnd => false
    case _ => b.coreSig.isDefined
  })
  // elements map is the coreSig name + bitIdx -> Flipped(ioType)
  val elements: SeqMap[String, Data] = SeqMap(coreSigs.map{c =>
    val sig = c.coreSig.get
    if (sig.bitIdx.isDefined) sig.name + "[" + sig.bitIdx.get.toString + "]" -> Flipped(sig.ioType)
    else sig.name -> Flipped(sig.ioType)
  }:_*)
	def apply(elt: String): Data = elements(elt)
	override def cloneType = (new CoreBundle).asInstanceOf[this.type]

  // Connect the correct core signals in this bundle to the corresponding submodule bundle
  def connectToMux(that: SubmodBundle): Unit = {
    if (that.submodIdx.isRedundant) {  // redundant submodule, tie to 0
      that.elements.values foreach ( d => d := 0.U.asTypeOf(d) )
    } else that.elements foreach ( elt => elt._2 <> elements(elt._1) )
  }

  // Get related clock for a core signal
  def getRelatedClk(coreSigName: String): Clock = {
    val sig = coreSigs.find(c => c.coreSig.get.name == coreSigName).get
    require(sig.coreSig.isDefined, s"Cannot get related clock for core signal ${coreSigName}")
    sig.coreSig.get.relatedClk.get.asUInt(0).asClock
  }
}

/** Submod-specific bundle, used for redundancy muxes*/
class SubmodBundle(val submodIdx: AIB3DCoordinates[Int], coreFacing: Boolean)(implicit p: Parameters) extends Record {
  val params = p(AIB3DKey)

  // First, extract the bumps corresponding to this submod index
  val submodSigs: Seq[AIB3DBump] = params.flatBumpMap.filter(b => b match {
    case _:Pwr | _:Gnd => false
    case _ => b.submodIdx.get == submodIdx  // submodIdx should be defined for all non-power/ground bumps
  })

  // elements map is the bump/core signal name -> ioType
  // If this bundle is core-facing, get the coreSig name
  // Else, get the bumpName
  val elements: SeqMap[String, Data] = SeqMap(submodSigs.map(b => {
    if (submodIdx.isRedundant) {  // redundant submodule, get from bumpName
      // TODO: make this more elegant than a string search
      val dtype = if (b.bumpName.contains("CK")) Clock() else UInt(1.W)
      b.bumpName -> (
        if (coreFacing ^ b.bumpName.contains("TX")) Output(dtype)
        else Input(dtype))
    } else if (coreFacing) {  // core facing, get from coreSig name and flip IO
      b.coreSig.get.name + (
        if (b.coreSig.get.bitIdx.isDefined) "[" + b.coreSig.get.bitIdx.get.toString + "]" else ""
      ) -> Flipped(b.coreSig.get.ioType)
    } else b.bumpName -> b.coreSig.get.ioType  // bump facing, get from bumpName
  }):_*)
  def apply(elt: String): Data = elements(elt)
  override def cloneType = (new SubmodBundle(submodIdx, coreFacing)).asInstanceOf[this.type]
}

class DefaultDataBundle extends Bundle {
  val tx = Output(UInt((64*8).W))
  val rx = Input(UInt((64*8).W))
}