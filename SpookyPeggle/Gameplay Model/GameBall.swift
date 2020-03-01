//
//  GameBall.swift
//  PS3
//
//  Created by Calvin Chen on 11/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

/**
The `GameBall` represents a ball in the Peggle Game.
*/
class GameBall: GameObject {
    var onFire = false

    /// Constructs a `GameBall`
    init(radius: CGFloat, centre: CGPoint, onFire: Bool) {
        super.init(radius: radius, circleWithCentre: centre)
    }

    /// Constructs a `GameBall` with the default diameter
    convenience init(centre: CGPoint) {
        self.init(radius: Settings.defaultBallDiameter / 2, centre: centre, onFire: false)
    }

    func setOnFire() {
        onFire = true
    }

}
