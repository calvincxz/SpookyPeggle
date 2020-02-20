//
//  PhysicsBodyTest.swift
//  PS3Tests
//
//  Created by Calvin Chen on 9/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import PS3

class PhysicsBodyTest: XCTestCase {
    let origin = CGPoint(x: 0, y: 0)
    let sampleFloat = CGFloat(1)
    let sampleVector = CGVector(dx: 1, dy: 1)

    func testConstruct() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        XCTAssertEqual(sampleBody.radius, sampleFloat)
        XCTAssertEqual(sampleBody.centre, origin)
    }

    func testConstruct_withAnotherPhysicsBody() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        let newBody = PhysicsBody(physicsBody: sampleBody)
        XCTAssertEqual(sampleBody.radius, newBody.radius)
        XCTAssertEqual(sampleBody.centre, newBody.centre)
    }

    func testIsShape() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        XCTAssertTrue(sampleBody.isShape(.Circle), "Object should be circular")
    }

    func testStop_nonMovingObject() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.stop()
        XCTAssertEqual(sampleBody.velocity, CGVector.zero)

    }

    func testStop_movingObject() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = sampleVector
        sampleBody.stop()
        XCTAssertEqual(sampleBody.velocity, CGVector.zero)
    }

    func testMove_staticObject_constantVelocity() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.isDynamic = false
        sampleBody.velocity = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.velocity, sampleVector)
        XCTAssertEqual(sampleBody.centre, origin)
    }

    func testMove_staticObject_constantAcceleration() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.isDynamic = false
        sampleBody.acceleration = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.velocity, CGVector.zero)
        XCTAssertEqual(sampleBody.acceleration, sampleVector)
        XCTAssertEqual(sampleBody.centre, origin)
    }

    func testMove_dynamicObject_constantVelocityAndAcceleration() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.isDynamic = false
        sampleBody.velocity = sampleVector
        sampleBody.acceleration = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.centre, origin)
    }

    func testMove_dynamicObject_constantVelocity_zeroAcceleration() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.velocity, sampleVector, "Object velocity should not change")
        XCTAssertEqual(sampleBody.centre, CGPoint(x: 1, y: 1), "Object should move")
    }

    func testMove_dynamicObject_zeroVelocity_constantAcceleration() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.acceleration = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.velocity, CGVector(dx: 1, dy: 1))
        XCTAssertEqual(sampleBody.centre, origin, "Object should not move")
    }

    func testMove_staticObject_constantVelocityAndAcceleration() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = sampleVector
        sampleBody.acceleration = sampleVector
        sampleBody.move()
        XCTAssertEqual(sampleBody.velocity, CGVector(dx: 2, dy: 2))
        XCTAssertEqual(sampleBody.centre, CGPoint(x: 1, y: 1), "Object should move")
    }

    func testReflectVelocityInDirectionX_objectAtRest() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.reflectVelocityInDirectionX()
        XCTAssertEqual(sampleBody.velocity, CGVector.zero, "Object velocity should not change")
    }

    func testReflectVelocityInDirectionX_movingObject() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = sampleVector
        sampleBody.reflectVelocityInDirectionX()
        XCTAssertEqual(sampleBody.velocity, CGVector(dx: -sampleVector.dx, dy:
            sampleVector.dy), "Object velocity should change")
    }

    func testReflectVelocityInDirectionY_objectAtRest() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.reflectVelocityInDirectionY()
        XCTAssertEqual(sampleBody.velocity, CGVector.zero, "Object velocity should not change")
    }

    func testReflectVelocityInDirectionY_movingObject() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = sampleVector
        sampleBody.reflectVelocityInDirectionY()
        XCTAssertEqual(sampleBody.velocity, CGVector(dx: sampleVector.dx, dy:
            -sampleVector.dy), "Object velocity should change")
    }

    func testCollidedWith_success() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, centre: CGPoint(x: 1, y: 1))
        XCTAssertTrue(sampleBody.collidedWith(circularObject: sampleBodyTwo), "Objects should collide")
    }

    func testCollidedWith_failure() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, centre: CGPoint(x: 2, y: 2))
        XCTAssertFalse(sampleBody.collidedWith(circularObject: sampleBodyTwo), "Objects should not collide")
    }

    func testWillCollide_success() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = CGVector(dx: 1, dy: 1)
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, centre: CGPoint(x: 1, y: 1))
        XCTAssertTrue(sampleBody.willCollide(circularObject: sampleBodyTwo,
                                             tolerance: CGFloat.zero), "Objects will collide")
    }

    func testWillCollide_failure() {
        let sampleBody = PhysicsBody(radius: sampleFloat, centre: origin)
        sampleBody.velocity = CGVector(dx: 1, dy: 1)
        let sampleBodyTwo = PhysicsBody(radius: sampleFloat, centre: CGPoint(x: 2, y: 1))
        XCTAssertFalse(sampleBody.willCollide(circularObject: sampleBodyTwo,
                                              tolerance: CGFloat.zero), "Objects will not collide")
    }

}
