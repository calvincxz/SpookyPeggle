//
//  PhysicsBody.swift
//  PS3
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

/// The `PhysicsBody` class represents an object in 2D space.
/// There is no equality for `PhysicsBody`s since they can have
/// the same attributes.
public class PhysicsBody {

    let shape: Shape
    var isDynamic = true
    var centre: CGPoint
    var radius: CGFloat
    var size: CGSize
    var mass = CGFloat.zero
    var velocity = CGVector.zero
    var acceleration = CGVector.zero
    var isResting: Bool {
        return velocity == CGVector.zero
    }

    /// Creates a circular physics body.
    init(radius: CGFloat, centre: CGPoint) {
        self.shape = Shape.Circle
        self.centre = centre
        self.radius = radius
        self.size = CGSize.zero
    }

    /// Creates a rectangular physics body.
    init(centre: CGPoint, size: CGSize) {
        self.shape = Shape.Rectangle
        self.centre = centre
        self.size = size
        self.radius = CGFloat.zero
    }

    /// Creates a copy of the `PhysicsBody`
    init(physicsBody: PhysicsBody) {
        self.isDynamic = physicsBody.isDynamic
        self.centre = physicsBody.centre
        self.radius = physicsBody.radius
        self.size = physicsBody.size
        self.mass = physicsBody.mass
        self.velocity = physicsBody.velocity
        self.acceleration = physicsBody.acceleration
        self.shape = physicsBody.shape
    }

    func isShape(_ shape: Shape) -> Bool {
        return self.shape == shape
    }

    /// Checks if the `PhysicsBody` collided with another `PhysicsBody`
    /// Returns false if either object is not a circle
    public func collidedWith(circularObject: PhysicsBody) -> Bool {
        guard isShape(.Circle) && circularObject.isShape(.Circle) else {
            return false
        }

        let squaredDistanceX = (centre.x - circularObject.centre.x) * (centre.x - circularObject.centre.x)
        let squaredDistanceY = (centre.y - circularObject.centre.y) * (centre.y - circularObject.centre.y)
        let distanceBetweenObjects = sqrt(squaredDistanceX + squaredDistanceY)
        let minimumDistance = radius + circularObject.radius
        return distanceBetweenObjects <= minimumDistance
    }

    /** Checks if the `PhysicsBody` will collide with another `PhysicsBody`in the next instance of time.
        Returns false if either object is not a circle
     - Parameters:
       - physicsObject: The other `PhysicsBody`
       - tolerance: An additional tolerance to allow some intersection between objects
    */
    public func willCollide(circularObject: PhysicsBody, tolerance: CGFloat) -> Bool {
        guard isShape(.Circle) && circularObject.isShape(.Circle) else {
            return false
        }

        let object = PhysicsBody(physicsBody: circularObject)
        object.move()
        let squaredDistanceX = (centre.x - object.centre.x) * (centre.x - object.centre.x)
        let squaredDistanceY = (centre.y - object.centre.y) * (centre.y - object.centre.y)
        let distanceBetweenObjects = sqrt(squaredDistanceX + squaredDistanceY)
        let minimumDistance = radius + object.radius
        return distanceBetweenObjects <= minimumDistance - tolerance
    }

    /// Temporarily stops the movement of the `PhysicsBody`.
    /// Acceleration is unchanged.
    public func stop() {
        velocity = CGVector.zero
    }

    /// Simulates the movement of the `PhysicsBody`.
    /// Updates position and velocity of object for next instance of time.
    public func move() {
        guard isDynamic else {
            return
        }

        centre = CGPoint(x: centre.x + velocity.dx, y: centre.y + velocity.dy)
        velocity = CGVector(dx: velocity.dx + acceleration.dx, dy: velocity.dy + acceleration.dy)
    }

    /// Reflects the velocity of the `PhysicsBody` in the horizontal axis.
    public func reflectVelocityInDirectionX() {
        velocity = CGVector(dx: -velocity.dx, dy: velocity.dy)
    }
    /// Reflects the velocity of the `PhysicsBody` in the vertical axis.
    public func reflectVelocityInDirectionY() {
        velocity = CGVector(dx: velocity.dx, dy: -velocity.dy)
    }

    /// Changes the velocity of the `PhysicsBody` after collision with an object.
    /// Does not update velocity of the other `PhysicsBody`
    /// Set energy loss to 1 for a perfectly elastic collision.
    public func changeVelocityAfter(collisionWith object: PhysicsBody, energyLoss: CGFloat) {
        let normalVector = CGVector(dx: object.centre.x - centre.x, dy: object.centre.y - centre.y)
        let reflectedVector = GameDisplayHelper.calculateReflectedVector(a: velocity, b: normalVector)
        let newReflectedVector = CGVector(dx: energyLoss * reflectedVector.dx, dy: energyLoss * reflectedVector.dy)

        velocity = newReflectedVector
    }
}
