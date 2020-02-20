//
//  GamePeg.swift
//  PS3
//
//  Created by Calvin Chen on 11/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

/**
The `GamePeg` represents a peg in the Peggle Game.
*/
class GamePeg: GameObject {

    private var hitCount = 0
    private let pegType: PegType

    /// Constructs a `GamePeg` from a `Peg` object.
    init(peg: Peg) {
        let radius = peg.getDiameter() / 2
        let centre = peg.getCentrePoint()
        self.pegType = peg.getPegType()
        super.init(radius: radius, centre: centre)
        self.isDynamic = false
    }

    /// Returns the `PegType` of the `GamePeg`
    func getPegType() -> PegType {
        return pegType
    }

    /// Gets the number of times the `GamePeg` was hit by the ball.
    func getHitCount() -> Int {
        return hitCount
    }

    /// Increases the hit count of `GamePeg`by 1.
    func hitByBall() {
        hitCount += 1
    }
}
