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
    private var width: CGFloat
    private var height: CGFloat
    var bucketHoleLength = CGFloat(100)

    /// Constructs a `GameBucket` with the default diameter
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

    func checkHoritzontalPositionForCollision(x: CGFloat) -> Bool {
        return (x >= centre.x + bucketHoleLength / 2 &&  x <= centre.x + width / 2)
        || (x >= centre.x - width / 2 &&  x <= centre.x - bucketHoleLength / 2)
    }

    func checkEnterBucket(ball: GameObject) -> Bool {
        if ball.centre.x >= centre.x - bucketHoleLength / 2 &&
        ball.centre.x <= centre.x + bucketHoleLength / 2 {
            print(ball.centre.x.description)
            print(centre.x.description)
        }

        return ball.centre.x >= centre.x - bucketHoleLength / 2 &&
            ball.centre.x <= centre.x + bucketHoleLength / 2
    }


    func willCollide(ball: GameObject) -> Bool {
        if ball.willCollide(other: self) {
            print("collided")
        }
        return ball.collidedWith(other: self)
//        return ball.centre.y >= centre.y && ball.centre.x < centre.x + width/2 && ball.centre.x > centre.x - width/2
    }
}
