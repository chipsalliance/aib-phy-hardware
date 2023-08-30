package aib3d

import chisel3._

import org.chipsalliance.cde.config._

/** AIB3D Config Keys */
case object AIB3DGlblKey extends Field[AIB3DGlblParams]
case object AIB3DInstKey extends Field[AIB3DInstParams]
case object AIB3DKey extends Field[AIB3DParams]

/**
  * Global AIB3D Configs
  * When running the Generator, select one of these configs for the implicit params.
  */

class AIB3DBaseConfig extends Config ((site, here, up) => {
  case AIB3DGlblKey => AIB3DGlblParams(dataBundle = new DefaultDataBundle(72*2),
                                      redundRatio=1,
                                      submodSize = 80,
                                      pinSide = "W",
                                      sigsPerPGOvrdV = Some(3),
                                      sigsPerPGOvrdH = Some(5))
  case AIB3DInstKey => AIB3DInstParams(isLeader = true,
                                      bumpOffset = 0,
                                      blackBoxModels = true)
  case AIB3DKey => AIB3DParams(here(AIB3DGlblKey), here(AIB3DInstKey))
})

/*
class AIB3DHalfConfig extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(128, 128)
})

class AIB3DBalancedConfig(val numIOs: Int) extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(numIOs, numIOs)
})

// TODO: below configs are not yet supported.
class AIB3DUnbalancedConfig(val numTx: Int, val numRx: Int) extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(numTx, numRx)
})

class AIB3DAllTxConfig(val numTx: Int) extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(numTx, 0)
})

class AIB3DAllRxConfig(val numRx: Int) extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(0, numRx)
})

class AIB3DBiDirConfig(val numIOs: Int) extends Config ((site, here, up) => {
  case AIB3DInstDsnKey => AIB3DInstDsnParams(numIOs, numIOs)
})
*/