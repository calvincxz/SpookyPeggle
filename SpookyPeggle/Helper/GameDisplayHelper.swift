//
//  Helper.swift
//  PeggleGame
//
//  Created by Calvin Chen on 26/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
`GameDisplayHelper` is a class which provides helper functions related to game display.
*/
enum GameDisplayHelper {

    /// Gets an image associated with the `PegType`.
    static func getPegImage(of type: PegType, shape: PegShape) -> UIImage {
        switch shape {
        case .Circle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange")
            case .green:
                return #imageLiteral(resourceName: "peg-green")
            case .purple:
                return #imageLiteral(resourceName: "peg-purple")
            }
        case .Triangle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-triangle")
            case .purple:
                return #imageLiteral(resourceName: "peg-purple-triangle")
            }
        }

    }

    /// Gets an image associated with the `PegType`.
    static func getLightedPegImage(of type: PegType, shape: PegShape) -> UIImage? {
        switch shape {
        case .Circle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow")
            case .purple:
                return #imageLiteral(resourceName: "peg-purple-glow")
            }
        case .Triangle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow-triangle")
            case .purple:
                return #imageLiteral(resourceName: "peg-purple-glow-triangle")
            }
        }
    }

    static func createSmokeImageView(centre: CGPoint) -> UIImageView {

        let diameter = Settings.spookyBlastMaxLength * 2
        let frame = CGRect(x: centre.x - diameter / 2, y: centre.y - diameter / 2,
                           width: diameter, height: diameter)

        let smoke = UIImageView(frame: frame)
        smoke.image = #imageLiteral(resourceName: "smoke")
        smoke.layer.cornerRadius = 0.5 * smoke.bounds.size.width
        smoke.clipsToBounds = true
        return smoke

    }

    static func addGlowEffect(view: UIView, colour: CGColor) {
        view.layer.cornerRadius = 0.5 * view.bounds.size.width
        view.clipsToBounds = true
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = colour
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }

    static func removeGlowEffect(view: UIView) {
        view.layer.shadowOpacity = 0
    }

    /// Returns initial velocity of a ball
    ///    - Parameters:
    ///     - angle: Angle in radians
    ///
    ///    - Returns:
    ///        - The initial velocity for the ball
    static func getInitialVelocity(angle: CGFloat) -> CGVector {
        let dX = Settings.initialVelocityForBall * cos(angle)
        let dY = Settings.initialVelocityForBall * sin(angle)
        return CGVector(dx: dX, dy: dY)
    }

    /// Returns the angle of one point from another point.
    static func getAngle(of point: CGPoint, from otherPoint: CGPoint) -> CGFloat {
        let deltaX = point.x - otherPoint.x
        let deltaY = point.y - otherPoint.y
        return atan2(deltaY, deltaX)
    }

    static func reverseVelocity(_ velocity: CGVector) -> CGVector {
        return CGVector(dx: -velocity.dx, dy: -velocity.dy)
    }
}
