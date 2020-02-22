//
//  CirclePeg.swift
//  PS3
//
//  Created by Calvin Chen on 21/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

class CirclePeg: Peg {

    let diameter: CGFloat

    /// Creates a peg with the given peg type and centre.
    convenience override init(withType pegType: PegType, centre: CGPoint) {
        self.init(withType: pegType, centre: centre, diameter: Settings.defaultPegDiameter)

    }

    /// Creates a peg with the given peg type, centre and a diameter.
    init(withType pegType: PegType, centre: CGPoint, diameter: CGFloat) {

        self.diameter = diameter
        super.init(withType: pegType, centre: centre)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
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
    override func intersects(otherPeg: Peg) -> Bool {
        if let otherPeg = otherPeg as? CirclePeg {
            let otherCentre = otherPeg.getCentrePoint()
            return centre.distanceTo(other: otherCentre) < diameter
        }
        // TODO triangle
        return false

    }

    /// Checks if the peg contains a point.
    override func contains(point: CGPoint) -> Bool {
        let radius = diameter / 2
        return centre.distanceTo(other: point) < radius
    }
}
