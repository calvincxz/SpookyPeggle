//
//  GameObjectTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 13/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import PS3

class GameObjectTest: XCTestCase {

    let testRadius = CGFloat(1)
    let testCentre = CGPoint(x: 1, y: 1)
    let expectedObject = GameObject(radius: CGFloat(1), centre: CGPoint(x: 1, y: 1))

    func testConstruct() {
        let testObject = GameObject(radius: testRadius, centre: testCentre)

        XCTAssertEqual(testObject, expectedObject, "Objects should be equal")
    }

    func testEquals_sameObject_success() {
        let testObject = GameObject(radius: testRadius, centre: testCentre)
        XCTAssertEqual(testObject, testObject, "Object should be equal to itself")
    }

    func testEquals_objectWithSameAttributes_success() {
        let testObject = GameObject(radius: testRadius, centre: testCentre)
        let testObjectTwo = GameObject(radius: testRadius, centre: testCentre)
        XCTAssertEqual(testObject, testObjectTwo, "Objects should be equal")
    }

    func testEquals_differentObject_differentRadius_failure() {
        let testObject = GameObject(radius: testRadius, centre: testCentre)
        let testObjectTwo = GameObject(radius: CGFloat.zero, centre: testCentre)
        XCTAssertNotEqual(testObject, testObjectTwo, "Different objects should not be equal")
    }

    func testEquals_differentObject_differentCentre_failure() {
        let testObject = GameObject(radius: testRadius, centre: testCentre)
        let testObjectTwo = GameObject(radius: testRadius, centre: CGPoint(x: 2, y: 2))
        XCTAssertNotEqual(testObject, testObjectTwo, "Different objects should not be equal")
    }
}
