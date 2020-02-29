//
//  PhysicsEngineHelper.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 25/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

public enum PhysicsEngineHelper {
    /// Returns a reflected vector after collision.
     /// Formula adapted from https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
     /// - Parameters:
     ///     - a: incident vector
     ///     - b: normal vector
    public static func calculateReflectedVector(a: CGVector, b: CGVector) -> CGVector {
        let length = sqrt(b.dx * b.dx + b.dy * b.dy)
        let normalizedNormal = CGVector(dx: b.dx / length, dy: b.dy / length)
        let dotProduct = a.dx * normalizedNormal.dx + a.dy * normalizedNormal.dy
        let result = CGVector(dx: a.dx - 2 * dotProduct * normalizedNormal.dx,
                              dy: a.dy - 2 * dotProduct * normalizedNormal.dy)

        return result
    }

///    Checks if a circle has any intersection with a polygon
///    Formula adapted from https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
///    - Parameters:
///     - polygonVertices: Array of vertices for the polygon.
///     - circleCentre: Centre of the circle.
///     - circleRadius: Radius of the circle.
///
///    - Returns:
///        - A boolean value indicating intersection exists.

    public static func checkIntersection(polygonVertices: [CGPoint], circleCentre: CGPoint, circleRadius: CGFloat) -> Bool {

        let length = polygonVertices.count
        for i in 0..<length {
            let pointA = polygonVertices[i]
            let pointB = polygonVertices[(i + 1) % length]
            if PhysicsEngineHelper.lineCircle(p1: pointA, p2: pointB, centre: circleCentre, radius: circleRadius) {
                return true
            }
        }
        for vertex in polygonVertices {
            if vertex.distanceTo(other: circleCentre) < circleRadius {
                return true
            }
        }
        return false
    }

    // Returns true if any vertex of one triangle is contained in another triangle
    public static func checkIntersectionBetweenTriangle(vertices: [CGPoint], otherVertices: [CGPoint]) -> Bool {
        for point in otherVertices {
            if triangleContainsPoint(vertices: vertices, pt: point) {
                return true
            }
        }

        for point in vertices {
            if triangleContainsPoint(vertices: otherVertices, pt: point) {
                return true
            }
        }
        return false
    }

    public static func sign (p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGFloat {
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    }

    // Code adapted from https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
    public static func triangleContainsPoint(vertices: [CGPoint], pt: CGPoint) -> Bool {
        let v1 = vertices[0]
        let v2 = vertices[1]
        let v3 = vertices[2]

        let d1 = sign(p1: pt, p2: v1, p3: v2)
        let d2 = sign(p1: pt, p2: v2, p3: v3)
        let d3 = sign(p1: pt, p2: v3, p3: v1)

        let has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0)
        let has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0)

        return !(has_neg && has_pos)

    }

    /// Returns initial velocity of a ball
    ///    - Parameters:
    ///     - angle: Angle in radians
    ///
    ///    - Returns:
    ///        - The initial velocity for the ball
    public static func rectangleContainsPoint(topLeftPoint: CGPoint, bottomRightPoint: CGPoint, point: CGPoint) -> Bool {

        if point.x > topLeftPoint.x && point.x < bottomRightPoint.x &&
            point.y > topLeftPoint.y && point.y < bottomRightPoint.x {
            return true
        }
        return false
    }

    /// Gets the vertices of a special triangle inscribed in a square.
    ///    - Parameters:
    ///     - centre: Centre of the triangle which also happens to be centre of the square
    ///     - lengthOfBase: Length of the base of the triangle which is also the length of the square.
    ///
    ///    - Returns:
    ///        - Vertices of the triangle in clockwise manner, starting from the top
    public static func getVerticesOfTriangle(centre: CGPoint, lengthOfBase: CGFloat) -> [CGPoint] {
        let halfLength = lengthOfBase / 2
        let topVertex = CGPoint(x: centre.x, y: centre.y - halfLength)
        let leftVertex = CGPoint(x: centre.x - halfLength, y: centre.y + halfLength)
        let rightVertex = CGPoint(x: centre.x + halfLength, y: centre.y + halfLength)
        return [topVertex, leftVertex, rightVertex]
    }

    /// Gets the vertices of a rectangle
    ///    - Parameters:
    ///     - centre: The centre of the rectangle
    ///     - length: The height of the rectangle
    ///     - breadth: The width of the rectangle
    ///
    ///    - Returns:
    ///        - Vertices of the rectangle in clockwise manner, starting from the top left vertex.
    public static func getVerticesOfRectangle(centre: CGPoint, length: CGFloat, breadth: CGFloat) -> [CGPoint] {
        let topLeftVertex = CGPoint(x: centre.x - length / 2, y: centre.y - breadth / 2)
        let topRightVertex = CGPoint(x: centre.x + length / 2, y: centre.y - breadth / 2)
        let bottomLeftVertex = CGPoint(x: centre.x - length / 2, y: centre.y + breadth / 2)
        let bottomRightVertex = CGPoint(x: centre.x + length / 2, y: centre.y + breadth / 2)
        return [topLeftVertex, topRightVertex, bottomRightVertex, bottomLeftVertex]
    }

    /// Gets the closest edge of a polygon to a circle
    ///    - Parameters:
    ///     - centre: The centre of the circle
    ///     - radius: The radius of the circle
    ///     - vertices: The vertices of the polygon
    ///
    ///    - Returns:
    ///        - A line segment
    public static func getClosestEdge(centre: CGPoint, radius: CGFloat, vertices: [CGPoint]) -> (CGPoint, CGPoint)? {
        for i in 0..<vertices.count {
            let pointA = vertices[i]
            let pointB = vertices[(i + 1) % vertices.count]
            if lineCircle(p1: pointA, p2: pointB, centre: centre, radius: radius) {
                return (pointA, pointB)
            }
        }
        return nil
    }

    public static func pointCircle(point: CGPoint, centre: CGPoint, radius: CGFloat) -> Bool {
        return centre.distanceTo(other: point) < radius
    }
    /// Check if a line segment contains a point
    /// Code adapted from http://www.jeffreythompson.org/collision-detection/line-circle.php
    public static func linePoint(p1: CGPoint, p2: CGPoint, point: CGPoint) -> Bool {
      // get distance from the point to the two ends of the line
        let d1 = point.distanceTo(other: p1)
        let d2 = point.distanceTo(other: p2)

      // get the length of the line
        let lineLen = p1.distanceTo(other: p2)

      // since floats are so minutely accurate, add
      // a little buffer zone that will give collision
        let buffer = CGFloat(0.01);    // higher # = less accurate

        if d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer {
            return true
        }
        return false
    }

    /// Check if a line segment intersects with a circle
    /// Code adapted from http://www.jeffreythompson.org/collision-detection/line-circle.php
    public static func lineCircle(p1: CGPoint, p2: CGPoint, centre: CGPoint, radius: CGFloat) -> Bool {

        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let cx = centre.x
        let cy = centre.y
        // is either end INSIDE the circle?
        // if so, return true immediately
        let inside1 = pointCircle(point: p1, centre: centre, radius: radius)
        let inside2 = pointCircle(point: p2, centre: centre, radius: radius)
        if inside1 || inside2 {
            return true
        }

        // get length of the line
        var distX = x1 - x2
        var distY = y1 - y2
        let len = sqrt((distX * distX) + (distY * distY))

        // get dot product of the line and circle
        let dot = (((cx - x1) * (x2 - x1)) + ((cy - y1) * (y2 - y1))) / (len * len)

        // find the closest point on the line
        let closestX = x1 + (dot * (x2 - x1))
        let closestY = y1 + (dot * (y2 - y1))
        let closestPoint = CGPoint(x: closestX, y: closestY)

        // is this point actually on the line segment?
        // if so keep going, but if not, return false
        let onSegment = linePoint(p1: p1, p2: p2, point: closestPoint)
        guard onSegment else {
            return false
        }
        // get distance to closest point
        distX = closestX - cx
        distY = closestY - cy
        let distance = sqrt((distX * distX) + (distY * distY))

        if distance <= radius {
            return true
        }
        return false
    }
}
