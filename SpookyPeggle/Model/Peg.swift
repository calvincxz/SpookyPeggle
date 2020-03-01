//
//  Peg.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 21/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics
import PhysicsEngine
/**
`Peg` is an abstract data structure that represents a peg object
*/
class Peg: Codable, Hashable {

    let physicalShape: PhysicalShape
    let pegType: PegType
    let centre: CGPoint
    let shape: PegShape

    var rotation: CGFloat {
        return physicalShape.rotationAngle
    }

    /// Creates a circular peg.
    init(type pegType: PegType, circleOfCentre: CGPoint, radius: CGFloat) {
        self.pegType = pegType
        self.centre = circleOfCentre
        self.shape = .Circle
        self.physicalShape = PhysicalShape(circleOfCentre: centre, radius: radius)
    }

    /// Creates a triangular peg.
    init(type pegType: PegType, triangleOfCentre: CGPoint, length: CGFloat) {
        self.pegType = pegType
        self.centre = triangleOfCentre
        self.shape = .Triangle
        self.physicalShape = PhysicalShape(triangleOfCentre: centre, length: length)
    }

    /// Creates a peg with the given peg type, centre and shape.
    init(type pegType: PegType, centre: CGPoint, physicalShape: PhysicalShape, shape: PegShape) {
        self.pegType = pegType
        self.centre = centre
        self.physicalShape = physicalShape
        self.shape = shape
    }

    /// Creates a peg of default size
    convenience init(type pegType: PegType, centre: CGPoint, shape: PegShape) {
        switch shape {
        case .Circle:
            self.init(type: pegType, circleOfCentre: centre)
        case .Triangle:
            self.init(type: pegType, triangleOfCentre: centre)
        }
    }

    /// Creates a circlular peg of default size
    convenience init(type pegType: PegType, circleOfCentre: CGPoint) {
        self.init(type: pegType, circleOfCentre: circleOfCentre, radius: Settings.defaultPegDiameter / 2)
    }

    /// Creates a triangular peg of default size
    convenience init(type pegType: PegType, triangleOfCentre: CGPoint) {
        self.init(type: pegType, triangleOfCentre: triangleOfCentre, length: Settings.defaultTrianglePegLength)
    }

    /// Checks if the peg intersects with another peg.
    func intersects(otherPeg: Peg) -> Bool {
        return physicalShape.intersects(other: otherPeg.physicalShape)
    }

    /// Checks if the peg contains a point.
    func contains(point: CGPoint) -> Bool {
        return physicalShape.contains(point: point)
    }

    /// Rotates the `Peg`
    /// - Parameters:
    ///     - angle: The angle of rotation in radians
    /// - Returns: A peg with a rotated shape but the same `PegType` and centre.
    func rotate(by angle: CGFloat) -> Peg {
        return Peg(type: pegType, centre: centre, physicalShape: physicalShape.rotate(by: angle), shape: shape)
    }

    /// Resizes the `Peg`
    /// - Parameters:
    ///     - scale: The scale to apply to the original size.
    /// - Returns: A peg with a resized shape but the same `PegType` and centre.
    func resize(by scale: CGFloat) -> Peg {
        return Peg(type: pegType, centre: centre, physicalShape: physicalShape.resize(by: scale), shape: shape)
    }

    /// Moves the centre of a `Peg` to a new location
    func moveTo(location: CGPoint) -> Peg {
        return Peg(type: pegType, centre: location,
                   physicalShape: physicalShape.moveTo(location: location), shape: shape)

    }

    /// Checks if the size is between default area and 4 times the default
    func isSizeWithinLimit() -> Bool {
        switch shape {
        case .Circle:
            return physicalShape.radius >= Settings.defaultPegDiameter / 2 &&
                    physicalShape.radius <= Settings.defaultPegDiameter
        case .Triangle:
            return physicalShape.length >= Settings.defaultTrianglePegLength &&
                    physicalShape.length <= 2 * Settings.defaultTrianglePegLength
        }
    }

    static func == (lhs: Peg, rhs: Peg) -> Bool {
        return lhs.centre == rhs.centre
            && lhs.pegType == rhs.pegType
            && lhs.physicalShape == rhs.physicalShape
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(pegType)
        hasher.combine(physicalShape)
    }

}
