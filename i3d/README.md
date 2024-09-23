i3d-phy-hardware
==================

This is the [Chisel](https://www.chisel-lang.org) generator for the I3D (formerly AIB-3D) PHY RTL. Technology-specific cells are not included in this generator; they must be added as a mixin.

## Usage

### Chipyard

This repository relies on [Chipyard](https://github.com/ucb-bar/chipyard) version 1.10.0 at this time. Refer to the Chipyard documentation for how to add this project as a generator submodule. In the Chipyard `build.sbt`, add the following:

```
lazy val i3d = (project in file("generators/i3d-phy-hardware"))
  .dependsOn(rocketchip, tapeout, iocell, testchipip)
  .settings(libraryDependencies ++= rocketLibDeps.value)
  .settings(commonSettings)
```

When setting up Chipyard, you do not need to do any of the steps to build the toolchain, FireSim, or Marshal. Mainly, this repository depends on `rocket-chip`, `testchipip`, and `barstools`.

### Generator

After starting the sbt server, run the following command to generate the baseline I3D PHY RTL and all collateral into the root of the Chipyard workspace:

```
project i3d
runMain i3d.I3DGenerator
```

## Documentation

An overview of how this code works is given in the following [paper](https://ieeexplore.ieee.org/document/10681023).
Please cite it if you use this code.

> H. Liew, F. Sheikh, J. -R. Guo, Z. Wu and B. Nikolić, "A Chisel Generator for Standardized 3D Die-to-Die Interconnects," in IEEE Journal on Exploratory Solid-State Computational Devices and Circuits, doi: 10.1109/JXCDC.2024.3461471.

A deeper dive is given in Chapter 5 of this [dissertation](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2024/EECS-2024-178.html).
While physical design flow scripts are not included in this repository, recommendations are given here.

Refer to the `docs/Params.md` for more details about parameters and `docs/Code.md` for a description of how the code is organized and executed.
