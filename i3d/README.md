aib3d-phy-hardware
==================

This is the Chisel generator for the AIB-3D PHY RTL. Technology-specific cells are not included in this generator; they must be added as a mixin.

## Usage

### Chipyard

This repository relies on Chipyard. Refer to the Chipyard documentation for how to add this project as a generator submodule. In the Chipyard build.sbt, add the following:

```
lazy val aib3d = (project in file("generators/aib3d-phy-hardware"))
  .dependsOn(rocketchip)
  .settings(libraryDependencies ++= rocketLibDeps.value)
  .settings(libraryDependencies ++= Seq("edu.berkeley.cs" %% "chiseltest" % "0.5.2"))
  .settings(commonSettings)
```

**_NOTE:_** The `chiseltest` version must be compatible with the Chisel3 version. See the Chisel project version compatibility matrix in the Chisel documentation.

### Generator

WIP

### Unit Tests

WIP

## Diagrams

WIP

## Repository Structure

WIP