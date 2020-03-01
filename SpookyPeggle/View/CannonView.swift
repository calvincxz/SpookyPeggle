//
//  CannonView.swift
//  PS3
//
//  Created by Calvin Chen on 8/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
The `CannonView` is an `UIView` which contains the image of a
 cannon and a ball. This class handles the rotation of the cannon, and
 the ball reloading animations.
*/
class CannonView: UIView {

    private var angleRotated = CGFloat.zero
    private var cannon: UIImageView?
    private var ball: UIImageView?
    private let delta = Settings.cannonRotationPerGesture

    /// Sets up the cannon.
    func setUpCannonView(cannon: UIImageView, ball: UIImageView) {
        self.cannon = cannon
        self.ball = ball
        //let vw = UIView(frame: CGRect(x: 100, y: 100, width: 128, height: 128))
        //backgroundColor = .white
        //cannon.la

    }

    /// Hides the ball when game starts.
    func removeBall() {
        ball?.alpha = 0
    }

    /// Animates the appearance of the ball.
    func reloadBall() {
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut,
                       animations: { self.ball?.alpha = 1 })
    }

    /// Sets direction of cannon to face down
    func resetCannonDirection() {
        transform = CGAffineTransform(rotationAngle: 0)
        angleRotated = CGFloat.zero
    }

    /// Rotates the cannon depending on user gesture.
    func rotate(translation: CGPoint) {
        if translation.x < 0 {
            rotateLeft()
        } else if translation.x > 0 {
            rotateRight()
        }
    }

    /// Rotates the cannon to the left.
    private func rotateLeft() {
        if angleRotated + delta > Settings.maximumCannonRotationAngle {
            return
        }

        let rotation = transform.rotated(by: delta)
        angleRotated += delta
        transform = rotation
    }

    /// Rotates the cannon to the right.
    private func rotateRight() {
        if angleRotated - delta < -Settings.maximumCannonRotationAngle {
            return
        }
        let rotation = transform.rotated(by: -delta)
        angleRotated -= delta
        transform = rotation
    }
}
