//
//  Peg.swift
//  PeggleGame
//
//  Created by Calvin Chen on 21/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

/**
`Peg` is an abstract data structure that represents a peg object
*/
class Peg: Codable, Hashable {

    let physicalShape: PhysicalShape
    let pegType: PegType
    let centre: CGPoint
    var rotation: CGFloat {
        return physicalShape.rotationAngle
    }

    func getRotatedAngle() -> CGFloat {
        return physicalShape.rotationAngle
    }

    var shape: PegShape {
        return physicalShape.shape
    }

    /// Creates a circular peg with the given peg type and centre.
    init(type pegType: PegType, circleOfCentre: CGPoint, radius: CGFloat) {
        self.pegType = pegType
        self.centre = circleOfCentre
        self.physicalShape = PhysicalShape(circleOfCentre: centre, radius: radius)
    }

    convenience init(type pegType: PegType, circleOfCentre: CGPoint) {
        self.init(type: pegType, circleOfCentre: circleOfCentre, radius: Settings.defaultPegDiameter / 2)
    }

    /// Creates a fixed size triangular peg with the given peg type and centre.
    init(type pegType: PegType, triangleOfCentre: CGPoint, length: CGFloat) {
        self.pegType = pegType
        self.centre = triangleOfCentre
        self.physicalShape = PhysicalShape(triangleOfCentre: centre, length: length)
    }

    /// Creates a fixed size triangular peg with the given peg type and centre.
    init(type pegType: PegType, triangleOfCentre: CGPoint, physicalShape: PhysicalShape) {
        self.pegType = pegType
        self.centre = triangleOfCentre
        self.physicalShape = physicalShape
    }

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

    func rotate(by angle: CGFloat) -> Peg {
        switch shape {
        case .Circle:
            return self
        case .Triangle:
            return Peg(type: pegType, triangleOfCentre: centre, physicalShape: physicalShape.rotate(by: angle))
        }
    }

    func moveTo(location: CGPoint) -> Peg {
        switch shape {
        case .Circle:
            return Peg(type: pegType, circleOfCentre: location)
        case .Triangle:
            return Peg(type: pegType, triangleOfCentre: location, physicalShape: physicalShape.moveTo(location: location))
        }
    }

    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.centre == rhs.centre
            && lhs.pegType == rhs.pegType
            && lhs.physicalShape == rhs.physicalShape
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(pegType)
        //hasher.combine(physicalShape)
    }

}
