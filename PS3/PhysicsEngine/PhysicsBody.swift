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
    var vertices = [CGPoint]()
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
    init(size: CGSize, centre: CGPoint) {
        self.shape = Shape.Rectangle
        self.centre = centre
        self.size = size
        self.radius = CGFloat.zero
    }

    /// Creates a rectangular physics body.
    init(triangleWithCentre: CGPoint, length: CGFloat) {
        self.shape = Shape.Triangle
        self.centre = triangleWithCentre
        self.radius = CGFloat.zero
        self.size = CGSize.zero
        self.vertices = GameDisplayHelper.getVerticesOfTriangle(centre: centre, lengthOfBase: length)
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
        self.vertices = physicsBody.vertices
    }

    func isShape(_ shape: Shape) -> Bool {
        return self.shape == shape
    }

    /// Checks if the `PhysicsBody` collided with another `PhysicsBody`
    /// Returns false if either object is not a circle
    public func collidedWith(triangularObject: PhysicsBody) -> Bool {
        guard isShape(.Circle) && triangularObject.isShape(.Triangle) else {
            return false
        }

        let length = triangularObject.vertices.count
        for i in 0..<length {
            let pointA = triangularObject.vertices[i]
            let pointB = triangularObject.vertices[(i + 1) % length]
            if GameDisplayHelper.lineCircle(p1: pointA, p2: pointB, centre: centre, radius: radius) {
                return true
            }
        }
        return false
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

//    public func collidedWith(rectangularObject: PhysicsBody) -> Bool {
//        guard isShape(.Circle) && rectangularObject.isShape(.Rectangle) else {
//            return false
//        }
//
//        let squaredDistanceX = (centre.x - rectangularObject.centre.x) * (centre.x - rectangularObject.centre.x)
//        let squaredDistanceY = (centre.y - rectangularObject.centre.y) * (centre.y - rectangularObject.centre.y)
//        let distanceBetweenObjects = sqrt(squaredDistanceX + squaredDistanceY)
//        let minimumDistance = radius + rectangularObject.radius
//        return distanceBetweenObjects <= minimumDistance
//    }

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

        let object = PhysicsBody(physicsBody: self)
        object.move()
        let squaredDistanceX = (object.centre.x - circularObject.centre.x) * (object.centre.x - circularObject.centre.x)
        let squaredDistanceY = (object.centre.y - circularObject.centre.y) * (object.centre.y - circularObject.centre.y)
        let distanceBetweenObjects = sqrt(squaredDistanceX + squaredDistanceY)
        let minimumDistance = radius + circularObject.radius
        return distanceBetweenObjects <= minimumDistance - tolerance
    }

    public func willCollide(triangularObject: PhysicsBody, tolerance: CGFloat) -> Bool {
        guard isShape(.Circle) && triangularObject.isShape(.Triangle) else {
            return false
        }

        let object = PhysicsBody(physicsBody: self)
        object.move()
        return object.collidedWith(triangularObject: triangularObject)

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

    public func changeVelocityAfter(triangularObject: PhysicsBody, energyLoss: CGFloat) {

        let object = PhysicsBody(physicsBody: self)
        object.move()

//        for point in triangularObject.vertices {
//            if GameDisplayHelper.pointCircle(point: point, centre: object.centre, radius: object.radius) {
//                velocity = GameDisplayHelper.reverseVelocity(velocity)
//                return
//            }
//        }


        guard let edge = GameDisplayHelper.getClosestEdge(centre: centre, radius: radius, vertices: triangularObject.vertices) else {
            return
        }
        let midPoint = CGPoint(x: (edge.0.x + edge.1.x) / 2,
                               y: (edge.1.y + edge.0.y) / 2)


//        let normalVector = CGVector(dx: (triangularObject.centre.x - midPoint.x), dy: (triangularObject.centre.y - midPoint.y))
        let normalVector = CGVector(dx: (edge.0.x - edge.1.x), dy: -(edge.0.y - edge.1.y))
        let reflectedVector = GameDisplayHelper.calculateReflectedVector(a: velocity, b: normalVector)
        let newReflectedVector = CGVector(dx: energyLoss * reflectedVector.dx, dy: energyLoss * reflectedVector.dy)
        print("reflected")
        velocity = newReflectedVector
    }
}
