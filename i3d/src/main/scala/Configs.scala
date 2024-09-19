package i3d

import chisel3._

import org.chipsalliance.cde.config._

/** I3D Config Keys */
case object I3DGlblKey extends Field[I3DGlblParams]
case object I3DInstKey extends Field[I3DInstParams]
case object I3DKey extends Field[I3DParams]

/**
  * Global I3D Configs
  * When running the Generator, select one of these configs for the implicit params.
  */

class I3DBaseConfig extends Config ((site, here, up) => {
  case I3DGlblKey => I3DGlblParams(
    dataBundle = new ExampleArrayBundle(4, 9, 8),
    pitch = 10.0,
    redundRatio = 2,
    modSize = 72,
    pinSide = "W",
    sigsPerPGOvrdV = Some(3),
    sigsPerPGOvrdH = Some(5))
  case I3DInstKey => I3DInstParams(
    layerPitch = Map("m4" -> 90.0, "m6" -> 90.0),
    viaKOZRatio = 0.3,
    tsvKOZRatio = Some(0.6),
    vNom = 0.8,
    isLeader = true,
    bumpOffset = 0,
    blackBoxModels = true)
  case I3DKey => I3DParams(here(I3DGlblKey), here(I3DInstKey))
})

class I3DWideConfig extends Config ((site, here, up) => {
  case I3DGlblKey => I3DGlblParams(
    dataBundle = new ExampleArrayBundle(4, 9, 8),
    pitch = 9.0,
    redundRatio = 2,
    modSize = 72,
    pinSide = "N",
    sigsPerPGOvrdV = Some(3),
    sigsPerPGOvrdH = Some(4))
  case I3DInstKey => I3DInstParams(
    layerPitch = Map("m3" -> 90.0, "m5" -> 90.0),
    viaKOZRatio = 0.3,
    tsvKOZRatio = Some(0.75),
    vNom = 0.8,
    isLeader = true,
    bumpOffset = 0,
    blackBoxModels = true)
  case I3DKey => I3DParams(here(I3DGlblKey), here(I3DInstKey))
})

class I3DCoding5Config extends Config ((site, here, up) => {
  case I3DGlblKey => I3DGlblParams(
    dataBundle = new ExampleArrayBundle(4, 9, 8),
    dataStatistic = "sequential",
    pitch = 9.0,
    redundArch = 1,
    maxParticleSize = 5,
    hasDBI = true,
    modSize = 72,
    pinSide = "N")
  case I3DInstKey => I3DInstParams(
    layerPitch = Map("m3" -> 90.0, "m5" -> 90.0),
    viaKOZRatio = 0.3,
    tsvKOZRatio = Some(0.75),
    vNom = 0.8,
    isLeader = true,
    bumpOffset = 0,
    blackBoxModels = true)
  case I3DKey => I3DParams(here(I3DGlblKey), here(I3DInstKey))
})

class I3DCoding9Config extends Config ((site, here, up) => {
  case I3DGlblKey => I3DGlblParams(
    dataBundle = new ExampleArrayBundle(4, 9, 8),
    dataStatistic = "sequential",
    pitch = 9.0,
    redundArch = 1,
    maxParticleSize = 3,
    hasDBI = true,
    modSize = 72,
    pinSide = "N")
  case I3DInstKey => I3DInstParams(
    layerPitch = Map("m3" -> 90.0, "m5" -> 90.0),
    viaKOZRatio = 0.3,
    tsvKOZRatio = Some(0.75),
    vNom = 0.8,
    isLeader = true,
    bumpOffset = 0,
    blackBoxModels = true)
  case I3DKey => I3DParams(here(I3DGlblKey), here(I3DInstKey))
})