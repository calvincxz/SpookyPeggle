////
////  PeggleGameEngineTest.swift
////  PS3Tests
////
////  Created by Calvin Chen on 13/2/20.
////  Copyright © 2020 Calvin Chen. All rights reserved.
////
//
//import XCTest
//@testable import PS3
//
///**
//Only basic methods of the `PeggleGameEngine` is tested.
//The rest is left for integration testing.
//*/
//class PeggleGameEngineTest: XCTestCase {
//
//    let testEngine = PeggleGameEngine(area: CGSize(width: 10, height: 10))
//    let bluePeg = CirclePeg(withType: PegType.blue, centre: CGPoint.zero)
//    let orangePeg = CirclePeg(withType: PegType.orange, centre: CGPoint.zero)
//
//    func testAddBall() {
//        let ball = GameBall(centre: CGPoint.zero)
//        testEngine.addBall(ball: ball, angle: CGFloat.zero)
//
//        XCTAssertEqual(testEngine.getBall(), ball, "Add ball success")
//    }
//
//    func removeBall_nonExistingBall() {
//        testEngine.removeBall()
//        XCTAssertNil(testEngine.getBall(), "Remove ball success")
//    }
//
//    func removeBall_existingBall() {
//        let ball = GameBall(centre: CGPoint.zero)
//        testEngine.addBall(ball: ball, angle: CGFloat.zero)
//        testEngine.removeBall()
//        XCTAssertNil(testEngine.getBall(), "Remove ball success")
//    }
//
//    func testReadyToStart() {
//        XCTAssertTrue(testEngine.readyToStart, "Engine should be ready")
//    }
//
//    func testRanOutOfBalls() {
//        XCTAssertFalse(testEngine.ranOutOfBalls, "Engine should have balls")
//    }
//
//    func testResetEngine() {
//        let ball = GameBall(centre: CGPoint.zero)
//        testEngine.addBall(ball: ball, angle: CGFloat.zero)
//        testEngine.resetEngine()
//        XCTAssertNil(testEngine.getBall(), "Remove ball success")
//    }
//
//    func testCheckWinStatus_success() {
//        let blueGamePeg = GamePeg(peg: bluePeg)!
//        testEngine.addToGameEngine(gameObject: blueGamePeg)
//        XCTAssertTrue(testEngine.checkWinStatus(), "Game is won")
//    }
//
//    func testCheckWinStatus_failure() {
//        let gamePeg = GamePeg(peg: orangePeg)!
//        testEngine.addToGameEngine(gameObject: gamePeg)
//        XCTAssertFalse(testEngine.checkWinStatus(), "Game is lost")
//    }
//
//}
