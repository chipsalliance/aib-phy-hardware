// See README.md for license details.

// ThisBuild / scalaVersion     := "2.13.8"
// ThisBuild / version          := "0.1.0"
// ThisBuild / organization     := "com.github.harrisonliew"

// val chiselVersion = "3.5.1"

// lazy val root = (project in file("."))
//   .settings(
//     name := "aib3d",
//     libraryDependencies ++= Seq(
//       "edu.berkeley.cs" %% "chisel3" % chiselVersion,
//       "edu.berkeley.cs" %% "chiseltest" % "0.5.1" % "test"
//     ),
//     scalacOptions ++= Seq(
//       "-language:reflectiveCalls",
//       "-deprecation",
//       "-feature",
//       "-Xcheckinit",
//       "-P:chiselplugin:genBundleElements",
//     ),
//     addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full),
//   )

organization := "edu.berkeley.cs"
version := "0.1"
name := "aib3d"
scalaVersion := "2.13.10"

libraryDependencies += "org.creativescala" %% "doodle" % "0.19.0"