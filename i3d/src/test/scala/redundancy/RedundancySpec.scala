package aib3d.redundancy

import chisel3._
import chiseltest._
import chisel3.stage.PrintFullStackTraceAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import freechips.rocketchip.config._
import aib3d._


// Wrap RawModules as Modules for test
class RedundancyShiftLogicWrapMod(implicit val p: Parameters) extends Module with RedundancyShiftLogicIO {
  val mod = Module(new RedundancyShiftLogic)
  mod.faulty := faulty
  shift := mod.shift
}

class RedundancyWrapperWrapMod(implicit val p: Parameters) extends Module with RedundancyWrapperIO {
  val mod = Module(new RedundancyWrapper)
  mod.shift := shift
  mod.in <> in
  mod.out <> out
}

class RedundancyTopWrapMod(implicit val p: Parameters) extends Module with RedundancyTopIO {
  val mod = Module(new RedundancyTop)
  mod.from_pad <> from_pad
  mod.to_pad <> to_pad
  mod.adapter <> adapter
  mod.cfg <> cfg
}

class RedundancyShiftLogicSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "RedundancyShiftLogic"

  it should "generate shift bits properly" in {
    implicit val p: Parameters = new AIB3DBalancedConfig(16)
    test(new RedundancyShiftLogicWrapMod()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
      def getShiftBits: Unit = {
        val shift = dut.shift.peek().litValue
        // print bits
        for (i <- (0 until (16+4+2+2+4+16)).reverse) {
          print((shift >> i) % 2)
        }
        println("")
      }
      // make 2nd bump faulty
      dut.faulty.poke(2.U)
      getShiftBits
      // make 3rd from last bump faulty
      dut.faulty.poke(p(AIB3DKey).patchSize-3)
      getShiftBits
    }
  }
}

class RedundancyWrapperSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "RedundancyWrapper"

  def debugBits(dut: RedundancyWrapperWrapMod)(implicit p: Parameters): Unit = {
    // debug print which bits are 1
    println("data")
    for (i <- (0 until p(AIB3DKey).patchSize).reverse) {
      if (dut.out(i).data.peek().litValue == 1) println(i)
    }
    println("async")
    for (i <- (0 until p(AIB3DKey).patchSize).reverse) {
      if (dut.out(i).async.peek().litValue == 1) println(i)
    }
  }

  it should "shift up properly" in {
    implicit val p: Parameters = new AIB3DBalancedConfig(16)
		test(new RedundancyWrapperWrapMod()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
      // make 2nd bump faulty (bits 19:2 need to be 1)
      dut.shift.poke(0xFFFFC.U)
      dut.in.foreach(_.data.poke(0.U))
      dut.in.foreach(_.async.poke(0.U))
      // set data(0) = 1, should not shift
      dut.in(0).data.poke(1.U)
      dut.out(0).data.expect(1.U)
      // set data(2) = 1, should shift
      dut.in(2).data.poke(1.U)
      dut.out(4).data.expect(1.U)
      // set data(end-2) = 1, should not shift
      dut.in(p(AIB3DKey).patchSize-3).data.poke(1.U)
      dut.out(p(AIB3DKey).patchSize-1).data.expect(0.U)
      dut.out(p(AIB3DKey).patchSize-3).data.expect(1.U)
      // set ns_patch_por = 1, should shift
      dut.in(p(AIB3DKey).txCtrlIdx.last).async.poke(1.U)
      dut.out(p(AIB3DKey).txCtrlIdx.last).async.expect(0.U)
      dut.out(p(AIB3DKey).sparesIdx.last).async.expect(1.U)
      // set fs_patch_por = 1, should not shift
      dut.in(p(AIB3DKey).rxCtrlIdx.head).data.poke(1.U)
      dut.out(p(AIB3DKey).rxCtrlIdx.head).data.expect(1.U)
      dut.out(p(AIB3DKey).rxCtrlIdx.head+2).data.expect(0.U)

      debugBits(dut)(p)
    } 
  }

  it should "shift down properly" in {
    implicit val p: Parameters = new AIB3DBalancedConfig(16)
		test(new RedundancyWrapperWrapMod()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
      // make 3rd to last bump faulty (bits 39:22 need to be 1)
      dut.shift.poke(BigInt("FFFFC00000", 16).U)
      dut.in.foreach(_.data.poke(0.U))
      dut.in.foreach(_.async.poke(0.U))
      // set data(0) and data(2) = 1, should not shift
      dut.in(0).data.poke(1.U)
      dut.in(2).data.poke(1.U)
      dut.out(0).data.expect(1.U)
      dut.out(2).data.expect(1.U)
      // set data(end-1) = 1, should not shift
      dut.in(p(AIB3DKey).patchSize-1).data.poke(1.U)
      dut.out(p(AIB3DKey).patchSize-1).data.expect(1.U)
      // set data(end-3) = 1, should shift
      dut.in(p(AIB3DKey).patchSize-3).data.poke(1.U)
      dut.out(p(AIB3DKey).patchSize-3).data.expect(0.U)
      // set ns_patch_por = 1, should not shift
      dut.in(p(AIB3DKey).txCtrlIdx.last).async.poke(1.U)
      dut.out(p(AIB3DKey).txCtrlIdx.last).async.expect(1.U)
      dut.out(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
      // set fs_patch_por = 1, should shift
      dut.in(p(AIB3DKey).rxCtrlIdx.head).data.poke(1.U)
      dut.out(p(AIB3DKey).rxCtrlIdx.head).data.expect(0.U)
      dut.out(p(AIB3DKey).rxCtrlIdx.head+2).data.expect(1.U)

      debugBits(dut)(p)
    } 
  }
}

class RedundancyTopSpec extends AnyFlatSpec with ChiselScalatestTester {
	behavior of "RedundancyTop"

  def debugTx(dut: RedundancyTopWrapMod)(implicit p: Parameters): Unit = {
    // debug print which bits are 1
    println("data")
    for (i <- 0 until p(AIB3DKey).patchSize) {
      if (dut.to_pad(i).data.peek().litValue == 1) println(i)
    }
    println("async")
    for (i <- 0 until p(AIB3DKey).patchSize) {
      if (dut.to_pad(i).async.peek().litValue == 1) println(i)
    }
  }

  def debugRx(dut: RedundancyTopWrapMod)(implicit p: Parameters): Unit = {
    // debug print which bits are 1 (more limited)
    println("rx")
    for (i <- 0 until p(AIB3DKey).numRxIOs) {
      if (dut.adapter(s"rx_$i").peek().litValue == 1) println(i)
    }
    if (dut.adapter("fs_transfer_en").peek().litValue == 1) println(p(AIB3DKey).numRxIOs)
    if (dut.adapter("fs_patch_por").peek().litValue == 1) println(p(AIB3DKey).numRxIOs+1)
  }

	def shiftUpTest(dut: RedundancyTopWrapMod)(implicit p: Parameters): Unit = {
		dut.cfg.faulty.poke(2.U)
    // Tx should shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(4).data.expect(1.U)
    // Rx should not shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(1.U)
    // ns_patch_por should shift
		dut.to_pad(p(AIB3DKey).txCtrlIdx.last).async.expect(0.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(1.U)
    // fs_patch_por should not shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(0.U)
    dut.adapter("fs_patch_por").expect(1.U)
	}

  def shiftDownTest(dut: RedundancyTopWrapMod)(implicit p: Parameters): Unit = {
		dut.cfg.faulty.poke((p(AIB3DKey).patchSize-3).U)
    // Tx should not shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(2).data.expect(1.U)
    // Rx should shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(0.U)
    // ns_patch_por should not shift
		dut.to_pad(p(AIB3DKey).txCtrlIdx.last).async.expect(1.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
    // fs_patch_por should shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(1.U)
    dut.adapter("fs_patch_por").expect(0.U)
	}

  def noShiftTest(dut: RedundancyTopWrapMod)(implicit p: Parameters): Unit = {
		dut.cfg.faulty.poke(p(AIB3DKey).sparesIdx.head.U)
    // Tx should not shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(2).data.expect(1.U)
		dut.to_pad(4).data.expect(0.U)
    // Rx should not shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(1.U)
    // ns_patch_por should not shift
		dut.to_pad(p(AIB3DKey).txCtrlIdx.last).async.expect(1.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
    // fs_patch_por should not shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(0.U)
    dut.adapter("fs_patch_por").expect(1.U)
	}

	it should "shift inputs properly" in {
    implicit val p: Parameters = new AIB3DBaseConfig
		test(new RedundancyTopWrapMod()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
			println("Testing RedundancyTop")
			// init inputs
			dut.cfg.pad_rstb.poke(true.B)
			dut.cfg.pad_en.poke(true.B)
			dut.cfg.leader.poke(true.B)
      
      // Test 2nd, 2nd to last, and spare bumps

		  // Set tx(0) = 1 and tx(2) = 1
		  dut.adapter("tx_0").poke(1.U)
		  dut.adapter("tx_2").poke(1.U)
      dut.adapter("tx_4").poke(0.U)

      // Set rx(0) = 1, rx(2) = 1
		  dut.from_pad(p(AIB3DKey).patchSize-1).data.poke(1.U)
		  dut.from_pad(p(AIB3DKey).patchSize-3).data.poke(1.U)
		  dut.from_pad(p(AIB3DKey).patchSize-5).data.poke(0.U)

      // Set ns_patch_por
		  dut.adapter("ns_patch_por").poke(1.U)

      // Set fs_patch_por
      dut.from_pad(p(AIB3DKey).sparesIdx.end).async.poke(1.U)
      // For shift down test, it'll be configured as data instead
      dut.from_pad(p(AIB3DKey).sparesIdx.end).data.poke(1.U)

      println(p(AIB3DKey).sparesIdx.head)
      println(p(AIB3DKey).sparesIdx.last)
      println(p(AIB3DKey).sparesIdx.end)

			fork { 
        shiftUpTest(dut)(p)
        println("shift up test:")
        debugTx(dut)(p)
        debugRx(dut)(p)
      }
      fork {
        shiftDownTest(dut)(p)
        println("shift down test:")
        debugTx(dut)(p)
        debugRx(dut)(p)
      }
      fork {
        noShiftTest(dut)(p)
        println("no shift test:")
        debugTx(dut)(p)
        debugRx(dut)(p)
      }.join
		}
	}
}