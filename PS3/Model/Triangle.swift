////
////  Triangle.swift
////  PS3
////
////  Created by Calvin Chen on 23/2/20.
////  Copyright © 2020 Calvin Chen. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//
//class Triangle {
//    let centre: CGPoint
//    let length: CGFloat
//    let vertices: [CGPoint]
//
//
//    init(centre: CGPoint, length: CGFloat) {
//        self.centre = centre
//        self.length = length
//        vertices = GameDisplayHelper.getVerticesOfTriangle(centre: centre, lengthOfBase: length)
//    }
//
//
//    func intersects(otherShape: PhysicalShape) -> Bool {
//        if let circle = otherShape as? Circle {
//            return MathHelper.checkIntersection(polygonVertices: vertices, circleCentre: circle.centre, circleRadius: circle.radius)
//        } else if let triangle = otherShape as? Triangle {
//            return false
//        }
//
//        return false
//
//    }
//
//    // Code adapted from https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/
//    func contains(point: CGPoint) -> Bool {
//        /* Calculate area of triangle ABC */
//        let A = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: vertices[2])
//
//         /* Calculate area of triangle PBC */
//         let A1 = GameDisplayHelper.area(p1: point, p2: vertices[1], p3: vertices[2])
//
//         /* Calculate area of triangle PAC */
//         let A2 = GameDisplayHelper.area(p1: vertices[0], p2: point, p3: vertices[2])
//
//         /* Calculate area of triangle PAB */
//         let A3 = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: centre)
//
//         /* Check if sum of A1, A2 and A3 is same as A */
//         return (A == A1 + A2 + A3)
//    }
//
//    static func == (lhs: Triangle, rhs: Triangle) -> Bool {
//        lhs.centre == rhs.centre
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(centre)
//    }
//
//}
