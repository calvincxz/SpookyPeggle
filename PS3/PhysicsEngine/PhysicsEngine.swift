//
//  PhysicsEngine.swift
//  PS3
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

    init(area: CGSize) {
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
        return lhs.collidedWith(circularObject: rhs) || rhs.collidedWith(circularObject: lhs)
    }

    /// Checks if a `PhysicsBody`collided with the top of the given area.
    public func checkTopCollision(object: PhysicsBody) -> Bool {
        return object.centre.y <= object.radius
    }

    /// Checks if a `PhysicsBody`collided with the sides of the given area.
    public func checkSideCollision(object: PhysicsBody) -> Bool {
        return checkLeftSideCollision(object: object) || checkRightSideCollision(object: object)
    }

    /// Checks if a `PhysicsBody`collided with the left side of the given area.
    public func checkLeftSideCollision(object: PhysicsBody) -> Bool {
        return object.centre.x <= object.radius
    }

    /// Checks if a `PhysicsBody`collided with the right side of the given area.
    public func checkRightSideCollision(object: PhysicsBody) -> Bool {
        return object.centre.x >= area.width - object.radius
    }

    /// Checks if a `PhysicsBody`collided with the bottom of the given area.
    public func checkBottomCollision(object: PhysicsBody) -> Bool {
        return object.centre.y + object.radius >= area.height
    }
}
