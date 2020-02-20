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
struct Peg: Codable, Hashable {
    private let pegType: PegType
    private let centre: CGPoint
    private let diameter: CGFloat
    var isHit = false

    /// Creates a peg with the given peg type and centre.
    init(withType pegType: PegType, centre: CGPoint) {
        self.init(withType: pegType, centre: centre, diameter: Settings.defaultPegDiameter)

    }

    /// Creates a peg with the given peg type, centre and a diameter.
    init(withType pegType: PegType, centre: CGPoint, diameter: CGFloat) {
        self.pegType = pegType
        self.centre = centre
        self.diameter = diameter
    }

    /// Returns the centre of a peg as a point.
    func getCentrePoint() -> CGPoint {
        return centre
    }

    /// Returns the diameter of a peg.
    func getDiameter() -> CGFloat {
        return diameter
    }

    /// Returns the peg type of a peg.
    func getPegType() -> PegType {
        return pegType
    }

    /// Checks if the peg intersects with another peg.
    func intersects(otherPeg: Peg) -> Bool {
        let otherCentre = otherPeg.getCentrePoint()
        return centre.distanceTo(other: otherCentre) < diameter
    }

    /// Checks if the peg contains a point.
    func contains(point: CGPoint) -> Bool {
        let radius = diameter / 2
        return centre.distanceTo(other: point) < radius
    }

    mutating func hitByBall() {
        self.isHit = true
    }

}
