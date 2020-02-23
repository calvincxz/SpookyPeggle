//
//  MathHelperTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import PS3

class MathHelperTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let bool = GameDisplayHelper.linePoint(x1: 1, y1: 1, x2: 5, y2: 5, px: 3, py: 3)
        XCTAssertTrue(bool)
    }

    func testExample2() {
        let bool = GameDisplayHelper.linePoint(x1: 10, y1: 10, x2: 50, y2: 50, px: 30, py: 31)
        XCTAssertTrue(bool)
    }

    func testCheckTriangleContains() {
        let vertices = [CGPoint(x: 50, y: 0), CGPoint(x: 0, y: 100), CGPoint(x: 100, y: 100)]
        let bool = MathHelper.checkTriangleContains(vertices: vertices, point: CGPoint(x:25, y:49))
        XCTAssertTrue(bool)
    }

    func testCheckTriangleContains() {
        let vertices = [CGPoint(x: 50, y: 0), CGPoint(x: 0, y: 100), CGPoint(x: 100, y: 100)]
        let bool = MathHelper.checkTriangleContains(vertices: vertices, point: CGPoint(x:25, y:50))
        XCTAssertTrue(bool)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
