//
//  PhysicsEngineHelper.swift
//  PS3
//
//  Created by Calvin Chen on 25/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

enum PhysicsEngineHelper {
    
    /// Returns a reflected vector after collision.
     /// Formula adapted from https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
     /// - Parameters:
     ///     - a: incident vector
     ///     - b: normal vector
    static func calculateReflectedVector(a: CGVector, b: CGVector) -> CGVector {
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
///     - Returns:
///        - A boolean value indicating intersection exists.

    static func checkIntersection(polygonVertices: [CGPoint], circleCentre: CGPoint, circleRadius: CGFloat) -> Bool {

        let length = polygonVertices.count
        for i in 0..<length {
            let pointA = polygonVertices[i]
            let pointB = polygonVertices[(i + 1) % length]
            if GameDisplayHelper.lineCircle(p1: pointA, p2: pointB, centre: circleCentre, radius: circleRadius) {
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
    static func checkIntersectionBetweenTriangle(vertices: [CGPoint], otherVertices: [CGPoint]) -> Bool {
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


    static func sign (p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGFloat {
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    }

    // Code adapted from https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
    static func triangleContainsPoint(vertices: [CGPoint], pt: CGPoint) -> Bool {
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

    static func rectangleContainsPoint(topLeftPoint: CGPoint, bottomRightPoint: CGPoint, point: CGPoint) -> Bool {

        if (point.x > topLeftPoint.x && point.x < bottomRightPoint.x &&
            point.y > topLeftPoint.y && point.y < bottomRightPoint.x) {
            return true
        }
        
        return false
    }

    /// Create vertices of triangle
    static func getVerticesOfTriangle(centre: CGPoint, lengthOfBase: CGFloat) -> [CGPoint] {
        let halfLength = lengthOfBase / 2
        let topVertex = CGPoint(x: centre.x, y: centre.y - halfLength)
        let leftVertex = CGPoint(x: centre.x - halfLength, y: centre.y + halfLength)
        let rightVertex = CGPoint(x: centre.x + halfLength, y: centre.y + halfLength)
        return [topVertex, leftVertex, rightVertex]
    }

    /// Create vertices of triangle
    /// Array of vertices in clockwise direction starting from top left.
    static func getVerticesOfRectangle(centre: CGPoint, length: CGFloat, breadth: CGFloat) -> [CGPoint] {
        let topLeftVertex = CGPoint(x: centre.x - length / 2, y: centre.y - breadth / 2)
        let topRightVertex = CGPoint(x: centre.x + length / 2, y: centre.y - breadth / 2)
        let bottomLeftVertex = CGPoint(x: centre.x - length / 2, y: centre.y + breadth / 2)
        let bottomRightVertex = CGPoint(x: centre.x + length / 2, y: centre.y + breadth / 2)
        return [topLeftVertex, topRightVertex, bottomRightVertex, bottomLeftVertex]
    }
}
