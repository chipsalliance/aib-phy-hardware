Code Organization
=================

This is a rundown of how the code is structured.
All Chisel code is contained inside `src/main/scala` and external tool scripts are contained inside `scripts`.

## Generator, Configs, and Parameters

The generator object is contained within `Generator.scala`.
There is a choice of two objects:
- `I3DGenerator` is the baseline implementation. It includes code for selecting between a Tilelink and AXI4 implementation of a bus for memory-mapped control registers.
- `I3DRawGenerator` removes the buses and exposes control registers as raw ports.

Inside the object, you must select the generator config class to elaborate.
There are a few examples from `Configs.scala`, each of which lists overrides for the parameter defaults from `Params.scala` (see `docs/Params.md` for more details).
When writing your own config, ensure the right parameter definition goes in the respective `I3DGlblKey` and `I3DInstKey` case objects.

When the `implicit val p = new Config(...` is set, all the parameter calculations in `Params.scala` are run and then stored for implicit use by the rest of the generator.
The calculations go from parameter checking all the way to creating the final bump mapping data structure.
Notice that many calculation routines call functions defined in `Utils.scala`.
Many data structs for bump mapping are defined `io/Containers.scala`.

## Hardware

Depending on the generator object selected, one of the `RawModule`s in `Patch.scala` is elaborated.
- Bundles (i.e., ports) are defined in `Bundles.scala`.
- IO cells are defined in `io/IOCell.scala`.
- The redundancy modules are defined in `redundancy/Redundancy.scala`.

Refer to Chipyard/Rocket-chip documentation for how the register mapping works.

## Collateral

At the bottom of the `BasePatch` trait in `Patch.scala`, a `GenCollateral` instance is created.
Functions for auto-generating documentation and collateral are defined in `Collateral.scala`.

## Scripts

There is a script to dump Innovus static timing analysis results in a tabular format for graphical analysis in `scripts/innovus_timing_dump.tcl`.
