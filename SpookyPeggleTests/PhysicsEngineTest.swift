//
//  PhysicsEngineTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 9/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import PhysicsEngine

class PhysicsEngineTest: XCTestCase {
    let testArea = CGSize(width: 10, height: 10)
    let origin = CGPoint(x: 0, y: 0)
    let sampleFloat = CGFloat(1)
    let sampleVector = CGVector(dx: 1, dy: 1)

    func testConstruct_emptyEngine() {
        let testEngine = PhysicsEngine(area: testArea)
        XCTAssertTrue(testEngine.physicsBodies.isEmpty, "PhysicsEngine should be empty")
    }

    func testResetPhysicsEngine_emptyEngine() {
        let testEngine = PhysicsEngine(area: testArea)
        testEngine.resetPhysicsEngine()
        XCTAssertTrue(testEngine.physicsBodies.isEmpty, "PhysicsEngine should be empty")
    }

    func testResetPhysicsEngine_nonEmptyEngine() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)
        testEngine.resetPhysicsEngine()
        XCTAssertTrue(testEngine.physicsBodies.isEmpty, "PhysicsEngine should be empty")
    }

    func testAddToPhysicsWorld_nonEmptyEngine() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertFalse(testEngine.physicsBodies.isEmpty, "PhysicsEngine should not be empty")
    }

    func testRemoveFromPhysicsWorld_nonExistingBody_removeFailure() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)
        let sampleBodyCopy = PhysicsBody(physicsBody: sampleBody)

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)
        testEngine.removeFromPhysicsWorld(physicsBody: sampleBodyCopy)

        XCTAssertFalse(testEngine.physicsBodies.isEmpty, "PhysicsEngine should not be empty")
    }

    func testRemoveFromPhysicsWorld_existingBody_removeSuccess() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)

        testEngine.removeFromPhysicsWorld(physicsBody: sampleBody)

        XCTAssertTrue(testEngine.physicsBodies.isEmpty, "PhysicsEngine should be empty")
    }

    func testCheckTopCollision_success() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertTrue(testEngine.checkTopCollision(object: sampleBody), "Physics body should collide with top")
    }

    func testCheckTopCollision_failure() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 5))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertFalse(testEngine.checkTopCollision(object: sampleBody),
                       "Physics body should not collide with top")
    }

    func testCheckLeftSideCollision_success() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: origin)

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertTrue(testEngine.checkSideCollision(circularObject: sampleBody),
                      "Physics body should collide with left side")
    }

    func testCheckRightSideCollision_success() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 9, y: 5))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertTrue(testEngine.checkSideCollision(circularObject: sampleBody),
                      "Physics body should collide with right side")
    }

    func testCheckSideCollision_failure() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 5))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertFalse(testEngine.checkSideCollision(circularObject: sampleBody),
                       "Physics body should not collide with side")
    }

    func testCheckBottomCollision_success() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 9))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertTrue(testEngine.checkBottomCollision(object: sampleBody), "Physics body should collide with bottom")
    }

    func testCheckBottomCollision_failure() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 5))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)

        XCTAssertFalse(testEngine.checkBottomCollision(object: sampleBody),
                       "Physics body should not collide with bottom")
    }

    func testCheckCollision_success() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 5))
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 6, y: 5))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)
        testEngine.addToPhysicsWorld(physicsBody: sampleBodyTwo)

        XCTAssertTrue(testEngine.checkCollision(lhs: sampleBody, rhs: sampleBodyTwo), "Physics bodies should collide")
    }

    func testCheckCollision_failure() {
        let testEngine = PhysicsEngine(area: testArea)
        let sampleBody = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 5, y: 5))
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, circleWithCentre: CGPoint(x: 7, y: 7))

        testEngine.addToPhysicsWorld(physicsBody: sampleBody)
        testEngine.addToPhysicsWorld(physicsBody: sampleBodyTwo)

        XCTAssertFalse(testEngine.checkCollision(lhs: sampleBody, rhs: sampleBodyTwo),
                       "Physics bodies should not collide")
    }

}
