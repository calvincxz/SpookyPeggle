//
//  GameBallTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 13/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import SpookyPeggle

class GameBallTest: XCTestCase {
    let testRadius = CGFloat(1)
    let testCentre = CGPoint(x: 1, y: 1)

    let expectedBall = GameBall(radius: CGFloat(1), centre: CGPoint(x: 1, y: 1), onFire: false)

    func testConstruct_fromAttributes() {
        let testBall = GameBall(radius: testRadius, centre: testCentre, onFire: false)
        XCTAssertEqual(testBall, expectedBall, "Game ball init from attributes failed")
    }

    func testConstruct_withOnlyCentre() {
        let testBall = GameBall(centre: testCentre)

        let expectedBall = GameBall(centre: testCentre)

        XCTAssertEqual(testBall, expectedBall, "Game ball convenience init failed")
    }
}
