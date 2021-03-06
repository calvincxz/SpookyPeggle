//
//  GamePegTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 9/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import SpookyPeggle

class GamePegTest: XCTestCase {
    let testRadius = CGFloat(1)
    let testCentre = CGPoint(x: 1, y: 1)
    let testPegType = PegType.blue

    let testPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 1, y: 1), radius: CGFloat(1))
    let expectedObject = GamePeg(peg: Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 1, y: 1), radius: CGFloat(1)))

    func testConstruct_fromPeg() {
        let testObject = GamePeg(peg: testPeg)

        XCTAssertEqual(testObject, expectedObject, "Game object init from peg failed")
    }

    func testGetPegType() {
        let testObject = GamePeg(peg: testPeg)
        XCTAssertEqual(testObject.getPegType(), PegType.blue, "Wrong peg type")
    }

    func testGetHitCount() {
        let testObject = GamePeg(peg: testPeg)
        XCTAssertEqual(testObject.getHitCount(), 0, "Wrong hit count")
    }

    func testHitByBall() {
        let testObject = GamePeg(peg: testPeg)
        testObject.hitByBall()
        XCTAssertEqual(testObject.getHitCount(), 1, "Wrong hit count")
    }

    func testHitByBall_twice() {
        let testObject = GamePeg(peg: testPeg)
        testObject.hitByBall()
        testObject.hitByBall()
        XCTAssertEqual(testObject.getHitCount(), 2, "Wrong hit count")
    }

    func testEquals_sameObject_success() {
        let testObject = GamePeg(peg: testPeg)
        XCTAssertEqual(testObject, testObject, "Object should be equal to itself")
    }

    func testEquals_objectWithSameAttributes_success() {
        let testObject = GamePeg(peg: testPeg)
        let testObjectTwo = GamePeg(peg: testPeg)
        XCTAssertEqual(testObject, testObjectTwo, "Objects should be equal")
    }

    func testEquals_differentObject_failure() {
        let testObject = GamePeg(peg: testPeg)
        let testPegTwo = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 12, y: 1), radius: CGFloat(1))
        let testObjectTwo = GamePeg(peg: testPegTwo)
        XCTAssertNotEqual(testObject, testObjectTwo, "Different objects should not be equal")
    }
}
