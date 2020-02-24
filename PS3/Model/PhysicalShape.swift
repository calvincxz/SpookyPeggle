//
//  PhysicalShape.swift
//  PS3
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

struct PhysicalShape: Codable, Hashable {
    let centre: CGPoint
    let shape: PegShape
    let radius: CGFloat
    let vertices: [CGPoint]
    let length: CGFloat
    let rotationAngle: CGFloat

    init(circleOfCentre: CGPoint, radius: CGFloat) {
        self.shape = .Circle
        self.centre = circleOfCentre
        self.radius = radius
        self.vertices = []
        self.length = CGFloat.zero
        self.rotationAngle = CGFloat.zero
    }

    init(triangleOfCentre: CGPoint, length: CGFloat, rotation: CGFloat) {
        //print(rotation.description)
        self.shape = .Triangle
        self.centre = triangleOfCentre
        self.length = length
        self.radius = CGFloat.zero
        let initialVertices = GameDisplayHelper.getVerticesOfTriangle(centre: triangleOfCentre, lengthOfBase: length)
        self.vertices = initialVertices.map({ $0.rotate(origin: triangleOfCentre, byRadians: rotation) })
        self.rotationAngle = rotation
    }

//    init(triangleOfCentre: CGPoint, length: CGFloat, rotation: CGFloat) {
//        let vertices = GameDisplayHelper.getVerticesOfTriangle(centre: triangleOfCentre, lengthOfBase: length)
//        self.init(triangleOfCentre: triangleOfCentre, length: length, vertices: vertices)
//    }

    init(triangleOfCentre: CGPoint, length: CGFloat) {
        self.init(triangleOfCentre: triangleOfCentre, length: length, rotation: CGFloat.zero)
    }

    func intersects(other: PhysicalShape) -> Bool {
        if shape == .Circle && other.shape == .Circle {
            return centre.distanceTo(other: other.centre) < radius + other.radius

        } else if shape == .Triangle && other.shape == .Circle {
            return MathHelper.checkIntersection(polygonVertices: vertices, circleCentre: other.centre,
                                                circleRadius: other.radius)
        } else if shape == .Circle && other.shape == .Triangle {
            return MathHelper.checkIntersection(polygonVertices: other.vertices, circleCentre: centre, circleRadius: radius)
        } else {
            // TODO: triangle-triangle intersect
            return MathHelper.checkIntersectionBetweenTriangle(vertices: vertices, otherVertices: other.vertices)
        }
    }

    func contains(point: CGPoint) -> Bool {
        switch shape {
        case .Circle:
            return centre.distanceTo(other: point) < radius
        case .Triangle:
            return MathHelper.triangleContainsPoint(vertices: vertices, pt: point)
        }
    }

    // angle in radians
    func rotate(by angle: CGFloat) -> PhysicalShape {
        switch shape {
        case .Circle:
            return self
        case .Triangle:
            //let rotatedVertices = vertices.map({ $0.rotate(origin: centre, byRadians: angle) })
            return PhysicalShape(triangleOfCentre: centre, length: length, rotation: rotationAngle + angle)
        }
    }

    func moveTo(location: CGPoint) -> PhysicalShape {
//        let dx = location.x - self.centre.x
//        let dy = location.y - self.centre.y

        switch shape {
        case .Circle:
            return PhysicalShape(circleOfCentre: location, radius: radius)
        case .Triangle:
            //let movedVertices = vertices.map({ $0.moveTo(dx: dx, dy: dy) })
            return PhysicalShape(triangleOfCentre: location, length: length, rotation: rotationAngle)
        }
    }

    static func == (lhs: PhysicalShape, rhs: PhysicalShape) -> Bool {
        return lhs.centre == rhs.centre
            && lhs.shape == rhs.shape
            && lhs.radius == rhs.radius
            && lhs.vertices == rhs.vertices
            && lhs.length == rhs.length
            && lhs.rotationAngle == rhs.rotationAngle
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(shape)
        hasher.combine(radius)
        hasher.combine(vertices)
        hasher.combine(length)
        hasher.combine(rotationAngle)
    }
}
