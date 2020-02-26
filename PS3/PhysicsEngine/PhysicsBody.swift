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

    var isDynamic = true
    var centre: CGPoint
    var size: CGSize
    var mass = CGFloat.zero
    var velocity = CGVector.zero
    var acceleration = CGVector.zero
    var physicalShape: PhysicalShape
    
    var radius: CGFloat {
        return physicalShape.shape == .Circle ? physicalShape.radius : CGFloat.zero
    }

    var isResting: Bool {
        return velocity == CGVector.zero
    }

    /// Creates a circular physics body.
    init(radius: CGFloat, circleWithCentre: CGPoint) {
        self.centre = circleWithCentre
        self.size = CGSize.zero
        self.physicalShape = PhysicalShape(circleOfCentre: centre, radius: radius)
    }

    /// Creates a rectangular physics body.
    init(rectangleWithCentre: CGPoint, size: CGSize, rotation: CGFloat) {
        self.centre = rectangleWithCentre
        self.size = size
        self.physicalShape = PhysicalShape(rectangleOfCentre: centre, length: size.width,
                                           breadth: size.height, rotation: rotation)
    }

    /// Creates a triangular physics body.
    init(triangleWithCentre: CGPoint, length: CGFloat, rotation: CGFloat) {
        self.centre = triangleWithCentre
        self.size = CGSize.zero
        self.physicalShape = PhysicalShape(triangleOfCentre: centre, length: length, rotation: rotation)
    }

    /// Creates a copy of the `PhysicsBody`
    init(physicsBody: PhysicsBody) {
        self.isDynamic = physicsBody.isDynamic
        self.centre = physicsBody.centre
        self.size = physicsBody.size
        self.mass = physicsBody.mass
        self.velocity = physicsBody.velocity
        self.acceleration = physicsBody.acceleration
        self.physicalShape = physicsBody.physicalShape
    }

    /// Checks if the `PhysicsBody` collided with another `PhysicsBody`
    /// Returns false if either object is not a circle
    public func collidedWith(other: PhysicsBody) -> Bool {
        return physicalShape.intersects(other: other.physicalShape)
    }

    public func willCollide(other: PhysicsBody) -> Bool {
        let object = PhysicsBody(physicsBody: self)
        object.move()
        return object.collidedWith(other: other)
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
        physicalShape = physicalShape.moveTo(location: centre)
    }

    /// Reflects the velocity of the `PhysicsBody` in the horizontal axis.
    public func reflectVelocityInDirectionX() {
        velocity = CGVector(dx: -velocity.dx, dy: velocity.dy)
    }
    /// Reflects the velocity of the `PhysicsBody` in the vertical axis.
    public func reflectVelocityInDirectionY() {
        velocity = CGVector(dx: velocity.dx, dy: -velocity.dy)
    }

    public func changeVelocityAfter(collisionWith object: PhysicsBody, energyLoss: CGFloat) {
        switch object.physicalShape.shape {
        case .Circle:
            changeVelocityAfter(object: object, energyLoss: energyLoss)
        default:
            changeVelocityAfter(polygonObject: object, energyLoss: energyLoss)
        }
    }

    /// Changes the velocity of the `PhysicsBody` after collision with an object.
    /// Does not update velocity of the other `PhysicsBody`
    /// Set energy loss to 1 for a perfectly elastic collision.
    private func changeVelocityAfter(object: PhysicsBody, energyLoss: CGFloat) {
        let normalVector = CGVector(dx: object.centre.x - centre.x, dy: object.centre.y - centre.y)
        let reflectedVector = PhysicsEngineHelper.calculateReflectedVector(a: velocity, b: normalVector)
        let newReflectedVector = CGVector(dx: energyLoss * reflectedVector.dx, dy: energyLoss * reflectedVector.dy)

        velocity = newReflectedVector
    }

    public func changeVelocityAfter(polygonObject: PhysicsBody, energyLoss: CGFloat) {

        let object = PhysicsBody(physicsBody: self)
        object.move()

        guard let edge = GameDisplayHelper.getClosestEdge(
            centre: centre, radius: physicalShape.radius, vertices: polygonObject.physicalShape.vertices) else {
            return
        }

        let normalVector = CGVector(dx: (edge.0.x - edge.1.x), dy: -(edge.0.y - edge.1.y))
        let reflectedVector = PhysicsEngineHelper.calculateReflectedVector(a: velocity, b: normalVector)
        let newReflectedVector = CGVector(dx: energyLoss * reflectedVector.dx, dy: energyLoss * reflectedVector.dy)
        velocity = newReflectedVector
    }
}
