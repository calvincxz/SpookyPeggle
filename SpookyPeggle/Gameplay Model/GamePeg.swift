//
//  GamePeg.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 11/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics
import PhysicsEngine

/**
The `GamePeg` represents a peg in the Peggle Game.
*/
class GamePeg: GameObject {

    private var hitCount = 0
    private let pegType: PegType

    /// Constructs a `GamePeg` from a `Peg` object.
    init(peg: Peg) {
        switch peg.shape {
        case .Circle:
            let radius = peg.physicalShape.radius
            let centre = peg.centre
            self.pegType = peg.pegType
            super.init(radius: radius, circleWithCentre: centre)
            self.isDynamic = false
        case .Triangle:
            let centre = peg.centre
            self.pegType = peg.pegType
            super.init(triangleWithCentre: centre, length: peg.physicalShape.length,
                       rotation: peg.physicalShape.rotationAngle)
            self.isDynamic = false
        }
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
