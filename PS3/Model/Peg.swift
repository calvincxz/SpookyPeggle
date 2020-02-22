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
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        return lhs.centre == rhs.centre &&
            lhs.pegType == rhs.pegType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(pegType)
    }


    let pegType: PegType
    let centre: CGPoint

    /// Creates a peg with the given peg type and centre.
    init(withType pegType: PegType, centre: CGPoint) {
        self.pegType = pegType
        self.centre = centre
    }

    /// Checks if the peg intersects with another peg.
    func intersects(otherPeg: Peg) -> Bool {
        fatalError("This method should not be called")
    }

    /// Checks if the peg contains a point.
    func contains(point: CGPoint) -> Bool {
        return centre == point
    }
}
