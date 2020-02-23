////
////  Circle.swift
////  PS3
////
////  Created by Calvin Chen on 23/2/20.
////  Copyright © 2020 Calvin Chen. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//
//class Circle: PhysicalShape {
//    let radius: CGFloat
//
//    init(centre: CGPoint, radius: CGFloat) {
//        self.centre = centre
//        self.radius = radius
//    }
//
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
//
//    override func intersects(otherShape: PhysicalShape) -> Bool {
//        let otherCentre = otherShape.centre
//        if let circle = otherShape as? Circle {
//            return centre.distanceTo(other: otherCentre) < radius + circle.radius
//        } else if let triangle = otherShape as? Triangle {
//            return MathHelper.checkIntersection(polygonVertices: triangle.vertices, circleCentre: centre, circleRadius: radius)
//        }
//
//        return false
//
//    }
//
//    override func contains(point: CGPoint) -> Bool {
//        return centre.distanceTo(other: point) < radius
//    }
//
//    static func == (lhs: Circle, rhs: Circle) -> Bool {
//        lhs.centre == rhs.centre
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(centre)
//    }
//
//}
