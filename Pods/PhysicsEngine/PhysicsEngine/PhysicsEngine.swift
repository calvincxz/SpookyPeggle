//
//  PhysicsEngine.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

/// The `PhysicsEngine` class represents a 2D rectangular world of a finite area which contains `PhysicsBody`s.
/// The `PhysicsEngine` checks for object collisions with one another, as well as the bounds of the physics world.
public class PhysicsEngine {

    public var physicsBodies: [PhysicsBody] = []
    public let area: CGSize

    public init(area: CGSize) {
        self.area = area
    }
    /// Resets the `PhysicsEngine`.
    public func resetPhysicsEngine() {
        physicsBodies.removeAll()
    }

    /// Adds a `PhysicsBody` to the `PhysicsEngine`.
    public func addToPhysicsWorld(physicsBody: PhysicsBody) {
        physicsBodies.append(physicsBody)
    }

    /// Removes a `PhysicsBody` from the `PhysicsEngine`.
    /// Nothing happens if `PhysicsBody` does not exist.
    public func removeFromPhysicsWorld(physicsBody: PhysicsBody) {
        physicsBodies = physicsBodies.filter { $0 !== physicsBody }
    }

    /** Checks if the `PhysicsBody` has collided with another `PhysicsBody`
     - Parameters:
       - lhs: The first `PhysicsBody`
       - rhs: The second `PhysicsBody`
    */
    public func checkCollision(lhs: PhysicsBody, rhs: PhysicsBody) -> Bool {
        return lhs.collidedWith(other: rhs) || rhs.collidedWith(other: lhs)
    }

    /// Checks if a `PhysicsBody`collided with the top of the given area.
    public func checkTopCollision(object: PhysicsBody) -> Bool {
        return object.centre.y <= object.radius
    }

    /// Checks if a `PhysicsBody`collided with the sides of the given area.
    public func checkSideCollision(circularObject: PhysicsBody) -> Bool {
        return checkLeftSideCollision(circularObject: circularObject) || checkRightSideCollision(circularObject: circularObject)
    }

    public func checkSideCollision(rectangularObject: PhysicsBody) -> Bool {
        return rectangularObject.centre.x <= rectangularObject.size.width / 2 ||
            rectangularObject.centre.x >= area.width - rectangularObject.size.width / 2
    }

    /// Checks if a `PhysicsBody`collided with the left side of the given area.
    public func checkLeftSideCollision(circularObject: PhysicsBody) -> Bool {

        return circularObject.centre.x <= circularObject.radius
    }

    /// Checks if a `PhysicsBody`collided with the right side of the given area.
    public func checkRightSideCollision(circularObject: PhysicsBody) -> Bool {
        return circularObject.centre.x >= area.width - circularObject.radius
    }

    /// Checks if a `PhysicsBody`collided with the bottom of the given area.
    public func checkBottomCollision(object: PhysicsBody) -> Bool {
        return object.centre.y + object.radius >= area.height
    }
}
