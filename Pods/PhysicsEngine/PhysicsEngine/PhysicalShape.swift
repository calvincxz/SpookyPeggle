//
//  PhysicalShape.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

public struct PhysicalShape: Codable, Hashable {
    public let centre: CGPoint
    public let shape: Shape
    public let radius: CGFloat
    public let vertices: [CGPoint]
    public let length: CGFloat
    public let rotationAngle: CGFloat
    public let breadth: CGFloat

    public init(circleOfCentre: CGPoint, radius: CGFloat) {
        self.shape = .Circle
        self.centre = circleOfCentre
        self.radius = radius
        self.vertices = []
        self.length = CGFloat.zero
        self.breadth = CGFloat.zero
        self.rotationAngle = CGFloat.zero
    }

    public init(rectangleOfCentre: CGPoint, length: CGFloat, breadth: CGFloat, rotation: CGFloat) {
        self.shape = .Rectangle
        self.centre = rectangleOfCentre
        self.length = length
        self.breadth = breadth
        self.radius = CGFloat.zero
        let initialVertices = PhysicsEngineHelper.getVerticesOfRectangle(
            centre: rectangleOfCentre, length: length, breadth: breadth)
        self.vertices = initialVertices.map({ $0.rotate(origin: rectangleOfCentre, byRadians: rotation) })
        self.rotationAngle = rotation
    }

    public init(triangleOfCentre: CGPoint, length: CGFloat, rotation: CGFloat) {
        self.shape = .Triangle
        self.centre = triangleOfCentre
        self.length = length
        self.radius = CGFloat.zero
        self.breadth = CGFloat.zero
        let initialVertices = PhysicsEngineHelper.getVerticesOfTriangle(centre: triangleOfCentre, lengthOfBase: length)
        self.vertices = initialVertices.map({ $0.rotate(origin: triangleOfCentre, byRadians: rotation) })
        self.rotationAngle = rotation
    }

    public init(triangleOfCentre: CGPoint, length: CGFloat) {
        self.init(triangleOfCentre: triangleOfCentre, length: length, rotation: CGFloat.zero)
    }

    /// Self has to be of shape circle
    public func intersects(other: PhysicalShape) -> Bool {
        switch shape {
        case .Circle:
            switch other.shape {
            case .Circle:
                return centre.distanceTo(other: other.centre) < radius + other.radius
            default:
                return PhysicsEngineHelper.checkIntersection(
                    polygonVertices: other.vertices, circleCentre: centre, circleRadius: radius)
            }
        case .Triangle:
            switch other.shape {
            case .Circle:
                return PhysicsEngineHelper.checkIntersection(
                    polygonVertices: vertices, circleCentre: other.centre, circleRadius: other.radius)
            case .Triangle:
                return PhysicsEngineHelper.checkIntersectionBetweenTriangle(
                    vertices: vertices, otherVertices: other.vertices)
            case .Rectangle:
                return false
            }
        case .Rectangle:
            return false
        }
    }

    public func contains(point: CGPoint) -> Bool {
        switch shape {
        case .Circle:
            return centre.distanceTo(other: point) < radius
        case .Triangle:
            return PhysicsEngineHelper.triangleContainsPoint(vertices: vertices, pt: point)
        case .Rectangle:
            return PhysicsEngineHelper.rectangleContainsPoint(
                topLeftPoint: vertices[0], bottomRightPoint: vertices[2], point: point)
        }
    }

    public func resize(by scale: CGFloat) -> PhysicalShape {
        switch shape {
        case .Circle:
            return PhysicalShape(circleOfCentre: centre, radius: radius * scale)
        case .Triangle:
            return PhysicalShape(triangleOfCentre: centre, length: length * scale,
                                 rotation: rotationAngle)
        case .Rectangle:
            return PhysicalShape(rectangleOfCentre: centre, length: length * scale,
                                 breadth: breadth * scale, rotation: rotationAngle)
        }
    }

    public func rotate(by angle: CGFloat) -> PhysicalShape {
        switch shape {
        case .Circle:
            return self
        case .Triangle:
            return PhysicalShape(triangleOfCentre: centre, length: length,
                                 rotation: rotationAngle + angle)
        case .Rectangle:
            return PhysicalShape(rectangleOfCentre: centre, length: length,
                                 breadth: breadth, rotation: rotationAngle + angle)
        }
    }

    public func moveTo(location: CGPoint) -> PhysicalShape {
        switch shape {
        case .Circle:
            return PhysicalShape(circleOfCentre: location, radius: radius)
        case .Triangle:
            return PhysicalShape(triangleOfCentre: location, length: length,
                                 rotation: rotationAngle)
        case .Rectangle:
            return PhysicalShape(rectangleOfCentre: location, length: length,
                                 breadth: breadth, rotation: rotationAngle)
        }
    }

    public static func == (lhs: PhysicalShape, rhs: PhysicalShape) -> Bool {
        return lhs.centre == rhs.centre
            && lhs.shape == rhs.shape
            && lhs.radius == rhs.radius
            && lhs.vertices == rhs.vertices
            && lhs.length == rhs.length
            && lhs.rotationAngle == rhs.rotationAngle
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(shape)
        hasher.combine(radius)
        hasher.combine(vertices)
        hasher.combine(length)
        hasher.combine(rotationAngle)
    }
}
