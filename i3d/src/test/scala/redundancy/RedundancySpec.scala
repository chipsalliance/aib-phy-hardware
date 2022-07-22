package aib3d.redundancy

import chisel3._
import chiseltest._
import chisel3.stage.PrintFullStackTraceAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import freechips.rocketchip.config._
import aib3d._

class RedundancyShiftLogicSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "RedundancyShiftLogic"

  it should "generate shift bits properly" in {
    implicit val p: Parameters = new AIB3DBalancedConfig(16)
    test(new RedundancyShiftLogic()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
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

  def debugBits(dut: RedundancyWrapper)(implicit p: Parameters): Unit = {
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
		test(new RedundancyWrapper()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
      // make 2nd bump faulty (bits 21:2 need to be 1)
      dut.shift.poke(0x3FFFFC.U)
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
      // set patch_detect = 1, should shift
      dut.in(p(AIB3DKey).porIdx.last).async.poke(1.U)
      dut.out(p(AIB3DKey).porIdx.last).async.expect(0.U)
      dut.out(p(AIB3DKey).sparesIdx.last).async.expect(1.U)
      // set fs_transfer_en = 1, should not shift
      dut.in(p(AIB3DKey).sparesIdx.end).data.poke(1.U)
      dut.out(p(AIB3DKey).sparesIdx.end).data.expect(1.U)
      dut.out(p(AIB3DKey).sparesIdx.end+2).data.expect(0.U)

      debugBits(dut)(p)
    } 
  }

  it should "shift down properly" in {
    implicit val p: Parameters = new AIB3DBalancedConfig(16)
		test(new RedundancyWrapper()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
      // make 3rd to last bump faulty (bits 41:24 need to be 1)
      dut.shift.poke(BigInt("3FFFF000000", 16).U)
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
      // set patch_detect = 1, should not shift
      dut.in(p(AIB3DKey).porIdx.last).async.poke(1.U)
      dut.out(p(AIB3DKey).porIdx.last).async.expect(1.U)
      dut.out(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
      // set fs_transfer_en = 1, should shift
      dut.in(p(AIB3DKey).sparesIdx.end).data.poke(1.U)
      dut.out(p(AIB3DKey).sparesIdx.end).data.expect(0.U)
      dut.out(p(AIB3DKey).sparesIdx.end+2).data.expect(1.U)

      debugBits(dut)(p)
    } 
  }
}

class RedundancyTopSpec extends AnyFlatSpec with ChiselScalatestTester {
	behavior of "RedundancyTop"

  def debugTx(dut: RedundancyTop)(implicit p: Parameters): Unit = {
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

  def debugRx(dut: RedundancyTop)(implicit p: Parameters): Unit = {
    // debug print which bits are 1 (more limited)
    println("rx")
    for (i <- 0 until p(AIB3DKey).numRxIOs) {
      if (dut.adapter(s"rx_$i").peek().litValue == 1) println(i)
    }
    if (dut.adapter("fs_transfer_reset").peek().litValue == 1) println(p(AIB3DKey).numRxIOs)
    if (dut.adapter("fs_transfer_en").peek().litValue == 1) println(p(AIB3DKey).numRxIOs+1)
  }

	def shiftUpTest(dut: RedundancyTop)(implicit p: Parameters): Unit = {
		dut.csrs.faulty.poke(2.U)
    // Tx should shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(4).data.expect(1.U)
    // Rx should not shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(1.U)
    // patch_detect should shift
		dut.to_pad(p(AIB3DKey).porIdx.last).async.expect(0.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(1.U)
    // fs_transfer_en should not shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(0.U)
    dut.adapter("fs_transfer_en").expect(1.U)
	}

  def shiftDownTest(dut: RedundancyTop)(implicit p: Parameters): Unit = {
		dut.csrs.faulty.poke((p(AIB3DKey).patchSize-3).U)
    // Tx should not shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(2).data.expect(1.U)
    // Rx should shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(0.U)
    // patch_detect should not shift
		dut.to_pad(p(AIB3DKey).porIdx.last).async.expect(1.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
    // fs_transfer_en should shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(1.U)
    dut.adapter("fs_transfer_en").expect(0.U)
	}

  def noShiftTest(dut: RedundancyTop)(implicit p: Parameters): Unit = {
		dut.csrs.faulty.poke(p(AIB3DKey).sparesIdx.head.U)
    // Tx should not shift
    dut.to_pad(0).data.expect(1.U)
		dut.to_pad(2).data.expect(1.U)
		dut.to_pad(4).data.expect(0.U)
    // Rx should not shift
    dut.adapter("rx_0").expect(1.U)
    dut.adapter("rx_2").expect(1.U)
    // patch_detect should not shift
		dut.to_pad(p(AIB3DKey).porIdx.last).async.expect(1.U)
		dut.to_pad(p(AIB3DKey).sparesIdx.last).async.expect(0.U)
    // fs_transfer_en should not shift
    val rxLast = p(AIB3DKey).numRxIOs-1
    dut.adapter(s"rx_$rxLast").expect(0.U)
    dut.adapter("fs_transfer_en").expect(1.U)
	}

	it should "shift inputs properly" in {
    implicit val p: Parameters = new AIB3DBaseConfig
		test(new RedundancyTop()(p)).withAnnotations(Seq(PrintFullStackTraceAnnotation)) { dut =>
			println("Testing RedundancyTop")
			// init inputs
			dut.csrs.pad_rstb.poke(true.B)
			dut.csrs.pad_en.poke(true.B)
			dut.csrs.leader.poke(true.B)
      
      // Test 2nd, 2nd to last, and spare bumps

		  // Set tx(0) = 1 and tx(2) = 1
		  dut.adapter("tx_0").poke(1.U)
		  dut.adapter("tx_2").poke(1.U)
      dut.adapter("tx_4").poke(0.U)

      // Set rx(0) = 1, rx(2) = 1
		  dut.from_pad(p(AIB3DKey).patchSize-1).data.poke(1.U)
		  dut.from_pad(p(AIB3DKey).patchSize-3).data.poke(1.U)
		  dut.from_pad(p(AIB3DKey).patchSize-5).data.poke(0.U)

      // Set patch_detect
		  dut.adapter("patch_detect_out").poke(1.U)

      // Set fs_transfer_en
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