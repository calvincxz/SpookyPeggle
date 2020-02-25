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

    static func roundOffFloat(float: CGFloat) -> CGFloat {
        let x = Double(float)
        let y = Double(round(1000 * x) / 1000)

        return CGFloat(y)
    }
}
