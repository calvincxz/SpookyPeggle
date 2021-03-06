//
//  GameBucket.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 20/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics
import PhysicsEngine

/**
The `GameBucket` represents a bucket in the Peggle Game.
*/
class GameBucket: GameObject {

    /// Constructs a `GameBucket`
    private var width: CGFloat
    private var height: CGFloat
    var bucketHoleLength = Settings.defaultBucketHoleLength

    /// Constructs a `GameBucket`
    init(size: CGSize, centre: CGPoint) {
        self.width = size.width
        self.height = size.height
        super.init(rectangleWithCentre: centre, size: size, rotation: CGFloat.zero)
        self.velocity = Settings.initialVelocityForBucket
    }
    /// Constructs a `GameBucket` centred at the bottom of a
    /// given area
    convenience init(area: CGSize) {
        let bucketSize = CGSize(width: Settings.bucketWidth, height: Settings.bucketHeight)
        let centre = CGPoint(x: area.width / 2, y: area.height - Settings.bucketHeight / 2)
        self.init(size: bucketSize, centre: centre)
    }

    func resetVelocity() {
        velocity = Settings.initialVelocityForBucket
    }

    func close() {
        bucketHoleLength = CGFloat.zero
    }

    func open() {
        bucketHoleLength = Settings.defaultBucketHoleLength
    }

    func checkEnterBucket(ball: GameObject) -> Bool {
        return ball.centre.x > centre.x - bucketHoleLength / 2 &&
            ball.centre.x < centre.x + bucketHoleLength / 2
    }

    func collidedWith(ball: GameObject) -> Bool {
        return ball.collidedWith(other: self)
    }
}
