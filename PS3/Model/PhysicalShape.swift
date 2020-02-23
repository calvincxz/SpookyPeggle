//
//  PhysicalShape.swift
//  PS3
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

struct PhysicalShape: Codable {
    let centre: CGPoint
    let shape: PegShape
    let radius: CGFloat
    let vertices: [CGPoint]
    let length: CGFloat

    init(circleOfCentre: CGPoint, radius: CGFloat) {
        self.shape = .Circle
        self.centre = circleOfCentre
        self.radius = radius
        self.vertices = []
        self.length = CGFloat.zero
    }


    init(triangleOfCentre: CGPoint, length: CGFloat) {
        self.shape = .Triangle
        self.centre = triangleOfCentre
        self.length = length
        self.vertices =  GameDisplayHelper.getVerticesOfTriangle(centre: centre, lengthOfBase: length)
        self.radius = CGFloat.zero
    }

    func intersects(other: PhysicalShape) -> Bool {
        if shape == .Circle && other.shape == .Circle {
            return centre.distanceTo(other: other.centre) < radius + other.radius

        } else if shape == .Triangle && other.shape == .Circle {
            return MathHelper.checkIntersection(polygonVertices: vertices, circleCentre: other.centre, circleRadius: other.radius)
        } else if shape == .Circle && other.shape == .Triangle {
            return MathHelper.checkIntersection(polygonVertices: other.vertices, circleCentre: centre, circleRadius: radius)
        } else {
            // TODO: triangle-triangle intersect
            return false
        }
    }

    func contains(point: CGPoint) -> Bool {
        switch shape {
        case .Circle:
            return centre.distanceTo(other: point) < radius
        case .Triangle:
            return MathHelper.checkTriangleContains(vertices: vertices, point: point)
        }

    }

}
