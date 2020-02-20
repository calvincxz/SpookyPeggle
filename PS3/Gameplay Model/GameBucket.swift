//
//  GameBucket.swift
//  PS3
//
//  Created by Calvin Chen on 20/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

/**
The `GameBucket` represents a bucket in the Peggle Game.
*/
class GameBucket: GameObject {

    /// Constructs a `GameBall`
    var width: CGFloat
    var height: CGFloat

    /// Constructs a `GameBucket` with the default diameter
    override init(size: CGSize, centre: CGPoint) {

        self.width = Settings.bucketWidth
        self.height = Settings.bucketHeight
        super.init(size: size, centre: centre)
        self.velocity = CGVector(dx: 5, dy: 0)

    }
    /// Constructs a `GameBucket` centred at the bottom of a
    /// given area
    convenience init(area: CGSize) {
        let centre = CGPoint(x: area.width / 2, y: area.height - Settings.bucketHeight/2)
        self.init(size: CGSize(width: Settings.bucketWidth, height: Settings.bucketHeight), centre: centre)
    }

    func resetVelocity() {
        velocity = CGVector(dx: 5, dy: 0)
    }

    func collideWith(ball: GameObject) -> Bool {
        return ball.centre.y >= centre.y && ball.centre.x < centre.x + width/2 && ball.centre.x > centre.x - width/2
    }
}
