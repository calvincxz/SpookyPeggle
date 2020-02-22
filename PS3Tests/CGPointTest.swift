//
//  CGPointTest.swift
//  PeggleGameTests
//
//  Created by Calvin Chen on 30/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import PeggleGame

class CGPointTest: XCTestCase {

    let pointA = CGPoint(x: 0, y: 0)
    let pointB = CGPoint(x: 0, y: 10)
    let pointC = CGPoint(x: 3, y: 4)
    let pointD = CGPoint(x: 6, y: 8)
    let distanceAB = CGFloat(10)
    let distanceAC = CGFloat(5)
    let distanceCD = CGFloat(5)

    func testDistanceTo_relativeToOrigin() {
        let distance = pointA.distanceTo(other: pointB)
        let distanceTwo = pointA.distanceTo(other: pointC)
        XCTAssertEqual(distance, distanceAB, "Distance is not correct")
        XCTAssertEqual(distanceTwo, distanceAC, "Distance is not correct")
    }

    func testDistanceTo_relativeToAnotherPoint() {
        let distance = pointC.distanceTo(other: pointD)
        XCTAssertEqual(distance, distanceCD, "Distance is not correct")
    }

    func testEqual_SamePoint_success() {
        XCTAssertEqual(pointA, pointA, "Same point should be equal")
        XCTAssertEqual(pointB, pointB, "Same point should be equal")
    }

    func testEqual_pointWithSameCoordinates() {
        let originPoint = CGPoint(x: 0, y: 0)
        XCTAssertEqual(originPoint, pointA, "Points should be equal")
    }

    func testNotEqual_differentPoints() {
        XCTAssertNotEqual(pointA, pointB, "Different points should not be equal")
        XCTAssertNotEqual(pointC, pointD, "Different points should not be equal")
    }

    func testHashValue_SamePoint_equals() {
        XCTAssertEqual(pointA.hashValue, pointA.hashValue, "Hash value should be equal")
        XCTAssertEqual(pointB.hashValue, pointB.hashValue, "Hash value should be equal")
    }

    func testHashValue_pointWithSameCoordinates_equals() {
        let originPoint = CGPoint(x: 0, y: 0)
        XCTAssertEqual(originPoint.hashValue, pointA.hashValue, "Hash value for points should be equal")
    }

    func testHashValue_NotEqual_differentPoints() {
        XCTAssertNotEqual(pointA.hashValue, pointB.hashValue, "Hash value for different points should not be equal")
        XCTAssertNotEqual(pointC.hashValue, pointD.hashValue, "Hash value for different points should not be equal")
    }

}
