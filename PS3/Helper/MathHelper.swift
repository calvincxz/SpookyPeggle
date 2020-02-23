//
//  MathHelper.swift
//  PS3
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

enum MathHelper {

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

    // Code adapted from https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/
    static func checkTriangleContains(vertices: [CGPoint], point: CGPoint) -> Bool {
        guard vertices.count == 3 else {
            fatalError("Invalid vertices count")
        }
        /* Calculate area of triangle ABC */
        let A = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: vertices[2])

         /* Calculate area of triangle PBC */
         let A1 = GameDisplayHelper.area(p1: point, p2: vertices[1], p3: vertices[2])

         /* Calculate area of triangle PAC */
         let A2 = GameDisplayHelper.area(p1: vertices[0], p2: point, p3: vertices[2])

         /* Calculate area of triangle PAB */
         let A3 = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: point)
        let buffer = CGFloat(0)
        let sum = A1 + A2 + A3
         /* Check if sum of A1, A2 and A3 is same as A */
         return A <= sum + buffer && A >= sum - buffer
    }

    // Returns true if any vertex of one triangle is contained in another triangle
    static func checkIntersectionBetweenTriangle(vertices: [CGPoint], otherVertices: [CGPoint]) -> Bool {
        for point in otherVertices {
            if checkTriangleContains(vertices: vertices, point: point) {
                return true
            }
        }

        for point in vertices {
            if checkTriangleContains(vertices: otherVertices, point: point) {
                return true
            }
        }
        return false
    }
}
